<div class="pagemenus_container">
    <ul class="pagemenus">
        <li><strong>Tanımlar</strong>
        	<ul>
				<cfif not listfindnocase(denied_pages,'retail.price_types')><li><a href="<cfoutput>#request.self#?fuseaction=retail.price_types</cfoutput>" class="tableyazi">Fiyat Tipleri</a></li></cfif>
                <cfif not listfindnocase(denied_pages,'retail.rival_price_types')><li><a href="<cfoutput>#request.self#?fuseaction=retail.rival_price_types</cfoutput>" class="tableyazi">Rakip Fiyat Tipleri</a></li></cfif>
				<cfif not listfindnocase(denied_pages,'retail.banknote_types')><li><a href="<cfoutput>#request.self#?fuseaction=retail.banknote_types</cfoutput>" class="tableyazi">Banknot Tipleri</a></li></cfif>
                <cfif not listfindnocase(denied_pages,'retail.card_types')><li><a href="<cfoutput>#request.self#?fuseaction=retail.card_types</cfoutput>" class="tableyazi">Kart Tipleri</a></li></cfif>
                <cfif not listfindnocase(denied_pages,'retail.extra_product_types')><li><a href="<cfoutput>#request.self#?fuseaction=retail.extra_product_types</cfoutput>" class="tableyazi">Ürün Ektra Tanımları (Kriterler)</a></li></cfif>
            	<cfif not listfindnocase(denied_pages,'retail.extra_product_types_subs')><li><a href="<cfoutput>#request.self#?fuseaction=retail.extra_product_types_subs</cfoutput>" class="tableyazi">Ürün Ektra Tanımları (Alt Tanımlar)</a></li></cfif>
				<cfif not listfindnocase(denied_pages,'retail.table_process_types')><li><a href="<cfoutput>#request.self#?fuseaction=retail.table_process_types</cfoutput>" class="tableyazi">Uygulama Tipleri</a></li></cfif>
                <cfif not listfindnocase(denied_pages,'retail.label_types')><li><a href="<cfoutput>#request.self#?fuseaction=retail.label_types</cfoutput>" class="tableyazi">Etiket Tipleri</a></li></cfif>
            </ul>
        </li>
    </ul>
    <ul class="pagemenus">
        <li><strong>Genius Tanımlar</strong>
        	<ul>
				<cfif not listfindnocase(denied_pages,'retail.genius_general')><li><a href="<cfoutput>#request.self#?fuseaction=retail.genius_general</cfoutput>" class="tableyazi">Genius Genel Tanımlar</a></li></cfif>
            </ul>
        </li>
   	</ul>
    <ul class="pagemenus">
        <li><strong>Toplu Dönemsel İşlemler</strong>
        	<ul>
				<cfif not listfindnocase(denied_pages,'retail.create_revenue_rows')><li><a href="<cfoutput>#request.self#?fuseaction=retail.create_revenue_rows</cfoutput>" class="tableyazi">Tarih Bazlı Dönemsel İşlem Çalıştırma</a></li></cfif>
               
               <cfif not listfindnocase(denied_pages,'retail.delete_invoice_relations')><li><a href="<cfoutput>#request.self#?fuseaction=retail.delete_invoice_relations</cfoutput>" class="tableyazi">Fatura - Dönemsel İşlem Bağlantılarını Sil</a></li></cfif>
            <cfif not listfindnocase(denied_pages,'retail.popup_make_process_action&table_code=&table_secret_code=')><li><a href="<cfoutput>#request.self#?fuseaction=retail.popup_make_process_action&table_code=&table_secret_code=</cfoutput>" class="tableyazi">Ciro Pirimi Tanımı</a></li></cfif>
          
            </ul>
        </li>
    </ul>
    <ul class="pagemenus">
        <li><strong>Toplu İşlemler</strong>
        	<ul>
				<cfif not listfindnocase(denied_pages,'retail.transfer_branch')><li><a href="<cfoutput>#request.self#?fuseaction=retail.transfer_branch</cfoutput>" class="tableyazi">Stok Dağıtım (Şube Transfer)</a></li></cfif>
                <cfif not listfindnocase(denied_pages,'retail.transfer_branch_list')><li><a href="<cfoutput>#request.self#?fuseaction=retail.transfer_branch_list</cfoutput>" class="tableyazi">Stok Dağıtım Listeleri</a></li></cfif>
				<cfif not listfindnocase(denied_pages,'retail.transfer_branch_all_stocks')><li><a href="<cfoutput>#request.self#?fuseaction=retail.transfer_branch_all_stocks</cfoutput>" class="tableyazi">Şube Stok Taşıma</a></li></cfif>
            </ul>
        </li>
    </ul>
    <ul class="pagemenus">
        <li><strong>Tablo Ayarları</strong>
        	<ul>
            	<cfif not listfindnocase(denied_pages,'retail.table_b2b_user')><li><a href="<cfoutput>#request.self#?fuseaction=retail.table_b2b_user</cfoutput>" class="tableyazi">Tablo Genel Ayarlar</a></li></cfif>
				<cfif not listfindnocase(denied_pages,'retail.table_spe')><li><a href="<cfoutput>#request.self#?fuseaction=retail.table_spe</cfoutput>" class="tableyazi">Tablo Kolon İsimlendirme</a></li></cfif>
                <cfif not listfindnocase(denied_pages,'retail.table_spe_user')><li><a href="<cfoutput>#request.self#?fuseaction=retail.table_spe_user</cfoutput>" class="tableyazi">Kişiye Tablo Atama</a></li></cfif>
            </ul>
        </li>
    </ul>
    <ul class="pagemenus">
        <li><strong>Gülgen Tanımlar</strong>
        	<ul>
				<cfif not listfindnocase(denied_pages,'retail.budget_codes')><li><a href="<cfoutput>#request.self#?fuseaction=retail.budget_codes</cfoutput>" class="tableyazi">Bütçe Kodları</a></li></cfif>
            	<cfif not listfindnocase(denied_pages,'retail.emptypopup_budget_codes_transfer')><li><a href="javascript://" onclick="get_budget_codes();" class="tableyazi">Bütçe Kodları Önceki Dönemden Al</a></li></cfif>
                <cfif not listfindnocase(denied_pages,'retail.emptypopup_view_transfer')><li><a href="javascript://" onclick="get_view_transfer();" class="tableyazi">Yeni Dönem View Düzenle</a></li></cfif>
            </ul>
        </li>
   	</ul>
    <ul class="pagemenus">
        <li><strong>Cari Tanımlar</strong>
        	<ul>
				<cfif not listfindnocase(denied_pages,'retail.list_payment_group')><li><a href="<cfoutput>#request.self#?fuseaction=retail.list_payment_group</cfoutput>" class="tableyazi">Ödeme Grubu</a></li></cfif>
                <cfif not listfindnocase(denied_pages,'retail.set_payment_group')><li><a href="<cfoutput>#request.self#?fuseaction=retail.set_payment_group</cfoutput>" class="tableyazi">Ödeme Grubu - Ürün Kategori Bağlama</a></li></cfif>
            </ul>
        </li>
   	</ul>
</div>
<script src="../design/SpryAssets/left_menus/jquery.treeview.js" type="text/javascript"></script>
<script>
function get_budget_codes()
{
	if(confirm('Varolan Kodları Bir Önceki Dönemden Almak İstediğinize Emin misiniz?'))
		windowopen('<cfoutput>#request.self#?fuseaction=retail.emptypopup_budget_codes_transfer</cfoutput>','small');
	else
		return false;	
}

function get_view_transfer()
{
	if(confirm('Dönem Viewleri Düzenlemek İstediğinize Emin misiniz?'))
		windowopen('<cfoutput>#request.self#?fuseaction=retail.emptypopup_view_transfer</cfoutput>','small');
	else
		return false;	
}
</script>