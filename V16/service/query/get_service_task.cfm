<cfquery name="GET_SERVICE_TASK" datasource="#DSN#">
	SELECT 
		*
	FROM
		PRO_WORKS
	WHERE
		OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
		SERVICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.service_id#">
</cfquery>
