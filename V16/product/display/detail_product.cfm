<cfset xfa.submit = "product.upd_product"> 
<cfset url.pid = attributes.pid>
<cfparam name="is_commission" default="">
<cf_xml_page_edit fuseact="product.form_add_product">
<cf_get_lang_set module_name="product"><!--- sayfanin en altinda kapanisi var --->
<cfscript>
	get_product_list_action = createObject("component", "V16.product.cfc.get_product");
	if (isnumeric(attributes.pid))
	{
		get_product_list_action.dsn1 = dsn1;
		get_product_list_action.dsn_alias = dsn_alias;
		GET_PRODUCT = get_product_list_action.get_product_
		(
			pid : attributes.pid
		);
		GET_PROPERTY = get_product_list_action.GET_PROPERTY_STOCKS
		(
			pid : attributes.pid
		);
		
	}
	else
	{
		get_product.recordcount = 0;
		GET_PROPERTY.recordcount=0;
	}
</cfscript>
<cfinclude template="../query/get_code_cat.cfm">
<cfquery name="get_product_period" datasource="#dsn3#">
    	SELECT 
			PRODUCT_PERIOD.PRODUCT_PERIOD_CAT_ID 
		FROM 
			PRODUCT_PERIOD,
			#dsn_alias#.SETUP_PERIOD SP
		WHERE 
			SP.PERIOD_ID = PRODUCT_PERIOD.PERIOD_ID 
		AND 
			SP.PERIOD_YEAR = #session.ep.period_year# 
		AND 
			PRODUCT_PERIOD.PRODUCT_ID = #attributes.pid# 
		AND 
			SP.OUR_COMPANY_ID = #session.ep.company_id#
</cfquery>
<cfquery name="get_product_properties_rec" datasource="#dsn1#">
	SELECT PRODUCT_ID FROM PRODUCT_DT_PROPERTIES WHERE PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pid#">
</cfquery>
<cfif get_product_period.recordcount>
	<cfset product_period_cat_id = get_product_period.PRODUCT_PERIOD_CAT_ID>
</cfif>
<cfif not get_product.recordcount>
	<cfset hata  = 11>
	<cfsavecontent variable="message"><cf_get_lang dictionary_id='57997.Şube Yetkiniz Uygun Değil'> <cf_get_lang dictionary_id='57998.Veya'> <cf_get_lang dictionary_id='58642.Urun Kaydı Bulunamadı'> !</cfsavecontent>
	<cfset hata_mesaj  = message>
	<cfinclude template="../../dsp_hata.cfm">
<cfelse>
<cfquery name="GET_OUR_COMPANY_INFO" datasource="#DSN#">
    SELECT IS_BRAND_TO_CODE,IS_BARCOD_REQUIRED,IS_GUARANTY_FOLLOWUP,IS_PRODUCT_COMPANY,IS_WATALOGY_INTEGRATED FROM OUR_COMPANY_INFO WHERE COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
</cfquery>

<cfset watalogy_cat_name = ''>
<cfset cmp = createObject("component","V16/settings/cfc/watalogyWebServices")>
<cfif GET_OUR_COMPANY_INFO.recordCount and GET_OUR_COMPANY_INFO.IS_WATALOGY_INTEGRATED eq 1 and len(get_product.WATALOGY_CAT_ID)>
	<cfset get_watalogy_category = cmp.getWatalogyCategory(cat_id:get_product.WATALOGY_CAT_ID)>
	<cfset watalogy_cat_name = valuelist(get_watalogy_category.CATEGORY_NAME)>
</cfif>
<cfset get_country = get_product_list_action.get_country()>
<cfquery name="GET_PRODUCT_TREE" datasource="#DSN3#">
	SELECT 
        PT.PRODUCT_ID
    FROM 
        PRODUCT_TREE PT,
        STOCKS S
    WHERE 
        S.STOCK_ID = PT.STOCK_ID AND
        S.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pid#">
</cfquery>
<cfinclude template="../query/get_product_stock_id.cfm">
<cfinclude template="/V16/sales/query/get_moneys.cfm">

<cfif GET_OUR_COMPANY_INFO.IS_PRODUCT_COMPANY EQ 1>
<!--- Sirket Akis Parametrelerinde Ürün parametre bilgisi şirkete bağlı olarak gelsin mi secenegi evet ise buradan ceker, degilse eski yapi devam eder --->
    <cfquery name="get_general_parameters" datasource="#dsn1#">
        SELECT
            PRODUCT_PARAMETERS_ID, 
            PRODUCT_ID, 
            COMPANY_ID, 
            PRODUCT_STATUS, 
            IS_INVENTORY, 
            IS_PRODUCTION, 
            IS_SALES, 
            IS_PURCHASE, 
            IS_PROTOTYPE, 
            IS_INTERNET, 
            IS_EXTRANET, 
            IS_TERAZI, 
            IS_KARMA, IS_ZERO_STOCK, 
            IS_LIMITED_STOCK, 
            IS_SERIAL_NO, 
            IS_COST, 
            IS_QUALITY, 
            IS_COMMISSION, 
            OUR_COMPANY_ID, 
            PRODUCT_MANAGER, 
            IS_ADD_XML, 
            IS_GIFT_CARD, 
            GIFT_VALID_DAY, 
            QUALITY_START_DATE, 
            IS_LOT_NO,
			IS_IMPORTED
        FROM 
            PRODUCT_GENERAL_PARAMETERS
        WHERE 
            PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pid#"> 
            AND OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
    </cfquery>
    <cfif get_general_parameters.recordcount>
		<cfset get_product.product_status =get_general_parameters.product_status>
        <cfset get_product.is_inventory = get_general_parameters.is_inventory>
        <cfset get_product.is_production = get_general_parameters.is_production>
        <cfset get_product.is_sales = get_general_parameters.is_sales>
        <cfset get_product.is_purchase = get_general_parameters.is_purchase>
        <cfset get_product.is_prototype = get_general_parameters.is_prototype>
        <cfset get_product.is_internet = get_general_parameters.is_internet>
        <cfset get_product.is_extranet = get_general_parameters.is_extranet>
        <cfset get_product.is_terazi = get_general_parameters.is_terazi>
        <cfset get_product.is_karma = get_general_parameters.is_karma>
        <cfset get_product.is_zero_stock = get_general_parameters.is_zero_stock>
        <cfset get_product.is_limited_stock = get_general_parameters.is_limited_stock>
        <cfset get_product.is_serial_no = get_general_parameters.is_serial_no>
        <cfset get_product.is_lot_no = get_general_parameters.is_lot_no>
        <cfset get_product.is_cost = get_general_parameters.is_cost>
        <cfset get_product.is_quality = get_general_parameters.is_quality>
        <cfset get_product.is_commission = get_general_parameters.is_commission>
        <cfset get_product.is_add_xml = get_general_parameters.is_add_xml>
        <cfset get_product.is_gift_card = get_general_parameters.is_gift_card>
        <cfset get_product.company_id = get_general_parameters.company_id>
        <cfset get_product.quality_start_date = get_general_parameters.quality_start_date>
        <cfset get_product.gift_valid_day = get_general_parameters.gift_valid_day>
        <cfset get_product.product_manager = get_general_parameters.product_manager>
        <cfset get_product.is_imported = get_general_parameters.is_imported>

	</cfif>
</cfif> 
<script>
	if($('#otv_type').val())
	{
		window.onload = function show()
        {
        	var option = document.getElementById("otv_type").value;
            if(option == "1")
            {
            document.getElementById("item-OTV-1").style.display="block";
            document.getElementById("item-OTV-2").style.display="none";

            return true;
            }
                
            if(option == "2")
            {
            document.getElementById("item-OTV-2").style.display="block";
            document.getElementById("item-OTV-1").style.display="none";
            return true;
            }
            else
            {
            document.getElementById("item-OTV-2").style.display="none";
            document.getElementById("item-OTV-1").style.display="none";
            return true;
            }
        }
	}
