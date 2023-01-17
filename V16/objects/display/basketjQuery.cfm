<!--- Açıklamalar ---> 
<!--- basket_read_only_discount_list : Bu parametre kişinin iskontoları değiştiremesin yetkisini kontrol ediyor. Değiştiremeyeceği alanlar iskonto_tutar, iskonto1,iskonto2...,iskonto10,genel_indirim --->
<!--- basket_read_only_discount_list : Bu parametre kişinin fiyatları değiştiremesin yetkisini kontrol ediyor. Değiştiremeyeceği alanlar tax,OTV,tax_price,price,list_price_discount,set_row_duedate,price_other,ek_tutar,ek_tutar_price,ek_tutar_cost,ek_tutar_marj,ek_tutar_other_total,row_total,row_taxtotal,row_otvtotal,row_lasttotal,other_money_value,extra_cost_rate,row_cost_total,marj --->
<!--- readOnlyInputList :  Bu parametre her halükarda readonly gelen alanlar için eklenmiştir. Readonly alanlar stock_code,barcod,special_code,unit,list_price,price_net,price_net_doviz,row_nettotal,other_money_gross_total,row_cost_total --->
<!---if(!$("#tblBasket tr[basketItem]").eq($(e.target).closest("tr[basketItem]").attr("itemIndex")).find("#indirim3").attr('readonly'))--->
<!---is_basket_readonly : siparişlerdeki kapatılmış ve fazla teslimat satırlarının readonly geldigi bolum is_basket_readonly parametresi sipariş için üretim emri set edilmişse, sipariş detay sayfasında tanımlanıyor. Bu alan herhangi bir input'a atanmadığı sayfadaki query buraya da eklenmiştir.--->
<!--- <link rel="stylesheet" href="../../css/basket.css" /> --->
<cfif fusebox.circuit eq "invoice" or listfind("1,2,3,4,5,6,10,14,18,20,21,33,38,42,43,46,51,52",attributes.basket_id,",")>
	<!---sepet.satir altı indirimde kullanılıyor,dikkat : bu satir dsp_basket_total_js.cfm de genel_indirim_ inputu ile iliskili 20040121--->
	<input type="hidden" id="genel_indirim" name="genel_indirim" value="<cfif StructKeyExists(sepet,'genel_indirim')><cfoutput>#sepet.genel_indirim#</cfoutput></cfif>">
  </cfif>
  <cfif isdefined("attributes.order_id") and len(attributes.order_id)>
	  <cfquery name="KONTROL" datasource="#dsn3#">
		  SELECT ORDER_ID FROM PRODUCTION_ORDERS_ROW WHERE ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.order_id#">
	  </cfquery>
	  <cfset is_basket_readonly = 1>
  <cfelse>
	  <cfset is_basket_readonly = 0>
  </cfif>
  
  <!---<script type="text/javascript" src="../../JS/js_functions.js"></script>--->
  <script type="text/javascript" src="../../JS/jquery.json-2.4.min.js"></script>
  <script type="text/javascript" src="../../JS/basketFixedHeader.js"></script>
  
  <cfscript>
	  str_money_bskt_found = true;
  </cfscript>
  <cfset fl_total_2 = 1>
  <cfset fl_total = 1>
  
  <!--- silinecek --->
  <!---<cfset attributes.basket_id = 2>--->
  
  <!---<cfinclude template="../../objects/query/get_sale_det.cfm">--->
  
  <cfif not isdefined("session_basket_kur_ekle")>
	  <cfinclude template="../../objects/functions/get_basket_money_js.cfm">  <!---rate1Array, rate2Array bu fonksiyonda tanımlanıyor.--->
	  <cfscript>session_basket_kur_ekle(action_id=attributes.iid,table_type_id:1,process_type:1);</cfscript>
  </cfif>
  <cfif not isdefined("default_basket_money_")>
	  <cfif IsQuery(get_standart_process_money) and len(get_standart_process_money.STANDART_PROCESS_MONEY)>
		  <cfset default_basket_money_= get_standart_process_money.STANDART_PROCESS_MONEY>
	  <cfelseif len(session_base.money2)>
		  <cfset default_basket_money_=session_base.money2>
	  <cfelse>
		  <cfset default_basket_money_=session_base.money>
	  </cfif>
  </cfif>
  
  <!---<cfinclude template="get_basket_1.cfm">--->
  <!---<cfinclude template="../../objects/query/get_basket_1.cfm">--->
  <!--- silinecek --->
  
  <!--- basket.cfm dosyası burada include edilecek. Parametreler buradan alınacak. --->
  <!--- Coldfusion tarafından çağrılan TlFormat, AmountFormat gibi fonksiyonlar JS ile yapılacağı için bu fonksiyonlar JS'e dönüştürülecek. --->
  <!--- Başlık kısmından tetiklenen satırlardaki iskonto hesabı için input değerleri değiştirilip event tetiklenir --->
  <!--- Numeric alanlardaki sayı formatlama fonksiyonu tek bir fonksiyon haline getirilip ilgili inputlardan fonksiyon tetiklenecek. --->
  <!--- data. ile yazılanlar query'den dönen değerlerdir. Büyük harfle yazılır. find(#amount)  input name'idir. --->
  <!--- sepet.satir = window.basket.items --->
  <!--- Dağılım'da asortileri kontrol et --->
  <!--- control_prod_discount fonksiyonu için Sayın ile görüş. Birlikte kontrol et. --->
  <!---//Niye yazılmış anlamadım. kısımları kaldırılabilir.--->
  <!--- // AAO. Anladıysam arap olayım. Bir bilene danışılıp ne işi yaradığı öğrenilecek. --->
  <!--- // ColdFusion kodlarının JS dönüşümleri . Almış oldukları parametreler aynıdır.--->
  <!--- // Post edilirken ekrandaki değerler array'de güncellenecek--->
  <!--- check_reserved_rows kontrol edilecek. Sipariş ekranında --->
  <!--- control_einvoice_paper kontrol edilecek. paper ID'li input piyasada görünmüyor --->
  <!--- check_member_project_risk kontrol edilecek. Üye proje risk bilgisi kontrolü --->
  <!--- check_project_discount_conditions kontrol edilecek. Üye proje indirim bilgisi kontrolü --->
  <!--- check_branch_discount_rates kontrol edilecek. --->
  <!--- basket_taksit_hesapla kontrol edilecek. --->
  <!--- Silinecek olan fonksiyonlar // Silinecek etiketiyle aranabilir. --->
  <!--- del_rows ve del_row fonksiyonları Zafer'le beraber düzeltilecek. --->
  <!--- Fiyat Tarihçe popup'ı düzeltilecek. JS hatası veriyor. --->
  
  <cfset extra_basket_hidden_list_=''>
  <cfif session.ep.price_display_valid eq 1><!--- kullanıcı yetkilerinde "Basketlerde Fiyat ve Toplamı Görüntülemesin" seçilmişse fiyat ve ilgili alanlar basket sablonunda secilmis olsada hidden olarak gelir --->
	  <cfset extra_basket_hidden_list_ ="Tax,OTV,tax_price,price_other,price_net,tax_price,price_net_doviz,price_total,other_money,List_price,Price,iskonto_tutar,ek_tutar,ek_tutar_other_total,disc_ount,disc_ount2_,disc_ount3_,disc_ount4_,disc_ount5_,disc_ount6_,disc_ount7_,disc_ount8_,disc_ount9_,disc_ount10_,row_total,row_taxtotal,row_nettotal,row_otvtotal,row_lasttotal,other_money_value,other_money_gross_total,marj,genel_indirim_,otv_type,otv_discount">
  </cfif>
  <cfif session.ep.cost_display_valid eq 1> <!--- kullanıcı yetkilerinde "Basketlerde Maliyeti Görüntülemesin" secilmisse --->
	  <cfset extra_basket_hidden_list_ =listappend(extra_basket_hidden_list_,'net_maliyet,extra_cost',',')>
  </cfif>
  
  
  <cfset input_id_list = valuelist(GET_BASKET.TITLE)>
  <cfset input_change_name_list_old = "PRODUCT_NAME2,AMOUNT2,UNIT2,SPEC,DISC_OUNT,DISC_OUNT2_,DISC_OUNT3_,DISC_OUNT4_,DISC_OUNT5_,DISC_OUNT6_,DISC_OUNT7_,DISC_OUNT8_,DISC_OUNT9_,DISC_OUNT10_,DELIVER_DEPT,SHELF_NUMBER,SHELF_NUMBER_2,BASKET_PROJECT,Duedate,basket_work">
  <cfset input_change_name_list_new = "product_name_other,amount_other,unit_other,spect_name,indirim1,indirim2,indirim3,indirim4,indirim5,indirim6,indirim7,indirim8,indirim9,indirim10,basket_row_departman,shelf_number_txt,to_shelf_number_txt,row_project_name,duedate,row_work_name">
  <cfset input_name_list = valuelist(GET_BASKET.TITLE_NAME)>
  <cfset DISPLAY_FIELD_WIDTH_LIST = valuelist(GET_BASKET.GENISLIK)>
  
  <cfset input_func_list = ''>
  <cfset select_func_list = ''>
  
  <cfset basket_info_list = '0;#getLang('main',322)#'>
  <cfquery name="basket_info_" datasource="#dsn3#">
	  SELECT BASKET_INFO_TYPE_ID,BASKET_INFO_TYPE FROM SETUP_BASKET_INFO_TYPES WHERE OPTION_NUMBER IN (1,3) AND ','+BASKET_ID+',' LIKE ',%#attributes.basket_id#%,' ORDER BY BASKET_INFO_TYPE
  </cfquery>
  <cfloop query="basket_info_">
	  <cfset basket_info_list = listappend(basket_info_list,"#BASKET_INFO_TYPE_ID#;#BASKET_INFO_TYPE#")>
  </cfloop>
  
  <cfquery name="getSelectInfoExtra" datasource="#dsn3#">
	  SELECT BASKET_INFO_TYPE_ID,BASKET_INFO_TYPE FROM SETUP_BASKET_INFO_TYPES WHERE OPTION_NUMBER IN (2,3) AND ','+BASKET_ID+',' LIKE ',%#attributes.basket_id#%,' ORDER BY BASKET_INFO_TYPE
  </cfquery>
  <cfset select_info_extra_list = '0;#getLang('main',322)#'>
  <cfloop query="getSelectInfoExtra">
	  <cfset select_info_extra_list = listappend(select_info_extra_list,"#BASKET_INFO_TYPE_ID#;#BASKET_INFO_TYPE#")>
  </cfloop>
  
  <!--- Aktivite Tipi --->
  <cfset getActivity = createobject("component","workdata.get_activity_types").getActivity()>
  <!--- Aktivite Tipi --->
  
  <!--- İhracat E-Fatura --->
  <cfquery name="delivery_condition" datasource="#dsn#">
	  SELECT * FROM DELIVERY_CONDITION
  </cfquery>
  <cfquery name="container_type" datasource="#dsn#">
	  SELECT * FROM CONTAINER_TYPE
  </cfquery>
  <cfquery name="delivery_type" datasource="#dsn#">
	  SELECT * FROM DELIVERY_TYPE
  </cfquery>
  
  <cffile action="read" file="#index_folder#admin_tools#dir_seperator#xml#dir_seperator#reason_codes.xml" variable="xmldosyam" charset = "UTF-8">
  <cfset dosyam = XmlParse(xmldosyam)>
  <cfset xml_dizi = dosyam.REASON_CODES.XmlChildren>
  <cfset d_boyut = ArrayLen(xml_dizi)>
  <cfset reason_code_list = "#getLang('main',322)#">
  <cfloop index="abc" from="1" to="#d_boyut#">    	
	  <cfset reason_code_list = listappend(reason_code_list,'#dosyam.REASON_CODES.REASONS[abc].REASONS_CODE.XmlText#--#dosyam.REASON_CODES.REASONS[abc].REASONS_NAME.XmlText#','*')>
  </cfloop>
  <cfloop index="aaa" from="1" to="#arrayLen(sepet.satir)#">
	  <cfset sepet.satir[aaa].tax = sepet.satir[aaa].TAX_PERCENT>
	  <!--- İkinci Birim selectbox'ini doldurmak icin basket array'ine unit2_extra alanı ekler. --->
	  <cfset sepet.satir[aaa].unit2_extra = ''>
	  <cfset attributes.pid = sepet.satir[aaa].product_id>
	  <cfinclude template="../../objects/query/get_product_unit.cfm">
	  <cfloop query="get_product_unit">
		  <cfif StructKeyExists(sepet.satir[aaa],'unit_other') and len(sepet.satir[aaa].unit_other) and sepet.satir[aaa].unit_other eq add_unit>
			  <cfset selected_ = 'selected="selected"'>
		  <cfelse>
			  <cfset selected_ = ''>
		  </cfif>
		  <cfset sepet.satir[aaa].unit2_extra = sepet.satir[aaa].unit2_extra & "<option value='#TR_UNIT#' #selected_#>#add_unit#</option>">
	  </cfloop>
	  <cfif StructKeyExists(sepet.satir[aaa],'promosyon_yuzde')>
		  <cfset sepet.satir[aaa].promosyon_yuzde = sepet.satir[aaa].promosyon_yuzde>
	  <cfelse>
		  <cfset sepet.satir[aaa].promosyon_yuzde = 0>
	  </cfif>
	  <cfif StructKeyExists(sepet.satir[aaa],'ISKONTO_TUTAR')>
		  <cfset sepet.satir[aaa].ISKONTO_TUTAR = sepet.satir[aaa].ISKONTO_TUTAR>
	  <cfelse>
		  <cfset sepet.satir[aaa].ISKONTO_TUTAR = 0>
	  </cfif>	
  
	  <cfif StructKeyExists(sepet.satir[aaa],'manufact_code')>
		  <cfset thisIsSuchAHorribleHack = "(!@$!@$)">
		  <cfset sepet.satir[aaa].manufact_code = thisIsSuchAHorribleHack & sepet.satir[aaa].manufact_code>
	  </cfif>	
	  <cfif StructKeyExists(sepet.satir[aaa],'special_code')>
		  <cfset thisIsSuchAHorribleHack = "(!@$!@$)">
		  <cfset sepet.satir[aaa].special_code = thisIsSuchAHorribleHack & sepet.satir[aaa].special_code>
	  </cfif>
	  <!--- Dövizler selectbox'ini doldurmak icin basket array'ine other_money_options alanı ekler. --->
	  <cfset sepet.satir[aaa].other_money_options = ''>
	  <cfoutput query="get_money_bskt">
		  <cfif sepet.satir[aaa].other_money eq get_money_bskt.money_type>
			  <cfset selected_ = 'selected="selected"'>
			  <cfset sepet.satir[aaa].fl_total_2 = get_money_bskt.rate1>
			  <cfset sepet.satir[aaa].fl_total = get_money_bskt.rate2>
			  <cfset sepet.satir[aaa].rate1 = get_money_bskt.rate1>
			  <cfset sepet.satir[aaa].rate2 = get_money_bskt.rate2>
		  <cfelse>
			  <cfset selected_ = ''>
			  <cfset sepet.satir[aaa].fl_total_2 = 1>
			  <cfset sepet.satir[aaa].fl_total = 1>
			  <cfset sepet.satir[aaa].rate1 = 1>
			  <cfset sepet.satir[aaa].rate2 = 1>
		  </cfif>
		  <cfset sepet.satir[aaa].other_money_options = sepet.satir[aaa].other_money_options & "<option value='#get_money_bskt.money_type#' #selected_#>#get_money_bskt.money_type#</option>">
	  </cfoutput>
	  
	  <!--- Basket ek aciklama selectbox'ini doldurmak icin basket array'ine basket_extra_info_ alanı ekler. --->
	  <cfset sepet.satir[aaa].basket_extra_info_ = ''>
	  <cfloop list="#basket_info_list#" index="info_list">
		  <cfif StructKeyExists(sepet.satir[aaa],'basket_extra_info') and sepet.satir[aaa].basket_extra_info eq info_list>
			  <cfset selected_ = 'selected="selected"'>
		  <cfelse>
			  <cfset selected_ = ''>
		  </cfif>
		  <cfset sepet.satir[aaa].basket_extra_info_ = sepet.satir[aaa].basket_extra_info_ & "<option value='#ListFirst(info_list,';')#' #selected_#>#ListLast(info_list,';')#</option>">
	  </cfloop>
	  
	  <!--- Basket Ek Aciklama2 Selectbox'ini doldurmak icin basket Array'ine select_info_extra_ alani ekler Mifa FBS20181004 --->
	  <cfset sepet.satir[aaa].select_info_extra_ = ''>
	  <cfloop list="#select_info_extra_list#" index="extra_list">
		  <cfif StructKeyExists(sepet.satir[aaa],'select_info_extra') and sepet.satir[aaa].select_info_extra eq extra_list>
			  <cfset selected_ = 'selected="selected"'>
		  <cfelse>
			  <cfset selected_ = ''>
		  </cfif>
		  <cfset sepet.satir[aaa].select_info_extra_ = sepet.satir[aaa].select_info_extra_ & "<option value='#ListFirst(extra_list,';')#' #selected_#>#ListLast(extra_list,';')#</option>">
	  </cfloop>
  
	  <!--- istisna --->
	  <cfset sepet.satir[aaa].reason_code_info_ = ''>
	  <cfloop list="#reason_code_list#" index="info_list" delimiters="*">
		  <cfif StructKeyExists(sepet.satir[aaa],'reason_code') and sepet.satir[aaa].reason_code eq info_list>
			  <cfset selected_ = 'selected="selected"'>
		  <cfelse>
			  <cfset selected_ = ''>
		  </cfif>
		  <cfset sepet.satir[aaa].reason_code_info_ = sepet.satir[aaa].reason_code_info_ & "<option value='#listfirst(info_list,'*')#' #selected_#>#listlast(info_list,'*')#</option>">
	  </cfloop>

		<!--- ötv indirimi --->
		<cfset sepet.satir[aaa].otv_type_info_ = ''>
		<cfset sepet.satir[aaa].otv_type_info_ &= "<option value='0' #StructKeyExists(sepet.satir[aaa],'otv_type') and sepet.satir[aaa].otv_type eq 0 ? 'selected' : ''#>İndirim Yok</option>">
		<cfset sepet.satir[aaa].otv_type_info_ &= "<option value='1' #StructKeyExists(sepet.satir[aaa],'otv_type') and sepet.satir[aaa].otv_type eq 1 ? 'selected' : ''#>Tam İndirim</option>">

		<cfif StructKeyExists(sepet.satir[aaa],'OTV_DISCOUNT')>
			<cfset sepet.satir[aaa].OTV_DISCOUNT = sepet.satir[aaa].OTV_DISCOUNT>
		<cfelse>
			<cfset sepet.satir[aaa].OTV_DISCOUNT = 0>
		</cfif>
	  
	  <!--- ihracat --->
	  <cfset sepet.satir[aaa].delivery_condition_info_ = "<option value=''>#getLang('main',322)#</option>">
	  <cfoutput query="delivery_condition">
		  <cfif StructKeyExists(sepet.satir[aaa],'delivery_condition') and sepet.satir[aaa].delivery_condition eq delivery_condition.code>
			  <cfset selected_ = 'selected="selected"'>
		  <cfelse>
			  <cfset selected_ = ''>
		  </cfif>
		  <cfset sepet.satir[aaa].delivery_condition_info_ = sepet.satir[aaa].delivery_condition_info_ & "<option value='#delivery_condition.code#' #selected_#>#delivery_condition.code#-#delivery_condition.name#</option>">
	  </cfoutput>
	  <cfset sepet.satir[aaa].container_type_info_ = "<option value=''>#getLang('main',322)#</option>">
	  <cfoutput query="container_type">
		  <cfif StructKeyExists(sepet.satir[aaa],'container_type') and sepet.satir[aaa].container_type eq container_type.code>
			  <cfset selected_ = 'selected="selected"'>
		  <cfelse>
			  <cfset selected_ = ''>
		  </cfif>
		  <cfset sepet.satir[aaa].container_type_info_ = sepet.satir[aaa].container_type_info_ & "<option value='#container_type.code#' #selected_#>#container_type.code#-#container_type.name#</option>">
	  </cfoutput>
	  <cfset sepet.satir[aaa].delivery_type_info_ = "<option value=''>#getLang('main',322)#</option>">
	  <cfoutput query="delivery_type">
		  <cfif StructKeyExists(sepet.satir[aaa],'delivery_type') and sepet.satir[aaa].delivery_type eq delivery_type.code>
			  <cfset selected_ = 'selected="selected"'>
		  <cfelse>
			  <cfset selected_ = ''>
		  </cfif>
		  <cfset sepet.satir[aaa].delivery_type_info_ = sepet.satir[aaa].delivery_type_info_ & "<option value='#delivery_type.code#' #selected_#>#delivery_type.code#-#delivery_type.name#</option>">
	  </cfoutput>
	  
	  <!---start: Aktivite Tipi --->
	  
	  <cfif StructKeyExists(sepet.satir[aaa],'row_activity_id')>
		  <cfset sepet.satir[aaa].row_activity_id = sepet.satir[aaa].row_activity_id>
	  <cfelse>
		  <cfset sepet.satir[aaa].row_activity_id = ''>
	  </cfif>
	  
	  <cfset sepet.satir[aaa].row_activity_id_info_ = "<option value=''>#getLang('main',322)#</option>">
	  <cfoutput query="getActivity">
		  <cfif sepet.satir[aaa].ROW_ACTIVITY_ID eq ACTIVITY_ID>
			  <cfset selected_ = 'selected="selected"'>
		  <cfelse>
			  <cfset selected_ = ''>
		  </cfif>
		  <cfset sepet.satir[aaa].row_activity_id_info_ &= "<option value='#ACTIVITY_ID#' #selected_#>#ACTIVITY_NAME#</option>">
	  </cfoutput>
  
	  <!---end: Aktivite Tipi --->
  
	  <!---Abone--->
	  <cfset sepet.satir[aaa].row_subscription_id = StructKeyExists(sepet.satir[aaa],'row_subscription_id') ? sepet.satir[aaa].row_subscription_id : ''>
	  <cfset sepet.satir[aaa].row_subscription_name = StructKeyExists(sepet.satir[aaa],'row_subscription_name') ? sepet.satir[aaa].row_subscription_name : ''>
  
	  <!---Fiziki Varlık--->
	  <cfset sepet.satir[aaa].row_assetp_id = StructKeyExists(sepet.satir[aaa],'row_assetp_id') ? sepet.satir[aaa].row_assetp_id : ''>
	  <cfset sepet.satir[aaa].row_assetp_name = StructKeyExists(sepet.satir[aaa],'row_assetp_name') ? sepet.satir[aaa].row_assetp_name : ''>
  
	  <!---BSMV Oran--->
	  <cfset sepet.satir[aaa].row_bsmv_rate = StructKeyExists(sepet.satir[aaa],'row_bsmv_rate') ? sepet.satir[aaa].row_bsmv_rate : ''>

  	  <!---Hacim Oran--->
		<cfset sepet.satir[aaa].row_volume = StructKeyExists(sepet.satir[aaa],'row_volume') ? sepet.satir[aaa].row_volume : ''>
      
	  <!---Özgül Ağırlık--->
		<cfset sepet.satir[aaa].row_specific_weight = StructKeyExists(sepet.satir[aaa],'row_specific_weight') ? sepet.satir[aaa].row_specific_weight : ''>
  
	  <!---BSMV Tutar--->
	  <cfset sepet.satir[aaa].row_bsmv_amount = StructKeyExists(sepet.satir[aaa],'row_bsmv_amount') ? sepet.satir[aaa].row_bsmv_amount : ''>
	  
	  <!---BSMV Döviz--->
	  <cfset sepet.satir[aaa].row_bsmv_currency = StructKeyExists(sepet.satir[aaa],'row_bsmv_currency') ? sepet.satir[aaa].row_bsmv_currency : ''>
  
	  <!---OİV Oran--->
	  <cfset sepet.satir[aaa].row_oiv_rate = StructKeyExists(sepet.satir[aaa],'row_oiv_rate') ? sepet.satir[aaa].row_oiv_rate : ''>
  
	  <!---OİV Tutar--->
	  <cfset sepet.satir[aaa].row_oiv_amount = StructKeyExists(sepet.satir[aaa],'row_oiv_amount') ? sepet.satir[aaa].row_oiv_amount : ''>
  
	  <!---Tevkifat Oran--->
	  <cfset sepet.satir[aaa].row_tevkifat_rate = StructKeyExists(sepet.satir[aaa],'row_tevkifat_rate') ? sepet.satir[aaa].row_tevkifat_rate : ''>
  
	  <!---Tevkifat Tutar--->
	  <cfset sepet.satir[aaa].row_tevkifat_amount = StructKeyExists(sepet.satir[aaa],'row_tevkifat_amount') ? sepet.satir[aaa].row_tevkifat_amount : ''>
  
		<!---SERİ NO--->
	  <cfset sepet.satir[aaa].is_serial_no = StructKeyExists(sepet.satir[aaa],'is_serial_no') ? sepet.satir[aaa].is_serial_no : 0>

	  <cfif StructKeyExists(sepet.satir[aaa],'container_number')>
		  <cfset sepet.satir[aaa].container_number = sepet.satir[aaa].container_number>
	  <cfelse>
		  <cfset sepet.satir[aaa].container_number = ''>
	  </cfif>
	  <cfif StructKeyExists(sepet.satir[aaa],'container_quantity')>
		  <cfset sepet.satir[aaa].container_quantity = sepet.satir[aaa].container_quantity>
	  <cfelse>
		  <cfset sepet.satir[aaa].container_quantity = ''>
	  </cfif>
	  <cfif StructKeyExists(sepet.satir[aaa],'delivery_country')>
		  <cfset sepet.satir[aaa].delivery_country = sepet.satir[aaa].delivery_country>
	  <cfelse>
		  <cfset sepet.satir[aaa].delivery_country = ''>
	  </cfif>
	  <cfif StructKeyExists(sepet.satir[aaa],'delivery_city')>
		  <cfset sepet.satir[aaa].delivery_city = sepet.satir[aaa].delivery_city>
	  <cfelse>
		  <cfset sepet.satir[aaa].delivery_city = ''>
	  </cfif>
	  <cfif StructKeyExists(sepet.satir[aaa],'delivery_county')>
		  <cfset sepet.satir[aaa].delivery_county = sepet.satir[aaa].delivery_county>
	  <cfelse>
		  <cfset sepet.satir[aaa].delivery_county = ''>
	  </cfif>
	  <cfif StructKeyExists(sepet.satir[aaa],'gtip_number')>
		  <cfset sepet.satir[aaa].gtip_number = sepet.satir[aaa].gtip_number>
	  <cfelse>
		  <cfset sepet.satir[aaa].gtip_number = ''>
	  </cfif>    
	  <!--- ihracat --->
	  
	  <!--- Rezerve tipi selectbox'ini doldurmak icin basket array'ine reserve_type_list alanı ekler. --->
	  <cfset current_row = 1>
	  <cfset sepet.satir[aaa].reserve_type_list = ''>
	  <cfloop list="#reserve_type_list#" index="info_list">
		  <cfif StructKeyExists(sepet.satir[aaa],'reserve_type') and sepet.satir[aaa].reserve_type eq (-1*current_row)>
			  <cfset selected_ = 'selected="selected"'>
		  <cfelse>
			  <cfset selected_ = ''>
		  </cfif>
		  <cfset sepet.satir[aaa].reserve_type_list = sepet.satir[aaa].reserve_type_list & "<option value='#-1*current_row#' #selected_#>#ListGetAt(reserve_type_list,current_row,",")#</option>">
		  <cfset current_row = current_row + 1>
	  </cfloop>
	  <!--- Sipariş Aşama selectbox'ini doldurmak icin basket array'ine order_currency_list alanı ekler. --->
	  <cfset sepet.satir[aaa].order_currency_list = ''>
	  <cfset current_row = 1>
	  <cfloop list="#order_currency_list#" index="info_list">
		  <cfif StructKeyExists(sepet.satir[aaa],'order_currency') and sepet.satir[aaa].order_currency eq (-1*current_row)>
			  <cfset selected_ = 'selected="selected"'>
		  <cfelse>
			  <cfset selected_ = ''>
		  </cfif>
		  <cfset sepet.satir[aaa].order_currency_list = sepet.satir[aaa].order_currency_list & "<option value='#-1*current_row#' #selected_#>#ListGetAt(order_currency_list,current_row,",")#</option>">
		  <cfset current_row = current_row + 1>
	  </cfloop> 
	  
	  <cfif StructKeyExists(sepet.satir[aaa],'ROW_PROJECT_ID') and StructKeyExists(sepet.satir[aaa],'ROW_PROJECT_NAME')>
		  <cfset sepet.satir[aaa].ROW_PROJECT_ID = sepet.satir[aaa].ROW_PROJECT_ID>
		  <cfset sepet.satir[aaa].ROW_PROJECT_NAME = sepet.satir[aaa].ROW_PROJECT_NAME>
	  <cfelse>
		  <cfset sepet.satir[aaa].ROW_PROJECT_ID = ''>
		  <cfset sepet.satir[aaa].ROW_PROJECT_NAME = ''>
	  </cfif>	  
	  
	  <cfif StructKeyExists(sepet.satir[aaa],'ROW_WORK_ID') and StructKeyExists(sepet.satir[aaa],'ROW_WORK_NAME')>
		  <cfset sepet.satir[aaa].ROW_WORK_ID = sepet.satir[aaa].ROW_WORK_ID>
		  <cfset sepet.satir[aaa].ROW_WORK_NAME = sepet.satir[aaa].ROW_WORK_NAME>
	  <cfelse>
		  <cfset sepet.satir[aaa].ROW_WORK_ID = ''>
		  <cfset sepet.satir[aaa].ROW_WORK_NAME = ''>
	  </cfif>	 
  
	  <cfif StructKeyExists(sepet.satir[aaa],'ROW_EXP_CENTER_ID') and StructKeyExists(sepet.satir[aaa],'ROW_EXP_CENTER_NAME')>
		  <cfset sepet.satir[aaa].ROW_EXP_CENTER_ID = sepet.satir[aaa].ROW_EXP_CENTER_ID>
		  <cfset sepet.satir[aaa].ROW_EXP_CENTER_NAME = sepet.satir[aaa].ROW_EXP_CENTER_NAME>
	  <cfelse>
		  <cfset sepet.satir[aaa].ROW_EXP_CENTER_ID = ''>
		  <cfset sepet.satir[aaa].ROW_EXP_CENTER_NAME = ''>
	  </cfif>
  
	  <cfif StructKeyExists(sepet.satir[aaa],'ROW_EXP_ITEM_ID') and StructKeyExists(sepet.satir[aaa],'ROW_EXP_ITEM_NAME')>
		  <cfset sepet.satir[aaa].ROW_EXP_ITEM_ID = sepet.satir[aaa].ROW_EXP_ITEM_ID>
		  <cfset sepet.satir[aaa].ROW_EXP_ITEM_NAME = sepet.satir[aaa].ROW_EXP_ITEM_NAME>
	  <cfelse>
		  <cfset sepet.satir[aaa].ROW_EXP_ITEM_ID = ''>
		  <cfset sepet.satir[aaa].ROW_EXP_ITEM_NAME = ''>
	  </cfif>
  
	  <cfif StructKeyExists(sepet.satir[aaa],'ROW_ACC_CODE')>
		  <cfset sepet.satir[aaa].ROW_ACC_CODE = sepet.satir[aaa].ROW_ACC_CODE>
	  <cfelse>
		  <cfset sepet.satir[aaa].ROW_ACC_CODE = ''>
	  </cfif>
  
  </cfloop>
  
  <cfset selectbox_list = 'other_money,order_currency,reserve_type,basket_extra_info,select_info_extra,reason_code,unit2,delivery_condition,container_type,delivery_type,row_activity_id,otv_type'>
  <cfif ListFindNoCase(display_list, "is_use_add_unit")>
	  <cfset selectbox_list = listAppend(selectbox_list,'unit2',',')>
  </cfif>
  
  <cfset non_inputs = 'is_promotion,is_price_total_other_money,is_amount_total,is_paper_discount,basket_cursor,barcode_price_list,barcode_amount,barcode_amount_2,barcode_stock_code,barcode_barcode,barcode_serial_no,barcode_lot_no,barcode_choose_row,is_member_selected,is_project_not_change,is_use_add_unit,is_member_not_change,is_project_selected,use_project_discount_,check_row_discounts,zero_stock_status,zero_stock_control_date,is_serialno_guaranty,is_risc,is_cash_pos,is_installment,otv_from_tax_price,price_total,Kdv,oiv,bsmv,is_specific_weight,use_configurator'> <!--- Basket şablonlarında genel amaçlı tutulan inputlar. Örneğin is_price_total_other_money : Baskette toplam bilgileri gösterilsin. Bu alanları ekranda göstermeyeceğiz. --->
  <!--- is_promotion : Ödeme Yöntemi, Genel Promosyonlar çalıştırılsın. is_price_total_other_money : Basket Toplamda Döviz Bilgileri Gösterilsin. is_amount_total: Toplamda Miktar gösterilsin. is_paper_discount: Toplamda fatura altı indirim gösterilsin. basket_cursor : Barkoddan ürün düşürme. is_member_selected:Üye seçme zorunluluğu. is_project_not_change : proje zorunlu. is_use_add_unit : 2.birim otomatik hesaplansın. is_member_not_change: ürün varsa cari değiştirilemesin. is_project_selected: Proje seçme zorunluluğu. use_project_discount_ : Proje Bağlantı kontrolleri. check_row_discounts : Şube iskonto yetki kontrolleri.zero_stock_status : Sıfır Stok. zero_stock_control_date: Sıfır Stok Belge tarihi kontrolü. is_serialno_guaranty: Garanti Seri No. is_risc : Risk. is_cash_pos : Nakit Pos Ödeme. is_installment : Taksit Hesaplama. otv_from_tax_price : OTV KDVye eklenir. price_total : Basket Toplam. Kdv : KDV toplam--->
  
  <cfloop from="1" to="#listlen(input_id_list,",")#" index="dli">
	  <cfset select_func_list = listAppend(select_func_list,'*','§')>
  </cfloop>
  
  <cfloop index="ii" from="1" to="#arrayLen(sepet.satir)#">
		<cfif sepet.satir[ii].amount neq 0>
			<cfset sepet.satir[ii]['PRICE_NET'] = sepet.satir[ii].row_nettotal/sepet.satir[ii].amount>
		<cfelse>
			<cfset sepet.satir[ii]['PRICE_NET'] = 0>
		</cfif>
	  <!---<cfset sepet.satir[ii]['PRICE_NET'] = sepet.satir[ii].row_nettotal/sepet.satir[ii].amount>--->
	  <cfif StructKeyExists(sepet.satir[ii],'list_price') and len(sepet.satir[ii].list_price) and sepet.satir[ii].list_price neq 0 and StructKeyExists(sepet.satir[ii],'net_maliyet') and len(sepet.satir[ii].net_maliyet)>
		  <cfset list_price_discount=100-((sepet.satir[ii].net_maliyet*100)/sepet.satir[ii].list_price)>
	  <cfelse>
		  <cfset list_price_discount=0>
	  </cfif>
	  <cfset sepet.satir[ii]['LIST_PRICE_DISCOUNT'] = list_price_discount>
	  <cfset sepet.satir[ii]['OTHER_MONEY_VALUE'] = sepet.satir[ii].OTHER_MONEY_VALUE>
	  <!---<cfdump var="#sepet.satir[ii].ROW_NETTOTAL#-#sepet.satir[ii].AMOUNT#-#sepet.satir[ii].fl_total_2#-#sepet.satir[ii].fl_total#">--->
		<cfif sepet.satir[ii].amount neq 0>
			<cfset sepet.satir[ii]['PRICE_NET_DOVIZ'] = (sepet.satir[ii].ROW_NETTOTAL / sepet.satir[ii].AMOUNT) * sepet.satir[ii].fl_total_2/sepet.satir[ii].fl_total>
		<cfelse>
			<cfset sepet.satir[ii]['PRICE_NET_DOVIZ'] = 0>
		</cfif>
	  <!---<cfset sepet.satir[ii]['PRICE_NET_DOVIZ'] = (sepet.satir[ii].ROW_NETTOTAL / sepet.satir[ii].AMOUNT) * sepet.satir[ii].fl_total_2/sepet.satir[ii].fl_total>--->
	  <cfif isdefined("fl_total")>
		  <cfset fl_other_money = sepet.satir[ii].row_nettotal*sepet.satir[ii].fl_total_2/sepet.satir[ii].fl_total>
	  <cfelse>
		  <cfset fl_other_money = sepet.satir[ii].other_money_value>
	  </cfif>
	  <cfif fl_other_money is "">
		  <cfset fl_other_money = sepet.satir[ii].price>
	  </cfif>
	  <cfif StructKeyExists(sepet.satir[ii],'otv_oran')>
		  <cfif ListFindNoCase(display_list, "otv_from_tax_price")>
			  <!--- kdv matrahına otv toplam ekleniyor --->
			  <cfif otv_calc_type_ eq 1>
				  <cfset sepet.satir[ii]['OTHER_MONEY_GROSSTOTAL'] = (fl_other_money) + ((fl_other_money + sepet.satir[ii].otv_oran * sepet.satir[ii].amount)*sepet.satir[ii].tax_percent/100) + (sepet.satir[ii].otv_oran * sepet.satir[ii].amount)>
			  <cfelse>
			  	  <cfset sepet.satir[ii]['OTHER_MONEY_GROSSTOTAL'] = (fl_other_money*((sepet.satir[ii].tax_percent + (sepet.satir[ii].otv_oran*(sepet.satir[ii].tax_percent/100)))+sepet.satir[ii].otv_oran+100))/100>
			  </cfif>
		  <cfelse>
			  <cfif otv_calc_type_ eq 1>
				  <cfset sepet.satir[ii]['OTHER_MONEY_GROSSTOTAL'] = (fl_other_money) + (fl_other_money*sepet.satir[ii].tax_percent/100) + (sepet.satir[ii].otv_oran * sepet.satir[ii].amount)>
			  <cfelse>
			      <cfset sepet.satir[ii]['OTHER_MONEY_GROSSTOTAL'] = (fl_other_money*(sepet.satir[ii].tax_percent+sepet.satir[ii].otv_oran+100))/100>
			  </cfif>
		  </cfif>
	  <cfelse>
		  <cfset sepet.satir[ii]['OTHER_MONEY_GROSSTOTAL'] = (fl_other_money*(sepet.satir[ii].tax_percent+100))/100>
	  </cfif>
	  
	  <cfif StructKeyExists(sepet.satir[ii],'ROW_UNIQUE_RELATION_ID')>
		  <cfset sepet.satir[ii]['ROW_UNIQUE_RELATION_ID'] = sepet.satir[ii]['ROW_UNIQUE_RELATION_ID']>
	  <cfelse>
		  <cfset sepet.satir[ii]['ROW_UNIQUE_RELATION_ID'] = ''>
	  </cfif>
	  
	  <cfif StructKeyExists(sepet.satir[ii],'net_maliyet') and len(sepet.satir[ii].net_maliyet) and sepet.satir[ii].net_maliyet neq 0 and StructKeyExists(sepet.satir[ii],'extra_cost') and len(sepet.satir[ii].extra_cost)>
		  <cfset extra_cost_rate_= (sepet.satir[ii].extra_cost/sepet.satir[ii].net_maliyet)*100>
	  <cfelse>
		  <cfset extra_cost_rate_= 0>
	  </cfif>
	  <cfset sepet.satir[ii]['EXTRA_COST_RATE'] = extra_cost_rate_>
	  <cfset row_cost_total=0>
	  <cfif StructKeyExists(sepet.satir[ii],'net_maliyet') and len(sepet.satir[ii].net_maliyet) and sepet.satir[ii].net_maliyet neq 0>
		  <cfset row_cost_total=row_cost_total+sepet.satir[ii].net_maliyet>
	  </cfif>
	  <cfif StructKeyExists(sepet.satir[ii],'extra_cost') and len(sepet.satir[ii].extra_cost) and sepet.satir[ii].extra_cost neq 0>
		  <cfset row_cost_total=row_cost_total+sepet.satir[ii].extra_cost>
	  </cfif>
	  <cfset sepet.satir[ii]['ROW_COST_TOTAL'] = row_cost_total>
	  
	  <!--- Buradan aşağıya kadar olan kısım baskette satırda tuttuğumuz hidden inputlardır. --->
	  <cfif StructKeyExists(sepet.satir[ii],'wrk_row_id')>
		  <cfset value_ = sepet.satir[ii].wrk_row_id>
	  <cfelse>
		  <cfset value_ = ''>
	  </cfif>
	  <cfset sepet.satir[ii]['WRK_ROW_ID'] = value_>
	  
	  <cfif StructKeyExists(sepet.satir[ii],'wrk_row_relation_id')>
		  <cfset value_ = sepet.satir[ii].wrk_row_relation_id>
	  <cfelse>
		  <cfset value_ = ''>
	  </cfif>
	  <cfset sepet.satir[ii]['WRK_ROW_RELATION_ID'] = value_>
	  
	  <cfif StructKeyExists(sepet.satir[ii],'action_row_id')>
		  <cfset value_ = sepet.satir[ii].action_row_id>
	  <cfelse>
		  <cfset value_ = ''>
	  </cfif>
	  <cfset sepet.satir[ii]['ACTION_ROW_ID'] = value_>
	  
	  <cfset sepet.satir[ii]['PRODUCT_ID'] = sepet.satir[ii].product_id>
	  <cfif StructKeyExists(sepet.satir[ii],'karma_product_id') and len(sepet.satir[ii].karma_product_id)>
		  <cfset value_ = sepet.satir[ii].karma_product_id>
	  <cfelse>
		  <cfset value_ = ''>
	  </cfif>
	  <cfset sepet.satir[ii]['KARMA_PRODUCT_ID'] = value_>
	  
	  <cfset sepet.satir[ii]['IS_INVENTORY'] = sepet.satir[ii].is_inventory>
	  <cfif StructKeyExists(sepet.satir[ii],'is_production')>
		  <cfset value_ = sepet.satir[ii].is_production>
	  <cfelse>
		  <cfset value_ = ''>
	  </cfif>
	  <cfset sepet.satir[ii]['IS_PRODUCTION'] = value_>
	  
	  <cfset sepet.satir[ii]['STOCK_ID'] = sepet.satir[ii].stock_id>
	  <cfset sepet.satir[ii]['UNIT_ID'] = sepet.satir[ii].unit_id>
	  <cfif StructKeyExists(sepet.satir[ii],'row_ship_id')>
		  <cfset value_ = sepet.satir[ii].row_ship_id>
	  <cfelse>
		  <cfset value_ = 0>
	  </cfif>
	  <cfset sepet.satir[ii]['ROW_SHIP_ID'] = value_>
	  
	  <cfif StructKeyExists(sepet.satir[ii],'is_promotion')>
		  <cfset value_ = sepet.satir[ii].is_promotion>
	  <cfelse>
		  <cfset value_ = 0>
	  </cfif>
	  <cfset sepet.satir[ii]['IS_PROMOTION'] = value_>
	  
	  <cfif StructKeyExists(sepet.satir[ii],'prom_stock_id')>
		  <cfset value_ = sepet.satir[ii].prom_stock_id>
	  <cfelse>
		  <cfset value_ = 0>
	  </cfif>
	  <cfset sepet.satir[ii]['PROM_STOCK_ID'] = value_>
	  
	  <cfif StructKeyExists(sepet.satir[ii],'row_paymethod_id')>
		  <cfset value_ = sepet.satir[ii].row_paymethod_id>
	  <cfelse>
		  <cfset value_ = ''>
	  </cfif>
	  <cfset sepet.satir[ii]['ROW_PAYMETHOD_ID'] = value_>
	  
	  <cfif StructKeyExists(sepet.satir[ii],'row_promotion_id')>
		  <cfset value_ = sepet.satir[ii].row_promotion_id>
	  <cfelse>
		  <cfset value_ = ''>
	  </cfif>
	  <cfset sepet.satir[ii]['ROW_PROMOTION_ID'] = value_>
	  
	  <cfif StructKeyExists(sepet.satir[ii],'prom_relation_id')>
		  <cfset value_ = sepet.satir[ii].prom_relation_id>
	  <cfelse>
		  <cfset value_ = ''>
	  </cfif>
	  <cfset sepet.satir[ii]['PROM_RELATION_ID'] = value_>
	  <cfset sepet.satir[ii]['INDIRIM_TOTAL'] = sepet.satir[ii].indirim_carpan>
	  
	  <cfif StructKeyExists(sepet.satir[ii],'ek_tutar_total')>
		  <cfset value_ = sepet.satir[ii].ek_tutar_total>
	  <cfelse>
		  <cfset value_ = 0>
	  </cfif>
	  <cfset sepet.satir[ii]['EK_TUTAR_TOTAL'] = value_>
  
	  <cfif StructKeyExists(sepet.satir[ii],'price_cat')>
		  <cfset value_ = sepet.satir[ii].price_cat>
	  <cfelse>
		  <cfset value_ = ''>
	  </cfif>
	  <cfset sepet.satir[ii]['PRICE_CAT'] = value_>
	  
	  <cfif StructKeyExists(sepet.satir[ii],'row_catalog_id') and len(sepet.satir[ii].row_catalog_id)>
		  <cfset value_ = sepet.satir[ii].row_catalog_id>
	  <cfelse>
		  <cfset value_ = ''>
	  </cfif>
	  <cfset sepet.satir[ii]['ROW_CATALOG_ID'] = value_>
	  
	  <cfif StructKeyExists(sepet.satir[ii],'row_service_id') and len(sepet.satir[ii].row_service_id)>
		  <cfset value_ = sepet.satir[ii].row_service_id>
	  <cfelse>
		  <cfset value_ = ''>
	  </cfif>
	  <cfset sepet.satir[ii]['ROW_SERVICE_ID'] = value_>
  
	  <cfif StructKeyExists(sepet.satir[ii],'is_commission')>
		  <cfset value_ = sepet.satir[ii].is_commission>
	  <cfelse>
		  <cfset value_ = 0>
	  </cfif>
	  <cfset sepet.satir[ii]['IS_COMMISSION'] = value_>
	  
	  <cfif StructKeyExists(sepet.satir[ii],'related_action_id')>
		  <cfset value_ = sepet.satir[ii].related_action_id>
	  <cfelse>
		  <cfset value_ = ''>
	  </cfif>
	  <cfset sepet.satir[ii]['RELATED_ACTION_ID'] = value_>
	  
	   <!--- satırın geldigi ilişkili belge id --->
	  <cfif StructKeyExists(sepet.satir[ii],'related_action_id')>
		  <cfset value_ = sepet.satir[ii].related_action_id>
	  <cfelse>
		  <cfset value_ = ''>
	  </cfif>
	  <cfset sepet.satir[ii]['RELATED_ACTION_ID'] = value_>
	  
	  <!--- satırın ilişkili oldugu belgenin tablosu --->
	  <cfif StructKeyExists(sepet.satir[ii],'related_action_table')>
		  <cfset value_ = sepet.satir[ii].related_action_table>
	  <cfelse>
		  <cfset value_ = ''>
	  </cfif>
	  <cfset sepet.satir[ii]['RELATED_ACTION_TABLE'] = value_>
  
	  <!--- satırın ilişkili oldugu belgenin tablosu --->
	  <cfif StructKeyExists(sepet.satir[ii],'pbs_id') and len(sepet.satir[ii].pbs_id)>
		  <cfset value_ = sepet.satir[ii].pbs_id>
		  <cfquery name="get_pbs_code" datasource="#dsn3#">
			  SELECT PBS_ID,PBS_CODE FROM SETUP_PBS_CODE WHERE PBS_ID=#sepet.satir[ii].pbs_id#
		  </cfquery>
		  <cfset temp_pbs_code = get_pbs_code.pbs_code>
	  <cfelse>
		  <cfset value_ = ''>
		  <cfset temp_pbs_code = ''>
	  </cfif>
	  <cfset sepet.satir[ii]['PBS_ID'] = value_>
	  <cfset sepet.satir[ii]['PBS_CODE'] = temp_pbs_code>
	  
	  <!--- satırın ilişkili oldugu belgenin tablosu --->
	  <cfif StructKeyExists(sepet.satir[ii],'related_action_table')>
		  <cfset value_ = sepet.satir[ii].related_action_table>
	  <cfelse>
		  <cfset value_ = ''>
	  </cfif>
	  <cfset sepet.satir[ii]['RELATED_ACTION_TABLE'] = value_>
  
	  <cfif StructKeyExists(sepet.satir[ii],'shelf_number') and len(sepet.satir[ii].shelf_number)>
		  <cfquery name="get_shelf_name" datasource="#dsn3#">
			  SELECT SHELF_CODE,SHELF_TYPE FROM PRODUCT_PLACE WHERE PLACE_STATUS=1 AND PRODUCT_PLACE_ID=#sepet.satir[ii].shelf_number#
		  </cfquery>
		  <cfif len(get_shelf_name.SHELF_CODE)>
			  <cfif len(get_shelf_name.SHELF_TYPE)>
				  <cfquery name="get_shelf_type" datasource="#DSN#">
					  SELECT * FROM SHELF WHERE SHELF_ID = #get_shelf_name.SHELF_TYPE#
				  </cfquery>
			  </cfif>
			  <cfset temp_shelf_number_ = "#get_shelf_name.SHELF_CODE# - #get_shelf_type.SHELF_NAME#">
		  <cfelse>
			  <cfset temp_shelf_number_ = ''>
		  </cfif>
	  <cfelse>
		  <cfset temp_shelf_number_ = ''>
	  </cfif>
	  <cfset sepet.satir[ii]['SHELF_NUMBER_TXT'] = temp_shelf_number_>
	  
	  <cfif StructKeyExists(sepet.satir[ii],'to_shelf_number') and len(sepet.satir[ii].to_shelf_number)>
		  <cfquery name="get_shelf_name" datasource="#dsn3#">
			  SELECT SHELF_CODE,SHELF_TYPE FROM PRODUCT_PLACE WHERE PLACE_STATUS=1 AND PRODUCT_PLACE_ID=#sepet.satir[ii].to_shelf_number#
		  </cfquery>
		  <cfif len(get_shelf_name.SHELF_CODE)>
			  <cfif len(get_shelf_name.SHELF_TYPE)>
				  <cfquery name="get_shelf_type" datasource="#DSN#">
					  SELECT * FROM SHELF WHERE SHELF_ID = #get_shelf_name.SHELF_TYPE#
				  </cfquery>
			  </cfif>
			  <cfset temp_shelf_number_2 = "#get_shelf_name.SHELF_CODE# - #get_shelf_type.SHELF_NAME#">
		  <cfelse>
			  <cfset temp_shelf_number_2 = ''>
		  </cfif>
	  <cfelse>
		  <cfset temp_shelf_number_2 = ''>
		  <cfset sepet.satir[ii]['TO_SHELF_NUMBER'] = ''>
	  </cfif>
	  <cfset sepet.satir[ii]['TO_SHELF_NUMBER_TXT'] = temp_shelf_number_2>
	  
	  <cfif len(listsort(sepet.satir[ii].deliver_dept,"Text","asc","-")) and listlen(sepet.satir[ii].deliver_dept,'-') eq 2>
		  <cfset attributes.department_id = listgetat(sepet.satir[ii].deliver_dept,1,'-')>
		  <cfinclude template="../query/get_department.cfm">
		  <cfset department_head = get_department.DEPARTMENT_HEAD>
		  <!--- Gonderilen location degerinde eksiklikler oldugundan asagidaki sekilde location_id gonderildi FBS 20110914
		  <cfset attributes.department_location = sepet.satir[i].deliver_dept>
		  --->
		  <cfset attributes.location_id = listgetat(sepet.satir[ii].deliver_dept,2,'-')>
		  <cfinclude template="../query/get_department_location.cfm">
		  <cfset department_head = "#department_head#-#get_department_location.comment#">
	  <cfelse>
		  <cfset department_head = ''>
	  </cfif>
	  <cfset sepet.satir[ii]['DEPT_HEAD'] = department_head>
	  
	  <cfif StructKeyExists(sepet.satir[ii],'row_ship_id')>
		  <cfset value_ = sepet.satir[ii].row_ship_id>
	  <cfelse>
		  <cfset value_ = 0>
	  </cfif>
	  <cfset sepet.satir[ii]['ROW_SHIP_ID'] = value_>
  </cfloop>
  
  <cfset basketItemsJSON = SerializeJSON(sepet.satir)>
  <cfif left(basketItemsJSON, 2) is "//"><cfset basketItemsJSON = mid(basketItemsJSON, 3, len(basketItemsJSON) - 2)></cfif>
  <cfif isdefined("thisIsSuchAHorribleHack")>
	  <cfset basketItemsJSON = Replace(basketItemsJSON, thisIsSuchAHorribleHack, "", "ALL")>
  </cfif>
  <cfset basketItemsJSON = URLEncodedFormat(basketItemsJSON, "utf-8")>
  
  <cfquery name="get_money_bskt_curr" dbtype="query">
	  SELECT MONEY_TYPE FROM get_money_bskt WHERE IS_SELECTED = 1
  </cfquery>
  <cfset readOnlyInputList = 'stock_code,barcod,special_code,unit,list_price,price_net,price_net_doviz,row_nettotal,other_money_gross_total,row_cost_total,otv_discount'>
	  <style>
		 /*  #btnNext, #btnPrev, #btnFirst, #btnLast, #pageNumber { display:none; } 
			 #tblBasket { border-spacing:5px; }
		  #tblSummary { margin-top:20px; margin-left:20px; float:left; }
		  #tblSummary td:nth-child(1) { text-align:right; font-weight:bold; }
		  #tblDiscount { margin-top:20px; margin-left:20px; float:left;}
		  #tblDiscount td:nth-child(1) { text-align:right; font-weight:bold; } 
		  #basket_doviz {  margin-top:20px; float:left;} */
		  #basketItemBase { display:none; }
	  </style>
	  <script>
		  <cfif (isdefined("moneyformat_style") and moneyformat_style eq 0) or not isdefined("moneyformat_style")>
			  var js_money_ayrac_binlik = '.';
			  var js_money_ayrac_ondalik = ',';
		  <cfelse>
			  var js_money_ayrac_binlik = ',';
			  var js_money_ayrac_ondalik = '.';
		  </cfif>
  
		  var display_list = "<cfoutput>#display_list#</cfoutput>";
		  var d1=0, d2=0, d3=0, d4=0, d5=0, d6=0, d7=0, d8=0, d9=0, d10=0;
		  
		  var extra_basket_hidden_list_ = "<cfoutput>#extra_basket_hidden_list_#</cfoutput>";
		  
		  var display_field_readonly_list = '<cfoutput>#display_field_readonly_list#</cfoutput>';
		  var display_field_required_list = '<cfoutput>#display_field_required_list#</cfoutput>';
		  var basket_read_only_price_list = '<cfoutput>#basket_read_only_price_list#</cfoutput>';
		  var basket_read_only_duedate_list = '<cfoutput>#basket_read_only_duedate_list#</cfoutput>';
		  var readOnlyInputList = '<cfoutput>#readOnlyInputList#</cfoutput>';
		  var duedate_valid = '<cfoutput>#session.ep.duedate_valid#</cfoutput>';
		  
  //		'spect_name ve product_name' kontrol edilecek
		  function init()
		  {
			  window.basket = {
				  header: {},
				  footer:	{
							  basket_gross_total : <cfoutput><cfif StructKeyExists(sepet,'total')>#wrk_round(sepet.total,basket_total_round_number)#<cfelse>0</cfif></cfoutput>,
							  basket_tax_total : <cfoutput><cfif StructKeyExists(sepet,'total_tax')>#wrk_round(sepet.total_tax,basket_total_round_number)#<cfelse>0</cfif></cfoutput>,
							  basket_otv_total : <cfoutput><cfif StructKeyExists(sepet,'total_otv')>#wrk_round(sepet.total_otv,basket_total_round_number)#<cfelse>0</cfif></cfoutput>,
							  basket_net_total : <cfoutput><cfif StructKeyExists(sepet,'net_total')>#wrk_round(sepet.net_total,basket_total_round_number)#<cfelse>0</cfif></cfoutput>,
							  basket_discount_total : <cfoutput><cfif StructKeyExists(sepet,'toplam_indirim')>#wrk_round(sepet.toplam_indirim,basket_total_round_number)#<cfelse>0</cfif></cfoutput>,
							  basket_money : <cfoutput><cfif isdefined('str_money_bskt')>'#str_money_bskt#'<cfelse>''</cfif></cfoutput>,
							  basket_rate1 : <cfoutput><cfif isdefined('sepet_rate1')>#sepet_rate1#<cfelse>''</cfif></cfoutput>,
							  basket_rate2 : <cfoutput><cfif isdefined('sepet_rate2')>#sepet_rate2#<cfelse>''</cfif></cfoutput>,
							  genel_indirim_ : <cfoutput><cfif StructKeyExists(sepet,'genel_indirim')>#sepet.genel_indirim#<cfelse>0</cfif></cfoutput>,
							  kur_say : <cfoutput>#get_money_bskt.recordcount#</cfoutput>,
							  yuvarlama : <cfoutput><cfif StructKeyExists(sepet,'yuvarlama') and len(sepet.yuvarlama)>#wrk_round(sepet.yuvarlama,basket_total_round_number)#<cfelse>0</cfif></cfoutput>,
							  basketCurrencyType : '<cfoutput>#get_money_bskt_curr.MONEY_TYPE#</cfoutput>'
						  },
				  items: $.evalJSON(decodeURIComponent("<cfoutput>#basketItemsJSON#</cfoutput>")),
				  scrollIndex: 0,
				  pageSize: <cfoutput><cfif isdefined("GET_BASKET.LINE_NUMBER") and len(GET_BASKET.LINE_NUMBER)>#GET_BASKET.LINE_NUMBER#<cfelse>10</cfif></cfoutput>,
				  hidden_values : {
									  control_field_value : null ,
									  today_date_ : "<cfoutput>#dateadd('h',session.ep.time_zone,now())#</cfoutput>",
									  rows_ : 0,  //display_file'larda window.basket.items.length diye güncellenecek. Basket henüz yüklenmediği için 0 set edildi. Aşağıda satır sayısı set ediliyor.
									  basket_id : <cfoutput>#attributes.basket_id#</cfoutput>,
									  sale_product : <cfif len(sale_product)><cfoutput>#sale_product#</cfoutput><cfelse>null</cfif>,
									  use_basket_project_discount_ : <cfoutput>#use_basket_project_discount_#</cfoutput>,
									  basket_otv_from_tax_price : listfind(display_list,'otv_from_tax_price') != -1 ? 1 : 0,
									  basket_price_round_number : <cfoutput>#price_round_number#</cfoutput>,
									  basket_total_round_number_ : <cfoutput>#basket_total_round_number#</cfoutput>,
									  basket_rate_round_number_ : <cfoutput>#basket_rate_round_number#</cfoutput>,
									  amount_round : <cfoutput>#amount_round#</cfoutput>,
									  basket_spect_type : listfind(display_list,'spec_product_cat_property') != -1 ? 7 : 0,
									  is_general_prom : <cfoutput><cfif StructKeyExists(sepet,'general_prom_id') or StructKeyExists(sepet,'free_prom_id')>1<cfelse>0</cfif></cfoutput>,
									  old_general_prom_amount : <cfoutput><cfif StructKeyExists(sepet,'general_prom_id') and StructKeyExists(sepet,'general_prom_amount') and len(sepet.general_prom_amount)>#sepet.general_prom_amount#<cfelse>0</cfif></cfoutput>,
									  <cfoutput>
										  <cfif fusebox.circuit eq "invoice" or listfind("1,2,4,5,6,10,14,18,20,21,33,38,42,43,46,51,52",attributes.basket_id,",")>
											  genel_indirim : <cfif StructKeyExists(sepet,'genel_indirim')>#sepet.genel_indirim#<cfelse>null</cfif>,
										  </cfif>
									  </cfoutput>
									  basket_member_pricecat : null,
									  fuseaction : "<cfoutput>#attributes.fuseaction#</cfoutput>",
									  is_basket_readonly : '<cfoutput>#is_basket_readonly#</cfoutput>',
									  basket_read_only_discount_list : '<cfoutput>#basket_read_only_discount_list#</cfoutput>',
									  basket_read_only_price_list : '<cfoutput>#basket_read_only_price_list#</cfoutput>',
									  basket_read_only_duedate_list : '<cfoutput>#basket_read_only_duedate_list#</cfoutput>'
								  }
			  }
			  var rowCount = window.basket.items.length;
			  window.basket.hidden_values.rows_ = window.basket.items.length;
			  
			  add_prod_no = 0;
			  var frameler = window.frames;
			  for (var fm = 0; fm < frameler.length; fm++)
			  {   
				  if(frameler[fm].name == '_add_prod_')
					   add_prod_no = fm;
			  }
				  
		  }
		  
		  function findInList(list, str, noCase, delimiter){
			  if (delimiter == null) delimiter = ",";
			  var items = list.split(delimiter);
			  for (var i = 0; i < items.length; i++){
				  if (items[i] == str || noCase == true && items[i].toLowerCase() == str.toLowerCase()) return true;
			  }
			  return false;
		  }
	  
			$(document).ready(function(){
				$("#btnNext, #btnPrev, #btnFirst, #btnLast").bind("click", showBasketItems);
				<cfif IsDefined("attributes.isAjax")>setTimeout(function() { </cfif>
					init();
					showBasketItems();
					check_member_price_cat(0);
					kur_degistir();
					basket_set_height();
				<cfif IsDefined("attributes.isAjax")>}, 1);</cfif>
				<cfif session.ep.SCREEN_WIDTH lt 767>$(".is_mobile").remove();</cfif>
			});
		  
		  function deleteBasketItem(e){
			  var itemIndex = $(e.target).closest("tr[basketItem]").attr("itemIndex");
			  window.basket.hidden_values.rows_ = window.basket.hidden_values.rows_ - 1;
			  window.basket.items.splice(itemIndex, 1);
			  
			  showBasketItems();
		  }
		  function updateBasketItemFromPopup(index, data){
			  for (var prop in data){
				  window.basket.items[index][prop] = data[prop];
				  //console.log(data[prop]+'-'+prop);
			  }
			  
			  if (data.AMOUNT != null) fillArrayField('Amount',Number(data.Amount),Number(data.Amount),index,1);
			  if (data.ROW_WORK_NAME != null) fillArrayField('row_work_name',data.ROW_WORK_NAME,data.ROW_WORK_NAME,index,1);
			  if (data.ROW_WORK_ID != null) fillArrayField('row_work_id',Number(data.ROW_WORK_ID),Number(data.ROW_WORK_ID),index,1);
			  if (data.ROW_PROJECT_NAME != null) fillArrayField('row_project_name',data.ROW_PROJECT_NAME,data.ROW_PROJECT_NAME,index,1);
			  if (data.ROW_PROJECT_ID != null) fillArrayField('row_project_id',Number(data.ROW_PROJECT_ID),Number(data.ROW_PROJECT_ID),index,1);
			  if (data.ROW_EXP_CENTER_NAME != null) fillArrayField('basket_exp_center',data.ROW_EXP_CENTER_NAME,data.ROW_EXP_CENTER_NAME,index,1);
			  if (data.ROW_EXP_CENTER_ID != null) fillArrayField('basket_exp_center_id',Number(data.ROW_EXP_CENTER_ID),Number(data.ROW_EXP_CENTER_ID),index,1);
			  if (data.ROW_EXP_ITEM_NAME != null) fillArrayField('basket_exp_item',data.ROW_EXP_ITEM_NAME,data.ROW_EXP_ITEM_NAME,index,1);
			  if (data.ROW_EXP_ITEM_ID != null) fillArrayField('basket_exp_item_id',Number(data.ROW_EXP_ITEM_ID),Number(data.ROW_EXP_ITEM_ID),index,1);
			  if (data.ROW_ACC_CODE != null) fillArrayField('basket_acc_code',data.ROW_ACC_CODE,data.ROW_ACC_CODE,index,1);
			  if (data.BASKET_EMPLOYEE != null) fillArrayField('basket_employee',data.BASKET_EMPLOYEE,data.BASKET_EMPLOYEE,index,1);
			  if (data.BASKET_EMPLOYEE_ID != null) fillArrayField('basket_employee_id',Number(data.BASKET_EMPLOYEE_ID),Number(data.BASKET_EMPLOYEE_ID),index,1);
			  if (data.BASKET_ROW_DEPARTMENT != null) fillArrayField('basket_row_departman',data.BASKET_ROW_DEPARTMENT,data.BASKET_ROW_DEPARTMENT,index,1);
			  if (data.RESERVE_DATE != null) fillArrayField('reserve_date',data.RESERVE_DATE,data.RESERVE_DATE,index,1);
			  if (data.SHELF_NUMBER != null) fillArrayField('shelf_number',Number(data.SHELF_NUMBER),Number(data.SHELF_NUMBER),index,1);
			  if (data.SHELF_NUMBER_TXT != null) fillArrayField('shelf_number_txt',data.SHELF_NUMBER_TXT,data.SHELF_NUMBER_TXT,index,1);
			  if (data.TO_SHELF_NUMBER != null) fillArrayField('to_shelf_number',Number(data.TO_SHELF_NUMBER),Number(data.TO_SHELF_NUMBER),index,1);
			  if (data.TO_SHELF_NUMBER_TXT != null) fillArrayField('to_shelf_number_txt',data.TO_SHELF_NUMBER_TXT,data.TO_SHELF_NUMBER_TXT,index,1);
			  if (data.PBS_ID != null) fillArrayField('pbs_id',Number(data.PBS_ID),Number(data.PBS_ID),index,1);
			  if (data.PBS_CODE != null) fillArrayField('pbs_code',data.PBS_CODE,data.PBS_CODE,index,1);
			  if (data.DELIVER_DATE != null) fillArrayField('deliver_date',data.DELIVER_DATE,data.DELIVER_DATE,index,1);
			  //spec sayfalaları için ekledim PY
			  if (data.SPECT_NAME != null) fillArrayField('spect_name',data.SPECT_NAME,data.SPECT_NAME,index,1);
			  if (data.PRICE != null) fillArrayField('Price',Number(data.PRICE),Number(data.PRICE),index,1);
			  if (data.LIST_PRICE_DISCOUNT != null) fillArrayField('list_price_discount',Number(data.LIST_PRICE_DISCOUNT),Number(data.LIST_PRICE_DISCOUNT),index,1);
			  if (data.OTHER_MONEY != null) fillArrayField('other_money',data.OTHER_MONEY,data.OTHER_MONEY,index,1);
			  if (data.PRICE_OTHER != null) fillArrayField('price_other',Number(data.PRICE_OTHER),Number(data.PRICE_OTHER),index,1);
			  if (data.PRICE_NET_DOVIZ != null) fillArrayField('price_net_doviz',Number(data.PRICE_NET_DOVIZ),Number(data.PRICE_NET_DOVIZ),index,1);
			  if (data.OTV_DISCOUNT != null) fillArrayField('otv_discount',Number(data.OTV_DISCOUNT),Number(data.OTV_DISCOUNT),index,1);
			  if (data.NET_MALIYET != null) fillArrayField('net_maliyet',Number(data.NET_MALIYET),Number(data.NET_MALIYET),index,1);
			  if (data.BASKET_EXTRA_INFO != null) fillArrayField('basket_extra_info',data.BASKET_EXTRA_INFO,data.BASKET_EXTRA_INFO,index,1);
			  if (data.SELECT_INFO_EXTRA != null) fillArrayField('select_info_extra',data.SELECT_INFO_EXTRA,data.SELECT_INFO_EXTRA,index,1);
			  if (data.SPECT_ID != null) fillArrayField('spect_id',Number(data.SPECT_ID),Number(data.SPECT_ID),index,1);
			  if (data.LOT_NO != null) fillArrayField('lot_no',data.LOT_NO,data.LOT_NO,index,1);
			  if (data.ROW_ACTIVITY_ID != null) fillArrayField('row_activity_id',data.ROW_ACTIVITY_ID,data.ROW_ACTIVITY_ID,index,1);
			  if (data.ROW_SUBSCRIPTION_ID != null) fillArrayField('row_subscription_id',data.ROW_SUBSCRIPTION_ID,data.ROW_SUBSCRIPTION_ID,index,1);
			  if (data.ROW_SUBSCRIPTION_NAME != null) fillArrayField('row_subscription_name',data.ROW_SUBSCRIPTION_NAME,data.ROW_SUBSCRIPTION_NAME,index,1);
			  if (data.ROW_ASSETP_ID != null) fillArrayField('row_assetp_id',data.ROW_ASSETP_ID,data.ROW_ASSETP_ID,index,1);
			  if (data.ROW_ASSETP_NAME != null) fillArrayField('row_assetp_name',data.ROW_ASSETP_NAME,data.ROW_ASSETP_NAME,index,1);
			  if (data.ROW_BSMV_RATE != null) fillArrayField('row_bsmv_rate',Number(data.ROW_BSMV_RATE),Number(data.ROW_BSMV_RATE),index,1);
			  if (data.ROW_VOLUME != null) fillArrayField('row_volume',Number(data.ROW_VOLUME),Number(data.ROW_VOLUME),index,1);
			  if (data.ROW_BSMV_AMOUNT != null) fillArrayField('row_bsmv_amount',Number(data.ROW_BSMV_AMOUNT),Number(data.ROW_BSMV_AMOUNT),index,1);
			  if (data.ROW_BSMV_CURRENCY != null) fillArrayField('row_bsmv_currency',Number(data.ROW_BSMV_CURRENCY),Number(data.ROW_BSMV_CURRENCY),index,1);
			  if (data.ROW_OIV_RATE != null) fillArrayField('row_oiv_rate',Number(data.ROW_OIV_RATE),Number(data.ROW_OIV_RATE),index,1);
			  if (data.ROW_OIV_AMOUNT != null) fillArrayField('row_oiv_amount',Number(data.ROW_OIV_AMOUNT),Number(data.ROW_OIV_AMOUNT),index,1);
			  if (data.ROW_TEVKIFAT_RATE != null) fillArrayField('row_tevkifat_rate',Number(data.ROW_TEVKIFAT_RATE),Number(data.ROW_TEVKIFAT_RATE),index,1);
			  if (data.ROW_TEVKIFAT_AMOUNT != null) fillArrayField('row_tevkifat_amount',Number(data.ROW_TEVKIFAT_AMOUNT),Number(data.ROW_TEVKIFAT_AMOUNT),index,1);
		  }
		  
		  //Bu fonksiyon ekrana yüklenen inputların içlerini dolduruyor.
		  function showBasketItems(e){
			  timeDelay('timeInput');
			  if (e != null && $(e.target).attr("id") == "btnNext") 
			  {
				  //window.basket.scrollIndex = Math.min(window.basket.items.length - window.basket.pageSize, window.basket.scrollIndex + window.basket.pageSize);
				  //console.log(parseFloat($("#basket_main_div #pageNumber").val())*window.basket.pageSize);
				  window.basket.scrollIndex = parseFloat($("#basket_main_div #pageNumber").val())*window.basket.pageSize;
				  $("#basket_main_div #pageNumber").val(parseFloat($("#basket_main_div #pageNumber").val())+1);
			  }
			  if (e != null && $(e.target).attr("id") == "btnPrev") 
			  {
				  window.basket.scrollIndex = Math.max(0, window.basket.scrollIndex - window.basket.pageSize);
				  $("#basket_main_div #pageNumber").val(parseFloat($("#basket_main_div #pageNumber").val())-1);
			  }
			  if (e != null && $(e.target).attr("id") == "btnFirst")
			  { 
				  window.basket.scrollIndex = 0;
				  $("#basket_main_div #pageNumber").val(1);
			  }
			  if (e != null && $(e.target).attr("id") == "btnLast")
			  {
				  //window.basket.scrollIndex = window.basket.items.length - window.basket.pageSize;
				  if(window.basket.items.length % window.basket.pageSize == 0)
				  {
					  window.basket.scrollIndex = (Math.floor(window.basket.items.length / window.basket.pageSize)-1) * window.basket.pageSize;
					  $("#basket_main_div #pageNumber").val(Math.floor(window.basket.items.length / window.basket.pageSize));
				  }
				  else
				  {
					  window.basket.scrollIndex = (Math.floor(window.basket.items.length / window.basket.pageSize)) * window.basket.pageSize;
					  $("#basket_main_div #pageNumber").val(Math.floor(window.basket.items.length / window.basket.pageSize)+1);
				  }
				  
				  //window.basket.scrollIndex = (Math.floor(window.basket.items.length / window.basket.pageSize)-1) * window.basket.pageSize;
				  
			  }
			  
			  if((window.basket.scrollIndex+window.basket.pageSize) >= window.basket.items.length)
				  $("#btnNext, #btnLast").attr('disabled', 'disabled');
			  else
				  $("#btnNext, #btnLast").removeAttr("disabled");
				  
			  if(window.basket.scrollIndex == 0)
				  $("#btnPrev, #btnFirst").attr('disabled', 'disabled');
			  else
				  $("#btnPrev, #btnFirst").removeAttr("disabled");
			  
			  // sıfırla
			  $("#tblBasket tr[basketItem]").remove();
			  
			  // satırları bas
			  for (var i = window.basket.scrollIndex; i < Math.min(window.basket.items.length, window.basket.scrollIndex + window.basket.pageSize); i++){
				  $("#tblBasket").append($("#basketItemBase").html());
				  var item = $("#tblBasket tr[basketItem]").last();
				  var data = window.basket.items[i];
				  //console.log(data);
				  $(item).attr("itemIndex", i);
				  $(item).find("#rowNr").after('<input type="hidden" id="wrk_row_relation_id" name="wrk_row_relation_id" value="'+data.WRK_ROW_RELATION_ID+'">');
				  $(item).find("#rowNr").after('<input type="hidden" id="wrk_row_id" name="wrk_row_id" value="'+data.WRK_ROW_ID+'">');
				  $(item).find("#rowNr").after('<input type="hidden" id="row_ship_id" name="row_ship_id" value="'+data.ROW_SHIP_ID+'">');
				  $(item).find("#rowNr").text(i + 1);
				  $(item).find("#copy_basket_row_id").attr("onclick",'copy_basket_row('+i+')');
				  $(item).find("#update_icon").attr("onclick",'control_comp_selected('+i+')');
				  <cfsavecontent variable="delete_product"><cf_get_lang dictionary_id='57683.Ürünü Silmek İstediğinizden Emin misiniz'></cfsavecontent>
				  $(item).find("#basket_delete_list_href").attr("onclick",'if (confirm("<cfoutput>#delete_product#</cfoutput>")) clear_related_rows('+i+'); else return;');
				   <cfif listfind("11,12,47,48,1,20,2,18,31,32,11,15,17,47,49,10,14",attributes.basket_id,",") and ((isdefined("attributes.event") and (attributes.event is 'add' or attributes.event is 'upd') ) or not isdefined("attributes.event"))>
				 
				  if(data.IS_SERIAL_NO == 1){
						  $(item).find("#update_icon").parents('ul').append('<li><a href="javascript://" onClick="add_seri_no('+i+');"><i class="fa fa-barcode" alt="Seri No Eklemek İçin Tıklayınız"></i></a></li>');
					  }
				  </cfif>				
				  if(listfind(display_list,'product_name') != -1 && data.WRK_ROW_RELATION_ID)
					  $(item).find("#update_icon").css('display','none');
				  
				  if(window.basket.hidden_values.session_ep_admin == 1 || !(listfind('4,6',window.basket.hidden_values.basket_id) != -1 && window.basket.items[i].ORDER_CURRENCY && (listfind('-3,-8',window.basket.items[i].ORDER_CURRENCY) != -1 || (window.basket.items[i].ORDER_CURRENCY == -5 && window.basket.hidden_values.is_basket_readonly != 0))))
				  {
					  <cfoutput><cfsavecontent variable="delete_product"><cf_get_lang dictionary_id='57683.Ürünü Silmek İstediğinizden Emin misiniz'></cfsavecontent></cfoutput>
					  $(item).find("#basket_delete_list_href").css("display=''");
					  $(item).find("#basket_delete_list_href").attr("onclick","if(confirm('<cfoutput>#delete_product#</cfoutput>')) clear_related_rows("+i+");  else return;");
				  }
				  else
					  $(item).find("#basket_delete_list_href").css("display='none'");
  
				  <cfif listFindNoCase('4,6', attributes.basket_id) and session.ep.admin neq 1>
					  if( data.ORDER_CURRENCY == -3 || data.ORDER_CURRENCY == -8){
						  $(item).find("#basket_delete_list_href").css('display','none');
						  $(item).find("#copy_basket_row_id").css('display','none');
						  $(item).find("#update_icon").css('display','none');
					  }
				  </cfif>
				  
				  if (data.STOCK_CODE != null)
					  fillArrayField('stock_code',data.STOCK_CODE,data.STOCK_CODE,i);
				  if (data.BARCODE != null)
					  fillArrayField('Barcod',data.BARCODE,data.BARCODE,i);
				  if (data.SPECIAL_CODE != null)
					  fillArrayField('special_code',data.SPECIAL_CODE,data.SPECIAL_CODE,i);
				  if (data.MANUFACT_CODE != null)
					  fillArrayField('manufact_code',data.MANUFACT_CODE,data.MANUFACT_CODE,i);
				  if (data.PRODUCT_NAME != null)
				  {
					  fillArrayField('product_name',data.PRODUCT_NAME,data.PRODUCT_NAME,i);
					  $(item).find("#product_name").attr("title",data.PRODUCT_NAME);
					  $(item).find("#product_name").after('<input type="hidden" id="product_id" name="product_id" value="'+data.PRODUCT_ID+'">');
					  //JS yukaridan asagi okudugu icin siralama bu sekilde olmalidir.
					  <cfif isdefined("session.ep.user_level") and get_module_user(5)>
						  $(item).find("#product_name").after('<span class="input-group-addon" id="product_price_history" onclick="open_product_price_history('+i+')"><i class="fa fa-history" title="<cf_get_lang dictionary_id='57721.Ürün Fiyat Tarihçe'>"></i></span>');
					  </cfif>
					  $(item).find("#product_name").after('<span class="input-group-addon" id="product_popup" onclick="open_product_popup('+i+')"><i class="fa fa-ellipsis-v" title="<cf_get_lang dictionary_id='57720.Ürün Detayları İçin Tıklayınız'>"></i></span>');
				  }
				  if (data.AMOUNT != null)
					  if(data.ROW_UNIQUE_RELATION_ID.length != 0)
						  $(item).find("#Amount").attr("readonly","true");						
					  fillArrayField('Amount',data.AMOUNT,commaSplit(data.AMOUNT,amount_round),i); // Array'de virgüllü ifade olmadığı için TLFormat ile yazdırmıyoruz.
				  if (data.UNIT != null)
					  fillArrayField('Unit',data.UNIT,data.UNIT,i);
				  if (data.PRODUCT_NAME_OTHER != null)
					  fillArrayField('product_name_other',data.PRODUCT_NAME_OTHER,data.PRODUCT_NAME_OTHER,i);
  
				  if (data.CONTAINER_NUMBER != null)
					  fillArrayField('container_number',data.CONTAINER_NUMBER,data.CONTAINER_NUMBER,i);
  
				  if (data.CONTAINER_QUANTITY != null)
					  fillArrayField('container_quantity',data.CONTAINER_QUANTITY,data.CONTAINER_QUANTITY,i);
				  if (data.DELIVERY_COUNTRY != null)
					  fillArrayField('delivery_country',data.DELIVERY_COUNTRY,data.DELIVERY_COUNTRY,i);
				  if (data.DELIVERY_CITY != null)
					  fillArrayField('delivery_city',data.DELIVERY_CITY,data.DELIVERY_CITY,i);
				  if (data.DELIVERY_COUNTY != null)
					  fillArrayField('delivery_county',data.DELIVERY_COUNTY,data.DELIVERY_COUNTY,i);
				  if (data.GTIP_NUMBER != null)
					  fillArrayField('gtip_number',data.GTIP_NUMBER,data.GTIP_NUMBER,i);
  
				  if (data.AMOUNT_OTHER != null)
					  fillArrayField('amount_other',data.AMOUNT_OTHER,commaSplit(wrk_round(data.AMOUNT_OTHER),amount_round),i);
				  if (data.UNIT_OTHER != null) 
				  {
					  $(item).find("#unit_other").html(data.UNIT2_EXTRA);
					  fillArrayField('unit_other',data.UNIT_OTHER,data.UNIT_OTHER,i);
					  
					  if(window.basket.hidden_values.amountReadOnly == 1)
					  {
						  $(item).find("#unit_other").attr('disabled','disabled');
					  }
					  
				  }
				  if (data.SPECT_NAME != null){
					  fillArrayField('spect_name',data.SPECT_NAME,data.SPECT_NAME,i);
					  $(item).find("#spect_name").after('<input type="hidden" id="spect_id" name="spect_id" value="'+data.SPECT_ID+'">');
				  }
				  if (data.SPECT_ID != null) 
				  {
					  fillArrayField('spect_id',data.SPECT_ID,data.SPECT_ID,i);
					  if(data.SPECT_ID != null && data.SPECT_ID != '')
						  $(item).find("#spect_name").after('<cfoutput><span class="input-group-addon" onclick="windowopen(\'#request.self#?fuseaction=objects.popup_detail_spec&is_spec=1&id='+data.SPECT_ID+'\',\'medium\');"><i class="fa fa-ellipsis-v"></i></span></cfoutput>');
						  $(item).find("#spect_name").after('<span class="input-group-addon" onclick="open_spec('+i+');"><i class="fa fa-ellipsis-v"></i></span>');
				  }
				  if(data.BASKET_ROW_DEPARTMENT != null)
					  fillArrayField('basket_row_departman',data.BASKET_ROW_DEPARTMENT,data.BASKET_ROW_DEPARTMENT,i);
				  if (data.LIST_PRICE != null)
					  fillArrayField('List_price',data.LIST_PRICE,commaSplit(data.LIST_PRICE,price_round_number),i);
				  if (data.LIST_PRICE_DISCOUNT != null)
					  fillArrayField('list_price_discount',data.LIST_PRICE_DISCOUNT,commaSplit(data.LIST_PRICE_DISCOUNT),i);
				  if (data.ROW_LASTTOTAL != null && data.AMOUNT != null)
					  fillArrayField('tax_price',data.ROW_LASTTOTAL/data.AMOUNT,commaSplit(data.ROW_LASTTOTAL/data.AMOUNT,price_round_number),i);
				  if (data.PRICE != null)
				  {
					  fillArrayField('Price',data.PRICE,commaSplit(data.PRICE,price_round_number),i);
					  if(data.ROW_UNIQUE_RELATION_ID.length != 0)
						  $(item).find("#Price").attr("readonly","true");
					  //else
					  //	$(item).find("#Price").removeAttr("readonly");
				  }
				  if (data.PRICE_OTHER != null)
					  fillArrayField('price_other',data.PRICE_OTHER,commaSplit(data.PRICE_OTHER,price_round_number),i);
				  if (data.ROW_NETTOTAL != null && data.AMOUNT != null) 
					  fillArrayField('price_net',data.PRICE_NET,commaSplit(data.PRICE_NET,price_round_number),i);
				  if (data.PRICE_NET_DOVIZ != null)
					  fillArrayField('price_net_doviz',data.PRICE_NET_DOVIZ,commaSplit(data.PRICE_NET_DOVIZ,price_round_number),i);
				  if (data.OTV_DISCOUNT != null)
					  fillArrayField('otv_discount',data.OTV_DISCOUNT,commaSplit(data.OTV_DISCOUNT,price_round_number),i);
				  if (data.TAX_PERCENT != null) 
					  fillArrayField('Tax',data.TAX_PERCENT,commaSplit(data.TAX_PERCENT,0),i);
				  if (data.OTV_ORAN != null)
					  fillArrayField('OTV',data.OTV_ORAN,commaSplit(data.OTV_ORAN,price_round_number),i);
				  if (data.DUEDATE != null)
					  fillArrayField('duedate',data.DUEDATE,data.DUEDATE,i);
				  if (data.NUMBER_OF_INSTALLMENT != null)
					  fillArrayField('number_of_installment',data.NUMBER_OF_INSTALLMENT,commaSplit(data.NUMBER_OF_INSTALLMENT,0),i);
				  if (data.ISKONTO_TUTAR != null)
					  fillArrayField('iskonto_tutar',data.ISKONTO_TUTAR,commaSplit(data.ISKONTO_TUTAR,price_round_number),i);
				  if (data.EK_TUTAR != null)
					  fillArrayField('ek_tutar',data.EK_TUTAR,commaSplit(data.EK_TUTAR,price_round_number),i);
				  if (data.EK_TUTAR_PRICE != null)
					  fillArrayField('ek_tutar_price',data.EK_TUTAR_PRICE,commaSplit(data.EK_TUTAR_PRICE,price_round_number),i);
				  if (data.EK_TUTAR_OTHER_TOTAL != null)
					  fillArrayField('ek_tutar_other_total',data.EK_TUTAR_OTHER_TOTAL,commaSplit(data.EK_TUTAR_OTHER_TOTAL,price_round_number),i);
				  if (data.EK_TUTAR_COST != null)
					  fillArrayField('ek_tutar_cost',data.EK_TUTAR_COST,commaSplit(data.EK_TUTAR_COST,price_round_number),i);
				  if (data.EK_TUTAR_MARJ != null)
					  fillArrayField('ek_tutar_marj',data.EK_TUTAR_MARJ,commaSplit(data.EK_TUTAR_MARJ,2),i);
				  if (data.INDIRIM1 != null)
					  fillArrayField('indirim1',data.INDIRIM1,commaSplit(data.INDIRIM1,2),i);
				  if (data.INDIRIM2 != null)
					  fillArrayField('indirim2',data.INDIRIM2,commaSplit(data.INDIRIM2,2),i);
				  if (data.INDIRIM3 != null)
					  fillArrayField('indirim3',data.INDIRIM3,commaSplit(data.INDIRIM3,2),i);
				  if (data.INDIRIM4 != null)
					  fillArrayField('indirim4',data.INDIRIM4,commaSplit(data.INDIRIM4,2),i);
				  if (data.INDIRIM5 != null)
					  fillArrayField('indirim5',data.INDIRIM5,commaSplit(data.INDIRIM5,2),i);
				  if (data.INDIRIM6 != null)
					  fillArrayField('indirim6',data.INDIRIM6,commaSplit(data.INDIRIM6,2),i);
				  if (data.INDIRIM7 != null)
					  fillArrayField('indirim7',data.INDIRIM7,commaSplit(data.INDIRIM7,2),i);
				  if (data.INDIRIM8 != null)
					  fillArrayField('indirim8',data.INDIRIM8,commaSplit(data.INDIRIM8,2),i);
				  if (data.INDIRIM9 != null)
					  fillArrayField('indirim9',data.INDIRIM9,commaSplit(data.INDIRIM9,2),i);
				  if (data.INDIRIM10 != null)
					  fillArrayField('indirim10',data.INDIRIM10,commaSplit(data.INDIRIM10,2),i);
				  if (data.ROW_TOTAL != null)
					  fillArrayField('row_total',data.ROW_TOTAL,commaSplit(data.ROW_TOTAL,price_round_number),i);
				  if (data.ROW_NETTOTAL != null)
					  fillArrayField('row_nettotal',data.ROW_NETTOTAL,commaSplit(data.ROW_NETTOTAL,price_round_number),i);
				  if (data.ROW_TAXTOTAL != null)
					  fillArrayField('row_taxtotal',data.ROW_TAXTOTAL,commaSplit(data.ROW_TAXTOTAL,price_round_number),i);
				  if (data.ROW_OTVTOTAL != null)
					  fillArrayField('row_otvtotal',data.ROW_OTVTOTAL,commaSplit(data.ROW_OTVTOTAL,price_round_number),i);
				  if (data.ROW_LASTTOTAL != null)
					  fillArrayField('row_lasttotal',data.ROW_LASTTOTAL,commaSplit(data.ROW_LASTTOTAL,price_round_number),i);
  
  
				  if (data.OTHER_MONEY != null)
				  {
					  fillArrayField('other_money',data.OTHER_MONEY,data.OTHER_MONEY,i);
					  data.OTHER_MONEY_OPTIONS = "";
					  <cfoutput>
						  <cfloop query="get_money_bskt">
							  if('#money_type#' == data.OTHER_MONEY)
								  data.OTHER_MONEY_OPTIONS = data.OTHER_MONEY_OPTIONS + '<option value="#money_type#" selected="selected">#money_type#</option>'
							  else
								  data.OTHER_MONEY_OPTIONS = data.OTHER_MONEY_OPTIONS + '<option value="#money_type#">#money_type#</option>'
						  </cfloop>
					  </cfoutput>	
				  }
				  $(item).find("#other_money").html(data.OTHER_MONEY_OPTIONS);
				  
				  if (data.OTHER_MONEY_VALUE != null)
					  fillArrayField('other_money_value',data.OTHER_MONEY_VALUE,commaSplit(data.OTHER_MONEY_VALUE,price_round_number),i);
					  
				  if (data.OTHER_MONEY_GROSSTOTAL != null)
					  fillArrayField('other_money_gross_total',data.OTHER_MONEY_GROSSTOTAL,commaSplit(data.OTHER_MONEY_GROSSTOTAL,price_round_number),i);
				  if (data.DELIVER_DATE != null)
				  {
					  fillArrayField('deliver_date',data.DELIVER_DATE,data.DELIVER_DATE,i);
					  $(item).find("#deliver_date").after('<span class="input-group-addon" onclick="get_basket_date_deliver(\'deliver_date\',('+i+'));"><i class="fa fa-ellipsis-v" id="deliver_date_image"></i></span>');
				  }
				  if (data.RESERVE_DATE != null)
				  {
					  fillArrayField('reserve_date',data.RESERVE_DATE,data.RESERVE_DATE,i);
					  $(item).find("#reserve_date").after('<span class="input-group-addon" onclick="get_basket_date_reserve(\'reserve_date\',('+i+'));"><i class="fa fa-ellipsis-v" id="reserve_date_image"></i></span>');
				  }
				  if (data.DELIVER_DEPT != null)
					  fillArrayField('deliver_dept',data.DELIVER_DEPT,data.DELIVER_DEPT,i);
				  if (data.DEPT_HEAD != null)
				  {
					  fillArrayField('basket_row_departman',data.DEPT_HEAD,data.DEPT_HEAD,i);
					  $(item).find("#basket_row_departman").after('<input type="hidden" id="deliver_dept" name="deliver_dept" value="'+data.DELIVER_DEPT+'">');
				  }
				  if (data.SHELF_NUMBER != null)
				  {
					  fillArrayField('shelf_number_txt',data.SHELF_NUMBER_TXT,data.SHELF_NUMBER_TXT,i);	
					  $(item).find("#shelf_number_txt").after('<span class="input-group-addon" onclick="open_shelf_list('+i+','+i+',0,\'shelf_number\',\'shelf_number_txt\');"><i class="fa fa-info" title="<cf_get_lang dictionary_id ='30001.Raf Bilgisi'>"></i></span> <span class="input-group-addon"onclick="open_shelf_list('+i+','+i+',1,\'shelf_number\',\'shelf_number_txt\');"><i class="fa fa-ellipsis-v" title="<cf_get_lang dictionary_id ='30002.Raf Dağılım'>"></i></span>');
					  $(item).find("#shelf_number_txt").after('<input type="hidden" id="shelf_number" name="shelf_number" value="'+data.SHELF_NUMBER+'">');
				  }
				  if (data.TO_SHELF_NUMBER != null)
				  {
					  fillArrayField('to_shelf_number_txt',data.TO_SHELF_NUMBER_TXT,data.TO_SHELF_NUMBER_TXT,i);
					  $(item).find("#to_shelf_number_txt").after('<input type="hidden" id="to_shelf_number" name="to_shelf_number" value="'+data.TO_SHELF_NUMBER+'">');
				  }
				  if (data.PBS_CODE != null)
				  {
					  fillArrayField('pbs_code',data.PBS_CODE,data.PBS_CODE,i);
					  $(item).find("#pbs_code").after('<span class="input-group-addon" onclick="open_pbs_list('+i+','+i+',0,\'pbs_id\',\'pbs_code\');" ><i class="fa fa-ellipsis-v" title="PBS"></i></span>');
					  $(item).find("#pbs_code").after('<input type="hidden" id="pbs_id" name="pbs_id" value="'+data.PBS_ID+'">');
				  }
				  if (data.LOT_NO != null)
				  {
					  fillArrayField('lot_no',data.LOT_NO,data.LOT_NO,i);
					  $(item).find("#lot_no").after('<span class="input-group-addon" onclick="open_lot_no_list('+i+','+i+',0,\'lot_no\');" ><i class="fa fa-ellipsis-v" title="PBS"></i></span>');
				  }					
				  if (data.NET_MALIYET != null)
					  fillArrayField('net_maliyet',data.NET_MALIYET,commaSplit(data.NET_MALIYET,price_round_number),i);
				  if (data.EXTRA_COST != null)
					  fillArrayField('extra_cost',data.EXTRA_COST,commaSplit(data.EXTRA_COST,price_round_number),i);
				  if (data.EXTRA_COST_RATE != null)
					  fillArrayField('extra_cost_rate',data.EXTRA_COST_RATE,commaSplit(data.EXTRA_COST_RATE,2),i);
				  if (data.ROW_COST_TOTAL != null)
					  fillArrayField('row_cost_total',data.ROW_COST_TOTAL,commaSplit(data.ROW_COST_TOTAL,price_round_number),i);
				  if (data.MARJ != null)
				  {
					  fillArrayField('marj',data.MARJ,commaSplit(data.MARJ,2),i);
				  }
				  if (data.DARA != null)
					  fillArrayField('dara',data.DARA,commaSplit(data.DARA,amount_round),i);
				  if (data.DARALI != null)
					  fillArrayField('darali',data.DARALI,commaSplit(data.DARALI,amount_round),i);
				  if (data.PROMOSYON_YUZDE != null)
					  fillArrayField('promosyon_yuzde',data.PROMOSYON_YUZDE,commaSplit(data.PROMOSYON_YUZDE,2),i);
				  if (data.PROMOSYON_MALIYET != null)
					  fillArrayField('promosyon_maliyet',data.PROMOSYON_MALIYET,commaSplit(data.PROMOSYON_MALIYET,price_round_number),i);
				  if (data.RESERVE_TYPE != null)
				  {
					  fillArrayField('reserve_type',data.RESERVE_TYPE,data.RESERVE_TYPE,i);
					  data.RESERVE_TYPE_LIST = "";
					  
					  <cfset current_row = 1>
					  <cfoutput>
						  data.RESERVE_TYPE_LIST = '<option value"">#getLang("main",322)#</option>';
						  <cfloop list="#reserve_type_list#" index="info_list">
							  if('#-1*current_row#' == data.RESERVE_TYPE)
								  data.RESERVE_TYPE_LIST = data.RESERVE_TYPE_LIST + '<option value="#-1*current_row#" selected="selected">#ListGetAt(reserve_type_list,current_row,",")#</option>'
							  else
								  data.RESERVE_TYPE_LIST = data.RESERVE_TYPE_LIST + '<option value="#-1*current_row#">#ListGetAt(reserve_type_list,current_row,",")#</option>'
						  <cfset current_row++>
						  </cfloop>
					  </cfoutput>
				  }
				  $(item).find("#reserve_type").html(data.RESERVE_TYPE_LIST);
  
				  if (data.DELIVERY_CONDITION != null)
				  {
					  fillArrayField('delivery_condition',data.DELIVERY_CONDITION,data.DELIVERY_CONDITION,i);
				  }
				  $(item).find("#delivery_condition").html(data.DELIVERY_CONDITION_INFO_);
					  fillArrayField('delivery_condition',data.DELIVERY_CONDITION,data.DELIVERY_CONDITION,i);
  
				  if (data.CONTAINER_TYPE != null)
				  {
					  fillArrayField('container_type',data.CONTAINER_TYPE,data.CONTAINER_TYPE,i);
					  data.CONTAINER_TYPE_INFO_ = "";
					  
					  <cfoutput>
						  data.CONTAINER_TYPE_INFO_ = '<option value"">#getLang("main",322)#</option>';
						  <cfloop query="container_type">
							  if('#container_type.code#' == data.CONTAINER_TYPE)
								  data.CONTAINER_TYPE_INFO_ = data.CONTAINER_TYPE_INFO_ + '<option value="#container_type.code#" selected="selected">#container_type.code#-#container_type.name#</option>'
							  else
								  data.CONTAINER_TYPE_INFO_ = data.CONTAINER_TYPE_INFO_ + '<option value="#container_type.code#">#container_type.code#-#container_type.name#</option>'
						  </cfloop>
					  </cfoutput>
				  }
				  $(item).find("#container_type").html(data.CONTAINER_TYPE_INFO_);
  
				  if (data.BASKET_EMPLOYEE != null)
				  {
					  fillArrayField('basket_employee',data.BASKET_EMPLOYEE,data.BASKET_EMPLOYEE,i);
					  $(item).find("#basket_employee").after('<input type="hidden" id="basket_employee_id" name="basket_employee_id" value="'+data.BASKET_EMPLOYEE_ID+'">');
					  $(item).find("#basket_employee").after('<span class="input-group-addon" onclick="open_basket_employee_popup('+i+');"><i class="fa fa-ellipsis-v"></i></span>');
				  }
				  if (data.ROW_WIDTH != null)
					  fillArrayField('row_width',data.ROW_WIDTH,commaSplit(data.ROW_WIDTH,2),i);
				  if (data.ROW_DEPTH != null)
					  fillArrayField('row_depth',data.ROW_DEPTH,commaSplit(data.ROW_DEPTH,2),i);
				  if (data.ROW_HEIGHT != null)
					  fillArrayField('row_height',data.ROW_HEIGHT,commaSplit(data.ROW_HEIGHT,2),i);
				  if (data.BASKET_PROJECT != null)
					  fillArrayField('basket_project',data.BASKET_PROJECT,data.BASKET_PROJECT,i);
				  if (data.ROW_PROJECT_NAME != null && data.ROW_PROJECT_ID != null)
				  {
					  fillArrayField('row_project_name',data.ROW_PROJECT_NAME,data.ROW_PROJECT_NAME,i);
				  }
				  $(item).find("#row_project_name").after('<span class="input-group-addon" onclick="open_basket_project_popup('+i+');"><i class="fa fa-ellipsis-v"></i></span>');
				  $(item).find("#row_project_name").after('<input type="hidden" id="row_project_id" name="row_project_id" value="'+data.ROW_PROJECT_ID+'">');
				  
				  if (data.ROW_WORK_ID != null && data.ROW_WORK_NAME != null)
				  {
					  fillArrayField('row_work_name',data.ROW_WORK_NAME,data.ROW_WORK_NAME,i);
				  }
  
				  $(item).find("#row_work_name").after('<span class="input-group-addon" onclick="open_basket_work_popup('+i+');"><i class="fa fa-ellipsis-v"></i></span>');
				  $(item).find("#row_work_name").after('<input type="hidden" id="row_work_id" name="row_work_id" value="'+data.ROW_WORK_ID+'">');
				  
				  if(data.ROW_EXP_CENTER_ID != null){
					  fillArrayField('basket_exp_center',data.ROW_EXP_CENTER_NAME,data.ROW_EXP_CENTER_NAME,i);
				  }
  
				  $(item).find("#basket_exp_center").after('<span class="input-group-addon" onclick="open_basket_exp_center_popup('+i+');"><i class="fa fa-ellipsis-v"></i></span>');
				  $(item).find("#basket_exp_center").after('<input type="hidden" id="basket_exp_center_id" name="basket_exp_center_id" value="'+data.ROW_EXP_CENTER_ID+'">');
				  
				  //row_activity_id
				  
				  if (data.ROW_ACTIVITY_ID != null)
				  {
					  data.ROW_ACTIVITY_ID_INFO_ = "";
					  
					  <cfoutput>
						  data.ROW_ACTIVITY_ID_INFO_ = '<option value="">#getLang("main",322)#</option>';
						  <cfloop query="getActivity">
							  if('#ACTIVITY_ID#' == data.ROW_ACTIVITY_ID)
								  data.ROW_ACTIVITY_ID_INFO_ = data.ROW_ACTIVITY_ID_INFO_ + '<option value="#ACTIVITY_ID#" selected="selected">#ACTIVITY_NAME#</option>'
							  else
								  data.ROW_ACTIVITY_ID_INFO_ = data.ROW_ACTIVITY_ID_INFO_ + '<option value="#ACTIVITY_ID#">#ACTIVITY_NAME#</option>'
						  </cfloop>
					  </cfoutput>
				  }
				  $(item).find("#row_activity_id").html(data.ROW_ACTIVITY_ID_INFO_);
  
				  //row_activity_id
  
				  //row_subscription_id
				  if(data.ROW_SUBSCRIPTION_ID != null && data.ROW_SUBSCRIPTION_NAME != null){
					  fillArrayField('row_subscription_id',data.ROW_SUBSCRIPTION_ID,data.ROW_SUBSCRIPTION_ID,i);
					  fillArrayField('row_subscription_name',data.ROW_SUBSCRIPTION_NAME,data.ROW_SUBSCRIPTION_NAME,i);
				  }
				  $(item).find("#row_subscription_name").after('<span class="input-group-addon" onclick="open_subscription_popup('+i+');"><i class="fa fa-ellipsis-v"></i></span>');
				  $(item).find("#row_subscription_name").after('<input type="hidden" id="row_subscription_id" name="row_subscription_id" value="'+data.ROW_SUBSCRIPTION_ID+'">');
				  
				  //row_assetp_id
				  if(data.ROW_ASSETP_ID != null && data.ROW_ASSETP_NAME != null){
					  fillArrayField('row_assetp_id',data.ROW_ASSETP_ID,data.ROW_ASSETP_ID,i);
					  fillArrayField('row_assetp_name',data.ROW_ASSETP_NAME,data.ROW_ASSETP_NAME,i);
				  }
				  $(item).find("#row_assetp_name").after('<span class="input-group-addon" onclick="open_assetp_popup('+i+');"><i class="fa fa-ellipsis-v"></i></span>');
				  $(item).find("#row_assetp_name").after('<input type="hidden" id="row_assetp_id" name="row_assetp_id" value="'+data.ROW_ASSETP_ID+'">');
  
				  //bsmv, öiv, tevkifat
				  if(data.ROW_BSMV_RATE != null) fillArrayField('row_bsmv_rate',data.ROW_BSMV_RATE,commaSplit(data.ROW_BSMV_RATE, price_round_number),i);
				  if(data.ROW_BSMV_AMOUNT != null) fillArrayField('row_bsmv_amount',data.ROW_BSMV_AMOUNT,commaSplit(data.ROW_BSMV_AMOUNT, price_round_number),i);
				  if(data.ROW_BSMV_CURRENCY != null) fillArrayField('row_bsmv_currency',data.ROW_BSMV_CURRENCY,commaSplit(data.ROW_BSMV_CURRENCY, price_round_number),i);
				  if(data.ROW_OIV_RATE != null) fillArrayField('row_oiv_rate',data.ROW_OIV_RATE,commaSplit(data.ROW_OIV_RATE, price_round_number),i);
				  if(data.ROW_OIV_AMOUNT != null) fillArrayField('row_oiv_amount',data.ROW_OIV_AMOUNT,commaSplit(data.ROW_OIV_AMOUNT, price_round_number),i);
				  if(data.ROW_TEVKIFAT_RATE != null) fillArrayField('row_tevkifat_rate',data.ROW_TEVKIFAT_RATE,commaSplit(data.ROW_TEVKIFAT_RATE, price_round_number),i);
				  if(data.ROW_TEVKIFAT_AMOUNT != null) fillArrayField('row_tevkifat_amount',data.ROW_TEVKIFAT_AMOUNT,commaSplit(data.ROW_TEVKIFAT_AMOUNT, price_round_number),i);
  
				  //basket_exp_item
				  if(data.ROW_EXP_ITEM_ID != null) fillArrayField('basket_exp_item',data.ROW_EXP_ITEM_NAME,data.ROW_EXP_ITEM_NAME,i);
				  $(item).find("#basket_exp_item").after('<span class="input-group-addon" onclick="open_basket_exp_item_popup('+i+');"><i class="fa fa-ellipsis-v"></i></span>');
				  $(item).find("#basket_exp_item").after('<input type="hidden" id="basket_exp_item_id" name="basket_exp_item_id" value="'+data.ROW_EXP_ITEM_ID+'">');
  
				  //basket_acc_code
				  if(data.ROW_ACC_CODE != null) fillArrayField('basket_acc_code',data.ROW_ACC_CODE,data.ROW_ACC_CODE,i);
				  $(item).find("#basket_acc_code").after('<span class="input-group-addon" onclick="open_basket_acc_code_popup('+i+');"><i class="fa fa-ellipsis-v"></i></span>');
  
				  if (data.BASKET_EXTRA_INFO != null)
				  {
					  fillArrayField('basket_extra_info',data.BASKET_EXTRA_INFO,data.BASKET_EXTRA_INFO,i);
					  data.BASKET_EXTRA_INFO_ = "";
					  <cfoutput>
						  <cfloop list="#basket_info_list#" index="info_list">
							  if('#ListFirst(info_list,";")#' == data.BASKET_EXTRA_INFO)
								  data.BASKET_EXTRA_INFO_ = data.BASKET_EXTRA_INFO_ + '<option value="#ListFirst(info_list,";")#" selected="selected">#ListLast(info_list,";")#</option>'
							  else
								  data.BASKET_EXTRA_INFO_ = data.BASKET_EXTRA_INFO_ + '<option value="#ListFirst(info_list,";")#">#ListLast(info_list,";")#</option>'
						  </cfloop>
					  </cfoutput>	
				  }
				  $(item).find("#basket_extra_info").html(data.BASKET_EXTRA_INFO_);
  
				  if (data.SELECT_INFO_EXTRA != null)
				  {
					  fillArrayField('select_info_extra',data.SELECT_INFO_EXTRA,data.SELECT_INFO_EXTRA,i);
					  data.SELECT_INFO_EXTRA_ = "";
					  <cfoutput>
						  <cfloop list="#select_info_extra_list#" index="extra_list">
							  if('#ListFirst(extra_list,";")#' == data.SELECT_INFO_EXTRA)
								  data.SELECT_INFO_EXTRA_ = data.SELECT_INFO_EXTRA_ + '<option value="#ListFirst(extra_list,";")#" selected="selected">#ListLast(extra_list,";")#</option>'
							  else
								  data.SELECT_INFO_EXTRA_ = data.SELECT_INFO_EXTRA_ + '<option value="#ListFirst(extra_list,";")#">#ListLast(extra_list,";")#</option>'
						  </cfloop>
					  </cfoutput>	
				  }
				  $(item).find("#select_info_extra").html(data.SELECT_INFO_EXTRA_);
  
				  if (data.DETAIL_INFO_EXTRA != null)
					  fillArrayField('detail_info_extra',data.DETAIL_INFO_EXTRA,data.DETAIL_INFO_EXTRA,i);
  
				  $(item).find("#to_shelf_number_txt").after('<span class="input-group-addon" onclick="open_shelf_list('+i+','+i+',0,\'to_shelf_number\',\'to_shelf_number_txt\');" ><i class="fa fa-info" title="<cf_get_lang dictionary_id ='30001.Raf Bilgisi'>"></i></span>');
				  $(item).find("#basket_row_departman").after('<span class="input-group-addon" onclick="open_basket_locations('+i+');"><i class="fa fa-ellipsis-v"></i></span>');
				  if (data.ORDER_CURRENCY != null)
				  {
					  fillArrayField('order_currency',data.ORDER_CURRENCY,data.ORDER_CURRENCY,i);
					  data.ORDER_CURRENCY_LIST = "";
					  
					  <cfset current_row = 1>
					  <cfoutput>
						  data.ORDER_CURRENCY_LIST = '<option value"">#getLang("main",322)#</option>';
						  <cfloop list="#order_currency_list#" index="info_list">
							  if('#-1*current_row#' == data.ORDER_CURRENCY)
								  data.ORDER_CURRENCY_LIST = data.ORDER_CURRENCY_LIST + "<option value='#-1*current_row#' selected='selected'>#ListGetAt(order_currency_list,current_row,',')#</option>"
							  else
								  data.ORDER_CURRENCY_LIST = data.ORDER_CURRENCY_LIST + "<option value='#-1*current_row#'>#ListGetAt(order_currency_list,current_row,',')#</option>"
						  <cfset current_row++>
						  </cfloop>
					  </cfoutput>
				  }
				  $(item).find("#order_currency").html(data.ORDER_CURRENCY_LIST);	
  
				  if (data.REASON_CODE != null)
				  {
					  fillArrayField('reason_code',data.REASON_CODE,data.REASON_CODE,i);
					  data.REASON_CODE_INFO_ = "";
					  <cfoutput>
						  <cfloop list="#reason_code_list#" index="info_list" delimiters="*">
							  if('#listlast(info_list,"*")#' == data.REASON_CODE)
								  data.REASON_CODE_INFO_ = data.REASON_CODE_INFO_ + '<option value="#listlast(info_list,"*")#" selected="selected">#listlast(info_list,"*")#</option>'
							  else
								  data.REASON_CODE_INFO_ = data.REASON_CODE_INFO_ + '<option value="#listlast(info_list,"*")#">#listlast(info_list,"*")#</option>'
						  </cfloop>
					  </cfoutput>
				  }
				  $(item).find("#reason_code").html(data.REASON_CODE_INFO_);

					if (data.OTV_TYPE != null)
					{
						fillArrayField('otv_type',data.OTV_TYPE,data.OTV_TYPE,i);
						data.OTV_TYPE_INFO_ = "";
						selected_ = data.OTV_TYPE == 0 ? 'selected' : '';
						data.OTV_TYPE_INFO_ = data.OTV_TYPE_INFO_ + '<option value="0"' + selected_ + '>İndirim Yok</option>';
						selected_ = data.OTV_TYPE == 1 ? 'selected' : '';
						data.OTV_TYPE_INFO_ = data.OTV_TYPE_INFO_ + '<option value="1"' + selected_ + '>Tam İndirim</option>';
					}
					$(item).find("#otv_type").html(data.OTV_TYPE_INFO_);
  
				  if (data.DELIVERY_CONDITION != null)
				  {
					  fillArrayField('delivery_condition',data.DELIVERY_CONDITION,data.DELIVERY_CONDITION,i);
					  data.DELIVERY_CONDITION_INFO_ = '<option value""><cfoutput>#getLang("main",322)#</cfoutput></option>';
					  <cfoutput>
						  <cfloop query="delivery_condition">
							  if('#delivery_condition.code#' == data.DELIVERY_CONDITION)
								  data.DELIVERY_CONDITION_INFO_ = data.DELIVERY_CONDITION_INFO_ + '<option value="#delivery_condition.code#" selected="selected">#delivery_condition.code#-#delivery_condition.name#</option>'
							  else
								  data.DELIVERY_CONDITION_INFO_ = data.DELIVERY_CONDITION_INFO_ + '<option value="#delivery_condition.code#">#delivery_condition.code#-#delivery_condition.name#</option>'
						  </cfloop>
					  </cfoutput>
				  }
				  $(item).find("#delivery_condition").html(data.DELIVERY_CONDITION_INFO_);
				  
				  if (data.DELIVERY_TYPE != null)
				  {
					  fillArrayField('delivery_type',data.DELIVERY_TYPE,data.DELIVERY_TYPE,i);
					  data.DELIVERY_TYPE_INFO_ = '<option value""><cfoutput>#getLang("main",322)#</cfoutput></option>';
					  <cfoutput>
						  <cfloop query="delivery_type">
							  if('#delivery_type.code#' == data.DELIVERY_TYPE)
								  data.DELIVERY_TYPE_INFO_ = data.DELIVERY_TYPE_INFO_ + '<option value="#delivery_type.code#" selected="selected">#delivery_type.code#-#delivery_type.name#</option>'
							  else
								  data.DELIVERY_TYPE_INFO_ = data.DELIVERY_TYPE_INFO_ + '<option value="#delivery_type.code#">#delivery_type.code#-#delivery_type.name#</option>'
						  </cfloop>
					  </cfoutput>
				  }
				  $(item).find("#delivery_type").html(data.DELIVERY_TYPE_INFO_);
				  
				  if( (listfind(extra_basket_hidden_list_, "Price") == -1) || (window.basket.items[i].ROW_UNIQUE_RELATION_ID.length))
					  $(item).find("#Price").after('<span class="input-group-addon" onclick="open_price('+i+')"><i class="fa fa-ellipsis-v" title="<cf_get_lang dictionary_id='57722.Farklı Ürün Fiyatı Seçmek İçin Tıklayınız'>" id="price_list_image"></i></span>');
								  
				  $(item).find("#Amount , #amount_other, #Price , #price_other, #Tax, #indirim1, #indirim2, #indirim3, #indirim4, #indirim5, #indirim6, #indirim7, #indirim8, #indirim9, #indirim10, #OTV, #duedate, #ek_tutar, #ek_tutar_price, #product_name_other, #lot_no, #container_number, #container_quantity, #delivery_country, #delivery_city, #delivery_county, #gtip_number, #detail_info_extra, #promosyon_yuzde, #row_bsmv_rate, #row_bsmv_amount, #row_bsmv_currency, #row_oiv_rate, #row_oiv_amount, #row_tevkifat_rate, #row_tevkifat_amount,#list_price_discount,#dara,#darali").bind("blur", formatField);
				  $(item).find("#extra_cost, #extra_cost_rate, #ek_tutar_cost").bind("keyup", formatFieldAmount);
				  $(item).find("#tax_price, #row_otvtotal, #row_total, #net_maliyet, #row_taxtotal, #other_money_value, #row_lasttotal, #extra_cost_rate, #net_maliyet, #extra_cost, #iskonto_tutar").bind("blur", formatField);
				  $(item).find("#unit_other, #other_money, #order_currency, #reserve_type, #basket_extra_info,#reason_code,#otv_type,#delivery_condition,#container_type,#delivery_type,#deliver_date,#product_name,#manufact_code,#select_info_extra,#row_activity_id,#basket_exp_center,#basket_exp_item,#basket_acc_code,#row_subscription_name,#row_assetp_name").bind("change", formatField);
				  $(item).find("#row_width, #row_height, #row_depth,#promosyon_maliyet").bind("blur", nonFormatField);
				  $(item).find("#row_project_name, #row_work_name,#shelf_number_txt,#to_shelf_number_txt").bind("blur", checkValue);
				  
				  //$(item).find("input").bind("blur", AmountFormat);
				  $(item).find("#btnDelete").bind("click", deleteBasketItem);
			  }
			  
			  // navigasyon
			  $("#itemCount").text(window.basket.items.length);
			  if(window.basket.items.length % window.basket.pageSize == 0)
				  $("#itemPageCount").text(Math.floor(window.basket.items.length / window.basket.pageSize));
			  else
				  $("#itemPageCount").text(Math.floor(window.basket.items.length / window.basket.pageSize)+1);
			  if (window.basket.items.length > window.basket.pageSize){
				  $("#btnNext, #btnPrev, #btnFirst, #btnLast, #pageNumber").show();
			  } else {
				  $("#btnNext, #btnPrev, #btnFirst, #btnLast, #pageNumber").hide();
			  }
			  timeDelay('timeInput');
  
			  try
			  {
				  end_basket_actions();
			  }
			  catch(e)
			  {
				  //nothing
			  }
			  
		  }
		  
		  function checkValue(e)
		  {
			  rowNumber = Number($(e.target).closest("tr[basketItem]").attr("itemIndex"));
			  fixedRowNumber = rowNumber - window.basket.scrollIndex ;
			  //console.log(fixedRowNumber);
			  switch ($(e.target).attr("id")){
				  case "row_project_name":
				  {
					  if(!$("#tblBasket tr[basketItem]").eq(fixedRowNumber).find("#row_project_name").val())
						  window.basket.items[fixedRowNumber].ROW_PROJECT_NAME = '';
					  break;
				  }
				  case "row_work_name":
				  {
					  if(!$("#tblBasket tr[basketItem]").eq(fixedRowNumber).find("#row_work_name").val())
						  window.basket.items[fixedRowNumber].ROW_WORK_NAME = '';
					  break;
				  }
				  case "shelf_number_txt":
				  {
					  if(!$("#tblBasket tr[basketItem]").eq(fixedRowNumber).find("#shelf_number_txt").val())
						  window.basket.items[fixedRowNumber].SHELF_NUMBER = '';
					  break;
				  }
				  case "to_shelf_number_txt":
				  {
					  if(!$("#tblBasket tr[basketItem]").eq(fixedRowNumber).find("#to_shelf_number_txt").val())
						  window.basket.items[fixedRowNumber].TO_SHELF_NUMBER = '';
					  break;
				  }
			  }
		  }
		  
		  function formatFieldAmount(e)
		  {
			  obj_ = $("#tblBasket tr[basketItem]").eq($(e.target).closest("tr[basketItem]").attr("itemIndex")).find("#"+[$(e.target).attr("id")]);
			  if(window.basket.hidden_values.amount_round == 0)
			  {
				  if(obj_.val().indexOf('.') != -1)
					  obj_.val(left(obj_.val(),obj_.val().length - 1));
				  else if($.isNumeric(obj_.val()) == false)
					  obj_.val(left(obj_.val(),obj_.val().length - 1));
			  }
		  }
		  
		  //Input alanlar icin blur fonksiyonunda calistirilan fonksiyonlar asagida tanimlaniyor.
		  function formatField(e){
			  rowNumber = Number($(e.target).closest("tr[basketItem]").attr("itemIndex"));
			  fixedRowNumber = rowNumber - window.basket.scrollIndex ;
			  
			  if($(e.target).attr("id") == 'OTV')
				  newId = 'OTV_ORAN';
			  else
				  newId = $(e.target).attr("id");
			  
			  var data = 	window.basket.items[rowNumber];
			  try{
				  if(commaSplit(window.basket.items[rowNumber][newId.toUpperCase()],8).indexOf('NaN') != -1)
					  new_value = window.basket.items[rowNumber][newId.toUpperCase()];
				  else
					  new_value = commaSplit(window.basket.items[rowNumber][newId.toUpperCase()],8);
			  }
			  catch(ex){
				  new_value = window.basket.items[rowNumber][newId.toUpperCase()];
			  }
			  window.basket.hidden_values.control_field_value = new_value;
			  
			  switch ($(e.target).attr("id")){
				  case "Amount":
					fillArrayField('Amount',filterNum($("#tblBasket tr[basketItem]").eq(fixedRowNumber).find("#Amount").val(),price_round_number), (amount_round != 0) ? commaSplit($("#tblBasket tr[basketItem]").eq(fixedRowNumber).find("#Amount").val(),amount_round) : $("#tblBasket tr[basketItem]").eq(fixedRowNumber).find("#Amount").val(),rowNumber,1);
					if($("#tblBasket tr[basketItem]").eq(fixedRowNumber).find("#darali").length != 0 && $("#tblBasket tr[basketItem]").eq(fixedRowNumber).find("#dara").length != 0 && list_find('40,41,42,43',window.basket.hidden_values.basket_id)) // hal işlemleri
						dara_miktar_hesabi(rowNumber,3);
					 else
						hesapla('Amount',rowNumber);
					  break;
				 case "dara":
					fillArrayField('dara',filterNum($("#tblBasket tr[basketItem]").eq(fixedRowNumber).find("#dara").val(),price_round_number), (amount_round != 0) ? commaSplit($("#tblBasket tr[basketItem]").eq(fixedRowNumber).find("#dara").val(),amount_round) : $("#tblBasket tr[basketItem]").eq(fixedRowNumber).find("#dara").val(),rowNumber,1);
					dara_miktar_hesabi(rowNumber,3);
				case "darali":
					fillArrayField('darali',filterNum($("#tblBasket tr[basketItem]").eq(fixedRowNumber).find("#darali").val(),price_round_number), (amount_round != 0) ? commaSplit($("#tblBasket tr[basketItem]").eq(fixedRowNumber).find("#darali").val(),amount_round) : $("#tblBasket tr[basketItem]").eq(fixedRowNumber).find("#darali").val(),rowNumber,1);
					dara_miktar_hesabi(rowNumber,3);
				  case "amount_other":
					  fillArrayField('amount_other',filterNum($("#tblBasket tr[basketItem]").eq(fixedRowNumber).find("#amount_other").val(),price_round_number), (amount_round != 0) ? commaSplit($("#tblBasket tr[basketItem]").eq(fixedRowNumber).find("#amount_other").val(),amount_round) : $("#tblBasket tr[basketItem]").eq(fixedRowNumber).find("#amount_other").val(),rowNumber,1);
					  hesapla('amount_other',rowNumber);
					  break;
				  case "Price":
					  fillArrayField('price',filterNum($("#tblBasket tr[basketItem]").eq(fixedRowNumber).find("#Price").val(),price_round_number),commaSplit($("#tblBasket tr[basketItem]").eq(fixedRowNumber).find("#Price").val(),price_round_number),rowNumber,1);
					  if (listfind(display_list, "net_maliyet") != -1 && listfind(display_list, "marj"))
						  marj_maliyet_hesabi(rowNumber,4);
					  else
						  hesapla('Price',rowNumber);
					  break;
				  case "price_other":
					  fillArrayField('price_other',filterNum($("#tblBasket tr[basketItem]").eq(fixedRowNumber).find("#price_other").val(),price_round_number),commaSplit($("#tblBasket tr[basketItem]").eq(fixedRowNumber).find("#price_other").val(),price_round_number),rowNumber,1);
					  hesapla('price_other',rowNumber);
					  break;
				  case "price_net_doviz":
					  fillArrayField('price_net_doviz',filterNum($("#tblBasket tr[basketItem]").eq(fixedRowNumber).find("#price_net_doviz").val(),price_round_number),commaSplit($("#tblBasket tr[basketItem]").eq(fixedRowNumber).find("#price_net_doviz").val(),price_round_number),rowNumber,1);
					  hesapla('price_net_doviz',rowNumber);
					  break;
				  case "Tax":
					  fillArrayField('Tax',Number($("#tblBasket tr[basketItem]").eq(fixedRowNumber).find("#Tax").val()),Number($("#tblBasket tr[basketItem]").eq(fixedRowNumber).find("#Tax").val()),rowNumber,1);
					  hesapla('Tax',rowNumber);
					  break;
				  case "indirim1":
					  fillArrayField('indirim1',filterNum($("#tblBasket tr[basketItem]").eq(fixedRowNumber).find("#indirim1").val()),commaSplit($("#tblBasket tr[basketItem]").eq(fixedRowNumber).find("#indirim1").val(),2),rowNumber,1);
					  hesapla('indirim1',rowNumber);
					  break;
				  case "indirim2":
					  fillArrayField('indirim2',filterNum($("#tblBasket tr[basketItem]").eq(fixedRowNumber).find("#indirim2").val()),commaSplit($("#tblBasket tr[basketItem]").eq(fixedRowNumber).find("#indirim2").val(),2),rowNumber,1);
					  hesapla('indirim2',rowNumber);
					  break;
				  case "indirim3":
					  fillArrayField('indirim3',filterNum($("#tblBasket tr[basketItem]").eq(fixedRowNumber).find("#indirim3").val()),commaSplit($("#tblBasket tr[basketItem]").eq(fixedRowNumber).find("#indirim3").val(),2),rowNumber,1);
					  hesapla('indirim3',rowNumber);
					  break;
				  case "indirim4":
					  fillArrayField('indirim4',filterNum($("#tblBasket tr[basketItem]").eq(fixedRowNumber).find("#indirim4").val()),commaSplit($("#tblBasket tr[basketItem]").eq(fixedRowNumber).find("#indirim4").val(),2),rowNumber,1);
					  hesapla('indirim4',rowNumber);
					  break;
				  case "indirim5":
					  fillArrayField('indirim5',filterNum($("#tblBasket tr[basketItem]").eq(fixedRowNumber).find("#indirim5").val()),commaSplit($("#tblBasket tr[basketItem]").eq(fixedRowNumber).find("#indirim5").val(),2),rowNumber,1);
					  hesapla('indirim5',rowNumber);
					  break;
				  case "indirim6":
					  fillArrayField('indirim6',filterNum($("#tblBasket tr[basketItem]").eq(fixedRowNumber).find("#indirim6").val()),commaSplit($("#tblBasket tr[basketItem]").eq(fixedRowNumber).find("#indirim6").val(),2),rowNumber,1);
					  hesapla('indirim6',rowNumber);
					  break;
				  case "indirim7":
					  fillArrayField('indirim7',filterNum($("#tblBasket tr[basketItem]").eq(fixedRowNumber).find("#indirim7").val()),commaSplit($("#tblBasket tr[basketItem]").eq(fixedRowNumber).find("#indirim7").val(),2),rowNumber,1);
					  hesapla('indirim7',rowNumber);
					  break;
				  case "indirim8":
					  fillArrayField('indirim8',filterNum($("#tblBasket tr[basketItem]").eq(fixedRowNumber).find("#indirim8").val()),commaSplit($("#tblBasket tr[basketItem]").eq(fixedRowNumber).find("#indirim8").val(),2),rowNumber,1);
					  hesapla('indirim8',rowNumber);
					  break;
				  case "indirim9":
					  fillArrayField('indirim9',filterNum($("#tblBasket tr[basketItem]").eq(fixedRowNumber).find("#indirim9").val()),commaSplit($("#tblBasket tr[basketItem]").eq(fixedRowNumber).find("#indirim9").val(),2),rowNumber,1);
					  hesapla('indirim9',rowNumber);
					  break;
				  case "indirim10":
					  fillArrayField('indirim10',filterNum($("#tblBasket tr[basketItem]").eq(fixedRowNumber).find("#indirim10").val()),commaSplit($("#tblBasket tr[basketItem]").eq(fixedRowNumber).find("#indirim10").val(),2),rowNumber,1);
					  hesapla('indirim10',rowNumber);
					  break;
				  case "iskonto_tutar":
					  fillArrayField('iskonto_tutar',filterNum($("#tblBasket tr[basketItem]").eq(fixedRowNumber).find("#iskonto_tutar").val(),price_round_number),commaSplit($("#tblBasket tr[basketItem]").eq(fixedRowNumber).find("#iskonto_tutar").val(),price_round_number),rowNumber,1);
					  hesapla('iskonto_tutar',rowNumber);
					  break;
				  case "other_money":
					  fillArrayField('other_money',$("#tblBasket tr[basketItem]").eq(fixedRowNumber).find("#other_money").find(":selected").val(),$("#tblBasket tr[basketItem]").eq(fixedRowNumber).find("#other_money").val(),rowNumber,1);
					  hesapla('other_money',rowNumber);
					  break;
				  case "unit_other":
					  fillArrayField('unit_other',$("#tblBasket tr[basketItem]").eq(fixedRowNumber).find("#unit_other").val(),$("#tblBasket tr[basketItem]").eq(fixedRowNumber).find("#unit_other").find(":selected").index(),rowNumber,2);
					  hesapla('amount_other',rowNumber);
					  break;
				  case "tax_price":
					  fillArrayField('tax_price',filterNum($("#tblBasket tr[basketItem]").eq(fixedRowNumber).find("#tax_price").val(),price_round_number),commaSplit($("#tblBasket tr[basketItem]").eq(fixedRowNumber).find("#tax_price").val(),price_round_number),rowNumber,1);
					  kdvdahildenhesapla(rowNumber,'tax_price');
					  break;
				  case "OTV":
					  fillArrayField('OTV',filterNum($("#tblBasket tr[basketItem]").eq(fixedRowNumber).find("#OTV").val(),price_round_number),commaSplit($("#tblBasket tr[basketItem]").eq(fixedRowNumber).find("#OTV").val(),price_round_number),rowNumber,1);
					  hesapla('OTV',rowNumber);
					  break;
				  case "row_otvtotal":
					  fillArrayField('row_otvtotal',filterNum($("#tblBasket tr[basketItem]").eq(fixedRowNumber).find("#row_otvtotal").val(),price_round_number),commaSplit($("#tblBasket tr[basketItem]").eq(fixedRowNumber).find("#row_otvtotal").val(),price_round_number),rowNumber,1);
					  hesapla('row_otvtotal',rowNumber);
					  break;
				  case "row_total":
					  fillArrayField('row_total',filterNum($("#tblBasket tr[basketItem]").eq(fixedRowNumber).find("#row_total").val(),price_round_number),commaSplit($("#tblBasket tr[basketItem]").eq(fixedRowNumber).find("#row_total").val(),price_round_number),rowNumber,1);
					  hesapla('row_total',rowNumber);
					  break;
				  case "row_taxtotal":
					  fillArrayField('row_taxtotal',filterNum($("#tblBasket tr[basketItem]").eq(fixedRowNumber).find("#row_taxtotal").val(),price_round_number),commaSplit($("#tblBasket tr[basketItem]").eq(fixedRowNumber).find("#row_taxtotal").val(),price_round_number),rowNumber,1);
					  hesapla('row_taxtotal',rowNumber);
					  break;
				  case "other_money_value":
					  fillArrayField('other_money_value',filterNum($("#tblBasket tr[basketItem]").eq(fixedRowNumber).find("#other_money_value").val(),price_round_number),commaSplit($("#tblBasket tr[basketItem]").eq(fixedRowNumber).find("#other_money_value").val(),price_round_number),rowNumber,1);
					  hesapla('other_money_value',rowNumber);
					  break;
				  case "row_lasttotal":
					  fillArrayField('row_lasttotal',filterNum($("#tblBasket tr[basketItem]").eq(fixedRowNumber).find("#row_lasttotal").val(),price_round_number),commaSplit($("#tblBasket tr[basketItem]").eq(fixedRowNumber).find("#row_lasttotal").val(),price_round_number),rowNumber,1);
					  kdvdahildenhesapla(rowNumber,'row_lasttotal');
					  break;
				  case "extra_cost_rate":
					  fillArrayField('extra_cost_rate',filterNum($("#tblBasket tr[basketItem]").eq(fixedRowNumber).find("#extra_cost_rate").val(),price_round_number),commaSplit($("#tblBasket tr[basketItem]").eq(fixedRowNumber).find("#extra_cost_rate").val(),price_round_number),rowNumber,1);
					  marj_maliyet_hesabi(rowNumber,1,'extra_cost_rate');
					  break;
				  case "net_maliyet":
					  fillArrayField('net_maliyet',filterNum($("#tblBasket tr[basketItem]").eq(fixedRowNumber).find("#net_maliyet").val(),price_round_number),commaSplit($("#tblBasket tr[basketItem]").eq(fixedRowNumber).find("#net_maliyet").val(),price_round_number),rowNumber,1);
					  marj_maliyet_hesabi(rowNumber,1,'net_maliyet');
					  break;
				  case "extra_cost":
					  fillArrayField('extra_cost',filterNum($("#tblBasket tr[basketItem]").eq(fixedRowNumber).find("#extra_cost").val(),price_round_number),commaSplit($("#tblBasket tr[basketItem]").eq(fixedRowNumber).find("#extra_cost").val(),price_round_number),rowNumber,1);
					  marj_maliyet_hesabi(rowNumber,1,'extra_cost');
					  break;
				  case "order_currency":
					  fillArrayField('order_currency',$("#tblBasket tr[basketItem]").eq(fixedRowNumber).find("#order_currency").val(),$("#tblBasket tr[basketItem]").eq(fixedRowNumber).find("#order_currency").val(),rowNumber,2);
					  break;
				  case "reserve_type":
					  fillArrayField('reserve_type',$("#tblBasket tr[basketItem]").eq(fixedRowNumber).find("#reserve_type").val(),$("#tblBasket tr[basketItem]").eq(fixedRowNumber).find("#reserve_type").val(),rowNumber,2);
					  break;
				  case "duedate":
					  fillArrayField('duedate',$("#tblBasket tr[basketItem]").eq(fixedRowNumber).find("#duedate").val(),$("#tblBasket tr[basketItem]").eq(fixedRowNumber).find("#duedate").val(),rowNumber,2);
					  hesapla('duedate',rowNumber);	
					  break;
				  case "ek_tutar":
					  fillArrayField('ek_tutar',$("#tblBasket tr[basketItem]").eq(fixedRowNumber).find("#ek_tutar").val(),commaSplit($("#tblBasket tr[basketItem]").eq(fixedRowNumber).find("#ek_tutar").val(),price_round_number),rowNumber,1);
					  ek_tutar_hesapla(rowNumber,'ek_tutar');
					  hesapla('ek_tutar',rowNumber);	
					  break;
				  case "ek_tutar_price":
					  fillArrayField('ek_tutar_price',filterNum($("#tblBasket tr[basketItem]").eq(fixedRowNumber).find("#ek_tutar_price").val(),price_round_number),commaSplit($("#tblBasket tr[basketItem]").eq(fixedRowNumber).find("#ek_tutar_price").val(),price_round_number),rowNumber,1);
					  ek_tutar_hesapla(rowNumber,'ek_tutar_price');
					  hesapla('ek_tutar_price',rowNumber);	
					  break;
				  case "basket_extra_info":
					  fillArrayField('basket_extra_info',$("#tblBasket tr[basketItem]").eq(fixedRowNumber).find("#basket_extra_info").val(),$("#tblBasket tr[basketItem]").eq(fixedRowNumber).find("#basket_extra_info").find(":selected").index(),rowNumber,2);
					  break;
				  case "select_info_extra":
					  fillArrayField('select_info_extra',$("#tblBasket tr[basketItem]").eq(fixedRowNumber).find("#select_info_extra").val(),$("#tblBasket tr[basketItem]").eq(fixedRowNumber).find("#select_info_extra").find(":selected").index(),rowNumber,2);
					  break;
				  case "row_activity_id":
					  fillArrayField('row_activity_id',$("#tblBasket tr[basketItem]").eq(fixedRowNumber).find("#row_activity_id").val(),$("#tblBasket tr[basketItem]").eq(fixedRowNumber).find("#row_activity_id").find(":selected").index(),rowNumber,2);
					  break;
				  case "basket_exp_center":
					  fillArrayField('row_exp_center_name',$("#tblBasket tr[basketItem]").eq(fixedRowNumber).find("#basket_exp_center").val(),$("#tblBasket tr[basketItem]").eq(fixedRowNumber).find("#basket_exp_center").val(),rowNumber,2);
					  break;
				  case "basket_exp_item":
					  fillArrayField('row_exp_item_name',$("#tblBasket tr[basketItem]").eq(fixedRowNumber).find("#basket_exp_item").val(),$("#tblBasket tr[basketItem]").eq(fixedRowNumber).find("#basket_exp_item").val(),rowNumber,2);
					  break;
				  case "basket_acc_code":
					  fillArrayField('row_acc_code',$("#tblBasket tr[basketItem]").eq(fixedRowNumber).find("#basket_acc_code").val(),$("#tblBasket tr[basketItem]").eq(fixedRowNumber).find("#basket_acc_code").val(),rowNumber,2);
					  break;
				  case "row_subscription_name":
					  fillArrayField('row_subscription_name',$("#tblBasket tr[basketItem]").eq(fixedRowNumber).find("#row_subscription_name").val(),$("#tblBasket tr[basketItem]").eq(fixedRowNumber).find("#row_subscription_name").val(),rowNumber,2);
					  break;
				  case "row_assetp_name":
					  fillArrayField('row_assetp_name',$("#tblBasket tr[basketItem]").eq(fixedRowNumber).find("#row_assetp_name").val(),$("#tblBasket tr[basketItem]").eq(fixedRowNumber).find("#row_assetp_name").val(),rowNumber,2);
					  break;
				  case "detail_info_extra":
					  fillArrayField('detail_info_extra',$("#tblBasket tr[basketItem]").eq(fixedRowNumber).find("#detail_info_extra").val(),$("#tblBasket tr[basketItem]").eq(fixedRowNumber).find("#detail_info_extra").val(),rowNumber,2);
					  break;
				  case "lot_no":
					  lotno_control(fixedRowNumber);
					  fillArrayField('lot_no',$("#tblBasket tr[basketItem]").eq(fixedRowNumber).find("#lot_no").val(),$("#tblBasket tr[basketItem]").eq(fixedRowNumber).find("#lot_no").val(),rowNumber,2);
					  break;
				  case "product_name_other":
					  fillArrayField('product_name_other',$("#tblBasket tr[basketItem]").eq(fixedRowNumber).find("#product_name_other").val(),$("#tblBasket tr[basketItem]").eq(fixedRowNumber).find("#product_name_other").val(),rowNumber,2);
					  break;
				  case "product_name":
					  fillArrayField('product_name',$("#tblBasket tr[basketItem]").eq(fixedRowNumber).find("#product_name").val(),$("#tblBasket tr[basketItem]").eq(fixedRowNumber).find("#product_name").val(),rowNumber,2);
					  break;
				  case "manufact_code":
					  fillArrayField('manufact_code',$("#tblBasket tr[basketItem]").eq(fixedRowNumber).find("#manufact_code").val(),$("#tblBasket tr[basketItem]").eq(fixedRowNumber).find("#manufact_code").val(),rowNumber,2);
					  break;
				  case "reason_code":
					  fillArrayField('reason_code',$("#tblBasket tr[basketItem]").eq(fixedRowNumber).find("#reason_code").val(),$("#tblBasket tr[basketItem]").eq(fixedRowNumber).find("#reason_code").val(),rowNumber,2);
					  break;
				  case "otv_type":
					  fillArrayField('otv_type',$("#tblBasket tr[basketItem]").eq(fixedRowNumber).find("#otv_type").val(),$("#tblBasket tr[basketItem]").eq(fixedRowNumber).find("#otv_type").val(),rowNumber,2);
					  hesapla('OTV_type',rowNumber); 
					  break;
				  case "delivery_condition":
					  fillArrayField('delivery_condition',$("#tblBasket tr[basketItem]").eq(fixedRowNumber).find("#delivery_condition").val(),$("#tblBasket tr[basketItem]").eq(fixedRowNumber).find("#delivery_condition").val(),rowNumber,2);
					  break;
				  case "container_type":
					  fillArrayField('container_type',$("#tblBasket tr[basketItem]").eq(fixedRowNumber).find("#container_type").val(),$("#tblBasket tr[basketItem]").eq(fixedRowNumber).find("#container_type").val(),rowNumber,2);
					  break;
				  case "delivery_type":
					  fillArrayField('delivery_type',$("#tblBasket tr[basketItem]").eq(fixedRowNumber).find("#delivery_type").val(),$("#tblBasket tr[basketItem]").eq(fixedRowNumber).find("#delivery_type").val(),rowNumber,2);
					  break;
				  case "container_number":
					  fillArrayField('container_number',$("#tblBasket tr[basketItem]").eq(fixedRowNumber).find("#container_number").val(),$("#tblBasket tr[basketItem]").eq(fixedRowNumber).find("#container_number").val(),rowNumber,2);
					  break;
				  case "container_quantity":
					  fillArrayField('container_quantity',$("#tblBasket tr[basketItem]").eq(fixedRowNumber).find("#container_quantity").val(),$("#tblBasket tr[basketItem]").eq(fixedRowNumber).find("#container_quantity").val(),rowNumber,2);
					  break;
				  case "delivery_country":
					  fillArrayField('delivery_country',$("#tblBasket tr[basketItem]").eq(fixedRowNumber).find("#delivery_country").val(),$("#tblBasket tr[basketItem]").eq(fixedRowNumber).find("#delivery_country").val(),rowNumber,2);
					  break;
				  case "delivery_city":
					  fillArrayField('delivery_city',$("#tblBasket tr[basketItem]").eq(fixedRowNumber).find("#delivery_city").val(),$("#tblBasket tr[basketItem]").eq(fixedRowNumber).find("#delivery_city").val(),rowNumber,2);
					  break;
				  case "delivery_county":
					  fillArrayField('delivery_county',$("#tblBasket tr[basketItem]").eq(fixedRowNumber).find("#delivery_county").val(),$("#tblBasket tr[basketItem]").eq(fixedRowNumber).find("#delivery_county").val(),rowNumber,2);
					  break;
				  case "gtip_number":
					  fillArrayField('gtip_number',$("#tblBasket tr[basketItem]").eq(fixedRowNumber).find("#gtip_number").val(),$("#tblBasket tr[basketItem]").eq(fixedRowNumber).find("#gtip_number").val(),rowNumber,2);
					  break;
				  case "deliver_date":
					  fillArrayField('deliver_date',$("#tblBasket tr[basketItem]").eq(fixedRowNumber).find("#deliver_date").val(),$("#tblBasket tr[basketItem]").eq(fixedRowNumber).find("#deliver_date").val(),rowNumber,2);
					  break;
				  case "promosyon_yuzde":
					  fillArrayField('promosyon_yuzde',$("#tblBasket tr[basketItem]").eq(fixedRowNumber).find("#promosyon_yuzde").val(),$("#tblBasket tr[basketItem]").eq(fixedRowNumber).find("#promosyon_yuzde").val(),rowNumber,2);
					  hesapla('promosyon_yuzde',rowNumber);	
					  break;
				  case "row_bsmv_rate":
					  fillArrayField('row_bsmv_rate',$("#tblBasket tr[basketItem]").eq(fixedRowNumber).find("#row_bsmv_rate").val(),commaSplit($("#tblBasket tr[basketItem]").eq(fixedRowNumber).find("#row_bsmv_rate").val(),price_round_number),rowNumber,2);
					  hesapla('row_bsmv_rate',rowNumber);	
					  break;
				  case "row_bsmv_amount":
					  fillArrayField('row_bsmv_amount',$("#tblBasket tr[basketItem]").eq(fixedRowNumber).find("#row_bsmv_amount").val(),commaSplit($("#tblBasket tr[basketItem]").eq(fixedRowNumber).find("#row_bsmv_amount").val(),price_round_number),rowNumber,2);
					  hesapla('row_bsmv_amount',rowNumber);	
					  break;
				  case "row_bsmv_currency":
					  fillArrayField('row_bsmv_currency',$("#tblBasket tr[basketItem]").eq(fixedRowNumber).find("#row_bsmv_currency").val(),commaSplit($("#tblBasket tr[basketItem]").eq(fixedRowNumber).find("#row_bsmv_currency").val(),price_round_number),rowNumber,2);
					  hesapla('row_bsmv_currency',rowNumber);	
					  break;
				  case "row_oiv_rate":
					  fillArrayField('row_oiv_rate',$("#tblBasket tr[basketItem]").eq(fixedRowNumber).find("#row_oiv_rate").val(),commaSplit($("#tblBasket tr[basketItem]").eq(fixedRowNumber).find("#row_oiv_rate").val(),price_round_number),rowNumber,2);
					  hesapla('row_oiv_rate',rowNumber);	
					  break;
				  case "row_oiv_amount":
					  fillArrayField('row_oiv_amount',$("#tblBasket tr[basketItem]").eq(fixedRowNumber).find("#row_oiv_amount").val(),commaSplit($("#tblBasket tr[basketItem]").eq(fixedRowNumber).find("#row_oiv_amount").val(),price_round_number),rowNumber,2);
					  hesapla('row_oiv_amount',rowNumber);	
					  break;
				  case "row_tevkifat_rate":
					  fillArrayField('row_tevkifat_rate',$("#tblBasket tr[basketItem]").eq(fixedRowNumber).find("#row_tevkifat_rate").val(),commaSplit($("#tblBasket tr[basketItem]").eq(fixedRowNumber).find("#row_tevkifat_rate").val(),price_round_number),rowNumber,2);
					  hesapla('row_tevkifat_rate',rowNumber);
					  break;
				  case "row_tevkifat_amount":
					  fillArrayField('row_tevkifat_amount',$("#tblBasket tr[basketItem]").eq(fixedRowNumber).find("#row_tevkifat_amount").val(),commaSplit($("#tblBasket tr[basketItem]").eq(fixedRowNumber).find("#row_tevkifat_amount").val(),price_round_number),rowNumber,2);
					  hesapla('row_tevkifat_amount',rowNumber);
					  break;
				  case "list_price_discount":
					  fillArrayField('list_price_discount',$("#tblBasket tr[basketItem]").eq(fixedRowNumber).find("#list_price_discount").val(),commaSplit($("#tblBasket tr[basketItem]").eq(fixedRowNumber).find("#list_price_discount").val(),price_round_number),rowNumber,2);
					  hesapla('list_price_discount',rowNumber);
					  break;
			  }
		  }
		  
		  function nonFormatField(e){
			  rowNumber = Number($(e.target).closest("tr[basketItem]").attr("itemIndex"));
			  fixedRowNumber = rowNumber - window.basket.scrollIndex ;
			  
			  window.basket.hidden_values.control_field_value = commaSplit(window.basket.items[rowNumber][$(e.target).attr("id").toUpperCase()],8);
			  switch ($(e.target).attr("id")){
				  case "row_width":
					  fillArrayField('row_width',filterNum($("#tblBasket tr[basketItem]").eq(fixedRowNumber).find("#row_width").val()),commaSplit($("#tblBasket tr[basketItem]").eq(fixedRowNumber).find("#row_width").val()),rowNumber,1);
					  break;
				  case "row_height":
					  fillArrayField('row_height',filterNum($("#tblBasket tr[basketItem]").eq(fixedRowNumber).find("#row_height").val()),commaSplit($("#tblBasket tr[basketItem]").eq(fixedRowNumber).find("#row_height").val()),rowNumber,1);
					  break;
				  case "row_depth":
					  fillArrayField('row_depth',filterNum($("#tblBasket tr[basketItem]").eq(fixedRowNumber).find("#row_depth").val()),commaSplit($("#tblBasket tr[basketItem]").eq(fixedRowNumber).find("#row_depth").val()),rowNumber,1);
					  break;
				  case "promosyon_maliyet":
					  fillArrayField('promosyon_maliyet',filterNum($("#tblBasket tr[basketItem]").eq(fixedRowNumber).find("#promosyon_maliyet").val(),price_round_number),commaSplit($("#tblBasket tr[basketItem]").eq(fixedRowNumber).find("#promosyon_maliyet").val(),price_round_number),rowNumber,1);
					  break;
			  }
		  }
		  
		  function kur_degistir(gelen)
		  {
			  if(gelen == undefined)
				  gelen = 1;
			  $( window.basket ).ready(function() {
  //			window.basket.footer.basketCurrencyType = $("#basket_main_div #rd_money")
				  var tempGelen = gelen;
	  //			timeDelay('timeInput');
				  try
				  {
					  for(i=1;i<= $("#basket_main_div #rd_money").length;i++)
					  {
						  gelen=i;
						  if(gelen != undefined) //tekli kur degistirildiginde cagrılmıssa
						  {
							  var eleman = $("#basket_main_div #txt_rate2_"+gelen).val();
							  rate2Array[gelen-1] = filterNum(eleman,basket_rate_round_number);
							  if($("input[name=rd_money][value="+gelen+"]").is(":checked") )
							  window.basket.footer.basketCurrencyType = $("#basket_main_div #hidden_rd_money_"+gelen).val();
						  }
					  }
				  }
				  catch(e)
				  {
					  if(gelen != undefined) //tekli kur degistirildiginde cagrılmıssa
					  {
						  var eleman = $("#basket_main_div #txt_rate2_"+gelen).val();
						  rate2Array[gelen-1] = filterNum(eleman,basket_rate_round_number);
					  }
				  }
				  for( var satir_index = 0 ; satir_index < window.basket.items.length ; satir_index++)
				  {
					  /*if((window.basket.items[satir_index].OTHER_MONEY == window.basket.footer.basketCurrencyType))
					  {*/
						  if(satir_index < window.basket.items.length)
							  hesapla('price_other',satir_index,0);	
					  /*}*/
					  if(satir_index == window.basket.items.length-1) <!--- Son satırda her türlü toplam hesapla yapilsin.  --->
						  hesapla('price_other',satir_index,1);
				  }
				  
				  kdvsiz_doviz_indirim_hesapla();
				  kdvli_doviz_indirim_hesapla();
	  //			timeDelay('timeInput');
				  $("#basket_main_div #txt_rate2_"+tempGelen).val(commaSplit($("#basket_main_div #txt_rate2_"+tempGelen).val(),basket_rate_round_number));
				  return true;
			  })
		  }
		  
		  function saveFormAll()
		  {
			  if(!window.basket.items.length)
			  {
				  alert("<cf_get_lang dictionary_id='57725.Ürün Seçiniz'>!");
				  return false;
			  }
  
			  //_CF_checkform_basket(document.form_basket); //Formdaki zorunlu alan degisiklikleri
			  toplam_hesapla(1);
			  
			  if (taxArray.length != 0)
			  {
				  $("#hidden_fields").html('<input type="hidden" id="basket_tax_count" name="basket_tax_count" value="'+taxArray.length+'">');
				  
				  var taxArraylen= taxArray.length;
				  for (var taxi=0; taxi < taxArraylen; taxi++)
				  { 
					  $("#hidden_fields").html($("#hidden_fields").html()+'<input type="hidden" id="basket_tax_'+(taxi+1)+'" name="basket_tax_'+(taxi+1)+'" value="'+taxArray[taxi]+'">');
					  <cfif listfind('invoice,',fusebox.circuit,',') or listfind("1,2,18,20,33,42,43",attributes.basket_id,",")>
						var tev_oran = filterNum($("#basket_main_div #tevkifat_oran").val(),8);
						  if($("#basket_main_div #tevkifat_box").is(':checked') && $("#basket_main_div #tevkifat_oran").length && $("#basket_main_div #tevkifat_oran").val().length)
						  {
							  $("#hidden_fields").html($("#hidden_fields").html()+'<input type="hidden" id="basket_tax_value_'+(taxi+1)+'" name="basket_tax_value_'+(taxi+1)+'" value="'+wrk_round(taxTotalArray[taxi]*tev_oran,price_round_number)+'">');
							  $("#hidden_fields").html($("#hidden_fields").html()+'<input type="hidden" id="tevkifat_tutar_'+(taxi+1)+'" name="tevkifat_tutar_'+(taxi+1)+'" value="'+wrk_round(taxTotalArray[taxi]-(taxTotalArray[taxi]*tev_oran),price_round_number)+'">');
						  }
						  else
							  $("#hidden_fields").html($("#hidden_fields").html()+'<input type="hidden" id="basket_tax_value_'+(taxi+1)+'" name="basket_tax_value_'+(taxi+1)+'" value="'+taxTotalArray[taxi]+'">');
					  <cfelse>
						  $("#hidden_fields").html($("#hidden_fields").html()+'<input type="hidden" id="basket_tax_value_'+(taxi+1)+'" name="basket_tax_value_'+(taxi+1)+'" value="'+taxTotalArray[taxi]+'">');
					  </cfif>
				  }
			  }
			  if (otvArray.length != 0)
			  { 	
				  $("#hidden_fields").html($("#hidden_fields").html()+'<input type="hidden" id="basket_otv_count" name="basket_otv_count" value="'+otvArray.length+'">');
				  var otvArraylen= otvArray.length;
				  for (var otv_count=0; otv_count < otvArraylen; otv_count++)
				  {
					  if(otvArray[otv_count] == '' || isNaN(otvArray[otv_count])){
						  otvArray[otv_count]=0
					  }
					  if(otvArray[otv_count] != '')
					  {
						  if(window.basket.items.length == 1)
							  $("#hidden_fields").html($("#hidden_fields").html()+'<input type="hidden" id="basket_otv_'+(otv_count+1)+'" name="basket_otv_'+(otv_count+1)+'" value="'+otvArray[otv_count]+'">');
						  else
							  $("#hidden_fields").html($("#hidden_fields").html()+'<input type="hidden" id="basket_otv_'+(otv_count+1)+'" name="basket_otv_'+(otv_count+1)+'" value="'+filterNumBasket(otvArray[otv_count])+'">');
					  }
					  else
						  $("#hidden_fields").html($("#hidden_fields").html()+'<input type="hidden" id="basket_otv_'+(otv_count+1)+'" name="basket_otv_'+(otv_count+1)+'" value="'+otvArray[otv_count]+'">');
					  $("#hidden_fields").html($("#hidden_fields").html()+'<input type="hidden" id="basket_otv_value_'+(otv_count+1)+'" name="basket_otv_value_'+(otv_count+1)+'" value="'+otvTotalArray[otv_count]+'">');						
				  }
			  }
			  
			  //waitForDisableAction($('#wrk_submit_button'));
			  //timeDelay('saveInputTime');
			  $("#basket_main_div div[basket_header]").find("input,select,textarea").each(function(index,element){
				  if($(element).is("input") && $(element).attr("type").toLowerCase() == "checkbox")
				  {
					  if($(element).is(":checked")) window.basket.header[$(element).attr("name")] = 1;
				  }
				  else if($(element).is("input") && $(element).attr("type") == "radio")
				  {
					  if ($(element).is(":checked")) window.basket.header[$(element).attr("name")] = $(element).val();
				  }
				  else
				  {
					  if(!($(element).css('visibility') == 'hidden' && $(element).is("textarea")))
					  {
						  if(!window.basket.header[$(element).attr("name")])  // purchase.form_add_offer sayfasında workcube_to_cc kullanılıyor. Burada aynı isimli oluşan hidden'lar query sayfasında kontrol ediliyor. Bu yüzden bu kontrol eklendi .
							  window.basket.header[$(element).attr("name")] = $(element).val();
						  else
							  window.basket.header[$(element).attr("name")] = window.basket.header[$(element).attr("name")] + ',' + $(element).val();
					  }
				  }
			  })
			  $("#basket_main_div div[basket_footer]").find("input,select,textarea").each(function(index,element){
				  if($(element).is("input") && $(element).attr("type").toLowerCase() == "checkbox")
				  {
					  if($(element).is(":checked")) window.basket.footer[$(element).attr("name")] = 1;
				  }
				  else if($(element).is("input") && $(element).attr("type") == "radio")
				  {
					  if ($(element).is(":checked")) window.basket.footer[$(element).attr("name")] = $(element).val();
				  }
				  else
				  {
					  if(listfind('stopaj',$(element).attr("name")) != -1)
						  val_ = filterNum($(element).val(),price_round_number);
					  else if(listfind('stopaj_yuzde',$(element).attr("name")) != -1)
						  val_ = filterNum($(element).val(),2)
					  else if(listfind('genel_indirim_',$(element).attr("name")) != -1)
						  val_ = filterNum($(element).val(),basket_total_round_number);
					  else if($(element).attr("name").indexOf('txt_rate') > -1)
						  val_ = filterNum($(element).val(),basket_rate_round_number);
					  else if(listfind('yuvarlama',$(element).attr("name")) != -1)
						  val_ = filterNum($(element).val(),basket_total_round_number);
					  else if(listfind('tevkifat_oran',$(element).attr("name")) != -1)
					  {
						  val_ = filterNum($(element).val(),8);
					  }
					  else
						  val_ = $(element).val();
					  window.basket.footer[$(element).attr("name")] = val_;
				  }
			  })
			  $("#basket_main_div table[paymentTable]").find("input,select,textarea").each(function(index,element){
				  if($(element).is("input") && $(element).attr("type").toLowerCase() == "checkbox")
				  {
					  if($(element).is(":checked")) window.basket.footer[$(element).attr("name")] = 1;
				  }
				  else if($(element).is("input") && $(element).attr("type") == "radio")
				  {
					  if ($(element).is(":checked")) window.basket.footer[$(element).attr("name")] = $(element).val();
				  }
				  else
				  {
					  val_ = $(element).val();
					  window.basket.footer[$(element).attr("name")] = val_;
				  }
			  })
			  $("#basket_main_div table[totalTable]").find("input,select,textarea").each(function(index,element){
				  if($(element).is("input") && $(element).attr("type").toLowerCase() == "checkbox")
				  {
					  if($(element).is(":checked")) window.basket.footer[$(element).attr("name")] = 1;
				  }
				  else if($(element).is("input") && $(element).attr("type") == "radio")
				  {
					  if ($(element).is(":checked")) window.basket.footer[$(element).attr("name")] = $(element).val();
				  }
				  else
				  {
					  val_ = $(element).val();
					  window.basket.footer[$(element).attr("name")] = val_;
				  }
			  })
			  $("#basket_main_div table[statisticalTable]").find("input,select,textarea").each(function(index,element){
				  if($(element).is("input") && $(element).attr("type").toLowerCase() == "checkbox")
				  {
					  if($(element).is(":checked")) window.basket.footer[$(element).attr("name")] = 1;
				  }
				  else if($(element).is("input") && $(element).attr("type") == "radio")
				  {
					  if ($(element).is(":checked")) window.basket.footer[$(element).attr("name")] = $(element).val();
				  }
				  else
				  {
					  val_ = $(element).val();
					  window.basket.footer[$(element).attr("name")] = val_;
				  }
			  })
			  
			  $("#hidden_fields").find("input").each(function(index,element){
				  window.basket.footer[$(element).attr("name")] = $(element).val();
			  })
			  try{
				  for(var instanceName in CKEDITOR.instances)
				  {
					  window.basket.header['CKEDITOR_'+CKEDITOR.instances[instanceName].name] = CKEDITOR.instances[CKEDITOR.instances[instanceName].name].getData();
				  }
			  }
			  catch(e){}
			  
  
			  <cfif isdefined("nextEvent")>
				  var queryPathJSON = $.evalJSON(decodeURIComponent("<cfoutput>#queryPath#</cfoutput>"));
				  var nextEventJSON = $.evalJSON(decodeURIComponent("<cfoutput>#nextEvent#</cfoutput>"));
				  if($(obj).closest('form').find("input[name='eventName']").length)
				  {
					  $(obj).closest('form').find("input[name='eventName']").each(function(index,element){
						  window.basket.header['queryPath'] = queryPathJSON[$(element).val()]['queryPath'];
						  window.basket.header['nextEvent'] = nextEventJSON[$(element).val()]['nextEvent'];
					  });
				  }
				  else
				  {
					  window.basket.header['queryPath'] = queryPathJSON['<cfoutput>#attributes.event#</cfoutput>']['queryPath'];
					  window.basket.header['nextEvent'] = nextEventJSON['<cfoutput>#attributes.event#</cfoutput>']['nextEvent'];
				  }
			  </cfif>
			  
			  <cfif isdefined("WOStruct") and isStruct(WOStruct)>
				  <cfif structKeyExists(WOStruct['#attributes.fuseaction#'],'extendedForm')>
					  window.basket.header['extendedControllerFileName'] = '<cfoutput>#WOStruct["#attributes.fuseaction#"]["extendedForm"]["controllerFileName"]#</cfoutput>';
				  </cfif>
			  </cfif>
			  
			  //console.log(window.basket);
			  //timeDelay('saveInputTime');
			  //callURL("<cfoutput>#request.self#?fuseaction=objects.emptypopup_basket_converter&ajax=1</cfoutput>",handlerPost,{ page:"<cfoutput>#fusebox.circuit#.#fusebox.fuseaction#</cfoutput>", basket: encodeURIComponent($.toJSON(window.basket)) });			
			  
			  // wrk button içerisine adreslenmiş bir cfc var ise datagate üzerinden ilgili cfc ve içerisindeki fonksiyona yönlendirilir.
			if( $("input#data_action").val() != undefined && $("input#next_page").val() != undefined ) {
				var next_url = $("input#next_page").val();
				var data = new FormData();
					data.append('cfc', $("input#data_action").val().split(":")[0]);
					data.append('function', $("input#data_action").val().split(":")[1]);
					data.append('event', '<cfif isDefined('attributes.event')><cfoutput>#attributes.event#</cfoutput></cfif>');
					data.append('basketv', 1);
					data.append('form_data', encodeURIComponent($.toJSON(window.basket)) );
					AjaxControlPostDataJson('/WMO/datagate.cfc?method=basketConverter', data, function(response) {
						if( response.STATUS ){
							if($("input[name=data_action_draggable]").length > 0){
								alertObject({message:"<cfoutput>#getLang('','',47470)#</cfoutput>",type:"success"}); 
								closeBoxDraggable( $("input[name=data_action_modal_id]").val() );
								return false;
							}else window.location.href = next_url + response.IDENTITY;
						}else{
							alert(response.MESSAGE);
						}
					});
					return false;
			}else{
			  	callURLBasket("<cfoutput>#request.self#?fuseaction=objects.emptypopup_basket_converter&ajax=1&xmlhttp=1&_cf_nodebug=true</cfoutput>",handlerPostBasket,{ basket: encodeURIComponent($.toJSON(window.basket)) });
			  	return false;
			}
		  }
		  function saveForm()
		  {
  
			  /* Uğur Hamurpet : 27/01/2020, Desc :  Check basket required form elements by Page Designer Basket Settings */
			  var reqWarning = false;
			  $("table#tblBasket tbody").find("input[required], select[required]").each(function(){
				  if( $.trim($(this).val()) == '' || $(this).parent("td").find("input[type = hidden]").val() == '' || ($(this).attr("type") == undefined && $(this).val() == 0) ){
					  reqWarning = true;
					  return false;
				  }else{
					  reqWarning = false;
				  }
			  });
  
			  if( reqWarning ){
				  alert("Lütfen basketteki zorunlu alanları boş bırakmayınız!");
				  return false;
			  }
  
			  tempAmountControl = 0;
			  tempRow = 0;
			  jQuery.each( $("div#sepetim input[name='Amount']"), function( ind, obj ) {
				  tempAmount = filterNum($(obj).val(),4);
					if(parseFloat(tempAmount) == 0){
					  tempAmountControl = 1;
					  tempRow = ind + 1;
				  }
			  });
			  if(tempAmountControl){
				  alert(tempRow+'. satırdaki miktar değerini kontrol ediniz');
				  return false;
			  }
			  <cfif isdefined('use_basket_project_discount_') and use_basket_project_discount_ eq 1>
				  if(!check_project_discount_conditions())//proje bakiye kontrolleri için eklendi 
				  {
					  return false;
				  }
			  </cfif>
  
			  <!--- Baskette yapılan sipariş aşamasındaki değişikliğin sipariş detayında tetiklenmesi için eklendi. --->
			  //check_reserved_rows();
			  return (validate().check() && window['_CF_checkform_basket'](this) && saveFormAll());
		  }
	  </script>
	  <!---
	  <button id="btnAdd" type="button">Ekle</button>
	  <button id="btnSave" type="button">Kaydet</button>
	  --->
	  <input type="hidden" name="timeInput" id="timeInput" value="" />
	  <input type="hidden" name="saveInputTime" id="saveInputTime" value="" />
	  <!---<button id="btnClear">Temizle</button>--->
	  
	  
	  <cfif isdefined('attributes.is_retail') or ( ListFindNoCase(display_list, "barcode_price_list") and ListFindNoCase(display_list, "barcode_amount") )>
		  
		  <div id="basketIframe">
			  <iframe 
				  name="_add_prod_" 
				  id="_add_prod_" 
				  frameborder="0" 
				  vspace="0" 
				  hspace="0" 
				  scrolling="no" 
				  src="<cfoutput>#request.self#?fuseaction=objects.add_basket_row_from_barcod&isAjax=1&amount_round_number=#amount_round#&is_sale_product=#sale_product#&int_basket_id=#attributes.basket_id#<cfloop query="get_money_bskt">&#money_type#=#rate2/rate1#</cfloop></cfoutput>&iframe=1<cfif listgetat(attributes.fuseaction,1,'.') is 'store'>&is_store_module=1</cfif>&ajax_box_page=1"  
				  width="100%"
				  style="min-height:40px; height:40px;"></iframe>
		  </div>		
	  </cfif>
					  
		<div id="sepet_table" <cfif isdefined("attributes.is_basket_hidden") and attributes.is_basket_hidden eq 1>style="display:none;"</cfif>>
			<div id="basket_tr"><!--- id surec icin eklendi. Silmeyiniz div e çevrildi SA20160428--->
				<div id="hidden_fields" style="display:none;"></div>     
				<div id="basketBox">      
					<div id="sepetim" class="ui-scroll"><!--- style koymayiniz --->
						<table id="tblBasket" class="ui-table-list ui-form"  <cfif isdefined("attributes.is_basket_hidden") and attributes.is_basket_hidden eq 1>style="display:none;"</cfif>>
							<thead basketThead>
							<tr>
								<th nowrap="nowrap" style="width:20px;"><cf_get_lang dictionary_id="57487.No"></th>
								<th nowrap="nowrap" style="width:60px;">
									<ul class="ui-icon-list"><li>
									<a href="javascript://" onclick="control_comp_selected(0,0);"><i class="fa fa-plus"  id="basket_header_add_2" title="Ürün Ekle"></i></a>
									</li><cfif ListFindNoCase(display_list,'use_configurator')><li><a href="javascript:void(0)" onclick="control_comp_selected(0,0,1);"><i class="fa fa-puzzle-piece"></i></a>
									</li></cfif></ul>
								</th>
								<cfset extraTitleWidthList = 'Price,basket_project,basket_work,spec,basket_exp_center,basket_exp_item,basket_acc_code,reserve_date,basket_employee,shelf_number_2,deliver_dept,deliver_date,lot_no'><!--- Input'un yanında tek ikon varsa buraya yazıyoruz. --->
								<cfoutput query="GET_BASKET">
									<cfif IS_SELECTED eq 1 and not listFindNoCase(non_inputs,TITLE,',') and not listFindNoCase(extra_basket_hidden_list_,TITLE)>
										<cfif listFindNoCase('product_name,shelf_number',TITLE,',')><!--- Input'un yanında iki ikon varsa buraya yazıyoruz. --->
											<cfset headerWidth = GENISLIK+20>
										<cfelseif listFindNoCase(extraTitleWidthList,TITLE,',')>
											<cfset headerWidth = GENISLIK+10>
										<cfelse>
											<cfset headerWidth = GENISLIK + 30>
										</cfif>
										<th nowrap="nowrap" style="min-width:#headerWidth#px;" <cfif IS_MOBILE eq 1>class="is_mobile"</cfif>>
											<cfif not (TITLE contains 'disc_ount')>
												<span>#TITLE_NAME# <cfif listLen( display_field_required_list ) and listGetAt(display_field_required_list,listFindNoCase(display_list,TITLE,','))>*</cfif> </span>
												<cfif TITLE contains 'duedate' and session.ep.duedate_valid eq 0>
													<input type="text" id="set_row_duedate" class="boxtext" name="set_row_duedate" value="0,00" style="width:#GENISLIK/2#px;min-width:#GENISLIK/2#px;"<cfif listfindnocase(basket_read_only_price_list,'set_row_duedate') or listfindnocase(basket_read_only_duedate_list,'set_row_duedate,')>readonly='yes'<cfelse>onBlur="apply_duedate(2);" </cfif>>
												</cfif>
											<cfelse>
												<cfset discount_row = Replace(replace(TITLE,'disc_ount',''),'_','')>
												<cfif not len(discount_row)>
													<cfset discount_row = 1>
												</cfif>
												#TITLE_NAME#<input type="text" id="set_row_disc_ount#discount_row#" class="boxtext" name="set_row_disc_ount#discount_row#" onfocus="this.value='';" value="0,00" <cfif listfindnocase(basket_read_only_discount_list,'disc_ount')>readonly<cfelse>onBlur="if(this.value.length && filterNum(this.value) <= 100) apply_discount(#discount_row#)"</cfif> style="width:#GENISLIK - 30#px;" />
											</cfif>
										</th>
									</cfif>
								</cfoutput>
							</tr>
							</thead>
							<!---  <tbody style="display:none;"></tbody>fixThead fonksiyonunda dinamik olarak oluşturulan tbody alanı için ihtiyaç duyuluyor. EY 20150820 --->
						</table>            
						<cfset get_money_currency_list_for_popup = ''> <!--- Bu parametreyi control_comp_selected fonksiyonunda kullaniyoruz. EY20140905 --->
						<cfoutput query="get_money_bskt">
							<cfset get_money_currency_list_for_popup = get_money_currency_list_for_popup & '#MONEY_TYPE#=#RATE2/RATE1#&'>
						</cfoutput>
						<!--- DSP_BASKET_TOTAL_JS.CFM dosyasına taşınacak. --->                
						<table id="basketItemBase">
							<tr basketItem>
								<td><span id="rowNr"></span></td>
								<td style="width:80px;" nowrap="nowrap">
									<ul class="ui-icon-list">
										<li><a href="javascript://" id="basket_delete_list_href" name="basket_delete_list_href"><i class="fa fa-minus" title="<cf_get_lang dictionary_id='57682.Ürünü Sil'>" id="basket_delete_list"></i></a></li>
										<!---<input type="button" id="btnDelete" name="btnDelete" value="Sil" />--->
										<li><a id="copy_basket_row_id" href="javascript://"><i class="fa fa-copy" alt="Aynı Ürünü Eklemek İçin Tıklayınız"></i></a></li>
										<li><a id="update_icon" href="javascript://"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57719.Farklı Ürün Seçmek İçin Tıklayınız'>" id="basket_update_list"></i></a></li>
									</ul>
								</td>
								<cfset numericClassList = 'amount,amount2,list_price,list_price_discount,tax_price,price,price_other,price_net,price_net_doviz,tax,OTV,duedate,number_of_installment,iskonto_tutar,ek_tutar,ek_tutar_price,ek_tutar_other_total,ek_tutar_cost,ek_tutar_marj,disc_ount,disc_ount2_,disc_ount3_,disc_ount4_,disc_ount5_,disc_ount6_,disc_ount7_,disc_ount8_,disc_ount9_,disc_ount10_,row_total,row_nettotal,row_taxtotal,row_otvtotal,row_lasttotal,other_money_value,other_money_gross_total,net_maliyet,extra_cost,extra_cost_rate,row_cost_total,marj,dara,darali,promosyon_yuzde,promosyon_maliyet,row_width,row_depth,row_height,row_bsmv_rate,row_bsmv_amount,row_bsmv_currency,row_oiv_rate,row_oiv_amount,row_tevkifat_rate,row_tevkifat_amount,otv_discount'>
								<cfoutput query="GET_BASKET">
									<cfif IS_SELECTED eq 1 and not listFindNoCase(non_inputs,TITLE,',')  and not listFindNoCase(extra_basket_hidden_list_,TITLE)>
										<cfset select_func = listGetAt(select_func_list,currentrow,'§')>
										<td nowrap="nowrap" <cfif IS_MOBILE eq 1>class="is_mobile"</cfif>>
											<div class="form-group">
											<cfif listFindNoCase(input_change_name_list_old,TITLE,',')>
												<cfset new_title = listGetAt(input_change_name_list_new,listFindNoCase(input_change_name_list_old,TITLE,','),',')>
												<cfif listFindNoCase(selectbox_list,TITLE,',')>
													<select name="#new_title#" id="#new_title#" <cfif not select_func is '*'>#select_func#</cfif> <cfif listLen( display_field_required_list ) and listGetAt(display_field_required_list,listFindNoCase(display_list,TITLE,','))>required</cfif>>
														<!---<cfif not func_list is '*'>#func_list#</cfif>--->
													</select>
												<cfelse>
													<div class="input-group widFull">
														<input type="text" <cfif listFindNoCase(numericClassList,TITLE,',')>class="moneybox"</cfif> name="#new_title#" id="#new_title#" <cfif listFindNoCase(basket_read_only_discount_list,TITLE,',') or listFindNoCase(basket_read_only_duedate_list,TITLE,',') or listFindNoCase(basket_read_only_price_list,TITLE,',') or listFindNoCase(readOnlyInputList,TITLE,',') or (new_title is 'product_name' && listFindNoCase(display_list,'product_name') && listGetAt(display_field_readonly_list,listFindNoCase(display_list,'product_name',',')))>readonly="readonly"</cfif> <cfif listLen( display_field_required_list ) and listGetAt(display_field_required_list,listFindNoCase(display_list,TITLE,','))>required</cfif>>
													</div>
												</cfif>
											<cfelse>
												<cfif listFindNoCase(selectbox_list,TITLE,',')>
													<select name="#TITLE#" id="#TITLE#" <cfif not select_func is '*'>#select_func#</cfif> <cfif listLen( display_field_required_list ) and listGetAt(display_field_required_list,listFindNoCase(display_list,TITLE,','))>required</cfif>>
														<!---<cfif not func_list is '*'>#func_list#</cfif>--->
													</select>
												<cfelse>
													<div class="input-group widFull">
														<input type="text" <cfif listFindNoCase(numericClassList,TITLE,',')>class="moneybox"</cfif> name="#TITLE#" id="#TITLE#" <cfif listFindNoCase(basket_read_only_discount_list,TITLE,',') or listFindNoCase(basket_read_only_duedate_list,TITLE,',') or listFindNoCase(basket_read_only_price_list,TITLE,',') or listFindNoCase(readOnlyInputList,TITLE,',') or (title is 'product_name' && listFindNoCase(display_list,'product_name') && listGetAt(display_field_readonly_list,listFindNoCase(display_list,'product_name',',')))>readonly="readonly"</cfif> <cfif listLen( display_field_required_list ) and listGetAt(display_field_required_list,listFindNoCase(display_list,TITLE,','))>required</cfif>>
													</div>
												</cfif>
											</cfif>
											</div>
										</td>
									<cfelseif listFindNoCase(extra_basket_hidden_list_,TITLE)>
										<input type="hidden" name="#TITLE#" id="#TITLE#">
									</cfif>
								</cfoutput>
							</tr>
						</table>
					</div>
					<div class="ui-pagination basket_row_count" id="basket_money_totals_table">
						<div class="pagi-left basket_row_button">
							<ul>
								<li class="pagesButtonPassive"><a href="javascript://" name="btnFirst" id="btnFirst" value=""><i class="fa fa-angle-double-left"></i></a></li>
								<li class="pagesButtonPassive"><a href="javascript://" name="btnPrev" id="btnPrev" value=""><i class="fa fa-angle-left"></i></a></li>
								<li><input style="width:35px;" type="text" name="pageNumber" id="pageNumber"  value="1" onBlur="goPage();"/></li>
								<li class="pagesButtonActive"><a href="javascript://" name="btnNext" id="btnNext" value=""><i class="fa fa-angle-right"></i></a></li>
								<li><a href="javascript://" name="btnLast" id="btnLast" value=""><i class="fa fa-angle-double-right"></i></a></li>
								
							</ul>
						</div>
						<div class="rowCountText">
							<span class="txtbold"><b><cf_get_lang dictionary_id="44423.Satır Sayısı"></b>: </span><span id="itemCount" class="txtbold">0</span>
							<span class="txtbold"><b><cf_get_lang dictionary_id="57581.Sayfa"></b>: </span><span id="itemPageCount" class="txtbold">0</span>
						</div>
					</div>     
				</div>
				<div class="row" basketCurrency id="sepetim_total_table_tutar_tr">
					<cfinclude template="../../objects/display/dsp_basket_total_js_view.cfm">
				</div>
			</div>
		</div>
	  
  <script type="text/javascript">
  
  // dsp_basket_js_scripts dosyasında yer alan standart değerler atanıyor.
  // js_create_unique_id() : Special_functions içerisinde tanımlanıyorç
  var basket_unique_code = 'window_' + js_create_unique_id();
  var basket_last_input_value = 0;
  var basket_last_input_new_value = 0;
  var sale_product = '<cfoutput>#sale_product#</cfoutput>';
  var amount_round = <cfoutput>#amount_round#</cfoutput>; <!--- //miktarın virgulden sonraki basamak sayısı --->
  var price_round_number = <cfoutput>#price_round_number#</cfoutput>; <!--- //satır fiyat alanlarının virgulden sonraki basamak sayısı --->
  var basket_total_round_number = <cfoutput>#basket_total_round_number#</cfoutput>; <!--- //basket genel toplamdaki alanlarının virgulden sonraki basamak sayısı --->
  var basket_rate_round_number = <cfoutput>#basket_rate_round_number#</cfoutput>; <!--- //basket kur bilgisinin virgulden sonraki basamak sayısı --->
  var use_basket_project_discount_ = <cfoutput>#use_basket_project_discount_#</cfoutput>; <!--- //baskette proje iskontoları calıstırılsın mı --->
  <!---var rowCount = document.getElementById('rows_').value;--->
  var basket_member_id = '';<!--- 20060228 promlarda kullanmak uzere baskete secilen uyeyi tutuyor --->
  // dsp_basket_js_scripts dosyasında yer alan standart değerler atanıyor.
  var changeable_value = new Array();
  
  // Satınalma teklifinde kullanılıyor. //AAO
  <cfif ListFindNoCase(display_list, "deliver_dept_assortment") and attributes.basket_id eq 5>
	  departmentArray = new Array(1);
	  if(window.basket.items[0].DEPARTMENT_ARRAY != undefined)
	  {
		  for(i=0;i<window.basket.items.length;i++)
		  {
			  temp_row = window.basket.items[i];
			  departmentArray[i] = new Array(1);
			  for(k=0; k<=window.basket.items[i].DEPARTMENT_ARRAY.length;k++)
			  {
				  departmentArray[i][k] = new Array(1);
				  departmentArray[i][k][0] = temp_row.DEPARTMENT_ARRAY.AMOUNT; <!--- // miktar --->
				  departmentArray[i][k][1] = temp_row.DEPARTMENT_ARRAY.DEPARTMENT_ID; <!--- // departman --->
				  departmentArray[i][k][2] = temp_row.DEPARTMENT_ARRAY.LOCATION_ID; <!--- // lokasyon --->
			  }
		  }
	  }
  </cfif>
  
  function apply_deliver_date(date_field_name,project_field_name)
  { /*taksitli satış ve satış siparişinde xmle baglı olarak cagrılıyor. belgenin teslim tarihini, satırlardaki boş teslim tarihi alanlarına aktarıyor.*/
	  /*teslim tarihi kısmı*/
	  if(date_field_name != '')
	  {
		  if($("#basket_main_div #" + date_field_name).val().length != 0)
			  row_deliver_date_ = $("#basket_main_div #" + date_field_name).val();
		  else
			  row_deliver_date_='';
			  
		  if(row_deliver_date_ != '')
		  {
			  for(var row_db=0;row_db<window.basket.items.length;row_db++)
			  {
				  if(!(window.basket.items[row_db].DELIVER_DATE.length))
				  {
					  window.basket.items[row_db].DELIVER_DATE = row_deliver_date_;
					  $("#tblBasket tr[basketItem]").eq(row_db).find("#deliver_date").val(row_deliver_date_);
				  }
			  }
			  
		  }
	  }
	  /*proje kısmı*/
	  if(project_field_name != undefined && project_field_name != '')
	  {
		  if($("#basket_main_div #" + project_field_name).val().length != 0)
		  {
			  row_project_id_ = $("#basket_main_div #project_id_in").val();
			  row_project_name_ = $("#basket_main_div #project_head_in").val();
		  }
		  else
		  {
			  row_project_id_='';
			  row_project_name_='';
		  }
		  if(row_project_id_ == undefined && $("#basket_main_div #" + project_field_name).val().length != 0){
			  row_project_id_ = $("#basket_main_div #project_id").val();
			  row_project_name_ = $("#basket_main_div #project_head").val();
		  }
		  //console.log(row_project_name_);
		  if(row_project_name_ != '' && row_project_id_ != '')
		  {
			  for(var row_db=0;row_db<window.basket.items.length;row_db++)
			  {
				  window.basket.items[row_db].ROW_PROJECT_ID = row_project_id_;
				  window.basket.items[row_db].ROW_PROJECT_NAME = row_project_name_;
				  $("#tblBasket tr[basketItem]").eq(row_db).find("#row_project_id").val(row_project_id_);
				  $("#tblBasket tr[basketItem]").eq(row_db).find("#row_project_name").val(row_project_name_);
			  }
		  }
	  }
	  return true;
  }
  
  <cfif ListFindNoCase(display_list, "basket_work")>
	  function open_basket_work_popup(satir)
	  {
		  var field_project_id_ = '';
		  var field_project_name_ = '';
		  var field_work_name_ = 'row_work_name';
		  var field_work_id_ ='row_work_id';
		  var data = window.basket.items[satir];
		  <cfif ListFindNoCase(display_list, "basket_project")>
			  if(data.ROW_PROJECT_ID != null)
			  {
				  var field_project_name_ = data.ROW_PROJECT_NAME;
				  var field_project_id_ = data.ROW_PROJECT_ID;
			  }
		  </cfif>
		  windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_add_work&field_id='+field_work_id_+'&field_name='+field_work_name_+'&project_id='+field_project_id_+'&project_head='+field_project_name_+'&satir='+satir,'list');
	  }
  </cfif>
  
  <cfif listfind("1,2,4,6,18,20,33,51",attributes.basket_id,",")>var temp_paymethod = temp_card_paymethod = temp_paymethod_vehicle = '';</cfif>
  
  <cfif ListFindNoCase(display_list, "lot_no")>
	  function open_lot_no_list(satir)
	  {
		  form_stock_code = window.basket.items[satir].STOCK_CODE;
		  product_id = window.basket.items[satir].PRODUCT_ID;
		  stock_id = window.basket.items[satir].STOCK_ID;
  
		  sepet_process_obj = findObj("process_cat");
		  
		  var is_cost=<cfif ListFindNoCase(display_list, "net_maliyet")>1<cfelse>0</cfif>; 
		  var is_price = <cfif ListFindNoCase(display_list, "price")>1<cfelse>0</cfif>;
		  var is_price_other = <cfif ListFindNoCase(display_list, "price_other")>1<cfelse>0</cfif>;
		  <cfif listfind("1,2,4,6,10,11,17,18,20,21",attributes.basket_id)>/*listfind("1,6,11,17,20",attributes.basket_id) and not sale_product*/
			  var str_tlp_comp = "&branch_id=" + form_basket.branch_id.value;
		  <cfelse>
			  var str_tlp_comp="";
		  </cfif>
		  var aranan_tarih="";
		  var department_str = ""
		  var temp_project_id = ""
		  
		  sepet_process_obj = findObj("process_cat");
		  if(sepet_process_obj != null)
			  sepet_process_type = process_type_array[sepet_process_obj.selectedIndex];
		  else
			  sepet_process_type = -1;
		  
		  if(listfind('76,81',sepet_process_type) != -1) //81:depo sevk irs 76 alış irsaliyesi
		  {
			  department_str = '&department_out=' + $("#basket_main_div #department_id").val() + '&location_out=' + $("#basket_main_div #location_id").val();
		  }
		  if(listfind('111,112,113',sepet_process_type) != -1) //111:sarf fisi, 112:fire fisi, 113:ambar fisi
		  {
			  department_str = '&department_out=' + $("#basket_main_div #department_out").val() + '&location_out=' + $("#basket_main_div #location_out").val();
		  }
		  if(listfind('2,10,18,21,48,14',window.basket.hidden_values.basket_id) != -1) // Satış Faturası, Stok Satış İrsaliyesi, Şube Satış Faturası, Şube Satış İrsaliyesi, Servis Giriş
		  {
			  department_str = '&department_out=' + $("#basket_main_div #department_id").val() + '&location_out=' + $("#basket_main_div #location_id").val();
				  
		  }
		  if(listfind('4,51', window.basket.hidden_values.basket_id) != -1) // Satış Siparişi, Taksitli Satış
		  {
			  department_str = '&department_out=' + $("#basket_main_div #deliver_dept_id").val() + '&location_out=' + $("#basket_main_div #deliver_loc_id").val();
		  }
		  if(listfind('7', window.basket.hidden_values.basket_id) != -1) // İç Talep
		  {
			  department_str = '&department_out=' + $("#basket_main_div #department_id").val() + '&location_out=' + $("#basket_main_div #location_id").val();
		  }
		  
		  url_str='<cfoutput>&int_basket_id=#attributes.basket_id#<cfif listgetat(attributes.fuseaction,1,'.') is 'store'>&is_store_module=1</cfif></cfoutput><cfif listgetat(attributes.fuseaction,2,'.') contains 'internaldemand'>&demand_type=0</cfif>&update_product_row_id='+satir+'<cfif listfind("1,2,4,6,18,20,33,51",attributes.basket_id,",")>&paymethod_id='+temp_paymethod+'&card_paymethod_id='+temp_card_paymethod+'&paymethod_vehicle='+temp_paymethod_vehicle+'</cfif><cfoutput query="get_money_bskt">&'+eval("form_basket.hidden_rd_money_"+#currentrow#+".value")+'='+(filterNumBasket(eval("form_basket.txt_rate2_"+#currentrow#+".value"),4)/filterNumBasket(eval("form_basket.txt_rate1_"+#currentrow#+".value"),4))+'</cfoutput>&rowCount='+satir+'&is_sale_product='+sale_product+'&is_price='+is_price + "&is_price_other=" +is_price_other + "&is_cost=" + is_cost + str_tlp_comp + department_str + "&search_process_date=" + aranan_tarih+"&project_id="+temp_project_id+'&is_lot_no_based=1&prod_order_result_=1&satir='+satir;
		  if(sepet_process_obj != null)
			  url_str = url_str + '&sepet_process_type='+process_type_array[sepet_process_obj.selectedIndex];
		  else
			  url_str = url_str + '&sepet_process_type=-1';
		  url_str = url_str+ '&pid='+ product_id + '&sid='+stock_id+'&keyword=' + form_stock_code;
		  url_str = url_str+ '&sort_type=1';
		  windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_products'+url_str,'list');	
	  }
  </cfif>
  
  
  <cfif ListFindNoCase(display_list, "basket_project")>
	  function open_basket_project_popup(satir)
	  {
		  var field_project_name_ = 'row_project_name';
		  var field_project_id_ ='row_project_id';
		  openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_projects&project_id=form.'+field_project_id_+'&project_head=form.'+field_project_name_+'&satir='+satir);
	  }
  </cfif>
  <cfif ListFindNoCase(display_list, "basket_employee")>
	  function open_basket_employee_popup(satir)
	  {
		  var field_basket_emp_name_ = 'basket_employee';
		  var field_basket_emp_id_ ='basket_employee_id';
		  windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&select_list=1&field_emp_id='+field_basket_emp_id_+'&field_name='+field_basket_emp_name_+'&satir='+satir,'list');
	  }
  </cfif>
  function open_basket_locations(satir)
  {
		  var field_name = 'basket_row_departman';
		  var field_id ='deliver_dept';
		  var row_id = satir;
		  windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_stores_locations&form_name=form_basket&field_name='+field_name+'&field_id='+field_id+'&row_id='+satir+'&satir='+satir,'list');
  }
  
  <cfif ListFindNoCase(display_list, "product_name")>
	  function open_product_popup(satir)
	  {
		  url_str = '<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_detail_product';
		  var data = window.basket.items[satir];
		  var stock_id = data.STOCK_ID;
		  var product_id = data.PRODUCT_ID;
		  var spect_id = data.SPECT_ID;
		  var spect_name = data.SPECT_NAME;
		  if(spect_id != undefined && spect_id != '' && spect_name != '')
			  url_str = url_str+'&spec_id='+spect_id;
		  
		  <cfif fusebox.circuit eq 'store'>
			  url_str = url_str + '&is_store_module=1';
		  </cfif>
		  if(product_id != "")
			  openBoxDraggable(url_str + '&pid='+ product_id + '&sid='+stock_id);
	  }
	  <cfif isdefined("session.ep.user_level") and get_module_user(5)>
		  function open_product_price_history(satir)
		  {
			  url_str = '<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_std_sale&price_type=purc';
			  var data = window.basket.items[satir];
			  var product_id = data.PRODUCT_ID;
			  
			  if($("#basket_main_div #company_id").length != 0 && $("#basket_main_div #company_id").val().length != 0)
				  url_str=url_str + '&company_id=' + $("#basket_main_div #company_id").val();
			  
			  if($("#basket_main_div #branch_id").length != 0 && $("#basket_main_div #branch_id").val().length != 0)
				  url_str=url_str + '&branch_id=' + $("#basket_main_div #branch_id").val();
				  
			  if(product_id != "")
				  openBoxDraggable(url_str + '&pid='+ product_id);
		  }
	  </cfif>
	  //Niye yazılmış anlamadım. Kullanılmıyor.
	  function open_product_purchase_condition(satir)
	  {
		  url_str = '<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_contract';
		  if(satir)
			  satir_ = satir;
		  else
			  satir_ = 0;
		  
		  product_id = window.basket.items[satir_].PRODUCT_ID;
		  stock_id = window.basket.items[satir_].STOCK_ID;
		  
		  if(product_id != '')
			  windowopen(url_str + '&pid='+ product_id,'list');		
	  }
	  //Niye yazılmış anlamadım. Kullanılmıyor.
  </cfif>
  <cfif ListFindNoCase(display_list, "price")>
	  // Basket şablonlarındaki fiyat parametresine bağlı olarak fiyat detay popup'ını açar.
	  function open_price(satir)
	  {
		  url_str = '<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_price_history_js';
		  var data = window.basket.items[satir];
		  var product_id = data.PRODUCT_ID;
		  var stock_id = data.STOCK_ID;
		  var product_name = '';
		  var unit_ = data.UNIT;
			  
		  <!--- // process_type değişkeni --->
		  sepet_process_obj = findObj("process_cat");
		  if(sepet_process_obj != null)
			  url_str = url_str + '&sepet_process_type='+process_type_array[sepet_process_obj.selectedIndex];
		  else
			  url_str = url_str + '&sepet_process_type=-1';
		  <!--- // process_type değişkeni --->
		  url_str = url_str + '&product_id=' + product_id + '&stock_id=' + stock_id + '&pid=' + product_id + '&product_name=' + product_name + '&unit=' + unit_ + '&row_id=' + satir;
		  
		  if($("#basket_main_div #company_id").length != 0 && $("#basket_main_div #company_id").val().length != 0)
			  url_str = url_str + '&company_id=' + $("#basket_main_div #company_id").val();
		  if($("#basket_main_div #consumer_id").length != 0 && $("#basket_main_div #consumer_id").val().length != 0)
			  url_str = url_str + '&consumer_id=' + $("#basket_main_div #consumer_id").val();
		  
		  <cfif fusebox.circuit eq 'store'>
			  url_str = url_str + '&is_store_module=1';
		  </cfif>
		  <cfloop query="get_money_bskt">
			  url_str = url_str + '&<cfoutput>#money_type#=#rate2/rate1#</cfoutput>';
		  </cfloop>
		  if(product_id != "")
			  windowopen(url_str,'medium');
	  }
  </cfif>
  
  // Kendisine integer olarak gelen sayıyı nokta ve virgüllü bir hale dönüştürür. 3. parametre olan no_of_decimal ise virgülden sonraki yuvarlanacak hane sayısını belirler.
  function TlFormat(evt, money,no_of_decimal,is_round)
  {
	  if (evt != null) money = $(evt.target).val();
	  if(!money) return '';
	  money = money.toString().replace(/\./g,'');
	  // escape from format
	  if (isNaN(Number(money))) 
		  money = Number(money.replace(/\./g, "").replace(",", "."));
	  if(no_of_decimal == null || !$.isNumeric(no_of_decimal)) 
		  no_of_decimal= 2;	
	  money = $.trim(money);
	  if (money.indexOf('E')>-1) money = money.replace(/,/g,'','all');
	  if (money.indexOf('-')>-1)
	  {
		  negativeFlag = 1;
		  money =  money.replace(/-/g,'','all');
	  }
	  else negativeFlag = 0;
	  nokta = money.indexOf('.');
	  if(nokta>-1)
	  {
		  /*
		  if(is_round) // 20050823 and arguments.no_of_decimal *
		  {
			  rounded_value = CreateObject("java", "java.math.BigDecimal");
			  rounded_value.init(arguments.money);
			  rounded_value = rounded_value.setScale(arguments.no_of_decimal, rounded_value.ROUND_HALF_UP);
			  rounded_value = rounded_value.toString();
			  if(rounded_value contains '.') //10.00 degeri yerine 10 dondurmek icin
			  {
				  if(listlast(rounded_value,'.') eq 0)
					  rounded_value = listfirst(rounded_value,'.');
			  }
			  arguments.money = rounded_value;
			  if (arguments.money contains 'E') 
			  {
				  first_value = listgetat(arguments.money,1,'E-');
				  first_value = ReplaceNoCase(first_value,',','.');
				  last_value = ReplaceNoCase(listgetat(arguments.money,2,'E-'),'0','','all');
				  for(kk_float=1;kk_float lte last_value;kk_float=kk_float+1)
				  {
					  zero_info = ReplaceNoCase(first_value,'.','');
					  first_value = '0.#zero_info#';
				  }
				  arguments.money = first_value;
				  first_value = listgetat(arguments.money,1,'.');
				  arguments.money = "#first_value#.#Left(listgetat(arguments.money,2,'.'),8)#";
				  if(arguments.money lt 0.00000001) arguments.money = 0;
				  if(Find('.', arguments.money))
				  {
					  arguments.money = "#first_value#,#Left(listgetat(arguments.money,2,'.'),8)#";
					  return arguments.money;
				  }
			  }
		  }
		  
		  */
		  if(!money != 0) nokta = Find('.', money);
		  if(ceiling(money) != money)
		  {
			  tam = ceiling(money)-1;
			  tam = tam.toString();
			  onda = mid(money, nokta+1,no_of_decimal);
			  if(len(onda) < no_of_decimal)
				  onda = onda + RepeatString('0',no_of_decimal-len(onda));
		  }
		  else
		  {
			  tam = money;
			  onda = RepeatString('0',no_of_decimal);
		  }
	  }
	  else
	  {
		  tam = money;
		  onda = RepeatString('0',no_of_decimal);
	  }
	  textFormat='';
	  t=0;
	  if (tam.length > 3) 
	  {
		  for (k=tam.length; k; k=k-1)
		  {
			  t = t + 1;
			  if(!(t % 3))
				  textFormat = '.' + mid(tam, k-1, 1) + textFormat;
			  else
				  textFormat = mid(tam, k-1, 1) + textFormat;
			  
		  }
		  if(textFormat.substr(0,1) == '.')
			  textFormat = textFormat.substr(1,len(textFormat)-1);
		  if (mid(textFormat, 1, 1) == '.') 
			  textFormat =  right(textFormat,len(textFormat))+","+onda;
		  else 
			  textFormat =  textFormat+","+onda;
	  }
	  else
		  textFormat = tam+','+onda;
  
	  if (negativeFlag) textFormat =  "-"+textFormat;
	  
	  if (!no_of_decimal) 
		  textFormat = ListFirst(textFormat,',');
	  
	  var result;
	  //if((isDefined("session.ep.language") && !session.ep.language == 'tr'))
	  <cfif (isdefined("moneyformat_style") and moneyformat_style eq 0) or not isdefined("moneyformat_style")>
		  textFormat = replace(textFormat,'.','*','all');
		  textFormat = replace(textFormat,',','.','all');
		  textFormat = replace(textFormat,'*',',','all');
		  
		  if (!no_of_decimal) 
			  result = ListFirst(textFormat,'.');
		  else 
			  result = textFormat;
	  <cfelse>
		  if (!no_of_decimal) 
			  result = ListFirst(textFormat,',');
		  else 
			  result = textFormat;
	  </cfif>
  
	  if (evt != null){
		  $(evt.target).val(result);
	  } else {
		  return result;
	  }
  }
  
  function AmountFormat(evt, money, no_of_decimal)
  {
	  if (evt != null) money = $(evt.target).val();
	  if(!money) return '';
	  // escape from format
	  if (isNaN(Number(money))) money = Number(money.replace(".", "").replace(",", "."));
	  if(no_of_decimal == null || !$.isNumeric(no_of_decimal)) 
		  no_of_decimal= 2;
		  
	  money = $.trim(money);
	  if (money.indexOf('E')>-1) money = money.replace(/,/g,'','all');
	  if (money.indexOf('-')>-1)
	  {
		  negativeFlag = 1;
		  money =  money.replace(/-/g,'','all');
	  }
	  else negativeFlag = 0;	
  
	  nokta = money.indexOf('.');
	  if (nokta)
	  {
		  tam = mid(money, 1, nokta-1);
		  onda = mid(money, nokta+1,no_of_decimal);
	  }
	  else
	  {
		  tam = money;
		  onda = RepeatString(0,no_of_decimal);
	  }
	  
	  textFormat='';
	  t=0;
	  if (tam.length > 3) 
		  {
			  for (k=tam.length; k; k=k-1)
			  {
				  t = t + 1;
				  if(!(t % 3))
					  textFormat = '.' + mid(tam, k-1, 1) + textFormat;
				  else
					  textFormat = mid(tam, k-1, 1) + textFormat;
				  
			  }
			  if(textFormat.substr(0,1) == '.')
				  textFormat = textFormat.substr(1,len(textFormat)-1);
			  if (mid(textFormat, 1, 1) == '.') 
				  textFormat =  right(textFormat,len(textFormat))+","+onda;
			  else 
				  textFormat =  textFormat+","+onda;
		  }
	  else
		  textFormat = tam+','+onda;
  
	  if (negativeFlag) textFormat =  "-"+textFormat;
	  
	  var result;
	  //if((isDefined("session.ep.language") && !session.ep.language == 'tr'))
	  <cfif (isdefined("moneyformat_style") and moneyformat_style eq 0) or not isdefined("moneyformat_style")>
		  textFormat = replace(textFormat,'.','*','all');
		  textFormat = replace(textFormat,',','.','all');
		  textFormat = replace(textFormat,'*',',','all');
		  
		  if (!no_of_decimal) 
			  result = ListFirst(textFormat,'.');
		  else 
			  result = textFormat;
	  <cfelse>
		  if (!no_of_decimal) 
			  result = ListFirst(textFormat,',');
		  else 
			  result = textFormat;
	  </cfif>
  
	  if (evt != null){
		  $(evt.target).val(result);
	  } else {
		  return result;
	  }
  }
  
  
  // ColdFusion kodlarının JS dönüşümleri
  function RepeatString(str,count) // Kendisine gönderilen ilk parametreyi ikinci parametre kadar çoğaltır
  {
	  text = str;
	  if(text)
	  {
		  if(count)
		  {
			  for(i=1;i<count;i++)
				  text = text + str;
		  }
		  else
			  text = str;
	  }
	  else
		  text = '';
	  
	  return text;
  }
  
  function mid(str, start, len)
  {
	  if (start < 0 || len < 0) return "";
  
	  var iEnd, iLen = String(str).length;
	  if (start + len > iLen)
			  iEnd = iLen;
	  else
			  iEnd = start + len;
  
	  return String(str).substring(start,iEnd);
  }
  function left(str, n)
  {
	  if (n <= 0)
		  return "";
	  else if (n > String(str).length)
		  return str;
	  else
		  return String(str).substring(0,n);
  }
  function right(str, n)
  {
	  if (n <= 0)
		 return "";
	  else if (n > String(str).length)
		 return str;
	  else {
		 var iLen = String(str).length;
		 return String(str).substring(iLen, iLen - n);
	  }
  }
  function len(str)
  {
	  return str.length;	
  }
  function ListFirst(str,delimiter)
  {
	  if(!delimiter)
		  delimiter = ',';
		  
	  return str.substr(0,str.indexOf(delimiter));
  }
  
  function ListLast(str,delimiter)
  {
	  if(!delimiter)
		  delimiter = ',';
		  
	  return str.substr(str.indexOf(delimiter)+1,str.length-str.indexOf(delimiter));
  }
  function ceiling(str)
  {
	  return Math.ceil(str);
  }
  function Find(delim,str)
  {
	  return str.indexOf(delim);
  }
  // ColdFusion kodlarının JS dönüşümleri
  
  // Baskette urun secilmisse belgede seçilen projenin değistirilmesini engeller
  function check_project_changes()
  {
  <cfif ListFindNoCase(display_list, "is_project_not_change")>
	  var str_control = 0;
	  for(i=0;i<window.basket.items.length;i++)
	  {
		  if(window.basket.items[i].PRODUCT_ID)
		  {
			  str_control = 1;
			  break;
		  }
	  }
	  if(str_control == 1)
	  {
		  $("#basket_main_div #project_head").attr('readonly', true);
		  alert("Belgede Satırlar Seçilmiş Proje Değiştiremezsiniz");
		  return false;
	  }
	  else
		  AutoComplete_Create('project_head','PROJECT_ID,PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','form_basket','3','135');		
  <cfelse>
	  AutoComplete_Create('project_head','PROJECT_ID,PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','form_basket','3','135');
	  return true;
  </cfif>
  }
  
  // AAO.
  function control_prod_discount(cntrl_row) 
  {//sadece taksitli satıs (52) basketinde calısıyor. urun 1.kosulu ile basketteki 1. iskontosunu karsilastirip kullanıcıyı uyarıyor.
	  input_value = $("#basket_main_div #" + $("#basket_main_div #search_process_date").val()).val();
  
	  if($("#basket_main_div #paymethod_id").length != 0 && $("#basket_main_div #paymethod_id").val().length != 0)
	  {
		  if(cntrl_row)
			  row_ = cntrl_row;
		  else
			  row_ = 0;
			  
		  var cntrl_product_id_ = window.basket.items[row_].PRODUCT_ID;
		  var cntrl_row_discount_ = window.basket.items[row_].INDIRIM1;
		  
		  if(cntrl_product_id_ != undefined)
		  {
			  var disc_valid_date = js_date(input_value.toString());
			  var listParam = cntrl_product_id_ + "*" + $("#basket_main_div #paymethod_id").val() + "*" + disc_valid_date ;
			  var get_prod_max_discount = wrk_safe_query("obj_get_prod_max_discount","dsn3",0,listParam);
			  if(get_prod_max_discount.recordcount != undefined && get_prod_max_discount.recordcount != 0 && get_prod_max_discount.DISCOUNT1 < cntrl_row_discount_)
				  alert(parseInt(cntrl_row+1) +'.Satırdaki Ürün İçin Geçerli Max. İskonto Oranı :'+ get_prod_max_discount.DISCOUNT1 + ' dir.');	
		  }
	  }
  }
  
  //  Basket formunda yer alan Vade ve Vade Tarihi alanlarını değiştirir.
  function change_paper_duedate(field_name,type,is_row_parse)
  {
	  $(document).ready(function() // Form sayfalarında da kullanılan bu fonksiyon basket hazır olduğu zaman kontrol edilmeli.
	  {		
		  if(field_name == undefined || field_name=='')
			  paper_date_ = $("#basket_main_div #" + $("#basket_main_div #search_process_date").val()).val();
		  else
			  paper_date_ =  $("#basket_main_div #" + field_name).val();
  
		  if($("#basket_main_div #paymethod_id") != undefined && $("#basket_main_div #paymethod_id").val() != "" && $("#basket_main_div #paymethod").val() != "")
		  {
			  ////var pay_type = 1;
			  var paymethod_id_ = $("#basket_main_div #paymethod_id").val();
			  var is_holiday = 0;
			  var is_nextday = 0;
			  var data = "";
			  add_url_ = "";
			  //fonksiyonu çağıran yere göre cfc için urle ek alanlar ekleniyor
			  add_url_ = "";
			  var callfunction = "";
			  if(change_paper_duedate.caller != null) callfunction = change_paper_duedate.caller.toString();
			  if(type == 2 || (!callfunction.includes("check_member") && (callfunction.includes("function onchange(event)") || callfunction.includes("function onChange(event)"))) ){
				  if(type == 1){
					  add_url_ = "&due_date="+$("#basket_main_div #basket_due_value_date_").val();
				  }else{
					  
					  add_url_ = "&due_day="+$("#basket_main_div #basket_due_value").val();
				  }
				  
			  }
			  if(paymethod_id_ != ''){
				  $.ajax({ url :'cfc/paymethod_calc.cfc?method=calc_duedate&isAjax=1&action_date=' + paper_date_+'&paymethod_id='+paymethod_id_+add_url_, async:false,success : function(res){
					  data = res.replace('//""','');
					  data = $.parseJSON( data );
					  }
				  });
				  if(data != ""){
					  is_holiday = data.ISHOLIDAY;
					  is_nextday = data.NEXT_DAY;
					  $("#basket_main_div #basket_due_value").val(data.DAYDIFF);
					  $("#basket_main_div #basket_due_value_date_").val(data.DUE_DATE);
				  }else{
					  alert("Vade hesaplamasında hata oluştu!");
				  }
				  if(is_row_parse==undefined){
					  if(is_holiday)
						  alert("Ödeme Yönteminde Genel Tatil ve Hafta Tatilinde Vade İlk İş Gününe Ertelensin Parametresi Seçili. Vade Tarihi İlk İş Gününe Ertelendi!");
					  if(is_nextday)
						  alert("Ödeme Yönteminde hafta günü seçili. Vade Tarihi Düzenlendi!");
				  }
			  }
		  }
  
		  if(type!=undefined && type==1)
			  $("#basket_main_div #basket_due_value").val(datediff(paper_date_,$("#basket_main_div #basket_due_value_date_").val(),0));
		  else //if(type!=undefined && type!=2)
		  {
			  if(isNumber($("#basket_main_div #basket_due_value").val()) != false && $("#basket_main_div #basket_due_value").val() != 0)
			  {
				  $("#basket_main_div #basket_due_value_date_").val(date_add('d',parseFloat($("#basket_main_div #basket_due_value").val()),paper_date_));
			  }
			  else
			  {
				  $("#basket_main_div #basket_due_value_date_").val(paper_date_);
				  if($("#basket_main_div #basket_due_value").val() == '')
				  {
					  $("#basket_main_div #basket_due_value").val(datediff(paper_date_,$("#basket_main_div #basket_due_value_date_").val(),0));
				  }
			  }
		  }
		  
		  //Niye yazılmış anlamadım.
		  paper_due_day = $("#basket_main_div #basket_due_value").val();
		  //Niye yazılmış anlamadım.
  
		  //vade gun sayısı vadesi bos olan basket satırlarına yansıtılır
		  if(is_row_parse==undefined || is_row_parse==1) //apply_duedate > set_paper_duedate >change_paper_duedate zincirinde cagrılmıssa satırlar tekrar kontrol edilmez
		  {
			  apply_duedate(1,paper_due_day);	
		  }
	  })
  }
  // Vade tarihi alanı resmi tatile ve haftasonu tatiline denk gelirse ilgili vade tarihinin ilk iş gününe alınmasını kontrol ediyor.ödeme yöntemleri sayfasındaki 'Genel Tatil ve Hafta Tatilinde Vade İlk İş Gününe Ertelensin' checkbox değerine göre çalışıyor.
  function control_due_date(vade_input,paymethod_id,paper_date_field)
  {
  
	  if(paymethod_id != undefined && paymethod_id != '')
	  {
  
		  var is_holiday = 0;
		  var is_nextday = 0;
		  var data = "";
		  if(paper_date_field == undefined)
			  paper_date_field =$("#basket_main_div #" + $("#basket_main_div #search_process_date").val());
		  
		  $.ajax({ url :'cfc/paymethod_calc.cfc?method=calc_duedate&isAjax=1&action_date=' + paper_date_field.val()+'&paymethod_id='+paymethod_id, async:false,success : function(res){
			  data = res.replace('//""','');
			  data = $.parseJSON( data );
			  }
		  });
		  if(data != ""){
			  paper_date_field.value = data.DUE_DATE;	
			  is_holiday = data.ISHOLIDAY;
			  is_nextday = data.NEXT_DAY;
			  date_diff = data.DAYDIFF;
		  }
		  
		  $("#basket_main_div #basket_due_value").val(date_diff);
		  
		  if(is_holiday)
			  alert("Ödeme Yönteminde Genel Tatil ve Hafta Tatilinde Vade İlk İş Gününe Ertelensin Parametresi Seçili. Vade Tarihi İlk İş Gününe Ertelendi!");
		  if(is_nextday)
			  alert("Ödeme Yönteminde sonraki hafta günü seçili. Vade Tarihi Ertelendi!");
	  }
  
	  var tarih_kontrol = 0;
	  var paymethod_id_ = 0;
	  var pay_type = 0;
	  if(paymethod_id != undefined && paymethod_id != '')
	  {	
		  paymethod_id_ = paymethod_id;
		  pay_type = 1;
	  }
	  if(paymethod_id_ != 0)
	  {
		  var sls_pay_control =  wrk_safe_query("sls_pay_control","dsn",0,paymethod_id_);
		  if(sls_pay_control.recordcount && sls_pay_control.IS_DATE_CONTROL == 1)
		  {			
			  resmi_tatil();
			  hafta_tatil();
			  function resmi_tatil()
			  {
				  var due_date = document.getElementById(vade_input).value;   
				  var listParam = js_date(due_date); 
				  var get_setup_general_offtimes =  wrk_safe_query("get_setup_general_offtimes","dsn",0,listParam);
				  if(get_setup_general_offtimes.recordcount)
				  {  
					  gun_farki = get_setup_general_offtimes.FARK;
					  document.getElementById(vade_input).value = date_add('d',parseInt(gun_farki)+parseInt(1),due_date);
					  tarih_kontrol = 1;
				  }
				  if(get_setup_general_offtimes.IS_HALFOFFTIME == 1)
					  resmi_tatil();					
			  }
			  function hafta_tatil()
			  {
				  var due_date2 =  document.getElementById(vade_input).value; 		
				  var start_d = document.getElementById(vade_input).value.split(/\D+/);// \D sayı olmayan karakterleri temsil ediyor.
				  var d1=new Date(start_d[2]*1, start_d[1]-1, start_d[0]*1);
				  var weekday = d1.getDay();
				  if(weekday==6)
				  {
					  document.getElementById(vade_input).value = date_add('d',parseInt(2),due_date2);
					  tarih_kontrol = 1;
				  }
				  else if(weekday==0)
				  {
					  document.getElementById(vade_input).value = date_add('d',parseInt(1),due_date2);
					  tarih_kontrol = 1;
				  }
				  resmi_tatil();
			  }
			  if(tarih_kontrol == 1)
			  {
				 alert("Ödeme Yönteminde Genel Tatil ve Hafta Tatilinde Vade İlk İş Gününe Ertelensin Parametresi Seçili. Vade Tarihi İlk İş Gününe Ertelendi!");
			  }
		  }
	  }
  }
  <cfif ListFindNoCase(display_list, "pbs_code")>
	  // PBS Code liste popup'ını açar.
	  function open_pbs_list(satir,satir_sayisi,list_type,field_id,field_name)
	  {
		  if(satir)
			  satir_ = satir;
		  else
			  satir_ = 0;
  
		  windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pbs_code&is_single&row_id='+satir+'&form_name=form_basket&field_name='+field_name+'&field_id='+field_id+'&is_from_basket=1&row_count='+satir_sayisi+'&satir='+satir,'list','pbs_list_page');
	  }
  </cfif>
  
  <cfif ListFindNoCase(display_list, "basket_exp_center")>
	  // Masraf Merkezi popup'ını açar
	  function open_basket_exp_center_popup(satir)
	  {
		  <!--- xml'e bağlı olarak masraf/gelir merkezine bağlı bütçe kalemleri ilişkisi kurulsun. MK 211119 --->
		  <cfif ListFindNoCase(display_list, "basket_exp_center") and isdefined("x_authorized_branch_department") and len(x_authorized_branch_department) and x_authorized_branch_department eq 1>
			  windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_expense_center&x_authorized_branch_department=1&satir='+satir,'list');
		  <cfelse>
			  windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_expense_center&satir='+satir,'list');
		  </cfif>
	  }
  </cfif>
  
  <cfif ListFindNoCase(display_list, "row_subscription_name")>
	  // Abone popup'ını açar
	  function open_subscription_popup(satir)
	  {
		  windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_subscription&satir='+satir,'list');
	  }
  </cfif>
  
  <cfif ListFindNoCase(display_list, "row_assetp_name")>
	  // Fiziki Varlık popup'ını açar
	  function open_assetp_popup(satir)
	  {
		  windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=assetcare.popup_list_assetps&event_id=0&satir='+satir,'list');
	  }
  </cfif>
  
  <cfif ListFindNoCase(display_list, "basket_exp_item")>
	  // Bütçe Kalemi popup'ını açar
	  function open_basket_exp_item_popup(satir)
	  {
		  <!--- xml'e bağlı olarak masraf/gelir merkezine bağlı bütçe kalemleri ilişkisi kurulsun. MK 211119 --->
		  <cfif ListFindNoCase(display_list, "basket_exp_center") and isdefined("xml_expense_center_budget_item") and len(xml_expense_center_budget_item) and xml_expense_center_budget_item eq 1>
			  var ExpId = window.basket.items[satir].ROW_EXP_CENTER_ID;
			  windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_exp_item&is_exp=1&expense_center_id='+ExpId+'&satir='+satir,'list');
		  <cfelse>
			  windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_exp_item&satir='+satir,'list');
		  </cfif>
	  }
  </cfif>
  
  <cfif ListFindNoCase(display_list, "basket_exp_item")>
	  // Muhasebe Kodu popup'ını açar
	  function open_basket_acc_code_popup(satir)
	  {
		  windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&satir='+satir+'','list');
	  }
  </cfif>
  
  // Teslim Tarihi için takvim popupını açar.
  function get_basket_date_deliver(field_name,field_row_)
  {
	  var basket_date_field_ = field_name;
	  windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_calender&alan='+basket_date_field_+'&satir='+field_row_+'&deliver=1','date');
  }
  
  // Rezerve Tarihi için takvim popupını açar.
  function get_basket_date_reserve(field_name,field_row_)
  {
	  var basket_date_field_ = field_name;
	  windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_calender&alan='+basket_date_field_+'&satir='+field_row_,'date');
  }
  
  // Seri No ekleme popup'ını açar.
  function add_seri_no(row_no)
  {		
		  sale_product_ = 0;
		  if(row_no)
			  row_no_ = row_no;
		  else
			  row_no_ = 0;
		  amount = window.basket.items[row_no_].AMOUNT;
		  amount_other = window.basket.items[row_no_].AMOUNT_OTHER;
		  product_id = window.basket.items[row_no_].PRODUCT_ID;
		  stock_id = window.basket.items[row_no_].STOCK_ID;
		  wrk_row_id = window.basket.items[row_no_].WRK_ROW_ID;
		  lot_no_row = window.basket.items[row_no_].LOT_NO;
		  var location_out_id_ = '';
		  var department_out_id_ = '';
		  process_date_ = $("#basket_main_div #" + $("#basket_main_div #search_process_date").val()).val().toString();
		  if($("#basket_main_div #is_delivered").is(":checked") == true)
			  is_delivered = 1;
		  else
			  is_delivered = 0;
		  var sepet_process_obj = findObj("process_cat");
		  process_cat = process_type_array[sepet_process_obj.selectedIndex];
		  if(process_cat == 811)
		  {
			  if($("#basket_main_div #location_in_id").val().length != 0)
			  {
				  if($("#basket_main_div #location_in_id").val() == '')
				  {
					  alert('Giriş Depo Seçmelisiniz!');
					  return false;	
				  }
				  else
				  {
					var location_out_id_ = $("#basket_main_div #location_id").val();
					var department_out_id_ = $("#basket_main_div #department_id").val();
					var location_id_ = $("#basket_main_div #location_id").val();
					var department_id_ = $("#basket_main_div #department_id").val();
				  }
			  }
			  else
			  {
				  var location_id_ = '';
				  var department_id_ = '';
			  }	
			  sale_product_ = 1;
		  }
		  else if (process_cat == 81)
			  {
				  if(document.form_basket.location_id != undefined)
				  {
					  var location_out_id_ = document.form_basket.location_id.value;
					  var department_out_id_ = document.form_basket.department_id.value;
				  }
				  else
				  {
					  var location_out_id_ = '';
					  var department_out_id_ = '';
				  }
				  sale_product_ = 1;
			  }
		  else if (process_cat == 111 || process_cat == 112 || process_cat == 113|| process_cat == 114|| process_cat == 115|| process_cat == 110|| process_cat == 119)
		  {
			  if($("#basket_main_div #location_out").val().length != 0)
			  {
				  var location_out_id_ = $("#basket_main_div #location_out").val();
				  var department_out_id_ = $("#basket_main_div #department_out").val();
				  var location_id_ = $("#basket_main_div #location_out").val();
				  var department_id_ = $("#basket_main_div #department_out").val();
			  }
			  else
			  {
				  var location_out_id_ = '';
				  var department_out_id_ = '';
				  var location_id_ = '';
				  var department_id_ = '';
			  }
			  if($("#basket_main_div #location_in").val().length != 0)
			  {
				  var location_id_ = $("#basket_main_div #location_in").val();
				  var department_id_ = $("#basket_main_div #department_in").val();
			  }
			  else
			  {
				  var location_id_ = '';
				  var department_id_ = '';
			  }
		  }
		  else
		  {
			  if($("#basket_main_div #location_id").val().length != 0)
			  {
				  if(process_cat == 71){
					  var location_out_id_ = $("#basket_main_div #location_id").val();
					  var department_out_id_ = $("#basket_main_div #department_id").val();
					  var location_id_ = $("#basket_main_div #location_id").val();
					  var department_id_ = $("#basket_main_div #department_id").val();
				  }
				  else{
					  var location_id_ = $("#basket_main_div #location_id").val();
					  var department_id_ = $("#basket_main_div #department_id").val();
				  }
			  }
			  else
			  {
				  var location_id_ = '';
				  var department_id_ = '';
			  }
		  }
		  if(process_cat == 70 || process_cat == 71 || process_cat == 82|| process_cat == 78|| process_cat == 79|| process_cat == 83|| process_cat == 88) sale_product_ = 1;
		  if($("#basket_main_div #company_id").length != 0 && $("#basket_main_div #company_id").val().length != 0)
			  company_id_ = $("#basket_main_div #company_id").val();
		  else
			  company_id_ = '';
		  if($("#basket_main_div #consumer_id").length != 0 && $("#basket_main_div #consumer_id").val().length != 0)
			  consumer_id_ = $("#basket_main_div #consumer_id").val();
		  else
			  consumer_id_ = '';
		  
		  <cfif listfind('11,12,47,48,1,20,2,18,31,32,47,15,17,11,49,10,14',attributes.basket_id)>
			  process_id = <cfif isdefined("WOStruct") and isStruct(WOStruct) and isdefined("attributes.event") and attributes.event contains 'upd' ><cfoutput>#WOStruct["#attributes.fuseaction#"]["upd"]["Identity"]#</cfoutput><cfelse>0</cfif>;    
		  </cfif>
		  <cfif attributes.basket_id eq 11>
			  paper_number_ = $("#basket_main_div #ship_number").val();
		  <cfelseif attributes.basket_id eq 12>
			  paper_number_ = $("#basket_main_div #fis_no_").val();
		  <cfelseif attributes.basket_id eq 47>
			  paper_number_ = $("#basket_main_div #ship_number").val();
		  <cfelseif attributes.basket_id eq 48>
			  paper_number_ = $("#basket_main_div #ship_number").val();
		  <cfelseif attributes.basket_id eq 1><!--- Alis faturasi --->
			  paper_number_ = $("#basket_main_div #serial_no").val();
		  <cfelseif attributes.basket_id eq 20><!--- Sube Alis faturasi --->
			  paper_number_ = $("#basket_main_div #serial_no").val();
		  <cfelseif attributes.basket_id eq 2><!--- Satis faturasi --->
			  paper_number_ = $("#basket_main_div #serial_no").val();
		  <cfelseif attributes.basket_id eq 18><!--- Sube Satis faturasi --->
			  paper_number_ = $("#basket_main_div #serial_no").val();
		  <cfelseif attributes.basket_id eq 31><!--- Depolararasi Sevk Irsaliyesi --->
			  paper_number_ = $("#basket_main_div #ship_number").val();
		  <cfelseif attributes.basket_id eq 32><!--- Depolararasi Sevk Irsaliyesi Sube--->
			  paper_number_ = $("#basket_main_div #ship_number").val();
		  <cfelseif attributes.basket_id eq 47><!--- servis modulunden alis irsaliyesi --->
			  paper_number_ = $("#basket_main_div #ship_number").val();
		  <cfelseif attributes.basket_id eq 15><!--- Stok Emirlerden Alis Irsaliyesi --->
			  paper_number_ = $("#basket_main_div #ship_number").val();
		  <cfelseif attributes.basket_id eq 17><!--- Sube Alis Irsaliyesi --->
			  paper_number_ = $("#basket_main_div #ship_number").val();
		  <cfelseif attributes.basket_id eq 11><!--- Alis Irsaliyesi --->
			  paper_number_ = $("#basket_main_div #ship_number").val();
		  <cfelseif attributes.basket_id eq 49><!--- Ithal Mal Girisi --->
			  paper_number_ = $("#basket_main_div #ship_number").val();
		  <cfelseif attributes.basket_id eq 10><!--- Satış İrsaliye --->
			  paper_number_ = $("#basket_main_div #ship_number").val();
		  <cfelseif attributes.basket_id eq 14>
			  paper_number_ = $("#basket_main_div #ship_number").val();
		  </cfif>	
		  
			  var win = window.open('<cfoutput>#request.self#</cfoutput>?fuseaction=stock.list_serial_operations&event=det&is_line=1&is_delivered='+is_delivered+'&process_number='+paper_number_+'&product_amount='+amount+'&product_amount_2='+amount_other+'&product_id='+product_id+'&stock_id='+stock_id+'&process_date='+process_date_+'&process_cat='+process_cat+'&process_id='+process_id+'&wrk_row_id='+wrk_row_id+'&lot_no='+lot_no_row+'&sale_product='+sale_product_+'&company_id='+company_id_+'&con_id='+consumer_id_+'&location_out='+location_out_id_+'&department_out='+department_out_id_+'&location_in='+location_id_+'&department_in='+department_id_+'&is_serial_no=1&guaranty_cat=&guaranty_startdate=&spect_id=<cfif session.ep.isBranchAuthorization>&is_store=1</cfif>', '_blank');	
			  win.focus();
		  
		  
  }
  
  function filterNum(str,no_of_decimal) 
  {
	  /*form submit edilmeden önce float veya integer alanların temizliği için*/
	  if (str == undefined || str.length == 0) return '';
	  if(!no_of_decimal && no_of_decimal!=0)
		  no_of_decimal=2;
		  strCheck = '-0123456789' + js_money_ayrac_ondalik;
		  
	  newStr = '';
	  var temp_strlen =str.length;
	  for(var i=0; i < temp_strlen; i++) if (strCheck.indexOf(str.charAt(i)) != -1) newStr += str.charAt(i);
	  if(js_money_ayrac_ondalik == ',')
		  {
		  newStr = newStr.replace(js_money_ayrac_ondalik,js_money_ayrac_binlik);
		  while(newStr.indexOf(js_money_ayrac_ondalik) > 0) newStr = newStr.replace(js_money_ayrac_ondalik,'');
		  }
	  else
		  {
			  if(newStr.indexOf(js_money_ayrac_ondalik)>0)
				  {
					  var temp = newStr.length-newStr.indexOf(js_money_ayrac_ondalik)-1;
					  if(temp == 0)
						  {
							  newStr = newStr.replace(js_money_ayrac_ondalik,'');	
						  }
				  }
		  }
	  
	  return wrk_round(newStr,no_of_decimal);
  }
  
  function getSelectedIndex(alan, sira)
  {
	  if(sira != undefined)
		  satir_ = sira;
	  else
		  satir_ = 0;
		  
	  return $("#tblBasket tr[basketItem]").eq(satir_).find("#"+alan).find(":selected").index();
  }
  
  function setSelectedIndex(alan, sira, deger)
  {
	  if(sira != undefined)
		  satir_ = sira;
	  else
		  satir_ = 0;
	  switch (alan)
	  {
		  case 'reserve_type' :
			  property = 'RESERVE_TYPE';
			  break; 
		  default:
			  property = "OTHER_MONEY";
			  break;
	  }
	  
	  if(alan == 'reserve_type')
	  {
		  $("#tblBasket tr[basketItem]").eq(satir_).find("#"+alan).find("option").removeAttr("selected");
		  if( deger != "" ){
			  window.basket.items[satir_][property] = deger;
			  $("#tblBasket tr[basketItem]").eq(satir_).find("#"+alan).find("option[value="+deger+"]").prop("selected",true);
		  }
	  }
	  else
	  {
		  $("#tblBasket tr[basketItem]").eq(satir_).find("#"+alan).find("option").removeAttr("selected");
		  window.basket.items[satir_][property] = $("#tblBasket tr[basketItem]").eq(satir_).find("#"+alan).find("option").eq(deger).val();
		  $("#tblBasket tr[basketItem]").eq(satir_).find("#"+alan).find("option").eq(deger).prop("selected",true);
	  }
	  
  }
  
  function getIndexValue(alan, sira, deger)
  {
	  if(sira != undefined)
		  satir_ = sira;
	  else
		  satir_ = 0;
	  
	  return $("#tblBasket tr[basketItem]").eq(satir_).find("#"+alan).find("option").eq(deger).text();
  }
  
  function check_reserved_rows()
	{ 
	//sipariste belge bazında rezervasyon secenegine baglı olarak satır reserve tiplerini edit eder.
		var case_ = $("#basket_main_div #reserved").length != 0 && $("#basket_main_div #reserved").is(":checked");

		var temp_reserve_index = $("#tblBasket tr[basketItem]").eq(window.basket.items.length > 1 ? 1 : 0).find("#reserve_type option[value='"+(case_ == true ? -1 : -3)+"']").index();//-1 rezerve secenegini gosteren  option bulunuyor
		if(window.basket.items.length)
		{
			for(var row_index=0;row_index<window.basket.items.length;row_index++)
			{
				row = window.basket.items[row_index];
				if(row.ORDER_CURRENCY && $.inArray($(row).find("#order_currency").val(),['-3','-8']) == -1) //kapatılmıs ve fazla teslimat asaması haricindeki tum satırlar rezerve olarak set ediliyors
				{
					<cfif ListFindNoCase(display_list, "reserve_type")>
						setSelectedIndex('reserve_type', row_index, (case_ == true ? -1 : -3));
					<cfelse>
						window.basket.items[row_index].RESERVE_TYPE = (case_ == true ? -1 : -3);
					</cfif>
				}
			}
		}
		/* $("#tblBasket tr[basketItem]").each(function (row_index , row) // row_index : Satırın indexi, row : satır
		{
			if($(row).find("#order_currency").length != 0 && $.inArray($(row).find("#order_currency").val(),['-3','-8']) == -1) //kapatılmıs ve fazla teslimat asaması haricindeki tum satırlar rezerve olarak set ediliyors
			{
				<cfif ListFindNoCase(display_list, "reserve_type")>
					setSelectedIndex('reserve_type', row_index, (case_ == true ? -1 : -3));
				<cfelse>
					window.basket.items[row_index].RESERVE_TYPE = (case_ == true ? -1 : -3);
				</cfif>
			}
		}) */
	}
  function check_member_price_cat(type)
  {
  /*basketli islemler secilen uyenin dahil oldugu fiyat listesini baskete set eder. fatura vb islemlerde uye secme popupına gonderilmelidir OZDEN20071018*/
	  comp_id = 0;
	  
	  if($("#basket_main_div #company_id").length != 0 && $("#basket_main_div #company_id").val().length != 0)
	  {
		  c_id = $("#basket_main_div #company_id").val();
		  comp_id = 1; // company
	  }
	  else if($("#basket_main_div #consumer_id").length != 0 && $("#basket_main_div #consumer_id").val().length != 0)
	  {
		  c_id = $("#basket_main_div #consumer_id").val();
		  comp_id = 2; // consumer
	  }
	  if(comp_id == 1 || comp_id == 2)
		  var get_member_pricecat = wrk_safe_query('obj_get_member_pricecat','dsn' , 0, c_id);
		  
	  if(comp_id == 1)
	  {
		  if(get_member_pricecat.recordcount == 0 || get_member_pricecat.PRICE_CATID == '')
		  {
			  var get_member_cat = wrk_safe_query('obj_get_member_cat','dsn',0, c_id);
			  
			  var listParam = "<cfoutput>#dsn_alias#</cfoutput>" + "*" + get_member_cat.COMPANYCAT_ID + "*"+c_id;
			  var get_member_pricecat = wrk_safe_query("obj_get_member_pricecat_2","dsn3", 0, listParam);
		  }
		  if(get_member_pricecat.recordcount)
			  window.basket.hidden_values.basket_member_pricecat = get_member_pricecat.PRICE_CATID.toString();
	  }
	  else if(comp_id == 2)
	  {
		  if(get_member_pricecat.recordcount == 0 || get_member_pricecat.PRICE_CATID == '' )
		  {
			  var get_member_cat = wrk_safe_query('obj_get_member_cat_2','dsn',0,c_id);
			  
			  var listParam = "<cfoutput>#dsn_alias#</cfoutput>" + "*" + get_member_cat.CONSUMER_CAT_ID + "*" + c_id;
			  var get_member_pricecat = wrk_safe_query("obj_get_member_pricecat_3","dsn3",0,listParam);
		  }	
		  if(get_member_pricecat.recordcount)
			  window.basket.hidden_values.basket_member_pricecat = get_member_pricecat.PRICE_CATID.toString();
	  }
  
	  if(type == undefined)
	  {
		  <cfif listfind('2',attributes.basket_id)>
			  control_einvoice_paper();
		  </cfif>
	  }
  }
  
  function control_einvoice_paper()
  {	
	  if($("#basket_main_div #company_id").length != 0 && $("#basket_main_div #company_id").val().length != 0)
		  var get_member_control = wrk_safe_query('obj_get_company_efatura','dsn' , 0, $("#basket_main_div #company_id").val());
	  else if($("#basket_main_div #consumer_id").length != 0 && $("#basket_main_div #consumer_id").val().length != 0)
		  var get_member_control = wrk_safe_query('obj_get_consumer_efatura','dsn',0,$("#basket_main_div #consumer_id").val());
  
	  if (typeof old_paper_type == "undefined") {
		  var old_paper_type = "";
	  }
	  if (typeof paper_type != "undefined") {
		old_paper_type = paper_type;
	  }
	  if(get_member_control != undefined && get_member_control.USE_EFATURA == 1 && datediff(date_format(get_member_control.EFATURA_DATE), $("#basket_main_div #invoice_date").val(),0) >= 0)
		  paper_type = 'E_INVOICE';
	  else
		  paper_type = 'INVOICE';
	  
	  var get_paper = workdata('get_paper',paper_type);
	  get_paper[paper_type+'_NUMBER'];
	  if(get_paper[paper_type+'_NUMBER'] != '')
	  {
		  obj_name = $("#basket_main_div #serial_no");
		  obj_name_extra = $("#basket_main_div #serial_number");
		  if(get_paper.recordcount)
		  {
			  $("#basket_main_div #paper").val(String(parseFloat(get_paper[paper_type+'_NUMBER'])+1));
			  $(obj_name_extra).val(String(get_paper[paper_type+'_NO'][0]));
			  $(obj_name).val(String(parseFloat(get_paper[paper_type+'_NUMBER'][0])+1));
		  } else if (!get_paper.recordcount && old_paper_type != paper_type) {
			  $("#basket_main_div #paper").val("");
			  $(obj_name_extra).val("");
			  $(obj_name).val("");
		  }
	  }
  }
  
  function set_basket_duedate_price(from_row) 
  {//basket satırındaki vade degistiginde vade farkı oranlarına gore yeni fiyatı hesaplar. baskette taksit alanı seciliyse öncelik taksitten fiyat hesaplama (basket_taksit_hesapla) fonksiyonundadır
	  if(from_row)
		  from_row_ = from_row;
	  else
		  from_row_ = 0;
	  
	  var row_duedate_ = window.basket.items[from_row_].DUEDATE;
	  var row_list_price_ = window.basket.items[from_row_].LIST_PRICE;
	  var row_price_cat_ = window.basket.items[from_row_].PRICE_CAT;
  
	  if(row_duedate_!='' && row_price_cat_ != undefined && row_price_cat_ != '')
	  {
		  var get_price_cat_detail_ = wrk_safe_query('obj_get_price_cat_detail',"dsn3",0,row_price_cat_);
		  if(get_price_cat_detail_.recordcount != undefined && get_price_cat_detail_.recordcount != 0 && get_price_cat_detail_.AVG_DUE_DAY != '' && get_price_cat_detail_.DUE_DIFF_VALUE != '')
		  {
			  if(get_price_cat_detail_.AVG_DUE_DAY> row_duedate_) //erken vade oranını kullanarak indirimli fiyatı hesaplayacak, fiyat listelerinde erken vade oranı aylık bazda tutuldugundan gune cevirip hesaplanıyor
				  var new_price_ = (row_list_price_- ( (row_list_price_*parseInt(get_price_cat_detail_.AVG_DUE_DAY-row_duedate_)*(get_price_cat_detail_.EARLY_PAYMENT/30) ) /100)) ;
			  else if(get_price_cat_detail_.AVG_DUE_DAY < row_duedate_) //vade farkı oranını kullanarak yeni fiyatı hesaplayacak
				  var new_price_ = (row_list_price_+( (row_list_price_*parseInt(row_duedate_-get_price_cat_detail_.AVG_DUE_DAY)*(get_price_cat_detail_.DUE_DIFF_VALUE/30) ) /100)) ;
			  else if(get_price_cat_detail_.AVG_DUE_DAY == row_duedate_)
				  var new_price_ = row_list_price_;
			  if(new_price_ != undefined && new_price_ != '' && ! isNaN(new_price_))
			  {
				  setFieldValue('price', from_row, wrk_round(new_price_,price_round_number),3); //fiyat degistiriliyor
				  hesapla('price',from_row+1); //satır yeniden hesaplanıyor
			  }
		  }
	  }
  }
  
  function setFieldValue(alan, sira, deger, function_no) <!--- // verilen degeri istenen alana istenen formatda yazar. Alanlar büyük harfle yazılmalıdır. --->
  {
	  if(sira != undefined)
		  sira_ = sira;
	  else
		  sira_ = 0;
  
	  if(function_no == 0)
		  f_value = deger;
	  else if(function_no == 1)
		  f_value =  filterNumBasket(deger);
	  else if(function_no == 2)
		  f_value = f2(deger);
	  else if(function_no == 3)
	  {
		  if(listfind('amount,dara,darali',alan) != -1)
			  f_value = commaSplit(deger,amount_round);
		  else if(listfind('tax,otv_oran,number_of_installment,duedate',alan) != -1)
			  f_value = commaSplit(deger,0);
		  else if(alan.indexOf('indirim')==0 || list_find('promosyon_yuzde,marj,extra_cost_rate,ek_tutar_marj',alan) != -1 && alan != 'ek_tutar_cost')/*indirim yerine kullaniyoruz*/
			  f_value = commaSplit(deger,2);
		  else
			  f_value = commaSplit(deger,price_round_number);
	  }
	  fillArrayField(alan,deger,f_value,sira_,1);
	  return true;
  }
  
  function getFieldValue(alan, sira, function_no) <!--- // verilen alan içeriğini istenen formatda döndürür --->
  {
	  if(sira != undefined)
		  sira_ = sira;
	  else
		  sira_ = 0;
		  
	  var f_value = window.basket.items[sira_][alan];
  
	  var return_text = f_value;
	  
	  if(function_no == 1)
	  {
		  if(listfind('amount,dara,darali',alan) != -1) 
			  return_text = filterNumBasket(f_value,amount_round);
		  else if(listfind('tax,otv_oran,number_of_installment,duedate',alan) != -1) 
			  return_text = filterNumBasket(f_value,0);
		  else if(alan.indexOf('indirim')==0 || list_find('promosyon_yuzde,marj,extra_cost_rate,ek_tutar_marj',alan) != -1) 
			  return_text = filterNumBasket(f_value,2);
		  else 
			  return_text = filterNumBasket(f_value,price_round_number);
	  }
	  return return_text;
  }
  
  //check_member_price_cat(0);
  function apply_duedate(type,due_date_value)
  {
	  temp_row_due_date = $("#basket_main_div #duedate").val();
	  if(type==2)
		  set_due_date = $("#basket_main_div #set_row_duedate").val();
	  else if(type==1 && due_date_value != undefined && due_date_value !='')
		  set_due_date = due_date_value;
	  else
		  set_due_date = '';
  
	  if(window.basket.items.length)	
	  {
		  for(var dd=0; dd < window.basket.items.length ; dd++)
		  {
			  //document.getElementById('sepetim').scrollTop = document.getElementById('sepetim').scrollTop+21;
			  if(type == 1 && (window.basket.items[dd].DUEDATE == '' || window.basket.items[dd].DUEDATE == 0))
				  //change_paper_duedate fonksiyonundan type 1 gonderilerek cagrılıyor 
				  //sadece boş ve 0 olan vadeler degistiriliyor
				  //upd:10/07/2019 - Uğur Hamurpet 
				  window.basket.items[dd].DUEDATE = set_due_date;
				  //temp_row_due_date[dd].value = set_due_date;
			  else if(type==2)
			  {
				  window.basket.items[dd].DUEDATE = set_due_date;
				  <cfif not listfindnocase(display_list,'number_of_installment')>
				  /*taksitli satıs secili degilse vade degistiginde fiyat tekrar hesaplanır, fiyat degisiyorsa set_basket_duedate_price icinde yeniden hesapla calıstırılıyor */
					  set_basket_duedate_price(dd);
				  </cfif>
			  }
			  <cfif not listfindnocase(display_list,'duedate')>
				  if(type==1)
					  window.basket.items[dd].DUEDATE = set_due_date;
			  </cfif>
		  }
		  showBasketItems();
		  if(type != 1)
			  set_paper_duedate();//satır vadelerine baglı olarak belge ortalama vadesini hesaplar
	  }
	  else 
		  return true;
  }
  
  function listfind(listem,degerim,delim)
  {
	  var listItems = listem.split(delim ? delim: ",");
	  for (var i = 0; i < listItems.length; i++){
		  if (listItems[i] == degerim) return i;
	  }
	  
	  return -1;
  }
  
  function filterNumBasket(str,no_of_decimal) //Noktarları temizleyip virgülü uçurur.
  {
	  str = str.toString();
	  if (str == undefined || str.length == 0) return '';
	  if(!no_of_decimal && no_of_decimal!=0)
		  no_of_decimal=2;
  //	while(str.indexOf(js_money_ayrac_binlik) > 0) str = str.replace(js_money_ayrac_binlik,'');
	  //str = str.replace(',', '.');
	  decimal_carpan = Math.pow(10,no_of_decimal);
	  if(str!=0) return (Math.round(str*decimal_carpan)/decimal_carpan);
	  else return  0;
  }
  function control_comp_selected(update_product_row_id,isUpdOrAdd,prod_config)
  {
	  var rowCount = window.basket.items.length;
	  if(listfind('1,11,17,6,10,20,33',window.basket.hidden_values.basket_id) != -1) // Alış Faturası, Stok Alım İrsaliyesi, Şube Alım İrsaliyesi, Satın Alma Siparişi, Stok Satış İrsaliyesi, Şube Alış Faturası, Müstahsil Makbuzu
	  {
		  if($("#basket_main_div #branch_id").val() == '')
		  {
			  alert("<cf_get_lang dictionary_id='57723.Önce depo seçmelisiniz'>!");
			  return false;
		  }
	  }
	  if(listfind('4,51',window.basket.hidden_values.basket_id) != -1) // Satış Siparişi, Taksitli Satış
	  {
		  if($("#basket_main_div #x_required_dep").val() == 1 && $("#basket_main_div #deliver_dept_id").val() == '')
		  {
			  alert("<cf_get_lang dictionary_id='57723.Önce depo seçmelisiniz'>!");
			  return false;
		  }
	  }
	  
	  var is_cost = listfind(display_list,'net_maliyet') != -1 ? 1 : 0; 
	  var is_price = listfind(display_list,'Price') != -1 ? 1 : 0;
	  var is_price_other = listfind(display_list,'price_other') != -1 ? 1 : 0;
	  
	  if(listfind("1,2,4,6,10,11,17,18,20,21",window.basket.hidden_values.basket_id) != -1)
		  var str_tlp_comp = "&branch_id=" + $("#basket_main_div #branch_id").val();
	  else
		  var str_tlp_comp="";
  
	  var aranan_tarih="";
	  try
	  {
		  if($("#basket_main_div #search_process_date").val() != '')
			  aranan_tarih = $("#basket_main_div #" + $("#basket_main_div #search_process_date").val()).val().toString();
		  if(listfind(window.basket.hidden_values.basket_id,'1,5,6,11,15,17,20,37')!= -1)
		  {
			  if(aranan_tarih == '')
			  {
				  alert("<cf_get_lang dictionary_id='57714.Satınalma İndirimleri için Tarih Bilgisini Ekleyiniz'>!");
				  return false;
			  }
		  }
	  }
	  catch(e)
	  {}
	  <!--- // process_type değişkeni --->
	  var sepet_process_obj = findObj("process_cat");
	  //console.log(sepet_process_obj);
	  if(sepet_process_obj != null)
		  sepet_process_type = process_type_array[sepet_process_obj.selectedIndex];
	  else
		  sepet_process_type = -1;
	  if (sepet_process_obj != null && sepet_process_type == -1)
	  {
		  alert("<cf_get_lang dictionary_id='57733.Önce İşlem Tipi Seçiniz'>!");
		  return false;
	  }
	  <!--- // process_type değişkeni --->
		  
	  if(listfind(display_list,'is_member_selected') != -1)
	  {
		  if(sepet_process_type!=52 )<!--- 52:perakende satış faturası --->
		  {
			  if($("#basket_main_div #company_id").length != 0 && $("#basket_main_div #consumer_id").length != 0  && $("#basket_main_div #partner_name").length != 0)
			  {
				  if( $("#basket_main_div #company_id").val().length == 0  && $("#basket_main_div #consumer_id").val() == 0  && $("#basket_main_div #partner_name").val() == 0)	//Yetkili kismi da bossa
				  {
					  alert("<cf_get_lang dictionary_id='57715.Önce Üye Seçiniz'>!");
					  return false;
				  }
			  }
		  }
	  }
  
	  <!--- // proje bilgisi --->
	  var temp_project_id='';
	  if((sepet_process_type=='-1' || sepet_process_type!=52) && sepet_process_type != 115)<!--- 52:perakende satış faturası --->
	  {
		  if(($("#basket_main_div #project_id").length != 0 && $("#basket_main_div #project_head").length != 0) || $("#basket_main_div #project_id_in").length != 0 && $("#basket_main_div #project_head_in").length != 0)
		  {
			  if ((($("#basket_main_div #project_id").val().length == 0 || $("#basket_main_div #project_head").val().length == 0) && $("#basket_main_div #project_id_in").length == 0) || (($("#basket_main_div #project_id").val().length == 0 || $("#basket_main_div #project_head").val().length == 0) && ($("#basket_main_div #project_id_in").length != 0 && ($("#basket_main_div #project_id_in").length == 0 || $("#basket_main_div #project_id_in").val().length == 0))))
			  {
				  if(listfind(display_list,'is_project_selected') != -1)	
				  {
					  alert("<cf_get_lang dictionary_id='58848.Önce Proje Seçiniz'>!");
					  return false;
				  }
			  }
			  else
			  {
				  if($("#basket_main_div #project_id").val().length != 0 )
					  temp_project_id = $("#basket_main_div #project_id").val();
				  else if($("#basket_main_div #project_id_in").length != 0 && $("#basket_main_div #project_id_in").val().length != 0)
					  temp_project_id = $("#basket_main_div #project_id_in").val();
			  }
		  }
	  }
	  
	  if(window.basket.hidden_values.basket_id == 51) // Taksitli Satış
	  {
		  if($("#basket_main_div #paymethod_id").length != 0 && $("#basket_main_div #paymethod_id").val().length == 0 && $("#basket_main_div #card_paymethod_id").length != 0 && $("#basket_main_div #card_paymethod_id").val().length == 0)
		  {
			  alert("<cf_get_lang dictionary_id='58027.Ödeme Yöntemi Seçiniz!'>");
			  return false;
		  }	
	  }
	  // depo sevk irs ve ambar fislerinde cıkıs lokasyonuna gore urun miktarı kontrolu yapılacagı icin önce lokasyon secilmesi zorunlu
	  var department_str = '';
	  if(listfind('76,81',sepet_process_type) != -1) //81:depo sevk irs 76 alış irsaliyesi
	  {
		  if($("#basket_main_div #location_id").length != 0 && $("#basket_main_div #location_id").val().length == 0)
		  {
			  alert("<cf_get_lang dictionary_id='58782.Çıkış Lokasyonu Seçiniz'>");
			  return false;
		  }
		  else
			  department_str = '&department_out=' + $("#basket_main_div #department_id").val() + '&location_out=' + $("#basket_main_div #location_id").val();
	  }
	  if(listfind('111,112,113',sepet_process_type) != -1) //111:sarf fisi, 112:fire fisi, 113:ambar fisi
	  {
		  if($("#basket_main_div #location_out").length != 0 && $("#basket_main_div #location_out").val().length == 0)
		  { 
			  alert("<cf_get_lang dictionary_id='58782.Çıkış Lokasyonu Seçiniz'>");
			  return false;
		  }
		  else
			  department_str = '&department_out=' + $("#basket_main_div #department_out").val() + '&location_out=' + $("#basket_main_div #location_out").val();
	  }
	  if(listfind('2,10,18,21,48',window.basket.hidden_values.basket_id) != -1) // Satış Faturası, Stok Satış İrsaliyesi, Şube Satış Faturası, Şube Satış İrsaliyesi, Servis Giriş
	  {
		  if($("#basket_main_div #location_id").length != 0 && $("#basket_main_div #location_id").val().length == 0)
		  {
			  alert("<cf_get_lang dictionary_id='57723.Önce depo seçmelisiniz'>");
			  return false;
		  }
		  else
			  department_str = '&department_out=' + $("#basket_main_div #department_id").val() + '&location_out=' + $("#basket_main_div #location_id").val();
			  
	  }
	  if(listfind('4,51', window.basket.hidden_values.basket_id) != -1) // Satış Siparişi, Taksitli Satış
	  {
		  if($("#basket_main_div #deliver_dept_id").length && $("#basket_main_div #deliver_dept_id").val().length != 0)
			  department_str = '&department_out=' + $("#basket_main_div #deliver_dept_id").val() + '&location_out=' + $("#basket_main_div #deliver_loc_id").val();
	  }
	  if(listfind('7', window.basket.hidden_values.basket_id) != -1) // İç Talep
	  {
		  if($("#basket_main_div #department_id").length && $("#basket_main_div #department_id").val().length != 0)
			  department_str = '&department_out=' + $("#basket_main_div #department_id").val() + '&location_out=' + $("#basket_main_div #location_id").val();
	  }
	  
	  if(listfind('1,2,4,6,18,20,33,51', window.basket.hidden_values.basket_id) != -1) // Alış Faturası, Satış Faturası, Satış Siparişi, Satın Alma Siparişi, Şube Satış Faturası, Şube Alış Faturası, Müstahsil Makbuzu, Satış Siparişi, Taksitli Satış
	  {
		  if($("#basket_main_div #paymethod_id").length != 0 && $("#basket_main_div #paymethod_id").val().length)
			  temp_paymethod = $("#basket_main_div #paymethod_id").val();//perakende ile satıs fat aynı basketi kullanıyor ama perakendede odeme yontemi yok, kontrol icin eklendi.
  
		  if($("#basket_main_div #card_paymethod_id").length != 0 && $("#basket_main_div #card_paymethod_id").val().length) //perakende ile satıs fat aynı basketi kullanıyor ama perakendede odeme yontemi yok, kontrol icin eklendi.
			  temp_card_paymethod = $("#basket_main_div #card_paymethod_id").val();
		  else
			  temp_card_paymethod = '';
		  if($("#basket_main_div #paymethod_vehicle").length != 0 && $("#basket_main_div #paymethod_vehicle").val().length) //perakende ile satıs fat aynı basketi kullanıyor ama perakendede odeme yontemi yok, kontrol icin eklendi.
			  temp_paymethod_vehicle = $("#basket_main_div #paymethod_vehicle").val();	
	  }
  
	  var get_money_currency_list_for_popup = "<cfoutput>#get_money_currency_list_for_popup#</cfoutput>"
  
	  if(update_product_row_id != -1) //barkoddan urun ekleden cagrılmıyorsa popup acılmıyor
	  {
		  if(isUpdOrAdd != undefined)<!--- Ekleme ve ilk satır aynı update_product_row_id değerini döndürüyordu. Ekleme ikonuna eklendi. --->
			  satir = -1;
		  else
			  satir = update_product_row_id;
		  if($("#basket_main_div #company_id").length != 0 && $("#basket_main_div #company_id").val().length != 0)
			  var temp_ = '&company_id='+$("#basket_main_div #company_id").val();
		  else if($("#basket_main_div #consumer_id").length != 0 && $("#basket_main_div #consumer_id").val().length != 0)
			  var temp_ = '&consumer_id='+$("#basket_main_div #consumer_id").val();
		  else if($("#basket_main_div #employee_id").length != 0 && $("#basket_main_div #employee_id").val().length != 0)
			  var temp_ = '&employee_id='+$("#basket_main_div #employee_id").val();
		  else
			  var temp_ = '';
		  if($("#add_spect_variations #mpc").val() != undefined)
		  mpc_spect_filter='&keyword='+$("#add_spect_variations #mpc").val();
		  else
		  mpc_spect_filter='';
		  if(prod_config != undefined)
		  openBoxDraggable('<cfoutput>#request.self#?fuseaction=product.configurator&int_basket_id=#attributes.basket_id#<cfif listgetat(attributes.fuseaction,1,'.') is 'store'>&is_store_module=1</cfif></cfoutput><cfif listgetat(attributes.fuseaction,2,'.') contains 'internaldemand'>&demand_type=0</cfif>&update_product_row_id='+update_product_row_id+'&sepet_process_type='+sepet_process_type+'<cfif listfind("1,2,4,6,18,20,33,51",attributes.basket_id,",")>&paymethod_id='+temp_paymethod+'&card_paymethod_id='+temp_card_paymethod+'&paymethod_vehicle='+temp_paymethod_vehicle+'</cfif>&rowCount='+rowCount+'&is_sale_product='+sale_product+'&is_price='+is_price + "&is_price_other="+is_price_other+"&is_cost=" +is_cost + str_tlp_comp + department_str+"&search_process_date="+aranan_tarih+"&project_id="+temp_project_id+'&'+get_money_currency_list_for_popup+'&satir='+satir+temp_+mpc_spect_filter);
	  	  else
	  	  windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_products&int_basket_id=#attributes.basket_id#<cfif listgetat(attributes.fuseaction,1,'.') is 'store'>&is_store_module=1</cfif></cfoutput><cfif listgetat(attributes.fuseaction,2,'.') contains 'internaldemand'>&demand_type=0</cfif>&update_product_row_id='+update_product_row_id+'&sepet_process_type='+sepet_process_type+'<cfif listfind("1,2,4,6,18,20,33,51",attributes.basket_id,",")>&paymethod_id='+temp_paymethod+'&card_paymethod_id='+temp_card_paymethod+'&paymethod_vehicle='+temp_paymethod_vehicle+'</cfif>&rowCount='+rowCount+'&is_sale_product='+sale_product+'&is_price='+is_price + "&is_price_other="+is_price_other+"&is_cost=" +is_cost + str_tlp_comp + department_str+"&search_process_date="+aranan_tarih+"&project_id="+temp_project_id+'&'+get_money_currency_list_for_popup+'&satir='+satir+temp_+mpc_spect_filter,'page_horizantal',basket_unique_code);
		}
	  else
	  {
		  var url_info='';
		  url_info='&int_basket_id='+ window.basket.hidden_values.basket_id+'&sepet_process_type='+sepet_process_type;
		  if(list_getat(window.basket.hidden_values.fuseaction,1,'.') == 'store')
			  url_info = url_info + '&is_store_module=1';
		  if(listfind('1,2,4,6,18,20,33,51',window.basket.hidden_values.basket_id,',') != -1)
			  url_info = url_info + +'&paymethod_id='+temp_paymethod+'&card_paymethod_id='+temp_card_paymethod+'&paymethod_vehicle='+temp_paymethod_vehicle;
		  url_info=url_info+'&'+get_money_currency_list_for_popup;
		  url_info=url_info+'&rowCount='+rowCount+'&is_sale_product='+sale_product+'&is_price='+is_price + "&is_price_other=" +is_price_other + "&is_cost=" + is_cost + str_tlp_comp + department_str + "&search_process_date=" + aranan_tarih + "&project_id=" +temp_project_id;
		  
		  if($("#basket_main_div #company_id").length != 0 && $("#basket_main_div #company_id").val().length != 0)
			  url_info=url_info+'&company_id='+$("#basket_main_div #company_id").val();
		  else if($("#basket_main_div #consumer_id").length != 0 && $("#basket_main_div #consumer_id").val().length != 0)
			  url_info=url_info+'&consumer_id='+$("#basket_main_div #consumer_id").val();
		  else if($("#basket_main_div #employee_id").length != 0 && $("#basket_main_div #employee_id").val().length != 0)
			  url_info=url_info+'&employee_id='+$("#basket_main_div #employee_id").val();
		  $("#url_info").val(url_info);
		  $("#paper_process_type").val(sepet_process_type);
		  window.frames[add_prod_no].document.add_speed_prod.url_info.value='';
		  window.frames[add_prod_no].document.add_speed_prod.url_info.value=url_info;
		  window.frames[add_prod_no].document.add_speed_prod.paper_process_type.value='';
		  window.frames[add_prod_no].document.add_speed_prod.paper_process_type.value=sepet_process_type;
		  return true;
	  }
  }
  
  
  function hesapla_amount(field_name,satir)
  {
	  if(listfind(display_list,'is_use_add_unit') != -1)
	  {
		  fixedRowNumber = satir - window.basket.scrollIndex ;
		  
		  product_id_ = window.basket.items[satir].PRODUCT_ID;
		  amount_ = filterNum($("#tblBasket tr[basketItem]").eq(fixedRowNumber).find("#Amount").val(),amount_round);
		  amount_other_ = filterNum($("#tblBasket tr[basketItem]").eq(fixedRowNumber).find("#amount_other").val(),amount_round);
		  unit_other_ = $("#tblBasket tr[basketItem]").eq(fixedRowNumber).find("#unit_other").val();
		  
		  if(unit_other_ != '')
		  {
			  get_multiplier = wrk_query("SELECT ISNULL(MULTIPLIER,1) MULTIPLIER FROM PRODUCT_UNIT WHERE PRODUCT_UNIT_STATUS = 1 AND PRODUCT_ID ="+product_id_+" AND ADD_UNIT = '" + unit_other_ + "'","dsn3");
			  row_multiplier = get_multiplier.MULTIPLIER;
			  if(field_name == 'Amount' && row_multiplier!= undefined)
			  {
				  fillArrayField('Amount',amount_,commaSplit(amount_,amount_round),satir,1);
				  fillArrayField('amount_other',amount_/row_multiplier,commaSplit(wrk_round(amount_/row_multiplier),amount_round),satir,1);
			  }
			  else if(field_name == 'amount_other' && row_multiplier!= undefined)
			  {
				  fillArrayField('amount_other',amount_other_,commaSplit(amount_other_,amount_round),satir,1);
				  fillArrayField('Amount',amount_other_*row_multiplier,commaSplit(amount_other_*row_multiplier,amount_round),satir,1);
			  }
		  }
	  }
  }
  
  function kdvdahildenhesapla(satir,field_name)
  {//row_lasttotal(Son Toplam) veya tax_price alanlarından fiyatı hesaplar. fieldname gonderilmisse kdvdahil fiyattan yoksa satır son toplamından fiyat hesaplanır
	new_price_kdv = -1;
	amount_ = 1;
	promosyon_yuzde = 0;
	iskonto_tutar = 0;
	ek_tutar = 0;
	otv_oran_ = 0;
	var amount_ = window.basket.items[satir].AMOUNT;
	var promosyon_yuzde = window.basket.items[satir].PROMOSYON_YUZDE;
	var iskonto_tutar = window.basket.items[satir].ISKONTO_TUTAR;
	var ek_tutar = window.basket.items[satir].EK_TUTAR;
		
	rate1 = window.basket.items[satir].RATE1;
	rate2 = window.basket.items[satir].RATE2;
	
	if(rate1 == undefined && rate2 == undefined)
	{
		rate1 = 1;	
		rate2 = 1;
	}
	var tax_ = window.basket.items[satir].TAX_PERCENT;
	var otv_oran_ = window.basket.items[satir].OTV_ORAN;
	var bsmvAmount = 0.0;
	var oivAmount = 0.0;
	if(listfind(display_list, "row_bsmv_amount") != -1)
	bsmvAmount = window.basket.items[satir].ROW_BSMV_AMOUNT * rate1 / rate2;
	oivAmount = window.basket.items[satir].ROW_OIV_AMOUNT * rate1 / rate2;

	if(field_name!= undefined && field_name == 'tax_price') 
		var from_price = window.basket.items[satir].TAX_PRICE - ( bsmvAmount / amount_ ) - ( oivAmount / amount_ );
	else
		var from_price = window.basket.items[satir].ROW_LASTTOTAL;
	var indirim_carpan = window.basket.items[satir].INDIRIM_TOTAL;
	
	if(amount_ != 0)
	{
		if(listfind(display_list, "otv_from_tax_price") != -1)
		{
		<cfif otv_calc_type_ eq 1>
			var new_price =  (from_price*100)/(100+tax_) - otv_oran_; //kdv matrahı dahil otv hesaplamasından geri gidiliyor
			if(field_name!= undefined && (field_name == 'tax_price'))
				var new_price = wrk_round((new_price*100*100000000000000000000)/(indirim_carpan*100));
			else	
				var new_price = wrk_round((new_price*100*100000000000000000000)/(indirim_carpan*100*amount_));
		<cfelse>
			var new_price =  (from_price*100)/(100+tax_); //kdv matrahı dahil otv hesaplamasından geri gidiliyor
			if(field_name!= undefined && (field_name == 'tax_price'))
				var new_price = wrk_round((new_price*100*100000000000000000000)/(indirim_carpan*(100+otv_oran_)));
			else	
				var new_price = wrk_round((new_price*100*100000000000000000000)/(indirim_carpan*(100+otv_oran_)*amount_));
		</cfif>
		}
		else
		{
			if(field_name!= undefined && (field_name == 'tax_price'))
			{
				if(indirim_carpan == 100000000000000000000)
				{
				<cfif otv_calc_type_ eq 1>
					var last_price_info = (from_price - otv_oran_) * 100;
					var last_disc_info= 100 + tax_;
					var new_price = wrk_round(last_price_info/last_disc_info,price_round_number);
					var new_price_kdv = wrk_round(new_price * tax_ / 100,price_round_number);
				<cfelse>
					var last_price_info = (from_price * 100);
					var last_disc_info= ((100+tax_+otv_oran_));
					var new_price = wrk_round(last_price_info/last_disc_info,price_round_number);
					var new_price_kdv = wrk_round(new_price * (tax_+otv_oran_) / 100,price_round_number);
				</cfif>
				}
				else
				{
				<cfif otv_calc_type_ eq 1>
					var last_price_info = (from_price - otv_oran_) * 100 * 100000000000000000000;
					var last_disc_info= (indirim_carpan*(100+tax_));
					var new_price = (last_price_info/last_disc_info);
				<cfelse>
					var last_price_info = from_price * 100 * 100000000000000000000;
					var last_disc_info= (indirim_carpan*(100+tax_+otv_oran_));
					var new_price = (last_price_info/last_disc_info);
				</cfif>
				}
			}
			else
				var new_price = (from_price * 100 * 100000000000000000000)/(indirim_carpan*(100+tax_+otv_oran_)*amount_);
		}
	}
	else
		var new_price =0;

	new_price *= 100/(100-promosyon_yuzde);
	//new_price += iskonto_tutar*rate2/rate1;
	new_price += (iskonto_tutar*rate2/rate1);
	new_price -= (ek_tutar*rate2/rate1);
	setFieldValue('Price',satir,new_price,3);
	
	if(new_price_kdv > 0){
		new_price_kdv = new_price_kdv * amount_;
		if(field_name == 'tax_price')
		{
			hesapla('tax_price',satir,1);
		}
		else
		{
			hesapla('Price',satir,1,new_price_kdv);
		}
	}else{
		if(field_name == 'tax_price')
		{
			hesapla('tax_price',satir,1);
		}
		else
		{
			hesapla('Price',satir,1);
		}
	}
  }
  
  <cfif ListFindNoCase(display_list,'duedate')>
  function set_paper_duedate() //satır vadelerine baglı olarak belge ortalama vadesini hesaplar
  {
	  var general_total_ = 0;
	  var row_totals_=0
	  if(window.basket.items.length == 1 && $("#basket_main_div #basket_due_value").length != 0 && window.basket.items[0].DUEDATE.length != 0)
		  $("#basket_main_div #basket_due_value").val(window.basket.items[0].DUEDATE);
	  else
	  {
		  for(i=0;i<window.basket.items.length;i++)
		  {
			  row_due_date_ = window.basket.items[i].DUEDATE;
			  temp_row_total_ = window.basket.items[i].ROW_LASTTOTAL;
			  general_total_ = general_total_+ (row_due_date_*temp_row_total_);
			  row_totals_ = row_totals_ + temp_row_total_;
		  }
		  if(row_totals_ != 0 && $("#basket_main_div #basket_due_value").length != 0)
			  $("#basket_main_div #basket_due_value").val(wrk_round((general_total_/row_totals_),0));
	  }
	  if(listfind('4,6',window.basket.hidden_values.basket_id) != -1)
		  <cfif isdefined("xml_delivery_date_calculated") and xml_delivery_date_calculated neq 1 >
			  field_name_info_ = 'order_date';
		  <cfelse>
			  field_name_info_ = 'deliverdate';
		  </cfif>
	  else
		  field_name_info_ = '';
	  if($("#basket_main_div #basket_due_value_date_").length != 0 && $("#basket_main_div #basket_due_value_date_").val().length != 0) //vade tarih inputu varsa ve change_due_date fonksyionu sayfada tanımlı ise
	  {
		  if(typeof change_due_date != "undefined")
			  change_due_date();
		  else
			  change_paper_duedate(field_name_info_,2,0);
	  }
  }	
  </cfif>
  <cfif isdefined('use_basket_project_discount_') and use_basket_project_discount_ eq 1> <!--- proje baglantı kontrolleri --->
	  function check_member_project_risk(project_id_)
	  {
	  
		  if($("#basket_main_div #order_id").length != 0 && $("#basket_main_div #order_id").val().length != 0)
			  var chck_order_id_ = $("#basket_main_div #order_id").val();
		  else
			  var chck_order_id_ = 0;
			  
		  if(project_id_!=undefined && project_id_ !='')
		  {
			  var prj_total_risk_=0;
			  if(window.basket.hidden_values.basket_id == 6) <!--- Satınalma siparişi ise satınalma işlemlerinden çalışacak --->
			  {
				  if($("#basket_main_div #company_id").length != 0 && $("#basket_main_div #company_id").val().length != 0)
				  {
					  var str_member_prj_risk_ = 'SELECT * FROM COMPANY_REMAINDER_PROJECT WHERE COMPANY_ID = '+$("#basket_main_div #company_id").val()+' AND PROJECT_ID='+project_id_;	
					  
					  var str_prj_order_risk_='SELECT ISNULL(SUM(NETTOTAL),0) NETTOTAL FROM ('
					  str_prj_order_risk_=str_prj_order_risk_+' SELECT ((ORD_ROW.QUANTITY-ISNULL(ORD_ROW.CANCEL_AMOUNT,0)-ISNULL(ORD_ROW.DELIVER_AMOUNT,0))*'
					  str_prj_order_risk_=str_prj_order_risk_+' (((1-(ORDERS.SA_DISCOUNT)/((ORDERS.NETTOTAL)-(ORDERS.TAXTOTAL-ORDERS.SA_DISCOUNT)))*(ORD_ROW.NETTOTAL)-(-(((((1-(ORDERS.SA_DISCOUNT)/(ORDERS.NETTOTAL-(ORDERS.TAXTOTAL-ORDERS.SA_DISCOUNT)))*(ORD_ROW.NETTOTAL)*ORD_ROW.TAX)/100)))))/ORD_ROW.QUANTITY)) AS NETTOTAL FROM <cfoutput>#dsn3_alias#</cfoutput>.ORDERS,<cfoutput>#dsn3_alias#</cfoutput>.ORDER_ROW ORD_ROW WHERE ORDERS.ORDER_ID = ORD_ROW.ORDER_ID AND ISNULL(IS_MEMBER_RISK,1)=1 AND ORDER_STATUS=1'
					  str_prj_order_risk_=str_prj_order_risk_+' AND ORDERS.PURCHASE_SALES=0 AND ORDERS.ORDER_ZONE=0 AND IS_PAID<>1 AND COMPANY_ID='+$("#basket_main_div #company_id").val()+' AND PROJECT_ID='+project_id_+' AND ORDERS.ORDER_ID<>'+chck_order_id_+' AND ((ORDERS.NETTOTAL)-(ORDERS.TAXTOTAL-ORDERS.SA_DISCOUNT))>0 AND ORD_ROW.ORDER_ROW_CURRENCY NOT IN(-8,-9,-10,-3)) AS A1';
					  
					  var str_prj_ship_total_ = 'SELECT ISNULL(SUM(NETTOTAL),0) NETTOTAL FROM ('
					  var str_prj_ship_total_ = str_prj_ship_total_+' SELECT ((SR.AMOUNT - (SELECT ISNULL(SUM(IR.AMOUNT),0) FROM INVOICE_ROW IR,INVOICE I WHERE I.INVOICE_ID = IR.INVOICE_ID AND I.PURCHASE_SALES = S.PURCHASE_SALES AND I.IS_IPTAL = 0 AND IR.WRK_ROW_RELATION_ID = SR.WRK_ROW_ID))) * (SR.GROSSTOTAL/SR.AMOUNT) AS NETTOTAL FROM SHIP S,SHIP_ROW SR WHERE S.PURCHASE_SALES = 0 AND S.SHIP_ID=SR.SHIP_ID AND S.IS_WITH_SHIP=0 AND ISNULL(S.IS_SHIP_IPTAL,0)=0 AND S.COMPANY_ID='+$("#basket_main_div #company_id").val()+' AND S.PROJECT_ID='+project_id_;
					  var str_prj_ship_total_ = str_prj_ship_total_+' AND (SR.AMOUNT - (SELECT ISNULL(SUM(IR.AMOUNT),0) FROM <cfoutput>#dsn2_alias#</cfoutput>.INVOICE_ROW IR,<cfoutput>#dsn2_alias#</cfoutput>.INVOICE I WHERE I.INVOICE_ID = IR.INVOICE_ID AND I.PURCHASE_SALES = S.PURCHASE_SALES AND I.IS_IPTAL = 0 AND IR.WRK_ROW_RELATION_ID = SR.WRK_ROW_ID)) > 0';
					  if(chck_order_id_ > 0)
						  str_prj_ship_total_ = str_prj_ship_total_+' AND SR.ROW_ORDER_ID <> '+chck_order_id_;
					  var str_prj_ship_total_ = str_prj_ship_total_+') A1';
				  }
				  else if($("#basket_main_div #consumer_id").length != 0 && $("#basket_main_div #consumer_id").val().length != 0)
				  {
					  var str_member_prj_risk_ = 'SELECT * FROM CONSUMER_REMAINDER_PROJECT WHERE CONSUMER_ID = '+$("#basket_main_div #consumer_id").val()+' AND PROJECT_ID='+project_id_;
					  
					  var str_prj_order_risk_='SELECT ISNULL(SUM(NETTOTAL),0) NETTOTAL FROM ('
					  str_prj_order_risk_=str_prj_order_risk_+' SELECT ((ORD_ROW.QUANTITY-ISNULL(ORD_ROW.CANCEL_AMOUNT,0)-ISNULL(ORD_ROW.DELIVER_AMOUNT,0))*'
					  str_prj_order_risk_=str_prj_order_risk_+' (((1-(ORDERS.SA_DISCOUNT)/((ORDERS.NETTOTAL)-(ORDERS.TAXTOTAL-ORDERS.SA_DISCOUNT)))*(ORD_ROW.NETTOTAL)-(-(((((1-(ORDERS.SA_DISCOUNT)/(ORDERS.NETTOTAL-(ORDERS.TAXTOTAL-ORDERS.SA_DISCOUNT)))*(ORD_ROW.NETTOTAL)*ORD_ROW.TAX)/100)))))/ORD_ROW.QUANTITY)) AS NETTOTAL FROM <cfoutput>#dsn3_alias#</cfoutput>.ORDERS,<cfoutput>#dsn3_alias#</cfoutput>.ORDER_ROW ORD_ROW WHERE ORDERS.ORDER_ID = ORD_ROW.ORDER_ID AND ISNULL(IS_MEMBER_RISK,1)=1 AND ORDER_STATUS=1'
					  str_prj_order_risk_=str_prj_order_risk_+' AND ORDERS.PURCHASE_SALES=0 AND ORDERS.ORDER_ZONE=0 AND IS_PAID<>1 AND CONSUMER_ID='+$("#basket_main_div #consumer_id").val()+' AND PROJECT_ID='+project_id_+' AND ORDERS.ORDER_ID<>'+chck_order_id_+' AND ((ORDERS.NETTOTAL)-(ORDERS.TAXTOTAL-ORDERS.SA_DISCOUNT))>0 AND ORD_ROW.ORDER_ROW_CURRENCY NOT IN(-8,-9,-10,-3)) AS A1';
	  
					  var str_prj_ship_total_ = 'SELECT ISNULL(SUM(NETTOTAL),0) NETTOTAL FROM ('
					  var str_prj_ship_total_ = str_prj_ship_total_+' SELECT ((SR.AMOUNT - (SELECT ISNULL(SUM(IR.AMOUNT),0) FROM INVOICE_ROW IR,INVOICE I WHERE I.INVOICE_ID = IR.INVOICE_ID AND I.PURCHASE_SALES = S.PURCHASE_SALES AND I.IS_IPTAL = 0 AND IR.WRK_ROW_RELATION_ID = SR.WRK_ROW_ID))) * (SR.GROSSTOTAL/SR.AMOUNT) AS NETTOTAL FROM SHIP S,SHIP_ROW SR WHERE S.SHIP_ID=SR.SHIP_ID AND S.PURCHASE_SALES = 0 AND S.IS_WITH_SHIP=0 AND ISNULL(S.IS_SHIP_IPTAL,0)=0 AND S.CONSUMER_ID='+$("#basket_main_div #consumer_id").val()+' AND S.PROJECT_ID='+project_id_;
					  var str_prj_ship_total_ = str_prj_ship_total_+' AND (SR.AMOUNT - (SELECT ISNULL(SUM(IR.AMOUNT),0) FROM <cfoutput>#dsn2_alias#</cfoutput>.INVOICE_ROW IR,<cfoutput>#dsn2_alias#</cfoutput>.INVOICE I WHERE I.INVOICE_ID = IR.INVOICE_ID AND I.PURCHASE_SALES = S.PURCHASE_SALES AND I.IS_IPTAL = 0 AND IR.WRK_ROW_RELATION_ID = SR.WRK_ROW_ID)) > 0';
					  if(chck_order_id_ > 0)
						  str_prj_ship_total_ = str_prj_ship_total_+' AND SR.ROW_ORDER_ID <> '+chck_order_id_;
					  var str_prj_ship_total_ = str_prj_ship_total_+') A1';
				  }
				  if(str_member_prj_risk_!=undefined)
				  {
					  var get_member_prj_risk = wrk_query(str_member_prj_risk_,'dsn2');
					  if(get_member_prj_risk.recordcount!= 0 && get_member_prj_risk.BAKIYE!='')
						  prj_total_risk_=parseFloat(get_member_prj_risk.BAKIYE);
				  }
			  }
			  else
			  {
				  if($("#basket_main_div #company_id").length != 0 && $("#basket_main_div #company_id").val().length != 0)
				  {
					  var str_member_prj_risk_ = 'SELECT * FROM COMPANY_REMAINDER_PROJECT WHERE COMPANY_ID = '+$("#basket_main_div #company_id").val()+' AND PROJECT_ID='+project_id_;
					  
					  var str_prj_order_risk_='SELECT ISNULL(SUM(NETTOTAL),0) NETTOTAL FROM ('
					  str_prj_order_risk_=str_prj_order_risk_+' SELECT ((ORD_ROW.QUANTITY-ISNULL(ORD_ROW.CANCEL_AMOUNT,0)-ISNULL(ORD_ROW.DELIVER_AMOUNT,0))*'
					  str_prj_order_risk_=str_prj_order_risk_+' (((1-(ORDERS.SA_DISCOUNT)/((ORDERS.NETTOTAL)-(ORDERS.TAXTOTAL-ORDERS.SA_DISCOUNT)))*(ORD_ROW.NETTOTAL)-(-(((((1-(ORDERS.SA_DISCOUNT)/(ORDERS.NETTOTAL-(ORDERS.TAXTOTAL-ORDERS.SA_DISCOUNT)))*(ORD_ROW.NETTOTAL)*ORD_ROW.TAX)/100)))))/ORD_ROW.QUANTITY)) AS NETTOTAL FROM <cfoutput>#dsn3_alias#</cfoutput>.ORDERS,<cfoutput>#dsn3_alias#</cfoutput>.ORDER_ROW ORD_ROW WHERE ORDERS.ORDER_ID = ORD_ROW.ORDER_ID AND ISNULL(IS_MEMBER_RISK,1)=1 AND ORDER_STATUS=1'
					  str_prj_order_risk_=str_prj_order_risk_+' AND ((ORDERS.PURCHASE_SALES=1 AND ORDERS.ORDER_ZONE=0) OR (ORDERS.PURCHASE_SALES=0 AND ORDERS.ORDER_ZONE=1)) AND IS_PAID<>1 AND COMPANY_ID='+$("#basket_main_div #company_id").val()+' AND PROJECT_ID='+project_id_+' AND ORDERS.ORDER_ID<>'+chck_order_id_+' AND ((ORDERS.NETTOTAL)-(ORDERS.TAXTOTAL-ORDERS.SA_DISCOUNT))>0 AND ORD_ROW.ORDER_ROW_CURRENCY NOT IN(-8,-9,-10,-3)) AS A1';
			  
					  var str_prj_ship_total_ = 'SELECT ISNULL(SUM(NETTOTAL),0) NETTOTAL FROM ('
					  var str_prj_ship_total_ = str_prj_ship_total_+' SELECT ((SR.AMOUNT - (SELECT ISNULL(SUM(IR.AMOUNT),0) FROM INVOICE_ROW IR,INVOICE I WHERE I.INVOICE_ID = IR.INVOICE_ID AND I.PURCHASE_SALES = S.PURCHASE_SALES AND I.IS_IPTAL = 0 AND IR.WRK_ROW_RELATION_ID = SR.WRK_ROW_ID))) * (SR.GROSSTOTAL/SR.AMOUNT) AS NETTOTAL FROM SHIP S,SHIP_ROW SR WHERE S.PURCHASE_SALES = 1 AND S.SHIP_ID=SR.SHIP_ID AND S.IS_WITH_SHIP=0 AND ISNULL(S.IS_SHIP_IPTAL,0)=0 AND S.COMPANY_ID='+$("#basket_main_div #company_id").val()+' AND S.PROJECT_ID='+project_id_;
					  var str_prj_ship_total_ = str_prj_ship_total_+' AND (SR.AMOUNT - (SELECT ISNULL(SUM(IR.AMOUNT),0) FROM <cfoutput>#dsn2_alias#</cfoutput>.INVOICE_ROW IR,<cfoutput>#dsn2_alias#</cfoutput>.INVOICE I WHERE I.INVOICE_ID = IR.INVOICE_ID AND I.PURCHASE_SALES = S.PURCHASE_SALES AND I.IS_IPTAL = 0 AND IR.WRK_ROW_RELATION_ID = SR.WRK_ROW_ID)) > 0';
					  if(chck_order_id_ > 0)
						  str_prj_ship_total_ = str_prj_ship_total_+' AND SR.ROW_ORDER_ID <> '+chck_order_id_;
					  var str_prj_ship_total_ = str_prj_ship_total_+') A1';
				  }
				  else if($("#basket_main_div #consumer_id").length != 0 && $("#basket_main_div #consumer_id").val().length != 0)
				  {
					  var str_member_prj_risk_ = 'SELECT * FROM CONSUMER_REMAINDER_PROJECT WHERE CONSUMER_ID = '+$("#basket_main_div #consumer_id").val()+' AND PROJECT_ID='+project_id_;
					  
					  var str_prj_order_risk_='SELECT ISNULL(SUM(NETTOTAL),0) NETTOTAL FROM ('
					  str_prj_order_risk_=str_prj_order_risk_+' SELECT ((ORD_ROW.QUANTITY-ISNULL(ORD_ROW.CANCEL_AMOUNT,0)-ISNULL(ORD_ROW.DELIVER_AMOUNT,0))*'
					  str_prj_order_risk_=str_prj_order_risk_+' (((1-(ORDERS.SA_DISCOUNT)/((ORDERS.NETTOTAL)-(ORDERS.TAXTOTAL-ORDERS.SA_DISCOUNT)))*(ORD_ROW.NETTOTAL)-(-(((((1-(ORDERS.SA_DISCOUNT)/(ORDERS.NETTOTAL-(ORDERS.TAXTOTAL-ORDERS.SA_DISCOUNT)))*(ORD_ROW.NETTOTAL)*ORD_ROW.TAX)/100)))))/ORD_ROW.QUANTITY)) AS NETTOTAL FROM <cfoutput>#dsn3_alias#</cfoutput>.ORDERS,<cfoutput>#dsn3_alias#</cfoutput>.ORDER_ROW ORD_ROW WHERE ORDERS.ORDER_ID = ORD_ROW.ORDER_ID AND ISNULL(IS_MEMBER_RISK,1)=1 AND ORDER_STATUS=1'
					  str_prj_order_risk_=str_prj_order_risk_+' AND ((ORDERS.PURCHASE_SALES=1 AND ORDERS.ORDER_ZONE=0) OR (ORDERS.PURCHASE_SALES=0 AND ORDERS.ORDER_ZONE=1)) AND IS_PAID<>1 AND CONSUMER_ID='+$("#basket_main_div #consumer_id").val()+' AND PROJECT_ID='+project_id_+' AND ORDERS.ORDER_ID<>'+chck_order_id_+' AND ((ORDERS.NETTOTAL)-(ORDERS.TAXTOTAL-ORDERS.SA_DISCOUNT))>0 AND ORD_ROW.ORDER_ROW_CURRENCY NOT IN(-8,-9,-10,-3)) AS A1';
	  
					  var str_prj_ship_total_ = 'SELECT ISNULL(SUM(NETTOTAL),0) NETTOTAL FROM ('
					  var str_prj_ship_total_ = str_prj_ship_total_+' SELECT ((SR.AMOUNT - (SELECT ISNULL(SUM(IR.AMOUNT),0) FROM INVOICE_ROW IR,INVOICE I WHERE I.INVOICE_ID = IR.INVOICE_ID AND I.PURCHASE_SALES = S.PURCHASE_SALES AND I.IS_IPTAL = 0 AND IR.WRK_ROW_RELATION_ID = SR.WRK_ROW_ID))) * (SR.GROSSTOTAL/SR.AMOUNT) AS NETTOTAL FROM SHIP S,SHIP_ROW SR WHERE S.SHIP_ID=SR.SHIP_ID AND S.PURCHASE_SALES = 1 AND S.IS_WITH_SHIP=0 AND ISNULL(S.IS_SHIP_IPTAL,0)=0 AND S.CONSUMER_ID='+$("#basket_main_div #consumer_id").val()+' AND S.PROJECT_ID='+project_id_;
					  var str_prj_ship_total_ = str_prj_ship_total_+' AND (SR.AMOUNT - (SELECT ISNULL(SUM(IR.AMOUNT),0) FROM <cfoutput>#dsn2_alias#</cfoutput>.INVOICE_ROW IR,<cfoutput>#dsn2_alias#</cfoutput>.INVOICE I WHERE I.INVOICE_ID = IR.INVOICE_ID AND I.PURCHASE_SALES = S.PURCHASE_SALES AND I.IS_IPTAL = 0 AND IR.WRK_ROW_RELATION_ID = SR.WRK_ROW_ID)) > 0';
					  if(chck_order_id_ > 0)
						  str_prj_ship_total_ = str_prj_ship_total_+' AND SR.ROW_ORDER_ID <> '+chck_order_id_;
					  var str_prj_ship_total_ = str_prj_ship_total_+') A1';
				  }
				  if(str_member_prj_risk_!=undefined)
				  {
					  var get_member_prj_risk = wrk_query(str_member_prj_risk_,'dsn2');
					  if(get_member_prj_risk.recordcount!= 0 && get_member_prj_risk.BAKIYE!='')
						  prj_total_risk_=parseFloat(get_member_prj_risk.BAKIYE)*(-1);
				  }
			  }
			  if( str_prj_order_risk_!=undefined)
			  {
				  var get_prj_order_risk_=wrk_query(str_prj_order_risk_,'dsn2');
				  if(get_prj_order_risk_.recordcount!= 0 && get_prj_order_risk_.NETTOTAL!='')
					  prj_total_risk_=parseFloat(prj_total_risk_)-parseFloat(get_prj_order_risk_.NETTOTAL);
			  }
			  if(str_prj_ship_total_!=undefined)
			  {
				  var get_prj_ship_total_=wrk_query(str_prj_ship_total_,'dsn2');
				  if(get_prj_ship_total_.recordcount!= 0 && get_prj_ship_total_.NETTOTAL!='' )
					  prj_total_risk_=parseFloat(prj_total_risk_)-parseFloat(get_prj_ship_total_.NETTOTAL);
			  }
			  if(prj_total_risk_<=0 || (prj_total_risk_ < parseFloat($("#basket_main_div #basket_net_total").val()) ) )
			  {
				  alert('Cari Alacak Bakiyesi Siparişi Kaydetmek İçin Yeterli Değil!!! \nSiparişi Kaydedemezsiniz!'+'\n Proje Bakiyesi:'+commaSplit(prj_total_risk_));
				  return false;
			  }
			  else return true;
		  }
	  }
  
	  function check_project_discount_conditions(prj_id_,prj_name_)
	  {
		  if(prj_id_ == undefined) 
			  var prj_id_='';
		  if(prj_name_ == undefined) 
			  var prj_name_='';
		  if(prj_id_ == '' && $("#basket_main_div #project_id").length != 0)
			  var prj_id_ = $("#basket_main_div #project_id").val();
		  if(prj_name_=='' && $("#basket_main_div #project_head").length != 0)
			  var prj_name_ = $("#basket_main_div #project_head").val();
		  
		  
		  var paper_date_ = js_date($("#basket_main_div #" + $("#basket_main_div #search_process_date").val()).val().toString());
  
		  if(prj_id_!='' && prj_name_!='')
		  {
			  var str_prj_discnt="SELECT COMPANY_ID,CONSUMER_ID,FINISH_DATE,START_DATE,PRICE_CATID,PD.PRO_DISCOUNT_ID,IS_CHECK_RISK,IS_CHECK_PRJ_LIMIT,IS_CHECK_PRJ_PRODUCT,IS_CHECK_PRJ_MEMBER,IS_CHECK_PRJ_PRICE_CAT,BRAND_ID,PRODUCT_CATID,PRODUCT_ID FROM PROJECT_DISCOUNTS PD,PROJECT_DISCOUNT_CONDITIONS PDC ";
			  str_prj_discnt=str_prj_discnt+" WHERE PD.PRO_DISCOUNT_ID=PDC.PRO_DISCOUNT_ID AND PD.PROJECT_ID="+prj_id_+" AND FINISH_DATE >="+paper_date_+" AND START_DATE<="+paper_date_;
			  var get_prj_discnt=wrk_query(str_prj_discnt,"dsn3");
		  
			  if(get_prj_discnt.recordcount != undefined && get_prj_discnt.recordcount != 0)
			  {
				  if(get_prj_discnt.recordcount > 1)
				  {
					  var control_comp_info = get_prj_discnt.COMPANY_ID[1];
					  var control_cons_info = get_prj_discnt.CONSUMER_ID[1];
					  var control_price_cat_info = get_prj_discnt.PRICE_CATID[1];
					  var is_chck_prj_prods_ = get_prj_discnt.IS_CHECK_PRJ_PRODUCT[1];
					  var is_chck_prj_risk_ = get_prj_discnt.IS_CHECK_PRJ_LIMIT[1];
					  var is_chck_prj_member_ = get_prj_discnt.IS_CHECK_PRJ_MEMBER[1];
					  var is_chck_prj_pricecat_ = get_prj_discnt.IS_CHECK_PRJ_PRICE_CAT[1];
				  }
				  else
				  {
					  var control_comp_info = get_prj_discnt.COMPANY_ID;
					  var control_cons_info = get_prj_discnt.CONSUMER_ID;
					  var control_price_cat_info = get_prj_discnt.PRICE_CATID;
					  var is_chck_prj_prods_ = get_prj_discnt.IS_CHECK_PRJ_PRODUCT;
					  var is_chck_prj_risk_ = get_prj_discnt.IS_CHECK_PRJ_LIMIT;
					  var is_chck_prj_member_ = get_prj_discnt.IS_CHECK_PRJ_MEMBER;
					  var is_chck_prj_pricecat_ = get_prj_discnt.IS_CHECK_PRJ_PRICE_CAT;
				  }
				  
				  if(is_chck_prj_member_ ==1 && ($("#basket_main_div #company_id").length != 0 && $("#basket_main_div #company_id").val() != control_comp_info) || ($("#basket_main_div #consumer_id").length != 0 && $("#basket_main_div #consumer_id").val() != control_cons_info))				
				  {
					  alert("Seçilen Cari İle Proje Bağlantı Carisi Aynı Değil!");
					  return false;
				  }				
				  var price_cat_row=0;
				  var cntrl_prj_prods_=0;
				  if(is_chck_prj_risk_==1)  /*baglantı kapsamında proje limit kontrolu yapılacaksa*/
				  {
					  <cfif not (isdefined("x_check_prj_bakiye_for_process") and len(x_check_prj_bakiye_for_process))>
						  if(!check_member_project_risk(prj_id_)) return false;
					  <cfelse>
						  var control_process_ids = "<cfoutput>#x_check_prj_bakiye_for_process#</cfoutput>";
						  if(! list_find(control_process_ids,$("#basket_main_div #process_stage").val()))
						  {
							  if(!check_member_project_risk(prj_id_)) return false;
						  }
					  </cfif>
				  }
				  if(window.basket.items.length > 1)
				  {
					  for(var roww_ii=0; roww_ii < window.basket.items.length; roww_ii++)
						  if(is_chck_prj_pricecat_==1 && window.basket.items[roww_ii].PRICE_CAT != control_price_cat_info)
						  {
							  price_cat_row=roww_ii+1;
							  break;
						  }
						  else
							  cntrl_prj_prods_=cntrl_prj_prods_ + ',' + window.basket.items[roww_ii].PRODUCT_ID;
				  }
				  else
				  {
					  cntrl_prj_prods_=cntrl_prj_prods_ + ',' + window.basket.items[0].PRODUCT_ID;
						  
					  if(is_chck_prj_pricecat_==1) //fiyat liatesi kontrolu yapılacaksa
					  {
						  if(window.basket.items[0].PRICE_CAT != control_price_cat_info)
							  price_cat_row=1;
					  }
				  }
				  if(price_cat_row > 0)
				  {
					  alert(price_cat_row+'. Satırdaki ürünün eklendiği fiyat listesi ile proje bağlantısında seçilen fiyat listesi farklı!');
					  return false;
				  }
				  
				  if(is_chck_prj_prods_==1 && list_len(cntrl_prj_prods_,',')>1) /*baglantı kapsamında urun kontrolu yapılacaksa*/
				  {
					  var prj_prod_list_=0;
					  var prj_brand_list_=0;
					  var prj_prod_cat_list=0;
					  for(var prj_dis_ii=0;prj_dis_ii<get_prj_discnt.recordcount;prj_dis_ii++)
					  {
						  if(get_prj_discnt.PRODUCT_ID[prj_dis_ii] != '')
							  prj_prod_list_ = prj_prod_list_ + ',' + get_prj_discnt.PRODUCT_ID[prj_dis_ii];
						  if(get_prj_discnt.BRAND_ID[prj_dis_ii] != '')
							  prj_brand_list_ = prj_brand_list_ + ',' + get_prj_discnt.BRAND_ID[prj_dis_ii];
						  if(get_prj_discnt.PRODUCT_CATID[prj_dis_ii] != '')
							  prj_prod_cat_list = prj_prod_cat_list + ',' + get_prj_discnt.PRODUCT_CATID[prj_dis_ii];
					  }
					  
					  var str_prod_list_="SELECT PRODUCT_ID,PRODUCT_NAME FROM PRODUCT WHERE PRODUCT_ID IN (" + cntrl_prj_prods_ + ") AND (";
					  if(prj_brand_list_ != 0 && list_len(prj_brand_list_ )>1)
					  {
						  str_prod_list_=str_prod_list_+"	 ISNULL(BRAND_ID,0) NOT IN ("+prj_brand_list_+") ";
						  if((prj_prod_cat_list != 0 && list_len(prj_prod_cat_list )>1) || (prj_prod_list_ !=0 && list_len(prj_prod_list_ )>1))
							  str_prod_list_ = str_prod_list_+"	OR ";	
					  }
					  if(prj_prod_cat_list != 0 && list_len(prj_prod_cat_list )>1)
					  {
						  str_prod_list_ = str_prod_list_+"	ISNULL(PRODUCT_CATID,0) NOT IN ("+prj_prod_cat_list+")";
						  if(prj_prod_list_ != 0 && list_len(prj_prod_list_ )>1)
							  str_prod_list_ = str_prod_list_+"	OR ";	
					  }	
					  if(prj_prod_list_!=0 && list_len(prj_prod_list_ )>1)
						  str_prod_list_= str_prod_list_+" PRODUCT_ID NOT IN ("+prj_prod_list_+")";
					  str_prod_list_ = str_prod_list_+" )";
					  var get_prod_list_ = wrk_query(str_prod_list_,"dsn3");
					  if(get_prod_list_.recordcount != undefined && get_prod_list_.recordcount!=0)
					  {
						  var alert_str = 'Bağlantı Kapsamında Olmayan Ürünler :\n'
						  for(var pr_ii=0; pr_ii<get_prod_list_.recordcount; pr_ii++)
							  alert_str = alert_str + ' ' + get_prod_list_.PRODUCT_NAME[pr_ii] + '\n';
  
						  alert(alert_str);
						  return false;
					  }
				  }
			  }
			  else
			  {
				  alert("<cf_get_lang dictionary_id='60024.İşlem Tarihinde Geçerli Proje Bağlantısı Yok'>!");
				  return false;
			  }
		  }
		  else
		  {
			  if(listfind(display_list, "is_project_selected") != -1)
			  {
				  alert("<cf_get_lang dictionary_id='58797.Proje Seçiniz'>");
				  return false;
			  }
			  else
				  return true;
		  }
		  return true;
	  }
  </cfif>
  
  <cfif ListFindNoCase(display_list, "check_row_discounts")><!--- şube iskonto yetki tanımlarını kontrol ediyor --->
  function check_branch_discount_rates()
  {
	  var alert_list='';
	  var cntrl_disc_prod_list=0;
	  
	  for(var roww_dd=0; roww_dd < window.basket.items.length; roww_dd++)
	  {
		  if(window.basket.items[roww_dd].INDIRIM1 != null && window.basket.items[roww_dd].INDIRIM1 != 0)
			  cntrl_disc_prod_list = cntrl_disc_prod_list + ',' + window.basket.items[roww_dd].PRODUCT_ID;
	  }
	  
	  if($("#basket_main_div #paymethod_id").length != 0 && list_len(cntrl_disc_prod_list)>1)
	  {
		  var listParam = cntrl_disc_prod_list + "*" + $("#basket_main_div #paymethod_id").val();
		  var str_branch_disc= "obj_get_branch_disc"
		  if($("#basket_main_div #paymethod_id").length != 0 && $("#basket_main_div #paymethod_id").val().length != 0)
			  str_branch_disc= "obj_get_branch_disc_2";
		  else if($("#basket_main_div #card_paymethod_id").length != 0 && $("#basket_main_div #card_paymethod_id").val().length != 0)
			  str_branch_disc="obj_get_branch_disc_3";
		  var get_branch_disc=wrk_safe_query(str_branch_disc,"dsn3",0,listParam);
		  if(get_branch_disc.recordcount!=undefined && get_branch_disc.recordcount!=0)
		  {
			  //document.form_basket.detail.value=str_branch_disc;
			  var prod_list_disc = '';
			  for(var pr_tt=0;pr_tt<get_branch_disc.recordcount;pr_tt++)
			  {
				  if(prod_list_disc=='')
					  prod_list_disc=get_branch_disc.PRODUCT_ID[pr_tt];
				  else
					  prod_list_disc=prod_list_disc + ',' + get_branch_disc.PRODUCT_ID[pr_tt];
			  }
			  
			  var alert_add_prod_list='0';
			  for(var roww_aa=0; roww_aa < window.basket.items.length; roww_aa++)
			  {
				  temp_row_discount = filterNumBasket(window.basket.items[roww_aa].INDIRIM1);
				  if(temp_row_discount !=0 && list_find(prod_list_disc,window.basket.items[roww_aa].PRODUCT_ID) && get_branch_disc.MAX_DISCOUNT[list_find(prod_list_disc,window.basket.items[roww_aa].PRODUCT_ID)-1] < temp_row_discount)
				  {
					  if(list_find(alert_add_prod_list,window.basket.items[roww_aa].PRODUCT_ID) == 0)
					  {
						  alert_list = alert_list + ' ' + get_branch_disc.PRODUCT_NAME[list_find(prod_list_disc,window.basket.items[roww_aa].PRODUCT_ID)-1] + ' ürünü için max. iskonto miktarı '+get_branch_disc.MAX_DISCOUNT[0]+' olmalıdır. \n';
						  alert_add_prod_list = alert_add_prod_list + ',' + window.basket.items[roww_aa].PRODUCT_ID;
					  }
				  }
			  }
		  }
	  }
	  if(alert_list!='')
	  {
		  alert('Aşağıda Belirtilen Ürünlerin İskonto Oranlarını Kontrol Ediniz! \n\n' + alert_list);
		  return false;
	  }
	  else
		  return true;
  }
  </cfif>
  
  
  <cfif ListFindNoCase(display_list, "number_of_installment")>
  function basket_taksit_hesapla(from_row)
  {//basket satırındaki taksit degistiginde taksit oranlarına gore yeni fiyatı hesaplar.
	  if(!from_row)
		  from_row = 0;
	  var data = window.basket.items[from_row];
	  
	  if($("#basket_main_div #paymethod_vehicle").length != 0 && $("#basket_main_div #paymethod_vehicle").val().length != 0)
	  {
		  var price_list_inst_number = 0;
		  var new_installment_number_ =  filterNumBasket(data.NUMBER_OF_INSTALLMENT,0);
		  var row_price_cat_ = data.PRICE_CAT;
		  var row_list_price_ = filterNumBasket(data.LIST_PRICE,price_round_number);
		  var row_product_id_ = data.PRODUCT_ID;
		  
		  if(new_installment_number_ != 0 )
			  var avg_due_day = (30+(new_installment_number_*30))/2;
		  else
			  var avg_due_day = 0;
		  setFieldValue('duedate', from_row, avg_due_day,0); //satırın vadesi degistiriliyor
		  if(row_price_cat_ !='')
		  {
			  var new_sql = 'SELECT PRICE_CATID,NUMBER_OF_INSTALLMENT FROM PRICE_CAT WHERE PRICE_CATID ='+ row_price_cat_;
			  var get_price_cat_month = wrk_safe_query('obj_get_price_cat_month',"dsn3",0,row_price_cat_);
			  if(get_price_cat_month.recordcount) 
				  price_list_inst_number = get_price_cat_month.NUMBER_OF_INSTALLMENT;
		  }
		  if(new_installment_number_ == price_list_inst_number)
			  var new_price_ =row_list_price_;
			  
						  
		  else
		  { //dövizli fiyat hesaplaması eksik, tamamlanacak...
			  var paper_date = js_date($("#basket_main_div #" + $("#basket_main_div #search_process_date").val()).val().toString());
			  var listParam = new_installment_number_ + "*" + row_product_id_ + "*" + paper_date ;
			  var get_new_pricecat_ = wrk_safe_query("obj_get_new_pricecat","dsn3",0,listParam);
			  if(get_new_pricecat_.recordcount != undefined && get_new_pricecat_.recordcount != 0)
			  {
				  setFieldValue('price', from_row, wrk_round(get_new_pricecat_.PRICE,price_round_number),3);
				  //setFieldValue('price_cat', from_row,get_new_pricecat_.PRICE_CATID,0); yeni bulunan fiyat listesi id'si satıra set ediliyordu.
				  hesapla('price',from_row+1);
			  }
			  else
			  {
				  if(new_installment_number_ != 0) 
					  var get_installment_rate_ = wrk_safe_query('obj_get_installment_rate', "dsn3",0,new_installment_number_);
				  else if(new_installment_number_ == 0 && price_list_inst_number != 0)
					  var get_installment_rate_ = wrk_safe_query('obj_get_installment_rate', "dsn3",0,price_list_inst_number);
				  //vade oranları alınıyor
				  if(get_installment_rate_ != undefined && get_installment_rate_.recordcount != undefined && get_installment_rate_.recordcount != 0)
				  {
					  if(new_installment_number_ > price_list_inst_number) //taksit sayısı fiyat listesine gore artmıssa
					  {
						  switch(Number($("#basket_main_div #paymethod_vehicle").val()))
						  {
							  case -1 : var installment_rate_ = get_installment_rate_.CREDITCARD_RATE; //Kredi Kartı
							  case 1 : var installment_rate_ = get_installment_rate_.CHEQUE_RATE; //Çek
							  case 2 : var installment_rate_ = get_installment_rate_.VOUCHER_RATE; //Senet
							  case 3 : var installment_rate_ = get_installment_rate_.BANKPAYMENT_RATE; // Havale
						  }
					  }
					  else if(new_installment_number_ < price_list_inst_number) //taksit sayısı fiyat listesine gore azalmıssa
					  {
						  switch(Number($("#basket_main_div #paymethod_vehicle").val()))
						  {
							  case -1 : var installment_rate_ = get_installment_rate_.CREDITCARD_RATE_DISCOUNT; //Kredi Kartı
							  case 1 : var installment_rate_ = get_installment_rate_.CHEQUE_RATE_DISCOUNT; //Çek
							  case 2 : var installment_rate_ = get_installment_rate_.VOUCHER_RATE_DISCOUNT; //Senet
							  case 3 : var installment_rate_ = get_installment_rate_.BANKPAYMENT_RATE_DISCOUNT; // Havale
						  }
					  }
					  if(installment_rate_ != undefined && installment_rate_ != '' && price_list_inst_number != undefined && price_list_inst_number != '')
						  var new_price_ = ((new_installment_number_ - price_list_inst_number) * (installment_rate_ / 100) * row_list_price_) + row_list_price_;
				  }
			  }
		  }	
		  if(new_price_ != undefined && new_price_ != '')
		  {
			  setFieldValue('price', from_row, wrk_round(new_price_,price_round_number),3); //fiyat degistiriliyor
			  hesapla('price',from_row+1); //satır yeniden hesaplanıyor
		  }
		  else
			  toplam_hesapla(0);
	  }
  }
  </cfif>
  
  <cfif ListFindNoCase(display_list, "is_promotion")>
  function control_row_prom(from_row)
  { 
  /*satır promosyon bilgilerini kontrol edip, bedava urun miktarını edit eder.OZDEN20071018*/
	  var row_prom_relation_id = '';
	  var control_prom =0;
	  
	  if(!from_row)
		  from_row = 0;
		  
	  var data = window.basket.items[from_row];
	  
	  if(data.ROW_PROMOTION_ID.length != 0 && data.IS_PROMOTION.val() == 0) //satır bazlı promosyon varsa
	  {
			  var prom_stock_id = data.STOCK_ID.val();
			  var row_prom_id = data.ROW_PROMOTION_ID.val();
			  row_prom_relation_id =  data.PROM_RELATION_ID.val();
			  var row_stock_amount = filterNumBasket(data.AMOUNT.val(),amount_round);
			  control_prom =1;
	  }
	  if(control_prom) //satır bazlı promosyon varsa
	  {
		  var free_prom_row=0;
		  var prom_comp_id = $("#basket_main_div #company_id").val();
		  /*uyenin fiyat listesi varsa alınır yoksa standart satısa bakılır*/
		  if($("#basket_main_div #basket_member_pricecat").length != 0 && $("#basket_main_div #basket_member_pricecat").val().length != 0)
			  var member_price_cat = $("#basket_main_div #basket_member_pricecat").val();
		  else
			  var member_price_cat = '-2';
		  if(window.basket.items.length > 1) //tek satır varsa o promosyon satırı olamaz.
		  {
			  for(var counter_i=0; counter_i < window.basket.items.length; counter_i++) //promosyon urun satırı aranıyor
				  if(window.basket.items[counter_i].IS_PROMOTION == 1 && window.basket.items[counter_i].ROW_PROMOTION_ID == row_prom_id && window.basket.items[counter_i].PROM_RELATION_ID == row_prom_relation_id) //urunun promosyon satırı bulunuyor
					  free_prom_row=counter_i;
		  }
		  
		  var prom_date = js_date($("#basket_main_div #" + $("#basket_main_div #search_process_date").val()).val().toString());
		  if($("#basket_main_div #company_id").length != 0 && $("#basket_main_div #company_id").val().length != 0)
		  {
			  var listParam = row_stock_amount  + "*" + $("#basket_main_div #company_id").val() + "*" + member_price_cat + "*" + prom_stock_id + "*" + prom_date + "*" + row_prom_id;
			  //var new_row_sql = 'SELECT FREE_STOCK_ID,PROM_ID,FREE_STOCK_PRICE,AMOUNT_1_MONEY,LIMIT_VALUE, AMOUNT_1, FREE_STOCK_AMOUNT FROM PROMOTIONS WHERE PROM_ID = '+row_prom_id+' AND PROM_STATUS = 1 AND PROM_TYPE = 1 AND LIMIT_TYPE =1 AND LIMIT_VALUE < = ' + row_stock_amount + ' AND (COMPANY_ID IS NULL OR COMPANY_ID = '+form_basket.company_id.value+') AND (PRICE_CATID =-2 OR PRICE_CATID IN ('+ member_price_cat +')) AND STOCK_ID = '+prom_stock_id +' AND '+prom_date+' BETWEEN STARTDATE AND FINISHDATE ORDER BY STARTDATE ASC, LIMIT_VALUE DESC';
			  //form_basket.order_detail.value =new_row_sql;
		  }
		  else
		  {
			  var listParam = row_stock_amount  + "*" + 0 + "*" + member_price_cat + "*" + prom_stock_id + "*" + prom_date + "*" + row_prom_id;
			  //var new_row_sql = 'SELECT FREE_STOCK_ID,PROM_ID,FREE_STOCK_PRICE,AMOUNT_1_MONEY,LIMIT_VALUE, AMOUNT_1, FREE_STOCK_AMOUNT FROM PROMOTIONS WHERE PROM_ID = '+row_prom_id+' AND PROM_STATUS = 1 AND PROM_TYPE = 1 AND LIMIT_TYPE =1 AND LIMIT_VALUE < = ' + row_stock_amount + ' AND (COMPANY_ID IS NULL OR COMPANY_ID = '+form_basket.company_id.value+') AND (PRICE_CATID =-2 OR PRICE_CATID IN ('+ member_price_cat +')) AND STOCK_ID = '+prom_stock_id +' AND '+prom_date+' BETWEEN STARTDATE AND FINISHDATE ORDER BY STARTDATE ASC, LIMIT_VALUE DESC';
			  //form_basket.order_detail.value =new_row_sql;
		  }
		  var get_row_proms = wrk_safe_query("obj_get_row_proms",'dsn3',"1",listParam);
		  
		  
  
		  if(get_row_proms.recordcount)
		  { 
			  var free_stock_multiplier = parseInt(row_stock_amount/get_row_proms.LIMIT_VALUE);
			  
			  if(get_row_proms.PROM_ID != row_prom_id) //yeni promosyon bulunmussa is_promotion=0 olan satırın promosyon bilgisi guncelleniyor
			  {
				  data.ROW_PROMOTION_ID.val(get_row_proms.PROM_ID);
				  $("#tblBasket tr[basketItem]").eq(from_row).find("#row_promotion_id").val(get_row_proms.PROM_ID);
			  }
			  if(free_prom_row != 0 ) //bedava urun satırı var ve guncellenecek
				  add_free_prom(get_row_proms.FREE_STOCK_ID,get_row_proms.PROM_ID,get_row_proms.FREE_STOCK_PRICE,get_row_proms.AMOUNT_1_MONEY,(free_stock_multiplier*get_row_proms.FREE_STOCK_AMOUNT),'',get_row_proms.AMOUNT_1,free_prom_row+1,1,row_prom_relation_id)
			  else //bedava urun satırı yok, eklenecek
				  add_free_prom(get_row_proms.FREE_STOCK_ID,get_row_proms.PROM_ID,get_row_proms.FREE_STOCK_PRICE,get_row_proms.AMOUNT_1_MONEY,(free_stock_multiplier*get_row_proms.FREE_STOCK_AMOUNT),'',get_row_proms.AMOUNT_1,0,0,row_prom_relation_id)
		  }
		  else if(free_prom_row != 0 ) //promosyon bulamadıgı zaman ilk satırı silmemesi icin
			  del_row(free_prom_row+1); //bedava urun satırı siliniyor
	  }
  }
  </cfif>
  
  <cfif ListFindNoCase(display_list, "spec")>
  function open_spec(satir)
  {
	  var opener_basket_id = window.basket.hidden_values.basket_id;
	  if(!satir)
		  satir = 0;
		  
	  var data = window.basket.items[satir];
		  
	  var row_id = satir;
	  var field_id = data.SPECT_ID;
	  var money_ = data.OTHER_MONEY;
	  var stock_id = data.STOCK_ID;
	  var product_id = data.PRODUCT_ID;
	  var price_catid_ = data.PRICE_CAT;
	  var price_ = data.PRICE;
	  var main_stock_amount = filterNumBasket(data.AMOUNT,4);
	  
  
	  var aranan_tarih="";
	  try{
		  if($("#basket_main_div #search_process_date").val().length != 0)
			  aranan_tarih = $("#basket_main_div #" + $("#basket_main_div #search_process_date").val()).val().toString();
	  }
	  catch(e)
	  {}
	  if(field_id == '')
	  {
		  url_str = '<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_configurator&type=add&basket_id='+opener_basket_id;
		  <!--- // process_type değişkeni --->
		  sepet_process_obj = findObj("process_cat");
		  if(sepet_process_obj != null)
			  url_str = url_str + '&sepet_process_type='+process_type_array[sepet_process_obj.selectedIndex];
		  else
			  url_str = url_str + '&sepet_process_type=-1';
		  <!--- // process_type değişkeni --->
		  if($("#basket_main_div #company_id").length != 0)
			  url_str = url_str+'&company_id=' + $("#basket_main_div #company_id").val();
		  if($("#basket_main_div #consumer_id").length != 0)
			  url_str = url_str + '&consumer_id=' + $("#basket_main_div #consumer_id").val();
  
		  <cfloop query="get_money_bskt">
			  url_str = url_str + '&<cfoutput>#money_type#=#rate2/rate1#</cfoutput>';
		  </cfloop>
  
		  openBoxDraggable(url_str+'&product_id='+product_id+'&row_id='+row_id+'&stock_id='+stock_id+'&money_='+money_+'&price='+filterNum(price_)+'&price_catid='+price_catid_+'&search_process_date=' + aranan_tarih+'&main_stock_amount='+main_stock_amount,'','ui-draggable-box-large');
	  }
	  else
	  {
		  url_str = '<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_configurator&type=upd&basket_id='+opener_basket_id;
		  //lokasyon ve department
		  if($("#basket_main_div #location_id").length != 0)
			  var paper_location = $("#basket_main_div #location_id").val();
		  else
			  var paper_location = '';
		  
		  if($("#basket_main_div #department_id").length != 0)
			  var paper_department = $("#basket_main_div #department_id").val();
		  else if($("#basket_main_div #DEPARTMENT_ID").length != 0)//burda eger stok emirden sipars israsliyeye cekilirken duzenlerseniz kaldıralım
			  var paper_department = $("#basket_main_div #DEPARTMENT_ID").val();
		  else
			  var paper_department = '';
		  <!--- // process_type değişkeni --->
		  sepet_process_obj = findObj("process_cat");
		  if(sepet_process_obj != null)
			  url_str = url_str + '&sepet_process_type='+process_type_array[sepet_process_obj.selectedIndex];
		  else
			  url_str = url_str + '&sepet_process_type=-1';
		  <!--- // process_type değişkeni --->
		  if($("#basket_main_div #company_id").length != 0)
			  url_str = url_str+'&company_id=' + $("#basket_main_div #company_id").val();
		  if($("#basket_main_div #consumer_id").length != 0)
			  url_str = url_str + '&consumer_id=' + $("#basket_main_div #consumer_id").val();
			  
		  <cfloop query="get_money_bskt">
			  url_str = url_str + '&<cfoutput>#money_type#=#rate2/rate1#</cfoutput>';
		  </cfloop>
  
		  openBoxDraggable(url_str+'&product_id='+product_id+'&id='+field_id+'&row_id='+row_id+'&money_='+money_+'&price='+filterNum(price_)+'&stock_id='+stock_id+'&price_catid='+price_catid_+'&search_process_date=' + aranan_tarih+'&main_stock_amount='+main_stock_amount+'&paper_location='+paper_location+'&paper_department='+paper_department,'','ui-draggable-box-large');	
	  }
  }
  </cfif>
  
  <cfif ListFindNoCase(display_list, "shelf_number") or ListFindNoCase(display_list, "shelf_number_2")>
  function open_shelf_list(satir,satir_sayisi,list_type,field_id,field_name)
  {
	  url_str = '';
	  shelf_dept_name = '';
	  shelf_loc_name = '';
	  if(!satir)
		  satir = 0;
	  var data = window.basket.items[satir];
	  
	  if(field_id=='to_shelf_number') //depo sevk ve ambar fişindeki giriş depo,basketteki raf_no_2 alanıyla kontrol ediliyor
	  {
		  if(listfind('31,32,49',window.basket.hidden_values.basket_id) != -1) // Stok Sevk İrsaliyesi,İthal Mal Girişi
		  {
			  shelf_dept_name = 'department_in_id';
			  shelf_loc_name = 'location_in_id';
		  }
		  else if(listfind('10',window.basket.hidden_values.basket_id) != -1) // Toptan Satış İrsaliyesi
		  {
			  shelf_dept_name = 'department_id';
			  shelf_loc_name = 'location_id';	
		  }
		  else if(listfind('12',window.basket.hidden_values.basket_id) != -1) // Stok Alım İrsaliyesi, Stok Fişi
		  {
			  sepet_process_obj = findObj("process_cat");
			  if(sepet_process_obj != null)
				  control_process_type = process_type_array[sepet_process_obj.selectedIndex];
			  else
				  control_process_type = '-1';
			  if(control_process_type != undefined && list_find('113',control_process_type)) //sarf ve fire fisi icin cıkıs deposu
			  {
				  shelf_dept_name = 'department_in';
				  shelf_loc_name = 'location_in';
			  }
		  }
	  }
	  else
	  {
		  if(listfind('4,6',window.basket.hidden_values.basket_id) != -1) // Satış Siparişi, SatınAlma Siparişi
		  {
			  shelf_dept_name = 'deliver_dept_id';
			  shelf_loc_name = 'deliver_loc_id';	
		  }
		  else if(listfind('14,15',window.basket.hidden_values.basket_id) != -1) // Stok Alım Siparişi, Stok Satış Siparişi
		  {
			  shelf_dept_name = 'department_id';
			  shelf_loc_name = 'location_id';	
		  }
		  else if(listfind('7',window.basket.hidden_values.basket_id) != -1) // İç Talep
		  {
				shelf_dept_name = 'department_in_id';
				shelf_loc_name = 'location_in_id';	
		  }
		  else if(listfind('12',window.basket.hidden_values.basket_id) != -1) // Stok Fişi, Stok Açılış Fişi
		  {
			  sepet_process_obj = findObj("process_cat");
			  if(sepet_process_obj != null)
				  control_process_type=process_type_array[sepet_process_obj.selectedIndex];
			  else
				  control_process_type='-1';
			  if(control_process_type!=undefined && list_find('111,112,113',control_process_type)) //sarf ve fire fisi icin cıkıs deposu
			  {
				  shelf_dept_name = 'department_out';
				  shelf_loc_name = 'location_out';
			  }
			  else
			  {
				  shelf_dept_name = 'department_in';
				  shelf_loc_name = 'location_in';
			  }
		  }
		  else
		  {
			  shelf_dept_name = 'department_id';
			  shelf_loc_name = 'location_id';
		  }
	  }
	  if(shelf_dept_name!='' && shelf_loc_name!='' && $("#basket_main_div #"+shelf_dept_name).val().length != 0 && $("#basket_main_div #"+shelf_loc_name).val().length != 0)
	  {
		  var shelf_prod_id = data.PRODUCT_ID;
		  var shelf_stock_id = data.STOCK_ID;
		  var shelf_stock_amount = filterNumBasket(data.AMOUNT,4);
		  
		  sepet_process_obj = findObj("process_cat");
		  if(sepet_process_obj != null)
			  control_process_type=process_type_array[sepet_process_obj.selectedIndex];
		  else
			  control_process_type='-1';
		  kontrol_out = 0;
		  if(list_find('111,112,113,81',control_process_type))
			  kontrol_out = 1;
		  if(list_type == 0) //basket satırında acılan raf listesi
			  windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_shelves&kontrol_out='+kontrol_out+'&is_basket_kontrol=1&shelf_product_id='+shelf_prod_id+'&shelf_stock_id='+shelf_stock_id+'&form_name=form_basket&field_code='+field_name+'&field_id='+field_id+'&department_id='+$("#basket_main_div #"+shelf_dept_name).val()+'&location_id='+$("#basket_main_div #"+shelf_loc_name).val()+'&row_id='+satir+'&row_count='+satir_sayisi+'&satir='+satir,'small','shelf_list_page');
		  else if(list_type ==1) //stok raf dagılım listesi, satır cogaltarak raflara gore dagıtım yapıyor.
			  windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_stock_shelf_distribution&form_name=form_basket&prod_id='+shelf_prod_id+'&stock_id='+shelf_stock_id+'&prod_amount='+shelf_stock_amount+'&department_id='+$("#basket_main_div #"+shelf_dept_name).val()+'&location_id='+$("#basket_main_div #"+shelf_loc_name).val()+'&bskt_row_id='+satir+'&bskt_row_count='+satir_sayisi+'&satir='+satir,'medium','shelf_list_page');
	  }
	  else
		  alert("<cf_get_lang dictionary_id='57723.Önce depo seçmelisiniz'>");
  }
  </cfif>
  
  
  //Bu fonksiyon dsp_basket_js_scripts2.cfm dosyasında hesabi_bitir fonksiyonunda cagriliyor. Submit edilecek olan array olduğu için bu fonksiyona ihtiyaç kalmayacaktır. 
  function formatFieldValue(alan, sira, function_no,round_value_) <!--- // verilen alanı istenen formatda formatlar ---> 
  {	
	  if(sira != undefined)
		  sira_ = sira;
	  else
		  sira_ = 0;
  
	  var f_value = window.basket.items[sira][alan.toUpperCase()];
  
	  if(function_no == 1)
	  {
		  if(round_value_!= undefined && round_value_ != '')
			  f_value = filterNumBasket(f_value,round_value_);
		  else
			  f_value = filterNumBasket(f_value,price_round_number);
	  }
	  else if(function_no == 2) 
		  f_value = f2(f_value);
	  else if(function_no == 3)
	  {
		  if(!isNaN(round_value_))
			  f_value = commaSplit(f_value,round_value_);
		  else
			  f_value = commaSplit(f_value,price_round_number);
	  }
	  
	  $("#tblBasket tr[basketItem]").eq(sira_).find("#"+alan).val(f_value);
	  return true;
  }
  
  <cfif isdefined('attributes.is_retail') or ( ListFindNoCase(display_list, "barcode_price_list") and ListFindNoCase(display_list, "barcode_amount") )> 
  //perakende ve barkoddan urun ekle secilmisse gelir. cari, islem tipi, odeme yontemine gore secilebilecek fiyat listelerini add_bsket_row_from_barkod.cfm dosyasına ekler
  function set_price_catid_options()
  {
	  <cfif listgetat(attributes.fuseaction,1,'.') is 'store'>
		  var is_store_module=1; 
	  <cfelse>
		  var is_store_module=0;
	  </cfif>
	  if(window.basket.hidden_values.sale_product)
		  is_sale_product = window.basket.hidden_values.sale_product;
	  else
		  is_sale_product = 0;
		  
	  var sepet_process_obj = findObj("process_cat");
	  if(sepet_process_obj != null) 
		  selected_process_type = process_type_array[sepet_process_obj.selectedIndex]; 
	  else
		  selected_process_type = -1;	
	  
	  if(listfind('1,2,4,6,18,20,33,51',window.basket.hidden_values.basket_id) != -1)	
	  {
		  if($("#basket_main_div #card_paymethod_id").length != 0)
			  var temp_card_paymethod =$("#basket_main_div #card_paymethod_id").val(); 
		  else 
			  var temp_card_paymethod = '';	
		  if($("#basket_main_div #paymethod_vehicle").length != 0)
			  var temp_paymethod_vehicle =$("#basket_main_div #temp_paymethod_vehicle").val();
		  if($("#basket_main_div #paymethod_id").length != 0 &&  $("#basket_main_div #paymethod_id").val().length != 0)
		  {
			  var get_pymthd_vehicle_ = wrk_safe_query('obj_get_pymthd_vehicle',"dsn",0, $("#basket_main_div #paymethod_id").val());
			  if(get_pymthd_vehicle_.recordcount!=0 && get_pymthd_vehicle_.PAYMENT_VEHICLE != '')
				  var temp_paymethod_vehicle=get_pymthd_vehicle_.PAYMENT_VEHICLE;
			  else
				  var temp_paymethod_vehicle='';
		  }
		  else 
			  var temp_paymethod_vehicle = '';
	  }
	  else
	  {
		  var temp_card_paymethod = '';
		  var temp_paymethod_vehicle = '';
	  }
  
	  if(is_sale_product == 1) //satıs 
	  {
		if($("#basket_main_div #company_id").length != 0 && $("#basket_main_div #company_id").val().length != 0)
		{
			var get_credit_limit = wrk_safe_query('obj_get_credit_limit',"dsn",0,$("#basket_main_div #company_id").val());
			var get_comp_cat = wrk_safe_query('obj_get_comp_cat',"dsn",0,$("#basket_main_div #company_id").val());
			var str_price_cat_ = "SELECT PRICE_CATID,PRICE_CAT FROM PRICE_CAT WHERE ";
			if(window.frames[add_prod_no].document.add_speed_prod.dsp_only_member_price_cat_sales.value == 1) //sadece risk tanımında gecerli fiyat listesi gelsin
			{
				if(get_credit_limit.recordcount != 0 && get_credit_limit.PRICE_CAT != '' )
					str_price_cat_ = str_price_cat_+'  (PRICE_CAT_STATUS = 1 AND IS_SALES = 1 AND PRICE_CATID IN (SELECT PC.PRICE_CATID FROM PRICE_CAT_EXCEPTIONS PC WHERE PC.COMPANY_ID =' + $("#basket_main_div #company_id").val() + ' AND PC.ACT_TYPE = 2 AND IS_DEFAULT = 1 AND PC.PURCHASE_SALES = 1) ) ';
				else
					str_price_cat_ = str_price_cat_+' 1=2 ';
				str_price_cat_ = str_price_cat_	+' ORDER BY PRICE_CAT';
			}
			else
			{
				if(get_credit_limit.recordcount != 0 && get_credit_limit.PRICE_CAT != '' )
					str_price_cat_ = str_price_cat_+'  (PRICE_CAT_STATUS = 1 AND IS_SALES = 1 AND PRICE_CATID IN (SELECT PC.PRICE_CATID FROM PRICE_CAT_EXCEPTIONS PC WHERE PC.COMPANY_ID =' + $("#basket_main_div #company_id").val() + ' AND PC.ACT_TYPE = 2 AND IS_DEFAULT = 1 AND PC.PURCHASE_SALES = 1) ) OR ';
				str_price_cat_ = str_price_cat_+'(PRICE_CAT_STATUS = 1 ';
				//if(window.frames[add_prod_no].document.add_speed_prod.basket_product_list_type.value != 13)
					str_price_cat_ = str_price_cat_+' AND COMPANY_CAT LIKE \'%,' +get_comp_cat.COMPANYCAT_ID +',%\'';
				//else 
				//{
					if(temp_card_paymethod != undefined && temp_card_paymethod != '') 
						str_price_cat_ = str_price_cat_+'AND PAYMETHOD = 4';
					else if(temp_paymethod_vehicle != undefined && temp_paymethod_vehicle != '') 
						str_price_cat_ = str_price_cat_+'AND PAYMETHOD ='+temp_paymethod_vehicle;
					if(is_store_module != undefined && is_store_module==1)
						str_price_cat_ = str_price_cat_+'AND BRANCH LIKE \'%,<cfoutput>#LISTGETAT(SESSION.EP.USER_LOCATION,2,"-")#</cfoutput>,%\'';		
				//}
				str_price_cat_ = str_price_cat_	+') ORDER BY PRICE_CAT';
			}
			var get_price_cat = wrk_query(str_price_cat_,"dsn3");
			if(get_credit_limit.recordcount != 0 && get_credit_limit.PRICE_CAT != 0)
				var selected_price_catid = get_credit_limit.PRICE_CAT;
			else if(get_price_cat.recordcount != 0)
				var selected_price_catid=get_price_cat.PRICE_CATID;
		}
		else if($("#basket_main_div #consumer_id").length != 0 && $("#basket_main_div #consumer_id").val().length != 0)
		{
			var get_credit_limit = wrk_safe_query('obj_get_credit_limit_2',"dsn",0,$("#basket_main_div #consumer_id").val());
			
			var get_comp_cat = wrk_safe_query('obj_get_comp_cat_2',"dsn",0,$("#basket_main_div #consumer_id").val());
			
			var str_price_cat_ = "SELECT PRICE_CATID,PRICE_CAT FROM PRICE_CAT WHERE";
			if(window.frames[add_prod_no].document.add_speed_prod.dsp_only_member_price_cat_sales.value == 1)
			{
				if(get_credit_limit.recordcount != 0 && get_credit_limit.PRICE_CAT != '' )
					var str_price_cat_ = str_price_cat_+' (PRICE_CAT_STATUS = 1 AND PRICE_CATID = ' +get_credit_limit.PRICE_CAT+ ')';
				else
					var str_price_cat_ = str_price_cat_+' 1=2 ';
				str_price_cat_ = str_price_cat_	+'ORDER BY PRICE_CAT';
			}
			else
			{
				if(get_credit_limit.recordcount != 0 && get_credit_limit.PRICE_CAT != '' )
					var str_price_cat_ = str_price_cat_+' (PRICE_CAT_STATUS = 1 AND PRICE_CATID = ' +get_credit_limit.PRICE_CAT+ ') OR ';
				str_price_cat_ = str_price_cat_+'(PRICE_CAT_STATUS = 1 ';
				if(window.frames[add_prod_no].document.add_speed_prod.basket_product_list_type.value != 13)
					str_price_cat_ = str_price_cat_+' AND CONSUMER_CAT LIKE \'%,' +get_comp_cat.CONSUMER_CAT_ID +',%\'';
				else 
				{
					if(temp_card_paymethod != undefined && temp_card_paymethod != '') 
						str_price_cat_ = str_price_cat_+'AND PAYMETHOD = 4';
					else if(temp_paymethod_vehicle != undefined && temp_paymethod_vehicle != '') 
						str_price_cat_ = str_price_cat_+'AND PAYMETHOD ='+temp_paymethod_vehicle;
					if(is_store_module != undefined && is_store_module==1)
						str_price_cat_ = str_price_cat_+'AND BRANCH LIKE \'%,<cfoutput>#LISTGETAT(SESSION.EP.USER_LOCATION,2,"-")#</cfoutput>,%\'';		
				}
				str_price_cat_ = str_price_cat_	+' ) ORDER BY PRICE_CAT';
			}
			var get_price_cat = wrk_query(str_price_cat_,"dsn3");
			
			if(get_credit_limit.recordcount != 0 && get_credit_limit.PRICE_CAT != 0)
				var selected_price_catid = get_credit_limit.PRICE_CAT;
			else if(get_price_cat.recordcount != 0)
			{
				if(is_sale_product == 1)
					var selected_price_catid=-2;
				else
					var selected_price_catid=-1;
			}
		}
		else if($("#basket_main_div #employee_id").length != 0 && $("#basket_main_div #employee_id").val().length != 0)
		{
			var str_price_cat_ = "SELECT PRICE_CATID,PRICE_CAT FROM PRICE_CAT WHERE PRICE_CAT_STATUS = 1 AND IS_SALES = 1 ORDER BY PRICE_CAT";
			var get_price_cat = wrk_query(str_price_cat_,"dsn3");
			var selected_price_catid=get_price_cat.PRICE_CATID;
		}
	  }
	  else //alıs tipli islemler
	  {
		  
		  if($("#basket_main_div #company_id").length != 0 && $("#basket_main_div #company_id").val().length != 0)
		  {
			  
			  var str_price_cat_ ="SELECT PRICE_CATID,PRICE_CAT FROM PRICE_CAT WHERE" ;
			  var get_credit_limit = wrk_safe_query('obj_get_credit_limit_pur',"dsn",0,$("#basket_main_div #company_id").val());
			  var get_comp_cat = wrk_safe_query('obj_get_comp_cat',"dsn",0,$("#basket_main_div #company_id").val());
			  if(window.frames[add_prod_no].document.add_speed_prod.dsp_only_member_price_cat_purchase.value == 1){
				  if(get_credit_limit.recordcount != 0 && get_credit_limit.PRICE_CAT_PURCHASE != '' )
					  str_price_cat_ = str_price_cat_+' (PRICE_CAT_STATUS = 1 AND IS_PURCHASE = 1 AND PRICE_CATID IN (SELECT PC.PRICE_CATID FROM PRICE_CAT_EXCEPTIONS PC WHERE PC.COMPANY_ID =' + $("#basket_main_div #company_id").val() + ' AND PC.ACT_TYPE = 2 AND IS_DEFAULT = 1 AND PC.PURCHASE_SALES = 0) ) ';
				  else
					  str_price_cat_ = str_price_cat_+' 1=2 ';
				  str_price_cat_ = str_price_cat_	+' ORDER BY PRICE_CAT';
			  }
			  else{
				  if(get_credit_limit.recordcount != 0 && get_credit_limit.PRICE_CAT_PURCHASE != '' )
					  str_price_cat_ = str_price_cat_+'  (PRICE_CAT_STATUS = 1 AND IS_PURCHASE = 1 AND PRICE_CATID IN (SELECT PC.PRICE_CATID FROM PRICE_CAT_EXCEPTIONS PC WHERE PC.COMPANY_ID =' + $("#basket_main_div #company_id").val() + ' AND PC.ACT_TYPE = 2 AND IS_DEFAULT = 1 AND PC.PURCHASE_SALES = 0) ) OR ';
				  str_price_cat_ = str_price_cat_+'(PRICE_CAT_STATUS = 1 ';
				  if(get_comp_cat.recordcount != 0 && get_comp_cat.COMPANYCAT_ID != '' )
				  str_price_cat_ = str_price_cat_+' AND COMPANY_CAT LIKE \'%,' +get_comp_cat.COMPANYCAT_ID +',%\'';
				  if(window.frames[add_prod_no].document.add_speed_prod.basket_product_list_type.value != 13)
					  if(is_store_module != undefined && is_store_module==1 && selected_process_type != undefined && list_find('49,51,52,54,55,59,60,601,63,591',selected_process_type))
						  str_price_cat_ = str_price_cat_+'AND BRANCH LIKE \'%,<cfoutput>#LISTGETAT(SESSION.EP.USER_LOCATION,2,"-")#</cfoutput>,%\'';		
				  else 
				  {
					  if(temp_card_paymethod != undefined && temp_card_paymethod != '') 
						  str_price_cat_ = str_price_cat_+'AND PAYMETHOD = 4';
					  else if(temp_paymethod_vehicle != undefined && temp_paymethod_vehicle != '') 
						  str_price_cat_ = str_price_cat_+'AND PAYMETHOD ='+temp_paymethod_vehicle;
				  }
				  str_price_cat_ = str_price_cat_	+') ORDER BY PRICE_CAT';
			  
			  }
			  
			  var get_price_cat = wrk_query(str_price_cat_,"dsn3");
			  if(get_credit_limit.recordcount != 0 && get_credit_limit.PRICE_CAT_PURCHASE != 0)
				  var selected_price_catid = get_credit_limit.PRICE_CAT_PURCHASE;
			  else if(get_price_cat.recordcount != 0)
				  var selected_price_catid=get_price_cat.PRICE_CATID;
			  else 
				  var selected_price_catid='-1';
		  }
		  else if($("#basket_main_div #consumer_id").length != 0 && $("#basket_main_div #consumer_id").val().length != 0)
		  {
			  var str_price_cat_ ="SELECT PRICE_CATID,PRICE_CAT FROM PRICE_CAT WHERE ";
			  
			  var get_credit_limit = wrk_safe_query('obj_get_credit_limit_pur_2',"dsn",0,$("#basket_main_div #consumer_id").val());
		  
			  var get_comp_cat = wrk_safe_query('obj_get_comp_cat_2',"dsn",0,$("#basket_main_div #consumer_id").val());
			  if(window.frames[add_prod_no].document.add_speed_prod.dsp_only_member_price_cat_purchase.value == 1){
				  if(get_credit_limit.recordcount != 0 && get_credit_limit.PRICE_CAT_PURCHASE != '' )
					  var str_price_cat_ = str_price_cat_+' (PRICE_CAT_STATUS = 1 AND IS_PURCHASE = 1 AND PRICE_CATID = ' + get_credit_limit.PRICE_CAT_PURCHASE + ')';
				  else
					  var str_price_cat_ = str_price_cat_+' 1=2 ';
				  str_price_cat_ = str_price_cat_	+' ORDER BY PRICE_CAT';
			  }
			  else{
				  if(get_credit_limit.recordcount != 0 && get_credit_limit.PRICE_CAT_PURCHASE != '' )
					  var str_price_cat_ = str_price_cat_+'  (PRICE_CAT_STATUS = 1 AND IS_PURCHASE = 1 AND PRICE_CATID = ' + get_credit_limit.PRICE_CAT_PURCHASE + ') OR ';
					  
				  str_price_cat_ = str_price_cat_+'(PRICE_CAT_STATUS = 1 ';
			  
				  if(get_comp_cat.recordcount != 0 && get_comp_cat.CONSUMER_CAT_ID != '' )
					  str_price_cat_ = str_price_cat_+' AND CONSUMER_CAT LIKE \'%,' +get_comp_cat.CONSUMER_CAT_ID +',%\'';
				  if(window.frames[add_prod_no].document.add_speed_prod.basket_product_list_type.value != 13)
					  if(is_store_module != undefined && is_store_module==1 && selected_process_type != undefined)
						  str_price_cat_ = str_price_cat_+'AND BRANCH LIKE \'%,<cfoutput>#LISTGETAT(SESSION.EP.USER_LOCATION,2,"-")#</cfoutput>,%\'';		
				  else 
				  {
					  if(temp_card_paymethod != undefined && temp_card_paymethod != '') 
						  str_price_cat_ = str_price_cat_+'AND PAYMETHOD = 4';
					  else if(temp_paymethod_vehicle != undefined && temp_paymethod_vehicle != '') 
						  str_price_cat_ = str_price_cat_+'AND PAYMETHOD ='+temp_paymethod_vehicle;
				  }
					  
				  str_price_cat_ = str_price_cat_	+') ORDER BY PRICE_CAT';
			  
			  }
			  
			  var get_price_cat = wrk_query(str_price_cat_,"dsn3");
			  if(get_credit_limit.recordcount != 0 && get_credit_limit.PRICE_CAT_PURCHASE != 0)
				  var selected_price_catid = get_credit_limit.PRICE_CAT_PURCHASE;
			  else if(get_price_cat.recordcount != 0)
				  var selected_price_catid=get_price_cat.PRICE_CATID;
			  else 
				  var selected_price_catid='-1';
  
		  }	
		  else{
			  var str_price_cat_ ='SELECT PRICE_CATID,PRICE_CAT FROM PRICE_CAT WHERE PRICE_CAT_STATUS = 1 AND IS_PURCHASE = 1';
				  var get_price_cat = wrk_query(str_price_cat_,"dsn3");
				  
			  if(get_price_cat.recordcount != 0)
				  var selected_price_catid=get_price_cat.PRICE_CATID;
			  else 
				  var selected_price_catid='-1';
			  
		  }
	  }
	  var price_cat_len = window.frames[add_prod_no].document.add_speed_prod.price_catid_for_speed_.options.length;
	  if(price_cat_len!='') //fiyat listesi selectboxının içerigi silinip yeniden oluşturuluyor
	  { 
		for (var i = price_cat_len- 1; i>0; i--)
			window.frames[add_prod_no].document.add_speed_prod.price_catid_for_speed_.options.remove(i);
	  }
	  if(is_sale_product == 1){
		  if(window.frames[add_prod_no].document.add_speed_prod.dsp_only_member_price_cat_sales.value != 1 && list_find('2',window.frames[add_prod_no].document.add_speed_prod.basket_product_list_type.value)==0)
			  window.frames[add_prod_no].document.add_speed_prod.price_catid_for_speed_.options[0]=new Option("<cf_get_lang dictionary_id='58721.Standart Satış'>",-2);
		  else
			  window.frames[add_prod_no].document.add_speed_prod.price_catid_for_speed_.options[0]=new Option("<cf_get_lang dictionary_id='57734.Seçiniz'>",'');
	  }
	  else{
		  if(window.frames[add_prod_no].document.add_speed_prod.dsp_only_member_price_cat_purchase.value != 1 && list_find('2',window.frames[add_prod_no].document.add_speed_prod.basket_product_list_type.value)==0)
			  window.frames[add_prod_no].document.add_speed_prod.price_catid_for_speed_.options[0]=new Option("<cf_get_lang dictionary_id='58722.Standart Alış'>",-1);
		  else
			  window.frames[add_prod_no].document.add_speed_prod.price_catid_for_speed_.options[0]=new Option("<cf_get_lang dictionary_id='57734.Seçiniz'>",'');
	  }
	  if(get_price_cat != undefined && get_price_cat.recordcount!=0)
	  {
		  for(var jj=0;jj<get_price_cat.recordcount;jj++)
			  window.frames[add_prod_no].document.add_speed_prod.price_catid_for_speed_.options[jj+1]=new Option(get_price_cat.PRICE_CAT[jj],get_price_cat.PRICE_CATID[jj],false,(get_price_cat.PRICE_CATID[jj]==selected_price_catid)? true : false); //new Option(text, value, defaultSelected, selected)
	  }
  }
  
  </cfif>
  
  function apply_discount(col_no) // Basket thead'inde yer alan indirim katsayılarını satırlara yansıtır.
  {
	  window.basket.hidden_values.control_field_value = -1;
	  timeDelay('timeInput');
	  if(filterNum($("#basket_main_div #set_row_disc_ount"+col_no).val()) > 100)
		  $("#basket_main_div #set_row_disc_ount"+col_no).val(commaSplit(0,2));
	  else
	  {
		  $("#basket_main_div #set_row_disc_ount"+col_no).val(commaSplit($("#basket_main_div #set_row_disc_ount"+col_no).val(),2));
		  for(rowNum=0;rowNum<window.basket.items.length;rowNum++)
		  {
			  fillArrayField("indirim"+col_no,filterNum($("#basket_main_div #set_row_disc_ount"+col_no).val()),filterNum($("#basket_main_div #set_row_disc_ount"+col_no).val()),rowNum,1);
			  if(window.basket.hidden_values.basket_id == 51) // Taksitli satış basketinde
				  control_prod_discount(rowNum);
			  hesapla('indirim'+col_no,rowNum); //Hesapla fonksiyonu yazıldığında açılacak.
		  }
	  }
	  timeDelay('timeInput');
  }
  
  function reset_basket_kdv_rates()  //ithalat ve ihracat faturalarından cagılıyor ve kdv oranları sıfırlanıyor
  {
	  reset_kdv =0;
	  if(window.basket.items.length)
	  {
		  for(i=0;i<window.basket.items.length;i++)
		  {
			  if(window.basket.items[i].TAX_PERCENT != 0)
				  reset_kdv=1; //sıfırlanacak kdv var mı kontrol ediliyor
		  }
  
		  if(reset_kdv == 1)
		  {
			  if(confirm('<cf_get_lang dictionary_id="60056.Ürünlerin KDV Oranları Sıfırlanacaktır!">'))
			  {
				  for(var rowNum=0;rowNum<window.basket.items.length;rowNum++)
				  {
					  if(window.basket.items[rowNum].TAX_PERCENT != 0)
					  {
						  window.basket.hidden_values.control_field_value = window.basket.items[rowNum].TAX_PERCENT;
						  window.basket.items[rowNum].TAX_PERCENT = 0;
						  $("#tblBasket tr[basketItem]").eq(rowNum).find("#Tax").val(0);
						  if(rowNum == window.basket.items.length - 1) // Son Satırda toplam hesapla tetikleme kontrolü
							  last_row_control = 0;
						  else
							  last_row_control = 1;
						  hesapla('Tax',rowNum,last_row_control);
						  toplam_hesapla(1);
					  }
				  }
			  }
		  }
		  return true;
	  }
	  else 
		  return true;
  }
  
  function reset_basket_otv_rates()  //ithalat ve ihracat faturalarından cagılıyor ve OTV oranları sıfırlanıyor
  {
	  reset_otv =0;
	  if(window.basket.items.length)
	  {
		  for(i=0;i<window.basket.items.length;i++)
		  {
			  if(window.basket.items[i].OTV_ORAN != 0)
				  reset_otv=1; //sıfırlanacak OTV var mı kontrol ediliyor
		  }
  
		  if(reset_otv == 1)
		  {
			  if(confirm("<cf_get_lang dictionary_id='61776.Ürünlerin OTV Oranları Sıfırlanacaktır!'>"))
			  {
				  for(var rowNum=0;rowNum<window.basket.items.length;rowNum++)
				  {
					  if(window.basket.items[rowNum].OTV_ORAN != 0)
					  {
						  window.basket.hidden_values.control_field_value = window.basket.items[rowNum].OTV_ORAN;
						  window.basket.items[rowNum].OTV_ORAN = 0;
						  $("#tblBasket tr[basketItem]").eq(rowNum).find("#OTV").val(0);
						  if(rowNum == window.basket.items.length - 1) // Son Satırda toplam hesapla tetikleme kontrolü
							  last_row_control = 0;
						  else
							  last_row_control = 1;
						  hesapla('OTV',rowNum,last_row_control);
						  toplam_hesapla(1);
					  }
				  }
			  }
		  }
		  return true;
	  }
	  else 
		  return true;
  }
  function add_commission_row(commission_price,is_upd,upd_row_no)
  {
	  if(!$("#basket_main_div #card_paymethod_id").length != 0)
		  return false;
  
	  if($("#basket_main_div #commethod_id").length != 0 && Number($("#basket_main_div #commethod_id").val()) == 6) //ww den gelen siparisler icin
		  var new_sql = 'obj_get_card_comms';
	  else //pp ve ep den gelen siparisler icin
		  var new_sql = 'obj_get_card_comms_2';
	  var get_card_comms = wrk_safe_query(new_sql,'dsn3',0,Number($("#basket_main_div #commethod_id").val()));
  
	  if(get_card_comms.recordcount)
	  {
		  var product_id = get_card_comms.PRODUCT_ID;
		  var stock_id = get_card_comms.STOCK_ID;
		  var stock_code  = get_card_comms.STOCK_CODE;
		  var special_code  = get_card_comms.STOCK_CODE_2;
		  var barcod  = get_card_comms.BARCOD;
		  var manufact_code  = get_card_comms.MANUFACT_CODE;
		  var product_name  = get_card_comms.PRODUCT_NAME+get_card_comms.PROPERTY;
		  var unit_id_  = get_card_comms.PRODUCT_UNIT_ID;
		  var unit_  = get_card_comms.ADD_UNIT;
		  var spect_id  = '';
		  var spect_name  = '';
		  var row_promotion_id = '';
		  var promosyon_yuzde = '';
		  var promosyon_maliyet = '';
		  var is_promotion = '0';
		  var prom_stock_id = '';<!--- genel ise bos satirdan ise dolu --->
		  var iskonto_tutar=0;
		  var tax  = get_card_comms.TAX;
		  commission_price = wrk_round((commission_price * 100) / (100 + parseFloat(tax)),price_round_number);
		  var price  = commission_price;
		  for(var mon_i=0;mon_i<moneyArray.length;mon_i++)
			  if(moneyArray[mon_i]==money)
				  price  = commission_price*rate2Array[mon_i]/rate1Array[mon_i];
		  var price_other  = commission_price;
		  var is_inventory = get_card_comms.IS_INVENTORY;
		  var is_production = get_card_comms.IS_PRODUCTION;
		  var net_maliyet = '';
		  var marj = '';
		  var extra_cost=0;
		  var money  = money;
		  
		  var amount_ = 1;
		  var get_prod_acc = wrk_safe_query("obj_get_prod_acc_3",'dsn3',0,get_card_comms.PRODUCT_ID);
		  if(get_prod_acc.recordcount)
			  var product_account_code = get_prod_acc.ACCOUNT_CODE;
		  else
			  var product_account_code = '';
		  var row_unique_relation_id = '';
		  
		  var toplam_hesap=0;
		  var is_commission=1;
		  
		  if(is_upd!=undefined && is_upd==1 && upd_row_no != undefined)
		  {
			  if(window.basket.items[upd_row_no].ORDER_CURRENCY.length)
			  {
				  var order_currency_ = window.basket.items[upd_row_no].ORDER_CURRENCY;
				  var reserve_type_ = window.basket.items[upd_row_no].RESERVE_TYPE;
				  var row_ship_id  = window.basket.items[upd_row_no].ROW_SHIP_ID;
				  var duedate = window.basket.items[upd_row_no].DUEDATE;
				  upd_row(product_id, stock_id, stock_code, barcod, manufact_code, product_name, unit_id_, unit_, spect_id, spect_name, price, price_other, tax, duedate, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '', '', '', '', money, row_ship_id, amount_, product_account_code, is_inventory,is_production,net_maliyet,marj,extra_cost,row_promotion_id,promosyon_yuzde,promosyon_maliyet,iskonto_tutar,is_promotion,prom_stock_id,0,upd_row_no,is_commission,'',row_unique_relation_id,'','','',0,'','','','',order_currency_,0);
			  }
		  }
		  else
		  {
			  var row_ship_id  = 0;
			  var duedate = 0;
			  add_basket_row(product_id, stock_id, stock_code, barcod, manufact_code, product_name, unit_id_, unit_, spect_id, spect_name, price, price_other, tax, duedate, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '', '', '', '', money, row_ship_id, amount_, product_account_code,is_inventory,is_production,net_maliyet,marj,extra_cost,row_promotion_id,promosyon_yuzde,promosyon_maliyet,iskonto_tutar,is_promotion,prom_stock_id,0,'','','',0,'',row_unique_relation_id,'',toplam_hesap,is_commission,'','','','','',0,'','','','','',0,'','','','','','','','','',special_code);
		  }
	  }
  }
  
  function add_free_prom(stock_id,promotion_id,free_stock_price,money,free_stock_amount,is_general,free_prom_cost,upd_row_no,is_upd,prom_relation_id)
  {
  <cfif fusebox.circuit eq 'invoice' or listfind("1,2,4,10,14,18,20,21,33,42,43,51,52",attributes.basket_id,",")>
	  var get_stock_proms = wrk_safe_query("obj_get_stock_proms_2",'dsn3',0,stock_id);
	  if(get_stock_proms.recordcount)
	  {
		  var prom_date = js_date(date_add('d,',1,$("#basket_main_div #" + $("#basket_main_div #search_process_date").val()).val().toString()));
		  if(get_stock_proms.IS_COST)
		  {
			  var listParam = "<cfoutput>#dsn2_alias#</cfoutput>"+ "*" + prom_date + "*"+ stock_id;
			  var get_stock_cost = wrk_safe_query("obj_get_stock_cost",'dsn3',"1",listParam);
		  }
		  <cfif fusebox.circuit eq 'invoice' or listfind("1,2,33,42",attributes.basket_id,",")> //sadece fatura islemlerinde muhasebe kodu alınıyor
			  var get_prod_acc = wrk_safe_query("obj_get_prod_acc",'dsn3',0,get_stock_proms.PRODUCT_ID);
			  if(get_prod_acc.recordcount)
				  var product_account_code = get_prod_acc.ACCOUNT_CODE;
			  else
				  var product_account_code = '';
		  <cfelse>
			  var product_account_code = '';
		  </cfif>
		  var product_name = get_stock_proms.PRODUCT_NAME+get_stock_proms.PROPERTY;
		  var row_promotion_id = promotion_id;
		  var promosyon_maliyet = free_prom_cost;
		  var prom_stock_id = is_general ? '' : get_stock_proms.STOCK_ID;<!--- genel ise bos satirdan ise dolu --->
		  var iskonto_tutar = free_stock_price;
		  var price = free_stock_price;
		  for(var mon_i=0;mon_i<moneyArray.length;mon_i++)
			  if(moneyArray[mon_i]==money)
				  price = free_stock_price*rate2Array[mon_i]/rate1Array[mon_i];
		  var price_other = free_stock_price;
		  if(get_stock_proms.IS_COST == 1 && get_stock_cost.recordcount){
			  var net_maliyet = get_stock_cost.PURCHASE_NET_SYSTEM;
			  var extra_cost=get_stock_cost.PURCHASE_EXTRA_COST_SYSTEM;
			  }
		  else{
			  var net_maliyet = '';
			  var extra_cost=0;
			  }
		  var money = money;
		  var amount_ = free_stock_amount;
		  var row_unique_relation_id = '';
		  if(prom_relation_id != undefined)
			  var prom_relation = prom_relation_id;
		  else
			  var prom_relation = '';
		  var toplam_hesap = is_general ? 0 : 1;
		  if(is_upd == undefined || is_upd ==0)
			  add_basket_row(get_stock_proms.PRODUCT_ID, get_stock_proms.STOCK_ID, get_stock_proms.STOCK_CODE, get_stock_proms.BARCOD, get_stock_proms.MANUFACT_CODE, product_name, get_stock_proms.PRODUCT_UNIT_ID, get_stock_proms.ADD_UNIT, '', '', price, price_other, get_stock_proms.TAX, '', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '', '', '', '', money, 0, amount_, product_account_code,get_stock_proms.IS_INVENTORY,get_stock_proms.IS_PRODUCTION,net_maliyet,'',extra_cost,row_promotion_id,'',promosyon_maliyet,iskonto_tutar,1,prom_stock_id,0,'','','',0,'',row_unique_relation_id,'',toplam_hesap,0,'',prom_relation);
		  else
			  upd_row(get_stock_proms.PRODUCT_ID, get_stock_proms.STOCK_ID, get_stock_proms.STOCK_CODE, get_stock_proms.BARCOD, get_stock_proms.MANUFACT_CODE, product_name, get_stock_proms.PRODUCT_UNIT_ID, get_stock_proms.ADD_UNIT, '', '', price, price_other, get_stock_proms.TAX, '', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '', '', '', '', money, 0, amount_, product_account_code, get_stock_proms.IS_INVENTORY,get_stock_proms.IS_PRODUCTION,net_maliyet,'',extra_cost,row_promotion_id,'',promosyon_maliyet,iskonto_tutar,1,prom_stock_id,0,upd_row_no,0,'',row_unique_relation_id,'','','',0,'','',prom_relation);
	  }
  </cfif>
  }
  
  function kdvli_net_indirim_hesapla()
  {
	  if($("#basket_main_div #genel_indirim_kdvli_hesap_").length != 0 && $("#basket_main_div #genel_indirim_kdvli_hesap_").val().length != 0)
	  {
		  genel_t_ = filterNum($("#basket_main_div #net_total_default").html());
		  yazilan_ = filterNum($("#basket_main_div #genel_indirim_kdvli_hesap_").val());
		  total_ = 0;
		  toplam_hesapla(1);
		  if(taxArray.length != 0)
		  {
			  var taxArrayLen= taxArray.length;
			  for (var m=0; m < taxArrayLen; m++)
			  {
				  if(taxTotalArray[m] != '' && taxArray[m] > 0)
				  {
					  oran_deger_ = ((taxTotalArray[m] * 100) / taxArray[m]) + taxTotalArray[m];
					  oran_son_ = ((oran_deger_ * 100 / genel_t_) * yazilan_ / 100) / (1 + taxArray[m] / 100);
					  total_ += oran_son_;
				  }
			  }
		  }
		  window.basket.hidden_values.genel_indirim_ = parseFloat(total_);
		  window.basket.footer.genel_indirim_ = window.basket.hidden_values.genel_indirim_;
		  $("#basket_main_div #genel_indirim_").val(commaSplit(total_,basket_total_round_number));
		  $("#basket_main_div #genel_indirim").val(filterNumBasket(commaSplit(total_,basket_total_round_number),basket_total_round_number));
		  toplam_hesapla(1);
	  }
  }
  
  
  function kdvsiz_doviz_indirim_hesapla()
  {
	  if($("#basket_main_div #genel_indirim_doviz_net_hesap").length != 0 && $("#basket_main_div #genel_indirim_doviz_net_hesap").val().length != 0)
	  {
		  yazilan_ = filterNum($("#basket_main_div #genel_indirim_doviz_net_hesap").val(),basket_total_round_number);
		  total_ = 0;
		  toplam_hesapla(1);
		  total_ = yazilan_ * rate2;
		  window.basket.hidden_values.genel_indirim_ = parseFloat(total_);
		  window.basket.footer.genel_indirim_ = window.basket.hidden_values.genel_indirim_;
		  $("#basket_main_div #genel_indirim_").val(commaSplit(total_,basket_total_round_number));
		  $("#basket_main_div #genel_indirim").val(filterNum(commaSplit(total_,basket_total_round_number),basket_total_round_number));
		  toplam_hesapla(1);
	  }
	  return false;
  }
  
  
  function kdvli_doviz_indirim_hesapla()
  {
	  if($("#basket_main_div #genel_indirim_doviz_net_hesap").length != 0 && $("#basket_main_div #genel_indirim_doviz_brut_hesap").val().length != 0)
	  {
		  yazilan_ = filterNum($("#basket_main_div #genel_indirim_doviz_brut_hesap").val(),basket_total_round_number);
		  total_ = 0;
		  toplam_hesapla(1);
		  total_ = yazilan_ * rate2;
		  $("#basket_main_div #genel_indirim_kdvli_hesap_").val(commaSplit(total_,basket_total_round_number));
		  kdvli_net_indirim_hesapla();
		  toplam_hesapla(1);
	  }
  }
  
  
  function yuvarlama_doviz_hesapla()
  {
	  if($("#basket_main_div #yuvarlama_doviz").length != 0 && $("#basket_main_div #yuvarlama_doviz").val().length != 0)
	  {
		  yazilan_ = filterNumBasket($("#basket_main_div #yuvarlama_doviz").val(),basket_total_round_number);
		  total_ = 0;
		  toplam_hesapla(1);
		  total_ = yazilan_ / rate2;
		  $("#basket_main_div #yuvarlama").val(commaSplit(total_,basket_total_round_number));
		  toplam_hesapla(1);
	  }
  }
  
  
  // Hesapla fonksiyonunda satırda yer alan değerleri bir array'e atıp array elemanları üzerinden işlem yapıyordu. Bizim zaten window.basket diye bir array imiz olduğu için buna gerek kalmadı.
  function ayir(row_)
  {}
  function ayir_ters(row_)
  {}
  function load_all_row_values()
  {}
  function change_row_values()
  {}
  // Hesapla fonksiyonunda satırda yer alan değerleri bir array'e atıp array elemanları üzerinden işlem yapıyordu. Bizim zaten window.basket diye bir array imiz olduğu için buna gerek kalmadı.
  
  
  //Silinecek.
  function change_bg_color_basket_row(){}
  //Silinecek.
  
  function copy_basket_row(from_row_no,copy_full,copy_type,cpy_shelf_no_,cpy_deliver_date_,cpy_amount_,cpy_to_shelf_no_,shelf_control)
  {
	  if(!window.basket.items[from_row_no].PRODUCT_ID)
	  {
		  alert("<cf_get_lang dictionary_id='58846.Silinmiş Satır Kopyalanamaz'>!");
		  return false;	
	  }
	  else
	  {
		  var cloned = {};
		  for (var prop in window.basket.items[from_row_no]) // Array'in ilgili elemanları döndürülüyor
			  cloned[prop] = window.basket.items[from_row_no][prop];
  
		  //Üst tarafta kopyalanan satır olduğu gibi kopyalandı. Alt tarafta ise bazı menuel değişecek alanları değiştiriyoruz.
		  my_unique_id = js_create_unique_id();
		  cloned.WRK_ROW_ID = 'WRK'+my_unique_id;
		  cloned.WRK_ROW_RELATION_ID = '';
		  cloned.ROW_PAYMETHOD_ID = '';
		  cloned.SPECT_ID = '';
		  cloned.SPECT_NAME = '';
		  cloned.ACTION_ROW_ID = '';
  
		  cloned.OTHER_MONEY_OPTIONS = '';
		  other_money_options = '';
		  <cfoutput>
			  <cfloop query="get_money_bskt">
				  if('#money_type#' == cloned.OTHER_MONEY)
					  other_money_options = other_money_options + '<option value="#money_type#" selected="selected">#money_type#</option>'
				  else
					  other_money_options = other_money_options + '<option value="#money_type#">#money_type#</option>'
			  </cfloop>
		  </cfoutput>	
		  cloned.OTHER_MONEY_OPTIONS = other_money_options;
  
		  if(cpy_amount_ != undefined)
			  cloned.AMOUNT = cpy_amount_;
		  if(cpy_shelf_no_ != undefined && cpy_shelf_no_ != '')
		  {
			  var shelf_name_sql='SELECT SHELF_CODE FROM PRODUCT_PLACE WHERE PLACE_STATUS=1 AND PRODUCT_PLACE_ID= '+ cpy_shelf_no_;
			  var get_shelf_name =wrk_query(shelf_name_sql,'dsn3');
			  if(get_shelf_name.recordcount && get_shelf_name.SHELF_CODE != '')
				  cloned.SHELF_NUMBER_TXT = get_shelf_name.SHELF_CODE;
			  cloned.SHELF_NUMBER = cpy_shelf_no_;
		  }
		  if(cpy_to_shelf_no_ != undefined && cpy_to_shelf_no_ != '')
		  {
			  var shelf_name_sql='SELECT SHELF_CODE FROM PRODUCT_PLACE WHERE PLACE_STATUS=1 AND PRODUCT_PLACE_ID= '+ cpy_to_shelf_no_;
			  var get_shelf_name =wrk_query(shelf_name_sql,'dsn3');
			  if(get_shelf_name.recordcount && get_shelf_name.SHELF_CODE != '')
				  cloned.TO_SHELF_NUMBER_TXT = get_shelf_name.SHELF_CODE;
			  cloned.TO_SHELF_NUMBER = cpy_to_shelf_no_;
		  }
		  else if(window.basket.items[from_row_no].TO_SHELF_NUMBER_TXT && window.basket.items[from_row_no].TO_SHELF_NUMBER)
		  {
			  var shelf_name_sql='SELECT SHELF_CODE FROM PRODUCT_PLACE WHERE PLACE_STATUS=1 AND PRODUCT_PLACE_ID= '+ window.basket.items[from_row_no].TO_SHELF_NUMBER;
			  var get_shelf_name = wrk_query(shelf_name_sql,'dsn3');
			  if(get_shelf_name.recordcount && get_shelf_name.SHELF_CODE != '')
				  cloned.TO_SHELF_NUMBER_TXT = get_shelf_name.SHELF_CODE;
			  cloned.TO_SHELF_NUMBER = window.basket.items[from_row_no].TO_SHELF_NUMBER;
		  }
		  if(cpy_deliver_date_ != undefined && cpy_deliver_date_ != '')
			  cloned.DELIVER_DATE = cpy_deliver_date_;
		  
		  window.basket.items.push(cloned);
		  window.basket.hidden_values.rows_ = window.basket.items.length;
		  toplam_hesapla(0); <!--- Bu satır toplam_hesapla bitirilince açılacak --->
		  
	  //	window.basket.items.splice(from_row_no+1,0,cloned); Araya ekleme için
		  //window.basket.scrollIndex = Math.floor(window.basket.items.length / window.basket.pageSize);
		  showBasketItems();
	  }
  }
  
  function clear_related_rows(karma_prod_row)
  { /*silinecek satırın row_unique_relation_id alanı dolu ise, hem bu satır hem de iliskili oldugu diger satırlar silinir. bos ise sadece secilen satır silinir*/
	  if(window.basket.items.length > 1)
	  {
		  var uniq_rel_id = window.basket.items[karma_prod_row].ROW_UNIQUE_RELATION_ID;
		  if(window.basket.items[karma_prod_row].ROW_PROMOTION_ID.length && window.basket.items[karma_prod_row].IS_PROMOTION == 0) //silinecek satırın promosyon bilgisi alınıyor
			  var free_prom_relation_id = window.basket.items[karma_prod_row].PROM_RELATION_ID; //baskete aynı promosyondan birden fazla dusuruldugunde satırlar arasındaki uniqe iliskiyi prom_relation_id tutar. 
		  if(uniq_rel_id != '' || (free_prom_relation_id != undefined && free_prom_relation_id != '')) 
		  {
			clear_row(karma_prod_row);
			  //for (var remove_i = 0; remove_i < window.basket.items.length; remove_i++)
//			  //1- silinecek satırla uniq_id baglantılı satırsa siliniyor 2-silinecek satırın promosyon ürün satırıysa siliniyor
//			  {
//				  if((uniq_rel_id != '' && window.basket.items[remove_i].ROW_UNIQUE_RELATION_ID == uniq_rel_id) || (free_prom_relation_id != undefined && free_prom_relation_id!='' && window.basket.items[remove_i].PROM_RELATION_ID == free_prom_relation_id)/* && form_basket.is_promotion[remove_i].value == 1*/)
//					  clear_row(remove_i+1);
//			  }
		  }
		  else
		  {
			  clear_row(karma_prod_row);
		  }
	  }
	  else
		  clear_row(karma_prod_row);
		if(karma_prod_row == window.basket.items)
			$("table#tblBasket").closest('div').animate({scrollTop: $("tr[itemindex='"+(parseFloat(karma_prod_row)-1)+"'").position().top}, 800, 'swing');
		else
			$("table#tblBasket").closest('div').animate({scrollTop: $("tr[itemindex='"+karma_prod_row+"'").position().top}, 800, 'swing');
	  return true;
  }
  
  function clear_row(rowNum)
  {
	  window.basket.items.splice(rowNum,1);
  
	  if(listfind(display_list,'deliver_dept_assortment') != -1)
	  {
		  if (departmentArray[rowNum] != undefined)
		  {
			  var deptArraylen =departmentArray[rowNum].length;
			  for(var counter2 = 1 ; counter2 <= deptArraylen ; counter2++ )
				  if (departmentArray[rowNum] != undefined){
					  try { departmentArray[rowNum][counter2][0] = 0; }
					  catch(e){}
					  }
		  }
	  }
  
	  window.basket.hidden_values.rows_ = window.basket.items.length;
	  toplam_hesapla(0);
	  showBasketItems();	
	  return true;
  }
  
  function del_row(x)
  {
	  table_list.deleteRow(x);
	  rowCount--;
	  return true;
  }
  function del_rows()
  {
	  for (;rowCount>1;) del_row(rowCount); /*20051222 tek satir kalana kadara silmeli*/
	  window.basket.hidden_values.rows_ = rowCount;
	  toplam_hesapla(1);
	  return true;
  }
  
  <cfif ListFindNoCase(display_list, "darali") && ListFindNoCase(display_list, "dara")>
	  function dara_miktar_hesabi(int_row_id,int_nereden_geldi)
	  {
		  
		  var satir = int_row_id;
		  var flt_dara = getFieldValue('DARA', satir,1);
		  var flt_amount = getFieldValue('AMOUNT', satir,1);
		  var flt_darali = getFieldValue('DARALI', satir,1);
		  if(flt_dara=="") 
			  flt_dara=0;
		  else 
			  flt_dara=parseFloat(flt_dara);		
		  if(flt_darali=="") 
			  flt_darali=1; 
		  else 
			  flt_darali=parseFloat(flt_darali);		
		  if((flt_darali-flt_dara) <= 0)
		  {
			  alert('Darali ve Dara Miktarları Aynı veya Farkları Sıfırdan Küçük Olamaz!');
			  if(int_nereden_geldi == 1)
				  setFieldValue('darali', satir, 1, 3);
			  else if(int_nereden_geldi ==2)
				  setFieldValue('dara', satir, 0, 3);
		  }
		  else
		  {
			  if(int_nereden_geldi == 3){
				  if (flt_amount=="") flt_amount=1;else flt_amount=parseFloat(flt_amount);		
				  setFieldValue('darali', satir, flt_amount+flt_dara, 3);
			  }else{
				  if(flt_darali=="") flt_darali=1;else flt_darali=parseFloat(flt_darali);
					  setFieldValue('amount', satir, flt_darali-flt_dara, 3);
			  }
			  setFieldValue('dara', satir, flt_dara, 3);
			  hesapla('amount',int_row_id);
		  }
	  }
  </cfif>
  
  bool_marj_called=0;
  function marj_maliyet_hesabi(int_row_id,int_nereden_geldi,field_name)
  {
	  var satir = int_row_id;
	  var flt_maliyet = window.basket.items[satir].NET_MALIYET;
	  if(flt_maliyet == "")
		  flt_maliyet = 0;
	  var flt_pr = window.basket.items[satir].PRICE;
	  if(flt_pr == "")
		  flt_pr = 0;
	  if(int_nereden_geldi != 5)
	  {
		  var flt_marj = window.basket.items[satir].MARJ;
		  if(flt_marj == "")
			  flt_marj = 0;
		  if(window.basket.items[satir].EXTRA_COST == undefined)
			  window.basket.items[satir].EXTRA_COST = 0;
		  var flt_ek_maliyet = window.basket.items[satir].EXTRA_COST;
		  if(flt_ek_maliyet == "")
			  flt_ek_maliyet = 0;
		  if(field_name=='list_price_discount')
		  {
			  var flt_list_pr = window.basket.items[satir].LIST_PRICE;
			  if(flt_list_pr == "")
				  flt_list_pr = 0;
			  var flt_list_price_disc = window.basket.items[satir].LIST_PRICE_DISCOUNT;
			  if(flt_list_price_disc == "")
				  flt_list_price_disc = 0;
  
			  flt_maliyet = (flt_list_pr * (100 - flt_list_price_disc))/100;
			  fillArrayField('net_maliyet',flt_maliyet,commaSplit(flt_maliyet,price_round_number),satir,1);
  
			  if(listfind(display_list,'extra_cost_rate') != -1)
			  {
				  if(flt_maliyet != 0)
					  flt_extra_cost_rate=((flt_ek_maliyet * 100)/flt_maliyet);
				  else
					  flt_extra_cost_rate = 0;
				  fillArrayField('extra_cost_rate',flt_extra_cost_rate,commaSplit(flt_extra_cost_rate),satir,1);
			  }
		  }
		  else if(field_name=='net_maliyet' || field_name == 'extra_cost') //maliyet veya ek_maliyet degistiginde ek_maliyet_oranı yeniden hesaplanıyor
		  {
			  if(listfind(display_list,'extra_cost_rate') != -1)
			  {
				  if(flt_maliyet !=0)
				  {
					  flt_extra_cost_rate=((flt_ek_maliyet * 100)/flt_maliyet);
					  fillArrayField('extra_cost_rate',flt_extra_cost_rate,commaSplit(flt_extra_cost_rate),satir,1);
				  }
			  }
		  }
		  else if(field_name=='extra_cost_rate') //oran degistirildiginde maliyet uzerinden ek_maliyet hesaplanıyor
		  {
			  var flt_extra_cost_rate = window.basket.items[satir].EXTRA_COST_RATE;
			  if(flt_extra_cost_rate == "")
				  flt_extra_cost_rate=0;
			  flt_ek_maliyet = ((flt_maliyet * flt_extra_cost_rate)/100);
			  fillArrayField('extra_cost',flt_ek_maliyet,commaSplit(flt_ek_maliyet,price_round_number),satir,1);
		  }
		  if(flt_ek_maliyet!="")
			  flt_maliyet = flt_maliyet + flt_ek_maliyet;
		  if(listfind(display_list,'row_cost_total') != -1) //satır toplam maliyet set ediliyor
			  fillArrayField('row_cost_total',flt_maliyet,commaSplit(parseFloat(flt_maliyet),price_round_number),satir,1);
		  switch(int_nereden_geldi){
			  case 1:{
				  if(listfind(display_list,'net_maliyet') != -1 && listfind(display_list,'marj') != -1)
				  {
					  int_flag_marj=0;
					  if(flt_marj != 0)
					  {
						  fillArrayField('price',flt_maliyet*(100+flt_marj)/100,commaSplit(flt_maliyet*(100+flt_marj)/100,price_round_number),satir,1);
						  int_flag_marj = 1;
						  if(int_flag_marj)
							  hesapla('price',satir);	
					  }else if(flt_marj == 0 && flt_maliyet != 0)
					  {
						  fillArrayField('marj',((flt_pr-flt_maliyet)/flt_maliyet)*100,commaSplit(((flt_pr-flt_maliyet)/flt_maliyet)*100),satir,1);
						  int_flag_marj = 1;
					  }
				  }
				  break;
			  }
			  case 2:{
				  if(flt_maliyet != 0)
				  {
					  fillArrayField('price',flt_maliyet*((100+flt_marj)/100),commaSplit(flt_maliyet*((100+flt_marj)/100),price_round_number),satir,1);
					  hesapla('price',satir);
				  }else
				  {
					  fillArrayField('net_maliyet',flt_pr,commaSplit(flt_pr,price_round_number),satir,1);
					  if(listfind(display_list,'extra_cost_rate') != -1)
					  {
						  if(flt_pr!=0)
							  flt_extra_cost_rate = ((flt_ek_maliyet * 100)/flt_pr);
						  else
							  flt_extra_cost_rate=0;
						  fillArrayField('extra_cost_rate',flt_extra_cost_rate,commaSplit(flt_extra_cost_rate,price_round_number),satir,1);
					  }
					  if(listfind(display_list,'row_cost_total') != -1) //satır toplam maliyet set ediliyor
					  {
						  flt_maliyet = flt_pr + flt_ek_maliyet;
						  fillArrayField('row_cost_total',flt_maliyet,commaSplit(flt_maliyet,price_round_number),satir,1);
					  }
				  }
				  break;
			  }
			  case 4:{
				  if(flt_pr!=0 && flt_maliyet != 0)
					  fillArrayField('marj',(flt_pr-flt_maliyet)/flt_maliyet*100,commaSplit((flt_pr-flt_maliyet)/flt_maliyet*100),satir,1);
				  else
					  fillArrayField('marj',0,commaSplit(0),satir,1);
				  hesapla('Price',satir);
				  break;
			  }
		  }
	  }
	  else
	  {
		  hesapla('price_other',satir);
		  var flt_pr = window.basket.items[satir].PRICE;
		  if(flt_pr == "")
			  flt_pr = 0;
		  if(flt_pr!=0 && flt_maliyet != 0)
			  fillArrayField('marj',(flt_pr-flt_maliyet)/flt_maliyet*100,commaSplit((flt_pr-flt_maliyet)/flt_maliyet*100),satir,1);
		  else
			  fillArrayField('marj',0,commaSplit(0),satir,1);
	  }
  }
  
  function ek_tutar_hesapla(bsk_row_id,field_name)
  {
	  var satir = bsk_row_id;
	  var flt_amount = getFieldValue('AMOUNT_OTHER', satir,1);
	  if(flt_amount=='')
		  flt_amount=1;
	  var flt_ek_tutar_price = getFieldValue('EK_TUTAR_PRICE', satir,1);
	  if(flt_ek_tutar_price=="")
		  flt_ek_tutar_price = 0;
	  else
		  flt_ek_tutar_price = parseFloat(flt_ek_tutar_price);
	  var flt_ek_tutar_cost = flt_amount*flt_ek_tutar_price;
  
	  if(field_name=='amount_other' || field_name=='ek_tutar_price') //maliyet veya ek_maliyet degistiginde ek_maliyet_oranı yeniden hesaplanıyor
	  {
		  if(listfind(display_list,'ek_tutar_cost') != -1)
			  setFieldValue('ek_tutar_cost', satir, flt_ek_tutar_cost, 3);
		  var flt_ek_tutar_marj = getFieldValue('EK_TUTAR_MARJ', satir,1);
		  if(flt_ek_tutar_marj=="")
			  flt_ek_tutar_marj=0;
		  var flt_ek_tutar = (flt_ek_tutar_cost*(100+flt_ek_tutar_marj))/100
		  setFieldValue('ek_tutar', satir, flt_ek_tutar, 3);
		  hesapla('ek_tutar',bsk_row_id);
	  }
	  else if(field_name=='ek_tutar_marj') //oran degistirildiginde maliyet uzerinden ek_maliyet hesaplanıyor
	  {
		  var flt_ek_tutar_marj = getFieldValue('EK_TUTAR_MARJ', satir,1);
		  if(flt_ek_tutar_marj == "")
			  flt_ek_tutar_marj=0;
		  var flt_ek_tutar = (flt_ek_tutar_cost*(100+flt_ek_tutar_marj))/100
		  setFieldValue('ek_tutar', satir, flt_ek_tutar, 3);
		  hesapla('ek_tutar',bsk_row_id);
	  }
	  else if(field_name=='ek_tutar') 
	  {//ek_tutar_other_total degistirildiginde de -once hesapla ile ek_tutarın yeni hali hesaplandıgından- bu bolum calıstırılır
		  var flt_ek_tutar = getFieldValue('EK_TUTAR', satir,1);
		  if(flt_ek_tutar=='')
			  flt_ek_tutar=0;
		  if(flt_ek_tutar_cost!='' && flt_ek_tutar_cost != 0)
			  var flt_ek_tutar_marj = ((flt_ek_tutar*100)/flt_ek_tutar_cost)-100;
		  else
			  var flt_ek_tutar_marj = 0;
		  if(listfind(display_list,'ek_tutar_marj') != -1)
			  setFieldValue('ek_tutar_marj', satir, flt_ek_tutar_marj, 3);
	  }
  }
  
  <!---
  function remove_empty_rows()
  {	
	  rowCount = window.basket.items.length;
	  
	  if (rowCount > 1)
	  {
		  for (var remove_i = (rowCount-1); remove_i >=0; remove_i--)
		  {
			  console.log('remove_i:'+remove_i);
			  if (rowCount > 1 && window.basket.items[remove_i].PRODUCT_ID.val().length == 0)/*20050511 rowCount > 1 ifadesi dogru*/
				  del_row(remove_i+1);
		  }
	  }
	  window.basket.hidden_values.rows_ = rowCount;	
	  
	  toplam_hesapla(1);<!--- 20060309 toplam_hesapla from_proms parametresini true almali ki (sanki get_basket_proms dan geliyor gibi) kullanicinin indirime elle yaptigi mudahale kaybolmasin --->
	  return true;
  }
  
  --->
  
  function check_product_accounts()
  {
	  //remove_empty_rows();
	  var prod_list ='';
	  if(isDefined('product_id'))
	  {
		  var bsk_rowCount = window.basket.hidden_values.rows_;
		  for(var prd_ii=0; prd_ii<bsk_rowCount; prd_ii++)
		  {
			  if(window.basket.items[prd_ii].PRODUCT_ID.length != 0 && list_find(prod_list,window.basket.items[prd_ii].PRODUCT_ID,',')==0)
			  {
				  if(!list_len(prod_list,','))
					  prod_list = window.basket.items[prd_ii].PRODUCT_ID.toString();
				  else
					  prod_list = prod_list+','+window.basket.items[prd_ii].PRODUCT_ID.toString();
			  }	
		  }
		  
	  }
	  if(process_cat_array[$("#basket_main_div #process_cat").selectedIndex] == 1 && process_cat_project_based_acc[$("#basket_main_div #process_cat").selectedIndex] == 0 && process_cat_dept_based_acc[$("#basket_main_div #process_cat").selectedIndex] == 0) //muhasebe islemi yapılıyor ve proje bazlı muhasebe secili degil ve depo bazlı muhasebe seçili değil
	  {
		  if(list_len(prod_list))
		  {
			  var new_prod_sql = 'obj_control_basket_prod_acc';
			  if(list_find("54,55",process_type_array[$("#basket_main_div #process_cat").selectedIndex]))
				  var new_prod_sql = 'obj_control_basket_prod_acc_2';
			  else if(process_type_array[$("#basket_main_div #process_cat").selectedIndex] == 58)
				  var new_prod_sql = 'obj_control_basket_prod_acc_3';
			  else if(process_type_array[$("#basket_main_div #process_cat").selectedIndex] == 63)
				  var new_prod_sql = 'obj_control_basket_prod_acc_4';
			  else if(process_type_array[$("#basket_main_div #process_cat").selectedIndex] == 62)
				  var new_prod_sql = 'obj_control_basket_prod_acc_5';
			  else if(process_type_array[$("#basket_main_div #process_cat").selectedIndex] == 531)
				  var new_prod_sql = 'obj_control_basket_prod_acc_6';
			  else if(process_type_array[$("#basket_main_div #process_cat").selectedIndex] == 591)
				  var new_prod_sql = 'obj_control_basket_prod_acc_7';
			  else if(sale_product!=undefined && sale_product==1)
				  var new_prod_sql = 'obj_control_basket_prod_acc_8';
			  else
				  var new_prod_sql = 'obj_control_basket_prod_acc_9';
			  
			  var control_basket_prod_acc = wrk_safe_query(new_prod_sql,'dsn3',0,prod_list);
			  if(control_basket_prod_acc.recordcount)
			  {
				  alert_str = "<cf_get_lang dictionary_id='58483.Muhasebe Kodu Tanımlanmamış Ürünler'>:\n";
				  //alert_str = 'Muhasebe Kodu Tanımlanmamış Ürünler:\n'
				  for(var cnt_i=0;cnt_i<control_basket_prod_acc.recordcount;cnt_i=cnt_i+1)
					  alert_str = alert_str +' '+control_basket_prod_acc.PRODUCT_NAME[cnt_i] + '\n';
				  alert(alert_str);
				  return false;
			  }
		  }
	  }
	  return true;
  }
  
  <cfif ListFindNoCase(display_list, "deliver_dept_assortment")>	
  function departman_urun_doldur(row_id,s1,new_temp_row)
  {
	  counter = 1;
	  departmentArray[row_id] = new Array(1);
	  for (var i=1 ; i <= s1 ; i++)
	  {
		  departmentArray[row_id][counter] = new Array(1);
		  departmentArray[row_id][counter][0] = filterNumBasket(new_temp_row[counter][0],3);
		  departmentArray[row_id][counter][1] = new_temp_row[counter][1];
		  departmentArray[row_id][counter][2] = new_temp_row[counter][2];
		  counter++;
	  }
	  /*return false;*/
  }
  function get_stock_id(row_index)
  {
	  if(row_index)
		  row_index = 0;
	  else
		  row_index = row_index;
	  return window.basket.items[row_index].STOCK_ID;
  }
  </cfif>
  
  function wrk_round(ValToRnd, no_of_decimal){
	  /*Aldigi degerler matematik deger olmalidir.
	  Bunun sonucunu ekranda gormek icin cogu zaman commaSplit e vermek yeterlidir*/
	  if(ValToRnd == 0)
		  return 0;
	  if(!Number(ValToRnd)){
		  
		  ValToRnd = ValToRnd.replace(/\./g,'').replace(',','.');
	  }
	  if(!no_of_decimal && no_of_decimal!=0)
		  no_of_decimal=2;
	  decimal_carpan = Math.pow(10,no_of_decimal);
	  if(ValToRnd!=0) return (Math.round(ValToRnd*decimal_carpan)/decimal_carpan);
	  else return 0;
  }
  
  
  // Sevgili hesapla fonksiyonu. Lütfen sorunsuz bir şekilde çalış. Adamı hasta etme. Saygılar sunar çalışmana hayran olduğumu belirtmek isterim.
  function hesapla(field_name,satir,toplam_hesap,satir_kdv_tutar)
  {
	  new_field_name = field_name.toUpperCase(); // Array'de tutulan alanlar uppercase olarak yazılıyor.
	  
	  data_row = window.basket.items[satir]; // Array içindeki elemanlar
	  gelen_deger_ = data_row[new_field_name];
	  /*
	  if(field_name == 'Amount')
		  round_number = amount_round;
	  else
		  round_number = price_round_number;
		  */
	  //window.basket.hidden_values.control_field_value = commaSplit(data_row[new_field_name],8); // Bu özelliği hesapla fonksiyonundan önce calistiriyoruz. Böylece array'in eski değerini kaybetmiyoruz.
	  
	  //Kur değiştir gibi ekranda görünmeyen fakat değiştirilmesi gereken alanlar olduğu için bu case eklendi
	  if($("#tblBasket tr[basketItem]").eq(satir).find("#"+field_name).val() == undefined)
		  change_row_control = 1;
	  else
		  change_row_control = 0;
  
	  if(change_row_control == 0)
	  {
		  try{
		  if(commaSplit($("#tblBasket tr[basketItem]").eq(satir).find("#"+field_name).val(),8).indexOf('NaN') != -1)
			  field_changed_value = $("#tblBasket tr[basketItem]").eq(satir).find("#"+field_name).val();
		  else
			  field_changed_value = commaSplit($("#tblBasket tr[basketItem]").eq(satir).find("#"+field_name).val(),8);
		  }
		  catch(e)
		  {
			  field_changed_value = 0;
		  }
	  }
	  
	  if(change_row_control = 0 && toplam_hesap!= 1 && window.basket.hidden_values.control_field_value != null && field_changed_value == window.basket.hidden_values.control_field_value) //alanın eski ve yeni degeri aynı oldugundan hesaplamaya gerek yok.
	  {
		  alert('Eski değerden farklı bir değer giriniz.');
		  return true;
	  }
	  else
	  {
		  
		  // Bu case'in yazılma sebebi : yapılan hesaplamalar daima array elemanları üzerinden gerçekleştirildiği için hesaplamayı etkileyen amount değerini değiştirmemiz gerekiyor.
  //		if(field_name == 'amount_other')
  //			fillArrayField('amount_other',Number($("#tblBasket tr[basketItem]").eq(satir).find("#amount_other").val()),commaSplit($("#tblBasket tr[basketItem]").eq(satir).find("#amount_other").val(),amount_round),satir,1);
		  if(field_name == 'Amount' || field_name == 'amount_other')//Eğer miktar veya miktar 2 ise miktar hesapla fonksiyonu çalışacak
			  hesapla_amount(field_name,satir);
		  if(toplam_hesap==undefined) 
			  toplam_hesap = 1;
		  <!--- 20041208 toplam_hesap : toplu indirim gibi yerlerde sadece bir kez toplam_hesapla calistirilsin diye 
			  toplam_hesap parametresi aliniyor default tanımsiz ve hesabi yapiyor,
			  gonderilirse hesaplamak icin 1 hesaplamamak icin 0 bekleniyor --->
		  var amount_ = 1; 
		  var price_ = 0;//altta mutlaka set edilecekler
		  var tax_ = 0; 
		  var row_total_ = 0;
		  var otv_oran_ = 0; 
		  var row_otvtotal_= 0; 
		  var ek_tutar=0;
		  var row_taxtotal_ = 0; 
		  var row_lasttotal_ = 0;
		  var iskonto_tutar = 0;
		  var promosyon_yuzde = 0;
		  var price_other_,row_nettotal_,price_net_,price_net_doviz_,row_total_,price_other_;
		  var other_money_tax_total,other_money_value_,other_money_gross_total_,ek_tutar_other_total_;
		  var d1,d2,d3,d4,d5,d6,d7,d8,d9,d10,indirim_carpan;
		  var rate1,rate2,other_money_index;
		  var row_bsmv_rate = row_bsmv_amount = row_bsmv_currency = row_oiv_rate = row_oiv_amount = row_tevkifat_rate = row_tevkifat_amount = 0;
  
		  if(!data_row.OTHER_MONEY.length)
		  {
			  rate1 = 1;
			  rate2 = 1;
		  }
		  
		  for(var mon_i=0;mon_i<moneyArray.length;mon_i++)
		  {
			  if(moneyArray[mon_i].toUpperCase() == data_row.OTHER_MONEY.toUpperCase())
			  {
				  rate1 = rate1Array[mon_i];
				  rate2 = rate2Array[mon_i];
			  }			
		  }
		  if(field_name.indexOf('indirim')==0) //indirim gelmisse filteNum dan gecirmeden d1,d2.. degerleri ile formatla
		  {
			  d1 = data_row.INDIRIM1;
			  if( (d1 > 100) || (d1 < 0) )
			  {
				  alert("1. <cf_get_lang dictionary_id='57727.İndirim Değeri Hatalı'> ! ("+(satir+1)+")");
				  setFieldValue('indirim1', satir,0,0);
				  return false;
			  }
			  d2 = data_row.INDIRIM2;
			  if( (d2 > 100) || (d2 < 0) )
			  {
				  alert("2. <cf_get_lang dictionary_id='57727.İndirim Değeri Hatalı'> ! ("+(satir+1)+")");
				  setFieldValue('indirim2', satir,0,0);
				  return false;
			  }
			  d3 = data_row.INDIRIM3;
			  if( (d3 > 100) || (d3 < 0) )
			  {
				  alert("3. <cf_get_lang dictionary_id='57727.İndirim Değeri Hatalı'> ! ("+(satir+1)+")");
				  setFieldValue('indirim3', satir,0,0);
				  return false;
			  }
			  d4 = data_row.INDIRIM4;
			  if( (d4 > 100) || (d4 < 0) )
			  {
				  alert("4. <cf_get_lang dictionary_id='57727.İndirim Değeri Hatalı'> ! ("+(satir+1)+")");
				  setFieldValue('indirim4', satir,0,0);
				  return false;
			  }
			  d5 = data_row.INDIRIM5;
			  if( (d5 > 100) || (d5 < 0) )
			  {
				  alert("5. <cf_get_lang dictionary_id='57727.İndirim Değeri Hatalı'> ! ("+(satir+1)+")");
				  setFieldValue('indirim5', satir,0,0);
				  return false;
			  }
			  d6 = data_row.INDIRIM6;
			  if( (d6 > 100) || (d6 < 0) )
			  {
				  alert("6. <cf_get_lang dictionary_id='57727.İndirim Değeri Hatalı'> ! ("+(satir+1)+")");
				  setFieldValue('indirim6', satir,0,0);
				  return false;
			  }
			  d7 = data_row.INDIRIM7;
			  if( (d7 > 100) || (d7 < 0) )
			  {
				  alert("7. <cf_get_lang dictionary_id='57727.İndirim Değeri Hatalı'> ! ("+(satir+1)+")");
				  setFieldValue('indirim7', satir,0,0);
				  return false;
			  }
			  d8 = data_row.INDIRIM8;
			  if( (d8 > 100) || (d8 < 0) )
			  {
				  alert("8. <cf_get_lang dictionary_id='57727.İndirim Değeri Hatalı'> ! ("+(satir+1)+")");
				  setFieldValue('indirim8', satir,0,0);
				  return false;
			  }
			  d9 = data_row.INDIRIM9;
			  if( (d9 > 100) || (d9 < 0) )
			  {
				  alert("9. <cf_get_lang dictionary_id='57727.İndirim Değeri Hatalı'> ! ("+(satir+1)+")");
				  setFieldValue('indirim9', satir,0,0);
				  return false;
			  }
			  d10 = data_row.INDIRIM10;
			  if( (d10 > 100) || (d10 < 0) )
			  {
				  alert("10. <cf_get_lang dictionary_id='57727.İndirim Değeri Hatalı'> ! ("+(satir+1)+")");
				  setFieldValue('indirim10', satir,0,0);
				  return false;
			  }
			  indirim_carpan = (100-d1) * (100-d2) * (100-d3) * (100-d4) * (100-d5) * (100-d6) * (100-d7) * (100-d8) * (100-d9) * (100-d10);
			  fillArrayField('indirim_total',indirim_carpan,indirim_carpan,satir,1);
			  switch(field_name.replace('indirim',''))
			  {
				  case "1" : fillArrayField(field_name,d1,commaSplit(d1),satir,1); break;
				  case "2" : fillArrayField(field_name,d2,commaSplit(d2),satir,1); break;
				  case "3" : fillArrayField(field_name,d3,commaSplit(d3),satir,1); break;
				  case "4" : fillArrayField(field_name,d4,commaSplit(d4),satir,1); break;
				  case "5" : fillArrayField(field_name,d5,commaSplit(d5),satir,1); break;
				  case "6" : fillArrayField(field_name,d6,commaSplit(d6),satir,1); break;
				  case "7" : fillArrayField(field_name,d7,commaSplit(d7),satir,1); break;
				  case "8" : fillArrayField(field_name,d8,commaSplit(d8),satir,1); break;
				  case "9" : fillArrayField(field_name,d9,commaSplit(d9),satir,1); break;
				  case "10" : fillArrayField(field_name,d10,commaSplit(d10),satir,1); break;
			  }
		  }
		  else
			  indirim_carpan = data_row.INDIRIM_TOTAL;
		  if(data_row.AMOUNT < 0)
		  {
			  alert("<cf_get_lang dictionary_id='57728.Miktar Değeri Hatalı'> ! ("+(satir+1)+")");
			  setFieldValue('amount', satir,1,0);
			  return false;
		  }
		  if(data_row.PRICE < 0)
		  {
			  alert("<cf_get_lang dictionary_id='57729.Fiyat Değeri Hatalı'> ! ("+(satir+1)+")");
			  setFieldValue('price', satir,0,0);
			  return false;
		  }
		  amount_ = data_row.AMOUNT;
		  if(amount_==0) amount_ = 1;
		  
		  hesapla_amount('Amount',satir);// PHL den dosya yüklenirken miktar2 yi hesaplamasi icin.
		  
		  price_ = data_row.PRICE;
		  price_other_ = data_row.PRICE_OTHER;
		  tax_ = data_row.TAX_PERCENT;
		  if(data_row.OTV_ORAN)
			  otv_oran_ = data_row.OTV_ORAN;
		  promosyon_yuzde = data_row.PROMOSYON_YUZDE;
		  iskonto_tutar = wrk_round((data_row.ISKONTO_TUTAR*rate2)/rate1,price_round_number); <!--- satirin para birimine gore sisteme cevirme --->
		  if(field_name == 'ek_tutar' || field_name == 'Amount')
		  {
			  ek_tutar = data_row.EK_TUTAR;
			  ek_tutar_other_total_ = wrk_round((ek_tutar*amount_),price_round_number);  
			  ek_tutar = wrk_round(ek_tutar*rate2/rate1,price_round_number); <!--- satirin para birimine gore sisteme cevirme --->
		  }
		  else
		  {
			  ek_tutar = wrk_round((data_row.EK_TUTAR_TOTAL/amount_),price_round_number); <!--- ek_tutar isleminin sırası degistirilmemeli--->
			  ek_tutar_other_total_ = wrk_round((ek_tutar*(rate1/rate2)*amount_),price_round_number);  <!--- ek_tutar_other_total_, satır ek tutar toplamını satırda secili olan doviz biriminden tutar.ek_tutar_total ise sistem para birimi cinsinden ek tutar satır toplamnı tutar --->
		  }
		  <!--- fiyat - satir toplami - doviz degisiklikleri --->
		  if(field_name == 'row_total')<!--- // satır toplamı degismisse --->
		  { 
			  row_total_ = data_row.ROW_TOTAL;
			  if(amount_ !=0) <!--- //satırı sildikten sonra hesapla function calıstıgında degerlerin dagılmaması icin--->
				  price_ = (row_total_ -(ek_tutar*amount_)) / amount_;
			  else
				  price_ = 0;
			  price_other_ = wrk_round(price_*rate1/rate2,price_round_number);
			  
		  }
		  else if(field_name == 'price_other')
		  {
			  price_other_ = data_row.PRICE_OTHER;
			  price_ = wrk_round( price_other_*rate2/rate1,price_round_number);
		  }
		  else if(field_name == 'other_money_value')
		  {
			  other_money_value_ = data_row.OTHER_MONEY_VALUE;
			  //console.log(data_row.OTHER_MONEY_VALUE);
			  if(amount_ !=0)  <!--- satırı sildikten sonra hesapla function calıstıgında degerlerin dagılmaması icin--->
				  price_other_ = (other_money_value_/amount_)*100000000000000000000/indirim_carpan;
			  else
				  price_other_ = 0;
			  price_other_ *= 100/(100-promosyon_yuzde);
			  price_other_ += data_row.ISKONTO_TUTAR;
			  price_other_ -= data_row.EK_TUTAR;
			  price_ = price_other_*rate2/rate1;
  //			price_ = wrk_round( price_other_*rate2/rate1 ,price_round_number);
		  }
		  else if(field_name == 'ek_tutar_other_total')
		  {
			  if(data_row.EK_TUTAR_OTHER_TOTAL == '')
				  ek_tutar_other_total_ = 0;
			  else
				  ek_tutar_other_total_ = data_row.EK_TUTAR_OTHER_TOTAL;
			  if(amount_ != 0) <!--- satır silindiginde miktar 0 set ediliyor. miktar sıfırken sorun cıkmaması icin kontrol ediliyor --->
				  ek_tutar = wrk_round((ek_tutar_other_total_* (rate2/rate1))/amount_,price_round_number);
			  else
				  ek_tutar = 0;
		  }
		  else
		  {
			  price_other_ = wrk_round( price_*rate1/rate2 ,price_round_number);
		  }
		  if(iskonto_tutar > price_)
			  iskonto_tutar = 0;
  
		  row_total_ = wrk_round((price_+ek_tutar)* amount_,basket_total_round_number);
		  
		  fillArrayField('Amount',amount_,commaSplit(amount_,amount_round),satir,1);
		  fillArrayField('Price',price_,commaSplit(price_,price_round_number),satir,1);
		  fillArrayField('price_other',price_other_,commaSplit(price_other_,price_round_number),satir,1);
		  fillArrayField('iskonto_tutar',iskonto_tutar*rate1/rate2,commaSplit(iskonto_tutar*rate1/rate2,price_round_number),satir,1);<!--- yerel para birimine cevrilen prom tutar iskontosu satirda secili olan dovize donuyor --->
		  fillArrayField('ek_tutar_total',ek_tutar*amount_,wrk_round((ek_tutar*amount_),price_round_number),satir,1);<!--- yerel para birimine cevrilen ek tutar satır toplamını gosteriyor,hidden alanda tutuldugundan commaSplit ten gecirilmiyor, set etme sıralaması degistirilmemeli--->
		  fillArrayField('ek_tutar',ek_tutar*rate1/rate2,commaSplit(ek_tutar*rate1/rate2,price_round_number),satir,1);
		  fillArrayField('ek_tutar_other_total',ek_tutar_other_total_,commaSplit(ek_tutar_other_total_,price_round_number),satir,1);
		  fillArrayField('promosyon_yuzde',promosyon_yuzde,commaSplit(promosyon_yuzde,2),satir,1);
		  fillArrayField('row_total',row_total_,commaSplit(row_total_,price_round_number),satir,1);
		  fillArrayField('other_money_value',other_money_value_,commaSplit(row_total_,basket_total_round_number),satir,1);
  
		  price_ += ek_tutar;
		  price_ -= iskonto_tutar;
		  price_ -= price_ * promosyon_yuzde/100;
		  price_net_ = wrk_round(price_*indirim_carpan/100000000000000000000 ,price_round_number);
		  fillArrayField('price_net',price_net_,commaSplit(price_net_,price_round_number),satir,1);
		  row_nettotal_ = wrk_round(price_net_*amount_,basket_total_round_number);
		  fillArrayField('row_nettotal',row_nettotal_,commaSplit(row_nettotal_,price_round_number),satir,1);
  
		  if(field_name != 'row_otvtotal')
		  {
			  row_otvtotal_ = wrk_round((row_nettotal_*otv_oran_) / 100,basket_total_round_number);
			  <cfif otv_calc_type_ eq 1>
				  row_otvtotal_ = wrk_round((amount_ * otv_oran_),basket_total_round_number);
				  if(row_nettotal_ == 0)
					  row_otvtotal_ = 0;
			  </cfif>
		  }
		  else row_otvtotal_ = data_row.ROW_OTVTOTAL;

		  if(field_name != 'OTV_type') row_otv_discount = (data_row["OTV_TYPE"] == 0) ? 0 : row_otvtotal_;
		  else row_otv_discount = (data_row["OTV_TYPE"] == 0) ? 0 : row_otvtotal_;
		  
		  if(field_name != 'row_taxtotal')
		  {
			  <cfif ListFindNoCase(display_list, "otv_from_tax_price")> //kdv matrahına otv toplam ekleniyor
				  if(basket_total_round_number==2)
				  {
					  pre_tax_t = wrk_round( ((row_nettotal_+row_otvtotal_)* tax_),price_round_number);			
					  row_taxtotal_ = wrk_round((pre_tax_t / 100),price_round_number);
				  }
				  else
				  {
					  pre_tax_t=	wrk_round( ((row_nettotal_+row_otvtotal_)/100),price_round_number);			
					  row_taxtotal_ = wrk_round((pre_tax_t * tax_),price_round_number);
				  }
			  <cfelse>
				  if(satir_kdv_tutar!=undefined)
					  row_taxtotal_ = satir_kdv_tutar;
				  else
				  {
					  if(basket_total_round_number==2)
					  {
						  if(row_nettotal_ == 0){
							  row_taxtotal_ = filterNumBasket(0,price_round_number);
						  }
						  else
						  {
						  
							  pre_tax_t =	wrk_round((row_nettotal_* tax_),price_round_number);			
							  row_taxtotal_ = wrk_round((pre_tax_t / 100),price_round_number);
						  }
					  }
					  else
					  {
						  if(row_nettotal_ == 0){
							  row_taxtotal_ = filterNumBasket(0,price_round_number);
						  }
						  else
						  {
							  pre_tax_t=	wrk_round((row_nettotal_/ 100),price_round_number);			
							  row_taxtotal_ = wrk_round((pre_tax_t * tax_),price_round_number);
						  }
					  }
				  }
			  </cfif>
		  }
		  else row_taxtotal_ = filterNumBasket(data_row.ROW_TAXTOTAL,price_round_number);
  
			  /*bsmv*/
		  <!---<cfif ListFindNoCase(display_list, "row_bsmv_rate") and ListFindNoCase(display_list, "row_bsmv_amount") and ListFindNoCase(display_list, "row_bsmv_currency")>--->
  
			  if( field_name == 'row_bsmv_amount' )
			  {
				  
				  row_bsmv_amount = wrk_round( data_row.ROW_BSMV_AMOUNT ,price_round_number);
				  row_bsmv_rate = ( row_bsmv_amount > 0 ) ? row_bsmv_amount * 100 / row_nettotal_ : 0;
				  row_bsmv_currency = row_bsmv_amount * rate1 / rate2;
  
			  }else if( field_name == 'row_bsmv_currency' )
			  {
  
				  row_bsmv_currency = wrk_round( data_row.ROW_BSMV_CURRENCY ,price_round_number );
				  row_bsmv_amount = row_bsmv_currency * rate1 / rate2;
				  row_bsmv_rate = ( row_bsmv_amount > 0 ) ? row_bsmv_amount * 100 / row_nettotal_ : 0;
  
			  }
			  else
			  {
				  row_bsmv_rate = (data_row.ROW_BSMV_RATE) ? wrk_round( data_row.ROW_BSMV_RATE  ,price_round_number) : 0;
				  row_bsmv_amount = row_nettotal_ * row_bsmv_rate / 100;
				  row_bsmv_currency = ( row_bsmv_amount > 0 ) ? row_bsmv_amount * rate1 / rate2 : 0;
  
			  }
			  fillArrayField('row_bsmv_rate',row_bsmv_rate,commaSplit(row_bsmv_rate,price_round_number),satir,1);
			  fillArrayField('row_bsmv_amount',row_bsmv_amount,commaSplit(row_bsmv_amount,price_round_number),satir,1);
			  fillArrayField('row_bsmv_currency',row_bsmv_currency,commaSplit(row_bsmv_currency,price_round_number),satir,1);
	  <!---	</cfif>--->
		  /*bsmv*/
  
	  /*öiv*/
	  <!---	<cfif ListFindNoCase(display_list, "row_oiv_rate") and ListFindNoCase(display_list, "row_oiv_amount")>--->
			  if( field_name == 'row_oiv_amount' )
			  {
				  
				  row_oiv_amount = wrk_round( data_row.ROW_OIV_AMOUNT , price_round_number);
				  row_oiv_rate = (row_oiv_amount > 0) ? row_oiv_amount  * 100 / row_nettotal_ : 0;
  
			  }
			  else
			  {
  
				  row_oiv_rate = (data_row.ROW_OIV_RATE) ? wrk_round( data_row.ROW_OIV_RATE , price_round_number) : 0;
				  row_oiv_amount = ( row_oiv_rate > 0 ) ? row_nettotal_ * row_oiv_rate / 100 : 0;
  
			  }
			  fillArrayField('row_oiv_rate',row_oiv_rate,commaSplit(row_oiv_rate, price_round_number),satir,1);
			  fillArrayField('row_oiv_amount',row_oiv_amount,commaSplit(row_oiv_amount, price_round_number),satir,1);
		  <!---</cfif>--->
		  /*öiv*/
  
		  fillArrayField('row_taxtotal',row_taxtotal_,commaSplit(row_taxtotal_,basket_total_round_number),satir,1);
		  fillArrayField('row_otvtotal',row_otvtotal_,commaSplit(row_otvtotal_,basket_total_round_number),satir,1);
		  fillArrayField('otv_discount',row_otv_discount,commaSplit(row_otv_discount,basket_total_round_number),satir,1);
		  row_lasttotal_ = row_nettotal_+row_taxtotal_+row_otvtotal_+row_oiv_amount+row_bsmv_amount;
	  
		  if(amount_ > 0 && field_name == 'tax_price')
			  fillArrayField('tax_price',data_row.TAX_PRICE,commaSplit(filterNumBasket(data_row.TAX_PRICE,price_round_number),price_round_number),satir,1);
		  else if (amount_ > 0)
			  fillArrayField('tax_price',wrk_round(row_lasttotal_/amount_),commaSplit(wrk_round(row_lasttotal_/amount_),price_round_number),satir,1);		
		  else
			  fillArrayField('tax_price',0,commaSplit(0,price_round_number),satir,1);		
			  
		  fillArrayField('row_lasttotal',row_lasttotal_,commaSplit(row_lasttotal_,price_round_number),satir,1);
		  price_net_doviz_ = price_net_ * rate1 / rate2;
		  fillArrayField('price_net_doviz',price_net_doviz_,commaSplit(price_net_doviz_,price_round_number),satir,1);
		  other_money_value_ = wrk_round(amount_ * price_net_doviz_,price_round_number);
		  other_money_gross_value_ = row_lasttotal_ * rate1/rate2;
		  if(row_taxtotal_ == 0 && row_otvtotal_ == 0)
			  other_money_gross_value_ = other_money_value_;
		  else	
			  other_money_gross_value_ = row_lasttotal_ * rate1/rate2;
			  
		  fillArrayField('other_money_gross_total',other_money_gross_value_,commaSplit(other_money_gross_value_,price_round_number),satir,1);
		  fillArrayField('other_money_value',other_money_value_,commaSplit(other_money_value_,price_round_number),satir,1);
		  <cfif ListFindNoCase(display_list, "is_promotion")>
			  if(field_name == 'amount') /*promosyon seciliyse ve miktar edit edilmisse, promosyon satırı kontrol ediliyor*/
				  control_row_prom(satir);
		  </cfif>
  
		  /*tevkifat*/
		  <cfif ListFindNoCase(display_list, "row_tevkifat_rate") and ListFindNoCase(display_list, "row_tevkifat_amount")>
			  if( field_name == 'row_tevkifat_amount' ){
				  
				  row_tevkifat_amount = wrk_round( data_row.ROW_TEVKIFAT_AMOUNT );
				  row_tevkifat_rate = ( row_tevkifat_amount > 0 ) ? row_tevkifat_amount / row_taxtotal_ : 0;
  
			  }
			  else {
  
				  row_tevkifat_rate = wrk_round( data_row.ROW_TEVKIFAT_RATE );
				  row_tevkifat_amount = row_taxtotal_ * row_tevkifat_rate;
				  
			  }
  
			  fillArrayField('row_tevkifat_rate',row_tevkifat_rate,commaSplit(row_tevkifat_rate,basket_total_round_number),satir,1);
			  fillArrayField('row_tevkifat_amount',row_tevkifat_amount,commaSplit(row_tevkifat_amount,basket_total_round_number),satir,1);
		  </cfif>
		  /*tevkifat*/
  
		  if(window.basket.hidden_values.rows_ == 1)
			  {
			  //islem yok
			  }
		  else
			  ayir_ters(satir+1);//row_value geri inputlara aktarildi
		  if(toplam_hesap)
		  {
			  toplam_hesapla(0);
		  }
  
		  try
		  {
			  //Mifa- FBS ekledi, musterilerde basket satirlarinda yapilan degisikligin alinmasi icin eklendi
			  extra_basket_hesapla();
		  }
		  catch(e)
		  {
			  //nothing
		  }
		  return true;
		  
	  }
  }
  
  
  function add_general_prom(basket_net_val_)
  {
	  <cfif fusebox.circuit eq 'invoice' or listfind("1,2,4,10,14,18,20,21,33,42,43,51,52",attributes.basket_id,",")>
		  var is_general_prom_found=true;
		  var is_free_prom_found=true;
		  var general_prom_limit=0;
		  var free_prom_limit=0;
		  if($("#basket_main_div #company_id").length != 0)
		  {
			  var prom_date = js_date($("#basket_main_div #" + $("#basket_main_div #search_process_date").val()).val().toString());
			  
			  var listParam = prom_date + "*" + basket_net_val_;
			  var new_sql = 'obj_get_comp_proms_2';
			  if(basket_net_val_!=undefined && basket_net_val_!='' && basket_net_val_!=0) /*toplam hesapla icinden basket toplamı gonderilmisse*/
				  new_sql = 'obj_get_comp_proms_3';
			  var get_comp_proms = wrk_safe_query(new_sql,'dsn3',0,listParam);
			  <cfif session.ep.username is 'admin'>
				  general_prom_inputs.style.display='block';
				  general_prom_inputs.innerHTML += '<br/>Sorgu:<br/>'+new_sql;
			  </cfif>
		  }
		  else
		  {
			  get_comp_proms = new Object();
			  get_comp_proms.recordcount = 0;
		  }
	  
		  if(get_comp_proms.recordcount){
			  window.basket.hidden_values.IS_GENERAL_PROM = 1;
			  general_prom_inputs.style.display='block';
			  for(var prom_i=0;prom_i<get_comp_proms.recordcount;prom_i++){
				  if(is_general_prom_found && get_comp_proms.DISCOUNT[prom_i].length){
					  is_general_prom_found=false;
					  for(var mon_i=0;mon_i<moneyArray.length;mon_i++)
						  if(moneyArray[mon_i]==get_comp_proms.LIMIT_CURRENCY[prom_i])
							  general_prom_limit = get_comp_proms.LIMIT_VALUE[prom_i]*rate2Array[mon_i]/rate1Array[mon_i];
					  general_prom_inputs_1.innerHTML = '<a href="javascript:windowopen(\'<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_detail_promotion_unique&prom_id='+get_comp_proms.PROM_ID[prom_i]+'\',\'medium\')"><b>Toplama İndirim</b></a>';
					  general_prom_inputs_1.innerHTML += '<input type="hidden" name="general_prom_id" value="' + get_comp_proms.PROM_ID[prom_i] + '"><br/>';
					  general_prom_inputs_1.innerHTML += 'Alışveriş Miktarı<input type="text" style="width:75px;" name="general_prom_limit" value="' + general_prom_limit + '" readonly class="box"><br/>';
					  general_prom_inputs_1.innerHTML += 'İndirim % <input type="text" name="general_prom_discount" style="width:98px;" value="' + get_comp_proms.DISCOUNT[prom_i] + '" readonly class="box"><br/>';
					  general_prom_inputs_1.innerHTML += 'Toplam İndirim<input type="text" style="width:80px;" name="general_prom_amount" value="" readonly class="box">';
					  }
				  else if(is_free_prom_found && get_comp_proms.FREE_STOCK_ID[prom_i].length){
					  is_free_prom_found=false;
					  for(var mon_i=0;mon_i<moneyArray.length;mon_i++)
						  if(moneyArray[mon_i]==get_comp_proms.LIMIT_CURRENCY[prom_i])
							  free_prom_limit = get_comp_proms.LIMIT_VALUE[prom_i]*rate2Array[mon_i]/rate1Array[mon_i];
					  general_prom_inputs_2.innerHTML = '<a href="javascript:windowopen(\'<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_detail_promotion_unique&prom_id='+get_comp_proms.PROM_ID[prom_i]+'\',\'medium\')"><b>Toplama Bedava Ürün</b></a><br/>';
					  general_prom_inputs_2.innerHTML += '<input type="hidden" name="free_prom_id" value="' + get_comp_proms.PROM_ID[prom_i] + '"><input type="hidden" name="free_prom_cost" value="'+get_comp_proms.TOTAL_PROMOTION_COST[prom_i]+'" readonly class="box">';
					  general_prom_inputs_2.innerHTML += 'Alışveriş Miktarı<input type="text" name="free_prom_limit" style="width:75px;" value="' + free_prom_limit + '" readonly class="box"><br/>';
					  general_prom_inputs_2.innerHTML += 'Kazanılan Ürün ID<input type="text" name="free_prom_stock_id" style="width:63px;" value="'+get_comp_proms.FREE_STOCK_ID[prom_i]+'" readonly class="box"><br/>';
					  general_prom_inputs_2.innerHTML += 'Ürün Miktarı<input type="text" name="free_prom_amount" style="width:91px;" value="'+get_comp_proms.FREE_STOCK_AMOUNT[prom_i]+'" readonly class="box"><br/>';
					  general_prom_inputs_2.innerHTML += 'Ürün Fiyatı<input type="text" style="width:97px;" name="free_stock_price" value="'+get_comp_proms.FREE_STOCK_PRICE[prom_i]+'" readonly class="box"><input type="text" name="free_stock_money" style="width:40px;" value="'+get_comp_proms.AMOUNT_1_MONEY[prom_i]+'" readonly class="boxtext">';
					  }
				  }
				  if(is_general_prom_found)
					  general_prom_inputs_1.innerHTML = '<input type="hidden" name="general_prom_limit" value="0"><input type="hidden" name="general_prom_amount" value="0"><input type="hidden" name="general_prom_discount" value="0">';
				  if(is_free_prom_found)
					  general_prom_inputs_2.innerHTML = '<input type="hidden" name="free_prom_limit" value="0">';
				  toplam_hesapla(0);
			  }
		  else if(window.basket.hidden_values.IS_GENERAL_PROM){
			  general_prom_inputs.style.display='none';
			  window.basket.hidden_values.IS_GENERAL_PROM = 0;
			  general_prom_inputs_1.innerHTML = '<input type="hidden" name="general_prom_limit" value="0"><input type="hidden" name="general_prom_amount" value="0"><input type="hidden" name="general_prom_discount" value="0">';
			  general_prom_inputs_2.innerHTML = '<input type="hidden" name="free_prom_limit" value="0">';
			  toplam_hesapla(0);
			  }
		  else 
			  return true;<!--- eger kayit yoksa ve daha once de gelmemisse  --->
	  </cfif>
  }
  
  </script>
  
  <script>
  /**
  * Makes an ajax request to the given url and calls specified function for the results
  * 
  *  @param string url 			Target url
  *  @param function callback 	Function will be called for the results with the parameters as ordered: target, data, status, jqXHR
  *  @param string data			Data as string. Default is null
  *  @param any target 			Reference object which associated the ajax request
  */
  function callURLBasket(url, callback, data, target, async)
  {   
	  // Make method POST if data parameter is specified
	  var method = (data != null) ? "POST": "GET";
	  $.ajax({
		  async: async != null ? async: true,
		  url: url,
		  type: method,
		  data: data,
		  success: function(responseData, status, jqXHR)
		  { 
			  callback(target, responseData, status, jqXHR); 
		  }
		  /*,
		  error: function(xhr, opt, err)
		  {
			  // If error string is empty, it means page redirected to another url before ajax process done. Skip the process on this situation
			  if (err != null && err.toString().length != 0) callback(target, err, opt, xhr); 
		  }
		  */
	  });
  }
  function handlerPostBasket(target, responseData, status, jqXHR)
  {
	  responseData = $.trim(responseData);
	  
	  $('#working_div_main').css("display", "none");
	  
	  if(responseData.substr(0,2) == '//') responseData = responseData.substr(2,responseData.length-2);
	  //console.log(responseData);
  
	  ajax_request_script(responseData);
	  //console.log(responseData);
	  
	  var SCRIPT_REGEX = /<script\b[^<]*(?:(?!<\/script>)<[^<]*)*<\/script>/gi;
	  while (SCRIPT_REGEX.test(responseData)) {
		  responseData = responseData.replace(SCRIPT_REGEX, "");
	  }
	  responseData = responseData.replace(/<!-- sil -->/g, '');
	  responseData = responseData.replace(/(\r\n|\n|\r)/gm,'');
	  //if($.trim(responseData).length > 10) /* İşlem Başarılı, işlem hatalı gibi geri dönüş değerleri kontrol ediliyor. */
	  //	alert($.trim(responseData));
	  
	  /*
	  if (responseData.indexOf("İşlem Başarılı")){
		  sonuc_ = responseData.substr(responseData.indexOf("İşlem Başarılı"),responseData.length);
		  
		  request_page = responseData.substr(responseData.indexOf("İşlem Başarılı")+15,(responseData.indexOf("█") - responseData.indexOf("İşlem Başarılı") - 15));	
		  alert('İşleminiz Başarıyla kaydedilmiştir');
		  
		  
		  if(request_page.indexOf('index.cfm?fuseaction') == 0)
			  window.location.href = request_page;
		  else if (responseData.indexOf('window.location.href="'))
		  {
			  startCharacter = responseData.indexOf('window.location.href="');
			  newResponseData = responseData.substr(responseData.indexOf('window.location.href="'),responseData.length);
			  lastCharacter = newResponseData.indexOf('";');
			  request_page = newResponseData.substr(22,lastCharacter-22);
			  window.location.href = request_page;
			  
		  }
	  } else {
		  //document.getElementById('note').value = responseData;
		  alert('İşleminiz Sırasında Hata oluşmuştur');
	  }
	  */
  }
  function fillArrayField(fieldName,ArrayValue,FieldValue,rowNumber,notArray,extraFunction)  // Bu fonksiyon her seferinde array ve ekrandaki inputları tek tek doldurmamak için tek bir yere taşındı.
  {
	  
	  if(fieldName == 'Tax')
		  new_fieldName = 'tax_percent';
	  else if(fieldName == 'OTV')
		  new_fieldName = 'otv_oran';
	  else
		  new_fieldName = fieldName;
	  
	  data = window.basket.items[rowNumber];
  
	  rowNumber -= window.basket.scrollIndex; 
	  
	  
	  //Baskete yeni satır eklerken karma koli olma durumuna göre bazı durumlarda Amount alanı readonly olabiliyor yada hesaplayı tetikleyebilecek tarzda olabiliyor. Bu ayrımı yapmak için eklendi.
	  if(extraFunction)
		  $("#tblBasket tr[basketItem]").eq(rowNumber).find("#"+fieldName).attr($.trim(ListFirst(extraFunction,'=')),$.trim(ListLast(extra_function,'=')));
	  
	  if(notArray == 1) // Hem array'i hem ekranı günceller.
	  {
		  arrayText = new_fieldName.toUpperCase();
		  data[arrayText] = ArrayValue;
		  $("#tblBasket tr[basketItem]").eq(rowNumber).find("#"+fieldName).val(FieldValue);
  
	  }
	  else if(notArray == 2) // Sadece array'i günceller. Hesapla fonksiyonunda kullanılıyor. Hesapla işlemleri array üzerinden yazıldığı için ekrandan girilen değer array'i güncellemesi lazım.
	  {
		  arrayText = new_fieldName.toUpperCase();
		  data[arrayText] = ArrayValue;
	  }
	  else
	  {
		  if($("#tblBasket tr[basketItem]").eq(rowNumber).find("#"+fieldName).attr('type') == 'text')
			  $("#tblBasket tr[basketItem]").eq(rowNumber).find("#"+fieldName).val(FieldValue);
	  }
  }
  function toplam_hesapla(from_sa_amount,from_new_row_,is_from_upd)
  {
	  
	  var toplam_ = 0;
	  var indirim_ = 0;
	  var vergi_ = 0;
	  var otv_vergisi_ = 0;
	  var net_ = 0;
	  var re_toplam_hesapla = 0;
	  var prom_display='<font color="FF0000">Promosyon!</font>';
	  taxArray = new Array(0);
	  taxTotalArray = new Array(0);
	  otvArray = new Array(0);
	  otvTotalArray = new Array(0);
	  var rate_flag = false;
	  var commission_row = 0;
	  var oivTotal = 0.0;
	  var bsmvTotal = 0.0;
	  var OTVDiscountTotal = 0.0;
	  var tevkifatTotal = 0.0;
	  var totalTevkifatAmount = new Array();
	  var totalTevkifat = new Array();
  
	  function toplam_hesapla_in(is_take_commission,new_row_)
	  {	
		  toplam_ = 0;
		  vergi_ = 0;
		  otv_vergisi_ = 0;
		  net_ = 0;
		  var tax_flag = false;
		  var otv_flag = false;
		  taxArray = new Array(0);
		  taxTotalArray = new Array(0);
		  unitArray = new Array(0);
		  unitTotalArray = new Array(0);
		  otvArray = new Array(0);
		  otvTotalArray = new Array(0);
  
		  if(window.basket.hidden_values.rows_ > 1)
		  {
			  if(new_row_!=undefined && new_row_!='') // Yeni Kayıt Eklenince bu kısım işler
			  {
				  line_data = window.basket.items[new_row_];
				  toplam_ = window.basket.footer.basket_gross_total;
				  net_ = window.basket.footer.basket_net_total - window.basket.footer.basket_tax_total - window.basket.footer.basket_otv_total;	
				  if(is_take_commission)
				  {
					  toplam_ = toplam_ + line_data.ROW_TOTAL;
					  net_ = net_ + line_data.ROW_NETTOTAL;
					  if(generaltaxArray.length != 0)
					  {
						  var gnArrayLen = generaltaxArray.length;				
						  for (var gn=0; gn < gnArrayLen; gn++)
						  {
							  
							  taxArray[gn] = generaltaxArray[gn];
							  if(taxArray[gn] == line_data.TAX_PERCENT)//yeni satırın kdvsi onceden varsa toplama eklenir
							  {	
								  tax_flag = true;
								  taxTotalArray[gn] = wrk_round(generaltaxArrayTotal[gn],basket_total_round_number) + line_data.ROW_TAXTOTAL;
							  }
							  else
								  taxTotalArray[gn] = generaltaxArrayTotal[gn];
						  }
					  }
					  else
					  {
						  <cfif StructKeyExists(sepet,'kdv_array') and IsArray(sepet.kdv_array)>
							  <cfloop from="1" to="#arraylen(sepet.kdv_array)#" index="tt">
							  {
								  taxArray[taxArray.length] = '<cfoutput>#sepet.kdv_array[tt][1]#</cfoutput>';
								  //taxTotalArray[taxArray.length-1] = '0';
								  //taxMatrahArray[taxArray.length-1] = '<cfoutput>#sepet.kdv_array[tt][3]#</cfoutput>';
								  if('<cfoutput>#sepet.kdv_array[tt][1]#</cfoutput>' == line_data.TAX)
								  {
									  tax_flag = true;
									  taxTotalArray[taxArray.length-1] = '<cfoutput>#sepet.kdv_array[tt][2]#</cfoutput>';
										  
									  //taxTotalArray[taxArray.length-1] = 0;
									  taxTotalArray[taxArray.length-1] = wrk_round(taxTotalArray[taxArray.length-1],price_round_number) + line_data.ROW_TAXTOTAL;
									  //taxMatrahArray[taxArray.length-1] = wrk_round(taxMatrahArray[taxArray.length-1],basket_total_round_number)+filterNumBasket(changeable_value['row_taxtotal'][new_row_].value,basket_total_round_number);
								  }
							  }
							  </cfloop>
						  </cfif>
					  }
  
					  if(!tax_flag){ //yeni kdv oranıysa
						  taxArray[taxArray.length] = line_data.TAX;
						  taxTotalArray[taxTotalArray.length] = line_data.ROW_TAXTOTAL;
						  }
					  if(generalotvArray.length != 0)
					  {	
						  var gnotvArrayLen = generalotvArray.length;
						  for (var gg=0; gg < gnotvArrayLen; gg++)
						  {	
							  otvArray[gg] = generalotvArray[gg];
							  if(otvArray[gg] == line_data.OTV_ORAN) //yeni satırın kdvsi onceden varsa toplama eklenir
							  {	
								  otv_flag = true;
								  otvTotalArray[gg] = wrk_round(generalotvArrayTotal[gg],basket_total_round_number) + line_data.ROW_OTVTOTAL;
							  }
							  else
								  otvTotalArray[gg] = generalotvArrayTotal[gg];
						  }
						  
					  }
					  else
					  {
						  
							  {	
								  otvArray[otvArray.length] = '0';
								  otvTotalArray[otvTotalArray.length] = '0';
								  if(otvArray[otvArray.length-1] == line_data.ROW_OTVTOTAL)
								  {
									  otv_flag = true;
									  otvTotalArray[otvArray.length-1] = wrk_round(otvTotalArray[otvArray.length-1],basket_total_round_number) + line_data.ROW_OTVTOTAL;
								  }
							  }
							  
					  }
  
					  if(!otv_flag){
						  otvArray[otvArray.length] = line_data.OTV_ORAN;
						  otvTotalArray[otvTotalArray.length] = line_data.ROW_OTVTOTAL;
					  }
				  }
			  }
			  else
			  {
				  for (var counter_=0; counter_ < window.basket.hidden_values.rows_; counter_++)
				  {
					  if(window.basket.items[counter_].IS_COMMISSION == 1)
						  commission_row = counter_;
					  if(window.basket.items[counter_].IS_COMMISSION != 1 || is_take_commission )
					  {
						  toplam_ += window.basket.items[counter_].ROW_TOTAL;
						  net_ += window.basket.items[counter_].ROW_NETTOTAL;
						  tax_flag = false;
						  if($("#tblBasket tr[basketItem]").eq(counter_).find("#Tax").val() != undefined)
							  taxLine = $("#tblBasket tr[basketItem]").eq(counter_).find("#Tax").val();
						  else
							  taxLine =  window.basket.items[counter_].TAX;
						  if(taxArray.length != 0)
						  {
							  var taxArrayLen= taxArray.length;
							  for (var m=0; m < taxArrayLen; m++)
							  {
								  if(taxArray[m] == taxLine)
								  {
									  tax_flag = true;
									  
									  taxTotalArray[m] += window.basket.items[counter_].ROW_TAXTOTAL;
								  
									  break;
								  }
							  }
						  }
						  if(!tax_flag)
						  {
							  
							  taxArray[taxArray.length] = taxLine;
							  taxTotalArray[taxTotalArray.length] = window.basket.items[counter_].ROW_TAXTOTAL;
						  }
						  
						  otv_flag = false;
  
						  if(otvArray.length != 0)
						  {
							  var otvArrayLen= otvArray.length;
							  for (var nn=0; nn < otvArrayLen; nn++)
							  {
								  if(otvArray[nn] == window.basket.items[counter_].OTV_ORAN)
								  {
									  otv_flag = true;
									  otvTotalArray[nn] += window.basket.items[counter_].ROW_OTVTOTAL;
									  break;
								  }
							  }
						  }
						  if(!otv_flag)
						  {
							  otvArray[otvArray.length] = window.basket.items[counter_].OTV_ORAN;
							  otvTotalArray[otvTotalArray.length] = window.basket.items[counter_].ROW_OTVTOTAL;
						  }
					  }
				  }
			  }
			  
		  }
		  else if(window.basket.hidden_values.rows_ == 1)
		  {
  
			  toplam_ = window.basket.items[0].ROW_TOTAL;
			  net_ = window.basket.items[0].ROW_NETTOTAL;
			  taxArray[0] = window.basket.items[0].TAX_PERCENT;
			  taxTotalArray[0] = window.basket.items[0].ROW_TAXTOTAL;
			  
			  if(window.basket.items[0].ROW_OTVTOTAL && window.basket.items[0].OTV_ORAN)
			  {
				  if(isNaN(window.basket.items[0].OTV_ORAN)||window.basket.items[0].OTV_ORAN==undefined)
					  otvArray[0] = 0;
				  else
					  otvArray[0] = window.basket.items[0].OTV_ORAN;
				  if(isNaN(window.basket.items[0].ROW_OTVTOTAL)||window.basket.items[0].ROW_OTVTOTAL==undefined)
					  otvTotalArray[0] = 0;
				  else
					  otvTotalArray[0] = window.basket.items[0].ROW_OTVTOTAL;
			  }
		  }
		  
		  var taxlen= taxArray.length;
		  if(taxlen != 0)
		  {
			  if(from_new_row_ == undefined || (from_new_row_ != undefined && from_new_row_== ''))
			  {
				  generaltaxArray= new Array(0);
				  generaltaxArrayTotal= new Array(0);
			  }
		  
			  for (var m=0; m < taxlen; m++)
			  {
				  generaltaxArray[m]= taxArray[m]; //genel basket tax array  degerleri aktarıyor EN SONA TASINACAK
				  generaltaxArrayTotal[m] = taxTotalArray[m];
				  vergi_+=wrk_round(taxTotalArray[m],price_round_number);
			  }
		  }
		  var otvlen= otvArray.length;
		  if(otvlen != 0)
		  {	
			  if(from_new_row_ == undefined || (from_new_row_ != undefined && from_new_row_== ''))
			  {
				  generalotvArray= new Array(0);
				  generalotvArrayTotal= new Array(0);
			  }
			  for (var z=0; z < otvlen; z++)
			  {
				  if(otvTotalArray[z] == undefined || isNaN(otvTotalArray[z])){
					  otvTotalArray[z]=0;
				  }
				  generalotvArray[z]= otvArray[z]; //genel basket otv array degerleri aktarıyor
				  generalotvArrayTotal[z] = otvTotalArray[z];
				  otv_vergisi_ += otvTotalArray[z];
			  }
		  }
  
		  var totalAmount = new Array();
		  var totalUnits = new Array();
		  var totalBsmvAmount = new Array();
		  var totalBsmv = new Array();
		  var totalOivAmount = new Array();
		  var totalOiv = new Array();
		  var totalOTVDiscountAmount = new Array();
		  var totalOTVDiscount = new Array();
  
		  window.basket.items.forEach( (elm) => {
			  
			  <cfif ListFindNoCase(display_list, "row_oiv_rate") and ListFindNoCase(display_list, "row_oiv_amount") and ListFindNoCase(display_list, "OIV")>
				  ///Toplam OIV
				  if( elm.ROW_OIV_RATE != 0 ){
					  if(totalOivAmount.length > 0){
						  if( totalOiv.indexOf( elm.ROW_OIV_RATE ) == -1){
							  totalOivAmount.push({ rate:elm.ROW_OIV_RATE, amount:parseFloat( elm.ROW_OIV_AMOUNT ) });
							  totalOiv.push( elm.ROW_OIV_RATE );
						  }else totalOivAmount[totalOiv.indexOf( elm.ROW_OIV_RATE )].amount += elm.ROW_OIV_AMOUNT;
					  }else{
						  totalOivAmount.push({ rate:elm.ROW_OIV_RATE, amount: parseFloat( elm.ROW_OIV_AMOUNT ) });
						  totalOiv.push( elm.ROW_OIV_RATE );
					  }
				  }
				  oivTotal += parseFloat( elm.ROW_OIV_AMOUNT );
				  ///Toplam OIV
			  </cfif>
  
		  <!---	<cfif ListFindNoCase(display_list, "row_bsmv_rate") and ListFindNoCase(display_list, "row_bsmv_amount") and ListFindNoCase(display_list, "row_bsmv_currency") and ListFindNoCase(display_list, "BSMV")>--->
				  ///Toplam BSMV
				  if( elm.ROW_BSMV_RATE != 0 ){
					  if(totalBsmvAmount.length > 0){
						  if( totalBsmv.indexOf( elm.ROW_BSMV_RATE ) == -1 ){
							  totalBsmvAmount.push({ rate:elm.ROW_BSMV_RATE, amount:parseFloat( elm.ROW_BSMV_AMOUNT ) });
							  totalBsmv.push( elm.ROW_BSMV_RATE );
						  }else totalBsmvAmount[totalBsmv.indexOf( elm.ROW_BSMV_RATE )].amount += elm.ROW_BSMV_AMOUNT;
					  }else{
						  totalBsmvAmount.push({ rate:elm.ROW_BSMV_RATE, amount: parseFloat( elm.ROW_BSMV_AMOUNT ) });
						  totalBsmv.push( elm.ROW_BSMV_RATE );
					  }
				  }
				  bsmvTotal += parseFloat( elm.ROW_BSMV_AMOUNT );
				  ///Toplam BSMV
			  <!---</cfif>--->
			  <cfif ListFindNoCase(display_list, "otv_discount")>
				  if( elm.OTV_DISCOUNT != 0 ){
				  	  if(totalOTVDiscountAmount.length > 0){
						  if( totalOTVDiscount.indexOf( elm.OTV_DISCOUNT ) == -1 ){
							  totalOTVDiscountAmount.push({ amount:parseFloat( elm.OTV_DISCOUNT ) });
							  totalOTVDiscount.push( elm.OTV_DISCOUNT );
						  }else totalOTVDiscountAmount[totalOTVDiscount.indexOf( elm.OTV_DISCOUNT )].amount += 0;
					  }else{
						  totalOTVDiscountAmount.push({ amount: parseFloat( elm.OTV_DISCOUNT ) });
						  totalOTVDiscount.push( elm.OTV_DISCOUNT );
					  }
				  }
				  OTVDiscountTotal += parseFloat( elm.OTV_DISCOUNT );
  				</cfif>
			  <!----<cfif ListFindNoCase(display_list, "row_tevkifat_rate") and ListFindNoCase(display_list, "row_tevkifat_amount")>--->
				  ///Toplam Tevkifat
				  if( elm.ROW_TEVKIFAT_RATE != 0 ){
					  if(totalTevkifatAmount.length > 0){
						  if( totalTevkifat.indexOf( elm.ROW_TEVKIFAT_RATE ) == -1 ){
							  totalTevkifatAmount.push({ rate:elm.ROW_TEVKIFAT_RATE, amount:parseFloat( elm.ROW_TEVKIFAT_AMOUNT ) });
							  totalTevkifat.push( elm.ROW_TEVKIFAT_RATE );
						  }else totalTevkifatAmount[totalTevkifat.indexOf( elm.ROW_TEVKIFAT_RATE )].amount += elm.ROW_TEVKIFAT_AMOUNT;
					  }else{
						  totalTevkifatAmount.push({ rate:elm.ROW_TEVKIFAT_RATE, amount: parseFloat( elm.ROW_TEVKIFAT_AMOUNT ) });
						  totalTevkifat.push( elm.ROW_TEVKIFAT_RATE );
					  }
				  }
				  tevkifatTotal += elm.ROW_TEVKIFAT_AMOUNT;
				  ///Toplam Tevkifat
			  <!---</cfif>--->
  
			  ///Birimlere göre miktar hesaplama : start
			  if(totalAmount.length > 0){
				  if( totalUnits.indexOf( elm.UNIT ) == -1 ){
					  totalAmount.push({ unit:elm.UNIT, amount:parseFloat( elm.AMOUNT ) });
					  totalUnits.push( elm.UNIT );
				  }else totalAmount[totalUnits.indexOf( elm.UNIT )].amount += elm.AMOUNT;
			  }else{
				  totalAmount.push({ unit:elm.UNIT, amount: parseFloat( elm.AMOUNT ) });
				  totalUnits.push( elm.UNIT );
			  }
			  ///Birimlere göre miktar hesaplama : end
		  });
  
		  $("div#totalAmountList table").html("");
		  if( totalAmount.length > 0 ){
			  totalAmount.forEach(( elm ) => {
				  $("<tr height='20'>").append($("<td>").addClass("txtbold").text( elm.unit ),$("<td style='text-align:right;'>").text( commaSplit(elm.amount,amount_round) )).appendTo( $("div#totalAmountList table") );
			  });
		  }
  
		  <cfif ListFindNoCase(display_list, "OIV")>
			  $("#basket_main_div #td_oiv_list").html('<span><cf_get_lang dictionary_id="50982.	ÖİV"></span>');
			  if( totalOivAmount.length > 0 ){
				  totalOivAmount.forEach(( elm ) => {
					  if( elm.rate != 0 ) $("<span>").append( (" % " + elm.rate + " : " + commaSplit(elm.amount,basket_total_round_number) + ", ") ).appendTo( $("#basket_main_div #td_oiv_list") );
				  });
				  $("#basket_main_div #td_oiv_list").text( $("#basket_main_div #td_oiv_list").text().slice( 0, -2 ) );
			  }
		  </cfif>
		  <cfif ListFindNoCase(display_list, "BSMV")>
			  $("#basket_main_div #td_bsmv_list").html('<span><cf_get_lang dictionary_id="50923.BSMV"></span>');
			  if( totalBsmvAmount.length > 0 ){
				  totalBsmvAmount.forEach(( elm ) => {
					  if( elm.rate != 0 ) $("<span>").append( " % " + elm.rate + " : " + commaSplit(elm.amount,basket_total_round_number) + ", " ).appendTo( $("#basket_main_div #td_bsmv_list") );
				  });
				  $("#basket_main_div #td_bsmv_list").text( $("#basket_main_div #td_bsmv_list").text().slice( 0, -2 ) );
			  }
		  </cfif>
		  <cfif ListFindNoCase(display_list, "otv_discount")>
			  $("#basket_main_div #td_otv_disc_list").html('<span><cf_get_lang dictionary_id="62820.Ötv İndirimi"></span>');
			  if( totalOTVDiscountAmount.length > 0 ){
				  totalOTVDiscountAmount.forEach(( elm ) => {
					  if( elm.amount != 0 ) $("<span>").append( " " + commaSplit(elm.amount,basket_total_round_number) + ", " ).appendTo( $("#basket_main_div #td_otv_disc_list") );
					  else $("<span>").append( " " + commaSplit(0,basket_total_round_number) + ", " ).appendTo( $("#basket_main_div #td_otv_disc_list") );
				  });
				  $("#basket_main_div #td_otv_disc_list").text( $("#basket_main_div #td_otv_disc_list").text().slice( 0, -2 ) );
			  }
		  </cfif>
		  $("#total_oiv_default").text( commaSplit( oivTotal,basket_total_round_number  ) );
		  $("#total_oiv").val(oivTotal, basket_total_round_number ) ;
  
		  $("#total_bsmv_default").text( commaSplit( bsmvTotal, basket_total_round_number ) );
		  $("#total_bsmv").val( bsmvTotal, basket_total_round_number );

		  $("#total_otv_discount_default").text( commaSplit( OTVDiscountTotal, basket_total_round_number ) );
		  $("#total_otv_discount").val( OTVDiscountTotal, basket_total_round_number );
  
		  toplam_ = toplam_;
		  net_ = net_;
		  indirim_ = (toplam_ - net_);
		  vergi_ = vergi_;
		  otv_vergisi_ = otv_vergisi_;
		  
	  }
	  if(from_new_row_ != undefined && from_new_row_!= ''){
		  toplam_hesapla_in(0,from_new_row_);
	  }
	  else
	  {
		  toplam_hesapla_in(0);
	  }
	  
	  <cfif fusebox.circuit eq 'invoice' or listfind("1,2,3,4,5,6,10,14,18,20,21,33,38,42,43,46,51,52",attributes.basket_id,",")>
		  <cfif ListFindNoCase(display_list, "is_promotion")>
		  function toplam_hesapla_prom(from_sa_amount)
		  {
		  //alert('toplam_hesapla_prom');
		  <!--- proms ind hesabi --->
		  var rowCount = window.basket.items.length;
		  prom_display='<font color="FF0000">Promosyon!</font>';
		  if(!from_sa_amount)
		  {
			  var old_general_prom_discount_ = window.basket.hidden_values.old_general_prom_amount;
			  var old_genel_indirim_ = window.basket.footer.genel_indirim_;
			  if(isNaN(old_general_prom_discount_) || old_general_prom_discount_ == '')
				  old_general_prom_discount_ =0;
			  if(isNaN(old_genel_indirim_) || old_genel_indirim_ == '')
				  old_genel_indirim_ =0;
			  if(window.basket.hidden_values.is_general_prom == 1)
			  {
				  var general_prom_limit = parseFloat($("#basket_main_div #general_prom_limit").val(),price_round_number);
				  if(net_ >= general_prom_limit )
				  {
					  $("#basket_main_div #general_prom_limit").val(wrk_round(net_*filterNumBasket($("#basket_main_div #general_prom_discount").val(),basket_total_round_number)/100,basket_total_round_number));
					  if($("#basket_main_div #general_prom_amount").val().length)
						  var new_genel_indirim_ = (parseFloat(old_genel_indirim_,basket_total_round_number)-parseFloat(old_general_prom_discount_,basket_total_round_number)+parseFloat($("#basket_main_div #general_prom_amount").val(),basket_total_round_number));
					  else
						  var new_genel_indirim_ = (parseFloat(old_genel_indirim_,basket_total_round_number)-parseFloat(old_general_prom_discount_,basket_total_round_number));
					  $("#basket_main_div #genel_indirim_").val(commaSplit(new_genel_indirim_,basket_total_round_number));
				  }
				  else
				  {
					  $("#basket_main_div #general_prom_amount").val(wrk_round(0));
					  $("#basket_main_div #genel_indirim_").val(commaSplit((old_genel_indirim_-old_general_prom_discount_),basket_total_round_number));
				  }
				  var free_prom_limit = parseFloat($("#basket_main_div #free_prom_limit").val());
				  var free_prom_found=0;
				  
				  if($("#basket_main_div #free_prom_stock_id").length != 0)
				  {
					  var v = $("#basket_main_div #free_prom_stock_id").val();
					  for (var counter_=1; counter_ <= rowCount; counter_++)
						  if(window.basket.items[counter_].IS_PROMOTION && $("#basket_main_div #free_prom_stock_id").length != 0 && window.basket.items[counter_].STOCK_ID==v){
						  //if(changeable_value['is_promotion'][counter_] && $("#basket_main_div #free_prom_stock_id").length != 0 && changeable_value['stock_id'][counter_]==v)
							  free_prom_found = counter_;
						  }
  
					  if(net_ >= free_prom_limit && $("#basket_main_div #free_prom_stock_id").length != 0)
					  {
						  var free_price;
						  if(!free_prom_found)
						  {
							  add_free_prom($("#basket_main_div #free_prom_stock_id").val(),$("#basket_main_div #free_prom_id").val(),$("#basket_main_div #free_stock_price").val(),$("#basket_main_div #free_stock_money").val(),$("#basket_main_div #free_prom_amount").val(),1,$("#basket_main_div #free_prom_cost").val());
							  re_toplam_hesapla = 1;
						  }
					  }
					  else
					  {
						  if(free_prom_found > 0)
						  {
							  del_row(free_prom_found + 1);
							  re_toplam_hesapla = 1;
						  }
					  }
  
					  for (var counter_=1; counter_ <= rowCount; counter_++){
						  if(window.basket.items[counter_].IS_PROMOTION!=0)
							  prom_display += '<br/>'+window.basket.items[counter_].AMOUNT +' '+window.basket.items[counter_].UNIT +' '+window.basket.items[counter_].PRODUCT_NAME ;
					  
						  //if(changeable_value['is_promotion'][counter_]!=0)
						  //	prom_display += '<br/>'+changeable_value['amount'][counter_]+' '+changeable_value['unit'][counter_]+' '+changeable_value['product_name'][counter_];
					  }
				  }
			  }
			  else
			  {
				  $("#basket_main_div #general_prom_amount").val(wrk_round(0));
				  $("#basket_main_div #genel_indirim_").val(commaSplit((old_genel_indirim_-old_general_prom_discount_),basket_total_round_number));
				  if($("#basket_main_div #free_prom_id").length != 0 && $("#basket_main_div #free_prom_id").val().length != 0)
				  {
					  for (var counter_=1; counter_ <= rowCount; counter_++)
					  {
						  if(changeable_value['is_promotion'][counter_] && changeable_value['prom_stock_id'][counter_].length==0 && $("#basket_main_div #prom_id"+counter_).val() == $("#basket_main_div #free_prom_id").val())
						  {	
							  del_row(counter_+1);
							  re_toplam_hesapla =1;
						  }
					  }
				  }
				  prom_display ='';
				  }
			  }
			  $("#basket_main_div #old_general_prom_amount").val($("#basket_main_div #general_prom_amount").val());
		  }	
		  toplam_hesapla_prom(from_sa_amount);
		  </cfif>
		  
		  if(findObj('commission_rate') && $("#basket_main_div #commission_rate").length != 0 && $("#basket_main_div #commission_rate").val() != 0)
		  {
			  toplam_hesapla_in(0);
			  if(from_new_row_ != undefined && from_new_row_ != '') //seri urun eklemeden cagrılmıssa komisyon satırını bu asamada arar.
			  {
				  if(rowCount > 1)
				  {
					  for (var counter_= 1; counter_ <= rowCount; counter_++)
					  {
						  if(window.basket.items[counter_-1].IS_COMMISSION == 1)
								  commission_row = counter_;
					  }
				  }
			  }
			  
			  not_com_total = 0;
  
			  for (var counter_= 0; counter_ <= rowCount; counter_++)
			  {
				  if(window.basket.items[counter_].IS_COMMISSION == 0)
				  {
					  
					  var get_prod_control = wrk_safe_query('obj_get_prod_control','dsn3',0,window.basket.items[counter_].PRODUCT_ID);
					  if(get_prod_control.COM_CONTROL == 0)
					  {
						  not_com_total = parseFloat(not_com_total + filterNumBasket(window.basket.items[counter_].ROW_LASTTOTAL,price_round_number));
					  }
					  
				  }
			  }
		  var new_com_total = wrk_round(parseFloat((net_ + vergi_ + otv_vergisi_) - not_com_total),price_round_number);
		  var commission_price = wrk_round(new_com_total*parseFloat($("#basket_main_div #commission_rate").val())/100,price_round_number);
		  if(commission_price) //komisyon bedeli sıfırdan buyukse komisyon satırı ekleniyor
		  {
			  if(commission_row)
			  {
				  add_commission_row(commission_price,1,commission_row); //olan komisyon satırını update eder odeme yontemindeki komisyon bilgilerine gore
			  }
			  else
			  {
				  add_commission_row(commission_price); //yeni komisyon satırı ekler
			  }
		  }
		  else
		  {
			  if(commission_row)
				  del_row(commission_row+1);
		  }
		  re_toplam_hesapla=1;
	  }
	  else if(commission_row)
	  {
		  del_row(commission_row+1);
		  re_toplam_hesapla=1;
	  }
	  if(re_toplam_hesapla!= undefined && re_toplam_hesapla == 1)
		  toplam_hesapla_in(1);
  
	  var sa_percent = 0;
	  var sa_amount = window.basket.footer.genel_indirim_;
	  if(toplam_)
	  {
		  if($("#basket_main_div #genel_indirim_").val().length > 0 && sa_amount > 0 && net_ >= sa_amount)
		  {
			  sa_percent = ( sa_amount/net_ ) * 100;
			  vergi_ = wrk_round((vergi_ * (100-sa_percent)) / 100,basket_total_round_number);
			  otv_vergisi_ = wrk_round((otv_vergisi_ * (100-sa_percent)) / 100,basket_total_round_number);
			  indirim_ = indirim_ + sa_amount;
			  window.basket.hidden_values.genel_indirim = wrk_round(sa_amount,basket_total_round_number);
			  $("#basket_main_div #genel_indirim_").val(commaSplit(sa_amount,basket_total_round_number));
			  net_ = net_ - sa_amount; 
			  for (var mm=0; mm < taxArray.length; mm++)
				  taxTotalArray[mm] = wrk_round((taxTotalArray[mm] * (100-sa_percent)) / 100,basket_total_round_number);
			  for (var zz=0; zz < otvArray.length; zz++)
				  otvTotalArray[zz] = wrk_round((otvTotalArray[zz] * (100-sa_percent)) / 100,basket_total_round_number);
		  }
		  else
		  {
			  window.basket.footer.genel_indirim_ = 0;
			  window.basket.hidden_values.genel_indirim = 0;
			  $("#basket_main_div #genel_indirim_").val(commaSplit(0));
		  }
	  }
	  else
	  {
		  window.basket.footer.genel_indirim_ = 0;
		  window.basket.hidden_values.genel_indirim = 0;
		  $("#basket_main_div #genel_indirim_").val(commaSplit(0));
	  }
	  </cfif>
	  
	  	<cfif fusebox.circuit eq 'invoice' or listfind("1,2,18,20,33,42,43",attributes.basket_id,",")>
			var bey_kdv=0;
			if($("#basket_main_div #tevkifat_oran").length != 0 && $("#basket_main_div #tevkifat_box").is(":checked"))
			{
				var tev_oran = parseFloat(filterNum($("#basket_main_div #tevkifat_oran").val()));
				if($("#basket_main_div #tevkifat_box").is(':checked') && !isNaN(tev_oran) && tev_oran >= 0 && tev_oran <= 100)
				{
					vergi_ = 0;
					tev_kdv_list = '';
					bey_kdv_list = '';
					$("#basket_main_div #tev_kdv_list").css("font-weight", "bold");
					$("#basket_main_div #tev_kdv_list").html('<cf_get_lang dictionary_id="58022.Tevkifat">');
					$("#basket_main_div #bey_kdv_list").css("font-weight", "bold");
					$("#basket_main_div #bey_kdv_list").html('<cf_get_lang dictionary_id="58024.Beyan Edilen">');
					for (var m=0; m < taxArray.length; m++)
					{
						bey_kdv = wrk_round((taxTotalArray[m]*tev_oran),basket_total_round_number);
						vergi_ += bey_kdv;
						tev_kdv_list += '%'+taxArray[m]+' :'+commaSplit(taxTotalArray[m]-bey_kdv,basket_total_round_number)+' ';
						bey_kdv_list += '%'+taxArray[m]+' :'+commaSplit(bey_kdv,basket_total_round_number)+' ';
					}
					$("#basket_main_div #tev_kdv_list").html($("#basket_main_div #tev_kdv_list").html() + tev_kdv_list);
					$("#basket_main_div #bey_kdv_list").html($("#basket_main_div #bey_kdv_list").html() + bey_kdv_list);
				}
				else
				{
					$("#basket_main_div #tevkifat_oran").val('');
					tev_kdv_list.innerHTML = '';
					bey_kdv_list.innerHTML = '';
				}
			}
			else{
				amountTevkifat = vergi_ - tevkifatTotal;
				vergi_ = 0
				basket.items.forEach((el) => {
					vergi_ += el.ROW_TEVKIFAT_AMOUNT != undefined && el.ROW_TEVKIFAT_AMOUNT != 0 ? el.ROW_TEVKIFAT_AMOUNT : el.ROW_TAXTOTAL;
				});
				vergi_ = wrk_round((vergi_ * (100-sa_percent)) / 100,basket_total_round_number);
				tev_kdv_list = '';
				bey_kdv_list = '';
				$("#basket_main_div #tev_kdv_list").css("font-weight", "bold");
				$("#basket_main_div #tev_kdv_list").html('<cf_get_lang dictionary_id="58022.Tevkifat">');
				$("#basket_main_div #bey_kdv_list").css("font-weight", "bold");
				$("#basket_main_div #bey_kdv_list").html('<cf_get_lang dictionary_id="58024.Beyan Edilen">');
				
				for (var m=0; m < taxArray.length; m++)
				{
					tev_kdv_list += '%'+taxArray[m]+' :'+commaSplit(amountTevkifat,basket_total_round_number)+' ';
					bey_kdv_list += '%'+taxArray[m]+' :'+commaSplit(tevkifatTotal,basket_total_round_number)+' ';
				}
				$("#basket_main_div #tev_kdv_list").html($("#basket_main_div #tev_kdv_list").html() + tev_kdv_list);
				$("#basket_main_div #bey_kdv_list").html($("#basket_main_div #bey_kdv_list").html() + bey_kdv_list);
			}
	  </cfif>
	  <cfif listfind('form_copy_bill,form_add_bill,detail_invoice_sale,add_sale_invoice_from_order,form_add_bill_from_ship,form_add_bill_other,detail_invoice_other,form_add_bill_purchase,detail_invoice_purchase,form_copy_bill_purchase,add_purchase_invoice_from_order',fusebox.fuseaction)>
		  stopaj_yuzde_ = filterNum($("#basket_main_div #stopaj_yuzde").val(),basket_total_round_number);
		  if( (stopaj_yuzde_ < 0) || (stopaj_yuzde_ > 99.99) )
		  {
			  alert('<cf_get_lang dictionary_id="32930.Stopaj Oranı"> !');
			  stopaj_yuzde_ = 0;
		  }
		  //stopaj_ = Math.round(net_ * stopaj_yuzde_) / 100;
		  stopaj_ = wrk_round((net_ * stopaj_yuzde_ / 100),basket_total_round_number);
		  $("#basket_main_div #stopaj_yuzde").val(commaSplit( stopaj_yuzde_ ));
		  $("#basket_main_div #stopaj").val(commaSplit( stopaj_ ,basket_total_round_number));
	  <cfelse>
		  stopaj_ = 0;
	  </cfif>
	  vergi_ = wrk_round(vergi_,basket_total_round_number);
	  net_ += vergi_;
	  net_ += otv_vergisi_;
	  net_ += oivTotal;
	  net_ += bsmvTotal;
	  net_ -= OTVDiscountTotal;
	  total_default.innerHTML = commaSplit(toplam_ ,basket_total_round_number);
	  total_discount_default.innerHTML = commaSplit( indirim_ ,basket_total_round_number);
	  total_tax_default.innerHTML = commaSplit( vergi_,basket_total_round_number );
	  <cfif ListFindNoCase(display_list, "OTV")>
		  total_otv_default.innerHTML = commaSplit(otv_vergisi_,basket_total_round_number);
	  </cfif>
	  <cfif listfind('form_copy_bill,form_add_bill,detail_invoice_sale,add_sale_invoice_from_order,form_add_bill_from_ship,form_add_bill_other,detail_invoice_other,form_add_bill_purchase,detail_invoice_purchase,form_copy_bill_purchase,add_purchase_invoice_from_order',fusebox.fuseaction)>
		  net_total_default.innerHTML = commaSplit( (net_-stopaj_),basket_total_round_number);
	  <cfelse>
		  net_total_default.innerHTML = commaSplit( net_,basket_total_round_number);
	  </cfif>
	  $("#basket_main_div #basket_gross_total").val(wrk_round(toplam_,basket_total_round_number));
	  $("#basket_main_div #basket_tax_total").val(wrk_round(vergi_,basket_total_round_number));
	  $("#basket_main_div #basket_otv_total").val(wrk_round(otv_vergisi_,basket_total_round_number));
	  $("#basket_main_div #basket_net_total").val(wrk_round(net_,basket_total_round_number));
	  $("#basket_main_div #basket_discount_total").val(wrk_round(indirim_,basket_total_round_number));
  
	  var counter_ = 0;
	  <cfloop query="get_money_bskt">
		  if(window.basket.footer.basketCurrencyType.length != 0 && window.basket.footer.basketCurrencyType == "<cfoutput>#MONEY_TYPE#</cfoutput>")
		  {
			  rate_flag = true;
			  rate1 = rate1Array[counter_];
			  rate2 = rate2Array[counter_];
			  money_ = moneyArray[counter_];
		  }
		  else if(window.basket.footer.basketCurrencyType == '' && "<cfoutput>#default_basket_money_#</cfoutput>" == "<cfoutput>#MONEY_TYPE#</cfoutput>"){
			  
			  rate_flag = true;
			  rate1 = rate1Array[counter_];
			  rate2 = rate2Array[counter_];
			  money_ = moneyArray[counter_];
		  }
		  counter_ = counter_ + 1;
	  </cfloop>
	  
	  
	  if(!rate_flag)
	  {
		  rate1 = 1;
		  rate2 = 1;
		  money_ = '<cfoutput>#session_base.money#</cfoutput>';
	  }
	  window.basket.footer.basket_money = money_;
	  window.basket.footer.basket_rate1 = rate1;
	  window.basket.footer.basket_rate2 = rate2;
	  
	  $('#basket_money').val(money_);
	  $('#basket_rate1').val(rate1);
	  $('#basket_rate2').val(rate2);
	  
	  if(rate2 != 0)
	  {<!--- dovizli rakamlar set ediliyor ayni degiskenler ustune --->
		  toplam_ = wrk_round(toplam_* rate1/rate2,basket_total_round_number);
		  indirim_ = wrk_round(indirim_*rate1/rate2,basket_total_round_number);
		  vergi_ = wrk_round(vergi_*rate1/rate2,basket_total_round_number);
		  otv_vergisi_ = wrk_round(otv_vergisi_*rate1/rate2,basket_total_round_number);
		  oivTotalCurrency = wrk_round(oivTotal * rate1/rate2,basket_total_round_number);
		  bsmvTotalCurrency = wrk_round(bsmvTotal * rate1/rate2,basket_total_round_number);
		  OTVDiscountTotalCurrency = wrk_round(OTVDiscountTotal * rate1/rate2,basket_total_round_number);
		  <cfif listfind('form_copy_bill,form_add_bill,detail_invoice_sale,add_sale_invoice_from_order,form_add_bill_from_ship,form_add_bill_other,detail_invoice_other,form_add_bill_purchase,detail_invoice_purchase,form_copy_bill_purchase,add_purchase_invoice_from_order',fusebox.fuseaction)>
			  net_ = wrk_round( (net_-stopaj_)*rate1/rate2,basket_total_round_number );
		  <cfelse>
			  net_ = wrk_round( net_*rate1/rate2 ,basket_total_round_number);
		  </cfif>
	  }
	  else
	  {
		  toplam_ = 0;
		  indirim_ = 0;
		  vergi_ = 0;
		  otv_vergisi_ = 0;
		  oivTotalCurrency = 0;
		  bsmvTotalCurrency = 0;
		  OTVDiscountTotalCurrency = 0;
		  net_ = 0;
	  }
	  $("#basket_main_div #total_wanted").html(commaSplit(toplam_,basket_total_round_number));
	  $("#basket_main_div #total_tax_wanted").html(commaSplit(vergi_,basket_total_round_number));
	  <cfif ListFindNoCase(display_list, "OTV")>
		  $("#basket_main_div #total_otv_wanted").html(commaSplit(otv_vergisi_,basket_total_round_number));
	  </cfif>
	  <cfif ListFindNoCase(display_list, "OIV")>
		  $("#basket_main_div #total_oiv_wanted").html(commaSplit(oivTotalCurrency,basket_total_round_number));
	  </cfif>
	  <cfif ListFindNoCase(display_list, "BSMV")>
		  $("#basket_main_div #total_bsmv_wanted").html(commaSplit(bsmvTotalCurrency,basket_total_round_number));
	  </cfif>
	  <cfif ListFindNoCase(display_list, "otv_discount")>
		  $("#basket_main_div #total_otv_discount_wanted").html(commaSplit(OTVDiscountTotalCurrency,basket_total_round_number));
	  </cfif>
	  $("#basket_main_div #total_discount_wanted").html(commaSplit(indirim_ ,basket_total_round_number));
	  $("#basket_main_div #net_total_wanted").html(commaSplit(net_ ,basket_total_round_number));
	  $("#basket_main_div #td_kdv_list").css("font-weight", "bold");
	  $("#basket_main_div #td_kdv_list").html('');
	  kdv_str_ = '';
	  for (var m=0; m < taxArray.length; m++)
		  kdv_str_ += '<cf_get_lang dictionary_id="57639.KDV"> % ' + taxArray[m] + ' : ' + commaSplit( taxTotalArray[m],basket_total_round_number) + ' ';
	  $("#basket_main_div #td_kdv_list").html(kdv_str_);
	  <cfif ListFindNoCase(display_list, "OTV")>
		  otv_str = '';
		  $("#basket_main_div #td_otv_list").css("font-weight", "bold");
		  $("#basket_main_div #td_otv_list").html('');
		  for (var jj=0; jj < otvArray.length; jj++)
		  	  <cfif otv_calc_type_ eq 0>
			  	  otv_str += '<cf_get_lang dictionary_id="58021.ÖTV"> % ' + otvArray[jj] + ' : ' + commaSplit( otvTotalArray[jj],basket_total_round_number) + ' ';
			  <cfelse>
				  otv_str += '<cf_get_lang dictionary_id="58021.ÖTV"> ' + otvArray[jj] + " " + window.basket.items[jj].OTHER_MONEY + ' : ' + commaSplit( otvTotalArray[jj],basket_total_round_number) + ' ';
			  </cfif>
		  $("#basket_main_div #td_otv_list").html(otv_str);		
	  </cfif>
  
	  <cfif listfind("1,2,20,42,43",attributes.basket_id,",")>
		  if($("#basket_main_div #yuvarlama").length != 0) basket_yuvarlama_ = $("#basket_main_div #yuvarlama").val(); else basket_yuvarlama_ = 0;
		  <!--- //Eger yuvarlama islemi var ise. --->
		  if($("#basket_main_div #basket_net_total").val() != '')
		  {
			  var flt_value = parseFloat($("#basket_main_div #basket_net_total").val()-stopaj_,basket_total_round_number);
			  if($("#basket_main_div #yuvarlama").length != 0)
				  flt_value += filterNum(basket_yuvarlama_,basket_total_round_number);
			  $("#basket_main_div #net_total_default").html(commaSplit(flt_value,basket_total_round_number));
			  $("#basket_main_div #basket_net_total").val(flt_value);
			  $("#basket_main_div #net_total_wanted").html(commaSplit(flt_value*rate1/rate2,basket_total_round_number));
			  if($("#basket_main_div #yuvarlama").length != 0)
				  $("#basket_main_div #yuvarlama").val(commaSplit(filterNum($("#basket_main_div #yuvarlama").val(),basket_total_round_number),basket_total_round_number ));
		  }
		  else{$("#basket_main_div #yuvarlama").val(0);}
	  </cfif>
  
	  <cfif ListFindNoCase(display_list, "is_promotion")>
		  if(!from_sa_amount) $("#basket_main_div #basket_proms").html(prom_display);
	  </cfif>
	  <cfif ListFindNoCase(display_list,'duedate')>
		  set_paper_duedate();//satır vadelerine baglı olarak belge ortalama vadesini hesaplar
	  </cfif>
	  <cfif attributes.basket_id eq 51 and (not isdefined("kontrol_form_update") or (isdefined("kontrol_form_update") and kontrol_form_update eq 0))><!--- kontrol_form_update tahsilatı değişen siparişlerin sadece sipariş kısmını güncellemek için eklendi 1 ise senet oluşmuyor --->
		  add_voucher_row(is_from_upd);
	  </cfif>
	  <cfif attributes.basket_id eq 52>
		  toplam_tahsilat();
	  </cfif>
	  <cfif ListFindNoCase(display_list,'is_risc')> //display_member_risk.cfm 'de olan bi function, risk bilgisi seciliyse dosya include ediliyor
		  toplam_limit_hesapla();
	  </cfif>
	  <cfif isdefined('attributes.is_retail')>
		  if(typeof(genel_kontrol) != 'undefined') //perakende faturası icin tanımlı geliyor
			  genel_kontrol();
	  </cfif>
	  if(from_sa_amount == 0)
	  {
		  kdvsiz_doviz_indirim_hesapla();
		  kdvli_doviz_indirim_hesapla();
	  }
	  
	  //kdvsiz toplam hesabi 08012013 YO YO
	  dusulecek_vergi_default = parseFloat(filterNum($("#basket_main_div #total_tax_default").html(),basket_total_round_number));
	  dusulecek_vergi_wanted = parseFloat(filterNum($("#basket_main_div #total_tax_wanted").html(),basket_total_round_number));
	  brut_basket_toplam_default = filterNum($("#basket_main_div #net_total_default").html(),basket_total_round_number);
	  brut_basket_toplam_wanted = filterNum($("#basket_main_div #net_total_wanted").html(),basket_total_round_number);
	  <cfif ListFindNoCase(display_list, "OTV")>
		  dusulecek_vergi_default += parseFloat(filterNum($("#basket_main_div #total_otv_default").html(),basket_total_round_number));
		  dusulecek_vergi_wanted += parseFloat(filterNum($("#basket_main_div #total_otv_wanted").html(),basket_total_round_number));
	  </cfif>
	  <cfif ListFindNoCase(display_list, "OIV")>
		  dusulecek_vergi_default += oivTotal; 
		  dusulecek_vergi_wanted += oivTotalCurrency; 
	  </cfif>
	  <cfif ListFindNoCase(display_list, "BSMV")>
		  dusulecek_vergi_default += bsmvTotal; 
		  dusulecek_vergi_wanted += bsmvTotalCurrency; 
	  </cfif>
	  <cfif ListFindNoCase(display_list, "otv_discount")>
		  dusulecek_vergi_default -= OTVDiscountTotal; 
		  dusulecek_vergi_wanted -= OTVDiscountTotalCurrency; 
	  </cfif>
  
	  brut_basket_toplam_default = parseFloat(brut_basket_toplam_default) - parseFloat(dusulecek_vergi_default);
	  brut_basket_toplam_wanted = parseFloat(brut_basket_toplam_wanted) - parseFloat(dusulecek_vergi_wanted);
  
	  $("#basket_main_div #brut_total_default").html(commaSplit(brut_basket_toplam_default,basket_total_round_number));
	  $("#basket_main_div #brut_total_wanted").html(commaSplit(brut_basket_toplam_wanted,basket_total_round_number));
	  
	  return true;	
  }
  function add_basket_row(product_id, stock_id, stock_code, barcod, manufact_code, product_name, unit_id_, unit_, spect_id, spect_name, price, price_other,tax, duedate, d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, deliver_date, deliver_dept, department_head, lot_no, money, row_ship_id,amount_, product_account_code, is_inventory,is_production,net_maliyet,flt_marj,extra_cost,row_promotion_id,promosyon_yuzde,promosyon_maliyet,iskonto_tutar,is_promotion,prom_stock_id,otv,product_name_other,amount_other,unit_other,ek_tutar,shelf_number,row_unique_relation_id,row_catalog_id,toplam_hesap_yap,is_commission,basket_extra_info,prom_relation_id,reserve_date,list_price,number_of_installment,price_cat,karma_product_id,row_service_id,ek_tutar_price,wrk_row_relation_id,related_action_id,related_action_table,row_width,row_depth,row_height,to_shelf_number,row_project_id,row_project_name,row_otv_amount,action_window_name,row_paymethod_id,special_code,basket_employee_id,basket_employee,row_work_id,row_work_name, row_exp_center_id, row_exp_center_name, row_exp_item_id, row_exp_item_name, row_acc_code,select_info_extra,detail_info_extra,gtip_number,row_activity_id,row_subscription_id,row_subscription_name,row_assetp_id,row_assetp_name,row_bsmv_rate,row_bsmv_amount,row_bsmv_currency,row_oiv_rate,row_oiv_amount,row_tevkifat_rate,row_tevkifat_amount,reason_code_info,nosum,otv_type_info,otv_discount)
  {
	  //addBasketItem();
	  //showBasketItems();
	  /*
	  console.log('product_id:'+product_id+ 'stock_id:'+stock_id+' stock_code:'+stock_code+ ' barcod:'+barcod+' manufact_code:'+manufact_code+ ' product_name:'+product_name);
	  console.log('unit_id_:'+unit_id_+ 'unit_:'+unit_+' spect_id:'+spect_id+ ' spect_name:'+spect_name+' price:'+price+ ' price_other:'+price_other);
	  console.log('tax:'+tax+ 'duedate:'+duedate+' d1:'+d1+ ' d2:'+d2+' d3:'+d3+ ' d4:'+d4);
	  console.log('d5:'+d5+ 'd6:'+d6+' d7:'+d7+ ' d8:'+d8+' d9:'+d9+ ' d10:'+d10);
	  console.log('deliver_date:'+deliver_date+ 'deliver_dept:'+deliver_dept+' department_head:'+department_head+ ' lot_no:'+lot_no+' money:'+money+ ' row_ship_id:'+row_ship_id);
	  
	  console.log('amount_:'+amount_+ 'product_account_code:'+product_account_code+' is_inventory:'+is_inventory+ ' is_production:'+is_production+' net_maliyet:'+net_maliyet+ ' flt_marj:'+flt_marj);
	  console.log('extra_cost:'+extra_cost+ 'row_promotion_id:'+row_promotion_id+' promosyon_yuzde:'+promosyon_yuzde+ ' promosyon_maliyet:'+promosyon_maliyet+' iskonto_tutar:'+iskonto_tutar+ ' is_promotion:'+is_promotion);
	  console.log('tax:'+tax+ 'duedate:'+duedate+' d1:'+d1+ ' d2:'+d2+' d3:'+d3+ ' d4:'+d4);
	  console.log('prom_stock_id:'+prom_stock_id+ 'otv:'+otv+' product_name_other:'+product_name_other+ ' amount_other:'+amount_other+' unit_other:'+unit_other+ ' ek_tutar:'+ek_tutar);
	  console.log('shelf_number:'+shelf_number+ 'row_unique_relation_id:'+row_unique_relation_id+' row_catalog_id:'+row_catalog_id+ ' toplam_hesap_yap:'+toplam_hesap_yap+' is_commission:'+is_commission+ ' basket_extra_info:'+basket_extra_info);
	  
	  console.log('prom_relation_id:'+prom_relation_id+ 'reserve_date:'+reserve_date+' list_price:'+list_price+ ' number_of_installment:'+number_of_installment+' price_cat:'+price_cat+ ' karma_product_id:'+karma_product_id);
	  console.log('row_service_id:'+row_service_id+ 'ek_tutar_price:'+ek_tutar_price+' wrk_row_relation_id:'+wrk_row_relation_id+ ' related_action_id:'+related_action_id+' related_action_table:'+related_action_table+ ' row_width:'+row_width);
	  console.log('row_depth:'+row_depth+ 'row_height:'+row_height+' to_shelf_number:'+to_shelf_number+ ' row_project_id:'+row_project_id+' row_project_name:'+row_project_name+ ' row_otv_amount:'+row_otv_amount);
	  console.log('action_window_name:'+action_window_name+ 'row_paymethod_id:'+row_paymethod_id+' special_code:'+special_code+ ' basket_employee_id:'+basket_employee_id+' basket_employee:'+basket_employee+ ' row_work_id:'+row_work_id);
	  console.log('row_work_name:'+row_work_name+ 'row_exp_center_id:'+row_exp_center_id+' row_exp_center_name:'+row_exp_center_name+ ' row_exp_item_id:'+row_exp_item_id+' row_exp_item_name:'+row_exp_item_name+ ' row_acc_code:'+row_acc_code);
	  */
	  otv = (otv && otv != '') ? otv : 0;
	  if(action_window_name != undefined && action_window_name != '' && action_window_name != basket_unique_code)
	  {
		  alert('Çalıştığınız Ekran Mevcut Sepet İle Uyumlu Değil!\nFiyat Listesi Ekranınızı Yenilemelisiniz!');
		  return false;
	  }
	  
	  var ek_tutar = 0;
	  var ek_tutar_system = 0;
	  var ek_tutar_marj = 0;
	  var ek_tutar_cost = 0;
	  var ek_tutar_other_total = 0;
	  var row_cost_total_ = 0;
	  var indirim_carpan = (100-d1) * (100-d2) * (100-d3) * (100-d4) * (100-d5) * (100-d6) * (100-d7) * (100-d8) * (100-d9) * (100-d10);
	  var price_net = price;
	  if(isNaN(amount_) || amount_==0) var amount_ = 1;
	  if(isNaN(price_cat)) var price_cat='';
	  if(isNaN(ek_tutar_price) || ek_tutar_price.length == 0) var ek_tutar_price = 0;
	  if(isNaN(list_price) || list_price =='') var list_price = price;/*sadece bilgi amaclı tutuluyor, urun eklenirken kullanılan ilk fiyat bilgisini tutmak icin*/
	  if(isNaN(list_price_) || list_price_ =='') var list_price_ = price;/*sadece bilgi amaclı tutuluyor, urun eklenirken kullanılan ilk fiyat bilgisini tutmak icin*/
	  if(isNaN(number_of_installment) || number_of_installment =='') var number_of_installment=0;
	  if(isNaN(row_width)) var row_width='';
	  if(isNaN(price_other)) var price_other=0;
	  if(isNaN(flt_marj) || flt_marj == '') var flt_marj=0;
	  if(isNaN(row_depth)) var row_depth='';
	  if(isNaN(row_height)) var row_height='';
	  if(isNaN(to_shelf_number)) var to_shelf_number='';
	  if(isNaN(karma_product_id)) var karma_product_id='';
	  if(isNaN(row_project_id)) var row_project_id='';
	  if(isNaN(row_work_id)) var row_work_id='';
	  if(isNaN(row_exp_center_id)) var row_exp_center_id='';
	  if(isNaN(row_exp_item_id)) var row_exp_item_id='';
	  if(!iskonto_tutar) var iskonto_tutar = 0;
	  if(row_paymethod_id==undefined) var row_paymethod_id='';
	  if(row_project_name==undefined) var row_project_name='';
	  if(row_work_name==undefined) var row_work_name='';
	  if(row_exp_center_name==undefined) var row_exp_center_name='';
	  if(row_exp_item_name==undefined) var row_exp_item_name='';
	  if(row_acc_code==undefined) var row_acc_code='';
	  if(prom_relation_id == undefined) var prom_relation_id='';
	  if(row_service_id == undefined) var row_service_id = '';
	  if(wrk_row_relation_id==undefined) wrk_row_relation_id='';
	  if(special_code==undefined) special_code='';
	  if(basket_employee_id==undefined) basket_employee_id='';
	  if(basket_employee==undefined) basket_employee='';
	  if(otv_type_info==undefined) otv_type_info='';
	  if(otv_discount==undefined) otv_discount='';
  
	  <cfif session.ep.period_year gte 2009>
		  if(money!= undefined && money=='YTL')
			  money='<cfoutput>#session.ep.money#</cfoutput>'; //onceki donemden ytl cekilip yeni isleme eklenecek satırlar tl ye cevriliyor
	  <cfelseif session.ep.period_year lt 2009>
		  if(money!= undefined && money=='TL')
			  money='<cfoutput>#session.ep.money#</cfoutput>'; //onceki donemden tl cekilip yeni isleme eklenecek satırlar ytl ye cevriliyor
	  </cfif>
  
	  if(row_project_id != '' && row_project_name == '') //sadece proje_id gonderilmisse proje ismi cekilir
	  {
		  var get_pro_name =wrk_safe_query('obj_get_pro_name','dsn',0,row_project_id);
		  if(get_pro_name.recordcount)
			  row_project_name = String(get_pro_name.PROJECT_HEAD);
	  }
	  if(row_work_id != '' && row_work_name == '') //sadece work_id gonderilmisse work ismi cekilir
	  {
		  var get_work_name =wrk_safe_query('obj_get_work_name','dsn',0,row_work_id);
		  if(get_work_name.recordcount)
			  row_work_name = String(get_work_name.WORK_HEAD);
	  }
	  if(isNaN(amount_other) || amount_other =='') var amount_other=1;
	  if(ek_tutar_price != '' && ek_tutar_price != 0) //iscilik birim ucreti gonderilmisse ek_tutar ve ek_tutar_marj bu degerden hesaplanır
	  {
		  if(isNaN(amount_other)) var amount_other=1;
		  ek_tutar_cost = ek_tutar_price * amount_other;
		  if(ek_tutar != '' && ek_tutar != 0)	ek_tutar_marj=((ek_tutar*100)/ek_tutar_cost)-100;
		  else ek_tutar=ek_tutar_cost;
	  }
	  
	  if((iskonto_tutar!='') || (ek_tutar != '' && ek_tutar != 0))<!---  iskonto_tutar her zaman satir doviz cinsinden oldugundan yerel degerini bularak dusuyoruz--->
	  {	
		  var moneyArraylen=moneyArray.length;
		  for(var mon_i=0; mon_i<moneyArraylen; mon_i++)
			  if(moneyArray[mon_i]==money)
			  {
				  price_net  -= iskonto_tutar * rate2Array[mon_i]/rate1Array[mon_i];
				  price_net  += ek_tutar * rate2Array[mon_i]/rate1Array[mon_i]; <!--- ek tutar her zaman satir doviz cinsinden oldugundan yerel degerini bularak ekliyoruz --->
				  ek_tutar_system = ek_tutar * rate2Array[mon_i]/rate1Array[mon_i];
			  }
	  }
	  if(promosyon_yuzde!='') price_net -= price_net * promosyon_yuzde/100;
	  price_net = wrk_round(price_net*indirim_carpan/100000000000000000000,price_round_number);
	  var net_total = wrk_round((price_net*amount_),price_round_number); //kdv bu tutar uzerinden hesaplandıgı icin basket functionlarında net_total formatlandıgı halde onceden wrk_roundan geciriyoruz.
	  var ek_tutar_total_ = wrk_round((ek_tutar_system*amount_),price_round_number)
	  if(isNaN(row_otv_amount) || row_otv_amount == undefined || row_otv_amount == '')
	  {
		  var row_otv_total = net_total*otv/100;
	  }
	  else
		  var row_otv_total = row_otv_amount;
  
	  <cfif ListFindNoCase(display_list, "otv_from_tax_price")> //otv, kdv matrahına ekleniyor
		  var row_tax_total = (net_total+row_otv_total)*tax/100;
	  <cfelse>
		  var row_tax_total = net_total*tax/100
	  </cfif>
	  var price_net_doviz = price_other;
	  if(iskonto_tutar!='') price_net_doviz -=iskonto_tutar;
	  if(ek_tutar!='' && ek_tutar != 0)
	  {
		  price_net_doviz = (parseFloat(price_net_doviz)+parseFloat(ek_tutar));/*satır doviz toplamına ek tutarda katılıyor*/
		  ek_tutar_other_total = ek_tutar* amount_;
	  }
	  temp_wrk_row_id= 'WRK'+js_create_unique_id();
	  if(reserve_date == undefined) reserve_date='';
	  if(row_catalog_id == undefined) var row_catalog_id='';
	  if(related_action_id == undefined) var related_action_id='';
	  if(related_action_table == undefined) var related_action_table='';
	  if(promosyon_yuzde!='') price_net_doviz -= price_net_doviz*promosyon_yuzde/100;
	  price_net_doviz = wrk_round(price_net_doviz*indirim_carpan/100000000000000000000,price_round_number);
	  var other_money_value_ = parseFloat(price_net_doviz)*parseFloat(amount_);
	  var row_total_ = (parseFloat(price)+parseFloat(ek_tutar_system))*amount_;
	  var tax_total = (net_total + row_tax_total + row_otv_total)/amount_;
	  var row_lasttotal = net_total + row_tax_total + row_otv_total;
	  var other_money_gross_total = other_money_value_ * (100 + (parseFloat(tax) + (parseFloat(otv) * parseFloat(tax)/100))+parseFloat(otv))/100;
	  
	  if(net_maliyet!='' && net_maliyet!=0 && extra_cost!='')
		  var extra_cost_rate_ = (parseFloat(extra_cost)/parseFloat(net_maliyet)) * 100;
	  else
		  var extra_cost_rate_ = 0;
	  
	  if(net_maliyet != '' && net_maliyet != 0)
		  row_cost_total_ +=parseFloat(net_maliyet);
	  if(extra_cost != '' && extra_cost != 0)
		  row_cost_total_ +=parseFloat(extra_cost);
	  
	  <cfif ListFindNoCase(display_list,"amount")>
		  darali_ = amount_;
	  <cfelse>
		  darali_ = 1;
	  </cfif>
	  
	  var get_product_unit = wrk_safe_query('prdp_get_unit2_all','dsn3',0,product_id);
	  unit2_extra = '';
	  for(var kk=0;kk<get_product_unit.recordcount;kk++)
	  {
		  if(get_product_unit.ADD_UNIT[kk] == unit_other)
			  var selected_ = 'selected="selected"';
		  else
			  var selected_ = '';
		  unit2_extra = unit2_extra + "<option value='"+get_product_unit.ADD_UNIT[kk]+"' "+selected_+">"+get_product_unit.CRR_UNIT[kk]+"</option>";
	  }
  
	  if(shelf_number != undefined && shelf_number != '')
	  {/* raf id sine baglı olarak raf kodu getiriliyor */
		  var get_shelf_name =wrk_safe_query('obj_get_shelf_name','dsn3',0,shelf_number);
		  if(get_shelf_name.recordcount && get_shelf_name.SHELF_CODE != '')
			  var temp_shelf_number_ = String(get_shelf_name.SHELF_CODE);
		  else
			  var temp_shelf_number_ = '';
	  }
	  else
		  var temp_shelf_number_ = '';
  
	  if(to_shelf_number != undefined && to_shelf_number != '')
	  {/* raf id sine baglı olarak raf kodu getiriliyor */
		  var get_shelf_name = wrk_safe_query('obj_get_shelf_name','dsn3',0,to_shelf_number);
		  if(get_shelf_name.recordcount && get_shelf_name.SHELF_CODE != '')
			  var temp_shelf_number2_ = String(get_shelf_name.SHELF_CODE);
		  else
			  var temp_shelf_number2_ = '';
	  }
	  else
		  var temp_shelf_number2_ = '';
  
	  other_money_options = '';
	  <cfoutput>
		  <cfloop query="get_money_bskt">
			  if('#money_type#' == money)
				  other_money_options = other_money_options + '<option value="#money_type#" selected="selected">#money_type#</option>'
			  else
				  other_money_options = other_money_options + '<option value="#money_type#">#money_type#</option>'
		  </cfloop>
	  </cfoutput>	
  
	  basket_extra_info_ = '';
	  <cfoutput>
		  <cfloop list="#basket_info_list#" index="info_list">
			  if('#ListFirst(info_list,";")#' == basket_extra_info)
				  basket_extra_info_ = basket_extra_info_ + '<option value="#ListFirst(info_list,";")#" selected="selected">#ListLast(info_list,";")#</option>'
			  else
				  basket_extra_info_ = basket_extra_info_ + '<option value="#ListFirst(info_list,";")#">#ListLast(info_list,";")#</option>'
		  </cfloop>
	  </cfoutput>
  
	  select_info_extra_ = '';
	  <cfoutput>
		  <cfloop list="#select_info_extra_list#" index="extra_list">
			  if('#ListFirst(extra_list,";")#' == select_info_extra)
				  select_info_extra_ = select_info_extra_ + '<option value="#ListFirst(extra_list,";")#" selected="selected">#ListLast(extra_list,";")#</option>'
			  else
				  select_info_extra_ = select_info_extra_ + '<option value="#ListFirst(extra_list,";")#">#ListLast(extra_list,";")#</option>'
		  </cfloop>
	  </cfoutput>
  
	  detail_info_extra = '';
		  
	  reason_code_info_ = '<cfoutput><cfset current_row = 0><cfloop list="#reason_code_list#" index="info_list" delimiters="*"><cfset current_row = current_row + 1><option value="#listlast(info_list,"*")#">#listlast(info_list,"*")#</option></cfloop></cfoutput>';
	  reason_code_info = ( reason_code_info != '' ) ? reason_code_info : '';

	  otv_type_info_ = '<option value="0">İndirim Yok</option><option value="1">Tam İndirim</option>';
	  otv_type_info = ( otv_type_info != '' ) ? otv_type_info : '';
	  otv_discount = ( otv_discount != '' ) ? otv_discount : 0;
	  
	  delivery_condition_info_ = '<cfoutput><option value"">#getLang("main",322)#</option><cfloop query="delivery_condition"><option value="#delivery_condition.code#">#delivery_condition.code#-#delivery_condition.name#</option></cfloop></cfoutput>';
	  delivery_condition_info = '';
	  
	  container_type_info_ = '<cfoutput><option value"">#getLang("main",322)#</option><cfloop query="container_type"><option value="#container_type.code#">#container_type.code#-#container_type.name#</option></cfloop></cfoutput>';
	  container_type_info = '';
	  
	  delivery_type_info_ = '<cfoutput><option value"">#getLang("main",322)#</option><cfloop query="delivery_type"><option value="#delivery_type.code#">#delivery_type.code#-#delivery_type.name#</option></cfloop></cfoutput>';
	  delivery_type_info = '';
  
	  container_number = '';
	  container_quantity = '';
	  delivery_country = '';
	  delivery_city = '';
	  delivery_county = '';
  
	  is_serial_no = '';
	  
	  row_activity_id_info_ = '<cfoutput><option value="">#getLang("main",322)#</option><cfloop query="getActivity"><option value="#ACTIVITY_ID#">#ACTIVITY_NAME#</option></cfloop></cfoutput>';
	  row_subscription_id = row_subscription_name = row_assetp_id = row_assetp_name = '';
	  row_activity_id = (row_activity_id != '') ? row_activity_id : '';
	  row_bsmv_rate = (row_bsmv_rate != '') ? row_bsmv_rate : 0;
	  row_oiv_rate = (row_oiv_rate != '') ? row_oiv_rate : 0;
	  row_bsmv_currency  = row_oiv_amount = row_tevkifat_rate = row_tevkifat_amount = 0.0;
  
	  reserve_type_list = '<cfoutput><cfset current_row = 0><cfloop list="#reserve_type_list#" index="info_list"><cfset current_row = current_row + 1><option value="#-1*current_row#">#listlast(info_list,";")#</option></cfloop></cfoutput>';
	  order_currency_list = '<cfoutput><cfset current_row = 0><cfloop list="#order_currency_list#" index="info_list"><cfset current_row = current_row + 1><option value="#-1*current_row#">#replace(listlast(info_list,";"),"'","\'","all")#</option></cfloop></cfoutput>';
	  <cfif listfind("11,12,47,48,1,20,2,18,31,32,11,15,17,47,49,10",attributes.basket_id,",") and (attributes.fuseaction contains 'add' or (isdefined("attributes.event") and attributes.event is 'add'))><!--- seri no ekleme sayfası açılacak --->
		  my_serial_ctrl = wrk_safe_query('chk_product_serial1','dsn3',0,product_id);
		  is_serial_no = my_serial_ctrl.IS_SERIAL_NO[0];
	  </cfif>
	  
	  if(!is_promotion)
	  	is_promotion = 0;
  
	  newRowNumber = window.basket.items.length - 1;
	  window.basket.items.push({
		  PRODUCT_ID : parseFloat(product_id),
		  ACTION_ROW_ID : 0,
		  WRK_ROW_ID : temp_wrk_row_id,
		  WRK_ROW_RELATION_ID : wrk_row_relation_id,
		  RELATED_ACTION_ID : related_action_id,
		  RELATED_ACTION_TABLE : related_action_table,
		  KARMA_PRODUCT_ID : karma_product_id,
		  IS_INVENTORY : parseFloat(is_inventory),
		  ROW_PAYMETHOD_ID : row_paymethod_id,
		  IS_PRODUCTION : parseFloat(is_production),
		  PRICE_CAT : price_cat,
		  STOCK_ID : parseFloat(stock_id),
		  UNIT_ID : parseFloat(unit_id_),
		  ROW_SHIP_ID : row_ship_id,
		  IS_PROMOTION : parseFloat(is_promotion),
		  PROM_STOCK_ID : prom_stock_id,
		  ROW_PROMOTION_ID : row_promotion_id,
		  ROW_SERVICE_ID : row_service_id,
		  ROW_UNIQUE_RELATION_ID : row_unique_relation_id,
		  ROW_CATALOG_ID : row_catalog_id,
		  PROM_RELATION_ID : prom_relation_id,
		  INDIRIM_TOTAL : indirim_carpan,
		  INDIRIM_CARPAN : indirim_carpan,
		  EK_TUTAR_TOTAL : ek_tutar_total_,
		  IS_COSMISSION : is_commission,
		  STOCK_CODE : stock_code,
		  BARCODE : barcod,
		  SPECIAL_CODE : special_code,
		  MANUFACT_CODE : manufact_code,
		  PRODUCT_NAME : product_name,
		  UNIT : unit_,
		  PRODUCT_NAME_OTHER : product_name_other,
		  CONTAINER_NUMBER : container_number,
		  CONTAINER_QUANTITY : container_quantity,
		  DELIVERY_COUNTRY : delivery_country,
		  DELIVERY_CITY : delivery_city,
		  DELIVERY_COUNTY : delivery_county,
		  GTIP_NUMBER : gtip_number,
		  AMOUNT : parseFloat(amount_),
		  AMOUNT_OTHER : parseFloat(amount_other),
		  UNIT2_EXTRA : unit2_extra,
		  UNIT_OTHER : unit_other,
		  EK_TUTAR : parseFloat(ek_tutar),
		  EK_TUTAR_PRICE : parseFloat(ek_tutar_price),
		  EK_TUTAR_COST : parseFloat(ek_tutar_cost),
		  EK_TUTAR_MARJ : parseFloat(ek_tutar_marj),
		  EK_TUTAR_OTHER_TOTAL : parseFloat(ek_tutar_other_total),
		  <!--- spec'e bakilacak --->
		  SPECT_ID : spect_id,
		  SPECT_NAME : spect_name,
		  LIST_PRICE : parseFloat(list_price),
		  LIST_PRICE_DISCOUNT : '',
		  TAX_PRICE : parseFloat(tax_total),
		  PRICE : parseFloat(price),
		  PRICE_OTHER : parseFloat(price_other),
		  PRICE_NET : parseFloat(price_net),
		  PRICE_NET_DOVIZ : parseFloat(price_net_doviz),
		  TAX : parseFloat(tax),
		  TAX_PERCENT : parseFloat(tax),
		  OTV : parseFloat(otv),
		  OTV_ORAN : parseFloat(otv),
		  DUEDATE : duedate,
		  NUMBER_OF_INSTALLMENT : number_of_installment,
		  ISKONTO_TUTAR : parseFloat(iskonto_tutar),
		  INDIRIM1 : parseFloat(d1),
		  INDIRIM2 : parseFloat(d2),
		  INDIRIM3 : parseFloat(d3),
		  INDIRIM4 : parseFloat(d4),
		  INDIRIM5 : parseFloat(d5),
		  INDIRIM6 : parseFloat(d6),
		  INDIRIM7 : parseFloat(d7),
		  INDIRIM8 : parseFloat(d8),
		  INDIRIM9 : parseFloat(d9),
		  INDIRIM10 : parseFloat(d10),
		  ROW_TOTAL : row_total_,
		  ROW_NETTOTAL : net_total,
		  ROW_TAXTOTAL : row_tax_total,
		  ROW_OTVTOTAL : row_otv_total,
		  ROW_LASTTOTAL : row_lasttotal,
		  OTHER_MONEY : money,
		  OTHER_MONEY_OPTIONS : other_money_options,
		  <!--- other_money'e bakılacak. --->
		  OTHER_MONEY_VALUE : other_money_value_,
		  OTHER_MONEY_GROSSTOTAL : other_money_gross_total,
		  DELIVER_DATE : deliver_date,
		  RESERVE_DATE : reserve_date,
		  DELIVER_DEPT : deliver_dept,
		  BASKET_ROW_DEPARTMENT : department_head,
		  <!--- deliver_dept_assortment'e bakılacak. --->
		  SHELF_NUMBER : shelf_number,
		  SHELF_NUMBER_TXT : temp_shelf_number_,
		  PBS_ID : '',
		  PBS_CODE :'',
		  TO_SHELF_NUMBER : to_shelf_number,
		  TO_SHELF_NUMBER_TXT : temp_shelf_number2_,
		  IS_PARSE : '',
		  LOT_NO : lot_no,
		  NET_MALIYET : net_maliyet,
		  MARJ : parseFloat(flt_marj),
		  EXTRA_COST : parseFloat(extra_cost),
		  EXTRA_COST_RATE : parseFloat(extra_cost_rate_),
		  ROW_COST_TOTAL : parseFloat(row_cost_total_),
		  DARA : 0,
		  DARALI : darali_,
		  PROMOSYON_YUZDE : promosyon_yuzde,
		  PROMOSYON_MALIYET : promosyon_maliyet,
		  <!--- order_currency'e bakılacak. --->
		  <!--- reserve_type'a bakılacak. --->
		  ROW_WIDTH : row_width,
		  ROW_DEPTH : row_depth,
		  ROW_HEIGHT : row_height,
		  BASKET_EXTRA_INFO_ : basket_extra_info_,
		  BASKET_EXTRA_INFO : basket_extra_info,
		  SELECT_INFO_EXTRA_ : select_info_extra_,
		  SELECT_INFO_EXTRA : select_info_extra,
		  DETAIL_INFO_EXTRA : detail_info_extra,
		  BASKET_EMPLOYEE : basket_employee,
		  BASKET_EMPLOYEE_ID : basket_employee_id,
		  ROW_PROJECT_ID : row_project_id,
		  ROW_PROJECT_NAME : row_project_name,
		  ROW_WORK_ID : row_work_id,
		  ROW_WORK_NAME : row_work_name,
		  ROW_EXP_CENTER_ID : row_exp_center_id,
		  ROW_EXP_CENTER_NAME : row_exp_center_name,
		  ROW_ACTIVITY_ID : row_activity_id,
		  ROW_ACTIVITY_ID_INFO_ : row_activity_id_info_,
		  ROW_EXP_ITEM_ID : row_exp_item_id,
		  ROW_EXP_ITEM_NAME : row_exp_item_name,
		  ROW_ACC_CODE : row_acc_code,
		  ROW_SUBSCRIPTION_ID : row_subscription_id,
		  ROW_SUBSCRIPTION_NAME : row_subscription_name,
		  ROW_ASSETP_ID : row_assetp_id,
		  ROW_ASSETP_NAME : row_assetp_name,
		  ROW_BSMV_RATE : row_bsmv_rate,
		  ROW_BSMV_AMOUNT : row_bsmv_amount,
		  ROW_BSMV_CURRENCY : row_bsmv_currency,
		  ROW_OIV_RATE : row_oiv_rate,
		  ROW_OIV_AMOUNT : row_oiv_amount,
		  ROW_TEVKIFAT_RATE : row_tevkifat_rate,
		  ROW_TEVKIFAT_AMOUNT : row_tevkifat_amount,
		  RESERVE_TYPE_LIST : reserve_type_list,
		  RESERVE_TYPE : -1,
		  ORDER_CURRENCY_LIST : order_currency_list,
		  ORDER_CURRENCY : -1,
		  REASON_CODE_INFO_ : reason_code_info_,
		  REASON_CODE : reason_code_info,
		  OTV_TYPE_INFO_ : otv_type_info_,
		  OTV_TYPE : otv_type_info,
		  OTV_DISCOUNT : parseFloat(otv_discount),
		  DELIVERY_CONDITION_INFO_ : delivery_condition_info_,
		  DELIVERY_CONDITION : delivery_condition_info,
		  CONTAINER_TYPE_INFO_ : container_type_info_,
		  CONTAINER_TYPE : container_type_info,
		  DELIVERY_TYPE_INFO_ : delivery_type_info_,
		  DELIVERY_TYPE : delivery_type_info,
		  IS_SERIAL_NO : is_serial_no
	  });
	  //add_basket_rows
	  if(window.basket.items.length > window.basket.pageSize)
		  window.basket.scrollIndex = window.basket.items.length - 1;
	  
	  if (!nosum) {
	  	showBasketItems();
	}
	hesapla('price_other',window.basket.items.length-1,1);
  
	  window.basket.hidden_values.rows_ = window.basket.hidden_values.rows_ + 1;
	  window.basket.hidden_values.control_field_value = '-1';
	  if(toplam_hesap_yap == 0)
	  {
	  //hesaplama yapma
	  }
	  else
	  {
		  if (!nosum)
		  	toplam_hesapla(0);
	  }
	  //console.log(window.basket);
	  return true;
  }
  function upd_row(product_id, stock_id, stock_code, barcod, manufact_code, product_name, unit_id_, unit_, spect_id, spect_name, price, price_other, tax, duedate, d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, deliver_date, deliver_dept, department_head, lot_no, money, row_ship_id, amount_, product_account_code, is_inventory,is_production,net_maliyet,flt_marj,extra_cost,row_promotion_id,promosyon_yuzde,promosyon_maliyet,iskonto_tutar,is_promotion,prom_stock_id, otv, product_name_other, update_product_row_id, is_commission, row_catalog_id,row_unique_relation_id,amount_other,unit_other,ek_tutar,shelf_number,basket_extra_info,prom_relation_id,reserve_type_,order_currency_,toplam_hesap,reserve_date,list_price,number_of_installment,price_cat,karma_product_id,row_service_id,ek_tutar_price,row_width,row_depth,row_height,to_shelf_number,row_project_id,row_project_name,action_window_name,row_paymethod_id,pbs_id,pbs_code,special_code,basket_employee_id,basket_employee,row_work_id,row_work_name,row_exp_center_id,row_exp_center_name,row_exp_item_id,row_exp_item_name,row_acc_code,select_info_extra,detail_info_extra,price_other_calc,gtip_number,row_activity_id,row_subscription_id,row_subscription_name,row_assetp_id,row_assetp_name,row_bsmv_rate,row_bsmv_amount,row_bsmv_currency,row_oiv_rate,row_oiv_amount,row_tevkifat_rate,row_tevkifat_amount,reason_code_info,otv_type_info,otv_discount)
  {
	  reason_code_info_ = '<cfoutput><cfset current_row = 0><cfloop list="#reason_code_list#" index="info_list" delimiters="*"><cfset current_row = current_row + 1><option value="#listlast(info_list,"*")#">#listlast(info_list,"*")#</option></cfloop></cfoutput>';
	  reason_code_info = '';

	  otv_type_info_ = '<option value="0">İndirim Yok</option><option value="1">Tam İndirim</option>';
	  otv_type_info = '';
	  otv_discount = (otv_discount != '' && otv_discount != undefined) ? otv_discount : 0;
	  
	  delivery_condition_info_ = '<cfoutput><option value"">#getLang("main",322)#</option><cfloop query="delivery_condition"><option value="#delivery_condition.code#">#delivery_condition.code#-#delivery_condition.name#</option></cfloop></cfoutput>';
	  delivery_condition_info = '';
	  
	  container_type_info_ = '<cfoutput><option value"">#getLang("main",322)#</option><cfloop query="container_type"><option value="#container_type.code#">#container_type.code#-#container_type.name#</option></cfloop></cfoutput>';
	  container_type_info = '';
	  
	  delivery_type_info_ = '<cfoutput><option value"">#getLang("main",322)#</option><cfloop query="delivery_type"><option value="#delivery_type.code#">#delivery_type.code#-#delivery_type.name#</option></cfloop></cfoutput>';
	  delivery_type_info = '';
  
	  container_number = '';
	  container_quantity = '';
	  delivery_country = '';
	  delivery_city = '';
	  delivery_county = '';
	  
	  row_activity_id_info_ = '<cfoutput><option value="">#getLang("main",322)#</option><cfloop query="getActivity"><option value="#ACTIVITY_ID#">#ACTIVITY_NAME#</option></cfloop></cfoutput>';
	  row_subscription_id = row_subscription_name = row_assetp_id = row_assetp_name = '';
	  row_activity_id = (row_activity_id != '') ? row_activity_id : '';
	  row_bsmv_rate = (row_bsmv_rate != '') ? row_bsmv_rate : 0;
	  row_oiv_rate = (row_oiv_rate != '') ? row_oiv_rate : 0;
	  row_bsmv_currency = row_bsmv_amount = row_oiv_amount = row_tevkifat_rate = row_tevkifat_amount = 0.0;
  
	  reserve_type_list = '<cfoutput><cfset current_row = 0><cfloop list="#reserve_type_list#" index="info_list"><cfset current_row = current_row + 1><option value="#-1*current_row#">#listlast(info_list,";")#</option></cfloop></cfoutput>';
	  order_currency_list = '<cfoutput><cfset current_row = 0><cfloop list="#order_currency_list#" index="info_list"><cfset current_row = current_row + 1><option value="#-1*current_row#">#replace(listlast(info_list,";"),"'","\'","all")#</option></cfloop></cfoutput>';
	  <cfif listfind("11,12,47,48,1,20,2,18,31,32,11,15,17,47,49,10",attributes.basket_id,",") and (attributes.fuseaction contains 'add' or (isdefined("attributes.event") and attributes.event is 'add'))><!--- seri no ekleme sayfası açılacak --->
		  my_serial_ctrl = wrk_safe_query('chk_product_serial1','dsn3',0,product_id);
		  if(my_serial_ctrl.IS_SERIAL_NO==1)
	  </cfif>
  
	  if(action_window_name != undefined && action_window_name != '' && action_window_name != basket_unique_code)
	  {
		  alert('Çalıştığınız Ekran Mevcut Sepet İle Uyumlu Değil!\nFiyat Listesi Ekranınızı Yenilemelisiniz!');
		  return false;
	  }
  
	  var net_total,net_total_doviz,row_tax_total,other_money_value_;
	  var ek_tutar_other_total=0;
	  var ek_tutar_total=0;
	  var ek_tutar_marj=0;
	  var ek_tutar_cost=0;
	  var temp_wrk_row_id='WRK'+ js_create_unique_id();
	  if(isNaN(row_width)) var row_width='';
	  if(isNaN(row_depth)) var row_depth='';
	  if(isNaN(row_height)) var row_height='';
	  if(isNaN(to_shelf_number)) var to_shelf_number='';
	  if(isNaN(shelf_number)) var shelf_number='';
	  if(isNaN(pbs_id)) var pbs_id='';
	  if(isNaN(pbs_code)) var pbs_code='';
	  if(isNaN(ek_tutar)) var ek_tutar=0;
	  if(isNaN(iskonto_tutar) || iskonto_tutar=='' || iskonto_tutar == undefined) var iskonto_tutar =0;
	  if(isNaN(ek_tutar_price)) var ek_tutar_price =0;
	  if(isNaN(row_project_id)) var row_project_id =0;
	  if(row_project_name==undefined) var row_project_name='';
	  if(row_paymethod_id==undefined) var row_paymethod_id='';
	  if(isNaN(row_work_id)) var row_work_id =0;
	  if(row_work_name==undefined) var row_work_name='';
	  //alis faturasi masraf merkezi, butce kalemi ve muhasebe kodu//
	  if(isNaN(row_exp_center_id)) var row_exp_center_id =0;
	  if(row_exp_center_name==undefined) var row_exp_center_name='';
	  if(isNaN(row_exp_item_id)) var row_exp_item_id =0;
	  if(row_exp_item_name==undefined) var row_exp_item_name='';
	  if(row_acc_code==undefined) var row_acc_code='';
	  //alis faturasi masraf merkezi, butce kalemi ve muhasebe kodu//
	  var price_net_ = price;
	  var price_net_doviz = price_other;
	  if(isNaN(amount_other) || amount_other =='') var amount_other=1;
	  if(ek_tutar_price!='') //iscilik birim ucreti gonderilmisse ek_tutar ve ek_tutar_marj bu degerden hesaplanır
	  {
		  if(isNaN(amount_other) || amount_other == '') var amount_other=1;
			  ek_tutar_cost = ek_tutar_price * amount_other;
		  if(ek_tutar != '' && ek_tutar != 0)
			  ek_tutar_marj=((ek_tutar * 100)/ek_tutar_cost)-100;
		  else
			  ek_tutar=ek_tutar_cost;
	  }
	  if((iskonto_tutar != 0) || (ek_tutar != 0))
	  { 
		  price_net_doviz = parseFloat(price_net_doviz) + parseFloat(ek_tutar);
		  price_net_doviz = parseFloat(price_net_doviz) - parseFloat(iskonto_tutar);
		  ek_tutar_other_total = ek_tutar* amount_; /*ek tutar satır toplamı satırda secilen doviz cinsinden hesaplanıyor*/
		  for(var mon_i=0;mon_i<moneyArray.length;mon_i++)
			  if(moneyArray[mon_i] == money)
			  {
				  ek_tutar_total = ek_tutar*(rate2Array[mon_i]/rate1Array[mon_i])*amount_;/*ek tutarın sistem para birimi karsılıgı hesaplanıyor*/
				  price_net_  -= iskonto_tutar*rate2Array[mon_i]/rate1Array[mon_i];
				  price_net_  += ek_tutar*rate2Array[mon_i]/rate1Array[mon_i]; <!--- ek tutar her zaman satir doviz cinsinden oldugundan yerel degerini bularak ekliyoruz --->
			  }
	  }	
	  if(isNaN(list_price) || list_price=='') var list_price = price; //sadece bilgi amaclı tutuluyor, urun eklenirken kullanılan ilk fiyat bilgisini tutmak icin
	  if(isNaN(number_of_installment) || number_of_installment=='') var number_of_installment = 0;
	  if(price_cat == undefined) price_cat='';
	  if(isNaN(karma_product_id)) karma_product_id='';
	  if(isNaN(row_service_id)) row_service_id = '';
	  if(isNaN(row_catalog_id)) row_catalog_id = '';
	  if(isNaN(flt_marj) || flt_marj.length == 0) flt_marj = 0;
	  if(reserve_date == undefined) reserve_date='';
  
	  var upd_shelf_number_ = '',upd_to_shelf_number_= ''; //raf kod bilgileri
	  if(shelf_number != '' || to_shelf_number != '')
	  {/* raf id sine baglı olarak raf kodu getiriliyor */
		  var listParam = shelf_number + "*" + to_shelf_number ;
		  var shelf_name_sql='obj_get_shelf_name_2';
		  if(shelf_number != '' && to_shelf_number != '')
			  shelf_name_sql= 'obj_get_shelf_name_3';
		  else if(shelf_number != '')
			  shelf_name_sql= 'obj_get_shelf_name_4';
		  else if(to_shelf_number != '')
			  shelf_name_sql= 'obj_get_shelf_name_5';
			  
		  var get_shelf_name =wrk_safe_query(shelf_name_sql,'dsn3');
		  if(get_shelf_name.recordcount!=0)
		  {
			  for(shlf_i=0;shlf_i<get_shelf_name.recordcount;shlf_i++)
			  {
				  if(shelf_number !='' && get_shelf_name.PRODUCT_PLACE_ID[shlf_i] == shelf_number)
					  var upd_shelf_number_ = String(get_shelf_name.SHELF_CODE[shlf_i]);
				  else if(to_shelf_number !='' && get_shelf_name.PRODUCT_PLACE_ID[shlf_i] == to_shelf_number)
					  var upd_to_shelf_number_ = String(get_shelf_name.SHELF_CODE[shlf_i]);
			  }
		  }
	  }
	  if(row_project_id != '' && row_project_name == '') //sadece proje_id gonderilmisse proje ismi cekilir
	  {
		  var get_prjct_name =wrk_safe_query("obj_get_prjct_name",'dsn',0,row_project_id);
		  if(get_prjct_name.recordcount)
			  row_project_name = String(get_prjct_name.PROJECT_HEAD);
	  }
	  if(row_work_id != '' && row_work_name == '') //sadece work_id gonderilmisse work ismi cekilir
	  {
		  var get_work_name =wrk_safe_query("obj_get_work_name",'dsn',0,row_work_id);
		  if(get_work_name.recordcount)
			  row_work_name = String(get_work_name.WORK_HEAD);
	  }
	  indirim_carpan = (100-d1) * (100-d2) * (100-d3) * (100-d4) * (100-d5) * (100-d6) * (100-d7) * (100-d8) * (100-d9) * (100-d10);
	  price_net_ = price_net_ * indirim_carpan/100000000000000000000;
	  if(promosyon_yuzde!='') price_net_doviz -= price_net_doviz*promosyon_yuzde/100;
	  price_net_doviz = price_net_doviz*indirim_carpan/100000000000000000000;
	  net_total_doviz = price_other*amount_*indirim_carpan/100000000000000000000;
	  net_total = price_net_ * amount_;
	  row_otv_total = net_total*otv/100;
	  <cfif ListFindNoCase(display_list, "otv_from_tax_price")>//kdv matrahına otv ekleniyor
		  row_tax_total = (net_total+row_otv_total)*tax/100;
	  <cfelse>
		  row_tax_total = net_total*tax/100;
	  </cfif>
	  //other_money_value_ = wrk_round(((parseFloat(price_other)+parseFloat(ek_tutar))-iskonto_tutar)*amount_*indirim_carpan/100000000000000000000 ,price_round_number);
	  other_money_value_ = price_net_doviz * amount_;
	  //net maliyet ve ek tutar baglı olarak satır toplam maliyet ve ek maliyet oranı hesaplanıyor
	  var row_cost_total_ = 0;
	  var extra_cost_rate_ = 0;
	  if(net_maliyet!='' && net_maliyet!=0)
	  {
		  row_cost_total_ +=net_maliyet;
		  if(extra_cost!='' && extra_cost!=0)
		  {
			  extra_cost_rate_ = (extra_cost/net_maliyet)*100;
			  row_cost_total_ +=extra_cost;
		  }
	  }
	  else
	  {
		  net_maliyet = 0;	
	  }
	  dataRow = window.basket.items[update_product_row_id];
	  if(window.basket.items.length > 1)
	  {
		  if(window.basket.items[update_product_row_id].IS_PROMOTION == 0 && window.basket.items[update_product_row_id].ROW_PROMOTION_ID != '')
			  var old_prom_relation_id = window.basket.items[update_product_row_id].PROM_RELATION_ID; //eski promosyon satırının silinmesinde kullanılıyor
		  dataRow.IS_COMMISSION = is_commission;
	  }
	  else
		  dataRow.IS_COMMISSION = 0; <!---  tek satir olan bir sepette o tek urun komisyon urunu olamaz --->
		  
	  var unit2_extra = '';
	  var get_product_unit = wrk_safe_query('prdp_get_unit2_all','dsn3',0,product_id);
	  for(var kk=0;kk<get_product_unit.recordcount;kk++)
	  {
		  if(get_product_unit.ADD_UNIT[kk] == unit_other)
			  var selected_ = 'selected="selected"';
		  else
			  var selected_ = '';
		  unit2_extra = unit2_extra + "<option value='"+get_product_unit.ADD_UNIT[kk]+"' "+selected_+">"+get_product_unit.CRR_UNIT[kk]+"</option>";
	  }
	  
	  other_money_options = '';
	  <cfoutput>
		  <cfloop query="get_money_bskt">
			  if('#money_type#' == money)
				  other_money_options = other_money_options + '<option value="#money_type#" selected="selected">#money_type#</option>'
			  else
				  other_money_options = other_money_options + '<option value="#money_type#">#money_type#</option>'
		  </cfloop>
	  </cfoutput>
	  
	  basket_extra_info_ = '';
	  <cfoutput>
		  <cfloop list="#basket_info_list#" index="info_list">
			  if('#ListFirst(info_list,";")#' == basket_extra_info)
				  basket_extra_info_ = basket_extra_info_ + '<option value="#ListFirst(info_list,";")#" selected="selected">#ListLast(info_list,";")#</option>'
			  else
				  basket_extra_info_ = basket_extra_info_ + '<option value="#ListFirst(info_list,";")#">#ListLast(info_list,";")#</option>'
		  </cfloop>
	  </cfoutput>
  
	  select_info_extra_ = '';
	  <cfoutput>
		  <cfloop list="#select_info_extra_list#" index="extra_list">
			  if('#ListFirst(extra_list,";")#' == select_info_extra)
				  select_info_extra_ = select_info_extra_ + '<option value="#ListFirst(extra_list,";")#" selected="selected">#ListLast(extra_list,";")#</option>'
			  else
				  select_info_extra_ = select_info_extra_ + '<option value="#ListFirst(extra_list,";")#">#ListLast(extra_list,";")#</option>'
		  </cfloop>
	  </cfoutput>
	  detail_info_extra = '';
  
	  dataRow.ROW_CATALOG_ID = row_catalog_id;
	  dataRow.WRK_ROW_ID = temp_wrk_row_id;
	  dataRow.WRK_ROW_RELATION_ID = '';
	  dataRow.ROW_PAYMETHOD_ID = row_paymethod_id;
	  dataRow.RELATED_ACTION_ID = '';
	  dataRow.RELATED_ACTION_TABLE = '';
	  dataRow.PRICE_CAT = price_cat;
	  dataRow.PRODUCT_ID = product_id;
	  dataRow.IS_INVENTORY = is_inventory;
	  dataRow.ROW_SHIP_ID = row_ship_id;
	  dataRow.STOCK_ID = stock_id;
	  dataRow.LOT_NO = lot_no;
	  dataRow.KARMA_PRODUCT_ID = '';
	  dataRow.ROW_SERVICE_ID = '';
	  dataRow.ROW_UNIQUE_RELATION_ID = row_unique_relation_id;
	  dataRow.PROM_RELATION_ID = prom_relation_id;
	  dataRow.SHELF_NUMBER = shelf_number;
	  dataRow.SHELF_NUMBER_TXT = upd_shelf_number_;
	  dataRow.TO_SHELF_NUMBER = to_shelf_number;
	  dataRow.TO_SHELF_NUMBER_TXT = upd_to_shelf_number_;
	  dataRow.PBS_ID = pbs_id;
	  dataRow.PBS_CODE = pbs_code;
	  dataRow.BASKET_EMPLOYEE = '';
	  dataRow.BASKET_EMPLOYEE_ID = '';
	  dataRow.UNIT_OTHER = unit_other;
	  dataRow.UNIT2_EXTRA = unit2_extra;
	  dataRow.AMOUNT_OTHER = parseFloat(amount_other);
	  dataRow.PRODUCT_NAME_OTHER = product_name_other;
	  dataRow.CONTAINER_NUMBER = container_number;
	  dataRow.CONTAINER_QUANTITY = container_quantity;
	  dataRow.DELIVERY_COUNTRY = delivery_country;
	  dataRow.DELIVERY_CITY = delivery_city;
	  dataRow.DELIVERY_COUNTY = delivery_county;
	  dataRow.GTIP_NUMBER = gtip_number;
	  dataRow.EK_TUTAR = ek_tutar;
	  dataRow.EK_TUTAR_PRICE = ek_tutar_price;
	  dataRow.EK_TUTAR_COST = ek_tutar_cost;
	  dataRow.EK_TUTAR_MARJ = parseFloat(ek_tutar_marj);
	  dataRow.EK_TUTAR_TOTAL = ek_tutar_total;
	  dataRow.EK_TUTAR_OTHER_TOTAL = ek_tutar_other_total;
	  dataRow.STOCK_CODE = stock_code;
	  dataRow.BARCODE = barcod;
	  dataRow.SPECIAL_CODE = special_code;
	  dataRow.MANUFACT_CODE = manufact_code;
	  dataRow.PRODUCT_NAME = product_name;
	  dataRow.AMOUNT = amount_;
	  dataRow.UNIT_ID = unit_id_;
	  dataRow.PRODUCT_ACCOUNT_CODE = product_account_code;
	  dataRow.UNIT = unit_;
	  dataRow.SPECT_ID = spect_id;
	  dataRow.SPECT_NAME = spect_name;
	  dataRow.LIST_PRICE = parseFloat(list_price);
	  dataRow.LIST_PRICE_DISCOUNT = 0;
	  dataRow.PRICE = parseFloat(price);
	  dataRow.PRICE_OTHER = parseFloat(price_other);
	  dataRow.PRICE_NET = parseFloat(price_net_);
	  dataRow.PRICE_NET_DOVIZ = parseFloat(price_net_doviz);
	  dataRow.TAX = parseFloat(tax);
	  dataRow.TAX_PERCENT = parseFloat(tax);
	  dataRow.OTV = parseFloat(otv);
	  dataRow.ROW_TOTAL = parseFloat(price)*parseFloat(amount_);
	  dataRow.ROW_NETTOTAL = parseFloat(net_total);
	  dataRow.ROW_OTVTOTAL = parseFloat(row_otv_total);
	  dataRow.ROW_TAXTOTAL = parseFloat(row_tax_total);
	  dataRow.ROW_LASTTOTAL = parseFloat(net_total) + parseFloat(row_tax_total) + parseFloat(row_otv_total);
	  dataRow.TAX_PRICE = (parseFloat(net_total) + parseFloat(row_tax_total) + parseFloat(row_otv_total))/parseFloat(amount_);
	  dataRow.OTHER_MONEY = money;
	  dataRow.OTV_TYPE = otv_type_info;
	  dataRow.OTV_DISCOUNT = parseFloat(otv_discount);
	  dataRow.OTHER_MONEY_OPTIONS = other_money_options;
	  dataRow.OTHER_MONEY_VALUE = parseFloat(other_money_value_);
	  dataRow.OTHER_MONEY_GROSSTOTAL = parseFloat(other_money_value_) * (100 + parseFloat(tax))/100;
	  dataRow.DELIVER_DATE = deliver_date;
	  dataRow.RESERVE_DATE = reserve_date;
	  dataRow.DELIVER_DEPT = deliver_dept;
	  dataRow.BASKET_ROW_DEPARTMAN = department_head;
	  dataRow.ISKONTO_TUTAR = parseFloat(iskonto_tutar);
	  dataRow.NET_MALIYET = parseFloat(net_maliyet);
	  dataRow.EXTRA_COST = parseFloat(extra_cost);
	  dataRow.EXTRA_COST_RATE = parseFloat(extra_cost_rate_);
	  dataRow.ROW_COST_TOTAL = parseFloat(row_cost_total_);
	  dataRow.MARJ = parseFloat(flt_marj);
	  dataRow.DARA = 0;
	  dataRow.DARALI = parseFloat(amount_);
	  dataRow.DUEDATE = duedate;
	  dataRow.NUMBER_OF_INSTALLMENT = number_of_installment;
	  dataRow.ROW_PROMOTION_ID = row_promotion_id;
	  dataRow.PROMOSYON_YUZDE = 0;
	  dataRow.PROMOSYON_MALIYET = 0;
	  dataRow.PROM_STOCK_ID = '';
	  dataRow.INDIRIM1 = parseFloat(d1);
	  dataRow.INDIRIM2 = parseFloat(d2);
	  dataRow.INDIRIM3 = parseFloat(d3);
	  dataRow.INDIRIM4 = parseFloat(d4);
	  dataRow.INDIRIM5 = parseFloat(d5);
	  dataRow.INDIRIM6 = parseFloat(d6);
	  dataRow.INDIRIM7 = parseFloat(d7);
	  dataRow.INDIRIM8 = parseFloat(d8);
	  dataRow.INDIRIM9 = parseFloat(d9);
	  dataRow.INDIRIM10 = parseFloat(d10);
	  dataRow.INDIRIM_TOTAL = parseFloat(indirim_carpan);
	  dataRow.INDIRIM_CARPAN = parseFloat(indirim_carpan);
	  dataRow.BASKET_EXTRA_INFO = basket_extra_info;
	  dataRow.BASKET_EXTRA_INFO_ = basket_extra_info_;
	  dataRow.SELECT_INFO_EXTRA = select_info_extra;
	  dataRow.SELECT_INFO_EXTRA_ = select_info_extra_;
	  dataRow.DETAIL_INFO_EXTRA = detail_info_extra;
	  dataRow.ORDER_CURRENCY = order_currency_;
	  dataRow.RESERVE_TYPE = reserve_type_;
	  dataRow.ROW_WIDTH = row_width;
	  dataRow.ROW_DEPTH = row_depth;
	  dataRow.ROW_HEIGHT = row_height;
	  dataRow.ROW_PROJECT_ID = row_project_id;
	  dataRow.ROW_PROJECT_NAME = row_project_name;
	  dataRow.ROW_WORK_ID = row_work_id;
	  dataRow.ROW_WORK_NAME = row_work_name;
	  dataRow.ROW_EXP_CENTER_ID = row_exp_center_id;
	  dataRow.ROW_EXP_CENTER_NAME = row_exp_center_name;
	  dataRow.ROW_EXP_ITEM_ID = row_exp_item_id;
	  dataRow.ROW_EXP_ITEM_NAME = row_exp_item_name;
	  dataRow.ROW_ACTIVITY_ID = row_activity_id;
	  dataRow.ROW_ACTIVITY_ID_INFO_ = row_activity_id_info_;
	  dataRow.ROW_ACC_CODE = row_acc_code;
	  dataRow.ROW_SUBSCRIPTION_ID = row_subscription_id;
	  dataRow.ROW_SUBSCRIPTION_NAME = row_subscription_name;
	  dataRow.ROW_ASSETP_ID = row_assetp_id;
	  dataRow.ROW_ASSETP_NAME = row_assetp_name;
	  dataRow.ROW_BSMV_RATE = row_bsmv_rate;
	  dataRow.ROW_BSMV_AMOUNT = row_bsmv_amount;
	  dataRow.ROW_BSMV_CURRENCY = row_bsmv_currency;
	  dataRow.ROW_OIV_RATE = row_oiv_rate;
	  dataRow.ROW_OIV_AMOUNT = row_oiv_amount;
	  dataRow.ROW_TEVKIFAT_RATE = row_tevkifat_rate;
	  dataRow.ROW_TEVKIFAT_AMOUNT = row_tevkifat_amount;
	  
  //upd_basket_rows
	  if(is_promotion != undefined && is_promotion !='')
		  dataRow.IS_PROMOTION = is_promotion;
	  else
		  dataRow.IS_PROMOTION = 0;
	  //console.log(dataRow);
	  showBasketItems();
  
	  if(window.basket.items.length != 0 && old_prom_relation_id != undefined && old_prom_relation_id != '')
	  { //guncellenen satırın bedava promosyon satırı siliniyor, listeden secildiginde zaten promosyonunu yeni satır olarak ekliyor
		  for(var counter_i=0; counter_i < window.basket.items.length; counter_i++) //promosyon urun satırı aranıyor
		  {
			  if(window.basket.items[counter_i].IS_PROMOTION == 1 && window.basket.items[counter_i].PROM_RELATION_ID == old_prom_relation_id) //urunun promosyon satırı bulunuyor
				  clear_row(counter_i);
		  }
	  }
  
	  if(toplam_hesap == undefined || toplam_hesap ==1) //dikkat add_bsket_row fonksiyonunun tersine gonderilmemisse veya 1 gonderilmisse calısır
		  toplam_hesapla(0);
  }
  function timeDelay(input_) // Bu fonksiyon iki kere kullanilir. Arada gecen sureyi hesaplayip saniye cinsinden console'a yazar. Performans olcum amaciyla eklenmistir.
  {
	  var d = new Date();
	  if(!$("#"+input_).val().length)
		  $("#"+input_).val(d.getTime());
	  else
	  {
		  process_time = d.getTime() - $("#"+input_).val();
		  $("#"+input_).val(null)
	  }
	  return false;
  }
  $(document).ready(function() {
	$("#tblBasket").on("keyup","input[type='text']",function(e) {
		  kod_ = e.keyCode;
		  lastRow = window.basket.items.length;
		  input_ = $(this);
		  trRow = input_.closest("tr[basketItem]").attr("itemIndex");
		  if($("#tblBasket tr[basketItem]").eq((parseFloat(trRow)+1) - window.basket.scrollIndex).find("#"+input_.attr('id')).attr("readonly") != 'readonly')
		  {
			  if(kod_ == 40) // Asagi ok tusu
			  {
				  if(trRow < lastRow) //En alt satirdayken tekrar islem gormesin.
					  $("#tblBasket tr[basketItem]").eq((parseFloat(trRow)+1) - window.basket.scrollIndex).find("#"+input_.attr('id')).select();
			  }
			  else if(kod_ == 38) // Yukari ok tusu
			  {
				  if(trRow > 0) //İlk satirdayken tekrar islem gormesin.
					  $("#tblBasket tr[basketItem]").eq((parseFloat(trRow)-1) - window.basket.scrollIndex).find("#"+input_.attr('id')).select();
			  }
		  }
	  });
  
	  $("#tblBasket").delegate("input[name = Price]","keyup",function(){
		  if($(this).val() == "") $(this).val("0,0");
	}); 
  
  });
  function zero_stock_control(dep_id,loc_id,is_update,process_type,stock_type,is_del_,is_purchase_,is_deliver_)
  {
	  var hata = '';
	  var lotno_hata = '';
	  var stock_id_list='0';
	  var stock_amount_list='0';
	  var spec_id_list='0';
	  var spec_amount_list='0';
	  var main_spec_id_list='0';
	  var main_spec_amount_list='0';
	  var tree_stock_id_list='';//spec secilmemeis uretilen urunlerin sb lerini almak icin ayrı bir listede tutum  ****** 0 stok id si ürün ağacından gereksiz kayıt döndürüyordu listeyi boşalttım PY
	  var tree_stock_amount_list='0';
	  var not_stock_id_list='0';//urun agacina uygun specti bulunmayan urunler listesi
	  var popup_spec_type=1;
	  if(isNaN(is_del_)) var is_del_=0; //alış islemlerinde silme yapılırken, is_del_ 1 olarak gonderilir
	  if(isNaN(is_purchase_)) var is_purchase_=0; //alış islemlerinde günceleme yapılırken depo sevk ve ithal mal girişinde 1 gelir, is_purchase_ 1 olarak gonderilir
	  if(isNaN(is_deliver_)) var is_deliver_=1; //depo sevk ve ithal mal girişinde teslim alma seçeneği bilgisi gönderilir. 0 ise belgedeki tutar dikkate alınmaz
	  //eger baskete secilen popup specli ise stok kontrolleri specli yapılıyor
	  <cfif isdefined('attributes.basket_id')>
		  var att_bskt_id = <cfoutput>#attributes.basket_id#</cfoutput>;
	  <cfelse>
		  var att_bskt_id = 1;
	  </cfif> 
	  <cfif isdefined('attributes.basket_id')>
		  var att_bskt_id = <cfoutput>#attributes.basket_id#</cfoutput>;
	  <cfelse>
		  var att_bskt_id = 1;
	  </cfif> 
	  var get_basket_rows_ = wrk_safe_query("obj_get_basket_rows",'dsn3',0,att_bskt_id);
	  
	  
	  
	  input_value = $("#basket_main_div #" + $("#basket_main_div #search_process_date").val()).val().toString();
	  if(get_basket_rows_.recordcount && get_basket_rows_.IS_SELECTED == 1)
		  paper_date_kontrol = js_date($("#basket_main_div #" + $("#basket_main_div #search_process_date").val()).val().toString());
	  else
		  paper_date_kontrol = window.basket.hidden_values.today_date_;
  
	  is_update = is_update.toString();	
	  
	  row_count = window.basket.items.length;
	  
	  try{
		  <cfif session.ep.our_company_info.is_lot_no eq 1>//şirket akış parametrelerinde lot no zorunlu olsun seçili ise
			  if(check_lotno('form_basket') != undefined && check_lotno('form_basket'))//işlem kategorisinde lot no zorunlu olsun seçili ise
			  {
				  if(row_count != undefined)
				  {
					  for(i=0;i<row_count;i++)
					  {
						  var lotNo = String(window.basket.items[i].LOT_NO);
						  varName = "lot_no_" + window.basket.items[i].STOCK_ID + lotNo.replace(/-/g, '_').replace(/\./g, '_');
						  this[varName] = 0;
					  } 
					  for(i=0;i<row_count;i++)
					  {
						  if(window.basket.items[i].STOCK_ID.length != 0)
						  {
							  get_prod_detail = wrk_safe_query('obj2_get_prod_name','dsn3',0,window.basket.items[i].STOCK_ID);
							  if(get_prod_detail.IS_LOT_NO == 1 && get_prod_detail.IS_ZERO_STOCK == 0)//üründe lot no takibi yapılıyor seçili ise
							  {
								  var lotNo = String(window.basket.items[i].LOT_NO);
								  varName = "lot_no_" + window.basket.items[i].STOCK_ID + lotNo.replace(/-/g, '_').replace(/\./g, '_');
								  var xxx = String(this[varName]);
								  var yyy = window.basket.items[i].AMOUNT;
								  this[varName] = parseFloat( filterNum(xxx,price_round_number) ) + parseFloat( filterNum(yyy,price_round_number) );
							  }
						  }
					  } 
					  for(i=0;i<row_count;i++)
					  {
						  if(window.basket.items[i].STOCK_ID.length != 0)
						  {
							  get_prod_detail = wrk_safe_query('obj2_get_prod_name','dsn3',0,window.basket.items[i].STOCK_ID);
							  if(get_prod_detail.IS_LOT_NO == 1)//üründe lot no takibi yapılıyor seçili ise
							  {
								  if(window.basket.items[i].LOT_NO.length == 0)
								  {
									  alert((i+1)+'. satırdaki '+ window.basket.items[i].PRODUCT_NAME + ' ürünü için lot no takibi yapılmaktadır!');
									  return false;
								  }
							  }
							  if(get_prod_detail.IS_LOT_NO == 1 && get_prod_detail.IS_ZERO_STOCK == 0)//üründe lot no takibi yapılıyor seçili ise ve sifir stok ile calis secili degil ise
  
							  {
								  var stock_id_ = window.basket.items[i].STOCK_ID;
								  var lot_no_ = window.basket.items[i].LOT_NO;
								  var lotNo = String(window.basket.items[i].LOT_NO);
								  varName = "lot_no_" + window.basket.items[i].STOCK_ID + lotNo.replace(/-/g, '_').replace(/\./g, '_');
								  /*var xxx = String(this[varName]);
								  var yyy = document.form_basket.amount[i].value;
								  this[varName] = parseFloat( filterNum(xxx,price_round_number) ) + parseFloat( filterNum(yyy,price_round_number) );*/
								  if(dep_id==undefined || dep_id=='' || loc_id==undefined || loc_id=='')
								  {
									  if(stock_type==undefined || stock_type==0)
									  {
										  if(is_update != 0)
										  {
											  url_= 'V16/objects/cfc/get_stock_detail.cfc?method=obj_get_total_lot_no_stock&lot_no='+ encodeURIComponent(lot_no_) +'&stock_id='+ stock_id_ +'&paper_date_kontrol='+ encodeURIComponent(paper_date_kontrol)+'&is_update='+ is_update;
										  }
										  else
										  {
											  url_= 'V16/objects/cfc/get_stock_detail.cfc?method=obj_get_total_lot_no_stock_2&lot_no='+ encodeURIComponent(lot_no_) +'&stock_id='+ stock_id_ +'&paper_date_kontrol='+ encodeURIComponent(paper_date_kontrol);		
										  }
									  }
									  else
									  {
										  url_= 'V16/objects/cfc/get_stock_detail.cfc?method=obj_get_total_lot_no_stock_3&lot_no='+ encodeURIComponent(lot_no_) +'&stock_id='+ stock_id_;
									  }
								  }
								  else
								  {
									  if(stock_type==undefined || stock_type==0)
									  {
										  if(is_update != 0)
										  {
											  url_= 'V16/objects/cfc/get_stock_detail.cfc?method=obj_get_total_lot_no_stock_4&lot_no='+ encodeURIComponent(lot_no_) +'&stock_id='+ stock_id_ +'&paper_date_kontrol='+ encodeURIComponent(paper_date_kontrol) +'&loc_id='+ loc_id +'&dep_id='+ dep_id +'&is_update='+ is_update;
										  }
										  else
										  {
											  url_= 'V16/objects/cfc/get_stock_detail.cfc?method=obj_get_total_lot_no_stock_5&lot_no='+ encodeURIComponent(lot_no_) +'&stock_id='+ stock_id_ +'&paper_date_kontrol='+ encodeURIComponent(paper_date_kontrol) +'&loc_id='+ loc_id +'&dep_id='+ dep_id;
										  }
									  }
									  else /* depoya gore kontrol yapılacaksa*/
									  {
										  url_= 'V16/objects/cfc/get_stock_detail.cfc?method=obj_get_total_lot_no_stock_6&lot_no='+ encodeURIComponent(lot_no_) +'&stock_id='+ stock_id_ +'&paper_date_kontrol='+ encodeURIComponent(paper_date_kontrol) +'&loc_id='+ loc_id +'&dep_id='+ dep_id +'&is_update='+ is_update;
									  }
								  }
								  $.ajax({
										  
										  url: url_,
										  dataType: "text",
										  cache:false,
										  async: false,
										  success: function(read_data) {
										  data_ = jQuery.parseJSON(read_data);
										  if(data_.DATA.length != 0)
										  {
											  $.each(data_.DATA,function(i){
												  
												  var PRODUCT_TOTAL_STOCK = data_.DATA[i][0];
												  var STOCK_ID = data_.DATA[i][1];
												  var STOCK_CODE = data_.DATA[i][2];
												  var PRODUCT_NAME = data_.DATA[i][3];
												  if(list_find('73,74,75,76,77,80,761,82,84,86,87,114,761,115,110,140',process_type) || is_purchase_ == 1) // alış tipli işlemde sıfır stok kontrolu calıstırılıyorsa
												  {// alış tipli islem siliniyorsa ve silme işleminden sonra geriye kalan stok eksiye düşüyorsa veya alış tipli işlem guncelleniyor ve (satırdaki miktar+toplam stok miktarı) eksiye düşüyorsa
													  if( (((is_update != 0 && is_del_!=0) || is_deliver_ == 0) && parseFloat(PRODUCT_TOTAL_STOCK) <0 ) || (is_update != 0 && is_del_==0 &&( parseFloat(PRODUCT_TOTAL_STOCK)+ parseFloat(eval(varName)))< 0) )
														  lotno_hata = lotno_hata+ 'Ürün:'+PRODUCT_NAME+'(Stok Kodu:'+STOCK_CODE+')\n';
												  }
												  else
												  {
													  if(eval(varName) > PRODUCT_TOTAL_STOCK)
														  lotno_hata = lotno_hata+ 'Ürün:'+PRODUCT_NAME+'(Stok Kodu:'+STOCK_CODE+')\n';
												  }
											  });
										  }
										  else if(list_find('113,81,811',process_type) && is_purchase_ == 0)
											  lotno_hata = lotno_hata+ 'Ürün:'+get_prod_detail.PRODUCT_NAME+'(Stok Kodu:'+get_prod_detail.STOCK_CODE+')\n';
										  else if (!list_find('73,74,75,76,77,80,761,82,84,86,87,114,761,115,110,113,81,811',process_type))
											  lotno_hata = lotno_hata+ 'Ürün:'+get_prod_detail.PRODUCT_NAME+'(Stok Kodu:'+get_prod_detail.STOCK_CODE+')\n';
									  }
								  });
							  }
						  }
					  }
				  }
				  else
				  {
					  if(window.basket.items[0].STOCK_ID.length != 0)
					  {
						  get_prod_detail = wrk_safe_query('obj2_get_prod_name','dsn3',0,window.basket.items[0].STOCK_ID);
						  if(get_prod_detail.IS_LOT_NO == 1)//üründe lot no takibi yapılıyor seçili ise
						  {
							  if(window.basket.items[0].LOT_NO == '')
							  {
								  alert((1)+'. satırdaki '+ window.basket.items[0].PRODUCT_NAME + ' ürünü için lot no takibi yapılmaktadır!');
								  return false;
							  }
						  }
						  if(get_prod_detail.IS_LOT_NO == 1 && get_prod_detail.IS_ZERO_STOCK == 0)//üründe lot no takibi yapılıyor seçili ise ve sifir stok ile calis secili degil ise
						  {
							  var stock_id_ = window.basket.items[0].STOCK_ID;
							  var lot_no_ = window.basket.items[0].LOT_NO;
							  var lotNo = String(window.basket.items[i].LOT_NO);
							  varName = "lot_no_" + stock_id_ + lotNo.replace(/-/g, '_').replace(/\./g, '_');
							  
							  var yyy = window.basket.items[0].AMOUNT;
							  this[varName] = parseFloat(filterNum(yyy,price_round_number) );
							  //this[varName] = parseFloat(this[varName]) + parseFloat(document.form_basket.amount.value)
							  if(dep_id==undefined || dep_id=='' || loc_id==undefined || loc_id=='')
							  {
								  if(stock_type==undefined || stock_type==0)
								  {
									  if(is_update != 0)
									  {
										  url_= 'V16/objects/cfc/get_stock_detail.cfc?method=obj_get_total_lot_no_stock&lot_no='+ encodeURIComponent(lot_no_) +'&stock_id='+ stock_id_ +'&paper_date_kontrol='+ encodeURIComponent(paper_date_kontrol)+'&is_update='+ is_update;
									  }
									  else
									  {
										  url_= 'V16/objects/cfc/get_stock_detail.cfc?method=obj_get_total_lot_no_stock_2&lot_no='+ encodeURIComponent(lot_no_) +'&stock_id='+ stock_id_ +'&paper_date_kontrol='+ encodeURIComponent(paper_date_kontrol);		
									  }
								  }
								  else
								  {
									  url_= 'V16/objects/cfc/get_stock_detail.cfc?method=obj_get_total_lot_no_stock_3&lot_no='+ encodeURIComponent(lot_no_) +'&stock_id='+ stock_id_;
								  }
							  }
							  else
							  {
								  if(stock_type==undefined || stock_type==0)
								  {
									  if(is_update != 0)
									  {
										  url_= 'V16/objects/cfc/get_stock_detail.cfc?method=obj_get_total_lot_no_stock_4&lot_no='+ encodeURIComponent(lot_no_) +'&stock_id='+ stock_id_ +'&paper_date_kontrol='+ encodeURIComponent(paper_date_kontrol) +'&loc_id='+ loc_id +'&dep_id='+ dep_id +'&is_update='+ is_update;
									  }
									  else
									  {
										  url_= 'V16/objects/cfc/get_stock_detail.cfc?method=obj_get_total_lot_no_stock_5&lot_no='+ encodeURIComponent(lot_no_) +'&stock_id='+ stock_id_ +'&paper_date_kontrol='+ encodeURIComponent(paper_date_kontrol) +'&loc_id='+ loc_id +'&dep_id='+ dep_id;
									  }
								  }
								  else /*uretim rezerve ve stoklarda depoya gore kontrol yapılacaksa*/
								  {
									  url_= 'V16/objects/cfc/get_stock_detail.cfc?method=obj_get_total_lot_no_stock_6&lot_no='+ encodeURIComponent(lot_no_) +'&stock_id='+ stock_id_ +'&paper_date_kontrol='+ encodeURIComponent(paper_date_kontrol) +'&loc_id='+ loc_id +'&dep_id='+ dep_id +'&is_update='+ is_update;
								  }
							  }
							  $.ajax({
									  url: url_,
									  dataType: "text",
									  cache:false,
									  async: false,
									  success: function(read_data) {
									  data_ = jQuery.parseJSON(read_data);
									  if(data_.DATA.length != 0)
									  {
										  $.each(data_.DATA,function(i){
											  var PRODUCT_TOTAL_STOCK = data_.DATA[i][0];
											  var STOCK_ID = data_.DATA[i][1];
											  var STOCK_CODE = data_.DATA[i][2];
											  var PRODUCT_NAME = data_.DATA[i][3];
											  if(list_find('73,74,75,76,77,80,761,82,84,86,87,114,761,115,110,140',process_type) || is_purchase_ == 1) // alış tipli işlemde sıfır stok kontrolu calıstırılıyorsa
											  {// alış tipli islem siliniyorsa ve silme işleminden sonra geriye kalan stok eksiye düşüyorsa veya alış tipli işlem guncelleniyor ve (satırdaki miktar+toplam stok miktarı) eksiye düşüyorsa
												  if( (((is_update != 0 && is_del_!=0) || is_deliver_ == 0) && parseFloat(PRODUCT_TOTAL_STOCK) <0 ) || (is_update != 0 && is_del_==0 &&( parseFloat(PRODUCT_TOTAL_STOCK)+ parseFloat(eval(varName)))< 0) )
													  lotno_hata = lotno_hata+ 'Ürün:'+PRODUCT_NAME+'(Stok Kodu:'+STOCK_CODE+')\n';
											  }
											  else
											  {
												  if(eval(varName) > PRODUCT_TOTAL_STOCK)
													  lotno_hata = lotno_hata+ 'Ürün:'+PRODUCT_NAME+'(Stok Kodu:'+STOCK_CODE+')\n';
											  }
										  });
									  }
									  else if(list_find('113,81,811',process_type) && is_purchase_ == 0)
										  lotno_hata = lotno_hata+ 'Ürün:'+get_prod_detail.PRODUCT_NAME+'(Stok Kodu:'+get_prod_detail.STOCK_CODE+')\n';
									  else if (!list_find('73,74,75,76,77,80,761,82,84,86,87,114,761,115,110,113,81,811',process_type))
										  lotno_hata = lotno_hata+ 'Ürün:'+get_prod_detail.PRODUCT_NAME+'(Stok Kodu:'+get_prod_detail.STOCK_CODE+')\n';
								  }
							  });
						  }
					  }
				  }
			  }
		  </cfif>
	  }
	  catch(e)
	  {}
	  
	  if(is_update.indexOf(';') >= 0)	is_update = list_getat(is_update,1,';');
  
	  if( (is_update == 0 && ( $("#basket_main_div #irsaliye_id_listesi").length == 0  || ( $("#basket_main_div #irsaliye_id_listesi").length && ( $("#basket_main_div #irsaliye_id_listesi").val().length == 0 ||  $("#basket_main_div #irsaliye_id_listesi").val().split(";", 1) == '') ))) || (is_update!= 0 )) //faturaya irsaliye cekilerek baskete eklenmis urunler haricinde olanlar aliniyor
	  {
		  
		  for (var counter_=0; counter_ < window.basket.items.length; counter_++)
		  {
			  if(! list_find('4,6',att_bskt_id)|| window.basket.items[counter_].ORDER_CURRENCY != -3)//satır asaması kapalıysa stok kontrolu yapılmaz
			  {
				  if( $("#basket_main_div #order_id_listesi").val() != '' || (((list_getat(window.basket.items[counter_].ROW_SHIP_ID,1,';') ==0 || window.basket.items[counter_].ROW_SHIP_ID ==''))) || list_find('70,71,72,73,74,75,76,77,78,79,80,81,83,85,87,88,811,114,761,115,110,113,111,141',process_type) )
				  {
					  if(window.basket.items[counter_].IS_INVENTORY == 1)
					  {
						  if(window.basket.items[counter_].SPECT_ID.length != 0 && window.basket.items[counter_].SPECT_ID != 0) //satırda secilen spec varsa
						  {
							  var yer=list_find(spec_id_list,window.basket.items[counter_].SPECT_ID,',');//aynı olması kucuk bir ihtimal ama koyalım cunku spec idler farklidir ama main ler ayni olabilir
							  if(yer)
							  {
								  top_stock_miktar=parseFloat(list_getat(spec_amount_list,yer,','))+parseFloat(filterNumBasket(window.basket.items[counter_].AMOUNT,amount_round));
								  spec_amount_list=list_setat(spec_amount_list,yer,top_stock_miktar,',');
							  }else{
								  spec_id_list=spec_id_list+','+window.basket.items[counter_].SPECT_ID;
								  spec_amount_list=spec_amount_list+','+filterNumBasket(window.basket.items[counter_].AMOUNT,amount_round);
							  }
						  }
						  //artık uretilen urun ıcınde once kendi stok miktarı olmalı sonra specli stoğa bakılıyor
						  var yer=list_find(stock_id_list,window.basket.items[counter_].STOCK_ID,',');
						  if(yer)
						  {
							  top_stock_miktar=parseFloat(list_getat(stock_amount_list,yer,','))+parseFloat(filterNumBasket(window.basket.items[counter_].AMOUNT,amount_round));
							  stock_amount_list=list_setat(stock_amount_list,yer,top_stock_miktar,',');
						  }
						  else
						  {
							  stock_id_list=stock_id_list+','+window.basket.items[counter_].STOCK_ID;
							  stock_amount_list=stock_amount_list+','+filterNumBasket(window.basket.items[counter_].AMOUNT,amount_round);
						  }
						  //specli stok bakılacak ise spec secilmeyen satırların main_specleri bulunuyor
						  if(window.basket.items[counter_].IS_PRODUCTION == 1 && (window.basket.items[counter_].SPECT_ID.length == 0 && window.basket.items[counter_].SPECT_ID == ''))
						  {
							  var get_main_spec = wrk_safe_query("obj_get_main_spec_3",'dsn3',0,window.basket.items[counter_].STOCK_ID);
							  if(get_main_spec.recordcount)
							  {
								  var spec_amount=filterNumBasket(window.basket.items[counter_].AMOUNT,amount_round);
								  var yer=list_find(main_spec_id_list,get_main_spec.SPECT_MAIN_ID,',');
								  if(yer)
								  {
									  var top_stock_miktar=parseFloat(list_getat(main_spec_amount_list,yer,','))+parseFloat(spec_amount);
									  main_spec_amount_list=list_setat(main_spec_amount_list,yer,top_stock_miktar,',');
								  }
								  else{
									  main_spec_id_list=main_spec_id_list+','+get_main_spec.SPECT_MAIN_ID;
									  main_spec_amount_list=main_spec_amount_list+','+spec_amount;
								  }
							  }else//urune ait main spec yoksa zaten stokta yoktur...
								  not_stock_id_list=not_stock_id_list+','+window.basket.items[counter_].STOCK_ID;
							  get_main_spec='';
						  }
						  if(window.basket.items[counter_].IS_PRODUCTION == 1 && (window.basket.items[counter_].SPECT_ID.length == 0 && window.basket.items[counter_].SPECT_ID == ''))
						  {
							  var yer=list_find(tree_stock_id_list,window.basket.items[counter_].STOCK_ID);
							  if(yer)
							  {
								  top_stock_miktar=parseFloat(list_getat(tree_stock_amount_list,yer,','))+parseFloat(filterNumBasket(window.basket.items[counter_].AMOUNT,amount_round));
								  tree_stock_amount_list=list_setat(tree_stock_amount_list,yer,top_stock_miktar,',');
							  }
							  else{
								  if(tree_stock_id_list != ''){
									  tree_stock_id_list=tree_stock_id_list+','+window.basket.items[counter_].STOCK_ID;
									  tree_stock_amount_list=tree_stock_amount_list+','+filterNumBasket(window.basket.items[counter_].AMOUNT,amount_round);
								  }
								  else{
									  tree_stock_id_list=tree_stock_id_list+window.basket.items[counter_].STOCK_ID;
									  tree_stock_amount_list=tree_stock_amount_list+filterNumBasket(window.basket.items[counter_].AMOUNT,amount_round);
								  }
							  }
						  }
					  }
				  }
			  }
		  }
		  
		  if(list_len(spec_id_list,',')>1) //satırda secilen spect in sevkte birlestir urunleri
		  {
			  if(!list_find('81,113', process_type))//depo sevk ve ambar fisinde spect bilesenlerine bakılmıyor
			  {
				  //spect satirladındaki sbler için	
				  var get_spect_row = wrk_safe_query('obj_get_spect_row','dsn3',0,spec_id_list);
				  if(get_spect_row.recordcount)
				  {
					  for (var counter_1=0; counter_1 < get_spect_row.recordcount; counter_1++)
					  {
						  var spect_carpan=list_getat(spec_amount_list,list_find(spec_id_list,get_spect_row.SPECT_ID[counter_1],','),',');
						  var yer=list_find(stock_id_list,get_spect_row.STOCK_ID[counter_1],',');
						  if(yer)
						  {
							  top_stock_miktar=parseFloat(list_getat(stock_amount_list,yer,','))+parseFloat(filterNumBasket(get_spect_row.AMOUNT_VALUE[counter_1],amount_round)*spect_carpan);
							  stock_amount_list=list_setat(stock_amount_list,yer,top_stock_miktar,',');
						  }
						  else
						  {
							  stock_id_list=stock_id_list+','+get_spect_row.STOCK_ID[counter_1];
							  stock_amount_list=stock_amount_list+','+parseFloat(filterNumBasket(get_spect_row.AMOUNT_VALUE[counter_1],amount_round)*spect_carpan);
						  }
					  }
					  get_spect_row='';
				  }
			  }
			  if(popup_spec_type==1)//specli stok bakılacaksa 
			  {
				  //main spec idsini alıyor cunku bunlarında stokları varmı bakılacak
				  var get_spect = wrk_safe_query('obj_get_spect','dsn3',0,spec_id_list);
				  for (var counter=0; counter < get_spect.recordcount; counter++)
				  {
					  var yer_1=list_find(spec_id_list,get_spect.SPECT_VAR_ID[counter],',');
					  var spec_amount=list_getat(spec_amount_list,yer_1,',');
					  var yer=list_find(main_spec_id_list,get_spect.SPECT_MAIN_ID[counter],',');
					  if(yer)
					  {
						  var top_stock_miktar=parseFloat(list_getat(main_spec_amount_list,yer,','))+parseFloat(spec_amount);
						  main_spec_amount_list=list_setat(main_spec_amount_list,yer,top_stock_miktar,',');
					  }
					  else{
						  main_spec_id_list=main_spec_id_list+','+get_spect.SPECT_MAIN_ID[counter];
						  main_spec_amount_list=main_spec_amount_list+','+spec_amount;
					  }
				  }
				  get_spect='';
			  }
		  }
		  
		   var stock_id_count=list_len(stock_id_list,',');
		  //karma koli bilesenleri
		  if(stock_id_count >1)
		  {
		  	  var karma_koli_stock_id_list='-1';
			  var karma_koli_main_spec_list='';
			  var karmakoli_main_spec_amount_list='';
			  var listParam = "<cfoutput>#dsn3_alias#</cfoutput>" + "*" + stock_id_list;
			  var get_karma_koli = wrk_safe_query("obj_get_karma_koli",'dsn1',0,listParam);
			  if(get_karma_koli.recordcount)
			  {
				  for (var counter_1=0; counter_1 < get_karma_koli.recordcount; counter_1++)
				  {
					  var yer_k=list_find(karma_koli_stock_id_list,get_karma_koli.KARMA_STOCK_ID[counter_1],',');
					  if(yer_k == 0)
					  	karma_koli_stock_id_list=karma_koli_stock_id_list+','+get_karma_koli.KARMA_STOCK_ID[counter_1]; //karma koli stok
					  
					  var stock_amount=list_getat(stock_amount_list,list_find(stock_id_list,get_karma_koli.KARMA_STOCK_ID[counter_1],','),',');
					  
					  if(popup_spec_type==1 && get_karma_koli.IS_PRODUCTION ==1 && get_karma_koli.SPEC_MAIN_ID!='' ) //satırda main spec secilmisse ve specli stok bakılacaksa 
					  {
						  karma_koli_main_spec_list=karma_koli_main_spec_list+','+get_karma_koli.SPEC_MAIN_ID[counter_1]; //karma koli spec
						  karmakoli_main_spec_amount_list=karmakoli_main_spec_amount_list+','+parseFloat(get_karma_koli.PRODUCT_AMOUNT[counter_1]*stock_amount); //karma koli specli miktar
						  
						  var yer=list_find(main_spec_id_list,get_karma_koli.SPEC_MAIN_ID[counter_1],',');
						  if(yer)
						  {
							  top_stock_miktar=parseFloat(list_getat(main_spec_amount_list,yer,','))+parseFloat(get_karma_koli.PRODUCT_AMOUNT[counter_1]*stock_amount);
							  main_spec_amount_list=list_setat(main_spec_amount_list,yer,top_stock_miktar,',');
						  }
						  else{
							  main_spec_id_list=main_spec_id_list+','+get_karma_koli.SPEC_MAIN_ID[counter_1];
							  main_spec_amount_list=main_spec_amount_list+','+parseFloat(get_karma_koli.PRODUCT_AMOUNT[counter_1]*stock_amount);
						  }
					  }
					  var yer=list_find(stock_id_list,get_karma_koli.STOCK_ID[counter_1],',');
					  if(yer)
					  {
						  top_stock_miktar=parseFloat(list_getat(stock_amount_list,yer,','))+parseFloat(get_karma_koli.PRODUCT_AMOUNT[counter_1]*stock_amount);
						  stock_amount_list=list_setat(stock_amount_list,yer,top_stock_miktar,',');
					  }
					  else
					  {   
						  stock_id_list=stock_id_list+','+get_karma_koli.STOCK_ID[counter_1];
						  stock_amount_list=stock_amount_list+','+parseFloat(get_karma_koli.PRODUCT_AMOUNT[counter_1]*stock_amount);
					  }
				  }
				  if( karma_koli_main_spec_list!='' && list_len(karma_koli_main_spec_list)>1) //karma koli icerigindeki specli urunlerin sb icerikleri alınıyor
				  {
					  if(!list_find('81,113', process_type))//depo sevk ve ambar fisinde spect bilesenlerine bakılmıyor
					  {
						  //spect satirlarındaki sevte birleştirilen urunler için	
						  var get_spect_row = wrk_safe_query('obj_get_spect_row_2','dsn3',0,karma_koli_main_spec_list);
						  if(get_spect_row.recordcount)
						  {
							  for (var counter_1=0; counter_1 < get_spect_row.recordcount; counter_1++)
							  {
								  var spect_carpan=list_getat(karmakoli_main_spec_amount_list,list_find(karma_koli_main_spec_list,get_spect_row.SPECT_ID[counter_1],','),',');
								  var yer=list_find(stock_id_list,get_spect_row.STOCK_ID[counter_1],',');
								  
								  if(yer)
								  {
									  top_stock_miktar=parseFloat(list_getat(stock_amount_list,yer,','))+parseFloat(filterNumBasket(get_spect_row.AMOUNT_VALUE[counter_1],amount_round)*spect_carpan);
									  stock_amount_list=list_setat(stock_amount_list,yer,top_stock_miktar,',');
								  }
								  else
								  {
									  stock_id_list=stock_id_list+','+get_spect_row.STOCK_ID[counter_1];
									  stock_amount_list=stock_amount_list+','+parseFloat(filterNumBasket(get_spect_row.AMOUNT_VALUE[counter_1],amount_round)*spect_carpan);
								  }
							  }
							  get_spect_row='';
						  }
					  }
				  }
				  get_karma_koli='';
			  }
			
			  if(list_len(karma_koli_stock_id_list,',')>0){
			  	function listDeleteAt(string,indexList,delimiter){
					if(!delimiter)
						delimiter = ',';
					dataSize = list_len(string,delimiter);
					returnData = '';
					for(i=1;i<=dataSize;i++)
					{
						if(!list_find(indexList,i,delimiter)){
							if(returnData == '')
								returnData = list_getat(string,i,delimiter);
							else
								returnData = returnData + ',' + list_getat(string,i,delimiter);
						}
					}
					return returnData;
				}
			  
			  	index_list = '';
				for (var c=0; c <= list_len(stock_id_list,','); c++)
				{
					if(list_find(stock_id_list,list_getat(karma_koli_stock_id_list,c,','),',') != 0){
						index_list =  index_list+','+list_find(stock_id_list,list_getat(karma_koli_stock_id_list,c,','),',');
					}
				}
			  
			  	stock_id_list = listDeleteAt(stock_id_list,index_list,',');
				stock_amount_list = listDeleteAt(stock_amount_list,index_list,',');

			  }
		  }
		  
		  //agactaki sevkte birlestirler
		  if(list_len(tree_stock_id_list,',')>1)
		  {
			  var get_tree = wrk_safe_query('obj_get_tree','dsn3',0,tree_stock_id_list);
			  if(get_tree.recordcount)
			  {
				  for (var counter_1=0; counter_1 < get_tree.recordcount; counter_1++)
				  {
					  var stock_amount=list_getat(tree_stock_amount_list,list_find(tree_stock_id_list,get_tree.STOCK_ID[counter_1],','),',');
					  var yer=list_find(stock_id_list,get_tree.RELATED_ID[counter_1],',');
					  if(yer)
					  {
						  top_stock_miktar=parseFloat(list_getat(stock_amount_list,yer,','))+parseFloat(filterNumBasket(get_tree.AMOUNT[counter_1],amount_round)*stock_amount);
						  stock_amount_list=list_setat(stock_amount_list,yer,top_stock_miktar,',');
					  }
					  else{
						  stock_id_list=stock_id_list+','+get_tree.RELATED_ID[counter_1];
						  stock_amount_list=stock_amount_list+','+parseFloat(filterNumBasket(get_tree.AMOUNT[counter_1],amount_round)*stock_amount);
					  }
				  }
				  get_tree='';
			   }
		  }
		  //stock kontrolleri
		  
		  if(stock_id_count >1)
		  {/*sipariste depo bilgisi gonderilmiyor, satılabilir stok kontrol ediliyor , stock_type=1 olarak gonderiliyor*/
			  if(dep_id=='' || dep_id==undefined || loc_id=='' || loc_id==undefined)
			  {
				  if(stock_type==undefined || stock_type==0)
				  {
					  if(is_update != 0)
					  {
						  var listParam = "<cfoutput>#dsn3_alias#</cfoutput>" + "*" + stock_id_list + "*" + paper_date_kontrol + "*" +is_update + "*" + process_type;
						  var new_sql = 'obj_get_total_stock';
					  }
					  else
					  {
						  var listParam = "<cfoutput>#dsn3_alias#</cfoutput>" + "*" + stock_id_list + "*" + paper_date_kontrol;
						  var new_sql = 'obj_get_total_stock_2';			
					  }
				  }
				  else
				  {
					  if(is_update != 0)
					  {
						  var listParam = stock_id_list + "*" + "<cfoutput>#dsn3_alias#</cfoutput>" + "*" + paper_date_kontrol+ "*" +is_update;
						  var new_sql='obj_get_total_stock_3';
					  }						
					  else
					  {
						  var listParam = stock_id_list + "*" + "<cfoutput>#dsn3_alias#</cfoutput>" + "*" + paper_date_kontrol;
						  var new_sql='obj_get_total_stock_4';
					  }
				  }
			  }
			  else
			  {
				  if(stock_type==undefined || stock_type==0)
				  {
					  if(is_update != 0)
					  {
						  var listParam = "<cfoutput>#dsn3_alias#</cfoutput>" + "*" + stock_id_list + "*" + paper_date_kontrol + "*" +loc_id + "*" +  dep_id + "*" + is_update + "*" + process_type;
						  var new_sql = 'obj_get_total_stock_5';
					  }
					  else
					  {
						  var listParam = "<cfoutput>#dsn3_alias#</cfoutput>" + "*" + stock_id_list + "*" + paper_date_kontrol + "*" +loc_id + "*" +  dep_id;
						  var new_sql = 'obj_get_total_stock_6';
					  }
				  }
				  else /*satıs siparisinde depoya gore kontrol yapılacaksa*/
				  {
					  var listParam = "<cfoutput>#dsn3_alias#</cfoutput>" + "*" + stock_id_list + "*" + dep_id + "*" + loc_id + "*" + paper_date_kontrol + "*" + is_update + "*" + "<cfoutput>#dsn_alias#</cfoutput>";
					  var new_sql='obj_get_total_stock_7';
					  if(is_update != 0)
						  new_sql= 'obj_get_total_stock_8';				
				  }
			  }
			  //form_basket.detail.value=new_sql;
			  
			  var get_total_stock = wrk_safe_query(new_sql,'dsn2',0,listParam);
			  //console.log(new_sql);
			  //console.log(listParam);
			  //console.log(get_total_stock);
			  if(get_total_stock.recordcount)
			  {
				  var query_stock_id_list='0';
				  for(var cnt=0; cnt < get_total_stock.recordcount; cnt++)
				  {
					  query_stock_id_list=query_stock_id_list+','+get_total_stock.STOCK_ID[cnt];//queryden gelen kayıtları tutuyruz gelmeyenlerde stokta yoktur cunku
					  var yer=list_find(stock_id_list,get_total_stock.STOCK_ID[cnt],',');
					  //console.log(parseFloat(get_total_stock.PRODUCT_TOTAL_STOCK[cnt]));
					  //console.log( parseFloat(list_getat(stock_amount_list,yer,',')));
					  if(list_find('73,74,75,76,77,80,761,82,84,86,87,114,761,115,110,140',process_type) || is_purchase_ == 1) // alış tipli işlemde sıfır stok kontrolu calıstırılıyorsa
					  {// alış tipli islem siliniyorsa ve silme işleminden sonra geriye kalan stok eksiye düşüyorsa veya alış tipli işlem guncelleniyor ve (satırdaki miktar+toplam stok miktarı) eksiye düşüyorsa
						  if( (((is_update != 0 && is_del_!=0) || is_deliver_ == 0) && parseFloat(get_total_stock.PRODUCT_TOTAL_STOCK[cnt]) <0 ) || (is_update != 0 && is_del_==0 &&( parseFloat(get_total_stock.PRODUCT_TOTAL_STOCK[cnt])+ parseFloat(list_getat(stock_amount_list,yer,',')) )< 0) )
							  hata = hata+ 'Ürün:'+get_total_stock.PRODUCT_NAME[cnt]+'(Stok Kodu:'+get_total_stock.STOCK_CODE[cnt]+')\n';
					  }
					  else
					  {
						  if(parseFloat(get_total_stock.PRODUCT_TOTAL_STOCK[cnt]) < wrk_round(parseFloat(list_getat(stock_amount_list,yer,',')),8))
							  hata = hata+ 'Ürün:'+get_total_stock.PRODUCT_NAME[cnt]+'(Stok Kodu:'+get_total_stock.STOCK_CODE[cnt]+')\n';
					  }
				  }
			  }
			  var diff_stock_id='0';
			  if(list_find('73,74,75,76,77,80,761,82,84,86,87,114,761,115,110,140',process_type)==0 && is_purchase_ == 0) //alış tipli işlemlerde bu kontrole gerek yok
			  {
				  for(var lst_cnt=1;lst_cnt <= list_len(stock_id_list);lst_cnt++)
				  {
					  var stk_id=list_getat(stock_id_list,lst_cnt,',')
					  if(query_stock_id_list==undefined || query_stock_id_list=='0' || list_find(query_stock_id_list,stk_id,',') == '0')
						  diff_stock_id=diff_stock_id+','+stk_id;//kayıt gelmeyen urunler
				  }
				  if(list_len(diff_stock_id,',')>1)
				  {
				  //bu lokasyona hiç giriş veya çıkış olmadı ise kayıt gelemyecektir o yüzden yazıldı
					  
					  var new_sql = 'obj_get_stock_4';
					  if(stock_type!=undefined && stock_type==1) //satılabilir stoguna bakılmıssa ve kayıt yoksa stoklarla sınırlı olup olmadıgı kontrol ediliyor
						  new_sql = 'obj_get_stock_5';
					  var get_stock = wrk_safe_query(new_sql,'dsn3',0,diff_stock_id);
					  for(var cnt=0; cnt < get_stock.recordcount; cnt++)
						  hata = hata+ 'Ürün:'+get_stock.PRODUCT_NAME[cnt]+'(Stok Kodu:'+get_stock.STOCK_CODE[cnt]+')\n';
				  }
			  }
			  get_total_stock='';
		  }
		  //agac ile ayni bir spec hic olusmadı ise
		  /*
		  if(list_len(not_stock_id_list,',')>1)
		  {
			  var new_sql = 'obj_get_stock_4';
			  if(stock_type!=undefined && stock_type==1)
				  new_sql = 'obj_get_stock_5';
			  var get_stock = wrk_safe_query(new_sql,'dsn3',0,not_stock_id_list);
			  for(var cnt=0; cnt < get_stock.recordcount; cnt++)
				  hata = hata+ 'Ürün:'+get_stock.PRODUCT_NAME[cnt]+'(Stok Kodu:'+get_stock.STOCK_CODE[cnt]+')\n';
			  get_stock='';
		  }
		  Üretilen ama ağacı oluşmayan ürünlerde uyarı veriliyordu. Sebebi anlaşılmadığından kapatıldı PY  
		  */
		  //specli stok kontrolleri
		  if(popup_spec_type==1 && list_len(main_spec_id_list,',') >1)//sepcli stok bakılacaksa 
		  {
			  if(dep_id=='' || dep_id==undefined || loc_id=='' || loc_id==undefined)
			  {
				  if(stock_type==undefined || stock_type==0)
				  {
					  if(is_update != 0)
					  {
						  var listParam = "<cfoutput>#dsn3_alias#</cfoutput>" + "*" + main_spec_id_list + "*" + is_update + "*" + paper_date_kontrol + "*" + process_type;
						  var new_sql = 'obj_get_total_stock_9';
					  }
					  else
					  {
						  var listParam = "<cfoutput>#dsn3_alias#</cfoutput>" + "*" + main_spec_id_list + "*" + paper_date_kontrol;
						  var new_sql = 'obj_get_total_stock_10';
					  }
				  }
				  else
				  {
					  if(is_update != 0)
					  {
						  var listParam = main_spec_id_list + "*" + "<cfoutput>#dsn3_alias#</cfoutput>" + "*" + is_update + "*" + paper_date_kontrol;
						  var new_sql='obj_get_total_stock_11';
					  }
					  else
					  {			
						  var listParam = main_spec_id_list + "*" + "<cfoutput>#dsn3_alias#</cfoutput>" + "*" + paper_date_kontrol;
						  var new_sql='obj_get_total_stock_12';
					  }
				  }
			  }
			  else
			  {
				  if(stock_type==undefined || stock_type==0)
				  {
					  if(is_update != 0)
					  {
						  var listParam = "<cfoutput>#dsn3_alias#</cfoutput>" + "*" + main_spec_id_list + "*" + is_update + "*" + loc_id + "*" + dep_id + "*" + paper_date_kontrol + "*" + process_type;
						  var new_sql = 'obj_get_total_stock_13';
					  }
					  else
					  {
						  var listParam = "<cfoutput>#dsn3_alias#</cfoutput>" + "*" + main_spec_id_list + "*" + is_update + "*" + loc_id + "*" + dep_id + "*" + paper_date_kontrol + "*" + process_type;
						  var new_sql = 'obj_get_total_stock_14';
					  }
				  }
				  else /*satıs siparisinde depoya gore kontrol yapılacaksa*/
				  {
					  var listParam = "<cfoutput>#dsn3_alias#</cfoutput>" + "*" + main_spec_id_list + "*" + dep_id + "*" + loc_id + "*"+ paper_date_kontrol + "*" + is_update;
					  var new_sql='obj_get_total_stock_15';
					  if(is_update != 0)
						  new_sql='obj_get_total_stock_16';
				  }
					  //form_basket.detail.value=new_sql;
			  }
			  var get_total_stock = wrk_safe_query(new_sql,'dsn2','0',listParam);
			  var query_spec_id_list='0';
			  if(get_total_stock.recordcount)
			  {
				  for(var cnt=0; cnt < get_total_stock.recordcount; cnt++)
				  {
					  query_spec_id_list=query_spec_id_list+','+get_total_stock.SPECT_MAIN_ID[cnt];//queryden gelen kayıtları tutuyruz gelmeyenlerde stokta yoktur cunku
					  var yer=list_find(main_spec_id_list,get_total_stock.SPECT_MAIN_ID[cnt],',');
					  if(list_find('73,74,75,76,77,80,761,82,84,86,87,114,761,115,110,140',process_type) || is_purchase_ == 1) // alış tipli işlemde sıfır stok kontrolu calıstırılıyorsa
					  {// alış tipli islem siliniyorsa ve silme işleminden sonra geriye kalan stok eksiye düşüyorsa veya alış tipli işlem guncelleniyor ve (satırdaki miktar+toplam stok miktarı) eksiye düşüyorsa
						  if( (((is_update != 0 && is_del_!=0) || is_deliver_ == 0) && parseFloat(get_total_stock.PRODUCT_TOTAL_STOCK[cnt]) <0 ) || (is_update != 0 && is_del_==0 &&( parseFloat(get_total_stock.PRODUCT_TOTAL_STOCK[cnt])+ parseFloat(list_getat(main_spec_amount_list,yer,',')) )< 0) )
							  hata = hata+ 'Ürün:'+get_total_stock.PRODUCT_NAME[cnt]+'(Stok Kodu:'+get_total_stock.STOCK_CODE[cnt]+') (main spec id:'+get_total_stock.SPECT_MAIN_ID[cnt]+')\n';
					  }
					  else
					  {
						  if(parseFloat(get_total_stock.PRODUCT_TOTAL_STOCK[cnt]) < parseFloat(list_getat(main_spec_amount_list,yer,',')))
							  hata = hata+ 'Ürün:'+get_total_stock.PRODUCT_NAME[cnt]+'(Stok Kodu:'+get_total_stock.STOCK_CODE[cnt]+') (main spec id:'+get_total_stock.SPECT_MAIN_ID[cnt]+')\n';
					  }
				  }
			  }
			  var diff_spec_id='0';
			  if(list_find('73,74,75,76,77,80,761,82,84,86,87,114,761,115,110,140',process_type)==0 && is_purchase_ == 0) //alış tipli işlemlerde bu kontrole gerek yok
			  {
				  for(var lst_cnt=1;lst_cnt <= list_len(main_spec_id_list,',');lst_cnt++)
				  {
					  var spc_id=list_getat(main_spec_id_list,lst_cnt,',');
					  if(!list_find(query_spec_id_list,spc_id,','))
						  diff_spec_id=diff_spec_id+','+spc_id;//kayıt gelmeyen urunler
				  }
				  if(diff_spec_id!='0' && list_len(diff_spec_id,',')>1)
				  {//bu lokasyona hiç giriş veya çıkış olmadı ise kayıt gelemyecektir o yüzden else yazıldı
					  var new_sql = 'obj_get_stock_6';
					  if(stock_type!=undefined && stock_type==1) //satılabilir stoguna bakılmıssa ve kayıt yoksa stoklarla sınırlı olup olmadıgı kontrol ediliyor
						  new_sql = 'obj_get_stock_7'; //main specte secilmis mi
					  var get_stock = wrk_safe_query(new_sql,'dsn3',0,diff_spec_id);
					  for(var cnt=0; cnt < get_stock.recordcount; cnt++)
						  hata = hata+ 'Ürün:'+get_stock.PRODUCT_NAME[cnt]+'(Stok Kodu:'+get_stock.STOCK_CODE[cnt]+') (main spec id:'+get_stock.SPECT_MAIN_ID[cnt]+')\n';
				  }
			  }
			  get_total_stock='';
		  }
	  }
	  if(lotno_hata != '')
	  {
		  if(stock_type==undefined || stock_type==0)
			  alert(lotno_hata+'\n\nYukarıdaki ürünlerde lot no bazında stok miktarı yeterli değildir. Lütfen seçtiğiniz depo-lokasyonundaki miktarları kontrol ediniz !');
		  else
			  alert(lotno_hata+'\n\nYukarıdaki ürünlerde lot no bazında satılabilir stok miktarı yeterli değildir. Lütfen miktarları kontrol ediniz !');
		  lotno_hata='';
		  return false;
	  
	  }
	  else if(hata!='')
	  {
		  if(stock_type==undefined || stock_type==0)
			  alert(hata+'\n\nYukarıdaki ürünlerde stok miktarı yeterli değildir. Lütfen seçtiğiniz depo-lokasyonundaki miktarları kontrol ediniz !');
		  else
			  alert(hata+'\n\nYukarıdaki ürünlerde satılabilir stok miktarı yeterli değildir. Lütfen miktarları kontrol ediniz !');
		  hata='';
		  return false;
	  }
	  else
		  return true;
  }
  function selectedCurrency(currency)
  {
	  window.basket.footer.basketCurrencyType = currency;
	  window.basket.footer.basket_money = currency;	
	  $("#basket_main_div #basket_money").val(currency);
  }
  function basket_set_height()
  {
  /* 	var $child = $('#sepetim');
	  var h1 = $child.position().top;
	  h2 = document.body.clientHeight;
	  <cfif not ListFindNoCase(display_list, "price_total")>
		  b_special_height = h2 - h1 - 45;
	  <cfelse>
		  b_special_height = h2 - h1 - 144;
	  </cfif>
	  if(b_special_height < 100)
		  b_special_height = 100;
	  <cfif isdefined('attributes.is_retail') or ListFindNoCase(display_list, "basket_cursor")>
		  b_special_height = b_special_height - 30;
	  </cfif>
	  document.getElementById('sepetim').style.height = b_special_height + 40 + 'px';
	  fixThead(b_special_height); */
  }
  function SetFrameHeight(h1)
  {
	  document.getElementById('_add_prod_').style.height = h1 + 'px';
  }
  function goPage()
  {
	  if(parseFloat($("#basket_main_div #pageNumber").val()) < 1)
		  $("#basket_main_div #pageNumber").val(1);
		  
	  if(window.basket.items.length % window.basket.pageSize == 0)
	  {
		  //window.basket.scrollIndex = (Math.floor(window.basket.items.length / window.basket.pageSize)-1) * window.basket.pageSize;
		  if($("#basket_main_div #pageNumber").val()>Math.floor(window.basket.items.length / window.basket.pageSize))
			  $("#basket_main_div #pageNumber").val(Math.floor(window.basket.items.length / window.basket.pageSize));
		  window.basket.scrollIndex = (parseFloat($("#basket_main_div #pageNumber").val()) * window.basket.pageSize) - window.basket.pageSize;
	  }
	  else
	  {
		  //window.basket.scrollIndex = (Math.floor(window.basket.items.length / window.basket.pageSize)) * window.basket.pageSize;
		  if($("#basket_main_div #pageNumber").val()>Math.floor(window.basket.items.length / window.basket.pageSize)+1)
			  $("#basket_main_div #pageNumber").val(Math.floor(window.basket.items.length / window.basket.pageSize)+1);
		  window.basket.scrollIndex = (parseFloat($("#basket_main_div #pageNumber").val()) * window.basket.pageSize) - window.basket.pageSize+1;
	  }
		  
	  /*	
	  if(window.basket.items.length % window.basket.pageSize == 0)
		  window.basket.scrollIndex = (Math.floor(window.basket.items.length / window.basket.pageSize)-1) * window.basket.pageSize;
	  else
		  window.basket.scrollIndex = (Math.floor(window.basket.items.length / window.basket.pageSize)) * window.basket.pageSize;
	  */
	  window.basket.scrollIndex = (parseFloat($("#basket_main_div #pageNumber").val()) * window.basket.pageSize) - window.basket.pageSize;
	  if(window.basket.scrollIndex > window.basket.items.length)
		  window.basket.scrollIndex = window.basket.items.length - window.basket.pageSize;
	  else if(window.basket.scrollIndex + window.basket.pageSize == window.basket.items.length)
		  $("#btnNext, #btnLast").attr('disabled', 'disabled');
	  else
		  $("#btnNext, #btnLast").removeAttr("disabled");
	  showBasketItems();
  }
  function genelIndirimHesapla(obj)
  {
	  
	  if(!obj.value.length) 
		  this.value=0; 
	  form_basket.genel_indirim.value = filterNum(obj.value,basket_total_round_number);
	  form_basket.genel_indirim_.value = filterNum(obj.value,basket_total_round_number);
	  window.basket.hidden_values.genel_indirim_ = parseFloat(obj.value);
	  window.basket.footer.genel_indirim_ = window.basket.hidden_values.genel_indirim_;
	  toplam_hesapla(1);
  }
  function lotno_control(crntrw)
  {
	  //var prohibited=' [space] , ",  $, %, &, ', (, ), *, +, ,, ., /, <, =, >, ?, @, [, \, ], ], _, `, {, |,   }, , «, ';
	  var prohibited_asci='32,34,35,36,37,38,39,40,41,42,43,44,47,60,61,62,63,64,91,92,93,94,96,123,124,125,156,171';
	  lotno_control_input = $("#tblBasket tr[basketItem]").eq(crntrw).find("#lot_no");
	  toplam_ = lotno_control_input.val().length;
	  deger_ = lotno_control_input.val();
	  
	  if(toplam_>0)
	  {
		  for(var this_tus_=0; this_tus_< toplam_; this_tus_++)
		  {
			  tus_ = deger_.charAt(this_tus_);
			  cont_ = list_find(prohibited_asci,tus_.charCodeAt());
			  if(cont_>0)
			  {
				  alert("[space],\"\,##,$,%,&,',(,),*,+,,,/,<,=,>,?,@,[,\,],],`,{,|,},«,; Katakterlerinden Oluşan Lot No Girilemez!");
				  lotno_control_input.val('');
				  break;
			  }
		  }
	  }
  }
  function fixThead(height_)
  {
	  /* $('#tblBasket').fixedHeaderTable({ height : height_,  footer: false, cloneHeadToFoot: false }); */
	  //Basket thead kısmının tbody kısmından bağımsız hareket etmesini engellemek için eklendi.
  
	  /* $(".fht-thead").scrollLeft(0);
  
	  $(".fht-thead").scroll(function() {
		  console.log("ss");
		  $(this).scrollLeft(0);
	  }); */
  }
  $('.fsBtn').click(function(){
	  var portBox = $(this).parent().parent('div.portBox');
	  //console.log("test"+this);
	  portBox.toggleClass( "fullScreen");
  });	//.portbox fullscreen
  </script>