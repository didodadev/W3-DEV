<cfscript>
	if(attributes.tabMenuController eq 0)
	{
		WOStruct = StructNew();
		WOStruct['#attributes.fuseaction#'] = structNew();
		WOStruct['#attributes.fuseaction#']['default'] = 'list';
		WOStruct['#attributes.fuseaction#']['list'] = structNew();
		WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'finance.list_daily_zreport';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/finance/display/list_daily_zreport.cfm';
		
		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'finance.add_daily_zreport';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/finance/form/add_daily_zreport.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'V16/finance/query/add_daily_zreport.cfm';

		
		WOStruct['#attributes.fuseaction#']['upd'] = structNew();
		WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'finance.list_daily_zreport';
		WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'V16/finance/form/upd_daily_zreport.cfm';
		WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'V16/finance/query/upd_daily_zreport.cfm';
		
		if(isdefined("attributes.event") and (attributes.event is "upd" or attributes.event is "del"))
		{
		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
		WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'finance.emptypopup_upd_daily_zreport&INVOICE_NUMBER=##caller.get_sale_det.INVOICE_number##&old_process_type=##caller.get_sale_det.INVOICE_CAT##&process_cat=##caller.get_sale_det.process_cat##&active_period=#session.ep.period_id#&invoice_id=##caller.attributes.iid##&del_invoice_id=##caller.attributes.iid##';
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16/finance/query/upd_daily_zreport.cfm';
		WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/finance/query/upd_daily_zreport.cfm';
		WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'finance.list_daily_zreport';
		}
		

        
    }else
    {
		fuseactController = caller.attributes.fuseaction;
		getLang = caller.getLang;
		get_module_user = caller.get_module_user;
		// Tab Menus //
		tabMenuStruct = StructNew();
		tabMenuStruct['#attributes.fuseaction#'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus'] = structNew();
		
		if(isdefined("attributes.event") and attributes.event is 'add')
		{
			
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=finance.list_daily_zreport";
			
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";
			
			
		}
		else if (isdefined("attributes.event") and attributes.event is 'upd') {

			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();

			if (!listfindnocase(caller.denied_pages,'finance.add_daily_report')) {
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('','Ekle','57582')#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=finance.list_daily_zreport&event=add";
			}
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('','Liste','57509')#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=finance.list_daily_zreport";

			if (get_module_user(22)) {
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-table']['text'] = '#getLang('main','Mahsup Fişi',58452)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-table']['onclick'] = "windowopen('#request.self#?fuseaction=account.popup_list_card_rows&action_id=#attributes.iid#&process_cat='+form_basket.old_process_type.value,'page','upd_bill');";
			}
			
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['print']['text'] = '#getLang('','Yazdır',57474)#';
      		tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['print']['onClick'] = "window.open('#request.self#?fuseaction=objects.popup_print_files&print_type=140&iid=#attributes.iid#','list')";
		}
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
    }
      
</cfscript>