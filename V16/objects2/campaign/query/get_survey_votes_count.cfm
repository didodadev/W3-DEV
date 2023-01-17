<cfquery name="GET_SURVEY_VOTES_COUNT" datasource="#dsn#">
	SELECT
		ALT,
		VOTE_COUNT
	FROM
		SURVEY_ALTS
	WHERE
		SURVEY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.SURVEY_ID#">
</cfquery>
