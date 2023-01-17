<cfif login.recordcount>
    <cfobject name="inst_setting" type="component" component="AddOns.Plevne.models.settings">
    <cfset gopcha_enabled = inst_setting.get_plevne_setting_bykey("MFA_ENABLED")>
    <cfif gopcha_enabled eq "1">
        <cfobject name="inst_gopcha" type="component" component="AddOns.Plevne.models.gopchas">
        <cfset gopcha_key = inst_gopcha.get_gopcha_key(login.employee_id, cgi.REMOTE_ADDR, "2")>
        <cfif isDefined("cookie.gopcha") and len(gopcha_key) and cookie.gopcha neq gopcha_key>
            <cfset inst_gopcha.remove_gopcha_key(gopcha_key)>
            <cfset required_gopcha = 1>
        </cfif>
        <cfif not isDefined("cookie.gopcha") or len(gopcha_key) eq 0 or isDefined("required_gopcha")>
            <cfset gopcha_data = inst_gopcha.generate_gopcha_key(login.employee_id, cgi.REMOTE_ADDR)>
            <cfset session.ep.gopcha_verify = gopcha_data>
            
        </cfif>
    </cfif>
</cfif>