<cfquery name="GET_MONEY" datasource="#DSN#">
	SELECT RATE1, RATE2, MONEY FROM SETUP_MONEY WHERE PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#"> AND MONEY_STATUS = 1 ORDER BY MONEY_ID
</cfquery>
