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
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'salesplan.targets';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/salesplan/display/list_targets.cfm';

		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'objects.popup_form_add_target';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = '/V16/objects/form/form_add_target.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = '/V16/objects/query/add_target.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'salesplan.targets&event=upd&target_id=&position_code=&sales_plan=';
		WOStruct['#attributes.fuseaction#']['add']['formName'] = 'add_target';
	
		if(isdefined("attributes.target_id"))
		{
			WOStruct['#attributes.fuseaction#']['upd'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'objects.popup_form_upd_target';
			WOStruct['#attributes.fuseaction#']['upd']['filePath'] = '/V16/objects/form/form_upd_target.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = '/V16/objects/query/upd_target.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.target_id#';
			WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'salesplan.targets&event=upd&target_id=&position_code=&sales_plan=';

			WOStruct['#attributes.fuseaction#']['del'] = structNew();
			WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
			WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=objects.del_target&target_id=##caller.get_target.target_id##&head=##caller.get_target.target_head##&cat=##caller.get_target_cats.targetcat_id##';
			WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16/objects/query/del_target.cfm';
			WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/objects/query/del_target.cfm';
			WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'salesplan.targets';
		}
		
		WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
		WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'TARGET';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'TARGET_ID';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-startdate','item-finishdate','item-targetcat_id','item-target_head','item-target_weight']";
	}
	else
	{
		fuseactController = caller.attributes.fuseaction;
		getLang = caller.getLang;
		
		tabMenuStruct = StructNew();
		tabMenuStruct['#fuseactController#'] = structNew();
		tabMenuStruct['#fuseactController#']['tabMenus'] = structNew();
		
		if(caller.attributes.event is 'add')
		{			
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";
			
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=salesplan.targets";
			
		}
		else if(caller.attributes.event is 'upd')
		{
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";

			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('main',170)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=objects.popup_form_add_target";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['target'] = "normal";

			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['target'] = "normal";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=salesplan.targets";

			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['text'] = "#getLang('main',62)#";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['onClick'] = "window.open('#request.self#?fuseaction=objects.popup_print_files&action_id=#attributes.target_id#','page');";

		}
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	
</cfscript>

