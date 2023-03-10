<!---
File: offer_manaagement.cfc
Author: Workcube-Botan Kaygan <botankaygan@workcube.com>
Date: 19.12.2019
Controller: -
Description: -
--->
<cfcomponent>
    <cfset dsn = application.systemParam.systemParam().dsn>
    <cfset dsn_alias = application.systemParam.systemParam().dsn>
    <cfset dsn3 = "#dsn#_#session.ep.company_id#">
    <cfset user_domain = application.systemParam.systemParam().user_domain>
    <cfset dir_seperator = application.systemParam.systemParam().dir_seperator>
    <cfset date_add = createObject("component","WMO.functions").date_add>
    <cfset request.self = application.systemParam.systemParam().request.self>
    <cfset file_web_path = application.systemParam.systemParam().file_web_path>
    <cffunction name="UPD_OFFER_PROCESS" access="remote" returnformat="JSON" returntype="string">
        <cfargument name = "offer_id" default="">
        <cfargument name = "accepted_offer" default="">
        <cfargument name = "offer_stage" default="">
        <cfargument name = "old_process_line" default="">
        <cfargument name = "accepted_date" default="">
        <cfargument name = "fuseaction" default="">
        <cfif len(arguments.accepted_date) and isDate(arguments.accepted_date)>
            <cf_date tarih = 'arguments.accepted_date'>
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
                            ACCEPTED_OFFER_DATE = <cfif len(arguments.accepted_date)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.accepted_date#"><cfelse>NULL</cfif>
                        WHERE
                            OFFER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.offer_id#">
                    </cfquery>
                    <cfquery name="get_offer" datasource="#dsn3#">
                        SELECT OFFER_NUMBER FROM OFFER WHERE OFFER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.offer_id#">
                    </cfquery>
                    <cfset attributes.fuseaction = arguments.fuseaction>
                    <cfset FUSEBOX.PROCESS_TREE_CONTROL = application.systemParam.systemParam().fusebox.process_tree_control>
                    <cf_workcube_process 
                        is_upd='1' 
                        data_source='#dsn3#' 
                        process_stage='#arguments.offer_stage#' 
                        old_process_line='#arguments.old_process_line#'
                        record_member='#session.ep.userid#'
                        record_date='#now()#' 
                        action_table='OFFER'
                        action_column='OFFER_ID'
                        action_id='#arguments.offer_id#' 
                        action_page='index.cfm?fuseaction=purchase.list_offer&event=det&offer_id=#arguments.offer_id#' 
                        warning_description='Teklif : #get_offer.offer_number#'>
                    <!--- Tarih??e --->
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
                            #session.ep.userid#,
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
            <cfcatch type="any">
                <cfset status = false>
            </cfcatch>
        </cftry>
        <cfreturn replace(serializeJSON(status),"//","")>
    </cffunction>
    <cffunction name="UPD_FOR_OFFER" access="remote" returnformat="JSON" returntype="string">
        <cfargument name = "offer_id" default="">
        <cfargument name = "for_offer_id" default="">
        <cfset status = true>
        <cftry>
            <cfquery name="UPD_FOR_OFFER" datasource="#dsn3#">
                UPDATE
                    OFFER
                SET 
                    FOR_OFFER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes">
                WHERE
                    OFFER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.offer_id#"> AND
                    FOR_OFFER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.for_offer_id#">
            </cfquery>>
            <cfcatch type="any">
                <cfset status = false>
            </cfcatch>
        </cftry>
        <cfreturn replace(serializeJSON(status),"//","")>
    </cffunction>

    <cffunction name="updOfferRowAccepted" access="remote" returnformat="JSON">
        <cfargument name = "for_offer_id" default="">
        <cfargument name = "is_accept_offer" default="">
        <cfset result = structNew()>
        <cfset result.status = true>
        <cftry>
            <cftransaction>
                <cfquery name="updOfferRowAccepted" datasource="#dsn3#">
                    UPDATE
                        ORW
                    SET
                        ORW.IS_ACCEPTED_ROW = 0
                    FROM
                        OFFER_ROW ORW
                        LEFT JOIN OFFER O ON O.OFFER_ID = ORW.OFFER_ID
                    WHERE
                        O.FOR_OFFER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.for_offer_id#">
                </cfquery>
                <cfif len(arguments.is_accept_offer)>
                    <cfquery name="updOfferRowAccepted" datasource="#dsn3#">
                        UPDATE
                            OFFER_ROW
                        SET
                            IS_ACCEPTED_ROW = 1
                        WHERE
                            OFFER_ROW_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.is_accept_offer#" list="yes">)
                    </cfquery>
                </cfif>
            </cftransaction>
            <cfcatch type="any">
                <cfset result.status = false>
            </cfcatch>
        </cftry>

        <cfreturn LCase(Replace(serializeJSON(result), "//", ""))>
    
    </cffunction>
</cfcomponent>