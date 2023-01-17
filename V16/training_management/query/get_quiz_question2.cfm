<cfquery name="GET_QUIZ_QUESTION2" datasource="#dsn#">
	SELECT 
		*
	FROM 
		QUESTION
	WHERE
		QUESTION_ID=#attributes.QUESTION_ID#
</cfquery>		

