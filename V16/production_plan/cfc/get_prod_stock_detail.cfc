<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cfset dsn3_alias = "#dsn#_#session.ep.company_id#">
    <cfset dsn3 = "#dsn#_#session.ep.company_id#">
    <cfset dsn_alias = "#dsn#">
    <cfset dsn2 = "#dsn#_#session.ep.period_year#_#session.ep.company_id#">

	<cffunction name="prdp_get_total_lot_no_stock" access="remote" returntype="any" returnformat="plain">
		<cfargument name="stock_id" type="numeric" required="yes">
		<cfargument name="lot_no" type="string" required="yes">
        <cfargument name="paper_date_kontrol" type="string" required="yes">
        <cfargument name="is_update" type="string" required="yes">
		<cfif isdefined("session.ep")>
        	<cfquery name="get_lot_no" datasource="#dsn2#">
            	SELECT 
                	SUM(SR.STOCK_IN - SR.STOCK_OUT) AS PRODUCT_TOTAL_STOCK,
                    S.STOCK_ID,
                    S.PRODUCT_NAME,
                    S.STOCK_CODE
                FROM 
                	#dsn3_alias#.STOCKS S,
                    STOCKS_ROW SR
                WHERE 
                	S.IS_LOT_NO = 1 AND 
                	SR.STOCK_ID = S.STOCK_ID AND 
                    SR.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.stock_id#"> AND 
                    SR.LOT_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.lot_no#"> AND 
                    SR.PROCESS_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.paper_date_kontrol#"> AND 
                    S.IS_ZERO_STOCK = 0 AND 
                    UPD_ID NOT IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.is_update#">)
                GROUP BY 
                	S.STOCK_ID,
                    S.PRODUCT_NAME,
                    S.STOCK_CODE
            </cfquery>
        	<cfset return_val =  replace(serializeJson(get_lot_no),'//','')>
        <cfelse>
        	<cfset return_val =  ''>
        </cfif>
		<cfreturn return_val>
	</cffunction>
    
	<cffunction name="prdp_get_total_lot_no_stock_2" access="remote" returntype="any" returnformat="plain">
		<cfargument name="stock_id" type="numeric" required="yes">
		<cfargument name="lot_no" type="string" required="yes">
        <cfargument name="paper_date_kontrol" type="string" required="yes">
        <cfargument name="is_update" type="string" required="yes">
		<cfif isdefined("session.ep")>
        	<cfquery name="get_lot_no" datasource="#dsn2#">
            	SELECT 
                	SUM(SR.STOCK_IN - SR.STOCK_OUT) AS PRODUCT_TOTAL_STOCK,
                    S.STOCK_ID,
                    S.PRODUCT_NAME,
                    S.STOCK_CODE
                FROM 
                	#dsn3_alias#.STOCKS S,
                    STOCKS_ROW SR
                WHERE 
                	S.IS_LOT_NO = 1 AND 
                	SR.STOCK_ID = S.STOCK_ID AND 
                    SR.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.stock_id#"> AND 
                    SR.LOT_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.lot_no#"> AND 
                    SR.PROCESS_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.paper_date_kontrol#"> AND 
                    S.IS_ZERO_STOCK = 0 
                GROUP BY 
                	S.STOCK_ID,
                    S.PRODUCT_NAME,
                    S.STOCK_CODE
            </cfquery>
        	<cfset return_val =  replace(serializeJson(get_lot_no),'//','')>
        <cfelse>
        	<cfset return_val =  ''>
        </cfif>
		<cfreturn return_val>
	</cffunction>
    
    <cffunction name="prdp_get_total_lot_no_stock_3" access="remote" returntype="any" returnformat="plain">
		<cfargument name="stock_id" type="numeric" required="yes">
		<cfargument name="lot_no" type="string" required="yes">
		<cfif isdefined("session.ep")>
            <cfquery name="get_lot_no" datasource="#dsn2#">
                SELECT 
                	SUM(T1.PRODUCT_STOCK) PRODUCT_TOTAL_STOCK,
                    S.STOCK_ID,
                    S.STOCK_CODE,
                    S.PRODUCT_NAME,
                    T1.LOT_NO
                FROM (
                    SELECT 
                        SUM(SR.PRODUCT_STOCK) PRODUCT_STOCK,
                        SR.STOCK_ID,
                        SR.LOT_NO
                    FROM 
                        GET_STOCK_PRODUCT_LOT_NO SR
                    WHERE 
                        SR.STOCK_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.stock_id#">) AND 
                        SR.LOT_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.lot_no#">
                    GROUP BY 
                        SR.STOCK_ID,
                        SR.LOT_NO
                    UNION ALL
                    SELECT 
                        SUM(STOCK_ARTIR - STOCK_AZALT) AS PRODUCT_STOCK,
                        STOCK_ID,
                        LOT_NO
                    FROM 
                        #dsn3_alias#.GET_PRODUCTION_RESERVED_LOT_NO
                    WHERE 
                        STOCK_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.stock_id#">) AND 
                        LOT_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.lot_no#">
                    GROUP BY 
                    	STOCK_ID,
                    	LOT_NO
                    UNION ALL
                    SELECT 
                        (SUM(STOCK_IN - SR.STOCK_OUT) * - 1) AS PRODUCT_STOCK,
                        SR.STOCK_ID,
                        SR.LOT_NO
                    FROM 
                        STOCKS_ROW SR,
                        #dsn_alias#.STOCKS_LOCATION SL
                    WHERE 
                        SR.STOCK_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.stock_id#">) AND 
                        SR.STORE = SL.DEPARTMENT_ID AND 
                        SR.STORE_LOCATION = SL.LOCATION_ID AND 
                        NO_SALE = 1 AND 
                        SR.LOT_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.lot_no#">
                    GROUP BY 
                        STOCK_ID,
                        SR.LOT_NO
                    ) T1,
                    #dsn3_alias#.STOCKS S
                WHERE 
                    S.STOCK_ID = T1.STOCK_ID AND 
                    (
                        S.IS_ZERO_STOCK = 0 AND 
                        S.IS_LIMITED_STOCK = 1
                    )
                GROUP BY 
                	S.STOCK_ID,
                    S.STOCK_CODE,
                    S.PRODUCT_NAME,
                    T1.LOT_NO
                ORDER BY 
                	S.STOCK_ID
            </cfquery>
        	<cfset return_val =  replace(serializeJson(get_lot_no),'//','')>
        <cfelse>
        	<cfset return_val =  ''>
        </cfif>
		<cfreturn return_val>
	</cffunction>
    
    <cffunction name="prdp_get_total_lot_no_stock_4" access="remote" returntype="any" returnformat="plain">
		<cfargument name="stock_id" type="numeric" required="yes">
		<cfargument name="lot_no" type="string" required="yes">
        <cfargument name="paper_date_kontrol" type="string" required="yes">
        <cfargument name="is_update" type="string" required="yes">
        <cfargument name="loc_id" type="string" required="yes">
        <cfargument name="dep_id" type="string" required="yes">
		<cfif isdefined("session.ep")>
        	<cfquery name="get_lot_no" datasource="#dsn2#">
                SELECT 
                    SUM(SR.STOCK_IN - SR.STOCK_OUT) AS PRODUCT_TOTAL_STOCK,
                    S.STOCK_ID,
                    S.STOCK_CODE,
                    S.PRODUCT_NAME AS PRODUCT_NAME,
                    SR.LOT_NO
                FROM 
                    #dsn3_alias#.STOCKS S,
                    STOCKS_ROW SR
                WHERE 
                    SR.STOCK_ID = S.STOCK_ID AND 
                    SR.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.stock_id#"> AND 
                    S.IS_ZERO_STOCK = 0 AND 
                    SR.PROCESS_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.paper_date_kontrol#"> AND 
                    SR.STORE_LOCATION = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.loc_id#"> AND 
                    SR.STORE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.dep_id#"> AND 
                    UPD_ID NOT IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.is_update#">) AND 
                    SR.LOT_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.lot_no#">
                GROUP BY 
                    S.STOCK_ID,
                    S.STOCK_CODE,
                    S.PRODUCT_NAME,
                    SR.LOT_NO
            </cfquery>
        	<cfset return_val =  replace(serializeJson(get_lot_no),'//','')>
        <cfelse>
        	<cfset return_val =  ''>
        </cfif>
		<cfreturn return_val>
	</cffunction>  
    
    <cffunction name="prdp_get_total_lot_no_stock_5" access="remote" returntype="any" returnformat="plain">
		<cfargument name="stock_id" type="numeric" required="yes">
		<cfargument name="lot_no" type="string" required="yes">
        <cfargument name="paper_date_kontrol" type="string" required="yes">
        <cfargument name="loc_id" type="numeric" required="yes">
        <cfargument name="dep_id" type="numeric" required="yes">
		<cfif isdefined("session.ep")>
        	<cfquery name="get_lot_no" datasource="#dsn2#">
                SELECT 
                    SUM(SR.STOCK_IN - SR.STOCK_OUT) AS PRODUCT_TOTAL_STOCK,
                    S.STOCK_ID,
                    S.STOCK_CODE,
                    S.PRODUCT_NAME AS PRODUCT_NAME,
                    SR.LOT_NO
                FROM 
                    #dsn3_alias#.STOCKS S,
                    STOCKS_ROW SR
                WHERE 
                    SR.STOCK_ID = S.STOCK_ID AND 
                    SR.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.stock_id#"> AND 
                    S.IS_ZERO_STOCK = 0 AND 
                    SR.PROCESS_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.paper_date_kontrol#"> AND 
                    SR.STORE_LOCATION = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.loc_id#"> AND 
                    SR.STORE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.dep_id#"> AND 
                    SR.LOT_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.lot_no#">
                GROUP BY 
                    S.STOCK_ID,
                    S.STOCK_CODE,
                    S.PRODUCT_NAME,
                    SR.LOT_NO
            </cfquery>
            <cfset return_val =  replace(serializeJson(get_lot_no),'//','')>
        <cfelse>
        	<cfset return_val = ''>
        </cfif>
		<cfreturn return_val>
	</cffunction> 
    
    <cffunction name="get_result_fis_info" access="remote" returntype="any" returnformat="plain" hint="Üretim Sonucuna Dair Fiş Kontrolü Yapar">
		<cfargument name="pr_order_id" type="numeric" required="yes">
		<cfif isdefined("session.ep")>
        	<cfquery name="get_period" datasource="#dsn#">
                SELECT TOP 3 PERIOD_YEAR,OUR_COMPANY_ID,PERIOD_ID FROM SETUP_PERIOD WHERE OUR_COMPANY_ID = #session.ep.company_id# ORDER BY PERIOD_YEAR DESC
            </cfquery>
        	<cfquery name="get_fis" datasource="#dsn#">
            	SELECT DISTINCT PROD_ORDER_RESULT_NUMBER
                FROM (
                <cfloop query="get_period">
                    SELECT 
                    	SF.PROD_ORDER_RESULT_NUMBER 
                    FROM 
                    	#dsn#_#get_period.PERIOD_YEAR#_#get_period.OUR_COMPANY_ID#.STOCK_FIS SF 
                    WHERE 
                    	SF.PROD_ORDER_RESULT_NUMBER = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.pr_order_id#">
                    <cfif currentrow neq get_period.recordcount> UNION ALL </cfif> 
                </cfloop>
                ) AS T
            </cfquery>
            <cfset return_val =  replace(serializeJson(get_fis),'//','')>
        <cfelse>
        	<cfset return_val = ''>
        </cfif>
		<cfreturn return_val>
    </cffunction>
    
    <cffunction name="get_prod_amount_outage_control" access="remote" returntype="any" returnformat="plain">
		<cfargument name="pr_order_id" type="numeric" required="yes">
		<cfif isdefined("session.ep")>
        	<cfquery name="get_prod_amount_outage_control" datasource="#dsn3#">
            	SELECT 
                    STOCK_ID,
                    ISNULL(LOT_NO,'') AS LOT_NO,
                    AMOUNT,
                    WRK_ROW_ID 
                FROM 
                    PRODUCTION_ORDER_RESULTS_ROW 
                WHERE 
                    TYPE = 3
                    AND PR_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.pr_order_id#">
                ORDER BY PR_ORDER_ROW_ID
            </cfquery>
        	<cfset return_val =  replace(serializeJson(get_prod_amount_outage_control),'//','')>
        <cfelse>
        	<cfset return_val =  ''>
        </cfif>
		<cfreturn return_val>
    </cffunction>
    
    <cffunction name="get_prod_amount_exit_control" access="remote" returntype="any" returnformat="plain">
		<cfargument name="pr_order_id" type="numeric" required="yes">
		<cfif isdefined("session.ep")>
        	<cfquery name="get_prod_amount_exit_control" datasource="#dsn3#">
            	SELECT 
                    STOCK_ID,
                    ISNULL(LOT_NO,'') AS LOT_NO,
                    AMOUNT,
                    WRK_ROW_ID 
                FROM 
                    PRODUCTION_ORDER_RESULTS_ROW 
                WHERE 
                    TYPE = 2 
                    AND PR_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.pr_order_id#">
                ORDER BY PR_ORDER_ROW_ID
            </cfquery>
        	<cfset return_val =  replace(serializeJson(get_prod_amount_exit_control),'//','')>
        <cfelse>
        	<cfset return_val =  ''>
        </cfif>
		<cfreturn return_val>
	</cffunction>
</cfcomponent>
