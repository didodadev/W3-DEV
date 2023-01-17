<cfset subscription_no = "159951" />
<cfset domain = (cgi.SERVER_PORT eq 443 ? 'https://' : 'http://') & cgi.SERVER_NAME & "/" />
<cf_box title="Wocial Access Token Olusturucu">
    <iframe 
        name="wocial_access_token_creater" 
        id="wocial_access_token_creater" 
        height="500" 
        style = "width:100%;" 
        scrolling="yes" 
        frameborder="0" 
        src="https://qa.workcube.com/wex.cfm/authCreater/?state=<cfoutput>#subscription_no#&platform=#attributes.platform#&domain=#domain#</cfoutput>">
    </iframe>
</cf_box>