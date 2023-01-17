<cfquery name="GET_SURVEY_ALTS" datasource="#dsn#">
	SELECT
		*
	FROM
		SURVEY_ALTS
	WHERE
		SURVEY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.SURVEY_ID#">
</cfquery>
