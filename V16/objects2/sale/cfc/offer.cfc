<cfcomponent>
    <cfif isdefined("session.pp")>
        <cfset session_base = evaluate('session.pp')>
    <cfelseif isdefined("session.ep")>
        <cfset session_base = evaluate('session.ep')>
    <cfelseif isdefined("session.ww")>
        <cfset session_base = evaluate('session.ww')>
    </cfif>
    <cfset dsn = application.systemParam.systemParam().dsn>
    <cfset dsn1 = '#dsn#_product'>
    <cfset dsn2 = '#dsn#_#session_base.period_year#_#session_base.our_company_id#'>
    <cfset dsn3 = '#dsn#_#session_base.our_company_id#'>

    <cffunction name="GET_OFFER_LIST" access="remote" returntype="any">
        <cfargument name="offer_stage">
        <cfargument name="keyword">
        <cfargument name="status">
        <cfargument name="start_date">
        <cfargument name="finish_date">
        <cfquery name="GET_OFFER_LIST" datasource="#DSN3#">
            SELECT DISTINCT
                OFFER.OFFER_ID,
                OFFER.OFFER_NUMBER, 
                OFFER.RECORD_DATE, 
                OFFER.OFFER_HEAD,
                OFFER.NETTOTAL,
                OFFER.OFFER_DATE,
                OFFER.PARTNER_ID,
                OFFER.CONSUMER_ID,
                OFFER.OTHER_MONEY,
                OFFER.OTHER_MONEY_VALUE,
                OFFER.IS_PROCESSED,
                OFFER.PRICE,
                OFFER.OFFER_STAGE,
                OFFER.UPDATE_DATE
            FROM 
                <cfif isDefined("arguments.offer_stage") and len(arguments.offer_stage)>
                    OFFER_ROW,
                </cfif>
                OFFER
            WHERE
                <!--- teklifden siparise donen kayitlari getirme --->
                <cfif isdefined("session.pp.company_id")>
                    (
                         OFFER.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#"> OR
                         OFFER.SALES_PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#">
                    ) AND
                    OFFER_ID NOT IN(SELECT OFFER_ID FROM ORDERS WHERE OFFER_ID IS NOT NULL AND OFFER_ID <> 0 AND
                    ORDERS.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#">)
                <cfelseif  isdefined("session.ww.userid")>
                    OFFER.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#"> AND
                    OFFER_ID NOT IN(SELECT OFFER_ID FROM ORDERS WHERE OFFER_ID IS NOT NULL AND OFFER_ID <> 0 AND ORDERS.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#">)
                </cfif>
                <cfif isDefined("arguments.keyword") and len(arguments.keyword)>
                     AND (OFFER.OFFER_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%"> OR OFFER.OFFER_NUMBER LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%">) 
                </cfif>
                <cfif isDefined("arguments.offer_stage") and len(arguments.offer_stage)>
                     AND OFFER.OFFER_ID = OFFER_ROW.OFFER_ID
                     AND OFFER.OFFER_STAGE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.offer_stage#">
                </cfif>
                <cfif isDefined("arguments.STATUS") and len(arguments.STATUS)>
                     AND OFFER.OFFER_STATUS = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.STATUS#">
                </cfif>
                <cfif isdefined("arguments.start_date") and len(arguments.start_date)>
                    AND OFFER.OFFER_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.start_date#"> 
                </cfif>
                <cfif isdefined("arguments.finish_date") and len(arguments.finish_date)>
                    AND OFFER.OFFER_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.finish_date#">
                </cfif>
            ORDER BY 
                OFFER_DATE DESC
        </cfquery>
        <cfreturn GET_OFFER_LIST>
    </cffunction>

    <cffunction name="hesapla_total" access="remote" returntype="any">
        <cfargument name="int_off_id" type="numeric">
        <cfif len(arguments.int_off_id)>
           <cfquery name="GET_TOTAL" datasource="#DSN3#">
                SELECT
                    SUM(PRICE) AS PRICE
                FROM
                    OFFER_ROW
                WHERE		
                    OFFER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.int_off_id#">
           </cfquery>
        </cfif>
        <cfreturn GET_TOTAL.PRICE>
    </cffunction>

    <cffunction name="GET_OFFERS_STAGE" access="remote" returntype="any">
        <cfargument name="my_our_comp_">
        <cfargument name="stage_list">
        <cfquery name="GET_OFFERS_STAGE" datasource="#DSN#">
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
				PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.my_our_comp_#"> AND
				PTR.PROCESS_ROW_ID IN (#arguments.stage_list#)
			ORDER BY
				PTR.PROCESS_ROW_ID
		</cfquery>
        <cfreturn GET_OFFERS_STAGE>
    </cffunction>

    <cffunction name="GET_OFFERS_SHIP" access="remote" returntype="any">
        <cfargument name="offer_id_list">
        <cfquery name="GET_OFFERS_SHIP" datasource="#DSN3#">
			SELECT 
				OS.SHIP_ID,
				OS.ORDER_ID,				
				SR.SERVICE_COMPANY_ID,
				SR.SHIP_FIS_NO,
				SR.OZEL_KOD_2
			FROM
				OFFERS_SHIP OS,
				#dsn2#.GET_SHIP_RESULT SR
			WHERE
				<cfif isDefined("session.pp")>
                    OS.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.period_id#"> AND
                <cfelse>
                    OS.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.period_id#"> AND
                </cfif>
				SR.IS_TYPE = 'SHIP' AND
				OS.ORDER_ID IN (#arguments.offer_id_list#) AND
				OS.SHIP_ID = SR.SHIP_ID
			ORDER BY
				OS.SHIP_ID						
		</cfquery>
        <cfreturn GET_OFFERS_SHIP>
    </cffunction>

    <cffunction name="GET_PARTNER" access="remote" returntype="any">
        <cfargument name="partner_id_list">
        <cfquery name="GET_PARTNER" datasource="#DSN#">
			SELECT
				COMPANY_PARTNER_NAME,
				COMPANY_PARTNER_SURNAME
			FROM
				COMPANY_PARTNER
			WHERE
				COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#"> AND
				PARTNER_ID IN (#arguments.partner_id_list#)
			ORDER BY
				COMPANY_ID
		</cfquery>
        <cfreturn GET_PARTNER>
    </cffunction>

    <cffunction name="GET_CONSUMER" access="remote" returntype="any">
        <cfargument name="consumer_id_list">
        <cfquery name="GET_CONSUMER" datasource="#DSN#">
			SELECT
				CONSUMER_NAME,
				CONSUMER_SURNAME
			FROM
				CONSUMER
			WHERE
				CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#"> AND
				CONSUMER_ID IN (#arguments.consumer_id_list#)
			ORDER BY
				CONSUMER_ID
		</cfquery>
        <cfreturn GET_CONSUMER>
    </cffunction>

    <cffunction name="GET_OFFER" access="remote" returntype="any">
        <cfargument name="offer_id">
        <cfquery name="GET_OFFER" datasource="#DSN3#">
            SELECT
                OFFER_ID,
                OFFER_HEAD,
                OFFER_DETAIL,
                OFFER_STAGE,
                PAYMETHOD,
                CARD_PAYMETHOD_ID,
                CITY_ID,
                COUNTY_ID,
                SHIP_ADDRESS,
                DELIVERDATE,
                UPDATE_MEMBER,
                COMPANY_ID
            FROM 
                OFFER
            WHERE
                OFFER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.offer_id#">
        </cfquery>
        <cfreturn GET_OFFER>
    </cffunction>

    <cffunction name="get_offer_rows" access="remote" returntype="any">
        <cfargument name="offer_id">
        <cfquery name="get_offer_rows" datasource="#dsn3#">
            SELECT
                *
            FROM 
                OFFER_ROW
            WHERE
                OFFER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.offer_id#">
            ORDER BY 
                OFFER_ROW_ID
        </cfquery>
        <cfreturn get_offer_rows>
    </cffunction>

    <cffunction name="upd_offer" access="remote" returntype="any" returnformat = "JSON">
        <cfset response = structNew()>
        <cftransaction>
            <cftry> 
                <cfquery name="UPD_OFFER" datasource="#DSN3#">
                    UPDATE 
                        OFFER
                    SET
                        SALES_PARTNER_ID = #session.pp.userid#,
                        <cfif len(arguments.member) and ((#listgetat(arguments.member,3,',')# eq 3) or (#listgetat(arguments.member,3,',')# eq 4))><!--- yenin partnermi consumermi oldugunu anlamak iin --->
                            PARTNER_ID = #listgetat(arguments.member,1,',')#,
                            COMPANY_ID = #listgetat(arguments.member,2,',')#,		
                        <cfelseif len(arguments.member) and (#listgetat(arguments.member,3,',')#) eq 5>
                            CONSUMER_ID = #listgetat(arguments.member,1,',')#,
                        </cfif>
                        OFFER_HEAD = '#arguments.offer_head#',
                        OFFER_DETAIL = '#arguments.offer_detail#',
                        OFFER_STAGE = <cfif isdefined("arguments.process_stage")>#arguments.process_stage#<cfelse>NULL</cfif>,
                        PAYMETHOD = <cfif len(arguments.paymethod_id) and len(arguments.paymethod)>#arguments.paymethod_id#<cfelse>NULL</cfif>,
                        <cfif isdefined("arguments.card_paymethod_id") and len(arguments.card_paymethod_id)>
                            CARD_PAYMETHOD_ID = #arguments.card_paymethod_id#,
                            CARD_PAYMETHOD_RATE = <cfif isdefined("arguments.commission_rate") and len(arguments.commission_rate)>#arguments.commission_rate#,<cfelse>NULL,</cfif>,
                        <cfelse>
                            CARD_PAYMETHOD_ID = NULL,
                            CARD_PAYMETHOD_RATE = NULL,
                        </cfif>
                        SHIP_ADDRESS = '#arguments.ship_address#',
                        DUE_DATE = #now()#,
                        CITY_ID = <cfif isdefined("arguments.city_id") and len(arguments.city_id)>#arguments.city_id#<cfelse>NULL</cfif>,
                        COUNTY_ID = <cfif isdefined("arguments.county_id") and len(arguments.county_id)>#arguments.county_id#<cfelse>NULL</cfif>,
                    <cfif isdefined("session.ww")>
                        UPDATE_CONS = #session.ww.userid#
                        UPDATE_PAR = NULL
                    <cfelse>
                        UPDATE_CONS = NULL,
                        UPDATE_PAR = #session.pp.userid#
                    </cfif>			
                    WHERE
                        OFFER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.offer_id#">
                </cfquery>
                <cfquery name="GET_OFFER_ROWS" datasource="#DSN3#">
                    SELECT * FROM OFFER_ROW WHERE OFFER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.offer_id#"> ORDER BY OFFER_ROW_ID
                </cfquery>
                <cfoutput query="get_offer_rows">
                    <cfif isdefined("arguments.quantity_#offer_row_id#")>
                        <cfquery name="UPD_OFFER_ROW" datasource="#DSN3#">
                            UPDATE 
                                OFFER_ROW
                            SET
                                QUANTITY = #evaluate("arguments.quantity_#offer_row_id#")#
                            WHERE
                                OFFER_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#offer_row_id#">
                        </cfquery>
                    </cfif>
                </cfoutput>

                <cfset response = { status: true } />
                <cfcatch type = "any">
                    <cfset response = { status: false } />
                </cfcatch>
            </cftry>
        </cftransaction>
        <cfreturn replace(SerializeJSON(response),'//','') >
    </cffunction>

    <cffunction name="del_offer" access="remote" returntype="any">
        <cfargument name="offer_id">
        <cfquery name="DEL_OFFER" datasource="#DSN3#">
            DELETE FROM OFFER WHERE OFFER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.offer_id#">
        </cfquery>
        <cfquery name="DEL_OFFER_ROW" datasource="#DSN3#">
            DELETE FROM OFFER_ROW WHERE OFFER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.offer_id#">
        </cfquery>
    </cffunction>

</cfcomponent>