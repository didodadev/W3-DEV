<cfquery name="GET_SERVICE_PLUS" datasource="#DSN#">
	SELECT 
		*
	FROM 
		G_SERVICE_PLUS
	WHERE   
		SERVICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.service_id#">
	<cfif isDefined("attributes.service_plus_id")>
		AND SERVICE_PLUS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.service_plus_id#">
	</cfif>	
	ORDER BY 
		SERVICE_PLUS_ID DESC
</cfquery>
