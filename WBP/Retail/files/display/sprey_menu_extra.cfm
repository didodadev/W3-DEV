<style>
	.logo{float:left; width:70px; height:20px;position:absolute; margin-left:5px; margin-top:5px; background-image:url(/documents/logo.png); background-repeat:no-repeat;background-position:0px 0px;}
</style>
<cfoutput>
<cfif listgetat(session.ep.user_level, 39) and structkeyexists(fusebox.circuits,'extra')>
    <li><a href="#request.self#?fuseaction=retail.welcome"><img src="/documents/menu_gulgen.png" height="12" align="absmiddle">&nbsp;#market_name#</a>
        <ul class="fallback" style="z-index:9999 !important;">
            <li><a href="#request.self#?fuseaction=retail.welcome">#market_fullname#</a></li>
            <li><a href="#request.self#?fuseaction=retail.list_manage_products">Ürün - Fiyat Listeleri</a></li>
            <li><a href="#request.self#?fuseaction=retail.speed_manage_product_new">Ürün - Fiyat Yönetimi</a></li>
            <li><a href="#request.self#?fuseaction=retail.list_order">Siparişler</a></li>
            <li><a href="#request.self#?fuseaction=retail.pos">Yazar Kasa Pos İşlemleri</a></li>
            <li><a href="#request.self#?fuseaction=retail.consumer_list">Müşteri Kart</a></li>
            <li><a href="#request.self#?fuseaction=retail.form_add_rival_price">Toplu Rakip Fiyat</a></li>
            <li><a href="#request.self#?fuseaction=retail.pos_count_welcome">Sayım İşlemleri</a></li>
            <li><a href="#request.self#?fuseaction=retail.periodic_apps">Dönemsel Uygulamalar</a></li>
            <li><a href="#request.self#?fuseaction=retail.fon_management">Fon Yönetimi</a></li>
            <li><a href="#request.self#?fuseaction=retail.list_cheque_management">Çek Yönetimi</a></li>
            <li><a href="#request.self#?fuseaction=retail.cheque_management">Ödeme Yönetimi</a></li>
            <li><a href="#request.self#?fuseaction=retail.report">Raporlar</a></li>
            <li><a href="#request.self#?fuseaction=retail.definitions">Tanımlar</a></li>
        </ul>
    </li>
</cfif>
</cfoutput>