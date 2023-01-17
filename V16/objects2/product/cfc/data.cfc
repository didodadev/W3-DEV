<cfcomponent>
    <cfif isdefined("session.pp")>
        <cfset session_base = evaluate('session.pp')>
        <cfset company_id = session.pp.our_company_id>
        <cfset period_year = session.pp.period_year>
        <cfset language = session.pp.language>
    <cfelseif isdefined("session.ep")>
        <cfset session_base = evaluate('session.ep')>
        <cfset company_id = session.ep.our_company_id>
        <cfset period_year = session.ep.period_year>
        <cfset language = session.ep.language>
    <cfelseif isdefined("session.cp")>
        <cfset session_base = evaluate('session.cp')>
    <cfelseif isdefined("session.ww")>
        <cfset session_base = evaluate('session.ww')>
        <cfset company_id = session.ww.our_company_id>
        <cfset period_year = session.ww.period_year>
        <cfset language = session.ww.language>
    <cfelseif isdefined("session.qq")>
        <cfset session_base = evaluate('session.qq')>
        <cfset company_id = session.qq.our_company_id>
        <cfset period_year = session.qq.period_year>
        <cfset language = session.qq.language>
    <cfelse>
        <cfset session_base = structNew()>
    </cfif>   
    <cfset dsn = application.systemParam.systemParam().dsn>
    <cfset dsn1 = '#dsn#_product'>
    <cfif StructCount(session_base)>
        <cfset dsn2 = '#dsn#_#session_base.period_year#_#session_base.our_company_id#'>
        <cfset dsn3 = '#dsn#_#session_base.our_company_id#'>
        <cfset int_comp_id = session_base.our_company_id>
        <cfset int_period_id = session_base.period_id>
    </cfif>
    <cffunction name="GET_HOMEPAGE_PRODUCTS" returntype="any" access="remote">
        <cfargument name="new_products" required="false" default="">
        <cfargument name="high_sales" required="false" default="">
        <cfargument name="is_basket_standart" required="false" default="">
        <cfargument name="is_prod_company" required="false" default="">
        <cfargument name="is_from_price_cat" required="false" default="">
        <cfargument name="last_user_price_list" required="false" default="">
        <cfargument name="price_first_value" required="false" default="">
        <cfargument name="price_last_value" required="false" default="">
        <cfargument name="price_catid" required="false" default="">
        <cfargument name="all_product_id" required="false" default="">
        <cfargument name="is_prices_brand" required="false" default="">
        <cfargument name="is_prices_category" required="false" default="">
        <cfargument name="is_saleable_stock" required="false" default="">
        <cfargument name="price_productid_list" required="false" default="">
        <cfargument name="favourities_list" required="false" default="">
        <cfargument name="promotion_stock_list" required="false" default="">
        <cfargument name="segment_id" required="false" default="">
        <cfargument name="keyword" required="false" default="">
        <cfargument name="is_detail_keyword_search" required="false" default="">
        <cfargument name="hierarchy_keyword" required="false" default="">
        <cfargument name="brand_id" required="false" default="">
        <cfargument name="short_code_id" required="false" default="">
        <cfargument name="list_property_id" required="false" default="">
        <cfargument name="list_variation_id" required="false" default="">
        <cfargument name="is_detail_search_prototype" required="false" default="">
        <cfargument name="is_only_sale_product" required="false" default="">
        <cfargument name="product_order_by" required="false" default="">
        <cfargument name="product_order_element" required="false" default="">
        <cfargument name="product_order_type" required="false" default="">
        <cfargument name="hierarchy" required="false" default="">
        <cfargument name="product_catid" required="false" default="">
        <cfargument name="detail_search_keyword" required="false" default="">
        <cfargument name="stock_id" required="false" default="">
        <cfargument name="is_purchase" required="false" default="">
        <cfargument name="language" required="false" default="">
        <cfset dsn2 = '#dsn#_#session_base.period_year#_#session_base.our_company_id#'>
        <cfset dsn3 = '#dsn#_#session_base.our_company_id#'>

        <cfset GET_PRODUCT_HIERARCHY = this.GET_PRODUCT_HIERARCHY(
                                                                    hierarchy : '#IIf(len(arguments.hierarchy),"arguments.hierarchy",DE(''))#',
                                                                    product_catid : '#IIf(len(arguments.product_catid),"arguments.product_catid",DE(''))#'
                                                                )>
        <cfif isQuery(get_product_hierarchy) and get_product_hierarchy.recordcount neq 0>
            <cfset get_product_hierarchy.product_catid = valuelist(get_product_hierarchy.product_catid)>
        </cfif>
        <cfif isdefined("arguments.is_saleable_stock") and len(arguments.is_saleable_stock)>
            <cfquery name="GET_STOCK_LASTS" datasource="#DSN2#">
                SELECT 
                    ROW_NUMBER () OVER (ORDER BY STOCK_ID) AS ROW_NUMBER,
                    STOCK_ID
                FROM 
                    GET_STOCK_LAST 
                WHERE 
                    SALEABLE_STOCK > 0 
                ORDER BY 
                    STOCK_ID
            </cfquery>
            <cfset carpan_ = 2500>
            <cfset stock_mod_ = ceiling(get_stock_lasts.recordcount/carpan_)>
            <cfloop from="1" to="#stock_mod_#" index="ccc">
                <cfquery name="GET_" dbtype="query">
                    SELECT STOCK_ID FROM GET_STOCK_LASTS WHERE ROW_NUMBER >= <cfqueryparam cfsqltype="cf_sql_integer" value="#1+((ccc - 1)*carpan_)#"> AND ROW_NUMBER <= <cfqueryparam cfsqltype="cf_sql_integer" value="#ccc*carpan_#">
                </cfquery>
                <cfset 'last_stock_list_#ccc#' = valuelist(get_.stock_id)>
            </cfloop>
        </cfif>

        <cfquery name="GET_HOMEPAGE_PRODUCTS" datasource="#DSN3#">
            SELECT 
                <cfif len(arguments.new_products) or len(arguments.high_sales)>TOP 10</cfif>
                <cfif len(arguments.high_sales)>SUM(SS.SATIS) AS SATIS,</cfif><!--- cok satan veya yeni cikan urunler icin gerekli --->
                <cfif len(arguments.is_basket_standart) and arguments.is_basket_standart eq 0>PR.PRICE_CATID,</cfif>
                STOCKS.STOCK_ID,
                STOCKS.STOCK_CODE,
                STOCKS.PROPERTY, 
                STOCKS.BARCOD, 
                STOCKS.PRODUCT_UNIT_ID,
                STOCKS.IS_KARMA,
                STOCKS.IS_PROTOTYPE,
                PRODUCT.PRODUCT_ID, 
                <cfif isDefined('session_base.language') and len(session_base.language)>
                #dsn#.Get_Dynamic_Language(PRODUCT_UNIT.UNIT_ID,'#session_base.language#','SETUP_UNIT','UNIT',NULL,NULL,PRODUCT_UNIT.ADD_UNIT) AS ADD_UNIT,
                COALESCE(SLIPD2.ITEM,PRODUCT.PRODUCT_DETAIL2) AS PRODUCT_DETAIL2, 
                COALESCE(SLIPDE.ITEM,PRODUCT.PRODUCT_DETAIL) AS PRODUCT_DETAIL, 
                COALESCE(SLIPNE.ITEM,PRODUCT.PRODUCT_NAME) AS PRODUCT_NAME, 
                <cfelse>
                PRODUCT.PRODUCT_NAME, 
                PRODUCT.PRODUCT_DETAIL,
                PRODUCT.PRODUCT_DETAIL2,
                PRODUCT_UNIT.ADD_UNIT,
                </cfif>
                PRODUCT.TAX, 
                PRODUCT.IS_ZERO_STOCK, 
                PRODUCT.BRAND_ID, 
                PRODUCT.PRODUCT_CODE,
                PRODUCT.PRODUCT_CODE_2,  
                PRODUCT.PRODUCT_CATID, 
                PRODUCT.RECORD_DATE, 
                PRODUCT.IS_PRODUCTION, 
                PRODUCT.SEGMENT_ID,  
                PRODUCT.COMPANY_ID,
                PRODUCT.PRODUCT_CODE_2,
                PRODUCT.COMPANY_ID,
                <cfif not isdefined('arguments.site')>PRODUCT.USER_FRIENDLY_URL,</cfif>
                PRICE_STANDART.PRICE PRICE, 
                PRICE_STANDART.MONEY MONEY, 
                PRICE_STANDART.IS_KDV IS_KDV, 
                PRODUCT_CAT.WATALOGY_CAT_ID,
                PRODUCT.PRODUCT_DETAIL_WATALOGY,
                PRICE_STANDART.PRICE_KDV PRICE_KDV 
                <cfif len(arguments.is_prod_company) and arguments.is_prod_company eq 1>
                    ,COMPANY.NICKNAME,
                </cfif>
                <cfif isDefined('arguments.site') and len(arguments.site)>,UFU.USER_FRIENDLY_URL</cfif>
            FROM
                <cfif len(arguments.is_from_price_cat) and arguments.is_from_price_cat>PRICE PR,</cfif><!--- sadece fiyat kategorisinde olanlar --->
                <cfif len(arguments.high_sales)>#dsn2#.STOCKS_SALES SS,</cfif><!--- cok satan urunler icin gerekli --->
                PRODUCT
                LEFT JOIN #dsn#.SETUP_LANGUAGE_INFO SLIPNE 
                        ON SLIPNE.UNIQUE_COLUMN_ID = PRODUCT.PRODUCT_ID 
                        AND SLIPNE.COLUMN_NAME ='PRODUCT_NAME'
                        AND SLIPNE.TABLE_NAME = 'PRODUCT'
                        AND SLIPNE.LANGUAGE = '#session_base.language#'
                LEFT JOIN #dsn#.SETUP_LANGUAGE_INFO SLIPDE
                        ON SLIPDE.UNIQUE_COLUMN_ID = PRODUCT.PRODUCT_ID 
                        AND SLIPDE.COLUMN_NAME ='PRODUCT_DETAIL'
                        AND SLIPDE.TABLE_NAME = 'PRODUCT'
                        AND SLIPDE.LANGUAGE = '#session_base.language#'  
                LEFT JOIN #dsn#.SETUP_LANGUAGE_INFO SLIPD2
                        ON SLIPD2.UNIQUE_COLUMN_ID = PRODUCT.PRODUCT_ID 
                        AND SLIPD2.COLUMN_NAME ='PRODUCT_DETAIL2'
                        AND SLIPD2.TABLE_NAME = 'PRODUCT'
                        AND SLIPD2.LANGUAGE = '#session_base.language#'
                <cfif isdefined('arguments.site')>
                OUTER APPLY(
                    SELECT TOP 1 UFU.USER_FRIENDLY_URL 
                    FROM #dsn#.USER_FRIENDLY_URLS UFU 
                    WHERE UFU.ACTION_TYPE = 'PRODUCT_ID' 
                    AND UFU.ACTION_ID = PRODUCT.PRODUCT_ID 		
                    AND UFU.PROTEIN_SITE = #arguments.site#) UFU</cfif>,
                PRODUCT_CAT,
                #dsn1#.PRODUCT_CAT_OUR_COMPANY AS PRODUCT_CAT_OUR_COMPANY,
                STOCKS,
                <cfif len(arguments.last_user_price_list) and isnumeric(arguments.last_user_price_list)>
                    PRICE AS PRICE_STANDART,
                <cfelse>
                    PRICE_STANDART,
                </cfif>
                <cfif len(arguments.is_prod_company) and arguments.is_prod_company eq 1>
                    #dsn#.COMPANY,
                </cfif>
                PRODUCT_UNIT
                <cfif ( len(arguments.price_first_value) ) or ( len(arguments.price_last_value) )>
                    ,#dsn2#.SETUP_MONEY SETUP_MONEY
                </cfif>
            WHERE
                <cfif len(arguments.is_from_price_cat) and arguments.is_from_price_cat>
                    PR.PRODUCT_ID = PRODUCT.PRODUCT_ID AND
                    <cfif len(arguments.price_catid)>
                        PR.PRICE_CATID = <cfqueryparam value="#arguments.price_catid#" cfsqltype="cf_sql_integer"> AND
                    </cfif>
                    PR.STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> AND 
                    (PR.FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> OR PR.FINISHDATE IS NULL) AND
                </cfif>
                <cfif len(arguments.all_product_id)><!--- ürünle iliskili ürünlerin tümünü getirmek icin --->
                    PRODUCT.PRODUCT_ID IN (#arguments.all_product_id#) AND 
                </cfif>
                <cfif len(arguments.is_prices_brand)><!--- sadece bu markalara veya markaya ait ürünler --->
                    PRODUCT.BRAND_ID IN (<cfqueryparam value="#arguments.is_prices_brand#" cfsqltype="cf_sql_integer" list="yes">) AND 
                </cfif>
                <cfif len(arguments.is_prices_category)><!--- sadece bu kategorilere veya kategoriye ait ürünler --->
                    PRODUCT.PRODUCT_CATID IN (#arguments.is_prices_category#) AND 
                </cfif>
                <cfif len(arguments.high_sales)>
                    SS.PRODUCT_ID = STOCKS.PRODUCT_ID AND
                    SS.STOCK_ID = STOCKS.STOCK_ID AND
                </cfif><!--- cok satan urunler icin gerekli --->
                <cfif len(arguments.is_saleable_stock) and arguments.stock_mod_ gte 1>
                    (
                    <cfloop from="1" to="#arguments.stock_mod_#" index="ccc">
                        STOCKS.STOCK_ID IN (#evaluate("last_stock_list_#ccc#")#)
                        <cfif ccc neq arguments.stock_mod_>OR</cfif>
                    </cfloop>
                    )
                    AND
                </cfif>
                <cfif isdefined('session.pp.company_id') and len(arguments.is_purchase) and arguments.is_purchase eq 1><!--- tedarikcisi oldugum ürünler --->
                    PRODUCT.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#"> AND
                </cfif>
                <cfif len(arguments.is_prod_company) and arguments.is_prod_company eq 1>
                    PRODUCT.COMPANY_ID = COMPANY.COMPANY_ID AND
                </cfif>
                STOCKS.STOCK_STATUS = 1 AND
                <cfif len(arguments.stock_id)>STOCKS.STOCK_ID = <cfqueryparam value="#arguments.stock_id#" cfsqltype="cf_sql_integer"> AND</cfif>
                PRODUCT_CAT.PRODUCT_CATID = PRODUCT_CAT_OUR_COMPANY.PRODUCT_CATID AND
                PRODUCT_CAT_OUR_COMPANY.OUR_COMPANY_ID = <cfqueryparam value="#session_base.our_company_id#" cfsqltype="cf_sql_integer"> AND
                PRODUCT.PRODUCT_ID = STOCKS.PRODUCT_ID AND
                PRODUCT_UNIT.PRODUCT_ID = STOCKS.PRODUCT_ID AND
                STOCKS.PRODUCT_UNIT_ID = PRODUCT_UNIT.PRODUCT_UNIT_ID AND
                PRODUCT_CAT.PRODUCT_CATID = PRODUCT.PRODUCT_CATID AND
                PRODUCT_UNIT.IS_MAIN = 1 AND
                <cfif isdefined('arguments.product_types') and listfind(arguments.product_types,1)>
                    PRODUCT.IS_PURCHASE = <cfqueryparam value="1" cfsqltype="cf_sql_bit"> AND
                </cfif>
                <cfif isdefined('arguments.product_types') and listfind(arguments.product_types,2)>
                    PRODUCT.IS_INVENTORY = <cfqueryparam value="0" cfsqltype="cf_sql_bit"> AND
                </cfif>
                <cfif isdefined('arguments.product_types') and listfind(arguments.product_types,3)>
                    PRODUCT.IS_INVENTORY = <cfqueryparam value="1" cfsqltype="cf_sql_bit"> AND PRODUCT.IS_PRODUCTION = <cfqueryparam value="0" cfsqltype="cf_sql_bit"> AND
                </cfif>
                <cfif isdefined('arguments.product_types') and listfind(arguments.product_types,4)>
                    PRODUCT.IS_TERAZI = <cfqueryparam value="1" cfsqltype="cf_sql_bit"> AND
                </cfif>
                <cfif isdefined('arguments.product_types') and listfind(arguments.product_types,5)>
                    PRODUCT.IS_PURCHASE = <cfqueryparam value="0" cfsqltype="cf_sql_bit"> AND
                </cfif>
                <cfif isdefined('arguments.product_types') and listfind(arguments.product_types,6)>
                    PRODUCT.IS_PRODUCTION = <cfqueryparam value="1" cfsqltype="cf_sql_bit"> AND
                </cfif>
                <cfif isdefined('arguments.product_types') and listfind(arguments.product_types,7)>
                    PRODUCT.IS_SERIAL_NO = <cfqueryparam value="1" cfsqltype="cf_sql_bit"> AND
                </cfif>
                <cfif isdefined('arguments.product_types') and listfind(arguments.product_types,8)>
                    PRODUCT.IS_KARMA = <cfqueryparam value="1" cfsqltype="cf_sql_bit"> AND
                </cfif>
                <cfif isdefined('arguments.product_types') and listfind(arguments.product_types,9)>
                    PRODUCT.IS_INTERNET = <cfqueryparam value="1" cfsqltype="cf_sql_bit"> AND
                </cfif>
                <cfif isdefined('arguments.product_types') and listfind(arguments.product_types,10)>
                    PRODUCT.IS_PROTOTYPE = <cfqueryparam value="1" cfsqltype="cf_sql_bit"> AND
                </cfif>
                <cfif isdefined('arguments.product_types') and listfind(arguments.product_types,11)>
                    PRODUCT.IS_ZERO_STOCK = <cfqueryparam value="1" cfsqltype="cf_sql_bit"> AND
                </cfif>
                <cfif isdefined('arguments.product_types') and listfind(arguments.product_types,12)>
                    PRODUCT.IS_EXTRANET = <cfqueryparam value="1" cfsqltype="cf_sql_bit"> AND
                </cfif>
                <cfif isdefined('arguments.product_types') and listfind(arguments.product_types,13)>
                    PRODUCT.IS_COST = <cfqueryparam value="1" cfsqltype="cf_sql_bit"> AND
                </cfif>
                <cfif isdefined('arguments.product_types') and listfind(arguments.product_types,14)>
                    PRODUCT.IS_SALES = <cfqueryparam value="1" cfsqltype="cf_sql_bit"> AND
                </cfif>
                <cfif isdefined('arguments.product_types') and listfind(arguments.product_types,15)>
                    PRODUCT.IS_QUALITY = <cfqueryparam value="1" cfsqltype="cf_sql_bit"> AND
                </cfif>
                <cfif isdefined('arguments.product_types') and listfind(arguments.product_types,16)>
                    PRODUCT.IS_INVENTORY = <cfqueryparam value="1" cfsqltype="cf_sql_bit"> AND
                </cfif>
                <cfif isdefined('arguments.product_types') and listfind(arguments.product_types,17)>
                    PRODUCT.IS_LOT_NO = <cfqueryparam value="1" cfsqltype="cf_sql_bit"> AND
                </cfif>
                <cfif isdefined('arguments.product_types') and listfind(arguments.product_types,18)>
                    PRODUCT.IS_LIMITED_STOCK = <cfqueryparam value="1" cfsqltype="cf_sql_bit"> AND
                </cfif>
                <cfif isdefined('arguments.product_types') and listfind(arguments.product_types,19)>
                    PRODUCT.IS_WATALOGY_INTEGRATED = <cfqueryparam value="1" cfsqltype="cf_sql_bit"> AND
                </cfif>
                <cfif len(arguments.price_productid_list)>PRODUCT.PRODUCT_ID IN (#arguments.price_productid_list#) AND</cfif>
                <cfif len(arguments.favourities_list)>STOCKS.STOCK_ID IN (#arguments.favourities_list#) AND</cfif>
                <cfif len(arguments.promotion_stock_list)>STOCKS.STOCK_ID IN (#arguments.promotion_stock_list#) AND</cfif>
                <!---  <cfif isDefined("session.pp")>PRODUCT.IS_EXTRANET = <cfqueryparam value="1" cfsqltype="cf_sql_smallint"> AND <cfelse> PRODUCT.IS_INTERNET = <cfqueryparam value="1" cfsqltype="cf_sql_smallint"> AND</cfif> --->
                <!--- XML'E bağlandı. --->
                <cfif isdefined("arguments.listing_by_sale") and len(arguments.listing_by_sale)>
                    <cfif arguments.listing_by_sale eq 0>
                        PRODUCT.IS_INTERNET = <cfqueryparam cfsqltype="cf_sql_smallint" value="1"> AND
                        PRODUCT.IS_EXTRANET = <cfqueryparam cfsqltype="cf_sql_smallint" value="1"> AND
                    <cfelseif arguments.listing_by_sale eq 1>
                        PRODUCT.IS_INTERNET = <cfqueryparam cfsqltype="cf_sql_smallint" value="1"> AND               
                    <cfelseif arguments.listing_by_sale eq 2>
                        PRODUCT.IS_EXTRANET = <cfqueryparam cfsqltype="cf_sql_smallint" value="1"> AND                    
                    </cfif>
                </cfif> 
                <cfif len(arguments.last_user_price_list) and isnumeric(arguments.last_user_price_list)>
                    PRICE_STANDART.PRICE_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.last_user_price_list#"> AND
                    PRICE_STANDART.PRICE ><cfqueryparam value="0" cfsqltype="cf_sql_float"> AND
                    PRICE_STANDART.PRODUCT_ID = STOCKS.PRODUCT_ID AND
                    (ISNULL(PRICE_STANDART.STOCK_ID,0) = 0 OR PRICE_STANDART.STOCK_ID = STOCKS.STOCK_ID) AND
                    ISNULL(PRICE_STANDART.SPECT_VAR_ID,0)=0 AND
                    PRODUCT_UNIT.PRODUCT_UNIT_ID = PRICE_STANDART.UNIT AND
                    (PRICE_STANDART.FINISHDATE IS NULL OR PRICE_STANDART.FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">) AND
                <cfelse>
                    PRICE_STANDART.PRICE ><cfqueryparam value="0" cfsqltype="cf_sql_float"> AND
                    PRICE_STANDART.PRICESTANDART_STATUS = 1	AND
                    PRICE_STANDART.PURCHASESALES = 1 AND
                    PRODUCT_UNIT.PRODUCT_UNIT_ID = PRICE_STANDART.UNIT_ID AND
                </cfif>	
                PRODUCT.PRODUCT_STATUS = 1		
                <cfif len(arguments.segment_id)><!--- Detaylı Ürün aramada lazım --->
                    AND 
                    (
                        PRODUCT.SEGMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.segment_id#"> OR
                        PRODUCT.SEGMENT_ID IS NULL
                    )
                </cfif>
                <cfif len(arguments.keyword)>
                    <cfif arguments.is_detail_keyword_search eq 1>
                        AND 
                        (
                            (
                                PRODUCT.PRODUCT_NAME LIKE <cfqueryparam value="%#arguments.keyword#%" cfsqltype="cf_sql_varchar"> OR
                                PRODUCT.PRODUCT_DETAIL LIKE <cfqueryparam value="%#arguments.keyword#%" cfsqltype="cf_sql_varchar"> OR
                                PRODUCT.PRODUCT_DETAIL2 LIKE <cfqueryparam value="%#arguments.keyword#%" cfsqltype="cf_sql_varchar"> OR
                                PRODUCT.PRODUCT_CODE_2 LIKE <cfqueryparam value="%#arguments.keyword#%" cfsqltype="cf_sql_varchar"> OR
                                PRODUCT.PRODUCT_CODE LIKE <cfqueryparam value="%#arguments.keyword#%" cfsqltype="cf_sql_varchar"> OR
                                PRODUCT.USER_FRIENDLY_URL LIKE <cfqueryparam value="%#arguments.keyword#%" cfsqltype="cf_sql_varchar">
                            )
                            <cfif listlen(arguments.keyword,' ') gt 1>
                                OR
                                (
                                    <cfloop from="1" to="#listlen(arguments.keyword,' ')#" index="ccc">
                                    (
                                    PRODUCT.PRODUCT_NAME LIKE <cfqueryparam value="%#listgetat(arguments.keyword,ccc,' ')#%" cfsqltype="cf_sql_varchar"> OR
                                    PRODUCT.PRODUCT_DETAIL LIKE <cfqueryparam value="%#listgetat(arguments.keyword,ccc,' ')#%" cfsqltype="cf_sql_varchar"> OR
                                    PRODUCT.PRODUCT_DETAIL2 LIKE <cfqueryparam value="%#listgetat(arguments.keyword,ccc,' ')#%" cfsqltype="cf_sql_varchar"> OR
                                    PRODUCT.PRODUCT_CODE_2 LIKE <cfqueryparam value="%#listgetat(arguments.keyword,ccc,' ')#%" cfsqltype="cf_sql_varchar"> OR
                                    PRODUCT.PRODUCT_CODE LIKE <cfqueryparam value="%#listgetat(arguments.keyword,ccc,' ')#%" cfsqltype="cf_sql_varchar"> OR
                                    PRODUCT.USER_FRIENDLY_URL LIKE <cfqueryparam value="%#listgetat(arguments.keyword,ccc,' ')#%" cfsqltype="cf_sql_varchar">
                                )
                                <cfif ccc neq listlen(arguments.keyword,' ')>AND</cfif>
                            </cfloop>
                            )
                            </cfif>
                    )
                    <cfelse>
                        AND 
                        (
                            PRODUCT.PRODUCT_NAME LIKE <cfqueryparam value="%#arguments.keyword#%" cfsqltype="cf_sql_varchar"> OR
                            PRODUCT.PRODUCT_DETAIL LIKE <cfqueryparam value="%#arguments.keyword#%" cfsqltype="cf_sql_varchar"> OR
                            PRODUCT.PRODUCT_DETAIL2 LIKE <cfqueryparam value="%#arguments.keyword#%" cfsqltype="cf_sql_varchar"> OR
                            PRODUCT.PRODUCT_CODE_2 LIKE <cfqueryparam value="%#arguments.keyword#%" cfsqltype="cf_sql_varchar"> OR
                            PRODUCT.PRODUCT_CODE LIKE <cfqueryparam value="%#arguments.keyword#%" cfsqltype="cf_sql_varchar"> OR
                            PRODUCT.USER_FRIENDLY_URL LIKE <cfqueryparam value="%#arguments.keyword#%" cfsqltype="cf_sql_varchar">
                        )
                    </cfif>
                </cfif>
                <cfif len(arguments.hierarchy_keyword)>
                    AND (PRODUCT.PRODUCT_NAME LIKE <cfqueryparam value="%#arguments.hierarchy_keyword#%" cfsqltype="cf_sql_varchar"> OR
                    PRODUCT.PRODUCT_CODE LIKE <cfqueryparam value="%#arguments.hierarchy_keyword#%" cfsqltype="cf_sql_varchar"> OR
                    PRODUCT.PRODUCT_DETAIL LIKE <cfqueryparam value="%#arguments.hierarchy_keyword#%" cfsqltype="cf_sql_varchar"> OR
                    PRODUCT.PRODUCT_DETAIL2 LIKE <cfqueryparam value="%#arguments.hierarchy_keyword#%" cfsqltype="cf_sql_varchar"> OR
                    <cfif arguments.is_product_code eq 1>
                        PRODUCT.PRODUCT_CODE_2 LIKE <cfqueryparam value="%#arguments.hierarchy_keyword#%" cfsqltype="cf_sql_varchar"> OR
                    </cfif>
                    PRODUCT.USER_FRIENDLY_URL LIKE <cfqueryparam value="%#arguments.hierarchy_keyword#%" cfsqltype="cf_sql_varchar">
                    )
                </cfif>
                <cfif len(arguments.detail_search_keyword)>
                    <cfif arguments.is_detail_keyword_search eq 1>
                        AND 
                        (
                            (
                                PRODUCT.PRODUCT_NAME LIKE <cfqueryparam value="%#arguments.detail_search_keyword#%" cfsqltype="cf_sql_varchar"> OR
                                PRODUCT.PRODUCT_DETAIL LIKE <cfqueryparam value="%#arguments.detail_search_keyword#%" cfsqltype="cf_sql_varchar"> OR
                                PRODUCT.PRODUCT_DETAIL2 LIKE <cfqueryparam value="%#arguments.detail_search_keyword#%" cfsqltype="cf_sql_varchar"> OR
                                PRODUCT.PRODUCT_CODE_2 LIKE <cfqueryparam value="%#arguments.detail_search_keyword#%" cfsqltype="cf_sql_varchar"> OR
                                PRODUCT.PRODUCT_CODE LIKE <cfqueryparam value="%#arguments.detail_search_keyword#%" cfsqltype="cf_sql_varchar"> OR
                                PRODUCT.USER_FRIENDLY_URL LIKE <cfqueryparam value="%#arguments.detail_search_keyword#%" cfsqltype="cf_sql_varchar">
                            )
                            <cfif listlen(arguments.detail_search_keyword,' ') gt 1>
                                OR
                                (
                                    <cfloop from="1" to="#listlen(arguments.detail_search_keyword,' ')#" index="ccc">
                                    (
                                        PRODUCT.PRODUCT_NAME LIKE <cfqueryparam value="%#listgetat(arguments.detail_search_keyword,ccc,' ')#%" cfsqltype="cf_sql_varchar"> OR
                                        PRODUCT.PRODUCT_DETAIL LIKE <cfqueryparam value="%#listgetat(arguments.detail_search_keyword,ccc,' ')#%" cfsqltype="cf_sql_varchar"> OR
                                        PRODUCT.PRODUCT_DETAIL2 LIKE <cfqueryparam value="%#listgetat(arguments.detail_search_keyword,ccc,' ')#%" cfsqltype="cf_sql_varchar"> OR
                                        PRODUCT.PRODUCT_CODE_2 LIKE <cfqueryparam value="%#listgetat(arguments.detail_search_keyword,ccc,' ')#%" cfsqltype="cf_sql_varchar"> OR
                                        PRODUCT.PRODUCT_CODE LIKE <cfqueryparam value="%#listgetat(arguments.detail_search_keyword,ccc,' ')#%" cfsqltype="cf_sql_varchar"> OR
                                        PRODUCT.USER_FRIENDLY_URL LIKE <cfqueryparam value="%#listgetat(arguments.detail_search_keyword,ccc,' ')#%" cfsqltype="cf_sql_varchar">
                                    )
                                    <cfif ccc neq listlen(arguments.detail_search_keyword,' ')>AND</cfif>
                                    </cfloop>
                                )
                            </cfif>
                        )
                    <cfelse>
                        AND 
                        (
                            PRODUCT.PRODUCT_NAME LIKE <cfqueryparam value="%#arguments.detail_search_keyword#%" cfsqltype="cf_sql_varchar"> OR
                            PRODUCT.PRODUCT_DETAIL LIKE <cfqueryparam value="%#arguments.detail_search_keyword#%" cfsqltype="cf_sql_varchar"> OR
                            PRODUCT.PRODUCT_DETAIL2 LIKE <cfqueryparam value="%#arguments.detail_search_keyword#%" cfsqltype="cf_sql_varchar"> OR
                            PRODUCT.PRODUCT_CODE_2 LIKE <cfqueryparam value="%#arguments.detail_search_keyword#%" cfsqltype="cf_sql_varchar"> OR
                            PRODUCT.PRODUCT_CODE LIKE <cfqueryparam value="%#arguments.detail_search_keyword#%" cfsqltype="cf_sql_varchar"> OR
                            PRODUCT.USER_FRIENDLY_URL LIKE <cfqueryparam value="%#arguments.detail_search_keyword#%" cfsqltype="cf_sql_varchar">
                        )
                    </cfif>
                </cfif>
                <cfif isQuery(get_product_hierarchy) and get_product_hierarchy.recordcount neq 0>
                    AND (
                        PRODUCT_CAT.PRODUCT_CATID IN (<cfqueryparam value="#get_product_hierarchy.product_catid#" cfsqltype="cf_sql_integer" list="yes">) OR 
                        PRODUCT_CAT.HIERARCHY LIKE <cfqueryparam value="#get_product_hierarchy.hierarchy#.%" cfsqltype="cf_sql_varchar">
                    )
                </cfif>
                <cfif len(arguments.brand_id)>
                    AND PRODUCT.BRAND_ID IN(<cfqueryparam value="#arguments.brand_id#" cfsqltype="cf_sql_integer" list="yes">)
                </cfif>
                <cfif len(arguments.short_code_id)>
                    AND PRODUCT.SHORT_CODE_ID = <cfqueryparam value="#arguments.short_code_id#" cfsqltype="cf_sql_integer">
                </cfif>
                <cfif len(arguments.list_property_id)>
                    AND PRODUCT.PRODUCT_ID IN
                    (
                        SELECT
                            PRODUCT_ID
                        FROM
                            #dsn1#.PRODUCT_DT_PROPERTIES PRODUCT_DT_PROPERTIES
                        WHERE
                        (
                            <cfloop from="1" to="#listlen(arguments.list_property_id,',')#" index="pro_ind">
                                (PROPERTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ListGetAt(arguments.list_property_id,pro_ind,",")#"> AND VARIATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ListGetAt(arguments.list_variation_id,pro_ind,",")#">)
                                <cfif pro_ind lt listlen(arguments.list_property_id,',')>OR</cfif>
                            </cfloop>
                        )
                        GROUP BY
                            PRODUCT_ID
                        HAVING
                            COUNT(PRODUCT_ID)> = <cfqueryparam cfsqltype="cf_sql_integer" value="#listlen(arguments.list_property_id,',')#">
                    )
                </cfif>
                <cfif arguments.is_detail_search_prototype eq 1>
                    AND PRODUCT.IS_PROTOTYPE = 1
                </cfif>
                <cfif len(arguments.is_only_sale_product) and arguments.is_only_sale_product eq 1>
                    AND PRODUCT.IS_SALES = 1
                </cfif>
                <cfif ( len(arguments.price_first_value) ) or ( len(arguments.price_last_value) )>
                    AND PRICE_STANDART.MONEY = SETUP_MONEY.MONEY
                </cfif>
                <cfif isdefined("session.pp")>
                    <cfif len(arguments.price_first_value) and len(arguments.price_last_value)>
                        AND PRICE_STANDART.PRICE/SETUP_MONEY.RATE1*SETUP_MONEY.RATEPP2 BETWEEN <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.price_first_value#"> AND <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.price_last_value#">
                    <cfelseif len(arguments.price_first_value)>
                        AND PRICE_STANDART.PRICE/SETUP_MONEY.RATE1*SETUP_MONEY.RATEPP2 >= <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.price_first_value#"> 
                    <cfelseif len(arguments.price_last_value)>
                        AND PRICE_STANDART.PRICE/SETUP_MONEY.RATE1*SETUP_MONEY.RATEPP2 <= <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.price_last_value#"> 
                    </cfif>
                <cfelseif isdefined("session.ww")>
                    <cfif len(arguments.price_first_value) and len(arguments.price_last_value)>
                        AND PRICE_STANDART.PRICE/SETUP_MONEY.RATE1*SETUP_MONEY.RATEWW2 BETWEEN <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.price_first_value#"> AND <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.price_last_value#">
                    <cfelseif len(arguments.price_first_value)>
                        AND PRICE_STANDART.PRICE/SETUP_MONEY.RATE1*SETUP_MONEY.RATEWW2 >= <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.price_first_value#"> 
                    <cfelseif len(arguments.price_last_value)>
                        AND PRICE_STANDART.PRICE/SETUP_MONEY.RATE1*SETUP_MONEY.RATEWW2 <= <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.price_last_value#"> 
                    </cfif>
                </cfif>
            <cfif len(arguments.high_sales)><!--- cok satan urunler icin gerekli --->
                GROUP BY
                    <cfif arguments.is_basket_standart eq 0>PR.PRICE_CATID,</cfif>
                    STOCKS.STOCK_ID,
                    STOCKS.STOCK_CODE,
                    STOCKS.PROPERTY,
                    STOCKS.BARCOD,
                    STOCKS.PRODUCT_UNIT_ID,
                    PRODUCT.PRODUCT_ID,
                    PRODUCT.PRODUCT_NAME,
                    PRODUCT.TAX,
                    PRODUCT.IS_ZERO_STOCK,
                    PRODUCT.BRAND_ID,		
                    PRODUCT.PRODUCT_CODE,
                    PRODUCT.PRODUCT_CODE_2,
                    PRODUCT.PRODUCT_DETAIL,
                    PRODUCT.PRODUCT_CATID,
                    PRODUCT.RECORD_DATE,
                    PRODUCT.IS_PRODUCTION,
                    PRODUCT.IS_PROTOTYPE,
                    PRODUCT.SEGMENT_ID,
                    PRODUCT.PRODUCT_DETAIL2,
                    PRODUCT.COMPANY_ID,
                    PRODUCT.USER_FRIENDLY_URL,
                    PRICE_STANDART.PRICE, 
                    PRICE_STANDART.MONEY,
                    PRICE_STANDART.IS_KDV,
                    PRICE_STANDART.PRICE_KDV
            </cfif><!--- cok satan urunler icin gerekli --->
            ORDER BY
                <cfif len(arguments.new_products)>
                    PRODUCT.PRODUCT_ID DESC
                <cfelseif len(arguments.high_sales)>
                    SATIS DESC
                <cfelseif len(arguments.product_order_by) and arguments.product_order_by eq 2>
                    PRODUCT.RECORD_DATE DESC
                <cfelseif len(arguments.product_order_by) and arguments.product_order_by eq 3>
                    PRICE_STANDART.PRICE ASC
                <cfelseif len(arguments.product_order_by) and arguments.product_order_by eq 4>
                    PRICE_STANDART.PRICE DESC
                <cfelseif not len(arguments.product_order_element)>
                    PRODUCT.PRODUCT_NAME
                <cfelseif arguments.product_order_element is 'PRODUCT_NAME'>
                    PRODUCT.PRODUCT_NAME #arguments.product_order_type#
                <cfelseif arguments.product_order_element is 'PRICE'>
                    PRICE_STANDART.PRICE #arguments.product_order_type#
                <cfelseif arguments.product_order_element is 'COMPANY_NAME'>
                    COMPANY.FULLNAME #arguments.product_order_type#
                <cfelse>
                    PRODUCT.PRODUCT_NAME
                </cfif>
        </cfquery>
        <cfreturn GET_HOMEPAGE_PRODUCTS >
    </cffunction>

    <cffunction name="GET_PRODUCT_HIERARCHY" returntype="any" access="remote">
        <cfargument name="hierarchy" required="false">
        <cfargument name="product_catid" required="false">
        <cfargument name="is_filter" required="false" default="0">
        
        <cfif (isdefined("arguments.hierarchy") and len(arguments.hierarchy) and arguments.hierarchy neq 0) or (isdefined("arguments.product_catid") and len(arguments.product_catid) and arguments.product_catid neq 0) or arguments.is_filter eq 1>
            <cfquery name="GET_PRODUCT_HIERARCHY" datasource="#DSN3#">
                SELECT 
                    PRODUCT_CATID,
                    PRODUCT_CAT,
                    HIERARCHY,
                    IS_CUSTOMIZABLE 
                FROM 
                    PRODUCT_CAT 
                WHERE 
                    PRODUCT_CATID IS NOT NULL
                    <cfif isdefined("arguments.is_public") and len(arguments.is_public)>
                        AND IS_PUBLIC = <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.is_public#">
                    </cfif>
                    <cfif isdefined("arguments.hierarchy") and len(arguments.hierarchy) and arguments.hierarchy neq 0>
                        AND HIERARCHY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.hierarchy#"> 
                    </cfif>
                    <cfif isdefined("arguments.product_catid") and len(arguments.product_catid) and arguments.product_catid neq 0>	
                        AND PRODUCT_CATID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.product_catid#" list="yes">)
                    </cfif>
                ORDER BY 
		            HIERARCHY
            </cfquery>
            <cfif GET_PRODUCT_HIERARCHY.recordcount eq 0>
                <cfset GET_PRODUCT_HIERARCHY = 0 >
            </cfif>
        <cfelse>
            <cfset GET_PRODUCT_HIERARCHY = 0 >
        </cfif>
        
        <cfreturn GET_PRODUCT_HIERARCHY>
    </cffunction>

    <cffunction name="GET_PROM_ALL" returntype="any" access="remote">
        <cfargument name="stock_list" required="true">
        <cfquery name="GET_PROM_ALL" datasource="#DSN3#">
            SELECT
                PROMOTIONS.DISCOUNT,
                PROMOTIONS.AMOUNT_DISCOUNT,
                PROMOTIONS.AMOUNT_DISCOUNT_MONEY_1,
                PROMOTIONS.TOTAL_PROMOTION_COST,
                PROMOTIONS.PROM_HEAD,
                PROMOTIONS.FREE_STOCK_ID,
                PROMOTIONS.PROM_ID,
                PROMOTIONS.LIMIT_VALUE,
                PROMOTIONS.FREE_STOCK_AMOUNT,
                PROMOTIONS.COMPANY_ID,
                PROMOTIONS.CATALOG_ID,
                PROMOTIONS.PROM_POINT,
                PROMOTIONS.FREE_STOCK_PRICE,
                PROMOTIONS.AMOUNT_1_MONEY,
                PROMOTIONS.PRICE_CATID,
                PROMOTIONS.ICON_ID,			
                STOCKS.STOCK_ID
            FROM
                STOCKS,
                PROMOTIONS
            WHERE
                PROMOTIONS.PROM_STATUS = 1 AND 	
                PROMOTIONS.PROM_TYPE = 1 AND 	
                PROMOTIONS.LIMIT_TYPE = 1 AND
                STOCKS.STOCK_ID IN (#arguments.stock_list#) AND
                (
                    STOCKS.STOCK_ID = PROMOTIONS.STOCK_ID OR
                    STOCKS.BRAND_ID = PROMOTIONS.BRAND_ID OR
                    STOCKS.PRODUCT_CATID = PROMOTIONS.PRODUCT_CATID
                )	
                AND
                PROMOTIONS.STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> AND
                PROMOTIONS.FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
        </cfquery>
        <cfreturn GET_PROM_ALL>
    </cffunction>

    <cffunction name="MONEYS" access="public" returntype="any">
        <cfargument name="company_id" required="true">
        <cfargument name="period_id" required="true">
        <cfquery name="MONEYS" datasource="#DSN#">
            SELECT
                COMPANY_ID,
                PERIOD_ID,
                MONEY,
                RATE1,
                <cfif isDefined("session.pp")>
                    RATEPP2 RATE2
                <cfelse>
                    RATEWW2 RATE2
                </cfif>
            FROM
                SETUP_MONEY
            WHERE
                COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#"> AND
                PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.period_id#"> AND
                MONEY_STATUS = 1
        </cfquery>
        <cfreturn MONEYS>
    </cffunction>

    <cffunction name="DEFAULT_MONEY" access="public" returntype="any">
        <cfargument name="company_id" required="true">
        <cfargument name="period_id" required="true">
        <cfquery name="DEFAULT_MONEY" datasource="#DSN#">
            SELECT
                MONEY,
                RATE1,
                RATE2
            FROM
                SETUP_MONEY
            WHERE
                COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#"> AND
                RATE1 = 1 AND 
                RATE2 = 1 AND
                PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.period_id#">
        </cfquery>
        <cfreturn DEFAULT_MONEY>
    </cffunction>

    <cffunction name="GET_CREDIT_LIMIT" access="public" returntype="any" returnformat="JSON">
        <cfset result = structNew()>

        <cfif isdefined("session.pp")>
            <cfquery name="GET_CREDIT_LIMIT" datasource="#DSN#">
                SELECT 
                    PRICE_CAT
                FROM 
                    COMPANY_CREDIT
                WHERE 
                    COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.company_id#"> AND
                    OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.our_company_id#">
            </cfquery>
            <cfif get_credit_limit.recordcount and len(get_credit_limit.price_cat)>
                <cfset result.price_catid = get_credit_limit.price_cat>
            <cfelse>		
                <cfquery name="GET_COMP_CAT" datasource="#DSN#">
                    SELECT COMPANYCAT_ID FROM COMPANY WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.company_id#">
                </cfquery>
                <cfquery name="GET_PRICE_CAT" datasource="#DSN3#">
                    SELECT PRICE_CATID FROM PRICE_CAT WHERE COMPANY_CAT LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#get_comp_cat.companycat_id#,%">
                </cfquery>
                <cfif get_price_cat.recordcount>
                    <cfset result.price_catid = get_price_cat.price_catid>
                </cfif>		
            </cfif>
        <cfelseif isdefined("session.ww")>
            <cfquery name="GET_CREDIT_LIMIT" datasource="#DSN#">
                SELECT 
                    PRICE_CAT
                FROM 
                    COMPANY_CREDIT
                WHERE 
                    CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.userid#"> AND
                    OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.our_company_id#">
            </cfquery>
            <cfif get_credit_limit.recordcount and len(get_credit_limit.price_cat)>
                <cfset result.price_catid = get_credit_limit.price_cat>
            <cfelse>		
                <cfquery name="GET_COMP_CAT" datasource="#DSN#">
                    SELECT CONSUMER_CAT_ID FROM CONSUMER WHERE CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.userid#">
                </cfquery>
                <cfquery name="GET_PRICE_CAT" datasource="#DSN3#">
                    SELECT PRICE_CATID FROM PRICE_CAT WHERE CONSUMER_CAT LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#get_comp_cat.consumer_cat_id#,%">
                </cfquery>
                <cfif get_price_cat.recordcount>
                    <cfset result.price_catid = get_price_cat.price_catid>
                    <cfset result.price_catid_2 = get_price_cat.price_catid>
                </cfif>
            </cfif>
        <cfelse>
            <cfset result.price_catid = -2>
            <cfset result.price_catid_2 = -2>
        </cfif>
        <cfreturn Replace(serializeJSON(result),'//','')>
    </cffunction>

    <cffunction name="GET_PRICE_ALL" access="public" returntype="any">
        <cfargument name="company_id" required="false">
        <cfargument name="consumer_id" required="false">
        <cfargument name="price_catid" required="false">
        <cfargument name="employee" required="false">
        <cfargument name="pos_code" required="false">
        <cfargument name="get_company" required="false">
        <cfargument name="get_company_id" required="false">
        <cfargument name="brand_id" required="false">
        <cfargument name="keyword" required="false">
        <cfargument name="sepet_process_type" required="false">
        <cfset dsn2 = '#dsn#_#session_base.period_year#_#session_base.our_company_id#'>
        <cfset dsn3 = '#dsn#_#session_base.our_company_id#'>
        <cfset get_product_hierarchy = this.get_product_hierarchy()>

        <cfquery name="GET_PRICE_EXCEPTIONS_ALL" datasource="#DSN3#">
            SELECT
                PRODUCT_CATID,
                PRODUCT_ID,
                PRICE_CATID,
                BRAND_ID
            FROM 
                PRICE_CAT_EXCEPTIONS
            WHERE
                ACT_TYPE = 1 AND
            <cfif isdefined("arguments.company_id") and len(arguments.company_id)>
                COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#">
            <cfelseif isdefined("arguments.consumer_id") and len(arguments.consumer_id)>
                CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.consumer_id#">
            <cfelse>
                1=0
            </cfif>	
        </cfquery>
        <cfquery name="GET_PRICE_EXCEPTIONS_PID" dbtype="query">
            SELECT * FROM GET_PRICE_EXCEPTIONS_ALL WHERE PRODUCT_ID IS NOT NULL
        </cfquery>
        <cfquery name="GET_PRICE_EXCEPTIONS_PCATID" dbtype="query">
            SELECT * FROM GET_PRICE_EXCEPTIONS_ALL WHERE PRODUCT_CATID IS NOT NULL
        </cfquery>
        <cfquery name="GET_PRICE_EXCEPTIONS_BRID" dbtype="query">
            SELECT * FROM GET_PRICE_EXCEPTIONS_ALL WHERE BRAND_ID IS NOT NULL
        </cfquery>
        <cfquery name="GET_PRICE_ALL" datasource="#DSN3#">
            SELECT  
                P.CATALOG_ID,
                P.UNIT,
                P.PRICE,
                P.PRICE_KDV,
                P.PRODUCT_ID,
                P.MONEY,
                P.PRICE_CATID,
                ISNULL(P.STOCK_ID,0) STOCK_ID
            FROM 
                PRICE P,
                PRODUCT PR,
                PRODUCT_CAT PC
            WHERE 
                P.PRICE > 0 AND
                PC.PRODUCT_CATID = PR.PRODUCT_CATID AND 
                P.PRODUCT_ID = PR.PRODUCT_ID AND
                ISNULL(P.SPECT_VAR_ID,0) = 0 AND 
                P.PRICE_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.price_catid#"> AND
                (
                    P.STARTDATE <= #now()# AND
                    (P.FINISHDATE >= #now()# OR P.FINISHDATE IS NULL)
                )
                AND
                (
                    <cfif get_price_exceptions_pid.recordcount or get_price_exceptions_pcatid.recordcount or get_price_exceptions_brid.recordcount>
                        <cfif get_price_exceptions_pid.recordcount>
                            P.PRODUCT_ID NOT IN (#valuelist(get_price_exceptions_pid.product_id)#)
                        </cfif>
                        <cfif get_price_exceptions_pcatid.recordcount>
                            <cfif get_price_exceptions_pid.recordcount>AND </cfif> PR.PRODUCT_CATID NOT IN (#valuelist(get_price_exceptions_pcatid.product_catid)#)
                        </cfif>
                        <cfif get_price_exceptions_brid.recordcount>
                            <cfif get_price_exceptions_pid.recordcount or get_price_exceptions_pcatid.recordcount>AND </cfif> 
                            (PR.BRAND_ID NOT IN (#valuelist(get_price_exceptions_brid.BRAND_ID)#) OR PR.BRAND_ID IS NULL )
                        </cfif>
                    <cfelse>
                        1=1
                    </cfif>
                )
                <cfif isdefined('get_product_hierarchy') and get_product_hierarchy gt 0>
                    AND 
                        (PC.PRODUCT_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_product_hierarchy.product_catid#"> OR PC.HIERARCHY LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#get_product_hierarchy.hierarchy#.%">)
                </cfif>
                <cfif isdefined('arguments.employee') and len(arguments.employee) and isdefined('arguments.pos_code') and len(arguments.pos_code)>
                    AND PR.PRODUCT_MANAGER = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.pos_code#">
                </cfif>
                <cfif isdefined('arguments.get_company') and len(arguments.get_company) and isdefined('arguments.get_company_id') and len(arguments.get_company_id)>
                    AND PR.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.get_company_id#">
                </cfif>
                <cfif isdefined('arguments.brand_id') and len(arguments.brand_id)>
                    AND PR.BRAND_ID IN(<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.brand_id#" list="yes">)
                </cfif>
                <cfif isDefined("arguments.keyword") and len(arguments.keyword) gt 1>
                    AND
                        (
                            (
                                PR.PRODUCT_CODE LIKE <cfqueryparam value="%#arguments.keyword#%" cfsqltype="cf_sql_varchar"> OR
                                PR.PRODUCT_CODE_2 LIKE <cfqueryparam value="%#arguments.keyword#%" cfsqltype="cf_sql_varchar"> OR
                                PR.PRODUCT_NAME LIKE <cfqueryparam value="%#arguments.keyword#%" cfsqltype="cf_sql_varchar"> OR
                                PR.PRODUCT_DETAIL2 LIKE <cfqueryparam value="%#arguments.keyword#%" cfsqltype="cf_sql_varchar">
                            )
                            OR 
                            PR.BARCOD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.keyword#"> OR
                            PR.MANUFACT_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.keyword#">
                        )
                <cfelseif isDefined("arguments.keyword") and len(arguments.keyword) eq 1>
                    AND	PR.PRODUCT_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.keyword#">
                </cfif>
                <cfif isdefined("sepet_process_type") and (sepet_process_type neq -1)>
                    <cfif ListFind("56,58,60,63",sepet_process_type)>
                        AND PR.IS_INVENTORY = 0
                    </cfif>
                </cfif>						
                <cfif get_price_exceptions_pid.recordcount>
                    UNION
                        SELECT 
                            CATALOG_ID,
                            UNIT,
                            PRICE,
                            PRICE_KDV,
                            PRODUCT_ID,
                            MONEY,
                            PRICE_CATID,
                            0 STOCK_ID
                        FROM
                            PRICE
                        WHERE
                            PRICE > 0 AND
                            ISNULL(STOCK_ID,0)=0 AND 
                            ISNULL(SPECT_VAR_ID,0)=0 AND 
                            STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> AND
                            (FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> OR FINISHDATE IS NULL) AND
                            <cfif get_price_exceptions_pid.recordcount gt 1>(</cfif>
                                <cfoutput query="get_price_exceptions_pid">
                                    (PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#product_id#"> AND PRICE_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#price_catid#">)
                                    <cfif get_price_exceptions_pid.recordcount neq get_price_exceptions_pid.currentrow>
                                    OR
                                    </cfif>
                                </cfoutput>
                            <cfif get_price_exceptions_pid.recordcount gt 1>)</cfif>
                </cfif>
                <cfif get_price_exceptions_pcatid.recordcount>
                    UNION
                        SELECT
                            P.CATALOG_ID,
                            P.UNIT,
                            P.PRICE,
                            P.PRICE_KDV,
                            P.PRODUCT_ID,
                            P.MONEY,
                            P.PRICE_CATID,
                            0 STOCK_ID
                        FROM
                            PRICE P,
                            PRODUCT PR
                        WHERE 
                            P.PRICE > 0 AND
                            ISNULL(P.STOCK_ID,0)=0 AND 
                            ISNULL(P.SPECT_VAR_ID,0)=0 AND 
                            <cfif isdefined('add_basket_express_prod_id_list') and len(add_basket_express_prod_id_list)> <!--- hızlı siparis sayfasından cagrılıyorsa --->
                                PR.PRODUCT_ID IN (#add_basket_express_prod_id_list#) AND 
                            </cfif>
                            <cfif get_price_exceptions_pid.recordcount>
                                P.PRODUCT_ID NOT IN (#valuelist(get_price_exceptions_pid.PRODUCT_ID)#) AND
                            </cfif>
                            P.PRODUCT_ID = PR.PRODUCT_ID AND
                            P.STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> AND
                            (P.FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> OR P.FINISHDATE IS NULL) AND
                            <cfif get_price_exceptions_pcatid.recordcount gt 1>(</cfif>
                            <cfoutput query="get_price_exceptions_pcatid">
                                (PR.PRODUCT_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#product_catid#"> AND P.PRICE_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#price_catid#">)
                                <cfif get_price_exceptions_pcatid.recordcount neq get_price_exceptions_pcatid.currentrow>
                                    OR
                                </cfif>
                            </cfoutput>
                            <cfif get_price_exceptions_pcatid.recordcount gt 1>)</cfif>
                </cfif>
                <cfif get_price_exceptions_brid.recordcount>
                    UNION
                        SELECT
                            P.CATALOG_ID,
                            P.UNIT,
                            P.PRICE,
                            P.PRICE_KDV,
                            P.PRODUCT_ID,
                            P.MONEY,
                            P.PRICE_CATID,
                            0 STOCK_ID
                        FROM
                            PRICE P,
                            PRODUCT PR
                        WHERE 
                            P.PRICE > 0 AND
                            ISNULL(P.STOCK_ID,0)=0 AND 
                            ISNULL(P.SPECT_VAR_ID,0)=0 AND 
                            <cfif isdefined('add_basket_express_prod_id_list') and len(add_basket_express_prod_id_list)> <!--- hızlı siparis sayfasından cagrılıyorsa --->
                                PR.PRODUCT_ID IN (#add_basket_express_prod_id_list#) AND 
                            </cfif>
                            <cfif get_price_exceptions_pid.recordcount>
                                P.PRODUCT_ID NOT IN (#valuelist(get_price_exceptions_pid.PRODUCT_ID)#) AND
                            </cfif>
                            <cfif get_price_exceptions_pcatid.recordcount>
                                PR.PRODUCT_CATID NOT IN (#valuelist(get_price_exceptions_pcatid.PRODUCT_CATID)#) AND
                            </cfif>
                            P.PRODUCT_ID = PR.PRODUCT_ID AND
                            P.STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> AND
                            (P.FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> OR P.FINISHDATE IS NULL) AND
                            <cfif get_price_exceptions_brid.recordcount gt 1>(</cfif>
                            <cfoutput query="get_price_exceptions_brid">
                                (PR.BRAND_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#brand_id#"> AND P.PRICE_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#price_catid#">)
                                <cfif get_price_exceptions_brid.recordcount neq get_price_exceptions_brid.currentrow>
                                    OR
                                </cfif>
                            </cfoutput>
                            <cfif get_price_exceptions_brid.recordcount gt 1>)</cfif>
                </cfif>
        </cfquery>
        <cfreturn GET_PRICE_ALL>
    </cffunction>

    <cffunction name="GET_PRODUCT_CAT" access="public" returntype="any">
        <cfargument name="product_category_id" type="string">
        <cfargument name="product_id" type="string">
        <cfargument name="max_product_num" type="string">
            <cfquery name="GET_PRODUCT_CAT" datasource="#DSN1#">
                SELECT <cfif isdefined('max_product_num') and len(max_product_num)>TOP #max_product_num#</cfif>
                    P.PRODUCT_ID,                                       
                    P.PRODUCT_CATID,
                    P.PRODUCT_ID,
                    COALESCE(SLIPN.ITEM,P.PRODUCT_NAME) AS PRODUCT_NAME,
                    COALESCE(SLIPD.ITEM,P.PRODUCT_DETAIL) AS PRODUCT_DETAIL,
                    PC.PRODUCT_CAT,                    
                    (SELECT TOP 1 PIMG.PATH FROM PRODUCT_IMAGES PIMG WHERE P.PRODUCT_ID = PIMG.PRODUCT_ID AND (PIMG.IMAGE_SIZE = 0 OR PIMG.IMAGE_SIZE =1 OR PIMG.IMAGE_SIZE = 2)) PATH,
                    (SELECT TOP 1 PIMG.PATH FROM PRODUCT_IMAGES PIMG WHERE P.PRODUCT_ID = PIMG.PRODUCT_ID AND (PIMG.IMAGE_SIZE = 3)) PATH_ICON,
                    UFU.USER_FRIENDLY_URL
                FROM
                    PRODUCT AS P
                    LEFT JOIN PRODUCT_CAT AS PC ON P.PRODUCT_CATID = PC.PRODUCT_CATID    
                    LEFT JOIN #dsn#.SETUP_LANGUAGE_INFO SLIPN 
                        ON SLIPN.UNIQUE_COLUMN_ID = P.PRODUCT_ID 
                        AND SLIPN.COLUMN_NAME ='PRODUCT_NAME'
                        AND SLIPN.TABLE_NAME = 'PRODUCT'
                        AND SLIPN.LANGUAGE = '#session_base.language#' 
                    LEFT JOIN #dsn#.SETUP_LANGUAGE_INFO SLIPD
                        ON SLIPD.UNIQUE_COLUMN_ID = P.PRODUCT_ID 
                        AND SLIPD.COLUMN_NAME ='PRODUCT_DETAIL'
                        AND SLIPD.TABLE_NAME = 'PRODUCT'
                        AND SLIPD.LANGUAGE = '#session_base.language#'       
                    OUTER APPLY(
                        SELECT TOP 1 UFU.USER_FRIENDLY_URL 
                        FROM #dsn#.USER_FRIENDLY_URLS UFU 
                        WHERE UFU.ACTION_TYPE = 'PRODUCT_ID' 
                    AND UFU.ACTION_ID = P.PRODUCT_ID 		
                    AND UFU.PROTEIN_SITE = #arguments.site#
                    AND OPTIONS_DATA LIKE '%"LANGUAGE":"%#session_base.language#%"%') UFU
                WHERE
                    <cfif isdefined("session.pp")>P.IS_EXTRANET = 1 AND<cfelse>P.IS_INTERNET = 1 AND</cfif>
                    P.IS_INVENTORY = 1 AND
                    P.IS_SALES = 1 AND                    
                    P.PRODUCT_STATUS = 1
                    <cfif isdefined("arguments.product_category_id") and len(arguments.product_category_id)>	
                        AND PC.PRODUCT_CATID IN (<cfqueryparam value="#arguments.product_category_id#" cfsqltype="cf_sql_integer" list="true">)
                    </cfif>
                    <cfif isdefined("arguments.product_id") and len(arguments.product_id) and arguments.product_id neq 0>	
                        AND P.PRODUCT_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.product_id#" list="yes">)
                    </cfif>
            </cfquery>
        <cfreturn GET_PRODUCT_CAT>
    </cffunction>

    <cffunction name="GET_LAST_VISITED_5_PRODUCTS" access="public" returntype="any">
        <cfargument name="is_random_cat_brand">

        <cfquery name="GET_LAST_VISITED_5_PRODUCTS" datasource="#DSN3#">
            SELECT		 
                COUNT(P.PRODUCT_ID) AS SAYI,
                <cfif arguments.is_random_cat_brand eq 0>
                    P.PRODUCT_CATID AS TYPE
                <cfelse>
                    P.BRAND_ID AS TYPE
                </cfif>
            FROM
                PRODUCT P,
                STOCKS S, 
                PRODUCT_CAT PC,
                #dsn1#.PRODUCT_CAT_OUR_COMPANY PCO
            WHERE
                PCO.PRODUCT_CATID = PC.PRODUCT_CATID AND
                PCO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.our_company_id#"> AND
                S.PRODUCT_ID = P.PRODUCT_ID AND
                P.PRODUCT_CATID = PC.PRODUCT_CATID AND
                PC.IS_PUBLIC = 1 AND
                <cfif isdefined("session.pp")>P.IS_EXTRANET = 1 AND<cfelse>P.IS_INTERNET = 1 AND</cfif>
                P.PRODUCT_STATUS = 1 AND
                S.STOCK_ID IN (#cookie.last_visited_5_products#)		
            GROUP BY
                <cfif arguments.is_random_cat_brand eq 0>
                    P.PRODUCT_CATID
                <cfelse>
                    P.BRAND_ID,
                    P.PRODUCT_CATID
                </cfif>
        </cfquery>
        <cfreturn GET_LAST_VISITED_5_PRODUCTS>
    </cffunction>

    <cffunction name="GET_RANDOM_PRODUCTS" access="public" returntype="any">
        <cfargument name="max_">
        <cfargument name="random_cat">
        <cfargument name="visited_list">
        <cfargument name="is_random_cat_brand">
        <cfquery name="GET_RANDOM_PRODUCTS" datasource="#DSN3#" maxrows="#arguments.max#">			
            SELECT		
                DISTINCT
                P.PRODUCT_NAME, 
                P.PRODUCT_ID,
				P.PRODUCT_DETAIL,
                S.STOCK_ID,
                S.PROPERTY,
                PC.PRODUCT_CAT,
                PB.BRAND_NAME,
				PS.PRICE,
                PS.PRICE_KDV,
                PS.MONEY
            FROM
                PRODUCT P,
                PRICE AS PS,
                STOCKS S, 
                PRODUCT_CAT PC,
                #dsn1#.PRODUCT_CAT_OUR_COMPANY PCO,
                PRODUCT_BRANDS PB
            WHERE
               	P.PRODUCT_ID IN (SELECT PRODUCT_ID FROM PRODUCT_IMAGES WHERE IMAGE_SIZE = 0) AND
				PS.PRODUCT_ID = P.PRODUCT_ID AND
                P.BRAND_ID = PB.BRAND_ID AND
                PCO.PRODUCT_CATID = PC.PRODUCT_CATID AND
                PCO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.our_company_id#"> AND
                S.PRODUCT_ID = P.PRODUCT_ID AND
                P.PRODUCT_CATID = PC.PRODUCT_CATID AND
				PS.PRICE > <cfqueryparam value="0" cfsqltype="cf_sql_float">
				AND PC.IS_PUBLIC = 1 AND
                <cfif isdefined("session.pp")>P.IS_EXTRANET = 1 AND<cfelse>P.IS_INTERNET = 1 AND</cfif>
                P.PRODUCT_STATUS = 1 AND
                <cfif arguments.is_random_cat_brand eq 0>
                	P.PRODUCT_CATID IN (#arguments.visited_list#)
                <cfelse>
                	P.BRAND_ID IN(<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.visited_list#" list="yes">)
                    <cfif isdefined("arguments.random_cat")>
                        AND P.PRODUCT_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.random_cat#">
                    </cfif>
                </cfif>
		</cfquery>
        <cfreturn GET_RANDOM_PRODUCTS>
    </cffunction>

    <cffunction name="GET_SIMPLE_PRODUCT" access="public" returntype="any">        
        <cfquery name="GET_SIMPLE_PRODUCT" datasource="#DSN3#">
            SELECT DISTINCT
                P.PRODUCT_ID,
                P.PRODUCT_NAME,
                P.PRODUCT_DETAIL,
                P.PRODUCT_DETAIL2,
                UFU.USER_FRIENDLY_URL,		
                PS.PRICE PRICE,
                PS.MONEY MONEY,
                PS.IS_KDV IS_KDV,
                PS.PRICE_KDV PRICE_KDV
            FROM
                PRODUCT P
                OUTER APPLY(
                    SELECT TOP 1 UFU.USER_FRIENDLY_URL 
                    FROM #dsn#.USER_FRIENDLY_URLS UFU 
                    WHERE UFU.ACTION_TYPE = 'PRODUCT_ID' 
                    AND UFU.ACTION_ID = P.PRODUCT_ID 		
                    AND UFU.PROTEIN_SITE = #arguments.site#) UFU,
                STOCKS S,
                PRODUCT_CAT PC,
                #dsn1#.PRODUCT_CAT_OUR_COMPANY PCO,
                PRICE_STANDART PS,
                PRODUCT_UNIT PU
            WHERE
                PS.PRODUCT_ID = S.PRODUCT_ID AND
                PU.PRODUCT_UNIT_ID = PS.UNIT_ID AND
                PU.PRODUCT_ID = S.PRODUCT_ID AND
                S.PRODUCT_UNIT_ID = PU.PRODUCT_UNIT_ID AND
                S.PRODUCT_ID = P.PRODUCT_ID AND
                PS.PRICE > <cfqueryparam value="0" cfsqltype="cf_sql_float"> AND
                PS.PRICESTANDART_STATUS = 1	AND
                PS.PURCHASESALES = 1 AND
                <cfif isdefined("session.pp")>P.IS_EXTRANET = 1 AND<cfelse>P.IS_INTERNET = 1 AND</cfif>
                PCO.PRODUCT_CATID = PC.PRODUCT_CATID AND
                PCO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.our_company_id#"> AND
                P.PRODUCT_CATID = PC.PRODUCT_CATID AND
                P.PRODUCT_STATUS = 1
                <cfif isdefined('arguments.is_product_cat_id') and len(arguments.is_product_cat_id)>
                    AND PC.PRODUCT_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.is_product_cat_id#">
                </cfif>
            ORDER BY
                P.PRODUCT_NAME ASC
        </cfquery>
        <cfreturn GET_SIMPLE_PRODUCT>
    </cffunction>

    <cffunction name="get_product_properties_2" access="remote" returntype="query">
		<cfargument name="hierarchy" default="">
		<cfargument name="kategori" default="">
        <cfargument name="our_company_id" default="">

		<cfquery name="get_product_properties_query_2" datasource="#DSN#">
			SELECT 
				DISTINCT PP.PROPERTY_CODE, PP.PROPERTY, PPD.PROPERTY_DETAIL_CODE, PPD.PROPERTY_DETAIL,PPD.PROPERTY_DETAIL_ID,PP.PROPERTY_ID
			FROM
				#dsn1#.PRODUCT_PROPERTY PP,
                #dsn1#.PRODUCT_PROPERTY_OUR_COMPANY PPOC,
				#dsn3#.PRODUCT P,
				#dsn1#.PRODUCT_DT_PROPERTIES PDP,
				#dsn1#.PRODUCT_PROPERTY_DETAIL PPD
			WHERE
				PP.PROPERTY_ID=PDP.PROPERTY_ID AND
                PP.PROPERTY_ID=PPOC.PROPERTY_ID AND
				PDP.PRODUCT_ID=P.PRODUCT_ID	AND
				PPD.PRPT_ID=PP.PROPERTY_ID AND
				PDP.VARIATION_ID=PPD.PROPERTY_DETAIL_ID AND
                PP.IS_INTERNET=1 AND 
                PP.IS_ACTIVE = 1
                <cfif IsDefined("arguments.our_company_id") and len(arguments.our_company_id)>
                    AND PPOC.OUR_COMPANY_ID=<cfqueryparam value = "#arguments.our_company_id#" CFSQLType = "cf_sql_integer">
                </cfif>
				<cfif isdefined("arguments.kategori") and len(arguments.kategori)>
					AND 
					(
						<cfloop from="1" to="#listlen(arguments.kategori)#" index="deger">
							<cfset this_hie=listgetat(arguments.kategori,deger)>
							P.PRODUCT_CODE LIKE '#this_hie#.%'
							<cfif deger neq listlen(arguments.kategori)> OR </cfif> 
						</cfloop>
					)  
				<cfelseif len(arguments.hierarchy)>
					AND P.PRODUCT_CODE LIKE '#arguments.hierarchy#.%'
				</cfif>
			GROUP BY PP.PROPERTY_CODE, PP.PROPERTY, PPD.PROPERTY_DETAIL_CODE, PPD.PROPERTY_DETAIL,PPD.PROPERTY_DETAIL_ID,PP.PROPERTY_ID
			ORDER BY PP.PROPERTY_CODE, PP.PROPERTY, PPD.PROPERTY_DETAIL_CODE, PPD.PROPERTY_DETAIL
		</cfquery>
		<cfreturn get_product_properties_query_2>
        
	</cffunction>

    <cffunction name="get_product_brands" access="remote" returntype="query">
		<cfargument name="hierarchy" default="">
        <cfargument name="our_company_id" default="">
		<cfquery name="get_product_brands_query" datasource="#DSN#">
				SELECT 
					DISTINCT PB.BRAND_NAME,PB.BRAND_ID
				FROM				
					#dsn3#.PRODUCT_BRANDS PB,
                    #dsn1#.PRODUCT_BRANDS_OUR_COMPANY PBOC,
					#dsn3#.PRODUCT P
				WHERE
					PB.BRAND_ID=P.BRAND_ID
                    AND PB.BRAND_ID=PBOC.BRAND_ID
                    AND PB.IS_INTERNET = 1
                    AND PB.IS_ACTIVE = 1
                    <cfif IsDefined("arguments.our_company_id") and len(arguments.our_company_id)>
                        AND PBOC.OUR_COMPANY_ID=<cfqueryparam value = "#arguments.our_company_id#" CFSQLType = "cf_sql_integer">
                    </cfif>
					<cfif len(arguments.hierarchy)>
						AND P.PRODUCT_CODE LIKE '#arguments.hierarchy#.%'
					</cfif>
				
		</cfquery>
			<cfreturn get_product_brands_query>
	</cffunction>

    <cffunction name="get_product_stocks" access="public" returntype="any">
        <cfargument name="product_id" type="numeric">
        <cfargument name="not_stock_id" type="numeric">
        <cfargument name="last_user_price_list" type="any">

        <cfquery name="query_get_product_stock" datasource="#DSN3#">			
            SELECT
                STOCKS.STOCK_ID,
                STOCKS.STOCK_CODE,
                STOCKS.PRODUCT_NAME,
                STOCKS.PRODUCT_DETAIL,
                STOCKS.PROPERTY,
                STOCKS.STOCK_CODE_2,
                --PRODUCT.IS_ZERO_STOCK,
                PU.MAIN_UNIT,
                P.PRICE, 
                P.MONEY, 
                P.IS_KDV, 
                P.PRICE_KDV
            FROM
                STOCKS
                --JOIN PRODUCT ON STOCKS.PRODUCT_ID = STOCKS.PRODUCT_ID
                JOIN PRODUCT_UNIT AS PU ON STOCKS.PRODUCT_UNIT_ID = PU.PRODUCT_UNIT_ID
                JOIN PRICE AS P ON STOCKS.STOCK_ID = P.STOCK_ID AND STOCKS.PRODUCT_UNIT_ID = P.UNIT
            WHERE
               	STOCKS.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.product_id#">
                AND STOCKS.STOCK_ID <> <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.not_stock_id#">
                AND P.PRICE > <cfqueryparam value="0" cfsqltype="cf_sql_float">
                AND (P.FINISHDATE IS NULL OR P.FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">)
                <cfif IsDefined("arguments.last_user_price_list") and len(arguments.last_user_price_list)>
                    AND P.PRICE_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.last_user_price_list#">
                <cfelse>
                    AND 1 = 2
                </cfif>
		</cfquery>
        <cfreturn query_get_product_stock>
    </cffunction>

</cfcomponent>