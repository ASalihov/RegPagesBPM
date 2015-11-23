using System;
using System.Configuration;
using System.Web.Services;
using System.Web.UI;
using System.Web;

namespace RegistrationPages
{
	public class RegistrationToken
	{
		public string Fname;
		public string Sname;
        public string Mname;
        public string PCode;
        public int Year;
        public int Month;
        public int Day;
		public string PhoneCode;
		public string EmailCode;
		public Guid PhoneCodeId;
		public Guid EmailCodeId;
        public string DeviceId;
        public decimal Amount;
        public int Period;
        public string City;
		public string TimeZoneOffset;
	}

	public class VerifyResult
	{
		public bool PhoneCodeCorrect;
		public bool EmailCodeCorrect;
		public bool PhoneMaxAttemptsReached;
		public bool PhoneCodeExpired;
		public bool PhoneInBlockList;
		public bool EmailMaxAttemptsReached;
		public bool EmailCodeExpired;
		public bool EmailInBlockList;
		public string Login;
		public string Password;
		public Guid ApplicationId;
	}

	public partial class Register : Page
	{
        public static string deviceId;
        public static decimal amount;
        public static int period;
        public static string city;

		protected void Page_Load(object sender, EventArgs e) {
			var minAge = ConfigurationManager.AppSettings["MinConsentAge"];
			var maxAge = ConfigurationManager.AppSettings["MaxConsentAge"];
            deviceId = HttpContext.Current.Request.Form["device_id"] != null ? HttpContext.Current.Request.Form["device_id"].ToString() : string.Empty;
            amount = HttpContext.Current.Request.Form["sum"] != null ? Convert.ToDecimal(HttpContext.Current.Request.Form["sum"]) : 0;
            period = HttpContext.Current.Request.Form["period"] != null ? Convert.ToInt32(HttpContext.Current.Request.Form["period"]) : 0;
            city = HttpContext.Current.Request.Form["city"] != null ? HttpContext.Current.Request.Form["city"].ToString() : string.Empty;
			Page.ClientScript.RegisterClientScriptBlock(GetType(), "myAlertScript", string.Format("window.minAge = {0};window.maxAge = {1};", minAge, maxAge), true);
		}

		[WebMethod]
		public static object SendVerificationCodes(string phone, string email) {
			var cookie = Utils.TryLogin();
			return Utils.ExecuteConfigurationService(cookie, "RMFUserManagementService", "SendVerificationCodes", new {
				phone,
				email
			});
		}

		[WebMethod]
		public static object Verify(RegistrationToken token) {
			var cookie = Utils.TryLogin();
            token.Amount = amount;
            token.Period = period;
            token.City = city;
            token.DeviceId = deviceId;
			return Utils.ExecuteConfigurationService(cookie, "RMFUserManagementService", "Verify", new {
				token
			});
		}

		[WebMethod]
		public static object SendNewCode(string number, string type) {
			var cookie = Utils.TryLogin();
			return Utils.ExecuteConfigurationService(cookie, "RMFUserManagementService", "SendNewCode", new {
				number,
				type
			});
		}
	}
}