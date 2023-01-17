<cfquery name="GET_QUIZ_CHAPTER" datasource="#dsn#">
	SELECT 
		* 
	FROM 
		EMPLOYEE_QUIZ_CHAPTER
	WHERE
		CHAPTER_ID=#attributes.CHAPTER_ID#
</cfquery>

