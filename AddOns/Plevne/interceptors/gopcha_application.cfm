<cfif isDefined("session.ep.gopcha_verify") and isDefined("url.fuseaction") and (url.fuseaction neq "home.login" and url.fuseaction neq "home.act_login")>
    <cflocation url="/index.cfm?fuseaction=home.login&mfa=1" addtoken="No">
    <cfabort>
</cfif>