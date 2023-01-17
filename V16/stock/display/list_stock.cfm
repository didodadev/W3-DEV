<cf_xml_page_edit  default_value="1" fuseact="stock.list_stock">
<cf_get_lang_set module_name="stock">
<cfsetting showdebugoutput="no">
<cfparam name="is_show_detail_search" default="1">
<cfparam name="is_show_strateji_detail" default="0">
<cfparam name="is_strategy_real_stock" default="0">
<cfparam name="is_show_strateji_action_types" default="0">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.barcod" default="">
<cfparam name="attributes.employee" default="">
<cfparam name="attributes.employee_id" default="">
<cfparam name="attributes.stock_code" default="">
<cfparam name="attributes.ozel_kod" default="">
<cfparam name="attributes.company" default="">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.product_cat" default="">
<cfparam name="attributes.shelf_number" default="">
<cfparam name="attributes.shelf_number_txt" default="">
<cfparam name="attributes.search_product_catid" default="">
<cfparam name="attributes.is_stock_active" default="1">
<cfparam name="attributes.amount_flag" default="">
<cfparam name="attributes.list_property_id" default="">
<cfparam name="attributes.list_variation_id" default="">
<cfparam name="attributes.spect_main_id" default="">
<cfif isdefined("x_show_lot_default") and x_show_lot_default eq 1>
	<cfparam name="attributes.list_type" default="5">
<cfelse>
	<cfparam name="attributes.list_type" default="1">
</cfif>
<cfparam name="attributes.sort_type" default="0">
<cfparam name="attributes.strategy_type" default="">
<cfparam name="attributes.department_id" default="">
<cfparam name="attributes.location_id" default="">
<cfparam name="attributes.location_name" default="">
<cfparam name="attributes.product_brand_name" default="">
<cfparam name="attributes.product_model_name" default="">
<cfparam name="attributes.manufacturer_code" default="">
<cfparam name="attributes.lotno_filter" default="">
<cfinclude template="../query/get_stores.cfm">
<cfquery name="GET_ALL_LOCATION" datasource="#DSN#">
	SELECT * FROM STOCKS_LOCATION ORDER BY COMMENT
</cfquery>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfif isdefined("attributes.is_form_submitted")>
	<cfscript>
		get_stock_list_action = createObject("component", "V16.stock.cfc.get_stock_list");
		get_stock_list_action.dsn3 = dsn3;
		get_stock_list_action.dsn_alias = dsn_alias;
		get_stock_list_action.dsn1_alias = dsn1_alias;
		get_stock_list_action.dsn2_alias = dsn2_alias;
		get_stock_list_action.dsn3_alias = dsn3_alias;
		get_product = get_stock_list_action.GET_PRODUCT_fnc
			(
				list_type : '#IIf(IsDefined("attributes.list_type"),"attributes.list_type",DE(""))#',
				amount_flag : '#IIf(IsDefined("attributes.amount_flag"),"attributes.amount_flag",DE(""))#',
				is_saleable_stock : '#IIf(IsDefined("attributes.is_saleable_stock"),"attributes.is_saleable_stock",DE(""))#',
				x_include_scrap_location : '#IIf(IsDefined("x_include_scrap_location"),"#x_include_scrap_location#",DE(""))#',
				x_show_second_unit : '#IIf(IsDefined("x_show_second_unit"),"#x_show_second_unit#",DE(""))#',
				product_types : '#IIf(IsDefined("attributes.product_types"),"attributes.product_types",DE(""))#',
				date1 : '#IIf(IsDefined("attributes.date1"),"attributes.date1",DE(""))#',
				date2 : '#IIf(IsDefined("attributes.date2"),"attributes.date2",DE(""))#',
				is_stock_active : '#IIf(IsDefined("attributes.is_stock_active"),"attributes.is_stock_active",DE(""))#',
				employee : '#IIf(IsDefined("attributes.employee"),"attributes.employee",DE(""))#',
				employee_id : '#IIf(IsDefined("attributes.employee_id"),"attributes.employee_id",DE(""))#',
				company_id : '#IIf(IsDefined("attributes.company_id"),"attributes.company_id",DE(""))#',
				company : '#IIf(IsDefined("attributes.company"),"attributes.company",DE(""))#',
				search_product_catid : '#IIf(IsDefined("attributes.search_product_catid"),"attributes.search_product_catid",DE(""))#',
				product_cat : '#IIf(IsDefined("attributes.product_cat"),"attributes.product_cat",DE(""))#',
				product_brand_id : '#IIf(IsDefined("attributes.product_brand_id"),"attributes.product_brand_id",DE(""))#',
				product_brand_name : '#IIf(IsDefined("attributes.product_brand_name"),"attributes.product_brand_name",DE(""))#',
				product_model_id : '#IIf(IsDefined("attributes.product_model_id"),"attributes.product_model_id",DE(""))#',
				product_model_name : '#IIf(IsDefined("attributes.product_model_name"),"attributes.product_model_name",DE(""))#',
				barcod : '#IIf(IsDefined("attributes.barcod"),"attributes.barcod",DE(""))#',
				keyword : '#IIf(IsDefined("attributes.keyword"),"attributes.keyword",DE(""))#',
				shelf_number : '#IIf(IsDefined("attributes.shelf_number"),"attributes.shelf_number",DE(""))#',
				shelf_number_txt : '#IIf(IsDefined("attributes.shelf_number_txt"),"attributes.shelf_number_txt",DE(""))#',
				stock_code : '#IIf(IsDefined("attributes.stock_code"),"attributes.stock_code",DE(""))#',
				ozel_kod : '#IIf(IsDefined("attributes.ozel_kod"),"attributes.ozel_kod",DE(""))#',
				department_id : '#IIf(IsDefined("attributes.department_id"),"attributes.department_id",DE(""))#',
				location_id : '#IIf(IsDefined("attributes.location_id"),"attributes.location_id",DE(""))#',
				list_property_id : '#IIf(IsDefined("attributes.list_property_id"),"attributes.list_property_id",DE(""))#',
				property_search_type : '#IIf(IsDefined("attributes.property_search_type"),"attributes.property_search_type",DE(""))#',
				list_property_name : '#IIf(IsDefined("attributes.list_property_name"),"attributes.list_property_name",DE(""))#',
				list_variation_code : '#IIf(IsDefined("attributes.list_variation_code"),"attributes.list_variation_code",DE(""))#',
				list_variation_id : '#IIf(IsDefined("attributes.list_variation_id"),"attributes.list_variation_id",DE(""))#',
				strategy_type : '#IIf(IsDefined("attributes.strategy_type"),"attributes.strategy_type",DE(""))#',
				sort_type : '#IIf(IsDefined("attributes.sort_type"),"attributes.sort_type",DE(""))#',
				startrow : '#IIf(IsDefined("attributes.startrow"),"attributes.startrow",DE(""))#',
				maxrows : '#IIf(IsDefined("attributes.maxrows"),"attributes.maxrows",DE(""))#',
				manufacturer_code : '#IIf(IsDefined("attributes.manufacturer_code"),"attributes.manufacturer_code",DE(""))#',
				lotno_filter : '#IIf(IsDefined("attributes.lotno_filter"),"attributes.lotno_filter",DE(""))#',
				spect_main_id : '#IIf(IsDefined("attributes.spect_main_id"),"attributes.spect_main_id",DE(""))#'
			);
	</cfscript>
<!---  <cfinclude template="../query/get_stock_list.cfm">--->
<cfelse>
	<cfset get_product.recordcount = 0>
</cfif>
<cfif get_product.recordcount>
	<cfparam name="attributes.totalrecords" default='#get_product.query_count#'>
<cfelse>
	<cfparam name="attributes.totalrecords" default='0'>
