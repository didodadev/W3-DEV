<cfquery name="GET_QUIZ_CHAPTERS" datasource="#dsn#">
	SELECT 
		*
	FROM 
		EMPLOYEE_QUIZ_CHAPTER
	WHERE
		QUIZ_ID=#attributes.QUIZ_ID#
</cfquery>

