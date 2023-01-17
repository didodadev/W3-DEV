<cf_get_lang_set module_name="product">
<cf_xml_page_edit default_value="0" fuseact="product.list_product">
<cfparam name="attributes.cat_id" default="">
<cfif xml_is_extra_detail> <!--- extra detay kontrolü --->
    <cfset get_property = createObject("component", "V16.product.cfc.get_product")>
    <cfset get_property.dsn1 = dsn1>
    <cfset get_property_variation = get_property.get_property_variation( cat_id : attributes.cat_id)>
</cfif>
<cfif isDefined("xml_is_search_filter")>
    <cfset filter_list = "PRODUCT_NAME1,BARCODE1,SPECIAL_CODE1,PRODUCT_DESC,MANUFACT_CODE1,USER_FRIENDLY_URL1,PRODUCT_CODE1,PRODUCT_DETAIL1,COMPANY_STOCK_CODE1,COMPANY_PRODUCT_NAME1">
    <cfset checked_filter ="">
    <cfloop list="#xml_is_search_filter#" index="fi">
        <cfset checked_filter = ListAppend(checked_filter, ListGetAt(filter_list,fi))>
    </cfloop>
</cfif>
<cfif isDefined("attributes.PRODUCT_DESC") and len(attributes.PRODUCT_DESC)>
    <cfif listContains(checked_filter, "PRODUCT_DESC") eq 0>
        <cfset checked_filter = ListAppend(checked_filter, "PRODUCT_DESC")>
    </cfif>
</cfif>
<cfparam name="attributes.watalogy_cat_id" default="">
<cfparam name="attributes.watalogy_cat_name" default="">
<cfparam name="attributes.marketplace_id" default="">
<cfparam name="attributes.marketplace_name" default="">
<cfparam name="attributes.price_catid" default="-2">
<cfparam name="attributes.category_name" default="">
<cfparam name="attributes.cat" default="">
<cfparam name="attributes.brand_id" default="">
<cfparam name="attributes.keyword" default="">

