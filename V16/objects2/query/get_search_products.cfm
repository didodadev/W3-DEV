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
        PRODUCT.PRODUCT_CODE,
        PRODUCT.PRODUCT_DETAIL,
        PRODUCT.PRODUCT_CATID,
        PRODUCT.RECORD_DATE
    FROM
        PRODUCT,
        PRODUCT_CAT,
        #dsn1_alias#.PRODUCT_CAT_OUR_COMPANY AS PRODUCT_CAT_OUR_COMPANY,
        STOCKS,
        PRICE_STANDART,
        #dsn2_alias#.GET_STOCK GS
    WHERE
        PRODUCT_CAT.PRODUCT_CATID = PRODUCT_CAT_OUR_COMPANY.PRODUCT_CATID AND
        PRODUCT_CAT_OUR_COMPANY.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.our_company_id#"> AND
        PRODUCT_CAT.IS_PUBLIC = 1 AND
        PRODUCT.IS_INTERNET = 1 AND
        PRODUCT.PRODUCT_STATUS = 1 AND	
        PRODUCT.PRODUCT_ID = STOCKS.PRODUCT_ID AND
        GS.STOCK_ID = STOCKS.STOCK_ID AND
        PRODUCT_CAT.PRODUCT_CATID = PRODUCT.PRODUCT_CATID AND
        PRICE_STANDART.PURCHASESALES = 1 AND 
        PRICE_STANDART.PRODUCT_ID = STOCKS.PRODUCT_ID
    <cfif isDefined("attributes.keyword") and len(attributes.keyword)>
        AND
        (
            STOCKS.BARCOD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#"> OR
            PRODUCT.PRODUCT_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR
            PRODUCT_CAT.PRODUCT_CAT LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
        )
    </cfif>
    ORDER BY 
        PRODUCT.PRODUCT_NAME
</cfquery>
