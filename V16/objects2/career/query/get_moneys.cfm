<cfquery name="GET_MONEYS" datasource="#DSN#">
	SELECT
		MONEY_ID,
		MONEY
	FROM
		SETUP_MONEY
	WHERE
		<cfif isdefined("session.pp.userid")>
			PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.period_id#">
		<cfelse>
			PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.cp.period_id#">	
		</cfif>
</cfquery>
