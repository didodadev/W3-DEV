<cfquery name="GET_SURVEY" datasource="#DSN#">
	SELECT
		#dsn#.Get_Dynamic_Language(SURVEY_ID,'#session_base.language#','SURVEY','SURVEY',NULL,NULL,SURVEY) AS SURVEY
	FROM
		SURVEY
	WHERE
		SURVEY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.survey_id#">
</cfquery>
