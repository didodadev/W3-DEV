<cfquery name="GET_QUESTION" datasource="#dsn#">
	SELECT 
		* 
	FROM 
		EMPLOYEE_QUIZ_QUESTION
	WHERE
		QUESTION_ID=#attributes.QUESTION_ID#
</cfquery>		

