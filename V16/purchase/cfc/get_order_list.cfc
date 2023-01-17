<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="get_order_list_fnc" returntype="query">
        <cfargument name="listing_type" default="" />
        <cfargument name="xml_dsp_ship_amount_info_" default="" />
        <cfargument name="xml_dsp_row_other_money_" default="" />
        <cfargument name="xml_dps_price_from_row_amount_" default="" />
        <cfargument name="start_date" default="" />
        <cfargument name="finish_date" default="" />
        <cfargument name="currency_id" default="" />
        <cfargument name="department_id" default="" />
        <cfargument name="order_status" default="" />
        <cfargument name="project_id" default="" />
        <cfargument name="project_head" default="" />
        <cfargument name="product_id" default="" />
        <cfargument name="prod_cat" default="" />
        <cfargument name="position_code" default="" />
        <cfargument name="product_name" default="" />
        <cfargument name="position_name" default="" />
        <cfargument name="keyword" default="" />
        <cfargument name="order_no" default="" />
        <cfargument name="referance_no" default="" />
        <cfargument name="company_id" default="" />
        <cfargument name="company" default="" />
        <cfargument name="consumer_id" default="" />
        <cfargument name="employee" default="" />
        <cfargument name="employee_id" default="" />
        <cfargument name="order_stage" default="" />
        <cfargument name="zone_id" default="" />
        <cfargument name="sort_type" default="" />
        <cfargument name="irsaliye_fatura" default="" />
        <cfargument name="foreign_categories" default="" />
        <cfargument name="deliver_start_date" default="" />
        <cfargument name="deliver_finish_date" default="" />
        <cfargument name="branch_ids" default="" />

        <cfquery name="GET_ORDER_LIST" datasource="#this.DSN3#">
            SELECT 
                <cfif len(arguments.product_id) or len(arguments.currency_id) or len(arguments.position_code) or len(arguments.prod_cat)>
                    DISTINCT
                </cfif>
                O.ORDER_ID,
                O.ORDER_NUMBER, 
                O.REF_NO,
                O.ORDER_CURRENCY, 
                O.RECORD_DATE, 
                O.ORDER_HEAD,
                O.PARTNER_ID,
                O.RECORD_EMP,
                O.COMPANY_ID,
                O.CONSUMER_ID,
                O.DELIVER_DEPT_ID,
                O.ORDER_DATE,
                O.IS_PROCESSED,
                O.PROJECT_ID,
                <cfif (isdefined('arguments.listing_type') and arguments.listing_type eq 2)><!--- Eğer satır bazında listeleme yapılıyorsa --->
                    ORR.ORDER_ROW_ID,
                    S.STOCK_CODE,
                    <cfif (isdefined('xml_dsp_ship_amount_info_') and xml_dsp_ship_amount_info_ eq 1) or (isdefined('xml_dps_price_from_row_amount_') and xml_dps_price_from_row_amount_ eq 1)><!--- irsaliyelesen miktar listelenirken kullanılıyor --->
                        ORR.WRK_ROW_ID,
                    </cfif>
                    <cfif (isdefined('xml_dsp_row_other_money_') and xml_dsp_row_other_money_ eq 1) or (isdefined('xml_dps_price_from_row_amount_') and xml_dps_price_from_row_amount_ eq 1)>
                        ORR.PRICE_OTHER,
                    </cfif>
                    ORR.ORDER_ROW_CURRENCY,
                    ORR.QUANTITY,
                    ISNULL(ORR.CANCEL_AMOUNT,0) AS CANCEL_AMOUNT,
                    ORR.UNIT,
                    ORR.STOCK_ID,
                    PRODUCT.PRODUCT_ID,
                    PRODUCT.PRODUCT_NAME,
                    PRODUCT.PRODUCT_CODE,
                    <cfif isdefined('xml_dps_price_from_row_amount_') and xml_dps_price_from_row_amount_ eq 1>
                        ORR.PRICE,	
                    </cfif>
                    ORR.NETTOTAL AS NETTOTAL,
                    ORR.OTHER_MONEY_VALUE AS OTHER_MONEY_VALUE,
                    ORR.OTHER_MONEY AS OTHER_MONEY,
                    ORR.DELIVER_DATE AS DELIVER_DATE_,
                <cfelse>
                    O.NETTOTAL,
                    O.OTHER_MONEY,
                    O.OTHER_MONEY_VALUE,
                    O.DELIVERDATE AS DELIVER_DATE_,
                </cfif>
                O.ORDER_STAGE,
                (SELECT BRANCH_NAME FROM #this.dsn_alias#.BRANCH WHERE BRANCH_ID IN (SELECT BRANCH_ID FROM #this.dsn_alias#.DEPARTMENT WHERE DEPARTMENT_ID = O.DELIVER_DEPT_ID)) AS BRANCH_NAME,
                PP.PROJECT_HEAD,
                PTR.STAGE,
                CP.COMPANY_PARTNER_NAME + ' ' + CP.COMPANY_PARTNER_SURNAME PARTNER_NAME,
                COM.NICKNAME,
                EMP.EMPLOYEE_NAME+' '+EMP.EMPLOYEE_SURNAME EMPLOYEE_NAME,
                CON.CONSUMER_NAME+' '+CON.CONSUMER_SURNAME CONSUMER_NAME
                <cfif arguments.sort_type eq 1 >
                    ,O.DELIVERDATE 
                </cfif>	
            FROM 
                ORDERS O
                    LEFT JOIN #this.dsn_alias#.PRO_PROJECTS PP ON O.PROJECT_ID = PP.PROJECT_ID
                    LEFT JOIN #this.dsn_alias#.PROCESS_TYPE_ROWS PTR ON O.ORDER_STAGE = PTR.PROCESS_ROW_ID
                    LEFT JOIN #this.dsn_alias#.COMPANY_PARTNER CP ON O.PARTNER_ID = CP.PARTNER_ID
                    LEFT JOIN #this.dsn_alias#.COMPANY COM ON O.COMPANY_ID = COM.COMPANY_ID
                    LEFT JOIN #this.dsn_alias#.EMPLOYEES EMP ON O.RECORD_EMP = EMP.EMPLOYEE_ID
                    LEFT JOIN #this.dsn_alias#.CONSUMER CON ON O.CONSUMER_ID = CON.CONSUMER_ID
                    LEFT JOIN #this.dsn_alias#.DEPARTMENT D ON D.DEPARTMENT_ID = O.DELIVER_DEPT_ID
                    LEFT JOIN #this.dsn_alias#.BRANCH B ON B.BRANCH_ID = D.BRANCH_ID
                <cfif (isdefined('arguments.listing_type') and arguments.listing_type eq 2) or len(arguments.prod_cat) or len(arguments.position_code)>
                    ,PRODUCT 
                </cfif>	
                <!--- belge bazinda irsaliyelesen/faturalasan --->
                <cfif isdefined('arguments.listing_type') and arguments.listing_type eq 1 and isdefined("arguments.irsaliye_fatura") and arguments.irsaliye_fatura eq 1>
                    ,ORDERS_SHIP OS
                <cfelseif isdefined('arguments.listing_type') and arguments.listing_type eq 1 and isdefined("arguments.irsaliye_fatura") and arguments.irsaliye_fatura eq 2>
                    ,ORDERS_INVOICE OI
                </cfif>
                <cfif (isdefined('arguments.listing_type') and arguments.listing_type eq 2) or len(arguments.product_id) or len(arguments.currency_id) or len(arguments.prod_cat) or len(arguments.position_code)>
                    ,ORDER_ROW ORR 
                        LEFT JOIN STOCKS S ON ORR.STOCK_ID=S.STOCK_ID
                    <cfif isdefined('arguments.listing_type') and arguments.listing_type eq 2 and isdefined("arguments.irsaliye_fatura") and arguments.irsaliye_fatura eq 1>
                        ,GET_ALL_SHIP_ROW GESR
                    <cfelseif isdefined('arguments.listing_type') and arguments.listing_type eq 2 and isdefined("arguments.irsaliye_fatura") and arguments.irsaliye_fatura eq 2>
                        ,GET_ALL_INVOICE_ROW GALR
                        ,GET_ALL_SHIP_ROW GESR
                    </cfif>
                </cfif>				
            WHERE 
                O.PURCHASE_SALES = 0 AND
                O.ORDER_ZONE = 0
            <cfif isdefined("arguments.start_date") and isdate(arguments.start_date)>
                AND O.ORDER_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.start_date#">
            </cfif>
            <cfif isdefined("arguments.finish_date") and isdate(arguments.finish_date)>
                AND O.ORDER_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.finish_date#">
            </cfif>
            <!--- satir irsaliyelesen/faturalasan --->
            <cfif isdefined('arguments.listing_type') and arguments.listing_type eq 2 and isdefined("arguments.irsaliye_fatura") and arguments.irsaliye_fatura eq 1>
                AND ORR.WRK_ROW_ID = GESR.WRK_ROW_RELATION_ID
            <cfelseif isdefined('arguments.listing_type') and arguments.listing_type eq 2 and isdefined("arguments.irsaliye_fatura") and arguments.irsaliye_fatura eq 2>
                AND ORR.WRK_ROW_ID = GESR.WRK_ROW_RELATION_ID
                AND GESR.SHIP_ID = GALR.SHIP_ID
            </cfif>
            <!--- belge irsaliyelesen/faturalasan --->
            <cfif isdefined('arguments.listing_type') and arguments.listing_type eq 1 and isdefined("arguments.irsaliye_fatura") and arguments.irsaliye_fatura eq 1>
                AND OS.ORDER_ID = O.ORDER_ID
            <cfelseif isdefined('arguments.listing_type') and arguments.listing_type eq 1 and isdefined("arguments.irsaliye_fatura") and arguments.irsaliye_fatura eq 2>
                AND OI.ORDER_ID = O.ORDER_ID
            </cfif>
            <!--- teslim tarihi --->
            <cfif isdefined('arguments.listing_type') and arguments.listing_type eq 1>
                <cfif isdefined("arguments.deliver_start_date") and isdate(arguments.deliver_start_date)>
                    AND O.DELIVERDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.deliver_start_date#">
                </cfif>
                <cfif isdefined("arguments.deliver_finish_date") and isdate(arguments.deliver_finish_date)>
                    AND O.DELIVERDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.deliver_finish_date#">
                </cfif>
            <cfelseif isdefined('arguments.listing_type') and arguments.listing_type eq 2>
                <cfif isdefined("arguments.deliver_start_date") and isdate(arguments.deliver_start_date)>
                    AND ORR.DELIVER_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.deliver_start_date#">
                </cfif>
                <cfif isdefined("arguments.deliver_finish_date") and isdate(arguments.deliver_finish_date)>
                    AND ORR.DELIVER_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.deliver_finish_date#">
                </cfif>
            </cfif>
            <cfif len(arguments.currency_id)>
                AND ORR.ORDER_ROW_CURRENCY = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.currency_id#">
            </cfif>
            <cfif len(arguments.department_id)>
                AND O.DELIVER_DEPT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.department_id#">
            </cfif>
            <cfif len(arguments.order_status)>
                AND O.ORDER_STATUS = <cfqueryparam cfsqltype="cf_sql_smallint" value="#arguments.order_status#">
            </cfif>
            <cfif len(arguments.foreign_categories)>
                AND O.IS_FOREIGN = <cfqueryparam cfsqltype="cf_sql_smallint" value="#arguments.foreign_categories#">
            </cfif>
            <cfif isdefined("arguments.project_id") and len (arguments.project_id) and isdefined("arguments.project_head") and len (arguments.project_head)>
                AND O.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.project_id#">
            </cfif>
            <cfif (isdefined('arguments.listing_type') and arguments.listing_type eq 2) or len(arguments.product_id) or len(arguments.prod_cat) or len(arguments.position_code) or len(arguments.currency_id)>
                AND ORR.ORDER_ID = O.ORDER_ID
            </cfif>
            <cfif len(arguments.product_id) and len(arguments.product_name)>
                AND ORR.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.product_id#">
            </cfif>		
            <cfif len(arguments.position_code) and len(arguments.position_name)>
                AND PRODUCT.PRODUCT_MANAGER = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.position_code#">
            </cfif>
            <cfif (isdefined('arguments.listing_type') and arguments.listing_type eq 2) or len(arguments.prod_cat) or len(arguments.position_code)>
                AND PRODUCT.PRODUCT_ID=ORR.PRODUCT_ID
            </cfif>	
            <cfif len(arguments.prod_cat)>
                AND PRODUCT.PRODUCT_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.prod_cat#.%">
            </cfif>	
            <cfif len(arguments.keyword)>
                AND (
                        O.ORDER_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI OR
                        O.ORDER_NUMBER LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI
                    )
            </cfif>
            <cfif len(arguments.order_no)>
                AND O.ORDER_NUMBER = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.order_no#">
            </cfif>	
            <cfif len(arguments.referance_no)>
                AND O.REF_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.referance_no#%">
            </cfif>	
            <cfif isdefined('arguments.company_id') and len(arguments.company_id) and len(arguments.company)>
            AND O.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#">
            <cfelseif isdefined('arguments.consumer_id') and len(arguments.consumer_id) and len(arguments.company)>
                AND O.CONSUMER_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.consumer_id#">
            </cfif>
            <cfif len(arguments.employee_id) and len(arguments.employee)>
            AND O.RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.employee_id#">
            </cfif>
            <cfif isdefined('arguments.order_stage') and len(arguments.order_stage)>
                AND ORDER_STAGE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.order_stage#">
            </cfif>
            <cfif len(trim(arguments.branch_ids))>
                AND B.BRANCH_ID IN (<cfqueryparam list="true" cfsqltype="cf_sql_integer" value="#arguments.branch_ids#">)
            </cfif> 
            <cfif session.ep.isBranchAuthorization>
                AND DELIVER_DEPT_ID IN (SELECT DEPARTMENT_ID FROM #this.dsn_alias#.DEPARTMENT WHERE BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(session.ep.user_location,2,'-')#">)
            </cfif>
            <cfif isdefined('arguments.zone_id') and len(arguments.zone_id)>
                AND DELIVER_DEPT_ID IN 
                    (SELECT 
                        D.DEPARTMENT_ID 
                    FROM 
                        #this.dsn_alias#.DEPARTMENT D,
                        #this.dsn_alias#.BRANCH B
                    WHERE 
                        D.BRANCH_ID = B.BRANCH_ID AND
                        B.ZONE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.zone_id#">
                    )
            </cfif>
            ORDER BY
                <cfif arguments.sort_type eq 1>
                    O.DELIVERDATE ASC,
                <cfelseif arguments.sort_type eq 2>
                    O.DELIVERDATE DESC,
                <cfelseif arguments.sort_type eq 3>
                    O.ORDER_DATE ASC,
                <cfelseif arguments.sort_type eq 4>
                    O.ORDER_DATE DESC,
                </cfif>
                O.ORDER_ID DESC
        </cfquery>
        <cfreturn GET_ORDER_LIST>
    </cffunction>
    <cffunction name="get_order_kdvsiz" returntype="query">
        <cfargument name="order_id" default="" />
        <cfquery name="get_order_kdvsiz" datasource="#this.dsn3#">
            SELECT
                SUM(NETTOTAL) AS KDVSIZ_TOPLAM
            FROM
                ORDER_ROW
            WHERE
                ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.order_id#">
        </cfquery>
        <cfreturn get_order_kdvsiz>
    </cffunction>
</cfcomponent>