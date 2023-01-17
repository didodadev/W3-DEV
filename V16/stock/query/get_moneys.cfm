<cfquery name="MONEYS" datasource="#DSN#">
	SELECT 
        * 
    FROM 
        SETUP_MONEY 
    WHERE 
        PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#"> AND MONEY_STATUS = 1
</cfquery>
<cfquery name="GET_MONEYS" datasource="#DSN#">
	SELECT
    	MONEY_ID, 
        MONEY 
    FROM 
    	SETUP_MONEY 
    WHERE 
    	PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
</cfquery>
