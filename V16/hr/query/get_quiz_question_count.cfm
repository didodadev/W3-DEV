<cfquery name="GET_QUIZ_QUESTION_COUNT" datasource="#dsn#">
	SELECT 
		COUNT(QUIZ_ID) AS COUNTED
	FROM 
		EMPLOYEE_QUIZ_QUESTION
	WHERE
		QUIZ_ID=#attributes.QUIZ_ID#
</cfquery>
