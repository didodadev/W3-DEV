<div class="pagemenus_container">
    <ul class="pagemenus">
        <li><strong><cf_get_lang dictionary_id='36021.Pos İşlemleri'></strong>
        	<ul>
				<cfif not listfindnocase(denied_pages,'pos.list_stock_export')><li><a href="<cfoutput>#request.self#?fuseaction=pos.list_stock_export</cfoutput>" class="tableyazi"><cf_get_lang dictionary_id='36020.Stok Export'></a></li></cfif>
				<cfif not listfindnocase(denied_pages,'pos.list_stock_import')><li><a href="<cfoutput>#request.self#?fuseaction=pos.list_stock_import</cfoutput>" class="tableyazi"><cf_get_lang dictionary_id='36045.Stok Import'></a></li></cfif>
				<cfif not listfindnocase(denied_pages,'pos.list_sales_import')><li><a href="<cfoutput>#request.self#?fuseaction=pos.list_sales_import</cfoutput>" class="tableyazi"><cf_get_lang dictionary_id='36008.Satış Import'></a></li></cfif>
				<cfif not listfindnocase(denied_pages,'pos.list_price_change_genius')><li><a href="<cfoutput>#request.self#?fuseaction=pos.list_price_change_genius</cfoutput>" class="tableyazi"><cf_get_lang dictionary_id='36033.Fiyat Değişim Export'></a></li></cfif>
				<cfif not listfindnocase(denied_pages,'pos.list_price_change_import')><li><a href="<cfoutput>#request.self#?fuseaction=pos.list_price_change_import</cfoutput>" class="tableyazi"><cf_get_lang dictionary_id='58725.Fiyat Değişim Import'></a></li></cfif>
				<cfif not listfindnocase(denied_pages,'pos.list_acnielsen')><li><a href="<cfoutput>#request.self#?fuseaction=pos.list_acnielsen</cfoutput>" class="tableyazi"><cf_get_lang dictionary_id='36002.AC Nielsen Raporları'></a></li></cfif>
				<cfif not listfindnocase(denied_pages,'pos.list_export_promotion')><li><a href="<cfoutput>#request.self#?fuseaction=pos.list_export_promotion</cfoutput>" class="tableyazi"><cf_get_lang dictionary_id='36047.Promosyon Export'></a></li></cfif>
				<cfif not listfindnocase(denied_pages,'pos.list_xml_imports')><li><a href="<cfoutput>#request.self#?fuseaction=pos.list_xml_import</cfoutput>" class="tableyazi"><cf_get_lang dictionary_id='29478.XML Import'></a></li></cfif>
			</ul>
        </li>
    </ul>
    <ul class="pagemenus">
        <li><strong><cf_get_lang dictionary_id='36158.PHL Dosyası Oluştur'></strong>
        	<ul>
				<cfif not listfindnocase(denied_pages,'pos.emptypopup_take_phl_file1')><li><a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_create_phl_file</cfoutput>','small','pos_islem');" class="tableyazi"><cf_get_lang dictionary_id='29477.Belge Oluştur'></a></li></cfif>
			</ul>
        </li>
    </ul>
    <ul class="pagemenus">
        <li><strong><cf_get_lang dictionary_id='36050.Yürüyen Stok'></strong>
        	<ul>
				<cfif not listfindnocase(denied_pages,'stock.list_stock_count')><li><a href="<cfoutput>#request.self#?fuseaction=stock.list_stock_count</cfoutput>" class="tableyazi"><cf_get_lang dictionary_id='36051.Sayım Belgeleri'></a></li></cfif>
				<cfif not listfindnocase(denied_pages,'stock.list_stock_count')><li><a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=stock.list_stock_count&event=add&department_id=#listfirst(session.ep.user_location,"-")#</cfoutput>','medium','popup_form_import_stock_count');" class="tableyazi"><cf_get_lang dictionary_id='36052.Sayım Belgesi Ekle(Stok Sayımı)'></a></li></cfif>
				<cfif not listfindnocase(denied_pages,'pos.add_del_fileimports_total')><li><a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=pos.popup_add_del_fileimports_total</cfoutput>','small','acnielsen');" class="tableyazi"><cf_get_lang dictionary_id='36053.Sayım Belgelerini Birleştir'> </a></li></cfif>
				<cfif not listfindnocase(denied_pages,'pos.list_sayimlar')><li><a href="<cfoutput>#request.self#?fuseaction=pos.list_sayimlar</cfoutput>" class="tableyazi"><cf_get_lang dictionary_id='36054.Birleştirilmiş Belgeler ve Fiş Oluşturma'></a></li></cfif>
				<cfif not listfindnocase(denied_pages,'pos.list_fileimports_total_sayim')><li><a href="<cfoutput>#request.self#?fuseaction=pos.list_fileimports_total_sayim</cfoutput>" class="tableyazi"><cf_get_lang dictionary_id='36055.Sayımları Sıfırla'></a></li></cfif>
				<cfif not listfindnocase(denied_pages,'pos.list_fileimports_report')>
				<li><a href="<cfoutput>#request.self#?fuseaction=pos.list_fileimports_report</cfoutput>" class="tableyazi"><cf_get_lang dictionary_id='36157.Sayım Karşılaştırma'></a></li></cfif>
			</ul>
        </li>
    </ul>
</div>
<script src="../design/SpryAssets/left_menus/jquery.treeview.js" type="text/javascript"></script>