</cfif>
<cfif attributes.list_type eq 2>
	<cfscript>
		list_spec_id='';
		for(row_spec=1;row_spec lte attributes.maxrows;row_spec=row_spec+1)
			list_spec_id=listappend(list_spec_id,evaluate('GET_PRODUCT.SPECT_VAR_ID[#row_spec-1#]'),',');
		list_spec_id=ListDeleteDuplicates(listsort(list_spec_id,'numeric','ASC',','));
		if(not listlen(list_spec_id,','))list_spec_id=0;
	</cfscript>
	<cfquery name="GET_SPEC_NAME" datasource="#dsn3#">
		SELECT SPECT_MAIN_ID,SPECT_MAIN_NAME FROM SPECT_MAIN WHERE SPECT_MAIN_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#list_spec_id#">) ORDER BY SPECT_MAIN_ID
	</cfquery>
<cfelseif attributes.list_type eq 4>
	<cfscript>
		list_shelf_number='';
		for(row_shelf=1;row_shelf lte attributes.maxrows;row_shelf=row_shelf+1)
			list_shelf_number=listappend(list_shelf_number,evaluate('GET_PRODUCT.shelf_number[#row_shelf-1#]'),',');
		list_shelf_number=ListDeleteDuplicates(listsort(list_shelf_number,'numeric','ASC',','));
		if(not listlen(list_shelf_number,','))list_shelf_number=0;
	</cfscript>
	<cfquery name="GET_SHELF_NAME" datasource="#dsn3#">
		SELECT 
			SHELF_CODE,
			SHELF_TYPE,
			SHELF_NAME,
			PRODUCT_PLACE_ID,
			LOCATION_ID,
			STORE_ID
		FROM 
			PRODUCT_PLACE PP LEFT JOIN #dsn_alias#.SHELF ON SHELF.SHELF_ID = PP.SHELF_TYPE 
			
		WHERE 
			PRODUCT_PLACE_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#list_shelf_number#">) 
		ORDER BY 
			PRODUCT_PLACE_ID
	</cfquery>
