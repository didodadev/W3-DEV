<cfquery name="GET_QUIZ_POINT" datasource="#dsn#">
	SELECT 
		TOTAL_POINTS
	FROM 
		QUIZ
	WHERE
		QUIZ_ID=#attributes.QUIZ_ID#
</cfquery>		

