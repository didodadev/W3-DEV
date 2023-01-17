<cfquery name="GET_TRAINING_JOIN_REQUEST" datasource="#DSN#">
	SELECT 
		*
	FROM 
		TRAINING_JOIN_REQUESTS
	WHERE
		TRAINING_ID = #attributes.training_id# AND 
		EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
</cfquery>

