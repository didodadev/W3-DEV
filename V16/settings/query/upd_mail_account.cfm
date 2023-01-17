<cfset upd_mail_account = createObject("component","V16.settings.cfc.mail_accounts_settings")>
<cfset GET_MAIL_SERVER= upd_mail_account.SelectSN(SERVER_NAME_ID:attributes.server_name_id)/> 

<cfset Login = {
     "username":"workcube",
     "password":"pwd_workcube"
}>   
<cfhttp url="https://testapi.entegremail.com/authentication/login" method="post" result="httpResp">
    <cfhttpparam type="header" name="Content-Type" value="application/json; charset=utf-8">
    <cfhttpparam type="body" value="#Replace(serializeJSON(Login), "//", "")#">
</cfhttp>
<cfset response = "#DeserializeJson(httpResp.Filecontent)#">

<cfset theUserId = response.data.user.user_id>
<cfset theCompanyId = response.data.user.company_id>
<cfif response.status eq 0>
    <cfif attributes.is_active eq 1>
        <cfset ActivateAccount = {
            "user_id":"#theUserId#",
            "company_id":"#theCompanyId#",
            "account_address":"#attributes.MAIL_ACCOUNT#@#GET_MAIL_SERVER.SERVER_NAME#"
        }>
        <cfhttp url="https://testapi.entegremail.com/smtp/activateaccount" method="post" result="httpResp1">
            <cfhttpparam type="header" name="Content-Type" value="application/json; charset=utf-8">
            <cfhttpparam type="header" name="Authorization" value="Bearer #response.data.token#">
            <cfhttpparam type="body" value="#Replace(serializeJSON(ActivateAccount), "//", "")#">
        </cfhttp>
    </cfif>
    <cfif attributes.is_active eq 2>
        <cfset DeactivateAccount = {
            "user_id":"#theUserId#",
            "company_id":"#theCompanyId#",
            "account_address":"#attributes.MAIL_ACCOUNT#@#GET_MAIL_SERVER.SERVER_NAME#"
        }>  
        <cfhttp url="https://testapi.entegremail.com/smtp/deactivateaccount" method="post" result="httpResp1">
            <cfhttpparam type="header" name="Content-Type" value="application/json; charset=utf-8">
            <cfhttpparam type="header" name="Authorization" value="Bearer #response.data.token#">
            <cfhttpparam type="body" value="#Replace(serializeJSON(DeactivateAccount), "//", "")#">
        </cfhttp>
        
    </cfif>
    <cfset Update = upd_mail_account.Update(
            mail_account_id : attributes.maid,
            IS_ACTIVE : attributes.is_active,
            IS_AUTHORIZED : attributes.IS_AUTHORIZED
        )/>
</cfif>



<script type="text/javascript">
    <cfoutput>
        window.location.href = 'index.cfm?fuseaction=settings.list_mail_accounts&event=upd&maid=#attributes.maid#'
    </cfoutput>
</script>