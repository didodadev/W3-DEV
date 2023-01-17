<cfif fusebox.use_period>	
	<cfset db_source = "#DSN2#">
<cfelse>	
	<cfset db_source = "#DSN#">
</cfif>

<cfquery name="GET_ACCOUNT" datasource="#db_source#">
	SELECT 
		* 
	FROM 
		ACCOUNT_PLAN
	WHERE
		ACCOUNT_CODE = '#attributes.ACCOUNT_CODE#'
</cfquery>
