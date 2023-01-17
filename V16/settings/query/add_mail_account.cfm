<cfset add_mail_account = createObject("component", "V16.settings.cfc.mail_accounts_settings")>
<cfset GET_MAIL_SERVER= add_mail_account.SelectSN(server_name_id:attributes.server_name_id)/> 

<cfset Login = {
     "username":"workcube",
     "password":"pwd_workcube"
}>   
<cfhttp url="https://testapi.entegremail.com/authentication/login" method="post" result="httpResp">
    <cfhttpparam type="header" name="Content-Type" value="application/json; charset=utf-8">
    <cfhttpparam type="body" value="#Replace(serializeJSON(Login), "//", "")#">
</cfhttp>
<!--- <cfdump  var="#DeserializeJson(httpResp.Filecontent)#"> --->
<cfset response = "#DeserializeJson(httpResp.Filecontent)#">
<cfset theUserId = response.data.user.user_id>
<cfset theCompanyId = response.data.user.company_id>
<cfif response.status eq 0>

    <cfset AddAccount = {
        "user_id":"#theUserId#",
	    "company_id":"#theCompanyId#",
        "account_address":"#attributes.MAIL_ACCOUNT#@#GET_MAIL_SERVER.SERVER_NAME#",
        "password":"#attributes.MAIL_PASSWORD#",
        "mail_box_size":"#attributes.MAIL_ACCOUNT_QUOTA#"
    }>   
    <!--- <cfdump  var="#AddAccount#"> --->
    <cfhttp url="https://testapi.entegremail.com/smtp/addaccount" method="post" result="httpResp1">
        <cfhttpparam type="header" name="Content-Type" value="application/json; charset=utf-8">
        <cfhttpparam type="header" name="Authorization" value="Bearer #response.data.token#">
        <cfhttpparam type="body" value="#Replace(serializeJSON(AddAccount), "//", "")#">
    </cfhttp>
    <cfdump  var="#httpResp1#">
    <cfset Insert = add_mail_account.Insert(
    SERVER_NAME_ID : attributes.server_name_id,
    MAIL_ACCOUNT : attributes.mail_account,
    MAIL_PASSWORD : attributes.mail_password,
    MAIL_ACCOUNT_QUOTA : attributes.mail_account_quota,
    IS_ACTIVE : attributes.is_active,
    EMPLOYEE_ID : attributes.employee_id
    )/>
    <!--- <cfdump  var="#httpResp1#" abort> --->
<cfelse>
    <cfreturn false>
</cfif>
    <script type="text/javascript">
        <cfoutput>
            window.location.href = 'index.cfm?fuseaction=settings.list_mail_accounts&event=upd&maid=#Insert.IDENTITYCOL#'
        </cfoutput>
    </script>