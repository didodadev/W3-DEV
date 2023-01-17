<cfquery name="GET_QUIZ_RESULTS" datasource="#dsn#">
	SELECT 
		QUIZ_RESULTS.*,
		QUIZ.QUIZ_HEAD
	FROM 
		QUIZ_RESULTS,
		QUIZ
	WHERE
		QUIZ_RESULTS.QUIZ_ID = QUIZ.QUIZ_ID AND
		QUIZ_RESULTS.EMP_ID = #SESSION.EP.USERID# AND
		QUIZ.QUIZ_HEAD LIKE '%#ATTRIBUTES.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI
	ORDER BY
		USER_POINT DESC
</cfquery>		


<cfquery name="GET_QUIZ_RIGHT_SUM" datasource="#dsn#">
	SELECT 
		AVG(USER_RIGHT_COUNT) AS RIGHT_SUM,
		QUIZ_ID
	FROM 
		QUIZ_RESULTS
	GROUP BY
		QUIZ_ID
</cfquery>
