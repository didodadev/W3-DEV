<cf_get_lang_set module_name="product">
<cf_xml_page_edit default_value="0" fuseact="product.list_product">

<cfparam name="attributes.price_catid" default="-2">
<cfparam name="attributes.category_name" default="">
<cfparam name="attributes.cat" default="">
<cfparam name="attributes.brand_id" default="">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.cat_id" default="">
<cfparam name="attributes.short_code_id" default="">
<cfparam name="attributes.stock_id" default="">
<cfparam name="attributes.product_stages" default="">
<cfparam name="attributes.sort_type" default="0">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.list_variation_id" default="">
<cfparam name="attributes.list_property_value" default="">
<cfparam name="attributes.list_property_id" default="">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.allSelectDemand" default="">
<cfparam name="attributes.market_place" default="">

<cfif not (isDefined('attributes.maxrows') and isNumeric(attributes.maxrows))>
  <cfset attributes.maxrows = session.ep.maxrows>
</cfif>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfquery name="get_process_type" datasource="#dsn#">
	SELECT
        CASE
        	WHEN LEN(ITEM) > 0 THEN ITEM
            ELSE PTR.STAGE
        END AS STAGE,
		PTR.PROCESS_ROW_ID 
	FROM
		PROCESS_TYPE_ROWS PTR
        	LEFT JOIN SETUP_LANGUAGE_INFO SLI ON SLI.UNIQUE_COLUMN_ID = PTR.PROCESS_ROW_ID
            AND SLI.COLUMN_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="STAGE">
            AND SLI.TABLE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="PROCESS_TYPE_ROWS">
            AND SLI.LANGUAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.language#">,
		PROCESS_TYPE_OUR_COMPANY PTO,
		PROCESS_TYPE PT
	WHERE
		PT.IS_ACTIVE = 1 AND
		PT.PROCESS_ID = PTR.PROCESS_ID AND
		PT.PROCESS_ID = PTO.PROCESS_ID AND
		PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
		PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#listfirst(attributes.fuseaction,'.')#.list_product%">
	ORDER BY
		PTR.LINE_NUMBER
</cfquery>


<style>
    #mp-form label, #mp-form input { display:block; margin:0; }
    #mp-form input.number { margin-bottom:12px; width:95%; padding: .4em; }
    #mp-form select { margin-bottom:12px; width:95%; padding: .4em; }
    fieldset { padding:0; border:0; margin-top:25px; }
    #mp-form h1 { font-size: 1.2em; margin: .6em 0; }
    .ui-dialog .ui-state-error { padding: .3em; }
    .validateTips { border: 1px solid transparent; padding: 0.3em; }
