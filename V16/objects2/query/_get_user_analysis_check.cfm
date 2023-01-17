<cfquery name="get_user_analysis_check" DATASOURCE="#DSN#" maxrows="1">
	SELECT 
		RESULT_ID
	FROM 
		MEMBER_ANALYSIS_RESULTS
	WHERE
		ANALYSIS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.analysis_id#">
		<cfif isdefined("session.ww.userkey") and session.ww.userkey contains 'P'>
		AND
		PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#">
		</cfif>
		<cfif isdefined("session.ww.userkey") and session.ww.userkey contains 'C'>
		AND
		CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#">
		</cfif>
	ORDER BY RESULT_ID DESC
</cfquery>
