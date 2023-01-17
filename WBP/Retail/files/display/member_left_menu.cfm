<cfoutput>
<ul id="tree">
  	<li><strong>Gülen Kart İşlemleri</strong>
    	<ul>
                <li><a href="#request.self#?fuseaction=retail.consumer_list">Müşteri Kartları</a></li>
                <li><a href="#request.self#?fuseaction=retail.form_add_cards">Kart Tanımla</a></li>
                <li><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=retail.popup_add_bonus','medium');">Puan Ekle / Çıkar</a></li>
                <li><a href="#request.self#?fuseaction=retail.form_add_multi_cards">Toplu Katsayı Tanımla</a></li>
                <li><a href="#request.self#?fuseaction=retail.card_multi_list">Toplu Kart İşlemleri</a></li>
                <li><a href="#request.self#?fuseaction=retail.card_multi_add">Toplu Kart İşlemi Ekle</a></li>
                <li><a href="#request.self#?fuseaction=report.detayli_uye_analizi_raporu&search_type=2&list_type=3,4,27,44,33,18">Detaylı Üye Analiz Raporu</a></li>
         </ul>
    </li>
</cfoutput>
