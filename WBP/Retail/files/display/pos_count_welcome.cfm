<div class="pagemenus_container">
    <ul class="pagemenus">
        <li><strong>Sayım İşlemleri</strong>
        	<ul>
				<cfif not listfindnocase(denied_pages,'retail.list_stock_count_orders')><li><a href="<cfoutput>#request.self#?fuseaction=retail.list_stock_count_orders</cfoutput>" class="tableyazi">Sayım Emirleri</a></li></cfif>
			</ul>
        </li>
        
        <li><strong>Stok Düzenleme İşlemleri</strong>
        	<ul>
            	<cfif not listfindnocase(denied_pages,'retail.list_manage_stocks')><li><a href="<cfoutput>#request.self#?fuseaction=retail.list_manage_stocks</cfoutput>" class="tableyazi">Stok Düzenleme Listesi</a></li></cfif>
				<cfif not listfindnocase(denied_pages,'retail.manage_stocks')><li><a href="<cfoutput>#request.self#?fuseaction=retail.manage_stocks</cfoutput>" class="tableyazi">Stok Düzenleme</a></li></cfif>
            </ul>
        </li>
    </ul>
</div>
<script src="../design/SpryAssets/left_menus/jquery.treeview.js" type="text/javascript"></script>