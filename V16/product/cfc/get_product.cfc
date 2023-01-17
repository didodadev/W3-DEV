<!---
    Emine Yılmaz
    Create : 26012022
    Desc : Datagate.cfc üzerinden ürün işlemleri için adreslenen fonksiyonlar yer alır
--->

<cfcomponent extends="WMO.functions">
    <cfset dsn = dsn_alias = application.systemParam.systemParam().dsn />
    <cfset dsn1 = dsn_product = dsn1_alias = '#dsn#_product' />
    <cfset dsn2 = dsn2_alias = '#dsn#_#session.ep.period_year#_#session.ep.company_id#' />
    <cfset dsn3 = dsn3_alias = '#dsn#_#session.ep.company_id#' />
    <cfset request.self = application.systemParam.systemParam().request.self />
    <cfset fusebox.process_tree_control = application.systemParam.systemParam().fusebox.process_tree_control>
    <cfset index_folder = application.systemParam.systemParam().index_folder >
    <cfset dir_seperator = application.systemParam.systemParam().dir_seperator>
    <cfset database_type = application.systemParam.systemParam().database_type />
    <cfif isdefined("session.ep.dateformat_style") and len(session.ep.dateformat_style)>
        <cfset dateformat_style = session.ep.dateformat_style>
        <cfif dateformat_style is 'dd/mm/yyyy'>
            <cfset validate_style = 'eurodate'>
        <cfelse>
            <cfset validate_style = 'date'>
        </cfif>
        <cfset timeformat_style = session.ep.timeformat_style>
    <cfelse>
        <cfset dateformat_style = 'dd/mm/yyyy'>
        <cfset validate_style = 'eurodate'>
        <cfset timeformat_style = 'HH:MM'>
    </cfif>
    <cffunction name="get_product_" returntype="query">
        <cfargument name="pid" default="">
        <cfargument name="p_catid" default="">
        <cfargument name="startrow" default="1">
        <cfargument name="maxrows" default="#session.ep.maxrows#">
        <cfquery name="GET_PRODUCT" datasource="#this.DSN1#">
            WITH CTE1 AS (
            SELECT 
                P.PRODUCT_ID,
                P.PRODUCT_STATUS,
                P.IS_WATALOGY_INTEGRATED,
                P.WATALOGY_CAT_ID,
                P.PRODUCT_CODE,
                P.COMPANY_ID,
                P.PRODUCT_CATID,
                PC.PRODUCT_CAT,
                PC.HIERARCHY,
                P.BARCOD,
                CASE
                    WHEN LEN(SLI.ITEM) > 0 THEN SLI.ITEM
                    ELSE PRODUCT_NAME
                END AS PRODUCT_NAME,
                CASE
                    WHEN LEN(SLI2.ITEM) > 0 THEN SLI2.ITEM
                    ELSE PRODUCT_DETAIL
                END AS PRODUCT_DETAIL,
                CASE
                    WHEN LEN(SLI3.ITEM) > 0 THEN SLI3.ITEM
                    ELSE PRODUCT_DETAIL2
                END AS PRODUCT_DETAIL2,
                P.TAX,
                P.TAX_PURCHASE,
                P.IS_INVENTORY,
                P.IS_PRODUCTION,
                P.SHELF_LIFE,
                P.IS_SALES,
                P.IS_PURCHASE,
                P.MANUFACT_CODE,
                P.IS_PROTOTYPE,
                P.PRODUCT_TREE_AMOUNT,
                P.PRODUCT_MANAGER,
                P.SEGMENT_ID,
                P.IS_INTERNET,
                P.PROD_COMPETITIVE,
                P.PRODUCT_STAGE,
                P.IS_TERAZI,
                P.BRAND_ID,
                P.IS_SERIAL_NO,
                P.IS_ZERO_STOCK,
                P.MIN_MARGIN,
                P.MAX_MARGIN,
                P.OTV,
                P.OTV_TYPE,
                P.OIV,
                P.BSMV,
                P.IS_KARMA,
                P.PRODUCT_CODE_2,
                P.SHORT_CODE,
                P.IS_COST,
                P.WORK_STOCK_ID,
                P.WORK_STOCK_AMOUNT,
                P.IS_EXTRANET,
                P.IS_KARMA_SEVK,
                P.RECORD_BRANCH_ID,
                P.RECORD_MEMBER,
                P.RECORD_DATE,
                P.MEMBER_TYPE,
                P.UPDATE_DATE,
                P.UPDATE_EMP,
                P.UPDATE_PAR,
                P.UPDATE_IP,
                CASE
                    WHEN LEN(SLI4.ITEM) > 0 THEN SLI4.ITEM
                    ELSE P.USER_FRIENDLY_URL
                END AS USER_FRIENDLY_URL,
                P.PACKAGE_CONTROL_TYPE,
                P.IS_LIMITED_STOCK,
                P.SHORT_CODE_ID,
                P.IS_COMMISSION,
                P.CUSTOMS_RECIPE_CODE,
                P.IS_ADD_XML,
                P.IS_GIFT_CARD,
                P.GIFT_VALID_DAY,
                P.REF_PRODUCT_CODE,
                P.IS_QUALITY,
                P.QUALITY_START_DATE,
                P.IS_LOT_NO,        
                P.ORIGIN_ID,
                P.KARMA_FOR_PRODUCT_ID,
                P.KARMA_PROPERTY_DETAIL_ID,
                PU.PRODUCT_UNIT_ID, 
                PU.PRODUCT_UNIT_STATUS,  
                PU.MAIN_UNIT_ID, 
                PU.MAIN_UNIT, 
                PU.UNIT_ID, 
                PU.ADD_UNIT, 
                PU.MULTIPLIER, 
                PU.DIMENTION, 
                PU.DESI_VALUE, 
                PU.WEIGHT, 
                PU.IS_MAIN, 
                PU.IS_SHIP_UNIT, 
                PU.UNIT_MULTIPLIER, 
                PU.UNIT_MULTIPLIER_STATIC, 
                PU.VOLUME, 
                PU.RECORD_EMP, 
                PU.IS_ADD_UNIT,
                PC.PROFIT_MARGIN,
                PB.BRAND_NAME,
                PB.BRAND_CODE,
                PBM.MODEL_NAME,
                C.NICKNAME COMPANY,
                P.PURCHASE_CARBON_VALUE
                ,P.SALES_CARBON_VALUE 
                ,P.RECYCLE_RATE 
                ,P.RECYCLE_METHOD 
                ,P.RECYCLE_CALCULATION_TYPE
                ,P.RECOVERY_AMOUNT
                ,P.PROJECT_ID
                ,P.P_PROFIT
                ,P.S_PROFIT
                ,P.DUEDAY
                ,P.MAXIMUM_STOCK
                ,P.G_PRODUCT_TYPE
                ,P.ADD_STOCK_DAY
                ,P.MINIMUM_STOCK
                ,P.ORDER_LIMIT
                ,PRODUCT_KEYWORD
                ,PRODUCT_DESCRIPTION
                ,PRODUCT_DETAIL_WATALOGY
                ,DISPOSAL_COST
                ,DISPOSAL_COST_CURRENCY
                ,RECYCLE_GROUP_ID
                ,P.IS_IMPORTED
            FROM 
                PRODUCT P
                    JOIN PRODUCT_OUR_COMPANY ON PRODUCT_OUR_COMPANY.PRODUCT_ID  = P.PRODUCT_ID AND PRODUCT_OUR_COMPANY.OUR_COMPANY_ID = #session.ep.company_id#
                    LEFT JOIN PRODUCT_BRANDS PB ON P.BRAND_ID = PB.BRAND_ID
                    LEFT JOIN PRODUCT_BRANDS_MODEL PBM ON P.SHORT_CODE_ID = PBM.MODEL_ID
                    LEFT JOIN #this.dsn_alias#.COMPANY C ON C.COMPANY_ID = P.COMPANY_ID
                    LEFT JOIN #this.dsn_alias#.SETUP_LANGUAGE_INFO SLI ON SLI.UNIQUE_COLUMN_ID = P.PRODUCT_ID
                    AND SLI.COLUMN_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="PRODUCT_NAME">
                    AND SLI.TABLE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="PRODUCT">
                    AND SLI.LANGUAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.language#">
                    LEFT JOIN #this.dsn_alias#.SETUP_LANGUAGE_INFO SLI2 ON SLI2.UNIQUE_COLUMN_ID = P.PRODUCT_ID
                    AND SLI2.COLUMN_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="PRODUCT_DETAIL">
                    AND SLI2.TABLE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="PRODUCT">
                    AND SLI2.LANGUAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.language#">
                    LEFT JOIN #this.dsn_alias#.SETUP_LANGUAGE_INFO SLI3 ON SLI3.UNIQUE_COLUMN_ID = P.PRODUCT_ID
                    AND SLI3.COLUMN_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="PRODUCT_DETAIL2">
                    AND SLI3.TABLE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="PRODUCT">
                    AND SLI3.LANGUAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.language#">
                    LEFT JOIN #this.dsn_alias#.SETUP_LANGUAGE_INFO SLI4 ON SLI4.UNIQUE_COLUMN_ID = P.PRODUCT_ID
                    AND SLI4.COLUMN_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="USER_FRIENDLY_URL">
                    AND SLI4.TABLE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="PRODUCT">
                    AND SLI4.LANGUAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.language#">
                    ,			 
                PRODUCT_UNIT PU,
                PRODUCT_CAT PC
                <cfif session.ep.isBranchAuthorization>
                    ,PRODUCT_BRANCH PBR
                </cfif>
            WHERE
                <cfif isDefined('pid') and len(pid)>P.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#pid#"> AND</cfif>
                <cfif isDefined('p_catid') and len(p_catid)>PC.PRODUCT_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#p_catid#"> AND</cfif>
                P.PRODUCT_ID = PU.PRODUCT_ID AND 
                PU.IS_MAIN = 1 AND
                P.PRODUCT_CATID = PC.PRODUCT_CATID
                <cfif session.ep.isBranchAuthorization> <!--- BK 20070702 yetkili subelerdeki urunler --->
                    AND PBR.PRODUCT_ID = P.PRODUCT_ID
                    AND PBR.BRANCH_ID IN  (SELECT
                                                B.BRANCH_ID
                                            FROM 
                                                #this.dsn_alias#.BRANCH B, 
                                                #this.dsn_alias#.EMPLOYEE_POSITION_BRANCHES EPB
                                            WHERE 
                                                EPB.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#"> AND
                                                EPB.BRANCH_ID = B.BRANCH_ID )
                </cfif>
            ),
                CTE2 AS (
                        SELECT
                            CTE1.*,
                            ROW_NUMBER() OVER (	ORDER BY PRODUCT_ID ) AS RowNum,(SELECT COUNT(*) FROM CTE1) AS QUERY_COUNT
                        FROM
                            CTE1
                    )
                    SELECT
                        CTE2.*
                    FROM
                        CTE2
                    WHERE
                        RowNum BETWEEN #startrow# and #startrow#+(#maxrows#-1)
        </cfquery>
        <cfreturn GET_PRODUCT/>
    </cffunction>

    <cffunction name="get_product2_" returntype="query">
        <cfargument name="price_catid" default="">
        <cfargument name="product_status" default="">
        <cfargument name="product_name" default="">
        <cfargument name="barcode" default="">
        <cfargument name="product_types" default="">
        <cfargument name="pos_code" default="">
        <cfargument name="pos_manager" default="">
        <cfargument name="product_stages" default="">
        <cfargument name="record_emp_id" default="">
        <cfargument name="record_emp_name" default="">
        <cfargument name="company_id" default="">
        <cfargument name="company" default="">
        <cfargument name="brand_id" default="">
        <cfargument name="brand_name" default="">
        <cfargument name="short_code_id" default="">
        <cfargument name="short_code_name" default="">
        <cfargument name="cat" default="">
        <cfargument name="category_name" default="">
        <cfargument name="keyword" default="">
        <cfargument name="special_code" default="">
        <cfargument name="list_property_id" default="">
        <cfargument name="list_variation_id" default="">
        <cfargument name="sort_type" default="">
        <cfargument name="startrow" default="">
        <cfargument name="BARCODE1" default="">
        <cfargument name="PRODUCT_NAME1" default="">
        <cfargument name="SPECIAL_CODE1" default="">
        <cfargument name="MANUFACT_CODE1" default="">
        <cfargument name="USER_FRIENDLY_URL1" default="">
        <cfargument name="PRODUCT_CODE1" default="">
        <cfargument name="PRODUCT_DETAIL1" default="">
        <cfargument name="PRODUCT_DESC" default="">
        <cfargument name="COMPANY_STOCK_CODE1" default="">
        <cfargument name="COMPANY_PRODUCT_NAME1" default="">
        <cfargument name="maxrows" default="">
        <cfif len(arguments.PRODUCT_NAME1) or len(arguments.BARCODE1) or len(arguments.SPECIAL_CODE1) or len(arguments.MANUFACT_CODE1) or len(arguments.PRODUCT_CODE1) or len(arguments.PRODUCT_DETAIL1)>  
            <cfelse>
                <cfset arguments.BARCODE1 = 1 >            
                <cfset arguments.PRODUCT_NAME1 = 1 >
                <cfset arguments.SPECIAL_CODE1 = 1 >
                <cfset arguments.MANUFACT_CODE1 = 1 >
                <cfset arguments.PRODUCT_CODE1 = 1 >
                <cfset arguments.PRODUCT_DETAIL1 = 1 >
        </cfif>
        <cfif len(arguments.COMPANY_STOCK_CODE1)>
            <cfset arguments.COMPANY_STOCK_CODE1 = 1 >
        </cfif>
        <cfif len(arguments.COMPANY_PRODUCT_NAME1)>
            <cfset arguments.COMPANY_PRODUCT_NAME1 = 1 >
        </cfif>
        <cfif len(arguments.USER_FRIENDLY_URL1)>
            <cfset arguments.USER_FRIENDLY_URL1 = 1 >
        </cfif>
        <cfif isdefined("watalogy_cat_id") and len(watalogy_cat_id)>
            <cfset watalogy_cat_id = listRemoveDuplicates(watalogy_cat_id)>
        </cfif>
        <cfif isdefined("marketplace_id") and len(marketplace_id)>
            <cfset marketplace_id = listRemoveDuplicates(marketplace_id)>
        </cfif>
        <cfquery name="GET_PRODUCT" datasource="#this.DSN3#">
            WITH CTE1 AS (
            SELECT
                <cfif session.ep.isBranchAuthorization>DISTINCT</cfif><!--- FB 20070702 sube icin --->
                P.PRODUCT_ID,
                P.PRODUCT_CODE,
                P.PRODUCT_CODE_2,
                P.MANUFACT_CODE,
                <cfif session.ep.language is 'TR'>
                    P.PRODUCT_NAME,
                <cfelse>
                    #this.dsn_alias#.Get_Dynamic_Language(P.PRODUCT_ID,'#session.ep.language#','PRODUCT','PRODUCT_NAME',NULL,NULL,PRODUCT_NAME) AS PRODUCT_NAME,
                </cfif>
                P.BARCOD,
                P.TAX,
                P.IS_ADD_XML,
                P.BRAND_ID,
                P.RECORD_MEMBER,
                P.RECORD_DATE,
                P.UPDATE_DATE,
                P.PROD_COMPETITIVE,
                P.MAX_MARGIN,
                P.MIN_MARGIN,
                P.IS_ZERO_STOCK,
                P.RECORD_BRANCH_ID,
                P.PRODUCT_STAGE,
                P.SHORT_CODE_ID,
            <cfif (isDefined("price_catid") and (price_catid eq -1)) or (not isdefined("price_catid")) or (isDefined("price_catid") and (price_catid eq -2))>
                PS.PRICE,
                PS.PRICE_KDV,
                PS.IS_KDV,
                PS.MONEY,
            <cfelseif isDefined("price_catid") and len(price_catid) and (price_catid neq -1) and (price_catid neq -2)>
                PR.MONEY,
                PR.PRICE,
                PR.PRICE_KDV,
                PR.IS_KDV,
            </cfif>
                PU.PRODUCT_UNIT_ID,
                PU.ADD_UNIT,
                PU.MAIN_UNIT,
                P.PACKAGE_CONTROL_TYPE,
                P.CUSTOMS_RECIPE_CODE,
                P.COMPANY_ID,
                (SELECT NICKNAME FROM #this.dsn_alias#.COMPANY WHERE COMPANY_ID = P.COMPANY_ID) AS SUPPLIER
            FROM 
                PRODUCT P,
            <cfif (isDefined("price_catid") and (price_catid eq -1)) or (not isdefined("price_catid")) or (isDefined("price_catid") and (price_catid eq -2))>
                PRICE_STANDART PS,
            <cfelseif isDefined("price_catid") and len(price_catid) and (price_catid neq -1) and (price_catid neq -2)>
                #this.DSN3#.PRICE PR,
            </cfif>
            <cfif session.ep.isBranchAuthorization>#this.dsn1_alias#.PRODUCT_BRANCH PBR,</cfif><!--- FB 20070702 sube icin --->
                PRODUCT_UNIT PU
            WHERE
                P.PRODUCT_ID = PU.PRODUCT_ID AND
                PU.PRODUCT_UNIT_STATUS = 1 AND
            <cfif (isDefined("product_status") and (product_status neq 2))>
                PRODUCT_STATUS = <cfqueryparam cfsqltype="cf_sql_smallint" value="#product_status#"> AND
            </cfif>
            <cfif isDefined("product_id") and len(product_id) and isDefined("product_name") and len(product_name)>
                P.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#product_id#"> AND
            </cfif>
            <cfif isdefined('product_types') and (product_types eq 1)>
                P.IS_PURCHASE = 1 AND
            <cfelseif isdefined('product_types') and (product_types eq 2)>
                P.IS_INVENTORY = 0 AND
            <cfelseif isdefined('product_types') and (product_types eq 3)>
                P.IS_INVENTORY = 1 AND P.IS_PRODUCTION = 0 AND
            <cfelseif isdefined('product_types') and (product_types eq 4)>
                P.IS_TERAZI = 1 AND
            <cfelseif isdefined('product_types') and (product_types eq 5)>
                P.IS_PURCHASE = 0 AND
            <cfelseif isdefined('product_types') and (product_types eq 6)>
                P.IS_PRODUCTION = 1 AND
            <cfelseif isdefined('product_types') and (product_types eq 7)>
                P.IS_SERIAL_NO = 1 AND
            <cfelseif isdefined('product_types') and (product_types eq 8)>
                P.IS_KARMA = 1 AND
            <cfelseif isdefined('product_types') and (product_types eq 9)>
                P.IS_INTERNET = 1 AND
            <cfelseif isdefined('product_types') and (product_types eq 10)>
                P.IS_PROTOTYPE = 1 AND
            <cfelseif isdefined('product_types') and (product_types eq 11)>
                P.IS_ZERO_STOCK = 1 AND
            <cfelseif isdefined('product_types') and (product_types eq 12)>
                P.IS_EXTRANET = 1 AND
            <cfelseif isdefined('product_types') and (product_types eq 13)>
                P.IS_COST = 1 AND
            <cfelseif isdefined('product_types') and (product_types eq 14)>
                P.IS_SALES = 1 AND
            <cfelseif isdefined('product_types') and (product_types eq 15)>
                P.IS_QUALITY = 1 AND
            <cfelseif isdefined('product_types') and (product_types eq 16)>
                P.IS_INVENTORY = 1 AND
            <cfelseif isdefined('product_types') and (product_types eq 17)>
                P.IS_LOT_NO = 1 AND
            <cfelseif isdefined('product_types') and (product_types eq 18)>
                P.IS_LIMITED_STOCK = 1 AND
            <cfelseif isdefined('product_types') and (product_types eq 19)>
                P.IS_WATALOGY_INTEGRATED = 1 AND
            </cfif>
            <cfif isdefined("watalogy_cat_id") and len(watalogy_cat_id)>
                (
                    <cfloop list="#watalogy_cat_id#" index="i">
                        P.WATALOGY_CAT_ID LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#i#%"> <cfif ListLast(watalogy_cat_id) neq i>OR</cfif>
                    </cfloop>
                )
                AND
            </cfif>
            <cfif isdefined("marketplace_id") and len(marketplace_id)>
                P.PRODUCT_ID  IN (SELECT WRP.PRODUCT_ID FROM #this.dsn_alias#.WORKNET_RELATION_PRODUCT AS WRP WHERE WRP.WORKNET_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.marketplace_id#" list="yes">)) AND
            </cfif>
            <cfif isdefined("pos_code") and len(pos_code) and isdefined("pos_manager") and len(pos_manager)>
                P.PRODUCT_MANAGER = <cfqueryparam cfsqltype="cf_sql_integer" value="#pos_code#"> AND
            </cfif>
            <cfif isdefined('product_stages') and len(product_stages)>
                PRODUCT_STAGE = <cfqueryparam cfsqltype="cf_sql_integer" value="#product_stages#"> AND
            </cfif>
            <cfif isdefined("record_emp_id") and len(record_emp_id) and isdefined("record_emp_name") and len(record_emp_name)>
                P.RECORD_MEMBER = <cfqueryparam cfsqltype="cf_sql_integer" value="#record_emp_id#"> AND
            </cfif>
            <cfif isdefined("company_id") and len(company_id) and isdefined("company") and len(company)>
                (
                    P.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#company_id#"> OR
                    P.PRODUCT_ID IN (SELECT PRODUCT_ID FROM #this.dsn3#.CONTRACT_PURCHASE_PROD_DISCOUNT WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#company_id#"> AND START_DATE <= #now()# AND FINISH_DATE >= #now()#)
                )
                AND
            </cfif>
            <cfif isdefined("brand_id") and len(brand_id) and len(brand_name)>
                P.BRAND_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#brand_id#"> AND
            </cfif>
            <cfif isdefined("short_code_id") and len(short_code_id) and len(short_code_name)>
                P.SHORT_CODE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#short_code_id#"> AND
            </cfif>				
            <cfif isdefined("cat") and len(cat) and len(category_name)>
                P.PRODUCT_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#cat#.%"> AND
            </cfif>
            <cfif isdefined("is_promotion") and len(is_promotion)>1=1</cfif>
            <cfif (isDefined("price_catid") and (price_catid eq -1)) or (not isdefined("price_catid")) or (isDefined("price_catid") and (price_catid eq -2))>
                PS.PURCHASESALES = <cfif isDefined("price_catid") and (price_catid eq -1)>0<cfelse>1</cfif> AND
                PS.PRICESTANDART_STATUS = 1 AND	
                P.PRODUCT_ID = PS.PRODUCT_ID AND
                PS.UNIT_ID = PU.PRODUCT_UNIT_ID AND
                PU.PRODUCT_UNIT_STATUS = 1
            <cfelseif isDefined("price_catid") and len(price_catid) and (price_catid neq -1) and (price_catid neq -2)>
                PR.PRICE_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#price_catid#"> AND
                PR.STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> AND
                (PR.FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> OR PR.FINISHDATE IS NULL) AND
                P.PRODUCT_ID = PR.PRODUCT_ID AND
                <!---ISNULL(PR.STOCK_ID,0) = 0 AND fiyatlarda stok id atılması sağlandığı için kapatıldı PY--->
                ISNULL(PR.SPECT_VAR_ID,0) = 0 AND
                PR.UNIT = PU.PRODUCT_UNIT_ID AND
                PU.PRODUCT_UNIT_STATUS = 1
            </cfif>
                <cfif isdefined('arguments.keyword') and len(arguments.keyword)>
                    <cfif ListLen(arguments.keyword,';') gt 1>
                        AND
                        (
                        <cfset p_sayac = 0>
                        <cfloop list="#arguments.keyword#" index="pro_index">
                        <cfset p_sayac = p_sayac+1>
                        (
                            <cfif session.ep.language is 'TR'>
                                P.PRODUCT_NAME
                            <cfelse>
                                #this.dsn_alias#.Get_Dynamic_Language(P.PRODUCT_ID,'#session.ep.language#','PRODUCT','PRODUCT_NAME',NULL,NULL,PRODUCT_NAME)
                            </cfif>
                            = <cfqueryparam cfsqltype="cf_sql_varchar" value="#pro_index#"> COLLATE SQL_Latin1_General_CP1_CI_AI
                            OR BARCOD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#pro_index#">
                            OR PRODUCT_CODE_2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#pro_index#">
                            OR MANUFACT_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#pro_index#"> 
                            OR USER_FRIENDLY_URL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#pro_index#"> 
                            OR PRODUCT_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#pro_index#">
                            OR PRODUCT_DETAIL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#pro_index#"> 
                            OR P.PRODUCT_ID IN (SELECT STOCKS.PRODUCT_ID FROM STOCKS,#this.dsn1_alias#.SETUP_COMPANY_STOCK_CODE SCSC WHERE STOCKS.STOCK_ID = SCSC.STOCK_ID AND SCSC.COMPANY_PRODUCT_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#pro_index#">))
                
                        <cfif ListLen(arguments.keyword) gt p_sayac>OR </cfif>
                        </cfloop>
                        )
                    <cfelse><!--- tek bir tane ise like ile baksın.. --->
                        AND 
                        (
                            (1=2)  
                            <cfif len(arguments.PRODUCT_NAME1)>
                                OR (
                                    <cfif session.ep.language is 'TR'>
                                        P.PRODUCT_NAME
                                    <cfelse>
                                        #this.dsn_alias#.Get_Dynamic_Language(P.PRODUCT_ID,'#session.ep.language#','PRODUCT','PRODUCT_NAME',NULL,NULL,PRODUCT_NAME)
                                    </cfif>
                                    LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI
                                ) 
                            </cfif>                                
                            <cfif len(arguments.BARCODE1)>
                                OR (P.BARCOD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%">)									
                            </cfif> 
                            <cfif len(arguments.SPECIAL_CODE1)>
                                OR (P.PRODUCT_CODE_2 LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%">)									
                            </cfif> 
                            <cfif len(arguments.MANUFACT_CODE1)>
                                OR (P.MANUFACT_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%">)									
                            </cfif>
                            <cfif len(arguments.USER_FRIENDLY_URL1)>
                                OR (P.USER_FRIENDLY_URL LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%">)									
                            </cfif>
                            <cfif len(arguments.PRODUCT_CODE1)>
                                OR (P.PRODUCT_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%">)									
                            </cfif>
                            <cfif len(arguments.PRODUCT_DETAIL1)>
                                OR (
                                <cfif session.ep.language is 'TR'>
                                        P.PRODUCT_NAME
                                    <cfelse>
                                        #this.dsn_alias#.Get_Dynamic_Language(P.PRODUCT_ID,'#session.ep.language#','PRODUCT','PRODUCT_NAME',NULL,NULL,PRODUCT_NAME)
                                    </cfif>
                                    LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%">
                                )									
                            </cfif>
                            <cfif len(arguments.PRODUCT_DESC) and len(arguments.keyword) gt 3>
                                OR (P.PRODUCT_DETAIL LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%"> OR P.PRODUCT_DETAIL2 LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%">)
                            </cfif>
                            <cfif len(arguments.COMPANY_STOCK_CODE1)>
                                OR P.PRODUCT_ID IN (SELECT STOCKS.PRODUCT_ID FROM STOCKS,#this.dsn1_alias#.SETUP_COMPANY_STOCK_CODE SCSC WHERE STOCKS.STOCK_ID = SCSC.STOCK_ID AND (SCSC.COMPANY_STOCK_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%">))									
                            </cfif>
                            <cfif len(arguments.COMPANY_PRODUCT_NAME1)>
                                OR P.PRODUCT_ID IN (SELECT STOCKS.PRODUCT_ID FROM STOCKS,#this.dsn1_alias#.SETUP_COMPANY_STOCK_CODE SCSC WHERE STOCKS.STOCK_ID = SCSC.STOCK_ID AND SCSC.COMPANY_PRODUCT_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%">)
                            </cfif>
                        )
                    </cfif>
                </cfif>
            <cfif isDefined("special_code") and len(special_code)>
                AND P.PRODUCT_CODE_2 LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#IIf(len(special_code) gt 2,DE("%"),DE(""))##special_code#%">
            </cfif>
            <cfif isdefined("list_property_id") and len(list_property_id) and len(list_variation_id)>
                        AND P.PRODUCT_ID IN
                        (
                            SELECT
                                PRODUCT_ID
                            FROM
                                #this.dsn1_alias#.PRODUCT_DT_PROPERTIES PRODUCT_DT_PROPERTIES
                            WHERE
                                <cfloop from="1" to="#listlen(list_property_id,',')#" index="pro_index">
                                PRODUCT_ID IN (

                                                SELECT 
                                                    PRODUCT_ID
                                                FROM
                                                    #this.dsn1_alias#.PRODUCT_DT_PROPERTIES PRODUCT_DT_PROPERTIES 
                                                WHERE
                                                    (
                                                    PROPERTY_ID = #ListGetAt(list_property_id,pro_index,",")# AND VARIATION_ID = #ListGetAt(list_variation_id,pro_index,",")#
                                                    <cfif ListGetAt(list_property_value,pro_index,",") neq 'empty'>AND(TOTAL_MAX=#ListGetAt(list_property_value,pro_index,",")# OR TOTAL_MIN=#ListGetAt(list_property_value,pro_index,",")#)</cfif>
                                                    )
                                                GROUP BY 
                                                    PRODUCT_ID  
                                            ) 
                                <cfif pro_index lt listlen(list_property_id,',')>AND</cfif>
                                </cfloop>
                        )
                    </cfif>

            <cfif session.ep.isBranchAuthorization> <!--- FB 20070702 yetkili subelerdeki urunler --->
                AND PBR.PRODUCT_ID = P.PRODUCT_ID
                AND PBR.BRANCH_ID IN  (SELECT
                                            B.BRANCH_ID
                                        FROM 
                                            #this.dsn_alias#.BRANCH B, 
                                            #this.dsn_alias#.EMPLOYEE_POSITION_BRANCHES EPB
                                        WHERE 
                                            EPB.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#"> AND
                                            EPB.BRANCH_ID = B.BRANCH_ID )	
            </cfif>
                
            ),
            CTE2 AS (
                    SELECT
                        CTE1.*,
                        ROW_NUMBER() OVER (	ORDER BY
                                                <cfif Len(sort_type) and sort_type eq 1>
                                                    <cfif session.ep.language is 'TR'>
                                                        PRODUCT_NAME
                                                    <cfelse>
                                                        #this.dsn_alias#.Get_Dynamic_Language(PRODUCT_ID,'#session.ep.language#','PRODUCT','PRODUCT_NAME',NULL,NULL,PRODUCT_NAME)
                                                    </cfif>
                                                    DESC
                                                <cfelseif  Len(sort_type) and sort_type eq 2>
                                                    PRODUCT_CODE
                                                <cfelseif  Len(sort_type) and sort_type eq 3>
                                                    PRODUCT_CODE DESC
                                                <cfelseif  Len(sort_type) and sort_type eq 4>
                                                    PRODUCT_CODE_2 
                                                <cfelseif  Len(sort_type) and sort_type eq 5>
                                                    PRODUCT_CODE_2 DESC
                                                <cfelseif  Len(sort_type) and sort_type eq 6>
                                                    BARCOD 
                                                <cfelseif  Len(sort_type) and sort_type eq 7>
                                                    BARCOD DESC
                                                <cfelseif  Len(sort_type) and sort_type eq 8>
                                                    ISNULL(UPDATE_DATE,RECORD_DATE)
                                                <cfelseif  Len(sort_type) and sort_type eq 9>
                                                    ISNULL(UPDATE_DATE,RECORD_DATE) DESC
                                                <cfelse>
                                                    <cfif session.ep.language is 'TR'>
                                                        PRODUCT_NAME
                                                    <cfelse>
                                                        #this.dsn_alias#.Get_Dynamic_Language(PRODUCT_ID,'#session.ep.language#','PRODUCT','PRODUCT_NAME',NULL,NULL,PRODUCT_NAME)
                                                    </cfif>
                                                </cfif>
                                        ) AS RowNum,(SELECT COUNT(*) FROM CTE1) AS QUERY_COUNT
                    FROM
                        CTE1
                )
                SELECT
                    CTE2.*
                FROM
                    CTE2
                <cfif isdefined("startrow") and len(startrow) and isdefined("maxrows") and len(maxrows)>
                    WHERE
                        RowNum BETWEEN #startrow# and #startrow#+(#maxrows#-1)
                </cfif>
        </cfquery>
        <cfreturn GET_PRODUCT>
    </cffunction>

    <cffunction name="get_property_variation" returntype="any">
        <cfargument name="cat_id" default="">
            <cfif isdefined('attributes.cat_id') and len(attributes.cat_id)>
                <cfquery name="get_property_variation" datasource="#this.dsn1#">
                SELECT
                        PP.PROPERTY_ID,
                        PP.PROPERTY,
                        PPD.PROPERTY_DETAIL_ID,
                        PPD.PROPERTY_DETAIL,
                        PCP.PRODUCT_CAT_ID
                    FROM
                        PRODUCT_PROPERTY PP,
                        PRODUCT_PROPERTY_DETAIL PPD,
                        PRODUCT_CAT_PROPERTY PCP
                    WHERE
                        PP.PROPERTY_ID = PPD.PRPT_ID
                        AND PP.PROPERTY_ID=PCP.PROPERTY_ID
                        AND PCP.PROPERTY_ID=PPD.PRPT_ID
                        AND PCP.PRODUCT_CAT_ID=#attributes.cat_id#
                    ORDER BY
                        PP.PROPERTY,
                        PPD.PROPERTY_DETAIL
                </cfquery>
            <cfelse>
                <cfquery name="get_property_variation" datasource="#this.dsn1#">
                SELECT
                    PP.PROPERTY_ID,
                    PP.PROPERTY,
                    PPD.PROPERTY_DETAIL_ID,
                    PPD.PROPERTY_DETAIL
                FROM
                    PRODUCT_PROPERTY PP,
                    PRODUCT_PROPERTY_DETAIL PPD
                WHERE
                    PP.PROPERTY_ID = PPD.PRPT_ID
                ORDER BY
                    PP.PROPERTY,
                    PPD.PROPERTY_DETAIL
                </cfquery>
            </cfif>
        <cfreturn get_property_variation>
    </cffunction>

    <cffunction name="get_country" returntype="any">
        <cfquery name="get_country" datasource="#this.dsn_alias#">
            SELECT COUNTRY_ID,#dsn#.Get_Dynamic_Language(COUNTRY_ID,'#session.ep.language#','SETUP_COUNTRY','COUNTRY_NAME',NULL,NULL,COUNTRY_NAME) AS COUNTRY_NAME,COUNTRY_CODE FROM SETUP_COUNTRY ORDER BY COUNTRY_NAME
        </cfquery>
        <cfreturn get_country>
    </cffunction>

    <cffunction name="refreshCollection" returntype="any">
        <cftry>
            <cfcollection  action="list" name="collections">
            <cfset collection=[]>
            <cfoutput query="collections">
                <cfscript>
                    ArrayAppend(collection,  name, "true"); 
                </cfscript> 
            </cfoutput>
            <cfif not ArrayFind(collection, 'w_products')>
                <cfcollection collection="w_products" action="create" path="gettemplatepath()">
                <cfset cmp = createObject("component", "cfc.data")>
                <cfset get_products = cmp.GET_HOMEPAGE_PRODUCTS()>
                <cfindex
                    query="get_products"
                    collection="w_products"
                    action="refresh"
                    type="Custom"
                    key="PRODUCT_ID"
                    title="PRODUCT_NAME"
                    body="PRODUCT_NAME,PRODUCT_DETAIL,PRODUCT_DETAIL2,BRAND_ID,PRODUCT_CATID,WATALOGY_CAT_ID,PRODUCT_DETAIL_WATALOGY,PRICE,PRICE_KDV"
                    status="status"
                    custom1="PRODUCT_NAME,PRODUCT_DETAIL,PRODUCT_DETAIL2,PRODUCT_DETAIL_WATALOGY"
                    custom2="BRAND_ID,PRODUCT_CATID,WATALOGY_CAT_ID,PRICE,PRICE_KDV"
                    custom3="MONEY,PRODUCT_CODE,PRODUCT_CODE_2,PRODUCT_UNIT_ID,PROPERTY,RECORD_DATE,SEGMENT_ID,STOCK_CODE,STOCK_ID,TAX,USER_FRIENDLY_URL"
                    custom4="ADD_UNIT,BARCOD,COMPANY_ID,IS_KARMA,IS_KDV,IS_PRODUCTION,IS_PROTOTYPE,IS_ZERO_STOCK"
                    category="PRODUCT_NAME,PRODUCT_DETAIL,PRODUCT_DETAIL2,BRAND_ID,PRODUCT_CATID,WATALOGY_CAT_ID,PRODUCT_DETAIL_WATALOGY,PRICE,PRICE_KDV,PROPERTY,USER_FRIENDLY_URL,PRODUCT_CODE,ADD_UNIT"
                > 
            </cfif>
            <cfreturn true>
        <cfcatch type="exception">
            <cfreturn false>
        </cfcatch>
        </cftry>        
    </cffunction>
    <cffunction name="GET_PROPERTY_STOCKS"  returntype="query">
        <cfargument name="pid" default="">
        <cfquery name="GET_PROPERTY_STOCKS" datasource="#this.DSN1#">
            SELECT
                VARIATION_ID,
                DETAIL,
                IS_EXIT,
                TOTAL_MIN,
                TOTAL_MAX,
                AMOUNT,
                RECORD_DATE,
                RECORD_EMP,
                UPDATE_EMP,
                UPDATE_DATE,
                IS_OPTIONAL,
                IS_INTERNET,
                LINE_VALUE,
                PROPERTY_ID
                
            FROM
                PRODUCT_DT_PROPERTIES 
            WHERE
                PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.pid#">     
            
        </cfquery>
        <cfreturn GET_PROPERTY_STOCKS>
    </cffunction>   

    <cffunction name="add_product" returntype="any">
        <cfargument name="old_product_code" required="false" default="" hint="Product ID">
        <cfargument name="old_product_catid" required="false" default="" hint="Product ID">
        <cfargument name="product_id" required="false" default="" hint="Product ID">
        <cfargument name="watalogy_member_code" required="false" default="" hint="Üye kodu">
        <cfargument name="product_name" required="false" default="" hint="Product Name">
        <cfargument name="MAXIMUM_STOCK" required="false" default="" hint="Maximum Stock">
        <cfargument name="volume" required="false" default="" hint="Maximum Stock">
        <cfargument name="block_stock_value" required="false" default="" hint="RESERVE STOCK OUT">
        <cfargument name="MINIMUM_STOCK" required="false" default="" hint="Minimum Stock">
        <cfargument name="otv" required="false" default="" hint="OTV">
        <cfargument name="otv_type" required="false" default="" hint="OTV TYPE">
        <cfargument name="oiv" required="false" default="" hint="OIV">
        <cfargument name="bsmv" required="false" default="" hint="BSMV">
        <cfargument name="dimention" required="false" default="" hint="Dimention">
        <cfargument name="weight" required="false" default="" hint="Weight">
        <cfargument name="is_ship_unit" required="false" default="" hint="Is Ship Unit">
        <cfargument name="tax_purchase" required="false" default="" hint="tax_purchase">
        <cfargument name="tax_s" required="false" default="" hint="tax_s">
        <cfargument name="max_margin" required="false" default="" hint="max_margin">
        <cfargument name="min_margin" required="false" default="" hint="min_margin">
        <cfargument name="product_detail" required="false" default="" hint="product_detail">
        <cfargument name="product_detail2" required="false" default="" hint="product_detail2">
        <cfargument name="old_barcod" required="false" default="" hint="old barcod">
        <cfargument name="barcod" required="false" default="" hint="barcod">
        <cfargument name="product_code_2" required="false" default="" hint="product_code_2">
        <cfargument name="product_manager" required="false" default="" hint="product_manager">
        <cfargument name="product_manager_name" required="false" default="" hint="product_manager_name">
        <cfargument name="prod_comp" required="false" default="" hint="prod_comp">
        <cfargument name="segment_id" required="false" default="" hint="segment_id">
        <cfargument name="product_cat_id" required="false" default="" hint="product_cat_id">
        <cfargument name="product_description" required="false" default="" hint="product_description">
        <cfargument name="is_spect_name_upd" required="false" default="" hint="is_spect_name_upd ">
        <cfargument name="old_MANUFACT_CODE" required="false" default="" hint="old_MANUFACT_CODE">
        <cfargument name="product_cat" required="false" default="" hint="product_cat">
        <cfargument name="product_detail_watalogy" required="false" default="" hint="product_detail_watalogy ">
        <cfargument name="product_keyword" required="false" default="" hint="product_keyword">
        <cfargument name="hierarchy" required="false" default="" hint="hierarchy">
        <cfargument name="brand_name" required="false" default="" hint="brand_name">
        <cfargument name="brand_id" required="false" default="" hint="brand_id">
        <cfargument name="brand_code" required="false" default="" hint="brand_code">
        <cfargument name="short_code" required="false" default="" hint="short_code">
        <cfargument name="short_code_name" required="false" default="" hint="short_code_name">
        <cfargument name="short_code_id" required="false" default="" hint="short_code_id">
        <cfargument name="MANUFACT_CODE" required="false" default="" hint="MANUFACT CODE">
        <cfargument name="is_prototype" required="false" default="" hint="is_prototype">
        <cfargument name="is_inventory" required="false" default="" hint="is_inventory">
        <cfargument name="product_status" required="false" default="" hint="product_status">
        <cfargument name="is_production" required="false" default="" hint="is_production">
        <cfargument name="is_sales" required="false" default="" hint="is_sales">
        <cfargument name="is_purchase" required="false" default="" hint="is_purchase">
        <cfargument name="is_internet" required="false" default="" hint="is_internet">
        <cfargument name="is_extranet" required="false" default="" hint="is_extranet">
        <cfargument name="is_zero_stock" required="false" default="" hint="is_zero_stock">
        <cfargument name="is_serial_no" required="false" default="" hint="is_serial_no">
        <cfargument name="is_lot_no" required="false" default="" hint="is_lot_no">
        <cfargument name="is_karma" required="false" default="" hint="is_karma">
        <cfargument name="is_limited_stock" required="false" default="" hint="is_limited_stock">
        <cfargument name="is_cost" required="false" default="" hint="is_cost">
        <cfargument name="is_terazi" required="false" default="" hint="is_terazi">
        <cfargument name="gift_valid_day" required="false" default="" hint="gift_valid_day">
        <cfargument name="is_commission" required="false" default="" hint="Is Commission">
        <cfargument name="is_gift_card" required="false" default="" hint="Is Gift Card">
        <cfargument name="is_quality" required="false" default="" hint="Is Quality">
        <cfargument name="PACKAGE_CONTROL_TYPE" required="false" default="" hint="Package Control Type">
        <cfargument name="company_id" required="false" default="" hint="Company ID">
        <cfargument name="company" required="false" default="" hint="Company">
        <cfargument name="shelf_life" required="false" default="" hint="Shelf Life">
        <cfargument name="PRODUCT_CATID" required="false" default="" hint="Product Cat ID">
        <cfargument name="customs_recipe_code" required="false" default="" hint="Customs Recipe Code">
        <cfargument name="use_same_product_name" required="false" default="" hint="use_same_product_name">
        <cfargument name="is_barcode_control" required="false" default="" hint="is_barcode_control">
        <cfargument name="ACC_CODE_CAT" required="false" default="" hint="">
        <cfargument name="process_stage" required="false" default="" hint="">
        <cfargument name="MONEY_ID_SA" required="false" default="" hint="">
        <cfargument name="old_is_tax_included_purchase" required="false" default="" hint="">
        <cfargument name="OLD_STANDART_ALIS" required="false" default="" hint="">
        <cfargument name="STANDART_ALIS" required="false" default="" hint="">
        <cfargument name="barcode_require" required="false" default="" hint="">
        <cfargument name="old_PRODUCT_CODE_2" required="false" default="" hint="old_PRODUCT_CODE_2 ">
        <cfargument name="work_stock_id" required="false" default="" hint="">
        <cfargument name="work_product_name" required="false" default="" hint="">
        <cfargument name="is_watalogy_integrated" required="false" default="" hint="">
        <cfargument name="work_stock_amount" required="false" default="" hint="">
        <cfargument name="watalogy_cat_id" required="false" default="" hint="">
        <cfargument name="origin" required="false" default="" hint="">
        <cfargument name="watalogy_cat_name" required="false" default="" hint="">
        <cfargument name="is_add_xml" required="false" default="" hint="">
        <cfargument name="PURCHASE" required="false" default="" hint="">
        <cfargument name="is_tax_included_purchase" required="false" default="" hint="">
        <cfargument name="OLD_STANDART_SATIS" required="false" default="" hint="">
        <cfargument name="STANDART_SATIS" required="false" default="" hint="">
        <cfargument name="MONEY_ID_SS_OLD" required="false" default="" hint="">
        <cfargument name="MONEY_ID_SA_OLD" required="false" default="" hint="">
        <cfargument name="PRICE" required="false" default="" hint="">
        <cfargument name="is_tax_included_sales" required="false" default="" hint="">
        <cfargument name="MONEY_ID_SS" required="false" default="" hint="">
        <cfargument name="user_friendly_url" required="false" default="" hint="">
        <cfargument name="fuseaction" required="false" default="" hint="">
        <cfargument name="property_detail_" required="false" default="" hint="">
        <cfargument name="chk_product_property_" required="false" default="" hint="">
        <cfargument name="product_property_id" required="false" default="" hint="">
        <cfargument name="property_row_count" required="false" default="" hint="">
        <cfargument name="unit" required="false" default="" hint="">
        <cfargument name="old_tax_purchase" required="false" default="" hint="">
        <cfargument name="old_tax_sell" required="false" default="" hint="">
        <cfargument name="KARMA_FOR_PRODUCT_ID" required="false" default="" hint="">
        <cfargument name="KARMA_PROPERTY_DETAIL_ID" required="false" default="" hint="">
        <cfargument name="KARMA_PROPERTY_COLLAR_ID" required="false" default="" hint="">
        <cfargument name="KARMA_PROPERTY_SIZE_ID" required="false" default="" hint="">
        <cfargument name="old_acc_code_cat" required="false" default="" hint="">
        <cfargument name="is_imported" required="false" default="" hint="">
        <cfset attributes = arguments>
        
        <cfset responseStruct = structNew()>
        <!--- Subeye Ait Fiyat Listesinin kontrolu --->
        <cfif session.ep.isBranchAuthorization>
            <cfquery name="GET_PRICE_CAT" datasource="#DSN3#">
                SELECT PRICE_CATID FROM PRICE_CAT WHERE BRANCH LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#listgetat(session.ep.user_location,2,'-')#,%">
            </cfquery>
            <cfif not get_price_cat.recordcount>
                <cfset responseStruct.message = getLang('','Şube Fiyat Kategorisi eksik',37891)>
                <cfset responseStruct.status = false>
                <cfset responseStruct.error = {}>
                <cfabort>
            </cfif>
        </cfif>
        <cfset list="',""">
        <cfset list2=" , ">
        <cfset max_product_id="">
        <cfset arguments.PRODUCT_NAME = replacelist(arguments.PRODUCT_NAME,list,list2)><!--- ürün adına tek ve cift tirnak yazilmamali --->
        <cfset arguments.PRODUCT_NAME = trim(arguments.PRODUCT_NAME)>
        <cfquery name="CHECK_SAME" datasource="#DSN1#">
            SELECT PRODUCT_ID FROM PRODUCT WHERE PRODUCT_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.product_name#">
        </cfquery>
        <cfif check_same.recordcount>
            <cfif isdefined('arguments.use_same_product_name') and arguments.use_same_product_name eq 1>
                <cfset responseStruct.message = getLang('','Aynı İsimli Bir Ürün Daha Var',46886)>
            <cfelse>
                <cfset responseStruct.message = getLang('','Aynı İsimli Bir Ürün Daha Var Lütfen Başka Bir Ürün İsmi Giriniz',37892)>
                <cfset responseStruct.status = false>
                <cfset responseStruct.error = {}>
                <cfabort>
            </cfif>
        </cfif>
        <cfset arguments.BARCOD=trim(arguments.BARCOD)>
        <cfif len(arguments.BARCOD) and arguments.is_barcode_control eq 0>
            <cfquery name="CHECK_BARCODE" datasource="#DSN1#">
                SELECT STOCK_ID FROM GET_STOCK_BARCODES_ALL WHERE BARCODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.BARCOD#">
            </cfquery>
            <cfif check_barcode.recordcount>
                <cfif arguments.is_barcode_control eq 0>
                    <cfset responseStruct.message = getLang('','Girdiğiniz Barkod Başka Bir Ürün Tarafından Kullanılmakta  Lütfen Başka Bir Barkod Giriniz',46887)>
                    <cfset responseStruct.status = false>
                    <cfset responseStruct.error = {}>
                    <cfreturn responseStruct>
                <cfelse>
                    <cfif arguments.barcode_require><!--- barcode zorunluluğu varsa kayıt işlemini yapılmaz değilse işlem uyarı verir ancak kayıt yapılır--->
                        <cfset responseStruct.message = getLang('','Girdiğiniz Barkod Başka Bir Ürün Tarafından Kullanılmakta  Lütfen Başka Bir Barkod Giriniz',46887)>
                        <cfset responseStruct.status = false>
                        <cfset responseStruct.error = {}>
                        <cfreturn responseStruct>
                    <cfelse>
                        <cfset responseStruct.message = getLang('','Girdiğiniz Barkod Başka Bir Ürün Tarafından Kullanılmakta',37894)>
                    </cfif>
            </cfif>
            </cfif>
        </cfif>
        <!--- ürün kodunu hierarchye göre oluşturalım --->
        <cfquery name="GET_OUR_COMPANY_INFO" datasource="#DSN#">
            SELECT IS_BRAND_TO_CODE,IS_PRODUCT_COMPANY FROM OUR_COMPANY_INFO WHERE COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
        </cfquery>
        <cfquery name="GET_PRODUCT_CAT" datasource="#DSN1#">
            SELECT HIERARCHY,STOCK_CODE_COUNTER FROM PRODUCT_CAT WHERE PRODUCT_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.product_catid#">
        </cfquery>
        <cfif not (len(get_product_cat.stock_code_counter) And get_product_cat.stock_code_counter neq 0) >
            <cfset arguments.product_code="#trim(arguments.product_code)#">
        <cfelse>
            <cfset arguments.product_code=get_product_cat.stock_code_counter>
            <cfquery name="upd_stock_code_counter" datasource="#DSN1#">
                UPDATE PRODUCT_CAT 
                SET 
                STOCK_CODE_COUNTER = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.product_code+1#">
                WHERE PRODUCT_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.product_catid#">
            </cfquery>
        </cfif>
            <cfset arguments.product_code="#get_product_cat.hierarchy#.#arguments.product_code#">
            <cfset product_code_2_format="#arguments.brand_code#.#listlast(get_product_cat.hierarchy,'.')#.#arguments.short_code#">
            <!--- ürün kodu oluştu --->
            <cfquery name="CHECK_SAME" datasource="#DSN1#">
                SELECT PRODUCT_CODE FROM PRODUCT WHERE PRODUCT.PRODUCT_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.product_code#">
            </cfquery>
            <cfif check_same.recordcount>
                <cfset responseStruct.message = getLang('','Girdiğiniz Ürün Kodu Başka Bir Ürün Tarafından Kullanılmakta Lütfen Başka Bir Ürün Kodu Giriniz',37895)>
                <cfset responseStruct.status = false>
                <cfset responseStruct.error = {}>
                <cfreturn responseStruct>
            </cfif>

        <cfset bugun_00 = dateformat(now(),dateformat_style)>
        <cf_date tarih='bugun_00'>

        <cfif isdefined('arguments.acc_code_cat') and len(arguments.acc_code_cat)>
            <cfquery name="GET_CODES" datasource="#DSN3#">
                SELECT * FROM SETUP_PRODUCT_PERIOD_CAT WHERE PRO_CODE_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.acc_code_cat#">
            </cfquery>
            <cfquery name="GET_OTHER_PERIOD" datasource="#DSN3#">
                SELECT PERIOD_ID FROM #dsn_alias#.SETUP_PERIOD WHERE OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.EP.COMPANY_ID#">
            </cfquery>
        <cfelse>
            <cfset get_codes.recordcount = 0>
        </cfif>
        <cftry>
            <cftransaction>
                <cfquery name="ADD_PRODUCT" datasource="#DSN3#">
                    INSERT INTO 
                        #dsn1_alias#.PRODUCT
                    (
                        PRODUCT_STATUS,
                        IS_QUALITY,
                        IS_COST,
                        IS_INVENTORY,
                        IS_PRODUCTION,
                        IS_SALES,
                        IS_PURCHASE,
                        IS_PROTOTYPE,
                        IS_TERAZI,
                        IS_SERIAL_NO,
                        IS_ZERO_STOCK,
                        IS_KARMA,
                        IS_LIMITED_STOCK,
                        IS_LOT_NO,
                        PRODUCT_CATID,
                        PRODUCT_NAME,
                        TAX,
                        TAX_PURCHASE,
                        BARCOD,
                        PRODUCT_DETAIL,
                        PRODUCT_DETAIL2,
                        COMPANY_ID,
                        BRAND_ID,
                        RECORD_DATE,
                        RECORD_MEMBER,
                        MEMBER_TYPE,
                        PRODUCT_CODE,
                        MANUFACT_CODE,
                        SHELF_LIFE,
                        <cfif isDefined('arguments.SEGMENT_ID') and len(arguments.SEGMENT_ID)>
                        SEGMENT_ID,
                        </cfif>
                        <cfif isDefined('arguments.PRODUCT_MANAGER') and len(arguments.PRODUCT_MANAGER)>
                        PRODUCT_MANAGER,
                        </cfif>
                        IS_INTERNET,
                        IS_EXTRANET,
                        PROD_COMPETITIVE,
                        PRODUCT_STAGE,
                        MIN_MARGIN,
                        MAX_MARGIN,
                        OTV,
                        PRODUCT_CODE_2,
                        SHORT_CODE,
                        SHORT_CODE_ID,
                        WORK_STOCK_ID,
                        WORK_STOCK_AMOUNT,
                        RECORD_BRANCH_ID,
                        PACKAGE_CONTROL_TYPE,
                        IS_COMMISSION,
                        IS_GIFT_CARD,
                        GIFT_VALID_DAY,
                        CUSTOMS_RECIPE_CODE,
                        OIV,
                        BSMV,
                        IS_WATALOGY_INTEGRATED,
                        WATALOGY_CAT_ID,
                        ORIGIN_ID,
                        OTV_TYPE,
                        KARMA_FOR_PRODUCT_ID,
                        KARMA_PROPERTY_DETAIL_ID,
                        KARMA_PROPERTY_COLLAR_ID,
                        KARMA_PROPERTY_SIZE_ID,
                        PRODUCT_MEMBER_ID,
                        IS_IMPORTED
                    )
                    VALUES 
                    (
                        <cfif isDefined("arguments.product_status") and arguments.product_status eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                        <cfif isDefined("arguments.is_quality") and arguments.is_quality eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                        <cfif isDefined("arguments.IS_COST") and arguments.IS_COST eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                        <cfif isDefined("arguments.IS_INVENTORY") and arguments.IS_INVENTORY eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                        <cfif isDefined("arguments.IS_PRODUCTION") and arguments.IS_PRODUCTION eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                        <cfif isDefined("arguments.IS_SALES") and arguments.IS_SALES eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                        <cfif isDefined("arguments.IS_PURCHASE") and arguments.IS_PURCHASE eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                        <cfif isDefined("arguments.IS_PROTOTYPE") and arguments.IS_PROTOTYPE eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                        <cfif isDefined("arguments.IS_TERAZI") and arguments.IS_TERAZI eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                        <cfif isDefined("arguments.IS_SERIAL_NO") and arguments.IS_SERIAL_NO eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                        <cfif isDefined("arguments.IS_ZERO_STOCK") and arguments.IS_ZERO_STOCK eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                        <cfif isDefined("arguments.IS_KARMA") and arguments.IS_KARMA eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                        <cfif isDefined("arguments.is_limited_stock") and arguments.is_limited_stock eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                        <cfif isDefined("arguments.IS_LOT_NO") and arguments.IS_LOT_NO eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.PRODUCT_CATID#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.PRODUCT_NAME#">,
                        <cfqueryparam cfsqltype="cf_sql_float" value="#arguments.TAX#">,					
                        <cfqueryparam cfsqltype="cf_sql_float" value="#arguments.TAX_PURCHASE#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.BARCOD#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.PRODUCT_DETAIL#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.PRODUCT_DETAIL2#">,
                        <cfif arguments.COMPANY_ID is ""><cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.COMPANY_ID#"></cfif>,
                        <cfif len(arguments.brand_name) and len(arguments.brand_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.BRAND_ID#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes"></cfif>,
                        <cfqueryparam cfsqltype="cf_sql_timestamp" value="#NOW()#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.EP.USERID#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#SESSION.EP.USERKEY#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.PRODUCT_CODE#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.MANUFACT_CODE#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.SHELF_LIFE#">,
                        <cfif isDefined('arguments.SEGMENT_ID') and len(arguments.SEGMENT_ID)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.SEGMENT_ID#">,</cfif>
                        <cfif isDefined('arguments.PRODUCT_MANAGER') and len(arguments.PRODUCT_MANAGER)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.PRODUCT_MANAGER#">,</cfif>
                        <cfif isDefined('arguments.is_internet') and arguments.is_internet eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1">,<cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0">,</cfif>
                        <cfif isDefined('arguments.is_extranet') and arguments.is_extranet eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1">,<cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0">,</cfif>
                        <cfif isDefined('arguments.prod_comp') and len(arguments.prod_comp)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.prod_comp#">,<cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes">,</cfif>
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.process_stage#">,               
                        <cfif isDefined('arguments.MIN_MARGIN') and len(arguments.MIN_MARGIN)><cfqueryparam cfsqltype="cf_sql_float" value="#filterNum(arguments.min_margin,4)#"><cfelse>0</cfif>,
                        <cfif isDefined('arguments.MAX_MARGIN') and len(arguments.MAX_MARGIN)><cfqueryparam cfsqltype="cf_sql_float" value="#filterNum(arguments.max_margin,4)#"><cfelse>0</cfif>,
                        <cfif isDefined('arguments.OTV') and len(arguments.OTV)><cfif arguments.OTV_TYPE eq 1><cfqueryparam cfsqltype="cf_sql_float" value="#filterNum(arguments.OTV,4)#">,<cfelse><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.OTV#">,</cfif><cfelse><cfqueryparam cfsqltype="cf_sql_float" value="" null="yes">,</cfif>
                        <cfif get_our_company_info.is_brand_to_code>
                            <cfif len(arguments.product_code_2)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.product_code_2#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="#product_code_2_format#"></cfif>,
                        <cfelse>
                            <cfif len(arguments.product_code_2)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.product_code_2#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
                        </cfif>
                        <cfif len(arguments.short_code)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.SHORT_CODE#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
                        <cfif len(arguments.short_code_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.short_code_id#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes"></cfif>,
                        <cfif isdefined('arguments.work_product_name') and len(arguments.work_product_name) and len(arguments.work_stock_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.work_stock_id#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes"></cfif>,
                        <cfif isdefined('arguments.work_product_name') and len(arguments.work_product_name) and len(arguments.work_stock_id) and len(arguments.work_stock_amount)><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.work_stock_amount#"><cfelse><cfqueryparam cfsqltype="cf_sql_float" value="" null="yes"></cfif>,
                        <cfif session.ep.isBranchAuthorization><cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(session.ep.user_location,2,'-')#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes"></cfif>,
                        <cfif isdefined('arguments.PACKAGE_CONTROL_TYPE') and len(arguments.PACKAGE_CONTROL_TYPE)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.PACKAGE_CONTROL_TYPE#">,<cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes">,</cfif>
                        <cfif isDefined("arguments.is_commission") and arguments.is_commission eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                        <cfif isDefined("arguments.is_gift_card") and arguments.is_gift_card eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                        <cfif isDefined('arguments.gift_valid_day') and len(arguments.gift_valid_day)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.gift_valid_day#"><cfelse>NULL</cfif>,				
                        <cfif isdefined("arguments.customs_recipe_code") and len(arguments.customs_recipe_code)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.customs_recipe_code#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
                        <cfif isDefined('arguments.OIV') and len(arguments.OIV)><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.OIV#"><cfelse><cfqueryparam cfsqltype="cf_sql_float" value="" null="yes"></cfif>,
                        <cfif isDefined('arguments.BSMV') and len(arguments.BSMV)><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.BSMV#"><cfelse><cfqueryparam cfsqltype="cf_sql_float" value="" null="yes"></cfif>,
                        <cfif isdefined('arguments.is_watalogy_integrated') and arguments.is_watalogy_integrated eq 1><cfqueryparam cfsqltype="cf_sql_bit" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_bit" value="0"></cfif>,
                        <cfif isdefined('arguments.watalogy_cat_id') and isdefined('arguments.watalogy_cat_name') and len(arguments.watalogy_cat_id) and len(arguments.watalogy_cat_name)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.watalogy_cat_id#"><cfelse>NULL</cfif>,
                        <cfif isdefined('arguments.origin') and len(arguments.origin)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.origin#"><cfelse>NULL</cfif>,
                        <cfif isDefined('arguments.OTV_TYPE') and len(arguments.OTV_TYPE)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.OTV_TYPE#"><cfelse>NULL</cfif>,
                        <cfif isDefined('arguments.KARMA_FOR_PRODUCT_ID') and len(arguments.KARMA_FOR_PRODUCT_ID)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.KARMA_FOR_PRODUCT_ID#"><cfelse>NULL</cfif>,
                        <cfif isDefined('arguments.KARMA_PROPERTY_DETAIL_ID') and len(arguments.KARMA_PROPERTY_DETAIL_ID)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.KARMA_PROPERTY_DETAIL_ID#"><cfelse>NULL</cfif>,
                        <cfif isDefined('arguments.KARMA_PROPERTY_COLLAR_ID') and len(arguments.KARMA_PROPERTY_COLLAR_ID)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.KARMA_PROPERTY_COLLAR_ID#"><cfelse>NULL</cfif>,
                        <cfif isDefined('arguments.KARMA_PROPERTY_SIZE_ID') and len(arguments.KARMA_PROPERTY_SIZE_ID)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.KARMA_PROPERTY_SIZE_ID#"><cfelse>NULL</cfif>,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.product_id#-#arguments.watalogy_member_code#">,
                        <cfif isDefined("arguments.is_imported") and arguments.is_imported eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>
                    )
                    SELECT @@IDENTITY AS MAX_PRODUCT_ID
                </cfquery>
                <cfquery name="GET_PID" datasource="#DSN3#">
                    SELECT MAX(PRODUCT_ID) AS PRODUCT_ID FROM #dsn1_alias#.PRODUCT
                </cfquery>
                <cfset pid = GET_PID.PRODUCT_ID>
                <cfif GET_OUR_COMPANY_INFO.IS_PRODUCT_COMPANY EQ 1>
                    <cfquery name="add_general_parameters2" datasource="#dsn3#">
                        INSERT INTO #dsn1_alias#.PRODUCT_GENERAL_PARAMETERS
                        (
                            PRODUCT_ID,
                            COMPANY_ID, 
                            OUR_COMPANY_ID,
                            PRODUCT_MANAGER,
                            PRODUCT_STATUS, 
                            IS_INVENTORY, 
                            IS_PRODUCTION, 
                            IS_SALES, 
                            IS_PURCHASE, 
                            IS_PROTOTYPE,
                            IS_INTERNET, 
                            IS_EXTRANET, 
                            IS_TERAZI, 
                            IS_KARMA, 
                            IS_ZERO_STOCK, 
                            IS_LIMITED_STOCK, 
                            IS_SERIAL_NO, 
                            IS_COST, 
                            IS_QUALITY, 
                            IS_COMMISSION,
                            IS_ADD_XML,
                            IS_GIFT_CARD,
                            IS_LOT_NO,
                            GIFT_VALID_DAY
                        )
                        VALUES
                        (
                            #pid#, 
                            <cfif arguments.COMPANY_ID is ""><cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.COMPANY_ID#"></cfif>,
                            #session.ep.company_id#,
                            <cfif isDefined('arguments.PRODUCT_MANAGER') and len(arguments.PRODUCT_MANAGER)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.PRODUCT_MANAGER#"><cfelse>NULL</cfif>,
                            <cfif isDefined("arguments.PRODUCT_STATUS")><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                            <cfif isDefined("arguments.is_inventory") and arguments.is_inventory eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                            <cfif isDefined("arguments.is_production") and arguments.is_production eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>, 
                            <cfif isDefined("arguments.is_sales") and arguments.is_sales eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>, 
                            <cfif isDefined("arguments.is_purchase") and arguments.is_purchase eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>, 
                            <cfif isDefined("arguments.is_prototype") and arguments.is_prototype eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                            <cfif isDefined("arguments.is_internet") and arguments.is_internet eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                            <cfif isDefined("arguments.is_extranet") and arguments.is_extranet eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>, 
                            <cfif isDefined("arguments.is_terazi") and arguments.is_terazi eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                            <cfif isDefined("arguments.is_karma") and arguments.is_karma eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                            <cfif isDefined("arguments.is_zero_stock") and arguments.is_zero_stock eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                            <cfif isDefined("arguments.is_limited_stock") and arguments.is_limited_stock eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                            <cfif isDefined("arguments.is_serial_no") and arguments.is_serial_no eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                            <cfif isDefined("arguments.is_cost") and arguments.is_cost eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                            <cfif isDefined("arguments.is_quality") and arguments.is_quality eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                            <cfif isDefined("arguments.is_commission") and arguments.is_commission eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                            <cfif isDefined("arguments.is_add_xml") and arguments.is_add_xml eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                            <cfif isDefined('arguments.is_gift_card')><cfqueryparam cfsqltype="cf_sql_integer" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="0"></cfif>,
                            <cfif isDefined("arguments.is_lot_no") and arguments.is_lot_no eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                            <cfif isDefined('arguments.gift_valid_day') and len(arguments.gift_valid_day)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.gift_valid_day#"><cfelse>NULL</cfif>
                        )
                    </cfquery>
                </cfif>
                <cfif GET_CODES.recordcount and GET_OTHER_PERIOD.recordcount>
                    <cfloop list="#ValueList(GET_OTHER_PERIOD.PERIOD_ID)#" index="i">
                        <cfquery name="ADD_MAIN_UNIT" datasource="#DSN3#">
                            INSERT INTO
                                PRODUCT_PERIOD
                            (
                                PRODUCT_ID,  
                                PERIOD_ID,
                                ACCOUNT_CODE,
                                ACCOUNT_CODE_PUR,
                                ACCOUNT_DISCOUNT,
                                ACCOUNT_PRICE,
                                ACCOUNT_PUR_IADE,
                                ACCOUNT_IADE,
                                ACCOUNT_DISCOUNT_PUR,
                                ACCOUNT_YURTDISI,					
                                ACCOUNT_YURTDISI_PUR,
                                EXPENSE_CENTER_ID,
                                EXPENSE_ITEM_ID,
                                INCOME_ITEM_ID,
                                EXPENSE_TEMPLATE_ID,
                                ACTIVITY_TYPE_ID,
                                COST_EXPENSE_CENTER_ID,
                                INCOME_ACTIVITY_TYPE_ID,
                                INCOME_TEMPLATE_ID,
                                ACCOUNT_LOSS,
                                ACCOUNT_EXPENDITURE,
                                OVER_COUNT,
                                UNDER_COUNT,
                                PRODUCTION_COST,
                                HALF_PRODUCTION_COST,
                                SALE_PRODUCT_COST,
                                MATERIAL_CODE,
                                KONSINYE_PUR_CODE,
                                KONSINYE_SALE_CODE,
                                KONSINYE_SALE_NAZ_CODE,
                                DIMM_CODE,
                                DIMM_YANS_CODE,
                                PROMOTION_CODE,
                                PRODUCT_PERIOD_CAT_ID,
                                ACCOUNT_PRICE_PUR,
                                MATERIAL_CODE_SALE,
                                PRODUCTION_COST_SALE,
                                SALE_MANUFACTURED_COST,
                                PROVIDED_PROGRESS_CODE,
                                SCRAP_CODE_SALE,
                                SCRAP_CODE,
                                PROD_GENERAL_CODE,
                                PROD_LABOR_COST_CODE,
                                RECEIVED_PROGRESS_CODE,
                                INVENTORY_CAT_ID,
                                INVENTORY_CODE,
                                AMORTIZATION_METHOD_ID,
                                AMORTIZATION_TYPE_ID,
                                AMORTIZATION_EXP_CENTER_ID,
                                AMORTIZATION_EXP_ITEM_ID,
                                AMORTIZATION_CODE
                            )
                            VALUES 
                            (
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_PID.PRODUCT_ID#">,
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#i#">,
                                <cfif len(GET_CODES.ACCOUNT_CODE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.ACCOUNT_CODE#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
                                <cfif len(GET_CODES.ACCOUNT_CODE_PUR)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.ACCOUNT_CODE_PUR#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
                                <cfif len(GET_CODES.ACCOUNT_DISCOUNT)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.ACCOUNT_DISCOUNT#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
                                <cfif len(GET_CODES.ACCOUNT_PRICE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.ACCOUNT_PRICE#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
                                <cfif len(GET_CODES.ACCOUNT_PUR_IADE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.ACCOUNT_PUR_IADE#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
                                <cfif len(GET_CODES.ACCOUNT_IADE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.ACCOUNT_IADE#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
                                <cfif len(GET_CODES.ACCOUNT_DISCOUNT_PUR)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.ACCOUNT_DISCOUNT_PUR#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
                                <cfif len(GET_CODES.ACCOUNT_YURTDISI)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.ACCOUNT_YURTDISI#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
                                <cfif len(GET_CODES.ACCOUNT_YURTDISI_PUR)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.ACCOUNT_YURTDISI_PUR#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
                                <cfif len(GET_CODES.INC_CENTER_ID)><cfqueryparam cfsqltype="cf_sql_integer" value="#GET_CODES.INC_CENTER_ID#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes"></cfif>,
                                <cfif len(GET_CODES.EXP_ITEM_ID)><cfqueryparam cfsqltype="cf_sql_integer" value="#GET_CODES.EXP_ITEM_ID#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes"></cfif>,
                                <cfif len(GET_CODES.INC_ITEM_ID)><cfqueryparam cfsqltype="cf_sql_integer" value="#GET_CODES.INC_ITEM_ID#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes"></cfif>,
                                <cfif len(GET_CODES.EXP_TEMPLATE_ID)><cfqueryparam cfsqltype="cf_sql_integer" value="#GET_CODES.EXP_TEMPLATE_ID#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes"></cfif>,
                                <cfif len(GET_CODES.EXP_ACTIVITY_TYPE_ID)><cfqueryparam cfsqltype="cf_sql_integer" value="#GET_CODES.EXP_ACTIVITY_TYPE_ID#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes"></cfif>,
                                <cfif len(GET_CODES.EXP_CENTER_ID)><cfqueryparam cfsqltype="cf_sql_integer" value="#GET_CODES.EXP_CENTER_ID#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes"></cfif>,
                                <cfif len(GET_CODES.INC_ACTIVITY_TYPE_ID)><cfqueryparam cfsqltype="cf_sql_integer" value="#GET_CODES.INC_ACTIVITY_TYPE_ID#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes"></cfif>,
                                <cfif len(GET_CODES.INC_TEMPLATE_ID)><cfqueryparam cfsqltype="cf_sql_integer" value="#GET_CODES.INC_TEMPLATE_ID#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes"></cfif>,
                                <cfif len(GET_CODES.ACCOUNT_LOSS)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.ACCOUNT_LOSS#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
                                <cfif len(GET_CODES.ACCOUNT_EXPENDITURE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.ACCOUNT_EXPENDITURE#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
                                <cfif len(GET_CODES.OVER_COUNT)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.OVER_COUNT#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
                                <cfif len(GET_CODES.UNDER_COUNT)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.UNDER_COUNT#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
                                <cfif len(GET_CODES.PRODUCTION_COST)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.PRODUCTION_COST#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
                                <cfif len(GET_CODES.HALF_PRODUCTION_COST)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.HALF_PRODUCTION_COST#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
                                <cfif len(GET_CODES.SALE_PRODUCT_COST)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.SALE_PRODUCT_COST#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
                                <cfif len(GET_CODES.MATERIAL_CODE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.MATERIAL_CODE#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
                                <cfif len(GET_CODES.KONSINYE_PUR_CODE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.KONSINYE_PUR_CODE#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
                                <cfif len(GET_CODES.KONSINYE_SALE_CODE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.KONSINYE_SALE_CODE#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
                                <cfif len(GET_CODES.KONSINYE_SALE_NAZ_CODE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.KONSINYE_SALE_NAZ_CODE#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
                                <cfif len(GET_CODES.DIMM_CODE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.DIMM_CODE#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
                                <cfif len(GET_CODES.DIMM_YANS_CODE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.DIMM_YANS_CODE#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
                                <cfif len(GET_CODES.PROMOTION_CODE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.PROMOTION_CODE#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
                                <cfif isdefined('arguments.acc_code_cat') and len(arguments.acc_code_cat)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.acc_code_cat#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes"></cfif>,
                                <cfif len(GET_CODES.ACCOUNT_PRICE_PUR)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.ACCOUNT_PRICE_PUR#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
                                <cfif len(GET_CODES.MATERIAL_CODE_SALE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.MATERIAL_CODE_SALE#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
                                <cfif len(GET_CODES.PRODUCTION_COST_SALE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.PRODUCTION_COST_SALE#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
                                <cfif len(GET_CODES.SALE_MANUFACTURED_COST)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.SALE_MANUFACTURED_COST#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
                                <cfif len(GET_CODES.PROVIDED_PROGRESS_CODE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.PROVIDED_PROGRESS_CODE#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
                                <cfif len(GET_CODES.SCRAP_CODE_SALE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.SCRAP_CODE_SALE#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
                                <cfif len(GET_CODES.SCRAP_CODE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.SCRAP_CODE#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
                                <cfif len(GET_CODES.PROD_GENERAL_CODE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.PROD_GENERAL_CODE#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
                                <cfif len(GET_CODES.PROD_LABOR_COST_CODE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.PROD_LABOR_COST_CODE#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
                                <cfif len(GET_CODES.RECEIVED_PROGRESS_CODE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.RECEIVED_PROGRESS_CODE#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
                                <cfif len(GET_CODES.INVENTORY_CAT_ID)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.INVENTORY_CAT_ID#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
                                <cfif len(GET_CODES.INVENTORY_CODE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.INVENTORY_CODE#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
                                <cfif len(GET_CODES.AMORTIZATION_METHOD_ID)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.AMORTIZATION_METHOD_ID#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
                                <cfif len(GET_CODES.AMORTIZATION_TYPE_ID)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.AMORTIZATION_TYPE_ID#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
                                <cfif len(GET_CODES.AMORTIZATION_EXP_CENTER_ID)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.AMORTIZATION_EXP_CENTER_ID#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
                                <cfif len(GET_CODES.AMORTIZATION_EXP_ITEM_ID)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.AMORTIZATION_EXP_ITEM_ID#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
                                <cfif len(GET_CODES.AMORTIZATION_CODE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.AMORTIZATION_CODE#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>
                        
                            )
                        </cfquery>
                    </cfloop>
                </cfif>
                <cfif isdefined("UNIT_ID") and len(UNIT_ID)>
                    <cfset arguments.unit = UNIT_ID>
                <cfelse>
                    <cfset UNIT_ID = arguments.unit>
                </cfif>
                <cfquery name="ADD_MAIN_UNIT" datasource="#DSN3#">
                    INSERT INTO
                        #dsn1_alias#.PRODUCT_UNIT 
                    (
                        PRODUCT_ID, 
                        PRODUCT_UNIT_STATUS, 
                        MAIN_UNIT_ID, 
                        MAIN_UNIT, 
                        UNIT_ID, 
                        ADD_UNIT,
                        DIMENTION,
                        WEIGHT,
                        VOLUME,
                        IS_MAIN,
                        IS_SHIP_UNIT,
                        RECORD_EMP,
                        RECORD_DATE

                    )
                    VALUES 
                    (
                        #GET_PID.PRODUCT_ID#,
                        1,
                        #LISTGETAT(UNIT_ID,1)#,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#LISTGETAT(UNIT_ID,2)#">,
                        #LISTGETAT(UNIT_ID,1)#,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#LISTGETAT(UNIT_ID,2)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.DIMENTION#">,
                        <cfif isDefined('arguments.WEIGHT') and len(arguments.WEIGHT)><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.WEIGHT#"><cfelse>NULL</cfif>,
                        <cfqueryparam cfsqltype="cf_sql_float" value="#arguments.volume#" null="#not len(arguments.volume)#">,
                        1,
                        <cfif isdefined('is_ship_unit')>1<cfelse>0</cfif>,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                        <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
                    )					
                </cfquery>
                <cfquery name="GET_MAX_UNIT" datasource="#DSN3#">
                    SELECT MAX(PRODUCT_UNIT_ID) AS MAX_UNIT FROM #dsn1_alias#.PRODUCT_UNIT
                </cfquery>
                <cfscript>
                    if (isnumeric(arguments.PURCHASE))
                        if (arguments.is_tax_included_purchase eq 1)
                        {
                            purchase_kdvsiz = wrk_round(arguments.PURCHASE*100/(arguments.tax_purchase+100),session.ep.our_company_info.purchase_price_round_num);
                            purchase_kdvli = arguments.PURCHASE;
                            purchase_is_tax_included = 1;
                        }
                        else
                        {
                            purchase_kdvsiz = arguments.PURCHASE;
                            purchase_kdvli =  wrk_round(arguments.PURCHASE*(1+(arguments.tax_purchase/100)),session.ep.our_company_info.purchase_price_round_num);
                            purchase_is_tax_included = 0;
                        }
                    else
                    {
                        purchase_kdvsiz = 0;
                        purchase_kdvli = 0;
                        purchase_is_tax_included = 0;
                    }					
                </cfscript>
                <!--- purchasesales is 0 / alış fiyatı --->
                <cfquery name="ADD_STD_PRICE" datasource="#DSN3#">
                    INSERT INTO
                        #dsn1_alias#.PRICE_STANDART
                    (
                        PRODUCT_ID, 
                        PURCHASESALES, 
                        PRICE, 
                        PRICE_KDV,
                        IS_KDV,
                        ROUNDING,
                        MONEY,
                        START_DATE,
                        RECORD_DATE,
                        PRICESTANDART_STATUS,
                        UNIT_ID,
                        RECORD_EMP
                    )
                    VALUES
                    (
                        #GET_PID.PRODUCT_ID#,
                        0,
                        #purchase_kdvsiz#,
                        #purchase_kdvli#,
                        #purchase_is_tax_included#,
                        0,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.MONEY_ID_SA#">,
                        #bugun_00#,
                        #NOW()#,
                        1,
                        #GET_MAX_UNIT.MAX_UNIT#,
                        #SESSION.EP.USERID#
                    )
                </cfquery>

                <cfscript>
                    if (isnumeric(arguments.PRICE))
                        if (arguments.is_tax_included_sales eq 1)
                        {
                            price_kdvsiz = wrk_round(arguments.PRICE*100/(arguments.tax+100),session.ep.our_company_info.sales_price_round_num);
                            price_kdvli = arguments.PRICE;
                            price_is_tax_included = 1;
                        }
                        else
                        {
                            price_kdvsiz = arguments.PRICE;
                            price_kdvli = wrk_round(arguments.PRICE*(1+(arguments.tax/100)),session.ep.our_company_info.sales_price_round_num);
                            price_is_tax_included = 0;
                        }
                    else
                    {
                        price_kdvsiz = 0;
                        price_kdvli = 0;
                        price_is_tax_included = 0;
                    }					
                </cfscript>
                <!--- purchasesales is 1 / satış fiyatı --->
                <cfquery name="ADD_STD_PRICE" datasource="#DSN3#">
                    INSERT INTO 
                        #dsn1_alias#.PRICE_STANDART
                    (
                        PRODUCT_ID, 
                        PURCHASESALES, 
                        PRICE, 
                        PRICE_KDV,
                        IS_KDV,
                        ROUNDING,
                        MONEY,
                        START_DATE,
                        RECORD_DATE,
                        PRICESTANDART_STATUS,
                        UNIT_ID,
                        RECORD_EMP
                    )
                    VALUES
                    (
                        #GET_PID.PRODUCT_ID#,
                        1,
                        #price_kdvsiz#,
                        #price_kdvli#,
                        #price_is_tax_included#,
                        0,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.MONEY_ID_SS#">,
                        #bugun_00#,
                        #NOW()#,
                        1,
                        #GET_MAX_UNIT.MAX_UNIT#,
                        #SESSION.EP.USERID#
                    )
                </cfquery>
                
                <!--- Subedeben kayıt atilmis ise ilgili sube listesine fiyat atilmasi  --->
                <cfif session.ep.isBranchAuthorization>
                    <cfscript>
                        add_price(product_id : get_pid.product_id,
                            product_unit_id : get_max_unit.max_unit,
                            price_cat : get_price_cat.price_catid,
                            start_date : createodbcdatetime(createdatetime(year(now()),month(now()),day(now()),hour(now()),(minute(now()) - minute(now()) mod 5),0)),
                            price : price_kdvsiz,
                            price_money : arguments.money_id_sa,
                            is_kdv : arguments.is_tax_included_sales,
                            price_with_kdv : price_kdvli
                            );
                    </cfscript>
                </cfif>	
                
                <cfquery name="ADD_STOCKS" datasource="#DSN3#">
                    INSERT INTO
                        #dsn1_alias#.STOCKS
                    (
                        STOCK_CODE,
                        STOCK_CODE_2,
                        PRODUCT_ID,
                        PROPERTY,
                        BARCOD,					
                        PRODUCT_UNIT_ID,
                        STOCK_STATUS,
                        MANUFACT_CODE,
                        RECORD_EMP, 
                        RECORD_IP,
                        RECORD_DATE
                    )
                    VALUES
                    (
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.PRODUCT_CODE#">,
                        <cfif get_our_company_info.is_brand_to_code eq 1>
                            <cfif len(arguments.product_code_2)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.product_code_2#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="#product_code_2_format#"></cfif>,
                        <cfelse>
                            <cfif len(arguments.product_code_2)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.product_code_2#"><cfelse>NULL</cfif>,
                        </cfif>
                        #GET_PID.PRODUCT_ID#,
                        '', <!--- property degeri null oldugunda raporlar, urun agacı gibi bir cok ekranda property le beraber cekilen urun isminde sorun oluyordu ---><!--- '-',  boş olarak eklenmesi terch edildi--->
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.BARCOD#">,
                        #GET_MAX_UNIT.MAX_UNIT#,
                        <cfif isDefined("arguments.product_status") and arguments.product_status eq 1>1<cfelse>0</cfif>,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.MANUFACT_CODE#">,
                        #session.ep.userid#,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#remote_addr#">,
                        #now()#
                    )
                </cfquery>
                
                <cfquery name="GET_MAX_STCK" datasource="#DSN3#">
                    SELECT MAX(STOCK_ID) AS MAX_STCK FROM #dsn1_alias#.STOCKS
                </cfquery>
                <cfquery name="ADD_STOCK_BARCODE" datasource="#DSN3#">
                    INSERT INTO 
                        #dsn1_alias#.STOCKS_BARCODES
                    (
                        STOCK_ID,
                        BARCODE,
                        UNIT_ID
                    )
                    VALUES 
                    (
                        #GET_MAX_STCK.MAX_STCK#,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.BARCOD#">,
                        #GET_MAX_UNIT.MAX_UNIT#
                    )
                </cfquery>

                <cfquery name="ADD_PRODUCT_OUR_COMPANY_ID" datasource="#DSN3#">
                    INSERT INTO 
                        #dsn1_alias#.PRODUCT_OUR_COMPANY
                        (
                            PRODUCT_ID,
                            OUR_COMPANY_ID
                        )
                        VALUES
                        (
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#get_pid.product_id#">,
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
                        )
                </cfquery>
                
                <!--- FB 20070702 urune sessiondaki branch ekleniyor --->
                <cfquery name="add_product_branch_id" datasource="#DSN3#">
                    INSERT INTO
                        #dsn1_alias#.PRODUCT_BRANCH
                    (
                        PRODUCT_ID,
                        BRANCH_ID,
                        RECORD_EMP, 
                        RECORD_IP,
                        RECORD_DATE
                    )
                    VALUES
                    (
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#get_pid.product_id#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(session.ep.user_location,2,'-')#">,
                        #session.ep.userid#,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#remote_addr#">,
                        #now()#				
                    )
                </cfquery>
                <cfquery name="get_my_periods" datasource="#DSN3#">
                    SELECT * FROM #dsn_alias#.SETUP_PERIOD WHERE OUR_COMPANY_ID = #SESSION.EP.COMPANY_ID#
                </cfquery>
                <cfloop query="get_my_periods">
                    <cfif database_type is "MSSQL">
                        <cfset temp_dsn = "#DSN#_#PERIOD_YEAR#_#SESSION.EP.COMPANY_ID#">
                    <cfelseif database_type is "DB2">
                        <cfset temp_dsn = "#dsn#_#SESSION.EP.COMPANY_ID#_#right(period_year,2)#">
                    </cfif>
                    <cfquery name="INSRT_STK_ROW" datasource="#DSN3#">
                        INSERT INTO #temp_dsn#.STOCKS_ROW 
                            (
                                STOCK_ID,
                                PRODUCT_ID
                            )
                        VALUES 
                            (
                                #GET_MAX_STCK.MAX_STCK#,
                                #GET_PID.PRODUCT_ID#
                            )
                    </cfquery>
                </cfloop>
                <!--- Stok Stratejisi Ekliyor! --->
                <cfquery name="ADD_STK_STRATEGY" datasource="#DSN3#">
                    INSERT INTO
                        STOCK_STRATEGY 
                    (
                        PRODUCT_ID,
                        STOCK_ID,
                        MINIMUM_ORDER_UNIT_ID,
                        STRATEGY_TYPE,
                        IS_LIVE_ORDER
                        
                    )
                    VALUES
                    (
                        #pid#,
                        #GET_MAX_STCK.MAX_STCK#,
                        #GET_MAX_UNIT.MAX_UNIT#,
                        1,
                        0
                    )
                </cfquery>
                <cfif isDefined("arguments.block_stock_value") and len(arguments.block_stock_value)>
                    <cfquery name="GET_MAX_STRATEGY" datasource="#DSN3#">
                        SELECT MAX(STOCK_STRATEGY_ID) MAX_ID FROM STOCK_STRATEGY WHERE STOCK_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#GET_MAX_STCK.MAX_STCK#">
                    </cfquery>
                    <cfquery name="ADD_STK_STRATEGY" datasource="#DSN3#">
                        INSERT INTO
                            ORDER_ROW_RESERVED 
                        (
                            STOCK_STRATEGY_ID,
                            STOCK_ID,
                            PRODUCT_ID,
                            RESERVE_STOCK_IN,
                            RESERVE_STOCK_OUT,
                            STOCK_IN,
                            STOCK_OUT
                        )
                        VALUES
                        (
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_MAX_STRATEGY.MAX_ID#">,
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_MAX_STCK.MAX_STCK#">,
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#pid#">,
                            0,
                            #arguments.block_stock_value#,
                            0,
                            0
                        )
                    </cfquery>
                </cfif>
                
                <cfif isdefined("arguments.property_row_count") and len(arguments.property_row_count)>
                    <cfloop from="1" to="#arguments.property_row_count#" index="z">
                        <cfif isdefined("arguments.chk_product_property_#z#")>
                            <cfquery name="ADD_PROPERTY" datasource="#DSN3#">
                                INSERT INTO
                                    #dsn1_alias#.PRODUCT_DT_PROPERTIES
                                (
                                    PRODUCT_ID,
                                    PROPERTY_ID,
                                    VARIATION_ID,
                                    RECORD_EMP,
                                    RECORD_DATE,
                                    RECORD_IP
                                )
                                VALUES
                                (
                                    #GET_PID.PRODUCT_ID#,
                                    #evaluate("arguments.product_property_id#z#")#,
                                    <cfif isdefined("arguments.property_detail_")>#listfirst(evaluate("arguments.property_detail_#z#"),';')#<cfelse>NULL</cfif>,
                                    #session.ep.userid#,
                                    #now()#,
                                    '#cgi.remote_addr#'
                                )
                            </cfquery>
                        </cfif>
                    </cfloop>
                </cfif>
                <!--- <cfset indexProducts = refreshCollection()> --->
                <cf_workcube_process
                    data_source='#dsn3#'  
                    is_upd='1' 
                    old_process_line='0'
                    process_stage='#arguments.process_stage#' 
                    record_member='#session.ep.userid#' 
                    record_date='#now()#' 
                    action_table='PRODUCT'
                    action_column='PRODUCT_ID'
                    action_id='#get_pid.product_id#'
                    action_page='#request.self#?fuseaction=#listgetat(arguments.fuseaction,1,'.')#.list_product&event=det&pid=#get_pid.product_id#' 
                    warning_description='Ürün : #arguments.product_name#'>
            </cftransaction>
            <cfif isdefined("arguments.USER_FRIENDLY_URL") and len(arguments.USER_FRIENDLY_URL)> 
                <cf_workcube_user_friendly user_friendly_url='#arguments.user_friendly_url#' action_type='PRODUCT_ID' action_id='#pid#' action_page='objects2.detail_product&product_id=#pid#'>
                <cfquery name="upd_product_" datasource="#dsn1#">
                    UPDATE PRODUCT SET USER_FRIENDLY_URL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#user_friendly_#"> WHERE PRODUCT_ID = #pid#
                </cfquery>
            </cfif>  
            <cfset responseStruct.message = "İşlem Başarılı">
            <cfset responseStruct.status = true>
            <cfset responseStruct.identity = get_pid.product_id>
            <cfcatch>
                <cfset responseStruct.message = "İşlem Hatalı">
                <cfset responseStruct.status = false>
                <cfset responseStruct.error = cfcatch>
            </cfcatch>
        </cftry>
        <cfreturn responseStruct>
    </cffunction>

    <cffunction name="upd_product" returntype="any">
        <cfargument name="old_PRODUCT_CODE_2" required="false" default="" hint="old_PRODUCT_CODE_2 ">
        <cfargument name="old_MANUFACT_CODE" required="false" default="" hint="old_MANUFACT_CODE">
        <cfargument name="product_description" required="false" default="" hint="product_description">
        <cfargument name="is_spect_name_upd" required="false" default="" hint="is_spect_name_upd ">
        <cfargument name="product_detail_watalogy" required="false" default="" hint="product_detail_watalogy ">
        <cfargument name="product_keyword" required="false" default="" hint="product_keyword">
        <cfargument name="product_name" required="false" default="" hint="Product Name">
        <cfargument name="old_product_catid" required="false" default="" hint="Product ID">
        <cfargument name="old_product_code" required="false" default="" hint="Product ID">
        <cfargument name="product_id" required="false" default="" hint="Product ID">
        <cfargument name="watalogy_member_code" required="false" default="" hint="Üye kodu">
        <cfargument name="MAXIMUM_STOCK" required="false" default="" hint="Maximum Stock">
        <cfargument name="volume" required="false" default="" hint="Maximum Stock">
        <cfargument name="block_stock_value" required="false" default="" hint="RESERVE STOCK OUT">
        <cfargument name="MINIMUM_STOCK" required="false" default="" hint="Minimum Stock">
        <cfargument name="otv" required="false" default="" hint="OTV">
        <cfargument name="otv_type" required="false" default="" hint="OTV TYPE">
        <cfargument name="oiv" required="false" default="" hint="OIV">
        <cfargument name="bsmv" required="false" default="" hint="BSMV">
        <cfargument name="dimention" required="false" default="" hint="Dimention">
        <cfargument name="weight" required="false" default="" hint="Weight">
        <cfargument name="is_ship_unit" required="false" default="" hint="Is Ship Unit">
        <cfargument name="tax_purchase" required="false" default="" hint="tax_purchase">
        <cfargument name="tax_s" required="false" default="" hint="tax_s">
        <cfargument name="max_margin" required="false" default="" hint="max_margin">
        <cfargument name="min_margin" required="false" default="" hint="min_margin">
        <cfargument name="product_detail" required="false" default="" hint="product_detail">
        <cfargument name="product_detail2" required="false" default="" hint="product_detail2">
        <cfargument name="barcod" required="false" default="" hint="barcod">
        <cfargument name="old_barcod" required="false" default="" hint="old barcod">
        <cfargument name="product_code_2" required="false" default="" hint="product_code_2">
        <cfargument name="product_manager" required="false" default="" hint="product_manager">
        <cfargument name="product_manager_name" required="false" default="" hint="product_manager_name">
        <cfargument name="prod_comp" required="false" default="" hint="prod_comp">
        <cfargument name="segment_id" required="false" default="" hint="segment_id">
        <cfargument name="product_cat_id" required="false" default="" hint="product_cat_id">
        <cfargument name="product_cat" required="false" default="" hint="product_cat">
        <cfargument name="hierarchy" required="false" default="" hint="hierarchy">
        <cfargument name="brand_name" required="false" default="" hint="brand_name">
        <cfargument name="brand_id" required="false" default="" hint="brand_id">
        <cfargument name="brand_code" required="false" default="" hint="brand_code">
        <cfargument name="short_code" required="false" default="" hint="short_code">
        <cfargument name="short_code_name" required="false" default="" hint="short_code_name">
        <cfargument name="short_code_id" required="false" default="" hint="short_code_id">
        <cfargument name="MANUFACT_CODE" required="false" default="" hint="MANUFACT CODE">
        <cfargument name="is_prototype" required="false" default="" hint="is_prototype">
        <cfargument name="is_inventory" required="false" default="" hint="is_inventory">
        <cfargument name="product_status" required="false" default="" hint="product_status">
        <cfargument name="is_production" required="false" default="" hint="is_production">
        <cfargument name="is_sales" required="false" default="" hint="is_sales">
        <cfargument name="is_purchase" required="false" default="" hint="is_purchase">
        <cfargument name="is_internet" required="false" default="" hint="is_internet">
        <cfargument name="is_extranet" required="false" default="" hint="is_extranet">
        <cfargument name="is_zero_stock" required="false" default="" hint="is_zero_stock">
        <cfargument name="is_serial_no" required="false" default="" hint="is_serial_no">
        <cfargument name="is_lot_no" required="false" default="" hint="is_lot_no">
        <cfargument name="is_karma" required="false" default="" hint="is_karma">
        <cfargument name="is_limited_stock" required="false" default="" hint="is_limited_stock">
        <cfargument name="is_cost" required="false" default="" hint="is_cost">
        <cfargument name="is_terazi" required="false" default="" hint="is_terazi">
        <cfargument name="gift_valid_day" required="false" default="" hint="gift_valid_day">
        <cfargument name="is_commission" required="false" default="" hint="Is Commission">
        <cfargument name="is_gift_card" required="false" default="" hint="Is Gift Card">
        <cfargument name="is_quality" required="false" default="" hint="Is Quality">
        <cfargument name="PACKAGE_CONTROL_TYPE" required="false" default="" hint="Package Control Type">
        <cfargument name="company_id" required="false" default="" hint="Company ID">
        <cfargument name="company" required="false" default="" hint="Company">
        <cfargument name="shelf_life" required="false" default="" hint="Shelf Life">
        <cfargument name="PRODUCT_CATID" required="false" default="" hint="Product Cat ID">
        <cfargument name="customs_recipe_code" required="false" default="" hint="Customs Recipe Code">
        <cfargument name="use_same_product_name" required="false" default="" hint="use_same_product_name">
        <cfargument name="is_barcode_control" required="false" default="" hint="is_barcode_control">
        <cfargument name="ACC_CODE_CAT" required="false" default="" hint="">
        <cfargument name="process_stage" required="false" default="" hint="">
        <cfargument name="barcode_require" required="false" default="" hint="">
        <cfargument name="work_stock_id" required="false" default="" hint="">
        <cfargument name="work_product_name" required="false" default="" hint="">
        <cfargument name="is_watalogy_integrated" required="false" default="" hint="">
        <cfargument name="work_stock_amount" required="false" default="" hint="">
        <cfargument name="watalogy_cat_id" required="false" default="" hint="">
        <cfargument name="origin" required="false" default="" hint="">
        <cfargument name="watalogy_cat_name" required="false" default="" hint="">
        <cfargument name="is_add_xml" required="false" default="" hint="">
        <cfargument name="PURCHASE" required="false" default="" hint="">
        <cfargument name="is_tax_included_purchase" required="false" default="" hint="">
        <cfargument name="MONEY_ID_SA" required="false" default="" hint="">
        <cfargument name="PRICE" required="false" default="" hint="">
        <cfargument name="is_tax_included_sales" required="false" default="" hint="">
        <cfargument name="MONEY_ID_SS" required="false" default="" hint="">
        <cfargument name="user_friendly_url" required="false" default="" hint="">
        <cfargument name="fuseaction" required="false" default="" hint="">
        <cfargument name="property_detail_" required="false" default="" hint="">
        <cfargument name="chk_product_property_" required="false" default="" hint="">
        <cfargument name="product_property_id" required="false" default="" hint="">
        <cfargument name="property_row_count" required="false" default="" hint="">
        <cfargument name="OLD_STANDART_ALIS" required="false" default="" hint="">
        <cfargument name="MONEY_ID_SS_OLD" required="false" default="" hint="">
        <cfargument name="OLD_STANDART_SATIS" required="false" default="" hint="">
        <cfargument name="MONEY_ID_SA_OLD" required="false" default="" hint="">
        <cfargument name="old_is_tax_included_purchase" required="false" default="" hint="">
        <cfargument name="STANDART_ALIS" required="false" default="" hint="">
        <cfargument name="STANDART_SATIS" required="false" default="" hint="">
        <cfargument name="unit" required="false" default="" hint="">
        <cfargument name="old_tax_purchase" required="false" default="" hint="">
        <cfargument name="old_tax_sell" required="false" default="" hint="">
        <cfargument name="old_acc_code_cat" required="false" default="" hint="">
        <cfargument name="disposal_cost" required="false" default="" hint="">
        <cfargument name="disposal_cost_currency" required="false" default="" hint="">
        <cfargument name="recycle_group_id" required="false" default="" hint="Geri Kazanım Grubu">
        <cfargument name="is_imported" required="false" default="" hint="">
        <cfset attributes = arguments>
        <cfset responseStruct = structNew()>
        <cfset arguments.PRODUCT_NAME = trim(arguments.PRODUCT_NAME)>
        <cftry>
            <cfquery name="GET_UNIT" datasource="#dsn1#">
                SELECT 
                    PRODUCT_UNIT_ID,
                    UNIT_ID,
                    ADD_UNIT 
                FROM 
                    PRODUCT_UNIT 
                WHERE 
                    PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.PRODUCT_ID#"> AND 
                    IS_MAIN = <cfqueryparam cfsqltype="cf_sql_smallint" value="1"> AND 
                    PRODUCT_UNIT_STATUS = 1
            </cfquery>
            <cfset arguments.unit = "#GET_UNIT.UNIT_ID#,#GET_UNIT.ADD_UNIT#">
            <cfquery name="UPD_PRODUCT_STATUS" datasource="#DSN1#">
                UPDATE 
                    PRODUCT 
                SET 
                    PRODUCT_STATUS = #iif(isDefined('arguments.product_status'),1,0)#
                WHERE 
                    PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.PRODUCT_ID#">
            </cfquery>
            <cfquery name="UPD_STOCK_" datasource="#DSN1#">
                UPDATE 
                    STOCKS 
                SET 
                    STOCK_STATUS = <cfif isDefined("arguments.PRODUCT_STATUS")>1<cfelse>0</cfif>
                WHERE 
                    STOCK_CODE LIKE <cfqueryparam cfsqltype="cf_sql_nvarchar" value="%#arguments.old_product_code#%">
            </cfquery>
            <cfquery name="CHECK_SAME" datasource="#DSN1#">
                SELECT P.PRODUCT_ID FROM PRODUCT P WHERE P.PRODUCT_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.PRODUCT_NAME#"> AND P.PRODUCT_ID <> <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.PRODUCT_ID#">
            </cfquery>
            <cfif check_same.recordcount>
                <cfif isdefined('use_same_product_name') and use_same_product_name eq 1>
                    <cfset responseStruct.message = getLang('','Aynı İsimli Bir Ürün Daha Var',37925)>
                <cfelse>
                    <cfset responseStruct.message = getLang('','Aynı İsimli Bir Ürün Daha Var Lütfen Başka Bir Ürün İsmi Giriniz',37892)>
                    <cfset responseStruct.status = false>
                    <cfset responseStruct.error = {}>
                    <cfabort>
                </cfif>
            </cfif>
            <cfquery name="get_stock_barcode_query" datasource="#dsn1#">
                SELECT MIN(STOCK_ID) STOCK_ID FROM STOCKS WHERE PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.PRODUCT_ID#">
            </cfquery>
            <cfset arguments.BARCOD=TRIM(arguments.BARCOD)>
            <cfif len(arguments.BARCOD)>
                <cfquery name="CHECK_BARCODE" datasource="#dsn1#"><!--- baska ürüne veya varsa aynı ürünün baska stogunda aynı barkod kullanılmış mı  --->
                    SELECT 	
                        PRODUCT_ID 
                    FROM 
                        GET_STOCK_BARCODES_ALL
                    WHERE 
                        BARCODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.BARCOD#"> AND
                        (
                            PRODUCT_ID <> <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.PRODUCT_ID#">
                            <cfif len(get_stock_barcode_query.stock_id)>
                            OR (PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.PRODUCT_ID#"> AND STOCK_ID <> <cfqueryparam cfsqltype="cf_sql_integer" value="#get_stock_barcode_query.stock_id#">)
                            </cfif>
                        )
                </cfquery>
                <cfif check_barcode.recordcount>
                    <cfif arguments.is_barcode_control eq 0>
                        <cfset responseStruct.message = getLang('','Girdiğiniz Barkod Başka Bir Ürün Tarafından Kullanılmakta  Lütfen Başka Bir Barkod Giriniz',37893)>
                        <cfset responseStruct.status = false>
                        <cfset responseStruct.error = {}>
                        <cfreturn responseStruct>
                    <cfelse>
                        <cfif arguments.barcode_require><!--- barcode zorunluluğu varsa kayıt işlemini yapılmaz değilse işlem uyarı verir ancak kayıt yapılır--->
                            <cfset responseStruct.message = getLang('','Girdiğiniz Barkod Başka Bir Ürün Tarafından Kullanılmakta  Lütfen Başka Bir Barkod Giriniz',37893)>
                            <cfset responseStruct.status = false>
                            <cfset responseStruct.error = {}>
                            <cfreturn responseStruct>
                        <cfelse>
                            <cfset responseStruct.message = getLang('','Girdiğiniz Barkod Başka Bir Ürün Tarafından Kullanılmakta  Lütfen Başka Bir Barkod Giriniz',37893)>
                        </cfif>
                    </cfif>
                </cfif>
            </cfif>
            <!---  
            Burada ürün kodu veya kategorisi değişmiş mi diye kontrol ediyoruz...
            Eger deðiþmiþse deðiþmiþ halini db de kontrol ediyoruz hata varsa yazacaðýz.
            Yoksa ilgili degisiklikleri yapip devam edecegiz...
            Soyle ki;
            Bu ürün kodunu (kategori ile birlikte olusan veya kullanicinin elle girdigi) iceren stoklar taranacak ve bu degisiklik aynen
            buralara da yapilacak...
            18062002
            --->
            <!---<cfobject component="workdata/back_history" name="backHistory">--->
            <cfset bugun_00 = dateformat(now(),dateformat_style)>
            <cf_date tarih='bugun_00'>
            <cfif not (arguments.old_product_catid is arguments.product_catid)>
                <!--- Kategori degismisse ürün kodu da degisir ürün kodu ile bu ürüne bagli stoklar da degiseceginden hepsini yenileyelim. --->
                <cfquery name="GET_PRODUCT_CAT" datasource="#DSN3#">
                    SELECT HIERARCHY,STOCK_CODE_COUNTER FROM PRODUCT_CAT WHERE PRODUCT_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.PRODUCT_CATID#">
                </cfquery>
                <cfif not (len(get_product_cat.stock_code_counter) And get_product_cat.stock_code_counter neq 0) >
                    <cfset arguments.PRODUCT_CODE = '#get_product_cat.HIERARCHY#.#trim(ListLast(arguments.PRODUCT_CODE,'.'))#'>
                <cfelse>
                    <cfset arguments.PRODUCT_CODE = '#get_product_cat.HIERARCHY#.#get_product_cat.stock_code_counter#'>
                    <cfquery name="upd_stock_code_counter" datasource="#DSN1#">
                        UPDATE PRODUCT_CAT 
                        SET 
                        STOCK_CODE_COUNTER = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_product_cat.stock_code_counter+1#">
                        WHERE PRODUCT_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.product_catid#">
                    </cfquery>
                </cfif>
                <cfquery name="CHECK_CODE" datasource="#DSN1#">
                    SELECT PRODUCT_CODE FROM PRODUCT WHERE PRODUCT_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.PRODUCT_CODE#"> AND PRODUCT_ID <> <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.PRODUCT_ID#">
                </cfquery>
                <cfif check_code.recordcount>
                    <cfset responseStruct.message = getLang('','Girdiğiniz Ürün Kodu Başka Bir Ürün Tarafından Kullanılmakta Lütfen Başka Bir Ürün Kodu Giriniz',37895)>
                    <cfset responseStruct.status = false>
                    <cfset responseStruct.error = {}>
                    <cfabort>
                </cfif>
                <cfquery name="SEL_STOCK_ESKILER" datasource="#DSN1#">
                    SELECT STOCK_CODE AS PRODUCT_CODE, STOCK_ID FROM STOCKS WHERE STOCK_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.OLD_PRODUCT_CODE#%">
                </cfquery>

                <cflock name="#CREATEUUID()#" timeout="60">
                    <cftransaction>
                        <cfloop query="sel_stock_eskiler">
                            <cfset temp = "">
                            <cfset fark = Len(sel_stock_eskiler.product_code) - Len(arguments.old_product_code)>
                            <cfif (fark neq 0)>
                                <cfset temp = arguments.product_code & Right(sel_stock_eskiler.product_code,fark)>
                            <cfelse>
                                <cfset temp = arguments.product_code>
                            </cfif>
                            <cfquery name="UPD_STOCK" datasource="#DSN1#">
                                UPDATE 
                                    STOCKS 
                                SET 
                                    STOCK_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#temp#">,
                                    STOCK_STATUS = <cfif isDefined("arguments.PRODUCT_STATUS")>1<cfelse>0</cfif>,
                                    UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                                    UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#REMOTE_ADDR#">,
                                    UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
                                WHERE 
                                    STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#SEL_STOCK_ESKILER.STOCK_ID#">
                            </cfquery>
                        </cfloop>
                    </cftransaction>
                </cflock>
                <!--- cat değiştiği için info plus siliniyor--->
                <cfquery name="DEL_INFOPLUS" datasource="#DSN3#">
                    DELETE FROM PRODUCT_INFO_PLUS WHERE PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.PRODUCT_ID#">
                </cfquery>
            <cfelse>
                <!--- Kategori degismemis ama ürün kodu degismis ise ürün kodu ile bu ürüne bagli stoklar da degiseceginden hepsini yenileyelim.--->
                <cfif not (arguments.old_product_code is arguments.product_code)>
                    <cfquery name="CHECK_CODE" datasource="#DSN1#">
                        SELECT PRODUCT_CODE FROM PRODUCT WHERE PRODUCT_CODE=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.PRODUCT_CODE#"> AND PRODUCT_ID <> <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.PRODUCT_ID#">
                    </cfquery>
                    <cfif check_code.recordcount>
                        <cfset responseStruct.message = getLang('','Girdiğiniz Ürün Kodu Başka Bir Ürün Tarafından Kullanılmakta Lütfen Başka Bir Ürün Kodu Giriniz',37895)>
                        <cfset responseStruct.status = false>
                        <cfset responseStruct.error = {}>
                        <cfabort>
                    </cfif>
                </cfif>
                <cfif not (arguments.old_product_code is arguments.product_code)>
                    <cfquery name="SEL_STOCK_ESKILER" datasource="#DSN1#">
                        SELECT STOCK_CODE AS PRODUCT_CODE, STOCK_ID FROM STOCKS WHERE STOCK_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.OLD_PRODUCT_CODE#%">
                    </cfquery>
                    <cflock name="#CREATEUUID()#" timeout="60">
                        <cftransaction>
                            <cfloop query="sel_stock_eskiler">
                                <cfset temp="">
                                <cfset fark = Len(sel_stock_eskiler.product_code) - Len(arguments.old_product_code)>
                                <cfif fark neq 0>
                                    <cfset temp = arguments.product_code & Right(sel_stock_eskiler.product_code,fark)>
                                <cfelse>
                                    <cfset temp = arguments.product_code>
                                </cfif>
                                <cfquery name="UPD_STOCK" datasource="#DSN1#">
                                    UPDATE 
                                        STOCKS 
                                    SET 
                                        STOCK_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TEMP#">,
                                        STOCK_STATUS = <cfif isDefined("arguments.PRODUCT_STATUS")>1<cfelse>0</cfif>,
                                        UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                                        UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#REMOTE_ADDR#">,
                                        UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
                                    WHERE 
                                        STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#SEL_STOCK_ESKILER.STOCK_ID#">
                                </cfquery>
                            </cfloop>
                        </cftransaction>
                    </cflock>
                </cfif>
            </cfif>
            <cfif isdefined("arguments.USER_FRIENDLY_URL") and len(arguments.USER_FRIENDLY_URL)> 
                <cf_workcube_user_friendly user_friendly_url='#arguments.user_friendly_url#' action_type='PRODUCT_ID' action_id='#arguments.PRODUCT_ID#' action_page='objects2.detail_product&product_id=#arguments.PRODUCT_ID#'>
            </cfif>
            <cf_wrk_get_history datasource="#dsn1#" source_table="PRODUCT" target_table="PRODUCT_HISTORY" insert_column_name="DENEME" record_name="PRODUCT_ID" RECORD_ID="#arguments.product_id#">
            <cfif isdefined("arguments.quality_startdate") and len(arguments.quality_startdate)>
                <cf_date tarih="arguments.quality_startdate">
            </cfif>
            <cfquery name="get_our_company_info" datasource="#dsn#">
                SELECT IS_PRODUCT_COMPANY FROM OUR_COMPANY_INFO WHERE COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
            </cfquery>
            <cfquery name="UPD_PRODUCT" datasource="#DSN1#" result="xxxx">
                UPDATE 
                    PRODUCT 
                SET 
                    USER_FRIENDLY_URL = <cfif isdefined("arguments.USER_FRIENDLY_URL") and len(arguments.USER_FRIENDLY_URL)><cfqueryparam cfsqltype="cf_sql_varchar" value="#user_friendly_#"><cfelse><cfqueryparam cfsqltype="cf_sql_nvarchar" null="yes" value=""></cfif>,
                    <cfif get_our_company_info.is_product_company neq 1>
                        PRODUCT_STATUS = <cfif isDefined("arguments.PRODUCT_STATUS") and arguments.PRODUCT_STATUS eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                        IS_QUALITY = <cfif isDefined("arguments.is_quality") and arguments.is_quality eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                        IS_COST = <cfif isDefined("arguments.IS_COST") and arguments.IS_COST eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                        IS_INVENTORY = <cfif isDefined("arguments.IS_INVENTORY") and arguments.IS_INVENTORY eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                        IS_PRODUCTION = <cfif isDefined("arguments.IS_PRODUCTION") and arguments.IS_PRODUCTION eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                        IS_SALES = <cfif isDefined("arguments.IS_SALES") and arguments.IS_SALES eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                        IS_PURCHASE = <cfif isDefined("arguments.IS_PURCHASE") and arguments.IS_PURCHASE eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                        IS_PROTOTYPE = <cfif isDefined("arguments.IS_PROTOTYPE") and arguments.IS_PROTOTYPE eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                        IS_TERAZI = <cfif isDefined("arguments.IS_TERAZI") and arguments.IS_TERAZI eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                        IS_SERIAL_NO = <cfif isDefined("arguments.IS_SERIAL_NO") and arguments.IS_SERIAL_NO eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                        IS_ZERO_STOCK = <cfif isDefined("arguments.IS_ZERO_STOCK") and arguments.IS_ZERO_STOCK eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                        IS_LIMITED_STOCK = <cfif isDefined("arguments.is_limited_stock") and arguments.is_limited_stock eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                        IS_COMMISSION = <cfif isDefined("arguments.is_commission") and arguments.is_commission eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                        IS_ADD_XML = <cfif isDefined("arguments.is_add_xml") and arguments.is_add_xml eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                        IS_LOT_NO = <cfif isDefined("arguments.is_lot_no") and arguments.is_lot_no eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                        COMPANY_ID = <cfif isDefined("arguments.COMPANY_ID") and len(arguments.COMPANY_ID) and len(arguments.COMP)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.COMPANY_ID#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes"></cfif>,
                        PRODUCT_MANAGER = <cfif isDefined('arguments.PRODUCT_MANAGER') and len(arguments.PRODUCT_MANAGER) and isDefined('arguments.PRODUCT_MANAGER_NAME') and len(arguments.PRODUCT_MANAGER_NAME)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.PRODUCT_MANAGER#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" null="yes" value=""></cfif>,
                        IS_INTERNET = <cfif isDefined('arguments.is_internet') and arguments.is_internet eq 1><cfqueryparam cfsqltype="cf_sql_integer" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="0"></cfif>,
                        IS_EXTRANET = <cfif isDefined('arguments.is_extranet') and arguments.is_extranet eq 1><cfqueryparam cfsqltype="cf_sql_integer" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="0"></cfif>,
                        IS_GIFT_CARD = <cfif isDefined('arguments.is_gift_card') and arguments.is_gift_card eq 1><cfqueryparam cfsqltype="cf_sql_integer" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="0"></cfif>,
                        GIFT_VALID_DAY = <cfif isDefined('arguments.gift_valid_day') and len(arguments.gift_valid_day)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.gift_valid_day#"><cfelse>NULL</cfif>,
                        IS_IMPORTED = <cfif isDefined("arguments.is_imported") and arguments.is_imported eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                    </cfif>
                    IS_KARMA = <cfif isDefined("arguments.IS_KARMA") and arguments.IS_KARMA eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                    PRODUCT_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.PRODUCT_CATID#">,
                    PRODUCT_NAME = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.PRODUCT_NAME#">,
                    TAX = <cfqueryparam cfsqltype="cf_sql_float" value="#arguments.TAX#">,
                    TAX_PURCHASE = <cfqueryparam cfsqltype="cf_sql_float" value="#arguments.TAX_PURCHASE#">,
                    OTV_TYPE = <cfif isDefined('arguments.OTV_TYPE') and len(arguments.OTV_TYPE)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.OTV_TYPE#"><cfelse>NULL</cfif>,
                    OTV = <cfif isDefined('arguments.OTV') and len(arguments.OTV)><cfqueryparam cfsqltype="cf_sql_float" value="#filterNum(arguments.OTV,4)#"><cfelse>NULL</cfif>,
                    OIV = <cfif isDefined('arguments.OIV') and len(arguments.OIV)><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.OIV#"><cfelse>NULL</cfif>,
                    BSMV = <cfif isDefined('arguments.BSMV') and len(arguments.BSMV)><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.BSMV#"><cfelse>NULL</cfif>,
                    BARCOD = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.BARCOD#">,
                    PRODUCT_DETAIL = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.PRODUCT_DETAIL#">,
                    PRODUCT_DETAIL2 = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.PRODUCT_DETAIL2#">,
                    BRAND_ID = <cfif len(arguments.brand_name) and len(arguments.brand_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.brand_id#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes"></cfif>,
                    PRODUCT_CODE = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.PRODUCT_CODE#">,
                    MANUFACT_CODE = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.MANUFACT_CODE#">,
                    SHELF_LIFE = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.SHELF_LIFE#">,
                    SEGMENT_ID = <cfif isDefined('arguments.SEGMENT_ID') and len(arguments.SEGMENT_ID)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.SEGMENT_ID#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes"></cfif>,
                    
                    PROD_COMPETITIVE = <cfif isDefined('arguments.prod_comp') and len(arguments.prod_comp)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.prod_comp#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes"></cfif>,
                    PRODUCT_STAGE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.process_stage#">,
                    MIN_MARGIN = <cfif isDefined('arguments.MIN_MARGIN') and len(arguments.MIN_MARGIN)><cfqueryparam cfsqltype="cf_sql_float" value="#filterNum(arguments.MIN_MARGIN,4)#"><cfelse>null</cfif>,		
                    MAX_MARGIN = <cfif isDefined('arguments.MAX_MARGIN') and len(arguments.MAX_MARGIN)><cfqueryparam cfsqltype="cf_sql_float" value="#filterNum(arguments.MAX_MARGIN,4)#"><cfelse>null</cfif>,		
                    PRODUCT_CODE_2 = <cfif len(arguments.product_code_2)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.product_code_2#"><cfelse><cfqueryparam cfsqltype="cf_sql_nvarchar" value="" null="yes"></cfif>,
                    SHORT_CODE = <cfif len(arguments.SHORT_CODE)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.SHORT_CODE#"><cfelse><cfqueryparam cfsqltype="cf_sql_nvarchar" value="" null="yes"></cfif>,
                    SHORT_CODE_ID = <cfif len(arguments.SHORT_CODE_ID)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.SHORT_CODE_ID#"><cfelse><cfqueryparam cfsqltype="cf_sql_nvarchar" value="" null="yes"></cfif>,
                    WORK_STOCK_ID = <cfif isdefined('arguments.work_product_name') and len(arguments.work_product_name) and len(arguments.work_stock_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.work_stock_id#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes"></cfif>,
                    WORK_STOCK_AMOUNT = <cfif isdefined('arguments.work_product_name') and len(arguments.work_product_name) and len(arguments.work_stock_id) and len(arguments.work_stock_amount)><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.work_stock_amount#"><cfelse><cfqueryparam cfsqltype="cf_sql_float" value="" null="yes"></cfif>,
                    PACKAGE_CONTROL_TYPE = <cfif isdefined('arguments.PACKAGE_CONTROL_TYPE') and len(arguments.PACKAGE_CONTROL_TYPE)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.PACKAGE_CONTROL_TYPE#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes"></cfif>,
                    <cfif IsDefined("session.ep.userid")>
                        UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                    <cfelseif IsDefined("session.pp.userid")>
                        UPDATE_PAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#">,
                    </cfif>		
                    UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                    UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#cgi.REMOTE_ADDR#">,
                    CUSTOMS_RECIPE_CODE = <cfif isdefined("arguments.customs_recipe_code") and len(arguments.customs_recipe_code)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.customs_recipe_code#"><cfelse><cfqueryparam cfsqltype="cf_sql_nvarchar" value="" null="yes"></cfif>,
                    IS_WATALOGY_INTEGRATED = <cfif isdefined('arguments.is_watalogy_integrated') and arguments.is_watalogy_integrated eq 1><cfqueryparam cfsqltype="cf_sql_bit" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_bit" value="0"></cfif>,
                    WATALOGY_CAT_ID = <cfif isdefined('arguments.watalogy_cat_id') and isdefined('arguments.watalogy_cat_name') and len(arguments.watalogy_cat_id) and len(arguments.watalogy_cat_name)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.watalogy_cat_id#"><cfelse>NULL</cfif>,
                    PRODUCT_KEYWORD = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.product_keyword#" null="#not len(arguments.product_keyword)#">,
                    PRODUCT_DESCRIPTION = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.product_description#" null="#not len(arguments.product_description)#">,
                    PRODUCT_DETAIL_WATALOGY = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.product_detail_watalogy#" null="#not len(arguments.product_detail_watalogy)#">
                    <cfif get_our_company_info.is_product_company eq 0>,QUALITY_START_DATE = <cfif isdefined("arguments.quality_startdate") and len(arguments.quality_startdate)><cfqueryparam cfsqltype="cf_sql_date" value="#arguments.quality_startdate#"><cfelse><cfqueryparam cfsqltype="cf_sql_date" value="" null="yes"></cfif></cfif>,
                    ORIGIN_ID = <cfif isdefined("arguments.origin") and len(arguments.origin)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.origin#"><cfelse>NULL</cfif>
                    ,PURCHASE_CARBON_VALUE = <cfif isDefined('arguments.PURCHASE_CARBON_VALUE') and len(arguments.PURCHASE_CARBON_VALUE)><cfqueryparam cfsqltype="cf_sql_float" value="#filterNum(arguments.PURCHASE_CARBON_VALUE,8)#"><cfelse>NULL</cfif>
                    ,SALES_CARBON_VALUE = <cfif isDefined('arguments.SALES_CARBON_VALUE') and len(arguments.SALES_CARBON_VALUE)><cfqueryparam cfsqltype="cf_sql_float" value="#filterNum(arguments.SALES_CARBON_VALUE,8)#"><cfelse>NULL</cfif>
                    ,RECYCLE_RATE = <cfif isDefined('arguments.RECYCLE_RATE') and len(arguments.RECYCLE_RATE)><cfqueryparam cfsqltype="cf_sql_float" value="#filterNum(arguments.RECYCLE_RATE)#"><cfelse>NULL</cfif>
                    ,RECYCLE_METHOD = <cfif isDefined('arguments.RECYCLE_METHOD') and len(arguments.RECYCLE_METHOD)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.RECYCLE_METHOD#"><cfelse>NULL</cfif>
                    ,RECYCLE_CALCULATION_TYPE = <cfif isDefined('arguments.RECYCLE_CALCULATION_TYPE') and len(arguments.RECYCLE_CALCULATION_TYPE)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.RECYCLE_CALCULATION_TYPE#"><CFELSE>NULL</cfif>
                    ,PROJECT_ID = <cfif isDefined('arguments.PROJECT_ID') and len(arguments.PROJECT_ID) AND LEN(arguments.PROJECT_HEAD)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.PROJECT_ID#"><cfelse>NULL</cfif>
                    ,P_PROFIT = <cfif isDefined('arguments.P_PROFIT') and len(arguments.P_PROFIT)><cfqueryparam cfsqltype="cf_sql_float" value="#filterNum(arguments.P_PROFIT)#"><cfelse>NULL</cfif>
                    ,S_PROFIT = <cfif isDefined('arguments.S_PROFIT') and len(arguments.S_PROFIT)><cfqueryparam cfsqltype="cf_sql_float" value="#filterNum(arguments.S_PROFIT)#"><cfelse>NULL</cfif>
                    ,DUEDAY = <cfif isDefined('arguments.DUEDAY') and len(arguments.DUEDAY)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.DUEDAY#"><cfelse>NULL</cfif>
                    ,MAXIMUM_STOCK = <cfif isDefined('arguments.MAXIMUM_STOCK') and len(arguments.MAXIMUM_STOCK)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.MAXIMUM_STOCK#"><cfelse>NULL</cfif>
                    ,G_PRODUCT_TYPE = <cfif isDefined('arguments.G_PRODUCT_TYPE') and len(arguments.G_PRODUCT_TYPE)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.G_PRODUCT_TYPE#"><cfelse>NULL</cfif>
                    ,ADD_STOCK_DAY = <cfif isDefined('arguments.ADD_STOCK_DAY') and len(arguments.ADD_STOCK_DAY)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.ADD_STOCK_DAY#"><cfelse>NULL</cfif>
                    ,MINIMUM_STOCK = <cfif isDefined('arguments.MINIMUM_STOCK') and len(arguments.MINIMUM_STOCK)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.MINIMUM_STOCK#"><cfelse>NULL</cfif>
                    ,ORDER_LIMIT = <cfif isDefined('arguments.ORDER_LIMIT') and len(arguments.ORDER_LIMIT)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.ORDER_LIMIT#"><cfelse>NULL</cfif>
                    ,PRODUCT_MEMBER_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.product_id#-#arguments.watalogy_member_code#">
                    ,DISPOSAL_COST = <cfif isDefined('arguments.DISPOSAL_COST') and len(arguments.DISPOSAL_COST)><cfqueryparam cfsqltype="cf_sql_float" value="#filterNum(arguments.DISPOSAL_COST)#"><cfelse>NULL</cfif>
                    ,DISPOSAL_COST_CURRENCY = <cfif isDefined('arguments.DISPOSAL_COST_CURRENCY') and len(arguments.DISPOSAL_COST_CURRENCY)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.DISPOSAL_COST_CURRENCY#"><cfelse>NULL</cfif>
                    ,RECYCLE_GROUP_ID = <cfif isDefined('arguments.RECYCLE_GROUP_ID') and len(arguments.RECYCLE_GROUP_ID) and isDefined('arguments.RECYCLE_GROUP') and len(arguments.RECYCLE_GROUP)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.RECYCLE_GROUP_ID#"><cfelse>NULL</cfif>
                WHERE  
                    PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.product_id#">
            </cfquery>
            <cfif get_our_company_info.recordcount and get_our_company_info.IS_PRODUCT_COMPANY neq 1>
                <cfquery name="GET_PRODUCT_COMPANY" datasource="#DSN1#">
                    SELECT OUR_COMPANY_ID,PRODUCT_ID FROM PRODUCT_GENERAL_PARAMETERS WHERE PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.product_id#"> AND OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
                </cfquery>
                <cfif not GET_PRODUCT_COMPANY.recordcount>
                    <cfquery name="add_general_parameters" datasource="#dsn1#">
                        INSERT INTO PRODUCT_GENERAL_PARAMETERS
                        (
                            PRODUCT_ID,
                            COMPANY_ID, 
                            OUR_COMPANY_ID,
                            PRODUCT_MANAGER,
                            PRODUCT_STATUS, 
                            IS_INVENTORY, 
                            IS_PRODUCTION, 
                            IS_SALES, 
                            IS_PURCHASE, 
                            IS_PROTOTYPE,
                            IS_INTERNET, 
                            IS_EXTRANET, 
                            IS_TERAZI, 
                            IS_KARMA, 
                            IS_ZERO_STOCK, 
                            IS_LIMITED_STOCK, 
                            IS_SERIAL_NO, 
                            IS_COST, 
                            IS_QUALITY, 
                            IS_COMMISSION,
                            IS_ADD_XML,
                            IS_GIFT_CARD,
                            IS_LOT_NO,
                            GIFT_VALID_DAY,
                            QUALITY_START_DATE,
                            IS_IMPORTED
                        )
                        VALUES
                        (
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.product_id#">, 
                            <cfif isDefined("arguments.COMPANY_ID") and len(arguments.COMPANY_ID) and len(arguments.COMP)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.COMPANY_ID#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes"></cfif>,
                            #session.ep.company_id#,
                            <cfif isDefined('arguments.PRODUCT_MANAGER') and len(arguments.PRODUCT_MANAGER) and isDefined('arguments.PRODUCT_MANAGER_NAME') and len(arguments.PRODUCT_MANAGER_NAME)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.PRODUCT_MANAGER#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" null="yes" value=""></cfif>,
                            <cfif isDefined("arguments.PRODUCT_STATUS")><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                            <cfif isDefined("arguments.is_inventory") and arguments.is_inventory eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                            <cfif isDefined("arguments.is_production") and arguments.is_production eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>, 
                            <cfif isDefined("arguments.is_sales") and arguments.is_sales eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>, 
                            <cfif isDefined("arguments.is_purchase") and arguments.is_purchase eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>, 
                            <cfif isDefined("arguments.is_prototype") and arguments.is_prototype eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                            <cfif isDefined("arguments.is_internet") and arguments.is_internet eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                            <cfif isDefined("arguments.is_extranet") and arguments.is_extranet eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>, 
                            <cfif isDefined("arguments.is_terazi") and arguments.is_terazi eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                            <cfif isDefined("arguments.is_karma") and arguments.is_karma eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                            <cfif isDefined("arguments.is_zero_stock") and arguments.is_zero_stock eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                            <cfif isDefined("arguments.is_limited_stock") and arguments.is_limited_stock eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                            <cfif isDefined("arguments.is_serial_no") and arguments.is_serial_no eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                            <cfif isDefined("arguments.is_cost") and arguments.is_cost eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                            <cfif isDefined("arguments.is_quality") and arguments.is_quality eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                            <cfif isDefined("arguments.is_commission") and arguments.is_commission eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                            <cfif isDefined("arguments.is_add_xml") and arguments.is_add_xml eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                            <cfif isDefined('arguments.is_gift_card')><cfqueryparam cfsqltype="cf_sql_integer" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="0"></cfif>,
                            <cfif isDefined("arguments.is_lot_no") and arguments.is_lot_no eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                            <cfif isDefined('arguments.gift_valid_day') and len(arguments.gift_valid_day)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.gift_valid_day#"><cfelse>NULL</cfif>,
                            <cfif isdefined("arguments.quality_startdate") and len(arguments.quality_startdate)><cfqueryparam cfsqltype="cf_sql_date" value="#arguments.quality_startdate#"><cfelse><cfqueryparam cfsqltype="cf_sql_date" value="" null="yes"></cfif>,
                            <cfif isDefined("arguments.is_imported") and arguments.is_imported eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>
                        )
                    </cfquery>
                <cfelse>
                    <cfquery name="upd_general_parameters" datasource="#dsn1#">
                        UPDATE
                            PRODUCT_GENERAL_PARAMETERS
                        SET
                            PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.product_id#">, 
                            COMPANY_ID = <cfif isDefined("arguments.COMPANY_ID") and len(arguments.COMPANY_ID) and len(arguments.COMP)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.COMPANY_ID#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes"></cfif>,
                            OUR_COMPANY_ID = #session.ep.company_id#,
                            PRODUCT_MANAGER = <cfif isDefined('arguments.PRODUCT_MANAGER') and len(arguments.PRODUCT_MANAGER) and isDefined('arguments.PRODUCT_MANAGER_NAME') and len(arguments.PRODUCT_MANAGER_NAME)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.PRODUCT_MANAGER#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" null="yes" value=""></cfif>,
                            PRODUCT_STATUS = <cfif isDefined("arguments.PRODUCT_STATUS")><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                            IS_INVENTORY = <cfif isDefined("arguments.is_inventory") and arguments.is_inventory eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                            IS_PRODUCTION = <cfif isDefined("arguments.is_production") and arguments.is_production eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>, 
                            IS_SALES = <cfif isDefined("arguments.is_sales") and arguments.is_sales eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>, 
                            IS_PURCHASE = <cfif isDefined("arguments.is_purchase") and arguments.is_purchase eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>, 
                            IS_PROTOTYPE = <cfif isDefined("arguments.is_prototype") and arguments.is_prototype eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                            IS_INTERNET = <cfif isDefined("arguments.is_internet") and arguments.is_internet eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                            IS_EXTRANET = <cfif isDefined("arguments.is_extranet") and arguments.is_extranet eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>, 
                            IS_TERAZI = <cfif isDefined("arguments.is_terazi") and arguments.is_terazi eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                            IS_KARMA = <cfif isDefined("arguments.is_karma") and arguments.is_karma eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                            IS_ZERO_STOCK = <cfif isDefined("arguments.is_zero_stock") and arguments.is_zero_stock eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                            IS_LIMITED_STOCK = <cfif isDefined("arguments.is_limited_stock") and arguments.is_limited_stock eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                            IS_SERIAL_NO = <cfif isDefined("arguments.is_serial_no") and arguments.is_serial_no eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                            IS_COST = <cfif isDefined("arguments.is_cost") and arguments.is_cost eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                            IS_QUALITY = <cfif isDefined("arguments.is_quality") and arguments.is_quality eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                            IS_COMMISSION = <cfif isDefined("arguments.is_commission") and arguments.is_commission eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                            IS_ADD_XML = <cfif isDefined("arguments.is_add_xml") and arguments.is_add_xml eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                            IS_GIFT_CARD = <cfif isDefined('arguments.is_gift_card')><cfqueryparam cfsqltype="cf_sql_integer" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="0"></cfif>,
                            IS_LOT_NO = <cfif isDefined("arguments.is_lot_no") and arguments.is_lot_no eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                            GIFT_VALID_DAY = <cfif isDefined('arguments.gift_valid_day') and len(arguments.gift_valid_day)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.gift_valid_day#"><cfelse>NULL</cfif>,
                            QUALITY_START_DATE = <cfif isdefined("arguments.quality_startdate") and len(arguments.quality_startdate)><cfqueryparam cfsqltype="cf_sql_date" value="#arguments.quality_startdate#"><cfelse><cfqueryparam cfsqltype="cf_sql_date" value="" null="yes"></cfif>,
                            IS_IMPORTED = <cfif isDefined("arguments.is_imported") and arguments.is_imported eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>
                        WHERE
                            PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.product_id#">
                    </cfquery>
                    
                </cfif>
            </cfif>
            <cfquery name="get_lang" datasource="#dsn#">
                SELECT
                    ITEM,
                    LANGUAGE
                FROM 
                    SETUP_LANGUAGE_INFO
                WHERE
                    UNIQUE_COLUMN_ID = #arguments.product_id# AND
                    COLUMN_NAME = 'PRODUCT_NAME' AND
                    TABLE_NAME = 'PRODUCT' AND
                    LANGUAGE = '#session.ep.language#'
            </cfquery>
            <cfif get_lang.recordcount>
                <cfquery name="upd_" datasource="#dsn#">
                    UPDATE SETUP_LANGUAGE_INFO SET ITEM = '#arguments.product_name#' WHERE UNIQUE_COLUMN_ID = #arguments.product_id# AND COLUMN_NAME = 'PRODUCT_NAME' AND TABLE_NAME = 'PRODUCT' AND LANGUAGE = '#session.ep.language#'
                </cfquery>
            </cfif>
            <cfquery name="get_lang_det" datasource="#dsn#">
                SELECT
                    ITEM,
                    LANGUAGE
                FROM 
                    SETUP_LANGUAGE_INFO
                WHERE
                    UNIQUE_COLUMN_ID = #arguments.product_id# AND
                    COLUMN_NAME = 'PRODUCT_DETAIL' AND
                    TABLE_NAME = 'PRODUCT' AND
                    LANGUAGE = '#session.ep.language#'
            </cfquery>
            <cfif get_lang_det.recordcount>
                <cfquery name="upd_lang_det" datasource="#dsn#">
                    UPDATE SETUP_LANGUAGE_INFO SET ITEM = '#arguments.PRODUCT_DETAIL#' WHERE UNIQUE_COLUMN_ID = #arguments.product_id# AND COLUMN_NAME = 'PRODUCT_DETAIL' AND TABLE_NAME = 'PRODUCT' AND LANGUAGE = '#session.ep.language#'
                </cfquery>
            </cfif>
            <cfif arguments.is_spect_name_upd eq 1>
                <cfquery name="get_prod_prototype" datasource="#DSN1#">
                    SELECT IS_PROTOTYPE FROM PRODUCT WHERE PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.product_id#">
                </cfquery>
                <cfif get_prod_prototype.IS_PROTOTYPE eq 0>
                    <cfquery name="upd_prod_spect" datasource="#dsn3#" maxrows="1">
                        UPDATE
                            SPECT_MAIN
                        SET
                            SPECT_MAIN_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.PRODUCT_NAME#">
                        WHERE
                            STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_stock_barcode_query.STOCK_ID#"> AND
                            SPECT_STATUS = 1
                    </cfquery>
                </cfif>
            </cfif>
            <!--- <cfset indexProducts = refreshCollection()> --->
            <!--- Custom Tag' a Gidecek Parametreler --->
            <cfset pid = arguments.product_id>
            <cf_workcube_process 
                is_upd='1' 
                old_process_line='#arguments.old_process_line#'
                process_stage='#arguments.process_stage#' 
                record_member='#session.ep.userid#'
                record_date='#now()#'
                action_table='PRODUCT'
                action_column='PRODUCT_ID'
                action_id='#arguments.product_id#' 
                action_page='#request.self#?fuseaction=#listgetat(arguments.fuseaction,1,'.')#.list_product&event=det&pid=#arguments.product_id#' 
                warning_description='Ürün : #arguments.product_name#'>
            <!--- //Custom Tag' a Gidecek Parametreler --->
            <cfif arguments.BARCOD neq arguments.OLD_BARCOD or arguments.MANUFACT_CODE neq arguments.old_MANUFACT_CODE or arguments.PRODUCT_CODE_2 neq arguments.old_PRODUCT_CODE_2>
                <cfquery name="upd_stock_barcode" datasource="#DSN1#">
                    UPDATE
                        STOCKS
                    SET
                        <cfif arguments.PRODUCT_CODE_2 neq arguments.old_PRODUCT_CODE_2>STOCK_CODE_2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.PRODUCT_CODE_2#">,</cfif>
                        <cfif arguments.MANUFACT_CODE neq arguments.old_MANUFACT_CODE>MANUFACT_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.MANUFACT_CODE#">,</cfif>
                        <cfif arguments.BARCOD neq arguments.OLD_BARCOD>BARCOD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.BARCOD#">,</cfif>
                        STOCK_STATUS = <cfif isDefined("arguments.PRODUCT_STATUS")><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                        UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                        UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#REMOTE_ADDR#">,
                        UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
                    WHERE
                        STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_stock_barcode_query.STOCK_ID#">
                </cfquery>
                <cfif arguments.BARCOD neq arguments.OLD_BARCOD and get_stock_barcode_query.recordcount>
                    <cfquery name="upd_stock_barcode" datasource="#dsn1#">
                        UPDATE
                            STOCKS_BARCODES
                        SET
                            BARCODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.BARCOD#">
                        WHERE
                            BARCODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.OLD_BARCOD#"> AND 
                            STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_stock_barcode_query.STOCK_ID#">
                    </cfquery>
                </cfif>
            </cfif>
          
            <!--- Standart Alış ve Standart Satış Burada Kayıt Ediliyor --->

            <cfif (arguments.STANDART_ALIS neq arguments.OLD_STANDART_ALIS) or (arguments.MONEY_ID_SA neq arguments.MONEY_ID_SA_OLD) or (arguments.is_tax_included_purchase neq arguments.old_is_tax_included_purchase) or (arguments.old_tax_purchase neq arguments.tax_purchase) or (arguments.old_tax_sell neq arguments.tax)>
                <cflock name="#CREATEUUID()#" timeout="60">
                    <cftransaction>
                        <cfquery name="DEL_PRODUCT_PRICE_PURCHASE" datasource="#dsn1#">
                            DELETE FROM
                                PRICE_STANDART
                            WHERE
                                PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.PRODUCT_ID#"> AND
                                PURCHASESALES = <cfqueryparam cfsqltype="cf_sql_smallint" value="0"> AND
                                UNIT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_UNIT.PRODUCT_UNIT_ID#"> AND
                                START_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#bugun_00#">						
                        </cfquery> 
                        <cfscript>
                            if (isnumeric(arguments.STANDART_ALIS))
                                if (arguments.is_tax_included_purchase eq 1)
                                    {
                                        purchase_kdvsiz = wrk_round(arguments.STANDART_ALIS*100/(arguments.tax_purchase+100),session.ep.our_company_info.purchase_price_round_num);
                                        purchase_kdvli = arguments.STANDART_ALIS;
                                        purchase_is_tax_included = 1;
                                    }
                                else
                                    {
                                        purchase_kdvsiz = arguments.STANDART_ALIS;
                                        purchase_kdvli = wrk_round(arguments.STANDART_ALIS*(1+(arguments.tax_purchase/100)),session.ep.our_company_info.purchase_price_round_num);
                                        purchase_is_tax_included = 0;
                                    }
                            else
                                {
                                    purchase_kdvsiz = 0;
                                    purchase_kdvli = 0;
                                    purchase_is_tax_included = 0;
                                }					
                        </cfscript>
                        <cfquery name="CORRECT_PRICE_0" datasource="#dsn1#">
                            UPDATE 
                                PRICE_STANDART
                            SET 
                                PRICESTANDART_STATUS = <cfqueryparam cfsqltype="cf_sql_smallint" value="0">,
                                RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.EP.USERID#">
                            WHERE 
                                PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.PRODUCT_ID#"> AND 
                                PURCHASESALES = <cfqueryparam cfsqltype="cf_sql_smallint" value="0"> AND
                                UNIT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_UNIT.PRODUCT_UNIT_ID#"> AND
                                PRICESTANDART_STATUS = <cfqueryparam cfsqltype="cf_sql_smallint" value="1">
                        </cfquery>
                        <cfquery name="ADD_STANDART_PRICE" datasource="#dsn1#">
                            INSERT INTO 
                                PRICE_STANDART
                            (
                                PRODUCT_ID,
                                PURCHASESALES,
                                PRICE,
                                PRICE_KDV,
                                IS_KDV,
                                ROUNDING,
                                START_DATE,
                                RECORD_DATE,
                                RECORD_IP,
                                PRICESTANDART_STATUS,
                                MONEY,
                                UNIT_ID,
                                RECORD_EMP
                            )
                            VALUES 
                            (
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.PRODUCT_ID#">,
                                <cfqueryparam cfsqltype="cf_sql_smallint" value="0">,							
                                <cfqueryparam cfsqltype="cf_sql_float" value="#purchase_kdvsiz#">,
                                <cfqueryparam cfsqltype="cf_sql_float" value="#purchase_kdvli#">,
                                <cfqueryparam cfsqltype="cf_sql_smallint" value="#purchase_is_tax_included#">,
                                <cfqueryparam cfsqltype="cf_sql_integer" value="0">,
                                <cfqueryparam cfsqltype="cf_sql_timestamp" value="#bugun_00#">,
                                <cfqueryparam cfsqltype="cf_sql_timestamp" value="#NOW()#">,
                                <cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTEADDR#">,
                                <cfqueryparam cfsqltype="cf_sql_smallint" value="1">,
                                <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.MONEY_ID_SA#">,
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_UNIT.PRODUCT_UNIT_ID#">,
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.EP.USERID#">
                            )
                        </cfquery>
                    </cftransaction>
                </cflock>
            </cfif>
            <cfif (arguments.OLD_STANDART_SATIS neq arguments.STANDART_SATIS) or (arguments.MONEY_ID_SS neq arguments.MONEY_ID_SS_OLD) or (arguments.is_tax_included_sales neq arguments.old_is_tax_included_sales) or (arguments.old_tax_purchase neq arguments.tax_purchase) or (arguments.old_tax_sell neq arguments.tax)>
                <cflock name="#CREATEUUID()#" timeout="60">
                    <cftransaction>
                        <cfquery name="DEL_PRODUCT_PRICE_SALES" datasource="#dsn1#">
                            DELETE FROM
                                PRICE_STANDART
                            WHERE
                                PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.PRODUCT_ID#"> AND
                                PURCHASESALES = <cfqueryparam cfsqltype="cf_sql_smallint" value="1"> AND
                                UNIT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_UNIT.PRODUCT_UNIT_ID#"> AND
                                START_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#bugun_00#">						
                        </cfquery>
                        <cfscript>
                            if (isnumeric(arguments.STANDART_SATIS))
                                if (arguments.is_tax_included_sales eq 1)
                                    {
                                        price_kdvsiz = wrk_round(arguments.STANDART_SATIS*100/(arguments.tax+100),session.ep.our_company_info.sales_price_round_num);
                                        price_kdvli = arguments.STANDART_SATIS;
                                        price_is_tax_included = 1;
                                    }
                                else
                                    {
                                        price_kdvsiz = arguments.STANDART_SATIS;
                                        price_kdvli = wrk_round(arguments.STANDART_SATIS*(1+(arguments.tax/100)),session.ep.our_company_info.sales_price_round_num);
                                        price_is_tax_included = 0;
                                    }
                            else
                                {
                                    price_kdvsiz = 0;
                                    price_kdvli = 0;
                                    price_is_tax_included = 0;
                                }					
                        </cfscript>
                        <cfquery name="CORRECT_PRICE_0" datasource="#dsn1#">
                            UPDATE 
                                PRICE_STANDART
                            SET 
                                PRICESTANDART_STATUS = <cfqueryparam cfsqltype="cf_sql_smallint" value="0">,
                                RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.EP.USERID#">
                            WHERE 
                                PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.PRODUCT_ID#"> AND 
                                PURCHASESALES = <cfqueryparam cfsqltype="cf_sql_smallint" value="1"> AND
                                UNIT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_UNIT.PRODUCT_UNIT_ID#"> AND
                                PRICESTANDART_STATUS = <cfqueryparam cfsqltype="cf_sql_smallint" value="1">
                        </cfquery>
                        <cfquery name="ADD_STANDART_PRICE" datasource="#dsn1#">
                            INSERT INTO PRICE_STANDART 
                                (
                                    PRODUCT_ID,
                                    PURCHASESALES,							
                                    PRICE,
                                    PRICE_KDV,
                                    IS_KDV,
                                    ROUNDING,
                                    START_DATE,
                                    RECORD_DATE,
                                    RECORD_IP,
                                    PRICESTANDART_STATUS,
                                    MONEY,
                                    UNIT_ID,
                                    RECORD_EMP
                                )
                            VALUES 
                                (
                                    <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.PRODUCT_ID#">,
                                    <cfqueryparam cfsqltype="cf_sql_smallint" value="1">,							
                                    <cfqueryparam cfsqltype="cf_sql_float" value="#price_kdvsiz#">,
                                    <cfqueryparam cfsqltype="cf_sql_float" value="#price_kdvli#">,
                                    <cfqueryparam cfsqltype="cf_sql_smallint" value="#price_is_tax_included#">,
                                    <cfqueryparam cfsqltype="cf_sql_integer" value="0">,
                                    <cfqueryparam cfsqltype="cf_sql_timestamp" value="#bugun_00#">,
                                    <cfqueryparam cfsqltype="cf_sql_timestamp" value="#NOW()#">,
                                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTEADDR#">,
                                    <cfqueryparam cfsqltype="cf_sql_smallint" value="1">,
                                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.MONEY_ID_SS#">,
                                    <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_UNIT.PRODUCT_UNIT_ID#">,
                                    <cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.EP.USERID#">
                                )						
                        </cfquery>
                    
                    </cftransaction>
                </cflock>
            </cfif>
            <cfquery name="GET_MAX_STCK" datasource="#DSN3#">
                SELECT MAX(STOCK_ID) AS MAX_STCK FROM #dsn1_alias#.STOCKS
            </cfquery>
            <cfif isdefined('arguments.acc_code_cat') and len(arguments.acc_code_cat)>
                <cfquery name="GET_CODES" datasource="#DSN3#">
                    SELECT * FROM SETUP_PRODUCT_PERIOD_CAT WHERE PRO_CODE_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.acc_code_cat#">
                </cfquery>
            <cfelse>
                <cfset get_codes.recordcount = 0>
            </cfif>
            <cfif GET_CODES.recordcount>
                <cfquery name = "PRODUCT_PERIOD_CONTROL" datasource="#DSN3#">
                    SELECT * FROM PRODUCT_PERIOD WHERE PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.PRODUCT_ID#"> AND PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.EP.PERIOD_ID#"> 
                </cfquery>
            
                <cfif arguments.old_acc_code_cat eq arguments.acc_code_cat> <!--- muhasebe kodu varsa ve degisim olmicaksa --->
                <cfelseif len(arguments.old_acc_code_cat)><!---  daha onceden muhasebe kodu varsa guncelle --->
                    <cfquery name="UPD_MAIN_UNIT" datasource="#DSN3#">
                        UPDATE 
                            PRODUCT_PERIOD 
                        SET
                            PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.PRODUCT_ID#">,  
                            PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.EP.PERIOD_ID#"> ,
                            ACCOUNT_CODE = <cfif len(GET_CODES.ACCOUNT_CODE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.ACCOUNT_CODE#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
                            ACCOUNT_CODE_PUR = <cfif len(GET_CODES.ACCOUNT_CODE_PUR)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.ACCOUNT_CODE_PUR#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
                            ACCOUNT_DISCOUNT = <cfif len(GET_CODES.ACCOUNT_DISCOUNT)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.ACCOUNT_DISCOUNT#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
                            ACCOUNT_PRICE = <cfif len(GET_CODES.ACCOUNT_PRICE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.ACCOUNT_PRICE#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
                            ACCOUNT_PUR_IADE = <cfif len(GET_CODES.ACCOUNT_PUR_IADE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.ACCOUNT_PUR_IADE#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
                            ACCOUNT_IADE = <cfif len(GET_CODES.ACCOUNT_IADE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.ACCOUNT_IADE#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
                            ACCOUNT_DISCOUNT_PUR =<cfif len(GET_CODES.ACCOUNT_DISCOUNT_PUR)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.ACCOUNT_DISCOUNT_PUR#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
                            ACCOUNT_YURTDISI = <cfif len(GET_CODES.ACCOUNT_YURTDISI)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.ACCOUNT_YURTDISI#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
                            ACCOUNT_YURTDISI_PUR = <cfif len(GET_CODES.ACCOUNT_YURTDISI_PUR)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.ACCOUNT_YURTDISI_PUR#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
                            EXPENSE_CENTER_ID = <cfif len(GET_CODES.INC_CENTER_ID)><cfqueryparam cfsqltype="cf_sql_integer" value="#GET_CODES.INC_CENTER_ID#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes"></cfif>,			
                            EXPENSE_ITEM_ID = <cfif len(GET_CODES.EXP_ITEM_ID)><cfqueryparam cfsqltype="cf_sql_integer" value="#GET_CODES.EXP_ITEM_ID#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes"></cfif>,
                            INCOME_ITEM_ID = <cfif len(GET_CODES.INC_ITEM_ID)><cfqueryparam cfsqltype="cf_sql_integer" value="#GET_CODES.INC_ITEM_ID#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes"></cfif>,
                            EXPENSE_TEMPLATE_ID =<cfif len(GET_CODES.EXP_TEMPLATE_ID)><cfqueryparam cfsqltype="cf_sql_integer" value="#GET_CODES.EXP_TEMPLATE_ID#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes"></cfif>,  
                            ACTIVITY_TYPE_ID = <cfif len(GET_CODES.EXP_ACTIVITY_TYPE_ID)><cfqueryparam cfsqltype="cf_sql_integer" value="#GET_CODES.EXP_ACTIVITY_TYPE_ID#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes"></cfif>,		 
                            COST_EXPENSE_CENTER_ID = <cfif len(GET_CODES.EXP_CENTER_ID)><cfqueryparam cfsqltype="cf_sql_integer" value="#GET_CODES.EXP_CENTER_ID#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes"></cfif>, 
                            INCOME_ACTIVITY_TYPE_ID = <cfif len(GET_CODES.INC_ACTIVITY_TYPE_ID)><cfqueryparam cfsqltype="cf_sql_integer" value="#GET_CODES.INC_ACTIVITY_TYPE_ID#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes"></cfif>,	
                            INCOME_TEMPLATE_ID = <cfif len(GET_CODES.INC_TEMPLATE_ID)><cfqueryparam cfsqltype="cf_sql_integer" value="#GET_CODES.INC_TEMPLATE_ID#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes"></cfif>,
                            ACCOUNT_LOSS = <cfif len(GET_CODES.ACCOUNT_LOSS)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.ACCOUNT_LOSS#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
                            ACCOUNT_EXPENDITURE = <cfif len(GET_CODES.ACCOUNT_EXPENDITURE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.ACCOUNT_EXPENDITURE#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
                            OVER_COUNT = <cfif len(GET_CODES.OVER_COUNT)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.OVER_COUNT#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
                            UNDER_COUNT = <cfif len(GET_CODES.UNDER_COUNT)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.UNDER_COUNT#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
                            PRODUCTION_COST = <cfif len(GET_CODES.PRODUCTION_COST)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.PRODUCTION_COST#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,	
                            HALF_PRODUCTION_COST =<cfif len(GET_CODES.HALF_PRODUCTION_COST)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.HALF_PRODUCTION_COST#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
                            SALE_PRODUCT_COST = <cfif len(GET_CODES.SALE_PRODUCT_COST)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.SALE_PRODUCT_COST#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,					 
                            MATERIAL_CODE = <cfif len(GET_CODES.MATERIAL_CODE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.MATERIAL_CODE#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
                            KONSINYE_PUR_CODE = <cfif len(GET_CODES.KONSINYE_PUR_CODE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.KONSINYE_PUR_CODE#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
                            KONSINYE_SALE_CODE = <cfif len(GET_CODES.KONSINYE_SALE_CODE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.KONSINYE_SALE_CODE#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
                            KONSINYE_SALE_NAZ_CODE = <cfif len(GET_CODES.KONSINYE_SALE_NAZ_CODE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.KONSINYE_SALE_NAZ_CODE#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
                            DIMM_CODE = <cfif len(GET_CODES.DIMM_CODE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.DIMM_CODE#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
                            DIMM_YANS_CODE = <cfif len(GET_CODES.DIMM_YANS_CODE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.DIMM_YANS_CODE#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
                            PROMOTION_CODE = <cfif len(GET_CODES.PROMOTION_CODE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.PROMOTION_CODE#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
                            PRODUCT_PERIOD_CAT_ID = <cfif isdefined('arguments.acc_code_cat') and len(arguments.acc_code_cat)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.acc_code_cat#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes"></cfif>,
                            ACCOUNT_PRICE_PUR = <cfif len(GET_CODES.ACCOUNT_PRICE_PUR)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.ACCOUNT_PRICE_PUR#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
                            MATERIAL_CODE_SALE = <cfif len(GET_CODES.MATERIAL_CODE_SALE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.MATERIAL_CODE_SALE#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
                            PRODUCTION_COST_SALE = <cfif len(GET_CODES.PRODUCTION_COST_SALE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.PRODUCTION_COST_SALE#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
                            SALE_MANUFACTURED_COST = <cfif len(GET_CODES.SALE_MANUFACTURED_COST)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.SALE_MANUFACTURED_COST#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
                            PROVIDED_PROGRESS_CODE = <cfif len(GET_CODES.PROVIDED_PROGRESS_CODE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.PROVIDED_PROGRESS_CODE#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
                            SCRAP_CODE_SALE = <cfif len(GET_CODES.SCRAP_CODE_SALE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.SCRAP_CODE_SALE#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
                            SCRAP_CODE = <cfif len(GET_CODES.SCRAP_CODE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.SCRAP_CODE#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
                            PROD_GENERAL_CODE = <cfif len(GET_CODES.PROD_GENERAL_CODE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.PROD_GENERAL_CODE#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
                            PROD_LABOR_COST_CODE = <cfif len(GET_CODES.PROD_LABOR_COST_CODE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.PROD_LABOR_COST_CODE#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
                            RECEIVED_PROGRESS_CODE = <cfif len(GET_CODES.RECEIVED_PROGRESS_CODE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.RECEIVED_PROGRESS_CODE#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
                            INVENTORY_CAT_ID = <cfif len(GET_CODES.INVENTORY_CAT_ID)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.INVENTORY_CAT_ID#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
                            INVENTORY_CODE = <cfif len(GET_CODES.INVENTORY_CODE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.INVENTORY_CODE#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
                            AMORTIZATION_METHOD_ID = <cfif len(GET_CODES.AMORTIZATION_METHOD_ID)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.AMORTIZATION_METHOD_ID#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
                            AMORTIZATION_TYPE_ID = <cfif len(GET_CODES.AMORTIZATION_TYPE_ID)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.AMORTIZATION_TYPE_ID#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
                            AMORTIZATION_EXP_CENTER_ID = <cfif len(GET_CODES.AMORTIZATION_EXP_CENTER_ID)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.AMORTIZATION_EXP_CENTER_ID#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
                            AMORTIZATION_EXP_ITEM_ID = <cfif len(GET_CODES.AMORTIZATION_EXP_ITEM_ID)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.AMORTIZATION_EXP_ITEM_ID#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
                            AMORTIZATION_CODE = <cfif len(GET_CODES.AMORTIZATION_CODE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.AMORTIZATION_CODE#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
                            RECORD_EMP =  <cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.EP.USERID#">,
                            RECORD_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#NOW()#">,
                            RECORD_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTEADDR#">
                        WHERE 
                            PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.PRODUCT_ID#"> 
                        AND 
                            PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.EP.PERIOD_ID#"> 	
                    </cfquery>	
                <cfelse> <!--- ürünün muhasebe kodu girilmemisse --->
                    <!--- Muhasebe kodu popupından yapılan tanımlamaları kontrol etmediği için ürün muhasebe kodu tanımları birden fazla oluyordu --->
                    <cfquery name="delOldPeriods" datasource="#dsn3#">
                        DELETE FROM PRODUCT_PERIOD WHERE PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.PRODUCT_ID#"> AND PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.EP.PERIOD_ID#">
                    </cfquery>
                    <cfquery name="UPD_MAIN_UNIT" datasource="#DSN3#">
                        INSERT INTO PRODUCT_PERIOD
                        (
                            PRODUCT_ID,  
                            PERIOD_ID,
                            ACCOUNT_CODE,
                            ACCOUNT_CODE_PUR,
                            ACCOUNT_DISCOUNT, 
                            ACCOUNT_PRICE ,
                            ACCOUNT_PUR_IADE, 
                            ACCOUNT_IADE,
                            ACCOUNT_DISCOUNT_PUR,
                            ACCOUNT_YURTDISI,
                            ACCOUNT_YURTDISI_PUR,
                            EXPENSE_CENTER_ID,
                            EXPENSE_ITEM_ID ,
                            INCOME_ITEM_ID,
                            EXPENSE_TEMPLATE_ID,
                            ACTIVITY_TYPE_ID ,
                            COST_EXPENSE_CENTER_ID ,
                            INCOME_ACTIVITY_TYPE_ID ,
                            INCOME_TEMPLATE_ID,
                            ACCOUNT_LOSS ,
                            ACCOUNT_EXPENDITURE,
                            OVER_COUNT ,
                            UNDER_COUNT,
                            PRODUCTION_COST ,
                            HALF_PRODUCTION_COST,
                            SALE_PRODUCT_COST ,
                            MATERIAL_CODE,
                            KONSINYE_PUR_CODE ,
                            KONSINYE_SALE_CODE,
                            KONSINYE_SALE_NAZ_CODE,
                            DIMM_CODE,
                            DIMM_YANS_CODE,
                            PROMOTION_CODE,
                            PRODUCT_PERIOD_CAT_ID,
                            ACCOUNT_PRICE_PUR,
                            MATERIAL_CODE_SALE,
                            PRODUCTION_COST_SALE,
                            SALE_MANUFACTURED_COST,
                            PROVIDED_PROGRESS_CODE,
                            SCRAP_CODE_SALE,
                            SCRAP_CODE,
                            PROD_GENERAL_CODE,
                            PROD_LABOR_COST_CODE,
                            RECEIVED_PROGRESS_CODE,
                            INVENTORY_CAT_ID,
                            INVENTORY_CODE,
                            AMORTIZATION_METHOD_ID,
                            AMORTIZATION_TYPE_ID,
                            AMORTIZATION_EXP_CENTER_ID,
                            AMORTIZATION_EXP_ITEM_ID,
                            AMORTIZATION_CODE,
                            RECORD_EMP,
                            RECORD_DATE,
                            RECORD_IP
                        )
                        VALUES
                        (
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.PRODUCT_ID#">,
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.EP.PERIOD_ID#"> ,
                            <cfif len(GET_CODES.ACCOUNT_CODE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.ACCOUNT_CODE#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
                            <cfif len(GET_CODES.ACCOUNT_CODE_PUR)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.ACCOUNT_CODE_PUR#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
                            <cfif len(GET_CODES.ACCOUNT_DISCOUNT)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.ACCOUNT_DISCOUNT#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
                            <cfif len(GET_CODES.ACCOUNT_PRICE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.ACCOUNT_PRICE#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
                            <cfif len(GET_CODES.ACCOUNT_PUR_IADE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.ACCOUNT_PUR_IADE#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
                            <cfif len(GET_CODES.ACCOUNT_IADE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.ACCOUNT_IADE#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
                            <cfif len(GET_CODES.ACCOUNT_DISCOUNT_PUR)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.ACCOUNT_DISCOUNT_PUR#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
                            <cfif len(GET_CODES.ACCOUNT_YURTDISI)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.ACCOUNT_YURTDISI#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
                            <cfif len(GET_CODES.ACCOUNT_YURTDISI_PUR)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.ACCOUNT_YURTDISI_PUR#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
                            <cfif len(GET_CODES.INC_CENTER_ID)><cfqueryparam cfsqltype="cf_sql_integer" value="#GET_CODES.INC_CENTER_ID#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes"></cfif>,			
                            <cfif len(GET_CODES.EXP_ITEM_ID)><cfqueryparam cfsqltype="cf_sql_integer" value="#GET_CODES.EXP_ITEM_ID#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes"></cfif>,
                            <cfif len(GET_CODES.INC_ITEM_ID)><cfqueryparam cfsqltype="cf_sql_integer" value="#GET_CODES.INC_ITEM_ID#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes"></cfif>,
                            <cfif len(GET_CODES.EXP_TEMPLATE_ID)><cfqueryparam cfsqltype="cf_sql_integer" value="#GET_CODES.EXP_TEMPLATE_ID#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes"></cfif>,  
                            <cfif len(GET_CODES.EXP_ACTIVITY_TYPE_ID)><cfqueryparam cfsqltype="cf_sql_integer" value="#GET_CODES.EXP_ACTIVITY_TYPE_ID#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes"></cfif>,		 
                            <cfif len(GET_CODES.EXP_CENTER_ID)><cfqueryparam cfsqltype="cf_sql_integer" value="#GET_CODES.EXP_CENTER_ID#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes"></cfif>, 
                            <cfif len(GET_CODES.INC_ACTIVITY_TYPE_ID)><cfqueryparam cfsqltype="cf_sql_integer" value="#GET_CODES.INC_ACTIVITY_TYPE_ID#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes"></cfif>,	
                            <cfif len(GET_CODES.INC_TEMPLATE_ID)><cfqueryparam cfsqltype="cf_sql_integer" value="#GET_CODES.INC_TEMPLATE_ID#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes"></cfif>,
                            <cfif len(GET_CODES.ACCOUNT_LOSS)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.ACCOUNT_LOSS#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
                            <cfif len(GET_CODES.ACCOUNT_EXPENDITURE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.ACCOUNT_EXPENDITURE#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
                            <cfif len(GET_CODES.OVER_COUNT)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.OVER_COUNT#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
                            <cfif len(GET_CODES.UNDER_COUNT)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.UNDER_COUNT#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
                            <cfif len(GET_CODES.PRODUCTION_COST)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.PRODUCTION_COST#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,	
                            <cfif len(GET_CODES.HALF_PRODUCTION_COST)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.HALF_PRODUCTION_COST#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
                            <cfif len(GET_CODES.SALE_PRODUCT_COST)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.SALE_PRODUCT_COST#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,					 
                            <cfif len(GET_CODES.MATERIAL_CODE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.MATERIAL_CODE#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
                            <cfif len(GET_CODES.KONSINYE_PUR_CODE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.KONSINYE_PUR_CODE#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
                            <cfif len(GET_CODES.KONSINYE_SALE_CODE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.KONSINYE_SALE_CODE#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
                            <cfif len(GET_CODES.KONSINYE_SALE_NAZ_CODE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.KONSINYE_SALE_NAZ_CODE#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
                            <cfif len(GET_CODES.DIMM_CODE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.DIMM_CODE#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
                            <cfif len(GET_CODES.DIMM_YANS_CODE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.DIMM_YANS_CODE#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
                            <cfif len(GET_CODES.PROMOTION_CODE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.PROMOTION_CODE#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
                            <cfif isdefined('arguments.acc_code_cat') and len(arguments.acc_code_cat)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.acc_code_cat#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes"></cfif>,
                            <cfif len(GET_CODES.ACCOUNT_PRICE_PUR)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.ACCOUNT_PRICE_PUR#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
                            <cfif len(GET_CODES.MATERIAL_CODE_SALE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.MATERIAL_CODE_SALE#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
                            <cfif len(GET_CODES.PRODUCTION_COST_SALE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.PRODUCTION_COST_SALE#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
                            <cfif len(GET_CODES.SALE_MANUFACTURED_COST)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.SALE_MANUFACTURED_COST#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
                            <cfif len(GET_CODES.PROVIDED_PROGRESS_CODE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.PROVIDED_PROGRESS_CODE#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
                            <cfif len(GET_CODES.SCRAP_CODE_SALE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.SCRAP_CODE_SALE#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
                            <cfif len(GET_CODES.SCRAP_CODE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.SCRAP_CODE#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
                            <cfif len(GET_CODES.PROD_GENERAL_CODE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.PROD_GENERAL_CODE#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
                            <cfif len(GET_CODES.PROD_LABOR_COST_CODE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.PROD_LABOR_COST_CODE#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
                            <cfif len(GET_CODES.RECEIVED_PROGRESS_CODE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.RECEIVED_PROGRESS_CODE#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
                            <cfif len(GET_CODES.INVENTORY_CAT_ID)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.INVENTORY_CAT_ID#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
                            <cfif len(GET_CODES.INVENTORY_CODE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.INVENTORY_CODE#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
                            <cfif len(GET_CODES.AMORTIZATION_METHOD_ID)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.AMORTIZATION_METHOD_ID#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
                            <cfif len(GET_CODES.AMORTIZATION_TYPE_ID)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.AMORTIZATION_TYPE_ID#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
                            <cfif len(GET_CODES.AMORTIZATION_EXP_CENTER_ID)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.AMORTIZATION_EXP_CENTER_ID#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
                            <cfif len(GET_CODES.AMORTIZATION_EXP_ITEM_ID)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.AMORTIZATION_EXP_ITEM_ID#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
                            <cfif len(GET_CODES.AMORTIZATION_CODE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.AMORTIZATION_CODE#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.EP.USERID#">,
                            <cfqueryparam cfsqltype="cf_sql_timestamp" value="#NOW()#">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTEADDR#">
                        )
                    </cfquery>		
                </cfif>
            </cfif>
            <!---Ek Bilgiler--->
            <cfset arguments.info_id =  arguments.product_id>
            <cfset arguments.is_upd = 1>
            <cfset arguments.info_type_id=-5>
            <cfinclude template="../../objects/query/add_info_plus2.cfm">
            <cfset arguments.actionId = arguments.product_id>
            <!---Ek Bilgiler--->   
            <!--- Watalogye ürün gönderiyoruz. --->
            <cfif isdefined('arguments.is_watalogy_integrated') and arguments.is_watalogy_integrated eq 1>
                <cfset company_cmp = createObject("component","V16.member.cfc.member_company")>
                <cfset get_our_cmp = company_cmp.GET_OURCMP_INFO(company_id : session.ep.company_id)>
                <cfif get_our_cmp.IS_WATALOGY_INTEGRATED eq 1 and len(get_our_cmp.WATALOGY_MEMBER_CODE)>
                    <cfset arguments.watalogy_member_code = get_our_cmp.WATALOGY_MEMBER_CODE>
                    <cfhttp url="http://watalogy.workcube.com/wex.cfm/getWatalogyProduct/getProduct" result="response" charset="utf-8" method="POST">
                        <cfhttpparam name="data" type="formfield" value="#Replace(serializeJSON(arguments),"//","")#">
                    </cfhttp>
                </cfif>            
            </cfif>    
            <cfset responseStruct.message = "İşlem Başarılı">
            <cfset responseStruct.status = true>
            <cfset responseStruct.identity = arguments.product_id>
            <cfcatch>
                <cfset responseStruct.message = "İşlem Hatalı">
                <cfset responseStruct.status = false>
                <cfset responseStruct.error = cfcatch>
            </cfcatch>
        </cftry>       
        <cfreturn responseStruct>
    </cffunction>
    <cffunction name="get_watalogy_product" returntype="query">
        <cfargument name="product_id" default="">
        <cfargument name="watalogy_member_code" default="">
        <cfquery name="GET_PRODUCT" datasource="#this.DSN1#">
            SELECT PRODUCT_ID FROM PRODUCT WHERE PRODUCT_MEMBER_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.product_id#-#arguments.watalogy_member_code#">
        </cfquery>
        <cfreturn GET_PRODUCT/>
    </cffunction>
    <cffunction name="get_recycle_group" returntype="query">
        <cfargument name="recycle_sub_group_id" default="">
        <cfquery name="get_recycle_group" datasource="#DSN#">
            SELECT RSG.RECYCLE_GROUP_ID AS MAIN_GROUP_ID,RSG.RECYCLE_SUB_GROUP,RSG.RECYCLE_SUB_GROUP_CODE,RSG.RECYCLE_SUB_GROUP_ID FROM RECYCLE_SUB_GROUP RSG LEFT JOIN RECYCLE_GROUP RG ON RG.RECYCLE_GROUP_ID = RSG.RECYCLE_GROUP_ID WHERE RECYCLE_SUB_GROUP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.recycle_sub_group_id#">
        </cfquery>
        <cfreturn get_recycle_group/>
    </cffunction>
</cfcomponent>