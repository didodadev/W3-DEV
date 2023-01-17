<cfquery name="GET_MONEY" datasource="#DSN#">
	SELECT
		*
	FROM 
		SETUP_MONEY 
	WHERE 
	<cfif isdefined("session.ep.period_id")>
		PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
	<cfelseif isdefined("session.ww.period_id")>
		PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.period_id#">
	</cfif>
	ORDER BY
		MONEY_ID
</cfquery>
