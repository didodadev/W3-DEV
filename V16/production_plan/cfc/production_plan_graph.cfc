<cfcomponent>

    <cfset dsn = application.systemParam.systemParam().dsn />
    <cfset dsn3 = "#dsn#_#session.ep.company_id#" />
    <cfset queryJsonConverter = createObject("component","cfc.queryJSONConverter") />

    <!--- GET PROGRAM LIST --->
    <cffunction name="getProgramList" access="remote" returntype="any" output="no">
        
		<cfquery name="get_prog_list" datasource="#dsn#">
        	SELECT
            	SHIFT_NAME AS name,
                START_HOUR AS startHour,
                START_MIN AS startMin,
                END_HOUR AS endHour,
                END_MIN AS endMin
        	FROM
            	SETUP_SHIFTS
            WHERE 
            	IS_PRODUCTION = 1 AND FINISHDATE > #now()#
        </cfquery>
        
        <cfreturn get_prog_list>
	
    </cffunction>
    

    <!--- GET PRODUCT CATEGORY LIST --->
    <cffunction name="getProductCategoryList" access="remote" returntype="any" output="no">
    
    	<cfquery name="get_product_category_list" datasource="#dsn3#">
            SELECT PRODUCT_CATID AS id, PRODUCT_CAT AS name FROM PRODUCT_CAT ORDER BY name
        </cfquery>
        
        <cfreturn get_product_category_list>
    </cffunction>
    
    <!--- GET STATION LIST --->
    <cffunction name="getStationList" access="remote" returntype="query" output="no">
        <cfargument name="department_id" type="numeric" required="yes">
    
    	<cfquery name="get_station_list" datasource="#dsn3#">
            SELECT
            	STATION_ID AS id,
                STATION_NAME AS name
			FROM
            	WORKSTATIONS
			WHERE
                DEPARTMENT = <cfqueryparam value = "#arguments.department_id#" CFSQLType = "cf_sql_integer">
                AND UP_STATION IS NULL
        </cfquery>
        
        <cfreturn get_station_list>
    </cffunction>
    
    <!--- GET SUB STATION LIST --->
    <cffunction name="getSubStationList" access="remote" returntype="query" output="no">
        <cfargument name="department_id" type="numeric" required="yes">
        <cfargument name="station_id" type="numeric" required="yes">
    
    	<cfquery name="get_station_list" datasource="#dsn3#">
            SELECT
            	STATION_ID AS id,
                STATION_NAME AS name
			FROM
            	WORKSTATIONS
			WHERE
            	DEPARTMENT = <cfqueryparam value = "#arguments.department_id#" CFSQLType = "cf_sql_integer">
		        AND UP_STATION = <cfqueryparam value = "#arguments.station_id#" CFSQLType = "cf_sql_integer">
        </cfquery>
        
        <cfreturn get_station_list>
    </cffunction>
    
    <!--- GET PRODUCTION ORDERS --->
    <cffunction name="getProductionOrders" access="remote" returntype="struct" output="no">
        <cfargument name="employee_id" type="any" required="no">
        <cfargument name="branch_id" type="string" required="no">
        <cfargument name="department_id" type="string" required="no">
        <cfargument name="station_id" type="string" required="no">
        <cfargument name="start_date" type="date" required="no">
        <cfargument name="finish_date" type="date" required="no">
        <cfargument name="keyword" type="string" required="no">
        <cfargument name="product_category_id" type="any" required="no">
        <cfargument name="consumer_id" type="any" required="no">
        <cfargument name="is_consumer_company" type="any" required="no">
        <cfargument name="status" type="any" default="" required="no">
        <cfargument name="p_order_id" type="numeric" required="no">
        <cfargument name="startrow" type="any" default="1" required="no">
        <cfargument name="maxrows" type="any" default="1" required="no">
        <cfargument name="view_type" type="any" default="" required="no">
        
        <cfset getWorkStationControl.WORKSTATION_VIEW_CONTROL = 0>

        <cfquery name = "get_product_orders" datasource = "#dsn3#">
            SELECT 
                PRODUCTION_ORDERS.ORDER_ID,
                ORDERS.ORDER_HEAD,
                ORDERS.ORDER_NUMBER
            FROM PRODUCTION_ORDERS
            JOIN ORDERS ON PRODUCTION_ORDERS.ORDER_ID = ORDERS.ORDER_ID
            WHERE 
                PRODUCTION_ORDERS.ORDER_ID IS NOT NULL
                <cfif isdefined("arguments.start_date") and len(arguments.start_date)>AND PRODUCTION_ORDERS.START_DATE >= <cfqueryparam value = "#arguments.start_date#" CFSQLType = "cf_sql_timestamp"></cfif>
                <cfif isdefined("arguments.finish_date") and len(arguments.finish_date)>AND PRODUCTION_ORDERS.FINISH_DATE <= <cfqueryparam value = "#arguments.finish_date#" CFSQLType = "cf_sql_timestamp"></cfif>
                <cfif isdefined("arguments.status") and len(arguments.status)>
                    AND PRODUCTION_ORDERS.STATUS = <cfqueryparam value = "#arguments.status#" CFSQLType = "cf_sql_integer">
                </cfif>
        </cfquery>
        
        <cfquery name="get_orders" datasource="#dsn3#">
            WITH CTE1 AS(
                SELECT 
                    DISTINCT
                        STOCKS.PRODUCT_ID AS productID,
                        STOCKS.PRODUCT_NAME AS product,
                        STOCKS.PRODUCT_CATID AS productCatID,
                        (CASE WHEN ORDERS.CONSUMER_ID IS NULL THEN COMPANY.FULLNAME ELSE CONSUMER.CONSUMER_NAME + ' ' + CONSUMER.CONSUMER_SURNAME END)AS consumer,
                        PRODUCTION_ORDERS.STOCK_ID AS stockID,
                        PRODUCTION_ORDERS.IS_STAGE AS phase,
                        PRODUCTION_ORDERS.P_ORDER_ID AS id,
                        PRODUCTION_ORDERS.SPEC_MAIN_ID AS specMainID,
                        PRODUCTION_ORDERS.SPECT_VAR_ID AS specVarID,
                        PRODUCTION_ORDERS.QUANTITY AS quantity,
                        PRODUCTION_ORDERS.DETAIL AS description,
                        PRODUCTION_ORDERS.START_DATE AS startDate,
                        PRODUCTION_ORDERS.FINISH_DATE AS finishDate,
                        PRODUCTION_ORDERS.STATION_ID AS stationID,
                        WORKSTATIONS.STATION_NAME AS stationName,
                        PRODUCTION_ORDERS.P_ORDER_NO AS productionNo,
                        PRODUCTION_ORDERS.STATUS AS isActive,
                        PRODUCTION_ORDERS.PROJECT_ID AS projectID,
                        PRO_PROJECTS.PROJECT_HEAD AS projectName,
                        ORDERS.ORDER_NUMBER AS orderNo,
                        ORDERS.ORDER_HEAD AS orderHead,
                        ORDERS.DELIVERDATE AS terminDate,
                        ORDER_ROW.UNIT AS orderUnit,
                        PRODUCTION_ORDERS.PO_RELATED_ID AS relatedOrder,
                        0 AS isLastRelatedOrder,
                        PRODUCT_CAT.PRODUCT_CAT AS productCat,
                        PRODUCTION_ORDERS.ORDER_ID AS orderID,
                        PRODUCTION_ORDERS.ORDER_ROW_ID AS orderRowID
                    FROM	
                        PRODUCTION_ORDERS
                        LEFT JOIN #dsn#.PRO_PROJECTS ON PRO_PROJECTS.PROJECT_ID = PRODUCTION_ORDERS.PROJECT_ID,
                        PRODUCTION_ORDERS_ROW,
                        ORDERS
                        LEFT JOIN #dsn#.COMPANY ON COMPANY.COMPANY_ID = ORDERS.COMPANY_ID
                        LEFT JOIN #dsn#.CONSUMER ON CONSUMER.CONSUMER_ID = ORDERS.CONSUMER_ID,
                        ORDER_ROW,
                        STOCKS
                        LEFT JOIN PRODUCT_CAT ON STOCKS.PRODUCT_CATID = PRODUCT_CAT.PRODUCT_CATID,
                        WORKSTATIONS
                    WHERE
                        PRODUCTION_ORDERS.P_ORDER_ID = PRODUCTION_ORDERS_ROW.PRODUCTION_ORDER_ID AND
                        PRODUCTION_ORDERS.ORDER_ROW_ID = ORDER_ROW.ORDER_ROW_ID AND
                        PRODUCTION_ORDERS_ROW.ORDER_ID = ORDERS.ORDER_ID AND
                        PRODUCTION_ORDERS.STOCK_ID = STOCKS.STOCK_ID AND
                        PRODUCTION_ORDERS.STATION_ID = WORKSTATIONS.STATION_ID
                        <cfif isdefined("arguments.status") and len(arguments.status)>
                            AND PRODUCTION_ORDERS.STATUS = <cfqueryparam value = "#arguments.status#" CFSQLType = "cf_sql_integer">
                        </cfif>
                        <cfif isdefined("arguments.start_date") and len(arguments.start_date)>AND PRODUCTION_ORDERS.START_DATE >= <cfqueryparam value = "#arguments.start_date#" CFSQLType = "cf_sql_timestamp"></cfif>
                        <cfif isdefined("arguments.finish_date") and len(arguments.finish_date)>AND PRODUCTION_ORDERS.FINISH_DATE <= <cfqueryparam value = "#arguments.finish_date#" CFSQLType = "cf_sql_timestamp"></cfif>
                        <cfif isdefined("arguments.p_order_id") and len(arguments.p_order_id)>AND PRODUCTION_ORDERS.P_ORDER_ID = <cfqueryparam value = "#arguments.p_order_id#" CFSQLType = "cf_sql_integer"></cfif>
                        <cfif isdefined("arguments.branch_id") and len(arguments.branch_id)>AND WORKSTATIONS.BRANCH = <cfqueryparam value = "#arguments.branch_id#" CFSQLType = "cf_sql_integer"></cfif>
                        <cfif isdefined("arguments.department_id") and len(arguments.department_id)>AND WORKSTATIONS.DEPARTMENT = <cfqueryparam value = "#arguments.department_id#" CFSQLType = "cf_sql_integer"></cfif>
                        <cfif isdefined("arguments.station_id") and len(arguments.station_id)>AND (WORKSTATIONS.UP_STATION = <cfqueryparam value = "#arguments.station_id#" CFSQLType = "cf_sql_integer"> OR WORKSTATIONS.STATION_ID = <cfqueryparam value = "#arguments.station_id#" CFSQLType = "cf_sql_integer">)</cfif>
                        <cfif isdefined("arguments.keyword") and len(arguments.keyword)> AND PRODUCTION_ORDERS.P_ORDER_NO LIKE <cfqueryparam value = "%#arguments.keyword#%" CFSQLType = "cf_sql_nvarchar"></cfif>
                        <cfif isdefined("arguments.product_category_id") and len(arguments.product_category_id)> AND STOCKS.PRODUCT_CATID = <cfqueryparam value = "#arguments.product_category_id#" CFSQLType = "cf_sql_integer"></cfif>
                        <cfif isdefined("arguments.view_type") and len(arguments.view_type)>
                            <cfif arguments.view_type eq 2> <!--- Siparişe göre arama yapıldığında --->
                                AND PRODUCTION_ORDERS.ORDER_ID IS NOT NULL
                            <cfelseif arguments.view_type eq 3> <!--- Ürüne göre arama yapıldığında --->
                                AND PRODUCTION_ORDERS.STOCK_ID IS NOT NULL
                            <cfelseif arguments.view_type eq 4> <!--- İstasyona göre arama yapıldığında --->
                                AND PRODUCTION_ORDERS.STATION_ID IS NOT NULL
                            </cfif>
                        </cfif>
                        <cfif isdefined("arguments.consumer_id") and len(arguments.consumer_id) and isdefined("arguments.is_consumer_company") and arguments.is_consumer_company is 1> 
                            AND (ORDERS.COMPANY_ID IS NOT NULL AND ORDERS.COMPANY_ID = <cfqueryparam value = "#arguments.consumer_id#" CFSQLType = "cf_sql_integer">)
                        <cfelseif isdefined("arguments.consumer_id") and len(arguments.consumer_id)>
                            AND (ORDERS.CONSUMER_ID IS NOT NULL AND ORDERS.CONSUMER_ID = <cfqueryparam value = "#arguments.consumer_id#" CFSQLType = "cf_sql_integer">)
                        </cfif>
                        <cfif isdefined("arguments.employee_id") and getWorkStationControl.WORKSTATION_VIEW_CONTROL eq 1>
                            AND WORKSTATIONS.EMP_ID LIKE <cfqueryparam value = "%,#arguments.employee_id#,%" CFSQLType = "cf_sql_integer">
                        </cfif>
                
                <cfif not (IsDefined("arguments.consumer_id") and len(arguments.consumer_id))> 
                    UNION ALL
                    SELECT 
                        DISTINCT
                            STOCKS.PRODUCT_ID AS productID,
                            STOCKS.PRODUCT_NAME AS product,
                            STOCKS.PRODUCT_CATID AS productCatID,
                            NULL AS consumer,
                            PRODUCTION_ORDERS.STOCK_ID AS stockID,
                            PRODUCTION_ORDERS.IS_STAGE AS phase,
                            PRODUCTION_ORDERS.P_ORDER_ID AS id,
                            PRODUCTION_ORDERS.SPEC_MAIN_ID AS specMainID,
                            PRODUCTION_ORDERS.SPECT_VAR_ID AS specVarID,
                            PRODUCTION_ORDERS.QUANTITY AS quantity,
                            PRODUCTION_ORDERS.DETAIL AS description,
                            PRODUCTION_ORDERS.START_DATE AS startDate,
                            PRODUCTION_ORDERS.FINISH_DATE AS finishDate,
                            PRODUCTION_ORDERS.STATION_ID AS stationID,
                            WORKSTATIONS.STATION_NAME AS stationName,
                            PRODUCTION_ORDERS.P_ORDER_NO AS productionNo,
                            PRODUCTION_ORDERS.STATUS AS isActive,
                            PRODUCTION_ORDERS.PROJECT_ID AS projectID,
                            PRO_PROJECTS.PROJECT_HEAD AS projectName,
                            '' AS orderNo,
                            '' AS orderHead,
                            '' AS terminDate,
                            '' AS orderUnit,
                            PRODUCTION_ORDERS.PO_RELATED_ID AS relatedOrder,
                            0 AS isLastRelatedOrder,
                            PRODUCT_CAT.PRODUCT_CAT AS productCat,
                            PRODUCTION_ORDERS.ORDER_ID AS orderID,
                            PRODUCTION_ORDERS.ORDER_ROW_ID AS orderRowID
                        FROM	
                            PRODUCTION_ORDERS
                            LEFT JOIN #dsn#.PRO_PROJECTS ON PRO_PROJECTS.PROJECT_ID = PRODUCTION_ORDERS.PROJECT_ID,
                            STOCKS
                            LEFT JOIN PRODUCT_CAT ON STOCKS.PRODUCT_CATID = PRODUCT_CAT.PRODUCT_CATID,
                            WORKSTATIONS
                        WHERE
                            PRODUCTION_ORDERS.STOCK_ID = STOCKS.STOCK_ID AND
                            PRODUCTION_ORDERS.P_ORDER_ID NOT IN(SELECT PRODUCTION_ORDERS_ROW.PRODUCTION_ORDER_ID FROM PRODUCTION_ORDERS_ROW WHERE PRODUCTION_ORDERS_ROW.PRODUCTION_ORDER_ID = PRODUCTION_ORDERS.P_ORDER_ID) AND
                            PRODUCTION_ORDERS.STATION_ID = WORKSTATIONS.STATION_ID
                            <cfif isdefined("arguments.status") and len(arguments.status)>
                                AND PRODUCTION_ORDERS.STATUS = <cfqueryparam value = "#arguments.status#" CFSQLType = "cf_sql_integer">
                            </cfif>
                            <cfif isdefined("arguments.start_date") and len(arguments.start_date)>AND PRODUCTION_ORDERS.START_DATE >= <cfqueryparam value = "#arguments.start_date#" CFSQLType = "cf_sql_timestamp"></cfif>
                            <cfif isdefined("arguments.finish_date") and len(arguments.finish_date)>AND PRODUCTION_ORDERS.FINISH_DATE <= <cfqueryparam value = "#arguments.finish_date#" CFSQLType = "cf_sql_timestamp"></cfif>
                            <cfif isdefined("arguments.p_order_id") and len(arguments.p_order_id)>AND PRODUCTION_ORDERS.P_ORDER_ID = <cfqueryparam value = "#arguments.p_order_id#" CFSQLType = "cf_sql_integer"></cfif>
                            <cfif isdefined("arguments.branch_id") and len(arguments.branch_id)>AND WORKSTATIONS.BRANCH = #arguments.branch_id# </cfif>
                            <cfif isdefined("arguments.department_id") and len(arguments.department_id)>AND WORKSTATIONS.DEPARTMENT = #arguments.department_id# </cfif>
                            <cfif isdefined("arguments.station_id") and len(arguments.station_id)>AND (WORKSTATIONS.UP_STATION = #arguments.station_id# OR WORKSTATIONS.STATION_ID = #arguments.station_id#)</cfif>
                            <cfif isdefined("arguments.keyword") and len(arguments.keyword)> AND PRODUCTION_ORDERS.P_ORDER_NO LIKE '%#arguments.keyword#%'</cfif>
                            <cfif isdefined("arguments.product_category_id") and len(arguments.product_category_id)> AND STOCKS.PRODUCT_CATID = #arguments.product_category_id#</cfif>
                            <cfif isdefined("arguments.view_type") and len(arguments.view_type)>
                                <cfif arguments.view_type eq 2> <!--- Siparişe göre arama yapıldığında --->
                                    AND PRODUCTION_ORDERS.ORDER_ID IS NOT NULL
                                <cfelseif arguments.view_type eq 3> <!--- Ürüne göre arama yapıldığında --->
                                    AND PRODUCTION_ORDERS.STOCK_ID IS NOT NULL
                                <cfelseif arguments.view_type eq 4> <!--- İstasyona göre arama yapıldığında --->
                                    AND PRODUCTION_ORDERS.STATION_ID IS NOT NULL
                                </cfif>
                            </cfif>
                            <cfif isdefined("arguments.employee_id") and getWorkStationControl.WORKSTATION_VIEW_CONTROL eq 1>
                                AND WORKSTATIONS.EMP_ID LIKE '%,#arguments.employee_id#,%'
                            </cfif>
                </cfif>
            ),
            CTE2 AS (
                SELECT
                    CTE1.*,
                    ROW_NUMBER() OVER (	 
                        ORDER BY product
                    ) AS RowNum,
                    (SELECT COUNT(*) FROM CTE1) AS QUERY_COUNT
                FROM
                    CTE1
            )
            SELECT
                CTE2.*
            FROM
                CTE2
            WHERE
                RowNum BETWEEN #arguments.startrow# and #arguments.startrow# + (#arguments.maxrows#-1)
        </cfquery>
        
        <cfset result = StructNew()>
        
        <cfif isdefined("arguments.view_type") and len(arguments.view_type)>
            <cfif arguments.view_type eq 2> <!--- Siparişe göre arama yapıldığında --->
                <cfset result["product_orders"] = get_product_orders>
            <cfelseif arguments.view_type eq 3> <!--- Ürüne göre arama yapıldığında --->
                
                <cfquery name = "get_products" datasource = "#dsn3#">
                    SELECT
                        DISTINCT
                            PRODUCTION_ORDERS.STOCK_ID,
                            STOCKS.PRODUCT_NAME,
                            STOCKS.PRODUCT_CODE
                    FROM
                        PRODUCTION_ORDERS
                        JOIN STOCKS ON PRODUCTION_ORDERS.STOCK_ID = STOCKS.STOCK_ID
                    WHERE
                        <cfif get_orders.recordcount>
                            PRODUCTION_ORDERS.STOCK_ID IN( #listRemoveDuplicates( valuelist( get_orders.stockID ) )# )
                        <cfelse>
                            PRODUCTION_ORDERS.STOCK_ID IS NOT NULL
                            <cfif isdefined("arguments.start_date") and len(arguments.start_date)>AND PRODUCTION_ORDERS.START_DATE >= <cfqueryparam value = "#arguments.start_date#" CFSQLType = "cf_sql_timestamp"></cfif>
                            <cfif isdefined("arguments.finish_date") and len(arguments.finish_date)>AND PRODUCTION_ORDERS.FINISH_DATE <= <cfqueryparam value = "#arguments.finish_date#" CFSQLType = "cf_sql_timestamp"></cfif>
                        </cfif>
                        <cfif isdefined("arguments.status") and len(arguments.status)>
                            AND PRODUCTION_ORDERS.STATUS = <cfqueryparam value = "#arguments.status#" CFSQLType = "cf_sql_integer">
                        </cfif>
                </cfquery>
                
                <cfset result["products"] = get_products>
            <cfelseif arguments.view_type eq 4> <!--- İstasyona göre arama yapıldığında --->
                
                <cfquery name="get_workstations" datasource="#dsn3#">
                    SELECT 
                        DISTINCT
                            PRODUCTION_ORDERS.STATION_ID,
                            WORKSTATIONS.STATION_NAME
                    FROM PRODUCTION_ORDERS
                    RIGHT JOIN WORKSTATIONS ON PRODUCTION_ORDERS.STATION_ID = WORKSTATIONS.STATION_ID
                    WHERE
                        <cfif get_orders.recordcount>
                            PRODUCTION_ORDERS.STATION_ID IN( #listRemoveDuplicates( valuelist( get_orders.stationId ) )# )
                        <cfelse>
                            PRODUCTION_ORDERS.STATION_ID IS NOT NULL
                            <cfif isdefined("arguments.start_date") and len(arguments.start_date)>AND PRODUCTION_ORDERS.START_DATE >= <cfqueryparam value = "#arguments.start_date#" CFSQLType = "cf_sql_timestamp"></cfif>
                            <cfif isdefined("arguments.finish_date") and len(arguments.finish_date)>AND PRODUCTION_ORDERS.FINISH_DATE <= <cfqueryparam value = "#arguments.finish_date#" CFSQLType = "cf_sql_timestamp"></cfif>
                        </cfif>
                        <cfif isdefined("arguments.status") and len(arguments.status)>
                            AND PRODUCTION_ORDERS.STATUS = <cfqueryparam value = "#arguments.status#" CFSQLType = "cf_sql_integer">
                        </cfif>
                        <cfif isdefined("arguments.employee_id") and len(arguments.employee_id)>
                            AND WORKSTATIONS.EMP_ID LIKE '%,#arguments.employee_id#,%'
                        </cfif>
                        <cfif isdefined("arguments.branch_id") and len(arguments.branch_id)>AND WORKSTATIONS.BRANCH = <cfqueryparam value = "#arguments.branch_id#" CFSQLType = "cf_sql_integer"></cfif>
                        <cfif isdefined("arguments.department_id") and len(arguments.department_id)>AND WORKSTATIONS.DEPARTMENT = <cfqueryparam value = "#arguments.department_id#" CFSQLType = "cf_sql_integer"></cfif>
                        <cfif isdefined("arguments.station_id") and len(arguments.station_id)>AND (WORKSTATIONS.UP_STATION = <cfqueryparam value = "#arguments.station_id#" CFSQLType = "cf_sql_integer"> OR WORKSTATIONS.STATION_ID = <cfqueryparam value = "#arguments.station_id#" CFSQLType = "cf_sql_integer">)</cfif>
                    ORDER BY
                        WORKSTATIONS.STATION_NAME
                </cfquery>

                <cfset result["workstations"] = get_workstations>
            </cfif>
        </cfif>

        <cfset result["orders"] = get_orders>
        
        <cfreturn result>
	</cffunction>
    
    <cffunction name = "getProductionOrderById" access = "remote" returnFormat = "JSON">
        <cfargument name="p_order_id" type="numeric" required="yes">
        <cfreturn LCase(Replace(SerializeJson( queryJsonConverter.returnData( SerializeJson( this.getProductionOrders( p_order_id : arguments.p_order_id ).orders ) ) ), "//", "" )) />
    </cffunction>

    <!--- UPDATE ORDER --->
    <cffunction name="updateProductionOrder" access="remote">
        <cfargument name="p_order_id" type="numeric" required="yes">
        <cfargument name="start_date" type="string" required="yes">
        <cfargument name="finish_date" type="string" required="yes">
        
        <cfquery name="update_order" datasource="#dsn3#">
            UPDATE
                PRODUCTION_ORDERS
            SET
                START_DATE = <cfqueryparam value = "#arguments.start_date#" CFSQLType = "cf_sql_timestamp">,
                FINISH_DATE = <cfqueryparam value = "#arguments.finish_date#" CFSQLType = "cf_sql_timestamp">,
                UPDATE_DATE = #now()#,
                UPDATE_EMP = #session.ep.userid#,
                UPDATE_IP = '#cgi.REMOTE_ADDR#'
            WHERE
                P_ORDER_ID = <cfqueryparam value = "#p_order_id#" CFSQLType = "cf_sql_integer">
        </cfquery>
        
        <cfreturn true>
    </cffunction>

    <cffunction name="updateProductionOrderLot" access="remote">
        <cfargument name="START_DATE_REAL" required="yes" default="">
        <cfargument name="start_h" required="yes" default="">
        <cfargument name="start_m" required="yes" default="">

        <cfscript>
            arguments.START_DATE_REAL = DateAdd('h',arguments.start_h, arguments.START_DATE_REAL);
            arguments.START_DATE_REAL = DateAdd('n',arguments.start_m, arguments.START_DATE_REAL);
        </cfscript>
        
        <cfquery name="updateProductionOrderLot" datasource="#dsn3#">
            UPDATE
            PRODUCTION_ORDERS
            SET
                START_DATE_REAL = <cfqueryparam value = "#DateFormat(arguments.START_DATE_REAL,'dd-mm-yyyy')#" CFSQLType = "cf_sql_timestamp">,
                IS_STAGE=1,
                START_EMP_ID=<cfqueryparam value = "#session.ep.userid#" CFSQLType = "cf_sql_integer">,
                UPDATE_DATE= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,   
                UPDATE_EMP = #session.ep.userid#,
                UPDATE_IP = '#cgi.REMOTE_ADDR#'
            WHERE
                P_ORDER_ID = <cfqueryparam value = "#p_order_id#" CFSQLType = "cf_sql_integer">
        </cfquery>
    </cffunction>
    <cffunction name="updateProductionOrderStop" access="remote">
        <cfargument name="FINISH_DATE_REAL" required="yes" default="">
        <cfargument name="finish_h" required="yes" default="">
        <cfargument name="finish_m" required="yes" default="">
        <cfargument name="PROD_PAUSE_TYPE_ID" required="yes" default="">
        <cfargument name="PROD_PAUSE_ID" required="yes" default="">
        <cfargument name="PR_ORDER_ID" required="yes" default="">

        <cfscript>
            arguments.FINISH_DATE_REAL = DateAdd('h',arguments.finish_h, arguments.FINISH_DATE_REAL);
            arguments.FINISH_DATE_REAL = DateAdd('n',arguments.finish_m, arguments.FINISH_DATE_REAL);
        </cfscript>
        
        <cfquery name="updateProductionOrderStop" datasource="#dsn3#">
            UPDATE
            PRODUCTION_ORDERS
            SET
                FINISH_DATE_REAL = <cfqueryparam value = "#arguments.FINISH_DATE_REAL#" CFSQLType = "cf_sql_timestamp">,
                IS_STAGE=3,
                UPDATE_DATE= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,   
                FINISH_EMP_ID=<cfqueryparam value = "#session.ep.userid#" CFSQLType = "cf_sql_integer">,
                UPDATE_EMP =  <cfqueryparam value = "#session.ep.userid#" CFSQLType = "cf_sql_integer">,
                UPDATE_IP = '#cgi.REMOTE_ADDR#'
            WHERE
                P_ORDER_ID = <cfqueryparam value = "#p_order_id#" CFSQLType = "cf_sql_integer">
        </cfquery>
     

       <cfif not len(arguments.PROD_PAUSE_ID)>
            <cfquery name="addProduction" datasource="#dsn3#">
                 INSERT INTO 
                 SETUP_PROD_PAUSE
                    (
                    PROD_PAUSE_TYPE_ID
                    ,EMPLOYEE_ID
                    ,P_ORDER_ID
                    ,RECORD_DATE
                    ,RECORD_EMP
                    ,RECORD_IP
                    ,PR_ORDER_ID
                    
                    ) 
                VALUES 
                (
                    <cfqueryparam value = "#arguments.PROD_PAUSE_TYPE_ID#" CFSQLType = "cf_sql_integer">,
                    <cfqueryparam value = "#session.ep.userid#" CFSQLType = "cf_sql_integer">,
                    <cfqueryparam value = "#arguments.p_order_id#" CFSQLType = "cf_sql_integer">,
                    <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,  
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
                    <cfif isdefined("arguments.PR_ORDER_ID") and len(arguments.PR_ORDER_ID)><cfqueryparam value = "#arguments.pr_order_id#" CFSQLType = "cf_sql_integer"><cfelse>NULL</cfif>
                    
                )
               
            </cfquery>
        <cfelseif len(arguments.PROD_PAUSE_ID)>
            <cfquery name="updateProductionresult" datasource="#dsn3#">
                UPDATE
                SETUP_PROD_PAUSE
                SET
                    PROD_PAUSE_TYPE_ID=<cfqueryparam value = "#arguments.PROD_PAUSE_TYPE_ID#" CFSQLType = "cf_sql_integer">,
                    EMPLOYEE_ID=<cfqueryparam value = "#session.ep.userid#" CFSQLType = "cf_sql_integer">,
                    P_ORDER_ID=<cfqueryparam value = "#arguments.p_order_id#" CFSQLType = "cf_sql_integer">,
                    UPDATE_DATE= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,    
                    UPDATE_EMP= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                    UPDATE_IP=<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
                    PR_ORDER_ID=<cfif isdefined("arguments.PR_ORDER_ID") and len(arguments.PR_ORDER_ID)><cfqueryparam value = "#arguments.pr_order_id#" CFSQLType = "cf_sql_integer"><cfelse>NULL</cfif>
                
                WHERE
                PROD_PAUSE_ID = <cfqueryparam value = "#arguments.PROD_PAUSE_ID#" CFSQLType = "cf_sql_integer">
            </cfquery>
            
        </cfif>
    </cffunction>
    <cffunction name="updateProductionResult" access="remote">
        <cfquery name="updateProductionResult" datasource="#dsn3#">
            UPDATE
                PRODUCTION_ORDERS
            SET
                IS_STAGE = 2,
                UPDATE_DATE= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,    
                UPDATE_EMP= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                UPDATE_IP=<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
            WHERE
                P_ORDER_ID = <cfqueryparam value = "#p_order_id#" CFSQLType = "cf_sql_integer">
        </cfquery>
        
        </cffunction>
        <cffunction name="updateProductionControl" access="remote">
            <cfquery name="updateProductionControl" datasource="#dsn3#">
                UPDATE
                    PRODUCTION_ORDERS
                SET
                    IS_STAGE = 6,
                    UPDATE_DATE= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,    
                    UPDATE_EMP= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                    UPDATE_IP=<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
                    IS_CONTROL_DATE=<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,  
                    IS_CONTROL_EMP=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
                WHERE
                    P_ORDER_ID = <cfqueryparam value = "#p_order_id#" CFSQLType = "cf_sql_integer">
            </cfquery>
            
            </cffunction>
            <cffunction name="updateProductionRejection" access="remote">
                <cfquery name="updateProductionRejection" datasource="#dsn3#">
                    UPDATE
                        PRODUCTION_ORDERS
                    SET
                        IS_STAGE = 5,
                        UPDATE_DATE= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,    
                        UPDATE_EMP= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                        UPDATE_IP=<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
                        IS_CONTROL_DATE=<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,  
                        IS_CONTROL_EMP=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
                    WHERE
                        P_ORDER_ID = <cfqueryparam value = "#p_order_id#" CFSQLType = "cf_sql_integer">
                </cfquery>
                
                </cffunction>
</cfcomponent>