</cfif>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box>
		<cfform name="stock_search" method="post" action="#request.self#?fuseaction=#attributes.fuseaction#">
			<input name="is_form_submitted" id="is_form_submitted" type="hidden" value="1">
			<cf_box_search>
				<cfoutput>
					<div class="form-group">
						<cfinput type="text" name="keyword" id="keyword" placeholder="#getlang(48,'Filtre',57460)#" value="#attributes.keyword#" maxlength="50">
					</div>
					<div class="form-group">
						<cfinput type="text" name="stock_code" placeholder="#getlang(106,'Stok Kodu',57518)#" value="#attributes.stock_code#" maxlength="50">
					</div>
					<div class="form-group">
						<cfinput type="text" name="ozel_kod" placeholder="#getlang(377,'Özel Kod',57789)#" value="#attributes.ozel_kod#" maxlength="50">
					</div>
					<cfif x_manufacturer_code>
						<div class="form-group">
							<cfsavecontent variable="header_"><cf_get_lang dictionary_id="57634.üretici kodu"></cfsavecontent>
							<cfinput type="text" name="manufacturer_code" placeholder="#getlang(222,'Üretici Kodu',57634)#" value="#attributes.manufacturer_code#" maxlength="50">
						</div>
					</cfif>
					<div class="form-group" id="item-barcod">
						<cfinput type="text" name="barcod" value="#attributes.barcod#" placeholder="#getLang('','Barkod',57633)#" maxlength="15">
					</div>
					<div class="form-group">
						<select name="is_stock_active" id="is_stock_active">
							<option value="2" <cfif attributes.is_stock_active eq 2>selected</cfif>><cf_get_lang dictionary_id='57708.Tümü'></option>
							<option value="1" <cfif attributes.is_stock_active eq 1>selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'></option>
							<option value="0" <cfif attributes.is_stock_active eq 0>selected</cfif>><cf_get_lang dictionary_id='57494.Pasif'></option>
						</select>
					</div>
					<div class="form-group small">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
						<cfinput type="text" name="maxrows" value="#attributes.maxrows#" validate="integer" range="1,999" maxlength="3" required="yes" onKeyUp="isNumber(this)" message="#message#">
					</div>
					<div class="form-group">
						<cf_wrk_search_button button_type="4" search_function='input_control()'>
					</div>
					<cfif is_show_detail_search eq 1>
					<div class="form-group">
							<a class="ui-btn ui-btn-gray" onclick="$('##gizle_').toggleClass('hide')"><i class="catalyst-grid"></i></a>
					</div>
				</cfif>
					<div class="form-group">
						<a  class="ui-btn ui-btn-gray2" href="javascript://" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_barcod_search');"><i class="fa fa-barcode" title="<cf_get_lang dictionary_id='57633.Barkod'>"></i></a>
					</div>
				</cfoutput>
			</cf_box_search>
			<cf_box_search_detail search_function='input_control()'>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group" id="item-employee">
						<label><cf_get_lang dictionary_id='57544.Sorumlu'></label>
						<div class="input-group">
							<input type="hidden" name="employee_id" id="employee_id" value="<cfoutput>#attributes.employee_id#</cfoutput>">
							<input type="text" name="employee" id="employee"value="<cfif len(attributes.employee_id)><cfoutput>#attributes.employee#</cfoutput></cfif>"  maxlength="255" onfocus="AutoComplete_Create('employee','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','\'3\',0,0','POSITION_CODE','employee_id','','3','250');" autocomplete="off">
							<span class="input-group-addon icon-ellipsis btnPointer" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_code=stock_search.employee_id&field_name=stock_search.employee&select_list=1,9&keyword='+encodeURIComponent(document.stock_search.employee.value));" title="<cf_get_lang dictionary_id='57582.Ekle'>"></span>
						</div>
					</div>
					<div class="form-group" id="item-company">
						<label><cf_get_lang dictionary_id='29533.Tedarikçi'></label>
						<div class="input-group">
							<input type="hidden" name="company_id" id="company_id" value="<cfoutput>#attributes.company_id#</cfoutput>">
							<input name="company" type="text" id="company" onfocus="AutoComplete_Create('company','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1\',0,0','COMPANY_ID','company_id','','3','250');" value="<cfif len(attributes.company_id)><cfoutput>#attributes.company#</cfoutput></cfif>" autocomplete="off">
							<span class="input-group-addon icon-ellipsis btnPointer" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_comp_name=stock_search.company&field_comp_id=stock_search.company_id&select_list=2&keyword='+encodeURIComponent(document.stock_search.company.value));" title="<cf_get_lang dictionary_id='57582.Ekle'>"></span>
						</div>
					</div>
					<div class="form-group" id="item-product_cat">
						<label><cf_get_lang dictionary_id='57486.Kategori'></label>
						<div class="input-group">
							<input type="hidden" name="search_product_catid"  id="search_product_catid" value="<cfoutput>#attributes.search_product_catid#</cfoutput>">
							<input name="product_cat" type="text"  id="product_cat" onfocus="AutoComplete_Create('product_cat','PRODUCT_CAT,HIERARCHY','PRODUCT_CAT_NAME','get_product_cat','','HIERARCHY','search_product_catid','','3','150');" value="<cfif len(attributes.search_product_catid)><cfoutput>#attributes.product_cat#</cfoutput></cfif>" autocomplete="off">
							<span class="input-group-addon icon-ellipsis btnPointer" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_product_cat_names&is_sub_category=1&field_code=stock_search.search_product_catid&field_name=stock_search.product_cat</cfoutput>&keyword='+encodeURIComponent(document.stock_search.product_cat.value));" title="<cf_get_lang dictionary_id='45366.Ürün Kategorisi Ekle'>"></span>
						</div>
					</div>
					<div class="form-group" id="item-product_brand_name">
						<label><cf_get_lang dictionary_id='58847.Marka'></label>
						<div class="input-group">
							<cfoutput>
								<input type="hidden" name="product_brand_id" id="product_brand_id" value="<cfif len(attributes.product_brand_name)>#attributes.product_brand_id#</cfif>">
								<input type="text" name="product_brand_name" id="product_brand_name" value="<cfif len(attributes.product_brand_name)>#attributes.product_brand_name#</cfif>" onfocus="AutoComplete_Create('product_brand_name','BRAND_NAME','BRAND_NAME','get_brand','0','BRAND_ID,BRAND_NAME','product_brand_id,product_brand_name','','3','130','','');" autocomplete="off">
								<span class="input-group-addon icon-ellipsis btnPointer" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_product_brands&brand_id=stock_search.product_brand_id&brand_name=stock_search.product_brand_name&keyword='+encodeURIComponent(document.stock_search.product_brand_name.value));" title="<cf_get_lang dictionary_id='58847.Marka'>"></span>
							</cfoutput>
						</div>
					</div>
				</div>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
					<div class="form-group" id="item-department_id">
						<label><cf_get_lang dictionary_id='58763.Depo'></label>
						<cfif x_show_pasive_departments eq 0>
								<cf_wrkdepartmentlocation 
								returninputvalue="location_name,department_id,location_id"
								returnqueryvalue="LOCATION_NAME,DEPARTMENT_ID,LOCATION_ID"
								fieldname="location_name"
								fieldid="location_id"
								status="1"
								branch_fldId=""
								is_department="1"
								department_fldid="department_id"
								department_id="#attributes.department_id#"
								location_name="#attributes.location_name#"
								location_id="#attributes.location_id#"
								user_level_control="#session.ep.OUR_COMPANY_INFO.IS_LOCATION_FOLLOW#"
								width="120">

								
						<cfelse>
							<cf_wrkdepartmentlocation 
								returninputvalue="location_name,department_id,location_id"
								returnqueryvalue="LOCATION_NAME,DEPARTMENT_ID,LOCATION_ID"
								fieldname="location_name"
								fieldid="location_id"
								status="0"
								branch_fldId=""
								is_department="1"
								department_fldid="department_id"
								department_id="#attributes.department_id#"
								location_name="#attributes.location_name#"
								location_id="#attributes.location_id#"
								user_level_control="#session.ep.OUR_COMPANY_INFO.IS_LOCATION_FOLLOW#"
								width="120">
						</cfif>
					</div>
					<div class="form-group" id="item-product_model_name">
						<label><cf_get_lang dictionary_id='58225.Model'></label>
						<div class="input-group">
							<cfoutput>
								<input type="hidden" name="product_model_id" id="product_model_id" value="<cfif len(attributes.product_model_name)>#attributes.product_model_id#</cfif>">
								<input type="text" name="product_model_name" id="product_model_name" value="<cfif len(attributes.product_model_name)>#attributes.product_model_name#</cfif>" onfocus="AutoComplete_Create('product_model_name','MODEL_NAME','MODEL_NAME','get_product_model','0','MODEL_ID,MODEL_NAME','product_model_id,product_model_name','','3','130','','1');" autocomplete="off">
								<span class="input-group-addon icon-ellipsis btnPointer" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_product_model&model_id=stock_search.product_model_id&model_name=stock_search.product_model_name&keyword='+encodeURIComponent(document.stock_search.product_model_name.value));" title="<cf_get_lang dictionary_id='58225.Model'>"></span>
							</cfoutput>
						</div>
					</div>
					<div class="form-group" id="item-property_search_type">
						<label><cf_get_lang dictionary_id='58137.Kategoriler'></label>
						<select name="property_search_type" id="property_search_type">
							<option value="1" <cfif isdefined('attributes.property_search_type') and attributes.property_search_type eq 1>selected</cfif>><cf_get_lang dictionary_id='45563.Ürün Özelliklerinden'></option>
							<option value="2" <cfif isdefined('attributes.property_search_type') and attributes.property_search_type eq 2>selected</cfif>><cf_get_lang dictionary_id='45564.Ürün İsminden'></option>
							<option value="3" <cfif isdefined('attributes.property_search_type') and attributes.property_search_type eq 3>selected</cfif>><cf_get_lang dictionary_id='45565.Spec İsminden'></option>
							<option value="4" <cfif isdefined('attributes.property_search_type') and attributes.property_search_type eq 4>selected</cfif>><cf_get_lang dictionary_id='45566.Spec Özelliklerinden'></option>
						</select>
					</div>
					<div class="form-group" id="item-product_types">
						<label><cf_get_lang dictionary_id='45195.Ürün Bilgileri'></label>
						<select name="product_types" id="product_types">
							<option value=""><cf_get_lang dictionary_id='45195.Ürün Bilgileri'></option>
							<option value="5"<cfif isDefined("attributes.product_types") and (attributes.product_types eq 5)> selected</cfif>><cf_get_lang dictionary_id='37170.Tedarik Edilmiyor'></option>
							<option value="1"<cfif isDefined("attributes.product_types") and (attributes.product_types eq 1)> selected</cfif>><cf_get_lang dictionary_id='45422.Tedarik Ediliyor'></option>
							<option value="4"<cfif isDefined("attributes.product_types") and (attributes.product_types eq 4)> selected</cfif>><cf_get_lang dictionary_id='45423.Terazi'></option>
							<option value="6"<cfif isDefined("attributes.product_types") and (attributes.product_types eq 6)> selected</cfif>><cf_get_lang dictionary_id='45424.Üretiliyor'></option>
							<option value="13"<cfif isDefined("attributes.product_types") and (attributes.product_types eq 13)> selected</cfif>><cf_get_lang dictionary_id='45425.Maliyet Takip Ediliyor'></option>
							<option value="7"<cfif isDefined("attributes.product_types") and (attributes.product_types eq 7)> selected</cfif>><cf_get_lang dictionary_id='45426.Seri No Takip'></option>
							<option value="8"<cfif isDefined("attributes.product_types") and (attributes.product_types eq 8)> selected</cfif>><cf_get_lang dictionary_id='45743.Karma Koli'></option>
							<option value="9"<cfif isDefined("attributes.product_types") and (attributes.product_types eq 9)> selected</cfif>><cf_get_lang dictionary_id='58079.İnternet'></option>
							<option value="12"<cfif isDefined("attributes.product_types") and (attributes.product_types eq 12)> selected</cfif>><cf_get_lang dictionary_id='58019.Extranet'></option>
							<option value="10"<cfif isDefined("attributes.product_types") and (attributes.product_types eq 10)> selected</cfif>><cf_get_lang dictionary_id='45427.Özelleştirilebilir'></option>
							<option value="11"<cfif isDefined("attributes.product_types") and (attributes.product_types eq 11)> selected</cfif>><cf_get_lang dictionary_id='45428.Sıfır Stok İle Çalış'></option>
							<option value="14"<cfif isDefined("attributes.product_types") and (attributes.product_types eq 14)> selected</cfif>><cf_get_lang dictionary_id='45429.Satışta'></option>
						</select>
					</div>
				</div>
				<cfif attributes.amount_flag eq 2 and is_show_strateji_detail eq 1>
					<cfif is_show_strateji_action_types eq 1>
						<cfif is_strategy_real_stock eq 1 and isdefined("attributes.is_saleable_stock")>
							<cfset colspan_info = 18>
						<cfelse>
							<cfset colspan_info = 17>
						</cfif>
					<cfelse>
						<cfif is_strategy_real_stock eq 1 and isdefined("attributes.is_saleable_stock")>
							<cfset colspan_info = 17>
						<cfelse>
							<cfset colspan_info = 16>
						</cfif>
					</cfif>
				<cfelse>
					<cfif is_strategy_real_stock eq 1 and isdefined("attributes.is_saleable_stock")>
						<cfset colspan_info = 12>
					<cfelse>
						<cfset colspan_info = 11>
					</cfif>
				</cfif>
				<cfif attributes.list_type eq 4>
					<cfset colspan_info = 15>                    
				</cfif>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
					<div class="form-group" id="item-list_type">
						<label><cfoutput>#getlang(378,'Stok Bazından',45555)#</cfoutput></label>
						<select name="list_type" style="widows:100px;" id="list_type" onchange="show_shelf();">
							<option value="1" <cfif attributes.list_type eq 1>selected</cfif>><cf_get_lang dictionary_id='45555.Stok Bazında'></option>
							<option value="2" <cfif attributes.list_type eq 2>selected</cfif>><cf_get_lang dictionary_id='45556.Spec Bazında'></option>
							<option value="3" <cfif attributes.list_type eq 3>selected</cfif>><cf_get_lang dictionary_id ='45740.Karma Koli Bazında'></option>
							<option value="4" <cfif attributes.list_type eq 4>selected</cfif>><cf_get_lang dictionary_id ='45804.Raf Bazında'></option>
							<option value="5" <cfif attributes.list_type eq 5>selected</cfif>><cfoutput>#getlang(526,'Lot Bazında',59323)#</cfoutput></option>
						</select>
					</div>
					<div class="form-group" id="item-amount_flag">
						<label><cf_get_lang dictionary_id='38737.Stok Durumu'></label>
						<select name="amount_flag" id="amount_flag" onchange="show_strategy_type();gizle_goster(is_sale_stock);">
							<option value="" <cfif not len(attributes.amount_flag)>selected</cfif>><cf_get_lang dictionary_id='38737.Stok Durumu'></option>
							<option value="3" <cfif attributes.amount_flag eq 3>selected</cfif>><cf_get_lang dictionary_id='45745.Sıfır Stok'></option>
							<option value="0" <cfif attributes.amount_flag eq 0>selected</cfif>><cf_get_lang dictionary_id='45557.Negatif Stok'></option>
							<option value="1" <cfif attributes.amount_flag eq 1>selected</cfif>><cf_get_lang dictionary_id='45558.Pozitif Stok'></option>
							<option value="2" <cfif attributes.amount_flag eq 2>selected</cfif>><cf_get_lang dictionary_id='45559.Strateji Bazında'></option>
						</select>
					</div>
					<div class="form-group" id="item-sort_type">
						<label><cf_get_lang dictionary_id='58924.Sıralama'></label>
						<select name="sort_type" id="sort_type">
							<option value="0" <cfif attributes.sort_type eq 0>selected</cfif>><cf_get_lang dictionary_id='45553.Ürün Adına Göre'></option>
							<option value="1" <cfif attributes.sort_type eq 1>selected</cfif>><cf_get_lang dictionary_id='45554.Stok Koduna Göre'></option>
							<option value="2" <cfif attributes.sort_type eq 2>selected</cfif>><cf_get_lang dictionary_id='45231.Özel Koda Göre'></option>
							<option value="3" <cfif attributes.sort_type eq 3>selected</cfif>><cf_get_lang dictionary_id="45390.Raf No'ya Göre Artan"></option>
							<option value="4" <cfif attributes.sort_type eq 4>selected</cfif>><cf_get_lang dictionary_id="45395.Raf No'ya Göre Azalan"></option>
							<option value="5" <cfif attributes.sort_type eq 5>selected</cfif>><cf_get_lang dictionary_id="39362.Miktara Göre"><cf_get_lang dictionary_id="29826.Artan"></option>
							<option value="6" <cfif attributes.sort_type eq 6>selected</cfif>><cf_get_lang dictionary_id="39362.Miktara Göre"><cf_get_lang dictionary_id="29827.Artan"></option>
						</select>
					</div>
				</div>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="4" sort="true">
					<div class="form-group" id="item-lotno_filter" style="<cfif attributes.list_type neq 5>display:none;</cfif>">
						<label><cfoutput>#getlang(526,'Lot no',32916)#</cfoutput></label>
						<cfinput type="text" name="lotno_filter" value="#attributes.lotno_filter#" maxlength="50" >    
					</div>
					<div class="form-group" id="item-spect_name" style="<cfif attributes.list_type neq 2>display:none;</cfif>">
						<label><cfoutput>#getlang('','Spekt',57647)#</cfoutput></label>
						<div class="col col-12 col-xs-12">
                            <div class="input-group">
								<cfinput type="hidden" name="spect_main_name" id="spect_main_name" readonly="yes">
								<cfinput type="text" name="spect_main_id" value="#attributes.spect_main_id#" readonly>
                        		<span class="input-group-addon icon-ellipsis btnPoniter" onclick="open_spec();"></span>
							</div>
						</div>
					</div>
				</div>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="5" sort="true">
					<div class="form-group" id="item-strategy_type">
						<label><span class="hide"><cfoutput>#getlang('stock',626)#</cfoutput></span></label>
						<select name="strategy_type" id="strategy_type" style="<cfif attributes.amount_flag neq 2> display:none; </cfif>width:120px">
							<option value="" <cfif not len(attributes.strategy_type)>selected</cfif>><cf_get_lang dictionary_id='57708.Tümü'></option>
							<option value="1" <cfif attributes.strategy_type eq 1>selected</cfif>><cf_get_lang dictionary_id='45336.Fazla Stok'></option>
							<option value="2" <cfif attributes.strategy_type eq 2>selected</cfif>><cf_get_lang dictionary_id='45560.Yetersiz Stok'></option>
							<option value="3" <cfif attributes.strategy_type eq 3>selected</cfif>><cf_get_lang dictionary_id='45205.Yeniden Sipariş Noktası'></option>
						</select>
					</div>
					<div class="form-group" id="is_sale_stock" nowrap="nowrap" style="<cfif attributes.amount_flag neq 2>display:none;</cfif>">
						<label><span class="hide"><cf_get_lang dictionary_id='45561.Satılabilir Stoğa Göre Strateji'></span></label>
						<input type="checkbox" name="is_saleable_stock" id="is_saleable_stock" <cfif isdefined("attributes.is_saleable_stock")>checked</cfif>>
						<cf_get_lang dictionary_id='45561.Satılabilir Stoğa Göre Strateji'>
					</div>
					<div class="form-group" id="is_shelf_1" style="<cfif attributes.list_type neq 4>display:none;</cfif>">
						<label><cf_get_lang dictionary_id='45667.Raf'></label>
						<div class="input-group">
							<input type="hidden" name="shelf_number" id="shelf_number" value="<cfoutput>#attributes.shelf_number#</cfoutput>">
							<input type="text" name="shelf_number_txt" id="shelf_number_txt" value="<cfoutput>#attributes.shelf_number_txt#</cfoutput>">
							<span class="input-group-addon icon-ellipsis btnPointer" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_shelves&is_array_type=0&row_id=&form_name=stock_search&row_count=1&field_code=shelf_number_txt&field_id=shelf_number','small','shelf_list_page');" title="<cf_get_lang dictionary_id='57582.Ekle'>"></span>
						</div>
					</div>
				</div>
			
				<cfparam name="attributes.mode" default="4">
				<cfquery name="get_property_variation" datasource="#dsn1#">
					SELECT
						PP.PROPERTY_ID,
						PP.PROPERTY,
						PPD.PROPERTY_DETAIL_ID,
						PPD.PROPERTY_DETAIL_CODE,
						PPD.PROPERTY_DETAIL
					FROM
						PRODUCT_PROPERTY PP,
						PRODUCT_PROPERTY_DETAIL PPD,
						PRODUCT_PROPERTY_OUR_COMPANY PPOC
					WHERE
						PP.PROPERTY_ID = PPD.PRPT_ID AND
						PPOC.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
						PPOC.PROPERTY_ID = PP.PROPERTY_ID 
					ORDER BY
						PP.PROPERTY,
						PPD.PROPERTY_DETAIL
				</cfquery>
				<input type="hidden" name="list_property_id" id="list_property_id" value="">
				<input type="hidden" name="list_variation_id" id="list_variation_id" value="">
				<input type="hidden" name="list_variation_code" id="list_variation_code" value="">
				<input type="hidden" name="list_property_name" id="list_property_name" value="">
				<input type="hidden" name="list_variation_name" id="list_variation_name" value="">
				<cfif is_show_detail_search eq 1>
					<div id="gizle_" class="col col-12 col-md-12 col-sm-12 col-xs-12" type="column" index="6" sort="true">
					<cf_seperator title="#getLang('','Ek Özellikler',48135)#" id="seperator_" is_closed="1">
						<div id="seperator_">
						<div class="form-group" id="item-extraDetail" class="col col-12 col-md-12 col-sm-12 col-xs-12">
							<cfoutput>
								<cfset a=0>
								<cfset row=0>
								<cfset table_open_ = 0>
								<cfloop from="1" to="#get_property_variation.recordcount#" index="main_str">
									<cfparam name="attributes.variation_id#main_str#" default="">
									<cfset varyasyon_id = "">
									<cfif get_property_variation.property_id[main_str] neq get_property_variation.property_id[main_str-1]>                    	
										<div class="col col-3 col-md-4 col-sm-4 col-xs-12" id="frm_row#main_str#">
												<div class="form-group"><input type="hidden" name="property_id#main_str#" id="property_id#main_str#" value="#get_property_variation.property_id[main_str]#|,|#get_property_variation.property[main_str]#">
													<cfset varyasyon_id = listfirst(evaluate("attributes.variation_id#main_str#"),'|,|')>
													<select name="variation_id#main_str#" id="variation_id#main_str#">
														<option value="">#get_property_variation.property[main_str]#</option>
														<cfloop from="#main_str#" to="#get_property_variation.recordcount#" index="str">
															<cfif get_property_variation.property_id[main_str] eq get_property_variation.property_id[str]>
																<option value="#get_property_variation.property_detail_id[str]#" <cfif isdefined("attributes.list_variation_id") and listfind(attributes.list_variation_id,get_property_variation.property_detail_id[str])>selected="selected" style="background-color:##FF9;"</cfif>>&nbsp;#get_property_variation.property_detail[str]#</option>
															<cfelse>
																<cfbreak>
															</cfif>
														</cfloop>
													</select>
													<cfset a=a+1>                                    
												</div>
												</div>
									</cfif>
								</cfloop>
								<cfif table_open_ eq 1></div></cfif>
							</cfoutput>
						</div></div></div>
					</cfif>
			</cf_box_search_detail>
			<script type="text/javascript">
				<cfif isdefined("get_property_variation")>
					row_count = <cfoutput>#get_property_variation.recordcount#</cfoutput>;			
				<cfelse>
					row_count = 0;	
				</cfif>
				function gonder_detail()
				{
					for(r=1;r<=row_count;r++)
					{
						if(eval("document.stock_search.property_id"+r)!=undefined && eval("document.stock_search.variation_id"+r).value!='')
						{
							deger_property_id = list_getat(eval("document.stock_search.property_id"+r).value,1,'|,|');
							deger_property_name = list_getat(eval("document.stock_search.property_id"+r).value,2,'|,|');
							deger_variation_id = list_getat(eval("document.stock_search.variation_id"+r).value,1,'|,|');
							deger_variation_code = list_getat(eval("document.stock_search.variation_id"+r).value,2,'|,|');
							deger_variation_name = list_getat(eval("document.stock_search.variation_id"+r).value,3,'|,|');
							if(deger_variation_id != "")
							{
								if(document.stock_search.list_property_id.value.length==0){ ayirac=''; ayirac_2='';}else {ayirac=','; ayirac_2='|,|';}
								document.stock_search.list_property_id.value=document.stock_search.list_property_id.value+ayirac+deger_property_id;
								document.stock_search.list_property_name.value=document.stock_search.list_property_name.value+ayirac_2+deger_property_name;
								document.stock_search.list_variation_id.value=document.stock_search.list_variation_id.value+ayirac+deger_variation_id;
								document.stock_search.list_variation_code.value=document.stock_search.list_variation_code.value+ayirac_2+deger_variation_code;
								document.stock_search.list_variation_name.value=document.stock_search.list_variation_name.value+ayirac_2+deger_variation_name;
								
								if(document.stock_search.property_search_type.value==3 || document.stock_search.property_search_type.value==4)
									document.stock_search.list_type.value=2;
								else
									document.stock_search.list_type.value=1;
							}
						}
					}
					return true;
				}
				</script>
		</cfform>
	</cf_box>
	<cf_box title="#getLang(754,'Stoklar',58166)#" uidrop="1" hide_table_column="1">
		<cf_grid_list>
			<thead>
				<tr>
					<!-- sil --><th width="20"></th><!-- sil -->
					<th width="20"><cf_get_lang dictionary_id='45294.Sid'></th>
					<th><cf_get_lang dictionary_id='57518.stok kodu'></th>
					<th><cf_get_lang dictionary_id='57633.barkod'></th>
					<th><cf_get_lang dictionary_id='57789.özel kod'></th>
					<cfif x_manufacturer_code><th><cf_get_lang dictionary_id='57634.üretici kod'></th></cfif>
					<cfif attributes.list_type eq 3><th><cf_get_lang dictionary_id ='45743.Karma Koli'></th></cfif>
					<th><cf_get_lang dictionary_id='57657.ürün'></th>
					<th><cf_get_lang dictionary_id='63694.Paketleme Tipi'></th>
					<cfif attributes.list_type eq 5><th><cf_get_lang dictionary_id='45498.Lot No'></th></cfif>
					<cfif attributes.list_type eq 2><th><cf_get_lang dictionary_id='57647.spec'></th></cfif>
					<cfif attributes.list_type eq 4>
					<cfif attributes.department_id eq ''>
					<th><cf_get_lang dictionary_id='58763.Depo'>-<cf_get_lang dictionary_id='30031.lokasyon'></th>
					</cfif>
					<th><cf_get_lang dictionary_id='45667.Raf'></th>
					</cfif>
					<cfif attributes.list_type eq 1 and attributes.amount_flag eq 2 and is_strategy_real_stock eq 1 and isdefined("attributes.is_saleable_stock")>
					<th><cf_get_lang dictionary_id ='58120.Gerçek Stok'></th>
					</cfif>
					<th><cf_get_lang dictionary_id='57635.miktar'></th>
					<th><cf_get_lang dictionary_id='57636.birim'></th>
					<cfif x_show_second_unit><th>2.<cf_get_lang dictionary_id='57635.miktar'></th></cfif>
					<cfif x_show_second_unit><th>2.<cf_get_lang dictionary_id='57636.birim'></th></cfif>
					<cfif attributes.amount_flag eq 2 and is_show_strateji_detail eq 1> <!--- xml den detaylı stok stratejisi goster secilmisse --->
					<th><cf_get_lang dictionary_id ='45742.Max Stok Miktarı'></th>
					<th><cf_get_lang dictionary_id ='45741.Min Stok Miktarı'></th>
					<th><cf_get_lang dictionary_id ='45280.Bloke Stok Miktarı'></th>
					<th><cf_get_lang dictionary_id ='45205.Yeniden Sipariş Noktası'></th>
					<th><cf_get_lang dictionary_id ='45233.Min Sipariş Miktarı'></th>
					<th><cf_get_lang dictionary_id ='45204.Tedarik Süresi'></th>
					<cfif is_show_strateji_action_types eq 1>
					<th><cf_get_lang dictionary_id ='45284.Stok Prensibi'></th>
					</cfif>
					</cfif>
					<th id="durum_satir" <cfif attributes.amount_flag neq 2>style="display:none;"</cfif>><cf_get_lang dictionary_id='57756.Durum'></th><!-- sil -->
					<th width="20" class="text-center"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></th>
					<!-- sil -->
				</tr>
			</thead>
			<tbody>
				<cfif attributes.amount_flag eq 2 and is_show_strateji_detail eq 1 and is_show_strateji_action_types eq 1>
					<cfset stock_act_type_list = ''>
					<cfoutput query="get_product" >
						<cfif len(stock_action_id) and not listfind(stock_act_type_list,stock_action_id)>
							<cfset stock_act_type_list = listappend(stock_act_type_list,stock_action_id)>
						</cfif>	
					</cfoutput>
					<cfif len(stock_act_type_list)>
						<cfset stock_act_type_list=listsort(stock_act_type_list,"numeric","ASC",",")>
						<cfquery name="get_stock_acts" datasource="#dsn3#">
							SELECT STOCK_ACTION_ID, STOCK_ACTION_NAME FROM SETUP_SALEABLE_STOCK_ACTION WHERE STOCK_ACTION_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#stock_act_type_list#">) ORDER BY STOCK_ACTION_ID
						</cfquery>
						<cfset stock_act_type_list = listsort(listdeleteduplicates(valuelist(get_stock_acts.stock_action_id,',')),'numeric','ASC',',')>
					</cfif> 
				</cfif>
				<cfif get_product.recordcount>
					<cfset new_product_id_list = ''>
					<cfoutput query="get_product" >
						<cfif attributes.list_type eq 3>
							<cfif KARMA_STOCK lt 0><cfset _KARMA_STOCK_ = 0><cfelse><cfset _KARMA_STOCK_ = KARMA_STOCK></cfif>
							<cfif not isdefined('min_stock_#KARMA_PRODUCT_ID#')>
								<!--- Karma Koliyi Oluşturan Ürünlerin Karma Koli İhtiyacına Göre Oranlarının *En Küçüğü* Elimizdeki  Karma Koli Adedini Verir. --->
								<cfset 'min_stock_#KARMA_PRODUCT_ID#' = _KARMA_STOCK_>
							</cfif>
							<cfif not listfind(new_product_id_list,KARMA_PRODUCT_ID,',')>
								<tr>
									<!-- sil --><td>&nbsp;</td><!-- sil -->
									<td class="txtboldblue">#KARMA_STOCK_ID#</td>
									<td class="txtboldblue">#KARMA_STOCK_CODE#</td>
									<td class="txtboldblue">#KARMA_BARKOD#</td>
									<td class="txtboldblue">#KARMA_STOCK_CODE_2#</td>
									<td class="txtboldblue">#KARMA_PRODUCT_NAME#</td>
									<td>#KARMA_PROPERTY#</td>
									<td align="right"  class="txtboldblue" id="karma_stock#KARMA_PRODUCT_ID#" style="text-align:right;">#tlformat(0)#</td>
									<!-- sil -->
									<td colspan="9" align="right" style="text-align:right;">
										<a href="#request.self#?fuseaction=stock.list_stock&event=det&pid=#KARMA_PRODUCT_ID#"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a>&nbsp;&nbsp;
									</td>
									<!-- sil -->
								</tr>
								<cfset new_product_id_list = ListAppend(new_product_id_list,KARMA_PRODUCT_ID,',')> 
							</cfif>
							<cfif (Evaluate('min_stock_#KARMA_PRODUCT_ID#') gte _KARMA_STOCK_) and Evaluate('min_stock_#KARMA_PRODUCT_ID#') gte 0>
								<cfset 'min_stock_#KARMA_PRODUCT_ID#' = _KARMA_STOCK_>
								<script type="text/javascript">
									document.getElementById('karma_stock#KARMA_PRODUCT_ID#').innerHTML ='#tlformat(_KARMA_STOCK_)#';
								</script>
							</cfif>
						</cfif>
						<tr>
							<!-- sil -->
							<td class="iconL">
								<a href="javascript:void(0)" id="order_row#currentrow#"  onclick="gizle_goster(order_row#currentrow#);connectAjax('#currentrow#','#PRODUCT_ID#','#STOCK_ID#'<cfif attributes.list_type eq 2>,'#SPECT_VAR_ID#'<cfelse>,'0'</cfif>);gizle_goster(siparis_goster#currentrow#);gizle_goster(siparis_gizle#currentrow#);"><i class="fa fa-caret-right"></i></a>
							</td>
							<!-- sil -->
							<td>#stock_id#</td>
							<td style="mso-number-format:'\@'"><a href="#request.self#?fuseaction=stock.list_stock&event=det&pid=#product_id#" class="tableyazi">#stock_code#</a></td>
							<td style="mso-number-format:'\@'">#barcod#</td>
							<td style="mso-number-format:'\@'">#stock_code_2#</td>
							<cfif x_manufacturer_code><td style="mso-number-format:'\@'">#manufact_code#</td></cfif>
							<cfif attributes.list_type eq 3><td align="right" style="text-align:right;">#PRODUCT_AMOUNT# * </td></cfif>
							<td>
								<a href="javascript://" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_detail_product&pid=#product_id#&stock_id=#stock_id#<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>','large');" class="tableyazi">
									#PRODUCT_NAME#<cfif len(property) and trim(property) neq "-">-#property#</cfif>
								</a>
							</td>
							<td>						
								<cfif GET_PRODUCT.PACKAGE_TYPE_ID neq ''>
									<cfquery name="PACKAGES" datasource="#dsn#">
										SELECT 
											PACKAGE_TYPE_ID, 
											PACKAGE_TYPE
										FROM 
											SETUP_PACKAGE_TYPE
										WHERE
										PACKAGE_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_PRODUCT.PACKAGE_TYPE_ID#">
									</cfquery>
									#PACKAGES.PACKAGE_TYPE#
								</cfif>
							</td>
							<cfif attributes.list_type eq 5>
							<cfif LOT_NO neq ''>                  	
								<td style="mso-number-format:\@;" align="center">#LOT_NO#</td>
							<cfelse>
								<td style="mso-number-format:\@;" align="center">-</td>
							</cfif>                       
							</cfif>
							<cfif attributes.list_type eq 2><td>#SPECT_VAR_ID# - #evaluate("GET_SPEC_NAME.SPECT_MAIN_NAME[#listfind(list_spec_id,SPECT_VAR_ID,',')#]")#</td></cfif>
							<cfif attributes.list_type eq 4>
								<cfif attributes.department_id eq ''>
									<td><cfif len(shelf_number)>
											#get_location_info(GET_SHELF_NAME.STORE_ID[listfind(list_shelf_number,shelf_number)],GET_SHELF_NAME.LOCATION_ID[listfind(list_shelf_number,shelf_number)],1)#
										</cfif>
									</td>
								</cfif>
								<td><cfif len(shelf_number)>
										#evaluate("GET_SHELF_NAME.SHELF_CODE[#listfind(list_shelf_number,shelf_number,',')#]")#
										<cfif isdefined('is_shelf_code') and is_shelf_code eq 1> - #evaluate("GET_SHELF_NAME.SHELF_NAME[#listfind(list_shelf_number,shelf_number,',')#]")#</cfif> 
									</cfif>
								</td>
							</cfif>
							<cfif attributes.list_type eq 1 and attributes.amount_flag eq 2 and is_strategy_real_stock eq 1 and isdefined("attributes.is_saleable_stock")>
								<td align="right" style="text-align:right;">
									<cfif (isDefined("x_include_scrap_location") and x_include_scrap_location eq 0)>
										<cfset real_stock_ = real_stock - hurda_stock>
									<cfelse>
										<cfset real_stock_ = real_stock>
									</cfif>
									#TlFormat(real_stock_,2)#
								</td>
							</cfif>
							<td align="right" style="text-align:right;">
								<!--- Xml Hurda Lokasyonu Miktara Dahil Edilsin Mi/ Strateji Bazinda Zaten Dusuldugu Icin Tekrar Dusulmuyor --->
								<cfif (isDefined("x_include_scrap_location") and x_include_scrap_location eq 0) and attributes.amount_flag neq 2>
									<cfset Product_Stock_ = product_stock - hurda_stock>
								<cfelse>
									<cfset Product_Stock_ = wrk_round(product_stock,8,1)>
								</cfif>
								<cfset temp_product_name_ = replace(product_name,"'","","all")>
								<cfset temp_product_name_ = replace(temp_product_name_,'"','','all')>
								<cfset temp_product_name_ = replace(temp_product_name_,';','','all')>
								<a href="javascript://" onclick="openBoxDraggable('#request.self#?fuseaction=stock.popup_stock_graph&pid=#product_id#&product_name=#temp_product_name_#');">
									<cfif Product_Stock_ lt 0><font color="ff0000">#Tlformat(Product_Stock_)#</font><cfelse>#Tlformat(Product_Stock_)#</cfif>
								</a>
							</td>
							<td>#main_unit#</td>
							<cfif x_show_second_unit>
								<td align="right" style="text-align:right;">
									<cfif len(multiplier)>
										#TLFormat(POZ_PRODUCT_STOCK_2 - NEG_PRODUCT_STOCK_2)#
									</cfif>
								</td>
							</cfif>
							<cfif x_show_second_unit><td>#UNIT2#</td></cfif>
							<cfif len(Product_Stock_) and attributes.amount_flag eq 2>
								<cfif Product_Stock_ lte 0>
									<cfset stock_status = '<font color="ff0000">Stok Yok</font>'>
								<cfelseif isdefined('MINIMUM_STOCK') and len(MINIMUM_STOCK) and Product_Stock_ lte MINIMUM_STOCK>
									<cfset stock_status = '<font color="ff0000">Yetersiz Stok</font>'>
								<cfelseif isdefined('REPEAT_STOCK_VALUE') and isdefined('MINIMUM_STOCK') and len(REPEAT_STOCK_VALUE) and len(MINIMUM_STOCK) and Product_Stock_ lte REPEAT_STOCK_VALUE and Product_Stock_ gt MINIMUM_STOCK>
									<cfset stock_status = '<font color="009933">Sipariş Ver</font>'>
								<cfelseif isdefined('MAXIMUM_STOCK') and isdefined('REPEAT_STOCK_VALUE') and len(MAXIMUM_STOCK) and len(REPEAT_STOCK_VALUE) and Product_Stock_ lt MAXIMUM_STOCK and Product_Stock_ gt REPEAT_STOCK_VALUE>
									<cfset stock_status = "Yeterli Stok">
								<cfelseif isdefined('MAXIMUM_STOCK') and len(MAXIMUM_STOCK) and Product_Stock_ gte MAXIMUM_STOCK>
									<cfset stock_status = '<font color="6666FF">Fazla Stok</font>'>
								<cfelse>
								<cfsavecontent variable="messages"><cf_get_lang dictionary_id ="58845.Tanımsız"></cfsavecontent>
									<cfset stock_status = "#messages#">
								</cfif>
							<cfelse>
							<cfsavecontent variable="messages"><cf_get_lang dictionary_id ="58845.Tanımsız"></cfsavecontent>
								<cfset stock_status = "#messages#">
							</cfif>
							<cfif attributes.amount_flag eq 2 and is_show_strateji_detail eq 1>
								<td align="right" style="text-align:right;">#TlFormat(MAXIMUM_STOCK,2)#</td>
								<td align="right" style="text-align:right;">#TlFormat(MINIMUM_STOCK,2)#</td>
								<td align="right" style="text-align:right;">#TlFormat(BLOCK_STOCK_VALUE,2)#</td>
								<td align="right" style="text-align:right;">#TlFormat(REPEAT_STOCK_VALUE,2)#</td>
								<td align="right" style="text-align:right;">#TlFormat(MINIMUM_ORDER_STOCK_VALUE,2)#</td>
								<td align="right" style="text-align:right;"><cfif len(PROVISION_TIME)>#PROVISION_TIME# <cf_get_lang dictionary_id='57490.Gün'></cfif></td>
								<cfif is_show_strateji_action_types eq 1>
									<td><cfif len(stock_action_id)>#get_stock_acts.stock_action_name[listfind(stock_act_type_list,stock_action_id,',')]#</cfif></td>
								</cfif>
							</cfif>
							<!-- sil --><td id="durum_satir"  <cfif attributes.amount_flag neq 2>style="display:none;"</cfif> >#stock_status#</td><!-- sil -->
							<!-- sil --><td><a href="#request.self#?fuseaction=stock.list_stock&event=det&pid=#product_id#"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td><!-- sil -->
						</tr>
						<!-- sil -->
						<tr id="order_row#currentrow#" class="table_detail">
							<cfset tdspan = ( attributes.amount_flag neq 2) ? 20 : 22>
							<td colspan="#tdspan#">
								<div align="left" id="DISPLAY_ORDER_STOCK_INFO#currentrow#"></div>
							</td>
						</tr>
						<!-- sil -->
					</cfoutput>
				<cfelse>

				</cfif>
			</tbody>
		</cf_grid_list> 
		<cfif not get_product.recordcount>
			<div class="ui-info-bottom">
				<p><cfif isdefined("attributes.is_form_submitted")><cf_get_lang dictionary_id='57484.Kayıt Yok'><cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif>!</p>
			</div>
		</cfif>
		<cfset adres = url.fuseaction>
		<cfif isDefined('attributes.company_id') and len(attributes.company_id)>
			<cfset adres = '#adres#&company_id=#attributes.company_id#'>
		</cfif>
		<cfif isDefined('attributes.company') and len(attributes.company)>
			<cfset adres = '#adres#&company=#attributes.company#'>
		</cfif>
		<cfif isDefined("attributes.department_id") and len(attributes.department_id)>
			<cfset adres = "#adres#&department_id=#attributes.department_id#">
		</cfif>
		<cfif isDefined("attributes.location_id") and len(attributes.location_id)>
			<cfset adres = "#adres#&location_id=#attributes.location_id#">
		</cfif>
		<cfif isDefined("attributes.is_stock_active") and len(attributes.is_stock_active)>
			<cfset adres = "#adres#&is_stock_active=#attributes.is_stock_active#">
		</cfif>
		<cfif isDefined('attributes.product_cat') and len(attributes.product_cat)>
			<cfset adres = "#adres#&product_cat=#attributes.product_cat#">
		</cfif>
		<cfif isDefined("attributes.search_product_catid") and len(attributes.search_product_catid)>
			<cfset adres = "#adres#&search_product_catid=#attributes.search_product_catid#">
		</cfif>
		<cfif isDefined('attributes.keyword') and len(attributes.keyword)>
			<cfset adres = "#adres#&keyword=#UrlEncodedFormat(attributes.keyword)#">
		</cfif>
		<cfif isDefined('attributes.ozel_kod') and len(attributes.ozel_kod)>
			<cfset adres = "#adres#&ozel_kod=#attributes.ozel_kod#">
		</cfif>
		<cfif isDefined('attributes.stock_code') and len(attributes.stock_code)>
			<cfset adres = "#adres#&stock_code=#attributes.stock_code#">
		</cfif>
		<cfif isDefined('attributes.amount_flag') and len(attributes.amount_flag)>
			<cfset adres = "#adres#&amount_flag=#attributes.amount_flag#">
		</cfif>
		<cfif isDefined('attributes.employee_id') and len(attributes.employee_id)>
			<cfset adres = '#adres#&employee_id=#attributes.employee_id#'>
		</cfif>
		<cfif isDefined('attributes.employee') and len(attributes.employee)>
			<cfset adres = '#adres#&employee=#attributes.employee#'>
		</cfif>
		<cfif isdefined('attributes.list_property_id') and len(attributes.list_property_id)>
			<cfset adres = "#adres#&list_property_id=#attributes.list_property_id#">
		</cfif>
		<cfif isdefined('attributes.list_property_name') and len(attributes.list_property_name)>
			<cfset adres = "#adres#&list_property_name=#attributes.list_property_name#">
		</cfif>
		<cfif isdefined('attributes.list_variation_id') and len(attributes.list_variation_id)>
			<cfset adres = "#adres#&list_variation_id=#attributes.list_variation_id#">
		</cfif>
		<cfif isdefined('attributes.list_variation_code') and len(attributes.list_variation_code)>
			<cfset adres = "#adres#&list_variation_code=#attributes.list_variation_code#">
		</cfif>
		<cfif isdefined('attributes.list_type') and len(attributes.list_type)>
			<cfset adres = "#adres#&list_type=#attributes.list_type#">
		</cfif>
		<cfif isdefined('attributes.sort_type') and len(attributes.sort_type)>
			<cfset adres = "#adres#&sort_type=#attributes.sort_type#">
		</cfif>
		<cfif isdefined('attributes.barcod') and len(attributes.barcod)>
			<cfset adres = "#adres#&barcod=#attributes.barcod#">
		</cfif>
		<cfif isdefined('attributes.strategy_type') and len(attributes.strategy_type)>
			<cfset adres = "#adres#&strategy_type=#attributes.strategy_type#">
		</cfif>
		<cfif isdefined('attributes.is_saleable_stock')>
			<cfset adres = "#adres#&is_saleable_stock=#attributes.is_saleable_stock#">
		</cfif>
		<cfif isdefined('attributes.product_types')>
			<cfset adres = "#adres#&product_types=#attributes.product_types#">
		</cfif>
		<cfif isdefined('attributes.shelf_number')>
			<cfset adres = "#adres#&shelf_number=#attributes.shelf_number#">
		</cfif>
		<cfif isdefined('attributes.shelf_number_txt')>
			<cfset adres = "#adres#&shelf_number_txt=#attributes.shelf_number_txt#">
		</cfif>
		<cfif isdefined('attributes.product_brand_id')>
			<cfset adres = "#adres#&product_brand_id=#attributes.product_brand_id#">
		</cfif>
		<cfif isdefined('attributes.product_brand_name')>
			<cfset adres = "#adres#&product_brand_name=#attributes.product_brand_name#">
		</cfif>
		<cfif isdefined('attributes.is_form_submitted')>
			<cfset adres = "#adres#&is_form_submitted=#attributes.is_form_submitted#">
		</cfif>
		<cfif isdefined('attributes.manufacturer_code')>
			<cfset adres = "#adres#&manufacturer_code=#attributes.manufacturer_code#">
		</cfif>
		<cfif isdefined('attributes.property_search_type')>
			<cfset adres = "#adres#&property_search_type=#attributes.property_search_type#">
		</cfif>
		<cf_paging page="#attributes.page#"
			maxrows="#attributes.maxrows#"
			totalrecords="#attributes.totalrecords#"
			startrow="#attributes.startrow#"
			adres="#adres#">
	</cf_box>
