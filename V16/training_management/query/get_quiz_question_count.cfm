<cfquery name="GET_QUIZ_QUESTION_COUNT" datasource="#dsn#">
	SELECT 
		COUNT(QUESTION_ID) AS COUNTED
	FROM 
		QUIZ_QUESTIONS
	WHERE
		QUIZ_ID=#attributes.QUIZ_ID#
</cfquery>		