</style>
<cfscript>
	get_product.recordcount=0;
	get_product.query_count=0;
	
	if (session.ep.our_company_info.unconditional_list)
	{
		if (isdefined("attributes.is_form_submitted"))
		{
			get_product_list_action = createObject("component", "AddOns.protein.cfc.get_product");
			get_product_list_action.dsn3 = dsn3;
			get_product_list_action.dsn1 = dsn1;
			get_product_list_action.dsn1_alias = dsn1_alias;
			get_product_list_action.dsn_alias = dsn_alias;
            
			GET_PRODUCT = get_product_list_action.get_product2_
			(
				price_catid : '#iif(isdefined("attributes.price_catid"),"attributes.price_catid",DE(""))#',
				product_status : '#iif(isdefined("attributes.product_status"),"attributes.product_status",DE(""))#',
				product_name : '#IIf(IsDefined("attributes.product_name"),"attributes.product_name",DE(""))#',
				product_types : '#iif(isdefined("attributes.product_types"),"attributes.product_types",DE(""))#',
				product_code : '#iif(isdefined("attributes.product_code"),"attributes.product_code",DE(""))#',
				product_detail : '#iif(isdefined("attributes.product_detail"),"attributes.product_detail",DE(""))#',
				pos_code : '#iif(isdefined("attributes.pos_code"),"attributes.pos_code",DE(""))#',
				user_friendly_url : '#iif(isdefined("attributes.user_friendly_url"),"attributes.user_friendly_url",DE(""))#',
				company_stock_code : '#iif(isdefined("attributes.company_stock_code"),"attributes.company_stock_code",DE(""))#',
				company_product_name : '#iif(isdefined("attributes.company_product_name"),"attributes.company_product_name",DE(""))#',
				barcode : '#iif(isdefined("attributes.barcode"),"attributes.barcode",DE(""))#',
				manufact_code : '#iif(isdefined("attributes.manufact_code"),"attributes.manufact_code",DE(""))#',
				product_stages : '#iif(isdefined("attributes.product_stages"),"attributes.product_stages",DE(""))#',
				record_emp_id : '#iif(isdefined("attributes.record_emp_id"),"attributes.record_emp_id",DE(""))#',
				company_id : '#iif(isdefined("attributes.company_id"),"attributes.company_id",DE(""))#',
				brand_id : '#iif(isdefined("attributes.brand_id"),"attributes.brand_id",DE(""))#',
				keyword : '#IIf(IsDefined("attributes.keyword"),"attributes.keyword",DE(""))#',
				market_place : '#IIf(IsDefined("attributes.market_place"),"attributes.market_place",DE(""))#',
				brand_name : '#iif(isdefined("attributes.brand_name"),"attributes.brand_name",DE(""))#',
				short_code_id : '#iif(isdefined("attributes.short_code_id"),"attributes.short_code_id",DE(""))#', 
				short_code_name : '#iif(isdefined("attributes.short_code_name"),"attributes.short_code_name",DE(""))#',
				cat : '#iif(isdefined("attributes.cat"),"attributes.cat",DE(""))#',
				category_name : '#iif(isdefined("attributes.category_name"),"attributes.category_name",DE(""))#',
				special_code : '#iif(isdefined("attributes.special_code"),"attributes.special_code",DE(""))#',
				list_property_id : '#iif(isdefined("attributes.list_property_id"),"attributes.list_property_id",DE(""))#',
				list_variation_id : '#iif(isdefined("attributes.list_variation_id"),"attributes.list_variation_id",DE(""))#',
				sort_type : '#iif(isdefined("attributes.sort_type"),"attributes.sort_type",DE(""))#',
				startrow : '#iif(isdefined("attributes.startrow"),"attributes.startrow",DE(""))#',
				BARCODE1 : '#IIf(IsDefined("attributes.BARCODE1"),"attributes.BARCODE1",DE(""))#',
				PRODUCT_NAME1 : '#IIf(IsDefined("attributes.PRODUCT_NAME1"),"attributes.PRODUCT_NAME1",DE(""))#',
				SPECIAL_CODE1 : '#iif(isdefined("attributes.SPECIAL_CODE1"),"attributes.SPECIAL_CODE1",DE(""))#',
				MANUFACT_CODE1 : '#iif(isdefined("attributes.MANUFACT_CODE1"),"attributes.MANUFACT_CODE1",DE(""))#',
				USER_FRIENDLY_URL1 : '#iif(isdefined("attributes.USER_FRIENDLY_URL1"),"attributes.USER_FRIENDLY_URL1",DE(""))#',
				PRODUCT_CODE1 : '#iif(isdefined("attributes.PRODUCT_CODE1"),"attributes.PRODUCT_CODE1",DE(""))#',
				PRODUCT_DETAIL1 : '#iif(isdefined("attributes.PRODUCT_DETAIL1"),"attributes.PRODUCT_DETAIL1",DE(""))#',
				COMPANY_STOCK_CODE1 : '#iif(isdefined("attributes.COMPANY_STOCK_CODE1"),"attributes.COMPANY_STOCK_CODE1",DE(""))#',
				COMPANY_PRODUCT_NAME1 : '#iif(isdefined("attributes.COMPANY_PRODUCT_NAME1"),"attributes.COMPANY_PRODUCT_NAME1",DE(""))#',					
				x_filter_add_info : '#iif(isdefined("x_filter_add_info"),"x_filter_add_info",DE(""))#',
				maxrows : '#iif(isdefined("attributes.maxrows"),"attributes.maxrows",DE(""))#'
			);
			
			arama_yapilmali=0;
		}
		else
		{
			get_product.recordcount=0;
    	    get_product.query_count=0;
			arama_yapilmali=1;
		}
	}
	else
	{
		if(isdefined("attributes.is_form_submitted") and 
		(
			(isdefined("attributes.special_code") and len(attributes.special_code)) or
			(isdefined("attributes.product_name") and len(attributes.product_name)) or
			(isdefined("attributes.barcode") and len(attributes.barcode)) or
			(isdefined("attributes.product_code") and len(attributes.product_code)) or
			(isdefined("attributes.manufact_code") and len(attributes.manufact_code)) or
			(isdefined("attributes.product_detail") and len(attributes.product_detail)) or
			(isdefined("attributes.user_friendly_url") and len(attributes.user_friendly_url)) or
			(isdefined("attributes.company_stock_code") and len(attributes.company_stock_code)) or
			(isdefined("attributes.company_product_name") and len(attributes.company_product_name)) or 
			(isdefined("attributes.cat") and len(attributes.cat)) or 
			(isdefined("attributes.brand_id") and len(attributes.brand_id) and isdefined("attributes.brand_name") and len(attributes.brand_name)) or 
			(isdefined("attributes.short_code_id") and len(attributes.short_code_id) and isdefined("attributes.short_code_name") and len(attributes.short_code_name)) or 
			(isdefined("attributes.pos_code") and len(attributes.pos_code) and isdefined("attributes.pos_manager") and len(attributes.pos_manager)) or
			(isdefined("attributes.record_pos_code") and len(attributes.record_pos_code) and isdefined("attributes.record_pos_manager") and len(attributes.record_pos_manager)) or
			(isdefined("attributes.company_id") and len(attributes.company_id) and isdefined("attributes.company") and len(attributes.company))
		))
		{
			get_product_list_action = createObject("component", "V16.add_options.cfc.get_product");
            get_product_list_action.dsn3 = dsn3;
            get_product_list_action.dsn1 = dsn1;
            get_product_list_action.dsn1_alias = dsn1_alias;
            get_product_list_action.dsn_alias = dsn_alias;

			GET_PRODUCT = get_product_list_action.get_product2_
			(
				price_catid : '#iif(isdefined("attributes.price_catid"),"attributes.price_catid",DE(""))#',
				product_status : '#iif(isdefined("attributes.product_status"),"attributes.product_status",DE(""))#',
				product_name : '#IIf(IsDefined("attributes.product_name"),"attributes.product_name",DE(""))#',
				product_types : '#iif(isdefined("attributes.product_types"),"attributes.product_types",DE(""))#',
				product_code : '#iif(isdefined("attributes.product_code"),"attributes.product_code",DE(""))#',
				product_detail : '#iif(isdefined("attributes.product_detail"),"attributes.product_detail",DE(""))#',
				user_friendly_url : '#iif(isdefined("attributes.user_friendly_url"),"attributes.user_friendly_url",DE(""))#',
				company_stock_code : '#iif(isdefined("attributes.company_stock_code"),"attributes.company_stock_code",DE(""))#',
				company_product_name : '#iif(isdefined("attributes.company_product_name"),"attributes.company_product_name",DE(""))#',
				barcode : '#iif(isdefined("attributes.barcode"),"attributes.barcode",DE(""))#',
				manufact_code : '#iif(isdefined("attributes.manufact_code"),"attributes.manufact_code",DE(""))#',
				pos_code : '#iif(isdefined("attributes.pos_code"),"attributes.pos_code",DE(""))#',
				product_stages : '#iif(isdefined("attributes.product_stages"),"attributes.product_stages",DE(""))#',
				record_emp_id : '#iif(isdefined("attributes.record_emp_id"),"attributes.record_emp_id",DE(""))#',
				company_id : '#iif(isdefined("attributes.company_id"),"attributes.company_id",DE(""))#',
				brand_id : '#iif(isdefined("attributes.brand_id"),"attributes.brand_id",DE(""))#',
				brand_name : '#iif(isdefined("attributes.brand_name"),"attributes.brand_name",DE(""))#',
				short_code_id : '#iif(isdefined("attributes.short_code_id"),"attributes.short_code_id",DE(""))#', 
				short_code_name : '#iif(isdefined("attributes.short_code_name"),"attributes.short_code_name",DE(""))#',
				cat : '#iif(isdefined("attributes.cat"),"attributes.cat",DE(""))#',
				category_name : '#iif(isdefined("attributes.category_name"),"attributes.category_name",DE(""))#',
				list_property_id : '#iif(isdefined("attributes.list_property_id"),"attributes.list_property_id",DE(""))#',
				list_variation_id : '#iif(isdefined("attributes.list_variation_id"),"attributes.list_variation_id",DE(""))#',
				sort_type : '#iif(isdefined("attributes.sort_type"),"attributes.sort_type",DE(""))#',
				market_place : '#IIf(IsDefined("attributes.market_place"),"attributes.market_place",DE(""))#',
				startrow : '#iif(isdefined("attributes.startrow"),"attributes.startrow",DE(""))#',
				maxrows : '#iif(isdefined("attributes.maxrows"),"attributes.maxrows",DE(""))#'
			);
			arama_yapilmali=0;
		}
		else
		{
			get_product.recordcount=0;
			get_product.query_count =0;
			arama_yapilmali=1;
		}
	}
</cfscript>

<cfparam name="attributes.totalrecords" default='#get_product.query_count#'>
<cfquery name="GET_COMPETITIVE_LIST" datasource="#DSN3#">
	SELECT COMPETITIVE_ID FROM PRODUCT_COMP_PERM WHERE POSITION_CODE = #session.ep.position_code#
</cfquery>
<cfquery name="get_market_place" datasource="#dsn#">
	SELECT * FROM MARKET_PLACE_SETTINGS
