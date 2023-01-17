<cfquery name="GET_ANALYSIS_QUESTIONS" datasource="#DSN#">
	SELECT
		*
	FROM
		MEMBER_QUESTION
	WHERE
		ANALYSIS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.analysis_id#">
	ORDER BY
		QUESTION_ID
</cfquery>
