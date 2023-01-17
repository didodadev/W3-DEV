<cfquery name="GET_QUIZ_NAME" datasource="#dsn#">
	SELECT 
		QUIZ_HEAD
	FROM 
		QUIZ
	WHERE
		QUIZ_ID=#attributes.QUIZ_ID#
</cfquery>
