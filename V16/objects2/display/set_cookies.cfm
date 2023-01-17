<cfif not isdefined("session.pp") and not isdefined("session.ww.userid") and not IsDefined("Cookie.wrk_basket_#ReplaceList(cgi.http_host,'-,:','_,_')#")>
	<cfset cookie_name_ = createUUID()>
	<cfcookie name="wrk_basket_#ReplaceList(cgi.http_host,'-,:','_,_')#" value="#cookie_name_#" expires="1">
</cfif>

<cfif isdefined("session.ww.name") and isdefined("session.ww.surname")>
	<cfcookie name="wrk_name_#ReplaceList(cgi.http_host,'-,:','_,_')#" value="#session.ww.name# #session.ww.surname#" expires="1">
<cfelseif isdefined("session.pp.name") and isdefined("session.pp.surname")>
	<cfcookie name="wrk_name_#ReplaceList(cgi.http_host,'-,:','_,_')#" value="#session.pp.name# #session.pp.surname#" expires="1">
<cfelseif not isdefined("wrk_name_#ReplaceList(cgi.http_host,'-,:','_,_')#")>
	<cfcookie name="wrk_name_#ReplaceList(cgi.http_host,'-,:','_,_')#" value="Kullanıcı" expires="1">
</cfif>
