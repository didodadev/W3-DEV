<cfoutput>
<cfif isdefined("session.ww") and not isdefined("session.ww.userid")>
	<a href="#request.self#?fuseaction=objects2.public_login" class="upper_menu_link">Mail</a>
</cfif>
</cfoutput>
