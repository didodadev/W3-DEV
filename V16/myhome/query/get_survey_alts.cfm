<cfquery name="GET_SURVEY_ALTS" datasource="#DSN#">
	SELECT
		*
	FROM
		SURVEY_ALTS
	WHERE
		SURVEY_ID = #attributes.survey_id#
</cfquery>
<cfquery name="GET_SURVEY_VOTES_COUNT" datasource="#DSN#">
    SELECT
        #dsn#.Get_Dynamic_Language(ALT_ID,'#session.ep.language#','SURVEY_ALTS','ALT',NULL,NULL,ALT) AS ALT,
        ISNULL(VOTE_COUNT,0) VOTE_COUNT
    FROM
        SURVEY_ALTS
    WHERE
        SURVEY_ID = #attributes.survey_id#
</cfquery>
