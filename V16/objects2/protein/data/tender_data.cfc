<cfcomponent extends="cfc.queryJSONConverter">
    <cfset dsn = application.systemParam.systemParam().dsn>
    <cfset result = StructNew()>
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
    <cfset createFunc = createObject( "component", "cfc.functions" )>
    <cfset filterNum = createFunc.filterNum>
    <cfset wrk_round = createFunc.wrk_round>

    <cfset dsn1_alias = "#dsn#_product">
    <cfset dsn_alias = '#dsn#'>
    <cfset dsn2 = dsn2_alias = '#dsn#_#session_base.period_year#_#session_base.OUR_COMPANY_ID#' />
    <cfset dsn3 = dsn3_alias = '#dsn#_#session_base.OUR_COMPANY_ID#' />

    <cffunction name="GET_OFFER" access="remote">
        <cfargument name="keyword">
        <cfargument name="category">
        <cfargument name="deliverdate">
        <cfargument name="startdate">
        <cfquery name="GET_OFFER" datasource="#DSN3#">
            SELECT DISTINCT
                O.OFFER_ID,
                O.WORK_ID,
                O.OFFER_NUMBER,
                O.OFFER_HEAD,
                O.OFFER_DETAIL,
                O.SALES_EMP_ID,
                O.STARTDATE,
                O.DELIVERDATE,
                O.OTHER_MONEY,
                O.OTHER_MONEY_VALUE,
                O.OFFER_STAGE,
                O.OFFER_TO_PARTNER,
                O.OFFER_FINISHDATE,
                O.ACCEPTED_OFFER_ID,
                O.OFFER_DATE,
                O.COMPANY_ID,
                O.PARTNER_ID,
                P.WORK_ID,
                P.WORK_CURRENCY_ID,
                ISNULL(P.ESTIMATED_TIME,0) AS ESTIMATED_TIME,
                PWC.WORK_CAT_ID,
                PWC.WORK_CAT,
                SCV.CUSTOMER_VALUE,
                C.NICKNAME,
                CP.PHOTO,
                CP.COMPANY_PARTNER_NAME,
                CP.COMPANY_PARTNER_SURNAME
            FROM
                OFFER AS O
                LEFT JOIN #dsn_alias#.PRO_WORKS AS P ON O.WORK_ID = P.WORK_ID 
                LEFT JOIN #dsn_alias#.PRO_WORK_CAT AS PWC ON P.WORK_CAT_ID = PWC.WORK_CAT_ID 
                LEFT JOIN #dsn_alias#.COMPANY AS C ON O.COMPANY_ID = C.COMPANY_ID
                LEFT JOIN #dsn_alias#.COMPANY_PARTNER AS CP ON CP.PARTNER_ID = O.PARTNER_ID
                LEFT JOIN #dsn_alias#.SETUP_CUSTOMER_VALUE AS SCV ON SCV.CUSTOMER_VALUE_ID = C.COMPANY_VALUE_ID
            WHERE 
                O.IS_PARTNER_ZONE = 1 
                AND O.IS_PUBLIC_ZONE = 0
                AND OFFER_STATUS = 1
                AND ((O.OFFER_ZONE = 1 AND O.PURCHASE_SALES = 1) OR (O.OFFER_ZONE = 0 AND O.PURCHASE_SALES = 0))
                <cfif not isdefined("arguments.is_offer_id")>
                AND FOR_OFFER_ID IS NULL
                </cfif>
                <cfif isDefined("arguments.keyword") and len(arguments.keyword)>
                     AND (O.OFFER_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%">) 
                </cfif>
                <cfif isDefined("arguments.category") and len(arguments.category)>
                     AND PWC.WORK_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.category#">
                </cfif>
                <cfif isdefined("arguments.startdate") and len(arguments.startdate)>
                    AND O.STARTDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.startdate#"> 
                </cfif>
                <cfif isdefined("arguments.deliverdate") and len(arguments.deliverdate)>
                    AND O.DELIVERDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.deliverdate#">
                </cfif>
                <cfif isdefined("arguments.offer_id") and len(arguments.offer_id)>
                    AND O.OFFER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.offer_id#">
                </cfif>
                <cfif isdefined("arguments.work_id") and len(arguments.work_id)>
                    AND O.WORK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.work_id#">
                </cfif>
                <cfif isDefined("arguments.is_partner") and len(arguments.is_partner) and arguments.is_partner eq 1>
                    AND O.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#">
                    AND O.PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#">
                 </cfif>
            ORDER BY
                OFFER_ID DESC
        </cfquery> 
        <cfreturn GET_OFFER>
    </cffunction> 

    <cffunction name="GET_OFFER_CAT" access="remote">        
        <cfargument name="category">
        <cfquery name="GET_OFFER_CAT" datasource="#DSN#">
            SELECT                
                PWC.WORK_CAT_ID,
                PWC.WORK_CAT,
                OUR_COMPANY_ID
            FROM
                PRO_WORK_CAT PWC 
        </cfquery>	       
        <cfreturn GET_OFFER_CAT>
    </cffunction> 

    <cffunction name="get_work" access="remote">
        <cfquery name="get_work" datasource="#dsn#">
            SELECT ESTIMATED_TIME FROM PRO_WORKS WHERE WORK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.work_id#">
        </cfquery> 
        <cfreturn get_work>
    </cffunction>
    
    <cffunction name="GET_PROCESS" access="remote" returntype="any" hint="Süreç getir">
        <cfquery name="GET_PROCESS" datasource="#dsn#">
            SELECT 
                STAGE 
            FROM 
                PROCESS_TYPE,
                PROCESS_TYPE_ROWS 
            WHERE 
                PROCESS_TYPE_ROWS.PROCESS_ID = PROCESS_TYPE.PROCESS_ID
                <cfif isDefined("arguments.work_currency_id") and len(arguments.work_currency_id)>
                    AND PROCESS_TYPE_ROWS.PROCESS_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.work_currency_id#">
                </cfif>
        </cfquery>
        <cfreturn GET_PROCESS>
   </cffunction>

    <cffunction name="GET_PROCESS_TYPE" access="remote" returntype="any">
        <cfquery name="GET_PROCESS_TYPE" datasource="#dsn#">
            SELECT
                PTR.STAGE,
                PTR.PROCESS_ROW_ID 
            FROM
                PROCESS_TYPE_ROWS PTR,
                PROCESS_TYPE_OUR_COMPANY PTO,
                PROCESS_TYPE PT
            WHERE
                PT.IS_ACTIVE = 1 AND
                PT.PROCESS_ID = PTR.PROCESS_ID AND
                PT.PROCESS_ID = PTO.PROCESS_ID AND
                PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.our_company_id#"> AND
                PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%purchase.list_offer%">
            ORDER BY
                PTR.LINE_NUMBER
        </cfquery>
        <cfreturn GET_PROCESS_TYPE>
    </cffunction>

    <cffunction name="get_coming_offer" access="remote">
        <cfargument name="offer_id" default="">       
        <cfquery name="get_coming_offer" datasource="#dsn3#">
            SELECT 
                FOR_OFFER_ID,
                OFFER_TO_PARTNER,
                OFFER_ID,
                SHIP_METHOD,
                PAYMETHOD,
                OFFER_TO,
                DELIVERDATE,
                DELIVER_PLACE,
                LOCATION_ID,
                OFFER_NUMBER,
                REVISION_NUMBER,
                OTHER_MONEY,
                ( SELECT MAX(OTHER_MONEY_VALUE) AS OMV_MAX FROM OFFER WHERE FOR_OFFER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.offer_id#"> ) AS OM_MAX,
                ( SELECT MIN(OTHER_MONEY_VALUE) AS OMV_MIN FROM OFFER WHERE FOR_OFFER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.offer_id#"> ) AS OM_MIN
            FROM 
                OFFER 
            WHERE 
                FOR_OFFER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.offer_id#">         
            ORDER BY 
                OFFER_TO_PARTNER,
                REVISION_OFFER_ID,
                REVISION_NUMBER
        </cfquery>              
        <cfreturn get_coming_offer>
    </cffunction>   
    
    <!--- <cffunction name="GET_OFFER_DET" access="remote">
        <cfargument name="offer_id" default="">
        <cfquery name="GET_OFFER_DET" datasource="#DSN3#">
            SELECT
                O.OFFER_ID,
                O.WORK_ID,
                O.OFFER_HEAD,
                O.OFFER_DETAIL,
                O.SALES_EMP_ID,
                O.STARTDATE,
                O.OFFER_FINISHDATE,
                O.DELIVERDATE,
                O.OTHER_MONEY,
                O.OTHER_MONEY_VALUE,
                O.OFFER_STAGE,
                O.OFFER_TO_PARTNER,
                O.ACCEPTED_OFFER_ID,
                P.WORK_ID,
                P.WORK_CURRENCY_ID,
                P.ESTIMATED_TIME,
                PWC.WORK_CAT,
                E.PHOTO
            FROM
                OFFER O
                LEFT JOIN #dsn_alias#.PRO_WORKS P ON O.WORK_ID = P.WORK_ID
                LEFT JOIN #dsn_alias#.PRO_WORK_CAT PWC ON P.WORK_CAT_ID = PWC.WORK_CAT_ID 
                LEFT JOIN #dsn_alias#.EMPLOYEES E ON O.SALES_EMP_ID = E.EMPLOYEE_ID 
            WHERE
                O.OFFER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.offer_id#">
            ORDER BY
                OFFER_ID DESC
        </cfquery>	       
        <cfreturn GET_OFFER_DET>
    </cffunction> --->  

    <cffunction name="get_coming_offer_for_main" access="remote">
        <cfargument name="offer_id" default="">       
        <cfquery name="get_coming_offer_for_main" datasource="#dsn3#">
            SELECT 
                OFFER_ID,OFFER_NUMBER,OFFER_HEAD,OFFER_DETAIL,OFFER_TO,OFFER_TO_PARTNER,OTHER_MONEY,OTHER_MONEY_VALUE,REVISION_NUMBER,DELIVERDATE,ACCEPTED_OFFER_ID
            FROM 
                OFFER 
            WHERE 
                FOR_OFFER_ID = #arguments.offer_id# 
            ORDER BY 
                OFFER_TO_PARTNER, REVISION_OFFER_ID, REVISION_NUMBER
        </cfquery>      
        <cfreturn get_coming_offer_for_main>
    </cffunction>  

    <cffunction name="get_finally_coming_offers" access="remote">
        <cfargument name="offer_id" default="">       
        <cfquery name="get_finally_coming_offers" dbtype="query">
            SELECT 
                OFFER_TO,
                OFFER_ID
            FROM 
                get_coming_offer_for_main 
            GROUP BY 
                OFFER_TO,
                OFFER_ID
        </cfquery>          
        <cfreturn get_finally_coming_offers>
    </cffunction>  
    
    
    <cffunction name="get_finally_coming_offers_details" access="remote">
        <cfargument name="OFFER_TO" default="">       
        <cfquery name="get_finally_coming_offers_details" dbtype="query">
            SELECT 
                * 
            FROM 
                get_coming_offer_for_main 
            WHERE 
                OFFER_TO = '#arguments.OFFER_TO#' 
            ORDER BY 
                REVISION_NUMBER DESC
        </cfquery>              
        <cfreturn get_finally_coming_offers_details>
    </cffunction>  

    <cffunction name="get_coming_offer_details" access="remote">
        <cfargument name="offer_id" default="">    
        <cfargument name="offer_ids" default="">    
        <cfquery name="get_coming_offer_details" datasource="#dsn3#">
            SELECT
                ORW.OFFER_ID,
                SUM(((((ORW.QUANTITY*ORW.PRICE)+ ORW.EXTRA_PRICE_TOTAL)/100000000000000000000)*((100-DISCOUNT_1)*(100- DISCOUNT_2)*(100-DISCOUNT_3)*(100-DISCOUNT_4)*(100-DISCOUNT_5)*(100-DISCOUNT_6)*(100-DISCOUNT_7)*(100-DISCOUNT_8)*(100-DISCOUNT_9)*(100-DISCOUNT_10))/ORW.QUANTITY) * ORW.QUANTITY) AS NET_PRICE,
                O.PRICE,
                O.OTHER_MONEY,
                O.OTHER_MONEY_VALUE
            FROM
                OFFER O,
                OFFER_ROW ORW
            WHERE
                O.OFFER_ID = ORW.OFFER_ID AND
                O.FOR_OFFER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.offer_id#"> AND
                O.OFFER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.offer_ids#">
            GROUP BY
                ORW.OFFER_ID, O.PRICE, O.OTHER_MONEY, O.OTHER_MONEY_VALUE
        </cfquery>
        <cfreturn get_coming_offer_details>
    </cffunction>  

    <cffunction name="GET_POSITION_DETAIL" access="remote">
        <cfargument name="sales_emp_id_tender" default="">  
        <cfquery name="GET_POSITION_DETAIL" datasource="#DSN#">
            SELECT
                *
            FROM
                EMPLOYEE_POSITIONS,
                DEPARTMENT,
                BRANCH,
                OUR_COMPANY,
                ZONE
            WHERE
                EMPLOYEE_POSITIONS.DEPARTMENT_ID=DEPARTMENT.DEPARTMENT_ID AND
                DEPARTMENT.BRANCH_ID=BRANCH.BRANCH_ID AND
                OUR_COMPANY.COMP_ID=BRANCH.COMPANY_ID AND
                BRANCH.ZONE_ID=ZONE.ZONE_ID AND 
                EMPLOYEE_POSITIONS.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.sales_emp_id_tender#">
        </cfquery>
        <cfreturn GET_POSITION_DETAIL>
    </cffunction> 

    <cffunction name="UPD_OFFER_PROCESS" access="remote" returntype="string" returnargumentsat="json">
        <cfargument name = "offer_id" default="">
        <cfargument name = "accepted_offer" default="">
        <cfargument name = "offer_stage" default="">
        <cfargument name = "old_process_line" default="">
        <cfargument name = "accepted_date" default="">
        <cfargument name = "startdate" default="">
        <cfargument name = "offer_finishdate" default="">
        
        <cfif len(arguments.accepted_date) and isDate(arguments.accepted_date)>
            <cf_date tarih = 'arguments.accepted_date'>
        </cfif>
        <cfif len(arguments.startdate) and isDate(arguments.startdate)>
            <cf_date tarih = 'arguments.startdate'>
        </cfif>
        <cfif len(arguments.offer_finishdate) and isDate(arguments.offer_finishdate)>
            <cf_date tarih = 'arguments.offer_finishdate'>
        </cfif>
        <cfset status = true>
        <cftry>
            <cflock name="#CreateUUID()#" timeout="20">
                <cftransaction>
                    <cfquery name="UPD_OFFER_PROCESS" datasource="#dsn3#">
                        UPDATE
                            OFFER
                        SET 
                            ACCEPTED_OFFER_ID = <cfif len(arguments.accepted_offer)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.accepted_offer#"><cfelse>NULL</cfif>,
                            OFFER_STAGE = <cfif len(arguments.offer_stage)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.offer_stage#"><cfelse>NULL</cfif>,
                            ACCEPTED_OFFER_DATE = <cfif len(arguments.accepted_date)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.accepted_date#"><cfelse>NULL</cfif>,
                            STARTDATE = <cfif len(arguments.startdate)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.startdate#"><cfelse>NULL</cfif>,
                            OFFER_FINISHDATE = <cfif len(arguments.offer_finishdate)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.offer_finishdate#"><cfelse>NULL</cfif>
                        WHERE
                            OFFER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.offer_id#">
                    </cfquery>
                    <cfquery name="get_offer" datasource="#dsn3#">
                        SELECT OFFER_NUMBER FROM OFFER WHERE OFFER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.offer_id#">
                    </cfquery>
                    
                    <!--- Tarihçe --->
                    <cfquery name="OFFER" datasource="#DSN3#">
                        SELECT * FROM OFFER WHERE OFFER_ID = #arguments.OFFER_ID#
                    </cfquery>
                    <cfquery name="OFFER_ROWS" datasource="#DSN3#">
                        SELECT * FROM OFFER_ROW WHERE OFFER_ID = #arguments.OFFER_ID#
                    </cfquery>
                    <cfquery name="ADD_OFFER_HISTORY" datasource="#DSN3#" result="oh_result">
                        INSERT INTO
                            OFFER_HISTORY
                            (       
                            OFFER_ID,
                            OPP_ID,
                            OFFER_NUMBER,
                            OFFER_STATUS,
                            OFFER_CURRENCY,
                            PURCHASE_SALES,
                            OFFER_ZONE,
                            PRIORITY_ID,
                            OFFER_HEAD,
                            OFFER_DETAIL,
                            GUEST,
                            COMPANY_CAT,
                            CONSUMER_CAT,
                            OFFER_TO,
                            OFFER_TO_PARTNER,
                            OFFER_TO_CONSUMER,
                            CONSUMER_ID,
                            COMPANY_ID,
                            PARTNER_ID,
                            EMPLOYEE_ID,
                            SALES_PARTNER_ID,
                            SALES_EMP_ID,
                            NETTOTAL,
                            OFFER_DATE,
                            STARTDATE,
                            DELIVERDATE,
                            DELIVER_PLACE,
                            FINISHDATE,
                            PRICE,
                            TAX,
                            OTHER_MONEY,
                            CARD_PAYMETHOD_ID,
                            CARD_PAYMETHOD_RATE,
                            PAYMETHOD,
                            COMMETHOD_ID,
                            IS_PROCESSED,
                            IS_PARTNER_ZONE,
                            IS_PUBLIC_ZONE,
                            INCLUDED_KDV,
                            RECORD_EMP,
                            RECORD_DATE,
                            RECORD_IP,
                            SHIP_METHOD,
                            SHIP_ADDRESS,
                            PROJECT_ID,
                            WORK_ID,
                            OFFER_STAGE
                            )
                        VALUES
                            (     
                            #arguments.OFFER_ID#,
                            <cfif len(OFFER.OPP_ID)>#OFFER.OPP_ID#<cfelse>NULL</cfif>,
                            '#OFFER.OFFER_NUMBER#',
                            <cfif Len(OFFER.OFFER_STATUS)>#OFFER.OFFER_STATUS#<cfelse>NULL</cfif>,
                            <cfif len(OFFER.OFFER_CURRENCY)>#OFFER.OFFER_CURRENCY#<cfelse>NULL</cfif>,
                            #OFFER.PURCHASE_SALES#,
                            <cfif Len(OFFER.OFFER_ZONE)>#OFFER.OFFER_ZONE#<cfelse>NULL</cfif>,
                            <cfif len(OFFER.PRIORITY_ID)>#OFFER.PRIORITY_ID#<cfelse>NULL</cfif>,
                            '#OFFER.OFFER_HEAD#',
                            '#OFFER.OFFER_DETAIL#',
                            <cfif len(OFFER.GUEST)>#OFFER.GUEST#<cfelse>NULL</cfif>,
                            <cfif len(OFFER.COMPANY_CAT)>'#OFFER.COMPANY_CAT#'<cfelse>NULL</cfif>,
                            <cfif len(OFFER.CONSUMER_CAT)>'#OFFER.CONSUMER_CAT#'<cfelse>NULL</cfif>,
                            <cfif len(OFFER.OFFER_TO)>'#OFFER.OFFER_TO#'<cfelse>NULL</cfif>,
                            <cfif len(OFFER.OFFER_TO_PARTNER)>'#OFFER.OFFER_TO_PARTNER#'<cfelse>NULL</cfif>,
                            <cfif len(OFFER.OFFER_TO_CONSUMER)>'#OFFER.OFFER_TO_CONSUMER#'<cfelse>NULL</cfif>,
                            <cfif len(OFFER.CONSUMER_ID)>#OFFER.CONSUMER_ID#<cfelse>NULL</cfif>,
                            <cfif len(OFFER.COMPANY_ID)>#OFFER.COMPANY_ID#<cfelse>NULL</cfif>,
                            <cfif len(OFFER.PARTNER_ID)>#OFFER.PARTNER_ID#<cfelse>NULL</cfif>,
                            <cfif len(OFFER.EMPLOYEE_ID)>#OFFER.EMPLOYEE_ID#<cfelse>NULL</cfif>,
                            <cfif len(OFFER.SALES_PARTNER_ID)>#OFFER.SALES_PARTNER_ID#<cfelse>NULL</cfif>,
                            <cfif len(OFFER.SALES_EMP_ID)>#OFFER.SALES_EMP_ID#<cfelse>NULL</cfif>,
                            <cfif len(OFFER.NETTOTAL)>#OFFER.NETTOTAL#<cfelse>NULL</cfif>,
                            <cfif len(OFFER.OFFER_DATE)>#CreateODBCDateTime(OFFER.OFFER_DATE)#<cfelse>NULL</cfif>,
                            <cfif len(OFFER.STARTDATE)>#CreateODBCDateTime(OFFER.STARTDATE)#<cfelse>NULL</cfif>,
                            <cfif len(OFFER.DELIVERDATE)>#CreateODBCDateTime(OFFER.DELIVERDATE)#<cfelse>NULL</cfif>,
                            <cfif len(OFFER.DELIVER_PLACE)>#OFFER.DELIVER_PLACE#<cfelse>NULL</cfif>,
                            <cfif len(OFFER.FINISHDATE)>#CreateODBCDateTime(OFFER.FINISHDATE)#<cfelse>NULL</cfif>,
                            <cfif len(OFFER.PRICE)>#OFFER.PRICE#<cfelse>NULL</cfif>,
                            <cfif len(OFFER.TAX)>#OFFER.TAX#<cfelse>NULL</cfif>,
                            <cfif len(OFFER.OTHER_MONEY)>'#OFFER.OTHER_MONEY#'<cfelse>NULL</cfif>,
                            <cfif len(OFFER.CARD_PAYMETHOD_ID)>#OFFER.CARD_PAYMETHOD_ID#<cfelse>NULL</cfif>,
                            <cfif len(OFFER.CARD_PAYMETHOD_RATE)>#OFFER.CARD_PAYMETHOD_RATE#<cfelse>NULL</cfif>,
                            <cfif len(OFFER.PAYMETHOD)>#OFFER.PAYMETHOD#<cfelse>NULL</cfif>,
                            <cfif len(OFFER.COMMETHOD_ID)>#OFFER.COMMETHOD_ID#<cfelse>NULL</cfif>,
                            <cfif Len(OFFER.IS_PROCESSED)>#OFFER.IS_PROCESSED#<cfelse>NULL</cfif>,
                            <cfif len(OFFER.IS_PARTNER_ZONE)>#OFFER.IS_PARTNER_ZONE#<cfelse>NULL</cfif>,
                            <cfif len(OFFER.IS_PUBLIC_ZONE)>#OFFER.IS_PUBLIC_ZONE#<cfelse>NULL</cfif>,
                            <cfif len(OFFER.INCLUDED_KDV)>#OFFER.INCLUDED_KDV#<cfelse>NULL</cfif>,
                            #session.pp.userid#,
                            #now()#,
                            '#cgi.REMOTE_ADDR#',
                            <cfif len(OFFER.SHIP_METHOD)>#OFFER.SHIP_METHOD#<cfelse>NULL</cfif>,
                            <cfif len(OFFER.SHIP_ADDRESS)>'#OFFER.SHIP_ADDRESS#'<cfelse>NULL</cfif>,
                            <cfif len(OFFER.PROJECT_ID)>#OFFER.PROJECT_ID#<cfelse>NULL</cfif>,
                            <cfif len(OFFER.WORK_ID)>#OFFER.WORK_ID#<cfelse>NULL</cfif>,
                            <cfif len(OFFER.OFFER_STAGE)>#OFFER.OFFER_STAGE#<cfelse>NULL</cfif>
                            )
                    </cfquery>
                    <cfloop query="OFFER_ROWS">
                        <cfquery name="ADD_OFFER_ROW_HISTORY" datasource="#DSN3#" result="oh_result">
                            INSERT INTO
                                OFFER_ROW_HISTORY
                                (
                                
                                OFFER_ID,
                                OFFER_ROW_ID,
                                PRODUCT_ID,
                                STOCK_ID,
                                QUANTITY,
                                UNIT,
                                PRICE,
                                TAX,
                                DUEDATE,
                                PRODUCT_NAME,
                                DESCRIPTION,
                                PAY_METHOD_ID,
                                PARTNER_ID,
                                DELIVER_DATE,
                                DELIVER_DEPT,
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
                                LIST_PRICE,
                                NUMBER_OF_INSTALLMENT,
                                PRICE_CAT,
                                CATALOG_ID,
                                KARMA_PRODUCT_ID,
                                OTV_ORAN,
                                OTVTOTAL,
                                WIDTH_VALUE,
                                DEPTH_VALUE,
                                HEIGHT_VALUE,
                                ROW_PROJECT_ID
                                )
                            VALUES
                                (
                                
                                #arguments.OFFER_ID#,
                                #OFFER_ROW_ID#,
                                #PRODUCT_ID#,
                                #STOCK_ID#,
                                #QUANTITY#,
                                <cfif len(UNIT)>'#UNIT#'<cfelse>NULL</cfif>,
                                <cfif len(PRICE)>#PRICE#<cfelse>NULL</cfif>,
                                <cfif len(TAX)>#TAX#<cfelse>NULL</cfif>,
                                <cfif len(DUEDATE)>#DUEDATE#<cfelse>NULL</cfif>,
                                <cfif len(PRODUCT_NAME)>'#PRODUCT_NAME#'<cfelse>NULL</cfif>,
                                <cfif len(DESCRIPTION)>'#DESCRIPTION#'<cfelse>NULL</cfif>,
                                <cfif len(PAY_METHOD_ID)>#PAY_METHOD_ID#<cfelse>NULL</cfif>,
                                <cfif len(PARTNER_ID)>#PARTNER_ID#<cfelse>NULL</cfif>,
                                <cfif len(DELIVER_DATE)>#CreateODBCDateTime(DELIVER_DATE)#<cfelse>NULL</cfif>,
                                <cfif len(DELIVER_DEPT)>#DELIVER_DEPT#<cfelse>NULL</cfif>,
                                <cfif len(DISCOUNT_1)>#DISCOUNT_1#<cfelse>0</cfif>,
                                <cfif len(DISCOUNT_2)>#DISCOUNT_2#<cfelse>0</cfif>,
                                <cfif len(DISCOUNT_3)>#DISCOUNT_3#<cfelse>0</cfif>,
                                <cfif len(DISCOUNT_4)>#DISCOUNT_4#<cfelse>0</cfif>,
                                <cfif len(DISCOUNT_5)>#DISCOUNT_5#<cfelse>0</cfif>,			
                                <cfif len(DISCOUNT_6)>#DISCOUNT_6#<cfelse>0</cfif>,
                                <cfif len(DISCOUNT_7)>#DISCOUNT_7#<cfelse>0</cfif>,
                                <cfif len(DISCOUNT_8)>#DISCOUNT_8#<cfelse>0</cfif>,
                                <cfif len(DISCOUNT_9)>#DISCOUNT_9#<cfelse>0</cfif>,
                                <cfif len(DISCOUNT_10)>#DISCOUNT_10#<cfelse>0</cfif>,			
                                <cfif len(OTHER_MONEY)>'#OTHER_MONEY#'<cfelse>NULL</cfif>,
                                <cfif len(OTHER_MONEY_VALUE)>#OTHER_MONEY_VALUE#<cfelse>NULL</cfif>,
                                <cfif len(SPECT_VAR_ID)>#SPECT_VAR_ID#<cfelse>NULL</cfif>,
                                    '#SPECT_VAR_NAME#',
                                <cfif len(PRICE_OTHER)>#PRICE_OTHER#<cfelse>0</cfif>,
                                <cfif len(UNIQUE_RELATION_ID)>'#UNIQUE_RELATION_ID#'<cfelse>NULL</cfif>,
                                <cfif len(PRODUCT_NAME2)>'#PRODUCT_NAME2#'<cfelse>NULL</cfif>,
                                <cfif len(AMOUNT2)>#AMOUNT2#<cfelse>NULL</cfif>,
                                <cfif len(UNIT2)>'#UNIT2#'<cfelse>NULL</cfif>,
                                <cfif len(EXTRA_PRICE)>#EXTRA_PRICE#<cfelse>NULL</cfif>,
                                <cfif len(EXTRA_PRICE_TOTAL)>#EXTRA_PRICE_TOTAL#<cfelse>NULL</cfif>,
                                <cfif len(EXTRA_PRICE_OTHER_TOTAL)>#EXTRA_PRICE_OTHER_TOTAL#<cfelse>NULL</cfif>,
                                <cfif len(SHELF_NUMBER)>'#SHELF_NUMBER#'<cfelse>NULL</cfif>,
                                <cfif len(PRODUCT_MANUFACT_CODE)>'#PRODUCT_MANUFACT_CODE#'<cfelse>NULL</cfif>,
                                <cfif len(BASKET_EXTRA_INFO_ID)>#BASKET_EXTRA_INFO_ID#<cfelse>NULL</cfif>,
                                <cfif len(SELECT_INFO_EXTRA)>#SELECT_INFO_EXTRA#<cfelse>NULL</cfif>,
                                <cfif len(DETAIL_INFO_EXTRA)>'#DETAIL_INFO_EXTRA#'<cfelse>NULL</cfif>,
                                <cfif len(LIST_PRICE)>#LIST_PRICE#<cfelse>NULL</cfif>,
                                <cfif len(NUMBER_OF_INSTALLMENT)>#NUMBER_OF_INSTALLMENT#<cfelse>NULL</cfif>,
                                <cfif len(PRICE_CAT)>#PRICE_CAT#<cfelse>NULL</cfif>,
                                <cfif len(CATALOG_ID)>#CATALOG_ID#<cfelse>NULL</cfif>,
                                <cfif len(KARMA_PRODUCT_ID)>#KARMA_PRODUCT_ID#<cfelse>NULL</cfif>,
                                <cfif len(OTV_ORAN)>#OTV_ORAN#<cfelse>NULL</cfif>,
                                <cfif len(OTVTOTAL)>#OTVTOTAL#<cfelse>NULL</cfif>,
                                <cfif len(WIDTH_VALUE)>#WIDTH_VALUE#<cfelse>NULL</cfif>,
                                <cfif len(DEPTH_VALUE)>#DEPTH_VALUE#<cfelse>NULL</cfif>,
                                <cfif len(HEIGHT_VALUE)>#HEIGHT_VALUE#<cfelse>NULL</cfif>,
                                <cfif len(ROW_PROJECT_ID)>#ROW_PROJECT_ID#<cfelse>NULL</cfif>
                                )
                        </cfquery>
                    </cfloop>
                </cftransaction>
            </cflock>
            <cfset result.status = true>
            <cfset result.success_message = "Kaydı Yapıldı, Yönlendiriliyor">
            
            <cfcatch type="any">
                <cfset result.status = false>
                <cfset result.danger_message = "Şuanda işlem yapılamıyor...">
                <cfset result.error = cfcatch >
            </cfcatch>  
        </cftry>
        <cfreturn Replace(SerializeJSON(result),'//','')>
    </cffunction>

    <cffunction name="ADD_OFFER" access="remote" returntype="string" returnformat="JSON">
        <cfset response = structNew()>

        <cfif isdefined("arguments.for_offer_id") and len(arguments.for_offer_id)>
            <cfquery name="get_offer" datasource="#dsn3#">
                SELECT STOCK_ID FROM OFFER_ROW WHERE OFFER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.for_offer_id#">
            </cfquery>
            <cfset arguments.stock_id = get_offer.STOCK_ID>
        </cfif>
        <cftransaction>
            <cftry>
                <cfquery name="GET_OFFER_CODE" datasource="#DSN3#">
                    SELECT OFFER_NO, OFFER_NUMBER FROM GENERAL_PAPERS WHERE PAPER_TYPE = 0 AND ZONE_TYPE = 0
                </cfquery>
                <cfquery name="UPD_OFFER_CODE" datasource="#DSN3#">
                    UPDATE GENERAL_PAPERS SET OFFER_NUMBER = OFFER_NUMBER+1 WHERE PAPER_TYPE = 0 AND ZONE_TYPE = 0
                </cfquery>
                <cfquery name="get_prod_info" datasource="#dsn3#">
                    SELECT * FROM STOCKS AS S 
                    LEFT JOIN PRODUCT_UNIT AS PU 
                    ON S.PRODUCT_ID = PU.PRODUCT_ID 
                    WHERE S.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.stock_id#"> AND IS_MAIN = 1
                </cfquery>
                <cfquery name="ADD_OFFER" datasource="#DSN3#" result="MAX_ID">
                    INSERT INTO 
                        OFFER 
                        (
                            OFFER_STATUS,
                            OFFER_CURRENCY,
                            OFFER_NUMBER,    
                            INCLUDED_KDV,
                            DELIVERDATE,
                            DELIVER_PLACE,
                            LOCATION_ID,
                            PURCHASE_SALES,
                            STARTDATE,
                            FINISHDATE,
                            OFFER_FINISHDATE,
                            IS_PUBLIC_ZONE,
                            IS_PARTNER_ZONE, 
                            OFFER_HEAD,
                            OFFER_DETAIL,
                            SALES_EMP_ID,
                            OTHER_MONEY,
                            OTHER_MONEY_VALUE,
                            OFFER_STAGE,
                            OFFER_DATE,
                            PRIORITY_ID,
                            PRICE,
                            RECORD_DATE,						
                            RECORD_IP,
                            SHIP_METHOD,
                            DUE_DATE,
                            PROJECT_ID,
                            INTERNALDEMAND_ID,
                            FOR_OFFER_ID,
                            REF_NO,
                            WORK_ID,
                            <cfif isdefined("arguments.for_offer_id") and len(arguments.for_offer_id)>
                            OFFER_TO,
                            OFFER_TO_PARTNER
                            <cfelse>
                            COMPANY_ID,
                            PARTNER_ID
                            </cfif>
                        )
                    VALUES 
                        (
                            1,
                            1,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_OFFER_CODE.OFFER_NO#-#GET_OFFER_CODE.OFFER_NUMBER#">,
                            0,
                            <cfif isdefined("arguments.deliverdate") and isdate(arguments.deliverdate)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.deliverdate#"><cfelse>NULL</cfif>,
                            0,
                            NULL,
                            0,
                            <cfif isdefined("arguments.startdate") and isdate(arguments.startdate)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.startdate#"><cfelse>NULL</cfif>,
                            NULL,
                            <cfif isdefined("arguments.offer_finishdate") and isdate(arguments.offer_finishdate)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.offer_finishdate#"><cfelse>NULL</cfif>,
                            0,
                            1,
                            <cfqueryparam cfsqltype="cf_sql_nvarchar" value="PROTEIN - B2B PORTAL IHALE">,
                            <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.OFFER_DETAIL#">,
                            NULL,
                            <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.money#">,
                            <cfif len(arguments.price_tutar)><cfqueryparam cfsqltype="cf_sql_float" value="#filterNum(arguments.price_tutar)#"><cfelse>0</cfif>,
                            NULL,
                            #now()#,
                            NULL,
                            0,
                            #now()#,
                            <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#REMOTE_ADDR#">,
                            NULL,
                            NULL,
                            NULL,
                            NULL,
                            <cfif isdefined("arguments.for_offer_id") and len(arguments.for_offer_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#for_offer_id#"><cfelse>NULL</cfif>,
                            NULL,
                            <cfif isdefined("arguments.work_id") and len(arguments.work_id)>#arguments.work_id#<cfelse>NULL</cfif>,
                            #session.pp.company_id#,
                            #session.pp.userid#
                        )
                </cfquery>
                <cfquery name="ADD_PRODUCT_TO_OFFER" datasource="#DSN3#">
                    INSERT INTO 
                        OFFER_ROW(
                        OFFER_ID, 
                        PRODUCT_ID,
                        STOCK_ID,
                        QUANTITY,
                        UNIT,
                        UNIT_ID,
                        PRICE,
                        TAX,
                        DUEDATE,
                        PRODUCT_NAME,
                        DELIVER_DATE,
                        DELIVER_DEPT,
                        DELIVER_LOCATION,
                        OTHER_MONEY,
                        PRICE_OTHER,
                        EXTRA_PRICE_TOTAL
                        )
                    VALUES 
                        (
                        #MAX_ID.IDENTITYCOL#,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#get_prod_info.PRODUCT_ID#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#get_prod_info.STOCK_ID#">,
                        1,
                        <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#get_prod_info.ADD_UNIT#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#get_prod_info.PRODUCT_UNIT_ID#">,		
                        <cfif len(arguments.price_tutar)><cfqueryparam cfsqltype="cf_sql_float" value="#filterNum(arguments.price_tutar)#"><cfelse>0</cfif>,
                        18,
                        NULL,					
                        <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#get_prod_info.PRODUCT_NAME#">,
                        NULL,
                        NULL,
                        NULL,
                        <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.money#">,
                        <cfif len(arguments.price_tutar)><cfqueryparam cfsqltype="cf_sql_float" value="#filterNum(arguments.price_tutar)#"><cfelse>0</cfif>,
                        0
                    )
                </cfquery>
                    <cfset response.status = 1>
                    <cfif isdefined("arguments.for_offer_id") and len(arguments.for_offer_id)>
                        <cfset response.message = "Belirtilen ihaleye teklifiniz oluşturulmuştur, tekliflerim ekranından takibini sağlayabilirsiniz">
                    <cfelse>
                        <cfset response.message = "Talebiniz ihaleye çıkarılmıştır, ihalelerim ekranından takibini sağlayabilirsiniz">
                    </cfif>
                <cfcatch>
                    <cfset response.status = 0>
                    <cfif isdefined("arguments.for_offer_id") and len(arguments.for_offer_id)>
                        <cfset response.message = "Belirtilen ihaleye teklifiniz oluşturulamadı. Sistem yöneticisi ile iletişime geçiniz">
                    <cfelse>
                        <cfset response.message = "Talebiniz ihaleye çıkarılamadı. Sistem yöneticisi ile iletişime geçiniz">
                    </cfif>
                </cfcatch>
            </cftry>
            <cfreturn replace(SerializeJSON(response),"//","")>
        </cftransaction>
    </cffunction>

    <cffunction name="UPD_OFFER" access="remote" returntype="string" returnformat="JSON">
        <cfset response = structNew()>
        <cftransaction>
            <cftry>
                <cfquery name="UPD_OFFER" datasource="#dsn3#">
                    UPDATE
                        OFFER
                    SET 
                        DELIVERDATE = <cfif isdefined("arguments.deliverdate") and isdate(arguments.deliverdate)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.deliverdate#"><cfelse>NULL</cfif>,
                        OFFER_DETAIL = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.OFFER_DETAIL#">,
                        OTHER_MONEY = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.money#">,
                        OTHER_MONEY_VALUE =  <cfif len(arguments.price_tutar)><cfqueryparam cfsqltype="cf_sql_float" value="#filterNum(arguments.price_tutar)#"><cfelse>0</cfif>,
                        STARTDATE = <cfif isdefined("arguments.startdate") and isdate(arguments.startdate)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.startdate#"><cfelse>NULL</cfif>,
                        OFFER_FINISHDATE = <cfif isdefined("arguments.offer_finishdate") and isdate(arguments.offer_finishdate)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.offer_finishdate#"><cfelse>NULL</cfif>
                    WHERE
                        OFFER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.offer_id#">
                </cfquery>
                <cfquery name="UPD_OFFER_ROW" datasource="#dsn3#">
                    UPDATE
                        OFFER_ROW
                    SET 
                        PRICE = <cfif len(arguments.price_tutar)><cfqueryparam cfsqltype="cf_sql_float" value="#filterNum(arguments.price_tutar)#"><cfelse>0</cfif>,
                        OTHER_MONEY = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.money#">,
                        PRICE_OTHER = <cfif len(arguments.price_tutar)><cfqueryparam cfsqltype="cf_sql_float" value="#filterNum(arguments.price_tutar)#"><cfelse>0</cfif>
                    WHERE
                        OFFER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.offer_id#">
                </cfquery>
                    <cfset response.status = 1>
                    <cfset response.message = "İhale talebiniz güncellenmiştir, ihalelerim ekranından takibini sağlayabilirsiniz">
                <cfcatch>
                    <cfset response.status = 0>
                    <cfset response.message = "İhale talebiniz güncellenemedi. Sistem yöneticisi ile iletişime geçiniz">
                </cfcatch>
            </cftry>
            <cfreturn replace(SerializeJSON(response),"//","")>
        </cftransaction>
    </cffunction>

    <cffunction name="ADD_TOPIC" access="remote" returntype="string" returnargumentsat="json">
        <cfset result = structNew()>
        <cftry> 
            <cftransaction>
                <cfquery name="ADD_TOPIC" datasource="#dsn3#" result="MAX_ID">
                    INSERT INTO 
                        QUESTION_FOR_TENDER(
                            USERKEY,
                            OFFER_ID,
                            MESSAGE,
                            IS_SUB,
                            REPLY_ID,
                            RECORD_DATE,
                            RECORD_EMP,
                            RECORD_IP               
                        )
                    VALUES(
                        <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#session.pp.USERKEY#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.offer_id#">,
                        <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.topic#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.is_sub#">,
                        <cfif isdefined("arguments.reply_id")><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.reply_id#"><cfelse>NULL</cfif>,
                        #now()#,
                        #session_base.userid#,
                        <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#CGI.REMOTE_ADDR#">
                        )						
                </cfquery>
            </cftransaction>
            <cfset result.status = true>
            <cfset result.success_message = "Kaydı Yapıldı, Yönlendiriliyor">
            <cfset result.identity = arguments.offer_id>
            <cfcatch type="any">
                <cfset result.status = false>
                <cfset result.danger_message = "Şuanda işlem yapılamıyor...">
                <cfset result.error = cfcatch >
            </cfcatch>  
        </cftry>
        <cfreturn Replace(SerializeJSON(result),'//','')>
    </cffunction>

    <cffunction name="select_topic" access="public" returntype="any">

        <cfargument name="offer_id" default="">
        <cfargument name="startrow" default="0">
        <cfargument name="maxrows" default="0">
        <cfargument name="is_sub" default="">
    
        <cfquery name="select_topic" datasource="#dsn3#">
            WITH CTE1 AS(    
                SELECT 
                    *          
                FROM 
                    QUESTION_FOR_TENDER
                WHERE 
                    OFFER_ID = <cfqueryparam CFSQLType="cf_sql_integer" value="#arguments.offer_id#">
                    <cfif len(arguments.is_sub)>
                        AND IS_SUB = <cfqueryparam CFSQLType="cf_sql_integer"  value="#arguments.is_sub#">
                    </cfif>
                    <cfif isDefined("arguments.reply_id") and len(arguments.reply_id)>
                        AND REPLY_ID = <cfqueryparam CFSQLType="cf_sql_integer"  value="#arguments.reply_id#">
                    </cfif>
            ),
            CTE2 AS (
                        SELECT
                            CTE1.*,
                            ROW_NUMBER() OVER (	 
                                    ORDER BY
                                        RECORD_DATE DESC						    							    
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
                        RowNum BETWEEN #arguments.startrow# and #arguments.startrow#+(#arguments.maxrows#-1)
        </cfquery>
    
        <cfreturn select_topic>
    
    </cffunction>

    <cffunction name = "get_user_info" returnType = "any" access = "public" description = "Get user info">
        <cfargument name="userkey" type="string" required="true" displayname="user key string">
        
        <cfif arguments.userkey contains "e">
            <cfquery name="USERINFO" datasource="#DSN#">
                SELECT
                    EMPLOYEE_ID,
                    EMPLOYEE_NAME AS NAME,
                    EMPLOYEE_SURNAME AS SURNAME,
                    EMPLOYEE_EMAIL AS EMAIL,
                    'ÇALIŞAN' AS MEMBER_TYPE,
                    PHOTO
                FROM
                    EMPLOYEES
                WHERE
                    EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listlast(arguments.userkey,"-")#">
            </cfquery>	
        <cfelseif arguments.userkey contains "p">
            <cfquery name="USERINFO" datasource="#DSN#">
                SELECT
                    PARTNER_ID,
                    COMPANY_PARTNER_NAME AS NAME,
                    COMPANY_PARTNER_SURNAME AS SURNAME,
                    COMPANY_PARTNER_EMAIL AS EMAIL,
                    'PARTNER' AS MEMBER_TYPE,
                    PHOTO  
                FROM
                    COMPANY_PARTNER
                WHERE
                    PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listlast(arguments.userkey,"-")#">
            </cfquery>	
        <cfelseif arguments.userkey contains "c">
            <cfquery name="USERINFO" datasource="#DSN#">
                SELECT
                    CONSUMER_ID,
                    CONSUMER_NAME AS NAME,
                    CONSUMER_SURNAME AS SURNAME,
                    CONSUMER_EMAIL AS EMAIL,
                    'MÜŞTERI' AS MEMBER_TYPE,
                    PICTURE AS PHOTO
                FROM
                    CONSUMER
                WHERE
                    CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listlast(arguments.userkey,"-")#">
            </cfquery>	
        </cfif>

        <cfreturn USERINFO> 

    </cffunction>

</cfcomponent>