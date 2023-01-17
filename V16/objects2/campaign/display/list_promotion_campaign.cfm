<cfif isdefined("attributes.related_camp_id") and len(attributes.related_camp_id)>
	<cfset attributes.camp_id = attributes.related_camp_id>
</cfif>
<cfquery name="LIST_PROMOTIONS" datasource="#DSN3#">
	SELECT
		PROMOTIONS.PROM_HEAD,
		STOCKS.STOCK_ID,
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
		PROMOTIONS.CAMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.camp_id#"> AND
		PRODUCT.PRODUCT_ID = STOCKS.PRODUCT_ID AND
		#now()# BETWEEN PROMOTIONS.STARTDATE AND 
		PROMOTIONS.FINISHDATE AND
		(
			STOCKS.STOCK_ID = PROMOTIONS.STOCK_ID OR 
			(
				PROMOTIONS.BRAND_ID IS NOT NULL AND
				STOCKS.BRAND_ID = PROMOTIONS.BRAND_ID 
			)
			OR
			(
				PROMOTIONS.PRODUCT_CATID IS NOT NULL AND
				STOCKS.PRODUCT_CATID= PROMOTIONS.PRODUCT_CATID
			)
		)
	ORDER BY
		PROMOTIONS.PROM_ID DESC
</cfquery>
<cfif list_promotions.recordcount>
	<cfset attributes.promotion_stock_list = valuelist(list_promotions.stock_id)>
	<cfinclude template="../../product/list_prices.cfm">
</cfif>
