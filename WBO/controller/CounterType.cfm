<cfscript>
    if(attributes.tabMenuController eq 0)
    {
        WOStruct = StructNew();
        WOStruct['#attributes.fuseaction#'] = structNew();
        WOStruct['#attributes.fuseaction#']['default'] = 'list';

        WOStruct['#attributes.fuseaction#']['list'] = structNew();
        WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'settings.counter_type';
        WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/settings/display/list_counter_type.cfm';

        WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'settings.counter_type';
        WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/settings/form/add_counter_type.cfm';
        WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'V16/settings/query/add_counter_type.cfm';
        WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'settings.counter_type&event=upd&ct_id=';

        if(isdefined("attributes.event") and listFind('del,upd',attributes.event))
        {	
            WOStruct['#attributes.fuseaction#']['upd'] = structNew();
            WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
            WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'settings.counter_type';
            WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'V16/settings/form/upd_counter_type.cfm';
            WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'V16/settings/query/upd_counter_type.cfm';
            WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'settings.counter_type&event=upd&ct_id=';
            WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.ct_id#';
            WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'ct_id=##attributes.ct_id##';

            WOStruct['#attributes.fuseaction#']['del'] = structNew();
            WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
            WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,".")#.list_counter_type&ct_id=#attributes.ct_id#';
            WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16/settings/query/del_list_counter_type.cfm';
            WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/settings/query/del_list_counter_type.cfm';
            WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'settings.counter_type';
        }

    }
    else
	{
        getLang = caller.getLang;

        tabMenuStruct = StructNew();
		tabMenuStruct['#attributes.fuseaction#'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus'] = structNew();
		if((isdefined("attributes.event") and attributes.event is 'add') or (isdefined("attributes.event") and attributes.event is 'upd'))
        {
			if(attributes.event is 'upd'){
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('main','ekle',57582)#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=settings.counter_type&event=add";
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
			}
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['icons'] = structNew();
            tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['icons']['list-ul']['target'] = "_blank";
            tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['icons']['list-ul']['text'] = '#getLang('main','Liste',57509)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=settings.counter_type";

        }
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
    }
</cfscript>