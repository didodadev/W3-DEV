<cfif isdefined("session.pp")>
	<cfset session_base = evaluate('session.pp')>
<cfelseif isdefined("session.ep")>
	<cfset session_base = evaluate('session.ep')>
<cfelseif isdefined("session.ww")>
	<cfset session_base = evaluate('session.ww')>
<cfelseif isdefined("session.wp")>
	<cfset session_base = evaluate('session.wp')>
</cfif>