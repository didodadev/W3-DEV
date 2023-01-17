<cfquery name="LIST_PROMOTIONS" datasource="#DSN3#">
	SELECT
		PROMOTIONS.PROM_NO,
		PROMOTIONS.PROM_HEAD,
		PROMOTIONS.STOCK_ID,
		PROMOTIONS.ICON_ID,
		PROMOTIONS.STARTDATE,
		PROMOTIONS.FINISHDATE,		
		PRODUCT.PRODUCT_NAME,
		PRODUCT.PRODUCT_ID,
		STOCKS.PRODUCT_NAME
	FROM
		PROMOTIONS AS PROMOTIONS,
		PRODUCT AS PRODUCT,
		STOCKS AS STOCKS
	WHERE
		<cfif isDefined('attributes.prom_status') and len(attributes.prom_status)>PROMOTIONS.PROM_STATUS = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.prom_status#"> AND</cfif>
		PRODUCT.PRODUCT_ID = STOCKS.PRODUCT_ID AND
		STOCKS.STOCK_ID = PROMOTIONS.STOCK_ID AND
		<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> BETWEEN PROMOTIONS.STARTDATE AND PROMOTIONS.FINISHDATE 
		<cfif isdefined("attributes.is_prom_catid") and len(attributes.is_prom_catid)>
			AND PROMOTIONS.PRODUCT_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.is_prom_catid#">
		<cfelseif isdefined("attributes.catid") and len(attributes.catid)>
			AND PROMOTIONS.PRODUCT_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.catid#">
		</cfif>
	ORDER BY
		PROMOTIONS.PROM_ID DESC
</cfquery>
<cfset attributes.prod_coloum = 2>
<cfif list_promotions.recordcount>
	<cfset attributes.promotion_stock_list = valuelist(list_promotions.stock_id)>
	<cfinclude template="list_prices.cfm">
</cfif>