</div>
<script type="text/javascript">
	document.getElementById('keyword').focus();
	$( document ).ready(function() {
		$('#gizle_').addClass('hide');
});

	//stock_search.keyword.focus();
	function input_control()
	{
	
		<cfif is_show_detail_search eq 1>
		//if(document.stock_search.amount_flag.value==2)
			//document.stock_search.group_unit_2.checked=false;
		</cfif>
		<cfif not session.ep.our_company_info.unconditional_list>
		if(stock_search.employee.value.length == 0) stock_search.employee_id.value = '';
		if(stock_search.company.value.length == 0) stock_search.company_id.value = '';
		if(stock_search.product_cat.value.length == 0) stock_search.search_product_catid.value = '';
		if (stock_search.amount_flag.options[document.stock_search.amount_flag.selectedIndex].value.length == 0 && stock_search.department_id.value.length == 0 && stock_search.keyword.value.length == 0 && stock_search.barcod.value.length < 7 && (stock_search.product_cat.value.length == 0 || stock_search.search_product_catid.value.length == 0) && (stock_search.employee_id.value.length == 0 || stock_search.employee.value.length == 0) && (stock_search.company_id.value.length == 0 || stock_search.company.value.length == 0) && (stock_search.stock_code.value.length == 0) && (stock_search.ozel_kod.value.length == 0)) 
		{
			alert("<cf_get_lang dictionary_id='58950.En az bir alanda filtre etmelisiniz'> !");
			return false;
		}
		</cfif>
		<cfif is_show_detail_search eq 1>
			return gonder_detail();
		<cfelse>
			return true;;
		</cfif>
	}
	function show_strategy_type()
	{
		if(document.stock_search.amount_flag.options[document.stock_search.amount_flag.selectedIndex].value==2)
		{
			document.stock_search.strategy_type.style.display="";
		}	
		else
		{
			document.stock_search.strategy_type.style.display='none';
		}
	}
	function show_shelf()
	{
		if(document.stock_search.list_type.value==4)
		{
			is_shelf_1.style.display="";
			document.getElementById("item-lotno_filter").style.display = "none";	
			document.getElementById("item-spect_name").style.display = "none";	
		}
		else if(document.stock_search.list_type.value==5)
		{
			document.getElementById("item-lotno_filter").style.display = "";
			document.getElementById("item-spect_name").style.display = "none";
			is_shelf_1.style.display="none";
		}
		else if(document.stock_search.list_type.value==2)
		{
			document.getElementById("item-spect_name").style.display = "";
			document.getElementById("item-lotno_filter").style.display = "none";
			is_shelf_1.style.display="none";
		}
		else
		{
			is_shelf_1.style.display="none";
			document.getElementById("item-lotno_filter").style.display = "none";
			document.getElementById("item-spect_name").style.display = "none";			
		}
	}

	function open_spec()
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_spect_main&field_name=spect_main_name&field_main_id=spect_main_id','list')
	}

	function connectAjax(crtrow,prod_id,stock_id,spect_main_id)
	{
		if(spect_main_id == undefined)
		var spect_main_id = 0;
		var dept_loc_info='';
		var dept_loc_info_stock='';
		<cfif isdefined('x_dsp_orders_by_location') and x_dsp_orders_by_location eq 1>
			if(document.stock_search.department_id.value!='')
				var dept_loc_info=document.stock_search.department_id.value;
		</cfif>
		<cfif isdefined('x_dsp_stocks_by_location') and x_dsp_stocks_by_location eq 1>
			if(document.stock_search.department_id.value!='')
				var dept_loc_info_stock=document.stock_search.department_id.value;
		</cfif>
		var load_url_ = '<cfoutput>#request.self#?fuseaction=objects.emptypopup_ajax_product_stock_info&is_calc_row_=1<cfif isdefined('x_show_all_order_row_types') and x_show_all_order_row_types eq 0>&x_show_all_order_row_types=0</cfif><cfif isdefined('x_show_serial_stock') and x_show_serial_stock eq 1>&x_show_serial_stock=1</cfif><cfif isdefined('x_show_lot_stock') and x_show_lot_stock eq 1>&x_show_lot_stock=1</cfif></cfoutput>&show_stock_order&pid='+prod_id+'&sid='+ stock_id+'&type=1&spect_main_id='+ spect_main_id+'&crtrow='+crtrow+'&dept_loc_info_stock_='+dept_loc_info_stock+'&dept_loc_info_='+dept_loc_info;
		AjaxPageLoad(load_url_,'DISPLAY_ORDER_STOCK_INFO'+crtrow,1);
	}
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">