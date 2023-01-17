<cfquery name="GET_RESULT_DETAIL" datasource="#dsn#">
	SELECT 
		*
	FROM 
		MEMBER_ANALYSIS_RESULTS_DETAILS		
	WHERE
		MEMBER_ANALYSIS_RESULTS_DETAILS.RESULT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.result_id#">
		AND
		MEMBER_ANALYSIS_RESULTS_DETAILS.QUESTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_analysis_questions.question_id#">
</cfquery>

