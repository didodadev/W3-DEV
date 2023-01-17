<cfcomponent>
    <cfset dsn = application.systemParam.systemParam().dsn>
    <cfset dsn3 = "#dsn#_#session.ep.company_id#">
    <cffunction name="get_production_operation_control" access="remote" returntype="any" returnformat="plain">
      <cfargument name="wrk_row_id" type="string" required="yes">
      <cfif isdefined("session.ep")>
        <cfquery name="get_prod_operation" datasource="#dsn3#">
                    SELECT 
                        WRK_ROW_ID 
                    FROM 
                        P_ORDER_OPERATIONS_ROW 
                    WHERE 
                        P_ORDER_ID NOT IN ( SELECT 
                                                P_ORDER_ID 
                                            FROM 
                                                P_ORDER_OPERATIONS_ROW POR 
                                            WHERE 
                                                P_ORDER_OPERATIONS_ROW.WRK_ROW_ID = POR.WRK_ROW_ID AND 
                                                TYPE IN (2)) 
                        AND WRK_ROW_RELATION_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.wrk_row_id#">
                </cfquery>
                <cfset return_val =  replace(serializeJson(get_prod_operation),'//','')>
        <cfelse>
                <cfset return_val =  ''>
      </cfif>
      <cfreturn return_val>
    </cffunction>
</cfcomponent>
