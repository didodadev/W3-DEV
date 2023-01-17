<cfquery name="GET_TRAINING_QUIZ_NAMES" datasource="#dsn#">
	SELECT 
		QUIZ_ID, 
		TRAINING_ID,
		QUIZ_STARTDATE,
		QUIZ_FINISHDATE, 
		QUIZ_HEAD
	FROM 
		QUIZ
	WHERE
		<!---QUIZ_DEPARTMENTS IS NOT NULL
		AND--->
		TRAINING_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.training_id#">
</cfquery>		

