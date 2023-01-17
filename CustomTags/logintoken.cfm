<cfif not isDefined("session.logintoken") or len(session.logintoken) eq 0>
    <cfset session.logintoken = createUUID()>
</cfif>
<cfoutput>
<input type="hidden" name="token" value="#session.logintoken#">
</cfoutput>