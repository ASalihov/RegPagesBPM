using System;
using System.Configuration;
using System.IO;
using System.Linq;
using System.Net;
using System.Text;
using System.Web;
using Newtonsoft.Json;

using Terrasoft.Common;
using Terrasoft.Core;
using Terrasoft.Core.Store;

namespace RegistrationPages
{
	public static class Utils
    {
        
		private const string RedisRegistrationKey = "RegistrationAuthCookie";
		private const string AuthCookieName = ".ASPXAUTH";
		private const string SessionCookieName = "BPMSESSIONID";

		public static CookieContainer TryLogin() {

			var cont = (CookieContainer)Store.Cache[CacheLevel.Application][RedisRegistrationKey];
			if (cont != null) {
				var cookies = cont.GetCookies(new Uri(ConfigurationManager.AppSettings["ORIGIN_HOST_NAME"]));
				if (cookies[AuthCookieName] != null && cookies[SessionCookieName] != null) {
					return cont;
				}
			}
			/*var login = ConfigurationManager.AppSettings["UMULogin"];
			var password = HttpUtility.HtmlEncode(ConfigurationManager.AppSettings["UMUPassword"]);
			var workspace = ConfigurationManager.AppSettings["WorkspaceName"];*/
			var requestText = String.Format(
				"<AuthToken xmlns=\"http://Terrasoft.WebApp.ServiceModel/\">" +
				  @"<UserName>{0}</UserName>
                  <UserPassword>{1}</UserPassword>
                  <WorkspaceName>{2}</WorkspaceName>
                </AuthToken>", "Supervisor", "Supervisor", "Default");

            AddLogToTextFile("TryLogin.txt",  "ORIGIN_HOST_NAME - " + ConfigurationManager.AppSettings["ORIGIN_HOST_NAME"]);

			cont = new CookieContainer();
			var req = (HttpWebRequest)WebRequest.Create(String.Format("{0}/ServiceModel/AuthService.svc/Login", GetApplicationPrefix()));

            AddLogToTextFile("TryLogin.txt", "reqUrl - " + String.Format("{0}/ServiceModel/AuthService.svc/Login", GetApplicationPrefix()));
            AddLogToTextFile("TryLogin.txt", "requestText - " + requestText);

			req.Method = "POST";
			req.ContentType = "text/xml";
			req.CookieContainer = cont;
			using (var requestStream = req.GetRequestStream()) {
				requestStream.Write(Encoding.UTF8.GetBytes(requestText), 0,
					Encoding.UTF8.GetByteCount(requestText));
			}
			req.GetResponse();
			return cont;
		}

		private static string GetApplicationPrefix() {
			return ConfigurationManager.AppSettings["ORIGIN_HOST_NAME"] + HttpContext.Current.Request.ApplicationPath;
		}

		private static string GetApplicationWorkspacePrefix() {
			var conf = ConfigurationManager.AppSettings["WorkspaceNumber"];
			if (string.IsNullOrEmpty(conf)) {
				conf = "0";
			}
			return GetApplicationPrefix() + String.Format("/{0}/", conf);
		}

		public static string ExecuteConfigurationService<T>(CookieContainer container, string serviceName, string operation, T parameter)
        {
            var newline = Environment.NewLine;
            AddLogToTextFile("ExecuteConfigurationService.txt", "serviceName - " + serviceName + "operation - " + operation + newline);
			var jsonParams = JsonConvert.SerializeObject(parameter);
			try {
				return InternalExecuteConfigurationService(container, serviceName, operation, jsonParams);
			} catch (Exception ex) {
                AddLogToTextFile("ExecuteConfigurationService.txt", String.Format("serviceName - {0} operation - {1} jsonParams - {2} Exception - {3}",
                                                                    serviceName + newline, operation + newline, jsonParams + newline, ex + newline));


				Store.Cache[CacheLevel.Application].Remove(RedisRegistrationKey);
				var cont = TryLogin();
				return InternalExecuteConfigurationService(cont, serviceName, operation, jsonParams);
			}
		}

        private static string InternalExecuteConfigurationService(CookieContainer container, string serviceName, string operation, string serializedString)
        {
            var newline = Environment.NewLine;
            AddLogToTextFile("InternalExecuteConfigurationService.txt", "req - " + String.Format(@"{0}rest/{1}/{2}", GetApplicationWorkspacePrefix(), serviceName, operation) + newline);
			var req = (HttpWebRequest)WebRequest.Create(
				String.Format(@"{0}rest/{1}/{2}", GetApplicationWorkspacePrefix(), serviceName, operation));
			req.ContentType = "application/json";
			req.Method = "POST";
			req.Accept = "application/json";
			req.Timeout = 300000;
			req.CookieContainer = container;
			string result;
			try {
				using (var reqStream = req.GetRequestStream()) {
					using (var streamWriter = new StreamWriter(reqStream)) {
						streamWriter.Write(serializedString);
					}
				}
			} catch (Exception ex) {
                AddLogToTextFile("InternalExecuteConfigurationService.txt", "InternalExecuteConfigurationService Exception - " + ex.Message + newline);
				return ex.Message;
			}

			var response = (HttpWebResponse)req.GetResponse();
			using (var responseStream = response.GetResponseStream()) {
				using (var reader = new StreamReader(responseStream)) {
                    result = reader.ReadToEnd();
                    AddLogToTextFile("InternalExecuteConfigurationService.txt", "result - " + result + newline);
					CatchSessionCookie(container, response, req);
					var cookies = container.GetCookies(req.RequestUri);
					if (cookies[SessionCookieName] == null || cookies[AuthCookieName] == null) {
						throw new CookieException();
					}
				}
			}
			return result;
		}

		public static UserConnection GetUserConnection() {
			return (UserConnection)HttpContext.Current.Session["UserConnection"];
		}

		private static void CatchSessionCookie(CookieContainer container, HttpWebResponse resp, HttpWebRequest req) {
			var headerCookie = resp.Headers["Set-Cookie"];
			if (headerCookie != null) {
				var match = System.Text.RegularExpressions.Regex.Match(headerCookie, "(.+?)=(.+?);");
				if (match.Captures.Count > 0) {
					var cookies =
						container.GetCookies(req.RequestUri).Cast<Cookie>().Where(cookie => cookie.Name == match.Groups[1].Value);
					if (cookies.Any()) {
						cookies.ForEach(c => true, c => c.Value = match.Groups[2].Value);
					} else {
						container.Add(new Cookie(match.Groups[1].Value, match.Groups[2].Value, "/", req.RequestUri.Host));
					}
				}
			}
			Store.Cache[CacheLevel.Application][RedisRegistrationKey] = container;
		}


	    public static void AddLogToTextFile(string fileName, string text)
	    {
	        File.AppendAllText("E:\\" + fileName, text);
	    }

        public static string ParsePhoneNumber(string number)
        {
            number = number.Replace("(", "");
            number = number.Replace(")", "");
            number = number.Replace(" ", "");
            number = number.Replace("-", "");
            return number;
        }
	}
}