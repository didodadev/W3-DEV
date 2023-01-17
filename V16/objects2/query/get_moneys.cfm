<cfquery name="GET_MONEYS" datasource="#DSN#">
	SELECT 
		MONEY_ID, 
		MONEY 
	FROM 
		SETUP_MONEY 
	WHERE 
		PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.period_id#">
</cfquery>

