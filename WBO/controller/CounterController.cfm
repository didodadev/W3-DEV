<cfscript>
    if(attributes.tabMenuController eq 0)
    {
        WOStruct = StructNew();
        WOStruct['#attributes.fuseaction#'] = structNew();
        WOStruct['#attributes.fuseaction#']['default'] = 'list';

        WOStruct['#attributes.fuseaction#']['list'] = structNew();
        WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'sales.counter';
        WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/sales/display/list_counter.cfm';

        WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'sales.counter';
        WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/sales/form/add_counter.cfm';
        WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'V16/sales/query/add_counter.cfm';
        WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'sales.counter&event=upd&counter_id=';


       
		if(isdefined("attributes.event") and listFind('del,upd',attributes.event))
		{	
			WOStruct['#attributes.fuseaction#']['upd'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'sales.counter';
			WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'V16/sales/form/upd_counter.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'V16/sales/query/upd_counter.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'sales.counter&event=upd&counter_id=';
			WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.counter_id#';
	
			WOStruct['#attributes.fuseaction#']['del'] = structNew();
			WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
			WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,".")#.counter&counter_id=#attributes.counter_id#';
			WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16/sales/query/del_counter.cfm';
			WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/sales/query/del_counter.cfm';
		} 
    }
    else
	{
		fuseactController = caller.attributes.fuseaction;
		getLang = caller.getLang;
		
		tabMenuStruct = StructNew();
		tabMenuStruct['#fuseactController#'] = structNew();
		tabMenuStruct['#fuseactController#']['tabMenus'] = structNew();
		if((isdefined("attributes.event") and attributes.event is 'add') or (isdefined("attributes.event") and attributes.event is 'upd'))
        {
			if(attributes.event is 'upd'){
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('main','ekle',57582)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=sales.counter&event=add";
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
			}
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons'] = structNew();
            tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['target'] = "_blank";
            tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['text'] = '#getLang('main','Liste',57509)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=sales.counter";

        }
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
</cfscript>