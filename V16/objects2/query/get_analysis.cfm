<cfquery name="GET_ANALYSIS" datasource="#DSN#">
	SELECT
		ANALYSIS_HEAD,
		ANALYSIS_AVERAGE
	FROM
		MEMBER_ANALYSIS
	WHERE
		ANALYSIS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.analysis_id#">
</cfquery>
