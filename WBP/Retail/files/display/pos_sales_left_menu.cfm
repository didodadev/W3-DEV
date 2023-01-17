<cfoutput>
<ul id="tree">
	<li><strong>Pos İşlemleri</strong>
		<ul>
			<cfif not listfindnocase(denied_pages,'retail.list_stock_export')><li><a href="<cfoutput>#request.self#?fuseaction=retail.list_stock_export</cfoutput>" class="tableyazi">Stok Export</a></li></cfif>
			<cfif not listfindnocase(denied_pages,'retail.list_stock_import')><li><a href="<cfoutput>#request.self#?fuseaction=retail.list_stock_import</cfoutput>" class="tableyazi">Stok Import</a></li></cfif>
			<cfif not listfindnocase(denied_pages,'retail.list_sales_import')><li><a href="<cfoutput>#request.self#?fuseaction=retail.list_sales_import</cfoutput>" class="tableyazi">Satış Import</a></li></cfif>
			<cfif not listfindnocase(denied_pages,'retail.list_price_change_genius')><li><a href="<cfoutput>#request.self#?fuseaction=retail.list_price_change_genius</cfoutput>" class="tableyazi">Fiyat Değişim Export</a></li></cfif>
			<cfif not listfindnocase(denied_pages,'retail.list_price_change_import')><li><a href="<cfoutput>#request.self#?fuseaction=retail.list_price_change_import</cfoutput>" class="tableyazi">Fiyat Değişim Import</a></li></cfif>
			<cfif not listfindnocase(denied_pages,'retail.list_acnielsen')><li><a href="<cfoutput>#request.self#?fuseaction=retail.list_acnielsen</cfoutput>" class="tableyazi">AC Nielsen Raporları</a></li></cfif>
			<cfif not listfindnocase(denied_pages,'retail.list_export_promotion')><li><a href="<cfoutput>#request.self#?fuseaction=retail.list_export_promotion</cfoutput>" class="tableyazi">Promosyon Export</a></li></cfif>
		</ul>
	</li>
</cfoutput>
