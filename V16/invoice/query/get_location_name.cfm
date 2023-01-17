<cfquery name="GET_LOCATION_NAME" datasource="#DSN#">
	SELECT 
		COMMENT,
		DEPARTMENT_LOCATION 
	FROM
		STOCKS_LOCATION 
	WHERE 
		LOCATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.location_id#"> 
		AND DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department_id#">
</cfquery>
