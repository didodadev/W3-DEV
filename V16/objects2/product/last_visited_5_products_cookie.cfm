<cfif isdefined('attributes.sid') and isNumeric(attributes.sid)>
	<cfif isdefined("cookie.last_visited_5_products")>
		<cfif listfind(cookie.last_visited_5_products,attributes.sid)>
			<cfset cookie_sid_list = listdeleteat(cookie.last_visited_5_products,listfind(cookie.last_visited_5_products,attributes.sid))>
		<cfelse>
			<cfset cookie_sid_list = cookie.last_visited_5_products>
		</cfif>
		<cfif listlen(cookie_sid_list) lt 20>
			<cfset cookievalue = listprepend(cookie_sid_list,attributes.sid)>
		<cfelse>
			<cfset cookievalue = listprepend(listdeleteat(cookie_sid_list,listlen(cookie_sid_list)),attributes.sid)>
		</cfif>
		<cfcookie name="last_visited_5_products" value="#cookievalue#" expires="never">
	<cfelse>
		<cfcookie name="last_visited_5_products" value="#attributes.sid#" expires="never">
	</cfif>
</cfif>
