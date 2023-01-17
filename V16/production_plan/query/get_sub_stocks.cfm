<cfquery name="get_stock" datasource="#DSN3#">
		SELECT
			STOCK_CODE,STOCK_ID,PROPERTY
		FROM
			STOCKS
		WHERE 
 			PRODUCT_ID=#attributes.prod_id#
		AND 
			STOCK_ID <> #attributes.STOCK_ID#
</cfquery> 

