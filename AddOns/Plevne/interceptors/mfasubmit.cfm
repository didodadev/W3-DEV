<cfif isDefined("form.mfasubmit") and isDefined("form.mfacode")>
	<cfif session.ep.gopcha_verify.gopcha_code eq form.mfacode>
		<cfobject name="inst_setting" type="component" component="AddOns.Plevne.models.settings">
		<cfset cookie_until = inst_setting.get_plevne_setting_bykey("MFA_UNTIL")>
		<cfif cookie_until gt 0>
			<cfcookie name="gopcha" value="#session.ep.gopcha_verify.gopcha_key#" expires="#cookie_until#">
		<cfelse>
			<cfcookie name="gopcha" value="#session.ep.gopcha_verify.gopcha_key#">
		</cfif>
		<cfobject name="inst_gopcha" type="component" component="AddOns.Plevne.models.gopchas">
		<cfset inst_gopcha.update_gopcha_until(session.ep.gopcha_verify.gopcha_key, dateAdd('d', cookie_until, now()))>
		<cfset structDelete(session.ep,"gopcha_verify")>
    <cfelse>
        <cflocation url="/index.cfm?fuseaction=home.login&mfa=1" addtoken="No">
        <cfabort>
	</cfif>
</cfif>