<cfcomponent>
    <cfset dsn=application.systemParam.systemParam().dsn>
    <cfset dsn2 = '#dsn#_#session.ep.period_year#_#session.ep.company_id#'>
    <cfset dsn3 = '#dsn#_#session.ep.company_id#'> 
    <cffunction  name="GET_PROM"  access = "public">
        <cfargument name="PROM_ID" default="">
    <cfquery name="GET_PROM" datasource="#dsn3#">
        SELECT
        PR.PROM_NO,
        PR.CAMP_ID,
        PR.PROM_HEAD,
        PR.STOCK_ID,
        PR.PRODUCT_CATID,
        PR.COMPANY_ID,
        PR.SUPPLIER_ID,
        PR.FREE_STOCK_ID,
        PR.FREE_STOCK_AMOUNT,
        PR.FREE_STOCK_PRICE,
        PR.GIFT_AMOUNT,
        PR.GIFT_PRICE,
        PR.PROM_STATUS,
        PR.PROM_STAGE,
        PR.LIMIT_TYPE,
        PR.LIMIT_VALUE,
        PR.PROMOTION_CODE,
        PR.BANNER_ID,
        PR.USER_FRIENDLY_URL,
        PR.LIMIT_CURRENCY,
        PR.GIFT_HEAD,
        PR.PROM_POINT,
        PR.TOTAL_AMOUNT,
        PR.COUPON_ID,
        <!--- BK 20130722 6 aya silinsin <cfif len(DISCOUNT_TYPE_ID_1)>DISCOUNT_TYPE_ID_1, --->
            PR.DISCOUNT,
            PR.AMOUNT_DISCOUNT,
            PR.AMOUNT_DISCOUNT_MONEY_1, 
        <!--- BK 20130722 6 aya silinsin <cfif len(DISCOUNT_TYPE_ID_2)>DISCOUNT_TYPE_ID_2, --->
            PR.AMOUNT_DISCOUNT_2,
            PR.AMOUNT_DISCOUNT_MONEY_2,
            PR.PRIM_PERCENT,
            PR.IS_ALL_PRODUCTS,
            PR.CARD_TYPE,
            PR.AMOUNT_1,
            PR.AMOUNT_2,
            PR.AMOUNT_3,
            PR.AMOUNT_4,
            PR.AMOUNT_5,
            PR.AMOUNT_1_MONEY,
            PR.AMOUNT_2_MONEY,
            PR.AMOUNT_3_MONEY,
            PR.AMOUNT_4_MONEY,
            PR.AMOUNT_5_MONEY,
            PR.TOTAL_PROMOTION_COST,
            PR.TOTAL_PROMOTION_COST_MONEY,
            PR.ICON_ID,
            PR.STARTDATE,
            PR.FINISHDATE,
            PR.PROM_DETAIL,
            PR.PRICE_CATID,
            PR.RECORD_EMP,	
            PR.PROM_ZONE,
            PR.BRAND_ID,
            PB.BRAND_ID,
            PB.BRAND_NAME,
            CMP.COMPANY_ID,
            CMP.NICKNAME,
            PR.PROM_TYPE,
			<!--- IS_VIEWED, --->
			PR.RECORD_DATE,
			PR.RECORD_IP,
			PR.DUE_DAY,
			PR.TARGET_DUE_DATE,
            CP.COUPON_ID,
            S.PRODUCT_ID,
            P.PRODUCT_ID,
            P.PRODUCT_NAME,
            S.PROPERTY,
            CP.COUPON_NAME,
			PR.IS_DETAIL
        FROM
            PROMOTIONS AS PR
            LEFT JOIN #DSN#.COMPANY AS CMP ON CMP.COMPANY_ID = PR.SUPPLIER_ID
            LEFT JOIN PRODUCT_BRANDS AS PB ON PB.BRAND_ID = PR.BRAND_ID
            LEFT JOIN COUPONS AS CP ON CP.COUPON_ID = PR.COUPON_ID
            LEFT JOIN STOCKS AS S ON S.STOCK_ID = PR.FREE_STOCK_ID
            LEFT JOIN PRODUCT AS P ON P.PRODUCT_ID = S.PRODUCT_ID
                                                                   
                                                                    
        WHERE
            PROM_ID =<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.PROM_ID#">
    </cfquery>
      <cfreturn GET_PROM>
    </cffunction>
     <cffunction  name="get" access="public">
        <cfargument  name="PROM_ID" default="">
         <cfreturn GET_PROM(PROM_ID=arguments.PROM_ID)> 
    </cffunction>
    <cffunction  name="get_roundnum"  access = "public">
       
    <cfquery name="get_roundnum" datasource="#dsn#">
        SELECT SALES_PRICE_ROUND_NUM FROM OUR_COMPANY_INFO WHERE COMP_ID=#session.ep.company_id#
    </cfquery>
     <cfreturn get_roundnum>
    </cffunction>
    <cffunction  name="PRICE_CATS"  access = "public">
    <cfquery name="PRICE_CATS" datasource="#DSN3#">
        SELECT
            PRICE_CATID,
            PRICE_CAT
        FROM
            PRICE_CAT
        WHERE
            PRICE_CAT_STATUS = 1
        <cfif session.ep.isBranchAuthorization>
            AND PRICE_CAT.BRANCH LIKE '%,#LISTGETAT(SESSION.EP.USER_LOCATION,2,"-")#,%'
        </cfif>
        ORDER BY
            PRICE_CAT
    </cfquery>
    <cfreturn PRICE_CATS>
</cffunction>
    <cffunction name="get_card_types" access = "public">
        <cfquery name="get_card_types" datasource="#dsn#_retail">
            SELECT TYPE_NAME, TYPE_ID FROM CARD_TYPES
        </cfquery>
        <cfreturn get_card_types>
    </cffunction>
    <cffunction name="GET_COMPANY" access = "public">
        <cfquery name="get_company" datasource="#dsn#">
            SELECT NICKNAME FROM COMPANY WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#">
        </cfquery>
        <cfreturn get_company>
    </cffunction>
    <cffunction name="GET_CAMP_NAME" access = "public">
        <cfquery name="get_camp_name" datasource="#dsn3#">
            SELECT CAMP_HEAD,CAMP_STARTDATE,CAMP_FINISHDATE FROM CAMPAIGNS WHERE CAMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.camp_id#">
        </cfquery>
        <cfreturn get_camp_name>
    </cffunction>
    <cffunction name="GET_PRODUCT_CAT" access = "public">
        <cfquery name="get_product_cat" datasource="#DSN3#">
            SELECT PRODUCT_CATID,PRODUCT_CAT FROM PRODUCT_CAT WHERE PRODUCT_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.product_catid#">
        </cfquery>
        <cfreturn get_product_cat>
    </cffunction>
    <cffunction name="PRODUCT_NAME" access = "public">
        <cfquery name="product_name" datasource="#DSN3#">
            SELECT
                STOCKS.STOCK_ID,
                STOCKS.PRODUCT_ID,
                PRODUCT.PRODUCT_NAME,
                STOCKS.PROPERTY,
                STOCKS.STOCK_CODE
            FROM
                PRODUCT,
                STOCKS
            WHERE
                STOCKS.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.stock_id#"> AND
                STOCKS.PRODUCT_ID = PRODUCT.PRODUCT_ID
        </cfquery>	
        <cfreturn product_name>
    </cffunction>
    <cffunction name="GET_ICON" access = "public">
        <cfquery name="get_icon" datasource="#DSN3#">
            SELECT * FROM SETUP_PROMO_ICON 
        </cfquery>
        <cfreturn get_icon>
    </cffunction>
</cfcomponent>
