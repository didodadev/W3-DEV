<cfquery name="GET_SERVICE_PLUS" datasource="#DSN3#">
	SELECT 
		SERVICE_ID,
        SUBJECT,
        PLUS_CONTENT,
        UPDATE_PAR,
        UPDATE_EMP,
        PLUS_DATE,
        COMMETHOD_ID,
        SERVICE_PLUS_ID
	FROM 
		SERVICE_PLUS
	WHERE   
		SERVICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.service_id#">
		<cfif isDefined("attributes.service_plus_id")>
        	AND SERVICE_PLUS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.service_plus_id#">
		</cfif>
</cfquery>
