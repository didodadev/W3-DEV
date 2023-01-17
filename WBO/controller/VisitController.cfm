<cfscript>
	if(attributes.tabMenuController eq 0)
	{
		WOStruct = StructNew();
		
		WOStruct['#attributes.fuseaction#'] = structNew();
		
		WOStruct['#attributes.fuseaction#']['default'] = 'add';
		if(not isdefined('attributes.event')){
			attributes.event = WOStruct['#attributes.fuseaction#']['default'];
		}
		
		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'popup';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'objects.event_plan_result';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/objects/form/add_event_plan_result.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'V16/objects/query/add_event_plan_result.cfm';
		
		
		


		if(isdefined("attributes.event_plan_row_id"))
		{
	
			WOStruct['#attributes.fuseaction#']['upd'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd']['window'] = 'popup';
			WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'objects.event_plan_result';
			WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'V16/objects/form/upd_event_plan_result.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'objects.event_plan_result&event=upd&event_plan_row_id=';
			WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'V16/objects/query/upd_event_plan_result.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.event_plan_row_id#';
		}
		
	}
    else
 {
    fuseactController = caller.attributes.fuseaction;
		getLang = caller.getLang;

		tabMenuStruct = StructNew();
		tabMenuStruct['#fuseactController#'] = structNew();
		tabMenuStruct['#fuseactController#']['tabMenus'] = structNew();
    
   
       
        tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
   

    } 
</cfscript>