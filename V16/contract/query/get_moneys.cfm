<cfquery name="GET_MONEYS" datasource="#dsn#">
	SELECT 
		MONEY_ID,
        MONEY,
        RATE1,
        RATE2
	FROM 
		SETUP_MONEY
	WHERE
		PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#"> AND
		MONEY_STATUS = 1
	ORDER BY 
    	MONEY_ID
</cfquery>
