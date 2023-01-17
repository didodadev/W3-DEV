<cf_get_lang_set module_name="prod">
<cfif not isdefined("attributes.event") or attributes.event is 'list'>
	<cfparam name="attributes.employee_name" default="">
    <cfparam name="attributes.record_employee_name" default="">
    <cfparam name="attributes.product_employee_id" default="">
    <cfparam name="attributes.record_employee_id" default="">
    <cfparam name="attributes.stock_status" default="1">
    <cfparam name="attributes.brand_id" default="">
    <cfparam name="attributes.brand_name" default="">
    <cfparam name="attributes.keyword" default="">
    <cfparam name="attributes.cat" default="">
    <cfparam name="attributes.product_id" default="">
    <cfparam name="attributes.product_name" default="">
    <cfparam name="attributes.is_stock_id" default="">
    <cfinclude template="../production_plan/query/get_product_cat.cfm">
    <cfif isdefined("attributes.is_submit")>
        <cfscript>
            get_tree_action = createObject("component", "production_plan.cfc.get_tree");
            get_tree_action.dsn3 = dsn3;
			get_tree_action.dsn_alias = dsn_alias;
            get_tree = get_tree_action.get_tree_fnc(
                keyword : '#IIf(IsDefined("keyword"),"keyword",DE(""))#',
                cat : '#IIf(IsDefined("attributes.cat"),"attributes.cat",DE(""))#',
                record_employee_id : '#IIf(IsDefined("attributes.record_employee_id"),"attributes.record_employee_id",DE(""))#',
                record_employee_name : '#IIf(IsDefined("attributes.record_employee_name"),"attributes.record_employee_name",DE(""))#',
                brand_id : '#IIf(IsDefined("attributes.brand_id"),"attributes.brand_id",DE(""))#',
                brand_name : '#IIf(IsDefined("attributes.brand_name"),"attributes.brand_name",DE(""))#',
                product_id : '#IIf(IsDefined("attributes.product_id"),"attributes.product_id",DE(""))#',
                product_name : '#IIf(IsDefined("attributes.product_name"),"attributes.product_name",DE(""))#',
                is_stock_id : '#IIf(IsDefined("attributes.is_stock_id"),"attributes.is_stock_id",DE(""))#',
                product_employee_id : '#IIf(IsDefined("attributes.product_employee_id"),"attributes.product_employee_id",DE(""))#',
                employee_name : '#IIf(IsDefined("attributes.employee_name"),"attributes.employee_name",DE(""))#',
                stock_status : '#IIf(IsDefined("attributes.stock_status"),"attributes.stock_status",DE(""))#'
            );
        </cfscript>
    <cfelse>
        <cfset get_tree.recordcount = 0>
    </cfif>
    <cfparam name="attributes.page" default=1>
    <cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
    <cfparam name="attributes.totalrecords" default=#get_tree.recordcount#>
    <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfelseif isdefined("attributes.event") and attributes.event is 'upd'>
    <cf_xml_page_edit fuseact ="prod.add_product_tree" default_value="0">
    <cfsetting showdebugoutput="no">
    <cfparam name="old_main_spec_id" default="0">
    <cfparam name="is_used_rate" default="0">
    <cfparam name="attributes.stock_id" default="0">
    <cfset attributes.stock_main_id = attributes.stock_id>
    <cfinclude template="../production_plan/query/get_product_info.cfm">
    <cfquery name="GET_PRO_TREE_ID" datasource="#DSN3#">
      SELECT 
        PT.PRODUCT_TREE_ID,
        PT.RECORD_DATE,
        PT.UPDATE_DATE,
        PT.RECORD_EMP,
        (SELECT EMPLOYEE_NAME +' '+EMPLOYEE_SURNAME FROM #DSN_ALIAS#.EMPLOYEES E WHERE  E.EMPLOYEE_ID=PT.UPDATE_EMP) AS UPDATE_NAME,
        (SELECT EMPLOYEE_NAME +' '+EMPLOYEE_SURNAME FROM #DSN_ALIAS#.EMPLOYEES E WHERE  E.EMPLOYEE_ID=PT.RECORD_EMP) AS RECORD_NAME,
        UPDATE_EMP ,
        PROCESS_STAGE
     FROM 
        PRODUCT_TREE  PT
     WHERE 
        STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.STOCK_ID#">
    </cfquery>
    <cfquery name="get_alternative_questions" datasource="#dsn#">
        SELECT QUESTION_ID,QUESTION_NAME FROM SETUP_ALTERNATIVE_QUESTIONS
    </cfquery>
    <cfif isdefined('attributes.product_tree_id')>
        <cfset _product_tree_id_ = attributes.product_tree_id>
    <cfelse>
        <cfset _product_tree_id_ =0>
    </cfif>
    <cfquery name="get_product_conf" datasource="#dsn3#">
        SELECT CONFIGURATOR_NAME,PRODUCT_CONFIGURATOR_ID FROM SETUP_PRODUCT_CONFIGURATOR WHERE CONFIGURATOR_STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.stock_id#">
    </cfquery>
	<cfif isdefined('attributes.product_tree_id') and attributes.product_tree_id gt 0>
        <cfquery name="get_operation_name" datasource="#dsn3#">
            SELECT 
                (SELECT OPERATION_TYPE FROM OPERATION_TYPES WHERE OPERATION_TYPES.OPERATION_TYPE_ID = PRODUCT_TREE.OPERATION_TYPE_ID) AS OPERATION,
                PRODUCT_TREE.OPERATION_TYPE_ID
            FROM 
                PRODUCT_TREE 
            WHERE PRODUCT_TREE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_tree_id#">
        </cfquery>
    <cfelse>
        <cfquery name="get_prod_var" datasource="#dsn3#">
            SELECT TOP 1 SPECT_MAIN_ID FROM SPECT_MAIN SM WHERE SM.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.stock_id#"> AND SM.IS_TREE = 1 ORDER BY SM.RECORD_DATE DESC,SM.UPDATE_DATE DESC
        </cfquery>
    </cfif>

	<script type="text/javascript">
        function open_spec()
        {
            if(document.getElementById("add_stock_id").value!='' && document.getElementById("product_name").value!='')
                windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_spect_main&field_name=spect_main_name&field_main_id=spect_main_id&stock_id='+document.getElementById("add_stock_id").value,'list')
            else
                alert("<cf_get_lang_main no='59.Eksik Veri'> : <cf_get_lang_main no='245.Ürün'>");
        }
        function fire_control()
        {
            if(document.getElementById('fire_rate').value != '')
            {
                var fire_rate_ = parseFloat(filterNum(document.getElementById('fire_rate').value,2));
                if(fire_rate_ > 100)
                {
                    alert("Fire Oranı 100'den büyük olamaz!");
                    return false;
                }
            }
        }
        function copy_product_func(stock_id)
        {
            if(process_cat_control())
                AjaxPageLoad('<cfoutput>#request.self#?fuseaction=prod.emptypopup_copy_product_tree&process_stage_='+document.all.process_stage.value+'&FROM_STOCK_ID='+stock_id+'&to_stock_id=#attributes.stock_id#</cfoutput>','div_product_copy',1)
        }
        function kontrol()
        {
            if(document.getElementById('fire_rate').value != '')
            {
                var fire_rate_ = parseFloat(filterNum(document.getElementById('fire_rate').value,2));
                if(fire_rate_ > 100)
                {
                    alert("Fire Oranı 100'den büyük olamaz!");
                    return false;
                }
            }
            if(document.getElementById("fire_amount").value != '' && document.getElementById("fire_rate").value != '')
            {
                alert("<cf_get_lang no='70.Fire Miktarı ve Fire Oranı Birlikte Girilemez'>!");
                return false;
            }
            if(<cfoutput>#is_used_rate#</cfoutput>== 1){
                var product_tree_sum = parseFloat(document.getElementById('genel_toplam').value)+(parseFloat(filterNum(document.getElementById('amount').value)*100));
                if(product_tree_sum > 100){
                    alert("<cf_get_lang no='310.% Kullanarak Ürün Ağacı Tasarlanırken Ağaca Eklenen Ürün Oranlarının Toplamı %100den fazla olamaz'> !");
                    return false;
                }	
            }
            if((document.getElementById("add_stock_id").value == '' || document.getElementById("product_name").value == '' ) && ((document.getElementById('operation_type')!= undefined && document.getElementById('operation_type').value =="") || document.getElementById('operation_type') == undefined))
            {
                alert("<cf_get_lang_main no='59.Eksik Veri'> : <cf_get_lang_main no='245.Ürün'> <cf_get_lang_main no='586.veya'> <cf_get_lang_main no='1622.Operasyon'>");
                return false;
            }
            if((document.getElementById("add_stock_id").value != '' && document.getElementById("product_name").value!='') && (document.getElementById('operation_type').value!=''))
            {
                alert("<cf_get_lang no='399.Ürün ve operasyon birlikte seçilemez Lütfen sadece bir tanesini seçiniz'>");
                return false;
            }
            
            if(filterNum(document.getElementById("amount").value,8) == 0)
            {
                alert("<cf_get_lang no='46.Miktar Sıfırdan Büyük Olmalıdır'> !");
                return false;
            }
            
            if((document.getElementById("add_stock_id").value == '' && document.getElementById("product_name").value == '') && document.getElementById("add_stock_id").value == document.getElementById("main_stock_id").value)
            {
                alert("Ürüne Kendisini Ekleyemezsiniz!"); 
                return false;
            }
            document.getElementById("amount").value=filterNum(document.getElementById("amount").value,8);
            document.getElementById("fire_amount").value=filterNum(document.getElementById("fire_amount").value,8);
            document.getElementById("fire_rate").value=filterNum(document.getElementById("fire_rate").value,8);
            document.getElementById("process_stage_").value = document.getElementById("process_stage").value;
            return process_cat_control();
        }
        function kontrol_process_2()
        {
            if(process_cat_control())
                windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&run_function=copy_product_func&is_production=1&run_function_param=id','page');
            else
                return false;
        }
        function kontrol_process_3()
        {
            if(process_cat_control())
            {
                if(confirm("<cf_get_lang no='53.Ürün Ağacının Bileşenleri Silinecektir'> , <cf_get_lang no='54.Yaptığınız İşlem Geri Alınamaz'> ! <cf_get_lang_main no='1176.Emin misiniz'>?"))
                {
                    add_versiyon.action='<cfoutput>#request.self#?fuseaction=prod.emptypopup_del_product_tree</cfoutput>';
                    add_versiyon.submit();
                }
                else
                    return false;
            }
            else
                return false;
        }
        function kontrol_process()
        {
            return process_cat_control();
        }
        function goto_page()
        {
            for (var i = 0; i < add_sub_product.stock_select.options.length; i++){
               if (add_sub_product.stock_select.options[i].selected)
                my_val=add_sub_product.stock_select.options[i].value;
            }
            if(my_val!=0)
            window.location.href="<cfoutput>#request.self#</cfoutput>?fuseaction=prod.add_product_tree&stock_id=" + my_val;
        }
        function pencere(say)
        {
            str_link="<cfoutput>#request.self#?fuseaction=prod.popup_upd_sub_product#xml_str#&history_stock=#attributes.stock_id#</cfoutput>&pro_tree_id=" + say;
            windowopen(str_link,'medium');
        }
    </script>
</cfif>
<cfscript>
	// Switch //
	WOStruct = StructNew();
	WOStruct['#attributes.fuseaction#'] = structNew();
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	
	if(not isdefined('attributes.event'))
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];
	
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'prod.list_product_tree';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'production_plan/display/list_product_tree.cfm';
	WOStruct['#attributes.fuseaction#']['list']['queryPath'] = 'production_plan/display/list_product_tree.cfm';
	WOStruct['#attributes.fuseaction#']['list']['nextEvent'] = 'prod.list_product_tree';
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'prod.list_product_tree&event=upd';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'production_plan/display/add_product_tree.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'production_plan/query/add_sub_product.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'prod.list_product_tree&event=upd';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'stock_id=##attributes.stock_id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.stock_id##';
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'prod.list_product_tree&event=add';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'production_plan/display/add_product_tree.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'objects/query/add_spect_main_ver.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'prod.list_product_tree&event=add';
	
	if(attributes.event is 'upd')
	{
		if(attributes.stock_id gt 0)
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd'] = structNew();
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'] = structNew();
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['text'] = '#lang_array_main.item[61]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['onClick'] = "windowopen('#request.self#?fuseaction=prod.popup_product_tree_history&stock_id=#attributes.stock_id#','medium','popup_member_history')";
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['text'] = '#lang_array_main.item[235]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_list_spect_main&stock_id=#attributes.stock_id#','page')";
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][2]['text'] = '#lang_array_main.item[846]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][2]['href'] = "#request.self#?fuseaction=prod.product_tree_costs&stock_id=#attributes.stock_id#";
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][3]['text'] = '#lang_array_main.item[305]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][3]['onClick'] = "windowopen('#request.self#?fuseaction=product.popup_product_guaranty&pid=#get_product.product_id#','medium')";
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][4]['text'] = '#lang_array.item[337]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][4]['onClick'] = "windowopen('#request.self#?fuseaction=product.popup_product_quality&pid=#get_product.product_id#','longpage')";
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][5]['text'] = '#lang_array.item[519]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][5]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_list_related_trees&stock_id=#attributes.stock_id#','project')";
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][6]['text'] = '#lang_array_main.item[40]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][6]['href'] = "#request.self#?fuseaction=stock.list_stock&event=upd&pid=#get_product.product_id#";
			if(get_module_user(5)){
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][7]['text'] = '#lang_array_main.item[245]#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][7]['href'] = "#request.self#?fuseaction=product.list_product&event=det&pid=#get_product.PRODUCT_ID#&sid=#attributes.stock_id#";
			}else{
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][7]['text'] = '#lang_array.item[56]#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][7]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_detail_product&pid=#get_product.product_id#&sid=#attributes.stock_id#','page')";
			}
			if(get_product_conf.recordcount){
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][8]['text'] = '#lang_array.item[57]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][8]['onClick'] = "windowopen('#request.self#?fuseaction=product.popup_upd_product_configuration&id=#get_product_conf.PRODUCT_CONFIGURATOR_ID#','longpage')";
			}

			tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
		}
	}
</cfscript>
