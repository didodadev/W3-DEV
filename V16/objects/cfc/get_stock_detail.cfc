<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cfset dsn3_alias = "#dsn#_#session.ep.company_id#">
    <cfset dsn_alias = "#dsn#">
    <cfset dsn2 = "#dsn#_#session.ep.period_year#_#session.ep.company_id#">
    <cfset dsn3 = "#dsn#_#session.ep.company_id#">
	<cffunction name="obj_get_total_lot_no_stock" access="remote" returntype="any" returnformat="plain">
		<cfargument name="stock_id" type="numeric" required="yes">
		<cfargument name="lot_no" type="string" required="yes">
        <cfargument name="paper_date_kontrol" type="string" required="yes">
        <cfargument name="is_update" type="string" required="yes">
		<cfif isdefined("session.ep")>
        	<cfquery name="get_lot_no" datasource="#dsn2#">
                SELECT 
                    ROUND(SUM(SR.STOCK_IN - SR.STOCK_OUT),8) AS PRODUCT_TOTAL_STOCK,
                    S.STOCK_ID,
                    S.STOCK_CODE,
                    S.PRODUCT_NAME AS PRODUCT_NAME
                FROM 
                    #dsn3_alias#.STOCKS S,
                    STOCKS_ROW SR
                WHERE 
                    S.IS_LOT_NO = 1 AND 
                    SR.STOCK_ID = S.STOCK_ID AND 
                    SR.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.stock_id#"> AND 
                    SR.LOT_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.lot_no#"> AND 
                    S.IS_ZERO_STOCK = 0 AND 
                    SR.PROCESS_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.paper_date_kontrol#"> AND 
                    UPD_ID NOT IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.is_update#">)
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
    
    <cffunction name="obj_get_total_lot_no_stock_2" access="remote" returntype="any" returnformat="plain">
		<cfargument name="stock_id" type="numeric" required="yes">
		<cfargument name="lot_no" type="string" required="yes">
        <cfargument name="paper_date_kontrol" type="string" required="yes">
        <cfargument name="is_update" type="string" required="yes">
		<cfif isdefined("session.ep")>
        	<cfquery name="get_lot_no" datasource="#dsn2#">
                SELECT 
                    ROUND(SUM(SR.STOCK_IN - SR.STOCK_OUT),8) AS PRODUCT_TOTAL_STOCK,
                    S.STOCK_ID,
                    S.STOCK_CODE,
                    S.PRODUCT_NAME AS PRODUCT_NAME
                FROM 
                    #dsn3_alias#.STOCKS S,
                    STOCKS_ROW SR
                WHERE 
                    S.IS_LOT_NO = 1 AND 
                    SR.STOCK_ID = S.STOCK_ID AND 
                    SR.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.stock_id#"> AND 
                    SR.LOT_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.lot_no#"> AND 
                    S.IS_ZERO_STOCK = 0 AND 
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
    
    <cffunction name="obj_get_total_lot_no_stock_3" access="remote" returntype="any" returnformat="plain">
		<cfargument name="stock_id" type="numeric" required="yes">
		<cfargument name="lot_no" type="string" required="yes">
		<cfif isdefined("session.ep")>
            <cfquery name="get_lot_no" datasource="#dsn2#">
                SELECT 
                	ROUND(SUM(T1.PRODUCT_STOCK),8) PRODUCT_TOTAL_STOCK,
                    S.STOCK_ID,
                    S.STOCK_CODE,
                    S.PRODUCT_NAME,
                    T1.LOT_NO
                FROM (
                    SELECT 
                        ROUND(SUM(SR.PRODUCT_STOCK),8) PRODUCT_STOCK,
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
					<!--- UNION ALL
                        SELECT 
                            SUM(STOCK_ARTIR - STOCK_AZALT) AS PRODUCT_STOCK
                            ,STOCK_ID
                            ,'' LOT_NO
                        FROM 
                            #dsn3_alias#.GET_STOCK_RESERVED_ROW
                        WHERE 
                            STOCK_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.stock_id#">)
                            AND ORDER_ID NOT IN (#arguments.order_id#)
                        GROUP BY 
                            STOCK_ID --->
                    UNION ALL
                    SELECT 
                        ROUND(SUM(STOCK_ARTIR - STOCK_AZALT),8) AS PRODUCT_STOCK,
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
                       ROUND((SUM(STOCK_IN - SR.STOCK_OUT) * - 1),8) AS PRODUCT_STOCK,
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
    
    <cffunction name="obj_get_total_lot_no_stock_4" access="remote" returntype="any" returnformat="plain">
		<cfargument name="stock_id" type="numeric" required="yes">
		<cfargument name="lot_no" type="string" required="yes">
        <cfargument name="paper_date_kontrol" type="string" required="yes">
        <cfargument name="is_update" type="string" required="yes">
        <cfargument name="loc_id" type="string" required="yes">
        <cfargument name="dep_id" type="string" required="yes">
		<cfif isdefined("session.ep")>
        	<cfquery name="get_lot_no" datasource="#dsn2#">
                SELECT 
                    ROUND(SUM(SR.STOCK_IN - SR.STOCK_OUT),8) AS PRODUCT_TOTAL_STOCK,
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
    
    <cffunction name="obj_get_total_lot_no_stock_5" access="remote" returntype="any" returnformat="plain">
		<cfargument name="stock_id" type="numeric" required="yes">
		<cfargument name="lot_no" type="string" required="yes">
        <cfargument name="paper_date_kontrol" type="string" required="yes">
        <cfargument name="loc_id" type="numeric" required="yes">
        <cfargument name="dep_id" type="numeric" required="yes">
		<cfif isdefined("session.ep")>
        	<cfquery name="get_lot_no" datasource="#dsn2#">
                SELECT 
                    ROUND(SUM(SR.STOCK_IN - SR.STOCK_OUT),8) AS PRODUCT_TOTAL_STOCK,
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
        	<cfset return_val =  ''>
        </cfif>
		<cfreturn return_val>
	</cffunction>  
    
    <cffunction name="obj_get_total_lot_no_stock_6" access="remote" returntype="any" returnformat="plain">
		<cfargument name="stock_id" type="numeric" required="yes">
		<cfargument name="lot_no" type="string" required="yes">
        <cfargument name="paper_date_kontrol" type="string" required="yes">
        <cfargument name="loc_id" type="numeric" required="yes">
        <cfargument name="dep_id" type="numeric" required="yes">
		<cfif isdefined("session.ep")>
        	<cfquery name="get_lot_no" datasource="#dsn2#">
                SELECT 
                    ROUND(SUM(T1.PRODUCT_STOCK),8) PRODUCT_TOTAL_STOCK,
                    S.STOCK_ID,
                    S.STOCK_CODE,
                    S.PRODUCT_NAME,
                    T1.LOT_NO
                FROM (
                    SELECT 
                        ROUND(SUM(STOCK_ARTIR - STOCK_AZALT),8) AS PRODUCT_STOCK,
                        STOCK_ID,
                        LOT_NO
                    FROM 
                        #dsn3_alias#.GET_PRODUCTION_RESERVED_LOCATION_LOT_NO
                    WHERE 
                        STOCK_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.stock_id#">) AND 
                        DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.dep_id#"> AND 
                        LOCATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.loc_id#"> AND 
                        LOT_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.lot_no#">
                    GROUP BY 
                        STOCK_ID,
                        LOT_NO
                    UNION ALL
                    SELECT 
                        ROUND((SUM(STOCK_IN - SR.STOCK_OUT)),8) AS PRODUCT_STOCK,
                        SR.STOCK_ID,
                        SR.LOT_NO
                    FROM 
                        STOCKS_ROW SR,
                        #dsn_alias#.STOCKS_LOCATION SL
                    WHERE 
                        SR.STOCK_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.stock_id#">) AND 
                        SR.STORE = SL.DEPARTMENT_ID AND 
                        SR.STORE_LOCATION = SL.LOCATION_ID AND 
                        ISNULL(NO_SALE, 0) = 0 AND 
                        SR.STORE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.dep_id#"> AND 
                        SR.STORE_LOCATION = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.loc_id#"> AND 
                        SR.PROCESS_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.paper_date_kontrol#"> AND 
                        SR.LOT_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.lot_no#">
                    GROUP BY 
                        STOCK_ID,
                        SR.LOT_NO
                    ) T1
                    ,#dsn3_alias#.STOCKS S
                WHERE 
                    S.STOCK_ID = T1.STOCK_ID AND 
                    (
                        S.IS_ZERO_STOCK = 0
                        AND S.IS_LIMITED_STOCK = 1
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
    <cffunction name="GET_STOCK_RESERVED" access="remote" returntype="any"><!-----Satılabilir Stok Miktarı Listelenecek Depo-Lokasyon bilgileri için eklendi ERU------>
        <cfargument name="xml_use_other_dept_info_ss" type="string" required="yes">
        <cfargument name="product_id_list" type="string" required="yes">
        <cfquery name="GET_STOCK_RESERVED" datasource="#DSN3#"><!--- siparisler stoktan dusulecek veya eklenecekse toplamını alalım--->
			SELECT
				SUM(STOCK_AZALT) AS AZALAN,
				SUM(STOCK_ARTIR) AS ARTAN,
				PRODUCT_ID,
				STOCK_ID
			FROM
					GET_STOCK_RESERVED_ROW_LOCATION	
			WHERE
				PRODUCT_ID IN (#arguments.product_id_list#)
			AND DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listfirst(arguments.xml_use_other_dept_info_ss,'-')#">
			AND LOCATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listlast(arguments.xml_use_other_dept_info_ss,'-')#">
			GROUP BY
				PRODUCT_ID,
				STOCK_ID
			ORDER BY
			STOCK_ID
        </cfquery>
        <cfreturn GET_STOCK_RESERVED>
    </cffunction>
    <cffunction name="SCRAP_LOCATION_TOTAL_STOCK" access="remote" returntype="any">
        <cfargument name="xml_use_other_dept_info_ss" type="string" required="yes">
        <cfargument name="product_id_list" type="string" required="yes">
        <cfquery name="SCRAP_LOCATION_TOTAL_STOCK" datasource="#DSN2#">
            SELECT
                SUM(STOCK_IN - SR.STOCK_OUT) AS TOTAL_SCRAP_STOCK
            FROM
                STOCKS_ROW SR,
                #dsn_alias#.STOCKS_LOCATION SL 
            WHERE
                SR.PRODUCT_ID IN (#arguments.product_id_list#)
             AND
                SR.STORE = SL.DEPARTMENT_ID AND
                SR.STORE_LOCATION = SL.LOCATION_ID AND
                ISNULL(SL.IS_SCRAP,0) = 1
                AND SR.STORE =  <cfqueryparam cfsqltype="cf_sql_integer" value="#listfirst(arguments.xml_use_other_dept_info_ss,'-')#">
                AND SR.STORE_LOCATION =  <cfqueryparam cfsqltype="cf_sql_integer" value="#listlast(arguments.xml_use_other_dept_info_ss,'-')#">
        </cfquery>
        <cfreturn SCRAP_LOCATION_TOTAL_STOCK>
    </cffunction>
    <cffunction name="PRODUCT_TOTAL_STOCK" access="remote" returntype="any">
        <cfargument name="xml_use_other_dept_info_ss" type="string" required="yes">
        <cfargument name="product_id_list" type="string" required="yes">
        <cfquery name="PRODUCT_TOTAL_STOCK" datasource="#DSN2#">
            SELECT 
            SUM(PRODUCT_STOCK) AS PRODUCT_TOTAL_STOCK,
            PRODUCT_ID
        FROM
            GET_STOCK_LOCATION_TOTAL
        WHERE
            
            STORE = <cfqueryparam cfsqltype="cf_sql_integer" value="#listfirst(arguments.xml_use_other_dept_info_ss,'-')#">  AND
            STORE_LOCATION = <cfqueryparam cfsqltype="cf_sql_integer" value="#listlast(arguments.xml_use_other_dept_info_ss,'-')#">  AND
            PRODUCT_ID IN (#arguments.product_id_list#)
        GROUP BY
            
            PRODUCT_ID
        </cfquery>
        <cfreturn PRODUCT_TOTAL_STOCK>
    </cffunction>
    <cffunction name="GET_PROD_RESERVED_" access="remote" returntype="any">
        <cfargument name="xml_use_other_dept_info_ss" type="string" required="yes">
        <cfargument name="product_id_list" type="string" required="yes">
        <cfquery name="GET_PROD_RESERVED_" datasource="#DSN3#"><!--- üretim emrinden gelen stok rezerv --->
            SELECT
                SUM(STOCK_AZALT) AS AZALAN,
                SUM(STOCK_ARTIR) AS ARTAN
            FROM
                GET_PRODUCTION_RESERVED_LOCATION
            WHERE
                PRODUCT_ID IN (#arguments.product_id_list#)
                AND DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listfirst(arguments.xml_use_other_dept_info_ss,'-')#"> 
                AND LOCATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listlast(arguments.xml_use_other_dept_info_ss,'-')#"> 
        </cfquery>
        <cfreturn GET_PROD_RESERVED_>
    </cffunction>
    <cffunction name="LOCATION_BASED_TOTAL_STOCK" access="remote" returntype="any">
        <cfargument name="xml_use_other_dept_info_ss" type="string" required="yes">
        <cfargument name="product_id_list" type="string" required="yes">
        <cfquery name="LOCATION_BASED_TOTAL_STOCK" datasource="#DSN2#">
            SELECT
                SUM(STOCK_IN - SR.STOCK_OUT) AS TOTAL_LOCATION_STOCK
            FROM
                STOCKS_ROW SR,
                #dsn_alias#.STOCKS_LOCATION SL 
            WHERE
                
                    SR.PRODUCT_ID  IN (#arguments.product_id_list#)
                AND
                SR.STORE = SL.DEPARTMENT_ID AND
                SR.STORE_LOCATION = SL.LOCATION_ID AND
                NO_SALE = 1
                AND SR.STORE = <cfqueryparam cfsqltype="cf_sql_integer" value="#listfirst(arguments.xml_use_other_dept_info_ss,'-')#"> 
                AND SR.STORE_LOCATION = <cfqueryparam cfsqltype="cf_sql_integer" value="#listlast(arguments.xml_use_other_dept_info_ss,'-')#"> 
        </cfquery>
        <cfreturn LOCATION_BASED_TOTAL_STOCK>
    </cffunction>
</cfcomponent>
