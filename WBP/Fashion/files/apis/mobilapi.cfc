<cfcomponent rest="true" restPath="mobilapi">

    <cfset company_id = 0>
    <cfset period_id = 0>
    <cfset period_year = 0>
    <cfset schema_ext = "">

    <cfset dsn = "">
    <cfset dsn2 = dsn & "_" & period_year & "_" & company_id>
    <cfset dsn3 = dsn & "_" & company_id>
    <cfset dsn1 = dsn & "_product">

    <cfset ship_process_catid = 62>
    <cfset toptan_process_catid = 161>
    <cfset perakende_process_catid = 167>
    <cfset ship_process_type = 70>
    <cfset price_cat_id = 3>

    <cfset use_location_in_stocks = 0>

    <cffunction name="login" access="remote" returntype="string" httpMethod="POST" produces="application/json" consumes="application/json" restPath="login">
        <cfargument name="bodydata" type="struct">

        <cftry>

            <cfset logindata = get_login(arguments.bodydata.username, arguments.bodydata.password)>
            <cfset result = get_result( logindata.recordcount?1:0, 
                logindata.recordcount?"Giriş Başarılı":"Hatalı Kullanıcı/Şifre",
                { title: "#logindata.EMPLOYEE_NAME# #logindata.EMPLOYEE_SURNAME#" })>
            <cfreturn result>
            
            <cfcatch>
                <cfreturn get_result(0, cfcatch.message, cfcatch)>
            </cfcatch>
        </cftry>
    </cffunction>

    <cffunction name="depo" access="remote" returntype="string" httpMethod="POST" produces="application/json" consumes="application/json" restPath="depo">
        <cfargument name="bodydata" type="struct">

        <cftry>

            <cfset logindata = get_login(arguments.bodydata.username, arguments.bodydata.password)>
            <cfif logindata.recordcount eq 0>
                <cfreturn get_result(0, "Hatalı Kullanıcı/Şifre")>
            </cfif>

            <cfquery name="query_department" datasource="#dsn#">
                SELECT DEPARTMENT_ID, DEPARTMENT_HEAD 
                FROM DEPARTMENT 
                WHERE IS_STORE = 1 AND DEPARTMENT_STATUS = 1
            </cfquery>

            <cfset department_ids = valueList( query_department.DEPARTMENT_ID )>

            <cfquery name="query_location" datasource="#dsn#">
                SELECT LOCATION_ID, DEPARTMENT_ID, COMMENT
                FROM STOCKS_LOCATION
                WHERE STATUS = 1 AND DEPARTMENT_ID IN (#department_ids#)
            </cfquery>

            <cfcatch>
                <cfreturn get_result(0, cfcatch.message, cfcatch)>
            </cfcatch>
        </cftry>
        <cfreturn get_result(1,"", { department: query_department, locations: query_location })>
    </cffunction>

    <cffunction name="stoksayim" access="remote" returntype="string" httpMethod="POST" produces="application/json" consumes="application/json" restPath="stoksayim">
        <cfargument name="bodydata" type="struct">

        <cftry>

            <cfset logindata = get_login(arguments.bodydata.username, arguments.bodydata.password)>
            <cfif logindata.recordcount eq 0>
                <cfreturn get_result(0, "Hatalı Kullanıcı/Şifre")>
            </cfif>

            <cfquery name="query_stock" datasource="#dsn2#">
                <cfloop array="#arguments.bodydata.DATA#" index="item">
                INSERT INTO DYZ_STOCK_DATA (DEPARTMENT_ID, LOCATION_ID, BARCODE, AMOUNT, RECORD_DATE, RECORD_EMP, RECORD_IP)
                VALUES
                (
                    <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.bodydata.DEPO#'>
                    ,<cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.bodydata.LOC#'>
                    ,<cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#item["barcode"]#'>
                    ,<cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#item["amount"]#'>
                    ,#now()#
                    ,#logindata.EMPLOYEE_ID#
                    ,'#cgi.REMOTE_ADDR#'
                )
                </cfloop>
            </cfquery>
            <cfreturn get_result(1)>

            <cfcatch>
                <cfreturn get_result(0, cfcatch.message, cfcatch)>
            </cfcatch>
        </cftry>
    </cffunction>

    <cffunction name="get_stocks" access="remote" returntype="string" httpMethod="POST" produces="application/json" consumes="application/json" restPath="getstocks">
        <cfargument name="bodydata" type="struct">

        <cftry>

            <cfset logindata = get_login(arguments.bodydata.username, arguments.bodydata.password)>
            <cfif logindata.recordcount eq 0>
                <cfreturn get_result(0, "Hatalı Kullanıcı/Şifre")>
            </cfif>

            <cfquery name="query_stocks" datasource="#dsn2#">
                SELECT 
                    SR.PRODUCT_STOCK,
                    SR.STOCK_ID,
                    SR.STOCK_CODE,
                    SR.BARCOD,
                    SR.PROPERTY,
                    SR.PRODUCT_ID,
                    D.DEPARTMENT_ID,
                    D.DEPARTMENT_HEAD,
                    L.COMMENT AS LOCATION_HEAD,
                    PU.MAIN_UNIT,
                    PU.MAIN_UNIT_ID,
                    PRD.PRODUCT_NAME,
                    ISNULL((SELECT TOP 1 PRICE FROM #dsn3##schema_ext#.PRICE WHERE PRODUCT_ID = SR.PRODUCT_ID AND PRICE_CATID = #price_cat_id# AND STARTDATE <= GETDATE() ORDER BY STARTDATE DESC), 0) AS PRICE,
                    ISNULL((SELECT TOP 1 [MONEY] FROM #dsn3##schema_ext#.PRICE WHERE PRODUCT_ID = SR.PRODUCT_ID AND PRICE_CATID = #price_cat_id# AND STARTDATE <= GETDATE() ORDER BY STARTDATE DESC), 'TL') AS [MONEY],
                    ISNULL(PI.PATH, '') AS PRODUCT_IMAGE,
                    PRD.TAX
                FROM 
                    (
                        SELECT
                            ROUND(SUM(SR.STOCK_IN - SR.STOCK_OUT),4) AS PRODUCT_STOCK, 
                            S.PRODUCT_ID, 
                            S.STOCK_ID, 
                            S.STOCK_CODE, 
                            S.PROPERTY, 
                            S.BARCOD,
                            SR.STORE AS DEPARTMENT_ID,
                            SR.STORE_LOCATION AS LOCATION_ID
                        FROM
                            #dsn1##schema_ext#.STOCKS S,
                            #dsn2##schema_ext#.STOCKS_ROW SR
                        WHERE
                            S.STOCK_ID = SR.STOCK_ID
                        GROUP BY
                            S.PRODUCT_ID, 
                            S.STOCK_ID, 
                            S.STOCK_CODE, 
                            S.PROPERTY, 
                            S.BARCOD, 
                            SR.STORE,
                            SR.STORE_LOCATION
                    ) SR
                    LEFT OUTER JOIN #dsn##schema_ext#.DEPARTMENT D ON SR.DEPARTMENT_ID = D.DEPARTMENT_ID
                    LEFT OUTER JOIN #dsn##schema_ext#.STOCKS_LOCATION L ON SR.LOCATION_ID = L.LOCATION_ID AND SR.DEPARTMENT_ID = L.DEPARTMENT_ID
                    LEFT OUTER JOIN #dsn1##schema_ext#.KARMA_PRODUCTS KP ON SR.STOCK_ID = KP.STOCK_ID
                    INNER JOIN #dsn1##schema_ext#.PRODUCT PRD ON SR.PRODUCT_ID = PRD.PRODUCT_ID OR KP.PRODUCT_ID = PRD.PRODUCT_ID
                    INNER JOIN #dsn1##schema_ext#.PRODUCT_UNIT PU ON PRD.PRODUCT_ID = PU.PRODUCT_ID
                    <cfif structKeyExists(arguments.bodydata, "withkarma") and arguments.bodydata.withkarma eq 1>
                    LEFT OUTER JOIN (
						SELECT KP.PRODUCT_ID, PP.BARCOD AS PPBARCOD
							FROM #dsn1##schema_ext#.[KARMA_PRODUCTS] KP
							INNER JOIN #dsn1##schema_ext#.PRODUCT PP ON KP.KARMA_PRODUCT_ID = PP.PRODUCT_ID
                    ) PG ON PG.PRODUCT_ID = PRD.PRODUCT_ID
                    </cfif>
                    LEFT OUTER JOIN #dsn1##schema_ext#.PRODUCT_IMAGES PI ON PRD.PRODUCT_ID = PI.PRODUCT_ID
                WHERE 
                    (
                        SR.BARCOD = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.bodydata.BARCODE#'>
                        <cfif structKeyExists(arguments.bodydata, "withkarma") and arguments.bodydata.withkarma eq 1>
                        OR PG.PPBARCOD = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.bodydata.BARCODE#'>
                        </cfif>
                    )
                    AND PU.IS_MAIN = 1
                    <cfif use_location_in_stocks eq 1 and structKeyExists(arguments.bodydata, "DEPARTMENT_ID")>
                        <cfif arguments.bodydata.DEPARTMENT_ID gt 0>
                        AND SR.DEPARTMENT_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.bodydata.DEPARTMENT_ID#'>
                        <cfelse>
                        AND SR.DEPARTMENT_ID IS NULL
                        </cfif>
                    </cfif>
                    ORDER BY MAIN_UNIT_ID DESC
            </cfquery>
                <cfreturn get_result(1, "", query_stocks)>
            <cfcatch>
                <cfreturn get_result(0, cfcatch.message, cfcatch)>
            </cfcatch>
        </cftry>
    </cffunction>

    <cffunction name="money_rates" access="remote" returntype="string" httpMethod="POST" produces="application/json" consumes="application/json" restPath="moneyrates">
        <cfargument name="bodydata" type="struct">

        <cftry>

            <cfset logindata = get_login(arguments.bodydata.username, arguments.bodydata.password)>
            <cfif logindata.recordcount eq 0>
                <cfreturn get_result(0, "Hatalı Kullanıcı/Şifre")>
            </cfif>

            <cfquery name="query_money_rates" datasource="#dsn#">
                SELECT [MONEY], RATE2 FROM SETUP_MONEY WHERE COMPANY_ID = #company_id# AND PERIOD_ID = #period_id#
            </cfquery>
            <cfreturn get_result(1, "", query_money_rates)>
            <cfcatch>
                <cfreturn get_result(0, cfcatch.message, cfcatch)>
            </cfcatch>
        </cftry>
    </cffunction>

    <cffunction name="save_sevk" access="remote" returntype="string" httpMethod="POST" produces="application/json" consumes="application/json" restPath="savesevk">
        <cfargument name="bodydata" type="struct">

        <cftry>

            <cfset logindata = get_login(arguments.bodydata.username, arguments.bodydata.password)>
            <cfif logindata.recordcount eq 0>
                <cfreturn get_result(0, "Hatalı Kullanıcı/Şifre")>
            </cfif>

            <cfset wrk_id = getwrkid()>
            <cflock name="#CreateUUID()#" timeout="60">
                <cftransaction>

                    <cfquery name="GET_PAPER" datasource="#dsn2#">
                        SELECT * FROM #dsn3##schema_ext#.PAPERS_NO WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#logindata.EMPLOYEE_ID#"> ORDER BY PAPER_ID DESC 
                    </cfquery>
                    <cfif not (len(evaluate('get_paper.SHIP_NO')) and len(evaluate('get_paper.SHIP_number')))>
                        <cfquery name="GET_PAPER" datasource="#dsn2#">
                            SELECT
                                *
                            FROM
                                #dsn3##schema_ext#.PAPERS_NO PN,
                                #dsn##schema_ext#.SETUP_PRINTER_USERS SPU
                            WHERE
                                PN.PRINTER_ID = SPU.PRINTER_ID AND
                                SPU.PRINTER_EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#logindata.EMPLOYEE_ID#">
                            ORDER BY
                                PAPER_ID DESC 
                        </cfquery>
                    </cfif>
                    <cfif len(evaluate('get_paper.SHIP_NO')) and len(evaluate('get_paper.SHIP_number'))>
                        <cfset paper_code = evaluate('get_paper.SHIP_no')>
                        <cfset paper_number = evaluate('get_paper.SHIP_number') +1>
                        <cfquery name="query_updshipno" datasource="#dsn2#">
                            UPDATE #dsn3##schema_ext#.PAPERS_NO SET SHIP_NUMBER = #GET_PAPER.SHIP_NUMBER + 1# WHERE PAPER_ID = #GET_PAPER.PAPER_ID#
                        </cfquery>
                    <cfelse>
                        <cfset paper_code = ''>
                        <cfset paper_number = ''>
                    </cfif>
                    
                    <cfquery name="query_process_type" datasource="#dsn2#">
                        SELECT 
                            PROCESS_TYPE,
                            PROCESS_CAT_ID,
                            IS_CARI,
                            IS_ACCOUNT,
                            IS_STOCK_ACTION,
                            IS_ACCOUNT_GROUP,
                            IS_PROJECT_BASED_ACC,
                            IS_COST,
                            ACTION_FILE_NAME,
                            ACTION_FILE_SERVER_ID,
                            ACTION_FILE_FROM_TEMPLATE,
                            ISNULL(IS_ADD_INVENTORY,0) IS_ADD_INVENTORY,
                            ISNULL(IS_DEPT_BASED_ACC,0) IS_DEPT_BASED_ACC
                         FROM 
                             #dsn3##schema_ext#.SETUP_PROCESS_CAT 
                        WHERE 
                            PROCESS_CAT_ID = #ship_process_catid#
                    </cfquery>
                    <cfquery name="query_add_sale" result="result_add_sale" datasource="#dsn2#">
                        INSERT INTO SHIP
                        (
                            WRK_ID,
                            PURCHASE_SALES,
                            SHIP_NUMBER,
                            DISPATCH_SHIP_ID,
                            SHIP_TYPE,
                            PROCESS_CAT,
                            SHIP_DATE,
                            DISCOUNTTOTAL,
                            NETTOTAL,
                            GROSSTOTAL,
                            TAXTOTAL,
                            OTHER_MONEY,
                            OTHER_MONEY_VALUE,
                            DELIVER_STORE_ID,
                            LOCATION,
                            DEPARTMENT_IN,
                            LOCATION_IN,
                            REF_NO,
                            PROJECT_ID,
                            PROJECT_ID_IN,
                            WORK_ID,
                            RECORD_DATE,
                            RECORD_EMP,
                            SHIP_DETAIL,
                            DELIVER_DATE
                        )
                        VALUES
                        (
                            <cfqueryparam cfsqltype="CF_SQL_NVARCHAR" value="#wrk_id#">,
                            1,
                            '#paper_code#-#paper_number#',
                            NULL,
                            #query_process_type.process_type#,
                            #ship_process_catid#,
                            #now()#,
                            0,
                            0,
                            0,
                            0,
                            'TL',
                            0,
                            #bodydata.CIKISDEPOID#,
                            #bodydata.CIKISLOCID#,
                            #bodydata.GIRISDEPOID#,
                            #bodydata.GIRISLOCID#,
                            NULL,
                            NULL,
                            NULL,
                            NULL,
                            #now()#,
                            #logindata.EMPLOYEE_ID#,
                            NULL,
                            #now()#
                        )
                    </cfquery>
                    
                    <cfloop array="#bodydata.rows#" index="ri">
                        
                        <cfquery name="query_get_units" datasource="#dsn2#">
                            SELECT 
                                PRODUCT_UNIT.ADD_UNIT,
                                PRODUCT_UNIT.MULTIPLIER,
                                PRODUCT_UNIT.MAIN_UNIT,
                                PRODUCT_UNIT.MAIN_UNIT_ID,
                                PRODUCT_UNIT.PRODUCT_UNIT_ID
                            FROM
                                #dsn3##schema_ext#.STOCKS
                                INNER JOIN #dsn3##schema_ext#.PRODUCT_UNIT ON STOCKS.PRODUCT_ID = PRODUCT_UNIT.PRODUCT_ID 
                            WHERE 
                                STOCKS.STOCK_ID = #ri["stockid"]#
                        </cfquery>
                        <cfif query_get_units.recordcount and len(query_get_units.MULTIPLIER)>
                            <cfset multi = query_get_units.MULTIPLIER * ri["amount"]>
                        <cfelse>
                            <cfset multi = ri["amount"]>
                        </cfif>
                        <cfquery name="query_product" datasource="#dsn2#">
                            SELECT TOP 1 PRODUCT_ID, PRODUCT_NAME FROM #dsn3##schema_ext#.STOCKS
                            WHERE STOCK_ID = #ri["stockid"]#
                        </cfquery>
                        <cfquery name="query_karma_products_stock" datasource="#dsn2#"><!--- karma koli olan ürünler --->
							SELECT PRODUCT.PRODUCT_ID, PRODUCT.PRODUCT_NAME, PRODUCT_UNIT.MAIN_UNIT, STOCKS.PRODUCT_UNIT_ID
                            FROM #dsn3##schema_ext#.PRODUCT
                            INNER JOIN #dsn3##schema_ext#.STOCKS ON PRODUCT.PRODUCT_ID = STOCKS.PRODUCT_ID 
                            INNER JOIN #dsn1##schema_ext#.PRODUCT_UNIT ON STOCKS.PRODUCT_UNIT_ID = PRODUCT_UNIT.PRODUCT_UNIT_ID
                            WHERE STOCKS.STOCK_ID = #ri["stockid"]# AND PRODUCT.IS_KARMA = 1
                        </cfquery>
                        <cfif query_karma_products_stock.recordcount>
                            <cfquery name="query_karma_products" datasource="#dsn2#">
                                SELECT PRODUCT_ID,STOCK_ID,SPEC_MAIN_ID,PRODUCT_AMOUNT,PRODUCT_NAME
                                FROM #dsn1##schema_ext#.KARMA_PRODUCTS
                                WHERE KARMA_PRODUCT_ID = #query_product.PRODUCT_ID#
                            </cfquery>
                            
                            <cfloop query="query_karma_products">
                                <cfset ship_row_wrkid = getwrkid()>
                                <cfquery name="query_ship_row" datasource="#dsn2#">
                                    INSERT INTO SHIP_ROW
                                    (
                                        NAME_PRODUCT,
                                        SHIP_ID,
                                        STOCK_ID,
                                        PRODUCT_ID,
                                        AMOUNT,
                                        UNIT,
                                        UNIT_ID,
                                        SPECT_VAR_ID,
                                        TAX,
                                        PRICE,
                                        DISCOUNT,
                                        PURCHASE_SALES,
                                        DISCOUNT2,
                                        DISCOUNT3,
                                        DISCOUNT4,
                                        DISCOUNT5,
                                        DISCOUNT6,
                                        DISCOUNT7,
                                        DISCOUNT8,
                                        DISCOUNT9,
                                        DISCOUNT10,
                                        DISCOUNTTOTAL,
                                        GROSSTOTAL,
                                        NETTOTAL,
                                        TAXTOTAL,
                                        DELIVER_DEPT,
                                        DELIVER_LOC,
                                        PRICE_OTHER,
                                        OTHER_MONEY_GROSS_TOTAL,
                                        IS_PROMOTION,
                                        OTHER_MONEY,
                                        OTHER_MONEY_VALUE,
                                        COST_PRICE,
                                        AMOUNT2,
                                        WRK_ROW_ID,
                                        EXTRA_PRICE_TOTAL,
                                        OTV_ORAN,
                                        OTVTOTAL,
                                        BASKET_EXTRA_INFO_ID
                                    )
                                    VALUES
                                    (
                                        '#query_karma_products.PRODUCT_NAME#',
                                        #result_add_sale.IDENTITYCOL#,
                                        #query_karma_products.stock_id#,
                                        #query_karma_products.product_id#,
                                        #multi*query_karma_products.product_amount#,
                                        '#query_karma_products_stock.MAIN_UNIT#',
                                        #query_karma_products_stock.PRODUCT_UNIT_ID#,
                                        #len(query_karma_products.SPEC_MAIN_ID)?query_karma_products.SPEC_MAIN_ID:'NULL'#,
                                        0,
                                        0,
                                        0,
                                        1,
                                        0,
                                        0,
                                        0,
                                        0,
                                        0,
                                        0,
                                        0,
                                        0,
                                        0,
                                        0,
                                        0,
                                        0,
                                        0,
                                        #bodydata.GIRISDEPOID#,
                                        #bodydata.GIRISLOCID#,
                                        0,
                                        0,
                                        0,
                                        'TL',
                                        0,
                                        0,
                                        #multi#,
                                        '#ship_row_wrkid#',
                                        0,
                                        0,
                                        0,
                                        -1
                                    )
                                </cfquery>
                                <cfquery name="add_stock_row" datasource="#dsn2#">
                                    INSERT INTO STOCKS_ROW
                                        (
                                            UPD_ID,
                                            PRODUCT_ID,
                                            STOCK_ID,
                                            PROCESS_TYPE,
                                            STOCK_IN,
                                            STOCK_OUT,
                                            STORE,
                                            STORE_LOCATION,
                                            PROCESS_DATE,
                                            SPECT_VAR_ID,
                                            AMOUNT2
                                        )
                                        VALUES
                                        (
                                            #result_add_sale.IDENTITYCOL#,
                                            #query_karma_products.product_id#,
                                            #query_karma_products.stock_id#,
                                            #query_process_type.process_type#,
                                            0,
                                            #multi*query_karma_products.product_amount#,
                                            #bodydata.CIKISDEPOID#,
                                            #bodydata.CIKISLOCID#,
                                            #now()#,
                                            #len(query_karma_products.SPEC_MAIN_ID)?query_karma_products.SPEC_MAIN_ID:'NULL'#,
                                            #multi#
                                        )
                                </cfquery>
                            </cfloop>
                        <cfelse>
                            <cfquery name="query_product" datasource="#dsn2#">
                                SELECT TOP 1 PRODUCT_ID, PRODUCT_NAME FROM #dsn3##schema_ext#.STOCKS
                                WHERE STOCK_ID = #ri["stockid"]#
                            </cfquery>
                            <cfset ship_row_wrkid = getwrkid()>
                            <cfquery name="query_ship_row" datasource="#dsn2#">
                                INSERT INTO SHIP_ROW
                                (
                                    NAME_PRODUCT,
                                    SHIP_ID,
                                    STOCK_ID,
                                    PRODUCT_ID,
                                    AMOUNT,
                                    UNIT,
                                    UNIT_ID,
                                    TAX,
                                    PRICE,
                                    DISCOUNT,
                                    PURCHASE_SALES,
                                    DISCOUNT2,
                                    DISCOUNT3,
                                    DISCOUNT4,
                                    DISCOUNT5,
                                    DISCOUNT6,
                                    DISCOUNT7,
                                    DISCOUNT8,
                                    DISCOUNT9,
                                    DISCOUNT10,
                                    DISCOUNTTOTAL,
                                    GROSSTOTAL,
                                    NETTOTAL,
                                    TAXTOTAL,
                                    DELIVER_DEPT,
                                    DELIVER_LOC,
                                    PRICE_OTHER,
                                    OTHER_MONEY_GROSS_TOTAL,
                                    IS_PROMOTION,
                                    OTHER_MONEY,
                                    OTHER_MONEY_VALUE,
                                    COST_PRICE,
                                    AMOUNT2,
                                    WRK_ROW_ID,
                                    EXTRA_PRICE_TOTAL,
                                    OTV_ORAN,
                                    OTVTOTAL,
                                    BASKET_EXTRA_INFO_ID
                                )
                                VALUES
                                (
                                    '#query_product.PRODUCT_NAME#',
                                    #result_add_sale.IDENTITYCOL#,
                                    #ri["stockid"]#,
                                    #query_product.product_id#,
                                    #multi#,
                                    '#query_get_units.MAIN_UNIT#',
                                    #query_get_units.PRODUCT_UNIT_ID#,
                                    0,
                                    0,
                                    0,
                                    1,
                                    0,
                                    0,
                                    0,
                                    0,
                                    0,
                                    0,
                                    0,
                                    0,
                                    0,
                                    0,
                                    0,
                                    0,
                                    0,
                                    #bodydata.GIRISDEPOID#,
                                    #bodydata.GIRISLOCID#,
                                    0,
                                    0,
                                    0,
                                    'TL',
                                    0,
                                    0,
                                    #multi#,
                                    '#ship_row_wrkid#',
                                    0,
                                    0,
                                    0,
                                    -1
                                )
                            </cfquery>
                            <cfquery name="query_add_stock_row" datasource="#dsn2#">
                                INSERT INTO STOCKS_ROW
                                (
                                    UPD_ID,
                                    PRODUCT_ID,
                                    STOCK_ID,
                                    PROCESS_TYPE,
                                    STOCK_OUT,
                                    STORE,
                                    STORE_LOCATION,
                                    PROCESS_DATE,
                                    LOT_NO,
                                    PRODUCT_MANUFACT_CODE,				
                                    AMOUNT2,
                                    UNIT2,
                                    DELIVER_DATE,
                                    SHELF_NUMBER,
                                    DEPTH_VALUE,
                                    WIDTH_VALUE,
                                    HEIGHT_VALUE
                                )
                                VALUES
                                (
                                    #result_add_sale.IDENTITYCOL#,
                                    #query_product.PRODUCT_ID#,
                                    #ri["stockid"]#,
                                    #query_process_type.process_type#,
                                    #multi#,
                                    #bodydata.CIKISDEPOID#,
                                    #bodydata.CIKISLOCID#,
                                    #now()#,
                                    NULL,
                                    NULL,
                                    NULL,
                                    NULL,
                                    NULL,
                                    NULL,
                                    NULL,
                                    NULL,
                                    NULL
                                )
                            </cfquery>    
                        </cfif>
                        
                    </cfloop>
                </cftransaction>
            </cflock>
            <cfreturn get_result(1, result_add_sale.IDENTITYCOL)>
            <cfcatch>
                <cfreturn get_result(0, cfcatch.message, cfcatch)>
            </cfcatch>
        </cftry>
    </cffunction>

    <cffunction name="customer_list" access="remote" returntype="string" httpMethod="POST" consumes="application/json" produces="application/json" restPath="customerlist">
        <cfargument name="bodydata" type="struct">

        <cftry>
            <cfset logindata = get_login(arguments.bodydata.username, arguments.bodydata.password)>
            <cfif logindata.recordcount eq 0>
                <cfreturn get_result(0, "Hatalı Kullanıcı/Şifre")>
            </cfif>

            <cfquery name="query_caris" datasource="#dsn#">
                SELECT 1 AS CARITYPE, COMPANY_ID AS CARIID, FULLNAME 
                FROM COMPANY
                WHERE FULLNAME LIKE <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='%#arguments.bodydata.customer#%'>
                UNION ALL
                SELECT 2 AS CARITYPE, CONSUMER_ID, CONSUMER_NAME + ' ' + CONSUMER_SURNAME
                FROM CONSUMER
                WHERE (CONSUMER_NAME + ' ' + CONSUMER_SURNAME) LIKE <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='%#arguments.bodydata.customer#%'>
            </cfquery>

            <cfreturn get_result(1, "", query_caris)>
            <cfcatch>
                <cfreturn get_result(0, cfcatch.message, cfcatch)>
            </cfcatch>
        </cftry>
    </cffunction>

    <cffunction name="save_invoice" access="remote" returntype="string" httpMethod="POST" consumes="application/json" produces="application/json" restPath="saveinvoice">
        <cfargument name="bodydata" type="struct">

        <cftry>
            <cfset logindata = get_login(arguments.bodydata.username, arguments.bodydata.password)>
            <cfif logindata.recordcount eq 0>
                <cfreturn get_result(0, "Hatalı Kullanıcı/Şifre")>
            </cfif>
            <cfset branchdata = get_branch_dept(logindata.POSITION_CODE, logindata.OUR_COMPANY_ID)>
            <cfif "#branchdata.LOCATION_ID#" eq "">
                <cfreturn get_result(0, "Şube/Lokasyon tanımınız eksik. Lütfen sistem yöneticinize başvurun")>
            </cfif>


            <cfquery name="GET_PAPER" datasource="#dsn3#">
				SELECT * FROM PAPERS_NO WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#logindata.EMPLOYEE_ID#"> ORDER BY PAPER_ID DESC 
			</cfquery>
			<cfif not (len(evaluate('get_paper.INVOICE_NO')) and len(evaluate('get_paper.INVOICE_NUMBER')))>
				<cfquery name="GET_PAPER" datasource="#dsn3#">
					SELECT
						*
					FROM
						PAPERS_NO PN,
						#dsn##schema_ext#.SETUP_PRINTER_USERS SPU
					WHERE
						PN.PRINTER_ID = SPU.PRINTER_ID AND
						SPU.PRINTER_EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#logindata.EMPLOYEE_ID#">
					ORDER BY
						PAPER_ID DESC 
				</cfquery>
			</cfif>
			<cfif len(evaluate('get_paper.INVOICE_NO')) and len(evaluate('get_paper.INVOICE_NUMBER'))>
				<cfset paper_code = evaluate('get_paper.INVOICE_NO')>
				<cfset paper_number = evaluate('get_paper.INVOICE_NUMBER') +1>
            <cfelse>
				<cfset paper_code = ''>
				<cfset paper_number = ''>
			</cfif>

            <cfquery name="query_get_consumer_cat" datasource="#dsn#">
                SELECT CONSCAT_ID FROM CONSUMER_CAT WHERE IS_DEFAULT = 1
            </cfquery>
            <cfquery name="query_get_consumer_stage" datasource="#dsn#" maxrows="1">
                SELECT TOP 1
                    PTR.STAGE,
                    PTR.PROCESS_ROW_ID,
                    PTR.LINE_NUMBER
                FROM
                    PROCESS_TYPE_ROWS PTR,
                    PROCESS_TYPE_OUR_COMPANY PTO,
                    PROCESS_TYPE PT
                WHERE
                    PT.IS_ACTIVE = 1 AND
                    PT.PROCESS_ID = PTR.PROCESS_ID AND
                    PT.PROCESS_ID = PTO.PROCESS_ID AND
                    PTO.OUR_COMPANY_ID = #logindata.OUR_COMPANY_ID# AND
                    PT.FACTION LIKE <cfqueryparam cfsqltype="CF_SQL_NVARCHAR" value="%member.form_add_consumer%">
                ORDER BY
                    PTR.LINE_NUMBER
            </cfquery>
            <cfquery name="query_get_company_stage" datasource="#dsn#" maxrows="1">
                SELECT TOP 1
                    PTR.STAGE,
                    PTR.PROCESS_ROW_ID,
                    PTR.LINE_NUMBER
                FROM
                    PROCESS_TYPE_ROWS PTR,
                    PROCESS_TYPE_OUR_COMPANY PTO,
                    PROCESS_TYPE PT
                WHERE
                    PT.IS_ACTIVE = 1 AND
                    PT.PROCESS_ID = PTR.PROCESS_ID AND
                    PT.PROCESS_ID = PTO.PROCESS_ID AND
                    PTO.OUR_COMPANY_ID = #logindata.OUR_COMPANY_ID# AND
                    PT.FACTION LIKE <cfqueryparam cfsqltype="CF_SQL_NVARCHAR" value="%member.form_add_company%">
                ORDER BY
                    PTR.LINE_NUMBER
            </cfquery>
            <cfquery name="query_get_location_type" datasource="#dsn#">
                SELECT LOCATION_TYPE,IS_SCRAP FROM STOCKS_LOCATION WHERE DEPARTMENT_ID=#logindata.DEPARTMENT_ID# AND LOCATION_ID=#branchdata.LOCATION_ID#
            </cfquery>

            <cfquery name="query_money_rates" datasource="#dsn#">
                SELECT [MONEY], RATE2 FROM SETUP_MONEY WHERE COMPANY_ID = #company_id# AND PERIOD_ID = #period_id#
            </cfquery>
            
            <cfscript>
            
            attributes = structNew();
            attributes.comp_member_cat = "";
            attributes.cons_member_cat = "";
            attributes.PAPER = '#paper_code#-#paper_number#';
            attributes.SERIAL_NUMBER = paper_code;
            attributes.SERIAL_NO = paper_number;
            attributes.CONSUMER_STAGE = query_get_consumer_stage.recordcount ? query_get_consumer_stage.PROCESS_ROW_ID : '';
            attributes.COMPANY_STAGE = query_get_company_stage.recordcount ? query_get_company_stage.PROCESS_ROW_ID : '';
            attributes.CASH = 0;
            attributes.CONSUMER_CAT_ID = query_get_consumer_cat.recordcount ? query_get_consumer_cat.CONSCAT_ID : '';
            attributes.COMPANY_CAT_ID = 1;
            attributes.COMPANY_ID =  arguments.bodydata.CUSTOMERTYPE eq 1 ? arguments.bodydata.CUSTOMERID : "";
            attributes.PARTNER_ID = "";
            attributes.CONSUMER_ID = arguments.bodydata.CUSTOMERTYPE eq 2 ? arguments.bodydata.CUSTOMERID : "";
            attributes.LOCATION_TYPE = query_get_location_type.recordcount ? query_get_location_type.LOCATION_TYPE : '';
            attributes.MEMBER_NAME = trim(replace(arguments.bodydata.TITLE, listLast(arguments.bodydata.TITLE, " "), ""));
            attributes.MEMBER_SURNAME = trim(listLast(arguments.bodydata.TITLE, " "));
            attributes.PROCESS_CAT = arguments.bodydata.PERAKENDE ? toptan_process_catid : perakende_process_catid;
            
            WRK_ID = dateformat(now(),'YYYYMMDD')&timeformat(now(),'HHmmss')&'_#logindata.EMPLOYEE_ID#_'&round(rand()*100);

            moneynamesArr = valueArray( query_money_rates, "MONEY" );
            moneyratesArr = valueArray( query_money_rates, "RATE2" );
            invoiceMoneyRate = moneyratesarr[ arrayFind( moneynamesArr, arguments.bodydata.money ) ];

            BASKET_NET_TOTAL = arrayReduce( arguments.bodydata.rows, function(acc, val) { acc = isDefined("arguments.acc")?arguments.acc:0; return acc + (val["price"] * val["amount"] * moneyratesarr[ arrayFind( moneynamesArr, val["money"] ) ]); }, 0 );
            BASKET_TAX_TOTAL = arrayReduce( arguments.bodydata.rows, function(acc, val) { acc = isDefined("arguments.acc")?arguments.acc:0; return acc + (val["price"] * val["amount"] * val["tax"] / 100 * moneyratesarr[ arrayFind( moneynamesArr, val["money"] ) ]); }, 0 );
            BASKET_GROSS_TOTAL = arrayReduce( arguments.bodydata.rows, function(acc, val) { acc = isDefined("arguments.acc")?arguments.acc:0; return acc + (val["price"] * val["amount"] * (100 + val["tax"]) / 100 * moneyratesarr[ arrayFind( moneynamesArr, val["money"] ) ]); }, 0 );

            if ( len(arguments.bodydata.INDIRIM) ) {
                discounttax = 0;
                for (row in arguments.bodydata.rows) {
                    rtotal = row["price"] * row["amount"] * moneyratesarr[ arrayFind( moneynamesArr, row["money"] ) ];
                    rrate = rtotal * 100 / BASKET_NET_TOTAL / 100;                    
                    discounttax = discounttax + (arguments.bodydata.INDIRIM * rrate * ( row["tax"] / 100 ) );
                }
                arguments.bodydata.INDIRIM = arguments.bodydata.INDIRIM - discounttax;
            }

            </cfscript>

            <cfquery name="query_get_process_type" datasource="#dsn3#">
                SELECT 
                    PROCESS_TYPE,
                    IS_CARI,
                    IS_ACCOUNT,
                    IS_BUDGET,
                    IS_DISCOUNT,
                    PROCESS_CAT,
                    IS_STOCK_ACTION,
                    IS_ACCOUNT_GROUP,
                    IS_PROJECT_BASED_ACC,
                    IS_DEPT_BASED_ACC,
                    IS_PROJECT_BASED_BUDGET,
                    IS_COST,
                    IS_DUE_DATE_BASED_CARI,
                    IS_PAYMETHOD_BASED_CARI,
                    IS_PROD_COST_ACC_ACTION,
                    ACTION_FILE_NAME,
                    ACTION_FILE_SERVER_ID,
                    ACTION_FILE_FROM_TEMPLATE,
                    ISNULL(IS_ROW_PROJECT_BASED_CARI,0) IS_ROW_PROJECT_BASED_CARI,
                    PROFILE_ID
                FROM 
                    SETUP_PROCESS_CAT 
                WHERE 
                    PROCESS_CAT_ID = #attributes.PROCESS_CAT#
            </cfquery>

            <cfset INVOICE_CAT = query_get_process_type.PROCESS_TYPE>
            
            <cftransaction>
            <cfif arguments.bodydata.CUSTOMERID eq 0 and arguments.bodydata.CUSTOMERTYPE eq 2>
                
                <cfquery name="query_add_consumer" datasource="#dsn#">
                    INSERT INTO
                    CONSUMER
                    (
                        IS_CARI,
                        ISPOTANTIAL,
                        CONSUMER_CAT_ID,
                        CONSUMER_STAGE,
                        CONSUMER_EMAIL,
                        CONSUMER_FAX,
                        CONSUMER_FAXCODE,
                        COMPANY,
                        CONSUMER_NAME,
                        CONSUMER_SURNAME,
                        MOBIL_CODE,
                        MOBILTEL,
                        TAX_OFFICE,
                        TAX_NO,
                        <cfif isdefined("attributes.adres_type") and len(attributes.adres_type)>
                            CONSUMER_HOMETEL,
                            CONSUMER_HOMETELCODE,
                            HOMEADDRESS,
                            HOME_COUNTY_ID,
                            HOME_CITY_ID,
                            HOME_COUNTRY_ID,
                        <cfelse>
                            CONSUMER_WORKTEL,
                            CONSUMER_WORKTELCODE,
                            TAX_ADRESS,
                            TAX_COUNTY_ID,
                            TAX_CITY_ID,
                            TAX_COUNTRY_ID,
                        </cfif>
                        TC_IDENTY_NO,
                        VOCATION_TYPE_ID,
                        IMS_CODE_ID,
                        PERIOD_ID,
                        RECORD_IP,
                        RECORD_MEMBER,
                        RECORD_DATE
                    )
                    VALUES 	 
                    (
                        1,
                        0,
                        <cfif isdefined("attributes.cons_member_cat") and len(attributes.cons_member_cat)>#cons_member_cat#,<cfelse>#attributes.CONSUMER_CAT_ID#,</cfif>
                        #attributes.consumer_stage#,
                        <cfif isdefined("attributes.email") and len(attributes.email)><cfqueryparam cfsqltype="CF_SQL_NVARCHAR" value="#attributes.email#"><cfelse>NULL</cfif>,
                        <cfif isdefined("attributes.fax_number") and len(attributes.fax_number)><cfqueryparam cfsqltype="CF_SQL_NVARCHAR" value="#attributes.fax_number#"><cfelse>NULL</cfif>,
                        <cfif isdefined("attributes.faxcode") and len(attributes.faxcode)><cfqueryparam cfsqltype="CF_SQL_NVARCHAR" value="#attributes.faxcode#"><cfelse>NULL</cfif>,
                        <cfif isDefined("attributes.comp_name") and Len(attributes.comp_name)><cfqueryparam cfsqltype="CF_SQL_NVARCHAR" value="#attributes.comp_name#"><cfelse>NULL</cfif>,
                        <cfqueryparam cfsqltype="CF_SQL_NVARCHAR" value="#attributes.member_name#">,
                        <cfqueryparam cfsqltype="CF_SQL_NVARCHAR" value="#attributes.member_surname#">,
                        <cfif isDefined("attributes.mobil_code") and len(attributes.mobil_code)><cfqueryparam cfsqltype="CF_SQL_NVARCHAR" value="#attributes.mobil_code#"><cfelse>NULL</cfif>,
                        <cfif isDefined("attributes.mobil_tel") and len(attributes.mobil_tel)><cfqueryparam cfsqltype="CF_SQL_NVARCHAR" value="#attributes.mobil_tel#"><cfelse>NULL</cfif>,
                        <cfif isDefined("attributes.tax_office") and len(attributes.tax_office)><cfqueryparam cfsqltype="CF_SQL_NVARCHAR" value="#attributes.tax_office#"><cfelse>NULL</cfif>,
                        <cfif isDefined("attributes.tax_num") and len(attributes.tax_num)><cfqueryparam cfsqltype="CF_SQL_NVARCHAR" value="#attributes.tax_num#"><cfelse>NULL</cfif>,
                        <cfif isDefined("attributes.tel_number") and len(attributes.tel_number)><cfqueryparam cfsqltype="CF_SQL_NVARCHAR" value="#attributes.tel_number#"><cfelse>NULL</cfif>,
                        <cfif isDefined("attributes.tel_code") and len(attributes.tel_code)><cfqueryparam cfsqltype="CF_SQL_NVARCHAR" value="#attributes.tel_code#"><cfelse>NULL</cfif>,
                        <cfif isDefined("attributes.address") and len(attributes.address)><cfqueryparam cfsqltype="CF_SQL_NVARCHAR" value="#attributes.address#"><cfelse>NULL</cfif>,
                        <cfif isDefined("attributes.county_id") and len(attributes.county_id)>#attributes.county_id#<cfelse>NULL</cfif>,
                        <cfif isDefined("attributes.city") and len(attributes.city)>#attributes.city#<cfelse>NULL</cfif>,
                        1,
                        <cfif isdefined('attributes.tc_num') and len(attributes.tc_num)><cfqueryparam cfsqltype="CF_SQL_NVARCHAR" value="#attributes.tc_num#"><cfelse>NULL</cfif>,
                        <cfif isdefined("attributes.vocation_type") and len(attributes.vocation_type)>#attributes.vocation_type#<cfelse>NULL</cfif>,
                        <cfif isdefined("attributes.ims_code_id") and len(attributes.ims_code_id)>#attributes.ims_code_id#<cfelse>NULL</cfif>,
                        #logindata.PERIOD_ID#,
                        <cfqueryparam cfsqltype="CF_SQL_NVARCHAR" value="#cgi.remote_addr#">,
                        #logindata.EMPLOYEE_ID#,
                        #now()#
                    )
                </cfquery>
                <cfquery name="query_get_max_cons" datasource="#dsn#">
                    SELECT 
                        MAX(CONSUMER_ID) MAX_CONS 
                    FROM 
                        CONSUMER
                </cfquery>
                <cfset attributes.CONSUMER_ID = query_get_max_cons.MAX_CONS>
                <cfquery name="query_upd_member_code" datasource="#dsn#">
                    UPDATE 
                        CONSUMER 
                    SET 
                        <cfif isdefined("attributes.member_code") and len(attributes.member_code)>
                            MEMBER_CODE=<cfqueryparam cfsqltype="CF_SQL_NVARCHAR" value="#trim(attributes.member_code)#">
                        <cfelse>
                            MEMBER_CODE = <cfqueryparam cfsqltype="CF_SQL_NVARCHAR" value="B#query_get_max_cons.max_cons#">
                        </cfif>
                    WHERE 
                        CONSUMER_ID = #query_get_max_cons.max_cons#
                </cfquery>
                <cfquery name="query_add_comp_period" datasource="#dsn#">
                    INSERT INTO
                        CONSUMER_PERIOD
                    (
                        CONSUMER_ID,
                        PERIOD_ID,
                        ACCOUNT_CODE
                    )
                    VALUES
                    (
                        #query_get_max_cons.max_cons#,
                        #logindata.PERIOD_ID#,
                        <cfif isdefined("acc") and len(acc)><cfqueryparam cfsqltype="CF_SQL_NVARCHAR" value="#acc#"><cfelse>NULL</cfif>
                    )
                </cfquery>
                <cfquery name="query_add_branch_related" datasource="#dsn#">
                    INSERT INTO
                    COMPANY_BRANCH_RELATED
                    (
                        CONSUMER_ID,
                        OUR_COMPANY_ID,
                        BRANCH_ID,
                        OPEN_DATE,
                        RECORD_EMP,
                        RECORD_DATE,
                        RECORD_IP
                    )
                    VALUES
                    (
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#query_get_max_cons.max_cons#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#logindata.OUR_COMPANY_ID#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#branchdata.LOCATION_ID#">,
                        <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#logindata.EMPLOYEE_ID#">,
                        <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                        <cfqueryparam cfsqltype="CF_SQL_NVARCHAR" value="#cgi.remote_addr#">
                    )
                </cfquery>

            </cfif>
            
            <cfif arguments.bodydata.CUSTOMERID eq 0 and arguments.bodydata.CUSTOMERTYPE eq 1>

                <cfquery name="query_add_company" datasource="#dsn#">
                    INSERT INTO 
                    COMPANY
                    (
                        COMPANY_STATUS,
                        COMPANYCAT_ID,
                        COMPANY_STATE,
                        PERIOD_ID,
                        MEMBER_CODE,
                        FULLNAME,
                        NICKNAME,
                        TAXOFFICE,
                        TAXNO,
                        COMPANY_EMAIL,
                        COMPANY_TELCODE,
                        COMPANY_TEL1,
                        COMPANY_FAX,												
                        COMPANY_ADDRESS,
                        COUNTY,
                        CITY,
                        COUNTRY,
                        IS_SELLER,
                        IS_BUYER,
                        IMS_CODE_ID,
                        MOBIL_CODE,
                        MOBILTEL,
                        RECORD_EMP,
                        RECORD_IP,
                        RECORD_DATE,
                        IS_PERSON
                    )
                    VALUES
                    (
                        1,
                        <cfif isdefined("attributes.comp_member_cat") and len(attributes.comp_member_cat)>#comp_member_cat#,<cfelse>#attributes.company_cat_id#,</cfif>
                        #attributes.COMPANY_STAGE#,
                        #logindata.PERIOD_ID#,
                        <cfif isDefined("attributes.member_code") and len(attributes.member_code)><cfqueryparam cfsqltype="CF_SQL_NVARCHAR" value="#attributes.member_code#"><cfelse>NULL</cfif>,
                        <cfqueryparam cfsqltype="CF_SQL_NVARCHAR" value="#arguments.bodydata.TITLE#">,
                        <cfqueryparam cfsqltype="CF_SQL_NVARCHAR" value="#arguments.bodydata.TITLE#">,
                        <cfif isDefined("attributes.tax_office") and len(attributes.tax_office)><cfqueryparam cfsqltype="CF_SQL_NVARCHAR" value="#attributes.tax_office#"><cfelse>NULL</cfif>,
                        <cfif isDefined("attributes.tax_num") and len(attributes.tax_num)><cfqueryparam cfsqltype="CF_SQL_NVARCHAR" value="#attributes.tax_num#"><cfelse>NULL</cfif>,
                        <cfif isdefined("attributes.email") and len(attributes.email)><cfqueryparam cfsqltype="CF_SQL_NVARCHAR" value="#trim(attributes.email)#"><cfelse>NULL</cfif>,
                        <cfif isDefined("attributes.tel_code") and len(attributes.tel_code)><cfqueryparam cfsqltype="CF_SQL_NVARCHAR" value="#attributes.tel_code#"><cfelse>NULL</cfif>,
                        <cfif isDefined("attributes.tel_number") and len(attributes.tel_number)><cfqueryparam cfsqltype="CF_SQL_NVARCHAR" value="#attributes.tel_number#"><cfelse>NULL</cfif>,				
                        <cfif isdefined("attributes.fax_number") and len(attributes.fax_number)><cfqueryparam cfsqltype="CF_SQL_NVARCHAR" value="#attributes.fax_number#"><cfelse>NULL</cfif>,
                        <cfif isDefined("attributes.address") and len(attributes.address)><cfqueryparam cfsqltype="CF_SQL_NVARCHAR" value="#attributes.address#"><cfelse>NULL</cfif>,
                        <cfif isDefined("attributes.county_id") and len(attributes.county_id)>#attributes.county_id#<cfelse>NULL</cfif>,
                        <cfif isDefined("attributes.city") and len(attributes.city)>#attributes.city#<cfelse>NULL</cfif>,
                        1,
                        0,
                        1,
                        <cfif isdefined("attributes.ims_code_id") and len(attributes.ims_code_id)>#attributes.ims_code_id#<cfelse>NULL</cfif>,
                        <cfif isdefined("attributes.mobil_code") and len(attributes.mobil_code)><cfqueryparam cfsqltype="CF_SQL_NVARCHAR" value="#attributes.mobil_code#"><cfelse>NULL</cfif>,
                        <cfif isdefined("attributes.mobil_tel") and len(attributes.mobil_tel)><cfqueryparam cfsqltype="CF_SQL_NVARCHAR" value="#attributes.mobil_tel#"><cfelse>NULL</cfif>,
                        #logindata.EMPLOYEE_ID#,
                        <cfqueryparam cfsqltype="CF_SQL_NVARCHAR" value="#cgi.remote_addr#">,
                        #now()#,
                        <cfif isdefined("attributes.is_person")>1<cfelse>0</cfif>			
                    )
                </cfquery>
                <cfquery name="query_company_max" datasource="#dsn#">
                    SELECT MAX(COMPANY_ID) MAX_COMPANY FROM COMPANY
                </cfquery>
                <cfset attributes.COMPANY_ID = query_company_max.MAX_COMPANY>

                <cfquery name="query_add_comp_period" datasource="#dsn#">
                    INSERT INTO
                        COMPANY_PERIOD
                    (
                        COMPANY_ID,
                        PERIOD_ID
                    )
                    VALUES
                    (
                        #query_company_max.max_company#,
                        #logindata.PERIOD_ID#
                    )
                </cfquery>
                <cfquery name="query_add_partner" datasource="#dsn#">
                    INSERT INTO 
                        COMPANY_PARTNER 
                    (
                        COMPANY_ID,
                        COMPANY_PARTNER_NAME,
                        COMPANY_PARTNER_SURNAME,
                        COMPANY_PARTNER_EMAIL,
                        MOBIL_CODE,
                        MOBILTEL,
                        COMPANY_PARTNER_TELCODE,
                        COMPANY_PARTNER_TEL,
                        COMPANY_PARTNER_FAX,					
                        MEMBER_TYPE,					
                        COMPANY_PARTNER_ADDRESS,
                        COUNTY,
                        CITY,
                        RECORD_DATE,
                        RECORD_MEMBER,
                        RECORD_IP,
                        TC_IDENTITY	
                    )
                    VALUES
                    (
                        #attributes.COMPANY_ID#,
                        <cfqueryparam cfsqltype="CF_SQL_NVARCHAR" value="#attributes.member_name#">,
                        <cfqueryparam cfsqltype="CF_SQL_NVARCHAR" value="#attributes.member_surname#">,
                        <cfif isdefined("attributes.email") and len(attributes.email)><cfqueryparam cfsqltype="CF_SQL_NVARCHAR" value="#attributes.email#"><cfelse>NULL</cfif>,
                        <cfif isDefined("attributes.mobil_code") and len(attributes.mobile_code)><cfqueryparam cfsqltype="CF_SQL_NVARCHAR" value="#attributes.mobil_code#"><cfelse>NULL</cfif>,
                        <cfif isDefined("attributes.mobil_tel") and len(attributes.mobil_tel)><cfqueryparam cfsqltype="CF_SQL_NVARCHAR" value="#attributes.mobil_tel#"><cfelse>NULL</cfif>,
                        <cfif isDefined("attributes.tel_code") and len(attributes.tel_code)><cfqueryparam cfsqltype="CF_SQL_NVARCHAR" value="#attributes.tel_code#"><cfelse>NULL</cfif>,
                        <cfif isDefined("attributes.tel_number") and len(attributes.tel_number)><cfqueryparam cfsqltype="CF_SQL_NVARCHAR" value="#attributes.tel_number#"><cfelse>NULL</cfif>,
                        <cfif isdefined("attributes.fax_number") and len(attributes.fax_number)><cfqueryparam cfsqltype="CF_SQL_NVARCHAR" value="#attributes.fax_number#"><cfelse>NULL</cfif>,
                        1,
                        <cfif isDefined("attributes.address") and len(attributes.address)><cfqueryparam cfsqltype="CF_SQL_NVARCHAR" value="#attributes.address#"><cfelse>NULL</cfif>,
                        <cfif isDefined("attributes.county_id") and len(attributes.county_id)>#attributes.county_id#<cfelse>NULL</cfif>,
                        <cfif isDefined("attributes.city") and len(attributes.city)>#attributes.city#<cfelse>NULL</cfif>,
                        #now()#,
                        #logindata.EMPLOYEE_ID#,
                        <cfqueryparam cfsqltype="CF_SQL_NVARCHAR" value="#cgi.remote_addr#">,
                        <cfif isdefined("attributes.tc_num") and len(attributes.tc_num)>'#attributes.tc_num#'<cfelse>NULL</cfif>
                    )
                </cfquery>
                <cfquery name="query_max_partner" datasource="#dsn#">
                    SELECT
                        MAX(PARTNER_ID) MAX_PARTNER_ID
                    FROM
                        COMPANY_PARTNER
                </cfquery>
                <cfset attributes.partner_id = query_max_partner.max_partner_id>
                <cfquery name="query_upd_member_code" datasource="#dsn#">
                    UPDATE
                        COMPANY_PARTNER
                    SET
                        MEMBER_CODE = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="CP#query_max_partner.max_partner_id#">
                    WHERE
                        PARTNER_ID = #query_max_partner.max_partner_id#
                </cfquery>
                <cfquery name="query_add_company_partner_detail" datasource="#dsn#">
                    INSERT INTO
                        COMPANY_PARTNER_DETAIL
                    (
                        PARTNER_ID
                    )
                    VALUES
                    (
                        #query_max_partner.max_partner_id#
                    )
                </cfquery>
                <cfquery name="query_add_part_settings" datasource="#dsn#">
                    INSERT INTO 
                        MY_SETTINGS_P 
                    (
                        PARTNER_ID,
                        TIME_ZONE,
                        MAXROWS,
                        TIMEOUT_LIMIT
                    )
                    VALUES 
                    (
                        #query_max_partner.max_partner_id#,
                        0,
                        20,
                        30
                    )
                </cfquery>

                <cfquery name="query_upd_member_code" datasource="#dsn#">
                    UPDATE 
                        COMPANY 
                    SET		
                    <cfif isdefined("attributes.company_code") and len(attributes.company_code)>
                        MEMBER_CODE=<cfqueryparam cfsqltype="CF_SQL_NVARCHAR" value="#attributes.company_code#">
                    <cfelse>
                        MEMBER_CODE=<cfqueryparam cfsqltype="CF_SQL_NVARCHAR" value="C#query_company_max.max_company#">
                    </cfif>
                    WHERE 
                        COMPANY_ID = #query_company_max.max_company#
                </cfquery>
                <cfquery name="query_add_branch_related" datasource="#dsn#">
                    INSERT INTO
                        COMPANY_BRANCH_RELATED
                    (
                        COMPANY_ID,
                        OUR_COMPANY_ID,
                        BRANCH_ID,
                        OPEN_DATE,
                        RECORD_EMP,
                        RECORD_DATE,
                        RECORD_IP
                    )
                    VALUES
                    (
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#query_company_max.max_company#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#logindata.OUR_COMPANY_ID#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#branchdata.LOCATION_ID#">,
                        <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#logindata.EMPLOYEE_ID#">,
                        <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                        <cfqueryparam cfsqltype="CF_SQL_NVARCHAR" value="#cgi.remote_addr#">
                    )
                </cfquery>
            </cfif>

            <cfif len(arguments.bodydata.CUSTOMERID) and arguments.bodydata.CUSTOMERID neq 0 and arguments.bodydata.CUSTOMERTYPE eq 1>
                <cfquery name="query_get_partner_id" datasource="#dsn#">
                    SELECT PARTNER_ID FROM COMPANY_PARTNER WHERE COMPANY_ID = #arguments.bodydata.CUSTOMERID#
                </cfquery>
                <cfset attributes.partner_id = query_get_partner_id.PARTNER_ID>
            </cfif>
            
            <cfquery name="query_add_invoice" result="result_add_invoice" datasource="#dsn#">
                INSERT INTO #dsn2##schema_ext#.INVOICE
                    (
                
                    WRK_ID,
                    IS_CASH,
                    PURCHASE_SALES,
                    INVOICE_NUMBER,
                    SERIAL_NUMBER,
                    SERIAL_NO,
                    INVOICE_CAT,
                    INVOICE_DATE,
                    DUE_DATE,
                    COMPANY_ID,
                    PARTNER_ID,
                    CONSUMER_ID,
                    NETTOTAL,
                    GROSSTOTAL,
                    TAXTOTAL,
                    OTV_TOTAL,
                    SA_DISCOUNT,
                    NOTE,
                    <cfif isDefined("attributes.EMPO_ID") and len(attributes.EMPO_ID)>
                        <cfif attributes.EMPO_ID neq 0>SALE_EMP,<cfelse>SALE_PARTNER,</cfif>
                    </cfif>
                    DELIVER_EMP, 
                    DEPARTMENT_ID,
                    DEPARTMENT_LOCATION,
                    RECORD_DATE,
                    RECORD_EMP,
                    SHIP_METHOD,
                    UPD_STATUS,
                    OTHER_MONEY,
                    OTHER_MONEY_VALUE,
                    IS_WITH_SHIP,
                    PROCESS_CAT,
                    ASSETP_ID
                )
                VALUES
                (
                    <cfqueryparam cfsqltype="CF_SQL_NVARCHAR" value="#wrk_id#">,
                    NULL,
                    1,
                    <cfqueryparam cfsqltype="CF_SQL_NVARCHAR" value="#attributes.PAPER#">,
                    <cfif arguments.bodydata.PERAKENDE>
                    <cfqueryparam cfsqltype="CF_SQL_NVARCHAR" value="#attributes.SERIAL_NUMBER#">,
                    <cfqueryparam cfsqltype="CF_SQL_NVARCHAR" value="#attributes.SERIAL_NO#">,
                    <cfelse>
                    NULL,
                    NULL,
                    </cfif>
                    #INVOICE_CAT#,
                    #now()#,
                    <cfif isdefined("invoice_due_date") and len(invoice_due_date)>#invoice_due_date#<cfelse>NULL</cfif>,
                    <cfif arguments.bodydata.CUSTOMERTYPE eq 1>
                        <cfif len(attributes.company_id)>#attributes.company_id#<cfelse>NULL</cfif>,
                        <cfif len(attributes.partner_id)>#attributes.partner_id#<cfelse>NULL</cfif>,
                        NULL,
                    <cfelse>
                        NULL,
                        NULL,
                        <cfif len(attributes.consumer_id)>#attributes.consumer_id#<cfelse>NULL</cfif>,
                    </cfif>
                    #BASKET_NET_TOTAL#,
                    #BASKET_GROSS_TOTAL#,
                    #BASKET_TAX_TOTAL#,
                    <cfif isDefined("form.basket_otv_total") and len(form.basket_otv_total)>#form.basket_otv_total#<cfelse>NULL</cfif>,
                    #arguments.bodydata.INDIRIM * invoiceMoneyRate#,
                    <cfif isDefined("NOTE") and len(NOTE)><cfqueryparam cfsqltype="CF_SQL_NVARCHAR" value="#NOTE#"><cfelse>NULL</cfif>,
                    <cfif isDefined("attributes.EMPO_ID") and len(attributes.EMPO_ID)>
                        <cfif attributes.EMPO_ID neq 0>#EMPO_ID#<cfelse>#PARTO_ID#</cfif>,
                    </cfif>
                    '',
                    #branchdata.DEPARTMENT_ID#,
                    #branchdata.LOCATION_ID#,
                    #NOW()#,
                    #logindata.EMPLOYEE_ID#,
                    <cfif isdefined('attributes.ship_method') and len(attributes.ship_method)>#attributes.ship_method#<cfelse>NULL</cfif>,
                    1,
                    '#arguments.bodydata.MONEY#',
                    #BASKET_NET_TOTAL * invoiceMoneyRate#,
                    0,
                    #attributes.PROCESS_CAT#,
                <cfif isdefined("attributes.asset_id") and len(attributes.asset_id) and len(attributes.asset_name)>#attributes.asset_id#<cfelse>NULL</cfif>
                )
            </cfquery>

            <cfset invoice_id = result_add_invoice.IDENTITYCOL>

            <cfquery name="query_add_money" datasource="#dsn#">
                INSERT INTO #dsn2##schema_ext#.INVOICE_MONEY (
                    MONEY_TYPE,
                    ACTION_ID,
                    RATE2,
                    RATE1,
                    IS_SELECTED
                )
                SELECT [MONEY], #invoice_id#, RATE2, 1,
                CASE
                    WHEN [MONEY] = '#arguments.bodydata.MONEY#' THEN 1
                    ELSE 0
                END
                FROM SETUP_MONEY 
                WHERE COMPANY_ID = #company_id# AND PERIOD_ID = #period_id#
            </cfquery>
            
            <cfquery name="query_add_sale" datasource="#dsn#">
                INSERT INTO #dsn2##schema_ext#.SHIP
                    (
                    WRK_ID,
                    PURCHASE_SALES,
                    SHIP_NUMBER,
                    SHIP_TYPE,
                    PROCESS_CAT,
                    SHIP_DATE,
                    DELIVER_DATE,
                    COMPANY_ID,
                    PARTNER_ID,
                    CONSUMER_ID,
                    DELIVER_EMP, 
                    DISCOUNTTOTAL,
                    NETTOTAL,
                    GROSSTOTAL,
                    TAXTOTAL,
                    ADDRESS,
                    DELIVER_STORE_ID,
                    LOCATION,
                    RECORD_DATE,
                    RECORD_EMP,
                    IS_WITH_SHIP,
                    SHIP_DETAIL
                    )
                VALUES
                    (
                    <cfqueryparam cfsqltype="CF_SQL_NVARCHAR" value="#wrk_id#">,
                    1,
                    <cfqueryparam cfsqltype="CF_SQL_NVARCHAR" value="#invoice_id#">,
                    #ship_process_type#,
                    NULL,
                    #now()#,
                    #now()#,
                    <cfif arguments.bodydata.CUSTOMERTYPE eq 1>
                        <cfif len(attributes.company_id)>#attributes.company_id#<cfelse>NULL</cfif>,
                        <cfif len(attributes.partner_id)>#attributes.partner_id#<cfelse>NULL</cfif>,
                        NULL,
                    <cfelse>
                        NULL,
                        NULL,
                        <cfif len(attributes.consumer_id)>#attributes.consumer_id#<cfelse>NULL</cfif>,
                    </cfif>
                    '',
                    #arguments.bodydata.INDIRIM * invoiceMoneyRate#,
                    #BASKET_NET_TOTAL#,
                    #BASKET_GROSS_TOTAL#,
                    #BASKET_TAX_TOTAL#,
                    <cfqueryparam cfsqltype="CF_SQL_NVARCHAR" value="">,
                    #branchdata.DEPARTMENT_ID#,
                    #branchdata.LOCATION_ID#,
                    #NOW()#,
                    #logindata.EMPLOYEE_ID#,
                    1,
                    <cfif isDefined("note") and len(note)><cfqueryparam cfsqltype="CF_SQL_NVARCHAR" value="#note#"><cfelse>NULL</cfif>
                    )
            </cfquery>	
            <cfquery name="query_get_ship_id" datasource="#dsn#">
                SELECT SHIP_ID AS MAX_ID,SHIP_NUMBER,SHIP_TYPE FROM #dsn2##schema_ext#.SHIP 
                WHERE WRK_ID = <cfqueryparam cfsqltype="CF_SQL_NVARCHAR" value="#wrk_id#"> AND SHIP_ID = (SELECT MAX(SHIP_ID) AS MAX_ID FROM #dsn2##schema_ext#.SHIP WHERE WRK_ID = <cfqueryparam cfsqltype="CF_SQL_NVARCHAR" value="#wrk_id#">)
            </cfquery>

            <cfset i=1>
            <cfloop array="#arguments.bodydata.rows#" index="row">
                <cfset ri = row>
                <cfquery name="query_get_units" datasource="#dsn#">
                    SELECT 
                        PRODUCT_UNIT.ADD_UNIT,
                        PRODUCT_UNIT.MULTIPLIER,
                        PRODUCT_UNIT.MAIN_UNIT,
                        PRODUCT_UNIT.MAIN_UNIT_ID,
                        PRODUCT_UNIT.PRODUCT_UNIT_ID
                    FROM
                        #dsn3##schema_ext#.STOCKS
                        INNER JOIN #dsn3##schema_ext#.PRODUCT_UNIT ON STOCKS.PRODUCT_ID = PRODUCT_UNIT.PRODUCT_ID 
                    WHERE 
                        STOCKS.STOCK_ID = #ri["stockid"]#
                </cfquery>
                <cfif query_get_units.recordcount and len(query_get_units.MULTIPLIER)>
                    <cfset multi = query_get_units.MULTIPLIER * ri["amount"]>
                <cfelse>
                    <cfset multi = ri["amount"]>
                </cfif>
                <cfquery name="query_product" datasource="#dsn#">
                    SELECT TOP 1 PRODUCT_ID, PRODUCT_NAME FROM #dsn3##schema_ext#.STOCKS
                    WHERE STOCK_ID = #ri["stockid"]#
                </cfquery>
                <cfquery name="query_karma_products_stock" datasource="#dsn#"><!--- karma koli olan ürünler --->
                    SELECT PRODUCT.PRODUCT_ID, PRODUCT.PRODUCT_NAME, PRODUCT_UNIT.MAIN_UNIT, STOCKS.PRODUCT_UNIT_ID
                    FROM #dsn3##schema_ext#.PRODUCT
                    INNER JOIN #dsn3##schema_ext#.STOCKS ON PRODUCT.PRODUCT_ID = STOCKS.PRODUCT_ID 
                    INNER JOIN #dsn1##schema_ext#.PRODUCT_UNIT ON STOCKS.PRODUCT_UNIT_ID = PRODUCT_UNIT.PRODUCT_UNIT_ID
                    WHERE STOCKS.STOCK_ID = #ri["stockid"]# AND PRODUCT.IS_KARMA = 1
                </cfquery>

                <cfif query_karma_products_stock.recordcount>
                    <cfquery name="query_karma_products" datasource="#dsn#">
                        SELECT PRODUCT_ID,STOCK_ID,SPEC_MAIN_ID,PRODUCT_AMOUNT,PRODUCT_NAME
                        FROM #dsn1##schema_ext#.KARMA_PRODUCTS
                        WHERE KARMA_PRODUCT_ID = #query_product.PRODUCT_ID#
                    </cfquery>
                    <cfset pricefact = query_karma_products.recordcount>
                    <cfloop query="query_karma_products">
                        <cfquery name="query_add_row" result="result_add_row" datasource="#dsn#">
                            INSERT INTO
                            #dsn2##schema_ext#.INVOICE_ROW
                            (
                                PURCHASE_SALES,
                                PRODUCT_ID,
                                NAME_PRODUCT,
                                INVOICE_ID,
                                STOCK_ID,
                                AMOUNT,
                                UNIT,
                                UNIT_ID,				
                                PRICE,
                                DISCOUNTTOTAL,
                                GROSSTOTAL,
                                NETTOTAL,
                                TAXTOTAL,
                                TAX,
                                DUE_DATE,
                                DISCOUNT1,
                                DISCOUNT2,
                                DISCOUNT3,
                                DISCOUNT4,
                                DISCOUNT5,
                                DISCOUNT6,
                                DISCOUNT7,
                                DISCOUNT8,
                                DISCOUNT9,
                                DISCOUNT10,				
                                DELIVER_DATE,
                                DELIVER_DEPT,
                                DELIVER_LOC,
                                OTHER_MONEY,
                                OTHER_MONEY_VALUE,
                                LOT_NO,
                                PRICE_OTHER,
                                OTHER_MONEY_GROSS_TOTAL,
                                <!--- COST_ID, --->
                                COST_PRICE,
                                MARGIN,
                                SHIP_ID,
                                SHIP_PERIOD_ID,
                                DISCOUNT_COST,
                                IS_PROMOTION,
                                UNIQUE_RELATION_ID,
                                PROM_RELATION_ID,
                                PRODUCT_NAME2,
                                AMOUNT2,
                                UNIT2,
                                EXTRA_PRICE,
                                EXTRA_PRICE_TOTAL,
                                SHELF_NUMBER,
                                PRODUCT_MANUFACT_CODE,
                                BASKET_EXTRA_INFO_ID,
                                BASKET_EMPLOYEE_ID,
                                OTV_ORAN,
                                OTVTOTAL,
                                PROM_ID,
                                PROM_COMISSION,
                                PROM_STOCK_ID,				
                                IS_COMMISSION,				
                                PRICE_CAT,
                                CATALOG_ID,
                                PROM_COST,
                                WRK_ROW_ID,
                                WRK_ROW_RELATION_ID,
                                WIDTH_VALUE,
                                DEPTH_VALUE,
                                HEIGHT_VALUE,
                                ROW_PROJECT_ID
                            )
                            VALUES
                            (
                                1,
                                #query_karma_products.product_id#,
                                '#query_karma_products.PRODUCT_NAME#',
                                #INVOICE_ID#,
                                #query_karma_products.stock_id#,
                                #multi#,
                                '#query_karma_products_stock.MAIN_UNIT#',
                                #query_karma_products_stock.PRODUCT_UNIT_ID#,
                                #row["price"]/pricefact*moneyratesarr[ arrayFind( moneynamesArr, row["money"] ) ]#,
                                0,
                                #row["price"]/pricefact*multi*moneyratesarr[ arrayFind( moneynamesArr, row["money"] ) ]#,
                                #row["price"]/pricefact*multi*(100+row["tax"])/100*moneyratesarr[ arrayFind( moneynamesArr, row["money"] ) ]#,
                                #row["price"]/pricefact*multi*row["tax"]/100*moneyratesarr[ arrayFind( moneynamesArr, row["money"] ) ]#,
                                #row["tax"]#,
                                <cfif isdefined("attributes.duedate#i#") and len(Evaluate("attributes.duedate#i#"))>#Evaluate("attributes.duedate#i#")#<cfelse>0</cfif>,
                                0,
                                0,
                                0,
                                0,
                                0,
                                0,
                                0,
                                0,
                                0,
                                0,					
                                <cfif isdefined('attributes.deliver_date#i#') and isdate(evaluate('attributes.deliver_date#i#'))>#evaluate('attributes.deliver_date#i#')#,<cfelse>NULL,</cfif>
                                #branchdata.DEPARTMENT_ID#,
                                #branchdata.LOCATION_ID#,
                                '#row["money"]#',
                                #row["price"]/pricefact*multi#,
                                NULL,
                                #row["price"]/pricefact#,
                                #row["price"]/pricefact*multi*(100+row["tax"])/100#,
                                0,
                                NULL,
                                NULL,
                                #logindata.PERIOD_ID#,
                                <cfif isdefined('attributes.iskonto_tutar#i#') and len(evaluate('attributes.iskonto_tutar#i#'))>#evaluate('attributes.iskonto_tutar#i#')#<cfelse>NULL</cfif>,
                                <cfif isdefined('attributes.is_promotion#i#') and len(evaluate('attributes.is_promotion#i#'))>#evaluate('attributes.is_promotion#i#')#<cfelse>0</cfif>,
                                <cfif isdefined('attributes.row_unique_relation_id#i#') and len(evaluate('attributes.row_unique_relation_id#i#'))><cfqueryparam cfsqltype="CF_SQL_NVARCHAR" value="#wrk_eval('attributes.row_unique_relation_id#i#')#"><cfelse>NULL</cfif>,
                                <cfif isdefined('attributes.prom_relation_id#i#') and len(evaluate('attributes.prom_relation_id#i#'))><cfqueryparam cfsqltype="CF_SQL_NVARCHAR" value="#wrk_eval('attributes.prom_relation_id#i#')#"><cfelse>NULL</cfif>,
                                <cfif isdefined('attributes.product_name_other#i#') and len(evaluate('attributes.product_name_other#i#'))><cfqueryparam cfsqltype="CF_SQL_NVARCHAR" value="#wrk_eval('attributes.product_name_other#i#')#"><cfelse>NULL</cfif>,
                                <cfif isdefined('attributes.amount_other#i#') and len(evaluate('attributes.amount_other#i#'))>#evaluate('attributes.amount_other#i#')#<cfelse>NULL</cfif>,
                                <cfif isdefined('attributes.unit_other#i#') and len(evaluate('attributes.unit_other#i#'))><cfqueryparam cfsqltype="CF_SQL_NVARCHAR" value="#wrk_eval('attributes.unit_other#i#')#"><cfelse>NULL</cfif>,
                                <cfif isdefined('attributes.ek_tutar#i#') and len(evaluate('attributes.ek_tutar#i#'))>#evaluate('attributes.ek_tutar#i#')#<cfelse>NULL</cfif>,
                                <cfif isdefined('attributes.ek_tutar_total#i#') and len(evaluate('attributes.ek_tutar_total#i#'))>#evaluate('attributes.ek_tutar_total#i#')#<cfelse>NULL</cfif>,
                                <cfif isdefined('attributes.shelf_number#i#') and len(evaluate('attributes.shelf_number#i#'))>#evaluate('attributes.shelf_number#i#')#<cfelse>NULL</cfif>,
                                <cfif isdefined('attributes.manufact_code#i#') and len(evaluate('attributes.manufact_code#i#'))><cfqueryparam cfsqltype="CF_SQL_NVARCHAR" value="#wrk_eval('attributes.manufact_code#i#')#"><cfelse>NULL</cfif>,
                                <cfif isdefined('attributes.basket_extra_info#i#') and len(evaluate('attributes.basket_extra_info#i#'))>#evaluate('attributes.basket_extra_info#i#')#<cfelse>NULL</cfif>,
                                <cfif isdefined('attributes.basket_employee_id#i#') and len(evaluate('attributes.basket_employee_id#i#')) and isdefined('attributes.basket_employee#i#') and len(evaluate('attributes.basket_employee#i#'))>#evaluate('attributes.basket_employee_id#i#')#<cfelse>NULL</cfif>,
                                <cfif isdefined('attributes.otv_oran#i#') and len(evaluate('attributes.otv_oran#i#'))><cfqueryparam cfsqltype="CF_SQL_NVARCHAR" value="#wrk_eval('attributes.otv_oran#i#')#"><cfelse>NULL</cfif>,
                                <cfif isdefined('attributes.row_otvtotal#i#') and len(evaluate('attributes.row_otvtotal#i#'))>#evaluate('attributes.row_otvtotal#i#')#<cfelse>NULL</cfif>,
                                <cfif isdefined('attributes.row_promotion_id#i#') and len(evaluate('attributes.row_promotion_id#i#'))>#evaluate('attributes.row_promotion_id#i#')#<cfelse>NULL</cfif>,
                                <cfif isdefined('attributes.promosyon_yuzde#i#') and len(evaluate('attributes.promosyon_yuzde#i#'))>#evaluate('attributes.promosyon_yuzde#i#')#<cfelse>NULL</cfif>,
                                <cfif isdefined('attributes.prom_stock_id#i#') and len(evaluate('attributes.prom_stock_id#i#'))>#evaluate('attributes.prom_stock_id#i#')#<cfelse>NULL</cfif>,
                                0,
                                <cfif isdefined('attributes.price_cat#i#') and len(evaluate('attributes.price_cat#i#'))>#evaluate('attributes.price_cat#i#')#<cfelse>NULL</cfif>,
                                <cfif isdefined('attributes.row_catalog_id#i#') and len(evaluate('attributes.row_catalog_id#i#'))>#evaluate('attributes.row_catalog_id#i#')#<cfelse>NULL</cfif>,
                                0,
                                <cfif isdefined('attributes.wrk_row_id#i#') and len(evaluate('attributes.wrk_row_id#i#'))><cfqueryparam cfsqltype="CF_SQL_NVARCHAR" value="#wrk_eval('attributes.wrk_row_id#i#')#"><cfelse>NULL</cfif>,
                                <cfif isdefined('attributes.wrk_row_relation_id#i#') and len(evaluate('attributes.wrk_row_relation_id#i#'))><cfqueryparam cfsqltype="CF_SQL_NVARCHAR" value="#wrk_eval('attributes.wrk_row_relation_id#i#')#"><cfelse>NULL</cfif>,
                                <cfif isdefined('attributes.row_width#i#') and len(evaluate('attributes.row_width#i#'))>#evaluate('attributes.row_width#i#')#<cfelse>NULL</cfif>,
                                <cfif isdefined('attributes.row_depth#i#') and len(evaluate('attributes.row_depth#i#'))>#evaluate('attributes.row_depth#i#')#<cfelse>NULL</cfif>,
                                <cfif isdefined('attributes.row_height#i#') and len(evaluate('attributes.row_height#i#'))>#evaluate('attributes.row_height#i#')#<cfelse>NULL</cfif>,
                                <cfif isdefined('attributes.row_project_id#i#') and len(evaluate('attributes.row_project_id#i#')) and isdefined('attributes.row_project_name#i#') and len(evaluate('attributes.row_project_name#i#'))>#evaluate('attributes.row_project_id#i#')#<cfelse>NULL</cfif>
                            )
                        </cfquery>
                        <cfset row_temp_wrk_id="#round(rand()*65)##dateformat(now(),'YYYYMMDD')##timeformat(now(),'HHmmssL')##logindata.EMPLOYEE_ID##round(rand()*100)#">
                        <cfquery name="query_add_ship_row" datasource="#dsn#">
                            INSERT INTO #dsn2##schema_ext#.SHIP_ROW
                                (
                                NAME_PRODUCT,
                                SHIP_ID,
                                STOCK_ID,
                                PRODUCT_ID,
                                AMOUNT,
                                UNIT,
                                UNIT_ID,
                                TAX,
                                PRICE,
                                PURCHASE_SALES,
                                DISCOUNT,
                                DISCOUNT2,
                                DISCOUNT3,
                                DISCOUNT4,
                                DISCOUNT5,
                                DISCOUNT6,
                                DISCOUNT7,
                                DISCOUNT8,
                                DISCOUNT9,
                                DISCOUNT10,
                                DISCOUNTTOTAL,
                                GROSSTOTAL,
                                NETTOTAL,
                                TAXTOTAL,						
                                DELIVER_DATE,
                                DELIVER_DEPT,
                                DELIVER_LOC,
                                OTHER_MONEY,
                                OTHER_MONEY_VALUE,
                                OTHER_MONEY_GROSS_TOTAL,
                            <cfif isdefined("attributes.spect_id#i#") and len(evaluate("attributes.spect_id#i#"))>
                                SPECT_VAR_ID,
                                SPECT_VAR_NAME,
                            </cfif>
                                LOT_NO,
                                PRICE_OTHER,
                                IS_PROMOTION,
                                DISCOUNT_COST,
                                UNIQUE_RELATION_ID,
                                PROM_RELATION_ID,
                                PRODUCT_NAME2,
                                AMOUNT2,
                                UNIT2,
                                EXTRA_PRICE,
                                EXTRA_PRICE_TOTAL,
                                SHELF_NUMBER,
                                PRODUCT_MANUFACT_CODE,
                                BASKET_EMPLOYEE_ID,
                                LIST_PRICE,
                                PRICE_CAT,
                                CATALOG_ID,
                                NUMBER_OF_INSTALLMENT,
                                WRK_ROW_ID,
                                WRK_ROW_RELATION_ID,
                                OTV_ORAN,
                                OTVTOTAL,
                                WIDTH_VALUE,
                                DEPTH_VALUE,
                                HEIGHT_VALUE,
                                ROW_PROJECT_ID
                                )
                            VALUES
                                (
                                '#query_karma_products.PRODUCT_NAME#',
                                #query_get_ship_id.MAX_ID#,
                                #query_karma_products.stock_id#,
                                #query_karma_products.product_id#,
                                #multi#,
                                '#query_karma_products_stock.MAIN_UNIT#',
                                #query_karma_products_stock.PRODUCT_UNIT_ID#,
                                #row["tax"]#,
                                #row["price"]/pricefact#,
                                1,
                                0,
                                0,
                                0,
                                0,
                                0,
                                0,
                                0,
                                0,
                                0,
                                0,
                                0,
                                #row["price"]/pricefact*multi#,
                                #row["price"]/pricefact*multi*(100+row["tax"])/100#,
                                #row["price"]/pricefact*multi*row["tax"]/100#,						
                                <cfif isdefined('attributes.deliver_date#i#') and isdate(evaluate('attributes.deliver_date#i#'))>#evaluate('attributes.deliver_date#i#')#,<cfelse>NULL,</cfif>
                                #branchdata.DEPARTMENT_ID#,
                                #branchdata.LOCATION_ID#,
                                'TL',
                                #row["price"]/pricefact*multi#,
                                #row["price"]/pricefact*multi*(100+row["tax"])/100#,
                                <cfif isdefined("attributes.spect_id#i#") and len(evaluate("attributes.spect_id#i#"))>
                                    #evaluate("attributes.spect_id#i#")#,
                                    <cfqueryparam cfsqltype="CF_SQL_NVARCHAR" value="#wrk_eval('attributes.spect_name#i#')#">,
                                </cfif>
                                <cfif isdefined("attributes.lot_no#i#") and len(evaluate("attributes.lot_no#i#"))><cfqueryparam cfsqltype="CF_SQL_NVARCHAR" value="#wrk_eval('attributes.lot_no#i#')#"><cfelse>NULL</cfif>,
                                <cfif isdefined("attributes.price_other#i#") and len(evaluate("attributes.price_other#i#"))>#evaluate("attributes.price_other#i#")#<cfelse>NULL</cfif>,
                                    0,
                                <cfif isdefined('attributes.iskonto_tutar#i#') and len(evaluate('attributes.iskonto_tutar#i#'))>#evaluate('attributes.iskonto_tutar#i#')#<cfelse>NULL</cfif>,
                                <cfif isdefined('attributes.row_unique_relation_id#i#') and len(evaluate('attributes.row_unique_relation_id#i#'))><cfqueryparam cfsqltype="CF_SQL_NVARCHAR" value="#wrk_eval('attributes.row_unique_relation_id#i#')#"><cfelse>NULL</cfif>,
                                <cfif isdefined('attributes.prom_relation_id#i#') and len(evaluate('attributes.prom_relation_id#i#'))><cfqueryparam cfsqltype="CF_SQL_NVARCHAR" value="#wrk_eval('attributes.prom_relation_id#i#')#"><cfelse>NULL</cfif>,
                                <cfif isdefined('attributes.product_name_other#i#') and len(evaluate('attributes.product_name_other#i#'))><cfqueryparam cfsqltype="CF_SQL_NVARCHAR" value="#wrk_eval('attributes.product_name_other#i#')#"><cfelse>NULL</cfif>,
                                <cfif isdefined('attributes.amount_other#i#') and len(evaluate('attributes.amount_other#i#'))>#evaluate('attributes.amount_other#i#')#<cfelse>NULL</cfif>,
                                <cfif isdefined('attributes.unit_other#i#') and len(evaluate('attributes.unit_other#i#'))><cfqueryparam cfsqltype="CF_SQL_NVARCHAR" value="#wrk_eval('attributes.unit_other#i#')#"><cfelse>NULL</cfif>,
                                <cfif isdefined('attributes.ek_tutar#i#') and len(evaluate('attributes.ek_tutar#i#'))>#evaluate('attributes.ek_tutar#i#')#<cfelse>NULL</cfif>,
                                <cfif isdefined('attributes.ek_tutar_total#i#') and len(evaluate('attributes.ek_tutar_total#i#'))>#evaluate('attributes.ek_tutar_total#i#')#<cfelse>NULL</cfif>,
                                <cfif isdefined('attributes.shelf_number#i#') and len(evaluate('attributes.shelf_number#i#'))>#evaluate('attributes.shelf_number#i#')#<cfelse>NULL</cfif>,
                                <cfif isdefined('attributes.manufact_code#i#') and len(evaluate('attributes.manufact_code#i#'))><cfqueryparam cfsqltype="CF_SQL_NVARCHAR" value="#wrk_eval('attributes.manufact_code#i#')#"><cfelse>NULL</cfif>,
                                <cfif isdefined('attributes.basket_employee_id#i#') and len(evaluate('attributes.basket_employee_id#i#')) and isdefined('attributes.basket_employee#i#') and len(evaluate('attributes.basket_employee#i#'))>#evaluate('attributes.basket_employee_id#i#')#<cfelse>NULL</cfif>,
                                <cfif isdefined('attributes.list_price#i#') and len(evaluate('attributes.list_price#i#'))>#evaluate('attributes.list_price#i#')#<cfelse>NULL</cfif>,
                                <cfif isdefined('attributes.price_cat#i#') and len(evaluate('attributes.price_cat#i#'))>#evaluate('attributes.price_cat#i#')#<cfelse>NULL</cfif>,
                                <cfif isdefined('attributes.row_catalog_id#i#') and len(evaluate('attributes.row_catalog_id#i#'))>#evaluate('attributes.row_catalog_id#i#')#<cfelse>NULL</cfif>,
                                <cfif isdefined('attributes.number_of_installment#i#') and len(evaluate('attributes.number_of_installment#i#'))>#evaluate('attributes.number_of_installment#i#')#<cfelse>NULL</cfif>,
                                #row_temp_wrk_id#,
                                <cfif isdefined('attributes.wrk_row_id#i#') and len(evaluate('attributes.wrk_row_id#i#'))><cfqueryparam cfsqltype="CF_SQL_NVARCHAR" value="#wrk_eval('attributes.wrk_row_id#i#')#"><cfelse>NULL</cfif>,<!--- faturanın wrk_row_id si olusturdugu irsaliyenin wrk_row_relation_id sine gonderiliyor --->
                                <cfif isdefined('attributes.otv_oran#i#') and len(evaluate('attributes.otv_oran#i#'))><cfqueryparam cfsqltype="CF_SQL_NVARCHAR" value="#wrk_eval('attributes.otv_oran#i#')#"><cfelse>NULL</cfif>,
                                <cfif isdefined('attributes.row_otvtotal#i#') and len(evaluate('attributes.row_otvtotal#i#'))>#evaluate('attributes.row_otvtotal#i#')#<cfelse>NULL</cfif>,
                                <cfif isdefined('attributes.row_width#i#') and len(evaluate('attributes.row_width#i#'))>#evaluate('attributes.row_width#i#')#<cfelse>NULL</cfif>,
                                <cfif isdefined('attributes.row_depth#i#') and len(evaluate('attributes.row_depth#i#'))>#evaluate('attributes.row_depth#i#')#<cfelse>NULL</cfif>,
                                <cfif isdefined('attributes.row_height#i#') and len(evaluate('attributes.row_height#i#'))>#evaluate('attributes.row_height#i#')#<cfelse>NULL</cfif>,
                                <cfif isdefined('attributes.row_project_id#i#') and len(evaluate('attributes.row_project_id#i#')) and isdefined('attributes.row_project_name#i#') and len(evaluate('attributes.row_project_name#i#'))>#evaluate('attributes.row_project_id#i#')#<cfelse>NULL</cfif>
                                )
                        </cfquery>
                        <cfquery name="ADD_STOCK_ROW" datasource="#dsn#">
                            INSERT INTO #dsn2##schema_ext#.STOCKS_ROW
                                (
                                UPD_ID,
                                PRODUCT_ID,
                                STOCK_ID,
                                PROCESS_TYPE,
                                STOCK_OUT,
                                STORE,
                                STORE_LOCATION,
                                PROCESS_DATE,
                                SPECT_VAR_ID,
                                LOT_NO,
                                DELIVER_DATE,
                                SHELF_NUMBER,
                                PRODUCT_MANUFACT_CODE
                                )
                            VALUES
                                (
                                #query_get_ship_id.MAX_ID#,
                                #query_karma_products.product_id#,
                                #query_karma_products.stock_id#,
                                #ship_process_type#,
                                #multi#,
                                #branchdata.DEPARTMENT_ID#,
                                #branchdata.LOCATION_ID#,
                                #now()#,
                            <cfif isdefined('form_spect_main_id') and len(form_spect_main_id)>#form_spect_main_id#<cfelse>NULL</cfif>,<!--- <cfif isdefined("attributes.spect_id#i#") and len(evaluate("attributes.spect_id#i#"))>#evaluate("attributes.spect_id#i#")#<cfelse>NULL</cfif>, --->
                            <cfif isdefined("attributes.lot_no#i#") and len(evaluate("attributes.lot_no#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('attributes.lot_no#i#')#"><cfelse>NULL</cfif>,
                            <cfif isdefined('attributes.deliver_date#i#') and isdate(evaluate('attributes.deliver_date#i#'))>#evaluate('attributes.deliver_date#i#')#,<cfelse>NULL,</cfif>
                            <cfif isdefined('attributes.shelf_number#i#') and len(evaluate('attributes.shelf_number#i#'))>#evaluate('attributes.shelf_number#i#')#<cfelse>NULL</cfif>,
                            <cfif isdefined('attributes.manufact_code#i#') and len(evaluate('attributes.manufact_code#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('attributes.manufact_code#i#')#"><cfelse>NULL</cfif>
                                )
                        </cfquery>
                    </cfloop>
                <cfelse>
                    <cfquery name="query_add_row" result="result_add_row" datasource="#dsn#">
                        INSERT INTO
                        #dsn2##schema_ext#.INVOICE_ROW
                        (
                            PURCHASE_SALES,
                            PRODUCT_ID,
                            NAME_PRODUCT,
                            INVOICE_ID,
                            STOCK_ID,
                            AMOUNT,
                            UNIT,
                            UNIT_ID,				
                            PRICE,
                            DISCOUNTTOTAL,
                            GROSSTOTAL,
                            NETTOTAL,
                            TAXTOTAL,
                            TAX,
                            DUE_DATE,
                            DISCOUNT1,
                            DISCOUNT2,
                            DISCOUNT3,
                            DISCOUNT4,
                            DISCOUNT5,
                            DISCOUNT6,
                            DISCOUNT7,
                            DISCOUNT8,
                            DISCOUNT9,
                            DISCOUNT10,				
                            DELIVER_DATE,
                            DELIVER_DEPT,
                            DELIVER_LOC,
                            OTHER_MONEY,
                            OTHER_MONEY_VALUE,
                            LOT_NO,
                            PRICE_OTHER,
                            OTHER_MONEY_GROSS_TOTAL,
                            <!--- COST_ID, --->
                            COST_PRICE,
                            MARGIN,
                            SHIP_ID,
                            SHIP_PERIOD_ID,
                            DISCOUNT_COST,
                            IS_PROMOTION,
                            UNIQUE_RELATION_ID,
                            PROM_RELATION_ID,
                            PRODUCT_NAME2,
                            AMOUNT2,
                            UNIT2,
                            EXTRA_PRICE,
                            EXTRA_PRICE_TOTAL,
                            SHELF_NUMBER,
                            PRODUCT_MANUFACT_CODE,
                            BASKET_EXTRA_INFO_ID,
                            BASKET_EMPLOYEE_ID,
                            OTV_ORAN,
                            OTVTOTAL,
                            PROM_ID,
                            PROM_COMISSION,
                            PROM_STOCK_ID,				
                            IS_COMMISSION,				
                            PRICE_CAT,
                            CATALOG_ID,
                            PROM_COST,
                            WRK_ROW_ID,
                            WRK_ROW_RELATION_ID,
                            WIDTH_VALUE,
                            DEPTH_VALUE,
                            HEIGHT_VALUE,
                            ROW_PROJECT_ID
                        )
                        VALUES
                        (
                            1,
                            #row["productId"]#,
                            <cfqueryparam cfsqltype="CF_SQL_NVARCHAR" value="#row["productName"]#">,
                            #INVOICE_ID#,
                            #row["stockId"]#,
                            #row["amount"]#,
                            <cfqueryparam cfsqltype="CF_SQL_NVARCHAR" value="#row["mainUnit"]#">,
                            #row["mainUnitId"]#,
                            #row["price"]*moneyratesarr[ arrayFind( moneynamesArr, row["money"] ) ]#,
                            0,
                            #row["price"]*row["amount"]*moneyratesarr[ arrayFind( moneynamesArr, row["money"] ) ]#,
                            #row["price"]*row["amount"]*(100+row["tax"])/100*moneyratesarr[ arrayFind( moneynamesArr, row["money"] ) ]#,
                            #row["price"]*row["amount"]*row["tax"]/100*moneyratesarr[ arrayFind( moneynamesArr, row["money"] ) ]#,
                            #row["tax"]#,
                            <cfif isdefined("attributes.duedate#i#") and len(Evaluate("attributes.duedate#i#"))>#Evaluate("attributes.duedate#i#")#<cfelse>0</cfif>,
                            0,
                            0,
                            0,
                            0,
                            0,
                            0,
                            0,
                            0,
                            0,
                            0,					
                            <cfif isdefined('attributes.deliver_date#i#') and isdate(evaluate('attributes.deliver_date#i#'))>#evaluate('attributes.deliver_date#i#')#,<cfelse>NULL,</cfif>
                            #branchdata.DEPARTMENT_ID#,
                            #branchdata.LOCATION_ID#,
                            '#row["money"]#',
                            #row["price"]*row["amount"]#,
                            NULL,
                            #row["price"]#,
                            #row["price"]*row["amount"]*(100+row["tax"])/100#,
                            0,
                            NULL,
                            NULL,
                            #logindata.PERIOD_ID#,
                            <cfif isdefined('attributes.iskonto_tutar#i#') and len(evaluate('attributes.iskonto_tutar#i#'))>#evaluate('attributes.iskonto_tutar#i#')#<cfelse>NULL</cfif>,
                            <cfif isdefined('attributes.is_promotion#i#') and len(evaluate('attributes.is_promotion#i#'))>#evaluate('attributes.is_promotion#i#')#<cfelse>0</cfif>,
                            <cfif isdefined('attributes.row_unique_relation_id#i#') and len(evaluate('attributes.row_unique_relation_id#i#'))><cfqueryparam cfsqltype="CF_SQL_NVARCHAR" value="#wrk_eval('attributes.row_unique_relation_id#i#')#"><cfelse>NULL</cfif>,
                            <cfif isdefined('attributes.prom_relation_id#i#') and len(evaluate('attributes.prom_relation_id#i#'))><cfqueryparam cfsqltype="CF_SQL_NVARCHAR" value="#wrk_eval('attributes.prom_relation_id#i#')#"><cfelse>NULL</cfif>,
                            <cfif isdefined('attributes.product_name_other#i#') and len(evaluate('attributes.product_name_other#i#'))><cfqueryparam cfsqltype="CF_SQL_NVARCHAR" value="#wrk_eval('attributes.product_name_other#i#')#"><cfelse>NULL</cfif>,
                            <cfif isdefined('attributes.amount_other#i#') and len(evaluate('attributes.amount_other#i#'))>#evaluate('attributes.amount_other#i#')#<cfelse>NULL</cfif>,
                            <cfif isdefined('attributes.unit_other#i#') and len(evaluate('attributes.unit_other#i#'))><cfqueryparam cfsqltype="CF_SQL_NVARCHAR" value="#wrk_eval('attributes.unit_other#i#')#"><cfelse>NULL</cfif>,
                            <cfif isdefined('attributes.ek_tutar#i#') and len(evaluate('attributes.ek_tutar#i#'))>#evaluate('attributes.ek_tutar#i#')#<cfelse>NULL</cfif>,
                            <cfif isdefined('attributes.ek_tutar_total#i#') and len(evaluate('attributes.ek_tutar_total#i#'))>#evaluate('attributes.ek_tutar_total#i#')#<cfelse>NULL</cfif>,
                            <cfif isdefined('attributes.shelf_number#i#') and len(evaluate('attributes.shelf_number#i#'))>#evaluate('attributes.shelf_number#i#')#<cfelse>NULL</cfif>,
                            <cfif isdefined('attributes.manufact_code#i#') and len(evaluate('attributes.manufact_code#i#'))><cfqueryparam cfsqltype="CF_SQL_NVARCHAR" value="#wrk_eval('attributes.manufact_code#i#')#"><cfelse>NULL</cfif>,
                            <cfif isdefined('attributes.basket_extra_info#i#') and len(evaluate('attributes.basket_extra_info#i#'))>#evaluate('attributes.basket_extra_info#i#')#<cfelse>NULL</cfif>,
                            <cfif isdefined('attributes.basket_employee_id#i#') and len(evaluate('attributes.basket_employee_id#i#')) and isdefined('attributes.basket_employee#i#') and len(evaluate('attributes.basket_employee#i#'))>#evaluate('attributes.basket_employee_id#i#')#<cfelse>NULL</cfif>,
                            <cfif isdefined('attributes.otv_oran#i#') and len(evaluate('attributes.otv_oran#i#'))><cfqueryparam cfsqltype="CF_SQL_NVARCHAR" value="#wrk_eval('attributes.otv_oran#i#')#"><cfelse>NULL</cfif>,
                            <cfif isdefined('attributes.row_otvtotal#i#') and len(evaluate('attributes.row_otvtotal#i#'))>#evaluate('attributes.row_otvtotal#i#')#<cfelse>NULL</cfif>,
                            <cfif isdefined('attributes.row_promotion_id#i#') and len(evaluate('attributes.row_promotion_id#i#'))>#evaluate('attributes.row_promotion_id#i#')#<cfelse>NULL</cfif>,
                            <cfif isdefined('attributes.promosyon_yuzde#i#') and len(evaluate('attributes.promosyon_yuzde#i#'))>#evaluate('attributes.promosyon_yuzde#i#')#<cfelse>NULL</cfif>,
                            <cfif isdefined('attributes.prom_stock_id#i#') and len(evaluate('attributes.prom_stock_id#i#'))>#evaluate('attributes.prom_stock_id#i#')#<cfelse>NULL</cfif>,
                            0,
                            <cfif isdefined('attributes.price_cat#i#') and len(evaluate('attributes.price_cat#i#'))>#evaluate('attributes.price_cat#i#')#<cfelse>NULL</cfif>,
                            <cfif isdefined('attributes.row_catalog_id#i#') and len(evaluate('attributes.row_catalog_id#i#'))>#evaluate('attributes.row_catalog_id#i#')#<cfelse>NULL</cfif>,
                            0,
                            <cfif isdefined('attributes.wrk_row_id#i#') and len(evaluate('attributes.wrk_row_id#i#'))><cfqueryparam cfsqltype="CF_SQL_NVARCHAR" value="#wrk_eval('attributes.wrk_row_id#i#')#"><cfelse>NULL</cfif>,
                            <cfif isdefined('attributes.wrk_row_relation_id#i#') and len(evaluate('attributes.wrk_row_relation_id#i#'))><cfqueryparam cfsqltype="CF_SQL_NVARCHAR" value="#wrk_eval('attributes.wrk_row_relation_id#i#')#"><cfelse>NULL</cfif>,
                            <cfif isdefined('attributes.row_width#i#') and len(evaluate('attributes.row_width#i#'))>#evaluate('attributes.row_width#i#')#<cfelse>NULL</cfif>,
                            <cfif isdefined('attributes.row_depth#i#') and len(evaluate('attributes.row_depth#i#'))>#evaluate('attributes.row_depth#i#')#<cfelse>NULL</cfif>,
                            <cfif isdefined('attributes.row_height#i#') and len(evaluate('attributes.row_height#i#'))>#evaluate('attributes.row_height#i#')#<cfelse>NULL</cfif>,
                            <cfif isdefined('attributes.row_project_id#i#') and len(evaluate('attributes.row_project_id#i#')) and isdefined('attributes.row_project_name#i#') and len(evaluate('attributes.row_project_name#i#'))>#evaluate('attributes.row_project_id#i#')#<cfelse>NULL</cfif>
                        )
                    </cfquery>
                    <cfset row_temp_wrk_id="#round(rand()*65)##dateformat(now(),'YYYYMMDD')##timeformat(now(),'HHmmssL')##logindata.EMPLOYEE_ID##round(rand()*100)#">
                    <cfquery name="query_add_ship_row" datasource="#dsn#">
                        INSERT INTO #dsn2##schema_ext#.SHIP_ROW
                            (
                            NAME_PRODUCT,
                            SHIP_ID,
                            STOCK_ID,
                            PRODUCT_ID,
                            AMOUNT,
                            UNIT,
                            UNIT_ID,
                            TAX,
                            PRICE,
                            PURCHASE_SALES,
                            DISCOUNT,
                            DISCOUNT2,
                            DISCOUNT3,
                            DISCOUNT4,
                            DISCOUNT5,
                            DISCOUNT6,
                            DISCOUNT7,
                            DISCOUNT8,
                            DISCOUNT9,
                            DISCOUNT10,
                            DISCOUNTTOTAL,
                            GROSSTOTAL,
                            NETTOTAL,
                            TAXTOTAL,						
                            DELIVER_DATE,
                            DELIVER_DEPT,
                            DELIVER_LOC,
                            OTHER_MONEY,
                            OTHER_MONEY_VALUE,
                            OTHER_MONEY_GROSS_TOTAL,
                        <cfif isdefined("attributes.spect_id#i#") and len(evaluate("attributes.spect_id#i#"))>
                            SPECT_VAR_ID,
                            SPECT_VAR_NAME,
                        </cfif>
                            LOT_NO,
                            PRICE_OTHER,
                            IS_PROMOTION,
                            DISCOUNT_COST,
                            UNIQUE_RELATION_ID,
                            PROM_RELATION_ID,
                            PRODUCT_NAME2,
                            AMOUNT2,
                            UNIT2,
                            EXTRA_PRICE,
                            EXTRA_PRICE_TOTAL,
                            SHELF_NUMBER,
                            PRODUCT_MANUFACT_CODE,
                            BASKET_EMPLOYEE_ID,
                            LIST_PRICE,
                            PRICE_CAT,
                            CATALOG_ID,
                            NUMBER_OF_INSTALLMENT,
                            WRK_ROW_ID,
                            WRK_ROW_RELATION_ID,
                            OTV_ORAN,
                            OTVTOTAL,
                            WIDTH_VALUE,
                            DEPTH_VALUE,
                            HEIGHT_VALUE,
                            ROW_PROJECT_ID
                            )
                        VALUES
                            (
                            <cfqueryparam cfsqltype="CF_SQL_NVARCHAR" value="#left(row["productName"],250)#">,
                            #query_get_ship_id.MAX_ID#,
                            #row["stockId"]#,
                            #row["productId"]#,
                            #row["amount"]#,
                            <cfqueryparam cfsqltype="CF_SQL_NVARCHAR" value="#row["mainUnit"]#">,
                            #row["mainUnitId"]#,
                            #row["tax"]#,
                            #row["price"]#,
                            1,
                            0,
                            0,
                            0,
                            0,
                            0,
                            0,
                            0,
                            0,
                            0,
                            0,
                            0,
                            #row["price"]*row["amount"]#,
                            #row["price"]*row["amount"]*(100+row["tax"])/100#,
                            #row["price"]*row["amount"]*row["tax"]/100#,						
                            <cfif isdefined('attributes.deliver_date#i#') and isdate(evaluate('attributes.deliver_date#i#'))>#evaluate('attributes.deliver_date#i#')#,<cfelse>NULL,</cfif>
                            #branchdata.DEPARTMENT_ID#,
                            #branchdata.LOCATION_ID#,
                            'TL',
                            #row["price"]*row["amount"]#,
                            #row["price"]*row["amount"]*(100+row["tax"])/100#,
                            <cfif isdefined("attributes.spect_id#i#") and len(evaluate("attributes.spect_id#i#"))>
                                #evaluate("attributes.spect_id#i#")#,
                                <cfqueryparam cfsqltype="CF_SQL_NVARCHAR" value="#wrk_eval('attributes.spect_name#i#')#">,
                            </cfif>
                            <cfif isdefined("attributes.lot_no#i#") and len(evaluate("attributes.lot_no#i#"))><cfqueryparam cfsqltype="CF_SQL_NVARCHAR" value="#wrk_eval('attributes.lot_no#i#')#"><cfelse>NULL</cfif>,
                            <cfif isdefined("attributes.price_other#i#") and len(evaluate("attributes.price_other#i#"))>#evaluate("attributes.price_other#i#")#<cfelse>NULL</cfif>,
                                0,
                            <cfif isdefined('attributes.iskonto_tutar#i#') and len(evaluate('attributes.iskonto_tutar#i#'))>#evaluate('attributes.iskonto_tutar#i#')#<cfelse>NULL</cfif>,
                            <cfif isdefined('attributes.row_unique_relation_id#i#') and len(evaluate('attributes.row_unique_relation_id#i#'))><cfqueryparam cfsqltype="CF_SQL_NVARCHAR" value="#wrk_eval('attributes.row_unique_relation_id#i#')#"><cfelse>NULL</cfif>,
                            <cfif isdefined('attributes.prom_relation_id#i#') and len(evaluate('attributes.prom_relation_id#i#'))><cfqueryparam cfsqltype="CF_SQL_NVARCHAR" value="#wrk_eval('attributes.prom_relation_id#i#')#"><cfelse>NULL</cfif>,
                            <cfif isdefined('attributes.product_name_other#i#') and len(evaluate('attributes.product_name_other#i#'))><cfqueryparam cfsqltype="CF_SQL_NVARCHAR" value="#wrk_eval('attributes.product_name_other#i#')#"><cfelse>NULL</cfif>,
                            <cfif isdefined('attributes.amount_other#i#') and len(evaluate('attributes.amount_other#i#'))>#evaluate('attributes.amount_other#i#')#<cfelse>NULL</cfif>,
                            <cfif isdefined('attributes.unit_other#i#') and len(evaluate('attributes.unit_other#i#'))><cfqueryparam cfsqltype="CF_SQL_NVARCHAR" value="#wrk_eval('attributes.unit_other#i#')#"><cfelse>NULL</cfif>,
                            <cfif isdefined('attributes.ek_tutar#i#') and len(evaluate('attributes.ek_tutar#i#'))>#evaluate('attributes.ek_tutar#i#')#<cfelse>NULL</cfif>,
                            <cfif isdefined('attributes.ek_tutar_total#i#') and len(evaluate('attributes.ek_tutar_total#i#'))>#evaluate('attributes.ek_tutar_total#i#')#<cfelse>NULL</cfif>,
                            <cfif isdefined('attributes.shelf_number#i#') and len(evaluate('attributes.shelf_number#i#'))>#evaluate('attributes.shelf_number#i#')#<cfelse>NULL</cfif>,
                            <cfif isdefined('attributes.manufact_code#i#') and len(evaluate('attributes.manufact_code#i#'))><cfqueryparam cfsqltype="CF_SQL_NVARCHAR" value="#wrk_eval('attributes.manufact_code#i#')#"><cfelse>NULL</cfif>,
                            <cfif isdefined('attributes.basket_employee_id#i#') and len(evaluate('attributes.basket_employee_id#i#')) and isdefined('attributes.basket_employee#i#') and len(evaluate('attributes.basket_employee#i#'))>#evaluate('attributes.basket_employee_id#i#')#<cfelse>NULL</cfif>,
                            <cfif isdefined('attributes.list_price#i#') and len(evaluate('attributes.list_price#i#'))>#evaluate('attributes.list_price#i#')#<cfelse>NULL</cfif>,
                            <cfif isdefined('attributes.price_cat#i#') and len(evaluate('attributes.price_cat#i#'))>#evaluate('attributes.price_cat#i#')#<cfelse>NULL</cfif>,
                            <cfif isdefined('attributes.row_catalog_id#i#') and len(evaluate('attributes.row_catalog_id#i#'))>#evaluate('attributes.row_catalog_id#i#')#<cfelse>NULL</cfif>,
                            <cfif isdefined('attributes.number_of_installment#i#') and len(evaluate('attributes.number_of_installment#i#'))>#evaluate('attributes.number_of_installment#i#')#<cfelse>NULL</cfif>,
                            #row_temp_wrk_id#,
                            <cfif isdefined('attributes.wrk_row_id#i#') and len(evaluate('attributes.wrk_row_id#i#'))><cfqueryparam cfsqltype="CF_SQL_NVARCHAR" value="#wrk_eval('attributes.wrk_row_id#i#')#"><cfelse>NULL</cfif>,<!--- faturanın wrk_row_id si olusturdugu irsaliyenin wrk_row_relation_id sine gonderiliyor --->
                            <cfif isdefined('attributes.otv_oran#i#') and len(evaluate('attributes.otv_oran#i#'))><cfqueryparam cfsqltype="CF_SQL_NVARCHAR" value="#wrk_eval('attributes.otv_oran#i#')#"><cfelse>NULL</cfif>,
                            <cfif isdefined('attributes.row_otvtotal#i#') and len(evaluate('attributes.row_otvtotal#i#'))>#evaluate('attributes.row_otvtotal#i#')#<cfelse>NULL</cfif>,
                            <cfif isdefined('attributes.row_width#i#') and len(evaluate('attributes.row_width#i#'))>#evaluate('attributes.row_width#i#')#<cfelse>NULL</cfif>,
                            <cfif isdefined('attributes.row_depth#i#') and len(evaluate('attributes.row_depth#i#'))>#evaluate('attributes.row_depth#i#')#<cfelse>NULL</cfif>,
                            <cfif isdefined('attributes.row_height#i#') and len(evaluate('attributes.row_height#i#'))>#evaluate('attributes.row_height#i#')#<cfelse>NULL</cfif>,
                            <cfif isdefined('attributes.row_project_id#i#') and len(evaluate('attributes.row_project_id#i#')) and isdefined('attributes.row_project_name#i#') and len(evaluate('attributes.row_project_name#i#'))>#evaluate('attributes.row_project_id#i#')#<cfelse>NULL</cfif>
                            )
                    </cfquery>
                    <cfquery name="ADD_STOCK_ROW" datasource="#dsn#">
                        INSERT INTO #dsn2##schema_ext#.STOCKS_ROW
                            (
                            UPD_ID,
                            PRODUCT_ID,
                            STOCK_ID,
                            PROCESS_TYPE,
                            STOCK_OUT,
                            STORE,
                            STORE_LOCATION,
                            PROCESS_DATE,
                            SPECT_VAR_ID,
                            LOT_NO,
                            DELIVER_DATE,
                            SHELF_NUMBER,
                            PRODUCT_MANUFACT_CODE
                            )
                        VALUES
                            (
                            #query_get_ship_id.MAX_ID#,
                            #row["productId"]#,
                            #row["stockId"]#,
                            #ship_process_type#,
                            #row["amount"]#,
                            #branchdata.DEPARTMENT_ID#,
                            #branchdata.LOCATION_ID#,
                            #now()#,
                        <cfif isdefined('form_spect_main_id') and len(form_spect_main_id)>#form_spect_main_id#<cfelse>NULL</cfif>,<!--- <cfif isdefined("attributes.spect_id#i#") and len(evaluate("attributes.spect_id#i#"))>#evaluate("attributes.spect_id#i#")#<cfelse>NULL</cfif>, --->
                        <cfif isdefined("attributes.lot_no#i#") and len(evaluate("attributes.lot_no#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('attributes.lot_no#i#')#"><cfelse>NULL</cfif>,
                        <cfif isdefined('attributes.deliver_date#i#') and isdate(evaluate('attributes.deliver_date#i#'))>#evaluate('attributes.deliver_date#i#')#,<cfelse>NULL,</cfif>
                        <cfif isdefined('attributes.shelf_number#i#') and len(evaluate('attributes.shelf_number#i#'))>#evaluate('attributes.shelf_number#i#')#<cfelse>NULL</cfif>,
                        <cfif isdefined('attributes.manufact_code#i#') and len(evaluate('attributes.manufact_code#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('attributes.manufact_code#i#')#"><cfelse>NULL</cfif>
                            )
                    </cfquery>

                </cfif>
            </cfloop>
            
            <cfscript>
                carici(
                    action_id : INVOICE_ID,
                    action_table : 'INVOICE',
                    workcube_process_type : INVOICE_CAT,
                    account_card_type : 12,
                    islem_tarihi : now(),
                    islem_tutari : BASKET_NET_TOTAL,
                    islem_belge_no : attributes.PAPER,
                    to_cmp_id : attributes.company_id,
                    to_consumer_id : attributes.consumer_id,
                    to_branch_id : branchdata.LOCATION_ID,
                    islem_detay : "",
                    action_detail : "",
                    other_money_value : 0,
                    other_money : "",
                    due_date : "",
                    action_currency : '',
                    process_cat : attributes.PROCESS_CAT,
                    currency_multiplier : 1,
                    assetp_id : '',
                    rate2:1
                );
            </cfscript>
            <cfquery name="query_upd_paper" datasource="#dsn#">
                UPDATE #dsn3##schema_ext#.PAPERS_NO SET INVOICE_NUMBER = #paper_number+1# WHERE PAPER_ID = #GET_PAPER.PAPER_ID#
            </cfquery>

            </cftransaction>
            
            <cfcatch>
                <cfreturn get_result(0, cfcatch.message, cfcatch)>
            </cfcatch>
        </cftry>
        <cfreturn get_result(1, "", { paper: attributes.PAPER, invoice_id: INVOICE_ID } )>
    </cffunction>

    <cffunction name="get_stretching_tests" access="remote" returntype="string" httpMethod="POST" consumes="application/json" produces="application/json" restPath="getstretchingtest">
        <cfargument name="bodydata" type="struct">

        <cftry>
            <cfset logindata = get_login(arguments.bodydata.username, arguments.bodydata.password)>
            <cfif logindata.recordcount eq 0>
                <cfreturn get_result(0, "Hatalı Kullanıcı/Şifre")>
            </cfif>

            <cfquery name="query_cekme_test" datasource="#dsn#">
                SELECT
                TEXTILE_STRETCHING_TEST_HEAD.STRETCHING_TEST_ID,
                CONCAT('ÇT-', TEXTILE_STRETCHING_TEST_HEAD.STRETCHING_TEST_ID) AS STRETCHING_TEST_NUMBER,
				FORMAT(TEXTILE_STRETCHING_TEST_HEAD.TEST_DATE, 'dd.MM.yy') AS TEST_DATE,
                PRO_PROJECTS.PROJECT_HEAD,
                PROCESS_TYPE_ROWS.STAGE
                
                FROM #dsn3##schema_ext#.TEXTILE_STRETCHING_TEST_HEAD
                LEFT JOIN PRO_PROJECTS ON TEXTILE_STRETCHING_TEST_HEAD.PROJECT_ID = PRO_PROJECTS.PROJECT_ID
                LEFT JOIN PROCESS_TYPE_ROWS ON TEXTILE_STRETCHING_TEST_HEAD.STAGE_ID = PROCESS_TYPE_ROWS.PROCESS_ROW_ID

                ORDER BY STRETCHING_TEST_ID DESC
            </cfquery>

            <cfreturn get_result(1, "", query_cekme_test)>
            <cfcatch>
                <cfreturn get_result(0, cfcatch.message, cfcatch)>
            </cfcatch>
        </cftry>
    </cffunction>

    <cffunction name="get_stretching_test_detail" access="remote" returntype="string" httpMethod="POST" consumes="application/json" produces="application/json" restPath="getstretchingdetail">
        <cfargument name="bodydata" type="struct">

        <cftry>
            <cfset logindata = get_login(arguments.bodydata.username, arguments.bodydata.password)>
            <cfif logindata.recordcount eq 0>
                <cfreturn get_result(0, "Hatalı Kullanıcı/Şifre")>
            </cfif>

            <cfquery name="query_cekme_test" datasource="#dsn3#">
               SELECT STRETCHING_TEST_ROWID, PRODUCT_ID, ROLL_ID, ROLL_METER
               FROM TEXTILE_STRETCHING_TEST_ROWS
               WHERE STRETCHING_TEST_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.bodydata.id#'>
            </cfquery>

            <cfreturn get_result(1, "", query_cekme_test)>
            <cfcatch>
                <cfreturn get_result(0, cfcatch.message, cfcatch)>
            </cfcatch>
        </cftry>
    </cffunction>

    <cffunction name="get_lots" access="remote" returntype="string" httpMethod="POST" consumes="application/json" produces="application/json" restPath="getlots">
        <cfargument name="bodydata" type="struct">

        <cftry>
            <cfset logindata = get_login(arguments.bodydata.username, arguments.bodydata.password)>
            <cfif logindata.recordcount eq 0>
                <cfreturn get_result(0, "Hatalı Kullanıcı/Şifre")>
            </cfif>

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
                
                <cfif len(arguments.bodydata.PRODUCT_ID)>
                AND PRODUCT_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.bodydata.PRODUCT_ID#'> 
                </cfif>
    
                <cfif len(arguments.bodydata.LOT)>
                AND LOT_NO = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.bodydata.LOT#'>
                </cfif>
    
                GROUP BY PRODUCT_ID,LOT_NO
            </cfquery>

            <cfreturn get_result(1, "", query_list)>
            <cfcatch>
                <cfreturn get_result(0, cfcatch.message, cfcatch)>
            </cfcatch>
        </cftry>
    </cffunction>

    <cffunction name="add_stretching_row" access="remote" returntype="string" httpMethod="POST" consumes="application/json" produces="application/json" restPath="addlots">
        <cfargument name="bodydata" type="struct">

        <cftry>
            <cfset logindata = get_login(arguments.bodydata.username, arguments.bodydata.password)>
            <cfif logindata.recordcount eq 0>
                <cfreturn get_result(0, "Hatalı Kullanıcı/Şifre")>
            </cfif>

            <cfset idsa = arrayNew(1)> 
            <cfloop array="#arguments.bodydata.rows#" index="item">
                <cfset arrayAppend(idsa, item["rowid"])>
            </cfloop>
            <cfif arrayLen(idsa) eq 0>
                <cfreturn get_result(0, "Lütfen ürün ekleyin!")>
            </cfif>

            <cfset ids = arrayToList( idsa )>

            <cfquery name="delete_stretching_rows" datasource="#dsn3#">
                DELETE FROM TEXTILE_STRETCHING_TEST_ROWS WHERE STRETCHING_TEST_ROWID NOT IN (#ids#)
            </cfquery>

            <cfloop array="#arguments.bodydata.rows#" index="item">

                <cfif item["rowid"] eq 0>

                <cfquery name="query_add_stretching_test_rows" datasource="#dsn3#">
                INSERT INTO TEXTILE_STRETCHING_TEST_ROWS (
                    STRETCHING_TEST_ID,
                    PRODUCT_ID,
                    ROLL_ID,
                    ROLL_METER,
                    ROLL_TEST_METER,
                    FABRIC_WIDTH,
                    HEIGHT_SHRINKAGE,
                    WIDTH_SHRINKAGE,
                    SMOOTH,
                    COLOR_LOT,
                    COLOR_NAME,
                    DESC_ONE,
                    DESC_TWO,
                    RECORD_DATE,
                    RECORD_EMP,
                    RECORD_IP
                ) VALUES (
                    <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.bodydata.TESTID#'>
                    ,
                    <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#item["productId"]#'>
                    ,
                    <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#item["rollnr"]#'>
                    ,
                    <cfqueryparam cfsqltype='CF_SQL_DECIMAL' scale="2" value='#item["metering"]#'>
                    ,0
                    ,0
                    ,0
                    ,0
                    ,0
                    ,''
                    ,''
                    ,''
                    ,''
                    ,#now()#
                    ,#logindata.EMPLOYEE_ID#
                    ,'#cgi.REMOTE_ADDR#'
                )
                </cfquery>

                </cfif>

            </cfloop>

            <cfreturn get_result(1)>
            <cfcatch>
                <cfreturn get_result(0, cfcatch.message, cfcatch)>
            </cfcatch>
        </cftry>
    </cffunction>

    <cffunction name="get_login">
        <cfargument name="username">
        <cfargument name="password">

        <cfobject type="component" component="WMO.login" name="logincfc">
        <cfset logincfc.DSN = dsn>
        
        <cfset username_ban_control = logincfc.get_username_ban_control()>
        <cfif username_ban_control.recordcount>
            <cfthrow message="Engellenmiş kullanıcı!">
        </cfif>
        
        <cfset user_login = logincfc.get_login_employee(arguments.username, hash(arguments.password), "", 1, 'tr')>

        <cfset company_id = user_login.OUR_COMPANY_ID>
        <cfset period_id = user_login.PERIOD_ID>
        <cfset period_year = user_login.PERIOD_YEAR>

        <cfset dsn2 = dsn & "_" & period_year & "_" & company_id>
        <cfset dsn3 = dsn & "_" & company_id>
        <cfset dsn1 = dsn & "_product">
		
        <cfreturn user_login>
    </cffunction>

    <cffunction name="get_branch_dept">
        <cfargument name="position_code">
        <cfargument name="our_company_id">

        <cfobject type="component" component="WMO.login" name="logincfc">
        <cfset logincfc.DSN = dsn>
        <cfset branch = logincfc.GET_BRANCH_DEPT(arguments.position_code, arguments.our_company_id)>
        <cfreturn branch>
    </cffunction>

    <cffunction name="carici" returntype="boolean" output="false">
        <cfargument name="action_id" required="yes" type="numeric">
        <cfargument name="process_cat" required="yes" type="numeric">
        <cfargument name="action_table" type="string">
        <cfargument name="workcube_process_type" required="yes" type="numeric">
        <cfargument name="workcube_old_process_type" type="numeric">
        <cfargument name="action_currency" required="yes" default="TL">
        <cfargument name="action_currency_2" type="string" default="">
        <cfargument name="currency_multiplier" type="string" default="">
        <cfargument name="other_money" type="string" default="">
        <cfargument name="other_money_value" type="string" default="">
        <cfargument name="account_card_type" type="numeric">
        <cfargument name="islem_tarihi" required="yes" type="date">
        <cfargument name="paper_act_date" type="date">
        <cfargument name="acc_type_id">
        <cfargument name="due_date" type="string">
        <cfargument name="islem_tutari" required="yes" type="numeric">
        <cfargument name="action_value2">
        <cfargument name="islem_belge_no" type="string" default="">
        <cfargument name="islem_detay" type="string" default="">
        <cfargument name="period_is_integrated" type="boolean" default="0">
        <cfargument name="cari_db" type="string" default="">
        <cfargument name="cari_db_alias" type="string">
        <cfargument name="expense_center_id">
        <cfargument name="expense_item_id">
        <cfargument name="payer_id">
        <cfargument name="revenue_collector_id">
        <cfargument name="to_cmp_id">
        <cfargument name="from_cmp_id">
        <cfargument name="to_account_id">
        <cfargument name="from_account_id">
        <cfargument name="to_cash_id">
        <cfargument name="from_cash_id">
        <cfargument name="to_employee_id">
        <cfargument name="from_employee_id">
        <cfargument name="to_consumer_id">
        <cfargument name="from_consumer_id">
        <cfargument name="is_processed" type="numeric" default="0">
        <cfargument name="action_detail" type="string" default="">
        <cfargument name="from_branch_id">
        <cfargument name="to_branch_id">
        <cfargument name="project_id">
        <cfargument name="payroll_id">
        <cfargument name="rate2">
        <cfargument name="is_cancel">
        <cfargument name="is_cash_payment" default="0"><!---1 gönderildiğinde ödeme yöntemine göre parçalı ödemelerde peşinat satırını tutar  --->
        <cfargument name="is_upd_other_value" default="0"><!--- çek-senetler için extre değeri güncelledkten sonra değişmesin veya null olmasn diye ayrı bloklr içine almk için kullanıldı, if bloklarına eklenmedi çünkü else inde NULL set edilirdi ozaman.. --->
        <cfargument name="payment_value"><!--- Burasi fatura vb islem detaylarindaki odeme plani icin kullaniliyor, odeme plani 2 ondalik hane ile calirisken faturada 4 hane ile calisiliyorsa yuvarlamadan dolayi sorun oluyordu bu yuzden faturadaki hane kadar da tutabilmek icin boyle yaptik FBS 20110822 --->

        <cfset arguments.cari_db_alias = dsn2&schema_ext&".">
        <cfset arguments.cari_db = dsn>
        <cfif isdefined("arguments.workcube_old_process_type") and len(arguments.workcube_old_process_type)>
            <cfquery name="carici_get_cari_islem" datasource="#arguments.cari_db#">
                SELECT 
                    ACTION_ID 
                FROM 
                    #arguments.cari_db_alias#CARI_ROWS 
                WHERE 
                    ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.action_id#">
                    AND ACTION_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.workcube_old_process_type#">
                    <cfif isDefined('arguments.action_table') and len(arguments.action_table)> AND ACTION_TABLE = <cfqueryparam cfsqltype="CF_SQL_NVARCHAR" value="#arguments.action_table#"></cfif>
                    <cfif isDefined('arguments.payroll_id') and len(arguments.payroll_id)> AND PAYROLL_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.payroll_id#"></cfif> 
            </cfquery>
        </cfif>
        <cfif isdefined("arguments.workcube_old_process_type") and len(arguments.workcube_old_process_type) and len(carici_get_cari_islem.action_id)>
            <cfquery name="UPD_CARI" datasource="#arguments.cari_db#">
                UPDATE
                    #arguments.cari_db_alias#CARI_ROWS
                SET
                    ACTION_DATE=#arguments.islem_tarihi#,
                    ACTION_TYPE_ID = #arguments.workcube_process_type#,
                    ACTION_VALUE= #wrk_round(arguments.islem_tutari,2)#,ACTION_CURRENCY_ID='#arguments.action_currency#',PROCESS_CAT=#arguments.process_cat#,
                    <cfif is_upd_other_value eq 0>
                        <cfif len(arguments.action_currency_2)>
                            ACTION_CURRENCY_2='#arguments.action_currency_2#', 
                            <cfif isdefined('arguments.action_value2') and len(arguments.action_value2)>
                                ACTION_VALUE_2= #wrk_round(arguments.action_value2,2)#,
                            <cfelse>
                                ACTION_VALUE_2= #wrk_round((arguments.islem_tutari/arguments.currency_multiplier),2)#,
                            </cfif>
                        <cfelse>
                            ACTION_CURRENCY_2 = NULL, ACTION_VALUE_2 = NULL,
                        </cfif>
                    </cfif>
                    PAYMENT_VALUE=<cfif isDefined('arguments.payment_value') and len(arguments.payment_value)>#arguments.payment_value#<cfelse>NULL</cfif>,
                    ACTION_TABLE=<cfif isDefined('arguments.action_table') and len(arguments.action_table)>'#arguments.action_table#'<cfelse>NULL</cfif>,
                    DUE_DATE=<cfif isDefined('arguments.due_date') and isdate(arguments.due_date)>#arguments.due_date#<cfelse>#arguments.islem_tarihi#</cfif>,
                    PAPER_NO=<cfif isDefined('arguments.islem_belge_no') and len(arguments.islem_belge_no)>'#arguments.islem_belge_no#'<cfelse>NULL</cfif>,
                    ACTION_DETAIL=<cfif isDefined('arguments.action_detail') and len(arguments.action_detail)><cfqueryparam cfsqltype="CF_SQL_NVARCHAR" value="#LEFT(arguments.action_detail,250)#"><cfelse>NULL</cfif>,
                    ACTION_NAME=<cfif isDefined('arguments.islem_detay') and len(arguments.islem_detay)>'#LEFT(arguments.islem_detay,100)#'<cfelse>NULL</cfif>,
                    EXPENSE_CENTER_ID=<cfif isDefined('arguments.expense_center_id') and isnumeric(arguments.expense_center_id)>#arguments.expense_center_id#<cfelse>NULL</cfif>,
                    EXPENSE_ITEM_ID=<cfif isDefined('arguments.expense_item_id') and isnumeric(arguments.expense_item_id)>#arguments.expense_item_id#<cfelse>NULL</cfif>,
                    PAYER_ID=<cfif isDefined('arguments.payer_id') and isnumeric(arguments.payer_id)>#arguments.payer_id#<cfelse>NULL</cfif>,
                    <cfif is_upd_other_value eq 0>
                        OTHER_CASH_ACT_VALUE=<cfif isDefined('arguments.other_money_value') and isnumeric(arguments.other_money_value)>#wrk_round(arguments.other_money_value,2)#<cfelse>NULL</cfif>,
                        OTHER_MONEY=<cfif isDefined('arguments.other_money') and len(arguments.other_money)>'#arguments.other_money#'<cfelse>NULL</cfif>,
                        RATE2 = <cfif isdefined("arguments.rate2") and len(arguments.rate2) and arguments.rate2 neq 0>#arguments.rate2#<cfelseif isDefined('arguments.other_money_value') and isnumeric(arguments.other_money_value) and arguments.other_money_value neq 0>#arguments.islem_tutari/arguments.other_money_value#<cfelse>NULL</cfif>,
                    </cfif>
                    TO_CMP_ID=<cfif isDefined('arguments.to_cmp_id') and isnumeric(arguments.to_cmp_id)>#arguments.to_cmp_id#<cfelse>NULL</cfif>,
                    FROM_CMP_ID=<cfif isDefined('arguments.from_cmp_id') and isnumeric(arguments.from_cmp_id)>#arguments.from_cmp_id#<cfelse>NULL</cfif>,
                    TO_ACCOUNT_ID=<cfif isDefined('arguments.to_account_id') and isnumeric(arguments.to_account_id)>#arguments.to_account_id#<cfelse>NULL</cfif>,
                    FROM_ACCOUNT_ID=<cfif isDefined('arguments.from_account_id') and isnumeric(arguments.from_account_id)>#arguments.from_account_id#<cfelse>NULL</cfif>,
                    TO_CASH_ID=<cfif isDefined('arguments.to_cash_id') and isnumeric(arguments.to_cash_id)>#arguments.to_cash_id#<cfelse>NULL</cfif>,
                    FROM_CASH_ID=<cfif isDefined('arguments.from_cash_id') and isnumeric(arguments.from_cash_id)>#arguments.from_cash_id#<cfelse>NULL</cfif>,
                    TO_EMPLOYEE_ID=<cfif isDefined('arguments.to_employee_id') and isnumeric(arguments.to_employee_id)>#arguments.to_employee_id#<cfelse>NULL</cfif>,
                    FROM_EMPLOYEE_ID=<cfif isDefined('arguments.from_employee_id') and isnumeric(arguments.from_employee_id)>#arguments.from_employee_id#<cfelse>NULL</cfif>,
                    TO_CONSUMER_ID=<cfif isDefined('arguments.to_consumer_id') and isnumeric(arguments.to_consumer_id)>#arguments.to_consumer_id#<cfelse>NULL</cfif>,
                    FROM_CONSUMER_ID=<cfif isDefined('arguments.from_consumer_id') and isnumeric(arguments.from_consumer_id)>#arguments.from_consumer_id#<cfelse>NULL</cfif>,
                    REVENUE_COLLECTOR_ID=<cfif isDefined('arguments.revenue_collector_id') and isnumeric(arguments.revenue_collector_id)>#arguments.revenue_collector_id#<cfelse>NULL</cfif>,
                    IS_PROCESSED=<cfif isdefined('arguments.is_processed') and isnumeric(arguments.is_processed)>#arguments.is_processed#<cfelse>0</cfif>,
                    FROM_BRANCH_ID=<cfif isdefined('arguments.from_branch_id') and len(arguments.from_branch_id)>#arguments.from_branch_id#<cfelse>NULL</cfif>,
                    TO_BRANCH_ID=<cfif isdefined('arguments.to_branch_id') and len(arguments.to_branch_id)>#arguments.to_branch_id#<cfelse>NULL</cfif>,
                    ASSETP_ID=<cfif isdefined('arguments.assetp_id') and len(arguments.assetp_id)>#arguments.assetp_id#<cfelse>NULL</cfif>,
                    SPECIAL_DEFINITION_ID = <cfif isdefined('arguments.special_definition_id') and len(arguments.special_definition_id)>#arguments.special_definition_id#<cfelse>NULL</cfif>,
                    PROJECT_ID=<cfif isdefined('arguments.project_id') and len(arguments.project_id)>#arguments.project_id#<cfelse>NULL</cfif>,
                    IS_CASH_PAYMENT=<cfif isdefined('arguments.is_cash_payment') and len(arguments.is_cash_payment)>#arguments.is_cash_payment#<cfelse>NULL</cfif>,
                    ACC_TYPE_ID=<cfif isdefined('arguments.acc_type_id') and len(arguments.acc_type_id) and arguments.acc_type_id neq 0>#arguments.acc_type_id#<cfelseif (isDefined('arguments.to_employee_id') and isnumeric(arguments.to_employee_id)) or (isDefined('arguments.from_employee_id') and isnumeric(arguments.from_employee_id))>-1<cfelse>NULL</cfif>,
                    UPDATE_DATE = #now()#,
                    UPDATE_EMP = #logindata.EMPLOYEE_ID#,
                    UPDATE_PAR = <cfif isDefined("session.pp.userid")>#session.pp.userid#<cfelse>NULL</cfif>,
                    UPDATE_CONS = <cfif isDefined("session.ww.userid")>#session.ww.userid#<cfelse>NULL</cfif>,
                    UPDATE_IP = '#CGI.REMOTE_ADDR#',
                    <cfif arguments.period_is_integrated>IS_ACCOUNT=1,IS_ACCOUNT_TYPE=#arguments.account_card_type#<cfelse>IS_ACCOUNT=0,IS_ACCOUNT_TYPE=0</cfif>
                WHERE
                    ACTION_ID = #arguments.action_id#
                    AND ACTION_TYPE_ID = #arguments.workcube_old_process_type#
                    <cfif isDefined('arguments.action_table') and len(arguments.action_table)> AND ACTION_TABLE = '#arguments.action_table#'</cfif> 
                    <cfif isDefined('arguments.payroll_id') and len(arguments.payroll_id)> AND PAYROLL_ID = #arguments.payroll_id#</cfif> 
            </cfquery>
        <cfelse>
            <cfquery name="ADD_CARI" datasource="#arguments.cari_db#" result="GET_MAX_CARI">
                INSERT INTO
                    #arguments.cari_db_alias#CARI_ROWS
                    (
                        ACTION_ID,
                        ACTION_TYPE_ID,
                        ACTION_DATE,
                        PROCESS_CAT,
                        ACTION_VALUE,
                        ACTION_CURRENCY_ID,
                        <cfif len(arguments.action_currency_2)>
                        ACTION_VALUE_2,ACTION_CURRENCY_2,
                        </cfif>
                        PAYMENT_VALUE,
                        ACTION_TABLE,
                        PAPER_NO,
                        ACTION_DETAIL,
                        DUE_DATE,
                        ACTION_NAME,
                        EXPENSE_CENTER_ID,
                        EXPENSE_ITEM_ID,
                        SPECIAL_DEFINITION_ID,
                        PAYER_ID,
                        OTHER_CASH_ACT_VALUE,
                        OTHER_MONEY,
                        RATE2,
                        TO_CMP_ID,
                        FROM_CMP_ID,
                        TO_ACCOUNT_ID,
                        FROM_ACCOUNT_ID,
                        TO_CASH_ID,
                        FROM_CASH_ID,
                        TO_EMPLOYEE_ID,
                        FROM_EMPLOYEE_ID,
                        TO_CONSUMER_ID,
                        FROM_CONSUMER_ID,
                        REVENUE_COLLECTOR_ID,
                        IS_PROCESSED,
                        IS_CASH_PAYMENT,
                        ACC_TYPE_ID,
                        PAPER_ACT_DATE,
                        <cfif isdefined('arguments.from_branch_id') and len(arguments.from_branch_id)>
                        FROM_BRANCH_ID,
                        </cfif>
                        <cfif isdefined('arguments.to_branch_id') and len(arguments.to_branch_id)>
                        TO_BRANCH_ID,
                        </cfif>
                        <cfif isdefined('arguments.assetp_id') and len(arguments.assetp_id)>
                        ASSETP_ID,
                        </cfif>
                        <cfif isdefined('arguments.project_id') and len(arguments.project_id)>
                        PROJECT_ID,
                        </cfif>
                        <cfif isdefined('arguments.payroll_id') and len(arguments.payroll_id)>
                        PAYROLL_ID,
                        </cfif>
                        <cfif arguments.period_is_integrated>IS_ACCOUNT,IS_ACCOUNT_TYPE<cfelse>IS_ACCOUNT,IS_ACCOUNT_TYPE</cfif>,
                        RECORD_DATE,
                        <cfif isDefined("logindata.EMPLOYEE_ID")>
                            RECORD_EMP,
                        <cfelseif isDefined("session.pp.userid")>
                            RECORD_PAR,
                        <cfelseif isDefined("session.ww.userid")>
                            RECORD_CONS,
                        </cfif>
                        RECORD_IP
                    )
                VALUES
                    (
                        #arguments.action_id#,
                        #arguments.workcube_process_type#,
                        #arguments.islem_tarihi#,
                        #arguments.process_cat#,
                        #wrk_round(arguments.islem_tutari,2)#,
                        '#arguments.action_currency#',
                        <cfif len(arguments.action_currency_2)>
                            <cfif isdefined('arguments.action_value2') and len(arguments.action_value2)>#wrk_round(arguments.action_value2,2)#,<cfelseif isdefined("arguments.currency_multiplier") and len(arguments.currency_multiplier)>#wrk_round((arguments.islem_tutari/arguments.currency_multiplier),2)#,<cfelse>NULL,</cfif>
                            '#arguments.action_currency_2#',
                        </cfif>
                        <cfif isDefined('arguments.payment_value') and len(arguments.payment_value)>#arguments.payment_value#<cfelse>NULL</cfif>,
                        <cfif isDefined('arguments.action_table') and len(arguments.action_table)>'#arguments.action_table#'<cfelse>NULL</cfif>,
                        <cfif isDefined('arguments.islem_belge_no') and len(arguments.islem_belge_no)>'#arguments.islem_belge_no#'<cfelse>NULL</cfif>,
                        <cfif isDefined('arguments.action_detail') and len(arguments.action_detail)><cfqueryparam cfsqltype="CF_SQL_NVARCHAR" value="#LEFT(arguments.action_detail,250)#"><cfelse>NULL</cfif>,
                        <cfif isDefined('arguments.due_date') and isdate(arguments.due_date)>#arguments.due_date#<cfelse>#arguments.islem_tarihi#</cfif>,
                        <cfif isDefined('arguments.islem_detay') and len(arguments.islem_detay)>'#LEFT(arguments.islem_detay,100)#'<cfelse>NULL</cfif>,
                        <cfif isDefined('arguments.expense_center_id') and isnumeric(arguments.expense_center_id)>#arguments.expense_center_id#<cfelse>NULL</cfif>,
                        <cfif isDefined('arguments.expense_item_id') and isnumeric(arguments.expense_item_id)>#arguments.expense_item_id#<cfelse>NULL</cfif>,
                        <cfif isDefined('arguments.special_definition_id') and isnumeric(arguments.special_definition_id)>#arguments.special_definition_id#<cfelse>NULL</cfif>,
                        <cfif isDefined('arguments.payer_id') and isnumeric(arguments.payer_id)>#arguments.payer_id#<cfelse>NULL</cfif>,
                        <cfif isDefined('arguments.other_money_value') and isnumeric(arguments.other_money_value)>#wrk_round(arguments.other_money_value,2)#<cfelse>NULL</cfif>,
                        <cfif isDefined('arguments.other_money') and len(arguments.other_money)>'#arguments.other_money#'<cfelse>NULL</cfif>,
                        <cfif isdefined("arguments.rate2") and len(arguments.rate2) and arguments.rate2 neq 0>#arguments.rate2#<cfelseif isDefined('arguments.other_money_value') and isnumeric(arguments.other_money_value) and arguments.other_money_value neq 0>#arguments.islem_tutari/arguments.other_money_value#<cfelse>NULL</cfif>,
                        <cfif isDefined('arguments.to_cmp_id') and isnumeric(arguments.to_cmp_id) and not (isDefined('arguments.to_employee_id') and isnumeric(arguments.to_employee_id))>#arguments.to_cmp_id#<cfelse>NULL</cfif>,
                        <cfif isDefined('arguments.from_cmp_id') and isnumeric(arguments.from_cmp_id) and not (isDefined('arguments.from_employee_id') and isnumeric(arguments.from_employee_id))>#arguments.from_cmp_id#<cfelse>NULL</cfif>,
                        <cfif isDefined('arguments.to_account_id') and isnumeric(arguments.to_account_id)>#arguments.to_account_id#<cfelse>NULL</cfif>,
                        <cfif isDefined('arguments.from_account_id') and isnumeric(arguments.from_account_id)>#arguments.from_account_id#<cfelse>NULL</cfif>,
                        <cfif isDefined('arguments.to_cash_id') and isnumeric(arguments.to_cash_id)>#arguments.to_cash_id#<cfelse>NULL</cfif>,
                        <cfif isDefined('arguments.from_cash_id') and isnumeric(arguments.from_cash_id)>#arguments.from_cash_id#<cfelse>NULL</cfif>,
                        <cfif isDefined('arguments.to_employee_id') and isnumeric(arguments.to_employee_id)>#arguments.to_employee_id#<cfelse>NULL</cfif>,
                        <cfif isDefined('arguments.from_employee_id') and isnumeric(arguments.from_employee_id)>#arguments.from_employee_id#<cfelse>NULL</cfif>,
                        <cfif isDefined('arguments.to_consumer_id') and isnumeric(arguments.to_consumer_id)>#arguments.to_consumer_id#<cfelse>NULL</cfif>,
                        <cfif isDefined('arguments.from_consumer_id') and isnumeric(arguments.from_consumer_id)>#arguments.from_consumer_id#<cfelse>NULL</cfif>,
                        <cfif isDefined('arguments.revenue_collector_id') and isnumeric(arguments.revenue_collector_id)>#arguments.revenue_collector_id#<cfelse>NULL</cfif>,
                        <cfif isDefined('arguments.is_processed') and isnumeric(arguments.is_processed)>#arguments.is_processed#<cfelse>0</cfif>,
                        <cfif isdefined('arguments.is_cash_payment') and len(arguments.is_cash_payment)>#arguments.is_cash_payment#<cfelse>NULL</cfif>,
                        <cfif isdefined('arguments.acc_type_id') and len(arguments.acc_type_id) and arguments.acc_type_id neq 0>
                            #arguments.acc_type_id#
                        <cfelseif (isDefined('arguments.to_employee_id') and isnumeric(arguments.to_employee_id)) or (isDefined('arguments.from_employee_id') and isnumeric(arguments.from_employee_id))>
                            -1
                        <cfelse>
                            NULL
                        </cfif>,
                        <cfif isdefined('arguments.paper_act_date') and len(arguments.paper_act_date)>#arguments.paper_act_date#<cfelse>NULL</cfif>,
                        <cfif isdefined('arguments.from_branch_id') and len(arguments.from_branch_id)>#arguments.from_branch_id#,</cfif>
                        <cfif isdefined('arguments.to_branch_id') and len(arguments.to_branch_id)>#arguments.to_branch_id#,</cfif>
                        <cfif isdefined('arguments.assetp_id') and len(arguments.assetp_id)>#arguments.assetp_id#,</cfif>
                        <cfif isdefined('arguments.project_id') and len(arguments.project_id)>#arguments.project_id#,</cfif>
                        <cfif isdefined('arguments.payroll_id') and len(arguments.payroll_id)>#arguments.payroll_id#,</cfif>
                        <cfif arguments.period_is_integrated>1,#arguments.account_card_type#<cfelse>0,0</cfif>,
                        #now()#,
                        <cfif isDefined("logindata.EMPLOYEE_ID")>
                            #logindata.EMPLOYEE_ID#,
                        <cfelseif isDefined("session.pp.userid")>
                            #SESSION.PP.USERID#,
                        <cfelseif isDefined("session.ww.userid")>
                            #SESSION.WW.USERID#,
                        </cfif>
                        '#CGI.REMOTE_ADDR#'
                    )
            </cfquery>
        </cfif>
        <cfreturn 1>
    </cffunction>

    <cffunction name="wrk_round" returntype="string" output="false">
        <cfargument name="number" required="true">
        <cfargument name="decimal_count" required="no" default="2">
        <cfargument name="kontrol_float" required="no" default="0"><!--- ürün ağacında çok ufak değerler girildiğinde E- formatında yazılanlar bozulmasın diye eklendi SM20101007 --->
        <cfscript>
            if (not len(arguments.number)) return '';
            if(arguments.kontrol_float eq 0)
            {
                if (arguments.number contains 'E') arguments.number = ReplaceNoCase(NumberFormat(arguments.number), ',', '', 'all');
            }
            else
            {
                if (arguments.number contains 'E') 
                {
                    first_value = listgetat(arguments.number,1,'E-');
                    first_value = ReplaceNoCase(first_value,',','.');
                    last_value = ReplaceNoCase(listgetat(arguments.number,2,'E-'),'0','','all');
                    //if(last_value gt 5) last_value = 5;
                    for(kk_float=1;kk_float lte last_value;kk_float=kk_float+1)
                    {
                        zero_info = ReplaceNoCase(first_value,'.','');
                        first_value = '0.#zero_info#';
                    }
                    arguments.number = first_value;
                            first_value = listgetat(arguments.number,1,'.');
                arguments.number = "#first_value#.#Left(listgetat(arguments.number,2,'.'),8)#";
                    if(arguments.number lt 0.00000001) arguments.number = 0;
                    return arguments.number;
                }
            }
            if (arguments.number contains '-'){
                negativeFlag = 1;
                arguments.number = ReplaceNoCase(arguments.number, '-', '', 'all');}
            else negativeFlag = 0;
            if(not isnumeric(arguments.decimal_count)) arguments.decimal_count= 2;	
            if(Find('.', arguments.number))
            {
                tam = listfirst(arguments.number,'.');
                onda =listlast(arguments.number,'.');
                if(onda neq 0 and arguments.decimal_count eq 0) //yuvarlama sayısı sıfırsa noktadan sonraki ilk rakama gore tam kısımda yuvarlama yapılır
                {
                    if(Mid(onda, 1,1) gte 5) // yuvarlama 
                        tam= tam+1;	
                }
                else if(onda neq 0 and len(onda) gt arguments.decimal_count)
                {
                    if(Mid(onda,arguments.decimal_count+1,1) gte 5) // yuvarlama
                    {
                        onda = Mid(onda,1,arguments.decimal_count);
                        textFormat_new = "0.#onda#";
                        textFormat_new = textFormat_new+1/(10^arguments.decimal_count);
                        
                        decimal_place_holder = '_.';
                        for(decimal_index=1;decimal_index<=arguments.decimal_count;++decimal_index)
                            decimal_place_holder = '#decimal_place_holder#_';
                        textFormat_new = LSNumberFormat(textFormat_new,decimal_place_holder);
                            
                        if(listlen(textFormat_new,'.') eq 2)
                        {
                            tam = tam + listfirst(textFormat_new,'.');
                            onda =listlast(textFormat_new,'.');
                        }
                        else
                        {
                            tam = tam + listfirst(textFormat_new,'.');
                            onda = '';
                        }
                    }
                    else
                        onda= Mid(onda,1,arguments.decimal_count);
                }
            }
            else
            {
                tam = arguments.number;
                onda = '';
            }
            textFormat='';
            if(len(onda) and onda neq 0 and arguments.decimal_count neq 0)
                textFormat = "#tam#.#onda#";
            else
                textFormat = "#tam#";
            if (negativeFlag) textFormat =  "-#textFormat#";
            return textFormat;
        </cfscript>
    </cffunction>

    <cffunction name="getwrkid" returntype="string">
        <cfreturn dateformat(now(),'YYYYMMDD')&timeformat(now(),'HHmmss')&'_#logindata.EMPLOYEE_ID#_'&round(rand()*100)>
    </cffunction>

    <cffunction name="get_result">
        <cfargument name="status" default="1">
        <cfargument name="message" default="">
        <cfargument name="data" default="{}">

        <cfset result = { status: arguments.status, message: arguments.message, data: arguments.data }>
        <cfreturn serializeJSON(result, "yes", "no")>
    </cffunction>
</cfcomponent>