<cfquery name="GET_RESULT_DETAIL" datasource="#DSN#">
	SELECT 
		*
	FROM 
		MEMBER_ANALYSIS_RESULTS_DETAILS		
	WHERE
		RESULT_ID = #attributes.result_id# AND
		QUESTION_ID = #get_analysis_questions.question_id#
</cfquery>

