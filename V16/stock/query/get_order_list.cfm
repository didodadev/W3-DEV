<cfif session.ep.isBranchAuthorization>
	<cfquery name="GET_MY_DEPARTMENT" datasource="#DSN#">
		SELECT DEPARTMENT_ID FROM #dsn_alias#.DEPARTMENT WHERE BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(session.ep.user_location,2,'-')#">
	</cfquery>
</cfif>
<cfif Len(attributes.product_code) and Len(attributes.product_cat)>
	<cfquery name="GET_CATEGORIES" datasource="#DSN1#">
		SELECT PRODUCT_ID FROM PRODUCT WHERE PRODUCT_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.product_code#.%">
	</cfquery>
</cfif>

<cfset new_dsn3 = '#dsn#_#attributes.our_comp_id#'>
<cfquery name="GET_ORDER_LIST" datasource="#DSN3#">
    WITH CTE1 AS (
    <cfif not len(attributes.cat) or listfind(attributes.cat,1) or listfind(attributes.cat,2)>
        <cfif not isdefined("attributes.records_problems")>
            SELECT
                <cfif Len(attributes.listing_type) and attributes.listing_type eq 1>
                    DISTINCT
                </cfif>
                1 TYPE_ID,
                O.ORDER_ID ISLEM_ID,
                O.FRM_BRANCH_ID,
                <cfif Len(attributes.listing_type) and attributes.listing_type neq 1>
                    ORR.ORDER_ROW_ID ISLEM_ROW_ID,
                    ORR.PRODUCT_ID URUN_ID,
                    ORR.STOCK_ID STOK_ID,
                    ORR.PRODUCT_NAME URUN_ADI,
                    ORR.SPECT_VAR_ID SPEC_ID,
                    (SELECT SPECT_MAIN_ID FROM SPECTS S WHERE S.SPECT_VAR_ID = ORR.SPECT_VAR_ID) SPEC_MAIN_ID,
                    ORR.SPECT_VAR_NAME SPEC_ADI,
                    ORR.QUANTITY MIKTAR,
                    ORR.UNIT BIRIM,
                    ORR.PRODUCT_NAME2,
                    ORR.WRK_ROW_ID WRK_ROW_ID,
                </cfif>
                O.ORDER_NUMBER ISLEM_NO,
                O.REF_NO,
                O.ORDER_HEAD,
                O.PARTNER_ID,
                O.COMPANY_ID,
                O.CONSUMER_ID,
                O.PRIORITY_ID,
                O.ORDER_ZONE,
                O.PURCHASE_SALES,
                O.ORDER_DATE ISLEM_TARIHI,
                O.ORDER_STAGE,
                <cfif attributes.listing_type eq 3>
                    ISNULL(ORR.DELIVER_DATE,O.DELIVERDATE) TESLIM_TARIHI,
                    ISNULL(ORR.DELIVER_DEPT,O.DELIVER_DEPT_ID) DEPT_IN,
                    ISNULL(ORR.DELIVER_LOCATION,O.LOCATION_ID) LOC_IN,
                <cfelse>
                    <cfif attributes.listing_type eq 2>
						ORR.DELIVER_DATE TESLIM_TARIHI,
					<cfelse>
						O.DELIVERDATE TESLIM_TARIHI,
					</cfif>		
                    <cfif x_department_search eq 1 and len(attributes.listing_type) and attributes.listing_type eq 2>
                        ORR.DELIVER_DEPT DEPT_IN,
                    <cfelse>
                        O.DELIVER_DEPT_ID DEPT_IN,
                    </cfif>
                    O.LOCATION_ID LOC_IN,
                </cfif>
                '' DEPT_OUT,
                '' LOC_OUT,
                O.RECORD_EMP,
                O.RECORD_DATE AS RECORD_DATE,
                ORR.ORDER_ROW_CURRENCY ORDER_CURRENCY,
                O.SALES_ADD_OPTION_ID SALES_ADD_OPTION_ID
				<cfif x_equipment_planning_info eq 1 and attributes.listing_type eq 3>
                    ,(ISNULL(GET_DEPT_AMOUNT_SPEC.STOCK_IN,0) - ISNULL(GET_DEPT_AMOUNT_SPEC.STOCK_OUT,0) ) AS STOCK_AMOUNT1
                    ,(ISNULL(GET_DEPT_AMOUNT_PRODUCT.STOCK_IN,0) - ISNULL(GET_DEPT_AMOUNT_PRODUCT.STOCK_OUT,0)) AS STOCK_AMOUNT2
                </cfif>
                ,PTR.STAGE
                ,BR.BRANCH_NAME
            FROM 
                #new_dsn3#.ORDER_ROW ORR WITH (NOLOCK) JOIN 
                #new_dsn3#.ORDERS O WITH (NOLOCK) ON ORR.ORDER_ID = O.ORDER_ID
                LEFT JOIN #dsn_alias#.BRANCH BR ON O.FRM_BRANCH_ID = BR.BRANCH_ID
                LEFT JOIN #dsn_alias#.PROCESS_TYPE_ROWS PTR ON O.ORDER_STAGE = PTR.PROCESS_ROW_ID
					<cfif x_equipment_planning_info eq 1 and attributes.listing_type eq 3>
                        LEFT JOIN 
                        (
                                SELECT
                                    SUM(SR.STOCK_IN) STOCK_IN,
                                    SUM(SR.STOCK_OUT) STOCK_OUT,
                                    SR.PRODUCT_ID,
                                    SR.STORE,
                                    SR.STORE_LOCATION,
                                    S.SPECT_VAR_ID,
                                    SR.STOCK_ID
                                FROM
                                     #dsn2_alias#.STOCKS_ROW SR,
                                    #dsn3_alias#.SPECTS S
                                WHERE
                                    S.SPECT_MAIN_ID = SR.SPECT_VAR_ID
                                GROUP BY
                                    SR.STOCK_ID,
                                    SR.PRODUCT_ID,
                                    SR.STORE,
                                    SR.STORE_LOCATION,
                                    S.SPECT_VAR_ID
                        ) AS GET_DEPT_AMOUNT_SPEC 
                        ON GET_DEPT_AMOUNT_SPEC.STOCK_ID = ORR.STOCK_ID 
                        AND ORR.PRODUCT_ID = GET_DEPT_AMOUNT_SPEC.PRODUCT_ID 
                        AND ISNULL(ORR.DELIVER_LOCATION,O.LOCATION_ID) = GET_DEPT_AMOUNT_SPEC.STORE_LOCATION 
                        AND GET_DEPT_AMOUNT_SPEC.SPECT_VAR_ID = ORR.SPECT_VAR_ID
                        AND ISNULL(ORR.DELIVER_DEPT,O.DELIVER_DEPT_ID) = GET_DEPT_AMOUNT_SPEC.STORE
                        LEFT JOIN
                        (
                        	  SELECT
                                SUM(SR.STOCK_IN) STOCK_IN,
                                SUM(SR.STOCK_OUT) STOCK_OUT,
                                SR.PRODUCT_ID,
                                SR.STORE,
                                SR.STORE_LOCATION
                            FROM
                                #dsn2_alias#.STOCKS_ROW SR
                            GROUP BY
                                SR.PRODUCT_ID,
                                SR.STORE,
                                SR.STORE_LOCATION
                        ) AS GET_DEPT_AMOUNT_PRODUCT 
                        ON GET_DEPT_AMOUNT_PRODUCT.PRODUCT_ID = ORR.PRODUCT_ID 
                        AND GET_DEPT_AMOUNT_PRODUCT.STORE = ISNULL(ORR.DELIVER_DEPT,O.DELIVER_DEPT_ID)
                        AND GET_DEPT_AMOUNT_PRODUCT.STORE_LOCATION = ISNULL(ORR.DELIVER_LOCATION,O.LOCATION_ID)
                    </cfif>    
                <cfif Len(attributes.product_cat_id) and Len(attributes.product_cat)>
                    ,#dsn1_alias#.PRODUCT PE 
                </cfif>
            WHERE
                O.ORDER_STATUS = 1
                AND ORR.ORDER_ROW_CURRENCY <> -4<!--- Kismi uretimler gelmesin --->
                <cfif x_show_surplus_delivery eq 0>
                    AND ORR.ORDER_ROW_CURRENCY <> -8<!--- Fazla Teslimat Asamasindakiler xmle bagli olarak gelmesin --->
                </cfif>
                <cfif x_show_production_currency eq 0>
                    AND ORR.ORDER_ROW_CURRENCY <> -5<!--- Uretim Asamasindakiler xmle bagli olarak gelmesin --->
                </cfif>
                <cfif x_show_open_currency eq 0>
                    AND ORR.ORDER_ROW_CURRENCY <> -1<!--- Açık Asamasindakiler xmle bagli olarak gelmesin --->
                </cfif>
                <cfif ListLen(x_show_product_cat_list)><!--- Sadece Belirtilen Kategoriye Ait Urunler Xmle Bagli Olarak Gelsin --->
                    AND ORR.PRODUCT_ID IN (SELECT PRODUCT_ID FROM #dsn1_alias#.PRODUCT P WHERE PRODUCT_CATID IN (#x_show_product_cat_list#))
                </cfif>
                <cfif Len(attributes.listing_type) and attributes.listing_type eq 3>
                    AND ORR.ORDER_ROW_CURRENCY <> -3<!--- Kapatildi Asamasindakiler gelmesin --->
                    AND ORR.WRK_ROW_ID IS NOT NULL
                </cfif>
                <cfif Len(attributes.record_emp_id) and Len(attributes.record_emp_name)>
                    AND O.RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.record_emp_id#">
                </cfif>
                <cfif isdefined('attributes.city') and len(attributes.city) and isdefined('attributes.city_id') and len(attributes.city_id)>
                    AND O.CITY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.city_id#">
                </cfif>
                <cfif isdefined('attributes.county') and len(attributes.county) and isdefined('attributes.county_id') and len(attributes.county_id)>
                    AND O.COUNTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.county_id#">
                </cfif>
                <cfif len(attributes.ship_method)>
                    AND O.SHIP_METHOD = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ship_method#">
                </cfif>
                <cfif isdefined("attributes.project_head") and len(attributes.project_head) and len(attributes.project_id)>
                    AND O.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
                </cfif>
                <cfif isdefined("attributes.ord_stage") and len(attributes.ord_stage)>
                    AND O.ORDER_STAGE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ord_stage#">
                </cfif>
                <cfif isdefined('attributes.stock_branch_id') and len(attributes.stock_branch_id)>
                    AND O.FRM_BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.stock_branch_id#">
                </cfif>
                <cfif x_department_search eq 1 and len(attributes.listing_type) and (attributes.listing_type eq 2 or attributes.listing_type eq 3)>
                    <cfif isdefined("attributes.department_txt") and len(attributes.department_txt) and len(attributes.department_id)>
                        AND ORR.DELIVER_DEPT = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department_id#">
                    </cfif>            
                <cfelse>
                    <cfif isdefined("attributes.department_txt") and len(attributes.department_txt) and len(attributes.department_id)>
                        AND O.DELIVER_DEPT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department_id#">
                       <cfif len(attributes.location_id)>
                            AND O.LOCATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.location_id#">
                       </cfif>
                    </cfif>
                </cfif>
                <cfif session.ep.isBranchAuthorization>
					<cfif get_my_department.recordcount>
                   		AND O.DELIVER_DEPT_ID IN (<cfqueryparam list="yes" cfsqltype="cf_sql_integer" value="#ValueList(get_my_department.department_id)#">)
					<cfelse>
						AND O.DELIVER_DEPT_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#listfirst(session.ep.user_location,'-')#">)
					</cfif>
                </cfif>
                <cfif len(attributes.company) and len(attributes.company_id)>
                    AND O.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
                <cfelseif len(attributes.company) and isdefined("attributes.consumer_id") and len(attributes.consumer_id)>
                    AND O.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
                </cfif>
                <cfif isdate(attributes.date1)>
                    AND <cfif attributes.listing_type eq 1>O.DELIVERDATE<cfelse>ISNULL(ORR.DELIVER_DATE,O.DELIVERDATE)</cfif> >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#">
                </cfif>
                <cfif isdate(attributes.date2)>
                    AND <cfif attributes.listing_type eq 1>O.DELIVERDATE<cfelse>ISNULL(ORR.DELIVER_DATE,O.DELIVERDATE)</cfif> <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#">
                </cfif>
                <cfif isdate(attributes.documentdate1)>
                    AND O.ORDER_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.documentdate1#">
                </cfif>
                <cfif isdate(attributes.documentdate2)>
                    AND O.ORDER_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.documentdate2#">
                </cfif>
                <cfif Len(attributes.stock_id) and Len(attributes.product_name)>
                    AND ORR.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.stock_id#">
                    <cfif Len(attributes.spect_main_id) and Len(attributes.spect_main_name)>
                        AND ORR.SPECT_VAR_ID IN (SELECT SPECT_VAR_ID FROM SPECTS WHERE SPECT_MAIN_ID IN (SELECT SPECT_MAIN_ID FROM SPECTS WHERE SPECT_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.spect_main_id#">))
                    </cfif>
                </cfif>
                <cfif Len(attributes.product_cat_id) and Len(attributes.product_cat)>
                    AND ORR.PRODUCT_ID = PE.PRODUCT_ID AND PRODUCT_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.product_code#.%">
                </cfif>
                AND ORR.ORDER_ROW_CURRENCY IN (
                    <cfif not len(attributes.currency_id)>
                        <cfqueryparam cfsqltype="cf_sql_integer" value="-1,-3,-5,-6,-8,-7" list="yes">
                        <cfif ListLen(xml_order_currency_id)><!--- Belirtilen Onaylanmış Sipariş Aşamalarına Ait Urunler Xmle Bagli Olarak Gelsin --->
                            ,<cfqueryparam cfsqltype="cf_sql_integer" value="#xml_order_currency_id#" list="yes">
                        </cfif>
                    <cfelse>
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.currency_id#">
                    </cfif>)
                <cfif len(attributes.keyword) or (isdefined("attributes.order_no") and len(attributes.order_no))>
                    AND
                    (
                        <cfif isdefined("attributes.order_no") and len(attributes.order_no)>
                            (O.ORDER_NUMBER LIKE '<cfif len(attributes.order_no) gt 3>%</cfif>#attributes.order_no#%')
                        <cfelse>
                            (O.ORDER_NUMBER LIKE '<cfif len(attributes.keyword) gt 3>%</cfif>#attributes.keyword#%') OR
                            (O.ORDER_HEAD LIKE '<cfif len(attributes.keyword) gt 3>%</cfif>#attributes.keyword#%') OR
                            (O.REF_NO LIKE '<cfif len(attributes.keyword) gt 3>%</cfif>#attributes.keyword#%')
                        </cfif>
                    )
                </cfif>
                <cfif len(attributes.ref_no)>
                    AND O.REF_NO LIKE '<cfif len(attributes.ref_no) gt 3>%</cfif>#attributes.ref_no#%'
                </cfif>
                <cfif len(attributes.sale_add_option)>
                    AND O.SALES_ADD_OPTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sale_add_option#">
                </cfif>
                <cfif isdefined('attributes.subscription_id') and len(attributes.subscription_id) and isdefined('attributes.subscription_no') and len(attributes.subscription_no)>
                    AND O.SUBSCRIPTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.subscription_id#">
                </cfif>
                <cfif listfind(attributes.cat,1) and not listfind(attributes.cat,2)>
                    AND	(O.ORDER_ZONE = 0 AND O.PURCHASE_SALES = 0)
                <cfelseif listfind(attributes.cat,2) and not listfind(attributes.cat,1)>
                    AND ( (O.PURCHASE_SALES = 1 AND O.ORDER_ZONE = 0) OR (O.PURCHASE_SALES = 0 AND O.ORDER_ZONE = 1) )
                </cfif>
                <cfif isdefined("attributes.is_dispatch")>
                    AND O.IS_DISPATCH = 0
                </cfif>
                <cfif (Len(attributes.product_brand_name) and Len(attributes.product_brand_id)) or (Len(attributes.product_model_name) and Len(attributes.product_model_id))>
                    AND ORR.PRODUCT_ID IN 	(
                                                SELECT
                                                    PRODUCT_ID
                                                FROM
                                                    #dsn1_alias#.PRODUCT
                                                WHERE
                                                    1 = 1
                                                    <cfif Len(attributes.product_brand_name) and Len(attributes.product_brand_id)>
                                                    AND BRAND_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_brand_id#">
                                                    </cfif>
                                                    <cfif Len(attributes.product_model_name) and Len(attributes.product_model_id)>
                                                    AND SHORT_CODE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_model_id#">
                                                    </cfif>
                                            )
                </cfif>
                <cfif isDefined("attributes.planning_status") and Len(attributes.planning_status)>
                    AND ORR.WRK_ROW_ID <cfif attributes.planning_status eq 0>NOT</cfif> IN (	SELECT
                                                                                                    SRR.WRK_ROW_RELATION_ID
                                                                                                FROM
                                                                                                    #dsn2_alias#.SHIP_RESULT SR,
                                                                                                    #dsn2_alias#.SHIP_RESULT_ROW SRR
                                                                                                WHERE
                                                                                                    SR.SHIP_RESULT_ID = SRR.SHIP_RESULT_ID AND
                                                                                                    SRR.ORDER_ROW_ID = ORR.ORDER_ROW_ID AND
                                                                                                    SRR.ORDER_ROW_AMOUNT > 0 AND
                                                                                                    SR.OUT_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.planning_date#">
                                                                                            )
                </cfif>
                <cfif isdefined('attributes.zone_id') and len(attributes.zone_id)>
                    AND O.DELIVER_DEPT_ID IN 
                        (SELECT 
                            D.DEPARTMENT_ID 
                        FROM 
                            #dsn_alias#.DEPARTMENT D,
                            #dsn_alias#.BRANCH B
                        WHERE 
                            D.BRANCH_ID = B.BRANCH_ID AND
                            B.ZONE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.zone_id#">
                        )
                </cfif>
				<cfif isdefined('attributes.SZ_ID') and len(attributes.SZ_ID)>
					AND O.ZONE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.SZ_ID#">
			    </cfif>
        <cfelse>
            <!--- Sevkiyat sonuclarindan gelen sorunlu turundeki kayitlar icin --->
            <cfif attributes.listing_type eq 3>
                <cfif not isdefined("attributes.records_problems")>UNION</cfif>
                SELECT
                    5 TYPE_ID,
                    O.FRM_BRANCH_ID,
                    O.ORDER_ID ISLEM_ID,
                    ORR.ORDER_ROW_ID ISLEM_ROW_ID,
                    ORR.PRODUCT_ID URUN_ID,
                    ORR.STOCK_ID STOK_ID,
                    ORR.PRODUCT_NAME URUN_ADI,
                    ORR.SPECT_VAR_ID SPEC_ID,
                    (SELECT SPECT_MAIN_ID FROM SPECTS S WHERE S.SPECT_VAR_ID = ORR.SPECT_VAR_ID) SPEC_MAIN_ID,
                    ORR.SPECT_VAR_NAME SPEC_ADI,
                    ORR.QUANTITY MIKTAR,
                    ORR.UNIT BIRIM,
                    ORR.PRODUCT_NAME2,
                    ORR.WRK_ROW_ID WRK_ROW_ID,
                    O.ORDER_NUMBER ISLEM_NO,
                    O.REF_NO,
                    O.ORDER_HEAD,
                    O.PARTNER_ID,
                    O.COMPANY_ID,
                    O.CONSUMER_ID,
                    O.PRIORITY_ID,
                    O.ORDER_ZONE,
                    O.PURCHASE_SALES,
                    O.ORDER_DATE ISLEM_TARIHI,
                    O.ORDER_STAGE,
                    ISNULL(ORR.DELIVER_DATE,O.DELIVERDATE) TESLIM_TARIHI,
                    ISNULL(ORR.DELIVER_DEPT,O.DELIVER_DEPT_ID) DEPT_IN,
                    ISNULL(ORR.DELIVER_LOCATION,O.LOCATION_ID) LOC_IN,
                    '' DEPT_OUT,
                    '' LOC_OUT,
                    O.RECORD_EMP,
                    O.RECORD_DATE AS RECORD_DATE,
                    ORR.ORDER_ROW_CURRENCY ORDER_CURRENCY,
                    O.SALES_ADD_OPTION_ID SALES_ADD_OPTION_ID
                    <cfif x_equipment_planning_info eq 1 and attributes.listing_type eq 3>
                    ,(ISNULL(GET_DEPT_AMOUNT_SPEC.STOCK_IN,0) - ISNULL(GET_DEPT_AMOUNT_SPEC.STOCK_OUT,0) ) AS STOCK_AMOUNT1
                    ,(ISNULL(GET_DEPT_AMOUNT_PRODUCT.STOCK_IN,0) - ISNULL(GET_DEPT_AMOUNT_PRODUCT.STOCK_OUT,0)) AS STOCK_AMOUNT2
                    </cfif>
                	,PTR.STAGE
                    ,BR.BRANCH_NAME
                FROM
                    #dsn2_alias#.SHIP_RESULT_ROW SRR,
                    #new_dsn3#.ORDERS O WITH (NOLOCK) JOIN 
                    #new_dsn3#.ORDER_ROW ORR WITH (NOLOCK) ON O.ORDER_ID = ORR.ORDER_ID
                    LEFT JOIN #dsn_alias#.BRANCH BR ON O.FRM_BRANCH_ID = BR.BRANCH_ID
                    LEFT JOIN #dsn_alias#.PROCESS_TYPE_ROWS PTR ON O.ORDER_STAGE = PTR.PROCESS_ROW_ID
					<cfif x_equipment_planning_info eq 1 and attributes.listing_type eq 3>
                    LEFT JOIN 
                    (
                            SELECT
                                SUM(SR.STOCK_IN) STOCK_IN,
                                SUM(SR.STOCK_OUT) STOCK_OUT,
                                SR.PRODUCT_ID,
                                SR.STORE,
                                SR.STORE_LOCATION,
                                S.SPECT_VAR_ID,
                                SR.STOCK_ID
                            FROM
                                 #dsn2_alias#.STOCKS_ROW SR,
                                #dsn3_alias#.SPECTS S
                            WHERE
                                S.SPECT_MAIN_ID = SR.SPECT_VAR_ID
                            GROUP BY
                                SR.STOCK_ID,
                                SR.PRODUCT_ID,
                                SR.STORE,
                                SR.STORE_LOCATION,
                                S.SPECT_VAR_ID
                    ) AS GET_DEPT_AMOUNT_SPEC 
                    ON GET_DEPT_AMOUNT_SPEC.STOCK_ID = ORR.STOCK_ID 
                    AND ORR.PRODUCT_ID = GET_DEPT_AMOUNT_SPEC.PRODUCT_ID 
                    AND ISNULL(ORR.DELIVER_LOCATION,O.LOCATION_ID) = GET_DEPT_AMOUNT_SPEC.STORE_LOCATION 
                    AND GET_DEPT_AMOUNT_SPEC.SPECT_VAR_ID = ORR.SPECT_VAR_ID
                    AND ISNULL(ORR.DELIVER_DEPT,O.DELIVER_DEPT_ID) = GET_DEPT_AMOUNT_SPEC.STORE
                    LEFT JOIN
                        (
                        	  SELECT
                                SUM(SR.STOCK_IN) STOCK_IN,
                                SUM(SR.STOCK_OUT) STOCK_OUT,
                                SR.PRODUCT_ID,
                                SR.STORE,
                                SR.STORE_LOCATION
                            FROM
                                #dsn2_alias#.STOCKS_ROW SR
                            GROUP BY
                                SR.PRODUCT_ID,
                                SR.STORE,
                                SR.STORE_LOCATION
                        ) AS GET_DEPT_AMOUNT_PRODUCT 
                        ON GET_DEPT_AMOUNT_PRODUCT.PRODUCT_ID = ORR.PRODUCT_ID 
                        AND GET_DEPT_AMOUNT_PRODUCT.STORE = ISNULL(ORR.DELIVER_DEPT,O.DELIVER_DEPT_ID)
                        AND GET_DEPT_AMOUNT_PRODUCT.STORE_LOCATION = ISNULL(ORR.DELIVER_LOCATION,O.LOCATION_ID)
                    </cfif>
                    ,
                    #dsn2_alias#.SHIP_RESULT_ROW_COMPLETE SHC
                WHERE 
                    SRR.WRK_ROW_RELATION_ID = ORR.WRK_ROW_ID AND
                    SRR.SHIP_RESULT_ID = SHC.SHIP_RESULT_ID AND
                    SRR.WRK_ROW_ID = SHC.WRK_ROW_RELATION_ID AND
                    SHC.PROBLEM_RESULT_ID = 1 AND
                    SHC.IS_GIVE_SERVICE = 0 AND
                    SRR.SHIP_RESULT_ROW_ID = ( SELECT  MAX(SRRR.SHIP_RESULT_ROW_ID) FROM #dsn2_alias#.SHIP_RESULT_ROW SRRR WHERE SRRR.WRK_ROW_RELATION_ID=ORR.WRK_ROW_ID)
                    AND O.ORDER_STATUS = 1
                   -- AND ORR.ORDER_ID = O.ORDER_ID
                    <cfif ListLen(x_show_product_cat_list)><!--- Sadece Belirtilen Kategoriye Ait Urunler Xmle Bagli Olarak Gelsin --->
                        AND ORR.PRODUCT_ID IN (SELECT PRODUCT_ID FROM #dsn1_alias#.PRODUCT P WHERE PRODUCT_CATID IN (#x_show_product_cat_list#))
                    </cfif>
                    <cfif Len(attributes.record_emp_id) and Len(attributes.record_emp_name)>
                        AND O.RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.record_emp_id#">
                    </cfif>
                    <cfif isdefined('attributes.city') and len(attributes.city) and isdefined('attributes.city_id') and len(attributes.city_id)>
                        AND O.CITY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.city_id#">
                    </cfif>
                    <cfif isdefined('attributes.county') and len(attributes.county) and isdefined('attributes.county_id') and len(attributes.county_id)>
                        AND O.COUNTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.county_id#">
                    </cfif>
                    <cfif len(attributes.ship_method)>
                        AND O.SHIP_METHOD = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ship_method#">
                    </cfif>
                    <cfif isdefined("attributes.project_head") and len(attributes.project_head) and len(attributes.project_id)>
                        AND O.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
                    </cfif>
                    <cfif isdefined("attributes.ord_stage") and len(attributes.ord_stage)>
                        AND O.ORDER_STAGE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ord_stage#">
                    </cfif>
					<cfif isdefined('attributes.stock_branch_id') and len(attributes.stock_branch_id)>
                        AND O.FRM_BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.stock_branch_id#">
                    </cfif>
                    <cfif isdefined("attributes.department_txt") and len(attributes.department_txt) and len(attributes.department_id)>
                        AND O.DELIVER_DEPT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department_id#">
                    </cfif>
                    <cfif session.ep.isBranchAuthorization>
                        AND O.DELIVER_DEPT_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#listfirst(session.ep.user_location,'-')#">)
                    </cfif>
                    <cfif len(attributes.company) and len(attributes.company_id)>
                        AND O.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
                    <cfelseif len(attributes.company) and isdefined("attributes.consumer_id") and len(attributes.consumer_id)>
                        AND O.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
                    </cfif>
                    <cfif isdate(attributes.date1)>
                        AND <cfif attributes.listing_type eq 1>O.DELIVERDATE<cfelse>ORR.DELIVER_DATE</cfif> >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#">
                    </cfif>
                    <cfif isdate(attributes.date2)>
                        AND <cfif attributes.listing_type eq 1>O.DELIVERDATE<cfelse>ORR.DELIVER_DATE</cfif> <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#">
                    </cfif>
                    <cfif isdate(attributes.documentdate1)>
                        AND O.ORDER_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.documentdate1#">
                    </cfif>
                    <cfif isdate(attributes.documentdate2)>
                        AND O.ORDER_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.documentdate2#">
                    </cfif>
                    <cfif Len(attributes.stock_id) and Len(attributes.product_name)>
                        AND ORR.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.stock_id#">
                        <cfif Len(attributes.spect_main_id) and Len(attributes.spect_main_name)>
                            AND ORR.SPECT_VAR_ID IN (SELECT SPECT_VAR_ID FROM SPECTS WHERE SPECT_MAIN_ID IN (SELECT SPECT_MAIN_ID FROM SPECTS WHERE SPECT_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.spect_main_id#">))
                        </cfif>
                    </cfif>
                    <cfif Len(attributes.product_cat_id) and Len(attributes.product_cat)>
                        AND ORR.PRODUCT_ID = PE.PRODUCT_ID 
                    </cfif>
                    AND ORR.ORDER_ROW_CURRENCY IN (
                        <cfif not len(attributes.currency_id)>
                            <cfqueryparam cfsqltype="cf_sql_integer" value="-3,-5,-6,-8,-7" list="yes">
                            <cfif ListLen(xml_order_currency_id)><!--- Belirtilen Onaylanmış Sipariş Aşamalarına Ait Urunler Xmle Bagli Olarak Gelsin --->
                                ,<cfqueryparam cfsqltype="cf_sql_integer" value="#xml_order_currency_id#" list="yes">
                            </cfif>
                        <cfelse>
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.currency_id#">
                        </cfif>)
                    <cfif len(attributes.keyword)>
                        AND
                        (
                            (O.ORDER_NUMBER LIKE '<cfif len(attributes.keyword) gt 3>%</cfif>#attributes.keyword#%') OR
                            (O.ORDER_HEAD LIKE '<cfif len(attributes.keyword) gt 3>%</cfif>#attributes.keyword#%') OR
                            (O.REF_NO LIKE '<cfif len(attributes.keyword) gt 3>%</cfif>#attributes.keyword#%') OR
                            (ORR.PRODUCT_NAME LIKE '<cfif len(attributes.keyword) gt 3>%</cfif>#attributes.keyword#%')
                            <cfif isdefined("x_filter_row_detail") and x_filter_row_detail eq 1>
                                OR (ORR.PRODUCT_NAME2 LIKE '<cfif len(attributes.keyword) gt 3>%</cfif>#attributes.keyword#%')
                            </cfif>
                            OR (SELECT P.PRODUCT_CODE_2 FROM PRODUCT P WHERE P.PRODUCT_ID = ORR.PRODUCT_ID) LIKE '<cfif len(attributes.keyword) gt 3>%</cfif>#attributes.keyword#%'
                            OR (SELECT P.MANUFACT_CODE FROM PRODUCT P WHERE P.PRODUCT_ID = ORR.PRODUCT_ID) LIKE '<cfif len(attributes.keyword) gt 3>%</cfif>#attributes.keyword#%'
                        )
                    </cfif>
                    <cfif len(attributes.ref_no)>
                        AND O.REF_NO LIKE '<cfif len(attributes.ref_no) gt 3>%</cfif>#attributes.ref_no#%'
                    </cfif>
                    <cfif len(attributes.sale_add_option)>
                        AND O.SALES_ADD_OPTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sale_add_option#">
                    </cfif>
                    <cfif isdefined('attributes.subscription_id') and len(attributes.subscription_id) and isdefined('attributes.subscription_no') and len(attributes.subscription_no)>
                        AND O.SUBSCRIPTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.subscription_id#">
                    </cfif>
                    <cfif listfind(attributes.cat,1) and not listfind(attributes.cat,2)>
                        AND	(O.ORDER_ZONE = 0 AND O.PURCHASE_SALES = 0)
                    <cfelseif listfind(attributes.cat,2) and not listfind(attributes.cat,1)>
                        AND ( (O.PURCHASE_SALES = 1 AND O.ORDER_ZONE = 0) OR (O.PURCHASE_SALES = 0 AND O.ORDER_ZONE = 1) )
                    </cfif>
                    <cfif (Len(attributes.product_brand_name) and Len(attributes.product_brand_id)) or (Len(attributes.product_model_name) and Len(attributes.product_model_id))>
                        AND ORR.PRODUCT_ID IN 	(
                                                    SELECT
                                                        PRODUCT_ID
                                                    FROM
                                                        #dsn1_alias#.PRODUCT
                                                    WHERE
                                                        1 = 1
                                                        <cfif Len(attributes.product_brand_name) and Len(attributes.product_brand_id)>
                                                        AND BRAND_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_brand_id#">
                                                        </cfif>
                                                        <cfif Len(attributes.product_model_name) and Len(attributes.product_model_id)>
                                                        AND SHORT_CODE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_model_id#">
                                                        </cfif>
                                                )
                    </cfif>
                    <cfif isdefined('attributes.zone_id') and len(attributes.zone_id)>
                        AND O.DELIVER_DEPT_ID IN 
                            (SELECT 
                                D.DEPARTMENT_ID 
                            FROM 
                                #dsn_alias#.DEPARTMENT D,
                                #dsn_alias#.BRANCH B
                            WHERE 
                                D.BRANCH_ID = B.BRANCH_ID AND
                                B.ZONE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.zone_id#">
                            )
                    </cfif>
				<cfif isdefined('attributes.SZ_ID') and len(attributes.SZ_ID)>
					AND O.ZONE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.SZ_ID#">
			    </cfif>
            </cfif>
            <!--- Sevkiyat sonuclarindan gelen sorunlu turundeki kayitlar icin --->
        </cfif>
    </cfif>
    
    <!--- Sevkiyat Bazinda Buradan sonraki bilgilere gerek yok --->
    <cfif ListFind('1,2',attributes.listing_type,',') and not (isDefined("attributes.stock_branch_id") and len(attributes.stock_branch_id))>
        <cfif  not len(attributes.cat) or ((listfind(attributes.cat,1) or listfind(attributes.cat,2)) and (listfind(attributes.cat,3) or listfind(attributes.cat,4)))><!--- keyword varsa ship_internale girmeyecek --->
           UNION <cfif Len(attributes.listing_type) and attributes.listing_type eq 2>ALL</cfif>
        </cfif>
        <cfif not len(attributes.cat) or listfind(attributes.cat,3) or listfind(attributes.cat,4)><!--- Islenen Sevk Talepleri, Islenmeyen Sevk Talepleri --->
            SELECT
                <cfif Len(attributes.listing_type) and attributes.listing_type eq 1>
                    DISTINCT
                </cfif>
                2 TYPE_ID,
                '' AS FRM_BRANCH_ID,
                SI.DISPATCH_SHIP_ID ISLEM_ID,
                <cfif Len(attributes.listing_type) and attributes.listing_type eq 2>
                    '' ISLEM_ROW_ID,
                    PRODUCT_ID URUN_ID,
                    STOCK_ID STOK_ID,
                    NAME_PRODUCT URUN_ADI,
                    '' SPEC_ID,
                    '' SPEC_MAIN_ID,
                    '' SPEC_ADI,
                    SIR.AMOUNT MIKTAR,
                    SIR.UNIT BIRIM,
                    SIR.PRODUCT_NAME2,
                    '' WRK_ROW_ID,
                </cfif>
                CAST(SI.DISPATCH_SHIP_ID AS NVARCHAR(50)) ISLEM_NO,
                '' REF_NO,
                LEFT(SI.DETAIL,25) ORDER_HEAD,
                -1 PARTNER_ID,
                -1 COMPANY_ID,
                -1 CONSUMER_ID,
                -99 PRIORITY_ID,
                -1 ORDER_ZONE,
                -1 PURCHASE_SALES,
                SI.SHIP_DATE ISLEM_TARIHI,
                SI.PROCESS_STAGE ORDER_STAGE,
                SI.DELIVER_DATE TESLIM_TARIHI,
                SI.DEPARTMENT_IN DEPT_IN,
                SI.LOCATION_IN LOC_IN,
                SI.DEPARTMENT_OUT DEPT_OUT,
                SI.LOCATION_OUT LOC_OUT,
                SI.RECORD_EMP,
                SI.RECORD_DATE AS RECORD_DATE,
                0 ORDER_CURRENCY,
                -1 SALES_ADD_OPTION_ID,
                PTR.STAGE,
                '' AS BRANCH_NAME
            FROM 
                <cfif Len(attributes.listing_type) and attributes.listing_type eq 2>
                    #dsn2_alias#.SHIP_INTERNAL_ROW SIR,
                </cfif>
                #dsn2_alias#.SHIP_INTERNAL SI
                LEFT JOIN #dsn_alias#.PROCESS_TYPE_ROWS PTR ON SI.PROCESS_STAGE = PTR.PROCESS_ROW_ID
            WHERE
                1 = 1
                <cfif Len(attributes.listing_type) and attributes.listing_type eq 2>
                    AND SIR.DISPATCH_SHIP_ID = SI.DISPATCH_SHIP_ID
                    <cfif ListLen(x_show_product_cat_list)><!--- Sadece Belirtilen Kategoriye Ait Urunler Xmle Bagli Olarak Gelsin --->
                        AND SIR.PRODUCT_ID IN (SELECT PRODUCT_ID FROM #dsn1_alias#.PRODUCT P WHERE PRODUCT_CATID IN (#x_show_product_cat_list#))
                    </cfif>
                </cfif>
                <cfif Len(attributes.record_emp_id) and Len(attributes.record_emp_name)>
                    AND SI.RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.record_emp_id#">
                </cfif>
                <cfif len(attributes.ship_method)>
                    AND SI.SHIP_METHOD = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ship_method#">
                </cfif>
                <cfif isdefined("attributes.ord_stage") and len(attributes.ord_stage)>
                    AND SI.PROCESS_STAGE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ord_stage#">
                </cfif>
                <cfif isdefined("attributes.department_txt") and len(attributes.department_txt) and len(attributes.department_id)>
                    AND (	
                            SI.DEPARTMENT_IN = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department_id#"> OR 
                            SI.DEPARTMENT_OUT = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department_id#">
                        )
                </cfif>
                <cfif session.ep.isBranchAuthorization>
                    AND (	
                            SI.DEPARTMENT_IN = <cfqueryparam cfsqltype="cf_sql_integer" value="#listfirst(session.ep.user_location,'-')#"> OR 
                            SI.DEPARTMENT_OUT = <cfqueryparam cfsqltype="cf_sql_integer" value="#listfirst(session.ep.user_location,'-')#">
                        )
                </cfif>
                <cfif isdate(attributes.date1)>
                    AND (<cfif attributes.listing_type eq 2>SIR.DELIVER_DATE<cfelse>SI.DELIVER_DATE</cfif> >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#"> OR <cfif attributes.listing_type eq 2>SIR.DELIVER_DATE<cfelse>SI.DELIVER_DATE</cfif> IS NULL)
                </cfif>
                <cfif isdate(attributes.date2)>
                    AND (<cfif attributes.listing_type eq 2>SIR.DELIVER_DATE<cfelse>SI.DELIVER_DATE</cfif> <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#"> OR <cfif attributes.listing_type eq 2>SIR.DELIVER_DATE<cfelse>SI.DELIVER_DATE</cfif> IS NULL)
                </cfif>
                <cfif isdate(attributes.documentdate1)>
                    AND (SI.SHIP_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.documentdate1#"> OR SI.SHIP_DATE IS NULL)
                </cfif>
                <cfif isdate(attributes.documentdate2)>
                    AND (SI.SHIP_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.documentdate2#"> OR SI.SHIP_DATE IS NULL)
                </cfif>
                <cfif (Len(attributes.stock_id) and Len(attributes.product_name)) or (Len(attributes.product_cat_id) and Len(attributes.product_cat))>
                    <cfif Len(attributes.listing_type) and attributes.listing_type eq 1><!--- Belge Bazinda --->
                        AND SI.DISPATCH_SHIP_ID IN (	SELECT
                                                        DISPATCH_SHIP_ID
                                                    FROM
                                                        #dsn2_alias#.SHIP_INTERNAL_ROW
                                                    WHERE
                                                        <cfif Len(attributes.stock_id) and Len(attributes.product_name)>
                                                            STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.stock_id#">
                                                            <cfif Len(attributes.spect_main_id) and Len(attributes.spect_main_name)>
                                                                AND SPECT_VAR_ID IN (SELECT SPECT_VAR_ID FROM SPECTS WHERE SPECT_MAIN_ID IN (SELECT SPECT_MAIN_ID FROM SPECTS WHERE SPECT_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.spect_main_id#">))
                                                            </cfif>
                                                        <cfelse>
                                                            PRODUCT_ID IN (#ValueList(get_categories.product_id,',')#)
                                                        </cfif>
                                                )
                    <cfelse><!--- Satir Bazinda --->
                        <cfif Len(attributes.stock_id) and Len(attributes.product_name)>
                            SIR.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.stock_id#">
                            <cfif Len(attributes.spect_main_id) and Len(attributes.spect_main_name)>
                                AND SIR.SPECT_VAR_ID IN (SELECT SPECT_VAR_ID FROM SPECTS WHERE SPECT_MAIN_ID IN (SELECT SPECT_MAIN_ID FROM SPECTS WHERE SPECT_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.spect_main_id#">))
                            </cfif>
                        <cfelse>
                            AND SIR.PRODUCT_ID IN (#ValueList(get_categories.product_id,',')#)
                        </cfif>
                    </cfif>
                </cfif>
                <cfif len(attributes.keyword)>
                    AND
                    (
                        (SI.DISPATCH_SHIP_ID LIKE '<cfif len(attributes.keyword) gt 3>%</cfif>#attributes.keyword#%') OR
                        (SI.DETAIL LIKE '<cfif len(attributes.keyword) gt 3>%</cfif>#attributes.keyword#%')
                        <cfif Len(attributes.listing_type) and attributes.listing_type eq 2>
                            OR (SIR.NAME_PRODUCT LIKE '<cfif len(attributes.keyword) gt 3>%</cfif>#attributes.keyword#%')
                            OR (SELECT P.PRODUCT_CODE_2 FROM PRODUCT P WHERE P.PRODUCT_ID = SIR.PRODUCT_ID) LIKE '<cfif len(attributes.keyword) gt 3>%</cfif>#attributes.keyword#%'
                            OR (SELECT P.MANUFACT_CODE FROM PRODUCT P WHERE P.PRODUCT_ID = SIR.PRODUCT_ID) LIKE '<cfif len(attributes.keyword) gt 3>%</cfif>#attributes.keyword#%'
                        </cfif>
                        
                    )
                </cfif>
                <cfif isDefined("attributes.cat") and listfind(attributes.cat,3) and not listfind(attributes.cat,4)>
                    AND SI.DISPATCH_SHIP_ID IN (SELECT DISPATCH_SHIP_ID FROM #dsn2_alias#.SHIP WHERE DISPATCH_SHIP_ID IS NOT NULL)
                <cfelseif isDefined("attributes.cat") and listfind(attributes.cat,4) and not listfind(attributes.cat,3)>
                    AND SI.DISPATCH_SHIP_ID NOT IN (SELECT DISPATCH_SHIP_ID FROM #dsn2_alias#.SHIP WHERE DISPATCH_SHIP_ID IS NOT NULL)
                </cfif>
                <cfif isdefined('attributes.zone_id') and len(attributes.zone_id)>
                    AND(
                        (SI.DEPARTMENT_IN IN 
                            (SELECT 
                                D.DEPARTMENT_ID 
                            FROM 
                                #dsn_alias#.DEPARTMENT D,
                                #dsn_alias#.BRANCH B
                            WHERE 
                                D.BRANCH_ID = B.BRANCH_ID AND
                                B.ZONE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.zone_id#">
                            )
                        ) 
                        OR
                        (SI.DEPARTMENT_OUT IN 
                            (SELECT 
                                D.DEPARTMENT_ID 
                            FROM 
                                #dsn_alias#.DEPARTMENT D,
                                #dsn_alias#.BRANCH B
                            WHERE 
                                D.BRANCH_ID = B.BRANCH_ID AND
                                B.ZONE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.zone_id#">
                            )
                        )
                    )
                </cfif>
        </cfif>
        <cfif not (isdefined("attributes.ord_stage") and len(attributes.ord_stage) and isDefined("attributes.stock_branch_id"))><!--- Surec burada kullanilmadigindan girmesine gerek yok --->
            <cfif not len(attributes.cat) or ((listfind(attributes.cat,1) or listfind(attributes.cat,2) or listfind(attributes.cat,3) or listfind(attributes.cat,4)) and (listfind(attributes.cat,5) or listfind(attributes.cat,6)))>
                UNION <cfif Len(attributes.listing_type) and attributes.listing_type eq 2>ALL</cfif>
            </cfif>
            <cfif not len(attributes.cat) or listfind(attributes.cat,5) or listfind(attributes.cat,6)><!--- Teslim Alinan Irsaliyeler, Teslim Alinmayan Irsaliyeler --->
                SELECT
                    <cfif Len(attributes.listing_type) and attributes.listing_type eq 1>
                        DISTINCT
                    </cfif>
                    3 TYPE_ID,
                    '' AS FRM_BRANCH_ID,
                    S.SHIP_ID ISLEM_ID,
                    <cfif Len(attributes.listing_type) and attributes.listing_type eq 2>
                        SHIP_ROW_ID ISLEM_ROW_ID,
                        PRODUCT_ID URUN_ID,
                        STOCK_ID STOK_ID,
                        NAME_PRODUCT URUN_ADI,
                        SPECT_VAR_ID SPEC_ID,
                        (SELECT SPECT_MAIN_ID FROM SPECTS S WHERE S.SPECT_VAR_ID = SR.SPECT_VAR_ID) SPEC_MAIN_ID,
                        SPECT_VAR_NAME SPEC_ADI,
                        AMOUNT MIKTAR,
                        UNIT BIRIM,
                        PRODUCT_NAME2 PRODUCT_NAME2,
                        WRK_ROW_ID WRK_ROW_ID,
                    </cfif>
                    S.SHIP_NUMBER ISLEM_NO,
                    '' ORDER_HEAD,
                    '' REF_NO,
                    -1 PARTNER_ID,
                    -1 COMPANY_ID,
                    -1 CONSUMER_ID,
                    -99 PRIORITY_ID,
                    -1 ORDER_ZONE,
                    -1 PURCHASE_SALES,
                    S.SHIP_DATE ISLEM_TARIHI,
                    0 ORDER_STAGE,
                    S.DELIVER_DATE TESLIM_TARIHI,
                    S.DEPARTMENT_IN DEPT_IN,
                    S.LOCATION_IN LOC_IN,
                    S.DELIVER_STORE_ID DEPT_OUT,
                    S.LOCATION LOC_OUT,
                    S.RECORD_EMP,
                    S.RECORD_DATE AS RECORD_DATE,
                    -1 ORDER_CURRENCY,
                    -1 SALES_ADD_OPTION_ID,
                    '' STAGE,
                    '' AS BRANCH_NAME
                FROM 
                    <cfif Len(attributes.listing_type) and attributes.listing_type eq 2>
                        #dsn2_alias#.SHIP_ROW SR,
                    </cfif>
                    #dsn2_alias#.SHIP S
                WHERE
                    S.SHIP_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="81">
                    AND S.IS_SHIP_IPTAL = 0
                    <cfif Len(attributes.listing_type) and attributes.listing_type eq 2>
                        AND SR.SHIP_ID = S.SHIP_ID
                        <cfif ListLen(x_show_product_cat_list)><!--- Sadece Belirtilen Kategoriye Ait Urunler Xmle Bagli Olarak Gelsin --->
                            AND SR.PRODUCT_ID IN (SELECT PRODUCT_ID FROM #dsn1_alias#.PRODUCT P WHERE PRODUCT_CATID IN (#x_show_product_cat_list#))
                        </cfif>
                    </cfif>
                    <cfif Len(attributes.record_emp_id) and Len(attributes.record_emp_name)>
                        AND S.RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.record_emp_id#">
                    </cfif>
                    <cfif isdefined('attributes.city') and len(attributes.city) and isdefined('attributes.city_id') and len(attributes.city_id)>
                        AND S.CITY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.city_id#">
                    </cfif>
                    <cfif isdefined('attributes.county') and len(attributes.county) and isdefined('attributes.county_id') and len(attributes.county_id)>
                        AND S.COUNTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.county_id#">
                    </cfif>
                    <cfif len(attributes.ship_method)>
                        AND S.SHIP_METHOD = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ship_method#">
                    </cfif>
                    <cfif isdefined("attributes.project_head") and len(attributes.project_head) and len(attributes.project_id)>
                        AND S.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
                    </cfif>
                    <cfif isdefined("attributes.department_txt") and len(attributes.department_txt) and len(attributes.department_id)>
                        AND (
                                S.DEPARTMENT_IN = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department_id#"> OR 
                                S.DELIVER_STORE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department_id#">
                            )
                    </cfif>	  
                    <cfif session.ep.isBranchAuthorization>
                        AND S.DEPARTMENT_IN IN (<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#listfirst(session.ep.user_location,'-')#">)<!--- #ValueList(get_my_department.department_id,',')# --->
                    </cfif>
                    <cfif len(attributes.company) and len(attributes.company_id)>
                        AND S.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
                    <cfelseif len(attributes.company) and isdefined("attributes.consumer_id") and len(attributes.consumer_id)>
                        AND S.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
                    </cfif>
                    <cfif isdate(attributes.date1)>
                        AND <cfif attributes.listing_type eq 2>SR.DELIVER_DATE<cfelse>S.DELIVER_DATE</cfif> >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#">
                    </cfif>
                    <cfif isdate(attributes.date2)>
                        AND <cfif attributes.listing_type eq 2>SR.DELIVER_DATE<cfelse>S.DELIVER_DATE</cfif> <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#">
                    </cfif>
                    <cfif isdate(attributes.documentdate1)>
                        AND S.SHIP_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.documentdate1#">
                    </cfif>
                    <cfif isdate(attributes.documentdate2)>
                        AND S.SHIP_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.documentdate2#">
                    </cfif>
                    <cfif Len(attributes.deliver_emp_id) and Len(attributes.deliver_emp_name)>
                        AND S.DELIVER_EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.deliver_emp_id#">
                    </cfif>
                    <cfif (Len(attributes.stock_id) and Len(attributes.product_name)) or (Len(attributes.product_cat_id) and Len(attributes.product_cat))>
                        <cfif Len(attributes.listing_type) and attributes.listing_type eq 1><!--- Belge Bazinda --->
                            AND S.SHIP_ID IN (	SELECT
                                                    SHIP_ID
                                                FROM
                                                    #dsn2_alias#.SHIP_ROW
                                                WHERE
                                                    <cfif Len(attributes.stock_id) and Len(attributes.product_name)>
                                                        STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.stock_id#">
                                                        <cfif Len(attributes.spect_main_id) and Len(attributes.spect_main_name)>
                                                            AND SPECT_VAR_ID IN (SELECT SPECT_VAR_ID FROM SPECTS WHERE SPECT_MAIN_ID IN (SELECT SPECT_MAIN_ID FROM SPECTS WHERE SPECT_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.spect_main_id#">))
                                                        </cfif>
                                                    <cfelse>
                                                        PRODUCT_ID IN (#ValueList(get_categories.product_id,',')#)
                                                    </cfif>
                                            )
                        <cfelse><!--- Satir Bazinda --->
                            <cfif Len(attributes.stock_id) and Len(attributes.product_name)>
                                SR.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.stock_id#">
                                <cfif Len(attributes.spect_main_id) and Len(attributes.spect_main_name)>
                                    AND SR.SPECT_VAR_ID IN (SELECT SPECT_VAR_ID FROM SPECTS WHERE SPECT_MAIN_ID IN (SELECT SPECT_MAIN_ID FROM SPECTS WHERE SPECT_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.spect_main_id#">))
                                </cfif>
                            <cfelse>
                                AND SR.PRODUCT_ID IN (#ValueList(get_categories.product_id,',')#)
                            </cfif>
                        </cfif>
                    </cfif>
                    <cfif len(attributes.keyword)>
                        AND
                        (
                            (S.SHIP_NUMBER LIKE '<cfif len(attributes.keyword) gt 3>%</cfif>#attributes.keyword#%') OR
                            (S.SHIP_DETAIL LIKE '<cfif len(attributes.keyword) gt 3>%</cfif>#attributes.keyword#%')
                            <cfif Len(attributes.listing_type) and attributes.listing_type eq 2>
                                OR (SR.NAME_PRODUCT LIKE '<cfif len(attributes.keyword) gt 3>%</cfif>#attributes.keyword#%')
                                OR (SELECT P.PRODUCT_CODE_2 FROM PRODUCT P WHERE P.PRODUCT_ID = SR.PRODUCT_ID) LIKE '<cfif len(attributes.keyword) gt 3>%</cfif>#attributes.keyword#%'
                                OR (SELECT P.MANUFACT_CODE FROM PRODUCT P WHERE P.PRODUCT_ID = SR.PRODUCT_ID) LIKE '<cfif len(attributes.keyword) gt 3>%</cfif>#attributes.keyword#%'
                            </cfif>
                        )
                    </cfif>
                    <cfif len(attributes.ref_no)>
                        AND S.REF_NO LIKE '<cfif len(attributes.ref_no) gt 3>%</cfif>#attributes.ref_no#%'
                    </cfif>
                    <cfif isdefined('attributes.subscription_id') and len(attributes.subscription_id) and isdefined('attributes.subscription_no') and len(attributes.subscription_no)>
                        AND S.SUBSCRIPTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.subscription_id#">
                    </cfif>
                    <cfif  listfind(attributes.cat,5) and not listfind(attributes.cat,6)>
                        AND S.IS_DELIVERED = 1		
                    <cfelseif listfind(attributes.cat,6) and not listfind(attributes.cat,5)>
                        AND (S.IS_DELIVERED = 0 OR S.IS_DELIVERED IS NULL)
                    </cfif>	  	
                    <cfif isdefined("attributes.is_dispatch")>
                        AND S.IS_DISPATCH = 0
                    </cfif>
                    <cfif Len(attributes.listing_type) and attributes.listing_type eq 2>
                        <cfif (Len(attributes.product_brand_name) and Len(attributes.product_brand_id)) or (Len(attributes.product_model_name) and Len(attributes.product_model_id))>
                            AND SR.PRODUCT_ID IN 	(
                                                        SELECT
                                                            PRODUCT_ID
                                                        FROM
                                                            #dsn1_alias#.PRODUCT
                                                        WHERE
                                                            1 = 1
                                                            <cfif Len(attributes.product_brand_name) and Len(attributes.product_brand_id)>
                                                            AND BRAND_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_brand_id#">
                                                            </cfif>
                                                            <cfif Len(attributes.product_model_name) and Len(attributes.product_model_id)>
                                                            AND SHORT_CODE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_model_id#">
                                                            </cfif>
                                                    )
                        </cfif>
                    </cfif>
                    <cfif isdefined('attributes.zone_id') and len(attributes.zone_id)>
                        AND(
                            (S.DEPARTMENT_IN IN 
                                (SELECT 
                                    D.DEPARTMENT_ID 
                                FROM 
                                    #dsn_alias#.DEPARTMENT D,
                                    #dsn_alias#.BRANCH B
                                WHERE 
                                    D.BRANCH_ID = B.BRANCH_ID AND
                                    B.ZONE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.zone_id#">
                                )
                            ) 
                            OR
                            (S.DELIVER_STORE_ID IN 
                                (SELECT 
                                    D.DEPARTMENT_ID 
                                FROM 
                                    #dsn_alias#.DEPARTMENT D,
                                    #dsn_alias#.BRANCH B
                                WHERE 
                                    D.BRANCH_ID = B.BRANCH_ID AND
                                    B.ZONE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.zone_id#">
                                )
                            )
                        )
                </cfif>
            </cfif>
        </cfif>
    </cfif>
		),
		CTE2 AS (
				SELECT
					CTE1.*,
					ROW_NUMBER() OVER (ORDER BY <cfif attributes.listing_type eq 3>
														ISLEM_TARIHI ASC,
												</cfif>
														ISLEM_ID DESC ) AS RowNum,(SELECT COUNT(*) FROM CTE1) AS QUERY_COUNT
				FROM
					CTE1
			)
			SELECT
				CTE2.*
			FROM
				CTE2
			WHERE
				RowNum BETWEEN #attributes.startrow# and #attributes.startrow#+(#attributes.maxrows#-1)
	 <cfif Len(attributes.listing_type) and attributes.listing_type eq 3>
         ORDER BY 
            ISLEM_ROW_ID ASC
     </cfif>
</cfquery>
