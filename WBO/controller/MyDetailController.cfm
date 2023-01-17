<cfscript>

	if(attributes.tabMenuController eq 0)
	{
		WOStruct = StructNew();
		
		WOStruct['#attributes.fuseaction#'] = structNew();	
		
		WOStruct['#attributes.fuseaction#']['default'] = 'add';
		if(not isdefined('attributes.event'))
			attributes.event = WOStruct['#attributes.fuseaction#']['default'];
	
		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'myhome.my_detail';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/myhome/form/upd_my_detail.cfm';
		/* WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'V16/myhome/query/upd_my_detail.cfm'; */
		/* WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'myhome.my_detail'; */
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
			tabMenuStruct['#fuseactController#']['tabMenus']['add'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['menus'][0]['text'] = "#getLang('','Pozisyonum','30793')#";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['menus'][0]['href'] = "#request.self#?fuseaction=myhome.my_position";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['menus'][0]['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['menus'][1]['text'] = "#getLang('','Özgeçmiş','49821')#";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['menus'][1]['href'] = "#request.self#?fuseaction=myhome.my_profile";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['menus'][1]['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['menus'][2]['text'] = "#getLang('','Dashboard','63588')#";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['menus'][2]['href'] = "#request.self#?fuseaction=myhome.dashboard";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['menus'][2]['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['menus'][3]['text'] = "#getLang('','IK İşlemleri','47630')#";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['menus'][3]['href'] = "#request.self#?fuseaction=myhome.hr";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['menus'][3]['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['menus'][4]['text'] = "#getLang('','Diğer İşlemler','48428')#";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['menus'][4]['href'] = "#request.self#?fuseaction=myhome.other_hr";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['menus'][4]['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['print']['text'] = "#getLang('main',62)#";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['print']['onClick'] = "window.open('#request.self#?fuseaction=objects.popup_print_files&action=#attributes.fuseaction#&action_id=#session.ep.userid#&print_type=185','WOC');";
		}
		
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	
</cfscript>