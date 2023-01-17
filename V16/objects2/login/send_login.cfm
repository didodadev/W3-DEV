<cfif isdefined("session.cp") and not isdefined("session.cp.userid")>
	<cfinclude template="../career/form/form_login.cfm">
<cfelseif isdefined("session.ww") and not isdefined("session.ww.userid") and listfindnocase(server_url,cgi.HTTP_HOST,';')>
	<cfinclude template="public_login.cfm">
<cfelseif isdefined("session.pp") and not isdefined("session.pp.userid")>
	<cfinclude template="partner_login.cfm">
</cfif>
<cfexit method="exittemplate">
