<cfquery name="GET_QUIZ_QUESTION_ID_LIST" datasource="#dsn#">
	SELECT 
		QUESTION_ID
	FROM 
		QUIZ_QUESTIONS
	WHERE
		QUIZ_ID=#attributes.QUIZ_ID#
</cfquery>
