<cfquery name="PRODUCTS" datasource="#DSN3#">
	SELECT
		PRODUCT.COMPANY_ID,
		PRODUCT.PRODUCT_ID,
		PRODUCT.PRODUCT_NAME,
		PRODUCT.MANUFACT_CODE,
		PRODUCT.TAX,
		PRODUCT.TAX_PURCHASE,
		PRODUCT.PRODUCT_CATID,
		PRODUCT.IS_SERIAL_NO,
	<cfif isdefined("attributes.price_catid") and attributes.price_catid gt 0>
		PRICE.PRICE,
		PRICE.MONEY,
	<cfelse>
		PRICE_STANDART.PRICE,
		PRICE_STANDART.MONEY,
	</cfif>			
		PRODUCT_UNIT.ADD_UNIT,
		PRODUCT_UNIT.PRODUCT_UNIT_ID,
		PRODUCT_UNIT.MAIN_UNIT,
		PRODUCT_UNIT.MULTIPLIER,
		STOCKS.STOCK_ID,
		STOCKS.PROPERTY,
		STOCKS.STOCK_CODE,
		STOCKS.BARCOD,
        STOCKS.IS_PRODUCTION,
		STOCKS.ASSORTMENT_DEFAULT_AMOUNT,
		(SELECT SP.SPECT_MAIN_ID FROM SPECT_MAIN SP WHERE SP.STOCK_ID = STOCKS.STOCK_ID AND SP.SPECT_MAIN_ID = (SELECT MAX(SMM.SPECT_MAIN_ID) FROM SPECT_MAIN SMM WHERE SMM.STOCK_ID = STOCKS.STOCK_ID AND SMM.IS_TREE = 1)) SPECT_MAIN_ID,
		(SELECT SP.SPECT_MAIN_NAME FROM SPECT_MAIN SP WHERE SP.STOCK_ID = STOCKS.STOCK_ID AND SP.SPECT_MAIN_ID = (SELECT MAX(SMM.SPECT_MAIN_ID) FROM SPECT_MAIN SMM WHERE SMM.STOCK_ID = STOCKS.STOCK_ID AND SMM.IS_TREE = 1)) SPECT_MAIN_NAME
	FROM
		PRODUCT,
		PRODUCT_CAT,
		PRODUCT_UNIT,
		STOCKS,
	<cfif isdefined("attributes.price_catid") and attributes.price_catid gt 0>
		PRICE, PRICE_CAT
	<cfelse>
		PRICE_STANDART
	</cfif>
	WHERE
	<!--- <cfif not ( len(attributes.product_cat_code) or len(attributes.keyword) or (len(attributes.employee_id) and len(attributes.employee)) or (len(attributes.search_company_id) and len(attributes.search_company)) )>
		PRODUCT.PRODUCT_ID IS NULL AND <!--- kayit getirmesin --->
	</cfif> --->
		PRODUCT.PRODUCT_STATUS = 1 AND 	
		STOCKS.PRODUCT_ID = PRODUCT.PRODUCT_ID AND
		PRODUCT_UNIT.PRODUCT_ID = PRODUCT.PRODUCT_ID AND 
		PRODUCT_UNIT.PRODUCT_UNIT_STATUS = 1 AND 
		PRODUCT_CAT.PRODUCT_CATID = PRODUCT.PRODUCT_CATID AND 
		PRODUCT.IS_SALES = 1 AND
		PRODUCT_UNIT.IS_MAIN = 1
	<cfif isdefined("attributes.price_catid") and len(attributes.price_catid) and attributes.price_catid gt 0><!--- dinamik bir fiyat kategorisi istenmisse --->
		AND PRICE_CAT.PRICE_CATID = #attributes.price_catid#			
		AND	PRICE_CAT.PRICE_CAT_STATUS = 1
		AND	PRICE_CAT.PRICE_CATID = PRICE.PRICE_CATID
		AND PRICE.STARTDATE <= #now()#
		AND	(PRICE.FINISHDATE >= #now()# OR PRICE.FINISHDATE IS NULL)
		AND PRICE.UNIT = PRODUCT_UNIT.PRODUCT_UNIT_ID
		AND ((ISNULL(PRICE.STOCK_ID,0) = STOCKS.STOCK_ID AND PRICE.STOCK_ID IS NOT NULL) OR (ISNULL(PRICE.STOCK_ID,0) = 0 AND PRICE.STOCK_ID IS NULL))
		AND	ISNULL(PRICE.SPECT_VAR_ID,0) =0
	<cfelseif isdefined("attributes.price_catid") and attributes.price_catid eq '-1'><!--- Standart alis Fiyatlari Default Gelsin --->
		AND PRICE_STANDART.PURCHASESALES = 0
		AND PRODUCT_UNIT.PRODUCT_UNIT_ID = PRICE_STANDART.UNIT_ID
		AND PRICE_STANDART.PRICESTANDART_STATUS = 1			
	<cfelse>
		AND PRICE_STANDART.PRICESTANDART_STATUS = 1			
		AND PRICE_STANDART.PURCHASESALES = 1
		AND PRODUCT_UNIT.PRODUCT_UNIT_ID = PRICE_STANDART.UNIT_ID
	</cfif>
	<cfif isDefined("attributes.product_cat_code") and len(attributes.product_cat_code)>
		AND PRODUCT.PRODUCT_CODE LIKE '#attributes.product_cat_code#.%'
	</cfif>
	<cfif isdefined("attributes.product_catid") and isdefined("attributes.product_cat") and len(attributes.product_cat) and len(attributes.product_catid)>
		AND STOCKS.PRODUCT_CODE LIKE (SELECT HIERARCHY FROM PRODUCT_CAT WHERE PRODUCT_CATID=#attributes.product_catid#)+'.%' <!---kategori hiyerarşisine gore arama yapıyor --->
	</cfif>
	<cfif isDefined("attributes.product_id") and len(attributes.product_id)>
		AND PRODUCT.PRODUCT_ID = #attributes.product_id#
	</cfif>
	<cfif isDefined("attributes.karma_product_id") and len(attributes.karma_product_id)>
		AND STOCKS.PRODUCT_ID = #attributes.karma_product_id# 
	</cfif>
	<cfif isDefined("attributes.karma_product_barcod") and len(attributes.karma_product_barcod)>
		AND STOCKS.BARCOD <> '#attributes.karma_product_barcod#'
	</cfif>
	<cfif isDefined("attributes.property_collar_det") and len(attributes.property_collar_det)>
		AND STOCKS.STOCK_CODE_2 LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.property_collar_det#%">
	</cfif>
	<cfif isDefined("attributes.keyword") and len(attributes.keyword)>
		AND 
		(
		<cfif len(attributes.keyword) eq 1 >
			PRODUCT.PRODUCT_NAME LIKE '#attributes.keyword#%' 
		<cfelseif len(attributes.keyword) gt 1>
			<cfif listlen(attributes.keyword,"+") gt 1>
				(
					<cfloop from="1" to="#listlen(attributes.keyword,'+')#" index="pro_index">
						PRODUCT.PRODUCT_NAME LIKE '%#ListGetAt(attributes.keyword,pro_index,"+")#%' 
						<cfif pro_index neq listlen(attributes.keyword,'+')>AND</cfif>
					</cfloop>
				)		
			<cfelse>
				PRODUCT.PRODUCT_NAME LIKE '%#attributes.keyword#%' OR
				PRODUCT.PRODUCT_CODE LIKE '<cfif len(attributes.keyword) gt 1>%</cfif>#attributes.keyword#%' OR
				PRODUCT.BARCOD='#attributes.keyword#' OR 
				PRODUCT.MANUFACT_CODE LIKE '<cfif len(attributes.keyword) gt 1>%</cfif>#attributes.keyword#%' 
			</cfif>
		</cfif>		
		) 
	</cfif>
	<cfif isdefined("attributes.employee") and len(attributes.employee_id) and len(attributes.employee)>
		AND PRODUCT.PRODUCT_MANAGER = #attributes.employee_id#
	</cfif>
	<cfif isdefined("attributes.search_company_id") and len(attributes.search_company_id) and isdefined("attributes.search_company") and len(attributes.search_company)>
		AND PRODUCT.COMPANY_ID = #attributes.search_company_id#
	</cfif>
	ORDER BY
		PRODUCT.PRODUCT_NAME
</cfquery>
