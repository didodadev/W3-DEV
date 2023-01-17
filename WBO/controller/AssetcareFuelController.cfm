<cfscript>
	if(attributes.tabMenuController eq 0)
	{
			
		WOStruct = StructNew();
		
		WOStruct['#attributes.fuseaction#'] = structNew();	
		
		WOStruct['#attributes.fuseaction#']['default'] = 'add';
		if(not isdefined('attributes.event'))
			attributes.event = WOStruct['#attributes.fuseaction#']['default'];
	
		WOStruct['#attributes.fuseaction#']['list'] = structNew();
		WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'assetcare.list_fuel';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/assetcare/display/list_fuel.cfm';

		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'assetcare.form_add_fuel';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/assetcare/form/form_add_fuel.cfm';
		WOStruct['#attributes.fuseaction#']['add']['querypath'] = 'V16/assetcare/query/add_fuel.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'assetcare.list_fuel&event=upd_fuel&fuel_id=';

        if(isdefined("attributes.fuel_id"))
		{
			WOStruct['#attributes.fuseaction#']['upd'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'assetcare.form_upd_fuel';
			WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'V16/assetcare/form/form_upd_fuel.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'V16/assetcare/query/upd_fuel.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.fuel_id#';
			WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'assetcare.list_fuel&event=upd_fuel&fuel_id&assetp_id';
			
			WOStruct['#attributes.fuseaction#']['del'] = structNew();
			WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
			WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=assetcare.emptypopup_del_fuel&fuel_id=#attributes.fuel_id#&plaka=##caller.get_fuel_upd.assetp##&is_detail=1&is_popup=0';
			WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16/assetcare/query/del_fuel.cfm';
			WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/assetcare/query/del_fuel.cfm';
			WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'assetcare.list_fuel&event=fuel';
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
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=assetcare.list_fuel";
		}
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	
	}
</cfscript>