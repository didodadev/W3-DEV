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
    <cfelse>
        <cfset session_base = evaluate('session.qq')>
        <cfset company_id = session.qq.our_company_id>
        <cfset period_year = session.qq.period_year>
        <cfset language = session.qq.language>
    </cfif>   
    <cfset dsn = application.systemParam.systemParam().dsn>
    <cfset dsn1 = '#dsn#_product'>
    <cfset dsn2 = '#dsn#_#session_base.period_year#_#session_base.our_company_id#'>
    <cfset dsn3 = '#dsn#_#session_base.our_company_id#'>
    <cfset int_comp_id = session_base.our_company_id>
    <cfset int_period_id = session_base.period_id>
   
    <cffunction name="add_receive_offer" access="remote" returntype="string" returnFormat="json">
        <cfargument name="IS_APPROVE_ALL" default="1">
        <cfargument name="IS_APPROVE_CUSTOM" default="1">
        <cftry>  
                <cf_papers paper_type="offer" paper_type2="1">
                <cfquery name="get_offer" datasource="#dsn3#">
                    SELECT * FROM OFFER WHERE OFFER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.offer_id#">
                </cfquery>
                <cflock name="#CREATEUUID()#" timeout="20">
                    <cftransaction>
                        <cfquery name="SET_MAX_PAPER" datasource="#DSN3#">
                            UPDATE
                                GENERAL_PAPERS
                            SET
                                OFFER_NUMBER = OFFER_NUMBER+1
                            WHERE
                                PAPER_TYPE = 1 AND
                                ZONE_TYPE = 0
                        </cfquery>
                        <cfquery name="ADD_OFFER" datasource="#DSN3#" result="GET_MAX_OFFER">
                            INSERT INTO 
                                OFFER 
                            (
                                PARTNER_ID,
                                COMPANY_ID,
                                CONSUMER_ID,
                                SALES_EMP_ID,
                                SALES_PARTNER_ID,
                                SALES_CONSUMER_ID,
                                OFFER_CURRENCY,
                                OFFER_STAGE,
                                OFFER_DATE,
                                PRICE,
                                PAYMETHOD,
                                CARD_PAYMETHOD_ID,
                                CARD_PAYMETHOD_RATE,
                                DELIVERDATE,
                                SHIP_DATE,
                                FINISHDATE,
                                OFFER_HEAD,
                                OFFER_DETAIL,
                                OTHER_MONEY,
                                OTHER_MONEY_VALUE,
                                TAX,
                                OTV_TOTAL,
                                NETTOTAL,
                                OFFER_NUMBER,
                                OFFER_STATUS,
                                PURCHASE_SALES,
                                INCLUDED_KDV,
                                OFFER_ZONE,
                                SHIP_METHOD,
                                SHIP_ADDRESS,
                                SHIP_ADDRESS_ID,
                                IS_PARTNER_ZONE,
                                IS_PUBLIC_ZONE,
                                PROJECT_ID,
                                WORK_ID,
                                DUE_DATE,
                                REF_NO,
                                CITY_ID,
                                COUNTY_ID,
                                SALES_ADD_OPTION_ID,
                                RELATION_OFFER_ID,
                                RECORD_DATE,
                                RECORD_IP,
                                RECORD_MEMBER,
                                COUNTRY_ID,
                                SZ_ID,
                                PROBABILITY ,
                                EVENT_PLAN_ROW_ID,
                                SA_DISCOUNT,
                                FOR_OFFER_ID,
                                OFFER_TO,
	                            OFFER_TO_PARTNER
                            )
                            SELECT 
                                PARTNER_ID,
                                COMPANY_ID,
                                CONSUMER_ID,
                                SALES_EMP_ID,
                                SALES_PARTNER_ID,
                                SALES_CONSUMER_ID,
                                OFFER_CURRENCY,
                                OFFER_STAGE,
                                OFFER_DATE,
                                PRICE,
                                PAYMETHOD,
                                CARD_PAYMETHOD_ID,
                                CARD_PAYMETHOD_RATE,
                                DELIVERDATE,
                                SHIP_DATE,
                                FINISHDATE,
                                OFFER_HEAD,
                                OFFER_DETAIL,
                                OTHER_MONEY,
                                OTHER_MONEY_VALUE,
                                TAX,
                                OTV_TOTAL,
                                NETTOTAL,
                                '#paper_full#',
                                OFFER_STATUS,
                                PURCHASE_SALES,
                                INCLUDED_KDV,
                                OFFER_ZONE,
                                SHIP_METHOD,
                                SHIP_ADDRESS,
                                SHIP_ADDRESS_ID,
                                IS_PARTNER_ZONE,
                                IS_PUBLIC_ZONE,
                                PROJECT_ID,
                                WORK_ID,
                                DUE_DATE,
                                REF_NO,
                                CITY_ID,
                                COUNTY_ID,
                                SALES_ADD_OPTION_ID,
                                RELATION_OFFER_ID,
                                <cfqueryparam value="#now()#" cfsqltype="cf_sql_date">,                        
                                <cfqueryparam value="#cgi.remote_addr#" cfsqltype="cf_sql_varchar">,
                                1,
                                COUNTRY_ID,
                                SZ_ID,
                                PROBABILITY ,
                                EVENT_PLAN_ROW_ID,
                                SA_DISCOUNT,
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.offer_id#">,
                                ',#session_base.company_id#,',
                                ',#session_base.userid#,'
                            FROM
                                OFFER                         
                            WHERE 
                                OFFER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.offer_id#"> 
                        </cfquery>
                        <cfset GET_MAX_OFFER.max_id = GET_MAX_OFFER.IDENTITYCOL>
                        <cfquery name="get_offer_row" datasource="#dsn3#">
                            SELECT 
                                OFFER_ROW_ID                               
                            FROM 
                                OFFER_ROW
                            WHERE
                                OFFER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.offer_id#">
                        </cfquery>
                        <cfloop query="#get_offer_row#">                                                   
                            <cfquery name="ADD_OFFER_ROW" datasource="#DSN3#">
                                INSERT INTO
                                    OFFER_ROW
                                (
                                    OFFER_ID,
                                    PRODUCT_ID,
                                    STOCK_ID,
                                    QUANTITY,
                                    UNIT,
                                    UNIT_ID,					
                                    <cfif isdefined('arguments.price_#currentrow#') and len(evaluate('arguments.price_#currentrow#'))>
                                        PRICE,
                                    </cfif>
                                    TAX,
                                    DUEDATE,
                                    PRODUCT_NAME,
                                    DELIVER_DATE,
                                    DELIVER_DEPT,
                                    DELIVER_LOCATION,
                                    DISCOUNT_1,
                                    DISCOUNT_2,
                                    DISCOUNT_3,
                                    DISCOUNT_4,
                                    DISCOUNT_5,
                                    DISCOUNT_6,
                                    DISCOUNT_7,
                                    DISCOUNT_8,
                                    DISCOUNT_9,
                                    DISCOUNT_10,
                                    OTHER_MONEY,
                                    OTHER_MONEY_VALUE,                                
                                    SPECT_VAR_ID,
                                    SPECT_VAR_NAME,
                                    PRICE_OTHER,
                                    NET_MALIYET,                                   
                                    EXTRA_COST,
                                    MARJ,
                                    PROM_COMISSION,
                                    PROM_COST,
                                    DISCOUNT_COST,
                                    PROM_ID,
                                    IS_PROMOTION,
                                    PROM_STOCK_ID,
                                    UNIQUE_RELATION_ID,
                                    PRODUCT_NAME2,
                                    AMOUNT2,
                                    UNIT2,
                                    EXTRA_PRICE,
                                    EXTRA_PRICE_TOTAL,
                                    EXTRA_PRICE_OTHER_TOTAL,
                                    SHELF_NUMBER,
                                    PRODUCT_MANUFACT_CODE,
                                    BASKET_EXTRA_INFO_ID,
                                    SELECT_INFO_EXTRA,
                                    DETAIL_INFO_EXTRA,
                                    DELIVERY_CONDITION,
                                    LIST_PRICE,
                                    LOT_NO,
                                    NUMBER_OF_INSTALLMENT,
                                    PRICE_CAT,
                                    CATALOG_ID,
                                    EK_TUTAR_PRICE,
                                    OTV_ORAN,
                                    OTVTOTAL,
                                    WRK_ROW_ID,
                                    WRK_ROW_RELATION_ID,
                                    RELATED_ACTION_ID,
                                    RELATED_ACTION_TABLE,
                                    BASKET_EMPLOYEE_ID,
                                    WIDTH_VALUE,
                                    DEPTH_VALUE,
                                    HEIGHT_VALUE,
                                    ROW_PROJECT_ID,
                                    KARMA_PRODUCT_ID,
                                    PBS_ID,
                                    ROW_WORK_ID
                                    ,EXPENSE_CENTER_ID
                                    ,EXPENSE_ITEM_ID
                                    ,ACTIVITY_TYPE_ID
                                    ,ACC_CODE
                                    ,BSMV_RATE
                                    ,BSMV_AMOUNT
                                    ,BSMV_CURRENCY
                                    ,OIV_RATE
                                    ,OIV_AMOUNT
                                    ,TEVKIFAT_RATE
                                    ,TEVKIFAT_AMOUNT
                                )
                                SELECT
                                    #get_max_offer.max_id#,
                                    PRODUCT_ID,
                                    STOCK_ID,
                                    QUANTITY,
                                    UNIT,
                                    UNIT_ID,					
                                    <cfif isdefined('arguments.price_#currentrow#') and len(evaluate('arguments.price_#currentrow#'))>
                                        #evaluate('arguments.price_#currentrow#')#,
                                    </cfif>
                                    TAX,
                                    DUEDATE,
                                    PRODUCT_NAME,
                                    DELIVER_DATE,
                                    DELIVER_DEPT,
                                    DELIVER_LOCATION,
                                    DISCOUNT_1,
                                    DISCOUNT_2,
                                    DISCOUNT_3,
                                    DISCOUNT_4,
                                    DISCOUNT_5,
                                    DISCOUNT_6,
                                    DISCOUNT_7,
                                    DISCOUNT_8,
                                    DISCOUNT_9,
                                    DISCOUNT_10,
                                    OTHER_MONEY,
                                    OTHER_MONEY_VALUE,                                
                                    SPECT_VAR_ID,
                                    SPECT_VAR_NAME,
                                    PRICE_OTHER,
                                    NET_MALIYET,                                   
                                    EXTRA_COST,
                                    MARJ,
                                    PROM_COMISSION,
                                    PROM_COST,
                                    DISCOUNT_COST,
                                    PROM_ID,
                                    IS_PROMOTION,
                                    PROM_STOCK_ID,
                                    UNIQUE_RELATION_ID,
                                    PRODUCT_NAME2,
                                    AMOUNT2,
                                    UNIT2,
                                    EXTRA_PRICE,
                                    EXTRA_PRICE_TOTAL,
                                    EXTRA_PRICE_OTHER_TOTAL,
                                    SHELF_NUMBER,
                                    PRODUCT_MANUFACT_CODE,
                                    BASKET_EXTRA_INFO_ID,
                                    SELECT_INFO_EXTRA,
                                    DETAIL_INFO_EXTRA,
                                    DELIVERY_CONDITION,
                                    LIST_PRICE,
                                    LOT_NO,
                                    NUMBER_OF_INSTALLMENT,
                                    PRICE_CAT,
                                    CATALOG_ID,
                                    EK_TUTAR_PRICE,
                                    OTV_ORAN,
                                    OTVTOTAL,
                                    WRK_ROW_ID,
                                    WRK_ROW_RELATION_ID,
                                    RELATED_ACTION_ID,
                                    RELATED_ACTION_TABLE,
                                    BASKET_EMPLOYEE_ID,
                                    WIDTH_VALUE,
                                    DEPTH_VALUE,
                                    HEIGHT_VALUE,
                                    ROW_PROJECT_ID,
                                    KARMA_PRODUCT_ID,
                                    PBS_ID,
                                    ROW_WORK_ID
                                    ,EXPENSE_CENTER_ID
                                    ,EXPENSE_ITEM_ID
                                    ,ACTIVITY_TYPE_ID
                                    ,ACC_CODE
                                    ,BSMV_RATE
                                    ,BSMV_AMOUNT
                                    ,BSMV_CURRENCY
                                    ,OIV_RATE
                                    ,OIV_AMOUNT
                                    ,TEVKIFAT_RATE
                                    ,TEVKIFAT_AMOUNT
                                FROM
                                    OFFER_ROW
                                WHERE
                                    OFFER_ROW_ID = #OFFER_ROW_ID#                                
                            </cfquery>                            <!--- // urun asortileri --->						
                        </cfloop>
                    </cftransaction>
                </cflock>
            <cfset result.status = true>
            <cfset result.identitycol = 1<!--- query_result.identitycol --->>
            <cfset result.SUCCESS_MESSAGE = "Teklifiniz Kaydedilmiştir">
            <cfcatch type="any">
                <cfset result.status = false>
                <cfset result.error = cfcatch >
                <cfset result.DANGER_MESSAGE = "#application.functions.getLang('','Opps! bir hata meydana geldi, hemen ilgileniyoruz daha sonra tekrar deneyin..',33469)#">
            </cfcatch>  
        </cftry>
        <cfreturn Replace(SerializeJSON(result),'//','')>
    </cffunction>

</cfcomponent>