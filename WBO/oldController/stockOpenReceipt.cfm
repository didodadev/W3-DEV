<cfif not isdefined("attributes.event") or attributes.event is 'add'>
    <cfinclude template="../stock/query/get_shipment_method.cfm">
    <cfscript>session_basket_kur_ekle(process_type:0);</cfscript>
    <cf_papers paper_type="stock_fis">
    <cfset system_paper_no=paper_code & '-' & paper_number>
    <cfset system_paper_no_add=paper_number>
	<cfset attributes.basket_id = 13>
	<cfset attributes.form_add = 1>
<cfelseif isdefined("attributes.event") and attributes.event is 'upd'>
	<cfset attributes.ship_id = attributes.upd_id>
	<cfscript>session_basket_kur_ekle(action_id=attributes.upd_id,table_type_id:6,process_type:1);</cfscript>
    <cfinclude template="../stock/query/get_fis_det.cfm">
    <cfif not get_fis_det.recordcount>
      <br/><font class="txtbold"><cf_get_lang_main no='1531.Böyle Bir Kayıt Bulunmamaktadır'> !</font>
      <cfexit method="exittemplate">
    </cfif>
    <cfinclude template="../stock/query/get_shipment_method.cfm">
    <cfset fis_type = get_fis_det.fis_type>
    <cfset attributes.basket_id = 13>
</cfif>
<script type="text/javascript">
<cfif not isdefined("attributes.event") or attributes.event is 'add'>
	function kontrol_kayit()
	{
		if(!chk_process_cat('form_basket')) return false;
		if(!check_display_files('form_basket')) return false;
		if(!chk_period(form_basket.deliver_date_frm,"İşlem")) return false;
		if(form_basket.department_in.value == "" || form_basket.txt_departman_in.value=="")
		{
			alert("<cf_get_lang_main no ='311.Depo Seçiniz'>!");
			return false;
		}
		saveForm();
		return false;
	}
<cfelseif isdefined("attributes.event") and attributes.event is 'upd'>	
	function kontrol_firma()
	{
		if(!chck_zero_stock()) return false;
		if(!chk_process_cat('form_basket')) return false;
		if(!check_display_files('form_basket')) return false;
		if(!chk_period(form_basket.deliver_date_frm,"İşlem")) return false;
		saveForm();
		return false;
	}
	
	function kontrol2()
	{
		if(!chck_zero_stock(1)) return false; //sadece silme işleminden cagrılırken 1 gönderiliyor
		form_basket.DEL_ID.value = <cfoutput>#attributes.upd_id#</cfoutput>;
		if(!check_display_files('form_basket')) return false;
		form_basket.action = '<cfoutput>#request.self#</cfoutput>?fuseaction=stock.emptypopup_upd_open_fis_process';
		form_basket.submit();
		return true;	
	}
	function chck_zero_stock(is_del)
	{ 
		if(check_stock_action('form_basket'))
		{
			var basket_zero_stock_status = wrk_safe_query('inv_basket_zero_stock_status','dsn3',0,<cfoutput>#attributes.basket_id#</cfoutput>);
			if(basket_zero_stock_status.IS_SELECTED != 1)//<!--- basket sablonunda sıfır stok ile calıs secilmemisse zero_stock kontrolu yapılır --->
			{
				var temp_process_cat = document.form_basket.process_cat.options[document.form_basket.process_cat.selectedIndex].value;
				var temp_process_type = eval("document.form_basket.ct_process_type_" + temp_process_cat);
				if(!zero_stock_control(form_basket.department_in.value,form_basket.location_in.value,form_basket.upd_id.value,temp_process_type.value,0,is_del)) return false;
			}
		}
		return true;
	}
</cfif>
</script>
<cfscript>
	// Switch //
	WOStruct = StructNew();
	WOStruct['#attributes.fuseaction#'] = structNew();
	WOStruct['#attributes.fuseaction#']['default'] = 'add';
	if(not isdefined('attributes.event'))
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];
		
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'stock.form_add_ship_open_fis';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'stock/form/form_stock_open_fis.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'stock/query/add_ship_open_fis.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'stock.form_add_ship_open_fis&event=upd';
	WOStruct['#attributes.fuseaction#']['upd']['js'] = "javascript:gizle_goster_basket(add_ship_open_fis)";

	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'stock.form_add_ship_open_fis&event=upd';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'stock/form/form_upd_stock_open_fis.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'stock/query/upd_ship_open_fis.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'stock.form_add_ship_open_fis&event=upd';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'upd_id=##attributes.upd_id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.upd_id##';
	WOStruct['#attributes.fuseaction#']['upd']['js'] = "javascript:gizle_goster_basket(stock_open_fis)";
	
	if(attributes.event is 'upd')       
	{

		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['text'] = '#lang_array_main.item[345]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_page_warnings&action=stock.form_add_ship_open_fis&action_name=upd_id&action_id=#attributes.upd_id#','list')";
		if( session.ep.our_company_info.guaranty_followup)
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['text'] = '#lang_array_main.item[305]# #lang_array_main.item[306]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['href'] = "#request.self#?fuseaction=stock.list_serial_operations&is_filtre=1&belge_no=#get_fis_det.fis_number#&process_cat_id=#fis_type#&process_id=#get_fis_det.FIS_ID#";
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['target'] = "blank_";
		}
				
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#lang_array_main.item[170]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=stock.form_add_ship_open_fis&event=add";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['text'] = '#lang_array_main.item[62]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_print_files&action_id=#get_fis_det.FIS_ID#&print_type=31','page','workcube_print')";
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	
	WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
	WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'stockOpenReceipt';
	WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'STOCK_FIS';
	WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'period';
	if(attributes.event is 'add'){
		WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item-process_cat','item-txt_departman_in','item-fis_no_','item-deliver_date_frm']"; 
	}
	else if(attributes.event is 'upd'){
		WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item-process_cat','item-txt_departman_in','item-FIS_NO','item-deliver_date_frm']";
	}
</cfscript>