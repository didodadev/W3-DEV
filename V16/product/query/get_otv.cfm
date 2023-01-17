<cfquery name="GET_OTV" datasource="#dsn3#">
	SELECT OTV_ID,TAX_TYPE, TAX FROM SETUP_OTV WHERE PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#"> AND (TAX_TYPE = 2 OR TAX_TYPE IS NULL) ORDER BY TAX
</cfquery>
