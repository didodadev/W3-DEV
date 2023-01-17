<cfcomponent>

    <cfproperty name="queryJSONConverter">

    <cffunction name="init">
        <cfset this.queryJSONConverter = createObject("component","workcube.cfc.queryJSONConverter") />
        <cfreturn this />
    </cffunction>
    
    <cfif isdefined("session.pp")>
        <cfset session_base = evaluate('session.pp')>
    <cfelseif isdefined("session.ep")>
        <cfset session_base = evaluate('session.ep')>
    <cfelseif isdefined("session.wp")>
        <cfset session_base = evaluate('session.wp')>
    <cfelse>
        <cfset session_base = evaluate('session.ww')>
    </cfif>

    <cfset dsn = application.systemParam.systemParam().dsn>
    <cfset dsn1 = "#dsn#_product">
    <cfset dsn2 = "#dsn#_#session_base.period_year#_#session_base.company_id#">
    <cfset dsn3 = "#dsn#_#session_base.company_id#">
    <cfset dsn_alias = application.systemParam.systemParam().dsn>
    <cfset dsn1_alias = "#dsn#_product">
    <cfset dsn3_alias = dsn3>
    

    <cfset sql_unicode = application.functions.sql_unicode>
    <cfset wrk_round = application.functions.wrk_round>
    <cfset filternum = application.functions.filternum>
    <cfset tlformat = application.functions.TLFormat>
    <cfset get_product_account = application.functions.get_product_account>
    <cfset specer = application.mmFunctions.specer>
    <cfset cfquery = application.Functions.cfquery>

    <cffunction name="list" access="public">
        <cfargument name="wexdata">
        
        <cfparam name="arguments.wexdata.product_catid" default="">
        <cfparam name="arguments.wexdata.product_cat" default="">
        <cfparam name="arguments.wexdata.product_keyword" default="">
        <cfparam name="arguments.wexdata.barcode" default="">
        <cfparam name="arguments.wexdata.serial_number" default="">
        <cfparam name="arguments.wexdata.manufacturer_code" default="">
        <cfparam name="arguments.wexdata.stock_code" default="">
        <cfparam name="arguments.wexdata.price_catid" default="">
        <cfparam name="arguments.wexdata.search_company_id" default="">
        <cfparam name="arguments.wexdata.pos_code" default="">
        <cfparam name="arguments.wexdata.sort_type" default="0">
        <cfparam name="arguments.wexdata.product_keyword2" default="">
        <cfparam name="arguments.wexdata.startrow" default="0">
        <cfparam name="arguments.wexdata.maxrows" default="100">
        <cfparam name="is_expense_revenue_center" default="0">
        <cfset arguments.wexdata.money_currency = "#session_base.MONEY#">
        <cfparam name="arguments.wexdata.str_money_currency" default="#arguments.wexdata.money_currency#"> 
        <cfif not isDefined("arguments.wexdata.flt_price_other_amount") or not len(arguments.wexdata.flt_price_other_amount)>
            <cfset arguments.wexdata.flt_price_other_amount = 0>
        </cfif>
        <cfset arguments.wexdata.use_other_discounts = 1>
        <cfset arguments.wexdata.unit_multiplier = 1>
        <cfset arguments.wexdata.is_multiple_price_flag = 0>
        <cfset IS_LOT_NO_BASED = "">

        <cfif isdefined("arguments.wexdata.search_process_date") and isdate(arguments.wexdata.search_process_date)>
            <cf_date tarih='arguments.wexdata.search_process_date'>
            <cfset price_date = dateadd('h',hour(now()),arguments.wexdata.search_process_date)>
        <cfelse>
            <cfset price_date = now()>
        </cfif>

        <cfset arguments.wexdata.sale_product = 1>
        <cfset arguments.wexdata.url_str = "">
        <cfset department_name = "">
        <cfset dept_loc_info_=''>
        
        <cfif isdefined('arguments.wexdata.departmen_location_info')>
            <cfset dept_loc_info_ = arguments.wexdata.departmen_location_info>
        </cfif>
        <cfparam name="arguments.wexdata.departmen_location_info" default="#dept_loc_info_#">

        <cfquery name="query_get_all_location" datasource="#DSN#">
            SELECT DEPARTMENT_ID, LOCATION_ID, COMMENT FROM STOCKS_LOCATION
        </cfquery>
        <cfif isDefined('arguments.wexdata.amount_multiplier')>
            <cfset arguments.wexdata.amount_multiplier = filterNum(arguments.wexdata.amount_multiplier)>
        </cfif>
        <cfif not (isDefined('arguments.wexdata.amount_multiplier') and isnumeric(arguments.wexdata.amount_multiplier) and arguments.wexdata.amount_multiplier gt 0)>
            <cfset arguments.wexdata.amount_multiplier = 1>
        </cfif>

        <cfquery name="query_get_moneys" datasource="#DSN#">
            SELECT
                MONEY,
                RATE1,
                RATE2
            FROM
                SETUP_MONEY
            WHERE
                COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.company_id#"> AND
                PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.period_id#"> AND
                MONEY_STATUS = 1
        </cfquery>

        <cfquery name="DEFAULT_MONEY" datasource="#dsn#">
            SELECT
                MONEY,
                RATE1,
                RATE2
            FROM
                SETUP_MONEY
            WHERE
                COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.company_id#"> AND
                RATE1=1 AND RATE2=1 AND
                PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.period_id#">
        </cfquery>

        <cfif isDefined('arguments.wexdata.serial_number')>
            <cfquery name="query_get_serial_products" datasource="#DSN3#">
                SELECT DISTINCT STOCK_ID FROM SERVICE_GUARANTY_NEW WHERE SERIAL_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.wexdata.serial_number#">
            </cfquery>
            <cfif query_get_serial_products.recordcount>
                <cfset seri_stock_id_list = valueList(query_get_serial_products.STOCK_ID)>
            <cfelse>
                <cfset seri_stock_id_list = "">
            </cfif>
        </cfif>

        
        <cfquery name="query_products" datasource="#DSN1#">
            WITH CTE1 AS (
            SELECT DISTINCT
                STOCKS.STOCK_ID,
                STOCKS.PRODUCT_ID,
                STOCKS.STOCK_CODE,
                GS.PRODUCT_STOCK,
                #dsn#.Get_Dynamic_Language(PRODUCT.PRODUCT_ID,'#session_base.language#','PRODUCT','PRODUCT_NAME',NULL,NULL,PRODUCT.PRODUCT_NAME) AS PRODUCT_NAME,
                PRODUCT.PRODUCT_CODE,
                STOCKS.STOCK_CODE_2 PRODUCT_CODE_2,
                STOCKS.STOCK_CODE_2,
                PRODUCT.PRODUCT_DETAIL,
                PRODUCT.PRODUCT_DETAIL2,
                STOCKS.PROPERTY,
                STOCKS.BARCOD AS BARCOD,
                PRODUCT.IS_INVENTORY,
                PRODUCT.IS_PRODUCTION,
                PRODUCT.CUSTOMS_RECIPE_CODE,
                PRODUCT.TAX AS TAX,
                PRODUCT.OTV AS OTV,
                PRODUCT.BSMV AS BSMV,
                PRODUCT.OIV,
                PRODUCT.IS_ZERO_STOCK,
                PRODUCT.PRODUCT_CATID,
                PC.PRODUCT_CAT,
                PRODUCT.IS_SERIAL_NO,
                STOCKS.MANUFACT_CODE,
                PRICE_STANDART.PRICE,
                PRICE_STANDART.PRICE_KDV,
                PRICE_STANDART.MONEY,
                PRODUCT_UNIT.ADD_UNIT,
                PRODUCT_UNIT.PRODUCT_UNIT_ID,
                PRODUCT_UNIT.MAIN_UNIT,
                PRODUCT_UNIT.MULTIPLIER,
                GPA.UNIT GPA_UNIT,
                GPA.PRICE AS GPA_PRICE,
                GPA.PRICE_KDV GPA_PRICE_KDV,
                GPA.MONEY GPA_MONEY,
                GPA.PRICE_CATID GPA_PRICE_CATID,
                GPA.CATALOG_ID GPA_CATALOG_ID,
                '' DELIVER_DATE,
                (SELECT TOP 1 PIMG.PATH FROM #dsn3#.PRODUCT_IMAGES PIMG WHERE PRODUCT.PRODUCT_ID = PIMG.PRODUCT_ID AND (PIMG.IMAGE_SIZE = 0 OR PIMG.IMAGE_SIZE =1 OR PIMG.IMAGE_SIZE = 2)) AS PATH,
                (SELECT TOP 1 REASON_CODE FROM #dsn3#.PRODUCT_PERIOD WHERE PRODUCT_PERIOD.PRODUCT_ID = PRODUCT.PRODUCT_ID AND PRODUCT_PERIOD.PERIOD_ID= #session_base.period_id#) AS REASON_CODE
            FROM
                PRODUCT
                JOIN STOCKS ON STOCKS.PRODUCT_ID = PRODUCT.PRODUCT_ID
                JOIN #dsn1#.PRODUCT_OUR_COMPANY ON PRODUCT_OUR_COMPANY.PRODUCT_ID = PRODUCT.PRODUCT_ID
                JOIN PRODUCT_UNIT ON PRODUCT_UNIT.PRODUCT_ID = PRODUCT.PRODUCT_ID
                JOIN PRICE_STANDART ON PRODUCT_UNIT.PRODUCT_UNIT_ID = PRICE_STANDART.UNIT_ID AND PRICE_STANDART.PRODUCT_ID = STOCKS.PRODUCT_ID
                LEFT JOIN #dsn2#.GET_STOCK GS ON GS.STOCK_ID = STOCKS.STOCK_ID
                LEFT JOIN #dsn3#.PRODUCT_CAT AS PC ON PC.PRODUCT_CATID = PRODUCT.PRODUCT_CATID
                LEFT JOIN
                (
                    SELECT 
                        price_all.*,
                        SM.RATE1,
                        SM.RATE2
                    FROM
                    (
                        SELECT  
                        P.UNIT,
                        P.PRICE,
                        P.PRICE_KDV,
                        P.PRODUCT_ID,
                        P.MONEY,
                        P.PRICE_CATID,
                        P.CATALOG_ID
                        FROM 
                            #dsn3#.PRICE P,
                            #dsn3#.PRODUCT PR
                        WHERE
                            P.PRODUCT_ID = PR.PRODUCT_ID AND 
                            P.PRICE_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.wexdata.price_catid#"> AND
                            (
                                P.STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#price_date#"> AND
                                (P.FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#price_date#"> OR P.FINISHDATE IS NULL)
                            )
                            AND ISNULL(P.SPECT_VAR_ID, 0) = 0
                            <cfif len(arguments.wexdata.product_catid)>
                                AND PR.PRODUCT_CODE LIKE (SELECT HIERARCHY FROM PRODUCT_CAT WHERE PRODUCT_CATID= <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.wexdata.product_catid#">)+'.%' <!---kategori hiyerarşisine gore arama yapıyor --->
                            </cfif>
                            <cfif len(arguments.wexdata.pos_code)>
                                AND PR.PRODUCT_MANAGER=<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.wexdata.pos_code#">
                            </cfif>
                            <cfif len(arguments.wexdata.search_company_id)>
                                AND PR.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.wexdata.search_company_id#">
                            </cfif>
                            <cfif isDefined("arguments.wexdata.product_keyword") and len(arguments.wexdata.product_keyword) gt 1>
                                AND
                                    (
                                        (
                                            PR.PRODUCT_ID IN
                                                (
                                                    SELECT
                                                        S.PRODUCT_ID
                                                    FROM
                                                        STOCKS S
                                                    WHERE
                                                        S.PRODUCT_ID = PR.PRODUCT_ID AND
                                                        (S.STOCK_CODE LIKE '<cfif len(arguments.wexdata.product_keyword) gte 3>%</cfif>#arguments.wexdata.product_keyword#%' OR
                                                        S.STOCK_CODE_2 LIKE '<cfif len(arguments.wexdata.product_keyword) gte 3>%</cfif>#arguments.wexdata.product_keyword#%')
                                                ) OR
                                            PR.PRODUCT_CODE LIKE '<cfif len(arguments.wexdata.product_keyword) gte 3>%</cfif>#arguments.wexdata.product_keyword#%' OR
                                            PR.PRODUCT_CODE_2 LIKE '<cfif len(arguments.wexdata.product_keyword) gte 3>%</cfif>#arguments.wexdata.product_keyword#%' OR
                                            PR.PRODUCT_DETAIL LIKE '<cfif len(arguments.wexdata.product_keyword) gte 3>%</cfif>#arguments.wexdata.product_keyword#%' OR
                                            PR.PRODUCT_NAME LIKE #sql_unicode()#'%#arguments.wexdata.product_keyword#%'
                                            <cfif listlen(arguments.wexdata.product_keyword,"+") gt 1 and len(arguments.wexdata.product_keyword) gt 3>
                                            OR	(
                                                    <cfloop from="1" to="#listlen(arguments.wexdata.product_keyword,'+')#" index="pro_index">
                                                        PR.PRODUCT_NAME LIKE #sql_unicode()#'<cfif pro_index neq 1>%</cfif>#ListGetAt(arguments.wexdata.product_keyword,pro_index,"+")#%' 
                                                        <cfif pro_index neq listlen(arguments.wexdata.product_keyword,'+')>AND</cfif>
                                                    </cfloop>
                                                )		
                                            </cfif>
                                        ) OR
                                        PR.BARCOD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.wexdata.product_keyword#"> OR
                                        PR.MANUFACT_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.wexdata.product_keyword#%">
                                    )
                            <cfelseif isDefined("arguments.wexdata.product_keyword") and len(arguments.wexdata.product_keyword) eq 1>
                                AND	PR.PRODUCT_NAME LIKE #sql_unicode()#'#arguments.wexdata.product_keyword#%' 
                            </cfif>
                            
                    ) AS price_all
                    JOIN #dsn2#.SETUP_MONEY SM ON SM.MONEY = price_all.MONEY
                )  AS GPA ON GPA.PRODUCT_ID = PRODUCT.PRODUCT_ID AND GPA.UNIT = PRODUCT_UNIT.PRODUCT_UNIT_ID 
            WHERE
                PRODUCT_OUR_COMPANY.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.company_id#"> AND
                <cfif isDefined("arguments.wexdata.serial_number") and len(arguments.wexdata.serial_number) and isDefined("seri_stock_id_list") and listlen(seri_stock_id_list)>
                    STOCKS.STOCK_ID IN (#seri_stock_id_list#) AND
                <cfelseif isDefined("arguments.wexdata.serial_number") and len(arguments.wexdata.serial_number) and not listlen(seri_stock_id_list)>
                    STOCKS.STOCK_ID IS NULL AND
                </cfif>
                PRODUCT.PRODUCT_STATUS = 1 AND
                STOCKS.STOCK_STATUS = 1 AND
                PRODUCT_UNIT.PRODUCT_UNIT_STATUS = 1 AND
                PRODUCT.IS_SALES = 1
                <cfif len(arguments.wexdata.product_catid)>
                    AND PRODUCT.PRODUCT_CODE LIKE (SELECT HIERARCHY FROM PRODUCT_CAT WHERE PRODUCT_CATID=<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.wexdata.product_catid#">)+'.%'
                </cfif>
                <cfif len(arguments.wexdata.pos_code)>
                    AND PRODUCT.PRODUCT_MANAGER=<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.wexdata.pos_code#">
                </cfif>
                <cfif len(arguments.wexdata.search_company_id)>
                    AND PRODUCT.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.wexdata.search_company_id#">
                </cfif>
                AND PRICE_STANDART.PRICESTANDART_STATUS = 1
                AND PRICE_STANDART.PURCHASESALES = 1
                <cfif isDefined("arguments.wexdata.product_keyword") and len(arguments.wexdata.product_keyword) gt 1>
                    AND
                        (
                            (
                            STOCKS.STOCK_CODE LIKE '<cfif len(arguments.wexdata.product_keyword) gt 2>%</cfif>#arguments.wexdata.product_keyword#%' OR
                            STOCKS.STOCK_CODE_2 LIKE '<cfif len(arguments.wexdata.product_keyword) gt 2>%</cfif>#arguments.wexdata.product_keyword#%' OR
                            PRODUCT.PRODUCT_DETAIL LIKE '#arguments.wexdata.product_keyword#%' OR
                            PRODUCT.PRODUCT_CODE_2 LIKE '#arguments.wexdata.product_keyword#%'
                            <cfif len(arguments.wexdata.product_keyword) lte 2>
                                OR PRODUCT.PRODUCT_NAME LIKE #sql_unicode()#'#arguments.wexdata.product_keyword#%' 
                            <cfelseif len(arguments.wexdata.product_keyword) gt 2>
                                <cfif listlen(arguments.wexdata.product_keyword,"+") gt 1>
                                OR	(
                                        <cfloop from="1" to="#listlen(arguments.wexdata.product_keyword,'+')#" index="pro_index">
                                            PRODUCT.PRODUCT_NAME LIKE #sql_unicode()#'<cfif pro_index neq 1>%</cfif>#ListGetAt(arguments.wexdata.product_keyword,pro_index,"+")#%' 
                                            <cfif pro_index neq listlen(arguments.wexdata.product_keyword,'+')>AND</cfif>
                                        </cfloop>
                                    )		
                                <cfelse>
                                    OR PRODUCT.PRODUCT_NAME LIKE #sql_unicode()#'%#arguments.wexdata.product_keyword#%'
                                    OR PRODUCT.PRODUCT_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#replace(arguments.wexdata.product_keyword,"+","")#%">
                                </cfif>
                            </cfif>
                            ) OR
                            STOCKS.BARCOD = '#arguments.wexdata.product_keyword#' OR
                            STOCKS.MANUFACT_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.wexdata.product_keyword#%">
                        )
                <cfelseif isDefined("arguments.wexdata.product_keyword") and len(arguments.wexdata.product_keyword) eq 1>
                    AND	PRODUCT.PRODUCT_NAME LIKE #sql_unicode()#'#arguments.wexdata.product_keyword#%' 
                </cfif>
                    AND 
                    (
                        GS.PRODUCT_STOCK > 0
                    )
                <cfif isdefined("new_stock_id_list") and listlen(new_stock_id_list)>
                    AND STOCKS.STOCK_ID IN(#new_stock_id_list#)
                </cfif>
                <cfif isdefined("arguments.wexdata.barcode") and len(arguments.wexdata.barcode)>
                    AND ( PRODUCT.BARCOD = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.wexdata.barcode#"> )
                </cfif>
            ),
            CTE2 AS (
                    SELECT
                        CTE1.*,
                        ROW_NUMBER() OVER (
                                            <cfif isdefined('arguments.wexdata.sort_type') and arguments.wexdata.sort_type eq 0>
                                                ORDER BY PRODUCT_NAME, PROPERTY
                                            <cfelseif isdefined('arguments.wexdata.sort_type') and arguments.wexdata.sort_type eq 1>
                                                ORDER BY STOCK_CODE
                                            <cfelse>
                                                ORDER BY STOCK_CODE_2, PRODUCT_NAME
                                            </cfif>
                                        ) AS RowNum,(SELECT COUNT(*) FROM CTE1) AS QUERY_COUNT
                    FROM
                        CTE1
                )
                SELECT
                    CTE2.*
                FROM
                    CTE2
                WHERE
                    RowNum BETWEEN #arguments.wexdata.startrow# and #arguments.wexdata.startrow#+(#arguments.wexdata.maxrows#-1)	
        </cfquery>

        <cfparam name="arguments.wexdata.totalrecords" default="#query_products.query_count#">
        <cfset product_id_list=''>
        <cfset stock_list =''>
        <cfset dept_stock_id_list=''>
        <cfset other_dept_stock_id_list=''>
        <cfif isdefined("arguments.wexdata.is_submit_form")>
            <cfloop query="query_products" >
                <cfif not listfind(stock_list,query_products.STOCK_ID)>
                    <cfset stock_list = listappend(stock_list,query_products.STOCK_ID)>
                </cfif>
            </cfloop>
            <cfloop query="query_products">
                <cfif not listfind(product_id_list,query_products.PRODUCT_ID)>
                    <cfset product_id_list = listappend(product_id_list,query_products.PRODUCT_ID)>
                </cfif>
            </cfloop>
        </cfif>
        <cfif len(product_id_list)>
            <cfquery name="query_get_product_units" datasource="#DSN3#">
                SELECT ADD_UNIT,MAIN_UNIT,MULTIPLIER,PRODUCT_UNIT_ID,PRODUCT_ID FROM PRODUCT_UNIT WHERE PRODUCT_ID IN (#product_id_list#) AND PRODUCT_UNIT_STATUS = 1
            </cfquery>
        </cfif>
        <cfset products = arrayNew(1)>
        <cfloop query="query_products">
            <cfset product = structNew()>
            <cfquery name="query_get_units" dbtype="query">
                SELECT DISTINCT ADD_UNIT,PRODUCT_UNIT_ID,MULTIPLIER,MAIN_UNIT FROM query_get_product_units WHERE PRODUCT_ID = #query_products.PRODUCT_ID#
            </cfquery>
            <cfquery name="get_product_all_multip" datasource="#dsn3#">
                SELECT
                    PRODUCT_UNIT.MULTIPLIER,PRODUCT_UNIT.ADD_UNIT,PRODUCT_UNIT.PRODUCT_UNIT_ID,
                    PRODUCT.IS_COST,
                    PRODUCT.IS_ZERO_STOCK,
                    PRODUCT.IS_KARMA,
                    PRODUCT.IS_KARMA_SEVK,
                    PRODUCT.PRODUCT_CODE_2
                FROM
                    PRODUCT_UNIT,PRODUCT
                WHERE
                    PRODUCT_UNIT.PRODUCT_ID = PRODUCT.PRODUCT_ID AND
                    PRODUCT_UNIT.PRODUCT_ID = #query_products.PRODUCT_ID#
            </cfquery>
            <cfquery name="query_get_product_exp_center" datasource="#dsn3#">
                SELECT
                <cfif isdefined('arguments.wexdata.is_sale_product') and arguments.wexdata.is_sale_product eq 1>
                    CP.EXPENSE_CENTER_ID EXPENSE_ID,
                    CP.INCOME_ITEM_ID EXPENSE_ITEM_ID,
                    CP.INCOME_ACTIVITY_TYPE_ID ACTIVITY_ID,
                <cfelse>
                    CP.COST_EXPENSE_CENTER_ID EXPENSE_ID,
                    CP.EXPENSE_ITEM_ID EXPENSE_ITEM_ID,
                    CP.ACTIVITY_TYPE_ID ACTIVITY_ID,
                </cfif>
                    ET.EXPENSE_ITEM_NAME,
                    EXC.EXPENSE
                FROM
                    PRODUCT_PERIOD CP
                    LEFT JOIN #dsn2#.EXPENSE_CENTER EXC ON 
                    <cfif isdefined('arguments.wexdata.is_sale_product') and arguments.wexdata.is_sale_product eq 1>
                        CP.EXPENSE_CENTER_ID = EXC.EXPENSE_ID
                    <cfelse>
                        CP.COST_EXPENSE_CENTER_ID = EXC.EXPENSE_ID
                    </cfif>
                    LEFT JOIN #dsn2#.EXPENSE_ITEMS ET ON 
                    <cfif isdefined('arguments.wexdata.is_sale_product') and arguments.wexdata.is_sale_product eq 1>
                        CP.INCOME_ITEM_ID = ET.EXPENSE_ITEM_ID
                    <cfelse>
                        CP.EXPENSE_ITEM_ID = ET.EXPENSE_ITEM_ID
                    </cfif>
                    WHERE CP.PRODUCT_ID = #query_products.PRODUCT_ID# AND PERIOD_ID = <cfqueryparam value = "#session_base.period_id#" CFSQLType = "cf_sql_integer">
            </cfquery>
            <cfif is_expense_revenue_center eq 1>
                <cfset expense_center_id = ( isdefined("arguments.wexdata.exp_cntr_code") ) ? listfirst(arguments.wexdata.exp_cntr_code,';') : ''>
                <cfset expense_center_name = ( isdefined("arguments.wexdata.exp_cntr_code") ) ? listlast(arguments.wexdata.exp_cntr_code,';') : ''>
                <cfset expense_item_id = ( isdefined("arguments.wexdata.budget_items") ) ? listfirst(arguments.wexdata.budget_items,';') : ''>
                <cfset expense_item_name = ( isdefined("arguments.wexdata.budget_items") ) ? listlast(arguments.wexdata.budget_items,';') : ''>
                <cfif not len(expense_item_id)>
                    <cfset expense_item_id = ( query_get_product_exp_center.recordcount ) ? query_get_product_exp_center.EXPENSE_ITEM_ID : ''>
                    <cfset expense_item_name = ( query_get_product_exp_center.recordcount ) ? query_get_product_exp_center.EXPENSE_ITEM_NAME : ''>
                </cfif>
            <cfelse>
                <cfset expense_center_id = ( query_get_product_exp_center.recordcount ) ? query_get_product_exp_center.EXPENSE_ID : ''>
                <cfset expense_center_name = ( query_get_product_exp_center.recordcount ) ? query_get_product_exp_center.EXPENSE : ''>
                <cfset expense_item_id = ( query_get_product_exp_center.recordcount ) ? query_get_product_exp_center.EXPENSE_ITEM_ID : ''>
                <cfset expense_item_name = ( query_get_product_exp_center.recordcount ) ? query_get_product_exp_center.EXPENSE_ITEM_NAME : ''>
            </cfif>
            <cfset activity_type_id = ( query_get_product_exp_center.recordcount ) ? query_get_product_exp_center.ACTIVITY_ID : ''>
            <cfif not len(arguments.wexdata.unit_multiplier)>
                <cfquery name="query_get_multip" dbtype="query">
                    SELECT MULTIPLIER,ADD_UNIT FROM get_product_all_multip WHERE PRODUCT_UNIT_ID = #arguments.wexdata.UNIT_ID#
                </cfquery>
                <cfset arguments.wexdata.page_unit = query_get_multip.ADD_UNIT>
                <cfset arguments.wexdata.page_unit_multiplier = query_get_multip.MULTIPLIER>
            <cfelse>
                <cfset arguments.wexdata.page_unit = get_product_all_multip.ADD_UNIT>
                <cfset arguments.wexdata.page_unit_multiplier = arguments.wexdata.unit_multiplier>
            </cfif>

            <cfif ListFind("TL,YTL", query_products.money)>
                <cfset attributes.money = session_base.money>
            <cfelse>
                <cfset attributes.money = query_products.money>
            </cfif>
            
            <cfloop query="query_get_moneys">
                <cfif query_get_moneys.money is attributes.money>
                    <cfset row_money = money >
                    <cfset row_money_rate1 = query_get_moneys.rate1>
                    <cfset row_money_rate2 = query_get_moneys.rate2>
                    <cfset musteri_row_money_rate1 = query_get_moneys.rate1>
                    <cfset musteri_row_money_rate2 = query_get_moneys.rate2>
                </cfif>
                <cfif query_get_moneys.money is query_products.GPA_MONEY>
                    <cfset musteri_row_money_rate1 = query_get_moneys.rate1>
                    <cfset musteri_row_money_rate2 = query_get_moneys.rate2>
                </cfif>
            </cfloop>
            <cfset pro_price = query_products.price>
            <cfset pro_price_kdv = query_products.price_kdv>

            <cfif arguments.wexdata.price_catid neq -2>	
                <cfscript>
                    if(len(GPA_PRICE)){ 
                        musteri_pro_price = GPA_PRICE; 
                        musteri_pro_price_kdv= GPA_PRICE_KDV; 
                        musteri_row_money = GPA_MONEY;
                    }
                    else{ 
                        musteri_pro_price = 0;
                        musteri_pro_price_kdv = 0;
                        musteri_row_money =	default_money.money;
                        musteri_row_money_rate1 = 1;
                        musteri_row_money_rate2 = 1;
                    }
                </cfscript>
                <cfscript>
                    if(musteri_row_money is default_money.money){
                        musteri_str_other_money = musteri_row_money; 
                        musteri_flt_other_money_value = musteri_pro_price;
                        musteri_flt_other_money_value_kdv = musteri_pro_price_kdv;	
                        musteri_flag_prc_other = 0;
                    }
                    else{
                        musteri_flag_prc_other = 1 ;
                        musteri_str_other_money = musteri_row_money; 
                        musteri_flt_other_money_value = musteri_pro_price;
                        musteri_flt_other_money_value_kdv = musteri_pro_price_kdv;	
                        musteri_pro_price = musteri_pro_price*(musteri_row_money_rate2/musteri_row_money_rate1);
                    }
                </cfscript>
            <cfelse>
                <cfscript>
                    musteri_flt_other_money_value = pro_price;
                    musteri_flt_other_money_value_kdv = pro_price_kdv;
                    musteri_str_other_money = row_money;
                    musteri_row_money = row_money;
                    musteri_flag_prc_other = 1;
                    musteri_pro_price = pro_price*(row_money_rate2/row_money_rate1);
                    musteri_str_other_money = default_money.money;
                </cfscript>
            </cfif>

            <cfset arguments.wexdata.str_money_currency = musteri_str_other_money>
            <cfset arguments.wexdata.TL = 1>
            <cfset arguments.wexdata.flt_price_other_amount = musteri_flt_other_money_value>

            <cfif arguments.wexdata.str_money_currency eq arguments.wexdata.money_currency>
                <cfset arguments.wexdata.flt_price = musteri_flt_other_money_value>
            <cfelseif isdefined("arguments.wexdata.#arguments.wexdata.str_money_currency#")>
                <cfset arguments.wexdata.flt_price = musteri_flt_other_money_value * evaluate("arguments.wexdata.#arguments.wexdata.str_money_currency#")>
            <cfelse>
                <cfset arguments.wexdata.flt_price = musteri_flt_other_money_value >
            </cfif>
            <cfset arguments.wexdata.flt_miktar = 1>
            <cfif arguments.wexdata.is_multiple_price_flag>
                <cfset arguments.wexdata.flt_price = arguments.wexdata.flt_price * arguments.wexdata.page_unit_multiplier>
                <cfset arguments.wexdata.flt_price_other_amount = arguments.wexdata.flt_price_other_amount * arguments.wexdata.page_unit_multiplier>
            </cfif>

            <cfscript>
                // indirimler default 0
                if(not isdefined("arguments.wexdata.d1"))
                arguments.wexdata.d1 = 0;
                if(not isdefined("arguments.wexdata.d2"))
                arguments.wexdata.d2 = 0;
                if(not isdefined("arguments.wexdata.d3"))
                arguments.wexdata.d3 = 0;
                if(not isdefined("arguments.wexdata.d4"))
                arguments.wexdata.d4 = 0;
                if(not isdefined("arguments.wexdata.d5"))
                arguments.wexdata.d5 = 0;
                if(not isdefined("arguments.wexdata.d6"))
                arguments.wexdata.d6 = 0;
                arguments.wexdata.d7 = 0;
                arguments.wexdata.d8 = 0;
                arguments.wexdata.d9 = 0;
                arguments.wexdata.d10= 0;
                arguments.wexdata.disc_amount = 0;
            </cfscript>
            <!--- alis islemleri icin gelen blok eklenmedi ---->
            <cfif arguments.wexdata.is_sale_product eq 1 and isdefined('arguments.wexdata.int_basket_id') and arguments.wexdata.int_basket_id neq 51 and arguments.wexdata.int_basket_id neq 52>
                <cfif isdefined('arguments.wexdata.use_general_price_cat_exceptions') and arguments.wexdata.use_general_price_cat_exceptions eq 1>
                    <cfquery name="query_get_general_discounts" datasource="#dsn3#" maxrows="1">
                        SELECT
                            *
                        FROM 
                            PRICE_CAT_EXCEPTIONS
                        WHERE
                            ((ISNULL(IS_GENERAL,0)=1 AND ACT_TYPE = 3) OR (ISNULL(IS_GENERAL,0)=0 AND ACT_TYPE = 1))
                            AND CONTRACT_ID IS NULL
                            AND (SUPPLIER_ID IS NULL OR SUPPLIER_ID = (SELECT COMPANY_ID FROM STOCKS WHERE STOCK_ID = #query_products.stock_id#))
                            AND (PRODUCT_ID IS NULL OR PRODUCT_ID = #query_products.product_id#)
                            AND (BRAND_ID IS NULL OR BRAND_ID=(SELECT BRAND_ID FROM STOCKS WHERE STOCK_ID = #query_products.stock_id#))
                            AND (PRODUCT_CATID IS NULL OR PRODUCT_CATID = (SELECT PRODUCT_CATID FROM STOCKS WHERE STOCK_ID = #query_products.stock_id#))
                            AND (SHORT_CODE_ID IS NULL OR SHORT_CODE_ID=(SELECT SHORT_CODE_ID FROM STOCKS WHERE STOCK_ID = #query_products.stock_id#))
                            <cfif isdefined('arguments.wexdata.company_id') and len(arguments.wexdata.company_id)>
                                AND (COMPANYCAT_ID IS NULL OR COMPANYCAT_ID = (SELECT COMPANYCAT_ID FROM #dsn#.COMPANY WHERE COMPANY_ID = #arguments.wexdata.company_id#))
                            </cfif>
                            <cfif isdefined('arguments.wexdata.company_id') and len(arguments.wexdata.company_id)>
                                AND	(COMPANY_ID = #arguments.wexdata.company_id# OR (CONSUMER_ID IS NULL AND COMPANY_ID IS NULL))
                            <cfelseif isdefined('arguments.wexdata.consumer_id') and len(arguments.wexdata.consumer_id)>
                                AND (CONSUMER_ID = #arguments.wexdata.consumer_id# OR (CONSUMER_ID IS NULL AND COMPANY_ID IS NULL))
                            </cfif>
                            <cfif isdefined("arguments.wexdata.price_catid") and len(arguments.wexdata.price_catid)> <!--- fiyat listesi secilmemisse standart alıs fiyatından kontrol eder --->
                                AND PRICE_CATID = #arguments.wexdata.price_catid#
                            <cfelse>
                                AND PRICE_CATID=-2
                            </cfif>
                        ORDER BY PRODUCT_ID DESC,BRAND_ID DESC,PRODUCT_CATID DESC,SUPPLIER_ID DESC,COMPANYCAT_ID DESC,SHORT_CODE_ID DESC
                    </cfquery>
                    <cfif query_get_general_discounts.recordcount neq 0 and len(query_get_general_discounts.PAYMENT_TYPE_ID)>
                        <cfset arguments.wexdata.row_paymethod_id = query_get_general_discounts.PAYMENT_TYPE_ID>
                    </cfif>
                    <cfif query_get_general_discounts.recordcount neq 0 and len(query_get_general_discounts.DISCOUNT_RATE)>
                        <cfset arguments.wexdata.d1 = query_get_general_discounts.DISCOUNT_RATE>
                        <cfset arguments.wexdata.kontrol_discount = 1>
                    </cfif>
                    <cfif query_get_general_discounts.recordcount neq 0 and len(query_get_general_discounts.DISCOUNT_RATE_2)>
                        <cfset arguments.wexdata.d2 = query_get_general_discounts.DISCOUNT_RATE_2>
                        <cfset arguments.wexdata.kontrol_discount = 1>
                    </cfif>
                    <cfif query_get_general_discounts.recordcount neq 0 and len(query_get_general_discounts.DISCOUNT_RATE_3)>
                        <cfset arguments.wexdata.d3 = query_get_general_discounts.DISCOUNT_RATE_3>
                        <cfset arguments.wexdata.kontrol_discount = 1>
                    </cfif>
                    <cfif query_get_general_discounts.recordcount neq 0 and len(query_get_general_discounts.DISCOUNT_RATE_4)>
                        <cfset arguments.wexdata.d4 = query_get_general_discounts.DISCOUNT_RATE_4>
                        <cfset arguments.wexdata.kontrol_discount = 1>
                    </cfif>
                    <cfif query_get_general_discounts.recordcount neq 0 and len(query_get_general_discounts.DISCOUNT_RATE_5)>
                        <cfset arguments.wexdata.d5 = query_get_general_discounts.DISCOUNT_RATE_5>
                        <cfset arguments.wexdata.kontrol_discount = 1>
                    </cfif>
                <cfelse>
                    <cfset query_get_general_discounts.recordcount=0>
                </cfif>

                <!--- proje iskontoları dahil edilmedi --->
                <cfset query_get_project_discounts.recordcount = 0>
                <cfif isdefined('arguments.wexdata.row_promotion_id') and len(arguments.wexdata.row_promotion_id)>
                    <cfquery name="query_get_promotion_discount" datasource="#dsn3#" maxrows="1"><!---list_product sayfasındaki form_productta iskonto tutar, % iskonto set edilirse bu query silinebilir --->
                        SELECT
                            DISCOUNT,AMOUNT_DISCOUNT,AMOUNT_DISCOUNT_MONEY_1,PROM_ID,DUE_DAY,TARGET_DUE_DATE
                        FROM
                            PROMOTIONS
                        WHERE
                            PROM_STATUS = 1
                            AND PROM_ID = #arguments.wexdata.row_promotion_id#
                    </cfquery>
                    <cfif query_get_promotion_discount.recordcount>
                        <cfif len(query_get_promotion_discount.DUE_DAY)>
                            <cfset arguments.wexdata.prom_due_date = query_get_promotion_discount.DUE_DAY>
                        <cfelseif len(query_get_promotion_discount.TARGET_DUE_DATE) and isdefined("arguments.wexdata.search_process_date") and len(arguments.wexdata.search_process_date)>
                            <cfset arguments.wexdata.prom_due_date = datediff('d',arguments.wexdata.search_process_date,query_get_promotion_discount.TARGET_DUE_DATE)>
                        <cfelse>
                            <cfset arguments.wexdata.prom_due_date = ''>
                        </cfif>
                        <cfif len(query_get_promotion_discount.AMOUNT_DISCOUNT) and query_get_promotion_discount.AMOUNT_DISCOUNT neq 0>
                            <cfif not len(query_get_promotion_discount.AMOUNT_DISCOUNT_MONEY_1) or (arguments.wexdata.str_money_currency is query_get_promotion_discount.AMOUNT_DISCOUNT_MONEY_1)><!---  urunun para birimi ile promosyon iskonto tutarı para birimi aynı ise tutar aynen alınır yoksa urun para birimine cevirilir --->
                                <cfset arguments.wexdata.disc_amount = arguments.wexdata.disc_amount + query_get_promotion_discount.AMOUNT_DISCOUNT>
                            <cfelse>
                                <cfset arguments.wexdata.disc_amount = arguments.wexdata.disc_amount + wrk_round( ( (query_get_promotion_discount.AMOUNT_DISCOUNT * evaluate("arguments.wexdata.#query_get_promotion_discount.AMOUNT_DISCOUNT_MONEY_1#"))/evaluate("arguments.wexdata.#arguments.wexdata.str_money_currency#") ),4)>
                            </cfif>
            
                        </cfif>
                    </cfif>
                </cfif>
            </cfif>

            <cfscript>
                product.stock_code = query_products.stock_code;
                if (isDefined("xml_use_ozel_code") and xml_use_ozel_code eq 1) {
                    product.product_code_2 = query_products.product_code_2;
                }
                if (isdefined('xml_use_manufact_code') and xml_use_manufact_code eq 1) {
                    product.manufact_code = query_products.manufact_code;
                }
                if (is_lot_no_based eq 1) {
                    product.lot_no = query_products.lot_no;
                    product.deliver_date = query_products.deliver_date;
                    product.stock_amount = tlformat(query_products.stock_amount, 2);
                }
                if (isDefined('xml_use_department_filter') and xml_use_department_filter eq 1) {
                    if (isdefined('get_dept_stock_info')) {
                        if (isdefined('xml_use_department_filter') and xml_use_department_filter eq 1 and is_lot_no_based eq 1) {
                            lot_no_ = replaceNocase(product.lot_no, '-', '_', 'all');
                            lot_no_ = filterSpecialChars(lot_no_);
                            lot_no_ = trim(lot_no_);
                            if (isdefined('dept_stock_id_#product.stock_id#_#lot_no_#') and len(evaluate('dept_stock_id_#product.stock_id#_#lot_no_#'))) {
                                dept_amount_ = evaluate('dept_stock_id_#product.stock_id#_#lot_no_#');
                                if (isdefined('xml_dsp_unit_based_dept_stock') and xml_dsp_unit_based_dept_stock eq 1 and len(dept_amount_)) {
                                    for (qgu = 1; qgu <= query_get_units.recordcount; qgu++) {
                                        if (len(query_get_units["MULTIPLIER"][qgu]) and query_get_units["MULTIPLIER"][qgu] neq 0) {
                                            temp_amount_ = query_get_units["MULTIPLIER"][qgu];
                                        } else {
                                            temp_amount_ = 1;
                                        }
                                        product.dept_amount = tlformat(dept_amount_/temp_amount_) & " " & query_get_units["ADD_UNIT"][qgu];
                                    }
                                } else {
                                    product.dept_amount = dept_amount_;
                                }
                            }
                        }
                    }
                }
                if (isdefined('xml_use_other_dept_info') and listlen(xml_use_other_dept_info,'-') eq 2) {
                    if (isDefined("query_get_other_dept_stock_info")) {
                        product.other_dept_stock = TLFormat(query_get_other_dept_stock_info.total_dept_stock_2[listfind(other_dept_stock_id_list,STOCK_ID)]);
                    }
                }
                product.name_product_   = '#query_products.product_name# #query_products.property#';
                product.name_product_   = ReplaceNoCase(product.name_product_,'"','','all');
                product.name_product_   = ReplaceNoCase(product.name_product_,"'","","all");
                product.category_name   = query_products.PRODUCT_CAT;
                product.category_catid  = query_products.PRODUCT_CATID;
                product.pro_id          = query_products.product_id;
                product.stk_id          = query_products.stock_id;
                product.stk_code        = query_products.stock_code;
                product.brc_code        = query_products.barcod;
                product.man_code        = query_products.manufact_code;
                product.product_detail2 = query_products.PRODUCT_DETAIL2;
                product.is_inventory    = query_products.is_inventory;
                product.tax_end         = query_products.tax;
                product.ser_no          = query_products.is_serial_no;
                product.is_production   = query_products.is_production;
                product.otv_            = query_products.otv;
                product.bsmv_           = query_products.bsmv;
                product.oiv_            = query_products.oiv;	
                product.reason_code     = query_products.reason_code;	
                product.path            = '/documents/product/#query_products.path#';
                product.product_detail2 = Replace(Replace(product.product_detail2,'"','','all'),"'","","all");
                product.d1 = isDefined("arguments.wexdata.d1") ? arguments.wexdata.d1 : 0;
                product.d2 = isDefined("arguments.wexdata.d2") ? arguments.wexdata.d2 : 0;
                product.d3 = isDefined("arguments.wexdata.d3") ? arguments.wexdata.d3 : 0;
                product.d4 = isDefined("arguments.wexdata.d4") ? arguments.wexdata.d4 : 0;
                product.d5 = isDefined("arguments.wexdata.d5") ? arguments.wexdata.d5 : 0;
                product.d6 = isDefined("arguments.wexdata.d6") ? arguments.wexdata.d6 : 0;
                product.d7 = isDefined("arguments.wexdata.d7") ? arguments.wexdata.d7 : 0;
                product.d8 = isDefined("arguments.wexdata.d8") ? arguments.wexdata.d8 : 0;
                product.d9 = isDefined("arguments.wexdata.d9") ? arguments.wexdata.d9 : 0;
                product.d10 = isDefined("arguments.wexdata.d10") ? arguments.wexdata.d10 : 0;
                product.price_catid = arguments.wexdata.price_catid;
                product.price = arguments.wexdata.flt_price;
                product.price_kdv = musteri_flt_other_money_value_kdv;
                product.price_other = isDefined("arguments.wexdata.flt_price_other_amount") ? arguments.wexdata.flt_price_other_amount : '';
                if( len(arguments.wexdata.str_money_currency) )
                    product.money = arguments.wexdata.str_money_currency;
                else
                    product.money = arguments.wexdata.money_currency;
                product.add_basket      = arrayNew(1);
                for (qgu = 1; qgu <= query_get_units.recordcount; qgu++) {
                    if (len(query_get_units["MULTIPLIER"][qgu]) and query_get_units["MULTIPLIER"][qgu] neq 0) {
                        tmp_amount_ = query_get_units["MULTIPLIER"][qgu];
                    } else {
                        tmp_amount_ = 1;
                    }
                    add_item = structNew();
                    if (isdefined("prod_order_result_") and prod_order_result_ eq 1 and is_lot_no_based eq 1) {
                        add_item.op         = 'add_lot_no';
                        add_item.lot_no     = query_products.lot_no;
                        add_item.deliver_date = query_products.deliver_date;
                        add_item.unit       = query_get_units["ADD_UNIT"][qgu];
                        arrayAppend(product.add_basket, add_item);
                    } else {
                        add_item.op             = 'per_sepete_ekle';
                        add_item.pro_id         = product.pro_id;
                        add_item.stk_id         = product.stk_id;
                        add_item.stk_code       = product.stk_code;
                        add_item.brc_code       = product.brc_code;
                        add_item.man_code       = product.man_code;
                        add_item.name_product_  = product.name_product_;
                        add_item.product_unit_id = query_get_units["PRODUCT_UNIT_ID"][qgu];
                        add_item.ser_no         = product.ser_no;
                        add_item.flag_prc_other = isDefined("arguments.wexdata.is_price_other") and len(arguments.wexdata.is_price_other) ? arguments.wexdata.is_price_other : 0;
                        add_item.tax_end        = product.tax_end;
                        add_item.otv_           = product.otv_;
                        add_item.is_inventory   = product.is_inventory;
                        add_item.is_production  = product.is_production;
                        add_item.lot_no         = is_lot_no_based eq 1 ? query_products.lot_no : "";
                        add_item.expense_center_id = expense_center_id;
                        add_item.expense_center_name = expense_center_name;
                        add_item.expense_item_id = expense_item_id;
                        add_item.expense_item_name = expense_item_name;
                        add_item.activity_type_id = activity_type_id;
                        add_item.bsmv_          = product.bsmv_;
                        add_item.product_detail2 = product.product_detail2;
                        add_item.reason_code    = product.reason_code;
                        add_item.oiv_           = product.oiv_;
                        add_item.amount_multiplier = arguments.wexdata.amount_multiplier;
                        add_item.add_unit       = query_get_units["ADD_UNIT"][qgu];
                        add_item.temp_amount_   = isDefined('temp_amount_') ? temp_amount_ : '';

                        arrayAppend(product.add_basket, add_item);
                    }
                    add_item = structNew();
                    if (isDefined('is_price') and is_price) {
                        add_item.op             = 'per_sepete_ekle';
                        add_item.pro_id         = product.pro_id;
                        add_item.stk_id         = product.stk_id;
                        add_item.stk_code       = product.stk_code;
                        add_item.brc_code       = product.brc_code;
                        add_item.man_code       = product.man_code;
                        add_item.name_product_  = product.name_product_;
                        add_item.product_unit_id = query_get_units["PRODUCT_UNIT_ID"][qgu];
                        add_item.ser_no         = product.ser_no;
                        add_item.flag_prc_other = isDefined("arguments.wexdata.is_price_other") and len(arguments.wexdata.is_price_other) ? arguments.wexdata.is_price_other : 0;
                        add_item.tax_end        = product.tax_end;
                        add_item.otv_           = product.otv_;
                        add_item.is_inventory   = product.is_inventory;
                        add_item.is_production  = product.is_production;
                        add_item.lot_no         = is_lot_no_based eq 1 ? query_products.lot_no : "";
                        add_item.expense_center_id = expense_center_id;
                        add_item.expense_center_name = expense_center_name;
                        add_item.expense_item_id = expense_item_id;
                        add_item.expense_item_name = expense_item_name;
                        add_item.activity_type_id = activity_type_id;
                        add_item.bsmv_          = product.bsmv_;
                        add_item.product_detail2 = product.product_detail2;
                        add_item.reason_code    = product.reason_code;
                        add_item.oiv_           = product.oiv_;

                        arrayAppend(product.add_basket, add_item);
                    }
                }
            </cfscript>
            <cfif product.price gt 0>
            <cfset arrayAppend(products, product)>
            </cfif>
        </cfloop>

        <cfreturn Replace(serializeJson(products),"//","")>
        
    </cffunction>

    <cffunction name="add_row" access="public">
        <cfargument name="wexdata">

        <cfset arguments.wexdata.money_currency = "#session_base.MONEY#">
        <cfparam name="arguments.wexdata.department_id" default=""> 
        <cfparam name="arguments.wexdata.department_name" default=""> 
        <cfparam name="arguments.wexdata.is_basket_zero_stock" default="0"> 
        <cfparam name="arguments.wexdata.flt_price" default="0"> 
        <cfparam name="arguments.wexdata.str_money_currency" default="#arguments.wexdata.money_currency#"> 
        <cfparam name="arguments.wexdata.is_cost" default="0"> 
        <cfset arguments.wexdata.is_multiple_price_flag = 0>
        <cfset arguments.wexdata.kontrol_discount = 0>
        <cfif not (isDefined("arguments.wexdata.amount_multiplier") and len(arguments.wexdata.amount_multiplier))>
            <cfset arguments.wexdata.amount_multiplier = 1>
        </cfif>
        <cfif not isDefined("arguments.wexdata.flt_price_other_amount") or not len(arguments.wexdata.flt_price_other_amount)>
            <cfset arguments.wexdata.flt_price_other_amount = 0>
        </cfif>
        <cfset arguments.wexdata.TL = 1>
        <cfset arguments.wexdata.use_other_discounts = 1>
        <cfquery name="query_get_product_all_multip" datasource="#dsn3#">
            SELECT
                PRODUCT_UNIT.MULTIPLIER,PRODUCT_UNIT.ADD_UNIT,PRODUCT_UNIT.PRODUCT_UNIT_ID,
                PRODUCT.IS_COST,
                PRODUCT.IS_ZERO_STOCK,
                PRODUCT.IS_KARMA,
                PRODUCT.IS_KARMA_SEVK,
                PRODUCT.PRODUCT_CODE_2
            FROM
                PRODUCT_UNIT,PRODUCT
            WHERE
                PRODUCT_UNIT.PRODUCT_ID=PRODUCT.PRODUCT_ID AND
                PRODUCT_UNIT.PRODUCT_ID=#arguments.wexdata.product_id#
        </cfquery>
        <cfif isDefined("arguments.wexdata.basket_id") and len(arguments.wexdata.basket_id)>
            <cfquery name="query_get_amount_status" datasource="#dsn3#">
                SELECT IS_SELECTED FROM SETUP_BASKET_ROWS WHERE TITLE='is_use_add_unit' AND BASKET_ID = #arguments.wexdata.basket_id#
            </cfquery>
            <cfif not (isDefined("arguments.wexdata.unit_other") and len(arguments.wexdata.unit_other))>
                <cfquery name="query_get_product_unit_2" datasource="#dsn3#">
                    SELECT ADD_UNIT,MULTIPLIER FROM PRODUCT_UNIT WHERE PRODUCT_UNIT.PRODUCT_ID = #arguments.wexdata.product_id# AND IS_ADD_UNIT = 1
                </cfquery>
                <cfif query_get_product_unit_2.recordcount>
                    <cfset arguments.wexdata.unit_other = query_get_product_unit_2.ADD_UNIT>
                    <cfif isDefined("arguments.wexdata.amount_multipler") and len(arguments.wexdata.amount_multipler) and isnumeric(replace(arguments.wexdata.amount_multipler, ",", "."))>
                        <cfif isDefined("arguments.wexdata.multi_row") and len(arguments.wexdata.multi_row)>
                            <cfset arguments.wexdata.amount_other = 1>
                        <cfelseif isDefined("arguments.wexdata.number") and arguments.wexdata.number eq 3>
                            <cfset arguments.wexdata.amount_other = 1>
                        <cfelse>
                            <cfset arguments.wexdata.amount_other = arguments.wexdata.amount * replace(arguments.wexdata.amount_multipler, ",", ".") / query_get_product_unit_2.multipler>
                        </cfif>
                    <cfelse>
                        <cfif isDefined("arguments.wexdata.number") and arguments.wexdata.number eq 3>
                            <cfset arguments.wexdata.amount_other = 1>
                        <cfelse>
                            <cfset arguments.wexdata.amount_other = arguments.wexdata.amount / query_get_product_unit_2.multiplier>
                        </cfif>
                    </cfif>
                </cfif>
            </cfif>
        </cfif>
        <cfquery name="query_get_stock_info" datasource="#dsn3#">
            SELECT
                STOCK_CODE_2
            FROM
                STOCKS
            WHERE
                STOCK_ID = #arguments.wexdata.stock_id#
        </cfquery>
        <cfset arguments.wexdata.stock_code_2_ = replace(query_get_stock_info.STOCK_CODE_2, "'", "")>
        <cfif not (isDefined("arguments.wexdata.satir") and len(arguments.wexdata.satir))>
            <cfset arguments.wexdata.satir = -1>
        </cfif>
        <cfif query_get_product_all_multip.IS_KARMA eq 1 and query_get_product_all_multip.IS_KARMA_SEVK eq 1>
            <cfreturn '{"status":1, "data": ' & replace(serializeJSON(add_row_karma(arguments.wexdata)), '//', '') & '}'>
        <cfelse>
            <cfif query_get_product_all_multip.IS_KARMA eq 1 and query_get_product_all_multip.IS_KARMA_SEVK neq 1>
                <cfquery name="query_get_karma_product" datasource="#dsn1#">
                    SELECT 
                        KP.SPEC_MAIN_ID,
                        <cfif arguments.wexdata.is_sale_product eq 1>	KP.TAX	<cfelse>KP.TAX_PURCHASE AS TAX</cfif>,
                        KP.KARMA_PRODUCT_ID,
                        KP.STOCK_ID,
                        KP.PRODUCT_ID,
                        KP.PRODUCT_UNIT_ID,
                        KP.PRODUCT_AMOUNT,
                        KP.SALES_PRICE,
                        KP.OTHER_LIST_PRICE,
                        KP.ENTRY_ID,
                        <cfif session_base.period_year lt 2009>
                            CASE WHEN KP.MONEY ='TL' THEN '<cfoutput>#session_base.money#</cfoutput>' ELSE KP.MONEY END AS MONEY
                        <cfelseif session_base.period_year gte 2009>
                            CASE WHEN KP.MONEY ='YTL' THEN '<cfoutput>#session_base.money#</cfoutput>' ELSE KP.MONEY END AS MONEY
                        <cfelse>
                            KARMA_PRODUCTS.MONEY
                        </cfif> 
                    FROM 
                        KARMA_PRODUCTS KP
                    WHERE 
                        KP.KARMA_PRODUCT_ID = #arguments.wexdata.product_id#
                    ORDER BY 
                        ENTRY_ID
                </cfquery>
                <cfif not query_get_karma_product.recordcount>
                    <cfreturn '{"status": 0, "message": "Karma koli içeriğine ürün tanımlamalısınız"}'>
                </cfif>
            </cfif>
            <cfif arguments.wexdata.is_basket_zero_stock neq 1 and query_get_product_all_multip.IS_ZERO_STOCK eq 0 and arguments.wexdata.is_sale_product eq 1 and ( (isdefined('arguments.wexdata.is_chck_dept_based_stock') and arguments.wexdata.is_chck_dept_based_stock eq 1) or (session_base.our_company_info.workcube_sector is 'it' and ( (isdefined("arguments.wexdata.sepet_process_type") and listfind('52,53,62,81,85,86,111,112,113',arguments.wexdata.sepet_process_type)) or (isdefined("arguments.wexdata.int_basket_id") and listfind('10,21,48',arguments.wexdata.int_basket_id)) ) ) )>
                <cfset arguments.wexdata.urun_miktar = arguments.wexdata.amount * replace(arguments.wexdata.amount_multiplier,",",".")>
            <cfelse>
                <cfset arguments.wexdata.urun_miktar = arguments.wexdata.amount>
            </cfif>
            <cfif (isdefined('arguments.wexdata.department_out') and len(arguments.wexdata.department_out) and isdefined('arguments.wexdata.location_out') and len(arguments.wexdata.location_out)) or (isdefined('arguments.wexdata.departmen_location_info') and len(arguments.wexdata.departmen_location_info)) >
                <cfquery name="query_stock_location_amount" datasource="#dsn2#">
                    SELECT
                        SUM(SR.STOCK_IN - SR.STOCK_OUT) AS TOTAL_STOCK
                    FROM
                        #dsn_alias#.STOCKS_LOCATION SL,
                        STOCKS_ROW SR
                    WHERE
                        SR.STORE =SL.DEPARTMENT_ID
                        AND SR.STORE_LOCATION=SL.LOCATION_ID
                        <cfif isdefined('arguments.wexdata.departmen_location_info') and len(arguments.wexdata.departmen_location_info)>
                            AND SL.DEPARTMENT_ID = #listfirst(arguments.wexdata.departmen_location_info,'-')#
                            AND SL.LOCATION_ID = #listlast(arguments.wexdata.departmen_location_info,'-')#
                        <cfelse>
                            AND SL.DEPARTMENT_ID = #listfirst(arguments.wexdata.department_out,',')#
                            AND SL.LOCATION_ID = #listfirst(arguments.wexdata.location_out,',')# 
                        </cfif>
                        AND SR.STOCK_ID=#arguments.wexdata.stock_id#
                        <cfif isdefined('arguments.wexdata.spec_id') and len(arguments.wexdata.spec_id)>
                        AND SR.SPECT_VAR_ID=#arguments.wexdata.spec_id#
                        </cfif>
                        <cfif arguments.wexdata.is_basket_zero_stock_control_date eq 1 and len(arguments.wexdata.search_process_date)>
                            AND SR.PROCESS_DATE <= #arguments.wexdata.search_process_date#
                        </cfif>
                </cfquery>
                <cfif STOCK_LOCATION_AMOUNT.TOTAL_STOCK lte 0 or STOCK_LOCATION_AMOUNT.TOTAL_STOCK lt urun_miktar>
                    <cfreturn '{"status":0, "message": "Bu üründen stokta yeterli miktarda yoktur"}'>
                </cfif>
            </cfif>
            <cfif isdefined('arguments.wexdata.xml_use_other_dept_info_ss') and listlen(arguments.wexdata.xml_use_other_dept_info_ss,'-') eq 2>
                <cfif isdefined("arguments.wexdata.amount_multiplier") and len(arguments.wexdata.amount_multiplier) and isnumeric(replace(arguments.wexdata.amount_multiplier,",","."))>
                    <cfset arguments.wexdata.urun_miktar= arguments.wexdata.amount* replace(arguments.wexdata.amount_multiplier,",",".")>
                <cfelse>
                    <cfset arguments.wexdata.urun_miktar = arguments.wexdata.amount>
                </cfif>
                <cfset getComponent = createObject('component','V16.objects.cfc.get_stock_detail')>
                <cfset query_get_stock_reserved = getComponent.GET_STOCK_RESERVED(xml_use_other_dept_info_ss : arguments.wexdata.xml_use_other_dept_info_ss, product_id_list : arguments.wexdata.product_id)>
                <cfset query_scrap_location_total_stock = getComponent.SCRAP_LOCATION_TOTAL_STOCK(xml_use_other_dept_info_ss : arguments.wexdata.xml_use_other_dept_info_ss, product_id_list : arguments.wexdata.product_id)>
                <cfset query_product_total_stock = getComponent.PRODUCT_TOTAL_STOCK(xml_use_other_dept_info_ss : arguments.wexdata.xml_use_other_dept_info_ss, product_id_list : arguments.wexdata.product_id)>
                <cfset query_get_prod_reserved_ = getComponent.GET_PROD_RESERVED_(xml_use_other_dept_info_ss : arguments.wexdata.xml_use_other_dept_info_ss, product_id_list : arguments.wexdata.product_id)>
                <cfset query_location_based_total_stock = getComponent.location_based_total_stock(xml_use_other_dept_info_ss : arguments.wexdata.xml_use_other_dept_info_ss, product_id_list : arguments.wexdata.product_id)>
                <cfif query_product_total_stock.recordcount and len(query_product_total_stock.product_total_stock)>
                    <cfset arguments.wexdata.product_stocks = query_product_total_stock.product_total_stock>
                <cfelse>
                    <cfset arguments.wexdata.product_stocks = 0>
                </cfif>
                <cfif query_scrap_location_total_stock.recordcount and len(query_scrap_location_total_stock.total_scrap_stock) and query_scrap_location_total_stock.total_scrap_stock gt 0>
                    <cfset arguments.wexdata.product_stocks = arguments.wexdata.product_stocks - query_scrap_location_total_stock.total_scrap_stock>
                    <cfset arguments.wexdata.a = "#query_scrap_location_total_stock.total_scrap_stock#">
                </cfif>
                <cfif query_get_stock_reserved.recordcount and len(query_get_stock_reserved.artan)>
                    <cfset arguments.wexdata.product_stocks = arguments.wexdata.product_stocks + query_get_stock_reserved.artan>
                    <cfset arguments.wexdata.b = "#query_get_stock_reserved.artan#">
                </cfif>
                <cfif query_get_stock_reserved.recordcount and len(query_get_stock_reserved.azalan)>
                    <cfset arguments.wexdata.product_stocks = arguments.wexdata.product_stocks - query_get_stock_reserved.azalan>
                    <cfset arguments.wexdata.c= "#get_stock_reserved.azalan#">
                </cfif>
                <cfif query_get_prod_reserved_.recordcount>
                    <cfif len(query_get_prod_reserved_.azalan)>
                        <cfset arguments.wexdata.product_stocks = arguments.wexdata.product_stocks - query_get_prod_reserved_.azalan><cfset d= "#query_get_prod_reserved_.azalan#">
                    </cfif>
                    <cfif len(query_get_prod_reserved_.artan)>
                        <cfset arguments.wexdata.product_stocks = arguments.wexdata.product_stocks + query_get_prod_reserved_.artan>
                        <cfset arguments.wexdata.e= "#query_get_prod_reserved_.artan#">
                    </cfif>
                </cfif>
                <cfif query_location_based_total_stock.recordcount and len(query_location_based_total_stock.total_location_stock)>
                    <cfset arguments.wexdata.product_stocks = arguments.wexdata.product_stocks - query_location_based_total_stock.total_location_stock>
                    <cfset arguments.wexdata.f= "#location_based_total_stock.total_location_stock#">
                </cfif>
                <cfif isdefined("arguments.wexdata.product_stocks") and len(arguments.wexdata.product_stocks)>
                    <cfif (arguments.wexdata.product_stocks lte 0 or arguments.wexdata.product_stocks lt arguments.wexdata.urun_miktar) and (arguments.wexdata.is_basket_zero_stock eq 0 and query_get_product_all_multip.IS_ZERO_STOCK eq 0)>
                        <cfreturn '{"status":0, "message": "Bu üründen stokta yeterli miktarda yoktur"}'>
                    </cfif>
                </cfif>
            </cfif>
            <cfif not len(arguments.wexdata.unit_multiplier)>
                <cfquery name="query_get_multip" dbtype="query">
                    SELECT MULTIPLIER,ADD_UNIT FROM get_product_all_multip WHERE PRODUCT_UNIT_ID = #arguments.wexdata.UNIT_ID#
                </cfquery>
                <cfset arguments.wexdata.page_unit = query_get_multip.ADD_UNIT>
                <cfset arguments.wexdata.page_unit_multiplier = query_get_multip.MULTIPLIER>
            <cfelse>
                <cfset arguments.wexdata.page_unit = arguments.wexdata.unit>
                <cfset arguments.wexdata.page_unit_multiplier = arguments.wexdata.unit_multiplier>
            </cfif>
        </cfif>
        <cfif isdefined("arguments.wexdata.from_price_page") and arguments.wexdata.from_price_page eq 1>
            <cfif len(arguments.wexdata.flt_price_other_amount) and isnumeric(arguments.wexdata.flt_price_other_amount)>
                <cfset arguments.wexdata.flt_price_other_amount = arguments.wexdata.flt_price_other_amount>
                <cfif arguments.wexdata.str_money_currency eq arguments.wexdata.money_currency>
                    <cfset arguments.wexdata.flt_price = arguments.wexdata.flt_price_other_amount>
                <cfelse>
                    <cfif isdefined("arguments.wexdata.#arguments.wexdata.str_money_currency#")>
                        <cfset arguments.wexdata.flt_price = arguments.wexdata.flt_price_other_amount * evaluate("arguments.wexdata.#arguments.wexdata.str_money_currency#")>
                    <cfelse>
                        <cfreturn '{"status": 0, "message": "Ürün İçin Seçtiğiniz Fiyatın Para Birimi Tanımlı Değil.Para Birimi Tanımlarınızı Kontrol Ediniz!" }'>
                    </cfif>
                </cfif>
            </cfif>
        <cfelse>
            <cfif (isdefined("arguments.wexdata.basket_id") and arguments.wexdata.basket_id eq 6) or (isdefined("arguments.wexdata.int_basket_id") and arguments.wexdata.int_basket_id eq 6)>
                <cfquery name="query_get_minimum_order" datasource="#dsn3#">
                    SELECT MINIMUM_ORDER_UNIT_ID,MINIMUM_ORDER_STOCK_VALUE FROM STOCK_STRATEGY WHERE STOCK_ID = #arguments.wexdata.stock_id# AND ISNULL(DEPARTMENT_ID,0)=0
                </cfquery>
                <cfif len(query_get_minimum_order.MINIMUM_ORDER_UNIT_ID) and len(get_minimum_order.MINIMUM_ORDER_STOCK_VALUE)>
                    <cfif (arguments.wexdata.unit_id eq query_get_minimum_order.MINIMUM_ORDER_UNIT_ID)>
                        <cfif arguments.wexdata.amount_multiplier gte query_get_minimum_order.MINIMUM_ORDER_STOCK_VALUE>
                            <cfset arguments.wexdata.flt_miktar = arguments.wexdata.amount_multiplier>
                        <cfelse>
                            <cfset arguments.wexdata.flt_miktar = query_get_minimum_order.MINIMUM_ORDER_STOCK_VALUE>
                        </cfif>
                    <cfelse>
                        <cfquery name="query_get_strategy_unit" dbtype="query">
                            SELECT MULTIPLIER,ADD_UNIT FROM get_product_all_multip WHERE PRODUCT_UNIT_ID = #query_get_minimum_order.MINIMUM_ORDER_UNIT_ID#
                        </cfquery>
                        <cfif len(query_get_strategy_unit.MULTIPLIER) and len(query_get_minimum_order.MINIMUM_ORDER_STOCK_VALUE)>
                            <cfif (arguments.wexdata.amount_multiplier * arguments.wexdata.amount) gte (query_get_strategy_unit.MULTIPLIER * query_get_minimum_order.MINIMUM_ORDER_STOCK_VALUE)>
                                <cfset arguments.wexdata.flt_miktar = arguments.wexdata.amount_multiplier>
                            <cfelse>
                                <cfset arguments.wexdata.flt_miktar = (query_get_strategy_unit.MULTIPLIER * query_get_minimum_order.MINIMUM_ORDER_STOCK_VALUE) / arguments.wexdata.amount>
                            </cfif>
                        <cfelse>
                            <cfset arguments.wexdata.flt_miktar = arguments.wexdata.amount_multiplier>
                        </cfif>
                    </cfif>
                <cfelse>
                    <cfset arguments.wexdata.flt_miktar = arguments.wexdata.amount_multiplier>
                </cfif>
            <cfelse>
                <cfset arguments.wexdata.flt_miktar = 1>
            </cfif>
            <cfif arguments.wexdata.is_multiple_price_flag>
                <cfset arguments.wexdata.flt_price = arguments.wexdata.flt_price * arguments.wexdata.page_unit_multiplier>
                <cfset arguments.wexdata.flt_price_other_amount = arguments.wexdata.flt_price_other_amount * arguments.wexdata.page_unit_multiplier>
            </cfif>
            <cfscript>
                // indirimler default 0
                if(not isdefined("arguments.wexdata.d1"))
                arguments.wexdata.d1 = 0;
                if(not isdefined("arguments.wexdata.d2"))
                arguments.wexdata.d2 = 0;
                if(not isdefined("arguments.wexdata.d3"))
                arguments.wexdata.d3 = 0;
                if(not isdefined("arguments.wexdata.d4"))
                arguments.wexdata.d4 = 0;
                if(not isdefined("arguments.wexdata.d5"))
                arguments.wexdata.d5 = 0;
                if(not isdefined("arguments.wexdata.d6"))
                arguments.wexdata.d6 = 0;
                arguments.wexdata.d7 = 0;
                arguments.wexdata.d8 = 0;
                arguments.wexdata.d9 = 0;
                arguments.wexdata.d10= 0;
                arguments.wexdata.disc_amount = 0;
            </cfscript>
            <!--- alis islemleri icin gelen blok eklenmedi ---->
            <cfif arguments.wexdata.is_sale_product eq 1 and isdefined('arguments.wexdata.int_basket_id') and arguments.wexdata.int_basket_id neq 51 and arguments.wexdata.int_basket_id neq 52>
                <cfif isdefined('arguments.wexdata.use_general_price_cat_exceptions') and arguments.wexdata.use_general_price_cat_exceptions eq 1>
                    <cfquery name="query_get_general_discounts" datasource="#dsn3#" maxrows="1">
                        SELECT
                            *
                        FROM 
                            PRICE_CAT_EXCEPTIONS
                        WHERE
                            ((ISNULL(IS_GENERAL,0)=1 AND ACT_TYPE = 3) OR (ISNULL(IS_GENERAL,0)=0 AND ACT_TYPE = 1))
                            AND CONTRACT_ID IS NULL
                            AND (SUPPLIER_ID IS NULL OR SUPPLIER_ID = (SELECT COMPANY_ID FROM STOCKS WHERE STOCK_ID = #arguments.wexdata.stock_id#))
                            AND (PRODUCT_ID IS NULL OR PRODUCT_ID = #arguments.wexdata.product_id#)
                            AND (BRAND_ID IS NULL OR BRAND_ID=(SELECT BRAND_ID FROM STOCKS WHERE STOCK_ID = #arguments.wexdata.stock_id#))
                            AND (PRODUCT_CATID IS NULL OR PRODUCT_CATID = (SELECT PRODUCT_CATID FROM STOCKS WHERE STOCK_ID = #arguments.wexdata.stock_id#))
                            AND (SHORT_CODE_ID IS NULL OR SHORT_CODE_ID=(SELECT SHORT_CODE_ID FROM STOCKS WHERE STOCK_ID = #arguments.wexdata.stock_id#))
                            <cfif isdefined('arguments.wexdata.company_id') and len(arguments.wexdata.company_id)>
                                AND (COMPANYCAT_ID IS NULL OR COMPANYCAT_ID = (SELECT COMPANYCAT_ID FROM #dsn#.COMPANY WHERE COMPANY_ID = #arguments.wexdata.company_id#))
                            </cfif>
                            <cfif isdefined('arguments.wexdata.company_id') and len(arguments.wexdata.company_id)>
                                AND	(COMPANY_ID = #arguments.wexdata.company_id# OR (CONSUMER_ID IS NULL AND COMPANY_ID IS NULL))
                            <cfelseif isdefined('arguments.wexdata.consumer_id') and len(arguments.wexdata.consumer_id)>
                                AND (CONSUMER_ID = #arguments.wexdata.consumer_id# OR (CONSUMER_ID IS NULL AND COMPANY_ID IS NULL))
                            </cfif>
                            <cfif isdefined("arguments.wexdata.price_catid") and len(arguments.wexdata.price_catid)> <!--- fiyat listesi secilmemisse standart alıs fiyatından kontrol eder --->
                                AND PRICE_CATID = #arguments.wexdata.price_catid#
                            <cfelse>
                                AND PRICE_CATID=-2
                            </cfif>
                        ORDER BY PRODUCT_ID DESC,BRAND_ID DESC,PRODUCT_CATID DESC,SUPPLIER_ID DESC,COMPANYCAT_ID DESC,SHORT_CODE_ID DESC
                    </cfquery>
                    <cfif query_get_general_discounts.recordcount neq 0 and len(query_get_general_discounts.PAYMENT_TYPE_ID)>
                        <cfset arguments.wexdata.row_paymethod_id = query_get_general_discounts.PAYMENT_TYPE_ID>
                    </cfif>
                    <cfif query_get_general_discounts.recordcount neq 0 and len(query_get_general_discounts.DISCOUNT_RATE)>
                        <cfset arguments.wexdata.d1 = query_get_general_discounts.DISCOUNT_RATE>
                        <cfset arguments.wexdata.kontrol_discount = 1>
                    </cfif>
                    <cfif query_get_general_discounts.recordcount neq 0 and len(query_get_general_discounts.DISCOUNT_RATE_2)>
                        <cfset arguments.wexdata.d2 = query_get_general_discounts.DISCOUNT_RATE_2>
                        <cfset arguments.wexdata.kontrol_discount = 1>
                    </cfif>
                    <cfif query_get_general_discounts.recordcount neq 0 and len(query_get_general_discounts.DISCOUNT_RATE_3)>
                        <cfset arguments.wexdata.d3 = query_get_general_discounts.DISCOUNT_RATE_3>
                        <cfset arguments.wexdata.kontrol_discount = 1>
                    </cfif>
                    <cfif query_get_general_discounts.recordcount neq 0 and len(query_get_general_discounts.DISCOUNT_RATE_4)>
                        <cfset arguments.wexdata.d4 = query_get_general_discounts.DISCOUNT_RATE_4>
                        <cfset arguments.wexdata.kontrol_discount = 1>
                    </cfif>
                    <cfif query_get_general_discounts.recordcount neq 0 and len(query_get_general_discounts.DISCOUNT_RATE_5)>
                        <cfset arguments.wexdata.d5 = query_get_general_discounts.DISCOUNT_RATE_5>
                        <cfset arguments.wexdata.kontrol_discount = 1>
                    </cfif>
                <cfelse>
                    <cfset query_get_general_discounts.recordcount=0>
                </cfif>
                <cfquery name="query_get_contract_discounts" datasource="#dsn3#" maxrows="1">
                    SELECT
                        ISNULL(PC.DISCOUNT_RATE,0) DISCOUNT_RATE,
                        ISNULL(PC.DISCOUNT_RATE_2,0) DISCOUNT_RATE_2,
                        ISNULL(PC.DISCOUNT_RATE_3,0) DISCOUNT_RATE_3,
                        ISNULL(PC.DISCOUNT_RATE_4,0) DISCOUNT_RATE_4,
                        ISNULL(PC.DISCOUNT_RATE_5,0) DISCOUNT_RATE_5,
                        PC.PAYMENT_TYPE_ID
                    FROM 
                        PRICE_CAT_EXCEPTIONS PC,
                        RELATED_CONTRACT RC
                    WHERE
                        PC.CONTRACT_ID = RC.CONTRACT_ID
                        AND (PC.SUPPLIER_ID IS NULL OR PC.SUPPLIER_ID = (SELECT COMPANY_ID FROM STOCKS WHERE STOCK_ID = #arguments.wexdata.stock_id#))
                        AND (PC.PRODUCT_ID IS NULL OR PC.PRODUCT_ID = #arguments.wexdata.product_id#)
                        AND (PC.BRAND_ID IS NULL OR PC.BRAND_ID = (SELECT BRAND_ID FROM STOCKS WHERE STOCK_ID = #arguments.wexdata.stock_id#))
                        AND (PC.PRODUCT_CATID IS NULL OR PC.PRODUCT_CATID = (SELECT PRODUCT_CATID FROM STOCKS WHERE STOCK_ID = #arguments.wexdata.stock_id#) OR (SELECT STOCK_CODE FROM STOCKS WHERE STOCK_ID = #arguments.wexdata.stock_id#) LIKE (SELECT PCC.HIERARCHY FROM PRODUCT_CAT PCC WHERE PCC.PRODUCT_CATID = PC.PRODUCT_CATID)+'.%')
                        AND (PC.SHORT_CODE_ID IS NULL OR PC.SHORT_CODE_ID=(SELECT SHORT_CODE_ID FROM STOCKS WHERE STOCK_ID = #arguments.wexdata.stock_id#))
                        <cfif isdefined("arguments.wexdata.search_process_date") and len(arguments.wexdata.search_process_date)>
                            AND RC.STARTDATE <= #arguments.wexdata.search_process_date#
                            AND RC.FINISHDATE >= #arguments.wexdata.search_process_date#
                        <cfelse>
                            AND RC.STARTDATE <= #now()#
                            AND RC.FINISHDATE >= #now()#
                        </cfif>
                        <cfif isdefined('arguments.wexdata.company_id') and len(arguments.wexdata.company_id)>
                            AND	RC.COMPANY LIKE '%,#arguments.wexdata.company_id#,%'
                        <cfelseif isdefined('arguments.wexdata.consumer_id') and len(arguments.wexdata.consumer_id)>
                            AND	RC.CONSUMERS LIKE '%,#arguments.wexdata.consumer_id#,%'
                        </cfif>
                        <cfif isdefined("arguments.wexdata.price_catid") and len(arguments.wexdata.price_catid)> <!--- fiyat listesi secilmemisse standart alıs fiyatından kontrol eder --->
                            AND PC.PRICE_CATID = #arguments.wexdata.price_catid#
                        <cfelse>
                            AND PC.PRICE_CATID=-2
                        </cfif>
                    ORDER BY PC.PRODUCT_ID DESC,PC.BRAND_ID DESC,(SELECT PCC.HIERARCHY FROM PRODUCT_CAT PCC WHERE PCC.PRODUCT_CATID = PC.PRODUCT_CATID) DESC,PC.PRODUCT_CATID DESC,PC.SUPPLIER_ID DESC,PC.COMPANYCAT_ID DESC,PC.SHORT_CODE_ID DESC
                </cfquery>
                <cfif query_get_contract_discounts.recordcount>
                    <cfset arguments.wexdata.d1 = query_get_contract_discounts.DISCOUNT_RATE>
                    <cfset arguments.wexdata.d2 = query_get_contract_discounts.DISCOUNT_RATE_2>
                    <cfset arguments.wexdata.d3 = query_get_contract_discounts.DISCOUNT_RATE_3>
                    <cfset arguments.wexdata.d4 = query_get_contract_discounts.DISCOUNT_RATE_4>
                    <cfset arguments.wexdata.d5 = query_get_contract_discounts.DISCOUNT_RATE_5>
                    <cfset arguments.wexdata.row_paymethod_id = query_get_contract_discounts.PAYMENT_TYPE_ID>
                    <cfset arguments.wexdata.use_other_discounts = 0>
                </cfif>
                <!--- proje iskontoları dahil edilmedi --->
                <cfset query_get_project_discounts.recordcount = 0>
                <cfif arguments.wexdata.use_other_discounts eq 1>
                    <cfquery name="query_get_contracts" datasource="#dsn3#" maxrows="1">
                        SELECT
                            DISCOUNT1,
                            DISCOUNT2,
                            DISCOUNT3,
                            DISCOUNT4,
                            DISCOUNT5,
                            DISCOUNT_CASH,
                            DISCOUNT_CASH_MONEY
                        FROM
                            CONTRACT_SALES_PROD_DISCOUNT
                        WHERE
                            PRODUCT_ID = #arguments.wexdata.product_id#
                        <cfif isdefined('arguments.wexdata.use_paymethod_for_prod_conditions') and arguments.wexdata.use_paymethod_for_prod_conditions eq 1><!--- xmlde urun kosulları odeme yontemine gore calısır secilmisse --->
                            <cfif isdefined('arguments.wexdata.paymethod_id') and len(arguments.wexdata.paymethod_id)><!--- xmlde urun kosulları odeme yontemine gore calısır secilmisse ve islem detayda odeme yontemi secilmisse --->
                                AND PAYMETHOD_ID = #arguments.wexdata.paymethod_id# 
                            <cfelse>
                                AND 1=2 
                            </cfif>
                        </cfif>
                        <cfif isdefined("arguments.wexdata.company_id") and len(arguments.wexdata.company_id) and isdefined("arguments.wexdata.price_catid") and len(arguments.wexdata.price_catid)>
                            AND (COMPANY_ID = #arguments.wexdata.COMPANY_ID#
                            OR (COMPANY_ID IS NULL AND C_S_PROD_DISCOUNT_ID IN (SELECT C_S_PROD_DISCOUNT_ID FROM CONTRACT_SALES_PROD_PRICE_LIST CSPPL WHERE CSPPL.C_S_PROD_DISCOUNT_ID = CONTRACT_SALES_PROD_DISCOUNT.C_S_PROD_DISCOUNT_ID AND PRICE_CAT_ID IN (#arguments.wexdata.price_catid#))) )
                        <cfelseif isdefined("arguments.wexdata.price_catid") and len(arguments.wexdata.price_catid)>
                            AND COMPANY_ID IS NULL AND C_S_PROD_DISCOUNT_ID IN (SELECT C_S_PROD_DISCOUNT_ID FROM CONTRACT_SALES_PROD_PRICE_LIST CSPPL WHERE CSPPL.C_S_PROD_DISCOUNT_ID = CONTRACT_SALES_PROD_DISCOUNT.C_S_PROD_DISCOUNT_ID AND PRICE_CAT_ID IN (#arguments.wexdata.price_catid#))
                        <cfelseif isdefined("arguments.wexdata.company_id") and len(arguments.wexdata.company_id)>
                            AND COMPANY_ID = #arguments.wexdata.COMPANY_ID#
                        </cfif>
                        <cfif isdefined("arguments.wexdata.search_process_date") and len(arguments.wexdata.search_process_date)>
                            AND (
                                    START_DATE <= #arguments.wexdata.search_process_date#
                                    AND ( FINISH_DATE >= #arguments.wexdata.search_process_date# OR FINISH_DATE IS NULL )
                                )
                        <cfelse>
                            AND START_DATE <= #now()#
                            AND FINISH_DATE >= #now()#
                        </cfif>
                        ORDER BY
                            START_DATE DESC,
                            RECORD_DATE DESC
                    </cfquery>
                    <cfif not query_get_contracts.recordcount>
                        <cfquery name="query_get_contracts" datasource="#dsn3#" maxrows="1">
                            SELECT
                                DISCOUNT1,
                                DISCOUNT2,
                                DISCOUNT3,
                                DISCOUNT4,
                                DISCOUNT5,
                                DISCOUNT_CASH,
                                DISCOUNT_CASH_MONEY
                            FROM
                                CONTRACT_SALES_PROD_DISCOUNT
                            WHERE
                                PRODUCT_ID = #arguments.wexdata.product_id# AND
                                COMPANY_ID IS NULL AND
                            <cfif isdefined('arguments.wexdata.use_paymethod_for_prod_conditions') and arguments.wexdata.use_paymethod_for_prod_conditions eq 1><!--- xmlde urun kosulları odeme yontemine gore calısır secilmisse --->
                                <cfif isdefined('arguments.wexdata.paymethod_id') and len(arguments.wexdata.paymethod_id)><!--- xmlde urun kosulları odeme yontemine gore calısır secilmisse ve islem detayda odeme yontemi secilmisse --->
                                    PAYMETHOD_ID = #arguments.wexdata.paymethod_id# AND
                                <cfelse>
                                    1=2 AND
                                </cfif>
                            </cfif>
                                C_S_PROD_DISCOUNT_ID NOT IN (SELECT C_S_PROD_DISCOUNT_ID FROM CONTRACT_SALES_PROD_PRICE_LIST )  AND
                            <cfif isdefined("arguments.wexdata.search_process_date") and len(arguments.wexdata.search_process_date)>
                                (
                                    START_DATE <= #arguments.wexdata.search_process_date# AND
                                    (FINISH_DATE >= #arguments.wexdata.search_process_date# OR FINISH_DATE IS NULL)			
                                )
                            <cfelse>
                                START_DATE <= #now()# AND
                                FINISH_DATE >= #now()#
                            </cfif>
                            ORDER BY
                                START_DATE DESC,
                                RECORD_DATE DESC
                        </cfquery>
                    </cfif>
                    <cfscript>// indirimler anlaşma varsa
                        if(query_get_contracts.recordcount)
                        {
                            arguments.wexdata.d1 = query_get_contracts.discount1;
                            arguments.wexdata.d2 = query_get_contracts.discount2;
                            arguments.wexdata.d3 = query_get_contracts.discount3;
                            arguments.wexdata.d4 = query_get_contracts.discount4;
                            arguments.wexdata.d5 = query_get_contracts.discount5;
                            if(len(query_get_contracts.discount_cash))
                            {
                                if( arguments.wexdata.str_money_currency is query_get_contracts.discount_cash_money) //urunun para birimi ile retabe para birimi aynı ise tutar aynen alınır yoksa urun para birimine cevirilir
                                    arguments.wexdata.disc_amount = query_get_contracts.discount_cash;
                                else
                                    arguments.wexdata.disc_amount = wrk_round( ( (query_get_contracts.discount_cash * evaluate("arguments.wexdata.#query_get_contracts.discount_cash_money#"))/evaluate("arguments.wexdata.#arguments.wexdata.str_money_currency#") ),4);
                            }
                        }
                    </cfscript>
                    <cfif isdefined('arguments.wexdata.company_id') and len(arguments.wexdata.company_id) and ((isdefined("arguments.wexdata.branch_id") and isnumeric(arguments.wexdata.branch_id) ) or (not (isdefined('arguments.wexdata.branch_id') and len(arguments.wexdata.branch_id)) and isdefined('arguments.wexdata.int_basket_id') and listfind('3,4',arguments.wexdata.int_basket_id) and len(listlast(session_base.user_location,'-')) )) >
                        <cfquery name="query_get_sales_general_discounts" datasource="#dsn3#" maxrows="5">
                            SELECT
                                DISCOUNT
                            FROM
                                CONTRACT_SALES_GENERAL_DISCOUNT AS CS_GD,
                                CONTRACT_SALES_GENERAL_DISCOUNT_BRANCHES CS_GDB
                            WHERE
                                CS_GD.GENERAL_DISCOUNT_ID = CS_GDB.GENERAL_DISCOUNT_ID
                                <cfif not (isdefined('arguments.wexdata.branch_id') and len(arguments.wexdata.branch_id)) and isdefined('arguments.wexdata.int_basket_id') and listfind('3,4',arguments.wexdata.int_basket_id) and len(listlast(session_base.user_location,'-')) >
                                    AND CS_GDB.BRANCH_ID = #listlast(session_base.user_location,'-')#
                                <cfelse>
                                    AND CS_GDB.BRANCH_ID = #arguments.wexdata.branch_id#
                                </cfif>
                                AND CS_GD.COMPANY_ID = #arguments.wexdata.company_id#
                            <cfif isdefined("arguments.wexdata.search_process_date") and len(arguments.wexdata.search_process_date)>
                                AND CS_GD.START_DATE <= #arguments.wexdata.search_process_date#
                                AND CS_GD.FINISH_DATE >= #arguments.wexdata.search_process_date#
                            <cfelse>
                                AND CS_GD.START_DATE <= #now()#
                                AND CS_GD.FINISH_DATE >= #now()#
                            </cfif>
                            ORDER BY
                                CS_GD.GENERAL_DISCOUNT_ID
                        </cfquery>
                        <cfif query_get_sales_general_discounts.recordcount and not(isdefined("query_get_general_discounts") and query_get_general_discounts.recordcount gt 0 and arguments.wexdata.kontrol_discount eq 1)>
                            <cfloop query="query_get_sales_general_discounts">
                                <cfset 'arguments.wexdata.d#currentrow+5#' = query_get_sales_general_discounts.DISCOUNT>
                            </cfloop>
                        </cfif>
                    </cfif>
                </cfif>
                <cfif isdefined('arguments.wexdata.row_promotion_id') and len(arguments.wexdata.row_promotion_id)>
                    <cfquery name="query_get_promotion_discount" datasource="#dsn3#" maxrows="1"><!---list_product sayfasındaki form_productta iskonto tutar, % iskonto set edilirse bu query silinebilir --->
                        SELECT
                            DISCOUNT,AMOUNT_DISCOUNT,AMOUNT_DISCOUNT_MONEY_1,PROM_ID,DUE_DAY,TARGET_DUE_DATE
                        FROM
                            PROMOTIONS
                        WHERE
                            PROM_STATUS = 1
                            AND PROM_ID = #arguments.wexdata.row_promotion_id#
                    </cfquery>
                    <cfif query_get_promotion_discount.recordcount>
                        <cfif len(query_get_promotion_discount.DUE_DAY)>
                            <cfset arguments.wexdata.prom_due_date = query_get_promotion_discount.DUE_DAY>
                        <cfelseif len(query_get_promotion_discount.TARGET_DUE_DATE) and isdefined("arguments.wexdata.search_process_date") and len(arguments.wexdata.search_process_date)>
                            <cfset arguments.wexdata.prom_due_date = datediff('d',arguments.wexdata.search_process_date,query_get_promotion_discount.TARGET_DUE_DATE)>
                        <cfelse>
                            <cfset arguments.wexdata.prom_due_date = ''>
                        </cfif>
                        <cfif len(query_get_promotion_discount.AMOUNT_DISCOUNT) and query_get_promotion_discount.AMOUNT_DISCOUNT neq 0>
                            <cfif not len(query_get_promotion_discount.AMOUNT_DISCOUNT_MONEY_1) or (arguments.wexdata.str_money_currency is query_get_promotion_discount.AMOUNT_DISCOUNT_MONEY_1)><!---  urunun para birimi ile promosyon iskonto tutarı para birimi aynı ise tutar aynen alınır yoksa urun para birimine cevirilir --->
                                <cfset arguments.wexdata.disc_amount = arguments.wexdata.disc_amount + query_get_promotion_discount.AMOUNT_DISCOUNT>
                            <cfelse>
                                <cfset arguments.wexdata.disc_amount = arguments.wexdata.disc_amount + wrk_round( ( (query_get_promotion_discount.AMOUNT_DISCOUNT * evaluate("arguments.wexdata.#query_get_promotion_discount.AMOUNT_DISCOUNT_MONEY_1#"))/evaluate("arguments.wexdata.#arguments.wexdata.str_money_currency#") ),4)>
                            </cfif>
            
                        </cfif>
                    </cfif>
                </cfif>
            </cfif>
            <cfif not isdefined("arguments.wexdata.update_product_row_id")>
                <cfset arguments.wexdata.update_product_row_id = 0 >
            </cfif>
            <cfif session_base.our_company_info.is_cost_location eq 1 and listfind("53,52,62,70,71,72,78,79,88,111,112,113,116,119,141,531,532",arguments.wexdata.sepet_process_type) and len(query_get_product_all_multip.IS_COST) and query_get_product_all_multip.IS_COST>
                <cfquery name="query_get_product_cost" datasource="#dsn3#" maxrows="1">
                    SELECT
                        PC.PRODUCT_COST_ID,
                        PC.PURCHASE_NET_LOCATION_ALL * (SM.RATE2 / SM.RATE1) PURCHASE_NET,
                        PC.PURCHASE_EXTRA_COST_LOCATION * (SM.RATE2 / SM.RATE1) PURCHASE_EXTRA_COST
                    FROM
                        PRODUCT_COST PC,
                        #dsn2#.SETUP_MONEY SM
                    WHERE 
                        SM.MONEY = PC.PURCHASE_NET_MONEY AND
                        PC.PRODUCT_COST IS NOT NULL AND
                        <cfif isdefined("arguments.wexdata.search_process_date") and len(arguments.wexdata.search_process_date)>
                            PC.START_DATE < #DATEADD('d',1,arguments.wexdata.search_process_date)# AND 
                        <cfelse>
                            PC.START_DATE < #now()# AND
                        </cfif>
                        PC.PRODUCT_ID = #arguments.wexdata.product_id#
                        <cfif isdefined("arguments.wexdata.department_out") and len(arguments.wexdata.department_out)>
                            AND PC.DEPARTMENT_ID = #listfirst(arguments.wexdata.department_out)#	
                        </cfif>
                        <cfif isdefined("arguments.wexdata.location_out") and len(arguments.wexdata.location_out)>
                            AND PC.LOCATION_ID = #arguments.wexdata.location_out#	
                        </cfif>
                    ORDER BY 
                        PC.START_DATE DESC
                        --,PC.RECORD_DATE DESC
                        ,PC.PRODUCT_COST_ID DESC
                </cfquery>
            <cfelseif session_base.our_company_info.is_cost_location eq 2 and listfind("53,52,62,70,71,72,78,79,88,111,112,113,116,119,141,531,532",arguments.wexdata.sepet_process_type) and len(query_get_product_all_multip.IS_COST) and query_get_product_all_multip.IS_COST>
                <cfquery name="query_get_product_cost" datasource="#dsn3#" maxrows="1">
                    SELECT
                        PC.PRODUCT_COST_ID,
                        PC.PURCHASE_NET_DEPARTMENT_ALL * (SM.RATE2 / SM.RATE1) PURCHASE_NET,
                        PC.PURCHASE_EXTRA_COST_DEPARTMENT * (SM.RATE2 / SM.RATE1) PURCHASE_EXTRA_COST
                    FROM
                        PRODUCT_COST PC,
                        #dsn2#.SETUP_MONEY SM
                    WHERE 
                        SM.MONEY = PC.PURCHASE_NET_MONEY AND
                        PC.PRODUCT_COST IS NOT NULL AND
                        <cfif isdefined("arguments.wexdata.search_process_date") and len(arguments.wexdata.search_process_date)>
                            PC.START_DATE < #DATEADD('d',1,arguments.wexdata.search_process_date)# AND 
                        <cfelse>
                            PC.START_DATE < #now()# AND
                        </cfif>
                        PC.PRODUCT_ID = #arguments.wexdata.product_id#
                        <cfif isdefined("arguments.wexdata.department_out") and len(arguments.wexdata.department_out)>
                            AND PC.DEPARTMENT_ID = #listfirst(arguments.wexdata.department_out)#	
                        </cfif>
                    ORDER BY 
                        PC.START_DATE DESC
                        --,PC.RECORD_DATE DESC
                        ,PC.PRODUCT_COST_ID DESC
                </cfquery>
            <cfelseif (arguments.wexdata.is_sale_product eq 1 or (isdefined("arguments.wexdata.sepet_process_type") and listfind("110,111,112,113,114,115,119",arguments.wexdata.sepet_process_type)) or (isdefined('arguments.wexdata.int_basket_id') and listfind("50",arguments.wexdata.int_basket_id))) and len(query_get_product_all_multip.IS_COST) and query_get_product_all_multip.IS_COST>
                <cfquery name="query_get_product_cost" datasource="#dsn3#" maxrows="1">
                    SELECT
                        PC.PRODUCT_COST_ID,
                        PC.PURCHASE_NET_ALL * (SM.RATE2 / SM.RATE1) PURCHASE_NET,
                        PC.PURCHASE_EXTRA_COST * (SM.RATE2 / SM.RATE1) PURCHASE_EXTRA_COST
                    FROM
                        PRODUCT_COST PC,
                        #dsn2#.SETUP_MONEY SM
                    WHERE 
                        SM.MONEY = PC.PURCHASE_NET_MONEY AND
                        PC.PRODUCT_COST IS NOT NULL AND
                    <cfif isdefined("arguments.wexdata.search_process_date") and len(arguments.wexdata.search_process_date)>
                        PC.START_DATE < #DATEADD('d',1,arguments.wexdata.search_process_date)# AND 
                    <cfelse>
                        PC.START_DATE < #now()# AND
                    </cfif>
                        PC.PRODUCT_ID = #arguments.wexdata.product_id#
                    ORDER BY 
                        PC.START_DATE DESC
                        --,PC.RECORD_DATE DESC
                        ,PC.PRODUCT_COST_ID DESC
                </cfquery>
            <cfelseif isdefined("arguments.wexdata.sepet_process_type") and listfind('81',arguments.wexdata.sepet_process_type) and len(query_get_product_all_multip.IS_COST) and query_get_product_all_multip.IS_COST>
                <cfquery name="query_get_product_cost" datasource="#dsn3#" maxrows="1">
                    SELECT
                        PC.PRODUCT_COST_ID,
                        <cfif session_base.our_company_info.is_cost_location eq 2>
                            PC.PURCHASE_NET_DEPARTMENT_ALL * (SM.RATE2 / SM.RATE1) PURCHASE_NET,
                            PC.PURCHASE_EXTRA_COST_DEPARTMENT * (SM.RATE2 / SM.RATE1) PURCHASE_EXTRA_COST
                        <cfelseif session_base.our_company_info.is_cost_location eq 1>
                            PC.PURCHASE_NET_LOCATION_ALL * (SM.RATE2 / SM.RATE1) PURCHASE_NET,
                            PC.PURCHASE_EXTRA_COST_LOCATION * (SM.RATE2 / SM.RATE1) PURCHASE_EXTRA_COST
                        <cfelse>
                            PC.PURCHASE_NET_ALL * (SM.RATE2 / SM.RATE1) PURCHASE_NET,
                            PC.PURCHASE_EXTRA_COST * (SM.RATE2 / SM.RATE1) PURCHASE_EXTRA_COST
                        </cfif>
                    FROM
                        PRODUCT_COST PC,
                        #dsn2#.SETUP_MONEY SM
                    WHERE 
                        SM.MONEY = PC.PURCHASE_NET_MONEY AND
                        PC.PRODUCT_COST IS NOT NULL AND
                        <cfif isdefined("arguments.wexdata.search_process_date") and len(arguments.wexdata.search_process_date)>
                            PC.START_DATE < #DATEADD('d',1,arguments.wexdata.search_process_date)# AND 
                        <cfelse>
                            PC.START_DATE < #now()# AND
                        </cfif>
                        PC.PRODUCT_ID = #arguments.wexdata.product_id#
                        <cfif session_base.our_company_info.is_cost_location neq 0>
                            <cfif isdefined("arguments.wexdata.department_out") and len(arguments.wexdata.department_out)>
                                AND PC.DEPARTMENT_ID = #listfirst(arguments.wexdata.department_out)#	
                            </cfif>
                            <cfif session_base.our_company_info.is_cost_location eq 1>
                                <cfif isdefined("arguments.wexdata.location_out") and len(arguments.wexdata.location_out)>
                                    AND PC.LOCATION_ID = #arguments.wexdata.location_out#	
                                </cfif>
                            </cfif>
                        </cfif>
                    ORDER BY 
                        PC.START_DATE DESC
                        --,PC.RECORD_DATE DESC
                        ,PC.PRODUCT_COST_ID DESC
                </cfquery>
            </cfif>
            <cfscript>
                if(isdefined("arguments.wexdata.spec_id") and len(arguments.wexdata.spec_id))
                {
                    if(isdefined('arguments.wexdata.company_id') and len(arguments.wexdata.company_id))
                    {
                        spec_fonk=specer(
                                            dsn_type:dsn3,
                                            main_spec_id=arguments.wexdata.spec_id,
                                            add_to_main_spec=1,
                                            company_id=arguments.wexdata.company_id
                                        );
                    }
                    else if(isdefined('arguments.wexdata.consumer_id') and len(arguments.wexdata.consumer_id)){
                        spec_fonk=specer(
                                            dsn_type:dsn3,
                                            main_spec_id=arguments.wexdata.spec_id,
                                            add_to_main_spec=1,
                                            consumer_id=arguments.wexdata.consumer_id
                                        );
                    }
                    else{
                        spec_fonk=specer(
                                            dsn_type:dsn3,
                                            main_spec_id=arguments.wexdata.spec_id,
                                            add_to_main_spec=1
                                        );
                    }
                    arguments.wexdata.spec_name=listgetat(spec_fonk,3,',');
                    arguments.wexdata.spec_id=listgetat(spec_fonk,2,',');
                }else
                {
                    arguments.wexdata.spec_name='';
                    arguments.wexdata.spec_id='';
                }
                if(isdefined("arguments.wexdata.satir") and not len(arguments.wexdata.satir))
                arguments.wexdata.satir = -1;
            </cfscript>
            <cfset result = structNew()>
            <cfset result.product_id = arguments.wexdata.product_id>
            <cfset result.stock_id = arguments.wexdata.stock_id>
            <cfset result.stock_code = arguments.wexdata.stock_code>
            <cfset result.barcod = arguments.wexdata.barcod>
            <cfset result.manufact_code = arguments.wexdata.manufact_code>
            <cfset result.product_name = arguments.wexdata.product_name>
            <cfset result.unit_id = arguments.wexdata.unit_id>
            <cfset result.unit = arguments.wexdata.page_unit>
            <cfset result.spect_id = arguments.wexdata.spec_id>
            <cfset result.spect_name = arguments.wexdata.spec_name>
            <cfset result.product_cat_name = arguments.wexdata.product_cat>
            <cfset result.product_catid = arguments.wexdata.product_catid>
            <cfset result.product_name_other = arguments.wexdata.product_name_other>
            <cfset result.row_unique_relation_id = arguments.wexdata.row_unique_relation_id>
            <cfset result.row_catalog_id = arguments.wexdata.row_catalog_id>
            <cfset result.toplam_hesap_yap = arguments.wexdata.toplam_hesap_yap>
            <cfset result.basket_extra_info = arguments.wexdata.basket_extra_info>
            <cfset result.row_service_id = arguments.wexdata.row_service_id>
            <cfset result.wrk_row_relation_id = arguments.wexdata.wrk_row_relation_id>
            <cfset result.related_action_id = arguments.wexdata.related_action_id>
            <cfset result.related_action_table = arguments.wexdata.related_action_table>
            <cfset result.row_width = arguments.wexdata.row_width>
            <cfset result.row_depth = arguments.wexdata.row_depth>
            <cfset result.row_height = arguments.wexdata.row_height>
            <cfset result.to_shelf_number = arguments.wexdata.to_shelf_number>
            <cfset result.row_project_id = arguments.wexdata.row_project_id>
            <cfset result.row_project_name = arguments.wexdata.row_project_name>
            <cfset result.row_otv_amount = arguments.wexdata.row_otv_amount>
            <cfset result.action_window_name = arguments.wexdata.action_window_name>
            <cfset result.special_code = arguments.wexdata.special_code>
            <cfset result.basket_employee_id = arguments.wexdata.basket_employee_id>
            <cfset result.basket_employee = arguments.wexdata.basket_employee>
            <cfset result.row_work_id = arguments.wexdata.row_work_id>
            <cfset result.row_work_name = arguments.wexdata.row_work_name>
            <cfset result.row_exp_center_id = arguments.wexdata.row_exp_center_id>
            <cfset result.row_exp_center_name = arguments.wexdata.row_exp_center_name>
            <cfset result.row_exp_item_id = arguments.wexdata.row_exp_item_id>
            <cfset result.row_exp_item_name = arguments.wexdata.row_exp_item_name>
            <cfset result.row_acc_code = arguments.wexdata.row_acc_code>
            <cfset result.select_info_extra = arguments.wexdata.select_info_extra>
            <cfset result.detail_info_extra = arguments.wexdata.detail_info_extra>
            <cfset result.row_activity_id = arguments.wexdata.row_activity_id>
            <cfset result.row_subscription_id = arguments.wexdata.row_subscription_id>
            <cfset result.row_subscription_name = arguments.wexdata.row_subscription_name>
            <cfset result.row_assetp_id = arguments.wexdata.row_assetp_id>
            <cfset result.row_assetp_name = arguments.wexdata.row_assetp_name>
            <cfset result.row_bsmv_rate = arguments.wexdata.row_bsmv_rate>
            <cfset result.row_bsmv_amount = arguments.wexdata.row_bsmv_amount>
            <cfset result.row_bsmv_currency = arguments.wexdata.row_bsmv_currency>
            <cfset result.row_oiv_rate = arguments.wexdata.row_oiv_rate>
            <cfset result.row_oiv_amount = arguments.wexdata.row_oiv_amount>
            <cfset result.row_tevkifat_rate = arguments.wexdata.row_tevkifat_rate>
            <cfset result.row_tevkifat_amount = arguments.wexdata.row_tevkifat_amount>
            <cfset result.reason_code_info = arguments.wexdata.reason_code_info>
            <cfset result.row_tevkifat_id = arguments.wexdata.row_tevkifat_id>
            <cfset result.price_other_calc = ''>
            <cfset result.karma_product_id = isDefined('query_get_product_all_multip.IS_KARMA') and query_get_product_all_multip.IS_KARMA eq 1 ? '#arguments.wexdata.product_id#' : ''>
            <cfset result.gtip_number = isDefined('arguments.wexdata.gtip_number') and len(arguments.wexdata.gtip_number) ? '#arguments.wexdata.gtip_number#' : ''>
            <cfset result.ek_tutar = ''>
            <cfset result.ek_tutar_price = isDefined("arguments.wexdata.ek_tutar") ? "#arguments.wexdata.ek_tutar#" : "">
            <cfquery name="query_get_units" datasource="#dsn3#">
                SELECT ADD_UNIT,MAIN_UNIT,MULTIPLIER,PRODUCT_UNIT_ID,PRODUCT_ID FROM PRODUCT_UNIT WHERE PRODUCT_ID = '#result.product_id#' AND PRODUCT_UNIT_STATUS = 1
            </cfquery>
            <cfset product_unit_list_list = ''>
            <cfloop query="query_get_units">
                <cfset listAppend(product_unit_list_list, query_get_units.ADD_UNIT, ',')>
            </cfloop>
            <cfset result.product_unit_list = product_unit_list_list>
            <cfset result.unit_other = isDefined("arguments.wexdata.unit_other") ? '#arguments.wexdata.unit_other#' : ''>
            <cfset result.amount_other = isDefined("arguments.wexdata.amount_other") ? '#arguments.wexdata.amount_other#' : ''>
            <cfset result.row_promotion_id = isDefined('arguments.wexdata.row_promotion_id') ? '#arguments.wexdata.row_promotion_id#' : ''>
            <cfset result.row_paymethod_id = isDefined("arguments.wexdata.row_paymethod_id") ? "#arguments.wexdata.row_paymethod_id#" : ''>
            <cfset result.lot_no = isDefined("arguments.wexdata.lot_no") ? "#arguments.wexdata.lot_no#" : ''>
            <cfset result.promosyon_yuzde = isDefined("arguments.wexdata.promosyon_yuzde") ? "#arguments.wexdata.promosyon_yuzde#" : "">
            <cfset result.promosyon_maliyet = isDefined("arguments.wexdata.promosyon_maliyet") ? "#arguments.wexdata.promosyon_maliyet#" : "">
            <cfset result.is_promotion = isDefined("arguments.wexdata.is_promotion") ? "#arguments.wexdata.is_promotion#" : "">
            <cfset result.prom_stock_id = isDefined("arguments.wexdata.prom_stock_id") ? "#arguments.wexdata.prom_stock_id#" : "">
            <cfset result.iskonto_tutar = isDefined("arguments.wexdata.disc_amount") and len(arguments.wexdata.disc_amount) and arguments.wexdata.disc_amount lte arguments.wexdata.flt_price ? "#arguments.wexdata.disc_amount#" : "0">
            <cfset result.prom_relation_id = isDefined("arguments.wexdata.prom_relation_info") and isDefined("arguments.wexdata.row_promotion_id") ? "#arguments.wexdata.prom_relation_info#" : ''>
            <cfset result.price = arguments.wexdata.flt_price>
            <cfset result.price_other = isDefined("arguments.wexdata.flt_price_other_amount") ? arguments.wexdata.flt_price_other_amount : ''>
            <cfset result.tax = isDefined("arguments.wexdata.tax") ? arguments.wexdata.tax : "">
            <cfset result.otv = isDefined("arguments.wexdata.otv") ? arguments.wexdata.otv : 0>
            <cfset result.duedate = isDefined("arguments.wexdata.due_day_value") ? arguments.wexdata.due_day_value : "">
            <cfset result.duedate = isDefined("arguments.wexdata.prom_due_date") and len(arguments.wexdata.prom_due_date) and arguments.wexdata.prom_due_date gte 0 ? arguments.wexdata.prom_due_date : result.duedate>
            <cfset result.d1 = isDefined("arguments.wexdata.d1") ? arguments.wexdata.d1 : 0>
            <cfset result.d2 = isDefined("arguments.wexdata.d2") ? arguments.wexdata.d2 : 0>
            <cfset result.d3 = isDefined("arguments.wexdata.d3") ? arguments.wexdata.d3 : 0>
            <cfset result.d4 = isDefined("arguments.wexdata.d4") ? arguments.wexdata.d4 : 0>
            <cfset result.d5 = isDefined("arguments.wexdata.d5") ? arguments.wexdata.d5 : 0>
            <cfset result.d6 = isDefined("arguments.wexdata.d6") ? arguments.wexdata.d6 : 0>
            <cfset result.d7 = isDefined("arguments.wexdata.d7") ? arguments.wexdata.d7 : 0>
            <cfset result.d8 = isDefined("arguments.wexdata.d8") ? arguments.wexdata.d8 : 0>
            <cfset result.d9 = isDefined("arguments.wexdata.d9") ? arguments.wexdata.d9 : 0>
            <cfset result.d10 = isDefined("arguments.wexdata.d10") ? arguments.wexdata.d10 : 0>
            <cfset result.is_inventory = isDefined("arguments.wexdata.is_inventory") ? arguments.wexdata.is_inventory : ''>
            <cfset result.is_production = isDefined("arguments.wexdata.is_production") and arguments.wexdata.is_production eq 1 ? 1 : 0>
            <cfif session_base.our_company_info.is_cost_location eq 1 and isdefined("query_get_product_cost") and len(query_get_product_cost.PURCHASE_NET) and listfind("53,52,62,70,71,72,78,79,88,111,112,113,116,119,141,531,532", arguments.wexdata.sepet_process_type) and len(query_get_product_all_multip.IS_COST) and query_get_product_all_multip.IS_COST>
                <cfset result.net_maliyet = wrk_round(query_get_product_cost.PURCHASE_NET, 4)>
                <cfset result.extra_cost = wrk_round(query_get_product_cost.PURCHASE_EXTRA_COST, 4)>
                <cfif isDefined(arguments.wexdata.sepet_process_type) and listFind("110,111,112,113,114,115,119", arguments.wexdata.sepet_process_type)>
                    <cfset result.price = wrk_round(query_get_product_cost.PURCHASE_NET, 4)>
                    <cfset result.price_other_calc = 1>
                </cfif>
            <cfelseif  session_base.our_company_info.is_cost_location eq 2 and isdefined("query_get_product_cost") and len(query_get_product_cost.PURCHASE_NET) and listfind("53,52,62,70,71,72,78,79,88,111,112,113,116,119,141,531,532",arguments.wexdata.sepet_process_type) and len(query_get_product_all_multip.IS_COST) and query_get_product_all_multip.IS_COST>
                <cfset result.net_maliyet = wrk_round(query_get_product_cost.PURCHASE_NET, 4)>
                <cfset result.extra_cost = wrk_round(query_get_product_cost.PURCHASE_EXTRA_COST, 4)>
                <cfif isDefined(arguments.wexdata.sepet_process_type) and listFind("110,111,112,113,114,115,119", arguments.wexdata.sepet_process_type)>
                    <cfset result.price = wrk_round(query_get_product_cost.PURCHASE_NET, 4)>
                    <cfset result.price_other_calc = 1>
                </cfif>
            <cfelseif isdefined("query_get_product_cost") and len(query_get_product_cost.PURCHASE_NET) and (arguments.wexdata.is_sale_product eq 1 or (isdefined("arguments.wexdata.sepet_process_type") and listfind("110,111,112,113,114,115,119",arguments.wexdata.sepet_process_type)) or (isdefined('arguments.wexdata.int_basket_id') and listfind("50",arguments.wexdata.int_basket_id))) and len(query_get_product_all_multip.IS_COST) and query_get_product_all_multip.IS_COST and len(query_get_product_cost.PRODUCT_COST_ID)>
                <cfset result.net_maliyet = wrk_round(query_get_product_cost.PURCHASE_NET,4)>
                <cfset result.extra_cost = wrk_round(query_get_product_cost.PURCHASE_EXTRA_COST,4)>
                <cfif isdefined("arguments.wexdata.sepet_process_type") and listfind("110,111,112,113,114,115,119",arguments.wexdata.sepet_process_type)>
                    <cfset result.price  = wrk_round(query_get_product_cost.PURCHASE_NET,4)>
                    <cfset result.price_other_calc = 1>
                </cfif>
            <cfelseif isdefined("query_get_product_cost") and len(query_get_product_cost.PURCHASE_NET) and isdefined("arguments.wexdata.sepet_process_type") and listfind('81',arguments.wexdata.sepet_process_type) and len(query_get_product_all_multip.IS_COST) and len(query_get_product_cost.PURCHASE_NET) and query_get_product_all_multip.IS_COST and len(query_get_product_cost.PRODUCT_COST_ID)>
                <cfset result.net_maliyet = wrk_round(GET_PRODUCT_COST.PURCHASE_NET,4)>
                <cfset result.extra_cost = wrk_round(GET_PRODUCT_COST.PURCHASE_EXTRA_COST,4)>
                <cfset result.price  = wrk_round(GET_PRODUCT_COST.PURCHASE_NET,4)>
                <cfset result.price_other_calc = 1>
            <cfelse>
                <cfset result.net_maliyet = ''>
                <cfset result.extra_cost = 0>
            </cfif>
            <cfset result.marj = isdefined("arguments.wexdata.marj") and len(arguments.wexdata.marj) ? arguments.wexdata.marj : ''>
            <cfset result.deliver_date = isdefined('arguments.wexdata.deliver_date') and len(arguments.wexdata.deliver_date) ? arguments.wexdata.deliver_date : ''>
            <cfset result.deliver_dept =''>
            <cfset result.department_head =''>
            <cfif len(arguments.wexdata.str_money_currency)>
                <cfset result.money = arguments.wexdata.str_money_currency>
            <cfelse>
                <cfset result.money = arguments.wexdata.money_currency>
            </cfif>
            <cfset result.row_ship_id  = 0>
            <cfset result.is_commission = 0>
            <cfif (isdefined("arguments.wexdata.basket_id") and arguments.wexdata.basket_id eq 6) or (isdefined("arguments.wexdata.int_basket_id") and arguments.wexdata.int_basket_id eq 6)>
                <cfset result.amount_ = flt_miktar * arguments.wexdata.amount>
            <cfelse>
                <cfif isdefined("arguments.wexdata.amount_multiplier") and len(arguments.wexdata.amount_multiplier) and isnumeric(replace(arguments.wexdata.amount_multiplier,",","."))>		
                    <cfset result.amount_ = arguments.wexdata.amount * (arguments.wexdata.amount_multiplier)>
                <cfelseif isdefined("arguments.wexdata.amount_multiplier") and len(arguments.wexdata.amount_multiplier) and isnumeric(arguments.wexdata.amount_multiplier)>
                    <cfset result.amount_ = arguments.wexdata.amount * arguments.wexdata.amount_multiplier>
                <cfelse>
                    <cfset result.amount_ = arguments.wexdata.amount>
                </cfif>
            </cfif>
            <cfif arguments.wexdata.is_sale_product eq 1>
                <cfset result.product_account_code = get_product_account(prod_id:arguments.wexdata.product_id).ACCOUNT_CODE>
            <cfelse>
                <cfset result.product_account_code = get_product_account(prod_id:arguments.wexdata.product_id).ACCOUNT_CODE_PUR>
            </cfif>
            <cfif isdefined("arguments.wexdata.shelf_number") and len(arguments.wexdata.shelf_number)>
                <cfset result.shelf_number = arguments.wexdata.shelf_number>
            <cfelse>
                <cfset result.shelf_number = ''>
            </cfif>
            <cfif isdefined("arguments.wexdata.list_price") and len(arguments.wexdata.list_price) and arguments.wexdata.str_money_currency is session_base.money>
                <cfset result.list_price = arguments.wexdata.list_price>
            <cfelse>
                <cfset result.list_price = ''>
            </cfif>
            <cfif isdefined("arguments.wexdata.price_catid") and len(arguments.wexdata.price_catid)>
                <cfset result.price_cat_ = arguments.wexdata.price_catid>
            <cfelse>
                <cfset result.price_cat_ = ''>
            </cfif>
            <cfif isdefined("arguments.wexdata.number_of_installment") and len(arguments.wexdata.number_of_installment)>
                <cfset result.number_of_installment = arguments.wexdata.number_of_installment>
            <cfelse>
                <cfset result.number_of_installment = ''>
            </cfif>
            <cfif isdefined("arguments.wexdata.catalog_id") and len(arguments.wexdata.catalog_id)>
                <cfset result.catalog_id = arguments.wexdata.catalog_id>
            <cfelse>
                <cfset result.catalog_id = ''>
            </cfif>
            <cfif isdefined("arguments.wexdata.unit_other")>
                <cfset result.unit_other = arguments.wexdata.unit_other>
            <cfelse>
                <cfset result.unit_other = unit_>
            </cfif>
            <cfif isdefined("arguments.wexdata.expense_center_id") and len(arguments.wexdata.expense_center_id)>
                <cfset result.expense_center_id = arguments.wexdata.expense_center_id>
            <cfelse>
                <cfset result.expense_center_id = ''>
            </cfif>
            <cfif isdefined("arguments.wexdata.expense_center_name") and len(arguments.wexdata.expense_center_name)>
                <cfset result.expense_center_name = arguments.wexdata.expense_center_name>
            <cfelse>
                <cfset result.expense_center_name = ''>
            </cfif>
            <cfif isdefined("arguments.wexdata.expense_item_id") and len(arguments.wexdata.expense_item_id)>
                <cfset result.expense_item_id = arguments.wexdata.expense_item_id>
            <cfelse>
                <cfset result.expense_item_id = ''>
            </cfif>
            <cfif isdefined("arguments.wexdata.expense_item_name") and len(arguments.wexdata.expense_item_name)>
                <cfset result.expense_item_name = arguments.wexdata.expense_item_name>
            <cfelse>
                <cfset result.expense_item_name = ''>
            </cfif>
            <cfif isdefined("arguments.wexdata.activity_type_id") and len(arguments.wexdata.activity_type_id)>
                <cfset result.activity_type_id = arguments.wexdata.activity_type_id>
            <cfelse>
                <cfset result.activity_type_id = ''>
            </cfif>
            <cfif isdefined("arguments.wexdata.bsmv_") and len(arguments.wexdata.bsmv_)>
                <cfset result.bsmv = arguments.wexdata.bsmv_>
            <cfelse>
                <cfset result.bsmv = ''>
            </cfif>
            <cfif isdefined("arguments.wexdata.oiv_") and len(arguments.wexdata.oiv_)>
                <cfset result.oiv = arguments.wexdata.oiv_>
            <cfelse>
                <cfset result.oiv = ''>
            </cfif>
            <cfif isdefined("arguments.wexdata.product_detail2") and len(arguments.wexdata.product_detail2)>
                <cfset result.product_detail2 = arguments.wexdata.product_detail2>
            <cfelse>
                <cfset result.product_detail2 = ''>
            </cfif>
            <cfif isdefined("arguments.wexdata.reason_code") and len(arguments.wexdata.reason_code)>
                <cfset result.reason_code = arguments.wexdata.reason_code>
            <cfelse>
                <cfset result.reason_code = ''>
            </cfif>
            <cfif isdefined('arguments.wexdata.reserve_date') and len(arguments.wexdata.reserve_date)>
                <cfset result.reserve_date = arguments.wexdata.reserve_date>
            <cfelse>
                <cfset result.reserve_date = ''>
            </cfif>

            <cfreturn '{"status":1, "data": ' & replace(serializeJSON(result), '//', '') & '}'>
        </cfif>

    </cffunction>

    <cffunction name="add_row_karma" access="private">
        <cfargument name="wexdata">

        <cfquery name="query_get_karma_product" datasource="#dsn1#">
            SELECT 
                KP.SPEC_MAIN_ID,
                <cfif arguments.wexdata.is_sale_product eq 1>	KP.TAX	<cfelse>KP.TAX_PURCHASE AS TAX</cfif>,
                KP.KARMA_PRODUCT_ID,
                KP.STOCK_ID,
                KP.PRODUCT_ID,
                KP.PRODUCT_UNIT_ID,
                KP.PRODUCT_AMOUNT,
                KP.SALES_PRICE,
                KP.OTHER_LIST_PRICE,
                KP.ENTRY_ID,
                <cfif session_base.period_year lt 2009>
                    CASE WHEN KP.MONEY ='TL' THEN '<cfoutput>#session_base.money#</cfoutput>' ELSE KP.MONEY END AS MONEY
                <cfelseif session_base.period_year gte 2009>
                    CASE WHEN KP.MONEY ='YTL' THEN '<cfoutput>#session_base.money#</cfoutput>' ELSE KP.MONEY END AS MONEY
                <cfelse>
                    KARMA_PRODUCTS.MONEY
                </cfif> 
            FROM 
                KARMA_PRODUCTS KP
            WHERE 
                KP.KARMA_PRODUCT_ID = #arguments.wexdata.product_id#
            ORDER BY 
                ENTRY_ID
        </cfquery>

        <cfif not query_get_karma_product.recordcount>
            <cfreturn '{"status": 0, "message": "Karma koli içeriğine ürün tanımlamalısınız"}'>
        </cfif>

        <cfif isDefined("arguments.wexdata.price_catid") and len(arguments.wexdata.price_catid) and not listFind('-1,-2', arguments.wexdata.price_catid)>
            <cfquery name="query_get_karma_price" datasource="#dsn3#">
                SELECT 	
                    KPP.SALES_PRICE,KPP.START_DATE,KPP.FINISH_DATE,
                <cfif session_base.period_year lt 2009>
                    CASE WHEN KPP.MONEY ='TL' THEN '<cfoutput>#session_base.money#</cfoutput>' ELSE KPP.MONEY END AS MONEY,
                <cfelseif session_base.period_year gte 2009>
                    CASE WHEN KPP.MONEY ='YTL' THEN '<cfoutput>#session_base.money#</cfoutput>' ELSE KPP.MONEY END AS MONEY,
                <cfelse>
                    KARMA_PRODUCTS.MONEY,
                </cfif> 
                    KPP.PRODUCT_ID,KPP.STOCK_ID,KPP.SPEC_MAIN_ID,KPP.PRICE_CATID,KPP.ENTRY_ID,
                    PC.NUMBER_OF_INSTALLMENT,PC.AVG_DUE_DAY,
                    KPP.SALES_PRICE AS OTHER_LIST_PRICE
                FROM 
                    KARMA_PRODUCTS_PRICE KPP,
                    PRICE_CAT PC
                WHERE 
                    KPP.KARMA_PRODUCT_ID = #arguments.wexdata.product_id#
                    AND KPP.PRICE_CATID = #arguments.wexdata.price_catid#
                    AND KPP.PRICE_CATID = PC.PRICE_CATID
                <cfif isdefined("arguments.wexdata.search_process_date") and len(arguments.wexdata.search_process_date)>
                    AND KPP.START_DATE <= #arguments.wexdata.search_process_date#
                    AND KPP.FINISH_DATE >= #arguments.wexdata.search_process_date#
                </cfif>
            </cfquery>
        <cfelse>
            <cfset query_get_karma_price.recordcount = 0>
        </cfif>
        <cfset arguments.wexdata.system_round_number_row = 2>
        <cfif isdefined('arguments.wexdata.int_basket_id') and len(arguments.wexdata.int_basket_id)>
            <cfquery name="query_get_round_number" datasource="#dsn3#">
                SELECT PRICE_ROUND_NUMBER FROM SETUP_BASKET WHERE BASKET_ID=#arguments.wexdata.int_basket_id# AND B_TYPE=1
            </cfquery>
            <cfif len(query_get_round_number.PRICE_ROUND_NUMBER)>
                <cfset arguments.wexdata.system_round_number_row = query_get_round_number.PRICE_ROUND_NUMBER>
            </cfif>
        </cfif>
        <cfset unique_id = createUUID()>
        <cfif isDefined("arguments.wexdata.amount_multipler") and len(arguments.wexdata.amount_multipler) and isNumeric(replace(arguments.wexdata.amount_multipler, ",", "."))>
            <cfset arguments.wexdata.amount_multi = arguments.wexdata.amount_multipler>
        <cfelse>
            <cfset arguments.wexdata.amount_multi = 1>
        </cfif>
        <cfset result = arrayNew(1)>
        <cfloop query="query_get_karma_product">
            <cfset resultitem = structNew()>
            <cfset resultitem.price = 0>
            <cfset resultitem.money = '#session_base.money#'>
            <cfset resultitem.product_price_other = 0>
            <cfif isDefined("arguments.wexdata.price_catid") and arguments.wexdata.price_catid eq '-2'>
                <cfset resultitem.price = query_get_karma_product.OTHER_LIST_PRICE>
                <cfset resultitem.product_money = query_get_karma_product.MONEY>
            <cfelseif isDefined("arguments.wexdata.price_catid") and len(arguments.wexdata.price_catid)>
                <cfif query_get_karma_price.recordcount neq 0>
                    <cfquery name='query_get_pro_price' dbtype='query'>
                        SELECT * FROM GET_KARMA_PRICE WHERE PRODUCT_ID = #query_get_karma_product.PRODUCT_ID# AND STOCK_ID = #query_get_karma_product.STOCK_ID# AND <cfif len(query_get_karma_product.SPEC_MAIN_ID)>SPEC_MAIN_ID = #query_get_karma_product.SPEC_MAIN_ID#<cfelse>SPEC_MAIN_ID IS NULL </cfif> AND ENTRY_ID = #query_get_karma_product.ENTRY_ID#
                    </cfquery>
                    <cfif len(query_get_pro_price.OTHER_LIST_PRICE)>
                        <cfset resultitem.price = query_get_pro_price.OTHER_LIST_PRICE>
                        <cfset resultitem.money = query_get_pro_price.MONEY>
                    </cfif>
                </cfif>  
                
            <cfelse>
                <cfquery name="query_get_pro_price" datasource="#dsn3#" maxrows="1">
                    SELECT
                        PRICE,MONEY
                    FROM
                        PRICE_STANDART
                    WHERE
                        PRODUCT_ID = #query_get_karma_product.PRODUCT_ID# AND
                        UNIT_ID = #query_get_karma_product.PRODUCT_UNIT_ID# AND
                        PURCHASESALES = 0 AND
                    <cfif isdefined("arguments.wexdata.search_process_date") and len(arguments.wexdata.search_process_date)>
                        START_DATE < #DATEADD('d',1,arguments.wexdata.search_process_date)#
                    <cfelse>
                        PRICESTANDART_STATUS = 1
                    </cfif>
                    ORDER BY
                        START_DATE DESC,
                        RECORD_DATE DESC
                </cfquery>
                <cfif not query_get_pro_price.recordcount>
                    <cfquery name="query_get_pro_price" datasource="#dsn3#" maxrows="1">
                        SELECT
                            PS.PRICE,
                            PS.MONEY
                        FROM
                            PRICE_STANDART AS PS,
                            PRODUCT_UNIT AS PU
                        WHERE
                            PS.UNIT_ID = PU.PRODUCT_UNIT_ID AND
                            PS.PRODUCT_ID = #query_get_karma_product.PRODUCT_ID# AND
                            PU.IS_MAIN = 1 AND
                            PS.PURCHASESALES = 0 AND
                        <cfif isdefined("arguments.wexdata.search_process_date") and len(arguments.wexdata.search_process_date)>
                            PS.START_DATE < #DATEADD('d',1,arguments.wexdata.search_process_date)#
                        <cfelse>
                            PS.PRICESTANDART_STATUS = 1
                        </cfif>
                        ORDER BY
                            PS.START_DATE DESC,
                            PS.RECORD_DATE DESC
                    </cfquery>
                </cfif>
                <cfif query_get_pro_price.recordcount>
                    <cfset resultitem.price = query_get_pro_price.PRICE>
                    <cfset resultitem.money = query_get_pro_price.MONEY>
                </cfif>
            </cfif>
            <cfif isNumeric(resultitem.price) and resultitem.price neq 0>
                <cfset resultitem.product_price_other = resultitem.price>
                <cfif len(resultitem.money) and resultitem.money neq '#session_base.money#'>
                    <cfset resultitem.TL = 1>
                </cfif>
                <cfset resultitem.price = wrk_round(resultitem.price, arguments.wexdata.system_round_number_row)>
            </cfif>
            <cfif arguments.wexdata.satir eq -1>
                <cfset arguments.wexdata.upd_row = arguments.wexdata.update_product_row_id>
            <cfelse>
                <cfset arguments.wexdata.upd_row = 0>
            </cfif>
            <cfif isDefined("query_get_karma_price") and query_get_karma_price.recordcount neq 0>
                <cfset arguments.wexdata.temp_installment_number_ = query_get_karma_price.NUMBER_OF_INSTALLMENT>
                <cfset arguments.wexdata.temp_due_day_ = query_get_karma_price.AVG_DUE_DAY>
            <cfelse>
                <cfset arguments.wexdata.temp_installment_number_ = 0>
                <cfset arguments.wexdata.temp_due_day_ = 0> 
            </cfif>
            <cfif len(query_get_karma_product.SPEC_MAIN_ID)>
                <cfset spec_fonk = specer(dsn_type: dsn3, main_spec_id: query_get_karma_product.SPEC_MAIN_ID, add_to_main_spec: 1, get_message = 1)>
                <cfif isStruct(spec_fonk)>
                    <cfreturn '{"status": 0, "message": "#spec_fonk.mistakeMessage#"}'>
                <cfelse>
                    <cfset arguments.wexdata.temp_spect_name = listgetat(spec_fonk, 3, ',')>
                    <cfset arguments.wexdata.temp_spect_id = listgetat(spec_fonk, 2, ',')>
                </cfif>
            <cfelse>
                <cfset arguments.wexdata.temp_spect_id = "">
                <cfset arguments.wexdata.temp_spect_name = "">
            </cfif>
            <cfif query_get_karma_product.currentrow neq 1>
                <cfset arguments.wexdata.satir = -1>
            </cfif>
            <cfquery name="query_get_stock_karma" datasource="#dsn3#">
                SELECT S.PRODUCT_ID,S.PRODUCT_DETAIL2,S.PRODUCT_NAME, S.STOCK_CODE, S.STOCK_CODE_2, S.STOCK_ID, S.BARCOD, S.TAX, S.OTV, S.MANUFACT_CODE, S.IS_INVENTORY, S.IS_PRODUCTION, S.PRODUCT_UNIT_ID, S.PROPERTY, S.IS_SERIAL_NO, PU.ADD_UNIT FROM STOCKS S,PRODUCT_UNIT PU WHERE S.PRODUCT_UNIT_ID=PU.PRODUCT_UNIT_ID AND S.STOCK_ID= #query_get_karma_product.STOCK_ID#
            </cfquery>
            <cfif query_get_stock_karma.recordcount>
                <cfquery name="query_get_prod_acc_2" datasource="#dsn3#">
                    SELECT ACCOUNT_CODE,ACCOUNT_CODE_PUR,ACCOUNT_PUR_IADE,ACCOUNT_IADE,PRODUCT_ID FROM PRODUCT_PERIOD WHERE PERIOD_ID= '#session_base.period_id#' AND PRODUCT_ID= #query_get_karma_product.PRODUCT_ID#
                </cfquery>
                <cfif query_get_prod_acc_2.recordcount>
                    <cfset resultitem.get_prod_acc = query_get_prod_acc_2.PRODUCT_ID>
                <cfelse>
                    <cfset resultitem.get_prod_acc = ''>
                </cfif>
                <cfset resultitem.product_id = query_get_stock_karma.PRODUCT_ID>
                <cfset resultitem.stock_id = query_get_stock_karma.STOCK_ID>
                <cfset resultitem.speckt_id = arguments.wexdata.temp_spect_id>
                <cfset resultitem.spect_name = arguments.wexdata.temp_spect_name>
                <cfset resultitem.stock_code = query_get_stock_karma.STOCK_CODE>
                <cfset resultitem.stock_code_2 = query_get_stock_karma.STOCK_CODE_2>
                <cfset resultitem.barcod = query_get_stock_karma.BARCOD>
                <cfset resultitem.manufact_code = query_get_stock_karma.MANUFACT_CODE>
                <cfset resultitem.product_name = query_get_stock_karma.PRODUCT_NAME>
                <cfset resultitem.unit_id = query_get_stock_karma.PRODUCT_UNIT_ID>
                <cfset resultitem.unit = query_get_stock_karma.ADD_UNIT>
                <cfset resultitem.tax = query_get_karma_product.TAX>
                <cfset resultitem.basket_extra_info = "">
                <cfset resultitem.BASKET_ROW_DEPARTMENT = "">
                <cfset resultitem.DELIVER_DATE = "">
                <cfset resultitem.DELIVER_DEPT = "">
                <cfset resultitem.d1 = 0>
                <cfset resultitem.d2 = 0>
                <cfset resultitem.d3 = 0>
                <cfset resultitem.d4 = 0>
                <cfset resultitem.d5 = 0>
                <cfset resultitem.d6 = 0>
                <cfset resultitem.d7 = 0>
                <cfset resultitem.d8 = 0>
                <cfset resultitem.d9 = 0>
                <cfset resultitem.d10 = 0>
                <cfset resultitem.DUEDATE = "">
                <cfset resultitem.is_commission = 0>
                <cfset resultitem.is_promotion = "">
                <cfset resultitem.lot_no = "">
                <cfset resultitem.product_name_other = "">
                <cfset resultitem.promosyon_maliyet = "">
                <cfset resultitem.promosyon_yuzde = "">
                <cfset resultitem.prom_stock_id = "">
                <cfset resultitem.row_activity_id = "">
                <cfset resultitem.row_bsmv_amount = 0>
                <cfset resultitem.row_bsmv_rate = 0>
                <cfset resultitem.row_oiv_rate = 0>
                <cfset resultitem.EXTRA_COST_RATE = "">
                <cfset resultitem.GTIP_NUMBER = "">
                <cfset resultitem.row_promotion_id = ''>
                <cfset resultitem.row_ship_id = 0>
                <cfset resultitem.row_tevkifat_id = "">
                <cfset resultitem.select_info_extra = "">
                <cfset resultitem.spect_id = "">
                <cfif query_get_stock_karma.OTV != ''>
                    <cfset resultitem.otv = query_get_stock_karma.OTV>
                <cfelse>
                    <cfset resultitem.otv = 0>
                </cfif>
                <cfset resultitem.ek_tutar = ''>
                <cfset resultitem.ek_tutar_price = "">
                <cfset resultitem.is_inventory = query_get_stock_karma.IS_INVENTORY>
                <cfset resultitem.is_production = query_get_stock_karma.IS_PRODUCTION>
                <cfset resultitem.net_maliyet = ''>
                <cfset resultitem.extra_cost = 0>
                <cfset resultitem.amount_ = query_get_karma_product.PRODUCT_AMOUNT * arguments.wexdata.amount_multi>
                <cfif query_get_prod_acc_2.recordcount>
                    <cfset resultitem.product_account_code = query_get_prod_acc_2.ACCOUNT_CODE>
                <cfelse>
                    <cfset resultitem.product_account_code = ''>
                </cfif>
                <cfset resultitem.row_catalog_id = ''>
                <cfset resultitem.row_unique_relation_id = unique_id>
                <cfif isdefined("arguments.wexdata.shelf_number") and len(arguments.wexdata.shelf_number)>
                    <cfset resultitem.shelf_number = arguments.wexdata.shelf_number>
                <cfelse>
                    <cfset resultitem.shelf_number = ''>
                </cfif>
                <cfif isdefined("arguments.wexdata.list_price") and len(arguments.wexdata.list_price) and arguments.wexdata.str_money_currency is session_base.money>
                    <cfset resultitem.list_price = arguments.wexdata.list_price>
                <cfelse>
                    <cfset resultitem.list_price = ''>
                </cfif>
                <cfif isdefined("arguments.wexdata.price_catid") and len(arguments.wexdata.price_catid)>
                    <cfset resultitem.price_cat_ = arguments.wexdata.price_catid>
                <cfelse>
                    <cfset resultitem.price_cat_ = ''>
                </cfif>
                <cfif isdefined("arguments.wexdata.number_of_installment") and len(arguments.wexdata.number_of_installment)>
                    <cfset resultitem.number_of_installment = arguments.wexdata.number_of_installment>
                <cfelse>
                    <cfset resultitem.number_of_installment = ''>
                </cfif>
                <cfif isdefined("arguments.wexdata.catalog_id") and len(arguments.wexdata.catalog_id)>
                    <cfset resultitem.catalog_id = arguments.wexdata.catalog_id>
                <cfelse>
                    <cfset resultitem.catalog_id = ''>
                </cfif>
                <cfif isdefined("arguments.wexdata.unit_other")>
                    <cfset resultitem.unit_other = arguments.wexdata.unit_other>
                <cfelse>
                    <cfset resultitem.unit_other = unit_>
                </cfif>
                <cfif isdefined("arguments.wexdata.expense_center_id") and len(arguments.wexdata.expense_center_id)>
                    <cfset resultitem.expense_center_id = arguments.wexdata.expense_center_id>
                <cfelse>
                    <cfset resultitem.expense_center_id = ''>
                </cfif>
                <cfif isdefined("arguments.wexdata.expense_center_name") and len(arguments.wexdata.expense_center_name)>
                    <cfset resultitem.expense_center_name = arguments.wexdata.expense_center_name>
                <cfelse>
                    <cfset resultitem.expense_center_name = ''>
                </cfif>
                <cfif isdefined("arguments.wexdata.expense_item_id") and len(arguments.wexdata.expense_item_id)>
                    <cfset resultitem.expense_item_id = arguments.wexdata.expense_item_id>
                <cfelse>
                    <cfset resultitem.expense_item_id = ''>
                </cfif>
                <cfif isdefined("arguments.wexdata.expense_item_name") and len(arguments.wexdata.expense_item_name)>
                    <cfset resultitem.expense_item_name = arguments.wexdata.expense_item_name>
                <cfelse>
                    <cfset resultitem.expense_item_name = ''>
                </cfif>
                <cfif isdefined("arguments.wexdata.activity_type_id") and len(arguments.wexdata.activity_type_id)>
                    <cfset resultitem.activity_type_id = arguments.wexdata.activity_type_id>
                <cfelse>
                    <cfset resultitem.activity_type_id = ''>
                </cfif>
                <cfif isdefined("arguments.wexdata.bsmv_") and len(arguments.wexdata.bsmv_)>
                    <cfset resultitem.bsmv = arguments.wexdata.bsmv_>
                <cfelse>
                    <cfset resultitem.bsmv = ''>
                </cfif>
                <cfif isdefined("arguments.wexdata.oiv_") and len(arguments.wexdata.oiv_)>
                    <cfset resultitem.oiv = arguments.wexdata.oiv_>
                <cfelse>
                    <cfset resultitem.oiv = ''>
                </cfif>
                <cfif isdefined("arguments.wexdata.product_detail2") and len(arguments.wexdata.product_detail2)>
                    <cfset resultitem.product_detail2 = arguments.wexdata.product_detail2>
                <cfelse>
                    <cfset resultitem.product_detail2 = ''>
                </cfif>
                <cfif isdefined("arguments.wexdata.reason_code") and len(arguments.wexdata.reason_code)>
                    <cfset resultitem.reason_code = arguments.wexdata.reason_code>
                <cfelse>
                    <cfset resultitem.reason_code = ''>
                </cfif>
                <cfif isdefined('arguments.wexdata.reserve_date') and len(arguments.wexdata.reserve_date)>
                    <cfset resultitem.reserve_date = arguments.wexdata.reserve_date>
                <cfelse>
                    <cfset resultitem.reserve_date = ''>
                </cfif>
                <cfset arrayAppend(result, resultitem)>
            </cfif>
        </cfloop>

        <cfreturn result>
    </cffunction>

    <cffunction name="product" access="public">
        <cfargument name="wexdata">

        <cfscript>
            int_comp_id = session_base.COMPANY_ID;
            int_period_id = session_base.PERIOD_ID;
        </cfscript>

        <cfquery name="query_moneys" datasource="#DSN#">
            SELECT
                MONEY,
                RATE1,
                RATE2
            FROM
                SETUP_MONEY
            WHERE
                COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#int_comp_id#"> AND
                PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#int_period_id#"> AND
                MONEY_STATUS = 1
        </cfquery>

        <cfquery name="query_get_urun_birim" datasource="#DSN3#">
            SELECT ADD_UNIT,MULTIPLIER FROM PRODUCT_UNIT WHERE PRODUCT_ID = #arguments.wexdata.product_id#
        </cfquery>

        <cfquery name="query_get_rival_prices" datasource="#dsn#">
            SELECT
                PR.PR_ID,
                PR.PRICE,
                PR.MONEY,
                PR.STARTDATE,
                PR.FINISHDATE,
                SETUP_UNIT.UNIT,
                SETUP_RIVALS.RIVAL_NAME,
                PR.STOCK_ID,
                PU.PRODUCT_UNIT_ID
            FROM
                SETUP_RIVALS,
                #dsn3#.PRICE_RIVAL PR,
                #dsn3#.PRODUCT_UNIT PU,
            <cfif isdefined("arguments.wexdata.stock_id")>
                #dsn3#.STOCKS S,
            </cfif>
                SETUP_UNIT
            WHERE
                PU.PRODUCT_UNIT_ID = PR.UNIT_ID	
            <cfif isdefined("arguments.wexdata.stock_id")>
                AND	S.STOCK_ID = PR.STOCK_ID 
            </cfif>
                AND	SETUP_UNIT.UNIT_ID = PU.UNIT_ID
                AND	SETUP_RIVALS.R_ID = PR.R_ID
            <cfif isdefined("arguments.wexdata.product_id")>
                AND PR.PRODUCT_ID = #arguments.wexdata.PRODUCT_ID#
            </cfif>
            <cfif isdefined("arguments.wexdata.stock_id")>
                AND S.STOCK_ID = #arguments.wexdata.stock_id#
            </cfif>
        </cfquery>

        <cfquery name="query_get_product_price" datasource="#dsn3#">
            SELECT
                DISTINCT
                P.PRICE_ID,
                P.PRICE,
                P.PRICE_KDV,
                P.MONEY,
                P.RECORD_EMP,
                P.STARTDATE,
                P.FINISHDATE,
                PU.ADD_UNIT,
                PU.PRODUCT_UNIT_ID,
                PU.WEIGHT,
            <cfif isdefined("arguments.wexdata.stock_id")>
                S.PROPERTY,
            </cfif>
                PC.PRICE_CAT,
                PC.PRICE_CATID,
                PC.NUMBER_OF_INSTALLMENT,
                PC.AVG_DUE_DAY
            FROM
                PRICE AS P,
                PRICE_CAT AS PC,
                PRODUCT_UNIT AS PU
            <cfif isdefined("arguments.wexdata.stock_id")>
                ,STOCKS AS S
            </cfif>
            WHERE
            <cfif isdefined("arguments.wexdata.stock_id")>
                S.PRODUCT_UNIT_ID=PU.PRODUCT_UNIT_ID AND
            </cfif>
            <cfif isdefined("arguments.wexdata.product_id")>
                P.PRODUCT_ID = #arguments.wexdata.product_id# AND
            </cfif>
                P.PRICE_CATID = PC.PRICE_CATID AND
                P.STARTDATE <= #now()# AND 
                (P.FINISHDATE >= #now()# OR P.FINISHDATE IS NULL) AND
                P.UNIT = PU.PRODUCT_UNIT_ID 
            <cfif isdefined("arguments.wexdata.stock_id")>
                AND S.STOCK_ID=#arguments.wexdata.stock_id#
            </cfif>
            <cfif  not (get_module_user(5)) and isdefined("arguments.wexdata.is_store_module")>
                AND PC.BRANCH LIKE '%,#listgetat(session_base.user_location,2,'-')#,%'
            </cfif>
            ORDER BY
                <!--- P.STARTDATE DESC, --->
                PC.PRICE_CAT
        </cfquery>

        <cfquery name="query_get_stock_strategies" datasource="#dsn3#">
            SELECT
                MINIMUM_ORDER_UNIT_ID,
                MINIMUM_ORDER_STOCK_VALUE
            FROM
                STOCK_STRATEGY
            WHERE
                STOCK_ID = #arguments.wexdata.STOCK_ID#
                AND DEPARTMENT_ID IS NULL
        </cfquery>
        <!--- ooooooooooooooooo --->
        <cfset money_value = session_base.money>
        <cfquery name="get_pro_name" datasource="#DSN3#">
            SELECT PRODUCT_NAME FROM PRODUCT WHERE PRODUCT_ID = #arguments.wexdata.product_id#
        </cfquery>

        <cfquery name="query_get_price_ss" datasource="#DSN3#">
            SELECT	
                PRICE,
                PRICE_KDV,
            <cfif session_base.period_year lt 2009>
                CASE WHEN MONEY ='TL' THEN '<cfoutput>#session_base.money#</cfoutput>' ELSE MONEY END AS MONEY,
            <cfelse>
                MONEY,
            </cfif> 
                ADD_UNIT,
                PRODUCT_UNIT_ID
            FROM 
                PRICE_STANDART,
                PRODUCT_UNIT
            WHERE
            <cfif isdefined("arguments.wexdata.pid") >
                PRICE_STANDART.PRODUCT_ID = #arguments.wexdata.pid# AND 
            </cfif>
                PRICE_STANDART.PURCHASESALES = 1 AND 
                PRICE_STANDART.PRICESTANDART_STATUS = 1 AND 
                PRODUCT_UNIT.PRODUCT_ID = PRICE_STANDART.PRODUCT_ID AND 
                PRICE_STANDART.UNIT_ID = PRODUCT_UNIT.PRODUCT_UNIT_ID
            <cfif isdefined("arguments.wexdata.product_id")>
                AND PRICE_STANDART.PRODUCT_ID = #arguments.wexdata.product_id# 
            </cfif>
            ORDER BY
                PRODUCT_UNIT.PRODUCT_UNIT_ID
        </cfquery>
        <cfquery name="query_get_price_sa" datasource="#DSN3#">
            SELECT	
                PRICE,
                PRICE_KDV,
            <cfif session_base.period_year lt 2009>
                CASE WHEN MONEY ='TL' THEN '<cfoutput>#session_base.money#</cfoutput>' ELSE MONEY END AS MONEY,
            <cfelse>
                MONEY,
            </cfif> 
                ADD_UNIT,
                PRODUCT_UNIT_ID
            FROM 
                PRICE_STANDART,
                PRODUCT_UNIT
            WHERE
            <cfif isdefined("arguments.wexdata.pid") >
                PRICE_STANDART.PRODUCT_ID = #arguments.wexdata.pid# AND 
            </cfif>
                PRICE_STANDART.PURCHASESALES = 0 AND 
                PRICE_STANDART.PRICESTANDART_STATUS = 1 AND 
                PRODUCT_UNIT.PRODUCT_ID = PRICE_STANDART.PRODUCT_ID AND 
                PRICE_STANDART.UNIT_ID = PRODUCT_UNIT.PRODUCT_UNIT_ID
            <cfif isdefined("arguments.wexdata.product_id")>
                AND PRICE_STANDART.PRODUCT_ID = #arguments.wexdata.product_id# 
            </cfif>
            ORDER BY
                PRODUCT_UNIT.PRODUCT_UNIT_ID
        </cfquery>

    </cffunction>

    <cffunction name="categories" access="public">
        <cfquery name="productcats" datasource="#dsn1#">
            SELECT
                PRODUCT_CAT, PRODUCT_CATID
            FROM
                PRODUCT_CAT
            WHERE 
                IS_CASH_REGISTER = 1
                AND PRODUCT_CATID IS NOT NULL
                AND HIERARCHY NOT LIKE '%.%'
                AND PRODUCT_CATID IN (SELECT PRODUCT_CATID FROM PRODUCT_CAT_OUR_COMPANY WHERE OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.company_id#">)
            ORDER BY 
                HIERARCHY
        </cfquery>
        <cfreturn Replace(serializeJSON(this.queryJSONConverter.returnData(serializeJSON(productcats))),'//','') />
    </cffunction>

    <cffunction name="cat_list" access="remote" returntype="any" returnformat="json">
        <cfargument name="branch_id" required="true">
        <cfset this.queryJSONConverter = createObject("component","workcube.cfc.queryJSONConverter") />
        <cfquery name="cat_list" datasource="#dsn3#">
            SELECT PRICE_CAT, PRICE_CATID FROM PRICE_CAT WHERE PRICE_CAT_STATUS = 1 AND IS_SALES = 1 AND BRANCH LIKE <cfqueryparam cfsqltype="cf_sql_nvarchar" value="%#arguments.branch_id#%">
        </cfquery>
        <cfreturn Replace(serializeJSON(this.queryJSONConverter.returnData(serializeJSON(cat_list))),'//','') />
    </cffunction>

</cfcomponent>