</script>
<cfset pageHead = "#getlang('main',152)#: #left(Replace(get_product.product_name,"'"," "),50)#">
<cf_catalystHeader>
	<div class="ui-row">
		<div class="col col-9 col-md-9 col-sm-9 col-xs-12">
			<cf_box id="product_detail" title="#getLang('main','Ürün Detay',33929)#">
				<cfform name="form_upd_product" method="post">
					<input type="hidden" name="barcode_require" id="barcode_require" value="<cfoutput>#get_our_company_info.is_barcod_required#</cfoutput>">
					<input type="hidden" name="is_barcode_control" id="is_barcode_control" value="<cfoutput>#is_barcode_control#</cfoutput>">
					<input type="hidden" name="is_spect_name_upd" id="is_spect_name_upd" value="<cfoutput>#is_spect_name_upd#</cfoutput>">
					<input type="hidden" name="product_id" id="product_id" value="<cfoutput>#url.pid#</cfoutput>">
					<input type="hidden" name="pid" id="pid" value="<cfoutput>#url.pid#</cfoutput>">
					<input type="hidden" name="is_product_status" id="is_product_status" value="<cfoutput>#get_product.product_status#</cfoutput>">
					<input type="hidden" name="old_is_purchase" id="old_is_purchase" value="<cfoutput>#get_product.is_purchase#</cfoutput>">
					<input type="hidden" name="use_same_product_name" id="use_same_product_name" value="<cfif isdefined('x_use_same_product_name')><cfoutput>#x_use_same_product_name#</cfoutput><cfelse>0</cfif>">
					<cf_tab defaultOpen="sayfa_1" divId="sayfa_1,sayfa_3,sayfa_4" divLang="#getLang('','Temel Bilgiler',58131)#;#getLang('','Carbon Footprint',63069)#;#getLang('','Watalogy',30366)#">
						<div id="unique_sayfa_1" class="ui-info-text uniqueBox">
							<cf_box_elements vertical="1">
								<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
									<div class="form-group" id="item-product_status">
										<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id="57756.Durum"></label>
										<div class="col col-8 col-md-8 col-sm-8 col-xs-12"><input type="checkbox" name="product_status" id="product_status" value="1" <cfif get_product.product_status eq 1>checked</cfif>><cf_get_lang dictionary_id='57493.Aktif'>/<cf_get_lang dictionary_id='57494.Pasif'></div>
									</div>
									<div class="form-group" id="item-is_inventory">
										<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='37054.Envanter'></label>
										<div class="col col-8 col-md-8 col-sm-8 col-xs-12"><input type="checkbox" name="is_inventory" id="is_inventory" value="1" <cfif get_product.is_inventory eq 1>checked</cfif>><cf_get_lang dictionary_id='37055.envantere dahil'></div>
									</div>
									<div class="form-group" id="item-is_production" >
										<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57456.Üretim'></label>
										<div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
											<input type="checkbox" name="is_production" id="is_production" value="1" <cfif get_product.is_production eq 1>checked="checked"</cfif> <cfif isDefined('is_prod_product_tree') and is_prod_product_tree eq 1 and get_product_tree.recordcount>disabled="disabled"</cfif>><cf_get_lang dictionary_id='37057.üretiliyor'>
											<cfif isDefined('is_prod_product_tree') and is_prod_product_tree eq 1 and get_product_tree.recordcount>
												<input type="hidden" name="is_production" id="is_production" value="1">
											</cfif>
										</div>
									</div>
									<div class="form-group" id="item-is_sales" >
										<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57448.Satış'></label>
										<div class="col col-8 col-md-8 col-sm-8 col-xs-12"><input type="checkbox" name="is_sales" id="is_sales" value="1" <cfif get_product.is_sales eq 1>checked</cfif>><cf_get_lang dictionary_id='37059.satışta'></div>
									</div>
									<div class="form-group" id="item-is_purchase" >
										<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='29745.Tedarik'></label>
										<div class="col col-8 col-md-8 col-sm-8 col-xs-12"><input type="checkbox" name="is_purchase" id="is_purchase" value="1" <cfif get_product.is_purchase eq 1>checked</cfif>><cf_get_lang dictionary_id='37061.Tedarik ediliyor'></div>
									</div>
									<div class="form-group" id="item-is_prototype" >
										<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='37062.Prototip'></label>
										<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
											<input type="checkbox" name="is_prototype" id="is_prototype" value="1" <cfif get_product.is_prototype eq 1>checked</cfif>><cf_get_lang dictionary_id='37063.Ozellestirilebilir'>
										</div>
									</div>
									<div class="form-group" id="item-is_internet" >
										<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='37064.İnternet'></label>
										<div class="col col-8 col-md-8 col-sm-8 col-xs-12"><input type="checkbox" name="is_internet" id="is_internet" value="1" <cfif get_product.is_internet eq 1>checked</cfif>><cf_get_lang dictionary_id='37065.Satılıyor'></div>
									</div>
									<div class="form-group" id="item-is_extranet" >
										<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58019.Extranet'></label>
										<div class="col col-8 col-md-8 col-sm-8 col-xs-12"><input type="checkbox" name="is_extranet" id="is_extranet" value="1" <cfif get_product.is_extranet eq 1>checked</cfif>><cf_get_lang dictionary_id='37065.Satılıyor'></div>
									</div>
									<div class="form-group" id="item-is_terazi" >
										<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='37066.Terazi'></label>
										<div class="col col-8 col-md-8 col-sm-8 col-xs-12"><input type="checkbox" name="is_terazi" id="is_terazi" value="1" <cfif get_product.is_terazi eq 1>checked</cfif>><cf_get_lang dictionary_id='37067.Teraziye Gidiyor'></div>
									</div>
									<div class="form-group" id="item-is_karma" >
										<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='37467.Karma Koli'></label>
										<div class="col col-8 col-md-8 col-sm-8 col-xs-12"><input type="checkbox" name="is_karma" id="is_karma" value="1" <cfif get_product.is_karma eq 1>checked</cfif>> <cf_get_lang dictionary_id='57495.Evet'></div>
									</div>
									<div class="form-group" id="item-is_zero_stock" >
										<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='37351.Sıfır Stok'></label>
										<div class="col col-8 col-md-8 col-sm-8 col-xs-12"><input type="checkbox" name="is_zero_stock" id="is_zero_stock" value="1" <cfif get_product.is_zero_stock eq 1>checked</cfif>><cf_get_lang dictionary_id='37352.İle Çalış'></div>
									</div>
									<div class="form-group" id="item-is_limited_stock" >
										<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='37922.Stoklarla Sınırlı'></label>
										<div class="col col-8 col-md-8 col-sm-8 col-xs-12"><input type="checkbox" name="is_limited_stock" id="is_limited_stock" value="1" <cfif len(get_product.is_limited_stock) and get_product.is_limited_stock eq 1> checked</cfif>> <cf_get_lang dictionary_id='57495.Evet'></div>
									</div>
									<cfif get_our_company_info.recordcount and get_our_company_info.is_guaranty_followup eq 1>
										<div class="form-group" id="item-is_serial_no" >
											<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57637.Seri No'></label>
											<div class="col col-8 col-md-8 col-sm-8 col-xs-12"><input type="checkbox" name="is_serial_no" id="is_serial_no" value="1" <cfif get_product.is_serial_no eq 1>checked</cfif>><cf_get_lang dictionary_id='37349.Takibi Yapılıyor'></div>
										</div>
									</cfif>
									<div class="form-group" id="item-is_lot_no" >
										<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='37155.Lot No'></label>
										<div class="col col-8 col-md-8 col-sm-8 col-xs-12"><input type="checkbox" name="is_lot_no" id="is_lot_no" value="1" <cfif get_product.is_lot_no eq 1>checked</cfif>><cf_get_lang dictionary_id='37349.Takibi Yapılıyor'></div>
									</div>
									<div class="form-group" id="item-is_cost" >
										<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58258.Maliyet'></label>
										<div class="col col-8 col-md-8 col-sm-8 col-xs-12"><input type="checkbox" name="is_cost" id="is_cost" value="1" <cfif get_product.is_cost eq 1>checked</cfif>><cf_get_lang dictionary_id='37175.Takip Ediliyor'></div>
									</div>
									<div class="form-group" id="item-is_imported" >
										<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='49210.İthal'></label>
										<div class="col col-8 col-md-8 col-sm-8 col-xs-12"><input type="checkbox" name="is_imported" id="is_imported" value="1" <cfif get_product.is_imported eq 1>checked</cfif>><cf_get_lang dictionary_id='48110.İthal Ediliyor'></div>
									</div>
									<div class="form-group" id="item-is_quality" >
										<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id="37254.Kalite"></label>
										<div class="col col-8 col-md-8 col-sm-8 col-xs-12"><input type="checkbox" name="is_quality" id="is_quality" value="1" <cfif get_product.is_quality eq 1>checked</cfif>><cf_get_lang dictionary_id='37175.Takip Ediliyor'></div>
									</div>
									<div class="form-group" id="item-is_commission" >
										<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='37957.Pos Komisyonu Hesapla'></label>
										<div class="col col-8 col-md-8 col-sm-8 col-xs-12"><input type="checkbox" name="is_commission" id="is_commission" value="1" <cfif get_product.is_commission eq 1>checked</cfif>><cf_get_lang dictionary_id='58998.Hesapla'></div>
									</div>
									<cfif GET_OUR_COMPANY_INFO.recordCount and GET_OUR_COMPANY_INFO.IS_WATALOGY_INTEGRATED eq 1>
										<div class="form-group" id="item-is_watalogy_integrated">	
											<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='30366.Watalogy'></label>
											<div class="col col-8 col-md-8 col-sm-8 col-xs-12"><input type="checkbox" name="is_watalogy_integrated" id="is_watalogy_integrated" value="1" <cfif get_product.IS_WATALOGY_INTEGRATED eq 1> checked</cfif>><cf_get_lang dictionary_id='42485.Entegre'></div>			
										</div>
									</cfif>
									<div class="form-group" id="item-is_gift_card" >
										<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='38024.Hediye Çeki'></label>
										<div class="col col-8 col-md-8 col-sm-8 col-xs-12"><input type="checkbox" name="is_gift_card" id="is_gift_card" value="1" <cfif get_product.is_gift_card eq 1>checked</cfif> onclick="kontrol_day();"></div>
									</div>
									<cfif get_product.is_gift_card neq 1>
										<cfset style_ = "display:none">
									<cfelse>
										<cfset style_ = "display:'block'">
									</cfif>
									
									<div class="form-group" id="item-gift_valid_day" style="<cfoutput>#style_#</cfoutput>" >
										<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='37046.Validity Day'></label>
										<div class="col col-8 col-md-8 col-sm-8 col-xs-12"><input type="input" name="gift_valid_day" id="gift_valid_day" value="<cfoutput>#get_product.gift_valid_day#</cfoutput>" maxlength="4" onkeyup="isNumber(this);" class="moneybox"></div>
									</div>
									<cfif GET_OUR_COMPANY_INFO.IS_PRODUCT_COMPANY EQ 1>
									<div class="form-group" id="item-info" >
										<font color="red" style="font-weight:bold"><cf_get_lang dictionary_id='59980.Bu Alandaki Değişiklikleri Ürün Parametrelerinden Kaydetmelisiniz'> !</font>
										</div>
									</cfif>
								</div>
								<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
									<div class="form-group" id="item-product_name">
										<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57657.Ürün'> *</label>
										<cfsavecontent variable="message"><cf_get_lang dictionary_id='37331.ürün girmelisiniz'></cfsavecontent>
										<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
											<div class="input-group">
												<cfinput type="text" name="product_name" maxlength="500" value="#get_product.product_name#" required="Yes" message="#message#">
												<span class="input-group-addon">
													<cf_language_info 
														table_name="PRODUCT" 
														column_name="PRODUCT_NAME" 
														column_id_value="#url.pid#" 
														maxlength="500" 
														datasource="#dsn1#" 
														column_id="PRODUCT_ID" 
														control_type="0">
												</span>
											</div>						
										</div>						
									</div>
									<div class="form-group" id="item-product_cat">
										<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57486.Kategori'> *</label>
										<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
											<div class="input-group">
												<cfset attributes.ID = get_product.product_catid>
												<cfinclude template="../query/get_product_cat.cfm">
												<input type="hidden" name="old_product_catid" id="old_product_catid" value="<cfoutput>#get_product.product_catid#</cfoutput>">
												<input type="hidden" name="product_catid" id="product_catid" value="<cfoutput>#get_product.product_catid#</cfoutput>">
												<cfinput type="text" name="product_cat" id="product_cat" value="#get_product_cat.hierarchy# #get_product_cat.product_cat#" onFocus="AutoComplete_Create('product_cat','PRODUCT_CAT,HIERARCHY','PRODUCT_CAT_NAME','get_product_cat','1','PRODUCT_CATID','product_catid','','3','455');">
												<span class="input-group-addon icon-ellipsis btnPoniter" title="<cf_get_lang dictionary_id='37157.Ürün Kategorisi Ekle'> !" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_cat_names&field_id=form_upd_product.product_catid&field_name=form_upd_product.product_cat&field_min=form_upd_product.MIN_MARGIN&field_max=form_upd_product.MAX_MARGIN');"></span>
											</div>
										</div>
									</div>
									<div class="form-group" id="item-brand_name">
										<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58847.Marka'><cfif get_our_company_info.is_brand_to_code eq 1> </cfif></label>
										<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
											<input type="hidden" name="brand_code" id="brand_code" value="">
											<cf_wrkproductbrand
												returninputvalue="brand_id,brand_name,brand_code"
												returnqueryvalue="brand_id,brand_name,brand_code"
												width="140"
												compenent_name="getProductBrand"               
												boxwidth="300"
												boxheight="150"
												is_internet="1"
												brand_code="1"
												brand_id="#get_product.brand_id#">
										</div>
									</div>
									<div class="form-group" id="item-short_code_name">
										<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58225.Model'><cfif get_our_company_info.is_brand_to_code eq 1> </cfif></label>
										<cfif is_related_model_brand eq 1>
											<cfset deger = "brand_id">
										<cfelse>
											<cfset deger = "">
										</cfif>
										<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
											<cf_wrkproductmodel
												returninputvalue="short_code_id,short_code,short_code_name"
												returnqueryvalue="MODEL_ID,MODEL_CODE,MODEL_NAME"
												width="140"
												fieldname="short_code_name"
												fieldid="short_code_id"
												fieldcode="short_code"
												compenent_name="getProductModel"            
												boxwidth="300"
												boxheight="150"
												control_field_id="#deger#"
												control_field_name="brand_name"
												control_field_message="Marka Seçiniz!"
												model_id="#get_product.short_code_id#">
												<input type="hidden" name="old_short_code" id="old_short_code" value="<cfoutput>#get_product.short_code#</cfoutput>">
										</div>
									</div>
									<div class="form-group" id="item-product_code">
										<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58800.Ürün Kodu'> *</label>
										<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
											<input type="hidden" name="old_product_code" id="old_product_code" value="<cfoutput>#get_product.product_code#</cfoutput>">
											<cfsavecontent variable="message"><cf_get_lang dictionary_id='37332.ürün kodu girmelisiniz'></cfsavecontent>
											<cfinput type="text" name="product_code" value="#get_product.product_code#" required="yes" readonly="yes" message="#message#" ><!---  passthrough="readonly=yes" --->
										</div>
									</div>
									<div class="form-group" id="item-manufact_code">
										<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='37379.Üretici ürün Kodu'></label>
										<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
											<input type="hidden" name="old_manufact_code" id="old_manufact_code" value="<cfoutput>#get_product.manufact_code#</cfoutput>">
											<input type="text" name="manufact_code" id="manufact_code" value="<cfoutput>#get_product.manufact_code#</cfoutput>" maxlength="100">
										</div>
									</div>
								<div class="form-group" id="item-position_code">
									<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='62513.Menşei'></label>
									<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
										<select name="origin" id="origin">
											<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
											<cfloop query="get_country">
												<option value="<cfoutput>#country_id#</cfoutput>" <cfif get_product.origin_id eq country_id>selected</cfif>><cfoutput>#country_name#</cfoutput></option>
											</cfloop>
										</select>
									</div>
								</div>
									<div class="form-group" id="item-customs_recipe_code" >
										<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='62502.GTIP/CPA Kodu'></label>
										<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
											<div class="input-group">
												<cfinput type="text" name="customs_recipe_code" id="customs_recipe_code" value="#get_product.customs_recipe_code#" maxlength="50">
												<span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_gtip_hs_codes');"></span>
											</div>
										</div>	
									</div>
									<div class="form-group" id="item-process_stage">
										<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id="58859.Süreç"></label>
										<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
											<cf_workcube_process 
												is_upd='0' 
												select_value='#get_product.product_stage#' 
												process_cat_width='140' 
												is_detail='1'>
										</div>
									</div>
									<div class="form-group" id="item-segment_id">
										<label class="col col-4 col-md-4 col-sm-4 col-xs-12" type="text"><cf_get_lang dictionary_id='37035.Hedef Pazar'></label>
										<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
											<cfinclude template="../query/get_segments.cfm">
											<select name="segment_id" id="segment_id" >
												<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
												<cfoutput query="get_segments">
													<option value="#product_segment_id#" <cfif get_product.segment_id eq product_segment_id> selected</cfif>>#product_segment#</option>
												</cfoutput>
											</select>
										</div>
									</div>
									<div class="form-group" id="item-prod_comp">
										<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='37372.Fiyat Yetkisi'><!--- Rekabet ---></label>
										<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
											<cfinclude template="../query/get_product_comp.cfm">
											<select name="prod_comp" id="prod_comp" >
												<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
												<cfoutput query="get_product_comp">
													<option value="#competitive_id#" <cfif get_product.prod_competitive eq competitive_id> selected</cfif>>#competitive#</option>
												</cfoutput>
											</select>
										</div>
									</div>
									<div class="form-group" id="item-acc_code_cat">
										<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='37257.Muh Kod Grubu'></label>
										<div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
											<input type="hidden" name="old_acc_code_cat" id="old_acc_code_cat" value="<cfif isdefined("product_period_cat_id")><cfoutput>#product_period_cat_id#</cfoutput></cfif>">
											<select name="acc_code_cat" id="acc_code_cat">
												<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
												<cfoutput query="get_code_cat">
													<option value="#pro_code_catid#" <cfif isdefined("product_period_cat_id") and product_period_cat_id eq pro_code_catid>selected</cfif>>#pro_code_cat_name#</option>
												</cfoutput>
											</select>
										</div>
									</div>
									<div class="form-group" id="item-project_head">
										<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57416.Proje'></label>
										<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
											<div class="input-group">
												<input type="hidden" name="project_id" id="project_id" value="<cfoutput>#get_product.project_id#</cfoutput>">
												<input type="text" name="project_head" id="project_head" value="<cfif len(get_product.project_id)><cfoutput>#GET_PROJECT_NAME(get_product.project_id)#</cfoutput></cfif>" onFocus="AutoComplete_Create('project_head','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','','3','200');" autocomplete="off">
												<span class="input-group-addon btnPointer icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_projects&project_id=form_upd_product.project_id&project_head=form_upd_product.project_head');"></span>
											</div>					
										</div>						
									</div>
								
									<div class="form-group" id="item-position_code">
										<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='37376.Kategori sorumlusu'></label>
										<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
											<cfquery name="get_positions" datasource="#dsn1#">
												SELECT POSITION_CODE FROM PRODUCT_CAT_POSITIONS where PRODUCT_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_product.product_catid#">
										</cfquery>
											<input type="text" value="<cfif len(get_positions.position_code)><cfoutput>#get_emp_info(get_positions.position_code,1,0)#</cfoutput></cfif>" name="position_code" id="position_code" />
										</div>
									</div>	
									<div class="form-group" id="item-comp">
										<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='29533.Tedarikçi'></label>
										<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
											<div class="input-group">
												<cfif len(get_product.company_id)>
													<cfquery name="GET_COMP" datasource="#DSN#">
														SELECT MEMBER_CODE, FULLNAME FROM COMPANY WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_product.company_id#">
													</cfquery>
												</cfif>
												<input name="comp" type="text" id="comp"  onfocus="AutoComplete_Create('comp','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','1,1,0','COMPANY_ID','company_id','','3','140');" value="<cfif len(get_product.company_id)><cfoutput>#get_comp.member_code#- #get_comp.fullname#</cfoutput></cfif>" autocomplete="off">
												<span class="input-group-addon icon-ellipsis btnPointer" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&field_comp_id=form_upd_product.company_id&field_comp_name=form_upd_product.comp<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&select_list=2&keyword=</cfoutput>'+form_upd_product.comp.value);" title="<cf_get_lang dictionary_id='170.Ekle'>"></span>
												<cfif GET_OUR_COMPANY_INFO.IS_PRODUCT_COMPANY EQ 1>
													<span class="input-group-addon btnPointer bold" onclick="alert('<cfoutput>#getLang('','Ürün Parametrelerinden Düzenleyiniz',62510)#</cfoutput> !');">?</span>
												</cfif>
												<input type="hidden" name="company_id" id="company_id" value="<cfoutput>#get_product.company_id#</cfoutput>">
											</div>
										</div>
									</div>
									<div class="form-group" id="item-product_manager_name">
										<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57544.Sorumlu'></label>
										<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
											<div class="input-group">
												<input name="product_manager_name" type="text" id="product_manager_name"  onfocus="AutoComplete_Create('product_manager_name','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2,3\'','POSITION_CODE','product_manager','','3','150');" value="<cfif len(get_product.product_manager)><cfoutput>#get_emp_info(get_product.product_manager,1,0)#</cfoutput></cfif>" autocomplete="off" >
												<input type="hidden" name="product_manager" id="product_manager" value="<cfoutput>#get_product.product_manager#</cfoutput>">
												<span class="input-group-addon icon-ellipsis btnpointer" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_code=form_upd_product.product_manager&field_name=form_upd_product.product_manager_name<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&branch_related</cfoutput>&select_list=1&keyword='+encodeURIComponent(form_upd_product.product_manager_name.value));"></span>
												<cfif GET_OUR_COMPANY_INFO.IS_PRODUCT_COMPANY EQ 1>
													<span class="input-group-addon btnPointer bold" onclick="alert('Ürün Parametrelerinden Düzenleyiniz !');">?</span>
												</cfif>
											</div>
										</div>
									</div>
									<cfsavecontent variable="txt"><cfoutput>#get_product.product_catid#</cfoutput></cfsavecontent>
									<div class="form-group" id="item-product_catid1">
										<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57810.Ek Bilgi'></label>
										<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
											<cf_wrk_add_info info_type_id="-5" info_id="#attributes.pid#" upd_page = "1" colspan="9" product_catid1=#txt#>
										</div>
									</div>						
								</div>
								<div class="col col-5 col-md-6 col-sm-6 col-xs-12" type="column" index="7" sort="true">
									<div class="form-group" id="item-product_code_2" >
										<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57789.özel Kodu'></label>
										<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
											<cfif isdefined("is_mpc_code") and is_mpc_code eq 1>
												<div class="input-group">
											</cfif>
											<cfinput type="hidden" name="old_product_code_2" id="old_product_code_2" value="#get_product.product_code_2#">
											<cfif is_mpc_code neq 0>
												<cfinput type="text" name="product_code_2" id="product_code_2" readonly="readonly" value="#get_product.product_code_2#" maxlength="50">
											<cfelse>
												<cfinput type="text" name="product_code_2" id="product_code_2"  value="#get_product.product_code_2#" maxlength="50">
											</cfif>
											<cfif isdefined("is_mpc_code") and is_mpc_code eq 1>
													<span class="input-group-addon icon-ellipsis btnPointer" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.popup_list_mpc_create&type=2&product_id=#get_product.product_id#&product_code_2=</cfoutput>'+document.getElementById('product_code_2').value);"></span>
												</div>
											</cfif>	
										</div>
									</div>
									<div class="form-group" id="item-barcod">
										<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57633.Barkod'> <cfif get_our_company_info.is_barcod_required> *</cfif></label>
										<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
											<div class="input-group">
												<input type="hidden" name="old_barcod" id="old_barcod" value="<cfoutput>#get_product.barcod#</cfoutput>">
												<cfinput type="text" name="barcod" value="#get_product.barcod#"   onKeyUp="barcod_control();">
												<cfsavecontent variable="message_"><cf_get_lang dictionary_id='33505.Yeni Otomatik Barkod Oluşturulacak Emin misiniz ?'></cfsavecontent>
												<cfif is_auto_barcode eq 0>
													<span class="input-group-addon btnPointer" onclick="javascript:if (confirm('<cfoutput>#message_#</cfoutput>')) document.form_upd_product.barcod.value='<cfoutput>#get_barcode_no()#</cfoutput>'; else return;" title="<cf_get_lang dictionary_id='37940.Otomatik barkod'> !"><i class="fa fa-plus"></i></span>
												<cfelse>
													<span class="input-group-addon btnPointer" onclick="javascript:if (confirm('<cfoutput>#message_#</cfoutput>')) document.form_upd_product.barcod.value='<cfoutput>#get_barcode_no(1)#</cfoutput>'; else return;" title="<cf_get_lang dictionary_id='37940.Otomatik barkod'>"><i class="fa fa-plus"></i></span>
												</cfif>
											</div>
										</div>
									</div>
									<div class="form-group" id="item-product_detail">
										<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
										<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
											<div class="input-group">
												<cfinput type="text" name="product_detail" value="#get_product.product_detail#" maxlength="500" >
												<span class="input-group-addon">
													<!--- sonradan ekledim --->
													<cf_language_info 
														table_name="PRODUCT" 
														column_name="PRODUCT_DETAIL" 
														column_id_value="#url.pid#" 
														maxlength="500" 
														datasource="#dsn1#" 
														column_id="PRODUCT_ID" 
														control_type="0">
													<!--- sonradan ekledim --->
												</span>
											</div>
										</div>
									</div>
									<div class="form-group" id="item-product_detail2">
										<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'> 2</label>
										<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
											<div class="input-group">
												<cfinput type="text" name="product_detail2" value="#get_product.product_detail2#" maxlength="500" >
												<span class="input-group-addon">
													<cf_language_info 
														table_name="PRODUCT" 
														column_name="PRODUCT_DETAIL2" 
														column_id_value="#url.pid#" 
														maxlength="500" 
														datasource="#dsn1#" 
														column_id="PRODUCT_ID" 
														control_type="0">
												</span>
											</div>
										</div>
									</div>
									<div class="form-group" id="item-tax_purchase">
										<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='37631.Alis KDV'> *</label>
										<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
											<cfinclude template="../query/get_kdv.cfm">
											<cfinput type="hidden" name="old_tax_purchase" id="old_tax_purchase" value="#get_product.tax_purchase#">
											<select name="tax_purchase" id="tax_purchase" >
												<cfoutput query="get_kdv">
													<option value="#tax#" <cfif tax is get_product.tax_purchase> selected</cfif>>#tax#</option>
												</cfoutput>
											</select>
										</div>
									</div>
									<div class="form-group" id="item-tax_purchase">
										<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='37916.Satış KDV'>*</label>
										<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
											<cfinput type="hidden" name="old_tax_sell" value="#get_product.tax#">
											<select name="tax" id="tax">
												<cfoutput query="get_kdv">
													<option value="#tax#" <cfif tax is get_product.tax> selected</cfif>>#tax#</option>
												</cfoutput>
											</select>
										</div>
									</div>
									<cfinclude template="../query/get_money.cfm">
									<cfif session.ep.isBranchAuthorization>
										<cfset style_ = 'display:none;'>
									<cfelse>
										<cfset style_ = "display:'block'">
									</cfif>
									<div class="form-group" id="item-STANDART_ALIS" extra_select="MONEY_ID_SA,is_tax_included_purchase" style="#style_#">
										<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58722.Standart Alış'></label>
										<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
											<cfquery name="GET_PRICE" datasource="#DSN3#">
												SELECT
													PRICE,
													PRICE_KDV,
													IS_KDV,
													MONEY 
												FROM 
													PRICE_STANDART,
													PRODUCT_UNIT
												WHERE
													PRICE_STANDART.PURCHASESALES = 0 AND
													PRODUCT_UNIT.IS_MAIN = 1 AND 
													PRICE_STANDART.PRICESTANDART_STATUS = 1 AND
													PRODUCT_UNIT.PRODUCT_ID = PRICE_STANDART.PRODUCT_ID AND 
													PRODUCT_UNIT.PRODUCT_UNIT_ID = PRICE_STANDART.UNIT_ID AND	
													PRICE_STANDART.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pid#">
											</cfquery>
											<cfset alis_standart = get_price.price>
											<input name="OLD_STANDART_ALIS" id="OLD_STANDART_ALIS" type="hidden" value="<cfoutput>#get_price.price#</cfoutput>" >
											<cfsavecontent variable="message"><cf_get_lang dictionary_id='37334.standart alış girmelisiniz'></cfsavecontent>
											<cfif get_price.is_kdv is 1>
												<cfinput type="text" name="STANDART_ALIS" class="moneybox" message="#message#" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.purchase_price_round_num#));" value="#TLFormat(get_price.price_kdv,session.ep.our_company_info.purchase_price_round_num)#">
											<cfelse>
												<cfinput type="text" name="STANDART_ALIS" class="moneybox" message="#message#" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.purchase_price_round_num#));" value="#TLFormat(get_price.price,session.ep.our_company_info.purchase_price_round_num)#">
											</cfif>
										</div>
										<div class="col col-2 col-md-2 col-sm-2 col-xs-12">
											<select name="MONEY_ID_SA" id="MONEY_ID_SA" >
											<cfif (session.ep.period_year lt 2009 and get_price.money is 'TL') or (session.ep.period_year gte 2009 and get_price.money is 'YTL')>
												<cfset temp_price_money=session.ep.money>
											<cfelse>
												<cfset temp_price_money=get_price.money>
											</cfif>
											<cfoutput query="get_money">
												<option value="#money#" <cfif money is temp_price_money> selected</cfif>>#money#</option>
											</cfoutput>
											</select>
										</div>
										<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
											<select name="is_tax_included_purchase" id="is_tax_included_purchase">
												<option value="1" <cfif get_price.is_kdv is 1> selected</cfif>><cf_get_lang dictionary_id='37439.KDV Dahil'></option>
												<option value="0" <cfif get_price.is_kdv is 0> selected</cfif>><cf_get_lang dictionary_id='37440.KDV Hariç'></option>
											</select>
										</div>
										<input type="hidden" name="old_is_tax_included_purchase" id="old_is_tax_included_purchase" value="<cfoutput>#get_price.is_kdv#</cfoutput>">
										<input type="hidden" name="MONEY_ID_SA_OLD" id="MONEY_ID_SA_OLD" value="<cfoutput>#temp_price_money#</cfoutput>">
									</div>
									<cfsavecontent variable="header_"><cfif session.ep.isBranchAuthorization><cf_get_lang dictionary_id='37542.Sube Satış'><cfelse><cf_get_lang dictionary_id='58721.Standart Satış'></cfif></cfsavecontent>
									<div class="form-group" id="item-STANDART_SATIS" extra_select="is_tax_included_sales,money_id_ss">
										<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cfif session.ep.isBranchAuthorization><cf_get_lang dictionary_id='37542.Sube Satış'><cfelse><cf_get_lang dictionary_id='58721.Standart Satış'></cfif></label>
										<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
											<cfquery name="GET_PRICE" datasource="#DSN3#">
												SELECT
													PRICE,
													PRICE_KDV,
													IS_KDV,
													MONEY 
												FROM
													PRICE_STANDART,
													PRODUCT_UNIT
												WHERE
													PRICE_STANDART.PURCHASESALES = 1 AND
													PRODUCT_UNIT.IS_MAIN = 1 AND 
													PRICE_STANDART.PRICESTANDART_STATUS = 1 AND
													PRODUCT_UNIT.PRODUCT_ID = PRICE_STANDART.PRODUCT_ID AND 
													PRODUCT_UNIT.PRODUCT_UNIT_ID = PRICE_STANDART.UNIT_ID AND	
													PRICE_STANDART.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pid#">
											</cfquery>
											<cfset satis_standart = get_price.price_kdv>
											<cfif (session.ep.period_year lt 2009 and get_price.money is 'TL') or (session.ep.period_year gte 2009 and get_price.money is 'YTL')>
												<cfset temp_sale_price_money=session.ep.money>
											<cfelse>
												<cfset temp_sale_price_money=get_price.money>
											</cfif>
											<input name="OLD_STANDART_SATIS" id="OLD_STANDART_SATIS" type="hidden" value="<cfoutput>#get_price.price_kdv#</cfoutput>">
											<cfsavecontent variable="message"><cf_get_lang dictionary_id='37335.standart satış girmelisiniz'></cfsavecontent>
											<cfif len(get_price.is_kdv) and get_price.is_kdv>
												<cfinput type="text" name="STANDART_SATIS" id="STANDART_SATIS" class="moneybox" message="#message#" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.sales_price_round_num#));" value="#TLFormat(get_price.price_kdv,session.ep.our_company_info.sales_price_round_num)#">				
											<cfelse>
												<cfinput type="text" name="STANDART_SATIS" id="STANDART_SATIS" class="moneybox" message="#message#" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.sales_price_round_num#));" value="#TLFormat(get_price.price,session.ep.our_company_info.sales_price_round_num)#">				
											</cfif>
										</div>
										<div class="col col-2 col-md-2 col-sm-2 col-xs-12">
											<select name="money_id_ss" id="money_id_ss">
												<cfoutput query="get_money">
												<option value="#get_money.money#" <cfif get_money.money is temp_sale_price_money> selected</cfif>>#get_money.money#</cfoutput>
											</select>
										</div>
										<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
											<select name="is_tax_included_sales" id="is_tax_included_sales">
												<option value="1" <cfif len(get_price.is_kdv) and get_price.is_kdv is 1> selected</cfif>><cf_get_lang dictionary_id='37439.KDV Dahil'>
												<option value="0" <cfif len(get_price.is_kdv) and get_price.is_kdv is 0> selected</cfif>><cf_get_lang dictionary_id='37440.KDV Hariç'>
											</select>
										</div>
										<input type="hidden" name="old_is_tax_included_sales" id="old_is_tax_included_sales" value="<cfoutput>#get_price.IS_KDV#</cfoutput>">
										<input type="hidden" name="money_id_ss_old" id="money_id_ss_old" value="<cfoutput>#temp_sale_price_money#</cfoutput>">
									</div>
									<div class="form-group" id="item-MIN_MARGIN">
										<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='37374.Min Marj'></label>
										<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
											<div class="input-group">
												<span class="input-group-addon"><cf_get_lang dictionary_id='58908.min'></span>
												<input type="text" name="MIN_MARGIN" id="MIN_MARGIN" value="<cfoutput>#TLFORMAT(get_product.min_margin,4)#</cfoutput>">								
												<span class="input-group-addon"><cf_get_lang dictionary_id='58909.max'></span>								  
												<input type="text" name="MAX_MARGIN" id="MAX_MARGIN" value="<cfoutput>#TLFORMAT(get_product.max_margin,4)#</cfoutput>" >
											</div>
										</div>				
									</div>
									<cfif is_show_otv eq 1>  <!--- XML Sayfasında OTV Gözüksün mü (1'se Evet) form_add_product.xml --->
										<cfinclude template="../query/get_otv.cfm"> <!---  OTV değerleri eklemek için  --->
										<div class="form-group" id="item-type-otv">
											<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='62555.ÖTV Tipi'>-<cf_get_lang dictionary_id='58021.ÖTV'><cf_get_lang dictionary_id='58671.Oranı'></label>
											<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
												<select name="otv_type" id="otv_type" onchange="show2()">
													<option value="" ><cf_get_lang dictionary_id='57734.Seçiniz'></option>
													<option value="1" <cfif get_product.otv_type eq 1> selected</cfif>><cf_get_lang dictionary_id='62479.Sabit Tutar'></option>
													<option value="2" <cfif get_product.otv_type eq 2> selected</cfif>><cf_get_lang dictionary_id='62480.Oransal'></option>
												</select>
											</div>
											<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
												<div class="input-group">
													<select name="OTV" id="OTV_2">
														<option value=""><cf_get_lang dictionary_id='58546.Yok'></option>
														<cfoutput query="get_otv">
															<option value="#tax#" <cfif tax is get_product.otv> selected</cfif>>#tlformat(tax)#</option>
														</cfoutput>
													</select>
													<span class="input-group-addon"> % </span>
												</div>
											</div>
										</div>
										<div class="form-group" id="item-OTV-1">
											<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58021.ÖtV'></label>
											<div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
												<cfoutput>
												<input type="text" name="OTV" id="OTV" class="moneybox" <cfif get_product.otv_type eq 1 >value="#tlformat(get_product.otv,4)#"</cfif> onkeyup="return(FormatCurrency(this,event,4));">
												</cfoutput>
											</div>
										</div>
									
									</cfif>
									<cfif is_show_oiv eq 1>  <!--- XML Sayfasında OIV Gözüksün mü (1'se Evet) form_add_product.xml --->
										<cfinclude template="../query/get_oiv.cfm">  <!--- OIV değerleri eklemek için --->
										<div class="form-group" id="item-OIV">
											<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cfoutput>#getLang('contract',282)#</cfoutput></label> 
											<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
												<select name="OIV" id="OIV">
													<option value=""><cf_get_lang dictionary_id='58546.Yok'></option>
													<cfoutput query="get_oiv">
														<option value="#tax#" <cfif get_oiv.tax is get_product.oiv> selected</cfif>>#tax# </option>
													</cfoutput>
												</select>
											</div>
										</div>
									</cfif>
									<cfif is_show_bsmv eq 1>  <!--- XML Sayfasında BSMV Gözüksün mü (1'se Evet) form_add_product.xml --->
										<cfinclude template="../query/get_bsmv.cfm">  <!--- BSMV değerleri eklemek için --->
										<div class="form-group" id="item-BSMV">
											<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='50923.BSMV'></label> 
											<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
												<select name="BSMV" id="BSMV">
													<option value=""><cf_get_lang dictionary_id='58546.Yok'></option>
													<cfoutput query="get_bsmv">
														<option value="#tax#" <cfif tax is get_product.bsmv> selected</cfif>>#tax# </option>
													</cfoutput>
												</select>
											</div>
										</div>
									</cfif>
									<cfquery name="GET_WORK_STOCK" datasource="#DSN#">
										SELECT WORK_STOCK_ID FROM OUR_COMPANY_INFO WHERE WORK_STOCK_ID IS NOT NULL
									</cfquery>
									<cfif get_work_stock.recordcount>
										<div class="form-group" id="item-work_product_name">
											<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='37543.İşçilik Ürünü'></label>
											<div class="col col-6 col-xs-12">
												<div class="input-group">
													<input type="hidden" name="work_stock_id" id="work_stock_id" value="<cfoutput>#get_product.work_stock_id#</cfoutput>">
													<input type="text" name="work_product_name" id="work_product_name" value="<cfif len(get_product.work_stock_id)><cfoutput>#get_product_name(stock_id:get_product.work_stock_id,with_property:1)#</cfoutput></cfif>" onFocus="AutoComplete_Create('work_product_name','PRODUCT_NAME','PRODUCT_NAME','get_product','0','PRODUCT_ID,STOCK_ID','work_product_name,work_stock_id','','2','200');" autocomplete="off">
													<span class="input-group-addon icon-ellipsis btnPointer" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&field_id=form_upd_product.work_stock_id&field_name=form_upd_product.work_product_name');" title="<cf_get_lang dictionary_id='30416.Ürün Seç'>"></span>
												</div>
											</div>
											<div class="col col-2 col-xs-12">
												<cfinput type="text" name="work_stock_amount" id="work_stock_amount" value="#TLFormat(get_product.work_stock_amount,2)#" class="moneybox" onkeyup="return(formatcurrency(this,event,3));" validate="float" range="0," message="#getLang('','Miktar Girin',37413)#">
											</div>
										</div>
									</cfif>
									<div class="form-group" id="item-shelf_life">
										<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='37023.Raf Ömrü'></label>
										<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
											<input type="text" name="shelf_life" id="shelf_life" maxlength="50" value="<cfoutput>#get_product.shelf_life#</cfoutput>"  onkeyup="isNumber(this)">
										</div>
									</div>
									<div class="form-group" id="item-user_friendly_url" >
										<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='38023.Kullanıcı Dostu Url'></label>
										<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
											<cf_publishing_settings fuseaction="product.list_product" event="det" action_type="PRODUCT_ID" action_id="#url.pid#">									
										</div>
									</div>
									
									<div id="display_div"></div>
									<!------->
								</div>
							</cf_box_elements>
						</div>
						<div id="unique_sayfa_3" class="ui-info-text uniqueBox">
							<cf_box_elements>
								<div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="3" sort="true">
									<cfoutput>
									
										<div class="form-group" id="item-purchase_carbon_value">
											<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='63008.Alım Karbon Değeri'></label>
											<div class="col col-6 col-md-8 col-sm-8 col-xs-12">
												<input type="text" name="purchase_carbon_value" id="purchase_carbon_value" value="#TLFORMAT(GET_PRODUCT.purchase_carbon_value,8)#">
											</div>						
										</div>
										<div class="form-group" id="item-sales_carbon_value">
											<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='63009.Satım Karbon Değeri'></label>
											<div class="col col-6 col-md-8 col-sm-8 col-xs-12">
												<input type="text" name="sales_carbon_value" id="sales_carbon_value" value="#TLFORMAT(GET_PRODUCT.sales_carbon_value,8)#">
											</div>						
										</div>
										<div class="form-group" id="item-recycle_rate">
											<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='63010.Geri Kazanım Oranı'> %</label>
											<div class="col col-6 col-md-8 col-sm-8 col-xs-12">
												<input type="text" name="recycle_rate" id="recycle_rate" value="#TLFORMAT(GET_PRODUCT.recycle_rate)#">
											</div>						
										</div>
										<div class="form-group" id="item-recycle_method">
											<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='63011.Geri Kazanım Yöntemi'></label>
											<div class="col col-6 col-md-8 col-sm-8 col-xs-12">
												<select name="recycle_method" id="recycle_method">
													<option value="1" <cfif get_product.recycle_method eq 1>selected="selected"</cfif>><cf_get_lang dictionary_id='63012.Yakma'></option>
													<option value="2" <cfif get_product.recycle_method eq 2>selected="selected"</cfif>><cf_get_lang dictionary_id='63014.Geri Dönüştürme'></option>
													<option value="3" <cfif get_product.recycle_method eq 3>selected="selected"</cfif>><cf_get_lang dictionary_id='63013.Çöpe atma'></option>
													<option value="4" <cfif get_product.recycle_method eq 4>selected="selected"</cfif>><cf_get_lang dictionary_id='63015.Arıtma'></option>
													<option value="5" <cfif get_product.recycle_method eq 5>selected="selected"</cfif>><cf_get_lang dictionary_id='63016.Temizleme'></option>
													<option value="6" <cfif get_product.recycle_method eq 6>selected="selected"</cfif>><cf_get_lang dictionary_id='57448.Satış'></option>
												</select>
											</div>						
										</div>
										<div class="form-group" id="item-recycle_calculation_type">
											<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='63017.Bertaraf Hesaplama Yöntemi'></label>
											<div class="col col-6 col-md-8 col-sm-8 col-xs-12">
												<select name="recycle_calculation_type" id="recyle_calculation_type">
													<option value="1" <cfif get_product.RECYCLE_CALCULATION_TYPE eq 1>selected="selected"</cfif>><cf_get_lang dictionary_id="63019.Ürün Fiyatının %'si"></option>
													<option value="2" <cfif get_product.RECYCLE_CALCULATION_TYPE eq 2>selected="selected"</cfif>><cf_get_lang dictionary_id='62479.Sabit Tutar'></option>
												</select>
											</div>						
										</div>
										<div class="form-group" id="item-disposal_cost ">									
											<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='65333.Bertaraf Maliyeti'></label>
											<div class="col col-6 col-md-8 col-sm-8 col-xs-12">
												<div class="input-group">
													<input type="text" name="disposal_cost" id="disposal_cost" value="#TLformat(get_product.disposal_cost)#" onKeyUp="return(FormatCurrency(this,event,4))" class="moneybox">
													<span class="input-group-addon width">
														<select name="disposal_cost_currency" id="disposal_cost_currency">
															<cfloop query="get_moneys">
																<option value="#money#"<cfif money eq get_product.disposal_cost_currency>selected</cfif>>#money#</option>
															</cfloop>
														</select>
													</span>
												</div>
											</div>
											<label class="col col-2 col-md-2 col-sm-2 col-xs-12">#GET_PRODUCT.MAIN_UNIT#/<cf_get_lang dictionary_id='993.Birim Başına'></label>																													
										</div>
										<div class="form-group" id="item-project_head">
											<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='65342.Geri Kazanım Grubu'></label>
											<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
												<cfif len(get_product.recycle_group_id)>
													<cfset get_recycle_group= get_product_list_action.get_recycle_group(recycle_sub_group_id:get_product.recycle_group_id)>
												</cfif>
												<div class="input-group">
													<input type="hidden" name="recycle_group_id" id="recycle_group_id" value="<cfif len(get_product.recycle_group_id)>#get_product.recycle_group_id#</cfif>">
													<input type="hidden" name="recycle_group_main_id" id="recycle_group_main_id" value="<cfif isdefined("get_recycle_group")>#get_recycle_group.MAIN_GROUP_ID#</cfif>">
													<input type="hidden" name="recycle_group_code" id="recycle_group_code" value="<cfif isdefined("get_recycle_group")>#get_recycle_group.RECYCLE_SUB_GROUP_CODE#</cfif>">
													<input type="text" name="recycle_group" id="recycle_group" value="<cfif isdefined("get_recycle_group")>#get_recycle_group.RECYCLE_SUB_GROUP#</cfif>">
													
													<span class="input-group-addon btnPointer icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_recycle_group&field_id=form_upd_product.recycle_group_id&field_name=form_upd_product.recycle_group&field_main_id=form_upd_product.recycle_group_main_id&field_code=form_upd_product.recycle_group_code','','ui-draggable-box-medium');"></span>
												</div>					
											</div>						
										</div>
									</cfoutput>
								</div>
							</cf_box_elements>
						</div>
						<div id="unique_sayfa_4" class="ui-info-text uniqueBox">
							<cf_box_elements vertical="1">
								<div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="4" sort="true">
									<cfif GET_OUR_COMPANY_INFO.recordCount and GET_OUR_COMPANY_INFO.IS_WATALOGY_INTEGRATED eq 1>
										<div class="form-group" id="item-watalogy_product_cat">
											<label><cf_get_lang dictionary_id='61453.Watalogy Kategorisi'></label>
											<div class="input-group">
												<cfsavecontent  variable="message"><cf_get_lang dictionary_id='61453.Watalogy Kategorisi'></cfsavecontent>
												<cfinput type="hidden" name="watalogy_cat_id" value="#get_product.WATALOGY_CAT_ID#">
												<cfinput type="text" name="watalogy_cat_name" id="watalogy_cat_name" value="#watalogy_cat_name#">
												<span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_watalogy_category_names&field_id=form_upd_product.watalogy_cat_id&field_name=form_upd_product.watalogy_cat_name','','ui-draggable-box-large');" title="<cf_get_lang dictionary_id='61454.Watalogy Kategorisi Ekle'>!"></span>
											</div>
										</div>
									</cfif>
								</div>
								<div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="5" sort="true">
									<div class="form-group" id="item-product_keyword">
										<label><cf_get_lang dictionary_id="47741.Anahtar Kelimeler"> *</label>
										<input type="text" name="product_keyword" id="product_keyword" maxlength="250" value="<cfoutput>#get_product.product_keyword#</cfoutput>"/>
									</div>
								</div>
								<div class="col col-12 col-md-12 col-sm-12 col-xs-12" type="column" index="6" sort="true">
									<div class="form-group" id="item-product_desc">
										<label><cf_get_lang_main no="640.Özet"> *</label>
										<textarea name="product_description" id="product_description" onChange="counterr();return ismaxlength(this);" onkeydown="counterr();return ismaxlength(this);" onkeyup="counterr();return ismaxlength(this);" onBlur="return ismaxlength(this);" ><cfoutput>#get_product.product_description#</cfoutput></textarea>
									</div>
									<div class="form-group" id="item-product_detail_watalogy">
										<label><cf_get_lang dictionary_id='46775.Dataylı Bilgi'> *</label>
										<cfmodule
											template="/fckeditor/fckeditor.cfm"
											toolbarSet="mailcompose"
											basePath="/fckeditor/"
											instanceName="product_detail_watalogy"
											valign="top"
											value="#get_product.product_detail_watalogy#"
											width="600"
											height="150">
									</div>
								</div>
							</cf_box_elements>
						</div>
					</cf_tab>
					<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
						<cf_box_footer>
							<div class="col col-6">
								<cf_record_info 
									query_name="get_product"
									record_emp="record_member" 
									record_date="record_date"
									update_emp="update_emp"
									update_date="update_date">
							</div>
							<div class="col col-6">
								<cf_workcube_buttons is_upd='1' is_delete='0' add_function='kontrol()' data_action ="V16/product/cfc/get_product:upd_product" next_page="#request.self#?fuseaction=product.list_product&event=det&pid=">
								<!--- <cfif fusebox.circuit is "product">
									<cf_workcube_buttons is_upd='1' is_delete='0' add_function='kontrol()'>
								<cfelse><!--- Subeden eklenen bir urun bizim subemizden eklenmisse --->
									<cfif get_product.record_branch_id eq listgetat(session.ep.user_location,2,'-')>
										<cf_workcube_buttons is_upd='1' is_delete='0' add_function='kontrol()'><!---  class="button_input" --->
									</cfif>	
								</cfif> --->
							</div>            
						</cf_box_footer>
					</div>
				</cfform>
			</cf_box>
			<cfsavecontent variable="stock"><cf_get_lang dictionary_id='58166.Stoklar'></cfsavecontent>
			<cfsavecontent variable="info_title"><cf_get_lang dictionary_id="29439.Toplu Stok Ekle"></cfsavecontent>
			<cfif GET_PROPERTY.recordCount>
				<cfset adres_="openBoxDraggable('#request.self#?fuseaction=product.form_add_popup_sub_stock_code&pid=#get_product.product_id#&pcode=#get_product.product_code#&is_auto_barcode=#is_auto_barcode#');">
			<cfelse>
				<cfset adres_="stocks()">
			<!--- 	<cfscript>
					<cfset adres_="alert('<cf_get_lang dictionary_id="30433.Şık Sayısı"> : <cf_get_lang dictionary_id='506.Girilen Miktar 0 Olamaz'>!')";>
				</cfscript>
			 --->
			</cfif>
			<cf_box 
				add_href="openBoxDraggable('#request.self#?fuseaction=product.form_add_popup_stock_code&pid=#get_product.product_id#&pcode=#get_product.product_code#&is_terazi=#get_product.is_terazi#&is_inventory=#get_product.is_inventory#&is_auto_barcode=#is_auto_barcode#','','ui-draggable-box-medium');"
				info_title="#info_title#" 
				id="_dsp_product_stocks_" 
				unload_body="1" 
				closable="0" 
				title="#stock#" 
				box_page="#request.self#?fuseaction=product.emptypopup_ajax_dsp_product_stocks&is_production=#get_product.is_production#&pid=#attributes.pid#&product_code=#get_product.product_code#&is_terazi=#get_product.is_terazi#&is_inventory=#get_product.is_inventory#&is_auto_barcode=#is_auto_barcode#&is_product_status=#get_product.product_status#"
				info_title_6="#getLang('','Ölçü ve Dağılım Tablosu',63452)#"
				info_href_6="#adres_#"
				info_href_7="#request.self#?fuseaction=objects.popup_product_stocks&pid=#attributes.pid#" 
				info_title_7="#stock#">
			</cf_box>
			<cfset company_cmp = createObject("component","V16.member.cfc.member_company")>
			<cfset GET_OURCMP_INFO = company_cmp.GET_OURCMP_INFO()>
			<cfif (GET_OURCMP_INFO.IS_WATALOGY_INTEGRATED)>
				<cf_box
					id="product_relation_supplier"
					unload_body="1"
					add_href="#request.self#?fuseaction=objects.popup_list_pars_multiuser&field_comp_id=form1.aaa&select_list=2&is_supplier=1&pid=#attributes.pid#"
					title="#getLang('','Tedarikçi','29528')#"
					widget_load="productRelationSupplier&pid=#attributes.pid#">
				</cf_box>
				<cf_box
					id="list_worknet_relation"
					unload_body="1"
					add_href="javascript:openBoxDraggable('#request.self#?fuseaction=worknet.list_product&event=popup_addWorknetRelation&pid=#attributes.pid#&form_submitted=1&draggable=1')"
					title="#getLang('','Pazaryeri','63775')#"
					widget_load="WatalogyRelationProducts&pid=#attributes.pid#&table=Product">
				</cf_box>
			</cfif>
		</div>
		<div class="col col-3 col-md-3 col-sm-3 col-xs-12" id="product_boxes">
			<!---Images--->
			<cf_wrk_images pid="#attributes.pid#" type="product" >
			<!---Birimler--->
			<cf_box 
				title="#getLang('','Birimler',37031)#" 
				unload_body="1" 
				id="product_unit_detail" 
				add_href="openBoxDraggable('#request.self#?fuseaction=product.form_add_popup_unit&pid=#attributes.pid#&product_code=#get_product.product_code#');"
				box_page="#request.self#?fuseaction=product.emptypopup_dsp_product_detail_units_ajax&pid=#attributes.pid#&is_show_unit_amount=#is_show_unit_amount#" 
				closable="0">
			</cf_box>
			<!---Belgeler--->
			<cf_get_workcube_asset asset_cat_id="-3" module_id='5' action_section='PRODUCT_ID' action_id='#attributes.pid#'>
			<!---Ürünün Bulunduğu Karma Koliler --->
			<cf_box 
				title="#getLang('','Karma Koliler',41048)# - #getLang('','Paket',100)#" 
				id="_mixed_product_" 
				unload_body="1" 
				add_href_size="longpage"
				add_href="#request.self#?fuseaction=product.dsp_karma_contents&pid=#url.pid#"
				box_page="#request.self#?fuseaction=product.emptypopup_product_mixed_ajax&pid=#attributes.pid#"
				right_images="<li><a href='#request.self#?fuseaction=product.dsp_karma_props&pid=#attributes.pid#' title='#getLang('','Yeni Ürün ve Karma Koli Oluştur',65390)#'><i class='catalyst-social-dropbox'></i></a></li>"
				closable="0">
			</cf_box>
			<!---İliskili Ürün Kategorileri--->
			<cf_box 
				title="#getLang('','İlişkili Ürün Kategorileri',37056)#" 
				id="_dsp_product_cat_relations_" 
				unload_body="1" 
				add_href="openBoxDraggable('#request.self#?fuseaction=product.popup_add_related_product_cat&pid=#attributes.pid#','','ui-draggable-box-small');"
				box_page="#request.self#?fuseaction=product.emptypopup_dsp_related_product_cat_ajax&pid=#attributes.pid#" 
				closable="0">
			</cf_box>
			<!---İliskili Ürünler--->
			<cf_box 
				title="#getLang('','İlişkili Ürünler',37101)#" 
				id="_dsp_product_relations_" 
				unload_body="1" 
				add_href="openBoxDraggable('#request.self#?fuseaction=product.popup_add_related_product&pid=#attributes.pid#','','ui-draggable-box-small');"
				box_page="#request.self#?fuseaction=product.emptypopup_dsp_product_relations_ajax&pid=#attributes.pid#" 
				closable="0">
			</cf_box>
			<!---Alternatif Ürünler--->
			<cf_box 
				title="#getLang('','Alternatif Ürünler',37102)#" 
				id="_dsp_product_alternatives_" 
				unload_body="1" 
				add_href="openBoxDraggable('#request.self#?fuseaction=product.popup_add_anative_product&pid=#attributes.pid#&call_function=yeni_yukle');"
				box_page="#request.self#?fuseaction=product.emptypopup_dsp_product_alternatives_ajax&pid=#attributes.pid#"
				closable="0">
			</cf_box>
			<!---Uyumsuz Ürünler--->
			<cf_box 
				title="#getLang('','Uyumsuz Ürünler',37507)#" 
				id="_dsp_product_anti_alternatives_" 
				unload_body="1" 
				add_href="openBoxDraggable('#request.self#?fuseaction=product.popup_add_anative_product_except&pid=#attributes.pid#','','ui-draggable-box-small');"
				box_page="#request.self#?fuseaction=product.emptypopup_dsp_product_anti_alternatives_ajax&pid=#attributes.pid#"
				closable="0">
			</cf_box>
			<!---Gösterildiği Vitrinler--->
			<script defer type="text/javascript" src="../JS/temp/multiselect/jquery.multiselect.filter.js"></script>
			<script defer type="text/javascript" src="../JS/temp/multiselect/jquery.multiselect.js"></script>
			<cf_box 
				title="#getLang('','İlişkili Vitrinler',59149)#" 
				id="_dsp_showed_vision_" 
				unload_body="1" 
				add_href="openBoxDraggable('#request.self#?fuseaction=product.popup_add_product_vision&product_id=#attributes.pid#','','ui-draggable-box-small');"
				add_href_size="medium"
				box_page="#request.self#?fuseaction=product.emptypopup_dsp_showed_vision_ajax&product_id=#attributes.pid#" 
				closable="0">
			</cf_box>
			<!--- İlişkili İçerikler --->
			<cf_get_workcube_content action_type ='PRODUCT_ID' action_type_id ='#attributes.pid#' style='0' design='0'>
			<!---Meta Tanımları --->
			<cf_meta_descriptions action_id = '#attributes.pid#' action_type ='PRODUCT_ID' faction_type='#listgetat(attributes.fuseaction,1,"&")#'>
			<!--- Dosya silinmişti hataya düşüyordu geri koydum PY--->
			<cfinclude template="dsp_product_offer_price.cfm">
			<!---Ürün Ekibi--->
			<cf_box 
				title="#getLang('','Ürün Ekibi',37079)#" 
				id="_product_team_" 
				unload_body="1" 
				add_href="openBoxDraggable('#request.self#?fuseaction=product.popup_form_add_upd_worker&pid=#url.pid#','','ui-draggable-box-small');"
				box_page="#request.self#?fuseaction=product.emptypopup_product_team_ajax&pid=#attributes.pid#"
				closable="0">
			</cf_box>
			<cfif is_mpc_code eq 2>            
				<cf_box
					title="#getLang('','MPC Kodu',37071)#"
					closable="0"
					unload_body="1"
					id="_dsp_product_mpc_code_"
					box_page="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.popup_list_mpc_create&type=2&product_id=#get_product.product_id#&product_code_2=#get_product.product_code_2#&is_ajax=1">
				</cf_box>
			</cfif>
		</div>
	</div>
<script type="text/javascript">
	$(window).load(function(){
		var onclick = $('#wrk_submit_button').attr('onclick');
		if(onclick == 'return nothing();'){
			$("#product_boxes a").prop("onclick", null).off("click");
			$("#info_link").attr({"href":"javascript://", "target":""});
		}	
	});
form_upd_product.product_name.focus();

function yeni_yukle()
{
	<cfoutput>
		refresh_box('_dsp_product_alternatives_','#request.self#?fuseaction=product.emptypopup_dsp_product_alternatives_ajax&pid=#attributes.pid#','0');
	</cfoutput>
}
function show2()
        {
            var option = document.getElementById("otv_type").value;
                if(option == "1")
                {
                    document.getElementById("item-OTV-1").style.display="block";
                    document.getElementById("item-OTV-2").style.display="none";
                    document.getElementById('OTV_2').value = "";
                    return true;
                }
                if(option == "2")
                {
                    document.getElementById("item-OTV-2").style.display="block";
                    document.getElementById("item-OTV-1").style.display="none";
                    document.getElementById('OTV').value = "";
                    return true;
                }
                if(option == "")
                {
                    document.getElementById("item-OTV-2").style.display="none";
                    document.getElementById("OTV-1").style.display="none";
                    document.getElementById('OTV_2').value = "";
                    document.getElementById('OTV').value = "";
                    return true;
                }
        }

function change_prod_msg()
{
	var msg_txt='';	
	<cfsavecontent variable="lang"><cf_get_lang dictionary_id="37911.Envantere Dahil Seçeneğini Kaldırdınız"></cfsavecontent>
	<cfif get_product.is_production eq 1>
	if(form_upd_product.is_production.checked==false)
		msg_txt="<cf_get_lang dictionary_id='37711.Üretiliyor Seçeneğini Kaldırdınız Ürünün Ağacını Düzenlemeniz Gerekebilir'> !";
	</cfif>
	<cfif get_product.is_inventory eq 1>
		if(form_upd_product.is_inventory.checked==false)
			msg_txt = msg_txt + '\n'+lang + '!';
			var lang = "<cfoutput>#replace(lang, """", "\""", "all")#</cfoutput>";
	</cfif>
	<cfif get_our_company_info.recordcount and get_our_company_info.is_guaranty_followup eq 1>
		<cfif get_product.is_serial_no eq 1>
			if(form_upd_product.is_serial_no.checked==false)
				msg_txt=msg_txt + '\n <cf_get_lang dictionary_id="37712.Seri No Takip Seçeneğini Kaldırdınız">!';
		</cfif>
	</cfif>
	<cfif get_product.is_lot_no eq 1>
		if(form_upd_product.is_lot_no.checked==false)
			msg_txt=msg_txt + '\n <cf_get_lang dictionary_id="38003.Lot No Takip Seçeneğini Kaldırdınız">!';
	</cfif>
	<cfif get_product.is_zero_stock eq 0>
		if(form_upd_product.is_zero_stock.checked==true)
			msg_txt=msg_txt + '\n <cf_get_lang dictionary_id="37713.Sıfır Stok Seçeneği Seçili Ürün Artık Sıfır Stokla Çalışacaktır">!';
	</cfif>
	<cfif get_product.is_karma eq 1>
		if(form_upd_product.is_karma.checked==false)
			msg_txt=msg_txt + '\n<cf_get_lang dictionary_id="37714.Karma Koli Seçeneğini Kaldırdınız">';
	</cfif>
	if(msg_txt!='')
	{
		var r = confirm(msg_txt+'\n\n<cf_get_lang dictionary_id="37715.Yaptığınız Düzenlemelerden Emin Olunuz">!');
		if (r == true)
			return true;
		else
			return false;
	}
	return true;
}
function kontrol_day()
{
	if(document.form_upd_product.is_gift_card.checked == true)
		$("#item-gift_valid_day").show();
	else
		$("#item-gift_valid_day").hide();
}
function kontrol()
{
	if(document.form_upd_product.process_stage.value == ''){
            alertObject({message: "<cf_get_lang dictionary_id='58842.Lütfen Süreç Seçiniz'>!"});
            return false;
        }
	temp_profit_margin_min = filterNum(form_upd_product.MIN_MARGIN.value);
	temp_profit_margin_max = filterNum(form_upd_product.MAX_MARGIN.value);
	if(temp_profit_margin_min!="" && temp_profit_margin_max!="" && (temp_profit_margin_min>temp_profit_margin_max))
	{
		alert("<cf_get_lang dictionary_id='37702.Marj Degerlerini Kontrol Ediniz'>!");
		return false;
	}
	if ($('input#is_watalogy_integrated').is(':checked') && ($('input#watalogy_cat_id').val().length<1 || $('input#watalogy_cat_name').val().length<1 || $('#product_description').val().length<1 || $('#product_keyword').val().length<1 || $('#product_detail_watalogy').val().length<1 )) {
		alert("<cf_get_lang dictionary_id='63587.Required Field'>: <cf_get_lang dictionary_id='30366.Watalogy'>");
			return false;
	}
	<cfif GET_PRODUCT_TREE.recordcount and get_product.is_prototype eq 1>
		if(form_upd_product.is_prototype.checked==false){
			if (!confirm("<cf_get_lang dictionary_id='60381.Ürüne Ait Kayıtlar Var'>. <cf_get_lang dictionary_id='60382.Özelleştirilebilir Seçeneğini Kaldırmak İstediğinizden Emin Misiniz'>?") )
			{
			  return false;
			}
		}
	</cfif>
	<cfif is_special_code_for_one eq 1>
		if ($('#product_code_2').val().length > 0)
			{  
				var check_code = wrk_safe_query("prd_check_code", "dsn3", 0, $('#product_code_2').val());
				if($('#old_product_code_2').val() != $('#product_code_2').val() && check_code.recordcount > 0)
				{
					alert("<cf_get_lang dictionary_id='37921.Bu özel kod daha önce kullanılmıştır !'>");
					return false;
				}
			}
	</cfif>
	if(form_upd_product.is_gift_card.checked && form_upd_product.gift_valid_day.value==''){
		alert("<cf_get_lang dictionary_id='38025.Hediye Kartı İçin Geçerlilik Tarihi Girmelisiniz'>!");
		return false;
	}
	change_prod_msg();
	
	if(form_upd_product.is_terazi.checked && trim(form_upd_product.barcod.value).length!=7){
		alert("<cf_get_lang dictionary_id='37681.Teraziye Giden Ürünler İçin Barkod 7 Karakter Olmalıdır'>!");
		return false;
	}
	if(form_upd_product.is_inventory.checked && form_upd_product.barcode_require.value == 1 && trim(form_upd_product.barcod.value).length<7){
		alert("<cf_get_lang dictionary_id='37682.Envantere Dahil Ürünler İçin En Az 7 Karakter Barkod Girmelisiniz'>!");
		return false;
	}
	if (form_upd_product.product_cat.value == '' || form_upd_product.product_catid.value == '')
	{
		alert("<cf_get_lang dictionary_id='58947.Kategori Secmelisiniz'>");
		return false;
	}
	if(form_upd_product.tax.options.length <1)
	{
		alert("<cf_get_lang dictionary_id='37716.Lütfen KDV Bilgisi Ekleyiniz'>!");
		return false;
	}

	x = (500 - form_upd_product.product_detail.value.length);
	if ( x < 0 )
	{ 
		alert ("<cf_get_lang dictionary_id='37700.Ürün Açıklaması'> "+ ((-1) * x) +"<cf_get_lang dictionary_id='29538.Karakter Uzun'>!");
		return false;
	}
	if ( (form_upd_product.old_product_catid.value != form_upd_product.product_catid.value) || (form_upd_product.old_product_code.value!=form_upd_product.product_code.value) )
	{
		if (!confirm("<cf_get_lang dictionary_id='37717.Bu Değişiklik Stok Hiyerarşisinin Bozulmasına, Kaydedilmiş Ek Bilgilerin Silinmesine ve Veri Kaybına Neden Olabilir! Devam Etmek İstiyor musunuz'>?") )
	  	{
		  return false;
		}
	}
	if(form_upd_product.MIN_MARGIN.value == '')
		form_upd_product.MIN_MARGIN.value = 0;
	if(form_upd_product.MAX_MARGIN.value == '')
		form_upd_product.MAX_MARGIN.value = 0;
	temp_profit_margin_min = parseFloat(filterNum(form_upd_product.MIN_MARGIN.value));
	temp_profit_margin_max = parseFloat(filterNum(form_upd_product.MAX_MARGIN.value)); 
	
	if(temp_profit_margin_min!="" && temp_profit_margin_max!="" && (temp_profit_margin_min>temp_profit_margin_max))
	{
		alert("<cf_get_lang dictionary_id='37702.Marj Degerlerini Kontrol Ediniz'>!");
		return false;
	}
	<cfif get_work_stock.recordcount>
	if(form_upd_product.work_product_name.value!="" && form_upd_product.work_stock_id.value!="" && (form_upd_product.work_stock_amount.value==""))
	{
		alert("<cf_get_lang dictionary_id='37703.İşçilik Ürünü Miktarını Giriniz'>!");
		return false;
	}
	if(form_upd_product.work_stock_amount != undefined)
		form_upd_product.work_stock_amount.value = filterNum(form_upd_product.work_stock_amount.value);
	</cfif>
	var urun_adi_ = document.form_upd_product.product_name.value;
	var urun_adi_ = ReplaceAll(urun_adi_,"'"," ");
	var new_sql = "SELECT P.PRODUCT_ID FROM PRODUCT P WHERE P.PRODUCT_NAME = '"+urun_adi_+"' AND P.PRODUCT_ID <> <cfoutput>#attributes.pid#</cfoutput>";
	
	var get_prod_info = wrk_query(new_sql,'dsn1');
	if(get_prod_info.recordcount)
	{
		<cfif isdefined('x_use_same_product_name') and x_use_same_product_name eq 1>
			alert("<cf_get_lang dictionary_id ='37925.Aynı İsimli Bir Ürün Daha Var'>!");
		<cfelse>
			alert("<cf_get_lang dictionary_id='37704.Aynı İsimli Bir Ürün Daha Var Lütfen Başka Bir Ürün İsmi Giriniz'>!");
			form_upd_product.product_name.focus();
			return false;
		</cfif>
	}
	if(form_upd_product.product_status.disabled == true)
		form_upd_product.product_status.disabled = false;
	if(process_cat_control())
		return unformat_fields();
}
	
	function unformat_fields()
	{ 
		document.getElementById('STANDART_ALIS').value = filterNum(document.getElementById('STANDART_ALIS').value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
		document.getElementById('STANDART_SATIS').value = filterNum(document.getElementById('STANDART_SATIS').value,<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>);
		document.getElementById('MIN_MARGIN').value = filterNum(form_upd_product.MIN_MARGIN.value);
		document.getElementById('MAX_MARGIN').value = filterNum(form_upd_product.MAX_MARGIN.value); 
		return true;
	}
	
	function barcod_control()
	{
		var prohibited_asci='32,33,34,35,36,37,38,39,40,41,42,43,44,59,60,61,62,63,64,91,92,93,94,96,123,124,125,156,171,187,163,126';
	    barcode = document.getElementById('barcod');
		toplam_ = barcode.value.length;
		deger_ = barcode.value;
		if(toplam_>0)
		{
			for(var this_tus_=0; this_tus_< toplam_; this_tus_++)
			{
				tus_ = deger_.charAt(this_tus_);
				cont_ = list_find(prohibited_asci,tus_.charCodeAt());
				if(cont_>0)
				{
					alert("[space],!,\"\,#,$,%,&,',(,),*,+,,;,<,=,>,?,@,[,\,],],`,{,|,},£,~ Karakterlerinden Oluşan Barcod Girilemez!");
					barcode.value = '';
					break;
				}
			}
		}
	}
	function stocks(){
		
		window.alert("<cf_get_lang dictionary_id='64113.Ürün Özellikleri Eklendiğinde Ölçü Dağılım Tablosu Girilebilir'>");
				
	}
</script>
</cfif>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
<cfsetting showdebugoutput="yes">
