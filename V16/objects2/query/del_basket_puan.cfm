<cfif IsDefined("Cookie.wrk_basket_#ReplaceList(cgi.http_host,'-,:','_,_')#")>
	<cfquery name="del_rows_specs" datasource="#dsn3#">
		DELETE 
		FROM
			ORDER_PRE_ROWS_SPECIAL
		WHERE
			COOKIE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate("cookie.wrk_basket_#ReplaceList(cgi.http_host,'-,:','_,_')#")#">
	</cfquery>
</cfif>
<cflocation addtoken="no" url="#request.self#?fuseaction=objects2.list_basket">

