<cfquery name="GET_SURVEY_ALTS" datasource="#dsn#">
	SELECT
    	alt,
		ISNULL(VOTE_COUNT,0) COUNT_VOTE,
        *
	FROM
		SURVEY_ALTS
	WHERE
		SURVEY_ID = #attributes.survey_id#
</cfquery>
