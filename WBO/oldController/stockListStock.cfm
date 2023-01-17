<cf_get_lang_set module_name="stock">
<cf_xml_page_edit  default_value="1" fuseact="stock.list_stock">
<cfif not IsDefined("attributes.event") or (IsDefined("attributes.event") and attributes.event is 'list')>	
    <cfsetting showdebugoutput="yes">
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
    <cfparam name="attributes.list_type" default="1">
    <cfparam name="attributes.sort_type" default="0">
    <cfparam name="attributes.strategy_type" default="">
    <cfparam name="attributes.department_id" default="">
    <cfparam name="attributes.location_id" default="">
    <cfparam name="attributes.location_name" default="">
    <cfparam name="attributes.product_brand_name" default="">
    <cfparam name="attributes.product_model_name" default="">
    <cfparam name="attributes.manufacturer_code" default="">
    <cfinclude template="../stock/query/get_stores.cfm">
	<cfquery name="GET_ALL_LOCATION" datasource="#DSN#">
        SELECT * FROM STOCKS_LOCATION ORDER BY COMMENT
    </cfquery>
    <cfparam name="attributes.page" default=1>
    <cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
    <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>    
	<cfif isdefined("attributes.is_form_submitted")>
		<cfscript>
            get_stock_list_action = createObject("component", "stock.cfc.get_stock_list");
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
                    manufacturer_code : '#IIf(IsDefined("attributes.manufacturer_code"),"attributes.manufacturer_code",DE(""))#'
             );
        </cfscript>
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
    <cfparam name="attributes.mode" default="7">
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
<cfelseif IsDefined("attributes.event") and attributes.event is 'upd'>
	<cfscript>
	get_product_list_action = createObject("component", "stock.cfc.get_product");
	get_product_list_action.dsn3 = dsn3;
	get_product = get_product_list_action.get_product_fnc2(
		pid : '#iif(isdefined("attributes.pid"),"attributes.pid",DE(""))#'
	);
</cfscript>
</cfif>

<script type="text/javascript">
<cfif not IsDefined("attributes.event") or (IsDefined("attributes.event") and attributes.event is 'list')>
		$( document ).ready(function() {
			document.getElementById('keyword').focus();
		});			
		<cfif isdefined("get_property_variation")>
			row_count = <cfoutput>#get_property_variation.recordcount#</cfoutput>;			
		<cfelse>
			row_count = 0;	
		</cfif>
		function gonder()
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
		function input_control()
		{	
			<cfif is_show_detail_search eq 1>
			</cfif>
			<cfif not session.ep.our_company_info.unconditional_list>
			if(stock_search.employee.value.length == 0) stock_search.employee_id.value = '';
			if(stock_search.company.value.length == 0) stock_search.company_id.value = '';
			if(stock_search.product_cat.value.length == 0) stock_search.search_product_catid.value = '';
			if (stock_search.amount_flag.options[document.stock_search.amount_flag.selectedIndex].value.length == 0 && stock_search.department_id.value.length == 0 && stock_search.keyword.value.length == 0 && stock_search.barcod.value.length < 7 && (stock_search.product_cat.value.length == 0 || stock_search.search_product_catid.value.length == 0) && (stock_search.employee_id.value.length == 0 || stock_search.employee.value.length == 0) && (stock_search.company_id.value.length == 0 || stock_search.company.value.length == 0) && (stock_search.stock_code.value.length == 0) && (stock_search.ozel_kod.value.length == 0)) 
			{
				alert("<cf_get_lang_main no='1538.En az bir alanda filtre etmelisiniz'> !");
				return false;
			}
			</cfif>
			<cfif is_show_detail_search eq 1>
			  return gonder();
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
				is_shelf_2.style.display="";
			}	
			else
			{
				is_shelf_1.style.display="none";
				is_shelf_2.style.display="none";
			}
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
			var load_url_ = '<cfoutput>#request.self#?fuseaction=objects.emptypopup_ajax_product_stock_info&is_calc_row_=1<cfif isdefined('x_show_all_order_row_types') and x_show_all_order_row_types eq 0>&x_show_all_order_row_types=0</cfif></cfoutput>&show_stock_order&pid='+prod_id+'&sid='+ stock_id+'&type=1&spect_main_id='+ spect_main_id+'&crtrow='+crtrow+'&dept_loc_info_stock_='+dept_loc_info_stock+'&dept_loc_info_='+dept_loc_info;
			AjaxPageLoad(load_url_,'DISPLAY_ORDER_STOCK_INFO'+crtrow,1);
		}
</cfif>
</script>

<cfscript>
	// Switch //
	WOStruct = StructNew();
	
	WOStruct['#attributes.fuseaction#'] = structNew();	
	
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	if(not isdefined('attributes.event'))
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];
	
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'stock.list_stock';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'stock/display/list_stock.cfm';
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'stock.detail_stock';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'stock/display/detail_stock.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'stock.list_stock&event=upd';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'pid=##attributes.pid##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##get_product.product_name##';	
	
	if(isdefined("attributes.event") and attributes.event is 'upd')
	{
		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'] = structNew();
		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['text'] = '#lang_array_main.item[345]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['onclick'] = "windowopen('#request.self#?fuseaction=objects.popup_page_warnings&action=stock.detail_stock&action_name=pid&action_id=#attributes.pid#','list');";
		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['text'] = '#lang_array.item[210]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['onclick'] = "windowopen('#request.self#?fuseaction=stock.popup_list_product_spects&pid=#attributes.pid#&department_id=','list')";
			
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][2]['text'] = '#lang_array_main.item[507]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][2]['onclick'] = "windowopen('#request.self#?fuseaction=stock.detail_stock_popup&pid=#attributes.pid#','wide')";
			
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][3]['text'] = '#lang_array.item[44]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][3]['onclick'] = "windowopen('#request.self#?fuseaction=stock.detail_store_stock_popup&pid=#pid#','list')";
		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][4]['text'] = '#lang_array_main.item[846]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][4]['href'] = "#request.self#?fuseaction=product.form_add_product_cost&pid=#url.pid#";
			
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][5]['text'] = '#lang_array_main.item[1614]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][5]['href'] = "#request.self#?fuseaction=product.detail_product_price&pid=#attributes.pid#";
		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][6]['text'] = '#lang_array_main.item[1352]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][6]['href'] = "#request.self#?fuseaction=product.list_product&event=upd&pid=#attributes.pid#";
	
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
</cfscript>
