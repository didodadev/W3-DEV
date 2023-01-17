<cfscript>
	if(attributes.tabMenuController eq 0)
	{
		WOStruct = StructNew();
		
		WOStruct['#attributes.fuseaction#'] = structNew();	
		
		WOStruct['#attributes.fuseaction#']['default'] = 'list';
		if(not isdefined('attributes.event'))
			attributes.event = WOStruct['#attributes.fuseaction#']['default'];
	
		WOStruct['#attributes.fuseaction#']['list'] = structNew();
		WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal'; 
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'finance.list_stores_daily_reports';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/finance/display/list_stores_daily_reports.cfm'; 	
		WOStruct['#attributes.fuseaction#']['list']['nextEvent'] = '';

       

        WOStruct['#attributes.fuseaction#']['addSub'] = structNew();
        WOStruct['#attributes.fuseaction#']['addSub']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['addSub']['fuseaction'] = 'finance.list_stores_daily_reports';
        WOStruct['#attributes.fuseaction#']['addSub']['filePath'] = 'V16/finance/form/add_daily_report.cfm';
        WOStruct['#attributes.fuseaction#']['addSub']['queryPath'] = 'V16/finance/query/add_daily_reports.cfm';

        WOStruct['#attributes.fuseaction#']['add'] = structNew();
        WOStruct['#attributes.fuseaction#']['add']['window'] = 'popup';
        WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'finance.popup_add_daily_sales_report_store';
        WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/finance/form/add_daily_sales_report_stores.cfm';
        WOStruct['#attributes.fuseaction#']['add']['queryPath'] = '';

        WOStruct['#attributes.fuseaction#']['upd'] = structNew();
        WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'finance.upd_daily_report';
        WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'V16/finance/form/upd_daily_report.cfm';
        WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'V16/finance/query/upd_daily_report.cfm';

        WOStruct['#attributes.fuseaction#']['del'] = structNew();
        WOStruct['#attributes.fuseaction#']['del']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'finance.emptypopup_del_daily_report';
        WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16/finance/query/del_daily_report.cfm';
        WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/finance/query/del_daily_report.cfm';

        

            
		
	}else{
        fuseactController = caller.attributes.fuseaction;
		// Tab Menus //
		tabMenuStruct = StructNew();
	
		tabMenuStruct['#fuseactController#'] = structNew();
		tabMenuStruct['#fuseactController#']['tabMenus'] = structNew();
        getLang = caller.getLang;
		
		if(isdefined("attributes.event") and attributes.event is 'addSub')
		{

			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['addSub']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['addSub']['icons']['list-ul']['href'] = "#request.self#?fuseaction=finance.list_stores_daily_reports";
			
	
        }
        

        if(isdefined("attributes.event") and attributes.event is 'upd')
		{
            get_daily_store_report  = caller.get_daily_store_report;
            DATEFORMAT_STYLE =caller.DATEFORMAT_STYLE;
            
            tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#getlang('main',170)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['onClick'] = "openBoxDraggable('#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_stores_daily_reports&event=add&field_id=get_store_ids.store_ids');";
			

			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=finance.list_stores_daily_reports";
            tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['text'] = '#getLang('main',62)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_print_files&id=#attributes.id#&print_type=125','page');";
            
        }
        
        tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);

    }
    
	
</cfscript>