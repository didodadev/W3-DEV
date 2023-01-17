<cfquery name="GET_SHIP_DETAIL" datasource="#DSN2#">
	SELECT 
    	(SELECT TOP 1 DATEDIFF(DAY,O.ORDER_DATE,O.DUE_DATE) FROM #dsn3_alias#.ORDERS O,#dsn3_alias#.ORDERS_SHIP OS WHERE O.ORDER_ID = OS.ORDER_ID AND OS.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#"> AND OS.SHIP_ID = SHIP.SHIP_ID) DUE_DAY,* 
    FROM 
    	SHIP 
    WHERE  
    	SHIP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ship_id#">
</cfquery>

