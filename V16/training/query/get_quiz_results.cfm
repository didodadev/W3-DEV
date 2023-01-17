<cfquery name="GET_QUIZ_RESULTS" datasource="#dsn#">
	SELECT 
		*
	FROM 
		QUIZ_RESULTS
	WHERE
		QUIZ_RESULTS.QUIZ_ID = #attributes.QUIZ_ID#
	ORDER BY
		USER_POINT DESC
</cfquery>		

<cfquery name="GET_QUIZ_RIGHT_SUM" datasource="#dsn#">
	SELECT 
		AVG(USER_RIGHT_COUNT) AS RIGHT_SUM,
		QUIZ_ID
	FROM 
		QUIZ_RESULTS
	WHERE
		QUIZ_RESULTS.QUIZ_ID = #attributes.QUIZ_ID#
	GROUP BY
		QUIZ_ID
</cfquery>
