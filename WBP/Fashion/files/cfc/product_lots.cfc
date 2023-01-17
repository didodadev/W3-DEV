<cfcomponent hint="Ürün ID - Lot - Envanter Miktarı listeler">

    <cfset dsn = application.systemParam.systemParam().dsn>
	<cfset dsn3="#dsn#_#session.ep.company_id#">
    <cfset dsn2="#dsn#_#session.ep.period_year#_#session.ep.company_id#">

    <cffunction name="GetList" access="public" returntype="query">
        <cfargument name="product_id" default="">
        <cfargument name="lot" default="">

        <cfquery name="query_list" datasource="#dsn2#">
            SELECT 
            PRODUCT_ID ,
            LOT_NO,
            SUM(GIRIS-CIKIS) AS ENVANTER 
            FROM 
            (
            SELECT        (SR.STOCK_IN - SR.STOCK_OUT) AS TOTAL_STOCK, SR.PRODUCT_ID, SR.STOCK_ID, SR.STOCK_IN AS GIRIS, SR.STOCK_OUT AS CIKIS, SR.STORE, SR.STORE_LOCATION, SR.UPD_ID, SR.PROCESS_TYPE, 
                                    SR.PROCESS_DATE, S.RECORD_DATE AS RECORD_DATE, S.SHIP_DATE AS ACTION_DATE, S.SHIP_NUMBER AS ACTION_NUMBER, S.PROJECT_ID,SR.LOT_NO
            FROM            STOCKS_ROW SR, SHIP S
            WHERE        SR.UPD_ID = S.SHIP_ID AND SR.PROCESS_TYPE = S.SHIP_TYPE AND  SR.LOT_NO IS NOT NULL
            UNION ALL
            SELECT        (SR.STOCK_IN - SR.STOCK_OUT) AS TOTAL_STOCK, SR.PRODUCT_ID, SR.STOCK_ID, SR.STOCK_IN AS GIRIS, SR.STOCK_OUT AS CIKIS, SR.STORE, SR.STORE_LOCATION, SR.UPD_ID, SR.PROCESS_TYPE, 
                                    SR.PROCESS_DATE, SF.RECORD_DATE AS RECORD_DATE, SF.FIS_DATE AS ACTION_DATE, SF.FIS_NUMBER AS ACTION_NUMBER, SF.PROJECT_ID,SR.LOT_NO
            FROM            STOCKS_ROW SR, STOCK_FIS SF
            WHERE        SR.UPD_ID = SF.FIS_ID AND SR.PROCESS_TYPE = SF.FIS_TYPE AND  SR.LOT_NO IS NOT NULL
            UNION ALL
            SELECT        (SR.STOCK_IN - SR.STOCK_OUT) AS TOTAL_STOCK, SR.PRODUCT_ID, SR.STOCK_ID, SR.STOCK_IN AS GIRIS, SR.STOCK_OUT AS CIKIS, SR.STORE, SR.STORE_LOCATION, SR.UPD_ID, SR.PROCESS_TYPE, 
                                    SR.PROCESS_DATE, SF.RECORD_DATE AS RECORD_DATE, SF.PROCESS_DATE AS ACTION_DATE, SF.EXCHANGE_NUMBER AS ACTION_NUMBER, '' AS PROJECT_ID,SR.LOT_NO
            FROM            STOCKS_ROW SR, STOCK_EXCHANGE SF
            WHERE        SR.UPD_ID = SF.STOCK_EXCHANGE_ID AND SR.PROCESS_TYPE = SF.PROCESS_TYPE AND  SR.LOT_NO IS NOT NULL
            UNION ALL
            SELECT        (SR.STOCK_IN - SR.STOCK_OUT) AS TOTAL_STOCK, SR.PRODUCT_ID, SR.STOCK_ID, SR.STOCK_IN AS GIRIS, SR.STOCK_OUT AS CIKIS, SR.STORE, SR.STORE_LOCATION, SR.UPD_ID, SR.PROCESS_TYPE, 
                                    SR.PROCESS_DATE, SR.PROCESS_DATE AS RECORD_DATE, SR.PROCESS_DATE AS ACTION_DATE, '' AS FIS_NUMBER, '' AS PROJECT_ID,SR.LOT_NO
            FROM            STOCKS_ROW SR
            WHERE        SR.PROCESS_TYPE = 117 AND  SR.LOT_NO IS NOT NULL
            UNION ALL
            SELECT        (SR.STOCK_IN - SR.STOCK_OUT) AS TOTAL_STOCK, SR.PRODUCT_ID, SR.STOCK_ID, SR.STOCK_IN AS GIRIS, SR.STOCK_OUT AS CIKIS, SR.STORE, SR.STORE_LOCATION, SR.UPD_ID, SR.PROCESS_TYPE, 
                                    SR.PROCESS_DATE, EXP_P.RECORD_DATE AS RECORD_DATE, EXP_P.EXPENSE_DATE AS ACTION_DATE, EXP_P.PAPER_NO AS ACTION_NUMBER, EXP_P.PROJECT_ID,SR.LOT_NO
            FROM            STOCKS_ROW SR, EXPENSE_ITEM_PLANS EXP_P
            WHERE        SR.UPD_ID = EXP_P.EXPENSE_ID AND SR.PROCESS_TYPE = EXP_P.ACTION_TYPE AND  SR.LOT_NO IS NOT NULL
            ) T
            WHERE 1=1 
            
            <cfif len(arguments.product_id)>
            AND PRODUCT_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.product_id#'> 
            </cfif>

            <cfif len(arguments.lot)>
            AND LOT_NO = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.lot#'>
            </cfif>

            GROUP BY PRODUCT_ID,LOT_NO
        </cfquery>

        <cfreturn query_list>
    </cffunction>

    <cffunction name="GetStretchRoll" access="public" returntype="query">
        <cfargument name="product_id" default="">
        <cfargument name="lot" default="">
        <cfargument name="st_id" default="">

        <cfquery name="query_list" datasource="#dsn2#">
            SELECT 
            T.PRODUCT_ID ,
            LOT_NO,
            trw.COLOR_LOT,
            SUM(GIRIS-CIKIS) AS ENVANTER 
            FROM 
            (
            SELECT        (SR.STOCK_IN - SR.STOCK_OUT) AS TOTAL_STOCK, SR.PRODUCT_ID, SR.STOCK_ID, SR.STOCK_IN AS GIRIS, SR.STOCK_OUT AS CIKIS, SR.STORE, SR.STORE_LOCATION, SR.UPD_ID, SR.PROCESS_TYPE, 
                                    SR.PROCESS_DATE, S.RECORD_DATE AS RECORD_DATE, S.SHIP_DATE AS ACTION_DATE, S.SHIP_NUMBER AS ACTION_NUMBER, S.PROJECT_ID,SR.LOT_NO
            FROM            STOCKS_ROW SR, SHIP S
            WHERE        SR.UPD_ID = S.SHIP_ID AND SR.PROCESS_TYPE = S.SHIP_TYPE AND  SR.LOT_NO IS NOT NULL
            UNION ALL
            SELECT        (SR.STOCK_IN - SR.STOCK_OUT) AS TOTAL_STOCK, SR.PRODUCT_ID, SR.STOCK_ID, SR.STOCK_IN AS GIRIS, SR.STOCK_OUT AS CIKIS, SR.STORE, SR.STORE_LOCATION, SR.UPD_ID, SR.PROCESS_TYPE, 
                                    SR.PROCESS_DATE, SF.RECORD_DATE AS RECORD_DATE, SF.FIS_DATE AS ACTION_DATE, SF.FIS_NUMBER AS ACTION_NUMBER, SF.PROJECT_ID,SR.LOT_NO
            FROM            STOCKS_ROW SR, STOCK_FIS SF
            WHERE        SR.UPD_ID = SF.FIS_ID AND SR.PROCESS_TYPE = SF.FIS_TYPE AND  SR.LOT_NO IS NOT NULL
            UNION ALL
            SELECT        (SR.STOCK_IN - SR.STOCK_OUT) AS TOTAL_STOCK, SR.PRODUCT_ID, SR.STOCK_ID, SR.STOCK_IN AS GIRIS, SR.STOCK_OUT AS CIKIS, SR.STORE, SR.STORE_LOCATION, SR.UPD_ID, SR.PROCESS_TYPE, 
                                    SR.PROCESS_DATE, SF.RECORD_DATE AS RECORD_DATE, SF.PROCESS_DATE AS ACTION_DATE, SF.EXCHANGE_NUMBER AS ACTION_NUMBER, '' AS PROJECT_ID,SR.LOT_NO
            FROM            STOCKS_ROW SR, STOCK_EXCHANGE SF
            WHERE        SR.UPD_ID = SF.STOCK_EXCHANGE_ID AND SR.PROCESS_TYPE = SF.PROCESS_TYPE AND  SR.LOT_NO IS NOT NULL
            UNION ALL
            SELECT        (SR.STOCK_IN - SR.STOCK_OUT) AS TOTAL_STOCK, SR.PRODUCT_ID, SR.STOCK_ID, SR.STOCK_IN AS GIRIS, SR.STOCK_OUT AS CIKIS, SR.STORE, SR.STORE_LOCATION, SR.UPD_ID, SR.PROCESS_TYPE, 
                                    SR.PROCESS_DATE, SR.PROCESS_DATE AS RECORD_DATE, SR.PROCESS_DATE AS ACTION_DATE, '' AS FIS_NUMBER, '' AS PROJECT_ID,SR.LOT_NO
            FROM            STOCKS_ROW SR
            WHERE        SR.PROCESS_TYPE = 117 AND  SR.LOT_NO IS NOT NULL
            UNION ALL
            SELECT        (SR.STOCK_IN - SR.STOCK_OUT) AS TOTAL_STOCK, SR.PRODUCT_ID, SR.STOCK_ID, SR.STOCK_IN AS GIRIS, SR.STOCK_OUT AS CIKIS, SR.STORE, SR.STORE_LOCATION, SR.UPD_ID, SR.PROCESS_TYPE, 
                                    SR.PROCESS_DATE, EXP_P.RECORD_DATE AS RECORD_DATE, EXP_P.EXPENSE_DATE AS ACTION_DATE, EXP_P.PAPER_NO AS ACTION_NUMBER, EXP_P.PROJECT_ID,SR.LOT_NO
            FROM            STOCKS_ROW SR, EXPENSE_ITEM_PLANS EXP_P
            WHERE        SR.UPD_ID = EXP_P.EXPENSE_ID AND SR.PROCESS_TYPE = EXP_P.ACTION_TYPE AND  SR.LOT_NO IS NOT NULL
            ) T
            LEFT JOIN #dsn3#.TEXTILE_STRETCHING_TEST_ROWS trw ON T.LOT_NO = trw.ROLL_ID 
            WHERE 
            trw.STRETCHING_TEST_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.st_id#'>

            <cfif len(arguments.product_id)>
            AND T.PRODUCT_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.product_id#'> 
            </cfif>

            <cfif len(arguments.lot)>
            AND LOT_NO = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.lot#'>
            </cfif>
            GROUP BY T.PRODUCT_ID,LOT_NO,trw.COLOR_LOT
        </cfquery>

        <cfreturn query_list>
    </cffunction>

</cfcomponent>