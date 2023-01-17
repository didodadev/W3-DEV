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
    <cfargument name="module_name" default="" />
	<cfargument name="deliver_start_date" default="" />
    <cfargument name="deliver_finish_date" default="" />
    <cfargument name="order_type" default="" />
    <cfset bugun_ = createodbcdatetime(createdate(year(now()),month(now()),day(now())))>
    
    <cfquery name="get_periods_all" datasource="#this.dsn#">
        SELECT * FROM SETUP_PERIOD
    </cfquery>
    
    <cfquery name="get_order_date" datasource="#this.dsn_dev#">
        SELECT ORDER_DAY FROM SEARCH_TABLES_DEFINES
    </cfquery>
    <cfset order_control_day = -1 * get_order_date.ORDER_DAY>
    
    <cfquery name="GET_ORDER_LIST" datasource="#this.DSN3#">
     SELECT
     	*
     FROM
     	(
            SELECT 
                <cfif len(arguments.product_id) or len(arguments.currency_id) or len(arguments.position_code) or len(arguments.prod_cat)>
                    DISTINCT
                </cfif>
                ISNULL((SELECT COUNT(ORDER_ROW_ID) FROM ORDER_ROW ORR2 WHERE ORR2.ORDER_ID = O.ORDER_ID),0) AS URUN_SAYISI,
                ISNULL((SELECT COUNT(ORDER_ROW_ID) FROM ORDER_ROW ORR2 WHERE ORR2.ORDER_ROW_CURRENCY = -1 AND ORR2.ORDER_ID = O.ORDER_ID),0) AS ACIK_URUN_SAYISI,
                ISNULL((SELECT COUNT(ORDER_ROW_ID) FROM ORDER_ROW ORR2 WHERE ORR2.ORDER_ROW_CURRENCY = -6 AND ORR2.ORDER_ID = O.ORDER_ID),0) AS SEVK_URUN_SAYISI,
                CAST(O.COMPANY_ID AS NVARCHAR) + '_' + CAST(ISNULL(O.PROJECT_ID,0) AS NVARCHAR) AS COMP_CODE,
                YEAR(O.ORDER_DATE) ORDER_YIL,
                MONTH(O.ORDER_DATE) ORDER_AY,
                DAY(O.ORDER_DATE) ORDER_GUN,
                O.ORDER_ID,
                O.ORDER_NUMBER, 
                O.ORDER_CODE,
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
                    <cfif isdefined('xml_dsp_ship_amount_info_') and xml_dsp_ship_amount_info_ eq 1><!--- irsaliyelesen miktar listelenirken kullanılıyor --->
                        ORR.WRK_ROW_ID,
                    </cfif>
                    <cfif (isdefined('xml_dsp_row_other_money_') and xml_dsp_row_other_money_ eq 1) or (isdefined('xml_dps_price_from_row_amount_') and xml_dps_price_from_row_amount_ eq 1)>
                        ORR.PRICE_OTHER,
                    </cfif>
                    ORR.ORDER_ROW_CURRENCY,
                    ORR.QUANTITY,
                    ORR.CANCEL_AMOUNT,
                    ORR.UNIT,
                    ORR.STOCK_ID,
                    PRODUCT.PRODUCT_ID,
                    PRODUCT.PRODUCT_NAME,
                    PRODUCT.PRODUCT_CODE,
                    <cfif isdefined('xml_dps_price_from_row_amount_') and xml_dps_price_from_row_amount_ eq 1>
                        ORR.PRICE,	
                    </cfif>
                    ROUND((ORR.NETTOTAL * (100 + ORR.TAX) / 100),2) AS NETTOTAL,
                    ISNULL((
                             SELECT
                             	SUM(TOTAL)
                             FROM
                             	(
                                    <cfset count = 0>
                                   <cfloop query="get_periods_all">
                                   <cfset count = count + 1>
                                   <cfset db_ = "#this.dsn#_#get_periods_all.PERIOD_YEAR#_#session.ep.company_id#">
								   <cfif count neq 1>
                                    UNION ALL
                                   </cfif>
                                    SELECT 
                                        ROUND(SUM(SR.GROSSTOTAL),2) AS TOTAL
                                    FROM
                                        #db_#.SHIP S,
                                        #db_#.SHIP_ROW SR,
                                        ORDERS_SHIP OSS
                                    WHERE
                                        S.SHIP_ID = SR.SHIP_ID AND
                                        OSS.SHIP_ID = S.SHIP_ID AND
                                        OSS.ORDER_ID = O.ORDER_ID AND
                                        SR.STOCK_ID = ORR.STOCK_ID 
                                   </cfloop>
                                ) T1
                            ),0)
                      AS DONUSEN,
                    ORR.OTHER_MONEY_VALUE AS OTHER_MONEY_VALUE,
                    ORR.OTHER_MONEY AS OTHER_MONEY,
                    DATEADD(dd,ISNULL(ORR.DUEDATE,0),O.ORDER_DATE) AS VADE_TARIHI,
                <cfelse>
                    (SELECT SUM(OR_IC.NETTOTAL * (100 + TAX) / 100) FROM ORDER_ROW OR_IC WHERE OR_IC.ORDER_ID = O.ORDER_ID) AS NETTOTAL,
                    ISNULL((
                        SELECT 
                            SUM(SR.GROSSTOTAL)
                        FROM
                            #this.dsn2_alias#.SHIP S,
                            #this.dsn2_alias#.SHIP_ROW SR,
                            ORDERS_SHIP OSS,
                            ORDER_ROW ORR_IC
                        WHERE
                            S.SHIP_ID = SR.SHIP_ID AND
                            OSS.SHIP_ID = S.SHIP_ID AND
                            OSS.ORDER_ID = O.ORDER_ID AND
                            ORR_IC.ORDER_ID = O.ORDER_ID AND
                            SR.STOCK_ID = ORR_IC.STOCK_ID 
                            ),0)
                      AS DONUSEN,
                    O.OTHER_MONEY,
                    O.OTHER_MONEY_VALUE,
                    O.DUE_DATE AS VADE_TARIHI,
                </cfif>
                O.ORDER_STAGE,
                (SELECT BRANCH_NAME FROM #this.dsn_alias#.BRANCH WHERE BRANCH_ID IN (SELECT BRANCH_ID FROM #this.dsn_alias#.DEPARTMENT WHERE DEPARTMENT_ID = O.DELIVER_DEPT_ID)) AS BRANCH_NAME,
                PP.PROJECT_HEAD,
                PTR.STAGE,
                CP.COMPANY_PARTNER_NAME + ' ' + CP.COMPANY_PARTNER_SURNAME PARTNER_NAME,
                COM.NICKNAME,
                EMP.EMPLOYEE_NAME+' '+EMP.EMPLOYEE_SURNAME EMPLOYEE_NAME,
                CON.CONSUMER_NAME+' '+CON.CONSUMER_SURNAME CONSUMER_NAME
                <cfif arguments.sort_type eq 1 OR arguments.sort_type eq 2>
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
                AND O.ORDER_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#dateadd('d',1,arguments.finish_date)#">
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
                    AND O.DUE_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.deliver_start_date#">
                </cfif>
                <cfif isdefined("arguments.deliver_finish_date") and isdate(arguments.deliver_finish_date)>
                    AND O.DUE_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.deliver_finish_date#">
                </cfif>
            <cfelseif isdefined('arguments.listing_type') and arguments.listing_type eq 2>
                <cfif isdefined("arguments.deliver_start_date") and isdate(arguments.deliver_start_date)>
                    AND 
                    	DATEADD(dd,ISNULL(ORR.DUEDATE,0),O.ORDER_DATE) >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.deliver_start_date#">
                </cfif>
                <cfif isdefined("arguments.deliver_finish_date") and isdate(arguments.deliver_finish_date)>
                    AND DATEADD(dd,ISNULL(ORR.DUEDATE,0),O.ORDER_DATE) <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.deliver_finish_date#">
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
                AND O.PROJECT_ID IN (#arguments.project_id#)
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
            <cfif arguments.order_type eq 1>
                AND
                    O.ORDER_HEAD LIKE '%OTOMATİK SİPARİŞ%'
            </cfif>
            <cfif arguments.order_type eq 2>
                AND
                    O.ORDER_HEAD = 'MAĞAZA SİPARİŞİ'
            </cfif>
            <cfif len(arguments.keyword)>
                AND (
                        O.ORDER_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%"> OR
                        O.ORDER_NUMBER LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%">
                    )
            </cfif>
            <cfif len(arguments.order_no)>
                AND 
                    (
                    O.ORDER_NUMBER = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.order_no#">
                    OR
                    O.ORDER_CODE LIKE '%#arguments.order_no#%'
                    )
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
            <cfif isdefined("session.ep.admin") and session.ep.admin neq 1>
                AND DELIVER_DEPT_ID IN 
                	(
                    	SELECT 
                        	DEPARTMENT_ID 
                       	FROM 
                        	#this.dsn_alias#.DEPARTMENT 
                        WHERE 
                        	BRANCH_ID IN (SELECT BRANCH_ID FROM #this.dsn_alias#.EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#)
                   )
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
     ) T1
    <cfif isdefined("arguments.irsaliye_fatura") and arguments.irsaliye_fatura eq 3>
    WHERE
    	COMPANY_ID NOT IN (SELECT OWNER_ID FROM #this.dsn_alias#.INFO_PLUS WHERE PROPERTY3 = 'Hayır' AND INFO_OWNER_TYPE = -1) AND
        ROUND(NETTOTAL,2) > ROUND(DONUSEN,2) AND
        ORDER_DATE >= #dateadd('d',order_control_day,bugun_)#
    </cfif>
    ORDER BY
    <cfif arguments.sort_type eq 1>
        DELIVERDATE ASC,
    <cfelseif arguments.sort_type eq 2>
        DELIVERDATE DESC,
    <cfelseif arguments.sort_type eq 3>
        ORDER_DATE ASC,
    <cfelseif arguments.sort_type eq 4>
        ORDER_DATE DESC,
    <cfelseif arguments.sort_type eq 5>
        COMPANY_ID,
        VADE_TARIHI ,
        DELIVER_DEPT_ID ASC,
        ORDER_DATE ASC,
    <cfelseif arguments.sort_type eq 6>
        COMPANY_ID,
        VADE_TARIHI DESC,
        ORDER_DATE DESC,
    </cfif>
    ORDER_ID DESC
    </cfquery>
    <cfreturn GET_ORDER_LIST>
</cffunction>