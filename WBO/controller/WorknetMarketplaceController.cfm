<cfscript>
    if(attributes.tabMenuController eq 0)
    {
        WOStruct = StructNew();
        WOStruct['#attributes.fuseaction#'] = structNew();
        WOStruct['#attributes.fuseaction#']['default'] = 'list';

        WOStruct['#attributes.fuseaction#']['list'] = structNew();
        WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'worknet.list_worknet';
        WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/worknet/display/list_worknet.cfm';

        WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'worknet.list_worknet';
        WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/worknet/form/add_worknet.cfm';
        WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'V16/worknet/query/add_worknet.cfm';
        WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'worknet.list_worknet&event=upd&wid=';


       
		if(isdefined("attributes.event") and listFind('del,upd',attributes.event))
			{	
				WOStruct['#attributes.fuseaction#']['upd'] = structNew();
				WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
				WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'worknet.list_worknet';
				WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'V16/worknet/form/upd_worknet.cfm';
				WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'V16/worknet/query/upd_worknet.cfm';
				WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'worknet.list_worknet&event=upd&wid=';
				WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.wid#';
     
				WOStruct['#attributes.fuseaction#']['del'] = structNew();
				WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
				WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,".")#.list_worknet&wid=#attributes.wid#';
				WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16/worknet/query/del_worknet.cfm';
				WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/worknet/query/del_worknet.cfm';
				WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'worknet.list_worknet';
			} 
    }
    else
	{
		fuseactController = caller.attributes.fuseaction;
		getLang = caller.getLang;
		
		tabMenuStruct = StructNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'] = structNew();
		if((isdefined("attributes.event") and attributes.event is 'add') or (isdefined("attributes.event") and attributes.event is 'upd'))
        {
			if(attributes.event is 'upd'){
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('main',170,'ekle')#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=worknet.list_worknet&event=add";
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
			}
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons'] = structNew();
            tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['target'] = "_blank";
            tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=worknet.list_worknet";

        }
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
</cfscript>