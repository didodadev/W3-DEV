<cfquery name="get_suppliers" datasource="#DSN3#">
	SELECT
		NICKNAME,
		PRODUCT.COMPANY_ID
		
	FROM	
		#dsn_alias#.COMPANY COMPANY ,
		PRODUCT,
		STOCKS S
	WHERE
		S.STOCK_ID=PRODUCT.PRODUCT_ID
	AND
		PRODUCT.COMPANY_ID=COMPANY.COMPANY_ID
	AND
		S.STOCK_ID=#attributes.STOCK_ID#
</cfquery>
