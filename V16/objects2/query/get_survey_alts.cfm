<cfquery name="GET_SURVEY_ALTS" datasource="#DSN#">
	SELECT
		#dsn#.Get_Dynamic_Language(ALT_ID,'#session_base.language#','SURVEY_ALTS','ALT',NULL,NULL,ALT) AS ALT
	FROM
		SURVEY_ALTS
	WHERE
		SURVEY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.survey_id#">
</cfquery>

<cfquery name="GET_SURVEY_VOTES_COUNT" datasource="#DSN#">
	SELECT
		#dsn#.Get_Dynamic_Language(ALT_ID,'#session_base.language#','SURVEY_ALTS','ALT',NULL,NULL,ALT) AS ALT,
		VOTE_COUNT,
        (SELECT SUM(VOTE_COUNT)FROM SURVEY_ALTS WHERE SURVEY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.survey_id#">) AS TOTAL_VOTE_COUNT
	FROM
		SURVEY_ALTS
	WHERE
		SURVEY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.survey_id#">
</cfquery>
