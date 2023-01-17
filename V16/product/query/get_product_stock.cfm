<!--- _sil dosya silinecek
kullanılmıyor; list_product.cfm ve detail_product.cfm icinden simdilik disable edildi
*****
Bu sayfa her cagrildiginda pid(product_id) degerlerinden
biri verildiginde sayfa her bir ürün icin bir "product_stock" degeri üretir
*****
--->

<cfif isDefined("pid")>
	<cfquery name="PRODUCT_TOTAL_STOCK" datasource="#dsn2#">
		SELECT PRODUCT_TOTAL_STOCK FROM GET_PRODUCT_STOCK WHERE PRODUCT_ID = #PID#
	</cfquery>

	<cfif product_total_stock.recordcount>
		<cfset product_stock = product_total_stock.PRODUCT_TOTAL_STOCK>
	<cfelse>
		<cfset product_stock = 0>
	</cfif>
</cfif>
