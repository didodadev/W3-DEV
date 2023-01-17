<cfquery name="GET_SERVICE_PLUS" datasource="#DSN3#">
	SELECT 
		*
	FROM 
		SERVICE_PLUS
	WHERE   
		SERVICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#">
	  	<cfif isDefined("attributes.service_plus_id")>
			AND SERVICE_PLUS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.service_plus_id#">
	  	</cfif>
	ORDER BY 
		PLUS_DATE DESC,
		RECORD_DATE DESC
</cfquery>
