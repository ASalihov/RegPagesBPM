using System;
using System.Web;
using System.Web.UI;
using System.Configuration;

namespace RegistrationPages
{
	public partial class Eko : MasterPage
	{
		protected void Page_Load(object sender, EventArgs e) {
            var appPath = string.Empty;// ConfigurationManager.AppSettings["ApplicationPath"].ToString();
			if (appPath == "/") {
				appPath = "";
			}
			Page.ClientScript.RegisterClientScriptBlock(GetType(), "myAlertScript", string.Format("window.applicationPath = '{0}';", appPath), true);
		}
	}
}