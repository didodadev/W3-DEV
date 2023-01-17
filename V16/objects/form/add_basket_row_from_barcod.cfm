<cfset xml_page_control_list = 'xml_use_paymethod_for_prod_conditions,xml_use_general_price_cat_exceptions'>
<cf_xml_page_edit page_control_list="#xml_page_control_list#" fuseact="objects.popup_products"><!--- urun popupındaki xmlden calısır --->
<script src="../../../JS/js_functions.js"></script>
<cfif not isdefined("session.ep.userid") or (isdefined("moneyformat_style") and moneyformat_style eq 0)>
	<script type="text/javascript" src="../../../JS/js_functions_money_tr.js"></script>
<cfelse>
	<script type="text/javascript" src="../../../JS/js_functions_money.js"></script>
</cfif>

<!---add_speed_prod özelleştirilimiş QR kodun barkoda aktarılması içine gerekli olan query --->
<cfif isDefined('x_qr_barcode_enable') And x_qr_barcode_enable eq 1>
	<cfquery datasource="#dsn#" name="get_barkod_category">
		SELECT * FROM BARKOD_CATEGORY_CONVERSION
	</cfquery>
	<cfset data = replace(serializeJSON(get_barkod_category),"//","","All")/>
</cfif>
<!---add_speed_prod özelleştirilimiş QR kodun barkoda aktarılması içine gerekli olan query --->

<script type="text/javascript" src="index.cfm?fuseaction=home.emptypopup_special_functions&this_fuseact=myhome.welcome"></script>
<!--- <link rel="stylesheet" href="/css/assets/template/win_ie.css" type="text/css">
<link rel="stylesheet" href="/css/assets/template/catalyst/catalyst.css" type="text/css"> --->
<style>
	body{margin:0;}
	/* Ui-Form */
