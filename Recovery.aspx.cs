using System;
using System.Web.Services;
using System.Web.UI;

namespace RegistrationPages
{
    public partial class Recovery : Page
    {
        protected void PageLoad(object sender, EventArgs e)
        {
        }

        [WebMethod]
        public static object SendCodeForPasswordChange(string number, string type)
        {
            number = Utils.ParsePhoneNumber(number);
            Utils.AddLogToTextFile("serverRecoveryLog.txt", "(Recovery) Распарсеный номер телефона - " + number + Environment.NewLine);
            var cookie = Utils.TryLogin();
            return Utils.ExecuteConfigurationService(cookie, "RMFUserManagementService", "SendCodeForPasswordChange", new
            {
                number,
                type
            });
        }

        [WebMethod]
        public static object VerifyCodeForPasswordChange(Guid codeId, string code)
        {
            var cookie = Utils.TryLogin();
            return Utils.ExecuteConfigurationService(cookie, "RMFUserManagementService", "VerifyCodeForPasswordChange", new
            {
                code,
                codeId
            });
        }

        [WebMethod]
        public static object ChangePassword(Guid codeId, string code, string password, string type)
        {
            var cookie = Utils.TryLogin();
            return Utils.ExecuteConfigurationService(cookie, "RMFUserManagementService", "ChangePassword", new
            {
                code,
                codeId,
                password,
                type
            });
        }
    }
}