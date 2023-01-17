<cfparam name="attributes.product_status" default="2">
<cfif isdefined("attributes.search_selected_product_list") and listlen(attributes.search_selected_product_list) and isdefined("attributes.calc_type") and (attributes.calc_type eq 1 or attributes.calc_type eq 3)><!--- HESAPLAMA SEKLINE GORE BELLI URUNLER GELIYOR --->
    <cfif len(attributes.table_code)>
    	<cfquery name="get_table_p" datasource="#dsn_dev#">
        	SELECT PRODUCT_ID FROM SEARCH_TABLES_PRODUCTS WHERE PRODUCT_ID IN (#attributes.search_selected_product_list#)
            	AND TABLE_CODE = '#attributes.table_code#'
        </cfquery>
        <cfif not get_table_p.recordcount>
        	<cfset attributes.search_selected_product_list = ''>
            <cfset attributes.SEARCH_SELECTED_PRODUCT_LIST = ''>
        </cfif>
    </cfif>
</cfif>
<cfquery name="get_order_date" datasource="#dsn_dev#">
	SELECT ORDER_DAY FROM SEARCH_TABLES_DEFINES
</cfquery>
<cfset order_control_day = -1 * get_order_date.ORDER_DAY>
<cfquery name="get_my_branches" datasource="#dsn#">
	SELECT BRANCH_ID FROM #dsn_alias#.EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#
</cfquery>
<cfif get_my_branches.recordcount>
	<cfset my_branch_list = valuelist(get_my_branches.BRANCH_ID)>
<cfelse>
	<cfset my_branch_list = '0'>
</cfif>
<cfset bugun_ = createodbcdatetime(createdate(year(now()),month(now()),day(now())))>
<cfquery name="get_products" datasource="#dsn3#" result="query_result">
    SELECT DISTINCT
    	CASE 
        	WHEN PRODUCT_UNIT.MAIN_UNIT = 'Adet' THEN ISNULL((SELECT TOP 1 MULTIPLIER FROM PRODUCT_UNIT PU2 WHERE PU2.PRODUCT_ID = P.PRODUCT_ID AND (PU2.ADD_UNIT = 'KG' OR PU2.ADD_UNIT = 'LT')),1)
            ELSE 1 END AS UNIT_MUTP,
        (SELECT TOP 1 CAST(ISNULL(PTS.IS_ACTIVE_S,0) AS NVARCHAR) + '*' + CAST(PTS.S_PROFIT AS NVARCHAR) AS SON_STD_DURUM FROM #DSN_DEV#.PRICE_TABLE_STANDART PTS WHERE PTS.STD_P_STARTDATE IS NOT NULL AND PTS.PRODUCT_ID = P.PRODUCT_ID ORDER BY PTS.ROW_ID DESC) AS STD_SON_DURUM,
        (SELECT TOP 1 CAST(ISNULL(PTS.IS_ACTIVE_S,0) AS NVARCHAR) + '*' + CAST(PTS.S_PROFIT AS NVARCHAR) AS SON_STD_DURUM FROM #DSN_DEV#.PRICE_TABLE_STANDART PTS WHERE PTS.IS_ACTIVE_S = 1 AND PTS.STD_P_STARTDATE IS NOT NULL AND PTS.PRODUCT_ID = P.PRODUCT_ID ORDER BY PTS.ROW_ID DESC) AS STD_DURUM,
        (SELECT COUNT(S_IC.STOCK_ID) FROM STOCKS S_IC WHERE S_IC.PRODUCT_ID = P.PRODUCT_ID AND S_IC.STOCK_STATUS = 1) AS URUN_STOCK_SAYISI,
        P.PRODUCT_NAME, 
        P.PRODUCT_CODE,
        P.PRODUCT_ID,
        P.PRODUCT_CATID,
        P.TAX_PURCHASE,
        P.TAX,
        P.P_PROFIT,
        P.S_PROFIT,
        P.PRODUCT_STATUS,
        P.COMPANY_ID,
        P.PROJECT_ID,
        P.ADD_STOCK_DAY,
        S.STOCK_IS_PURCHASE,
        S.STOCK_IS_PURCHASE_C,
        S.STOCK_IS_PURCHASE_M,
        S.STOCK_IS_SALES,
        P.IS_PURCHASE,
        P.IS_PURCHASE_C,
        P.IS_PURCHASE_M,
        P.IS_SALES,
        P.BARCOD,
        P.MAXIMUM_STOCK,
        P.MINIMUM_STOCK,
        P.ORDER_LIMIT,
        ISNULL(( 
            SELECT TOP 1 
                PT1.NEW_ALIS_KDV
            FROM
                #DSN_DEV#.PRICE_TABLE PT1
            WHERE
                PT1.IS_ACTIVE_P = 1 AND
                PT1.P_STARTDATE <= #bugun_# AND 
                DATEADD("d",-1,PT1.P_FINISHDATE) >= #bugun_# AND
                (PT1.STOCK_ID = S.STOCK_ID OR (PT1.STOCK_ID IS NULL AND PT1.PRODUCT_ID = P.PRODUCT_ID))
            ORDER BY
                PT1.STARTDATE DESC,
                PT1.ROW_ID DESC
        ),PRICE_STANDART.PRICE_KDV) AS LISTE_FIYATI,
        (
        	SELECT TOP 1 
                PT1.PRICE_TYPE
            FROM
                #DSN_DEV#.PRICE_TABLE PT1
            WHERE
                PT1.IS_ACTIVE_S = 1 AND
                PT1.STARTDATE <= #bugun_# AND 
                DATEADD("d",-1,PT1.FINISHDATE) >= #bugun_# AND
                (PT1.STOCK_ID = S.STOCK_ID OR (PT1.STOCK_ID IS NULL AND PT1.PRODUCT_ID = P.PRODUCT_ID))
            ORDER BY
                PT1.STARTDATE DESC,
                PT1.FINISHDATE DESC,
                PT1.ROW_ID DESC
        ) AS OZEL_PRICE_TYPE,
        (
        	SELECT TOP 1 
                PT1.ROW_ID
            FROM
                #DSN_DEV#.PRICE_TABLE PT1
            WHERE
                PT1.IS_ACTIVE_S = 1 AND
                PT1.STARTDATE <= #bugun_# AND 
                DATEADD("d",-1,PT1.FINISHDATE) >= #bugun_# AND
                (PT1.STOCK_ID = S.STOCK_ID OR (PT1.STOCK_ID IS NULL AND PT1.PRODUCT_ID = P.PRODUCT_ID))
            ORDER BY
                PT1.STARTDATE DESC,
                PT1.FINISHDATE DESC,
                PT1.ROW_ID DESC
        ) AS OZEL_PRICE_ROW_ID,
        EPTR.SUB_TYPE_NAME,
        ISNULL(P.DUEDAY,0) AS P_DUEDAY,
        ISNULL(P.MAX_MARGIN,25) AS MAX_MARGIN_DEGER,
        PRODUCT_CAT.HIERARCHY + '-' + PRODUCT_CAT.PRODUCT_CAT + '-' + CAST(P.PRODUCT_CATID AS NVARCHAR) AS PRODUCT_CAT,
        PRODUCT_CAT.HIERARCHY,
        D.DEPARTMENT_ID,
        D.DEPARTMENT_HEAD,
        D.POINT_MULTIPLIER,
        S.PROPERTY,
        S.STOCK_ID,
        S.BARCOD AS S_BARCOD,
        S.STOCK_CODE,
        PRICE_STANDART.PRICE PRICE_STANDART,
        PRICE_STANDART.PRICE_KDV PRICE_STANDART_KDV,
        PS2.PRICE STANDART_SALE_PRICE,
        PS2.PRICE_KDV AS STANDART_SALE_PRICE_KDV,
        ISNULL((SELECT SUM(PRODUCT_STOCK) FROM #DSN2_ALIAS#.GET_STOCK_PRODUCT WHERE S.PRODUCT_ID = GET_STOCK_PRODUCT.PRODUCT_ID AND GET_STOCK_PRODUCT.DEPARTMENT_ID NOT IN (#iade_depo_id#)),0) AS URUN_STOCK,
        ISNULL((SELECT SUM(PRODUCT_STOCK) FROM #DSN2_ALIAS#.GET_STOCK_PRODUCT WHERE S.PRODUCT_ID = GET_STOCK_PRODUCT.PRODUCT_ID AND GET_STOCK_PRODUCT.DEPARTMENT_ID = #merkez_depo_id#),0) AS DEPO_STOCK,
        ISNULL((SELECT SUM(PRODUCT_STOCK) FROM #DSN2_ALIAS#.GET_STOCK_PRODUCT WHERE S.PRODUCT_ID = GET_STOCK_PRODUCT.PRODUCT_ID AND GET_STOCK_PRODUCT.DEPARTMENT_ID NOT IN (#merkez_depo_id#,#iade_depo_id#)),0) AS MAGAZA_STOK,
        ISNULL((SELECT SUM(PRODUCT_STOCK) FROM #DSN2_ALIAS#.GET_STOCK_PRODUCT WHERE S.STOCK_ID = GET_STOCK_PRODUCT.STOCK_ID AND GET_STOCK_PRODUCT.DEPARTMENT_ID = D.DEPARTMENT_ID),0) AS ROW_STOCK,
        ISNULL((SELECT SUM(PRODUCT_STOCK) FROM #DSN2_ALIAS#.GET_STOCK_PRODUCT WHERE S.STOCK_ID = GET_STOCK_PRODUCT.STOCK_ID AND GET_STOCK_PRODUCT.DEPARTMENT_ID NOT IN (#iade_depo_id#)),0) AS ROW_STOCK_GENEL,
        ISNULL((SELECT SUM(PRODUCT_STOCK) FROM #DSN2_ALIAS#.GET_STOCK_PRODUCT WHERE S.STOCK_ID = GET_STOCK_PRODUCT.STOCK_ID AND GET_STOCK_PRODUCT.DEPARTMENT_ID = #merkez_depo_id#),0) AS ROW_STOCK_DEPO,
        ISNULL((SELECT SUM(PRODUCT_STOCK) FROM #DSN2_ALIAS#.GET_STOCK_PRODUCT WHERE S.STOCK_ID = GET_STOCK_PRODUCT.STOCK_ID AND GET_STOCK_PRODUCT.DEPARTMENT_ID NOT IN (#merkez_depo_id#,#iade_depo_id#) AND GET_STOCK_PRODUCT.DEPARTMENT_ID IN (#attributes.search_department_id#)),0) AS ROW_STOCK_MAGAZALAR,
        ISNULL((SELECT SUM(PRODUCT_STOCK) FROM #DSN2_ALIAS#.GET_STOCK_PRODUCT WHERE S.STOCK_ID = GET_STOCK_PRODUCT.STOCK_ID AND GET_STOCK_PRODUCT.DEPARTMENT_ID = D.DEPARTMENT_ID),0) AS ROW_STOCK_MAGAZA,
        0 AS SON_MALIYET,
        ISNULL(#dsn3#.fnc_get_rival_avg(P.PRODUCT_ID),0) AS AVG_RIVAL,
        0 AS PURCHASE_ORDER_QUANTITY2,
        ISNULL((
        	SELECT
                SUM(ORR.QUANTITY)
            FROM
                ORDERS O INNER JOIN
                ORDER_ROW ORR ON ORR.ORDER_ID = O.ORDER_ID
            WHERE
                O.ORDER_STAGE = 76 AND
				O.PURCHASE_SALES = 0 AND
                ORR.ORDER_ROW_CURRENCY NOT IN (-3,-10) AND
                ORR.STOCK_ID = S.STOCK_ID AND
                <cfif listlen(attributes.search_department_id) and attributes.search_department_id eq merkez_depo_id>
                	O.DELIVER_DEPT_ID IS NOT NULL AND
                <cfelse>
                	O.DELIVER_DEPT_ID = D.DEPARTMENT_ID AND
                </cfif>
                O.ORDER_DATE >= #dateadd('d',order_control_day,bugun_)# AND
       			O.ORDER_DATE < #dateadd('d',1,bugun_)# 
        ),0) PURCHASE_ORDER_QUANTITY,
        ISNULL((
        	SELECT
                SUM(ORR.QUANTITY)
            FROM
                ORDERS O INNER JOIN
                ORDER_ROW ORR ON ORR.ORDER_ID = O.ORDER_ID
            WHERE
				O.PURCHASE_SALES = 0 AND
                ORR.ORDER_ROW_CURRENCY NOT IN (-3,-10) AND
                ORR.STOCK_ID = S.STOCK_ID AND
                <cfif listlen(attributes.search_department_id) and attributes.search_department_id eq merkez_depo_id>
                	O.DELIVER_DEPT_ID IS NOT NULL AND
                <cfelse>
                	O.DELIVER_DEPT_ID = D.DEPARTMENT_ID AND
                </cfif>
                O.ORDER_DATE >= #dateadd('d',order_control_day,bugun_)# AND
       			O.ORDER_DATE < #dateadd('d',1,bugun_)# 
        ),0) ROW_SIPARISLER,
        ISNULL((
        	SELECT	
                SUM(ORR.NETTOTAL * (1 + (ORR.TAX / 100)))
            FROM
                ORDERS O INNER JOIN
                ORDER_ROW ORR ON ORR.ORDER_ID = O.ORDER_ID
            WHERE
                <cfif listlen(attributes.search_department_id) and attributes.search_department_id eq 13>
                	O.DELIVER_DEPT_ID IS NOT NULL AND
                <cfelse>
                	O.DELIVER_DEPT_ID = D.DEPARTMENT_ID AND
                </cfif>
                O.ORDER_STAGE = 76 AND
				O.PURCHASE_SALES = 0 AND
                ORR.ORDER_ROW_CURRENCY NOT IN (-3,-10) AND
                ORR.STOCK_ID = S.STOCK_ID AND
                O.ORDER_DATE >= #dateadd('d',order_control_day,bugun_)# AND
       			O.ORDER_DATE < #dateadd('d',1,bugun_)# 
        ),0) PURCHASE_ORDER_TUTAR,
        ISNULL(#dsn3#.fnc_get_unit_multiplier(P.PRODUCT_ID,#koli_unit#),#dsn3#.fnc_get_unit_multiplier(P.PRODUCT_ID,#teneke_unit#)) MULTIPLIER,
        #dsn3#.fnc_get_unit_multiplier(P.PRODUCT_ID,#palet_unit#) AS P_MULTIPLIER,
        C.NICKNAME,
        PP.PROJECT_HEAD AS PROJECT,
        CAST(ISNULL(P.COMPANY_ID,0) AS NVARCHAR) + '_' + CAST(ISNULL(P.PROJECT_ID,0) AS NVARCHAR) AS COMPANY_CODE
    FROM 
        <cfif len(attributes.table_code)>
        	#dsn_dev_alias#.SEARCH_TABLES_PRODUCTS STP,	
        </cfif>
        #dsn_alias#.DEPARTMENT D,
        STOCKS S,
        #dsn1_alias#.PRODUCT P
        LEFT JOIN #dsn_alias#.COMPANY C ON (C.COMPANY_ID = P.COMPANY_ID)
        LEFT JOIN #dsn_alias#.PRO_PROJECTS PP ON (PP.PROJECT_ID = P.PROJECT_ID)
        LEFT JOIN #dsn_dev_alias#.EXTRA_PRODUCT_TYPES_ROWS EPTR ON (P.PRODUCT_ID = EPTR.PRODUCT_ID AND EPTR.TYPE_ID = #ambalaj_type_id#)
        LEFT JOIN PRODUCT_CAT ON P.PRODUCT_CATID = PRODUCT_CAT.PRODUCT_CATID
        LEFT JOIN PRODUCT_UNIT ON P.PRODUCT_ID = PRODUCT_UNIT.PRODUCT_ID
        LEFT JOIN PRICE_STANDART ON PRODUCT_UNIT.PRODUCT_ID = PRICE_STANDART.PRODUCT_ID
        LEFT JOIN PRICE_STANDART AS PS2 ON PRODUCT_UNIT.PRODUCT_ID = PS2.PRODUCT_ID
    WHERE 
        <cfif len(attributes.table_code)>
        	(P.IS_PURCHASE = 1 OR P.IS_SALES = 1) AND
        </cfif>
        <cfif attributes.product_status neq 2>
            ISNULL(P.PRODUCT_STATUS,0) = #attributes.product_status# AND
        </cfif>
        <cfif isdefined("attributes.calc_type") and attributes.calc_type eq 1>
			P.IS_PURCHASE = 1 AND
		</cfif>
        S.STOCK_STATUS = 1 AND
        D.IS_STORE IN (1,3) AND
        ISNULL(D.IS_PRODUCTION,0) = 0 AND
        P.PRODUCT_ID = S.PRODUCT_ID AND
        PS2.PRICESTANDART_STATUS = 1 AND
        PS2.PURCHASESALES = 1 AND
        PRODUCT_UNIT.PRODUCT_UNIT_ID = PS2.UNIT_ID AND
        PRICE_STANDART.PURCHASESALES = 0 AND
        PRODUCT_UNIT.IS_MAIN = 1 AND 
        PRICE_STANDART.PRICESTANDART_STATUS = 1 AND
        PRODUCT_UNIT.PRODUCT_UNIT_ID = PRICE_STANDART.UNIT_ID AND
        D.BRANCH_ID IN (#my_branch_list#) AND
		<cfif isdefined("attributes.action_code") and len(attributes.action_code) and attributes.action_code neq 0>
        	P.PRODUCT_ID IN 
            	(
                	SELECT 
                    	PT_SEARCH.PRODUCT_ID 
                    FROM 
                    	#dsn_dev_alias#.PRICE_TABLE PT_SEARCH 
                    WHERE
                    	<cfif listlen(attributes.action_code,'+') eq 1>
                        	<cfset code_ = attributes.action_code>
                            <cfif len(code_) lt 8>
                            	<cfloop from="1" to="#8-len(code_)#" index="kkk">
                                	<cfset code_ = '0#code_#'>
                                </cfloop>
                            </cfif>
                            PT_SEARCH.ACTION_CODE = '#code_#'
                        <cfelse>
                            (
                                <cfloop from="1" to="#listlen(attributes.action_code,'+')#" index="ccc">
                                    <cfset code_ = listgetat(attributes.action_code,ccc,'+')>
                                    <cfif len(code_) lt 8>
                                        <cfloop from="1" to="#8-len(code_)#" index="kkk">
                                            <cfset code_ = '0#code_#'>
                                        </cfloop>
                                    </cfif>
                                    PT_SEARCH.ACTION_CODE = '#code_#'
                                    <cfif ccc neq listlen(attributes.action_code,'+')>OR</cfif>
                                </cfloop>
                            )
                        </cfif> 
                ) 
            AND
        </cfif>
		<cfif isdefined("attributes.search_selected_product_list") and listlen(attributes.search_selected_product_list) and isdefined("attributes.calc_type") and (attributes.calc_type eq 1 or attributes.calc_type eq 3)><!--- HESAPLAMA SEKLINE GORE BELLI URUNLER GELIYOR --->
           	P.PRODUCT_ID IN (#attributes.search_selected_product_list#) AND
        </cfif>
		<cfif len(attributes.search_department_id)>
            D.DEPARTMENT_ID IN (#attributes.search_department_id#) AND
        </cfif>
		<cfif len(attributes.table_code)>
        	<cfif isdefined("attributes.wrk_id") and len(attributes.wrk_id)>
                <cfset code_ = attributes.wrk_id>
                 <cfloop from="1" to="#8-len(code_)#" index="ccc">
                    <cfset code_ = "0" & code_>
                 </cfloop>
                (
                    P.PRODUCT_ID IN
                    (
                        SELECT 
                                PT_SEARCH2.PRODUCT_ID 
                            FROM 
                                #dsn_dev_alias#.PRICE_TABLE PT_SEARCH2 
                            WHERE
                                PT_SEARCH2.WRK_ID = '#code_#'
                    )
                    OR
                    P.PRODUCT_ID IN
                    (
                        SELECT 
                                PT_SEARCH3.PRODUCT_ID 
                            FROM 
                                #dsn_dev_alias#.PRICE_TABLE_STANDART PT_SEARCH3 
                            WHERE
                                PT_SEARCH3.WRK_ID = '#code_#'
                    ) 
               )
                AND
            </cfif>
            P.PRODUCT_ID = STP.PRODUCT_ID AND
            STP.TABLE_ID = #attributes.table_id#
            <cfif isdefined("attributes.in_table_product_list") and listlen(attributes.in_table_product_list)>
            	AND P.PRODUCT_ID IN (#attributes.in_table_product_list#)
            </cfif>
            <cfif isdefined("attributes.keyword") and len(attributes.keyword)>
                AND (
                P.PRODUCT_NAME + ' ' + S.PROPERTY LIKE '%#attributes.keyword#%'
                OR
                (
                    P.PRODUCT_NAME IS NOT NULL
                        <cfloop from="1" to="#listlen(attributes.keyword,' ')#" index="ccc">
                            <cfset kelime_ = listgetat(attributes.keyword,ccc,' ')>
                                AND
                                P.PRODUCT_NAME + ' ' + S.PROPERTY LIKE '%#kelime_#%'
                        </cfloop>
                    ) OR
                    S.BARCOD = '#attributes.keyword#' OR
                    S.STOCK_CODE = '#attributes.keyword#'
                )
            <cfelse>
                AND P.PRODUCT_NAME IS NOT NULL
            </cfif>
        <cfelseif isdefined("attributes.selected_product_id")>
        	P.PRODUCT_ID IN (#attributes.selected_product_id#)
        <cfelseif isdefined("attributes.order_id") and len(attributes.order_id)>
        	P.PRODUCT_ID IN (SELECT ORR.PRODUCT_ID FROM #dsn3_alias#.ORDER_ROW ORR WHERE ORR.ORDER_ID = #attributes.order_id#) AND
            S.STOCK_ID IN (SELECT ORR.STOCK_ID FROM #dsn3_alias#.ORDER_ROW ORR WHERE ORR.ORDER_ID = #attributes.order_id#)
        <cfelseif isdefined("attributes.action_code_type") and (isdefined("attributes.action_code_list") or isdefined("attributes.p_action_code_list"))>
        	<cfif isdefined("attributes.action_code_type") and attributes.action_code_type eq 2>
				<cfif isdefined("attributes.action_code_list") and not isdefined("attributes.p_action_code_list")>
                    <cfset attributes.action_code_type = 0>
                </cfif>
                <cfif not isdefined("attributes.action_code_list") and isdefined("attributes.p_action_code_list")>
                    <cfset attributes.action_code_type = 1>
                </cfif>
            </cfif>
            <cfif isdefined("attributes.action_code_type") and attributes.action_code_type eq 0>
            (
                <cfset sira_ = 0>
                <cfloop list="#attributes.action_code_list#" index="ccc">
                <cfset sira_ = sira_ + 1>
                P.PRODUCT_ID IN 
                        (SELECT PT_SEARCH.PRODUCT_ID FROM #dsn_dev_alias#.PRICE_TABLE PT_SEARCH WHERE PT_SEARCH.ACTION_CODE = '#ccc#' AND PT_SEARCH.PRODUCT_ID IN (#evaluate("attributes.action_code_product_list_#ccc#")#))
            		<cfif listlen(attributes.action_code_list) gt 1 and sira_ neq listlen(attributes.action_code_list)>OR</cfif>
                </cfloop>
            )
            </cfif>
            <cfif isdefined("attributes.action_code_type") and attributes.action_code_type eq 1>
                <cfset sira_ = 0>
                <cfloop list="#attributes.p_action_code_list#" index="ccc">
                <cfset sira_ = sira_ + 1>
                P.PRODUCT_ID IN 
                        (SELECT PT_SEARCH.PRODUCT_ID FROM #dsn_dev_alias#.PRICE_TABLE PT_SEARCH WHERE PT_SEARCH.ACTION_CODE = '#ccc#' AND PT_SEARCH.PRODUCT_ID IN (#evaluate("attributes.p_action_code_product_list_#ccc#")#))
            		<cfif listlen(attributes.p_action_code_list) gt 1 and sira_ neq listlen(attributes.p_action_code_list)>OR</cfif>
                </cfloop>
            </cfif>
            <cfif isdefined("attributes.action_code_type") and attributes.action_code_type eq 2>
            ( 
                    <cfset sira_ = 0>
                    <cfloop list="#attributes.action_code_list#" index="ccc">
                    <cfset sira_ = sira_ + 1>
                    P.PRODUCT_ID IN 
                            (SELECT PT_SEARCH.PRODUCT_ID FROM #dsn_dev_alias#.PRICE_TABLE PT_SEARCH WHERE PT_SEARCH.ACTION_CODE = '#ccc#' AND PT_SEARCH.PRODUCT_ID IN (#evaluate("attributes.action_code_product_list_#ccc#")#))
                        <cfif listlen(attributes.action_code_list) gt 1 and sira_ neq listlen(attributes.action_code_list)>OR</cfif>
                    </cfloop>
                    OR
                    <cfset sira_ = 0>
                    <cfloop list="#attributes.p_action_code_list#" index="ccc">
                    <cfset sira_ = sira_ + 1>
                    P.PRODUCT_ID IN 
                            (SELECT PT_SEARCH.PRODUCT_ID FROM #dsn_dev_alias#.PRICE_TABLE PT_SEARCH WHERE PT_SEARCH.ACTION_CODE = '#ccc#' AND PT_SEARCH.PRODUCT_ID IN (#evaluate("attributes.p_action_code_product_list_#ccc#")#))
                        <cfif listlen(attributes.p_action_code_list) gt 1 and sira_ neq listlen(attributes.p_action_code_list)>OR</cfif>
                    </cfloop>
            )
            </cfif>
        <cfelseif not len(attributes.table_code) and isdefined("attributes.wrk_id") and len(attributes.wrk_id)>
        	 <cfset code_ = attributes.wrk_id>
             <cfloop from="1" to="#8-len(code_)#" index="ccc">
				<cfset code_ = "0" & code_>
             </cfloop>
             P.PRODUCT_ID IN
                (
                    SELECT 
                            PT_SEARCH2.PRODUCT_ID 
                        FROM 
                            #dsn_dev_alias#.PRICE_TABLE PT_SEARCH2 
                        WHERE
                            PT_SEARCH2.WRK_ID = '#code_#'
                )
        <cfelseif isdefined("attributes.order_stock_list") and listlen(attributes.order_stock_list)><!--- siparişten URUNLER GELIYOR --->
           	S.STOCK_ID IN (#attributes.order_stock_list#)
        <cfelse>
            1 = 0 AND
			<cfif isdefined("attributes.is_today_price_change")>
                <cfset date_ = createodbcdatetime(createdate(year(fusebox.simdi),month(fusebox.simdi),day(fusebox.simdi)))>
                PRICE.FINISHDATE >= #date_# AND 
                PRICE.FINISHDATE < #dateadd('d',1,date_)# AND
            </cfif>
            <cfif isdefined("attributes.add_product_id") and len(attributes.add_product_id)>
                P.PRODUCT_ID = #attributes.add_product_id# AND
            </cfif>	
            <cfif isdefined("attributes.all_product_list") and len(attributes.all_product_list)>
                P.PRODUCT_ID IN (#attributes.all_product_list#) AND
            </cfif>
            <cfif isdefined("attributes.HIERARCHY1") and len(attributes.HIERARCHY1)>
                <cfif isdefined("attributes.cat_in_out1")>
                (
                	<cfset count_ = 0>
                    <cfloop list="#attributes.HIERARCHY1#" index="ccc">
                    	<cfset count_ = count_ + 1>
                    	P.PRODUCT_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#ccc#.%">
                        <cfif count_ Neq listlen(attributes.HIERARCHY1)>
                        	OR
                        </cfif>
                    </cfloop>
                )
                AND
                <cfelse>
                (
                	<cfset count_ = 0>
                    <cfloop list="#attributes.HIERARCHY1#" index="ccc">
                    	<cfset count_ = count_ + 1>
                    	P.PRODUCT_CODE NOT LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#ccc#.%">
                        <cfif count_ Neq listlen(attributes.HIERARCHY1)>
                        	AND
                        </cfif>
                    </cfloop>
                )
                AND
                </cfif>
            </cfif>
            
            <cfif isdefined("attributes.HIERARCHY2") and len(attributes.HIERARCHY2)>
                <cfif isdefined("attributes.cat_in_out2")>
                (
                	<cfset count_ = 0>
                    <cfloop list="#attributes.HIERARCHY2#" index="ccc">
                    	<cfset count_ = count_ + 1>
                    	P.PRODUCT_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#ccc#.%">
                        <cfif count_ Neq listlen(attributes.HIERARCHY2)>
                        	OR
                        </cfif>
                    </cfloop>
                )
                AND
                <cfelse>
                (
                	<cfset count_ = 0>
                    <cfloop list="#attributes.HIERARCHY2#" index="ccc">
                    	<cfset count_ = count_ + 1>
                    	P.PRODUCT_CODE NOT LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#ccc#.%">
                        <cfif count_ Neq listlen(attributes.HIERARCHY2)>
                        	AND
                        </cfif>
                    </cfloop>
                )
                AND
                </cfif>
            </cfif>
            
            <cfif isdefined("attributes.HIERARCHY3") and len(attributes.HIERARCHY3)>
                <cfif isdefined("attributes.cat_in_out3")>
                (
                	<cfset count_ = 0>
                    <cfloop list="#attributes.HIERARCHY3#" index="ccc">
                    	<cfset count_ = count_ + 1>
                    	P.PRODUCT_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#ccc#.%">
                        <cfif count_ Neq listlen(attributes.HIERARCHY3)>
                        	OR
                        </cfif>
                    </cfloop>
                )
                AND
                <cfelse>
                (
                	<cfset count_ = 0>
                    <cfloop list="#attributes.HIERARCHY3#" index="ccc">
                    	<cfset count_ = count_ + 1>
                    	P.PRODUCT_CODE NOT LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#ccc#.%">
                        <cfif count_ Neq listlen(attributes.HIERARCHY3)>
                        	AND
                        </cfif>
                    </cfloop>
                )
                AND
                </cfif>
            </cfif>
            
			<cfif isdefined("attributes.tedarikci_kodu") and len(attributes.tedarikci_kodu)>
            	CAST(ISNULL(P.PROJECT_ID,0) AS VARCHAR) + '-' + CAST(P.COMPANY_ID AS VARCHAR) <cfif not isdefined("attributes.tedarikci_in_out")>NOT</cfif> IN ('#replace(attributes.tedarikci_kodu,",","','","all")#') AND
            </cfif>
            <cfif isdefined("attributes.brand_id") and len(attributes.brand_id)>
                P.BRAND_ID <cfif not isdefined("attributes.brand_in_out")>NOT</cfif> IN (#attributes.brand_id#) AND
            </cfif>
            <cfif isDefined("attributes.special_code") and len(attributes.special_code)>
                P.PRODUCT_CODE_2 LIKE '<cfif len(attributes.special_code) gt 2>%</cfif>#attributes.special_code#%' AND
            </cfif>
            <cfif isdefined('attributes.product_types') and (attributes.product_types eq 1)>
                P.IS_PURCHASE = 1 AND
            <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 2)>
                P.IS_INVENTORY = 0 AND
            <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 3)>
                P.IS_INVENTORY = 1 AND P.IS_PRODUCTION = 0 AND
            <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 4)>
                P.IS_TERAZI = 1 AND
            <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 5)>
                P.IS_PURCHASE = 0 AND
            <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 6)>
                P.IS_PRODUCTION = 1 AND
            <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 7)>
                P.IS_SERIAL_NO = 1 AND
            <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 8)>
                P.IS_KARMA = 1 AND
            <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 9)>
                P.IS_INTERNET = 1 AND
            <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 10)>
                P.IS_PROTOTYPE = 1 AND
            <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 11)>
                P.IS_ZERO_STOCK = 1 AND
            <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 12)>
                P.IS_EXTRANET = 1 AND
            <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 13)>
                P.IS_COST = 1 AND
            <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 14)>
                P.IS_SALES = 1 AND
            <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 15)>
                P.IS_QUALITY = 1 AND
            <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 16)>
                P.IS_INVENTORY = 1 AND
            <cfelse>
                P.IS_INVENTORY = 1 AND
            </cfif>
            <cfif isdefined("attributes.keyword") and len(attributes.keyword)>
                (
                P.PRODUCT_NAME + ' ' + S.PROPERTY LIKE '%#attributes.keyword#%'
                OR
                (
                P.PRODUCT_NAME IS NOT NULL
                    <cfloop from="1" to="#listlen(attributes.keyword,' ')#" index="ccc">
                        <cfset kelime_ = listgetat(attributes.keyword,ccc,' ')>
                            AND
                            P.PRODUCT_NAME + ' ' + S.PROPERTY LIKE '%#kelime_#%'
                    </cfloop>
                ) OR
                S.BARCOD = '#kelime_#' OR
                S.STOCK_CODE = '#kelime_#'
                )
            <cfelse>
                P.PRODUCT_NAME IS NOT NULL
            </cfif>
        </cfif>      
    ORDER BY
        P.PRODUCT_CODE ASC,
        SUB_TYPE_NAME,
    	P.PRODUCT_NAME,
        S.PROPERTY,
        D.DEPARTMENT_HEAD
</cfquery>

<cfoutput query="get_departments_search">
    <cfquery name="get_satis_#department_id#" datasource="#dsn_dev#" result="satis_donen">
        EXEC ortalama_satis_getir '#listdeleteduplicates(valuelist(get_products.stock_id))#',#attributes.search_startdate#,#attributes.search_finishdate#,#department_id#
    </cfquery>
    
    <cfquery name="get_sd_#department_id#" datasource="#dsn_dev#" result="sd_donen">
        EXEC stock_devir_hizi_getir '#listdeleteduplicates(valuelist(get_products.stock_id))#',#attributes.search_startdate#,#attributes.search_finishdate#,#department_id#
    </cfquery>
</cfoutput>

<cfquery name="get_satis_all" dbtype="query">
    <cfoutput query="get_departments_search">
        SELECT ORAN,STOCK_ID,#department_id# AS DEPARTMENT_ID FROM get_satis_#department_id#
        <cfif currentrow neq get_departments_search.recordcount>UNION </cfif>
    </cfoutput>
</cfquery>

<cfquery name="get_sd_all" dbtype="query">
    <cfoutput query="get_departments_search">
        SELECT STOK_DEVIR_HIZI,STOCK_ID,#department_id# AS DEPARTMENT_ID FROM get_sd_#department_id#
        <cfif currentrow neq get_departments_search.recordcount>UNION </cfif>
    </cfoutput>
</cfquery>

<cfquery name="get_satis" dbtype="query">
    SELECT SUM(ORAN) AS ORAN,STOCK_ID,DEPARTMENT_ID FROM get_satis_all WHERE DEPARTMENT_ID <> #merkez_depo_id# GROUP BY STOCK_ID,DEPARTMENT_ID
</cfquery>

<cfoutput query="get_satis">
    <cfset 'row_ort_#stock_id#_#DEPARTMENT_ID#' = ORAN>
</cfoutput>

<cfquery name="get_sd" dbtype="query">
    SELECT SUM(STOK_DEVIR_HIZI) AS STOK_DEVIR_HIZI,STOCK_ID,DEPARTMENT_ID FROM get_sd_all WHERE DEPARTMENT_ID <> #merkez_depo_id# GROUP BY STOCK_ID,DEPARTMENT_ID
</cfquery>
<cfoutput query="get_sd">
    <cfset 'sd_#stock_id#_#DEPARTMENT_ID#' = STOK_DEVIR_HIZI>
</cfoutput>


<cfquery name="get_satis_merkez" dbtype="query">
    SELECT SUM(ORAN) AS ORAN,STOCK_ID FROM get_satis_all GROUP BY STOCK_ID
</cfquery>

<cfoutput query="get_satis_merkez">
    <cfset 'row_ort_#stock_id#_#merkez_depo_id#' = ORAN>
</cfoutput>

<cfquery name="get_sd_merkez" dbtype="query">
    SELECT SUM(STOK_DEVIR_HIZI) / #get_departments_search.recordcount# AS STOK_DEVIR_HIZI,STOCK_ID FROM get_sd_all GROUP BY STOCK_ID
</cfquery>

<cfoutput query="get_sd_merkez">
    <cfset 'sd_#stock_id#_#merkez_depo_id#' = STOK_DEVIR_HIZI>
</cfoutput>

<cfset row_ort_array = ArrayNew(1)> 
<cfset QueryAddColumn(get_products,"ROW_ORT_STOK_SATIS_MIKTARI","Decimal",row_ort_array)>
<cfset QueryAddColumn(get_products,"ROW_STOK_DEVIR_HIZI","Decimal",row_ort_array)>

<cfoutput query="get_products">
    <cfif isdefined("row_ort_#stock_id#_#department_id#") and len(evaluate("row_ort_#stock_id#_#department_id#"))>
        <cfset row_ort_ = evaluate("row_ort_#stock_id#_#department_id#")>
        <cfset temp = querysetcell(get_products,"ROW_ORT_STOK_SATIS_MIKTARI",row_ort_,currentrow)>
    <cfelse>
    	<cfset temp = querysetcell(get_products,"ROW_ORT_STOK_SATIS_MIKTARI",0,currentrow)>
    </cfif>
    
    <cfif isdefined("sd_#stock_id#_#department_id#") and len(evaluate("sd_#stock_id#_#department_id#"))>
        <cfset sd_ = evaluate("sd_#stock_id#_#department_id#")>
        <cfset temp = querysetcell(get_products,"ROW_STOK_DEVIR_HIZI",sd_,currentrow)>
    <cfelse>
    	<cfset temp = querysetcell(get_products,"ROW_STOK_DEVIR_HIZI",0,currentrow)>
    </cfif>
</cfoutput>