.ui-form-list{display: flex;flex-wrap: wrap;}
.ui-form-list .form-group{display:flex;align-items:center;margin:0 0 5px 0!important;color:#555;font-size:12px;}
td .ui-form-list .form-group{margin:0!important;}
.ui-form-list .col > .col{padding-left:0;}
.ui-form-list .col > .col:last-child{padding-right:0;}
.ui-form-list .form-group label{display:block!important;line-height:inherit!important;margin:0!important;font-size:12px;color:#555;}
.ui-form-list .form-group input:not(.select2-search__field):not([type='checkbox']):not([type='radio']):not([type='submit']), .ui-form-list .form-group select, .ui-form-list .form-group textarea{width:100%;height:auto!important;min-height:30px!important;line-height:initial!important;font-size:12px!important;outline:none;color:#555;padding:5px;border:1px solid #ddd!important;box-shadow:none!important;resize:none;}
.ui-form-list .form-group textarea{height:auto!important;}
.ui-form-list .form-group img{height:initial!important;width:initial!important;max-width:100%;}
.ui-form-list .form-group input::placeholder , .ui-form-list .form-group select::placeholder , .ui-form-list .form-group textarea::placeholder {font-size:12px!important;color:#555;}
.ui-form-list .form-group input:-ms-input-placeholder, .ui-form-list .form-group :-ms-input-placeholder, .ui-form-list .form-group textarea:-ms-input-placeholder {font-size:12px!important;color:#555;}
.ui-form-list .form-group input::-ms-input-placeholder, .ui-form-list .form-group select::-ms-input-placeholder, .ui-form-list .form-group textarea::-ms-input-placeholder {font-size:12px!important;color:#555;}
.ui-form-list .form-group input[type="submit"]{width: 100%;padding: 0 10px!important;color: #fff;height: 28px!important;text-align: center;line-height: 28px;border: 0!important;transition:.4s;}
.ui-form-list .form-group input[type="submit"]:hover{background-color:#527DA8;transition:.4s;}
.ui-form-list .form-group input[type="file"]{border: 0!important;}
.ui-form-list .form-group .input-group .input-group-addon{border:0!important;padding:0 10px!important;border-color:#ddd!important;}
.ui-form-list .form-group .input-group .width{width:80px;padding:0!important;}
.ui-form-list .form-group .input-group .width select, .ui-form-list .form-group .input-group .width input{border:0!important;}
.ui-form-list .form-group .input-group .width select{background-color:#eaeaea;}
.ui-form-list .select2-container--default .select2-selection--multiple{cursor:pointer;border:1px solid #ddd!important;border-radius:0!important;}
.ui-form-list .select2-container--default.select2-container--focus .select2-selection--multiple{border:1px solid #ddd!important;border-radius:none!important;}
.ui-form-list .select2-container--default .select2-selection--multiple .select2-selection__choice{font-size:12px;margin:2px 3px!important;padding:2px 3px!important;;border:1px solid #eaeaea!important;background-color:#f9f9f9!important;}
.ui-form-list .select2-selection__clear{display:none;}
/* select{cursor:pointer;-webkit-appearance: none;-moz-appearance: none;appearance: none;background-image: url(/images/angle_down.png)!important;background-size: 13px;background-repeat: no-repeat;background-position: center right 5px;} */
table select{background-image:none!important;}

.ui-form-list .select2-container--default .select2-selection--single .select2-selection__arrow{height:33px!important;}
.ui-form-list .select2-container .select2-selection--multiple{min-height:30px!important;background-image: url(/images/angle_down.png)!important;background-size: 12px;background-repeat: no-repeat;background-position: center right 5px;}
.select2-dropdown{border:1px solid #f9f9f9!important;border-radius:0!important;}
.ui-form-list .select2-container .select2-selection--single{height:auto!important;}
.ui-form-list .select2-container--default .select2-selection--single .select2-selection__rendered{font-family:'Roboto';color:#555!important;padding:5px 20px 5px 5px!important}
.ui-form-list .select2-container--default .select2-selection--single{border:1px solid #eee!important;}
.ui-form-list .select2-container--default .select2-selection--multiple .select2-selection__rendered{max-height: 100px;overflow: auto;padding:3px 20px 3px 5px!important;}
/* .ui-form-list .form-group .input-group input{width:auto!important;} */
.ui-form-list .checkbox.checbox-switch{text-align:left;}
.ui-form-list .checkbox.checbox-switch label{display:inline-block;}
.ui-form-block .form-group{display:block;width:100%;}
.ui-form-block .form-group label{margin:0 0 5px 0!important;}

/* Flex-List */
.flex-list .form-group{margin:5px 5px 5px 0!important;}
.flex-list .small{width:50px;}
.flex-list .medium{width:100px;}
.flex-list .large{width:150px;}

</style>
<cfobject name="barcode_basket" type="component" component="V16.objects.cfc.basket"> 
<cfset basket_data = barcode_basket.get_basket(attributes.int_basket_id)>

<cfquery name="get_basket_displays" dbtype="query">
	SELECT 
		TITLE,TITLE_NAME,GENISLIK,PURCHASE_SALES,IS_READONLY,IS_REQUIRED
	FROM 
		basket_data 
	WHERE 
		IS_SELECTED = 1
		AND TITLE IN (#listqualify('barcode_price_list,barcode_amount,barcode_amount_2,barcode_stock_code,barcode_barcode,barcode_serial_no,barcode_lot_no,barcode_choose_row',"'")#)
	ORDER BY 
		LINE_ORDER_NO ASC
</cfquery>
<cfset display_list = valueList(get_basket_displays.title)>

<cfsetting showdebugoutput="no">
<cfparam name="attributes.add_amount_" default="1">
<cfparam name="attributes.add_amount_2_" default="1">
<div id="_add_prod_main_row_">
<form name="add_speed_prod" id="add_speed_prod" action="" method="post">
    <input type="hidden" name="basket_product_list_type" id="basket_product_list_type" value="">
    <input type="hidden" name="dsp_only_member_price_cat_sales" id="dsp_only_member_price_cat_sales" value="<cfif isdefined('xml_use_member_price_cat_sales')><cfoutput>#xml_use_member_price_cat_sales#</cfoutput><cfelse>0</cfif>"><!--- urun listesi xml inde sadece uye risk tanımlarındaki fiyat listesi gelsin secilmisse --->
    <input type="hidden" name="dsp_only_member_price_cat_purchase" id="dsp_only_member_price_cat_purchase" value="<cfif isdefined('xml_use_member_price_cat_purchase')><cfoutput>#xml_use_member_price_cat_purchase#</cfoutput><cfelse>0</cfif>"><!--- urun listesi xml inde sadece uye risk tanımlarındaki fiyat listesi gelsin secilmisse --->
    <input type="hidden" name="is_price_list_products_" id="is_price_list_products_" value="<cfif isdefined('is_price_list')><cfoutput>#is_price_list#</cfoutput><cfelse>0</cfif>"><!--- urun listesi xml inde Sadece Fiyat Listesinde Fiyatı Olan Ürünler Gelsin  secilmisse--->
    <input type="hidden" name="is_from_sale" id="is_from_sale" value="<cfif isdefined("attributes.is_from_sale")>1<cfelse>0</cfif>"><!--- Hızlı satış ekranından geliyorsa departman,tarih vs almasın diye eklendi --->
		<div class="ui-form-list flex-list">
			<cfif listFindNoCase(display_list, "barcode_price_list")>
				<div class="form-group">
					<select name="price_catid_for_speed_" id="price_catid_for_speed_"></select>
				</div>
			</cfif>
			<cfif listFindNoCase(display_list, "barcode_amount")>
				<div class="form-group small">
					<input type="text" name="add_amount_" id="add_amount_" placeholder="<cfoutput><cf_get_lang dictionary_id='57635.Miktar'></cfoutput>" onBlur="if(this.value.length==0 || filterNum(this.value)==0) this.value = commaSplit(1,'<cfoutput>#attributes.amount_round_number#</cfoutput>');" value="<cfoutput>#AmountFormat(attributes.add_amount_,attributes.amount_round_number)#</cfoutput>"  onkeyup="return(FormatCurrency(this,event,'<cfoutput>#attributes.amount_round_number#</cfoutput>'));" onKeyDown="if(event.keyCode == 13) {add_barkod_serial();}">
				</div>
			</cfif>
			<cfif listFindNoCase(display_list, "barcode_amount_2")>
				<div class="form-group small">
					<input type="text" name="add_amount_2_" id="add_amount_2_" placeholder="<cfoutput><cf_get_lang dictionary_id='57635.Miktar'> 2</cfoutput>" onBlur="if(this.value.length==0 || filterNum(this.value)==0) this.value = commaSplit(1,'<cfoutput>#attributes.amount_round_number#</cfoutput>');" value="<cfoutput>#AmountFormat(attributes.add_amount_2_,attributes.amount_round_number)#</cfoutput>"  onkeyup="return(FormatCurrency(this,event,'<cfoutput>#attributes.amount_round_number#</cfoutput>'));" onKeyDown="if(event.keyCode == 13) {add_barkod_serial();}">
				</div>
			</cfif>
			<cfif listFindNoCase(display_list, "barcode_stock_code")>
				<div class="form-group">
					<input name="add_stock_code_" id="add_stock_code_" placeholder="<cfoutput><cf_get_lang dictionary_id='57518.Stok Kodu'></cfoutput>" type="text" value="" onKeyDown="if(event.keyCode == 13) {add_barkod_serial(2);}"><!---  onFocus="AutoComplete_Create('add_stock_code_','STOCK_CODE','STOCK_CODE,PRODUCT_NAME','get_product_autocomplete','\'0\',\'1\'','STOCK_ID','add_stock_id_','add_speed_prod','3','250','add_barkod_serial()','1');" iframe icinde acılan div in display sorunları var, acılırsa bu konuya bakılacak --->
				</div>
			</cfif>
			<cfif listFindNoCase(display_list, "barcode_barcode")>
				<div class="form-group">
					<input name="add_barcod_" id="add_barcod_" type="text" placeholder="<cfoutput><cf_get_lang dictionary_id='57633.Barkod'></cfoutput>" value="" onKeyDown="if(event.keyCode == 13) {add_barkod_serial(1);}">
				</div>
			</cfif>
			<cfif listFindNoCase(display_list, "barcode_serial_no")>
				<div class="form-group">
					<input name="serial_number" id="serial_number" placeholder="<cfoutput><cf_get_lang dictionary_id='57637.Seri No'></cfoutput>" type="text" value="" onKeyDown="if(event.keyCode == 13) {add_barkod_serial(3);}">
				</div>
			</cfif>
			<cfif listFindNoCase(display_list, "barcode_lot_no")>
				<div class="form-group">
					<input name="lotNoQrCode" placeholder="<cfoutput><cf_get_lang dictionary_id='32916.Lot No'></cfoutput>" id="lotNoQrCode" type="text" value="" onKeyDown="if(event.keyCode == 13) {add_barkod_serial(4);}">
				</div>
			</cfif>
			<cfif listFindNoCase(display_list, "barcode_choose_row")>
				<div class="form-group">
					<select name="multi_row_" id="multi_row_">
						<option value="1"><cf_get_lang dictionary_id="60120.Tek satır"></option>
						<option value="2"><cf_get_lang dictionary_id="60121.2 Birim Kadar Çoklu Satır"></option>
					</select>
				</div>
			</cfif>
			<div class="form-group" id="SHOW_INFO"></div>
		</div>
    <input type="hidden" value="" name="add_stock_id_" id="add_stock_id_">
    <input type="hidden" name="url_info" id="url_info" value="">
    <input type="hidden" name="paper_process_type" id="paper_process_type" value="">
 </form>
<form name="form_product" method="post" action="">
	<input type="hidden" name="use_paymethod_for_prod_conditions" id="use_paymethod_for_prod_conditions" value="<cfif isdefined('xml_use_paymethod_for_prod_conditions')><cfoutput>#xml_use_paymethod_for_prod_conditions#</cfoutput></cfif>">
	<input type="hidden" name="use_general_price_cat_exceptions" id="use_general_price_cat_exceptions" value="<cfif isdefined('xml_use_general_price_cat_exceptions')><cfoutput>#xml_use_general_price_cat_exceptions#</cfoutput></cfif>">
	<input type="hidden" name="use_project_discounts" id="use_project_discounts" value="<cfif isdefined('xml_use_project_discounts')><cfoutput>#xml_use_project_discounts#</cfoutput></cfif>">
	<input type="hidden" name="from_add_barcod" id="from_add_barcod" value="1">
	<input type="hidden" name="is_basket_zero_stock" id="is_basket_zero_stock" value="0">
	<input type="hidden" name="from_price_page" id="from_price_page" value="1">
	<input type="hidden" name="update_product_row_id" id="update_product_row_id" value="0">
	<input type="hidden" name="product_id" id="product_id" value="" >
	<input type="hidden" name="stock_id" id="stock_id" value="">
	<input type="hidden" name="stock_code" id="stock_code" value="">
	<input type="hidden" name="barcod" id="barcod" value="">
	<input type="hidden" name="manufact_code" id="manufact_code" value="">
	<input type="hidden" name="product_name" id="product_name" value="">
	<input type="hidden" name="unit_id" id="unit_id" value="">
	<input type="hidden" name="unit" id="unit"  value="">
	<input type="hidden" name="is_inventory" id="is_inventory"  value="">
	<input type="hidden" name="product_code" id="product_code" value="">
	<input type="hidden" name="amount" id="amount" value="">
	<input type="hidden" name="unit_multiplier" id="unit_multiplier" value="">	
	<input type="hidden" name="amount_multiplier" id="amount_multiplier" value="">
	<input type="hidden" name="price_cat_amount_multiplier" id="price_cat_amount_multiplier" value="1">
	<input type="hidden" name="kur_hesapla" id="kur_hesapla" value="">	
	<input type="hidden" name="is_sale_product" id="is_sale_product" value="">
	<input type="hidden" name="tax" id="tax" value="">
	<input type="hidden" name="otv" id="otv" value="">
	<input type="hidden" name="flt_price_other_amount" id="flt_price_other_amount"  value="">
	<input type="hidden" name="str_money_currency" id="str_money_currency"  value="">
	<input type="hidden" name="department_id" id="department_id" value="">
	<input type="hidden" name="due_day_value" id="due_day_value" value="">	
	<input type="hidden" name="department_name" id="department_name" value="">
	<input type="hidden" name="branch_id" id="branch_id" value="<cfif isdefined("branch_id")><cfoutput>#branch_id#</cfoutput></cfif>">
	<input type="hidden" name="row_promotion_id" id="row_promotion_id" value="">
	<input type="hidden" name="promosyon_yuzde" id="promosyon_yuzde" value="">
	<input type="hidden" name="promosyon_maliyet" id="promosyon_maliyet" value="">
	<input type="hidden" name="promosyon_form_info" id="promosyon_form_info" value="">
	<input type="hidden" name="basket_id" id="basket_id" value="<cfif isdefined('attributes.int_basket_id')><cfoutput>#attributes.int_basket_id#</cfoutput></cfif>">
	<input type="hidden" name="spec_id" id="spec_id" value="">
	<input type="hidden" name="is_production" id="is_production" value="">
	<input type="hidden" name="ek_tutar" id="ek_tutar" value="0">
	<input type="hidden" name="unit_other" id="unit_other" value="">
	<input type="hidden" name="price_catid" id="price_catid" value="">
	<input type="hidden" name="shelf_number" id="shelf_number" value="">
	<input type="hidden" name="deliver_date" id="deliver_date" value="">
	<input type="hidden" name="duedate" id="duedate" value="">
	<input type="hidden" name="number_of_installment" id="number_of_installment" value="">
	<input type="hidden" name="list_price" id="list_price" value="">
	<input type="hidden" name="amount_other" id="amount_other" value="">
	<input type="hidden" name="catalog_id" id="catalog_id" value="">
	<input type="hidden" name="d1" id="d1" value="">
	<input type="hidden" name="d2" id="d2" value="">
	<input type="hidden" name="d3" id="d3" value="">
	<input type="hidden" name="d4" id="d4" value="">
	<input type="hidden" name="d5" id="d5" value="">
	<input type="hidden" name="d6" id="d6" value="">
	<input type="hidden" name="lot_no" id="lot_no" value="">
	<input type="hidden" name="gtip_number" id="gtip_number" value="">
	<input type="hidden" name="expense_center_id" id="expense_center_id" value="">
	<input type="hidden" name="expense_center_name" id="expense_center_name" value="">
	<input type="hidden" name="expense_item_id" id="expense_item_id" value="">
	<input type="hidden" name="expense_item_name" id="expense_item_name" value="">
	<input type="hidden" name="activity_type_id" id="activity_type_id" value="">
	<input type="hidden" name ="bsmv_" id="bsmv_" value="">
	<input type="hidden" name ="product_detail2" id="product_detail2" value="">
	<input type="hidden" name ="reason_code" id="reason_code" value="">
	<input type="hidden" name ="multi_row" id="multi_row" value="">
	<input type="hidden" name ="number" id="number" value="">
	<input type="hidden" name="reserve_date" id="reserve_date" value="">
</form>
</div>
<script type="text/javascript">
	function add_barkod_serial(number)
	{
		if(!parent.control_comp_selected(-1)) return false; 
		if(document.add_speed_prod.price_catid_for_speed_.options[document.add_speed_prod.price_catid_for_speed_.selectedIndex].value=='')
		{alert('Fiyat Listesi Seçiniz'); return false;}

		<!---add_speed_prod özelleştirilimiş QR kodun barkoda aktarılması içine gerekli olan JS tanımlamaları --->
		<cfif isDefined('x_qr_barcode_enable') And x_qr_barcode_enable eq 1 and listFindNoCase(display_list, "barcode_barcode")>
			var barcod =((document.add_speed_prod.add_barcod_.value).replace("'","")).substring(3,16);
			var JSONX = <cfoutput>#data#</cfoutput>;
			var lotno = ((document.add_speed_prod.add_barcod_.value).replace("'","")).substring(19,32);
			while (lotno.substr(0,1) == '0' && lotno.length>1) { lotno = lotno.substr(1,9999); }
			var deliverdate =((document.add_speed_prod.add_barcod_.value).replace("'","")).substring(34);
		<cfelseif listFindNoCase(display_list, "barcode_barcode")>
			var barcod = (document.add_speed_prod.add_barcod_.value).replace("'","");
		<cfelse>
			var barcod = "";
			var lotno = "";
		</cfif>
		<!---add_speed_prod özelleştirilimiş QR kodun barkoda aktarılması içine gerekli olan JS tanımlamaları --->
		<cfif listFindNoCase(display_list, "barcode_serial_no")>
			var serial_no =(document.add_speed_prod.serial_number.value).replace("'","");
		<cfelse>
			var serial_no = "";
		</cfif>
		var add_stock_code_js_= (document.add_speed_prod.add_stock_code_.value).replace("'","");;
		var add_stock_id_js_ =document.add_speed_prod.add_stock_id_.value;
		input_value = parent.$("#basket_main_div #" + parent.$("#basket_main_div #search_process_date").val()).val();
		var temp_date1 = js_date(input_value.toString());
		var lotNoQrCode =(document.add_speed_prod.lotNoQrCode.value).replace("'","");
		var multi_row = document.add_speed_prod.multi_row_.value;// 1) Tek Satır  2) 2. Birim Kadar Çoklu Satır 20200129ERU
		var str_seri_sale_control_ = "";
		if(multi_row == 2){//2. Birim Kadar Çoklu Satır seçili ise miktar 2 yi alır
			row_count = document.add_speed_prod.add_amount_2_.value;
		}
		else{//Tek Satır seçili ise 1 defa
			row_count = 1;
		}
		if(row_count == undefined)
		{
			alert("2. <cf_get_lang dictionary_id='41304.Birim Giriniz'>!");
			return false;
		}
		for(multi_count = 1; multi_count <= row_count; multi_count++)//Miktar2 kadar döner ERU
		{
			if(parent.$("#basket_main_div #basket_due_value") != undefined)
				temp_due_day_value = parent.$("#basket_main_div #basket_due_value").val();
			if(serial_no !='' && serial_no != 0 )
			{
				if(document.add_speed_prod.add_amount_.value != 1)	document.add_speed_prod.add_amount_.value = 1;  //aynı seri no ile 1 adet urun eklenebilir
				var seri_list='';
				if( parent.window.basketManager !== undefined ){ 
					if(parent.basketManagerObject.basketItems().length){
						for (i=0; i < parent.basketManagerObject.basketItems().length; i++){
							if(!list_find(seri_list, parent.basketManagerObject.basketItems()[i].lot_no(),',')){
								if(i != 0)
									seri_list = seri_list + ',' ;
								seri_list = seri_list + parent.basketManagerObject.basketItems()[i].lot_no();
							}
						}	
					}
				}else{
					if(parent.window.basket.items.length)
					{
						if(parent.window.basket.items.length == 1 && parent.window.basket.items[0].LOT_NO.length)
							seri_list = seri_list + parent.window.basket.items[0].LOT_NO;
						else
						{
							for (i=0; i < parent.window.basket.items.length; i++)
							{
								if(!list_find(seri_list,parent.window.basket.items[i].LOT_NO,','))
								{
									if(i != 0)
										seri_list = seri_list + ',' ;
									seri_list = seri_list + parent.window.basket.items[i].LOT_NO;
								}
							}
						}
					}
				}
			}
			d1 = 0;
			d2 = 0;
			d3 = 0;
			d4 = 0;
			d5 = 0;	
			d6 = 0;	
			if( (barcod != undefined && barcod !='') || (serial_no != undefined && serial_no !='') || (add_stock_id_js_ != undefined && add_stock_id_js_ != '') || (add_stock_code_js_!= undefined && add_stock_code_js_!='')||(lotNoQrCode!= undefined && lotNoQrCode!='') )
			{	
				if(barcod != undefined && barcod !='')
				{
					var listParam = barcod;
		
					if( ( ( ( parent.window.basketManager !== undefined ) ? parent.basketService.sale_product() : parent.window.basket.hidden_values.sale_product ) == 1 && document.add_speed_prod.paper_process_type.value !=62 ) || document.add_speed_prod.paper_process_type.value ==54 || document.add_speed_prod.paper_process_type.value ==55 )
					{
						str_product_detail_ = "obj_get_product_detail";
						<cfif isdefined('attributes.is_store_module')>
							str_product_detail_ = "obj_get_product_detail_3";
						</cfif>
						}
					else{
						str_product_detail_ = "obj_get_product_detail_2";
						<cfif isdefined('attributes.is_store_module')>
							str_product_detail_ = "obj_get_product_detail_4";
						</cfif>
						}
					var get_product_detail_ = wrk_safe_query(str_product_detail_,'dsn3',0,listParam);
					if(get_product_detail_.recordcount ==0)
					{
						alert("<cf_get_lang dictionary_id='58642.Ürün Kaydı Bulunamadı'>!");
						if(number == 1)
						{
							document.getElementById('add_barcod_').value = '';
							document.getElementById('add_barcod_').focus();
						}
						return false;
					}
					<!---add_speed_prod özelleştirilimiş QR kodun barkoda aktarılması içine gerekli olan JS kuralları --->
				<cfif isDefined('x_qr_barcode_enable') And x_qr_barcode_enable eq 1>
					if(document.add_speed_prod.add_amount_.value != 1)	document.add_speed_prod.add_amount_.value = 1;  //aynı barcod no ile 1 adet urun eklenebilir
					var seri_list='';
					var lot_list ='';

					if( parent.window.basketManager !== undefined ){ 
						if(parent.basketManagerObject.basketItems().length){
							for (i=0; i < parent.basketManagerObject.basketItems().length; i++){
								if(!list_find(seri_list, parent.basketManagerObject.basketItems()[i].product_id(),',')){
									if(i != 0){
										seri_list = seri_list + ',' ;
										lot_list = lot_list + ',' ;
									}	
									seri_list = seri_list + parent.basketManagerObject.basketItems()[i].product_id();
									lot_list = lot_list + parent.basketManagerObject.basketItems()[i].lot_no();
								}
							}
						}

					}else{
						if(parent.window.basket.items.length)
						{
							if(parent.window.basket.items.length == 1 && parent.window.basket.items[0].PRODUCT_ID.length)
							{
								seri_list = seri_list + parent.window.basket.items[0].PRODUCT_ID;
								lot_list = lot_list + parent.window.basket.items[0].LOT_NO;
							}
							else
							{
								for (i=0; i < parent.window.basket.items.length; i++)
								{
									if(!list_find(seri_list,parent.window.basket.items[i].PRODUCT_ID,','))
									{
										if(i != 0){
											seri_list = seri_list + ',' ;
											lot_list = lot_list + ',' ;
										}
											
										seri_list = seri_list + parent.window.basket.items[i].PRODUCT_ID;
										lot_list = lot_list + parent.window.basket.items[i].LOT_NO;
										
									}
								}
							}
						}
					}
					if(list_find(seri_list,get_product_detail_.PRODUCT_ID)&& (list_find(lot_list,lotno)))
					{
						alert("<cf_get_lang dictionary_id='32710.Bu Seri Daha Önce Eklenmişti'> !");
						return false;
					}
					var stockcode = get_product_detail_.STOCK_CODE.toString();
					for (let i = 0; i < JSONX.DATA.length; i++) {
						Datain = JSONX.DATA[i]
						category = Datain[0];
						date_parameter = Datain[1];
						len = category.length;
						year_ = deliverdate.substring(0,4);
						month_ = deliverdate.substring(4,6);
						day_ = deliverdate.substring(6,8);
						var res = stockcode.substring(0, len);
						if (res == category) {
							var dataparameter = date_parameter;
							yıl = dataparameter / 12 ;
							ay = dataparameter % 12 ;
							yıl_ = Math.floor(yıl);
							var full_date_ = day_ +"/"+month_+"/"+year_ ;
							if (ay > month_) {
								new_year = year_ - (yıl_+1);
								var new_month = month_ +  (ay - month_);
								if (new_month.toString().length == 1) {
									new_month = "0" + new_month;
								}
								var full_date = day_ +"/"+new_month+"/"+new_year ;
							}
							else{
								new_year = year_ - yıl_;
								var new_month = month_ - ay ;
								if (new_month.toString().length == 1) {
									new_month = "0" + new_month;
								}
								var full_date = day_ +"/"+new_month+"/"+new_year ;
							}
							break ;
						}
						else{
							var full_date = '' ;
							var full_date_ = day_ +"/"+month_+"/"+year_ ;
						}
					}
				</cfif>
					<!---add_speed_prod özelleştirilimiş QR kodun barkoda aktarılması içine gerekli olan JS kuralları --->
					temp_stock_id_=get_product_detail_.STOCK_ID;
				}
				else if(serial_no != undefined && serial_no !='')
				{
					if(list_find(seri_list,serial_no))
					{
						alert("<cf_get_lang dictionary_id='32710.Bu Seri Daha Önce Eklenmişti'> !");
						return false;
					}
					
					<cfif isdefined('attributes.is_store_module')> 
						str_seri_sale_control_ = "obj_get_seri_sale_control_2";
					<cfelse>
						str_seri_sale_control_ = "obj_get_seri_sale_control";
					</cfif>
					var listParam = "<cfoutput>#dsn_alias#</cfoutput>" + "*" + serial_no;
					var get_seri_sale_control_ =wrk_safe_query(str_seri_sale_control_,'dsn3',0,listParam);
					if(get_seri_sale_control_.recordcount ==0)
					{ 
						alert("<cf_get_lang dictionary_id='32722.Bu Seri Nolu Ürün Satılamaz Durumda'>!");
						if(number == 3)
						{
							document.getElementById('serial_number').value = '';
							document.getElementById('serial_number').focus();
						}
						return false;
					}
					else
					{
						temp_stock_id_=get_seri_sale_control_.STOCK_ID;
						var listParam = temp_stock_id_ + "*" + "<cfoutput>#dsn1_alias#</cfoutput>";
						if((( ( parent.window.basketManager !== undefined ) ? parent.basketService.sale_product() : parent.window.basket.hidden_values.sale_product ) == 1 && document.add_speed_prod.paper_process_type.value !=62 ) || document.add_speed_prod.paper_process_type.value ==54 || document.add_speed_prod.paper_process_type.value ==55 )
						{
									str_product_detail_ = "obj_get_product_detail_5";
							<cfif isdefined('attributes.is_store_module')>
								str_product_detail_ = "obj_get_product_detail_7";
							</cfif>
						}
						else{
							str_product_detail_ = "obj_get_product_detail_6";
							<cfif isdefined('attributes.is_store_module')>
								str_product_detail_ = "obj_get_product_detail_8";
							</cfif>
							}
						var get_product_detail_ = wrk_safe_query(str_product_detail_,'dsn3',0,listParam);
						if(get_product_detail_.recordcount ==0)
						{
							alert("<cf_get_lang dictionary_id='58642.Ürün Kaydı Bulunamadı'>!");			
							return false;
						}
					}
					
				}
				else if((add_stock_id_js_ != undefined && add_stock_id_js_ != '') || (add_stock_code_js_!= undefined && add_stock_code_js_ != ''))
				{
					
					temp_stock_id_=add_stock_id_js_;
					if((( ( parent.window.basketManager !== undefined ) ? parent.basketService.sale_product() : parent.window.basket.hidden_values.sale_product ) == 1 && document.add_speed_prod.paper_process_type.value !=62 && document.add_speed_prod.paper_process_type.value !=81) || document.add_speed_prod.paper_process_type.value ==54 || document.add_speed_prod.paper_process_type.value ==55 )
						{
							if(add_stock_id_js_ != undefined && add_stock_id_js_ != '')
							{
								
								<cfif isdefined('attributes.is_store_module')>
									var listParam = temp_stock_id_ + "*" + 0 + "*" + "<cfoutput>#dsn1_alias#</cfoutput>" + "*" + "<cfoutput>#LISTGETAT(SESSION.EP.USER_LOCATION,2,'-')#</cfoutput>";
									str_product_detail_= "obj_get_product_detail_13";
								<cfelse>
									var listParam = temp_stock_id_ + "*" + 0 + "*" + "<cfoutput>#dsn1_alias#</cfoutput>";
									str_product_detail_= "obj_get_product_detail_9";
								</cfif>
								
							}
							else
							{
								<cfif isdefined('attributes.is_store_module')>
									var listParam = 0 + "*" + add_stock_code_js_ + "*" + "<cfoutput>#dsn1_alias#</cfoutput>" + "*" + "<cfoutput>#LISTGETAT(SESSION.EP.USER_LOCATION,2,'-')#</cfoutput>";
									str_product_detail_= "obj_get_product_detail_14";
								<cfelse>
									var listParam = 0 + "*" + add_stock_code_js_ + "*" + "<cfoutput>#dsn1_alias#</cfoutput>";
									str_product_detail_= "obj_get_product_detail_10";
								</cfif>
							}
						}
					else if(document.add_speed_prod.paper_process_type.value ==81)
						{
							<cfif isdefined('attributes.is_store_module')>
									var listParam = 0 + "*" + add_stock_code_js_ + "*" + "<cfoutput>#dsn1_alias#</cfoutput>" + "*" + "<cfoutput>#LISTGETAT(SESSION.EP.USER_LOCATION,2,'-')#</cfoutput>";
									str_product_detail_= "obj_get_product_detail_21";
							<cfelse>
							
									var listParam = 0 + "*" + add_stock_code_js_ + "*" + "<cfoutput>#dsn1_alias#</cfoutput>";
									str_product_detail_= "obj_get_product_detail_22";
							</cfif>
						}	
					else{
							if(add_stock_id_js_ != undefined && add_stock_id_js_ != '')
							{
								<cfif isdefined('attributes.is_store_module')>
									var listParam = add_stock_id_js_ + "*" + 0 + "*" + "<cfoutput>#dsn1_alias#</cfoutput>" + "*" + "<cfoutput>#LISTGETAT(SESSION.EP.USER_LOCATION,2,'-')#</cfoutput>";
									str_product_detail_= "obj_get_product_detail_15";
								<cfelse>
									var listParam = add_stock_id_js_ + "*" + 0 + "*" + "<cfoutput>#dsn1_alias#</cfoutput>";
									str_product_detail_= "obj_get_product_detail_11";
								</cfif>
							}
							else
							{
								<cfif isdefined('attributes.is_store_module')>
									var listParam = 0 + "*" + add_stock_code_js_ + "*" + "<cfoutput>#dsn1_alias#</cfoutput>" + "*" + "<cfoutput>#LISTGETAT(SESSION.EP.USER_LOCATION,2,'-')#</cfoutput>";
									str_product_detail_= "obj_get_product_detail_16";
								<cfelse>
									var listParam = 0 + "*" + add_stock_code_js_ + "*" + "<cfoutput>#dsn1_alias#</cfoutput>";
									str_product_detail_= "obj_get_product_detail_12";
								</cfif>
							}
					
					}
					var get_product_detail_ = wrk_safe_query(str_product_detail_,'dsn3',0,listParam);
					if(get_product_detail_.recordcount ==0)
					{
						alert("<cf_get_lang dictionary_id='58642.Ürün Kaydı Bulunamadı'>!");			
						return false;
					}
				}
				else if(lotNoQrCode != undefined && lotNoQrCode != '')
				{
					if((( ( parent.window.basketManager !== undefined ) ? parent.basketService.sale_product() : parent.window.basket.hidden_values.sale_product )==1 && document.add_speed_prod.paper_process_type.value !=62 ) || document.add_speed_prod.paper_process_type.value ==54 || document.add_speed_prod.paper_process_type.value ==55 )
						{
							// satış irsaliyesi 
							if(lotNoQrCode != undefined && lotNoQrCode != '')
							{
								<cfif isdefined('attributes.is_store_module')>
									var listParam = temp_stock_id_ + "*" + 0 + "*" + "<cfoutput>#dsn1_alias#</cfoutput>" + "*" + "<cfoutput>#LISTGETAT(SESSION.EP.USER_LOCATION,2,'-')#</cfoutput>";
									str_product_detail_= "obj_get_product_detail_13";
								<cfelse>
									var listParam = lotNoQrCode + "*" + '<cfoutput>#dsn2_alias#</cfoutput>' + "*" + "<cfoutput>#dsn1_alias#</cfoutput>";
									str_product_detail_= "obj_get_product_detail_qrcodeSales";
								</cfif>
							}
							else
							{
								<cfif isdefined('attributes.is_store_module')>
									var listParam = 0 + "*" + add_stock_code_js_ + "*" + "<cfoutput>#dsn1_alias#</cfoutput>" + "*" + "<cfoutput>#LISTGETAT(SESSION.EP.USER_LOCATION,2,'-')#</cfoutput>";
									str_product_detail_= "obj_get_product_detail_14";
								<cfelse>
									var listParam = 0 + "*" + add_stock_code_js_ + "*" + "<cfoutput>#dsn1_alias#</cfoutput>";
									str_product_detail_= "obj_get_product_detail_10";
								</cfif>
							}
						}
					else{
					
							if(lotNoQrCode != undefined && lotNoQrCode != '')
							{
								<cfif isdefined('attributes.is_store_module')>
									var listParam = lotNoQrCode + "*" + 0 + "*" + "<cfoutput>#dsn1_alias#</cfoutput>" + "*" + "<cfoutput>#LISTGETAT(SESSION.EP.USER_LOCATION,2,'-')#</cfoutput>";
									str_product_detail_= "obj_get_product_detail_15";
								<cfelse>
									var listParam = lotNoQrCode + "*" + '<cfoutput>#dsn2_alias#</cfoutput>' + "*" + "<cfoutput>#dsn1_alias#</cfoutput>";
									str_product_detail_= "obj_get_product_detail_qrcode";
								</cfif>
							}
							else
							{
								<cfif isdefined('attributes.is_store_module')>
									var listParam = 0 + "*" + temp_stock_id_ + "*" + "<cfoutput>#dsn1_alias#</cfoutput>" + "*" + "<cfoutput>#LISTGETAT(SESSION.EP.USER_LOCATION,2,'-')#</cfoutput>";
									str_product_detail_= "obj_get_product_detail_16";
								<cfelse>
									var listParam = 0 + "*" + temp_stock_id_ + "*" + "<cfoutput>#dsn1_alias#</cfoutput>";
									str_product_detail_= "obj_get_product_detail_12";
								</cfif>
							}
					
					}
					var get_product_detail_ = wrk_safe_query(str_product_detail_,'dsn3',0,listParam);
					if(get_product_detail_.recordcount ==0)
					{
						alert("<cf_get_lang dictionary_id='58642.Ürün Kaydı Bulunamadı'>!");	
						if(number == 2)
						{
							document.getElementById('add_stock_code_').value = '';
							document.getElementById('add_stock_code_').focus();
						}		
						else if(number == 4)
						{
							document.getElementById('lotNoQrCode').value = '';
							document.getElementById('lotNoQrCode').focus();
						}	
						return false;
					}
					temp_stock_id_=get_product_detail_.STOCK_ID;
				}
				if(document.add_speed_prod.price_catid_for_speed_.value !='')
					row_price_cat =document.add_speed_prod.price_catid_for_speed_.value;
				else if(( ( parent.window.basketManager !== undefined ) ? parent.basketService.sale_product() : parent.window.basket.hidden_values.sale_product ) == 1)
					row_price_cat =-2; //satır fiyat listesi standart satıs
				else
					row_price_cat =-1; //satır fiyat listesi standart alıs
								
				if(( ( parent.window.basketManager !== undefined ) ? parent.basketService.sale_product() : parent.window.basket.hidden_values.sale_product ) == 1) //satıs icin
				{
					if(parent.$("#basket_main_div #company_id").length != 0 && parent.$("#basket_main_div #company_id").val().length != 0)
						{
							if(get_product_detail_.BRAND_ID!='')
							{
								var listParam = parent.$("#basket_main_div #company_id").val() + "*" + 0 + "*" + get_product_detail_.PRODUCT_ID + "*" + get_product_detail_.PRODUCT_CATID + "*" + 0; 
								str_price_exceptions_ =	"obj_get_price_exceptions_4";	
							}
							else
							{
								var listParam = parent.$("#basket_main_div #company_id").val() + "*" + 0 + "*" + get_product_detail_.PRODUCT_ID + "*" + get_product_detail_.PRODUCT_CATID + "*" + 0; 
								str_price_exceptions_ =	"obj_get_price_exceptions";
							}
						}
					else if(parent.$("#basket_main_div #consumer_id").length != 0 && parent.$("#basket_main_div #consumer_id").val().length != 0)		
						{
							if(get_product_detail_.BRAND_ID!='')
							{
								var listParam = 0 + "*" + parent.$("#basket_main_div #consumer_id").val() + "*" + get_product_detail_.PRODUCT_ID + "*" + get_product_detail_.PRODUCT_CATID + "*" + 0; 
								str_price_exceptions_ =	"obj_get_price_exceptions_5";					
							}
							else
							{
								var listParam = 0 + "*" + parent.$("#basket_main_div #consumer_id").val() + "*" + get_product_detail_.PRODUCT_ID + "*" + get_product_detail_.PRODUCT_CATID + "*" + 0; 
								str_price_exceptions_ =	"obj_get_price_exceptions_2";
							}
						}
					else{
							if(get_product_detail_.BRAND_ID!='')
							{
								var listParam = 0 + "*" + 0 + "*" + get_product_detail_.PRODUCT_ID + "*" + get_product_detail_.PRODUCT_CATID + "*" + 0; 
								str_price_exceptions_ =	"obj_get_price_exceptions_6";					
							}
							else
							{
								var listParam = 0 + "*" + 0 + "*" + get_product_detail_.PRODUCT_ID + "*" + get_product_detail_.PRODUCT_CATID + "*" + 0; 
								str_price_exceptions_ =	"obj_get_price_exceptions_3";
							}
						}
					var get_price_exceptions_ = wrk_safe_query(str_price_exceptions_,'dsn3',0,listParam);
					var exception_price_cat='';
					if(get_price_exceptions_.recordcount != 0 || row_price_cat > 0) //standart satıs degilse veya urun icin istisna fiyat listesi belirtilmisse
					{
						var price_date="<cfoutput>#now()#</cfoutput>";
						if(get_price_exceptions_.recordcount != 0)
						{
							for(var pri_i=0;pri_i <= get_price_exceptions_.recordcount; pri_i=pri_i+1)
							{
								if(get_price_exceptions_.PRICE_CATID[pri_i] == document.all.price_catid_for_speed_.value)
								{
									if(get_price_exceptions_.PRODUCT_ID[pri_i] != '' && exception_price_cat == '')
										exception_price_cat=get_price_exceptions_.PRICE_CATID[pri_i];
									else if(get_price_exceptions_.PRODUCT_CATID[pri_i] != '' && exception_price_cat == '')
										exception_price_cat=get_price_exceptions_.PRICE_CATID[pri_i];
									else if(get_price_exceptions_.BRAND_ID[pri_i] != '' && exception_price_cat == '')
										exception_price_cat=get_price_exceptions_.PRICE_CATID[pri_i];
									<cfif isdefined('xml_use_general_price_cat_exceptions') and xml_use_general_price_cat_exceptions eq 1>
										if(get_price_exceptions_.DISCOUNT_RATE != '')
											d1 = get_price_exceptions_.DISCOUNT_RATE;
										if(get_price_exceptions_.DISCOUNT_RATE_2 != '')
											d2 = get_price_exceptions_.DISCOUNT_RATE_2;
										if(get_price_exceptions_.DISCOUNT_RATE_3 != '')
											d3 = get_price_exceptions_.DISCOUNT_RATE_3;
										if(get_price_exceptions_.DISCOUNT_RATE_4 != '')
											d4 = get_price_exceptions_.DISCOUNT_RATE_4;
										if(get_price_exceptions_.DISCOUNT_RATE_5 != '')
											d5 = get_price_exceptions_.DISCOUNT_RATE_5;
									</cfif>
								}
							}
						}
						
						if(exception_price_cat != '')
							new_price_cat = exception_price_cat;
						else
							new_price_cat = row_price_cat;
						var listParam = get_product_detail_.PRODUCT_ID + "*" + new_price_cat + "*" + price_date + "*" + get_product_detail_.PRODUCT_UNIT_ID;
						if(exception_price_cat != '')
							str_price_all_= "obj_get_price";
						else
							str_price_all_= "obj_get_price_2";
						var get_price = wrk_safe_query(str_price_all_,'dsn3',0,listParam);
					}
					else
					{
						var listParam = get_product_detail_.PRODUCT_ID + "*" + get_product_detail_.PRODUCT_UNIT_ID;
						var get_price = wrk_safe_query("obj_get_price_3",'dsn3',0,listParam);
					}
					
					if(get_price.recordcount == 0) // Bu alan ürünün fiyat listesinde fiyati yoksa sepete eklememesi icin eklendi. Asagidaki kontrol calismiyordu.
					{
						alert("<cf_get_lang dictionary_id='34251.Ürün, Seçilen Fiyat Listesinde Tanımlı Fiyatı Olmadığından Sepete Eklenmeyecektir'>!");	
						return false;
					}
				}
				else 
				{
					var price_date="<cfoutput>#now()#</cfoutput>";
					if(row_price_cat > 0)
					{
						var listParam = get_product_detail_.PRODUCT_ID + "*" + row_price_cat + "*" + price_date + "*" + get_product_detail_.PRODUCT_UNIT_ID;
						var str_price_all_ = 'obj_get_price_4';
					}
					else
					{
						var listParam = get_product_detail_.PRODUCT_ID + "*" + get_product_detail_.PRODUCT_UNIT_ID;
						var str_price_all_ = "obj_get_price_5";
					}
					var get_price = wrk_safe_query(str_price_all_,'dsn3',0,listParam);
		
					if(get_price.recordcount == 0) // Bu alan ürünün fiyat listesinde fiyati yoksa sepete eklememesi icin eklendi. Asagidaki kontrol calismiyordu.
					{
						alert("<cf_get_lang dictionary_id='34251.Ürün, Seçilen Fiyat Listesinde Tanımlı Fiyatı Olmadığından Sepete Eklenmeyecektir'>!");	
						return false;
					}
				}
				if(input_value != '')
					var price_date_ = js_date(input_value.toString());
				else
					var price_date_="<cfoutput>#now()#</cfoutput>";

				if(parent.$("#basket_main_div #company_id").length != 0 && parent.$("#basket_main_div #company_id").val().length != 0)
				{
					var listParam = <cfoutput>#listgetat(session.ep.user_location,2,'-')#</cfoutput> + "*" + parent.$("#basket_main_div #company_id").val() + "*" +price_date_;
					var get_genaral_discount = wrk_safe_query("obj_get_genaral_discount",'dsn3',0,listParam);
					if(get_genaral_discount.recordcount != 0 && exception_price_cat == '')
					{
						for(var pri_i=0;pri_i < get_genaral_discount.recordcount; pri_i=pri_i+1)
						{
							<cfif isdefined('xml_use_general_price_cat_exceptions') and xml_use_general_price_cat_exceptions eq 1>
								if(get_genaral_discount.DISCOUNT[pri_i] != '')
									d6 = get_genaral_discount.DISCOUNT[pri_i];
							</cfif>
						}
					}
				}
				page_unit = get_product_detail_.ADD_UNIT;
				page_unit_multiplier = get_product_detail_.MULTIPLIER;
				if(temp_date1 != undefined || temp_date1 !='')
				{
					var listParam = row_price_cat + "*" + get_product_detail_.STOCK_ID + "*" + temp_date1;
					str_prom_control_= "obj_get_prom_control";
				}
				else
				{
					var listParam = row_price_cat + "*" + get_product_detail_.STOCK_ID + "*" + 0;
					str_prom_control_= "obj_get_prom_control_2";
				}
				var get_prom_control_ = wrk_safe_query(str_prom_control_,'dsn3',1,listParam);
					
				if (get_prom_control_.FREE_STOCK_ID!=undefined && get_prom_control_.FREE_STOCK_ID!= '')
				{
					if(get_prom_control_.FREE_STOCK_AMOUNT != '')
						free_stock_amount = get_prom_control_.FREE_STOCK_AMOUNT;
					if(get_prom_control_.TOTAL_PROMOTION_COST != '')
						promotion_cost = get_prom_control_.TOTAL_PROMOTION_COST;
					promotion_gift_info = get_prom_control_.FREE_STOCK_ID+"|"+get_prom_control_.PROM_ID;
					if(get_prom_control_.FREE_STOCK_PRICE != undefined && get_prom_control_.FREE_STOCK_PRICE!= '')
						promotion_gift_info=promotion_gift_info+"|"+get_prom_control_.FREE_STOCK_PRICE+"|"+get_prom_control_.AMOUNT_1_MONEY+"|"+free_stock_amount;
					else	
						promotion_gift_info=promotion_gift_info+"|0|"+get_prom_control_.AMOUNT_1_MONEY+"|"+free_stock_amount;
					prom_limit_value = get_prom_control_.LIMIT_VALUE;
				}
				else
				{
					promotion_gift_info = "";
					prom_limit_value = 1;
				}
				
				if(get_prom_control_.recordcount) row_prom_id_ = get_prom_control_.PROM_ID; else row_prom_id_ = ''; 
				if(serial_no != undefined && serial_no !=0)
					temp_lot_no = serial_no; /*ONEMLI : PERAKENDE SATIS FATURASINDA LOT-NO ALANINDA URUNUN SERI NOSU TUTULMAKTADIR*/
				else
					temp_lot_no = '';
					
				if(row_price_cat > 0)
				{
					var get_price_cat_detail= wrk_safe_query("obj_get_price_cat_detail",'dsn3',0, row_price_cat);
					if(get_price_cat_detail.TARGET_DUE_DATE != undefined && get_price_cat_detail.TARGET_DUE_DATE != '' && input_value != '')
						form_product.due_day_value.value =datediff(input_value,date_format(get_price_cat_detail.TARGET_DUE_DATE),0);
					else if(get_price_cat_detail.AVG_DUE_DAY != undefined && get_price_cat_detail.AVG_DUE_DAY != '')
						form_product.due_day_value.value=get_price_cat_detail.AVG_DUE_DAY;
						
					form_product.number_of_installment.value =  get_price_cat_detail.NUMBER_OF_INSTALLMENT;
				}
				if(document.add_speed_prod.is_price_list_products_.value == 1 && get_price!= undefined && get_price.recordcount == 0 )
				{
					alert("<cf_get_lang dictionary_id='34251.Ürün Fiyatı Fiyat Listesinde Tanımlı Olmadığından Sepete Eklenmeyecektir'>!");
					document.add_speed_prod.add_amount_.value=1;
					document.add_speed_prod.add_barcod_.value='';
					document.add_speed_prod.add_stock_code_.value='';
					document.add_speed_prod.add_stock_id_.value='';
					document.add_speed_prod.serial_number.value='';
					return false;			
				}
				
					<!---add_speed_prod özelleştirilimiş QR kodun barkoda aktarılması içine gerekli olan JS kuralları --->
					<cfif isDefined('x_qr_barcode_enable') And x_qr_barcode_enable eq 1>
					form_product.deliver_date.value = full_date_ ;
					form_product.reserve_date.value = full_date ;
					form_product.lot_no.value = lotno;
					form_product.barcod.value =get_product_detail_.BARCOD;
					</cfif>
					<!---add_speed_prod özelleştirilimiş QR kodun barkoda aktarılması içine gerekli olan JS kuralları --->  
					form_product.d1.value = d1;
					form_product.d2.value = d2;
					form_product.d3.value = d3;
					form_product.d4.value = d4;
					form_product.d5.value = d5;
					form_product.d6.value = d6;
					form_product.product_id.value = get_product_detail_.PRODUCT_ID;
					form_product.stock_id.value =get_product_detail_.STOCK_ID;
					form_product.stock_code.value =get_product_detail_.STOCK_CODE;
					form_product.barcod.value =get_product_detail_.BARCOD;
					form_product.manufact_code.value=get_product_detail_.MANUFACT_CODE;
					form_product.product_name.value=get_product_detail_.PRODUCT_NAME+' - '+get_product_detail_.PROPERTY;
					form_product.gtip_number.value = '';
					form_product.expense_center_id.value = '';
					form_product.expense_center_name.value = '';
					form_product.expense_item_id.value = '';
					form_product.expense_item_name.value = '';
					form_product.activity_type_id.value = '';
					form_product.bsmv_.value = '';
					form_product.product_detail2.value = get_product_detail_.PRODUCT_DETAIL2;
					form_product.reason_code.value = '';
					if(get_price != undefined && get_price.recordcount != 0)
					{
						form_product.flt_price_other_amount.value =get_price.PRICE;
						form_product.str_money_currency.value=get_price.MONEY;
						form_product.catalog_id.value =get_price.CATALOG_ID;
					}
					form_product.unit_id.value=get_product_detail_.PRODUCT_UNIT_ID;
					form_product.unit.value= page_unit;
					form_product.unit_multiplier.value=get_product_detail_.MULTIPLIER;
					if(str_seri_sale_control_ == "")
					{
						<cfif isdefined('attributes.is_store_module')> 
							str_seri_sale_control_ = "obj_get_seri_sale_control_2";
						<cfelse>
							str_seri_sale_control_ = "obj_get_seri_sale_control";
						</cfif>
						var listParam = "<cfoutput>#dsn_alias#</cfoutput>" + "*" + serial_no;
						var get_seri_sale_control_ =wrk_safe_query(str_seri_sale_control_,'dsn3',0,listParam);
					}
					if(multi_row == 2){
						var amount_=filterNum(document.add_speed_prod.add_amount_.value,'<cfoutput>#attributes.amount_round_number#</cfoutput>');
						amount_ = amount_ / row_count;
						form_product.multi_row.value = 1;
					}else{
						var amount_=filterNum(document.add_speed_prod.add_amount_.value,'<cfoutput>#attributes.amount_round_number#</cfoutput>');
						if(get_seri_sale_control_.UNIT_ROW_QUANTITY && number == 3)
						{
							amount_ = get_seri_sale_control_.UNIT_ROW_QUANTITY;
							form_product.number.value = 3;
						}
					}
					/*if(get_product_detail_.MULTIPLIER != undefined && get_product_detail_.MULTIPLIER != 1)
						amount_ = amount_*get_product_detail_.MULTIPLIER;*/
					form_product.amount.value = amount_ ;
					form_product.amount_other.value = '';
					form_product.tax.value =get_product_detail_.TAX;
					form_product.is_inventory.value=get_product_detail_.IS_INVENTORY;
					form_product.is_production.value=get_product_detail_.IS_PRODUCTION;
					form_product.price_catid.value=row_price_cat;
					form_product.otv.value=get_product_detail_.OTV;
					form_product.basket_id.value = parent.window.basket.hidden_values.basket_id;
					if(( ( parent.window.basketManager !== undefined ) ? parent.basketService.sale_product() : parent.window.basket.hidden_values.sale_product ) != '')
						form_product.is_sale_product.value = ( ( parent.window.basketManager !== undefined ) ? parent.basketService.sale_product() : parent.window.basket.hidden_values.sale_product );
					else
						form_product.is_sale_product.value = '-1'
					form_product.row_promotion_id.value=row_prom_id_;
					if(get_prom_control_.DISCOUNT!=undefined && get_prom_control_.DISCOUNT!='')
						form_product.promosyon_yuzde.value=get_prom_control_.DISCOUNT;
					else
						form_product.promosyon_yuzde.value='';
			
					form_product.promosyon_maliyet.value='';
					form_product.promosyon_form_info.value=promotion_gift_info;
					
					if(promotion_gift_info != '')
						form_product.action = '<cfoutput>#request.self#?fuseaction=objects.emptypopup_add_basket_row_multi</cfoutput>'+document.add_speed_prod.url_info.value;
					else
						form_product.action = '<cfoutput>#request.self#?fuseaction=objects.emptypopup_add_basket_row</cfoutput>'+document.add_speed_prod.url_info.value+'&from_barcode=1';
					
					if(get_seri_sale_control_.LOT_NO && number == 3)
						form_product.lot_no.value = get_seri_sale_control_.LOT_NO;
					else if(lotNoQrCode != undefined && lotNoQrCode != '')
						form_product.lot_no.value = lotNoQrCode;
					
					if(multi_row != 2){
						document.add_speed_prod.add_amount_.value=1;
						<cfif listFindNoCase(display_list, "barcode_barcode")>
						document.add_speed_prod.add_barcod_.value='';
						</cfif>
						<cfif listFindNoCase(display_list, "barcode_stock_code")>
						document.add_speed_prod.add_stock_code_.value='';
						document.add_speed_prod.add_stock_id_.value='';
						</cfif>
						<cfif listFindNoCase(display_list, "barcode_serial_no")>
						document.add_speed_prod.serial_number.value='';
						</cfif>
						<cfif listFindNoCase(display_list, "barcode_lot_no")>
						document.add_speed_prod.lotNoQrCode.value='';
						</cfif>
					}
					form_product.amount_other.value = 1;
					
				//form_product.submit();	
				AjaxFormSubmit("form_product","SHOW_INFO",1,"<cf_get_lang dictionary_id='58731.Ürün Ekleniyor'>","<cf_get_lang dictionary_id='58732.Ürün Eklendi'>!","","",1);
				//return true;
			}
		}
		if(multi_row == 2){
			document.add_speed_prod.add_amount_.value=1;
			<cfif listFindNoCase(display_list, "barcode_amount_2")>
			document.add_speed_prod.add_amount_2_.value='';
			</cfif>
			<cfif listFindNoCase(display_list, "barcode_barcode")>
			document.add_speed_prod.add_barcod_.value='';
			</cfif>
			<cfif listFindNoCase(display_list, "barcode_stock_code")>
			document.add_speed_prod.add_stock_code_.value='';
			document.add_speed_prod.add_stock_id_.value='';
			</cfif>
			<cfif listFindNoCase(display_list, "barcode_serial_no")>
			document.add_speed_prod.serial_number.value='';
			</cfif>
			<cfif listFindNoCase(display_list, "barcode_lot_no")>
			document.add_speed_prod.lotNoQrCode.value='';
			</cfif>
		}
	 }
	function set_basket_info()
	{
		var get_basket_info =wrk_safe_query("obj_get_basket_info",'dsn3',0,"<cfoutput>#attributes.int_basket_id#</cfoutput>");
		if(get_basket_info.recordcount != 0)
		{
			document.add_speed_prod.basket_product_list_type.value=get_basket_info.PRODUCT_SELECT_TYPE;
			<cfif isdefined('xml_use_project_discounts') and xml_use_project_discounts eq 1>
				if(get_basket_info.USE_PROJECT_DISCOUNT!=1) /*basket sablonunda proje iskontoları secilmemisse, urun listesi xmlinde secilmesi yeterli olmaz*/
					document.form_product.use_project_discounts.value=0;
			</cfif>
		}
	}
	set_basket_info();
	parent.$(window).ready(function(){
		parent.set_price_catid_options();
	})
	
	h1 = document.getElementById('_add_prod_main_row_').clientHeight;
	if(parseFloat(h1) > 40)
		window.top.SetFrameHeight((h1 + 5));
</script>