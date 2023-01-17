<cfquery name="get_homepage_products" datasource="#DSN3#">
	SELECT 
		DISTINCT
			STOCKS.STOCK_ID,
			STOCKS.PRODUCT_ID,
			STOCKS.STOCK_CODE,
			GS.PRODUCT_STOCK, 
			PRODUCT.PRODUCT_NAME,
			STOCKS.PROPERTY,
			STOCKS.BARCOD,
			PRODUCT.TAX,
			PRODUCT.BRAND_ID,
			PRODUCT.PRODUCT_CODE,
			PRODUCT.PRODUCT_DETAIL,
			PRODUCT.PRODUCT_CATID,
			PRODUCT.RECORD_DATE
		FROM
			PRODUCT,
			PRODUCT_CAT,
			#DSN1_ALIAS#.PRODUCT_CAT_OUR_COMPANY AS PRODUCT_CAT_OUR_COMPANY,
			STOCKS,
			PRICE_STANDART,
			#dsn2_alias#.GET_STOCK GS
		WHERE
			PRODUCT_CAT.PRODUCT_CATID = PRODUCT_CAT_OUR_COMPANY.PRODUCT_CATID AND
			PRODUCT_CAT_OUR_COMPANY.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.our_company_id#"> AND
			PRODUCT_CAT.IS_PUBLIC = 1 
			AND
			PRODUCT.IS_INTERNET = 1
			AND
			PRODUCT.PRODUCT_STATUS = 1
			AND	
			PRODUCT.PRODUCT_ID = STOCKS.PRODUCT_ID
			AND
			GS.STOCK_ID = STOCKS.STOCK_ID 
			AND
			PRODUCT_CAT.PRODUCT_CATID = PRODUCT.PRODUCT_CATID
			AND
			PRICE_STANDART.PURCHASESALES = 1
			AND 
			PRICE_STANDART.PRODUCT_ID = STOCKS.PRODUCT_ID
			<cfif isdefined("attributes.altgrup") and len("attributes.altgrup")>
				AND PRODUCT_CAT.PRODUCT_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.altgrup#">
			</cfif>
			<cfif isdefined("attributes.anagrup") and len("attributes.anagrup") and not len(attributes.altgrup)>
				AND PRODUCT_CAT.PRODUCT_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.anagrup#">
			</cfif>
			<cfif isdefined("attributes.marka") and len(attributes.marka)>
				AND PRODUCT.BRAND_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.marka#">
			</cfif>
			<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
				AND PRODUCT.PRODUCT_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
			</cfif>
			<cfif isdefined("attributes.product_catid") and len(attributes.product_catid)>
				AND PRODUCT_CAT.PRODUCT_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_catid#">
			</cfif>
			<cfif isdefined("attributes.brand_id") and len(attributes.brand_id)>
				AND PRODUCT.BRAND_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.brand_id#">
			</cfif>
			ORDER BY 
				PRODUCT.PRODUCT_NAME
</cfquery>
