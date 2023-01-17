<cfquery name="get_quiz_stages" datasource="#dsn#">
	SELECT
		STAGE_ID,
		STAGE_NAME
	FROM
		SETUP_QUIZ_STAGE
	ORDER BY
		STAGE_NAME
</cfquery>
