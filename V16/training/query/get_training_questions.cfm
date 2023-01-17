<cfquery name="get_training_questions" datasource="#dsn#">
	SELECT 
		QUESTION,
		QUESTION_ID
	FROM 
		QUESTION
	WHERE
		TRAINING_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.training_id#">
</cfquery>