</cfquery>
<cfset COMPETITIVE_LIST = ValueList(get_competitive_list.competitive_id)>
<cfinclude template="../../../V16/product/query/get_price_cat.cfm">
<cfform name="search_product" method="post" action="#request.self#?fuseaction=#url.fuseaction#">
<input type="hidden" name="list_property_id" id="list_property_id" value="<cfif isdefined("attributes.list_property_id")><cfoutput>#attributes.list_property_id#</cfoutput></cfif>">
<input type="hidden" name="list_variation_id" id="list_variation_id" value="<cfif isdefined("attributes.list_variation_id")><cfoutput>#attributes.list_variation_id#</cfoutput></cfif>">
<input type="hidden" name="list_property_value" id="list_property_value" value="<cfif isdefined("attributes.list__property_value")><cfoutput>#attributes.list__property_value#</cfoutput></cfif>">
<input name="is_form_submitted" id="is_form_submitted" type="hidden" value="1">
   <cf_big_list_search title="#getLang('main',152)#" collapsed="1">
		<cf_big_list_search_area>
        	<div class="row">
                <div class="col col-12 form-inline">
                    <div class="form-group">
                        <div class="input-group">
                        	<cfsavecontent variable="key_title"><cf_get_lang_main no='245.Ürün'>,<cf_get_lang_main no='221.Barkod'>,<cf_get_lang_main no='377.Ozel Kod'>,<cf_get_lang_main no='222.Üretici Kodu'>,<cf_get_lang no='1009.Kullanıcı Dostu URL'>,<cf_get_lang_main no='1388.Ürün Kodu'>,<cf_get_lang_main no='245.Ürün'> <cf_get_lang_main no='359.Detay'>,<cf_get_lang no='114.Üye Stok Kodu'>,<cf_get_lang_main no='246.Üye'><cf_get_lang_main no='809.Ürün Adı'> Alanlarında ; ile Arama Yapabilirsiniz!</cfsavecontent>
                    		<cf_wrk_search_input name="keyword" id="keyword" value="#attributes.keyword#" title="#key_title#" style="width:140px;" checkbox="Ürün Adı,Barkod No,Özel Kod,Üretici Kodu,Kullanıcı Dostu Url,Ürün Kodu,Ürün Detay,Üye Stok Kodu,Üye Ürün Adı" columnlist="PRODUCT_NAME1,BARCODE1,SPECIAL_CODE1,MANUFACT_CODE1,USER_FRIENDLY_URL1,PRODUCT_CODE1,PRODUCT_DETAIL1,COMPANY_STOCK_CODE1,COMPANY_PRODUCT_NAME1">
                        </div>
                    </div>
                    <div class="form-group">
                    	<div class="input-group">
                        	<select name="price_catid" id="price_catid" style="width:200px;">
                            <cfif session.ep.isBranchAuthorization eq 0>
                                <cfif attributes.price_catid is "-1">
                                    <option value="-1" selected><cf_get_lang_main no='1310.Standart Alış'></option>
                                    <option value="-2"><cf_get_lang_main no='1309.Standart Satış'></option>
                                <cfelse>
                                    <option value="-1"><cf_get_lang_main no='1310.Standart Alış'></option>
                                    <option value="-2" selected><cf_get_lang_main no='1309.Standart Satış'></option>
                                </cfif>
                            <cfelse>
                                <cfif attributes.price_catid is "-2">
                                    <option value="-2" selected><cf_get_lang_main no='1309.Standart Satış'></option>
                                <cfelse>
                                    <option value="-2"><cf_get_lang_main no='1309.Standart Satış'></option>
                                </cfif>
                                </cfif>
                                <cfoutput query="get_price_cat"> 
                                    <option value="#price_catid#"<cfif (price_catid is attributes.price_catid)> selected</cfif>>#price_cat#</option>
                                </cfoutput>
                            </select>
                        </div>
                    </div>
                    <div class="form-group">
                    	<div class="input-group">
                        	<select name="product_stages" id="product_stages" style="width:100px;">
                                <option value=""><cf_get_lang_main no='1447.Süreç'></option>
                                <cfoutput query="get_process_type">
                                <option value="#process_row_id#"<cfif attributes.product_stages eq process_row_id>selected</cfif>>#stage#</option>
                                </cfoutput>
                            </select>
                        </div>
                    </div>
                    <div class="form-group">
                    	<div class="input-group">
                        	<select name="product_status" id="product_status" style="width:50px;">
                                <option value="1"<cfif isDefined("attributes.product_status") and (attributes.product_status eq 1)> selected</cfif>><cf_get_lang_main no='81.Aktif'></option>
                                <option value="0"<cfif isDefined("attributes.product_status") and (attributes.product_status eq 0)> selected</cfif>><cf_get_lang_main no='82.Pasif'></option>
                                <option value="2"<cfif isDefined("attributes.product_status") and (attributes.product_status eq 2)> selected</cfif>><cf_get_lang_main no='296.Tümü'></option>
                            </select>
                        </div>
                    </div>
                    <div class="form-group">
                    	<div class="input-group x-3_5">
                        	<cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
                        	<cfinput type="text" name="maxrows" value="#attributes.maxrows#" validate="integer" range="1,999" required="yes" onKeyUp="isNumber(this)" message="#message#" maxlength="3" style="width:25px;">
                        </div>
                    </div>
                    <div class="form-group">
                    	<div class="input-group">
                            <cf_wrk_search_button search_function='input_control()'>
							
                    	</div>
                    </div>
               </div>
           </div>
			<cfparam name="attributes.mode" default="6">
        </cf_big_list_search_area>
        <cf_big_list_search_detail_area>
			<div id="detail_search_div" style="display:table-row;"></div>
            <div class="row">
            	<div class="col col-12 uniqueRow">
					<div class="row" type="row">
                    	<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                        	<div class="form-group" id="item-brand_id">
                            	<label class="col col-12"><cf_get_lang_main no='1435.Marka'></label>
                                <div class="col col-12">
                                	<cf_wrkproductbrand
                                    width="100"
                                    compenent_name="getProductBrand"               
                                    boxwidth="240"
                                    boxheight="150"
                                    brand_id="#attributes.brand_id#">
                                </div>
                            </div>
                            <div class="form-group" id="item-short_code_id">
                            	<label class="col col-12"><cf_get_lang_main no='813.Model'></label>
                                <div class="col col-12">
                                	<cf_wrkproductmodel
                                    returninputvalue="short_code_id,short_code_name"
                                    returnqueryvalue="MODEL_ID,MODEL_NAME"
                                    width="100"
                                    fieldname="short_code_name"
                                    fieldid="short_code_id"
                                    compenent_name="getProductModel"            
                                    boxwidth="240"
                                    boxheight="150"                        
                                    model_id="#attributes.short_code_id#">
                                </div>
                            </div>
                           <div class="form-group" id="item-product_types">
                            	<label class="col col-12"><cf_get_lang_main no='245.Ürün'> <cf_get_lang no='11.Bilgileri'></label>
                                <div class="col col-12">
                                    <select name="product_types" id="product_types" style="width:150px;">
                                        <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                        <option value="5"<cfif isDefined("attributes.product_types") and (attributes.product_types eq 5)> selected</cfif>><cf_get_lang no='159.Tedarik Edilmiyor'></option>
                                        <option value="1"<cfif isDefined("attributes.product_types") and (attributes.product_types eq 1)> selected</cfif>><cf_get_lang no='50.Tedarik Ediliyor'></option>
                                        <option value="2"<cfif isDefined("attributes.product_types") and (attributes.product_types eq 2)> selected</cfif>><cf_get_lang no='79.Hizmetler'></option>
                                        <option value="16"<cfif isDefined("attributes.product_types") and (attributes.product_types eq 16)> selected</cfif>><cf_get_lang no='44.Envantere Dahil'></option>
                                        <option value="3"<cfif isDefined("attributes.product_types") and (attributes.product_types eq 3)> selected</cfif>><cf_get_lang no='412.Mallar'></option>
                                        <option value="4"<cfif isDefined("attributes.product_types") and (attributes.product_types eq 4)> selected</cfif>><cf_get_lang no='55.Terazi'></option>
                                        <option value="6"<cfif isDefined("attributes.product_types") and (attributes.product_types eq 6)> selected</cfif>><cf_get_lang no='46.Üretiliyor'></option>
                                        <option value="13"<cfif isDefined("attributes.product_types") and (attributes.product_types eq 13)> selected</cfif>><cf_get_lang no='545.Maliyet Takip Ediliyor'></option>
                                        <option value="15"<cfif isDefined("attributes.product_types") and (attributes.product_types eq 15)> selected</cfif>><cf_get_lang no="243.Kalite"> <cf_get_lang no="164.Takip Ediliyor"></option>
                                        <option value="7"<cfif isDefined("attributes.product_types") and (attributes.product_types eq 7)> selected</cfif>><cf_get_lang no='546.Seri No Takip'></option>
                                        <option value="8"<cfif isDefined("attributes.product_types") and (attributes.product_types eq 8)> selected</cfif>><cf_get_lang no='456.Karma Koli'></option>
                                        <option value="9"<cfif isDefined("attributes.product_types") and (attributes.product_types eq 9)> selected</cfif>><cf_get_lang_main no='667.İnternet'></option>
                                        <option value="12"<cfif isDefined("attributes.product_types") and (attributes.product_types eq 12)> selected</cfif>><cf_get_lang_main no='607.Extranet'></option>
                                        <option value="10"<cfif isDefined("attributes.product_types") and (attributes.product_types eq 10)> selected</cfif>><cf_get_lang no='52.Özelleştirilebilir'></option>
                                        <option value="11"<cfif isDefined("attributes.product_types") and (attributes.product_types eq 11)> selected</cfif>><cf_get_lang no='547.Sıfır Stok İle Çalış'></option>
                                        <option value="14"<cfif isDefined("attributes.product_types") and (attributes.product_types eq 14)> selected</cfif>><cf_get_lang no='48.Satışta'></option>
                                        <option value="18"<cfif isDefined("attributes.product_types") and (attributes.product_types eq 18)> selected</cfif>><cf_get_lang no='909.Stoklarla Sınırlı'></option>
                                      	<option value="17"<cfif isDefined("attributes.product_types") and (attributes.product_types eq 17)> selected</cfif>><cf_get_lang no='144.Lot No'></option>
                                    </select>
                                 </div>
                            </div>
                        </div>
                        <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                        	<div class="form-group" id="item-cat_id">
                            	<label class="col col-12"><cf_get_lang_main no='74.Kategori'></label>
                                <div class="col col-12">
                                	<div class="input-group">
                                    	<input type="hidden" name="cat_id" id="cat_id" value="<cfif len(attributes.cat_id) and len(attributes.category_name)><cfoutput>#attributes.cat_id#</cfoutput></cfif>">
                                        <input type="hidden" name="cat" id="cat" value="<cfif len(attributes.cat) and len(attributes.category_name)><cfoutput>#attributes.cat#</cfoutput></cfif>">
                                        <input name="category_name" type="text" id="category_name" style="width:100px;" onfocus="AutoComplete_Create('category_name','PRODUCT_CATID,PRODUCT_CAT,HIERARCHY','PRODUCT_CAT_NAME','get_product_cat','','PRODUCT_CATID,HIERARCHY','cat_id,cat','','3','200','','1');" value="<cfif len(attributes.category_name)><cfoutput>#attributes.category_name#</cfoutput></cfif>" autocomplete="off">
                                        <span class="input-group-addon icon-ellipsis btnPointer" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_product_cat_names&is_sub_category=1&field_id=search_product.cat_id&field_code=search_product.cat&field_name=search_product.category_name</cfoutput>','list');"></span>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group" id="item-pos_code">
                            	<label class="col col-12"><cf_get_lang_main no='132.Sorumlu'></label>
                                <div class="col col-12">
                                	<div class="input-group">
                                    	<input type="hidden" name="pos_code"  id="pos_code" value="<cfif isdefined("attributes.pos_code")><cfoutput>#attributes.pos_code#</cfoutput></cfif>">
										<input name="pos_manager" type="text" id="pos_manager" style="width:100px;" onfocus="AutoComplete_Create('pos_manager','FULLNAME','FULLNAME','get_emp_pos','','POSITION_CODE','pos_code','','3','130');" value="<cfif isdefined("attributes.pos_code") and len(attributes.pos_code)><cfoutput>#attributes.pos_manager#</cfoutput></cfif>" maxlength="255" autocomplete="off">
                                        <span class="input-group-addon icon-ellipsis btnPointer" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_code=search_product.pos_code&field_name=search_product.pos_manager<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&select_list=1&is_form_submitted=1&keyword='+encodeURIComponent(document.search_product.pos_manager.value),'list','popup_list_positions');"></span>
                                    </div>
                                </div>
                            </div>
                             <div class="form-group" id="item-sort_type">
                            	<label class="col col-12"><cf_get_lang_main no='1512.Sıralama'></label>
                                <div class="col col-12">
                                	<select name="sort_type" id="sort_type" style="width:150px;">
                                        <option value="0" <cfif attributes.sort_type eq 0>selected</cfif>><cf_get_lang no='945.Ürün Adına Göre Artan'></option>
                                        <option value="1" <cfif attributes.sort_type eq 1>selected</cfif>><cf_get_lang no='946.Ürün Adına Göre Azalan'></option>
                                        <option value="2" <cfif attributes.sort_type eq 2>selected</cfif>><cf_get_lang no='947.Stok Koduna Göre Artan'></option>
                                        <option value="3" <cfif attributes.sort_type eq 3>selected</cfif>><cf_get_lang no='948.Stok Koduna Göre Azalan'></option>
                                        <option value="4" <cfif attributes.sort_type eq 4>selected</cfif>><cf_get_lang no='949.Özel Koda Göre Artan'></option>
                                        <option value="5" <cfif attributes.sort_type eq 5>selected</cfif>><cf_get_lang no='950.Özel Koda Göre Azalan'></option>
                                        <option value="6" <cfif attributes.sort_type eq 6>selected</cfif>><cf_get_lang no='951.Barkoda Göre Artan'></option>
                                        <option value="7" <cfif attributes.sort_type eq 7>selected</cfif>><cf_get_lang no='952.Barkoda Göre Azalan'></option>
                                        <option value="8" <cfif attributes.sort_type eq 8>selected</cfif>><cf_get_lang no='953.SD Tarihine Göre Artan'></option>
                                        <option value="9" <cfif attributes.sort_type eq 9>selected</cfif>><cf_get_lang no='954.SD Tarihine Göre Azalan'></option>
                                    </select>
                                </div>
                            </div>
                        </div>
                        <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
                        	<div class="form-group" id="item-record_emp_id">
                            	<label class="col col-12"><cf_get_lang_main no='487.Kaydeden'></label>
                                <div class="col col-12">
                                	<div class="input-group">
                                    	<input type="hidden" name="record_emp_id" id="record_emp_id" value="<cfif isdefined("attributes.record_emp_id")><cfoutput>#attributes.record_emp_id#</cfoutput></cfif>">
										<input name="record_emp_name" type="text" id="record_emp_name" style="width:100px;" onfocus="AutoComplete_Create('record_emp_name','FULLNAME','FULLNAME','get_emp_pos','','EMPLOYEE_ID','record_emp_id','','3','130');" value="<cfif isdefined("attributes.record_emp_id") and len(attributes.record_emp_id)><cfoutput>#attributes.record_emp_name#</cfoutput></cfif>" maxlength="255" autocomplete="off">
                                        <span class="input-group-addon icon-ellipsis btnPointer" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=search_product.record_emp_id&field_name=search_product.record_emp_name<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&select_list=1&is_form_submitted=1&keyword='+encodeURIComponent(document.search_product.record_emp_name.value),'list','popup_list_positions');"></span>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group" id="item-record_emp_id">
                            	<label class="col col-12"><cf_get_lang_main no='1736.Tedarikçi'></label>
                                <div class="col col-12">
                                	<div class="input-group">
                                    	<input type="hidden" name="company_id" id="company_id" value="<cfif isdefined("attributes.company_id")><cfoutput>#attributes.company_id#</cfoutput></cfif>">
										<input name="company" type="text" id="company" style="width:100px;" onfocus="AutoComplete_Create('company','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1\',0,0','COMPANY_ID','company_id','','3','150');" value="<cfif isdefined("attributes.company_id") and len(attributes.company_id)><cfoutput>#get_par_info(attributes.company_id,1,1,0)#</cfoutput></cfif>" autocomplete="off">
                                        <span class="input-group-addon icon-ellipsis btnPointer" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_comp_name=search_product.company&field_comp_id=search_product.company_id<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&select_list=2&keyword='+encodeURIComponent(document.search_product.company.value),'list','popup_list_pars');"></span>
                                    </div>
                                </div>
                            </div>
							<div class="form-group" id="item-mp_id">
                            	<label class="col col-12">Pazar Yerleri</label>
                                 <div class="col col-12">
                                	<select name="market_place" id="market_place" style="width:150px;">
                                        <option value="">Seçiniz</option>
										<cfoutput query="get_market_place">
                                        <option value="#market_place_id#"<cfif attributes.market_place eq market_place_id>selected</cfif>>#market_place#</option>
                                       </cfoutput>
                                    </select>
                                </div>
                            </div>
                        </div>
                    </div>                
                </div>
            </div>
		</cf_big_list_search_detail_area>
	</cf_big_list_search>
	</cfform>
	<cfset colspan_ = 14>
	<cfif not isdefined("attributes.trail")><cfset colspan_ = colspan_ + 1></cfif>
	<cfform name="send_form_1" id="send_form_1" method="post" action="#request.self#?fuseaction=product.emptypopup_upd_mp_product_detail">
	<cfinput type="hidden" value="" name="action_type">
	<cf_big_list id="list_product_big_list">
        <thead>
            <tr>
                <th width="35"><cf_get_lang_main no='1165.Sıra'></th>
                <th><cf_get_lang_main no='245.Ürün'></th>
                <th><cf_get_lang_main no='1435.Marka'></th>
                <th><cf_get_lang_main no='377.Özel Kod'></th>
                <th><cf_get_lang_main no='106.Stok Kodu'></th>
                <th><cf_get_lang_main no='224.Birim'></th>
                <th><cf_get_lang_main no='227.KDV'></th>
                <th style="text-align:right;" nowrap="nowrap"><cf_get_lang_main no='672.Fiyat'></th>
                <th style="text-align:right;" nowrap="nowrap"><cf_get_lang_main no='672.Fiyat'>(<cf_get_lang no='354.kdv dahil'>)</th>
				<cfif isdefined("attributes.market_place") and len(attributes.market_place)>
                <th>Yayın Durumu</th>
                <th>Yayın Tarihi</th>
                <th>Yayın Bitiş</th>
				</cfif>
				<th class="header_icn_none"><input type="checkbox" name="allSelectDemand" id="allSelectDemand" onclick="wrk_select_all('allSelectDemand','product_id_list');"></th>
            </tr>
        </thead>
		
        <tbody>
            <cfif get_product.recordcount>
                <cfset product_stage_list=''>
                <cfset brand_id_list=''>
                <cfset short_code_id_list=''>
                <cfoutput query="get_product">
                    <cfif len(product_stage) and not listfind(product_stage_list,product_stage)>
                        <cfset product_stage_list=listappend(product_stage_list,product_stage)>
                    </cfif>
                    <cfif len(brand_id) and not listfind(brand_id_list,brand_id)>
                        <cfset brand_id_list=listappend(brand_id_list,brand_id)>
                    </cfif>
                    <cfif len(short_code_id) and not listfind(short_code_id_list,short_code_id)>
                        <cfset short_code_id_list=listappend(short_code_id_list,short_code_id)>
                    </cfif>
                </cfoutput>
                <cfif len(product_stage_list)>
                    <cfset product_stage_list=listsort(product_stage_list,"numeric","ASC",",")>
                    <cfquery name="PROCESS_TYPE_ALL" datasource="#DSN#">
                        SELECT STAGE, PROCESS_ROW_ID FROM PROCESS_TYPE_ROWS WHERE PROCESS_ROW_ID IN (#product_stage_list#) ORDER BY PROCESS_ROW_ID
                    </cfquery>
                    <cfset product_stage_list = listsort(listdeleteduplicates(valuelist(process_type_all.process_row_id,',')),"numeric","ASC",",")>
                </cfif>
                <cfif len(brand_id_list)>
                    <cfset brand_id_list=listsort(brand_id_list,"numeric","ASC",",")>
                    <cfquery name="get_brand" datasource="#DSN1#">
                        SELECT
                        	BRAND_ID,
                            CASE
                                WHEN LEN(SLI.ITEM) > 0 THEN SLI.ITEM
                                ELSE BRAND_NAME
                            END AS BRAND_NAME
                        FROM
                        	#dsn1_alias#.PRODUCT_BRANDS
                            	LEFT JOIN #dsn_alias#.SETUP_LANGUAGE_INFO SLI ON SLI.UNIQUE_COLUMN_ID = BRAND_ID
                                AND SLI.COLUMN_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="BRAND_NAME">
                                AND SLI.TABLE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="PRODUCT_BRANDS">
                                AND SLI.LANGUAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.language#">                       
                        WHERE
                        	BRAND_ID IN (#brand_id_list#) ORDER BY BRAND_ID
                    </cfquery>
                    <cfset brand_id_list = listsort(listdeleteduplicates(valuelist(get_brand.BRAND_ID,',')),"numeric","ASC",",")>
                </cfif>
                <cfif len(short_code_id_list)>
                    <cfset short_code_id_list=listsort(short_code_id_list,"numeric","ASC",",")>
                    <cfquery name="get_model" datasource="#DSN1#">
                        SELECT
                            CASE
                                WHEN LEN(SLI.ITEM) > 0 THEN SLI.ITEM
                                ELSE MODEL_NAME
                            END AS MODEL_NAME,
                            MODEL_ID
                        FROM
                        	#dsn1_alias#.PRODUCT_BRANDS_MODEL
                            	LEFT JOIN #dsn_alias#.SETUP_LANGUAGE_INFO SLI ON SLI.UNIQUE_COLUMN_ID = MODEL_ID
                                AND SLI.COLUMN_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="MODEL_NAME">
                                AND SLI.TABLE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="PRODUCT_BRANDS_MODEL">
                                AND SLI.LANGUAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.language#">                        
                        WHERE
                        	MODEL_ID IN (#short_code_id_list#) ORDER BY MODEL_ID
                    </cfquery>
                    <cfset short_code_id_list = listsort(listdeleteduplicates(valuelist(get_model.MODEL_ID,',')),"numeric","ASC",",")>
                </cfif>
                <cfif isdefined('is_all_barcode') and is_all_barcode eq 1>
                    <cfquery name="GET_ALL_BARCODE" datasource="#dsn3#">
                        SELECT
                            STOCKS.PRODUCT_ID,
                            STOCKS_BARCODES.BARCODE,
                            STOCKS_BARCODES.UNIT_ID
                        FROM 
                            STOCKS_BARCODES,
                            STOCKS 
                        WHERE 
                            STOCKS_BARCODES.STOCK_ID=STOCKS.STOCK_ID AND
                            STOCKS.PRODUCT_ID IN (<cfoutput query="get_product">#PRODUCT_ID#,</cfoutput>0)
                    </cfquery>
                    <cfif GET_ALL_BARCODE.RECORDCOUNT>
                        <cfoutput query="GET_ALL_BARCODE">
                            <cfif not isdefined('list_#PRODUCT_ID#_#UNIT_ID#')><cfset 'list_#PRODUCT_ID#_#UNIT_ID#'=''></cfif>
                            <cfset 'list_#PRODUCT_ID#_#UNIT_ID#'=listappend(evaluate('list_#PRODUCT_ID#_#UNIT_ID#'),BARCODE,',')>
                        </cfoutput>
                    </cfif>
                </cfif>
                <cfif listgetat(attributes.fuseaction,1,'.') is 'sales' or listgetat(attributes.fuseaction,1,'.') is 'purchase'>
                    <cfset fuseaction_info = 'product'>
                <cfelse>
                    <cfset fuseaction_info = listgetat(attributes.fuseaction,1,'.')>
                </cfif>
				<cfoutput>
				
				</cfoutput>
                <cfoutput query="get_product">
                    <tr oncontextmenu="javascript:wrk_right_menu('PRODUCT_ID',#PRODUCT_ID#);return false;"> 
                        <td width="35">#rownum#</td>
                        <td>
							<a href="#request.self#?fuseaction=product.marketplace_product_detail&product_id=#get_product.product_id#" class="tableyazi">#get_product.product_name#</a>
						</td>
                       
                        <td><cfif len(brand_id)>#get_brand.BRAND_NAME[listfind(brand_id_list,brand_id,',')]#</cfif></td>
                        <td>#get_product.product_code_2#</td>
   
                        <td style="mso-number-format:\@;"><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=stock.list_stock&event=det&pid=#get_product.product_id#','wide');" class="tableyazi">#get_product.product_code#</a></td>
                        <td>#get_product.add_unit#</td>
                        <td style="text-align:right;">#tax#</td>
                        <cfif attributes.price_catid is "-1">
                            <td style="text-align:right;"><a href="##" class="tableyazi">#TLFormat(get_product.price,session.ep.our_company_info.purchase_price_round_num)# #get_product.money#</a></td>
                            <td style="text-align:right;"><a href="##" class="tableyazi"><cfif get_product.is_kdv >#TLFormat(get_product.price_kdv,session.ep.our_company_info.purchase_price_round_num)#<cfelse>#TLFormat(get_product.price*(100+get_product.tax)/100,session.ep.our_company_info.purchase_price_round_num)#</cfif> #get_product.money#</a></td>
                        <cfelse>
                            <td style="text-align:right;width:20mm">#TLFormat(get_product.price,2)# #get_product.money#</td>
                            <td style="text-align:right;">
                                <cfif get_product.is_kdv >#TLFormat(get_product.price_kdv,2)#<cfelse>#TLFormat(get_product.price*(100+get_product.tax)/100,2)#</cfif> #get_product.money# 
                                <cfif len(get_product.prod_competitive)>
                                    <cfif listfind(COMPETITIVE_LIST,get_product.prod_competitive,',')>
                                      <cfset str_url_open="product.popup_form_add_product_price&pid=#get_product.product_id[currentrow]#&price_catid=#attributes.price_catid#">
                                    <cfelse>
                                      <cfset str_url_open="product.list_price_change&event=add&pid=#get_product.product_id[currentrow]#&price_catid=#attributes.price_catid#">
                                    </cfif>
                                <cfelse>
                                    <cfset str_url_open="product.list_price_change&event=add&pid=#get_product.product_id[currentrow]#&price_catid=#attributes.price_catid#">
                                </cfif>
                                <!-- sil --><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=#str_url_open#','wide','popup_form_add_product_price');"><img src="/images/plus_thin.gif" align="absbottom" title="<cf_get_lang no='113.Fiyat Ekle'>"></a><!-- sil -->
                            </td>
                        </cfif>
						<cfif isdefined("attributes.market_place") and len(attributes.market_place)>
							<td><cfif IS_PUBLISHED eq 1>Yayında<cfelse>Yayında Değil</cfif></td>
							<td>----</td>
							<td style="text-align:center;">#PUBLISH_DAYS#</td>
						</cfif>
						<td style="text-align:center; width:1%"><input type="checkbox" name="product_id_list" id="product_id_list" value="#product_id#">
                    </tr> 
                </cfoutput>
			        <tr class="total">
                        <td colspan="<cfoutput>#colspan_#</cfoutput>" style="text-align:right">
						<input id="save2MP" value="Pazaryerine Kaydet">
						<input id="publish2MP" value="Pazaryerinde Yayınla">
						<input id="del2MP" value="Yayından Kaldır">
						</td>
                    </tr>
				</form>

				<tr> 
                    <td colspan="<cfoutput>#colspan_#</cfoutput>" height="20"><cfif arama_yapilmali eq 1><cf_get_lang_main no='289.Filtre Ediniz'> !<cfelse><cf_get_lang_main no='72.Kayıt Yok'>!</cfif></td>
                </tr>
            <cfelse>
                <tr> 
                    <td colspan="<cfoutput>#colspan_#</cfoutput>" height="20"><cfif arama_yapilmali eq 1><cf_get_lang_main no='289.Filtre Ediniz'> !<cfelse><cf_get_lang_main no='72.Kayıt Yok'>!</cfif></td>
                </tr>
            </cfif>
        </tbody>
	 
	</cf_big_list></cfform>
	
<div id="success-message" title="Pazaryeri İşlemleri">
<p>
    <span class="ui-icon ui-icon-circle-check" style="float:left; margin:0 7px 50px 0;"></span>
    <span id="mess">İşleminiz <b>başarıyla</b> gerçekleştirildi!</span>
</p>

</div>
<div id="mp-form" title="W3-Pazaryeri">
    <p class="validateTips">Lütfen, seçtiğiniz ürünleri hangi pazaryerinde kaç günlüğüne yayınlatmak için kaydettiğinizi belirtiniz.</p>
    <form>
        <fieldset>
            <label for="name">Pazaryeri</label>
            <select name="mps" id="mps" style="width:150px;">
                <cfoutput query="get_market_place">
                    <option value="#market_place_id#"<cfif attributes.market_place eq market_place_id>selected</cfif>>#market_place#</option>
                </cfoutput>
            </select>
            <label for="list_days">Yayınlanma Zamanı(Gün)</label>
            <input type="number" name="list_days" id="list_days" value="30" class="text ui-widget-content ui-corner-all">

            <!-- Allow form submission with keyboard without duplicating the dialog button -->
            <input type="submit" tabindex="-1" style="position:absolute; top:-1000px">
        </fieldset>
    </form>
</div>
<div id="mp-publish-form" title="W3-Pazaryeri">
    <p class="validateTips">Lütfen, seçtiğiniz ürünleri hangi pazaryerinde yayınlamak istediğinizi belirtiniz.</p>
    <form>
        <fieldset>
            <label for="name">Pazaryeri</label>
            <select name="mps" id="mps" style="width:150px;">
                <cfoutput query="get_market_place">
                    <option value="#market_place_id#"<cfif attributes.market_place eq market_place_id>selected</cfif>>#market_place#</option>
            </cfoutput>
        </select>

        <!-- Allow form submission with keyboard without duplicating the dialog button -->
        <input type="submit" tabindex="-1" style="position:absolute; top:-1000px">
        </fieldset>
    </form>
</div>
<div id="mp-del-form" title="W3-Pazaryeri">
    <p class="validateTips">Lütfen, seçtiğiniz ürünleri hangi pazaryerinden silmek istediğinizi belirtiniz.</p>
    <form>
        <fieldset>
            <label for="name">Pazaryeri</label>
            <select name="mps" id="mps" style="width:150px;">
                <cfoutput query="get_market_place">
                    <option value="#market_place_id#"<cfif attributes.market_place eq market_place_id>selected</cfif>>#market_place#</option>
                </cfoutput>
            </select>

        <!-- Allow form submission with keyboard without duplicating the dialog button -->
        <input type="submit" tabindex="-1" style="position:absolute; top:-1000px">
        </fieldset>
    </form>
</div>
	
<cfset adres = url.fuseaction>
<cfif len(attributes.cat) and len(attributes.category_name)>
  <cfset adres = '#adres#&cat=#attributes.cat#&category_name=#attributes.category_name#'>
</cfif>
<cfif len(attributes.brand_id) and len(attributes.brand_name)>
  <cfset adres = '#adres#&brand_id=#attributes.brand_id#&brand_name=#attributes.brand_name#'>
</cfif>
<cfif isDefined('attributes.short_code_id') and len(attributes.short_code_id)>
  <cfset adres = '#adres#&short_code_id=#attributes.short_code_id#'>
</cfif>
<cfif isDefined('attributes.keyword') and len(attributes.keyword)>
  <cfset adres = "#adres#&keyword=#attributes.keyword#">
</cfif>
<cfif isDefined('attributes.product_code') and len(attributes.product_code)>
  <cfset adres = '#adres#&product_code=#attributes.product_code#'>
</cfif>
<cfif isDefined('attributes.manufact_code') and len(attributes.manufact_code)>
  <cfset adres = '#adres#&manufact_code=#attributes.manufact_code#'>
</cfif>
<cfif isDefined('attributes.barcode') and len(attributes.barcode)>
  <cfset adres = '#adres#&barcode=#attributes.barcode#'>
</cfif>
<cfif isDefined('attributes.product_name') and len(attributes.product_name)>
  <cfset adres = '#adres#&product_name=#attributes.product_name#'>
</cfif>
<cfif isDefined('attributes.product_detail') and len(attributes.product_detail)>
  <cfset adres = '#adres#&product_detail=#attributes.product_detail#'>
</cfif>
<cfif isDefined('attributes.user_friendly_url') and len(attributes.user_friendly_url)>
  <cfset adres = '#adres#&user_friendly_url=#attributes.user_friendly_url#'>
</cfif>
<cfif isDefined('attributes.company_stock_code') and len(attributes.company_stock_code)>
  <cfset adres = '#adres#&company_stock_code=#attributes.company_stock_code#'>
</cfif>
<cfif isDefined('attributes.company_product_name') and len(attributes.company_product_name)>
  <cfset adres = '#adres#&company_product_name=#attributes.company_product_name#'>
</cfif>
<cfif isDefined('attributes.short_code_name') and len(attributes.short_code_name)>
  <cfset adres = '#adres#&short_code_name=#attributes.short_code_name#'>
</cfif>
<cfif isDefined('attributes.pos_code') and len(attributes.pos_code) and isDefined('attributes.pos_manager') and len(attributes.pos_manager)>
  <cfset adres = '#adres#&pos_code=#attributes.pos_code#&pos_manager=#attributes.pos_manager#'>
</cfif>
<cfif isDefined('attributes.record_emp_id') and len(attributes.record_emp_id) and isDefined('attributes.record_emp_name') and len(attributes.record_emp_name)>
  <cfset adres = '#adres#&record_emp_id=#attributes.record_emp_id#&record_emp_name=#attributes.record_emp_name#'>
</cfif>
<cfif isDefined('attributes.company_id') and len(attributes.company_id) and isDefined('attributes.company') and len(attributes.company)>
  <cfset adres = '#adres#&company_id=#attributes.company_id#&company=#attributes.company#'>

</cfif>		
<cfif isDefined('attributes.price_catid') and len(attributes.price_catid)>
  <cfset adres = '#adres#&price_catid=#attributes.price_catid#'>
</cfif>
<cfif isDefined('attributes.product_status') and len(attributes.product_status)>
  <cfset adres = '#adres#&product_status=#attributes.product_status#'>
</cfif>
<cfif isdefined('attributes.product_types') and len(attributes.product_types)>
  <cfset adres = '#adres#&product_types=#attributes.product_types#'>
</cfif>
<cfif isDefined('attributes.employee') and len(attributes.employee)>
  <cfset adres = '#adres#&employee=#attributes.employee#'>
</cfif>
<cfif isDefined('attributes.special_code') and len(attributes.special_code)>
  <cfset adres = '#adres#&special_code=#attributes.special_code#'>
</cfif>
<cfif isDefined('attributes.list_property_id') and len(attributes.list_property_id)>
  <cfset adres = '#adres#&list_property_id=#attributes.list_property_id#'>
</cfif>
<cfif isDefined('attributes.list_property_value') and len(attributes.list_property_value)>
  <cfset adres = '#adres#&list_property_value=#attributes.list_property_value#'>
</cfif>
<cfif len(attributes.product_stages)>
	<cfset adres = '#adres#&product_stages=#attributes.product_stages#'>
</cfif>
<cfif len(attributes.sort_type)>
	<cfset adres = '#adres#&sort_type=#attributes.sort_type#'>
</cfif>
<cfif isdefined("attributes.market_place") and len(attributes.market_place)>
	<cfset adres = '#adres#&market_place=#attributes.market_place#'>
</cfif>
<cfif isDefined('attributes.list_variation_id') and len(attributes.list_variation_id)>
  <cfset adres = '#adres#&list_variation_id=#attributes.list_variation_id#'>
</cfif>	
<cf_paging 
	page="#attributes.page#"
    maxrows="#attributes.maxrows#"
    totalrecords="#attributes.totalrecords#"
    startrow="#attributes.startrow#"
    adres="#adres#&is_form_submitted=1">
<script type="text/javascript">
	function set_act(type)
	{
		document.getElementById('action_type').value = type;
		return true;
	}
	function test(){
	
		if(document.getElementById("pos_manager").value=='')
		{
			$('#pos_code').val('');		
		}
		if(document.getElementById("record_emp_name").value=='')
		{
			$('#record_emp_id').val('');		
		}
	
	}
	function detail_ajax_product()
	{
		AjaxPageLoad('<cfoutput>#request.self#?fuseaction=product.emptypopup_list_product_detail&cat_id=#attributes.cat_id#&category_name=#attributes.category_name#&mode=#attributes.mode#</cfoutput>','detail_search_div',1);
	}
	//document.getElementById('keyword').focus();
	$('#keyword').focus();
	function showInformation(row)
	{
		if(document.getElementById("variation_id"+row).value=='')
			document.getElementById("information_row"+row).style.display='none';
		else
			document.getElementById("information_row"+row).style.display='';
	}

	function input_control()
	{	
		if(search_product.brand_name.value.length == 0) search_product.brand_id.value = '';
		if(search_product.company.value.length == 0) search_product.company_id.value = '';
		if(search_product.pos_manager.value.length == 0) search_product.pos_code.value = '';
		
		<cfif not session.ep.our_company_info.unconditional_list>
			if(search_product.keyword.value.length == 0 && search_product.cat.value.length == 0 &&(search_product.brand_id.value.length == 0 || search_product.brand_name.value.length == 0) && (search_product.pos_code.value.length == 0 || search_product.pos_manager.value.length == 0) && (search_product.company_id.value.length == 0 || search_product.company.value.length == 0) )
			{
				alert("<cf_get_lang_main no='1538.En az bir alanda filtre etmelisiniz '>!");
				return false;
			}		
			else
				return true;
		<cfelse>
			<cfoutput>
				AjaxPageLoad('#request.self#?fuseaction=product.emptypopup_ajax_list_marketplace_products&'+GetFormData(search_product),'body_get_products',1);
			</cfoutput>	
			return false;
		</cfif>
	}
	function connectAjax(div_id)
	{
		<cfoutput>
			AjaxPageLoad('#request.self#?fuseaction=product.emptypopup_ajax_list_marketplace_products<cfif len(attributes.cat_id) and len(attributes.category_name)>&cat_id=#attributes.cat_id#</cfif><cfif len(attributes.list_variation_id)>&list_variation_id=#attributes.list_variation_id#</cfif><cfif len(attributes.list_property_value)>&list_property_value=#attributes.list_property_value#</cfif><cfif len(attributes.list_property_id)>&list_property_id=#attributes.list_property_id#</cfif>',''+div_id+'',1);
		</cfoutput>	
	}
	search_product.list_property_id.value="";
	search_product.list_property_value.value="";
	search_product.list_variation_id.value="";
	
    $( function() {
        var addDialog, publDialog, delDialog, successDialog, currMP, listDays = 0;
        var product_id_list = '';
        currMP = $( "#mps" ), listDays = $( "#list_days" );
        function arrangeProdList() {
            console.log($('[id="product_id_list"]').length + ' ----> ' + $("input[name='product_id_list']:checked").length);
            console.log($("input[name='product_id_list']:checked").val());
            product_id_list = '';
            $("input[name='product_id_list']:checked").each(function() {
                console.log($(this).attr('value'));
                product_id_list += $(this).attr('value') + ',';
            });
            product_id_list = product_id_list.substring(0,product_id_list.length - 1);
            console.log(product_id_list);
        }
		function addProds() {
			console.log('addProds');
            console.log(currMP.val() + ' --- ' + listDays.val());
            $.post( "<cfoutput>#request.self#</cfoutput>?fuseaction=product.emptypopup_upd_mp_product_detail",
                    { product_id_list: product_id_list, currMP: currMP.val(), listDays: listDays.val(), mpProcess: "add" })
                    .done(function( data ) {
                        console.log( "Data Loaded: ", data );
						console.log( "currMP: ", currMP.val() );
                        console.log( "success-message: ", $( "#success-message p span#mess" ).html() );
                         var decoded = $('<div/>').html(data);
                        var theFile = $(decoded.html()).find('div.theFile');
                       if(currMP.val() == 3 && theFile.length) {
                            theFile = theFile[0].innerHTML;
                            $("#success-message p span#mess").html('hepsiburadaya ürünleri girmek için <a href = "' +
                                                                   theFile +
                                                                   '">' + theFile.split('/')[theFile.split('/').length - 1] + '</a> dosyasını indiriniz.');
                        }
                        successDialog.dialog( "open" );
                    });
		}
        function delProds() {
            console.log('delProds');
            console.log(currMP.val());
            $.post( "<cfoutput>#request.self#</cfoutput>?fuseaction=product.emptypopup_upd_mp_product_detail",
                    { product_id_list: product_id_list, currMP: currMP.val(), mpProcess: "del" })
                    .done(function( data ) {
                        console.log( "Data Loaded: ", data );
                        successDialog.dialog( "open" );
                    });
        }
        function publishProds() {
            console.log('publishProds');
            console.log(currMP.val());
            $.post( "<cfoutput>#request.self#</cfoutput>?fuseaction=product.emptypopup_upd_mp_product_detail",
                    { product_id_list: product_id_list, currMP: currMP.val(), mpProcess: "publish" })
                    .done(function( data ) {
                        console.log( "Data Loaded: ", data );
                        successDialog.dialog( "open" );
                    });
        }
        successDialog = $( "#success-message" ).dialog({
            autoOpen: false,
            modal: true,
            buttons: {
                Ok: function() {
                    $( this ).dialog( "close" );
                    addDialog.dialog( "close" );
                    publDialog.dialog( "close" );
                    delDialog.dialog( "close" );
					console.log( "search_product ---- ",  search_product );
                    /*search_product.submit(function( event ) {
                        console.log( "search_product submit is called." );
                        event.preventDefault();
                    });*/
                }
            }
        });
        addDialog = $( "#mp-form" ).dialog({
            autoOpen: false,
            height: 300,
            width: 350,
            modal: true,
            buttons: {
                "Kaydet": addProds,
                Cancel: function() {
                    addDialog.dialog( "close" );
                }
            },
            close: function() {
                console.log( "Close Func" );
            }
        });
        publDialog = $( "#mp-publish-form" ).dialog({
            autoOpen: false,
            height: 300,
            width: 350,
            modal: true,
            buttons: {
                "Kaydet": publishProds,
                Cancel: function() {
                    publDialog.dialog( "close" );
                }
            },
            close: function() {
                console.log( "Publish Close Func" );
            }
        });
        delDialog = $( "#mp-del-form" ).dialog({
            autoOpen: false,
            height: 300,
            width: 350,
            modal: true,
            buttons: {
                "Kaydet": delProds,
                Cancel: function() {
                    delDialog.dialog( "close" );
                }
            },
            close: function() {
                console.log( "Del Close Func" );
            }
        });
        $( "#save2MP" ).button().on( "click", function() {
            arrangeProdList();
            if(product_id_list.length)
                addDialog.dialog( "open" );
        });
        $( "#publish2MP" ).button().on( "click", function() {
            arrangeProdList();
            if(product_id_list.length)
                publDialog.dialog( "open" );
        });
        $( "#del2MP" ).button().on( "click", function() {
            arrangeProdList();
            if(product_id_list.length)
                delDialog.dialog( "open" );
        });
    })
	
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
<cfsetting showdebugoutput="yes">
