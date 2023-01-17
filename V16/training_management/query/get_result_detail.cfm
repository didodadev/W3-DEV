<cfquery name="GET_RESULT_DETAIL" datasource="#dsn#">
	SELECT 
		*
	FROM 
		QUIZ_RESULTS_DETAILS
	WHERE
		RESULT_ID = #attributes.RESULT_ID#
</cfquery>
