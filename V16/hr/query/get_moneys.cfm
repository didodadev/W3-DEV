<cfquery name="GET_MONEYS" datasource="#dsn#">
	SELECT MONEY_ID, MONEY FROM SETUP_MONEY WHERE PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
</cfquery>