<cfparam name="attributes.short_code_id" default="">
<cfparam name="attributes.stock_id" default="">
<cfparam name="attributes.product_stages" default="">
<cfparam name="attributes.sort_type" default="0">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.list_variation_id" default="">
<cfparam name="attributes.list_property_value" default="">
<cfparam name="attributes.list_property_id" default="">
<cfparam name="attributes.page" default=1>
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
<cfscript>
	get_product.recordcount=0;
	get_product.query_count=0;
	
	if (session.ep.our_company_info.unconditional_list)
	{
		if (isdefined("attributes.is_form_submitted"))
		{
			get_product_list_action = createObject("component", "V16.product.cfc.get_product");
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
                pos_manager : '#iif(isdefined("attributes.pos_manager"),"attributes.pos_manager",DE(""))#',
				user_friendly_url : '#iif(isdefined("attributes.user_friendly_url"),"attributes.user_friendly_url",DE(""))#',
				company_stock_code : '#iif(isdefined("attributes.company_stock_code"),"attributes.company_stock_code",DE(""))#',
				company_product_name : '#iif(isdefined("attributes.company_product_name"),"attributes.company_product_name",DE(""))#',
				barcode : '#iif(isdefined("attributes.barcode"),"attributes.barcode",DE(""))#',
				manufact_code : '#iif(isdefined("attributes.manufact_code"),"attributes.manufact_code",DE(""))#',
				product_stages : '#iif(isdefined("attributes.product_stages"),"attributes.product_stages",DE(""))#',
				record_emp_id : '#iif(isdefined("attributes.record_emp_id"),"attributes.record_emp_id",DE(""))#',
                record_emp_name : '#iif(isdefined("attributes.record_emp_name"),"attributes.record_emp_name",DE(""))#',
				company_id : '#iif(isdefined("attributes.company_id"),"attributes.company_id",DE(""))#',
                company : '#iif(isdefined("attributes.company"),"attributes.company",DE(""))#',
				brand_id : '#iif(isdefined("attributes.brand_id"),"attributes.brand_id",DE(""))#',
				keyword : '#IIf(IsDefined("attributes.keyword"),"attributes.keyword",DE(""))#',
				brand_name : '#iif(isdefined("attributes.brand_name"),"attributes.brand_name",DE(""))#',
				short_code_id : '#iif(isdefined("attributes.short_code_id"),"attributes.short_code_id",DE(""))#', 
				short_code_name : '#iif(isdefined("attributes.short_code_name"),"attributes.short_code_name",DE(""))#',
				cat : '#iif(isdefined("attributes.cat"),"attributes.cat",DE(""))#',
				category_name : '#iif(isdefined("attributes.category_name"),"attributes.category_name",DE(""))#',
                watalogy_cat_id : '#iif(isdefined("attributes.watalogy_cat_id") and isdefined("attributes.watalogy_cat_name") and len(attributes.watalogy_cat_name),"attributes.watalogy_cat_id",DE(""))#',
                marketplace_id : '#iif(isdefined("attributes.marketplace_id") and isdefined("attributes.marketplace_name") and len(attributes.marketplace_name),"attributes.marketplace_id",DE(""))#',
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
                maxrows : '#iif(isdefined("attributes.maxrows"),"attributes.maxrows",DE(""))#',
                PRODUCT_DESC : '#iif(isdefined("attributes.PRODUCT_DESC"),"attributes.PRODUCT_DESC",DE(""))#'
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
            (isdefined("attributes.keyword") and len(attributes.keyword)) or
			(isdefined("attributes.brand_id") and len(attributes.brand_id) and isdefined("attributes.brand_name") and len(attributes.brand_name)) or 
			(isdefined("attributes.short_code_id") and len(attributes.short_code_id) and isdefined("attributes.short_code_name") and len(attributes.short_code_name)) or 
			(isdefined("attributes.pos_code") and len(attributes.pos_code) and isdefined("attributes.pos_manager") and len(attributes.pos_manager)) or
			(isdefined("attributes.record_pos_code") and len(attributes.record_pos_code) and isdefined("attributes.record_pos_manager") and len(attributes.record_pos_manager)) or
			(isdefined("attributes.company_id") and len(attributes.company_id) and isdefined("attributes.company") and len(attributes.company))
		))
		{
			get_product_list_action = createObject("component", "V16.product.cfc.get_product");
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
                pos_manager : '#iif(isdefined("attributes.pos_manager"),"attributes.pos_manager",DE(""))#',
				product_stages : '#iif(isdefined("attributes.product_stages"),"attributes.product_stages",DE(""))#',
				record_emp_id : '#iif(isdefined("attributes.record_emp_id"),"attributes.record_emp_id",DE(""))#',
                record_emp_name : '#iif(isdefined("attributes.record_emp_name"),"attributes.record_emp_name",DE(""))#',
				company_id : '#iif(isdefined("attributes.company_id"),"attributes.company_id",DE(""))#',
                company : '#iif(isdefined("attributes.company"),"attributes.company",DE(""))#',
                brand_id : '#iif(isdefined("attributes.brand_id"),"attributes.brand_id",DE(""))#',
                keyword : '#IIf(IsDefined("attributes.keyword"),"attributes.keyword",DE(""))#',
				brand_name : '#iif(isdefined("attributes.brand_name"),"attributes.brand_name",DE(""))#',
				short_code_id : '#iif(isdefined("attributes.short_code_id"),"attributes.short_code_id",DE(""))#', 
				short_code_name : '#iif(isdefined("attributes.short_code_name"),"attributes.short_code_name",DE(""))#',
				cat : '#iif(isdefined("attributes.cat"),"attributes.cat",DE(""))#',
				category_name : '#iif(isdefined("attributes.category_name"),"attributes.category_name",DE(""))#',
				list_property_id : '#iif(isdefined("attributes.list_property_id"),"attributes.list_property_id",DE(""))#',
				list_variation_id : '#iif(isdefined("attributes.list_variation_id"),"attributes.list_variation_id",DE(""))#',
				sort_type : '#iif(isdefined("attributes.sort_type"),"attributes.sort_type",DE(""))#',
				startrow : '#iif(isdefined("attributes.startrow"),"attributes.startrow",DE(""))#',
                maxrows : '#iif(isdefined("attributes.maxrows"),"attributes.maxrows",DE(""))#',
                PRODUCT_DESC : '#iif(isdefined("attributes.PRODUCT_DESC"),"attributes.PRODUCT_DESC",DE(""))#'
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
<cfset COMPETITIVE_LIST = ValueList(get_competitive_list.competitive_id)>
<cfinclude template="../query/get_price_cat.cfm">
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box scroll="0">
        <cfform name="search_product" method="post" action="#request.self#?fuseaction=#url.fuseaction#">
            <input type="hidden" name="list_property_id" id="list_property_id" value="<cfif isdefined("attributes.list_property_id")><cfoutput>#attributes.list_property_id#</cfoutput></cfif>">
            <input type="hidden" name="list_variation_id" id="list_variation_id" value="<cfif isdefined("attributes.list_variation_id")><cfoutput>#attributes.list_variation_id#</cfoutput></cfif>">
            <input type="hidden" name="list_property_value" id="list_property_value" value="<cfif isdefined("attributes.list__property_value")><cfoutput>#attributes.list__property_value#</cfoutput></cfif>">
            <input name="is_form_submitted" id="is_form_submitted" type="hidden" value="1">
            <cf_box_search>
                <div class="form-group">
                    <cfsavecontent variable="urunad"><cf_get_lang dictionary_id='58221.Ürün Adı'></cfsavecontent>
                    <cfsavecontent variable="barkodno"><cf_get_lang dictionary_id='47699.Barkod No'></cfsavecontent>
                    <cfsavecontent variable="ozelkod"><cf_get_lang dictionary_id='57789.Özel Kod'></cfsavecontent>
                    <cfsavecontent variable="urunaciklma"><cf_get_lang dictionary_id='37700.Ürün Açıklama'></cfsavecontent>    
                    <cfsavecontent variable="uretıcıkod"><cf_get_lang dictionary_id='57634.Üretici Kodu'></cfsavecontent>
                    <cfsavecontent variable="kullanicidostuurl"><cf_get_lang dictionary_id='30253.Kullanıcı Dostu Url'></cfsavecontent>
                    <cfsavecontent variable="urunkod"><cf_get_lang dictionary_id='58800.Ürün Kodu'></cfsavecontent>  
                    <cfsavecontent variable="urundetay"><cf_get_lang dictionary_id='46799.Ürün Detay'></cfsavecontent> 
                    <cfsavecontent variable="uyestokkod"><cf_get_lang dictionary_id='37125.Üye Stok Kodu'></cfsavecontent>
                    <cfsavecontent variable="uye"><cf_get_lang dictionary_id='57658.Üye'></cfsavecontent>
                    <cf_wrk_search_input name="keyword" id="keyword" value="#attributes.keyword#" title="" checkbox="#urunad#,#barkodno#,#ozelkod#,#urunaciklma#,#uretıcıkod#,#kullanicidostuurl#,#urunkod#,#urundetay#,#uyestokkod#,#uye##urunad#" columnlist="PRODUCT_NAME1,BARCODE1,SPECIAL_CODE1,PRODUCT_DESC,MANUFACT_CODE1,USER_FRIENDLY_URL1,PRODUCT_CODE1,PRODUCT_DETAIL1,COMPANY_STOCK_CODE1,COMPANY_PRODUCT_NAME1" check_column="#checked_filter#">
                </div>
                <div class="form-group">
                    <select name="price_catid" id="price_catid">
                        <cfif session.ep.isBranchAuthorization eq 0>
                            <cfif attributes.price_catid is "-1">
                                <option value="-1" selected><cf_get_lang dictionary_id='58722.Standart Alış'></option>
                                <option value="-2"><cf_get_lang dictionary_id='58721.Standart Satış'></option>
                            <cfelse>
                                <option value="-1"><cf_get_lang dictionary_id='58722.Standart Alış'></option>
                                <option value="-2" selected><cf_get_lang dictionary_id='58721.Standart Satış'></option>
                            </cfif>
                        <cfelse>
                            <cfif attributes.price_catid is "-2">
                                <option value="-2" selected><cf_get_lang dictionary_id='58721.Standart Satış'></option>
                            <cfelse>
                                <option value="-2"><cf_get_lang dictionary_id='58721.Standart Satış'></option>
                            </cfif>
                        </cfif>
                        <cfoutput query="get_price_cat"> 
                            <option value="#price_catid#"<cfif (price_catid is attributes.price_catid)> selected</cfif>>#price_cat#</option>
                        </cfoutput>
                    </select>
                </div>
                <div class="form-group medium">
                    <select name="product_stages" id="product_stages" >
                        <option value=""><cf_get_lang dictionary_id='58859.Süreç'></option>
                        <cfoutput query="get_process_type">
                        <option value="#process_row_id#"<cfif attributes.product_stages eq process_row_id>selected</cfif>>#stage#</option>
                        </cfoutput>
                    </select>
                </div>
                <div class="form-group medium">
                    <select name="product_status" id="product_status">
                        <option value="1"<cfif isDefined("attributes.product_status") and (attributes.product_status eq 1)> selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'></option>
                        <option value="0"<cfif isDefined("attributes.product_status") and (attributes.product_status eq 0)> selected</cfif>><cf_get_lang dictionary_id='57494.Pasif'></option>
                        <option value="2"<cfif isDefined("attributes.product_status") and (attributes.product_status eq 2)> selected</cfif>><cf_get_lang dictionary_id='57708.Tümü'></option>
                    </select>
                </div>
                <div class="form-group small">
                    <cfinput type="text" name="maxrows" value="#attributes.maxrows#" validate="integer" range="1,999" required="yes" onKeyUp="isNumber(this)" message="#getLang('','Kayıt Sayısı Hatalı',57537)#" maxlength="3">
                </div>
                <div class="form-group">
                    <cf_wrk_search_button search_function='input_control()' button_type="4">
                </div>
                <cfif xml_is_extra_detail eq 1>
                    <div class="form-group">					
                        <a class="ui-btn ui-btn-gray" onclick="$('#extraDetail').toggleClass('hide')"><i class="catalyst-grid" title="<cf_get_lang dictionary_id='29792.Tasarım'>" alt="<cf_get_lang dictionary_id='29792.Tasarım'>"></i></a>
                    </div>
                </cfif>
				<div class="form-group">
					<a  class="ui-btn ui-btn-gray2" href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_barcod_search','medium');"><i class="fa fa-barcode" title="<cf_get_lang dictionary_id='37699.Barkod Ara'>"></i></a>
                </div>
                <div class="form-group">
                    <a class="ui-btn ui-btn-gray" target="blank_" href="<cfoutput>#request.self#</cfoutput>?fuseaction=objects.collected_barcode<cfif session.ep.isBranchAuthorization>&is_branch=1</cfif>"><i class="fa fa-print" title="<cf_get_lang dictionary_id='37698.Toplu Barkod Yazdır'>"></i></a>
                </div>
            </cf_box_search>
            <cf_box_search_detail>
                <div id="detail_search_div" style="display:table-row;"></div>
                <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group" id="item-brand_id">
                        <label><cf_get_lang dictionary_id='58847.Marka'></label>
                        <cf_wrkproductbrand
                        width="100"
                        compenent_name="getProductBrand"               
                        boxwidth="240"
                        boxheight="150"
                        brand_id="#attributes.brand_id#">
                    </div>
                    <div class="form-group" id="item-short_code_id">
                        <label><cf_get_lang dictionary_id='58225.Model'></label>
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
                    <div class="form-group" id="item-watalogy_product_cat">
                        <label><cf_get_lang dictionary_id='61453.Watalogy Kategorisi'></label>
                        <div class="input-group">
                            <cfsavecontent  variable="message"><cf_get_lang dictionary_id='61453.Watalogy Kategorisi'></cfsavecontent>
                            <input type="hidden" name="watalogy_cat_id" value="<cfif len(attributes.watalogy_cat_id) and len(attributes.watalogy_cat_name)><cfoutput>#attributes.watalogy_cat_id#</cfoutput></cfif>">
                            <input type="text" name="watalogy_cat_name" id="watalogy_cat_name" value="<cfif len(attributes.watalogy_cat_name)><cfoutput>#attributes.watalogy_cat_name#</cfoutput></cfif>">
                            <span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_watalogy_category_names&field_id=search_product.watalogy_cat_id&field_name=search_product.watalogy_cat_name&form_submitted=1','','ui-draggable-box-small');" title="<cf_get_lang dictionary_id='61454.Watalogy Kategorisi Ekle'>!"></span>
                        </div>
                    </div>
                </div>
                <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                    <div class="form-group" id="item-cat_id">
                        <label><cf_get_lang dictionary_id='57486.Kategori'></label>
                        <div class="input-group">
                            <input type="hidden" name="cat_id" id="cat_id" value="<cfif len(attributes.cat_id) and len(attributes.category_name)><cfoutput>#attributes.cat_id#</cfoutput></cfif>">
                            <input type="hidden" name="cat" id="cat" value="<cfif len(attributes.cat) and len(attributes.category_name)><cfoutput>#attributes.cat#</cfoutput></cfif>">
                            <input name="category_name" type="text" id="category_name"  onfocus="AutoComplete_Create('category_name','PRODUCT_CATID,PRODUCT_CAT,HIERARCHY','PRODUCT_CAT_NAME','get_product_cat','','PRODUCT_CATID,HIERARCHY','cat_id,cat','','3','200','','1');" value="<cfif len(attributes.category_name)><cfoutput>#attributes.category_name#</cfoutput></cfif>" autocomplete="off">
                            <span class="input-group-addon icon-ellipsis btnPointer" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_product_cat_names&is_sub_category=1&field_id=search_product.cat_id&field_code=search_product.cat&field_name=search_product.category_name</cfoutput>');"></span>
                        </div>
                    </div>
                    <div class="form-group" id="item-pos_code">
                        <label><cf_get_lang dictionary_id='57544.Sorumlu'></label>
                        <div class="input-group">
                            <input type="hidden" name="pos_code"  id="pos_code" value="<cfif isdefined("attributes.pos_code")><cfoutput>#attributes.pos_code#</cfoutput></cfif>">
                            <input name="pos_manager" type="text" id="pos_manager"  onfocus="AutoComplete_Create('pos_manager','FULLNAME','FULLNAME','get_emp_pos','','POSITION_CODE','pos_code','','3','130');" value="<cfif isdefined("attributes.pos_code") and len(attributes.pos_code)><cfoutput>#attributes.pos_manager#</cfoutput></cfif>" maxlength="255" autocomplete="off">
                            <span class="input-group-addon icon-ellipsis btnPointer" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_code=search_product.pos_code&field_name=search_product.pos_manager<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&select_list=1&is_form_submitted=1&keyword='+encodeURIComponent(document.search_product.pos_manager.value));"></span>
                        </div>
                    </div>
                    <div class="form-group" id="item-pos_code">
                        <label><cf_get_lang dictionary_id='63775.Pazaryeri'></label>
                        <div class="input-group">
                            <cfsavecontent  variable="message"><cf_get_lang dictionary_id='61453.Watalogy Kategorisi'></cfsavecontent>
                            <input type="hidden" name="marketplace_id" value="<cfif len(attributes.marketplace_id) and len(attributes.marketplace_name)><cfoutput>#attributes.marketplace_id#</cfoutput></cfif>">
                            <input type="text" name="marketplace_name" id="marketplace_name" value="<cfif len(attributes.marketplace_name)><cfoutput>#attributes.marketplace_name#</cfoutput></cfif>">
                            <span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=worknet.list_product&event=popup_addWorknetRelation&pid=0&form_submitted=1&select=1&draggable=1&field_id=search_product.marketplace_id&field_name=search_product.marketplace_name&</cfoutput>')" title="<cf_get_lang dictionary_id='61454.Watalogy Kategorisi Ekle'>!"></span>
                        </div>
                    </div>                    
                </div>
                <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
                    <div class="form-group" id="item-record_emp_id">
                        <label><cf_get_lang dictionary_id='57899.Kaydeden'></label>
                        <div class="input-group">
                            <input type="hidden" name="record_emp_id" id="record_emp_id" value="<cfif isdefined("attributes.record_emp_id")><cfoutput>#attributes.record_emp_id#</cfoutput></cfif>">
                            <input name="record_emp_name" type="text" id="record_emp_name"  onfocus="AutoComplete_Create('record_emp_name','FULLNAME','FULLNAME','get_emp_pos','','EMPLOYEE_ID','record_emp_id','','3','130');" value="<cfif isdefined("attributes.record_emp_id") and len(attributes.record_emp_id)><cfoutput>#attributes.record_emp_name#</cfoutput></cfif>" maxlength="255" autocomplete="off">
                            <span class="input-group-addon icon-ellipsis btnPointer" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=search_product.record_emp_id&field_name=search_product.record_emp_name<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&select_list=1&is_form_submitted=1&keyword='+encodeURIComponent(document.search_product.record_emp_name.value));"></span>
                        </div>
                    </div>
                    <div class="form-group" id="item-record_emp_id">
                        <label><cf_get_lang dictionary_id='29533.Tedarikçi'></label>
                        <div class="input-group">
                            <input type="hidden" name="company_id" id="company_id" value="<cfif isdefined("attributes.company_id")><cfoutput>#attributes.company_id#</cfoutput></cfif>">
                            <input name="company" type="text" id="company"  onfocus="AutoComplete_Create('company','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1\',0,0','COMPANY_ID','company_id','','3','150');" value="<cfif isdefined("attributes.company_id") and len(attributes.company_id) and isdefined("attributes.company") and len(attributes.company)><cfoutput>#get_par_info(attributes.company_id,1,1,0)#</cfoutput></cfif>" autocomplete="off">
                            <span class="input-group-addon icon-ellipsis btnPointer" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_comp_name=search_product.company&field_comp_id=search_product.company_id<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&select_list=2&keyword='+encodeURIComponent(document.search_product.company.value));"></span>
                        </div>
                    </div>
                </div>
                <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="4" sort="true">
                     <div class="form-group" id="item-product_types">
                        <label><cf_get_lang dictionary_id='46862.Ürün Bilgileri'></label>
                        <select name="product_types" id="product_types">
                            <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                            <option value="5"<cfif isDefined("attributes.product_types") and (attributes.product_types eq 5)> selected</cfif>><cf_get_lang dictionary_id='37170.Tedarik Edilmiyor'></option>
                            <option value="1"<cfif isDefined("attributes.product_types") and (attributes.product_types eq 1)> selected</cfif>><cf_get_lang dictionary_id='37061.Tedarik Ediliyor'></option>
                            <option value="2"<cfif isDefined("attributes.product_types") and (attributes.product_types eq 2)> selected</cfif>><cf_get_lang dictionary_id='37090.Hizmetler'></option>
                            <option value="16"<cfif isDefined("attributes.product_types") and (attributes.product_types eq 16)> selected</cfif>><cf_get_lang dictionary_id='37055.Envantere Dahil'></option>
                            <option value="3"<cfif isDefined("attributes.product_types") and (attributes.product_types eq 3)> selected</cfif>><cf_get_lang dictionary_id='37423.Mallar'></option>
                            <option value="4"<cfif isDefined("attributes.product_types") and (attributes.product_types eq 4)> selected</cfif>><cf_get_lang dictionary_id='37066.Terazi'></option>
                            <option value="6"<cfif isDefined("attributes.product_types") and (attributes.product_types eq 6)> selected</cfif>><cf_get_lang dictionary_id='37057.Üretiliyor'></option>
                            <option value="13"<cfif isDefined("attributes.product_types") and (attributes.product_types eq 13)> selected</cfif>><cf_get_lang dictionary_id='37556.Maliyet Takip Ediliyor'></option>
                            <option value="15"<cfif isDefined("attributes.product_types") and (attributes.product_types eq 15)> selected</cfif>><cf_get_lang dictionary_id="37254.Kalite"> <cf_get_lang dictionary_id="37175.Takip Ediliyor"></option>
                            <option value="7"<cfif isDefined("attributes.product_types") and (attributes.product_types eq 7)> selected</cfif>><cf_get_lang dictionary_id='37557.Seri No Takip'></option>
                            <option value="8"<cfif isDefined("attributes.product_types") and (attributes.product_types eq 8)> selected</cfif>><cf_get_lang dictionary_id='37467.Karma Koli'></option>
                            <option value="9"<cfif isDefined("attributes.product_types") and (attributes.product_types eq 9)> selected</cfif>><cf_get_lang dictionary_id='58079.İnternet'></option>
                            <option value="12"<cfif isDefined("attributes.product_types") and (attributes.product_types eq 12)> selected</cfif>><cf_get_lang dictionary_id='58019.Extranet'></option>
                            <option value="10"<cfif isDefined("attributes.product_types") and (attributes.product_types eq 10)> selected</cfif>><cf_get_lang dictionary_id='37063.Özelleştirilebilir'></option>
                            <option value="11"<cfif isDefined("attributes.product_types") and (attributes.product_types eq 11)> selected</cfif>><cf_get_lang dictionary_id='37558.Sıfır Stok İle Çalış'></option>
                            <option value="14"<cfif isDefined("attributes.product_types") and (attributes.product_types eq 14)> selected</cfif>><cf_get_lang dictionary_id='37059.Satışta'></option>
                            <option value="18"<cfif isDefined("attributes.product_types") and (attributes.product_types eq 18)> selected</cfif>><cf_get_lang dictionary_id='37922.Stoklarla Sınırlı'></option>
                            <option value="17"<cfif isDefined("attributes.product_types") and (attributes.product_types eq 17)> selected</cfif>><cf_get_lang dictionary_id='37155.Lot No'></option>
                            <option value="19"<cfif isDefined("attributes.product_types") and (attributes.product_types eq 19)> selected</cfif>><cf_get_lang dictionary_id='63813.Watalogy Entegre'></option>
                        </select>
                    </div>
                    <div class="form-group" id="item-sort_type">
                        <label><cf_get_lang dictionary_id='58924.Sıralama'></label>
                        <select name="sort_type" id="sort_type">
                            <option value="0" <cfif attributes.sort_type eq 0>selected</cfif>><cf_get_lang dictionary_id='37959.Ürün Adına Göre Artan'></option>
                            <option value="1" <cfif attributes.sort_type eq 1>selected</cfif>><cf_get_lang dictionary_id='37960.Ürün Adına Göre Azalan'></option>
                            <option value="2" <cfif attributes.sort_type eq 2>selected</cfif>><cf_get_lang dictionary_id='37961.Stok Koduna Göre Artan'></option>
                            <option value="3" <cfif attributes.sort_type eq 3>selected</cfif>><cf_get_lang dictionary_id='37962.Stok Koduna Göre Azalan'></option>
                            <option value="4" <cfif attributes.sort_type eq 4>selected</cfif>><cf_get_lang dictionary_id='37963.Özel Koda Göre Artan'></option>
                            <option value="5" <cfif attributes.sort_type eq 5>selected</cfif>><cf_get_lang dictionary_id='37964.Özel Koda Göre Azalan'></option>
                            <option value="6" <cfif attributes.sort_type eq 6>selected</cfif>><cf_get_lang dictionary_id='37965.Barkoda Göre Artan'></option>
                            <option value="7" <cfif attributes.sort_type eq 7>selected</cfif>><cf_get_lang dictionary_id='37966.Barkoda Göre Azalan'></option>
                            <option value="8" <cfif attributes.sort_type eq 8>selected</cfif>><cf_get_lang dictionary_id='37967.SD Tarihine Göre Artan'></option>
                            <option value="9" <cfif attributes.sort_type eq 9>selected</cfif>><cf_get_lang dictionary_id='37968.SD Tarihine Göre Azalan'></option>
                        </select>
                    </div>
                </div>
            </cf_box_search_detail>  
            <cfparam name="attributes.mode" default="6">
            <cfif xml_is_extra_detail >
            <div class="row">
                <div class="col col-12 hide" id="extraDetail">
                    <cfif get_property_variation.recordcount eq 0>
                        <tr><td></td></tr>
                    <cfelse>
                        <cfoutput>
                            <cfset a=0>
                            <cfloop from="1" to="#get_property_variation.recordcount#" index="main_str">
                                <cfif ((a mod attributes.mode is 0)) or (a eq 0)>
                                    <div class="col col-3 col-md-4 col-sm-6 col-xs-12" id="frm_row#main_str#">
                                </cfif>
                                <cfif get_property_variation.property_id[main_str] neq get_property_variation.property_id[main_str-1]>
                                    <div class="form-group">
                                        <input type="hidden" name="row_kontrol#main_str#" id="row_kontrol#main_str#" value="1">
                                        <input type="hidden" name="property_id#main_str#" id="property_id#main_str#" value="#get_property_variation.property_id[main_str]#">
                                        <select name="variation_id#main_str#" id="variation_id#main_str#" onchange="showInformation(#main_str#);">
                                            <option value="">#get_property_variation.property[main_str]#</option>
                                            <cfloop from="#main_str#" to="#get_property_variation.recordcount#" index="str">
                                                <cfif get_property_variation.property_id[main_str] eq get_property_variation.property_id[str]>
                                                    <option value="#get_property_variation.property_detail_id[str]#" <cfif isdefined('attributes.list_variation_id') and listfind(attributes.list_variation_id,get_property_variation.property_detail_id[str])>selected="selected"</cfif>>#get_property_variation.property_detail[str]#</option>
                                                <cfelse>
                                                    <cfbreak>
                                                </cfif>
                                            </cfloop>
                                        </select>
                                        <cfset a=a+1>
                                    </div>
                                    <div id="information_row#main_str#" <cfif isdefined('attributes.list_variation_id') and listfind(attributes.list_property_id,get_property_variation.property_id[main_str])><cfelse>style="display:none;"</cfif>>
                                        <input type="hidden" name="information_select#main_str#" id="information_select" value="<cfif isdefined('attributes.list_property_value') and listfind(attributes.list_property_id,get_property_variation.property_id[main_str]) and listgetat(attributes.list_property_value,listfind(attributes.list_property_id,get_property_variation.property_id[main_str]),',') neq 'empty'>#listgetat(attributes.list_property_value,listfind(attributes.list_property_id,get_property_variation.property_id[main_str]),',')#</cfif>" />
                                    </div>
                                </cfif>
                                <cfif ((a mod attributes.mode eq 0)) or (a eq get_property_variation.recordcount)>
                                    </div>
                                </cfif>
                            </cfloop>
                        </cfoutput>
                    </cfif>
                </div>
            </div> 
            </cfif>
        </cfform>
    </cf_box>
    <cfsavecontent variable="title"><cf_get_lang dictionary_id='57564.Ürünler'></cfsavecontent>
    <cf_box title="#title#" uidrop="1" hide_table_column="1" scroll="1" woc_setting = "#{ checkbox_name : 'print_product_id', print_type : 371 }#">
            <cfset colspan_ = 17>
            <cfif not isdefined("attributes.trail")><cfset colspan_ = colspan_ + 1></cfif>
            <cf_grid_list>
                <thead>
                    <tr>
                        <th width="20"><cf_get_lang dictionary_id='58577.Sıra'></th>
                        <th><cf_get_lang dictionary_id='57657.Ürün'></th>
                        <th><cf_get_lang dictionary_id='29533.Tedarikçi'></th>
                        <th><cf_get_lang dictionary_id='58847.Marka'></th>
                        <th><cf_get_lang dictionary_id='58225.Model'></th>
                        <th><cf_get_lang dictionary_id='57789.Özel Kod'></th>
                        <th><cf_get_lang dictionary_id='57633.Barkod'></th>
                        <th><cf_get_lang dictionary_id='57518.Stok Kodu'></th>
                        <th><cf_get_lang dictionary_id='57634.Ürt Kodu'></th>
                        <th><cf_get_lang dictionary_id='57636.Birim'></th>
                        <th><cf_get_lang dictionary_id='57639.KDV'></th>
                        <th><cf_get_lang dictionary_id='37375.Max'></th>
                        <th><cf_get_lang dictionary_id='37374.Min'></th>
                        <th>
                            <cfif attributes.price_catid eq -1>
                                <cf_get_lang dictionary_id='37041.Alış Fiyat'>
                            <cfelseif attributes.price_catid eq -2><cf_get_lang dictionary_id='37042.Satış Fiyat'>
                            <cfelse>
                                <cf_get_lang dictionary_id='58084.Fiyat'>
                            </cfif>
                        </th>
                        <th>
                            <cfif attributes.price_catid eq -1>
                                <cf_get_lang dictionary_id='37041.Fiyat'>(<cf_get_lang dictionary_id='37365.kdv dahil'>)
                            <cfelseif attributes.price_catid eq -2>
                                <cf_get_lang dictionary_id='37042.Fiyat'>(<cf_get_lang dictionary_id='37365.kdv dahil'>)
                            <cfelse>
                                <cf_get_lang dictionary_id='58084.Fiyat'>(<cf_get_lang dictionary_id='37365.kdv dahil'>)
                            </cfif>
                        </th>
                        <th><cf_get_lang dictionary_id='58859.Süreç'></th>		
                        <th><cf_get_lang dictionary_id='37040.S D Tarihi'></th>
                        <!-- sil -->
                        <th width="20" class="header_icn_none"><a href="<cfoutput>#request.self#?fuseaction=product.list_product&event=add</cfoutput>"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
                        <!-- sil -->
                        <cfif isdefined("attributes.is_form_submitted") and get_product.recordcount>
                            <th width="20" nowrap="nowrap" class="text-center header_icn_none">
                                <cfif get_product.recordcount eq 1><a href="javascript://" onclick="send_print_reset();"><i class="fa fa-print" alt="<cf_get_lang dictionary_id='57389.Print Sayisi Sifirla'>" title="<cf_get_lang dictionary_id='57389.Print Sayisi Sifirla'>"></i></a></cfif>
                                <input type="checkbox" name="allSelectDemand" id="allSelectDemand" onclick="wrk_select_all('allSelectDemand','print_product_id');">
                            </th>
                
                        </cfif>
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
                        <cfoutput query="get_product">
                            <tr oncontextmenu="javascript:wrk_right_menu('PRODUCT_ID',#PRODUCT_ID#);return false;"> 
                                <td>#rownum#</td>
                                <td><a href="#request.self#?fuseaction=#fuseaction_info#.list_product&event=det&pid=#get_product.product_id#" class="tableyazi">#get_product.product_name#</a></td>
                                <td>#SUPPLIER#</td>
                                <td><cfif len(brand_id)>#get_brand.BRAND_NAME[listfind(brand_id_list,brand_id,',')]#</cfif></td>
                                <td><cfif len(short_code_id)>#get_model.MODEL_NAME[listfind(short_code_id_list,short_code_id,',')]#</cfif></td>
                                <td>#get_product.product_code_2#</td>
                                <td>
                                    <cfif isdefined('is_all_barcode') and is_all_barcode eq 1 and isdefined('list_#GET_PRODUCT.PRODUCT_ID#_#GET_PRODUCT.PRODUCT_UNIT_ID#')>
                                    <!--- xmlde tüm barcodeler seçili ise birime göre listelenir --->
                                        <cfloop list="#evaluate('list_#GET_PRODUCT.PRODUCT_ID#_#GET_PRODUCT.PRODUCT_UNIT_ID#')#" index="barcod_ind">
                                            #barcod_ind#
                                        <cfif barcod_ind neq listlast(evaluate('list_#GET_PRODUCT.PRODUCT_ID#_#GET_PRODUCT.PRODUCT_UNIT_ID#'))><br/></cfif>
                                        </cfloop>
                                    <cfelse>
                                        #get_product.barcod#
                                </cfif>
                                </td>
                                <td style="mso-number-format:\@;"><a href="#request.self#?fuseaction=stock.list_stock&event=det&pid=#get_product.product_id#" class="tableyazi">#get_product.product_code#</a></td>
                                <td style="mso-number-format:\@;">#get_product.manufact_code#</td>
                                <td>#ADD_UNIT#</td>
                                <td>#tax#</td>
                                <td>#max_margin#</td>
                                <td>#min_margin#</td>
                                <cfif attributes.price_catid is "-1">
                                    <td class="text-right"><a href="#request.self#?fuseaction=product.list_price_change&event=det&pid=#get_product.product_id#" class="tableyazi">#TLFormat(get_product.price,session.ep.our_company_info.purchase_price_round_num)# #get_product.money#</a></td>
                                    <td class="text-right"><a href="#request.self#?fuseaction=product.list_price_change&event=det&pid=#get_product.product_id#" class="tableyazi"><cfif get_product.is_kdv >#TLFormat(get_product.price_kdv,session.ep.our_company_info.purchase_price_round_num)#<cfelse>#TLFormat(get_product.price*(100+get_product.tax)/100,session.ep.our_company_info.purchase_price_round_num)#</cfif> #get_product.money#</a></td>
                                <cfelse>
                                    <td class="text-right"><a href="#request.self#?fuseaction=product.list_price_change&event=det&pid=#get_product.product_id#" class="tableyazi">#TLFormat(get_product.price,session.ep.our_company_info.sales_price_round_num)# #get_product.money#</a></td>
                                    <td class="text-right">
                                        <div class="form-group">
                                            <div class="input-group">
                                                <a href="#request.self#?fuseaction=product.list_price_change&event=det&pid=#get_product.product_id#" class="tableyazi"><cfif get_product.is_kdv >#TLFormat(get_product.price_kdv,session.ep.our_company_info.sales_price_round_num)#<cfelse>#TLFormat(get_product.price*(100+get_product.tax)/100,session.ep.our_company_info.sales_price_round_num)#</cfif> #get_product.money#</a>
                                                <cfif len(get_product.prod_competitive)>
                                                    <cfif listfind(COMPETITIVE_LIST,get_product.prod_competitive,',')>
                                                    <cfset str_url_open="product.popup_form_add_product_price&pid=#get_product.product_id[currentrow]#&price_catid=#attributes.price_catid#">
                                                    <cfelse>
                                                    <cfset str_url_open="product.list_price_change&event=add&pid=#get_product.product_id[currentrow]#&price_catid=#attributes.price_catid#">
                                                    </cfif>
                                                <cfelse>
                                                    <cfset str_url_open="product.list_price_change&event=add&pid=#get_product.product_id[currentrow]#&price_catid=#attributes.price_catid#">
                                                </cfif>
                                                <!-- sil --><span class="input-group-addon icon-ellipsis" onclick="windowopen('#request.self#?fuseaction=#str_url_open#','wide','popup_form_add_product_price');" title="<cf_get_lang dictionary_id='37124.Fiyat Ekle'>"></span><!-- sil -->
                                            </div>
                                        </div>
                                    </td>
                                </cfif>
                                <td><cfif len(product_stage)>#process_type_all.stage[listfind(product_stage_list,product_stage,',')]#</cfif></td>
                                <td><cfif isdate(get_product.update_date)>#dateformat(get_product.update_date,dateformat_style)#<cfelse>#dateformat(get_product.record_date,dateformat_style)#</cfif></td>
                                <!-- sil -->
                                <td><a href="#request.self#?fuseaction=#fuseaction_info#.list_product&event=det&pid=#get_product.product_id#"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td>
                                <!-- sil -->
                                <td class="text-center"><input type="checkbox" name="print_product_id" id="print_product_id" value="#product_id#"></td>
                            </tr>
                        </cfoutput>
                    <cfelse>
                        <tr> 
                            <td colspan="<cfoutput>#colspan_#</cfoutput>" height="20"><cfif arama_yapilmali eq 1><cf_get_lang dictionary_id='57701.Filtre Ediniz'> !<cfelse><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</cfif></td>
                        </tr>
                    </cfif>
                </tbody>
            </cf_grid_list>
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
        <cfif isDefined('attributes.product_desc') and len(attributes.product_desc)>
            <cfset adres = '#adres#&product_desc=#attributes.product_desc#'>
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
        <cfif isDefined('attributes.list_variation_id') and len(attributes.list_variation_id)>
        <cfset adres = '#adres#&list_variation_id=#attributes.list_variation_id#'>
        </cfif>	
        <cf_paging 
            page="#attributes.page#"
            maxrows="#attributes.maxrows#"
            totalrecords="#attributes.totalrecords#"
            startrow="#attributes.startrow#"
            adres="#adres#&is_form_submitted=1">
    </cf_box>
</div>
<script type="text/javascript">
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
        <cfif xml_is_extra_detail >
            row_count=<cfoutput>#get_property_variation.recordcount#</cfoutput>;
            for(r=1;r<=row_count;r++)
            {
                deger_variation_id = eval("document.search_product.variation_id"+r);
                if(deger_variation_id!=undefined && deger_variation_id.value != "")
                {
                    deger_property_id = eval("document.search_product.property_id"+r);
                    deger_property_value=eval("document.search_product.information_select"+r);
                    
                    if(search_product.list_property_id.value.length==0) ayirac=''; else ayirac=',';
                    search_product.list_property_id.value=search_product.list_property_id.value+ayirac+deger_property_id.value;
                    search_product.list_variation_id.value=search_product.list_variation_id.value+ayirac+deger_variation_id.value;
                    if(search_product.list_property_value.value.length==0) ayirac=''; else ayirac=',';
                    if(deger_property_value.value=='')search_product.list_property_value.value=search_product.list_property_value.value+ayirac+'empty';
                    else search_product.list_property_value.value=search_product.list_property_value.value+ayirac+deger_property_value.value;
                    
                }
            }
        </cfif>
		if(search_product.brand_name.value.length == 0) search_product.brand_id.value = '';
		if(search_product.company.value.length == 0) search_product.company_id.value = '';
		if(search_product.pos_manager.value.length == 0) search_product.pos_code.value = '';
		
		<cfif not session.ep.our_company_info.unconditional_list>
			if(search_product.keyword.value.length == 0 && search_product.cat.value.length == 0 && (search_product.brand_id.value.length == 0 || search_product.brand_name.value.length == 0) && (search_product.pos_code.value.length == 0 || search_product.pos_manager.value.length == 0) && (search_product.company_id.value.length == 0 || search_product.company.value.length == 0) )
			{
				alert("<cf_get_lang dictionary_id='58950.En az bir alanda filtre etmelisiniz '>!");
				return false;
			}		
			else
				return true;
		<cfelse>
		
			return true;
		</cfif>
	}
	function connectAjax(div_id)
	{
		<cfoutput>
			AjaxPageLoad('#request.self#?fuseaction=product.popup_product_properties_ajax<cfif len(attributes.cat_id) and len(attributes.category_name)>&cat_id=#attributes.cat_id#</cfif><cfif len(attributes.list_variation_id)>&list_variation_id=#attributes.list_variation_id#</cfif><cfif len(attributes.list_property_value)>&list_property_value=#attributes.list_property_value#</cfif><cfif len(attributes.list_property_id)>&list_property_id=#attributes.list_property_id#</cfif>',''+div_id+'',1);
		</cfoutput>	
	}
	search_product.list_property_id.value="";
	search_product.list_property_value.value="";
	search_product.list_variation_id.value="";
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
<cfsetting showdebugoutput="yes">
