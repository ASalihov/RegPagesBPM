using System;
using System.Web.UI;
using System.Web;
using System.Web.Services;

namespace RegistrationPages
{
	public partial class Login : Page
	{
        public class ForwardSessionToken
        {
            public string TypeBpm;
            public string UtmSource;
            public string UtmMedium;
            public string UtmCampaign;
            public string UtmContent;
            public string UtmTerm;
        }

		protected void Page_Load(object sender, EventArgs e) {
            //if (Session["type_bpm"] == null && Session["utm_source_bpm"] == null && Session["utm_medium_bpm"] == null && Session["utm_campaign_bpm"] == null && Session["utm_content_bpm"] == null && Session["utm_term_bpm"] == null)
            //{
            //    Session["type_bpm"] = HttpContext.Current.Request.Form["type_bpm"] != null ? HttpContext.Current.Request.Form["type_bpm"].ToString() : string.Empty;
            //    Session["utm_source_bpm"] = HttpContext.Current.Request.Form["utm_source_bpm"] != null ? HttpContext.Current.Request.Form["utm_source_bpm"].ToString() : string.Empty;
            //    Session["utm_medium_bpm"] = HttpContext.Current.Request.Form["utm_medium_bpm"] != null ? HttpContext.Current.Request.Form["utm_medium_bpm"].ToString() : string.Empty;
            //    Session["utm_campaign_bpm"] = HttpContext.Current.Request.Form["utm_campaign_bpm"] != null ? HttpContext.Current.Request.Form["utm_campaign_bpm"].ToString() : string.Empty;
            //    Session["utm_content_bpm"] = HttpContext.Current.Request.Form["utm_content_bpm"] != null ? HttpContext.Current.Request.Form["utm_content_bpm"].ToString() : string.Empty;
            //    Session["utm_term_bpm"] = HttpContext.Current.Request.Form["utm_term_bpm"] != null ? HttpContext.Current.Request.Form["utm_term_bpm"].ToString() : string.Empty;
            //}
            if (HttpContext.Current.Request.Form["type_bpm"] != null &&
                HttpContext.Current.Request.Form["utm_source_bpm"] != null &&
                HttpContext.Current.Request.Form["utm_medium_bpm"] != null &&
                HttpContext.Current.Request.Form["utm_campaign_bpm"] != null &&
                HttpContext.Current.Request.Form["utm_content_bpm"] != null &&
                HttpContext.Current.Request.Form["utm_term_bpm"] != null
                )
            {
                HttpCookie cookie = new HttpCookie("bpmSettings");
                cookie["type_bpm"] = HttpContext.Current.Request.Form["type_bpm"].ToString();
                cookie["utm_source_bpm"] = HttpContext.Current.Request.Form["utm_source_bpm"].ToString();
                cookie["utm_medium_bpm"] = HttpContext.Current.Request.Form["utm_medium_bpm"].ToString();
                cookie["utm_campaign_bpm"] = HttpContext.Current.Request.Form["utm_campaign_bpm"].ToString();
                cookie["utm_content_bpm"] = HttpContext.Current.Request.Form["utm_content_bpm"].ToString();
                cookie["utm_term_bpm"] = HttpContext.Current.Request.Form["utm_term_bpm"].ToString();
                cookie.HttpOnly = false;
                HttpContext.Current.Response.Cookies.Add(cookie);
            }
           

            //cookie.Value = ColorSelector.SelectedValue;
            //cookie.Expires = DateTime.Now.AddHours(1);
            //Response.SetCookie(cookie);
            //if (HttpContext.Current.Request.Cookies["type_bpm"] == null &&
            //    HttpContext.Current.Request.Cookies["utm_source_bpm"] == null &&
            //    HttpContext.Current.Request.Cookies["utm_medium_bpm"] == null &&
            //    HttpContext.Current.Request.Cookies["utm_campaign_bpm"] == null &&
            //    HttpContext.Current.Request.Cookies["utm_content_bpm"] == null &&
            //    HttpContext.Current.Request.Cookies["utm_term_bpm"] == null)
            //{
               // HttpCookie cookie = new HttpCookie("bpmSettings");
               
                //Response.Cookies["bpmSettings"]["utm_source_bpm"] = HttpContext.Current.Request.Form["utm_source_bpm"] != null ? HttpContext.Current.Request.Form["utm_source_bpm"].ToString() : string.Empty;
                //Response.Cookies["bpmSettings"]["utm_medium_bpm"] = HttpContext.Current.Request.Form["utm_medium_bpm"] != null ? HttpContext.Current.Request.Form["utm_medium_bpm"].ToString() : string.Empty;
                //Response.Cookies["bpmSettings"]["utm_campaign_bpm"] = HttpContext.Current.Request.Form["utm_campaign_bpm"] != null ? HttpContext.Current.Request.Form["utm_campaign_bpm"].ToString() : string.Empty;
                //Response.Cookies["bpmSettings"]["utm_content_bpm"] = HttpContext.Current.Request.Form["utm_content_bpm"] != null ? HttpContext.Current.Request.Form["utm_content_bpm"].ToString() : string.Empty;
                //Response.Cookies["bpmSettings"]["utm_term_bpm"] = HttpContext.Current.Request.Form["utm_term_bpm"] != null ? HttpContext.Current.Request.Form["utm_term_bpm"].ToString() : string.Empty;
            //}
		}

        [WebMethod(EnableSession = true)]
        public static object ForwardSession()
        {
            var cookie = Utils.TryLogin();
            ForwardSessionToken token = new ForwardSessionToken();
            token.TypeBpm = HttpContext.Current.Session["type_bpm"] != null ? HttpContext.Current.Session["type_bpm"].ToString() : string.Empty;
            token.UtmSource = HttpContext.Current.Session["utm_source_bpm"] != null ? HttpContext.Current.Session["utm_source_bpm"].ToString() : string.Empty;
            token.UtmMedium = HttpContext.Current.Session["utm_medium_bpm"] != null ? HttpContext.Current.Session["utm_medium_bpm"].ToString() : string.Empty;
            token.UtmCampaign = HttpContext.Current.Session["utm_campaign_bpm"] != null ? HttpContext.Current.Session["utm_campaign_bpm"].ToString() : string.Empty;
            token.UtmContent = HttpContext.Current.Session["utm_content_bpm"] != null ? HttpContext.Current.Session["utm_content_bpm"].ToString() : string.Empty;
            token.UtmTerm = HttpContext.Current.Session["utm_term_bpm"] != null ? HttpContext.Current.Session["utm_term_bpm"].ToString() : string.Empty;
            return Utils.ExecuteConfigurationService(cookie, "RMFUserManagementService", "ForwardSession", new {token});
        }
	}

    
}