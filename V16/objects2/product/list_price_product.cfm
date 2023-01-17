<cfquery name="LIST_PRICES_PRODUCT" datasource="#DSN3#">
	SELECT
		PRODUCT.PRODUCT_ID
	FROM
		PRICE AS PRICE,
		PRODUCT AS PRODUCT
	WHERE
		PRICE.PRODUCT_ID = PRODUCT.PRODUCT_ID AND
		<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> BETWEEN PRICE.STARTDATE AND PRICE.FINISHDATE 
		<cfif isdefined("attributes.last_user_price_list") and len(attributes.last_user_price_list)>
			AND PRICE.PRICE_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.last_user_price_list#">
		</cfif>
</cfquery>
<cfif list_prices_product.recordcount>
	<cfset attributes.price_productid_list = valuelist(list_prices_product.product_id)>
	<cfinclude template="list_prices.cfm">
</cfif>

