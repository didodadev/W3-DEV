<cfinclude template="get_stok_devir_hizi_function.cfm">
<cfset bugun_ = createodbcdatetime(createdate(year(now()),month(now()),day(now())))>
<cfquery name="get_products" datasource="#dsn3#" result="query_result">
    SELECT
    	<cfif isdefined("attributes.search_list_id") and len(attributes.search_list_id)>
        	SLR.LINE_NUMBER,
        </cfif>
        P.*,
        D.DEPARTMENT_ID,
        D.DEPARTMENT_HEAD,
        D.POINT_MULTIPLIER,
        S.PROPERTY,
        S.STOCK_ID,
        S.BARCOD AS S_BARCOD,
        S.STOCK_CODE,
        #dsn2_alias#.fnc_stok_devir_hizi(P.PRODUCT_ID,#attributes.search_startdate#,#attributes.search_finishdate#) AS STOK_DEVIR_HIZI,
        #dsn2_alias#.fnc_stok_devir_hizi_stok(S.STOCK_ID,D.DEPARTMENT_ID,#attributes.search_startdate#,#attributes.search_finishdate#) AS ROW_STOK_DEVIR_HIZI,
        #dsn2_alias#.fnc_get_ortalama_satis_stok(S.STOCK_ID,D.DEPARTMENT_ID,#attributes.search_startdate#,#attributes.search_finishdate#) AS ROW_ORT_STOK_SATIS_MIKTARI,
        PRICE_STANDART.PRICE PRICE_STANDART,
        PRICE_STANDART.PRICE_KDV PRICE_STANDART_KDV,
        PS2.PRICE STANDART_SALE_PRICE,
        PS2.PRICE_KDV AS STANDART_SALE_PRICE_KDV,

        PT_ALIS.NEW_ALIS OZEL_FIYAT_ALIS,
        PT_ALIS.NEW_ALIS_KDV OZEL_FIYAT_ALIS_KDV,
        PT_ALIS.STARTDATE P_PRICE_STARTDATE,
        PT_ALIS.FINISHDATE P_PRICE_FINISHDATE,
        
        PT_SATIS.NEW_PRICE OZEL_FIYAT_SATIS,
        PT_SATIS.NEW_PRICE_KDV OZEL_FIYAT_SATIS_KDV,
        PT_SATIS.STARTDATE PRICE_START,
        PT_SATIS.FINISHDATE PRICE_FINISH,
        
        
        ISNULL((SELECT SUM(PRODUCT_STOCK) FROM #DSN2_ALIAS#.GET_STOCK_PRODUCT WHERE S.STOCK_ID = GET_STOCK_PRODUCT.STOCK_ID AND GET_STOCK_PRODUCT.DEPARTMENT_ID = D.DEPARTMENT_ID),0) AS ROW_STOCK,
        ISNULL((SELECT TOP 1 PURCHASE_NET + PURCHASE_EXTRA_COST FROM PRODUCT_COST WHERE PRODUCT_ID = P.PRODUCT_ID ORDER BY START_DATE DESC,RECORD_DATE DESC, PRODUCT_COST_ID DESC),0) AS SON_MALIYET,
        (
           SELECT
           		AVG(P) AS PRICE
           FROM
           		(
                    SELECT 
                        PRICE_RIVAL.PRICE AS P
                    FROM 
                        PRICE_RIVAL 
                    WHERE
                        PRICE_RIVAL.PRICE IS NOT NULL AND
                        PRICE_RIVAL.PRODUCT_ID = P.PRODUCT_ID AND 
                        PRICE_RIVAL.STARTDATE <= #now()# AND PRICE_RIVAL.FINISHDATE >= #now()#
                 UNION
                    SELECT 
                        PRICE_RIVAL.PRICE_2 AS P
                    FROM 
                        PRICE_RIVAL 
                    WHERE
                        PRICE_RIVAL.PRICE_2 IS NOT NULL AND
                        PRICE_RIVAL.PRODUCT_ID = P.PRODUCT_ID AND 
                        PRICE_RIVAL.STARTDATE <= #now()# AND PRICE_RIVAL.FINISHDATE >= #now()#
               ) AS RAKIP_FIYATLAR
        ) AS AVG_RIVAL,
        ISNULL((
           SELECT
                ROUND(SUM(STOCK_OUT) / COUNT(TARIH),2) AS ORT
           FROM
                (
                    SELECT
                        PPD2.*,
                        ISNULL((SELECT SUM(STOCK_IN-STOCK_OUT) FROM #dsn2_alias#.STOCKS_ROW SR2 WHERE SR2.PRODUCT_ID = P.PRODUCT_ID AND SR2.PROCESS_DATE<=PPD2.TARIH),0) STOCK
                        ,ISNULL(SR.STOCK_OUT,0) STOCK_OUT
                    FROM
                        PRODUCT_PRICE_DATES PPD2 LEFT JOIN
                        #dsn2_alias#.STOCKS_ROW SR ON 
                        (
                        	SR.PRODUCT_ID = P.PRODUCT_ID AND 
                            YEAR(SR.PROCESS_DATE) = YEAR(PPD2.TARIH) AND 
                            MONTH(SR.PROCESS_DATE) = MONTH(PPD2.TARIH) AND 
                            DAY(SR.PROCESS_DATE) = DAY(PPD2.TARIH)
                        )
                    WHERE
                    	PPD2.TARIH BETWEEN #attributes.search_startdate# AND #attributes.search_finishdate#
                
                ) A
            WHERE
                STOCK <> 0 OR STOCK_OUT > 0
        ),0) ORT_SATIS_MIKTARI,
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
                O.DELIVER_DEPT_ID = D.DEPARTMENT_ID
        ),0) PURCHASE_ORDER_QUANTITY,
        ISNULL((
        	SELECT	
                SUM(ORR.NETTOTAL * (1 + (ORR.TAX / 100)))
            FROM
                ORDERS O INNER JOIN
                ORDER_ROW ORR ON ORR.ORDER_ID = O.ORDER_ID
            WHERE
                O.PURCHASE_SALES = 0 AND
                ORR.ORDER_ROW_CURRENCY NOT IN (-3,-10) AND
                ORR.STOCK_ID = S.STOCK_ID AND
                O.DELIVER_DEPT_ID = D.DEPARTMENT_ID
        ),0) PURCHASE_ORDER_TUTAR,
        (
        	SELECT
                MULTIPLIER
            FROM
                PRODUCT_UNIT
            WHERE
                PRODUCT_ID = P.PRODUCT_ID AND
                UNIT_ID = 10
        ) MULTIPLIER,
        (SELECT NICKNAME FROM #dsn_alias#.COMPANY C WHERE C.COMPANY_ID = P.COMPANY_ID) NICKNAME
    FROM 
		<cfif isdefined("attributes.search_list_id") and len(attributes.search_list_id)>
        	#dsn_dev_alias#.SEARCH_LISTS_ROWS SLR,
        </cfif>
        #dsn_alias#.DEPARTMENT D,
        STOCKS S,
        #dsn1_alias#.PRODUCT P
        LEFT JOIN PRODUCT_UNIT ON P.PRODUCT_ID = PRODUCT_UNIT.PRODUCT_ID
        LEFT JOIN PRICE_STANDART ON PRODUCT_UNIT.PRODUCT_ID = PRICE_STANDART.PRODUCT_ID
        LEFT JOIN PRICE_STANDART AS PS2 ON PRODUCT_UNIT.PRODUCT_ID = PS2.PRODUCT_ID
        LEFT JOIN #dsn_dev_alias#.PRICE_TABLE AS PT_ALIS ON 
        	(
            	P.PRODUCT_ID = PT_ALIS.PRODUCT_ID AND 
                PT_ALIS.P_STARTDATE <= #bugun_# AND 
                PT_ALIS.P_FINISHDATE >= #bugun_# AND 
                PT_ALIS.NEW_ALIS IS NOT NULL AND 
                PT_ALIS.NEW_ALIS > 0 AND
                PT_ALIS.ROW_ID = (SELECT TOP 1 PT_IC.ROW_ID FROM #dsn_dev_alias#.PRICE_TABLE AS PT_IC WHERE P.PRODUCT_ID = PT_IC.PRODUCT_ID AND PT_IC.P_STARTDATE <= #bugun_# AND PT_IC.P_FINISHDATE >= #bugun_# AND PT_IC.NEW_ALIS IS NOT NULL AND PT_IC.NEW_ALIS > 0 ORDER BY PT_IC.NEW_ALIS ASC)
            )
        LEFT JOIN #dsn_dev_alias#.PRICE_TABLE AS PT_SATIS ON 
        	(
                P.PRODUCT_ID = PT_SATIS.PRODUCT_ID AND 
                PT_SATIS.STARTDATE <= #bugun_# AND 
                PT_SATIS.FINISHDATE >= #bugun_# AND 
                PT_SATIS.NEW_PRICE IS NOT NULL AND 
                PT_SATIS.NEW_PRICE > 0 AND
                PT_SATIS.ROW_ID = (SELECT TOP 1 PT_IC2.ROW_ID FROM #dsn_dev_alias#.PRICE_TABLE AS PT_IC2 WHERE P.PRODUCT_ID = PT_IC2.PRODUCT_ID AND PT_IC2.STARTDATE <= #bugun_# AND PT_IC2.FINISHDATE >= #bugun_# AND PT_IC2.NEW_PRICE IS NOT NULL AND PT_IC2.NEW_PRICE > 0 ORDER BY PT_IC2.NEW_PRICE ASC)
            ) 
    WHERE
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
        D.BRANCH_ID IN (SELECT BRANCH_ID FROM #dsn_alias#.EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#) AND
		<cfif len(attributes.search_department_id)>
            D.DEPARTMENT_ID IN (#attributes.search_department_id#) AND
        </cfif>
		<cfif len(attributes.table_code)>
        	P.PRODUCT_ID IN (SELECT STP.PRODUCT_ID FROM #dsn_dev_alias#.SEARCH_TABLES_PRODUCTS STP WHERE TABLE_CODE = '#attributes.table_code#')
        <cfelse>
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
            <cfif isdefined("attributes.search_list_id") and len(attributes.search_list_id)>
                SLR.LIST_ID = #attributes.search_list_id# AND
                SLR.PRODUCT_ID = P.PRODUCT_ID AND
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
            <cfif len(attributes.keyword)>
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
                P.PRODUCT_NAME LIKE '%#attributes.keyword#%'
            </cfif>
        </cfif>      
    ORDER BY
    	<cfif isdefined("attributes.search_list_id") and len(attributes.search_list_id)>
        	SLR.LINE_NUMBER,
        </cfif>
        P.PRODUCT_CODE ASC,
    	P.PRODUCT_NAME,
        S.PROPERTY,
        D.DEPARTMENT_HEAD
</cfquery>
<!---
<cfoutput>#get_products.recordcount#</cfoutput>
<br />
<cfdump var="#query_result#">
<CFABORT>
--->