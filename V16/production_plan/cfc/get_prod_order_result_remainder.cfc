<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="get_remain_order_result" access="remote" returntype="any" returnformat="plain">
    <cfargument name="p_order_id" type="numeric" required="yes">  
        <cfquery name="get_remain_order_result1" datasource="#DSN3#">
           SELECT 
            	P_ORDER_ID,(PO.QUANTITY - ISNULL((SELECT SUM(PORR.AMOUNT) AMOUNT FROM PRODUCTION_ORDER_RESULTS POR,PRODUCTION_ORDER_RESULTS_ROW PORR WHERE POR.PR_ORDER_ID = PORR.PR_ORDER_ID AND POR.P_ORDER_ID = PO.P_ORDER_ID AND PORR.TYPE = 1),0)) REMAIN_AMOUNT 
            FROM 
           		PRODUCTION_ORDERS PO 
            WHERE	
				(PO.QUANTITY - ISNULL((SELECT SUM(PORR.AMOUNT) AMOUNT FROM PRODUCTION_ORDER_RESULTS POR,PRODUCTION_ORDER_RESULTS_ROW PORR WHERE POR.PR_ORDER_ID = PORR.PR_ORDER_ID AND POR.P_ORDER_ID = PO.P_ORDER_ID AND PORR.TYPE = 1),0)) > 0
            	AND PO.P_ORDER_ID =#arguments.p_order_id#
        </cfquery>  
       <cfset return_val =  replace(serializeJson(get_remain_order_result1),'//','')>
       <cfreturn return_val>
    </cffunction>
</cfcomponent>
