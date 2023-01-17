<!--- bu sayfa ürün icin tüm giris-çikislari gösterecek --->
<cfif isDefined("pid")>
		<cfquery name="PRODUCT_TOTAL_STOCK" datasource="#dsn2#">
			SELECT 
				PRODUCT_TOTAL_STOCK 
			FROM 
				GET_PRODUCT_STOCK 
			WHERE PRODUCT_ID = #PID#
		</cfquery>
		<cfif #product_total_stock.recordcount# eq 0>
			<cfset product_stock='Hareket Yok'>
		<cfelse>
			<cfset product_stock=#product_total_stock.PRODUCT_TOTAL_STOCK#>
		</cfif>
</cfif>


