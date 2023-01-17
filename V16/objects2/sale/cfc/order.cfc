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

    <cffunction name="GET_STAGE_INFO" access="remote" returntype="any">
        <cfquery name="GET_STAGE_INFO" datasource="#dsn#">
            SELECT
                STAGE,
                PROCESS_ROW_ID,
                DETAIL
            FROM
                PROCESS_TYPE_ROWS	
        </cfquery>
        <cfreturn GET_STAGE_INFO>
    </cffunction>

    <cffunction name="GET_CAMP" access="remote" returntype="any">
        <cfquery name="GET_CAMP" datasource="#DSN3#">
            SELECT 
                CAMP_STARTDATE,
                CAMP_FINISHDATE,
                CAMP_ID,
                CAMP_HEAD
            FROM 
                CAMPAIGNS 
            WHERE 
                CAMP_STARTDATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> AND
                CAMP_FINISHDATE > <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
        </cfquery>
        <cfreturn GET_CAMP>
    </cffunction>

    <cffunction name="GET_LEVEL" access="remote" returntype="any">
        <cfargument name="consumer_cat_id">
        <cfargument name="camp_id">
        <cfquery name="GET_LEVEL" datasource="#DSN3#">
			SELECT ISNULL(MAX(PREMIUM_LEVEL),0) AS PRE_LEVEL FROM SETUP_CONSCAT_PREMIUM WHERE CONSCAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.consumer_cat_id#"> AND CAMPAIGN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.camp_id#">
		</cfquery>
        <cfreturn GET_LEVEL>
    </cffunction>

    <cffunction name="GET_REF_MEMBER" access="remote" returntype="any">
        <cfargument name="userid">
        <cfargument name="ref_count">
        <cfquery name="GET_REF_MEMBER" datasource="#DSN#">
            SELECT 
                CONSUMER_ID 
            FROM 
                CONSUMER
            WHERE 
                REF_POS_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.userid#"> OR 
                (
                    CONSUMER_REFERENCE_CODE IS NOT NULL AND
                    '.'+CONSUMER_REFERENCE_CODE+'.' LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%.#arguments.userid#.%"> AND
                    (LEN(REPLACE(CONSUMER_REFERENCE_CODE,'.','..'))-LEN(CONSUMER_REFERENCE_CODE)+1) < = #arguments.ref_count#
                )
        </cfquery>
        <cfreturn GET_REF_MEMBER>
    </cffunction>

    <cffunction name="GET_OUR_COMPANY_INFO" access="remote" returntype="any">
        <cfquery name="GET_OUR_COMPANY_INFO" datasource="#DSN#">
            SELECT 
                CARGO_CUSTOMER_CODE 
            FROM 
                OUR_COMPANY_INFO 
            WHERE  
            <cfif isdefined("session.pp.company_id")>
                COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.our_company_id#">
            <cfelseif  isdefined("session.ww.userid")>
                COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.our_company_id#">
            <cfelseif  isdefined("session.ep.userid")>
                COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
            <cfelse>
                1=0
            </cfif>
        </cfquery>
        <cfreturn GET_OUR_COMPANY_INFO>
    </cffunction>   

    <cffunction name="GET_HIERARCHIES" access="remote" returntype="any">
        <cfquery name="GET_HIERARCHIES" datasource="#DSN#">
			SELECT DISTINCT
				SZ_HIERARCHY
			FROM
				SALES_ZONES_ALL_1
			WHERE
				POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">
		</cfquery>
        <cfreturn GET_HIERARCHIES>
    </cffunction>

    <cffunction name="GET_ORDER_LIST" access="remote" returntype="any">
        <cfargument name="is_product_count">
        <cfargument name="listing_type">
        <cfargument name="currency_id">
        <cfargument name="zone">
        <cfargument name="is_ref_order">
        <cfargument name="list_ref_member">
        <cfargument name="keyword">
        <cfargument name="order_stage">
        <cfargument name="status">
        <cfargument name="is_order_stage_no">
        <cfargument name="start_date">
        <cfargument name="finish_date">
        <cfargument name="pos_code_text">
        <cfargument name="pos_code">
        <cfargument name="comp_id">

        <cfif isdefined("session.ep")>
            <cfset GET_HIERARCHIES = this.GET_HIERARCHIES()>
        </cfif>
        <cfset row_block = 500>

        <cfquery name="GET_ORDER_LIST" datasource="#DSN3#">
            SELECT 
            <cfif isdefined("arguments.is_product_count") and arguments.is_product_count eq 1>
                SUM(ORDER_ROW.QUANTITY) TOTAL_AMOUNT,
            </cfif>
            <cfif (isdefined('arguments.listing_type') and arguments.listing_type eq 2)><!--- Eğer satır bazında listeleme yapılıyorsa --->
                ORDER_ROW.ORDER_ROW_ID,
                ORDER_ROW.ORDER_ROW_CURRENCY,
                ORDER_ROW.STOCK_ID,
                ORDER_ROW.PRODUCT_ID,
                ORDER_ROW.QUANTITY,
                ORDER_ROW.UNIT,
                PRODUCT.PRODUCT_NAME,
                ORDER_ROW.PRICE,
                ISNULL(ORDER_ROW.NETTOTAL,0) AS NETTOTAL,
                (ORDER_ROW.NETTOTAL * ORDER_ROW.TAX /100) AS TAXTOTAL,
                ORDER_ROW.OTHER_MONEY_VALUE AS OTHER_MONEY_VALUE,
                ORDER_ROW.OTHER_MONEY AS OTHER_MONEY,
                ORDER_ROW.SPECT_VAR_ID,
                ORDER_ROW.SPECT_VAR_NAME,
                ORDER_ROW.PRODUCT_NAME2,
            </cfif>
                ORDERS.REF_NO,
                ORDERS.ORDER_ID,
                ORDERS.ORDER_NUMBER, 
                ORDERS.RECORD_DATE, 
                ORDERS.ORDER_HEAD,
                ISNULL(ORDERS.NETTOTAL,0) AS NETTOTAL,
                ORDERS.GROSSTOTAL,
                ORDERS.ORDER_DATE,
                ORDERS.PARTNER_ID,
                ORDERS.CONSUMER_ID,
                ORDERS.OTHER_MONEY,
                ORDERS.OTHER_MONEY_VALUE,
                ORDERS.IS_PROCESSED,
                ORDERS.ORDER_STATUS,
                ORDERS.ORDER_STAGE,
                ORDERS.RECORD_DATE,
                ORDERS.SHIP_ADDRESS,
                ORDERS.CARGO_INVOICE_NO,
                C.IMS_CODE_ID,
                ISNULL((SELECT SUM(USED_VALUE) FROM ORDER_MONEY_CREDIT_USED OMC WHERE OMC.ORDER_ID = ORDERS.ORDER_ID),0) USE_CREDIT
            FROM 
                <cfif (isdefined('arguments.listing_type') and arguments.listing_type eq 2) or (isDefined("arguments.currency_id") and len(arguments.currency_id)) or (isdefined("arguments.is_product_count") and arguments.is_product_count eq 1)>
                    ORDER_ROW,
                </cfif>
                <cfif isdefined('arguments.listing_type') and arguments.listing_type eq 2>
                    PRODUCT, 
                </cfif>	
                ORDERS,
                #dsn#.CONSUMER C
            WHERE
                ORDERS.IS_INSTALMENT IS NULL AND 
                ORDERS.CONSUMER_ID = C.CONSUMER_ID
                <cfif not len(arguments.zone)>
                    AND ((ORDERS.PURCHASE_SALES = 1 AND ORDERS.ORDER_ZONE = 0) OR (ORDERS.PURCHASE_SALES = 0 AND ORDERS.ORDER_ZONE = 1))
                <cfelseif arguments.zone eq 0>
                    AND (ORDERS.PURCHASE_SALES = 1 AND ORDERS.ORDER_ZONE = 0)
                 <cfelseif arguments.zone eq 1>
                    AND (ORDERS.PURCHASE_SALES = 0 AND ORDERS.ORDER_ZONE = 1)
                </cfif>
                <cfif isdefined("session.pp.company_id")>
                     AND ORDERS.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#">
                <cfelseif isdefined("session.ww.userid")>
                     <cfif isdefined("arguments.is_ref_order") and arguments.is_ref_order eq 1>
                        <cfif isdefined("list_ref_member") and len(list_ref_member)>
                            AND ORDERS.CONSUMER_ID IN(#list_ref_member#)
                        <cfelse>
                            AND 1 = 2
                        </cfif>
                     <cfelse>
                         AND ORDERS.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#">
                     </cfif>
                <cfelseif isdefined("session.ep.userid")>
                     <cfif isdefined("arguments.consumer_id") and len(arguments.consumer_id)>
                         AND ORDERS.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.consumer_id#">
                     <cfelseif isdefined("arguments.company_id") and len(arguments.company_id)>
                         AND ORDERS.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#">
                     </cfif>
                </cfif>
                <cfif isDefined("arguments.keyword") and len(arguments.keyword)>
                     AND (
                            ORDERS.ORDER_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%"> OR 
                            ORDERS.ORDER_NUMBER LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%">
                            <cfif isdefined('arguments.listing_type') and arguments.listing_type eq 2>
                                OR PRODUCT.PRODUCT_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%">
                            </cfif>
                        ) 
                </cfif>
                <cfif (isdefined('arguments.listing_type') and arguments.listing_type eq 2) or (isDefined("arguments.currency_id") and len(arguments.currency_id)) or (isdefined("arguments.is_product_count") and arguments.is_product_count eq 1)>
                    AND ORDERS.ORDER_ID = ORDER_ROW.ORDER_ID
                </cfif>
                <cfif isdefined('arguments.listing_type') and arguments.listing_type eq 2>
                    AND PRODUCT.PRODUCT_ID = ORDER_ROW.PRODUCT_ID
                </cfif>
                <cfif isDefined("arguments.currency_id") and len(arguments.currency_id)>
                    AND ORDER_ROW.ORDER_ROW_CURRENCY = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.currency_id#">
                </cfif>
                <cfif isDefined("arguments.order_stage") and len(arguments.order_stage)>
                    AND ORDERS.ORDER_STAGE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.order_stage#">
                </cfif>
                <cfif isdefined('arguments.is_order_stage_no') and len(arguments.is_order_stage_no)><!--- XML den gelen asamalardaki siparisler gelir --->
                    AND ORDERS.ORDER_STAGE IN (#arguments.is_order_stage_no#)
                </cfif>
                <cfif isDefined("arguments.STATUS") and len(arguments.status)>
                    AND ORDERS.ORDER_STATUS = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.status#">
                </cfif>
                <cfif isdefined("arguments.start_date") and len(arguments.start_date)>
                    AND ORDERS.ORDER_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.start_date#"> 
                </cfif>
                <cfif isdefined("arguments.finish_date") and len(arguments.finish_date)>
                    AND ORDERS.ORDER_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.finish_date#">
                </cfif>
                <cfif isdefined("arguments.pos_code_text") and len(arguments.pos_code) and len(arguments.pos_code_text)>
                    AND C.CONSUMER_ID IN (SELECT WEP.CONSUMER_ID FROM #dsn#.WORKGROUP_EMP_PAR WEP WHERE POSITION_CODE = #arguments.pos_code# AND IS_MASTER = 1 AND OUR_COMPANY_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#comp_id#">)
                </cfif>
                <cfif isdefined("session.ep") and session.ep.our_company_info.sales_zone_followup eq 1>
                    <!--- Satis Takimda Ekip Lideri veya Satıs Takiminda Ekipde ise ilgili IMS ler--->
                    AND 
                    (
                        C.IMS_CODE_ID IN (
                                            SELECT
                                                IMS_ID
                                            FROM
                                                #dsn#.SALES_ZONES_ALL_2
                                            WHERE
                                                POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#"> 
                                        )
                        <!--- Satis bolgeleri ekibinde veya Satis bolgesinde yonetici ise kendisi ve altindaki IMS ler--->			
                        <cfif get_hierarchies.recordcount>
                            OR C.IMS_CODE_ID IN (
                                                        SELECT
                                                            IMS_ID
                                                        FROM
                                                            #dsn#.SALES_ZONES_ALL_1
                                                        WHERE											
                                                            <cfloop index="page_stock" from="0" to="#(ceiling(get_hierarchies.recordcount/row_block))-1#">
                                                                <cfset start_row=(page_stock*row_block)+1>	
                                                                <cfset end_row=start_row+(row_block-1)>
                                                                <cfif (end_row) gte get_hierarchies.recordcount>
                                                                    <cfset end_row=get_hierarchies.recordcount>
                                                                </cfif>
                                                                    (
                                                                    <cfloop index="add_stock" from="#start_row#" to="#end_row#">
                                                                        <cfif (add_stock mod row_block) neq 1> OR</cfif> SZ_HIERARCHY+'.' LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#get_hierarchies.sz_hierarchy[add_stock]#%">
                                                                    </cfloop>
                                                                    
                                                                    )<cfif (ceiling(get_hierarchies.recordcount/row_block))-1 neq page_stock> OR</cfif>													
                                                            </cfloop>											
                                                    )
                          </cfif>						
                    )
                </cfif>
                <cfif isdefined("arguments.is_product_count") and arguments.is_product_count eq 1>
                    GROUP BY
                        <cfif (isdefined('arguments.listing_type') and arguments.listing_type eq 2)><!--- Eğer satır bazında listeleme yapılıyorsa --->
                            ORDER_ROW.ORDER_ROW_ID,
                            ORDER_ROW.ORDER_ROW_CURRENCY,
                            ORDER_ROW.STOCK_ID,
                            ORDER_ROW.PRODUCT_ID,
                            ORDER_ROW.QUANTITY,
                            ORDER_ROW.UNIT,
                            PRODUCT.PRODUCT_NAME,
                            ORDER_ROW.PRICE,
                            ORDER_ROW.NETTOTAL,
                            ORDER_ROW.TAX,
                            ORDER_ROW.OTHER_MONEY_VALUE,
                            ORDER_ROW.OTHER_MONEY,
                            ORDER_ROW.SPECT_VAR_ID,
                            ORDER_ROW.SPECT_VAR_NAME,
                            ORDER_ROW.PRODUCT_NAME2,
                        </cfif>
                        ORDERS.REF_NO,
                        ORDERS.ORDER_ID,
                        ORDERS.ORDER_NUMBER, 
                        ORDERS.RECORD_DATE, 
                        ORDERS.ORDER_HEAD,
                        ORDERS.NETTOTAL,
                        ORDERS.GROSSTOTAL,
                        ORDERS.ORDER_DATE,
                        ORDERS.PARTNER_ID,
                        ORDERS.CONSUMER_ID,
                        ORDERS.OTHER_MONEY,
                        ORDERS.OTHER_MONEY_VALUE,
                        ORDERS.IS_PROCESSED,
                        ORDERS.ORDER_STATUS,
                        ORDERS.ORDER_STAGE,
                        ORDERS.RECORD_DATE,
                        ORDERS.SHIP_ADDRESS,
                        ORDERS.CARGO_INVOICE_NO,
                        C.IMS_CODE_ID
                </cfif>
            UNION
                SELECT 
                    <cfif isdefined("arguments.is_product_count") and arguments.is_product_count eq 1>
                        SUM(ORDER_ROW.QUANTITY) TOTAL_AMOUNT,
                    </cfif>
                    <cfif (isdefined('arguments.listing_type') and arguments.listing_type eq 2)><!--- Eğer satır bazında listeleme yapılıyorsa --->
                        ORDER_ROW.ORDER_ROW_ID,
                        ORDER_ROW.ORDER_ROW_CURRENCY,
                        ORDER_ROW.STOCK_ID,
                        ORDER_ROW.PRODUCT_ID,
                        ORDER_ROW.QUANTITY,
                        ORDER_ROW.UNIT,
                        PRODUCT.PRODUCT_NAME,
                        ORDER_ROW.PRICE,
                        ORDER_ROW.NETTOTAL AS NETTOTAL,
                        (ORDER_ROW.NETTOTAL * ORDER_ROW.TAX /100) AS TAXTOTAL,
                        ORDER_ROW.OTHER_MONEY_VALUE AS OTHER_MONEY_VALUE,
                        ORDER_ROW.OTHER_MONEY AS OTHER_MONEY,
                        ORDER_ROW.SPECT_VAR_ID,
                        ORDER_ROW.SPECT_VAR_NAME,
                        ORDER_ROW.PRODUCT_NAME2,
                    </cfif>
                    ORDERS.REF_NO,
                    ORDERS.ORDER_ID,
                    ORDERS.ORDER_NUMBER, 
                    ORDERS.RECORD_DATE, 
                    ORDERS.ORDER_HEAD,
                    ORDERS.NETTOTAL,
                    ORDERS.GROSSTOTAL,
                    ORDERS.ORDER_DATE,
                    ORDERS.PARTNER_ID,
                    ORDERS.CONSUMER_ID,
                    ORDERS.OTHER_MONEY,
                    ORDERS.OTHER_MONEY_VALUE,
                    ORDERS.IS_PROCESSED,
                    ORDERS.ORDER_STATUS,
                    ORDERS.ORDER_STAGE,
                    ORDERS.RECORD_DATE,
                    ORDERS.SHIP_ADDRESS,
                    ORDERS.CARGO_INVOICE_NO,
                    C.IMS_CODE_ID,
                    ISNULL((SELECT SUM(USED_VALUE) FROM ORDER_MONEY_CREDIT_USED OMC WHERE OMC.ORDER_ID = ORDERS.ORDER_ID),0) USE_CREDIT
                FROM 
                    <cfif (isdefined('arguments.listing_type') and arguments.listing_type eq 2) or (isDefined("arguments.currency_id") and len(arguments.currency_id)) or (isdefined("arguments.is_product_count") and arguments.is_product_count eq 1)>
                        ORDER_ROW,
                    </cfif>
                    <cfif isdefined('arguments.listing_type') and arguments.listing_type eq 2>
                        PRODUCT, 
                    </cfif>
                    ORDERS,
                    #dsn#.COMPANY C
                WHERE
                    ORDERS.IS_INSTALMENT IS NULL AND 
                    ORDERS.COMPANY_ID = C.COMPANY_ID
                    <cfif not len(arguments.zone)>
                        AND ((ORDERS.PURCHASE_SALES = 1 AND ORDERS.ORDER_ZONE = 0) OR (ORDERS.PURCHASE_SALES = 0 AND ORDERS.ORDER_ZONE = 1))
                    <cfelseif arguments.zone eq 0>
                        AND (ORDERS.PURCHASE_SALES = 1 AND ORDERS.ORDER_ZONE = 0)
                     <cfelseif arguments.zone eq 1>
                        AND (ORDERS.PURCHASE_SALES = 0 AND ORDERS.ORDER_ZONE = 1)
                    </cfif>
                    <cfif isdefined("session.pp.company_id")>
                         AND ORDERS.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#">
                    <cfelseif isdefined("session.ww.userid")>
                         AND ORDERS.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#">
                    <cfelseif isdefined("session.ep.userid")>
                         <cfif isdefined("arguments.consumer_id") and len(arguments.consumer_id)>
                             AND ORDERS.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.consumer_id#">
                         <cfelseif isdefined("arguments.company_id") and len(arguments.company_id)>
                             AND ORDERS.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#">
                         </cfif>
                    </cfif>
                    <cfif isDefined("arguments.keyword") and len(arguments.keyword)>
                         AND (
                                ORDERS.ORDER_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%"> OR 
                                ORDERS.ORDER_NUMBER LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%">
                                <cfif isdefined('arguments.listing_type') and arguments.listing_type eq 2>
                                    OR PRODUCT.PRODUCT_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%">
                                </cfif>
                            ) 
                    </cfif>
                    <cfif (isdefined('arguments.listing_type') and arguments.listing_type eq 2) or (isDefined("arguments.currency_id") and len(arguments.currency_id)) or (isdefined("arguments.is_product_count") and arguments.is_product_count eq 1)>
                         AND ORDERS.ORDER_ID = ORDER_ROW.ORDER_ID
                    </cfif>
                    <cfif isdefined('arguments.listing_type') and arguments.listing_type eq 2>
                        AND PRODUCT.PRODUCT_ID = ORDER_ROW.PRODUCT_ID
                    </cfif>
                    <cfif isDefined("arguments.currency_id") and len(arguments.currency_id)>
                         AND ORDER_ROW.ORDER_ROW_CURRENCY = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.currency_id#">
                    </cfif>
                    <cfif isDefined("arguments.order_stage") and len(arguments.order_stage)>
                         AND ORDERS.ORDER_STAGE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.order_stage#">
                    </cfif>
                    <cfif isdefined('arguments.is_order_stage_no') and len(arguments.is_order_stage_no)><!--- XML den gelen asamalardaki siparisler gelir --->
                        AND ORDERS.ORDER_STAGE IN (#arguments.is_order_stage_no#)
                    </cfif>
                    <cfif isDefined("arguments.STATUS") and len(arguments.STATUS)>
                         AND ORDERS.ORDER_STATUS = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.STATUS#">
                    </cfif>
                    <cfif isdefined("arguments.start_date") and len(arguments.start_date)>
                        AND ORDERS.ORDER_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.start_date#"> 
                    </cfif>
                    <cfif isdefined("arguments.finish_date") and len(arguments.finish_date)>
                        AND ORDERS.ORDER_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.finish_date#">
                    </cfif>
                    <cfif isdefined("arguments.pos_code_text") and len(arguments.pos_code) and len(arguments.pos_code_text)>
                        AND C.COMPANY_ID IN (SELECT WEP.COMPANY_ID FROM #dsn#.WORKGROUP_EMP_PAR WEP WHERE POSITION_CODE = #arguments.pos_code# AND IS_MASTER = 1 AND OUR_COMPANY_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#comp_id#">)
                    </cfif>
                    <cfif isdefined("session.ep") and session.ep.our_company_info.sales_zone_followup eq 1>
                        <!--- Satis Takimda Ekip Lideri veya Satıs Takiminda Ekipde ise ilgili IMS ler--->
                        AND 
                        (
                            C.IMS_CODE_ID IN (
                                                SELECT
                                                    IMS_ID
                                                FROM
                                                    #dsn#.SALES_ZONES_ALL_2
                                                WHERE
                                                    POSITION_CODE = #session.ep.position_code# 
                                             )
                            <!--- Satis bolgeleri ekibinde veya Satis bolgesinde yonetici ise kendisi ve altindaki IMS ler--->			
                            <cfif get_hierarchies.recordcount>
                                OR C.IMS_CODE_ID IN (
                                                        SELECT
                                                            IMS_ID
                                                        FROM
                                                            #dsn#.SALES_ZONES_ALL_1
                                                        WHERE											
                                                            <cfloop index="page_stock" from="0" to="#(ceiling(get_hierarchies.recordcount/row_block))-1#">
                                                                <cfset start_row=(page_stock*row_block)+1>	
                                                                <cfset end_row=start_row+(row_block-1)>
                                                                <cfif (end_row) gte get_hierarchies.recordcount>
                                                                    <cfset end_row=get_hierarchies.recordcount>
                                                                </cfif>
                                                                    (
                                                                    <cfloop index="add_stock" from="#start_row#" to="#end_row#">
                                                                        <cfif (add_stock mod row_block) neq 1> OR</cfif> SZ_HIERARCHY+'.' LIKE '#get_hierarchies.sz_hierarchy[add_stock]#%'
                                                                    </cfloop>
                                                                    
                                                                    )<cfif (ceiling(get_hierarchies.recordcount/row_block))-1 neq page_stock> OR</cfif>													
                                                            </cfloop>											
                                                    )
                              </cfif>						
                        )
                    </cfif>
                    <cfif isdefined("arguments.is_product_count") and arguments.is_product_count eq 1>
                        GROUP BY
                        <cfif (isdefined('arguments.listing_type') and arguments.listing_type eq 2)><!--- Eğer satır bazında listeleme yapılıyorsa --->
                            ORDER_ROW.ORDER_ROW_ID,
                            ORDER_ROW.ORDER_ROW_CURRENCY,
                            ORDER_ROW.STOCK_ID,
                            ORDER_ROW.PRODUCT_ID,
                            ORDER_ROW.QUANTITY,
                            ORDER_ROW.UNIT,
                            PRODUCT.PRODUCT_NAME,
                            ORDER_ROW.PRICE,
                            ORDER_ROW.NETTOTAL,
                            ORDER_ROW.TAX,
                            ORDER_ROW.OTHER_MONEY_VALUE,
                            ORDER_ROW.OTHER_MONEY,
                            ORDER_ROW.SPECT_VAR_ID,
                            ORDER_ROW.SPECT_VAR_NAME,
                            ORDER_ROW.PRODUCT_NAME2,
                        </cfif>
                            ORDERS.REF_NO,
                            ORDERS.ORDER_ID,
                            ORDERS.ORDER_NUMBER, 
                            ORDERS.RECORD_DATE, 
                            ORDERS.ORDER_HEAD,
                            ORDERS.NETTOTAL,
                            ORDERS.GROSSTOTAL,
                            ORDERS.ORDER_DATE,
                            ORDERS.PARTNER_ID,
                            ORDERS.CONSUMER_ID,
                            ORDERS.OTHER_MONEY,
                            ORDERS.OTHER_MONEY_VALUE,
                            ORDERS.IS_PROCESSED,
                            ORDERS.ORDER_STATUS,
                            ORDERS.ORDER_STAGE,
                            ORDERS.RECORD_DATE,
                            ORDERS.SHIP_ADDRESS,
                            ORDERS.CARGO_INVOICE_NO,
                            C.IMS_CODE_ID
                    </cfif>
                ORDER BY 
                    ORDERS.RECORD_DATE DESC,
                    ORDERS.ORDER_NUMBER DESC
        </cfquery>
        <cfreturn GET_ORDER_LIST>
    </cffunction>

    <cffunction name="GET_PROCESS_TYPE" access="remote" returntype="any">
        <cfargument name="my_our_comp_">
        <cfargument name="is_order_stage_no">
        <cfquery name="GET_PROCESS_TYPE" datasource="#DSN#">
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
                PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%sales.list_order%">
                <cfif isdefined('arguments.is_order_stage_no') and len(arguments.is_order_stage_no)><!--- XML den gelen asamalardaki siparisler gelir --->
                    AND PTR.PROCESS_ROW_ID IN (#arguments.is_order_stage_no#)
                </cfif>
            ORDER BY
                PTR.LINE_NUMBER
        </cfquery>
        <cfreturn GET_PROCESS_TYPE>
    </cffunction>

    <cffunction name="GET_IMS" access="remote" returntype="any">
        <cfargument name="ims_id_list">
        <cfquery name="GET_IMS" datasource="#DSN#">
			SELECT 
				IMS_CODE_ID,
				IMS_CODE
			FROM
				SETUP_IMS_CODE
			WHERE
				IMS_CODE_ID IN (#arguments.ims_id_list#)
			ORDER BY
				IMS_CODE_ID
		</cfquery>
        <cfreturn GET_IMS>
    </cffunction>

    <cffunction name="GET_ORDERS_SHIP" access="remote" returntype="any">
        <cfargument name="order_id_list">
        <cfquery name="GET_ORDERS_SHIP" datasource="#DSN3#">
			SELECT 
				OS.SHIP_ID,
				OS.ORDER_ID,				
				SR.SERVICE_COMPANY_ID,
				SR.SHIP_FIS_NO,
				SR.OZEL_KOD_2
			FROM
				ORDERS_SHIP OS,
				#dsn2#.GET_SHIP_RESULT SR
			WHERE
				<cfif isDefined("session.pp")>
                    OS.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.period_id#"> AND
                <cfelseif isdefined("session.ww")>
                    OS.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.period_id#"> AND
                <cfelseif isdefined("session.ep")>
                    OS.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#"> AND
                </cfif>
				SR.IS_TYPE = 'SHIP' AND
				OS.ORDER_ID IN(#arguments.order_id_list#) AND
				OS.SHIP_ID = SR.SHIP_ID
			ORDER BY
				OS.SHIP_ID
		</cfquery>
        <cfreturn GET_ORDERS_SHIP>
    </cffunction>

    <cffunction name="GET_PRODUCTION_INFO" access="remote" returntype="any">
        <cfargument name="order_row_id_list">
        <cfquery name="GET_PRODUCTION_INFO" datasource="#DSN3#">
			SELECT 
				ISNULL(SUM(PO.QUANTITY),0) AS QUANTITY,
				POR.ORDER_ROW_ID,
				ISNULL(POR.TYPE,1) AS TYPE
			FROM 
				PRODUCTION_ORDERS PO,
				PRODUCTION_ORDERS_ROW POR,
				ORDER_ROW OR_
			WHERE
				OR_.ORDER_ROW_ID =POR.ORDER_ROW_ID AND
				OR_.STOCK_ID = PO.STOCK_ID AND
				PO.P_ORDER_ID = POR.PRODUCTION_ORDER_ID AND
				POR.ORDER_ROW_ID IN (#arguments.order_row_id_list#)
			GROUP BY 
				POR.ORDER_ROW_ID,
				POR.TYPE
		</cfquery>
        <cfreturn GET_PRODUCTION_INFO>
    </cffunction>

    <cffunction name="GET_SHIP_AMOUNT" access="remote" returntype="any">
        <cfargument name="order_row_id_list">
        <cfquery name="GET_SHIP_AMOUNT" datasource="#DSN3#">
			SELECT 
				SUM(SR.AMOUNT) SHIP_AMOUNT,
				ORR.ORDER_ROW_ID
			FROM 
				#dsn2#.SHIP_ROW SR ,
				ORDER_ROW ORR
			WHERE 
				(
					SR.WRK_ROW_RELATION_ID = ORR.WRK_ROW_ID OR 
					SR.WRK_ROW_RELATION_ID IN (SELECT IRR.WRK_ROW_ID FROM #dsn2#.INVOICE_ROW IRR WHERE IRR.WRK_ROW_RELATION_ID = ORR.WRK_ROW_ID)
				)
				AND ORR.ORDER_ROW_ID IN (#arguments.order_row_id_list#)
			GROUP BY 
				ORR.ORDER_ROW_ID
		</cfquery>
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
				CONSUMER_ID IN (#arguments.consumer_id_list#)
			ORDER BY
				CONSUMER_ID
		</cfquery>
        <cfreturn GET_CONSUMER>
    </cffunction>

    <cffunction name="GET_BANK_INFO" access="remote" returntype="any">
        <cfargument name="order_id">
        <cfquery name="GET_BANK_INFO" datasource="#DSN2#">
            SELECT
                A.ACCOUNT_NO,
                A.ACCOUNT_NAME,
                A.BRANCH_CODE,
                A.ACCOUNT_OWNER_CUSTOMER_NO,
                BANK_BRANCH.BANK_BRANCH_NAME,
                SETUP_BANK_TYPES.BANK_NAME
            FROM
                BANK_ORDERS BO,
                #dsn3#.ACCOUNTS A,
                #dsn3#.BANK_BRANCH,
                #dsn#.SETUP_BANK_TYPES
            WHERE
                BANK_BRANCH.BANK_ID = SETUP_BANK_TYPES.BANK_ID AND
                A.ACCOUNT_BRANCH_ID = BANK_BRANCH.BANK_BRANCH_ID AND
                BO.ACCOUNT_ID = A.ACCOUNT_ID AND
                BO.ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.order_id#">
        </cfquery>
        <cfreturn GET_BANK_INFO>
    </cffunction>

    <cffunction name="GET_MONEY_CREDITS" access="remote" returntype="any">
        <cfargument name="order_id">
        <cfquery name="GET_MONEY_CREDITS" datasource="#DSN3#">
            SELECT 
                OMC.IS_TYPE,
                OMCU.ORDER_CREDIT_ID,
                OMCU.USED_VALUE 
            FROM 
                ORDER_MONEY_CREDIT_USED OMCU,
                ORDER_MONEY_CREDITS OMC
            WHERE 
                OMC.ORDER_CREDIT_ID = OMCU.ORDER_CREDIT_ID AND
                OMCU.ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.order_id#">
        </cfquery>
        <cfreturn GET_MONEY_CREDITS>
    </cffunction>   

    <cffunction name="GET_CONS_REF_CODE" access="remote" returntype="any">
        <cfquery name="GET_CONS_REF_CODE" datasource="#DSN#">
            SELECT CONSUMER_REFERENCE_CODE,CONSUMER_CAT_ID FROM CONSUMER WHERE CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.userid#">
        </cfquery>
        <cfreturn GET_CONS_REF_CODE>
    </cffunction>

    <cffunction name="GET_CAMP_ID" access="remote" returntype="any">
        <cfquery name="GET_CAMP_ID" datasource="#DSN3#">
            SELECT 
                CAMP_ID,
                CAMP_HEAD
            FROM 
                CAMPAIGNS 
            WHERE 
                CAMP_STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> AND
                CAMP_FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
        </cfquery>
        <cfreturn GET_CAMP_ID>
    </cffunction>

    <cffunction name="GET_INVOICE_DET" access="remote" returntype="any">
        <cfargument name="order_id">
        <cfquery name="GET_INVOICE_DET" datasource="#DSN3#">
            SELECT INVOICE_ID FROM ORDERS_INVOICE WHERE ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.order_id#"> AND PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.period_id#">
        </cfquery>
        <cfreturn GET_INVOICE_DET>
    </cffunction>

    <cffunction name="GET_PRINT_COUNT" access="remote" returntype="any">
        <cfargument name="invoice_id">
        <cfquery name="GET_PRINT_COUNT" datasource="#DSN2#">
			SELECT ISNULL(PRINT_COUNT,0) PRINT_COUNT FROM INVOICE WHERE INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.invoice_id#"> 
		</cfquery>
        <cfreturn GET_PRINT_COUNT>
    </cffunction>

    <cffunction name="GET_STORE" access="remote" returntype="any">
        <cfargument name="deliver_dept_id">
        <cfquery name="GET_STORE" datasource="#DSN#">
            SELECT 
                DEPARTMENT_ID,
                DEPARTMENT_HEAD 
            FROM 
                DEPARTMENT 
            WHERE 
                DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.deliver_dept_id#">
        </cfquery>
        <cfreturn GET_STORE>
    </cffunction>

    <cffunction name="GET_METHOD" access="remote" returntype="any">
        <cfargument name="ship_method">
        <cfquery name="GET_METHOD" datasource="#DSN#">
            SELECT 
                SHIP_METHOD_ID,
                SHIP_METHOD 
            FROM 
                SHIP_METHOD 
            WHERE 
                SHIP_METHOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.ship_method#">
        </cfquery>
        <cfreturn GET_METHOD>
    </cffunction>

    <cffunction name="GET_ORDER_MONEY" access="remote" returntype="any">
        <cfargument name="order_id">
        <cfquery name="GET_ORDER_MONEY" datasource="#DSN3#">
            SELECT 
                IS_SELECTED,
                MONEY_TYPE,
                RATE2
            FROM 
                ORDER_MONEY
            WHERE
                ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.order_id#"> AND 
                <cfif isdefined("session.pp.money")>
                    MONEY_TYPE <> <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.pp.money#">
                <cfelseif isdefined("session.ww.money")>
                    MONEY_TYPE <> <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ww.money#">
                <cfelse>
                    MONEY_TYPE <> <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money#">
                </cfif>
        </cfquery>
        <cfreturn GET_ORDER_MONEY>
    </cffunction>

    <cffunction name="GET_RISC_MONEY" access="remote" returntype="any">
        <cfquery name="GET_RISC_MONEY" datasource="#DSN#">
            SELECT 
                MONEY 
            FROM 
                COMPANY_CREDIT 
            WHERE 
                <cfif isdefined('session.pp.userid')> 
                    COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#">
                <cfelseif isdefined('session.ww.userid')>
                    CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#">
                </cfif>
        </cfquery>
        <cfreturn GET_RISC_MONEY>
    </cffunction>

    <cffunction name="GET_SELECTED_MONEY" access="remote" returntype="any">
        <cfargument name="order_id">
        <cfargument name="money">
        <cfquery name="GET_SELECTED_MONEY" datasource="#DSN3#">
            SELECT 
                MONEY_TYPE, 
                RATE2
            FROM 
                ORDER_MONEY 
            WHERE 
                ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.order_id#"> AND 
                <cfif isdefined('arguments.money') and len(arguments.money)>
                    MONEY_TYPE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.money#">
                <cfelse>
                    IS_SELECTED = 1
                </cfif>
        </cfquery>
        <cfreturn GET_SELECTED_MONEY>
    </cffunction>

    <cffunction name="GET_PROCESS" access="remote" returntype="any">
        <cfargument name="order_stage">
        <cfquery name="GET_PROCESS" datasource="#DSN#">
            SELECT STAGE,DETAIL FROM PROCESS_TYPE_ROWS WHERE PROCESS_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.order_stage#">
        </cfquery>	
        <cfreturn GET_PROCESS>
    </cffunction>

    <cffunction name="GET_SPECT" access="remote" returntype="any">
        <cfquery name="GET_SPECT" datasource="#DSN3#">
            SELECT
                SPECTS.SPECT_VAR_NAME,
                SPECTS_ROW.AMOUNT_VALUE,
                SPECTS_ROW.PRODUCT_NAME,
                SPECTS_ROW.TOTAL_VALUE,
                SPECTS_ROW.MONEY_CURRENCY,
                SPECTS_ROW.IS_CONFIGURE,
                SPECTS_ROW.DIFF_PRICE,
                SPECTS.PRODUCT_AMOUNT,
                SPECTS.PRODUCT_AMOUNT_CURRENCY,
                SPECTS_ROW.IS_PROPERTY,
                STOCKS.PRODUCT_DETAIL
            FROM
                SPECTS,
                SPECTS_ROW,
                STOCKS
            WHERE
                SPECTS.SPECT_VAR_ID = SPECTS_ROW.SPECT_ID AND
                SPECTS_ROW.SPECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.spect_var_id#"> AND
                SPECTS_ROW.STOCK_ID = STOCKS.STOCK_ID 
        </cfquery>
        <cfreturn GET_SPECT>
    </cffunction>
</cfcomponent>