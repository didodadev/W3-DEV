<cfquery name="GET_QUIZ_JOIN_COUNT" datasource="#dsn#">
	SELECT
		COUNT(RESULT_ID) AS TOTAL_ATTENDS
	FROM
		QUIZ_RESULTS
	WHERE
		QUIZ_ID = #attributes.QUIZ_ID#
</cfquery>
