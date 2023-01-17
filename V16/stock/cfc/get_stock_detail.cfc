<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cfset dsn3_alias = "#dsn#_#session.ep.company_id#">
    <cfset dsn_alias = "#dsn#">
    <cfset dsn2 = "#dsn#_#session.ep.period_year#_#session.ep.company_id#">
    
    <cffunction name="stk_get_total_lot_no_stock_4" access="remote" returntype="any" returnformat="plain">
    	<cfargument name="stock_id" type="numeric" required="yes">
        <cfargument name="lot_no" type="string" required="yes">
        <cfargument name="loc_id" type="numeric" required="yes">
        <cfargument name="dep_id" type="numeric" required="yes">
        <cfargument name="paper_date_kontrol" type="string" required="yes">
        <cfif isdefined("session.ep")>
        	<cfquery name="get_lot_no" datasource="#dsn2#">
            	SELECT 
                	SUM(SR.STOCK_IN - SR.STOCK_OUT) AS PRODUCT_TOTAL_STOCK,
           			S.PRODUCT_NAME AS PRODUCT_NAME,
            		S.STOCK_CODE,
                    0 AS SPECT_MAIN_ID
        		FROM 
                	#dsn3_alias#.STOCKS S,
            		STOCKS_ROW SR
                WHERE 
                	S.IS_LOT_NO = 1 AND
                	SR.STOCK_ID = S.STOCK_ID AND
                    SR.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.stock_id#"> AND
                    SR.LOT_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.lot_no#"> AND
                    S.IS_ZERO_STOCK = 0 AND 
                    SR.STORE_LOCATION = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.loc_id#"> AND 
                    SR.STORE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.dep_id#"> AND 
                    SR.PROCESS_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.paper_date_kontrol#">
                GROUP BY 
                	S.STOCK_ID,
                    S.STOCK_CODE,
                    S.PRODUCT_NAME
            </cfquery>
        	<cfset return_val =  replace(serializeJson(get_lot_no),'//','')>
        <cfelse>
        	<cfset return_val =  ''>
        </cfif>
		<cfreturn return_val>
    </cffunction>
    
    <cffunction name="stk_get_total_lot_no_stock_5" access="remote" returntype="any" returnformat="plain">
    	<cfargument name="stock_id" type="numeric" required="yes">
        <cfargument name="lot_no" type="string" required="yes">
        <cfargument name="loc_id" type="numeric" required="yes">
        <cfargument name="dep_id" type="numeric" required="yes">
        <cfif isdefined("session.ep")>
        	<cfquery name="get_lot_no" datasource="#dsn2#">
            	SELECT 
                	SUM(SR.STOCK_IN - SR.STOCK_OUT) AS PRODUCT_TOTAL_STOCK,
                    S.PRODUCT_NAME AS PRODUCT_NAME,
                    S.STOCK_CODE,
                    0 AS SPECT_MAIN_ID
                FROM 
                	#dsn3_alias#.STOCKS S,
                    STOCKS_ROW SR
                WHERE 
                	S.IS_LOT_NO = 1 AND
                	SR.STOCK_ID = S.STOCK_ID AND 
                    SR.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.stock_id#"> AND
                    SR.LOT_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.lot_no#"> AND
                    S.IS_ZERO_STOCK = 0 AND
                    SR.STORE_LOCATION = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.loc_id#"> AND 
                    SR.STORE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.dep_id#">
                GROUP BY 
                	S.STOCK_ID,
                    S.STOCK_CODE,
                    S.PRODUCT_NAME

            </cfquery>
        	<cfset return_val =  replace(serializeJson(get_lot_no),'//','')>
        <cfelse>
        	<cfset return_val =  ''>
        </cfif>
		<cfreturn return_val>
    </cffunction>
    
    <cffunction name="stk_get_total_lot_no_stock_6" access="remote" returntype="any" returnformat="plain">
    	<cfargument name="spec_main_id" type="numeric" required="yes">
        <cfargument name="lot_no" type="string" required="yes">
        <cfargument name="loc_id" type="numeric" required="yes">
        <cfargument name="dep_id" type="numeric" required="yes">
        <cfargument name="paper_date_kontrol" type="string" required="yes">
        <cfif isdefined("session.ep")>
        	<cfquery name="get_lot_no" datasource="#dsn2#">
            	SELECT 
                	SUM(SR.STOCK_IN - SR.STOCK_OUT) PRODUCT_TOTAL_STOCK,
                    S.SPECT_MAIN_NAME AS PRODUCT_NAME,
                    ST.STOCK_CODE,
                    S.SPECT_MAIN_ID
                FROM
                	STOCKS_ROW AS SR,
                    #dsn3_alias#.STOCKS ST,
                    #dsn3_alias#.SPECT_MAIN AS S
                WHERE 
                	ST.IS_LOT_NO = 1 AND
                	ST.STOCK_ID = S.STOCK_ID AND
                    SR.PROCESS_TYPE IS NOT NULL AND 
                    S.SPECT_MAIN_ID = SR.SPECT_VAR_ID AND 
                    SR.SPECT_VAR_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.spec_main_id#"> AND
                    SR.LOT_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.lot_no#"> AND
                    ST.IS_ZERO_STOCK = 0 AND
                    SR.STORE_LOCATION = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.loc_id#"> AND 
                    SR.STORE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.dep_id#"> AND
                    SR.PROCESS_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.paper_date_kontrol#">
                GROUP BY 
                	ST.STOCK_CODE,
                    S.SPECT_MAIN_NAME,
                    S.SPECT_MAIN_ID
            </cfquery>
        	<cfset return_val =  replace(serializeJson(get_lot_no),'//','')>
        <cfelse>
        	<cfset return_val =  ''>
        </cfif>
		<cfreturn return_val>
    </cffunction>
    
    <cffunction name="stk_get_total_lot_no_stock_7" access="remote" returntype="any" returnformat="plain">
    	<cfargument name="spec_main_id" type="numeric" required="yes">
        <cfargument name="lot_no" type="string" required="yes">
        <cfargument name="loc_id" type="numeric" required="yes">
        <cfargument name="dep_id" type="numeric" required="yes">
        <cfif isdefined("session.ep")>
        	<cfquery name="get_lot_no" datasource="#dsn2#">
            	SELECT 
                	SUM(SR.STOCK_IN - SR.STOCK_OUT) PRODUCT_TOTAL_STOCK,
                    S.SPECT_MAIN_NAME AS PRODUCT_NAME,
                    ST.STOCK_CODE,
                    S.SPECT_MAIN_ID
                FROM
                	STOCKS_ROW AS SR,
                    #dsn3_alias#.STOCKS ST,
                    #dsn3_alias#.SPECT_MAIN AS S
                WHERE 
                	ST.IS_LOT_NO = 1 AND
                	ST.STOCK_ID = S.STOCK_ID AND
                    SR.PROCESS_TYPE IS NOT NULL AND 
                    S.SPECT_MAIN_ID = SR.SPECT_VAR_ID AND 
                    SR.SPECT_VAR_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.spec_main_id#"> AND
                    SR.LOT_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.lot_no#"> AND
                    ST.IS_ZERO_STOCK = 0 AND
                    SR.STORE_LOCATION = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.loc_id#"> AND
                    SR.STORE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.dep_id#">
                GROUP BY 
                	ST.STOCK_CODE,
                    S.SPECT_MAIN_NAME,
                    S.SPECT_MAIN_ID
            </cfquery>
        	<cfset return_val =  replace(serializeJson(get_lot_no),'//','')>
        <cfelse>
        	<cfset return_val =  ''>
        </cfif>
		<cfreturn return_val>
    </cffunction>
    
    <cffunction name="stk_get_total_lot_no_stock_8" access="remote" returntype="any" returnformat="plain">
    	<cfargument name="stock_id" type="numeric" required="yes">
        <cfargument name="lot_no" type="string" required="yes">
        <cfargument name="loc_id" type="numeric" required="yes">
        <cfargument name="dep_id" type="numeric" required="yes">
        <cfargument name="paper_date_kontrol" type="string" required="yes">
        <cfargument name="is_update" type="string" required="yes">
        <cfif isdefined("session.ep")>
        	<cfquery name="get_lot_no" datasource="#dsn2#">
            	SELECT 
                	SUM(SR.STOCK_IN - SR.STOCK_OUT) AS PRODUCT_TOTAL_STOCK,
           			S.PRODUCT_NAME AS PRODUCT_NAME,
            		S.STOCK_CODE,
                    0 AS SPECT_MAIN_ID
        		FROM 
                	#dsn3_alias#.STOCKS S,
            		STOCKS_ROW SR
                WHERE 
                	S.IS_LOT_NO = 1 AND
                	SR.STOCK_ID = S.STOCK_ID AND
                    SR.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.stock_id#"> AND
                    SR.LOT_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.lot_no#"> AND
                    S.IS_ZERO_STOCK = 0 AND 
                    SR.STORE_LOCATION = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.loc_id#"> AND 
                    SR.STORE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.dep_id#"> AND 
                    SR.PROCESS_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.paper_date_kontrol#"> AND
                    UPD_ID NOT IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.is_update#" list="yes">)
                GROUP BY 
                	S.STOCK_ID,
                    S.STOCK_CODE,
                    S.PRODUCT_NAME
            </cfquery>
        	<cfset return_val =  replace(serializeJson(get_lot_no),'//','')>
        <cfelse>
        	<cfset return_val =  ''>
        </cfif>
		<cfreturn return_val>
    </cffunction>
    
    <cffunction name="stk_get_total_lot_no_stock_9" access="remote" returntype="any" returnformat="plain">
    	<cfargument name="stock_id" type="numeric" required="yes">
        <cfargument name="lot_no" type="string" required="yes">
        <cfargument name="loc_id" type="numeric" required="yes">
        <cfargument name="dep_id" type="numeric" required="yes">
        <cfargument name="is_update" type="string" required="yes">
        <cfif isdefined("session.ep")>
        	<cfquery name="get_lot_no" datasource="#dsn2#">
            	SELECT 
                	SUM(SR.STOCK_IN - SR.STOCK_OUT) AS PRODUCT_TOTAL_STOCK,
                    S.PRODUCT_NAME AS PRODUCT_NAME,
                    S.STOCK_CODE,
                    0 AS SPECT_MAIN_ID
                FROM 
                	#dsn3_alias#.STOCKS S,
                    STOCKS_ROW SR
                WHERE 
                	S.IS_LOT_NO = 1 AND
                	SR.STOCK_ID = S.STOCK_ID AND 
                    SR.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.stock_id#"> AND
                    SR.LOT_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.lot_no#"> AND
                    S.IS_ZERO_STOCK = 0 AND
                    SR.STORE_LOCATION = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.loc_id#"> AND 
                    SR.STORE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.dep_id#"> AND
                    UPD_ID NOT IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.is_update#" list="yes">)
                GROUP BY 
                	S.STOCK_ID,
                    S.STOCK_CODE,
                    S.PRODUCT_NAME
            </cfquery>
        	<cfset return_val =  replace(serializeJson(get_lot_no),'//','')>
        <cfelse>
        	<cfset return_val =  ''>
        </cfif>
		<cfreturn return_val>
    </cffunction>
    
    <cffunction name="stk_get_total_lot_no_stock_10" access="remote" returntype="any" returnformat="plain">
    	<cfargument name="spec_main_id" type="numeric" required="yes">
        <cfargument name="lot_no" type="string" required="yes">
        <cfargument name="loc_id" type="numeric" required="yes">
        <cfargument name="dep_id" type="numeric" required="yes">
        <cfargument name="paper_date_kontrol" type="string" required="yes">
        <cfargument name="is_update" type="string" required="yes">
        <cfif isdefined("session.ep")>
        	<cfquery name="get_lot_no" datasource="#dsn2#">
            	SELECT 
                	SUM(SR.STOCK_IN - SR.STOCK_OUT) PRODUCT_TOTAL_STOCK,
                    S.SPECT_MAIN_NAME AS PRODUCT_NAME,
                    ST.STOCK_CODE,
                    S.SPECT_MAIN_ID
                FROM
                	STOCKS_ROW AS SR,
                    #dsn3_alias#.STOCKS ST,
                    #dsn3_alias#.SPECT_MAIN AS S
                WHERE 
                	ST.IS_LOT_NO = 1 AND
                	ST.STOCK_ID = S.STOCK_ID AND
                    SR.PROCESS_TYPE IS NOT NULL AND 
                    S.SPECT_MAIN_ID = SR.SPECT_VAR_ID AND 
                    SR.SPECT_VAR_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.spec_main_id#"> AND
                    SR.LOT_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.lot_no#"> AND
                    ST.IS_ZERO_STOCK = 0 AND
                    SR.STORE_LOCATION = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.loc_id#"> AND 
                    SR.STORE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.dep_id#"> AND
                    SR.PROCESS_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.paper_date_kontrol#"> AND
                    UPD_ID NOT IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.is_update#" list="yes">)
                GROUP BY 
                	ST.STOCK_CODE,
                    S.SPECT_MAIN_NAME,
                    S.SPECT_MAIN_ID
            </cfquery>
        	<cfset return_val =  replace(serializeJson(get_lot_no),'//','')>
        <cfelse>
        	<cfset return_val =  ''>
        </cfif>
		<cfreturn return_val>
    </cffunction>
    
    <cffunction name="stk_get_total_lot_no_stock_11" access="remote" returntype="any" returnformat="plain">
    	<cfargument name="spec_main_id" type="numeric" required="yes">
        <cfargument name="lot_no" type="string" required="yes">
        <cfargument name="loc_id" type="numeric" required="yes">
        <cfargument name="dep_id" type="numeric" required="yes">
        <cfargument name="is_update" type="string" required="yes">
        <cfif isdefined("session.ep")>
        	<cfquery name="get_lot_no" datasource="#dsn2#">
            	SELECT 
                	SUM(SR.STOCK_IN - SR.STOCK_OUT) PRODUCT_TOTAL_STOCK,
                    S.SPECT_MAIN_NAME AS PRODUCT_NAME,
                    ST.STOCK_CODE,
                    S.SPECT_MAIN_ID
                FROM
                	STOCKS_ROW AS SR,
                    #dsn3_alias#.STOCKS ST,
                    #dsn3_alias#.SPECT_MAIN AS S
                WHERE 
                	ST.IS_LOT_NO = 1 AND
                	ST.STOCK_ID = S.STOCK_ID AND
                    SR.PROCESS_TYPE IS NOT NULL AND 
                    S.SPECT_MAIN_ID = SR.SPECT_VAR_ID AND 
                    SR.SPECT_VAR_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.spec_main_id#"> AND
                    SR.LOT_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.lot_no#"> AND
                    ST.IS_ZERO_STOCK = 0 AND
                    SR.STORE_LOCATION = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.loc_id#"> AND
                    SR.STORE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.dep_id#"> AND
                    UPD_ID NOT IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.is_update#" list="yes">)
                GROUP BY 
                	ST.STOCK_CODE,
                    S.SPECT_MAIN_NAME,
                    S.SPECT_MAIN_ID
            </cfquery>
        	<cfset return_val =  replace(serializeJson(get_lot_no),'//','')>
        <cfelse>
        	<cfset return_val =  ''>
        </cfif>
		<cfreturn return_val>
    </cffunction>
</cfcomponent>
