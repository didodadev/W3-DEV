<cfcomponent>
    <cfset dsn = application.systemParam.systemParam().dsn>
    <cfset dsn3= "#dsn#_#session.ep.company_id#">
    <cfset dsn_alias= '#dsn#'>

    <cffunction name="get_prod_result_quality" access="remote" returntype="query">
        <cfargument name="branch" default="">
        <cfargument name="warehouse" default="">
        <cfargument name="station" default="">
        <cfargument name="start_date" default="">
        <cfargument name="finish_date" default="">
        <cfargument name="stock_id" default="">
        <cfargument name="product_name" default="">

        <cfquery name="get_prod_result_quality" datasource="#dsn3#">
            SELECT
                *
            FROM
            (
                SELECT
                    ORQ.OR_Q_ID,
                    ORQ.SUCCESS_ID,
                    ORQ.Q_CONTROL_NO,
                    SUM(ISNULL(ORQ.CONTROL_AMOUNT,0)) AS CONTROL_AMOUNT,
                    TABLE1.AMOUNT QUANTITY,
                    TABLE1.LOT_NO,
                    TABLE1.STOCK_ID,
                    TABLE1.LOCATION_IN,
                    TABLE1.DEPARTMENT_IN,
                    TABLE1.LOCATION_OUT,
                    TABLE1.DEPARTMENT_OUT,
                    TABLE1.P_ORDER_ID PROCESS_ID,
                    TABLE1.RESULT_NO PROCESS_NUMBER,
                    TABLE1.FINISH_DATE PROCESS_DATE,
                    TABLE1.STATION_NAME STATION_NAME,
                    171 PROCESS_CAT,
                    TABLE1.PR_ORDER_ROW_ID AS PROCESS_ROW_ID,
                    TABLE1.WRK_ROW_ID SHIP_WRK_ROW_ID,
                    TABLE1.PR_ORDER_ROW_ID PR_ORDER_ROW_ID,
                    TABLE1.PR_ORDER_ID AS PR_ORDER_ID
                FROM
                (
                    SELECT
                        PORR.STOCK_ID,
                        POR.P_ORDER_ID,
                        POR.PR_ORDER_ID,
                        PR_ORDER_ROW_ID,
                        RESULT_NO,
                        POR.FINISH_DATE,
                        PORR.AMOUNT,
                        POR.LOT_NO,
                        POR.STATION_ID STATION_NAME,
                        POR.ENTER_LOC_ID LOCATION_IN,
                        POR.ENTER_DEP_ID DEPARTMENT_IN,
                        POR.EXIT_LOC_ID LOCATION_OUT,
                        POR.EXIT_DEP_ID DEPARTMENT_OUT,
                        PORR.WRK_ROW_ID
                    FROM
                        PRODUCTION_ORDER_RESULTS POR,
                        PRODUCTION_ORDER_RESULTS_ROW PORR
                        LEFT JOIN STOCKS S ON S.STOCK_ID = PORR.STOCK_ID
                        LEFT JOIN PRODUCT ON PRODUCT.PRODUCT_ID = S.PRODUCT_ID
                        WHERE
                        S.IS_QUALITY = 1 AND
                        PORR.TYPE = 1
                        AND PORR.PR_ORDER_ID = POR.PR_ORDER_ID
                        AND POR.P_ORDER_ID NOT IN(SELECT P_ORDER_ID FROM PRODUCTION_ORDERS PO WHERE PO.IS_DEMONTAJ = 1)
                        AND (PRODUCT.QUALITY_START_DATE IS NULL OR PRODUCT.QUALITY_START_DATE <= POR.FINISH_DATE)
                        <cfif len(arguments.warehouse)>
                            AND (POR.ENTER_DEP_ID = <cfqueryparam value="#arguments.warehouse#" cfsqltype="cf_sql_integer"> OR POR.EXIT_DEP_ID = <cfqueryparam value="#arguments.warehouse#" cfsqltype="cf_sql_integer">)
                        </cfif>
                        <cfif len(arguments.station)>
                            AND POR.STATION_ID = <cfqueryparam value="#arguments.station#" cfsqltype="cf_sql_integer">
                        </cfif>
                        <cfif (not len(arguments.warehouse)) and (not len(arguments.station)) and len(arguments.branch)>
                            AND
                            (
                                POR.ENTER_DEP_ID IN (SELECT DEPARTMENT_ID FROM #dsn_alias#.DEPARTMENT WHERE BRANCH_ID = <cfqueryparam value="#arguments.branch#" cfsqltype="cf_sql_integer">)
                                OR POR.EXIT_DEP_ID IN (SELECT DEPARTMENT_ID FROM #dsn_alias#.DEPARTMENT WHERE BRANCH_ID = <cfqueryparam value="#arguments.branch#" cfsqltype="cf_sql_integer">)
                            )
                        </cfif>
                        <cfif len(arguments.start_date)>
							AND POR.START_DATE >= <cfqueryparam value="#arguments.start_date#" cfsqltype="cf_sql_timestamp">
						</cfif>
						<cfif len(arguments.finish_date)>
                            <cfset finish = DATEADD("d",1,arguments.finish_date)>
							AND POR.START_DATE <  <cfqueryparam value="#finish#" cfsqltype="cf_sql_timestamp">
						</cfif>
                        <cfif len(arguments.stock_id) and len(arguments.product_name)>
							AND PORR.STOCK_ID = #arguments.stock_id#
						</cfif>
                ) TABLE1

                LEFT JOIN ORDER_RESULT_QUALITY ORQ ON ORQ.PROCESS_ID = TABLE1.P_ORDER_ID AND ORQ.SHIP_WRK_ROW_ID = TABLE1.WRK_ROW_ID AND ORQ.PROCESS_CAT = 171<!--- Sadece Üretimden oluşanlar --->
                WHERE
                    1 = 1
                    AND ORQ.OR_Q_ID NOT IN (SELECT OR_Q_ID FROM ORDER_RESULT_QUALITY_ROW ORQR WHERE ORQR.OR_Q_ID = ORQ.OR_Q_ID AND IS_REPROCESS = 1) <!--- Yeniden Islemler Dikkate Alinmiyor --->
                GROUP BY
                    ORQ.SUCCESS_ID,
                    ORQ.OR_Q_ID,
                    ORQ.Q_CONTROL_NO,
                    TABLE1.AMOUNT,
                    TABLE1.STOCK_ID,
                    TABLE1.P_ORDER_ID,
                    TABLE1.PR_ORDER_ID,
                    TABLE1.STATION_NAME,
                    TABLE1.PR_ORDER_ROW_ID,
                    TABLE1.WRK_ROW_ID,
                    TABLE1.RESULT_NO,
                    TABLE1.FINISH_DATE,
                    TABLE1.LOCATION_IN,
                    TABLE1.DEPARTMENT_IN,
                    TABLE1.LOCATION_OUT,
                    TABLE1.DEPARTMENT_OUT,
                    TABLE1.LOT_NO
            ) AS NEW_TABLE
        </cfquery>  
        <cfreturn get_prod_result_quality/>
    </cffunction>

    <cffunction name="get_dep_detail" access="remote" returntype="query">
        <cfquery name="get_dep_detail" datasource="#DSN#" >
            SELECT DEPARTMENT_ID, DEPARTMENT_HEAD FROM DEPARTMENT WHERE DEPARTMENT_ID = <cfqueryparam value="#arguments.department_id#" cfsqltype="cf_sql_integer"> ORDER BY DEPARTMENT_ID
        </cfquery>
        <cfreturn get_dep_detail/>
    </cffunction>

    <cffunction name="get_stock_info" access="remote" returntype="query">
        <cfquery name="get_stock_info" datasource="#DSN3#">
            SELECT
                #dsn#.Get_Dynamic_Language(PRODUCT.PRODUCT_ID,'#session.ep.language#','PRODUCT','PRODUCT_NAME',NULL,NULL,PRODUCT.PRODUCT_NAME) AS PRODUCT_NAME,
                STOCKS.STOCK_CODE
            FROM
                PRODUCT,
                STOCKS 
            WHERE 
                STOCKS.PRODUCT_ID = PRODUCT.PRODUCT_ID AND
                STOCKS.STOCK_ID = <cfqueryparam value="#arguments.stock_id#" cfsqltype="cf_sql_integer">
            ORDER BY
                STOCKS.STOCK_ID
        </cfquery>
        <cfreturn get_stock_info/>
    </cffunction>

    <cffunction name="get_station" access="remote" returntype="query">
        <cfquery name="get_station" datasource="#DSN3#">
            SELECT
                W.STATION_NAME,
                W.STATION_ID
            FROM 
                WORKSTATIONS W
            WHERE
                W.STATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.station_id#">
            ORDER BY
                W.STATION_ID
        </cfquery>
        <cfreturn get_station/>
    </cffunction>

    <cffunction name="get_branch" access="remote" returntype="query">
        <cfquery name="get_branch" datasource="#dsn#">
            SELECT
                BRANCH_ID,BRANCH_NAME
            FROM
                BRANCH
            WHERE
                BRANCH_STATUS = 1
                AND COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
            <cfif session.ep.isBranchAuthorization>
                AND BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#) ORDER BY BRANCH_NAME
            </cfif>
            ORDER BY BRANCH_NAME
        </cfquery>
        <cfreturn get_branch/>
    </cffunction>


    <cffunction name="get_quality_success_by_stock" access="remote" returntype="query">
        <cfargument name="branch" default="">
        <cfargument name="warehouse" default="">
        <cfargument name="station" default="">
        <cfargument name="start_date" default="">
        <cfargument name="finish_date" default="">
        <cfargument name="stock_id" default="">
        <cfargument name="product_name" default="">
        <cfquery name="get_quality_success_by_stock" datasource="#dsn3#">
            SELECT
                SUM(ISNULL(PORR.AMOUNT,0)) AS TOTAL_AMOUNT,
                PORR.STOCK_ID
            FROM
                PRODUCTION_ORDER_RESULTS_ROW PORR

            LEFT JOIN PRODUCTION_ORDER_RESULTS POR ON PORR.PR_ORDER_ID = POR.PR_ORDER_ID
            LEFT JOIN ORDER_RESULT_QUALITY ORQ ON ORQ.PROCESS_ID = POR.P_ORDER_ID AND ORQ.SHIP_WRK_ROW_ID = PORR.WRK_ROW_ID AND ORQ.PROCESS_CAT = 171<!--- Sadece Üretimden oluşanlar --->
            LEFT JOIN STOCKS S ON S.STOCK_ID = PORR.STOCK_ID
            LEFT JOIN PRODUCT ON PRODUCT.PRODUCT_ID = S.PRODUCT_ID

            WHERE
                ORQ.OR_Q_ID NOT IN (SELECT OR_Q_ID FROM ORDER_RESULT_QUALITY_ROW ORQR WHERE ORQR.OR_Q_ID = ORQ.OR_Q_ID AND IS_REPROCESS = 1)
                AND S.IS_QUALITY = 1
                AND PORR.TYPE = 1
                AND POR.P_ORDER_ID NOT IN(SELECT P_ORDER_ID FROM PRODUCTION_ORDERS PO WHERE PO.IS_DEMONTAJ = 1)
                AND (PRODUCT.QUALITY_START_DATE IS NULL OR PRODUCT.QUALITY_START_DATE <= POR.FINISH_DATE)
                <cfif len(arguments.warehouse)>
                    AND (POR.ENTER_DEP_ID = <cfqueryparam value="#arguments.warehouse#" cfsqltype="cf_sql_integer"> OR POR.EXIT_DEP_ID = <cfqueryparam value="#arguments.warehouse#" cfsqltype="cf_sql_integer">)
                </cfif>
                <cfif len(arguments.station)>
                    AND POR.STATION_ID = <cfqueryparam value="#arguments.station#" cfsqltype="cf_sql_integer">
                </cfif>
                <cfif (not len(arguments.warehouse)) and (not len(arguments.station)) and len(arguments.branch)>
                    AND
                    (
                        POR.ENTER_DEP_ID IN (SELECT DEPARTMENT_ID FROM #dsn_alias#.DEPARTMENT WHERE BRANCH_ID = <cfqueryparam value="#arguments.branch#" cfsqltype="cf_sql_integer">)
                        OR POR.EXIT_DEP_ID IN (SELECT DEPARTMENT_ID FROM #dsn_alias#.DEPARTMENT WHERE BRANCH_ID = <cfqueryparam value="#arguments.branch#" cfsqltype="cf_sql_integer">)
                    )
                </cfif>
                <cfif len(arguments.start_date)>
                    AND POR.START_DATE >= <cfqueryparam value="#arguments.start_date#" cfsqltype="cf_sql_timestamp">
                </cfif>
                <cfif len(arguments.finish_date)>
                    <cfset finish = DATEADD("d",1,arguments.finish_date)>
                    AND POR.START_DATE <  <cfqueryparam value="#finish#" cfsqltype="cf_sql_timestamp">
                </cfif>
                <cfif len(arguments.stock_id) and len(arguments.product_name)>
                    AND PORR.STOCK_ID = #arguments.stock_id#
                </cfif>

            GROUP BY 
                PORR.STOCK_ID
               
            ORDER BY
                PORR.STOCK_ID
        </cfquery>
        <cfreturn get_quality_success_by_stock/>

    </cffunction>
</cfcomponent>