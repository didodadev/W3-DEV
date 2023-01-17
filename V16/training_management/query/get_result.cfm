<cfquery name="GET_RESULT" datasource="#dsn#">
	SELECT 
		*
	FROM 
		QUIZ_RESULTS
	WHERE
		QUIZ_RESULTS.RESULT_ID = #attributes.RESULT_ID#
</cfquery>		

