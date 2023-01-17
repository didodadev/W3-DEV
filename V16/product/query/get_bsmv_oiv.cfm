<cfquery name="GET_OIV" datasource="#dsn3#">
	SELECT OIV_ID, TAX FROM SETUP_OIV WHERE PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#"> ORDER BY TAX
</cfquery>

<cfquery name="GET_BSMV" datasource="#dsn3#">
	SELECT BSMV_ID, TAX FROM SETUP_BSMV WHERE PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#"> ORDER BY TAX
</cfquery>
