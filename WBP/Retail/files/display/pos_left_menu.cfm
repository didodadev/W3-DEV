<cfoutput>
<ul id="tree">
  	<li><strong>Sayım İşlemleri</strong>
    	<ul>
			<cfif not listfindnocase(denied_pages,'retail.list_stock_count_orders')><li><a href="<cfoutput>#request.self#?fuseaction=retail.list_stock_count_orders</cfoutput>" class="tableyazi">Sayım Emirleri</a></li></cfif>
         	<cfif not listfindnocase(denied_pages,'retail.list_stock_count_orders_report_product')><li><a href="<cfoutput>#request.self#?fuseaction=retail.list_stock_count_orders_report_product</cfoutput>" class="tableyazi">Ürün Bazlı Sayım Karşılaştırma Raporu</a></li></cfif>
            <cfif not listfindnocase(denied_pages,'retail.list_stock_count_orders_report_product')><li><a href="<cfoutput>#request.self#?fuseaction=retail.list_stock_count_orders_report_product_cat_grup</cfoutput>" class="tableyazi">Grup Sıralı Ürün Bazlı Sayım Karşılaştırma Raporu</a></li></cfif>
            <cfif not listfindnocase(denied_pages,'retail.list_stock_count_orders_report_product')><li><a href="<cfoutput>#request.self#?fuseaction=retail.list_stock_count_orders_report_product_cat</cfoutput>" class="tableyazi">Kategori Bazlı Sayım Karşılaştırma Raporu</a></li></cfif>
            
         </ul>
    </li>
</cfoutput>
