<cfquery name="GET_QUIZ" datasource="#dsn#">
	SELECT 
		* 
	FROM 
		QUIZ
	WHERE
		QUIZ_ID=#attributes.QUIZ_ID#
</cfquery>
