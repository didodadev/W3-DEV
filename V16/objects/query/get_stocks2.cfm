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

<cfquery name="GET_STOCKS" datasource="#DSN1#">
	SELECT 
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
		PS.PRICE_KDV,
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
		,P.IS_PRODUCTION
		,P.IS_SALES
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
		PRODUCT_OUR_COMPANY POC,
		STOCKS S, 
		PRODUCT_UNIT PU,
		#dsn2_alias#.SETUP_TAX ST,
		STOCKS_BARCODES SB,
		PRICE_STANDART PS
	WHERE
		P.PRODUCT_ID = POC.PRODUCT_ID AND
		POC.OUR_COMPANY_ID = #session.ep.company_id# AND
		(P.PRODUCT_STATUS = 1 OR (P.PRODUCT_STATUS = 0 AND P.UPDATE_DATE BETWEEN #my_today# AND #my_tomorrow#)) AND
		P.IS_INVENTORY = 1 AND
		P.IS_SALES = 1 AND
		(S.STOCK_STATUS = 1 OR (S.STOCK_STATUS = 0 AND S.UPDATE_DATE BETWEEN #my_today# AND #my_tomorrow#)) AND		
		PS.PURCHASESALES = 1 AND
		PS.PRICESTANDART_STATUS = 1 AND
	<cfif isdefined("x_product_stage") and len(x_product_stage)>
		P.PRODUCT_STAGE IN (#x_product_stage#) AND
	</cfif>
	<cfif isdate(attributes.product_recorddate)>
		<cfif attributes.target_pos is "-4"><!--- bir urune bagli herhangi bir stock guncellenmis olabilir ancak tum urun ve cesitleri belgede olmali --->
			S.PRODUCT_ID IN (
							SELECT 
								PRODUCT_ID 
							FROM 
								STOCKS 
							<cfif isdefined('attributes.is_insert') or isdefined('attributes.is_update')>
							WHERE
							</cfif>
								<cfif isdefined('attributes.is_insert')>STOCKS.RECORD_DATE >= #attributes.product_recorddate#</cfif> 
								<cfif isdefined('attributes.is_insert') and isdefined('attributes.is_update')>OR</cfif>
								<cfif isdefined('attributes.is_update')>STOCKS.UPDATE_DATE >=#attributes.product_recorddate#</cfif>
							 ) AND
		<cfelse>
			(S.UPDATE_DATE >= #attributes.product_recorddate# OR S.RECORD_DATE >= #attributes.product_recorddate#) AND
		</cfif>
	</cfif>
		P.PRODUCT_ID = S.PRODUCT_ID AND
		SB.UNIT_ID = PU.PRODUCT_UNIT_ID AND
		SB.STOCK_ID = S.STOCK_ID AND
		SB.UNIT_ID = PS.UNIT_ID AND
		ST.TAX = P.TAX AND
		LEN(SB.BARCODE) > 6 AND
		LEN(SB.BARCODE) < 14 AND
		PS.PRICE < 10000000 AND
		(PS.PRICE <> 0 OR PS.PRICE_KDV <> 0)
	 <cfif isdefined("form.product_cat_id") and len(form.product_cat_id)>
		AND P.PRODUCT_CODE LIKE '#form.product_cat_id#%'
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
