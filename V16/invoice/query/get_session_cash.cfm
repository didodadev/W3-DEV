<cfquery name="KASA" datasource="#DSN2#">
	SELECT 
    	CASH_ID,
        CASH_CURRENCY_ID,
        CASH_NAME 
    FROM 
    	CASH 
    WHERE 
    	CASH_CURRENCY_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money#"> 
    ORDER BY 
    	CASH_NAME
</cfquery>

