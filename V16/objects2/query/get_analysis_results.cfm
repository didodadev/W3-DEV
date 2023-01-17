<cfquery name="GET_ANALYSIS_RESULTS" datasource="#DSN#">
	SELECT 
		*
	FROM 
		MEMBER_ANALYSIS_RESULTS
	WHERE
		ANALYSIS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.analysis_id#">
	ORDER BY
		USER_POINT DESC
</cfquery>		

