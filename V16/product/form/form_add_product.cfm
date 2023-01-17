<cf_xml_page_edit fuseact="product.form_add_product">
	<cfparam name="MAXIMUM_STOCK" default="">
	<cfparam name="PROVISION_TIME" default="">
	<cfparam name="REPEAT_STOCK_VALUE" default="">
	<cfparam name="block_stock_value" default="">
	<cfparam name="saleable_stock_action_id" default="">
	<cfparam name="MINIMUM_STOCK" default="">
	<cfparam name="MINIMUM_ORDER_STOCK_VALUE" default="">
	<cfparam name="MINIMUM_ORDER_UNIT_ID" default="">
	<cfparam name="IS_LIVE_ORDER" default="">
	<cfparam name="STRATEGY_TYPE" default="">
	<cfparam name="STRATEGY_ORDER_TYPE" default="">
	<cfparam name="otv" default="0">
	<cfparam name="otv_type" default="0">
	<cfparam name="oiv" default="0">
	<cfparam name="bsmv" default="0">
	<cfparam name="dimention" default="">
	<cfparam name="weight" default="">
	<cfparam name="main_unit_id" default="0">
	<cfparam name="is_ship_unit" default="0">
	<cfparam name="tax_purchase" default="18">
	<cfparam name="tax_s" default="18">
	<cfparam name="max_margin" default="0">
	<cfparam name="min_margin" default="0">
	<cfparam name="product_detail" default="">
	<cfparam name="product_detail2" default="">
	<cfparam name="barcod" default="">
	<cfparam name="product_code_2" default="">
	<cfparam name="product_manager" default="">
	<cfparam name="product_manager_name" default="">
	<cfparam name="prod_comp" default="0">
	<cfparam name="segment_id" default="0">
	<cfparam name="product_name" default="">
	<cfparam name="product_cat_id" default="">
	<cfparam name="product_cat" default="">
	<cfparam name="hierarchy" default="">
	<cfparam name="brand_name" default="">
	<cfparam name="brand_id" default="">
	<cfparam name="brand_code" default="">
	<cfparam name="short_code" default="">
	<cfparam name="short_code_name" default="">
	<cfparam name="short_code_id" default="">
	<cfparam name="MANUFACT_CODE" default="">
	<cfparam name="is_prototype" default="0">
	<cfparam name="is_inventory" default="1">
	<cfparam name="product_status" default="1">
	<cfparam name="is_production" default="0">
	<cfparam name="is_sales" default="1">
	<cfparam name="is_purchase" default="1">
	<cfparam name="is_internet" default="0">
	<cfparam name="is_extranet" default="0">
	<cfparam name="is_zero_stock" default="0">
	<cfparam name="is_serial_no" default="0">
	<cfparam name="is_lot_no" default="0">
	<cfparam name="is_karma" default="0">
	<cfparam name="is_limited_stock" default="0">
	<cfparam name="is_cost" default="1">
	<cfparam name="is_terazi" default="0">
	<cfparam name="gift_valid_day" default="0">
	<cfparam name="is_commission" default="0">
	<cfparam name="is_gift_card" default="0">
	<cfparam name="is_quality" default="0">
	<cfparam name="PACKAGE_CONTROL_TYPE" default="0">
	<cfparam name="company_id" default="">
	<cfparam name="company" default="">
	<cfparam name="shelf_life" default="">
	<cfparam name="PRODUCT_CATID" default="">
	<cfparam name="PRODUCT_CAT" default="">
	<cfparam name="customs_recipe_code" default="">
	<cfparam name="is_imported" default="1">

	<cfif isdefined('attributes.pid') and len(attributes.pid)>
		<cfscript>
		if (isnumeric(attributes.pid))
		{
			get_product_list_action = createObject("component", "V16.product.cfc.get_product");
			get_product_list_action.dsn1 = dsn1;
			get_product_list_action.dsn_alias = dsn_alias;
			get_product_info = get_product_list_action.get_product_
			(
				pid : attributes.pid
			);
		}
		else
		{
			get_product_info.recordcount = 0;
		}
	</cfscript>
		<cfquery name="get_product_period" datasource="#dsn3#">
			SELECT PRODUCT_PERIOD.PRODUCT_PERIOD_CAT_ID FROM PRODUCT_PERIOD,#dsn_alias#.SETUP_PERIOD SP WHERE SP.PERIOD_ID = PRODUCT_PERIOD.PERIOD_ID AND SP.PERIOD_YEAR = #session.ep.period_year# AND PRODUCT_PERIOD.PRODUCT_ID = #attributes.pid# AND SP.OUR_COMPANY_ID = #session.ep.company_id#
		</cfquery>
		<cfif get_product_period.recordcount>
			<cfset product_period_cat_id = get_product_period.PRODUCT_PERIOD_CAT_ID>
		</cfif>
		<cfif get_product_info.recordcount>
			<cfscript>
				otv_type= get_product_info.OTV_TYPE;
				otv =get_product_info.OTV;
				oiv =get_product_info.OIV;
				bsmv =get_product_info.BSMV;
				dimention = get_product_info.DIMENTION;
				weight = get_product_info.WEIGHT;
				main_unit_id = get_product_info.MAIN_UNIT_ID;
				is_ship_unit = get_product_info.IS_SHIP_UNIT;
				tax_s=get_product_info.TAX;
				tax_purchase=  get_product_info.TAX_PURCHASE;
				min_margin = get_product_info.MIN_MARGIN;
				max_margin = get_product_info.MAX_MARGIN;
				product_detail =get_product_info.PRODUCT_DETAIL;
				if(is_mpc_code != 1)
					product_code_2 = get_product_info.PRODUCT_CODE_2;
				product_manager = get_product_info.PRODUCT_MANAGER;
				if(len(product_manager))
					product_manager_name = get_emp_info(product_manager,1,0);
				prod_comp =get_product_info.PROD_COMPETITIVE;
				segment_id = get_product_info.SEGMENT_ID;
				shelf_life=get_product_info.SHELF_LIFE;
				product_name = get_product_info.PRODUCT_NAME;
				product_cat_id = get_product_info.PRODUCT_CATID;
				product_cat = get_product_info.PRODUCT_CAT;
				hierarchy = get_product_info.hierarchy;
				brand_name = get_product_info.BRAND_NAME;
				brand_id = get_product_info.BRAND_ID;
				brand_code = get_product_info.BRAND_CODE;
				short_code = get_product_info.SHORT_CODE;
				short_code_name = get_product_info.model_name;
				short_code_id = get_product_info.SHORT_CODE_ID;
				manufact_code = get_product_info.MANUFACT_CODE;
				is_prototype = get_product_info.IS_PROTOTYPE;
				is_inventory = get_product_info.IS_INVENTORY;
				is_production = get_product_info.IS_PRODUCTION;
				is_sales = get_product_info.IS_SALES;
				is_purchase = get_product_info.IS_PURCHASE;
				is_internet = get_product_info.IS_INTERNET;
				is_extranet = get_product_info.IS_EXTRANET;
				is_zero_stock = get_product_info.IS_ZERO_STOCK;
				is_serial_no = get_product_info.IS_SERIAL_NO;
				is_lot_no = get_product_info.IS_LOT_NO;
				is_karma = get_product_info.IS_KARMA;
				is_limited_stock = get_product_info.IS_LIMITED_STOCK;
				is_cost = get_product_info.IS_COST;
				is_terazi = get_product_info.IS_TERAZI;
				is_gift_card = get_product_info.IS_GIFT_CARD;
				is_quality = get_product_info.IS_QUALITY;
				gift_valid_day = get_product_info.GIFT_VALID_DAY;
				package_control_type = get_product_info.PACKAGE_CONTROL_TYPE;
				company_id = get_product_info.COMPANY_ID;
				company = get_product_info.COMPANY;
				user_friendly_url =get_product_info.user_friendly_url;
				product_detail2 =get_product_info.product_detail2;
				is_imported = get_product_info.is_imported;
			</cfscript>
		</cfif>
		<cfquery name="get_product_strategy" datasource="#dsn3#">
			SELECT 
				TOP 1
				MAXIMUM_STOCK,
				PROVISION_TIME,
				REPEAT_STOCK_VALUE,
				MINIMUM_STOCK,
				MINIMUM_ORDER_STOCK_VALUE,
				MINIMUM_ORDER_UNIT_ID,
				IS_LIVE_ORDER,
				STRATEGY_TYPE,
				STRATEGY_ORDER_TYPE,
				BLOCK_STOCK_VALUE,
				STOCK_ACTION_ID
			FROM
				STOCK_STRATEGY
			WHERE PRODUCT_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pid#">
		</cfquery>
		<cfif get_product_strategy.recordcount>
			<cfscript>
				MAXIMUM_STOCK = get_product_strategy.MAXIMUM_STOCK;
				PROVISION_TIME= get_product_strategy.PROVISION_TIME;
				REPEAT_STOCK_VALUE= get_product_strategy.REPEAT_STOCK_VALUE;
				MINIMUM_STOCK= get_product_strategy.MINIMUM_STOCK;
				MINIMUM_ORDER_STOCK_VALUE= get_product_strategy.MINIMUM_ORDER_STOCK_VALUE;
				MINIMUM_ORDER_UNIT_ID= get_product_strategy.MINIMUM_ORDER_UNIT_ID;
				IS_LIVE_ORDER= get_product_strategy.IS_LIVE_ORDER;
				STRATEGY_TYPE= get_product_strategy.STRATEGY_TYPE;
				STRATEGY_ORDER_TYPE= get_product_strategy.STRATEGY_ORDER_TYPE;
				block_stock_value=get_product_strategy.BLOCK_STOCK_VALUE;
				saleable_stock_action_id=get_product_strategy.STOCK_ACTION_ID;
			</cfscript>
		</cfif>
	</cfif>
