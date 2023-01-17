<cfset my_today = CreateDateTime(year(now()),month(now()),day(now()),00,00,00)>
<cfset my_tomorrow = date_add('d',+1,my_today)>

<!--- Son urun asamasini almak icin kullanildi BK 20060815 --->
<!--- bk kapatti 20120115 1 yila silinsin
<cfquery name="GET_PROCESS_TYPE" datasource="#DSN#" maxrows="1">
	SELECT TOP 1
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
		PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
		PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%product.form_upd_product,%">
	ORDER BY
		PTR.LINE_NUMBER DESC
</cfquery> --->

<cfif session.ep.admin or session.ep.userid eq 3>
	<cfset bugun_ = attributes.product_finishdate>
<cfelse>
	<cfset bugun_ = createodbcdatetime(createdate(year(now()),month(now()),day(now())))>
</cfif>
<cfquery name="GET_STOCKS" datasource="#DSN1#" result="my_result">
	SELECT 
		ISNULL((SELECT TOP 1 EPTR.SUB_TYPE_ID FROM #DSN_DEV#.EXTRA_PRODUCT_TYPES_ROWS EPTR WHERE EPTR.PRODUCT_ID = P.PRODUCT_ID AND EPTR.TYPE_ID = #ambalaj_type_id#),0) AS AMBALAJ_SUB_TYPE,
        ISNULL((SELECT TOP 1 EPTR.SUB_TYPE_ID FROM #DSN_DEV#.EXTRA_PRODUCT_TYPES_ROWS EPTR WHERE EPTR.PRODUCT_ID = P.PRODUCT_ID AND EPTR.TYPE_ID = #uretici_type_id#),0) AS URETICI_SUB_TYPE,
        ISNULL((SELECT TOP 1 EPTR.SUB_TYPE_ID FROM #DSN_DEV#.EXTRA_PRODUCT_TYPES_ROWS EPTR WHERE EPTR.PRODUCT_ID = P.PRODUCT_ID AND EPTR.TYPE_ID = #muadil_type_id#),0) AS MUADIL_SUB_TYPE,
        ISNULL((SELECT TOP 1 EPTR.SUB_TYPE_ID FROM #DSN_DEV#.EXTRA_PRODUCT_TYPES_ROWS EPTR WHERE EPTR.PRODUCT_ID = P.PRODUCT_ID AND EPTR.TYPE_ID = #marka_type_id#),0) AS MARKA_SUB_TYPE,
        ISNULL((SELECT TOP 1 EPTR.SUB_TYPE_ID FROM #DSN_DEV#.EXTRA_PRODUCT_TYPES_ROWS EPTR WHERE EPTR.PRODUCT_ID = P.PRODUCT_ID AND EPTR.TYPE_ID = #promosyon_type_id#),0) AS PROMOSYON_SUB_TYPE,
        ISNULL((SELECT TOP 1 EPTR.SUB_TYPE_ID FROM #DSN_DEV#.EXTRA_PRODUCT_TYPES_ROWS EPTR WHERE EPTR.PRODUCT_ID = P.PRODUCT_ID AND EPTR.TYPE_ID = #market_promosyon_type_id#),0) AS MARKET_PROMOSYON_SUB_TYPE,
        ISNULL((SELECT TOP 1 EPTR.SUB_TYPE_ID FROM #DSN_DEV#.EXTRA_PRODUCT_TYPES_ROWS EPTR WHERE EPTR.PRODUCT_ID = P.PRODUCT_ID AND EPTR.TYPE_ID = #sektor_type_id#),0) AS SEKTOR_SUB_TYPE,
        ISNULL((SELECT TOP 1 EPTR.SUB_TYPE_ID FROM #DSN_DEV#.EXTRA_PRODUCT_TYPES_ROWS EPTR WHERE EPTR.PRODUCT_ID = P.PRODUCT_ID AND EPTR.TYPE_ID = #buyukluk_type_id#),0) AS BUYUKLUK_SUB_TYPE,
        NULL AS BRAND_NAME,
        ISNULL(P.IS_SALES,0) AS IS_SALES,
        ISNULL(S.STOCK_IS_SALES,0) AS STOCK_IS_SALES,
        P.G_PRODUCT_TYPE,
        P.PRODUCT_NAME,
		P.PRODUCT_ID,
		P.PRODUCT_CODE,	
		P.BRAND_ID,		
		P.IS_TERAZI,
		P.RECORD_DATE,
		P.PRODUCT_CATID,
		P.COMPANY_ID,
		P.PRODUCT_CODE_2,
        P.PRODUCT_DETAIL2,
		S.STOCK_ID,
		S.PROPERTY,
		PU.ADD_UNIT,
		PU.UNIT_ID,
		PU.IS_MAIN,
		PU.MULTIPLIER,
		ST.TAX_ID,
		ST.TAX,
		SB.UNIT_ID PRODUCT_UNIT_ID,
		SB.BARCODE BARCOD,
        ISNULL(( 
                SELECT TOP 1 
                    CAST(ISNULL(PT1.P_PRODUCT_TYPE,0) AS INTEGER)
                FROM
                    #DSN_DEV#.PRICE_TABLE PT1
                WHERE
                    PT1.IS_ACTIVE_S = 1 AND
                    (
                    PT1.STARTDATE <= #bugun_# AND DATEADD("d",-1,PT1.FINISHDATE) >= #bugun_#
                    ) 
                    AND
                    (PT1.STOCK_ID = S.STOCK_ID OR (PT1.STOCK_ID IS NULL AND PT1.PRODUCT_ID = P.PRODUCT_ID))
                    AND
                    PT1.ROW_ID NOT IN (SELECT PTD1.ROW_ID FROM #DSN_DEV#.PRICE_TABLE_DEPARTMENTS PTD1)
                ORDER BY
                	PT1.STARTDATE DESC,
					PT1.ROW_ID DESC 
            ),'-1') AS P_PRODUCT_TYPE,
        ISNULL(( 
                SELECT TOP 1 
                    PT1.NEW_PRICE_KDV
                FROM
                    #DSN_DEV#.PRICE_TABLE PT1
                WHERE
                    PT1.IS_ACTIVE_S = 1 AND
                    (
                    PT1.STARTDATE <= #bugun_# AND DATEADD("d",-1,PT1.FINISHDATE) >= #bugun_#
                    ) 
                    AND
                    (PT1.STOCK_ID = S.STOCK_ID OR (PT1.STOCK_ID IS NULL AND PT1.PRODUCT_ID = P.PRODUCT_ID))
                    AND
                    PT1.ROW_ID NOT IN (SELECT PTD1.ROW_ID FROM #DSN_DEV#.PRICE_TABLE_DEPARTMENTS PTD1)
                ORDER BY
                	PT1.STARTDATE DESC,
					PT1.ROW_ID DESC
            ),PS.PRICE_KDV) AS PRICE_KDV,
        ISNULL(( 
                SELECT TOP 1 
                    CAST(ISNULL(PT1.P_PRODUCT_TYPE,0) AS INTEGER)
                FROM
                    #DSN_DEV#.PRICE_TABLE PT1
                WHERE
                    PT1.IS_ACTIVE_S = 1 AND
                    (
                    PT1.STARTDATE <= #bugun_# AND DATEADD("d",-1,PT1.FINISHDATE) >= #bugun_#
                    ) 
                    AND
                    (PT1.STOCK_ID = S.STOCK_ID OR (PT1.STOCK_ID IS NULL AND PT1.PRODUCT_ID = P.PRODUCT_ID))
                    AND
                    PT1.ROW_ID IN (SELECT PTD1.ROW_ID FROM #DSN_DEV#.PRICE_TABLE_DEPARTMENTS PTD1 WHERE PTD1.DEPARTMENT_ID = #attributes.department_id#)
                ORDER BY
                	PT1.STARTDATE DESC,
					PT1.ROW_ID DESC 
            ),'-1') AS P_PRODUCT_TYPE_DEPT,
        ISNULL(( 
                SELECT TOP 1 
                    PT1.NEW_PRICE_KDV
                FROM
                    #DSN_DEV#.PRICE_TABLE PT1
                WHERE
                    PT1.IS_ACTIVE_S = 1 AND
                    (
                    PT1.STARTDATE <= #bugun_# AND DATEADD("d",-1,PT1.FINISHDATE) >= #bugun_#
                    ) 
                    AND
                    (PT1.STOCK_ID = S.STOCK_ID OR (PT1.STOCK_ID IS NULL AND PT1.PRODUCT_ID = P.PRODUCT_ID))
                    AND
                    PT1.ROW_ID IN (SELECT PTD1.ROW_ID FROM #DSN_DEV#.PRICE_TABLE_DEPARTMENTS PTD1 WHERE PTD1.DEPARTMENT_ID = #attributes.department_id#)
                ORDER BY
                	PT1.STARTDATE DESC,
					PT1.ROW_ID DESC
            ),-1) AS PRICE_KDV_DEPT,
		PS.PRICE,
		PS.IS_KDV,
		PS.MONEY
		<cfif attributes.target_pos is "-4"><!--- workcube belge formatında lazım olan alanlar --->
		,P.MANUFACT_CODE
		,P.PRODUCT_STAGE
		,P.PRODUCT_DETAIL
		,P.PROD_COMPETITIVE
		,P.COMPANY_ID
		,P.UPDATE_DATE
        ,P.IS_INVENTORY
		,P.INVENTORY_CALC_TYPE
		,P.IS_PRODUCTION
		,P.IS_PURCHASE
		,P.IS_PROTOTYPE
		,P.IS_INTERNET
		,P.IS_EXTRANET
		,P.IS_SERIAL_NO
		,P.IS_ZERO_STOCK
		,P.IS_KARMA
		,P.IS_COST
		,S.STOCK_CODE  
		,S.RECORD_DATE STOCK_RECORD_DATE
		,S.UPDATE_DATE STOCK_UPDATE_DATE        
		</cfif>
	FROM 
		PRODUCT P, 
		STOCKS S, 
		PRODUCT_UNIT PU,
		#dsn2_alias#.SETUP_TAX ST,
		STOCKS_BARCODES SB,
		PRICE_STANDART PS
	WHERE
        <cfif isdefined("attributes.barcode") and len(attributes.barcode)>
        	SB.BARCODE LIKE '#attributes.barcode#%' AND
        </cfif>
        --P.PRODUCT_STATUS = 1 AND
		--P.IS_SALES = 1 AND
		P.IS_INVENTORY = 1 AND
		(S.STOCK_STATUS = 1 OR (S.STOCK_STATUS = 0 AND S.UPDATE_DATE BETWEEN #attributes.product_startdate# AND #attributes.product_finishdate#)) AND		
		PS.PURCHASESALES = 1 AND
		PS.PRICESTANDART_STATUS = 1 AND
	<cfif isdefined("x_product_stage") and len(x_product_stage)>
		P.PRODUCT_STAGE IN (#x_product_stage#) AND
	</cfif>
    <cfif attributes.is_all eq 0>
		<cfif isdate(attributes.product_startdate)>
                (
                S.PRODUCT_ID IN 
                    (
                        SELECT 
                            PRODUCT_ID
                        FROM
                            #DSN_DEV#.PRICE_TABLE PT1
                        WHERE
                            PT1.IS_ACTIVE_S = 1 AND
                            (
                                PT1.STARTDATE BETWEEN #attributes.product_startdate# AND #attributes.product_finishdate# OR
                                DATEADD("d",-1,PT1.FINISHDATE) BETWEEN #attributes.product_startdate# AND #attributes.product_finishdate#
                            )
                    )
                OR
                (
                PS.START_DATE >= #attributes.product_startdate# AND 
                PS.START_DATE < #dateadd('d',1,attributes.product_finishdate)#
                )
                OR
                (
                P.RECORD_DATE >= #attributes.product_startdate# AND 
                P.RECORD_DATE < #dateadd('d',1,attributes.product_finishdate)#
                )
                OR
                (
                P.FORCE_UPDATE_DATE >= #attributes.product_startdate# AND 
                P.FORCE_UPDATE_DATE < #dateadd('d',1,attributes.product_finishdate)#
                )
                OR
                (
                S.UPDATE_DATE >= #attributes.product_startdate# AND 
                S.UPDATE_DATE < #dateadd('d',1,attributes.product_finishdate)#
                )
             ) 
             AND
        </cfif>
    </cfif>
		P.PRODUCT_ID = S.PRODUCT_ID AND
		SB.UNIT_ID = PU.PRODUCT_UNIT_ID AND
		SB.STOCK_ID = S.STOCK_ID AND
		SB.UNIT_ID = PS.UNIT_ID AND
		ST.TAX = P.TAX AND
		PS.PRICE < 10000000 AND
		(PS.PRICE <> 0 OR PS.PRICE_KDV <> 0)
        
	 <cfif isdefined("form.product_cat_id") and len(form.product_cat_id)>
		AND 
        	(
            <cfset count_ = 0>
            <cfloop list="#attributes.product_cat_id#" index="ccc">
                <cfset count_ = count_ + 1>
                P.PRODUCT_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#ccc#.%">
                <cfif count_ Neq listlen(attributes.product_cat_id)>
                    OR
                </cfif>
            </cfloop>
            )
	</cfif>
	<cfif isdefined("form.product_name") and isdefined("form.product_id") and len(form.product_name) and len(form.product_id)>
		AND P.PRODUCT_ID = #form.product_id#
	</cfif>
	<cfif isdefined("form.company_id") and len(form.company_id)>
		AND P.COMPANY_ID = #form.company_id#
	</cfif>
	<cfif isdefined("form.brand_id") and len(form.brand_id)>
		AND P.BRAND_ID = #form.brand_id#
	</cfif>
	<!--- Stok Export Detayindaki PHL İçin Sadece Tedarik Edilenleri Getir secilirse  --->
	<cfif isdefined("attributes.is_phl") and len(attributes.is_phl)>
		AND P.IS_PURCHASE = 1
	</cfif>
	<cfif attributes.target_pos is "-4">
	ORDER BY
		S.STOCK_CODE
	</cfif>
</cfquery>