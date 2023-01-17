<!--- performans calismalari bolum 1 yo15032010 --->
<cfobject name="cmp_basket" type="component" component="V16.objects.cfc.basket"> 
<cfset basket_mod = cmp_basket.get_basket_mod(attributes.basket_id)>
<cfif basket_mod eq 2>
	<cfinclude template="basket2.cfm">
	<cfexit>
</cfif>
<cfscript>
	if(isDefined('session.ep.design_color'))
		{		
		if(session.ep.design_color eq 1)
			colorrow = 'F4F9FD';
		else if(session.ep.design_color eq 2)
			colorrow = 'F5F5F5';
		else if(session.ep.design_color eq 3)
			colorrow = 'FFFEEE';
		else if(session.ep.design_color eq 4)
			colorrow = 'EDEDD8';
		else if(session.ep.design_color eq 5)
			colorrow = 'F9FCFE';
		else if(session.ep.design_color eq 6)
			colorrow = 'EBF4F5';
		}
	else
		colorrow = 'F4F9FD';
		
	colorlight='FFFF33';
</cfscript>

<!--- performans calismalari bolum 1 yo15032010 --->
<cfif listfindnocase(employee_url,'#cgi.http_host#',';')>
	<cfset session_base = evaluate('session.ep')>
	<cfset module_type="e">
<cfelseif listfindnocase(partner_url,'#cgi.http_host#',';')>
	<cfset session_base = evaluate('session.pp')>
	<cfset module_type="p">
<cfelseif listfindnocase(server_url,'#cgi.http_host#',';')>
	<cfset session_base = evaluate('session.ww')>
	<cfset module_type="u">
</cfif>
<!--- 20051201 buraya gelen elemanlar alttaki gibi ayarlanir
B_TYPE=0 icin settings.form_add_bskt_temp_detail ve B_TYPE=1 icin settings.form_add_bskt_detail --->
<cfquery name="GET_BASKET" datasource="#DSN3#"><!--- 20050723 get_lang_main_cached_time : get_lang_set_main custom tag icinde set ediliyor --->
    SELECT 
        SETUP_BASKET.PURCHASE_SALES,
        SETUP_BASKET.AMOUNT_ROUND,
        SETUP_BASKET.PRICE_ROUND_NUMBER,
        SETUP_BASKET.BASKET_TOTAL_ROUND_NUMBER,
        SETUP_BASKET.BASKET_RATE_ROUND_NUMBER,
        SETUP_BASKET.USE_PROJECT_DISCOUNT,
		SETUP_BASKET.OTV_CALC_TYPE,
		#DSN#.#dsn#.Get_Dynamic_Language(BASKET_ROW_ID,'#session.ep.language#','SETUP_BASKET_ROWS','TITLE_NAME',NULL,NULL,ISNULL(SLT.ITEM_#UCase(session.ep.language)#, TITLE_NAME)) AS TITLE_NAME,
        SETUP_BASKET_ROWS.BASKET_ID, 
        SETUP_BASKET_ROWS.LINE_ORDER_NO, 
        SETUP_BASKET_ROWS.IS_SELECTED, 
        SETUP_BASKET_ROWS.TITLE, 
        SETUP_BASKET_ROWS.B_TYPE, 
        SETUP_BASKET_ROWS.GENISLIK, 
		ISNULL(SETUP_BASKET_ROWS.IS_READONLY,0) AS IS_READONLY,
		ISNULL(SETUP_BASKET_ROWS.IS_REQUIRED,0) AS IS_REQUIRED,
        SETUP_BASKET_ROWS.BASKET_ROW_ID,
        SETUP_BASKET.LINE_NUMBER,
		SETUP_BASKET_ROWS.IS_MOBILE
    FROM 
        SETUP_BASKET,
        SETUP_BASKET_ROWS LEFT JOIN #DSN#.SETUP_LANGUAGE_TR AS SLT ON SLT.DICTIONARY_ID = SETUP_BASKET_ROWS.LANGUAGE_ID 
    WHERE 
        SETUP_BASKET_ROWS.BASKET_ID = SETUP_BASKET.BASKET_ID AND
        SETUP_BASKET_ROWS.B_TYPE = SETUP_BASKET.B_TYPE AND
		<cfif isdefined("attributes.is_view") and attributes.is_view>
			SETUP_BASKET_ROWS.B_TYPE = 0 AND
		<cfelse>
			SETUP_BASKET_ROWS.B_TYPE = 1 AND
		</cfif>
   		SETUP_BASKET.BASKET_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.basket_id#">
    ORDER BY
        SETUP_BASKET_ROWS.LINE_ORDER_NO ASC
