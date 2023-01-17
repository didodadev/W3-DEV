<cfquery name="GET_QUIZ_RESULT" datasource="#dsn#">
	SELECT 
		*
	FROM 
		QUIZ_RESULTS
	WHERE
		QUIZ_RESULTS.QUIZ_ID = #attributes.QUIZ_ID#
		AND
		EMP_ID = #attributes.EMP_ID#
</cfquery>
