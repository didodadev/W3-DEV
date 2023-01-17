<cfquery name="GET_QUIZ_QUESTIONS" datasource="#dsn#">
	SELECT 
		*
	FROM 
		EMPLOYEE_QUIZ_QUESTION
	WHERE
		CHAPTER_ID=#attributes.CHAPTER_ID#
</cfquery>

