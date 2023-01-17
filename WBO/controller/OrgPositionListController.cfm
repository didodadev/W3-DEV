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
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'hr.list_position_cats';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/hr/display/list_position_cat.cfm';
		
		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'hr.form_add_position_cat';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/hr/form/add_position_cat.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = '/V16/hr/query/add_position_cat.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'hr.list_position_cats&event=upd&position_id=';
		
		if(isdefined("attributes.position_id"))
		{
			WOStruct['#attributes.fuseaction#']['upd'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'hr.form_upd_position_cat';
			WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'V16/hr/form/upd_position_cat.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'V16/hr/query/upd_position_cat.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.position_id#';
			WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'hr.list_position_cats&event=upd&position_id=';
			
		}
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
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=hr.list_position_cats";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";
		}
		
		else if(caller.attributes.event is 'upd')
		{
			denied_pages=caller.denied_pages;
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('main',170)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=hr.list_position_cats&event=add";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=hr.list_position_cats";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'] = structNew();
			i=0;

			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('correspondence','temel ücret skalası','51187')#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onclick'] = "openBoxDraggable('#request.self#?fuseaction=hr.popup_basic_wage_scale&position_cat_id=#url.position_id#&year=#session.ep.period_year#');";
			i++;

			if (!listfindnocase(denied_pages,'hr.popup_list_position_cat_norms'))
			{
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('correspondence','Yaş','55745')#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onclick'] = "openBoxDraggable('#request.self#?fuseaction=hr.popup_list_position_cat_norms&position_cat_id=#url.position_id#');";
				i++;
			}
			if (not listfindnocase(denied_pages,'hr.popup_list_employee_career'))
			{
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('','Kariyer Planlama','55976')#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onclick'] = "openBoxDraggable('#request.self#?fuseaction=hr.popup_add_employee_career&position_cat_id=#url.position_id#');";
				i++;	
			}
			if (not listfindnocase(denied_pages,'hr.popup_add_position_cat_requirements'))
			{
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('','Pozisyon Gereklilikleri','55979')#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onclick'] = "openBoxDraggable('#request.self#?fuseaction=hr.popup_add_position_cat_requirements&position_cat_id=#url.position_id#');";
				i++;	
			}
			if (not listfindnocase(denied_pages,'hr.popup_form_add_position_content'))
			{
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('','Yetki ve Sorumluluklar','55169')#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onclick'] = "openBoxDraggable('#request.self#?fuseaction=hr.popup_form_add_position_content&position_cat_id=#url.position_id#');";
				i++;	
			}
		}
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
	WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'SETUP_POSITION_CAT';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'POSITION_CAT_ID';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-position_cat']";

</cfscript>