<cfquery name="get_country" datasource="#dsn#">
	SELECT COUNTRY_ID,COUNTRY_NAME,COUNTRY_CODE FROM SETUP_COUNTRY ORDER BY COUNTRY_NAME
</cfquery>
	<cf_get_lang_set module_name="product"><!--- sayfanin en altinda kapanisi var --->
	<cfinclude template="../query/get_product_comp.cfm">
	<cfinclude template="../query/get_segments.cfm">
	<cfinclude template="../query/get_kdv.cfm">
	<cfinclude template="../query/get_otv.cfm">
	<cfinclude template="../query/get_oiv.cfm">
	<cfinclude template="../query/get_bsmv.cfm">
	<cfinclude template="../query/get_unit.cfm">
	<cfinclude template="../query/get_money.cfm">
	<cfset attributes.active_cat = 1>
	<cfinclude template="../query/get_code_cat.cfm">
	<cfquery name="GET_OUR_COMPANY_INFO" datasource="#DSN#">
		SELECT IS_BRAND_TO_CODE,IS_BARCOD_REQUIRED,IS_WATALOGY_INTEGRATED FROM OUR_COMPANY_INFO WHERE COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
	</cfquery>
	<cf_catalystHeader>
	<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
		<cf_box>
				<cfform name="form_add_product" method="post" onsubmit="return (unformat_fields());">
					<input type="hidden" name="barcode_require" id="barcode_require" value="<cfoutput>#get_our_company_info.is_barcod_required#</cfoutput>">
					<input type="hidden" name="is_barcode_control" id="is_barcode_control" value="<cfoutput>#is_barcode_control#</cfoutput>">
					<input type="hidden" name="use_same_product_name" id="use_same_product_name" value="<cfif isdefined('x_use_same_product_name')><cfoutput>#x_use_same_product_name#</cfoutput><cfelse>0</cfif>">
					<input type="hidden" name="property_row_count" id="property_row_count" value="" />
					<cf_box_elements>
						<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">	
							<div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12">
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57756.Durum'></label>
								<div class="col col-8 col-md-8 col-sm-8 col-xs-12"><input type="checkbox" name="product_status" id="product_status" value="1" <cfif product_status eq 1>checked</cfif>><cf_get_lang dictionary_id='57493.Aktif'>/<cf_get_lang dictionary_id='57494.Pasif'></div>
							</div>
							<div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12" id="item-is_inventory">	
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='37054.Envanter'></label>
								<div class="col col-8 col-md-8 col-sm-8 col-xs-12"><input type="checkbox" name="is_inventory" id="is_inventory" value="1" <cfif is_inventory eq 1> checked</cfif>><cf_get_lang dictionary_id='37055.envantere dahil'></div>				
							</div>
							<div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12" id="item-is_production">	
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57456.Üretim'></label>
								<div class="col col-8 col-md-8 col-sm-8 col-xs-12"><input type="checkbox" name="is_production" id="is_production" value="1" <cfif is_production eq 1> checked</cfif>><cf_get_lang dictionary_id='37057.üretiliyor'></div>				
							</div>
							<div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12" id="item-is_sales">	
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57448.Satış'></label>
								<div class="col col-8 col-md-8 col-sm-8 col-xs-12"><input type="checkbox" name="is_sales" id="is_sales" value="1" <cfif is_sales eq 1> checked</cfif>><cf_get_lang dictionary_id='37059.satışta'></div>				
							</div>
							<div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12" id="item-is_purchase">	
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='29745.Tedarik'></label>
								<div class="col col-8 col-md-8 col-sm-8 col-xs-12"><input type="checkbox" name="is_purchase" id="is_purchase" value="1" <cfif is_purchase eq 1> checked</cfif>><cf_get_lang dictionary_id='37061.tedarik ediliyor'></div>	
							</div>
							<div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12" id="item-is_prototype">	
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='37062.Prototip'></label>
								<div class="col col-8 col-md-8 col-sm-8 col-xs-12"><input type="checkbox" name="is_prototype" id="is_prototype" value="1" <cfif is_prototype eq 1> checked</cfif>><cf_get_lang dictionary_id='37562.yeni ürün'></div>	
							</div>
							<div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12" id="item-is_internet">	
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='37064.İnternet'></label>
								<div class="col col-8 col-md-8 col-sm-8 col-xs-12"><input type="checkbox" name="is_internet" id="is_internet" value="1"<cfif is_internet eq 1> checked</cfif>><cf_get_lang dictionary_id='37059.satışta'></div>		
							</div>
							<div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12" id="item-is_extranet">	
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58019.Extranet'></label>
								<div class="col col-8 col-md-8 col-sm-8 col-xs-12"><input type="checkbox" name="is_extranet" id="is_extranet" value="1"<cfif is_extranet eq 1> checked</cfif>><cf_get_lang dictionary_id='37059.satışta'></div>		
							</div>
							<div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12" id="item-is_karma">	
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='37467.Karma Koli'></label>
								<div class="col col-8 col-md-8 col-sm-8 col-xs-12"><input type="checkbox" name="is_karma" id="is_karma" value="1"<cfif is_karma eq 1> checked</cfif>><cf_get_lang dictionary_id='57495.Evet'></div>				
							</div>
							<div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12" id="item-is_zero_stock">	
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='37351.Sıfır Stok'></label>
								<div class="col col-8 col-md-8 col-sm-8 col-xs-12"><input type="checkbox" name="is_zero_stock" id="is_zero_stock" value="1"<cfif is_zero_stock eq 1> checked</cfif>><cf_get_lang dictionary_id='37352.İle Çalış'></div>	
							</div>
							<div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12" id="item-is_limited_stock">	
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='37922.Stoklarla Sınırlı'></label>
								<div class="col col-8 col-md-8 col-sm-8 col-xs-12"><input type="checkbox" name="is_limited_stock" id="is_limited_stock" value="1"<cfif is_limited_stock eq 1> checked</cfif>><cf_get_lang dictionary_id='57495.Evet'></div>				
							</div>
							<div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12" id="item-is_serial_no">	
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57637.Seri No'></label>
								<div class="col col-8 col-md-8 col-sm-8 col-xs-12"><input type="checkbox" name="is_serial_no" id="is_serial_no" value="1"<cfif is_serial_no eq 1> checked</cfif>><cf_get_lang dictionary_id='37349.Takibi Yapılıyor'></div>				
							</div>
							<div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12" id="item-is_lot_no">	
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='37155.Lot No'></label>
								<div class="col col-8 col-md-8 col-sm-8 col-xs-12"><input type="checkbox" name="is_lot_no" id="is_lot_no" value="1" <cfif is_lot_no eq 1>checked</cfif>><cf_get_lang dictionary_id='37349.Takibi Yapılıyor'></div>		
							</div>
							<div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12" id="item-is_cost">	
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58258.Maliyet'></label>
								<div class="col col-8 col-md-8 col-sm-8 col-xs-12"><input type="checkbox" name="is_cost" id="is_cost" value="1"<cfif is_cost eq 1> checked</cfif>><cf_get_lang dictionary_id='37175.Takip Ediliyor'></div>		
							</div>
							<div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12" id="item-is_imported">	
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='49210.İthal'></label>
								<div class="col col-8 col-md-8 col-sm-8 col-xs-12"><input type="checkbox" name="is_imported" id="is_imported" value="1" onclick="kontrol_day2();" <cfif is_imported eq 1>checked</cfif>><cf_get_lang dictionary_id='48110.İthal Ediliyor'></div>		
							</div>
							<div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12" id="item-is_quality">	
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id="37254.Kalite"></label>
								<div class="col col-8 col-md-8 col-sm-8 col-xs-12"><input type="checkbox" name="is_quality" id="is_quality" value="1" <cfif is_quality eq 1>checked</cfif>><cf_get_lang dictionary_id='37175.Takip Ediliyor'></div>		
							</div>
							<div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12" id="item-is_commission">	
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='37957.Pos Komisyonu Hesapla'></label>
								<div class="col col-8 col-md-8 col-sm-8 col-xs-12"><input type="checkbox" name="is_commission" id="is_commission"  value="1" <cfif is_commission eq 1> checked <cfelse> value="0"</cfif>><cf_get_lang dictionary_id='58998.Hesapla'></div>				
							</div>
							<div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12" id="item-is_terazi">	
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='37066.Terazi'></label>
								<div class="col col-8 col-md-8 col-sm-8 col-xs-12"><input type="checkbox" name="is_terazi" id="is_terazi" value="1" <cfif is_terazi eq 1> checked</cfif>><cf_get_lang dictionary_id='37154.Tartılıyor'></div>			
							</div>
							<cfif GET_OUR_COMPANY_INFO.recordCount and GET_OUR_COMPANY_INFO.IS_WATALOGY_INTEGRATED eq 1>
								<div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12" id="item-is_watalogy_integrated">	
									<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='30366.Watalogy'></label>
									<div class="col col-8 col-md-8 col-sm-8 col-xs-12"><input type="checkbox" name="is_watalogy_integrated" id="is_watalogy_integrated" value="1" <cfif GET_OUR_COMPANY_INFO.recordCount and GET_OUR_COMPANY_INFO.IS_WATALOGY_INTEGRATED eq 1> checked</cfif>><cf_get_lang dictionary_id='42485.Entegre'></div>			
								</div>
							</cfif>
							<div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12" id="item-is_gift_card">	
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='38024.Hediye Kartı'></label>
								<div class="col col-8 col-md-8 col-sm-8 col-xs-12"><input type="checkbox" name="is_gift_card" id="is_gift_card" value="1" <cfif is_gift_card eq 1>checked</cfif>></div>		
							</div>
						
						</div>
						<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">	
							<div class="form-group" id="item-gift_valid_day" style="display:none">	
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id="37296.Geçerlilik Günü"></label>
								<label class="col col-8 col-md-8 col-sm-8 col-xs-12"><input type="input" name="gift_valid_day" id="gift_valid_day" value="<cfoutput>#gift_valid_day#</cfoutput>" onkeyup="isNumber(this);" maxlength="4" class="moneybox"></label>				
							</div>
							<div class="form-group" id="item-product_name">
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58221.Ürün Adı'>*</label>
								<div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
									<cfsavecontent variable="message"><cf_get_lang dictionary_id='37331.Ürün Girmelisiniz'></cfsavecontent>
									<cfinput type="text" name="product_name" id="product_name" value="#product_name#" required="Yes" message="#message#" maxlength="500">
								</div>
							</div>
							<div class="form-group" id="item-product_cat">
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57486.Kategori'>*</label>
								<div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
									<div class="input-group">
										<cfinput type="hidden" name="product_catid" value="#product_cat_id#">
										<cfsavecontent variable="message"><cf_get_lang dictionary_id='53158.Kategori Girmelisiniz'></cfsavecontent>
										<cfsavecontent variable="value"><cfif len(hierarchy)><cfoutput>#hierarchy#</cfoutput></cfif><cfif len(product_cat)><cfoutput> #product_cat#</cfoutput></cfif></cfsavecontent>
										<cfif is_show_detail_variation eq 1>
											<cfinput type="text" name="product_cat" id="product_cat" required="yes" message="#message#" value="#value#" onFocus="AutoComplete_Create('product_cat','PRODUCT_CAT,HIERARCHY','PRODUCT_CAT_NAME','get_product_cat','1','PRODUCT_CATID','product_catid','','3','455',true,'add_property()');">
										<cfelse>                                
											<cfinput type="text" name="product_cat" id="product_cat" required="yes" message="#message#" value="#value#" onFocus="AutoComplete_Create('product_cat','PRODUCT_CAT,HIERARCHY','PRODUCT_CAT_NAME','get_product_cat','1','PRODUCT_CATID','product_catid','','3','455');">
										</cfif>
										<span class="input-group-addon icon-ellipsis btnPoniter" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_cat_names&field_id=product_catid&field_name=form_add_product.product_cat&field_min=form_add_product.MIN_MARGIN&field_max=form_add_product.MAX_MARGIN<cfif is_show_detail_variation eq 1>&caller_function=add_property</cfif>');" title="<cf_get_lang dictionary_id='37157.Ürün Kategorisi Ekle'>!"></span>
									</div>
								</div>
							</div>			
							<div class="form-group" id="item-brand_name">
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58847.Marka'></label>
								<div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
									<cfinput type="hidden" name="brand_code" id="brand_code" value="#brand_code#">
									<cf_wrkProductBrand
									returnInputValue="brand_id,brand_name,brand_code"
									returnQueryValue="BRAND_ID,BRAND_NAME,BRAND_CODE"
									width="120"
									compenent_name="getProductBrand"               
									boxwidth="300"
									boxheight="150"
									is_internet="1"
									brand_code="1"
									brand_ID="#brand_id#">
								</div>
							</div>					
							<div class="form-group" id="item-short_code_name">
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58225.Model'><cfif get_our_company_info.is_brand_to_code> </cfif></label>
								<div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
									<cfif is_related_model_brand eq 1>
										<cfset deger = "brand_id">
									<cfelse>
										<cfset deger = "">
									</cfif>
									<cf_wrkProductModel
										returnInputValue="short_code_id,short_code_name,short_code"
										returnQueryValue="MODEL_ID,MODEL_NAME,MODEL_CODE"
										width="120"
										fieldName="short_code_name"
										fieldid="short_code_id"
										fieldcode="short_code"
										control_field_id="#deger#"
										control_field_name="brand_name"
										compenent_name="getProductModel"               
										boxwidth="300"
										boxheight="150"  
										model_ID="#short_code_id#">
								</div>
							</div>
							<cfif GET_OUR_COMPANY_INFO.recordCount and GET_OUR_COMPANY_INFO.IS_WATALOGY_INTEGRATED eq 1>
								<div class="form-group" id="item-watalogy_product_cat">
									<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='61453.Watalogy Kategorisi'></label>
									<div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
										<div class="input-group">
											<cfinput type="hidden" name="watalogy_cat_id" value="">
											<cfinput type="text" name="watalogy_cat_name" id="watalogy_cat_name" value="">
											<span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_watalogy_category_names&field_id=form_add_product.watalogy_cat_id&field_name=form_add_product.watalogy_cat_name');" title="<cf_get_lang dictionary_id='61454.Watalogy Kategorisi Ekle'>!"></span>
										</div>
									</div>
								</div>
							</cfif>
							<div class="form-group" id="item-product_code">
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58800.Ürün Kodu'>*</label>
								<div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
									<cfset product_no = get_product_no(action_type:'product_no')>
									<cfsavecontent variable="message"><cf_get_lang dictionary_id='37332.Ürün Kodu girmelisiniz'></cfsavecontent>
									<cfinput type="text" id="product_code" name="product_code" value="#product_no#" required="yes" message="#message#" readonly="yes">
								</div>
							</div>					
							<div class="form-group" id="item-MANUFACT_CODE">
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='37379.Üretici ürün Kodu'></label>
								<div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
									<cfinput type="text" name="MANUFACT_CODE" id="MANUFACT_CODE" maxlength="100" value="#MANUFACT_CODE#">
								</div>
							</div>					
							<div class="form-group" id="item-position_code">
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='62513.Menşei'></label>
								<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
									<select name="origin" id="origin">
										<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
										<cfloop query="get_country">
											<option value="<cfoutput>#country_id#</cfoutput>"><cfoutput>#country_name#</cfoutput></option>
										</cfloop>
									</select>
								</div>
							</div>	
							<div class="form-group" id="item-customs_recipe_code">
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='62502.GTIP/CPA Kodu'></label>
								<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
									<div class="input-group">
										<cfinput type="hidden" name="customs_recipe_code" id="customs_recipe_code" value="#customs_recipe_code#" maxlength="50">
										<input type="text" name="customs_recipe_code_name" id="customs_recipe_code_name" value="">
										<span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_gtip_hs_codes');"></span>
									</div>
								</div>
							</div>					
							<div class="form-group" id="item-comp">
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='29533.Tedarikçi'></label>
								<div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
									<div class="input-group">
										<cfinput type="hidden" name="company_id" id="company_id" value="#company_id#">
										<input name="comp" type="text"  id="comp" onfocus="AutoComplete_Create('comp','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1\',\'<cfif fusebox.circuit is 'store'>1<cfelse>0</cfif>\',\'0\',\'\',\'2\',\'1\'','COMPANY_ID','company_id','','3','140');" value="<cfoutput>#company#</cfoutput>" autocomplete="off">
										<span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&field_comp_id=form_add_product.company_id&field_comp_name=form_add_product.comp<cfif fusebox.circuit is "store">&is_store_module=1</cfif>&select_list=2</cfoutput>&keyword='+encodeURIComponent(form_add_product.comp.value));"></span>
									</div>
								</div>
							</div>					
							<div class="form-group" id="item-product_manager_name">
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57544.Sorumlu'></label>
								<div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
									<div class="input-group">
										<cfinput type="hidden" name="product_manager" id="product_manager" value="#product_manager#">
										<input name="product_manager_name" type="text" id="product_manager_name" onfocus="AutoComplete_Create('product_manager_name','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2,3\'','POSITION_CODE','product_manager','','3','120');" value="<cfoutput>#product_manager_name#</cfoutput>" autocomplete="off">
										<apan class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_code=form_add_product.product_manager&field_name=form_add_product.product_manager_name<cfif fusebox.circuit is "store">&branch_related</cfif></cfoutput>&select_list=1,7,8&keyword='+encodeURIComponent(form_add_product.product_manager_name.value));"></span>
									</div>
								</div>
							</div>					
							<div class="form-group" id="item-process_stage">
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id="58859.Süreç"></label>
								<div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
									<cf_workcube_process is_upd='0' process_cat_width='120' is_detail='0'>
								</div>
							</div>					
							<div class="form-group" id="item-segment_id">
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='37035.Hedef Pazar'></label>
								<div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
									<select name="segment_id" id="segment_id">
										<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
										<cfoutput query="get_segments">
											<option value="#product_segment_id#" <cfif segment_id eq product_segment_id>selected</cfif>>#product_segment#</option>
										</cfoutput>
									</select>
								</div>
							</div>					
							<div class="form-group" id="item-prod_comp">
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='37372.fiyat yetkisi'></label>
								<div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
									<select name="prod_comp" id="prod_comp">
										<cfoutput query="get_product_comp">
											<option  value="#competitive_id#"<cfif prod_comp eq competitive_id>selected</cfif>>#competitive#</option>
										</cfoutput>
									</select>
								</div>
							</div>
							<div class="form-group" id="item-shelf_life">
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='37023.Raf Ömrü'></label>
								<div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
									<cfsavecontent variable="message">Raf Ömrünü Kontrol Ediniz!</cfsavecontent>
									<cfinput type="text" name="shelf_life" id="shelf_life" value="#shelf_life#" validate="integer" message="#message#" maxlength="50" onKeyUp="isNumber(this)">
								</div>
							</div>			
						</div>
						<div class="col col-5 col-md-6 col-sm-6 col-xs-12" type="column" index="3" sort="true">	
							<div class="form-group" id="item-acc_code_cat">
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='37257.Muh Kod Grubu'></label>
								<div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
								<select name="acc_code_cat" id="acc_code_cat">
									<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
									<cfoutput query="get_code_cat">
										<option value="#pro_code_catid#" <cfif isdefined("product_period_cat_id") and product_period_cat_id eq pro_code_catid>selected</cfif>>#pro_code_cat_name#</option>
									</cfoutput>
								</select>
								</div>
							</div>
							<div class="form-group" id="item-user_friendly_url">
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id ='38023.Kullanıcı Dostu Url'></label>
								<div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
									<input type="text" name="user_friendly_url" id="user_friendly_url" value="" maxlength="250">
								</div>
							</div>	
							<cfquery name="GET_WORK_STOCK" datasource="#DSN#">
								SELECT 
									OUR_COMPANY_INFO.WORK_STOCK_ID,
									STOCKS.PRODUCT_NAME,
									STOCKS.PROPERTY
								FROM
									OUR_COMPANY_INFO,
									#dsn3_alias#.STOCKS STOCKS
								WHERE
									OUR_COMPANY_INFO.COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
									STOCKS.STOCK_ID = OUR_COMPANY_INFO.WORK_STOCK_ID AND
									OUR_COMPANY_INFO.WORK_STOCK_ID IS NOT NULL
							</cfquery>
							<cfif get_work_stock.recordcount>                        
								<div class="form-group <cfif get_work_stock.recordcount eq 0>hide</cfif>" id="item-work_product_name">
									<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='37543.İşçilik Ürünü'></label>
									<div class="col col-6 col-xs-12"> 
										<div class="input-group">
											<!--- <cf_wrk_products form_name = 'form_add_product' product_name='work_product_name' stock_id='work_stock_id'> --->
											<input type="hidden" name="work_stock_id" id="work_stock_id" value="<cfoutput>#get_work_stock.work_stock_id#</cfoutput>">
											<input type="text" name="work_product_name" id="work_product_name" value="<cfoutput>#get_work_stock.product_name# #get_work_stock.property#</cfoutput>" onFocus="AutoComplete_Create('work_product_name','PRODUCT_NAME','PRODUCT_NAME','get_product','0','PRODUCT_ID,STOCK_ID','work_product_name,work_stock_id','','2','200');" autocomplete="off">
											<span class="input-group-addon icon-ellipsis btnPointer" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&field_id=form_add_product.work_stock_id&field_name=form_add_product.work_product_name');" title="<cf_get_lang dictionary_id='30416.Ürün Seç'>" alt="<cf_get_lang dictionary_id='30416.Ürün Seç'>"></span>
										</div>
									</div>
									<div class="col col-3 col-xs-12"> 
										<cfinput type="text" name="work_stock_amount" id="work_stock_amount" value="#TLFormat(1,2)#" class="moneybox" onkeyup="return(formatcurrency(this,event,3));" validate="float" range="0," message="#getLang('','Miktar Girin',37413)#">
									</div>
								</div>
							</cfif>
							<div class="form-group" id="item-product_code_2">
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57789.Özel Kod'></label>
								<div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
									<cfinput type="text" name="product_code_2" id="product_code_2" value="#product_code_2#" maxlength="50">
								</div>
							</div>
							<div class="form-group" id="item-barcod">
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57633.Barkod'> <cfif get_our_company_info.is_barcod_required eq 1> *</cfif></label>
								<div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
									<div class="input-group">
										<cfinput type="text" name="barcod" id="barcod" value="#barcod#" onKeyUp="barcod_control()">
										<cfif is_auto_barcode eq 0>
										<span class="input-group-addon btnPointer" onclick="javascript:document.form_add_product.barcod.value='<cfoutput>#get_barcode_no()#</cfoutput>'" title="<cf_get_lang dictionary_id='37940.Otomatik barkod'> !"><i class="fa fa-plus"></i></span>
										<cfelse>
										<span class="input-group-addon btnPointer" onclick="javascript:document.form_add_product.barcod.value='<cfoutput>#get_barcode_no(1)#</cfoutput>'" title="<cf_get_lang dictionary_id='37940.Otomatik barkod'> !"><i class="fa fa-plus"></i></span>
										</cfif>
									</div>
								</div>
							</div>					
							<div class="form-group" id="item-PRODUCT_DETAIL">
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
								<div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
									<textarea name="PRODUCT_DETAIL" id="PRODUCT_DETAIL"><cfoutput>#product_detail#</cfoutput></textarea>
								</div>
							</div>	
							<div class="form-group" id="item-product_detail2">
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'> 2</label>
								<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
									<cfinput type="text" name="product_detail2" value="#product_detail2#" maxlength="500" >
								</div>
							</div>				
							<div class="form-group" id="item-MIN_MARGIN">
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='37045.Marj'>%</label>
								<div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
									<div class="input-group">
										<span class="input-group-addon"><cf_get_lang dictionary_id='58908.min'></span>
										<input type="text" name="MIN_MARGIN" id="MIN_MARGIN" value="<cfoutput>#TlFormat(min_margin)#</cfoutput>" class="moneybox" onkeyup="return(FormatCurrency(this,event,4));">
										<span class="input-group-addon"><cf_get_lang dictionary_id='58909.max'></span>
										<input type="text" name="MAX_MARGIN" id="MAX_MARGIN" value="<cfoutput>#TLFormat(max_margin)#</cfoutput>" class="moneybox" onkeyup="return(FormatCurrency(this,event,4));">
									</div>
								</div>
							</div>
							<div class="form-group" id="item-tax_purchase">
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='37631.Alis KDV'>*</label>
								<div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
									<select name="tax_purchase" id="tax_purchase">
										<cfoutput query="get_kdv">
											<option value="#tax#"<cfif tax_purchase eq tax>selected</cfif>>#tax#</option>
										</cfoutput>
									</select>
								</div>
							</div>
							<div class="form-group" id="item-tax">
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='37916.Satış KDV'>*</label>
								<div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
									<select name="tax" id="tax">
										<cfoutput query="get_kdv">
											<option value="#tax#"<cfif tax_s eq tax>selected</cfif>>#tax#</option>
										</cfoutput>
									</select>
								</div>
							</div>					
							<div class="form-group" id="item-purchase">
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cfif fusebox.circuit is "store"><cf_get_lang dictionary_id='37541.Sube Alış'><cfelse><cf_get_lang dictionary_id='58722.Standart Alış'></cfif></label>
								<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
									<cfinput type="text" name="purchase" id="purchase" maxlength="50" class="moneybox" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.purchase_price_round_num#));">
								</div>
								<div class="col col-2 col-md-2 col-sm-2 col-xs-12">	
									<select name="MONEY_ID_SA" id="MONEY_ID_SA" >
									<cfoutput>
										<cfloop from="1" to="#get_money.recordcount#" index="k">
											<option value="#get_money.money[k]#" <cfif get_money.money[k] eq session.ep.money>selected</cfif>>#get_money.money[k]#</option>
										</cfloop>
									</cfoutput>
									</select>
								</div>
								<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
									<select name="is_tax_included_purchase" id="is_tax_included_purchase">
										<option value="1"><cf_get_lang dictionary_id='49998.KDV Dahil'></option>
										<option value="0" selected><cf_get_lang dictionary_id='48656.KDV Hariç'></option>
									</select>
								</div>
							</div>											
							<div class="form-group" id="item-price">
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cfif fusebox.circuit is "store"><cf_get_lang dictionary_id='37542.Sube Satış'><cfelse><cf_get_lang dictionary_id='58721.Standart Satış'></cfif></label>
								<div class="col col-3 col-md-3 col-sm-3 col-xs-12"> 
									<cfinput type="text" name="price" id="price" class="moneybox" maxlength="50" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.sales_price_round_num#));">
								</div>
								<div class="col col-2 col-md-2 col-sm-2 col-xs-12">
									<select name="MONEY_ID_SS" id="item-MONEY_ID_SS">
										<cfoutput>
											<cfloop from="1" to="#get_money.recordcount#" index="k">
												<option value="#get_money.money[k]#" <cfif get_money.money[k] eq session.ep.money>selected</cfif>>#get_money.money[k]#</option>
											</cfloop>
										</cfoutput>
									</select>
								</div>
								<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
									<select name="is_tax_included_sales" id="is_tax_included_sales">
										<option value="1"><cf_get_lang dictionary_id='49998.KDV Dahil'></option>
										<option value="0" <cfif session.ep.our_company_info.workcube_sector neq 'per'>selected</cfif>><cf_get_lang dictionary_id='48656.KDV Hariç'></option>
									</select>
								</div>
							</div>
							<cfif is_show_otv eq 1>  <!--- XML Sayfasında OTV Gözüksün mü (1'se Evet) form_add_product.xml --->
								<div class="form-group" id="item-type-otv">
									<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='62555.ÖTV Tipi'></label>
									<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
										<select name="otv_type" id="otv_type" onchange="show2()">
											<option value="" ><cf_get_lang dictionary_id='57734.Seçiniz'></option>
											<option value="1"><cf_get_lang dictionary_id='62479.Sabit Tutar'></option>
											<option value="2"><cf_get_lang dictionary_id='62480.Oransal'></option>
										</select>
									</div>
								</div>
								<div class="form-group" id="item-OTV-1" style="display:none">
									<div class="col col-4 col-md-4 col-sm-4 col-xs-12"><label><cf_get_lang dictionary_id='58021.ÖtV'></label></div>
									<div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
										<cfoutput>
										<input type="text" name="OTV" id="OTV" class="moneybox" value="" onkeyup="return(FormatCurrency(this,event,4));">
										</cfoutput>
									</div>
								</div>
								<div class="form-group" id="item-OTV-2" style="display:none">
									<div class="col col-4 col-md-4 col-sm-4 col-xs-12"><label><cf_get_lang dictionary_id='58021.ÖTV'><cf_get_lang dictionary_id='58671.Oranı'></label></div>
									<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
										<div class="input-group">
											<select name="OTV" id="OTV_2">
												<option value=""><cf_get_lang dictionary_id='58546.Yok'></option>
												<cfoutput query="get_otv">
													<option value="#tax#"<cfif otv eq tax>selected</cfif>>#tax#</option>
												</cfoutput>
											</select>
											<span class="input-group-addon"> % </span>
										</div>
									</div>
								</div>
							</cfif>
							<cfif is_show_oiv eq 1> <!--- XML Sayfasında OIV Gözüksün mü (1'se Evet) form_add_product.xml --->
								<div class="form-group" id="item-OIV">
									<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='50982.ÖİV'></label>
									<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
										<select name="OIV" id="OIV">
											<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
											<cfoutput query="get_oiv">
												<option value="#tax#"<cfif oiv eq tax>selected</cfif>>#tax#</option>
											</cfoutput>
										</select>
									</div>
								</div>
							</cfif>
							<cfif is_show_bsmv eq 1> <!--- XML Sayfasında BSMV Gözüksün mü (1'se Evet) form_add_product.xml --->
								<div class="form-group" id="item-BSMV">
									<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='50923.BSMV'></label>
									<div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
										<select name="BSMV" id="BSMV">
											<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
											<cfoutput query="get_bsmv">
												<option value="#tax#"<cfif bsmv eq tax>selected</cfif>>#tax#</option>
											</cfoutput>
										</select>
									</div>
								</div>
							</cfif>
							<div class="form-group" id="item-unit_id">
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57636.Birim'>*</label>
								<div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
									<select name="unit_id" id="unit_id">
									<cfoutput query="get_unit">
										<option value="#unit_id#,#unit#"<cfif main_unit_id eq unit_id>selected</cfif>>#unit#</option>
									</cfoutput>
									</select>
								</div>
							</div>					
							<div class="form-group" id="item-weight">
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='29784.Ağırlık'></label>
								<div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
									<div class="input-group">
										<cfinput type="text" maxlength="50" name="weight" id="weight" value="#TLFormat(weight,8)#" onkeyup="FormatCurrency(this,event,8)">
										<span class="input-group-addon bold"><cf_get_lang dictionary_id='37188.kg'></span>
									</div>
								</div>
							</div>					
							<div class="form-group" id="item-dimention">
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57713.Boyut'>(<cf_get_lang dictionary_id='29703.cm'>)</label>
								<div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
									<div class="input-group">								
										<cfinput type="text" name="dimention" id="dimention"  maxlength="50" value="#dimention#" onblur="return volume_calculate();">
										<span class="input-group-addon bold">a*b*h</span>
									</div>
								</div>
							</div>					
							<div class="form-group" id="item-volume">
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='30114.Hacim'></label>
								<div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
									<div class="input-group">
										<cfif isdefined("get_product_info.volume")>
											<cfinput type="text" name="volume" maxlength="50" value="#get_product_info.volume#">
											<span class="input-group-addon bold"><cf_get_lang dictionary_id='37318.cm3'></span>
										<cfelse>
											<cfinput type="text" name="volume" maxlength="50" value="">
											<span class="input-group-addon bold"><cf_get_lang dictionary_id='37318.cm3'></span>
										</cfif>
									</div>
								</div>
							</div>						
						</div>
					</cf_box_elements>	
					<cf_box_footer>
						<cf_workcube_buttons is_upd='0' add_function='kontrol()' data_action ="V16/product/cfc/get_product:add_product" next_page="#request.self#?fuseaction=product.list_product&event=det&pid=">
					</cf_box_footer>
				</cfform>
		</cf_box>
	</div>
	<script type="text/javascript">
		$('#product_name').focus();
	//document.getElementById('product_name').focus();
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
	function kontrol()
	{
		<cfif is_mpc_code eq 1 and is_show_detail_variation eq 1>
			var mpc_code="";
			
			for (var r=1;r<=$('#property_row_count').val();r++)
			{
				if(document.getElementById('chk_product_property_'+r).checked)
				{
					var mpc_code_temp = list_getat(document.getElementById('property_detail_'+r).value,2,';');
					
					if(mpc_code_temp == "")
					{ 
						alert (r + ". <cf_get_lang dictionary_id='37240.Özellik İçin Varyasyon Kodu Tanımlamalısınız'> ! ");
						return false;
					}				
					if(mpc_code!='')
						mpc_code = mpc_code  + '.' + mpc_code_temp;
					else
						mpc_code = mpc_code_temp;
				}
			}
			if(mpc_code.lenght!=0)
			
			$('#product_code_2').val()=mpc_code;
		</cfif>	
	
		if ($('input#is_watalogy_integrated').is(':checked') && ($('input#watalogy_cat_id').val().length<1 || $('input#watalogy_cat_name').val().length<1)){ 
			alert("<cf_get_lang dictionary_id='63587.Required Field'>: <cf_get_lang dictionary_id='61453.Watalogy Category'>");
			return false;
		}
		
		<cfif is_special_code_for_one eq 1>
			if ($('#product_code_2').val().length > 0)
			{
				var check_code = wrk_safe_query("prd_check_code", "dsn3", 0, $('#product_code_2').val());
				if(check_code.recordcount > 0)
				{
					alert("<cf_get_lang dictionary_id='37921.Bu özel kod daha önce kullanılmıştır !'>");
					return false;
				}
			}
		</cfif>
		
		if(form_add_product.is_terazi.checked && trim(form_add_product.barcod.value).length!=7)
		{
			alert("<cf_get_lang dictionary_id ='33893.Teraziye Giden Ürünler İçin Barkod 7 Karakter Olmalıdır'>!");
			return false;
		}
		if(form_add_product.is_inventory.checked && form_add_product.barcode_require.value == 1 && trim(form_add_product.barcod.value).length<7)
		{
			alert("<cf_get_lang dictionary_id ='37682.Envantere Dahil Ürünler İçin En Az 7 Karakter Barkod Girmelisiniz'>!");
			return false;
		}
		else if(form_add_product.barcode_require.value == 0 && form_add_product.barcod.value != '' && form_add_product.is_barcode_control == 0)
		{
			var get_barcod_info = wrk_safe_query('prod_control_barcode','dsn1',0,form_add_product.barcod.value);
			if(get_barcod_info.recordcount)
			{
				alert("<cf_get_lang dictionary_id ='37894.Girdiğiniz Barkod Başka Bir Ürün Tarafından Kullanılmakta'> !");
				return false;
			}	
		}
		
		if($('#product_catid').val() =="")
		{
			alert("<cf_get_lang dictionary_id='58947.Kategori Secmelisiniz'>");
			return false;
		}
		x = (500 - form_add_product.PRODUCT_DETAIL.value.length);
		if ( x < 0 )
		{
			alert ("<cf_get_lang dictionary_id='37700.Ürün Açıklaması'> "+ ((-1) * x) +"<cf_get_lang dictionary_id='29538.Karakter Uzun'>!");
			return false;
		}
		if (form_add_product.tax.value == '')
		{
			alert("<cf_get_lang dictionary_id ='58558.KDV Seçmediniz'>");
			return false;		
		}	
		if (form_add_product.unit_id.value == '')
		{
			alert("<cf_get_lang dictionary_id ='58559.Ürün Birimini Seçmediniz'>..");
			return false;
		}
		if(form_add_product.is_gift_card.checked && form_add_product.gift_valid_day.value==''){
			alert("<cf_get_lang dictionary_id='38025.Hediye Kartı İçin Geçerlilik Tarihi Girmelisiniz'>!");
			return false;
		}
		if(form_add_product.MIN_MARGIN.value == '')
			form_add_product.MIN_MARGIN.value = 0;
		if(form_add_product.MAX_MARGIN.value == '')
			form_add_product.MAX_MARGIN.value = 0;
	
		temp_profit_margin_min = parseFloat(filterNum(form_add_product.MIN_MARGIN.value));
		temp_profit_margin_max = parseFloat(filterNum(form_add_product.MAX_MARGIN.value));
		if(temp_profit_margin_min!="" && temp_profit_margin_max!="" && (temp_profit_margin_min>temp_profit_margin_max))
		{
			alert("<cf_get_lang dictionary_id='37702.Marj Degerlerini Kontrol Ediniz'>!");
			return false;
		}
		<cfif GET_WORK_STOCK.RECORDCOUNT>
		if(form_add_product.work_product_name.value!="" && form_add_product.work_stock_id.value!="" && (form_add_product.work_stock_amount.value==""))
		{
			alert("<cf_get_lang dictionary_id='37703.İşçilik Ürünü Miktarını Giriniz'>!");
			return false;
		}
		form_add_product.work_stock_amount.value = filterNum(form_add_product.work_stock_amount.value);
		</cfif>
		
		var urun_adi_ = document.form_add_product.product_name.value;
		var urun_adi_ = ReplaceAll(urun_adi_,"'"," ");
		
		var get_prod_info = wrk_safe_query('prd_get_prod_info','dsn1',0,urun_adi_);
		if(get_prod_info.recordcount)
		{
			<cfif isdefined('x_use_same_product_name') and x_use_same_product_name eq 1>
				alert("<cf_get_lang dictionary_id ='37925.Aynı İsimli Bir Ürün Daha Var'>!");
			<cfelse>
				alert("<cf_get_lang dictionary_id ='37704.Aynı İsimli Bir Ürün Daha Var Lütfen Başka Bir Ürün İsmi Giriniz'>!");
				form_add_product.product_name.focus();
				return false;
			</cfif>
		}
		return process_cat_control();
	}
	function kontrol_day()
	{
		if(document.form_add_product.is_gift_card.checked == true)
			gift_day.style.display = '';
		else
			gift_day.style.display = 'none';
	}
	
	function kontrol_day2()
	{
		if(document.form_add_product.is_gift_card.checked == true)
			$("#gift_valid_day").css('display','');
		else
			$("#gift_valid_day").css('display','none');
	}
	
	function unformat_fields()
	{
		allFilterNum('purchase','price','weight','MIN_MARGIN','MAX_MARGIN','maximum_stock','repeat_stock_value','minimum_stock','minimum_order_stock_value','provision_time','block_stock_value');
		var pname_ = form_add_product.product_name.value;
		<cfif isdefined('x_use_same_product_name') and x_use_same_product_name eq 1>//Aynı isimde ürün girilmesine izin verilirse benzer kayıtları göstersin
			windowopen('<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#</cfoutput>.popup_dsp_product_prerecords&product_name=' + encodeURIComponent(pname_.replace("'","")) + '&manufact_code=' + form_add_product.MANUFACT_CODE.value,'project');
		</cfif>
		//form_add_product.MIN_MARGIN.value = filterNum(form_add_product.MIN_MARGIN.value);
		//form_add_product.MAX_MARGIN.value = filterNum(form_add_product.MAX_MARGIN.value);	
		return false;
	}
	<cfif is_show_detail_variation eq 1>
		function add_property()
		{
			var sql = "SELECT PP.PROPERTY,PP.PROPERTY_ID FROM PRODUCT_CAT_PROPERTY PCP,PRODUCT_PROPERTY PP WHERE PP.PROPERTY_ID = PCP.PROPERTY_ID AND PCP.PRODUCT_CAT_ID = "+$('#product_catid').val() + " ORDER BY PCP.LINE_VALUE ASC";
			var property = wrk_query(sql,'dsn1');
			var row_count=0;  
			for(kk=1;kk<=$('#property_row_count').val();kk++)
			{
				hide('product_property_row'+kk);
			}
			
			for(i=1;i<=$('#property_row_count').val();i++)
			{
				document.getElementById('chk_product_property_'+i).checked = false;
				document.getElementById("product_property").deleteRow(1);
			}
			
			for(i=0;i<property.recordcount;++i)
			{
				row_count++;
				$('#property_row_count').val() = row_count;
				var newRow;
				var newCell;
				newRow = document.getElementById("product_property").insertRow(document.getElementById("product_property").rows.length);
				newRow.setAttribute("name","product_property_row" + row_count);
				newRow.setAttribute("id","product_property_row" + row_count);
				var sql_2 = "SELECT PROPERTY_DETAIL_ID,PROPERTY_DETAIL,PROPERTY_DETAIL_CODE FROM PRODUCT_PROPERTY_DETAIL PPD,PRODUCT_PROPERTY PP WHERE PPD.PRPT_ID = PP.PROPERTY_ID AND PP.PROPERTY_ID = "+property.PROPERTY_ID[i];
				var property_detail = wrk_query(sql_2,'dsn1');
		
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.setAttribute("width","60px;");
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.setAttribute("width","10px;");
				newCell.innerHTML = '<input type="checkbox" name="chk_product_property_'+row_count+'" id="chk_product_property_'+row_count+'" value="'+property.PROPERTY_ID[i]+'" checked>';
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.setAttribute("width","50px;");
				newCell.innerHTML = '<input type="hidden" name="product_property_id'+row_count+'" id="product_property_id'+row_count+'" value="'+property.PROPERTY_ID[i]+'"><input type="text" name="product_property_value'+row_count+'" id="product_property_value'+row_count+'" value="'+property.PROPERTY[i]+'" style="width:210px;">';
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.setAttribute("width","200px;");
				newCell.innerHTML = '<select name="property_detail_'+row_count+'" id="property_detail_'+row_count+'" style="width:210px;"><option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option></select>';
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.setAttribute("colspan","2");
				for(var k=0;k < property_detail.recordcount;k++)
					document.getElementById('property_detail_'+row_count).options[k+1]=new Option(property_detail.PROPERTY_DETAIL[k],property_detail.PROPERTY_DETAIL_ID[k]+';'+property_detail.PROPERTY_DETAIL_CODE[k]);
			}
		}
	</cfif>
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
		
		function volume_calculate()
		{
			var dimention_ = ReplaceAll(document.getElementById('dimention').value,"x","*");
			var a = list_getat(dimention_,1,'*');
			a = a.replace(',','.');
			var b = list_getat(dimention_,2,'*');
			b = b.replace(',','.');
			var c = list_getat(dimention_,3,'*');
			c = c.replace(',','.');
			var volume = a*b*c ;
			eval('form_add_product.volume').value = volume;
		}
		
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->