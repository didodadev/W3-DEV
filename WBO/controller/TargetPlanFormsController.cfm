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
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'hr.list_target_perf';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/hr/display/list_target_perf.cfm';
	
        WOStruct['#attributes.fuseaction#']['add'] = structNew();
        WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'hr.list_target_perf&event=add';
        WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/hr/form/target_plan_forms_info.cfm';
        WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'V16/hr/query/add_target_plan_forms_info.cfm';
        
        if(isdefined("attributes.per_id") and len(attributes.per_id))
		{
            WOStruct['#attributes.fuseaction#']['upd'] = structNew();
            WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
            WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'hr.list_target_perf';
            WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'hr.list_target_perf&event=upd';
            WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'V16/hr/form/upd_target_plan_forms.cfm';
            WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'V16/hr/query/upd_target_plan_forms.cfm';

            WOStruct['#attributes.fuseaction#']['del'] = structNew();
            WOStruct['#attributes.fuseaction#']['del']['window'] = 'normal';
            WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'hr.list_target_perf';
            WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'hr.list_target_perf&event=upd';
            WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16/hr/form/upd_target_plan_forms.cfm';
            WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/hr/query/del_target_plan_forms.cfm';

        }
	}
    else
	{
		fuseactController = caller.attributes.fuseaction;
		getLang = caller.getLang;
		
		tabMenuStruct = StructNew();
		tabMenuStruct['#fuseactController#'] = structNew();
		tabMenuStruct['#fuseactController#']['tabMenus'] = structNew();
        
		
        if(caller.attributes.event is 'upd')
		{
			tabMenuStruct['#fuseactController#']['tabMenus']['list']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['list']['icons']['list-ul']['text'] = '#getLang('','Listele',58715)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['list']['icons']['list-ul']['href'] = "#request.self#?fuseaction=hr.list_target_perf";

			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['add']['text'] = '#getLang('','Listele',58715)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['add']['href'] = "#request.self#?fuseaction=hr.list_target_perf&event=add";
            tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['add']['target'] = "_blank";
		}

        if(caller.attributes.event is 'add')
		{
			tabMenuStruct['#fuseactController#']['tabMenus']['list']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['list']['icons']['list-ul']['text'] = '#getLang('','Listele',58715)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['list']['icons']['list-ul']['href'] = "#request.self#?fuseaction=hr.list_target_perf";
            tabMenuStruct['#fuseactController#']['tabMenus']['list']['icons']['list-ul']['target'] = "_blank";
		}
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	
	}
</cfscript>