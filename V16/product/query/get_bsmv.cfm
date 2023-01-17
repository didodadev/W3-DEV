<cfquery name="GET_BSMV" datasource="#dsn3#">
	SELECT BSMV_ID, TAX FROM SETUP_BSMV WHERE PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#"> ORDER BY TAX
</cfquery>