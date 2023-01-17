<cfquery name="GET_TRAINING_JOIN_REQUEST_GENERAL" datasource="#dsn#">
	SELECT 
		*
	FROM 
		TRAINING_JOIN_REQUESTS
	WHERE
		TRAINING_ID=#attributes.TRAINING_ID#
		AND 
		EMPLOYEE_ID = #session.ep.userid#
		AND 
		CLASS_ID IS NULL
</cfquery>

