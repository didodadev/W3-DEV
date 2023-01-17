<cfquery name="GET_SERVICE_REPLY" datasource="#dsn3#">
	SELECT 
		*
	FROM
		SERVICE_REPLY
	WHERE
		SERVICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#service_id#">
</cfquery>
