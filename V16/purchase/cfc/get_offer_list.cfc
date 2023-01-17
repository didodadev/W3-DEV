<cffunction name="get_offer_list_fnc" returntype="query">
	<cfargument name="listing_type" default="" />
    <cfargument name="product_id" default="" />
    <cfargument name="product_name" default="" />
    <cfargument name="keyword" default="" />
    <cfargument name="offer_number" default="" />
    <cfargument name="currency_id" default="" />
    <cfargument name="offer_stage" default="" />
    <cfargument name="public_partner" default="" />
    <cfargument name="offer_status" default="" />
    <cfargument name="employee_id" default="" />
    <cfargument name="employee" default="" />
    <cfargument name="company_id" default="" />
    <cfargument name="company" default="" />
    <cfargument name="consumer_id" default="" />
    <cfargument name="public_start_date" default="" />
    <cfargument name="public_finish_date" default="" />
    <cfargument name="start_date" default="" />
    <cfargument name="finish_date" default="" />
    <cfargument name="project_id" default="" />
    <cfargument name="project_head" default="" />
    <cfargument name="order_by_date" default="" />
    <cfargument name="assc_offers" default="" />

    <cfquery name="get_offer_list" datasource="#this.dsn3#">
        SELECT
            <cfif len(arguments.listing_type) and arguments.listing_type eq 2>
                ORW.OFFER_ROW_ID,
                ORW.STOCK_ID,
                ORW.WRK_ROW_ID,
                ORW.PRODUCT_ID,
                ORW.PRODUCT_NAME,
                ORW.QUANTITY,
                ORW.UNIT,
            </cfif>
            O.OFFER_ID,
            O.FOR_OFFER_ID,
            O.OFFER_DATE,
            O.OFFER_FINISHDATE,
            O.DELIVERDATE,
            O.OFFER_HEAD,
            O.OFFER_NUMBER,
            O.OFFER_CURRENCY,
            O.OFFER_STAGE,
            O.IS_PARTNER_ZONE,
            O.IS_PUBLIC_ZONE,
            O.OFFER_STATUS,
            O.SALES_EMP_ID,
            O.OFFER_TO,
            O.OFFER_TO_CONSUMER,
            O.SHIP_METHOD,
            O.PAYMETHOD,
            O.OTHER_MONEY,
            O.OTHER_MONEY_VALUE,
            <cfif len(arguments.listing_type) and arguments.listing_type eq 2>
            ORW.ROW_PROJECT_ID AS PROJECT_ID,
            <cfelse>
            O.PROJECT_ID,
            </cfif>
            O.REF_NO,
            O.RECORD_MEMBER,
            O.RECORD_DATE
        FROM
            <cfif len(arguments.listing_type) and arguments.listing_type eq 2>
                OFFER_ROW ORW,
            </cfif>
            OFFER O
        WHERE
            <cfif len(arguments.listing_type) and arguments.listing_type eq 2>
                O.OFFER_ID = ORW.OFFER_ID AND
                <cfif len(arguments.product_id) and len(arguments.product_name)>
                     ORW.PRODUCT_ID =#arguments.product_id# AND
                </cfif>		
            </cfif>
            <cfif len(arguments.listing_type) and arguments.listing_type eq 1>
                <cfif len(arguments.product_id) and len(arguments.product_name)>
                     O.OFFER_ID IN(SELECT OFFER_ID FROM OFFER_ROW WHERE PRODUCT_ID= #arguments.product_id#)AND
                </cfif>
            </cfif>		
            <cfif len(arguments.keyword)>
                <cfif len(arguments.listing_type) and arguments.listing_type eq 1>
                    (O.OFFER_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI OR O.OFFER_DETAIL LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI OR O.REF_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI) AND
                <cfelse>
                    ORW.PRODUCT_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI AND
                </cfif>
            </cfif>
            <cfif len(arguments.offer_number)>
                O.OFFER_NUMBER LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.offer_number#%"> AND
            </cfif>
            <cfif len(arguments.currency_id)>
                O.OFFER_CURRENCY = #arguments.currency_id# AND
            </cfif>
            <cfif len(arguments.offer_stage)>
                O.OFFER_STAGE = #arguments.offer_stage# AND
            </cfif>
            <cfif len(arguments.public_partner) and arguments.public_partner eq 1>
                O.IS_PARTNER_ZONE = 1 AND O.IS_PUBLIC_ZONE = 0 AND
            <cfelseif len(arguments.public_partner) and arguments.public_partner eq 2>
                O.IS_PARTNER_ZONE = 0 AND O.IS_PUBLIC_ZONE = 1 AND
            <cfelseif len(arguments.public_partner) and arguments.public_partner eq 3>
                O.IS_PARTNER_ZONE = 1 AND O.IS_PUBLIC_ZONE = 1 AND
            </cfif>
            <cfif len(arguments.offer_status)>
                O.OFFER_STATUS = #arguments.offer_status# AND
            </cfif>
            <cfif len(arguments.employee_id) and len(arguments.employee)>
                (O.SALES_EMP_ID = #arguments.employee_id# OR O.RECORD_MEMBER = #arguments.employee_id#) AND
            </cfif>
            <cfif len(arguments.company_id) and len(arguments.company)>
                O.OFFER_TO LIKE '%,#arguments.company_id#,%' AND
            <cfelseif len(arguments.consumer_id) and len(arguments.company)>
                O.OFFER_TO_CONSUMER LIKE '%,#arguments.consumer_id#,%' AND
            </cfif>
            <cfif len(arguments.public_start_date)>
                O.STARTDATE >= #arguments.public_start_date# AND
            </cfif>
            <cfif len(arguments.public_finish_date)>
                O.FINISHDATE <= #arguments.public_finish_date# AND
            </cfif>
            <cfif len(arguments.start_date) and len(arguments.finish_date)>
                O.OFFER_DATE >= #arguments.start_date# AND
                O.OFFER_DATE <= #arguments.finish_date# AND
            </cfif>
            ((O.OFFER_ZONE = 1 AND O.PURCHASE_SALES = 1) OR (O.OFFER_ZONE = 0 AND O.PURCHASE_SALES = 0))
            <cfif isdefined("arguments.project_id") and len (arguments.project_id) and isdefined("arguments.project_head") and len (arguments.project_head)>
                AND O.PROJECT_ID = #arguments.project_id#
            </cfif>
            <cfif isDefined("arguments.assc_offers") and arguments.assc_offers eq 2>
                AND FOR_OFFER_ID IS NULL
            </cfif>
        ORDER BY
        <cfif len(arguments.order_by_date) and arguments.order_by_date eq 1>
            O.OFFER_DATE DESC,
        <cfelseif len(arguments.order_by_date) and arguments.order_by_date eq 2>
            O.OFFER_DATE,
        <cfelseif len(arguments.order_by_date) and arguments.order_by_date eq 3>
            O.UPDATE_DATE DESC,
        <cfelseif len(arguments.order_by_date) and arguments.order_by_date eq 4>
            O.UPDATE_DATE,
        <cfelseif len(arguments.order_by_date) and arguments.order_by_date eq 5>
            LEFT(O.OFFER_NUMBER, CHARINDEX('-', O.OFFER_NUMBER) - 1) DESC, CAST(SUBSTRING(O.OFFER_NUMBER, CHARINDEX('-', O.OFFER_NUMBER) + 1, 99999999) AS int) DESC,
        <cfelseif len(arguments.order_by_date) and arguments.order_by_date eq 6>
            LEFT(O.OFFER_NUMBER, CHARINDEX('-', O.OFFER_NUMBER) - 1), CAST(SUBSTRING(O.OFFER_NUMBER, CHARINDEX('-', O.OFFER_NUMBER) + 1, 99999999) AS int),
        </cfif>
            O.OFFER_ID DESC,
            O.FOR_OFFER_ID DESC
    </cfquery>
    <cfreturn get_offer_list>
</cffunction>

<cffunction name="get_offer_kdvsiz" returntype="query">
    <cfargument name="offer_id" default="" />
    <cfquery name="get_offer_kdvsiz" datasource="#this.dsn3#">
        SELECT
            SUM(((((QUANTITY*PRICE)+ EXTRA_PRICE_TOTAL)/100000000000000000000)*((100-DISCOUNT_1)*(100- DISCOUNT_2)*(100-DISCOUNT_3)*(100-DISCOUNT_4)*(100-DISCOUNT_5)*(100-DISCOUNT_6)*(100-DISCOUNT_7)*(100-DISCOUNT_8)*(100-DISCOUNT_9)*(100-DISCOUNT_10))/QUANTITY) * QUANTITY) AS KDVSIZ_TOPLAM
        FROM
            OFFER_ROW
        WHERE
            OFFER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.offer_id#">
    </cfquery>
    <cfreturn get_offer_kdvsiz>
</cffunction>