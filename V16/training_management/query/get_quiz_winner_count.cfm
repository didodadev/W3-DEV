<cfquery name="GET_QUIZ_WINNER_COUNT" datasource="#dsn#">
	SELECT
		COUNT(RESULT_ID) AS TOTAL_WINNERS
	FROM
		QUIZ_RESULTS
	WHERE
		QUIZ_ID = #attributes.QUIZ_ID#
		AND
		USER_POINT >= #get_quiz.quiz_average#
</cfquery>
