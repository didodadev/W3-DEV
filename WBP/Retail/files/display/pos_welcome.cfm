<div class="pagemenus_container">
    <ul class="pagemenus">
        <li><strong>Pos İşlemleri</strong>
        	<ul>
				<cfif not listfindnocase(denied_pages,'retail.list_department_extra_info')><li><a href="<cfoutput>#request.self#?fuseaction=retail.list_department_extra_info</cfoutput>" class="tableyazi">Şube Extra Tanımları</a></li></cfif>
				<cfif not listfindnocase(denied_pages,'retail.list_pos_equipment')><li><a href="<cfoutput>#request.self#?fuseaction=retail.list_pos_equipment</cfoutput>" class="tableyazi">Yazar Kasalar</a></li></cfif>
                <cfif not listfindnocase(denied_pages,'retail.list_pos_users')><li><a href="<cfoutput>#request.self#?fuseaction=retail.list_pos_users</cfoutput>" class="tableyazi">Yazar Kasa Kullanıcıları</a></li></cfif>
				<cfif not listfindnocase(denied_pages,'retail.list_pos_pay_methods')><li><a href="<cfoutput>#request.self#?fuseaction=retail.list_pos_pay_methods</cfoutput>" class="tableyazi">Ödeme Tipleri</a></li></cfif>
                <cfif not listfindnocase(denied_pages,'retail.popup_export_terazi')><li><a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=retail.popup_export_terazi</cfoutput>','medium');" class="tableyazi">Terazi</a></li></cfif>
				<cfif not listfindnocase(denied_pages,'retail.list_export_promotion')><li><a href="<cfoutput>#request.self#?fuseaction=retail.list_export_promotion</cfoutput>" class="tableyazi">Promosyon Export</a></li></cfif>
			</ul>
        </li>
        <br /><br />
        <li><strong>Promosyon</strong>
        	<ul>
				<cfif not listfindnocase(denied_pages,'retail.list_promotions')><li><a href="<cfoutput>#request.self#?fuseaction=retail.list_promotions</cfoutput>" class="tableyazi">Promosyonlar</a></li></cfif>
                <cfif not listfindnocase(denied_pages,'retail.add_promotion')><li><a href="<cfoutput>#request.self#?fuseaction=retail.add_promotion</cfoutput>" class="tableyazi">Promosyon Ekle</a></li></cfif>
			</ul>
        </li>
        <br /><br />
        <li><strong>Etiket</strong>
        	<ul>
				<cfif not listfindnocase(denied_pages,'retail.list_etiket')><li><a href="<cfoutput>#request.self#?fuseaction=retail.list_etiket</cfoutput>" class="tableyazi">Etiketleri Listele</a></li></cfif>
			</ul>
        </li>
        <br /><br />
        <li><strong>Genius</strong>
        	<ul>
				<cfif not listfindnocase(denied_pages,'retail.list_stock_export')><li><a href="<cfoutput>#request.self#?fuseaction=retail.list_stock_export</cfoutput>" class="tableyazi">Yazar Kasa Bilgi Hazırlama</a></li></cfif>
                <cfif not listfindnocase(denied_pages,'retail.list_sales_import')><li><a href="<cfoutput>#request.self#?fuseaction=retail.list_sales_import</cfoutput>" class="tableyazi">Satış Import</a></li></cfif>
				<cfif not listfindnocase(denied_pages,'retail.offline_import')><li><a href="<cfoutput>#request.self#?fuseaction=retail.offline_import</cfoutput>" class="tableyazi">Offline Aktarım</a></li></cfif>
				<cfif not listfindnocase(denied_pages,'retail.genius_action_watch_screen')><li><a href="<cfoutput>#request.self#?fuseaction=retail.genius_action_watch_screen</cfoutput>" class="tableyazi">Genius Aktarım İzleme</a></li></cfif>
                <cfif not listfindnocase(denied_pages,'retail.genius_online_sales_screen')><li><a href="<cfoutput>#request.self#?fuseaction=retail.genius_online_sales_screen</cfoutput>" class="tableyazi">Online Satış İzleme</a></li></cfif>
				<cfif not listfindnocase(denied_pages,'retail.genius_clear_rows')><li><a href="<cfoutput>#request.self#?fuseaction=retail.genius_clear_rows</cfoutput>" class="tableyazi">Genius Aktarım Silme</a></li></cfif>
                <cfif not listfindnocase(denied_pages,'retail.list_genius_in')><li><a href="<cfoutput>#request.self#?fuseaction=retail.list_genius_in</cfoutput>" class="tableyazi">Pos Kasa Para Teslim Tutanağı</a></li></cfif>
            </ul>
        </li>
    </ul>
</div>
<script src="../design/SpryAssets/left_menus/jquery.treeview.js" type="text/javascript"></script>