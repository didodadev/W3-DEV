<cfquery name="GET_SURVEY_VOTES_COUNT" datasource="#dsn#">
	SELECT
		ANSWER_ID,
		VOTES
	FROM
		SURVEY_VOTES
	WHERE
		SURVEY_ID = #attributes.survey_id#
</cfquery>
