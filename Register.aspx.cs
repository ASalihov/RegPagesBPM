using System;
using System.Linq;
using System.Configuration;
using System.Net;
using System.Web.Configuration;
using System.Web.Services;
using System.Web.UI;
using System.Web;
using System.IO;

namespace RegistrationPages
{
    public partial class Signup : Page
    {
        public class RegistrationToken
        {
            
            public string Fname;
            public string Sname;
            public string Mname;
            public int Year;
            public int Month;
            public int Day;
            public string Pcode;
            public string Phone;
            public string Email;
            public string DeviceId;
            public decimal Amount;
            public string UniqueClientId;
            public int Period;
            public string City;
            public string TimeZoneOffset;
            public string TypeBpm;
            public string UtmSource;
            public string UtmMedium;
            public string UtmCampaign;
            public string UtmContent;
            public string UtmTerm;
        }


        public class VerifyResult
        {
            public string Login;
            public string Password;
            public Guid ApplicationId;
        }
     
        protected void Page_Load(object sender, EventArgs e)
        {
            var minAge = WebConfigurationManager.AppSettings["MinConsentAge"];
            var maxAge = WebConfigurationManager.AppSettings["MaxConsentAge"];
            Page.ClientScript.RegisterClientScriptBlock(GetType(), "myAlertScript", string.Format("window.minAge = {0};window.maxAge = {1};", minAge, maxAge), true);

            if (Session["deviceId"] == null && Session["sum"] == null && Session["period"] == null && Session["city"] == null && Session["cidbpm"] == null)
            {
                Session["deviceId"]  = HttpContext.Current.Request.Form["device_id"] != null ? HttpContext.Current.Request.Form["device_id"].ToString() : string.Empty;
                Session["sum"] = HttpContext.Current.Request.Form["sum"] != null ? Convert.ToDecimal(HttpContext.Current.Request.Form["sum"]) : 0;
                Session["period"] = HttpContext.Current.Request.Form["period"] != null ? Convert.ToInt32(HttpContext.Current.Request.Form["period"]) : 0;
                Session["city"] = HttpContext.Current.Request.Form["city"] != null ? HttpContext.Current.Request.Form["city"].ToString() : string.Empty;
                Session["cidbpm"] = HttpContext.Current.Request.Form["cidbpm"] != null ? HttpContext.Current.Request.Form["cidbpm"].ToString() : string.Empty;
            }
            if (Session["type_bpm"] == null && 
                Session["utm_source_bpm"] == null && 
                Session["utm_medium_bpm"] == null &&
                Session["utm_campaign_bpm"] == null &&
                Session["utm_content_bpm"] == null &&
                Session["utm_term_bpm"] == null)
            {
                Session["type_bpm"] = HttpContext.Current.Request.Form["type_bpm"] != null ? HttpContext.Current.Request.Form["type_bpm"].ToString() : string.Empty;
                Session["utm_source_bpm"] = HttpContext.Current.Request.Form["utm_source_bpm"] != null ? HttpContext.Current.Request.Form["utm_source_bpm"].ToString() : string.Empty;
                Session["utm_medium_bpm"] = HttpContext.Current.Request.Form["utm_medium_bpm"] != null ? HttpContext.Current.Request.Form["utm_medium_bpm"].ToString() : string.Empty;
                Session["utm_campaign_bpm"] = HttpContext.Current.Request.Form["utm_campaign_bpm"] != null ? HttpContext.Current.Request.Form["utm_campaign_bpm"].ToString() : string.Empty;
                Session["utm_content_bpm"] = HttpContext.Current.Request.Form["utm_content_bpm"] != null ? HttpContext.Current.Request.Form["utm_content_bpm"].ToString() : string.Empty;
                Session["utm_term_bpm"] = HttpContext.Current.Request.Form["utm_term_bpm"] != null ? HttpContext.Current.Request.Form["utm_term_bpm"].ToString() : string.Empty;
            }
        }

        [WebMethod(EnableSession = true)]
        public static object Register(RegistrationToken token)
        {
            var cookie = Utils.TryLogin();
            token.Amount = HttpContext.Current.Session["sum"] == null ? 0 : Convert.ToDecimal(HttpContext.Current.Session["sum"].ToString());
            token.Period = HttpContext.Current.Session["period"] == null ? 0 : Convert.ToInt32(HttpContext.Current.Session["period"].ToString());
            token.City = HttpContext.Current.Session["city"] == null ? string.Empty : HttpContext.Current.Session["city"].ToString();
            token.DeviceId = HttpContext.Current.Session["deviceId"] == null ? string.Empty : HttpContext.Current.Session["deviceId"].ToString();
            token.UniqueClientId = HttpContext.Current.Session["cidbpm"] == null ? string.Empty : HttpContext.Current.Session["cidbpm"].ToString();

            token.TypeBpm = HttpContext.Current.Session["type_bpm"] == null ? string.Empty : HttpContext.Current.Session["type_bpm"].ToString();
            token.UtmSource = HttpContext.Current.Session["utm_source_bpm"] == null ? string.Empty : HttpContext.Current.Session["utm_source_bpm"].ToString();
            token.UtmMedium = HttpContext.Current.Session["utm_medium_bpm"] == null ? string.Empty : HttpContext.Current.Session["utm_medium_bpm"].ToString();
            token.UtmCampaign = HttpContext.Current.Session["utm_campaign_bpm"] == null ? string.Empty : HttpContext.Current.Session["utm_campaign_bpm"].ToString();
            token.UtmContent = HttpContext.Current.Session["utm_content_bpm"] == null ? string.Empty : HttpContext.Current.Session["utm_content_bpm"].ToString();
            token.UtmTerm = HttpContext.Current.Session["utm_term_bpm"] == null ? string.Empty : HttpContext.Current.Session["utm_term_bpm"].ToString();
            return Utils.ExecuteConfigurationService(cookie, "RMFUserManagementService", "Register", new
            {
                token
            });
        }

        [WebMethod]
        public static object Verify(Guid codeId, string code)
        {
            var cookie = Utils.TryLogin();
            return Utils.ExecuteConfigurationService(cookie, "RMFUserManagementService", "Verify", new
            {
                codeId,
                code
            });
        }

        [WebMethod]
        public static object SendVerificationCodes(string number, string type)
        {
            var cookie = new CookieContainer();
            number = Utils.ParsePhoneNumber(number);
            try
            {
                Utils.AddLogToTextFile("SendVerificationCodes.txt", "Распарсеный номер телефона - " + number + Environment.NewLine);
                cookie = Utils.TryLogin();
            }
            catch (Exception ex)
            {
                Utils.AddLogToTextFile("SendVerificationCodes.txt", "TryLogin Exception - " + ex.Message);
            }
  
            return Utils.ExecuteConfigurationService(cookie, "RMFUserManagementService", "SendVerificationCodes", new
            {
                number,
                type
            });
        }



        [WebMethod]
        public static object SendNewCode(string number, string type)
        {
            var cookie = Utils.TryLogin();
            return Utils.ExecuteConfigurationService(cookie, "RMFUserManagementService", "SendNewCode", new
            {
                number,
                type
            });
        }
    }
}