</cfquery>
<cfif get_basket.recordcount>
	<cfset extra_basket_hidden_list_=''>
	<cfif session.ep.price_display_valid eq 1><!--- kullanıcı yetkilerinde "Basketlerde Fiyat ve Toplamı Görüntülemesin" seçilmişse fiyat ve ilgili alanlar basket sablonunda secilmis olsada hidden olarak gelir --->
		<cfset extra_basket_hidden_list_ ="Tax,OTV,tax_price,price_other,price_net,tax_price,price_net_doviz,price_total,other_money,List_price,Price,iskonto_tutar,ek_tutar,ek_tutar_other_total,disc_ount,disc_ount2_,disc_ount3_,disc_ount4_,disc_ount5_,disc_ount6_,disc_ount7_,disc_ount8_,disc_ount9_,disc_ount10_,row_total,row_taxtotal,row_nettotal,row_otvtotal,row_lasttotal,other_money_value,other_money_gross_total,marj,genel_indirim_">
	</cfif>
	<cfif session.ep.cost_display_valid eq 1> <!--- kullanıcı yetkilerinde "Basketlerde Maliyeti Görüntülemesin" secilmisse --->
		<cfset extra_basket_hidden_list_ =listappend(extra_basket_hidden_list_,'net_maliyet,extra_cost',',')>
	</cfif>
	<cfquery name="get_basket_displays" dbtype="query">
		SELECT 
			TITLE,TITLE_NAME,GENISLIK,PURCHASE_SALES,IS_READONLY,IS_REQUIRED
		FROM 
			get_basket 
		WHERE 
			IS_SELECTED = 1
			<cfif listlen(extra_basket_hidden_list_)>
			AND TITLE NOT IN (#listqualify(extra_basket_hidden_list_,"'")#)
			</cfif>
		ORDER BY 
			LINE_ORDER_NO ASC
	</cfquery>
	<cfquery name="get_basket_hiddens" dbtype="query">
		SELECT 
			TITLE,TITLE_NAME,GENISLIK,PURCHASE_SALES ,IS_READONLY,IS_REQUIRED
		FROM 
			get_basket 
		WHERE 
			IS_SELECTED = 0
			<cfif listlen(extra_basket_hidden_list_)>
			OR TITLE IN (#listqualify(extra_basket_hidden_list_,"'")#)
			</cfif>
	</cfquery>
	<!--- 1305.Acik, 1948.Tedarik, 1949.Kapatıldı, 1950.Kısmi Üretim, 44.Üretim, 1349.Sevk, 1951.Eksik Teslimat, 1952.Fazla Teslimat, 1094.İptal, 1211.Kapatıldı(Manuel) --->
	<cfset order_currency_list="#getLang('main',1305)#,#getLang('main',1948)#,#getLang('main',1949)#,#getLang('main',1950)#,#getLang('main',44)#,#getLang('main',1349)#,#getLang('main',1951)#,#getLang('main',1952)#,#getLang('main',1094)#,#getLang('main',1211)#">
	<!--- 1953.Rezerve, 1954.Kısmi Rezerve, 1955.Rezerve Degil, 1956.Rezerve Kapatıldı --->
	<cfset reserve_type_list = "#getLang('main',1953)#,#getLang('main',1954)#,#getLang('main',1955)#,#getLang('main',1956)#">
	<cfscript>
		//basket sablonundan set ediliyor.
		hidden_list = valueList(get_basket_hiddens.title);
		display_list = valueList(get_basket_displays.title);
		display_field_name_list = valueList(get_basket_displays.title_name);
		display_field_width_list = valueList(get_basket_displays.genislik);
		display_field_readonly_list = valueList(get_basket_displays.is_readonly);
		display_field_required_list = valueList(get_basket_displays.is_required); 
		if(session.ep.PRICE_VALID eq 1) //kullanıcı yetkilerinde "Basketlerde Fiyat Değişimi Yapmasın" seçilmişse readonly gelecek alanların listesi
			basket_read_only_price_list ="tax,OTV,tax_price,price,list_price_discount,set_row_duedate,price_other,ek_tutar,ek_tutar_price,ek_tutar_cost,ek_tutar_marj,ek_tutar_other_total,row_total,row_taxtotal,row_otvtotal,row_lasttotal,other_money_value,extra_cost_rate,row_cost_total,marj";
		else
			basket_read_only_price_list ="";
		
		if(session.ep.DISCOUNT_VALID eq 1) //kullanıcı yetkilerinde "Basketlerde İskonto Değişimi Yapmasın " seçilmişse readonly gelecek alanların listesi
			basket_read_only_discount_list ="iskonto_tutar,disc_ount,disc_ount2_,disc_ount3_,disc_ount4_,disc_ount5_,disc_ount6_,disc_ount7_,disc_ount8_,disc_ount9_,disc_ount10_,genel_indirim_";
		else
			basket_read_only_discount_list ="";

		if(session.ep.duedate_valid eq 1)
			basket_read_only_duedate_list = "duedate,set_row_duedate";
		else
			basket_read_only_duedate_list = "";
				
		sale_product = get_basket_displays.purchase_sales;
		basket_info_list ='-1;Seçiniz'; //basket ek bilgileri ayarlar modulunde tanımlanıyor OZDEN20070815>
		use_basket_project_discount_=get_basket.USE_PROJECT_DISCOUNT;
		amount_round=get_basket.amount_round;
		price_round_number = get_basket.price_round_number; //basket satırlarındaki fiyat alanlarının virgülden sonraki basamak sayısını gosterir
		if(len(get_basket.basket_total_round_number))
			basket_total_round_number = get_basket.basket_total_round_number; //basket toplamdaki alanlarının virgülden sonraki basamak sayısını gosterir
		else
			basket_total_round_number = session.ep.our_company_info.rate_round_num; //basket sablonunda tanımlı degilse şirket akış parametrelerindeki yuvarlama degerini alır
		if(len(get_basket.basket_rate_round_number))
			basket_rate_round_number = get_basket.basket_rate_round_number; //basket kur bilgisinin virgülden sonraki basamak sayısını gosterir
		else
			basket_rate_round_number = session.ep.our_company_info.rate_round_num; //basket sablonunda tanımlı degilse şirket akış parametrelerindeki yuvarlama degerini alır
			
		if(not len(get_basket.OTV_CALC_TYPE))
			otv_calc_type_ = 0;
		else
			otv_calc_type_ = 1;

		basket_price_cat_id_list_='';
		basket_price_cat_name_list_='';
		if(listfind(display_list,'List_price') or listfind(display_list,'list_price'))
		{	
			get_basket_price_cat_list = cfquery(SQLString:'SELECT PRICE_CAT,PRICE_CATID FROM PRICE_CAT ORDER BY PRICE_CATID',Datasource:dsn3);
			if(get_basket_price_cat_list.recordcount)
			{
				basket_price_cat_id_list_=valuelist(get_basket_price_cat_list.PRICE_CATID);
				basket_price_cat_name_list_=valuelist(get_basket_price_cat_list.PRICE_CAT,'§'); //§ :alt789
			}
		}		
	</cfscript>
	<cfif ListLen(display_list, ",") neq ListLen(display_field_name_list, ",")>
		<p><b><cf_get_lang dictionary_id='34277.Sepet Başlık İsimleri Eksik (Lütfen Sistem Yöneticinize Başvurun)'></b></p>
		<cfoutput>#display_list#<br/>#display_field_name_list#</cfoutput>
		<cfexit method="exittemplate">
	</cfif>
	<cfscript>if (fusebox.circuit is 'store') display_list = listAppend(display_list, "is_store"); /* NEDEN EKLENDİ???*/</cfscript>
	<script type="text/javascript">
		generaltaxArray= new Array(0);
		generaltaxArrayTotal= new Array(0);
		generaltaxArrayMatrah = new Array(0);
		generalotvArray= new Array(0);
		generalotvArrayTotal= new Array(0);
		for (var r_ind=0; r_ind < rate2Array.length; r_ind++) //basket kurları yuvarlama parametresine gore wrk_rounddan geciriliyor
		{
			rate1Array[r_ind] = wrk_round(rate1Array[r_ind],<cfoutput>#basket_rate_round_number#</cfoutput>);
			rate2Array[r_ind] = wrk_round(rate2Array[r_ind],<cfoutput>#basket_rate_round_number#</cfoutput>);
		}
		basket_price_cat_id_list_ ='<cfoutput>#basket_price_cat_id_list_#</cfoutput>';
		basket_price_cat_name_list_ ='<cfoutput>#basket_price_cat_name_list_#</cfoutput>';
	</script>
	<cfif isdefined('attributes.basket_related_action')>
		<cfinclude template="../query/get_basket_from_related_action.cfm">
	<cfelseif not isdefined("attributes.form_add") or (isdefined("attributes.convert_products_id") and len(attributes.convert_products_id) and isdefined("attributes.convert_stocks_id") and len(attributes.convert_stocks_id)) or isdefined("internald_row_id_list") or (isdefined("attributes.id") and len(attributes.id)) or isdefined("attributes.st_id")>
		<cfif isdefined("attributes.basket_sub_id")><!--- alt sepet id erk 20040227 --->
			<cfinclude template="../query/get_basket_sub_contents.cfm">
		<cfelse>
			<cfinclude template="../query/get_basket_contents.cfm">
		</cfif>
	<cfelse>
		<cfscript>
			sepet.satir = ArrayNew(2);
			sepet.kdv_array = ArrayNew(2);
			sepet.otv_array = ArrayNew(2);
			sepet.total = 0;
			sepet.total_other_money = 0;
			sepet.total_other_money_tax = 0;
			sepet.toplam_indirim = 0;
			sepet.total_tax = 0;
			sepet.total_otv = 0;
			sepet.net_total = 0;
			sepet.genel_indirim = 0;
			sepet.stopaj = 0;
			sepet.stopaj_yuzde = 0;
			sepet.stopaj_rate_id = 0;
		</cfscript>
	</cfif>
	<div basket-content>
		<cfif isdefined("attributes.is_view") and attributes.is_view>
			<cfinclude template="dsp_basket_view_js.cfm"><!--- print display basket --->
		<cfelse>
			<!---
			<cfinclude template="dsp_basket_js.cfm"><!--- input lu basket --->
			<cfinclude template="dsp_basket_js_scripts_2.cfm"><!--- basket add, upd fonksiyonlari ---> <!--- once dsp_basket_js_scripts include ediliyordu, sıralamayı degistirdim, sorun olursa geri alınacak --->
			<cfinclude template="dsp_basket_js_scripts.cfm"><!--- basket javascriptleri --->
			--->
			<cfif (session.ep.price_display_valid eq 1) or ((not ListFindNoCase(display_list, "price_total")) and (not listFindNoCase(display_list, "is_amount_total")))>
				<cfset total_table_display_ = "none">
			<cfelse>
				<cfset total_table_display_ = "">
			</cfif>
			<cfinclude template="basketjQuery.cfm">
			<!--- Emin Kaldirilacak. --->
			<!---
			<cfif listFindNoCase('4,6',attributes.basket_id,',') and fusebox.is_special><!--- Düzenleme şimdilik kontrol amaçlı olarak sadece sipariş ekleme güncelleme de yapıldı. Koşul zamanla kaldırılacak. EY20150713--->
				<cfinclude template="basketjQuery.cfm">
			<cfelse>
				<cfinclude template="dsp_basket_js.cfm"><!--- input lu basket --->
				<cfinclude template="dsp_basket_js_scripts_2.cfm"><!--- basket add, upd fonksiyonlari ---> <!--- once dsp_basket_js_scripts include ediliyordu, sıralamayı degistirdim, sorun olursa geri alınacak --->
				<cfinclude template="dsp_basket_js_scripts.cfm"><!--- basket javascriptleri --->
			</cfif>
			--->
		</cfif>
	</div>
<cfelse>
	<cfparam name="sec_id" default="0"> 
	<cfparam name="attributes.sec_id" default="0">
	<cfscript>
	switch (attributes.fuseaction)
	{
		case "invoice.form_add_bill_purchase" : sec_id = 1; int_fnc_action_id=1; break;
		case "invoice.detail_invoice_purchase" : sec_id = 1;  int_fnc_action_id=1; break;
		case "invoice.form_add_bill" : sec_id = 2;  int_fnc_action_id=1; break;
		case "invoice.detail_invoice_sale" : sec_id = 2; int_fnc_action_id=1; break;			
		case "sales.form_add_offer" : sec_id = 3; int_fnc_action_id=4; break;
		case "sales.detail_offer_tv" : sec_id = 3; int_fnc_action_id=4; break;
		case "sales.form_copy_offer" : sec_id = 3; int_fnc_action_id=4; break;
		case "sales.form_add_opp_offer" : sec_id = 3; int_fnc_action_id=4; break;
		case "sales.detail_offer_pta" : sec_id = 3; int_fnc_action_id=4; break;
		case "sales.popup_upd_offer_product_page" : sec_id = 3; int_fnc_action_id=4; break;
		case "sales.form_add_order" : sec_id = 4; int_fnc_action_id=3; break;
		case "sales.detail_order_sa" : sec_id = 4; int_fnc_action_id=3; break;
		case "sales.form_copy_order" : sec_id = 4; int_fnc_action_id=3; break;
		case "sales.detail_order_psv" : sec_id = 4; int_fnc_action_id=3; break;
		case "purchase.form_add_offer" : sec_id = 5; int_fnc_action_id=4; break;
		case "purchase.detail_offer_ta" : sec_id = 5; int_fnc_action_id=4; break;
		case "purchase.form_copy_offer" : sec_id = 5; int_fnc_action_id=4; break;
		case "purchase.detail_offer_ptv" : sec_id = 5; int_fnc_action_id=4; break;
		case "purchase.form_add_order" : sec_id = 6; int_fnc_action_id=3; break;
		case "purchase.add_product_all_order" : sec_id = 6; int_fnc_action_id=3; break;				
		case "purchase.detail_order" : sec_id = 6; int_fnc_action_id=3; break;
		case "purchase.form_copy_order" : sec_id = 6; int_fnc_action_id=3; break;
		case "purchase.form_add_to_offer_order" : sec_id = 6; int_fnc_action_id=3; break;
		case "purchase.upd_internaldemand" : sec_id = 7; int_fnc_action_id=7; break;
		//case "purchase.upd_purchasedemand" : sec_id=7;int_fnc_action_id=7;break;
		case "correspondence.add_internaldemand" : sec_id = 8; int_fnc_action_id=7; break;
		case "correspondence.upd_internaldemand" : sec_id = 8; int_fnc_action_id=7; break;
		case "service.upd_service" : sec_id = 9; int_fnc_action_id=5; break;
		case "stock.form_add_sale" : sec_id = 10; int_fnc_action_id=2; break;
		case "stock.form_upd_sale" : sec_id = 10; int_fnc_action_id=2; break;
		case "stock.form_add_purchase" : sec_id = 11; int_fnc_action_id=2; break;
		case "stock.form_upd_purchase" : sec_id = 11; int_fnc_action_id=2; break;
		case "stock.form_add_fis" : sec_id = 12; int_fnc_action_id=6; break;
		case "stock.form_upd_fis" : sec_id = 12; int_fnc_action_id=6; break;
		case "stock.form_add_ship_open_fis" : sec_id = 13; int_fnc_action_id=6; break;
		case "stock.form_upd_open_fis" : sec_id = 13; int_fnc_action_id=6; break;
		case "stock.form_add_order_sale" : sec_id = 14; int_fnc_action_id=2; break;
		case "stock.detail_order" : sec_id = 14; int_fnc_action_id=3; break;
		case "stock.form_add_order_purchase" : sec_id = 15; int_fnc_action_id=2; break;
		case "stock.detail_orderp" : sec_id = 15; int_fnc_action_id=3; break;
		case "product.form_add_catalog" : sec_id = 16; int_fnc_action_id=8; break;
		case "product.form_upd_catalog" : sec_id = 16; int_fnc_action_id=8; break;
		case "store.product_accept" : sec_id = 17;  int_fnc_action_id=2; break;
		case "store.form_add_bill" : sec_id = 18;  int_fnc_action_id=1; break;
		case "store.form_add_fis" : sec_id = 19;  int_fnc_action_id=6; break;
		case "store.form_add_bill_purchase" : sec_id = 20; int_fnc_action_id=1; break;
		case "store.form_add_sale" : sec_id = 21; int_fnc_action_id=2; break;
		case "call.upd_service" : sec_id = 23;  int_fnc_action_id=5; break;
		case "offer.temp_offer_tv" : sec_id = 24; int_fnc_action_id=4; break;
		case "offer.form_add_offer_t" : sec_id = 24; int_fnc_action_id=4; break;	
		case "offer.detail_offer_t" : sec_id = 24; int_fnc_action_id=4; break;
		case "offer.form_copy_offer_t" : sec_id = 24; int_fnc_action_id=4; break;
		case "offer.form_add_offer_g" : sec_id = 24; int_fnc_action_id=4; break;
		case "offer.detail_offer_g" : sec_id = 24; int_fnc_action_id=4; break;
		case "offer.form_copy_offer_g" : sec_id = 24; int_fnc_action_id=4; break;
		case "offer.detail_offer_ta" : sec_id = 24; int_fnc_action_id=4; break;
		case "offer.form_copy_offer_ta" : sec_id = 24 ; int_fnc_action_id=4; break;
		case "offer.form_add_offer_order_g" : sec_id = 24; int_fnc_action_id=4; break;
		case "offer.detail_offer_tv" : sec_id = 24; int_fnc_action_id=4; break;
		case "service.popup_detail_similar_service": sec_id = 30; int_fnc_action_id=4; break;
		case "stock.add_ship_dispatch": sec_id = 31; int_fnc_action_id=4; break;
		case "stock.upd_ship_dispatch": sec_id = 31; int_fnc_action_id=4; break;
		case "store.add_ship_dispatch": sec_id = 32; int_fnc_action_id=4; break;
		case "store.upd_ship_dispatch": sec_id = 32; int_fnc_action_id=4; break;
		case "invoice.form_add_bill_producer": sec_id = 33; int_fnc_action_id=4; break;
		case "invoice.form_upd_bill_producer": sec_id = 33; int_fnc_action_id=4; break;
		case "stock.add_dispatch_internaldemand": sec_id = 44;  break;
		case "stock.upd_dispatch_internaldemand": sec_id = 44; break;
		case "store.add_dispatch_internaldemand": sec_id = 45;  break;
		case "store.upd_dispatch_internaldemand": sec_id = 45; break;
		case "sales.add_subscription_contract": sec_id = 46; break;
		case "sales.upd_subscription_contract": sec_id = 46; break;
		default : sec_id = 0;
	}
	</cfscript>
	<p class="label">
	<cfif isdefined("attributes.is_view") and attributes.is_view and module_type eq "e"><!---B_TYPE=0 icin settings.form_add_bskt_temp_detail--->
<!---		<a class="tableyazi" href="<cfoutput>#request.self#</cfoutput>?fuseaction=settings.form_add_bskt_temp_detail&sec_id=<cfoutput>#sec_id#</cfoutput>">--->
        <a class="tableyazi" onclick="myPopup('formPanel')">
			<cf_get_lang dictionary_id='57481.Lütfen Basket Şablon İçerik Düzenlemesi Yapınız'>
		</a>
	<cfelseif module_type eq "e"><!--- wrk_not:settings yetkisi eklenmeli and isDefined('session.ep') and listgetat(session.ep.user_level,7) --->
<!---		<a class="tableyazi" href="<cfoutput>#request.self#</cfoutput>?fuseaction=settings.form_add_bskt_detail&sec_id=<cfoutput>#sec_id#</cfoutput>">--->
		<a class="tableyazi" onclick="myPopup('formPanel')">
			<cf_get_lang dictionary_id='57481.Lütfen Basket Şablon İçerik Düzenlemesi Yapınız'>
		</a>
	<cfelse>
			<cf_get_lang dictionary_id='57481.Lütfen Basket Şablon İçerik Düzenlemesi Yapınız'>
	</cfif>
</cfif>