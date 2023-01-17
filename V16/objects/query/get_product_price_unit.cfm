<cfquery name="GET_PRODUCT_PRICE" datasource="#dsn3#">
	SELECT
		PRODUCT.IS_INVENTORY,
		PRODUCT.PRODUCT_NAME,
		STOCKS.PROPERTY,
		PRODUCT.PRODUCT_ID,
		STOCKS.STOCK_ID,
		STOCKS.STOCK_CODE,
		PRODUCT.PRODUCT_CODE,
		PRODUCT.TAX,
		PRODUCT.OTV,
		PRODUCT.PRODUCT_CATID,
		PRODUCT.IS_SERIAL_NO,
		<cfif attributes.price_cat_id eq "-2">
			PRICE_STANDART.PRICE,
			PRICE_STANDART.PRICE_KDV,
			PRICE_STANDART.IS_KDV,
			PRICE_STANDART.MONEY,
		<cfelse>
			PRICE.PRICE,
			PRICE.PRICE_KDV,
			PRICE.IS_KDV,
			PRICE.MONEY,
		</cfif>
		PRODUCT_UNIT.ADD_UNIT,
		PRODUCT_UNIT.UNIT_ID,
		PRODUCT_UNIT.MAIN_UNIT,
		PRODUCT_UNIT.MULTIPLIER,
		PRODUCT_UNIT.ADD_UNIT,
		PRODUCT_UNIT.PRODUCT_UNIT_ID,
		PRODUCT_UNIT.WEIGHT,
		<cfif isdefined("attributes.company_id") and len(attributes.company_id)>
			(
				SELECT
					ISNULL(PRICE,0)
				FROM 
					PRICE_CAT_EXCEPTIONS PC,
					RELATED_CONTRACT RC
				WHERE
					((ISNULL(IS_GENERAL,0)=1 AND ACT_TYPE = 3) OR (ISNULL(IS_GENERAL,0)=0 AND ACT_TYPE = 1))
					AND PC.CONTRACT_ID  = RC.CONTRACT_ID
					AND (PC.SUPPLIER_ID IS NULL OR SUPPLIER_ID = (SELECT COMPANY_ID FROM STOCKS SS WHERE SS.STOCK_ID=STOCKS.STOCK_ID))
					AND (PC.PRODUCT_ID IS NULL OR PRODUCT_ID=STOCKS.PRODUCT_ID)
					AND (PC.BRAND_ID IS NULL OR BRAND_ID=(SELECT BRAND_ID FROM STOCKS SS WHERE STOCK_ID=STOCKS.STOCK_ID))
					AND (PC.PRODUCT_CATID IS NULL OR PRODUCT_CATID=(SELECT PRODUCT_CATID FROM STOCKS SS WHERE SS.STOCK_ID=STOCKS.STOCK_ID))
					AND (PC.SHORT_CODE_ID IS NULL OR SHORT_CODE_ID=(SELECT SHORT_CODE_ID FROM STOCKS SS WHERE SS.STOCK_ID=STOCKS.STOCK_ID))
					AND (PC.COMPANYCAT_ID IS NULL OR COMPANYCAT_ID = (SELECT COMPANYCAT_ID FROM #dsn_alias#.COMPANY WHERE COMPANY_ID=#attributes.company_id#))
					AND	(RC.COMPANY_ID=#attributes.company_id# OR RC.COMPANY_ID IS NULL)
					AND RC.STARTDATE <= #now()#
					AND RC.FINISHDATE >= #now()#
					<cfif isdefined("attributes.price_cat_id") and len(attributes.price_cat_id) and attributes.price_cat_id neq -2>
						AND PRICE_CATID=#attributes.price_cat_id#
					<cfelse>
						AND PRICE_CATID=-2
					</cfif>
			) PRICE_CONTRACT,
			(
				SELECT
					PRICE_MONEY
				FROM 
					PRICE_CAT_EXCEPTIONS PC,
					RELATED_CONTRACT RC
				WHERE
					((ISNULL(IS_GENERAL,0)=1 AND ACT_TYPE = 3) OR (ISNULL(IS_GENERAL,0)=0 AND ACT_TYPE = 1))
					AND PC.CONTRACT_ID  = RC.CONTRACT_ID
					AND (PC.SUPPLIER_ID IS NULL OR SUPPLIER_ID = (SELECT COMPANY_ID FROM STOCKS SS WHERE SS.STOCK_ID=STOCKS.STOCK_ID))
					AND (PC.PRODUCT_ID IS NULL OR PRODUCT_ID=STOCKS.PRODUCT_ID)
					AND (PC.BRAND_ID IS NULL OR BRAND_ID=(SELECT BRAND_ID FROM STOCKS SS WHERE STOCK_ID=STOCKS.STOCK_ID))
					AND (PC.PRODUCT_CATID IS NULL OR PRODUCT_CATID=(SELECT PRODUCT_CATID FROM STOCKS SS WHERE SS.STOCK_ID=STOCKS.STOCK_ID))
					AND (PC.SHORT_CODE_ID IS NULL OR SHORT_CODE_ID=(SELECT SHORT_CODE_ID FROM STOCKS SS WHERE SS.STOCK_ID=STOCKS.STOCK_ID))
					AND (PC.COMPANYCAT_ID IS NULL OR COMPANYCAT_ID = (SELECT COMPANYCAT_ID FROM #dsn_alias#.COMPANY WHERE COMPANY_ID=#attributes.company_id#))
					AND	(RC.COMPANY_ID=#attributes.company_id# OR RC.COMPANY_ID IS NULL)
					AND RC.STARTDATE <= #now()#
					AND RC.FINISHDATE >= #now()#
					<cfif isdefined("attributes.price_cat_id") and len(attributes.price_cat_id) and attributes.price_cat_id neq -2>
						AND PRICE_CATID=#attributes.price_cat_id#
					<cfelse>
						AND PRICE_CATID=-2
					</cfif>
			) PRICE_MONEY
		<cfelse>
			0 PRICE_CONTRACT,
			'' PRICE_MONEY
		</cfif>
	FROM
		PRODUCT,
		PRODUCT_CAT,
		PRODUCT_UNIT,
		<cfif attributes.price_cat_id eq "-2">
			PRICE_STANDART,
		<cfelse>
			PRICE,
		</cfif>
		STOCKS
	WHERE			
		PRODUCT.PRODUCT_STATUS = 1 AND
		STOCKS.STOCK_STATUS = 1 AND
		PRODUCT_UNIT.PRODUCT_ID = PRODUCT.PRODUCT_ID AND 
		PRODUCT.PRODUCT_ID = STOCKS.PRODUCT_ID AND
		PRODUCT_UNIT.PRODUCT_UNIT_STATUS = 1 AND
		PRODUCT_CAT.PRODUCT_CATID = PRODUCT.PRODUCT_CATID AND 
		PRODUCT_UNIT.IS_MAIN =1 AND
		<cfif attributes.price_cat_id eq "-2">
			PRICE_STANDART.PRICESTANDART_STATUS = 1	AND
			PRICE_STANDART.PURCHASESALES = 1 AND
			PRODUCT_UNIT.PRODUCT_UNIT_ID = PRICE_STANDART.UNIT_ID
		<cfelse>
			PRICE.PRICE_CATID = #attributes.price_cat_id# AND
			PRODUCT_UNIT.PRODUCT_UNIT_ID = PRICE.UNIT AND
			PRICE.STARTDATE <= #now()# AND
			(PRICE.FINISHDATE >= #now()# OR PRICE.FINISHDATE IS NULL)	
		</cfif>
		<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
			AND(PRODUCT.PRODUCT_NAME LIKE '<cfif len(attributes.keyword) gt 1>%</cfif>#attributes.keyword#%' 
				OR STOCKS.STOCK_CODE LIKE '<cfif len(attributes.keyword) gt 1>%</cfif>#attributes.keyword#%')
		</cfif>
		<cfif isdefined("attributes.product_cat") and len(attributes.product_cat)>
			AND PRODUCT_CAT.HIERARCHY = '#attributes.product_cat_id#'
		</cfif>
		<cfif isdefined("attributes.barcode") and len(attributes.barcode)>
			AND PRODUCT.BARCOD = '#attributes.barcode#'
		</cfif>
	ORDER BY
		PRODUCT.PRODUCT_NAME
</cfquery>
