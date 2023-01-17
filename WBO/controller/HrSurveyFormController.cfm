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
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'hr.list_detail_survey_report';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/objects/display/list_detail_survey_report.cfm';
			
		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'objects.popup_form_add_detail_survey';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = '/V16/objects/form/form_add_detail_survey.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = '/V16/objects/query/emptypopup_add_detail_survey.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'hr.list_detail_survey_report&event=upd&survey_id=';
		
		if(isdefined("attributes.survey_id"))
		{	
			WOStruct['#attributes.fuseaction#']['upd'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'objects.popup_form_upd_detail_survey';
			WOStruct['#attributes.fuseaction#']['upd']['filePath'] = '/V16/objects/form/form_upd_detail_survey.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = '/V16/objects/query/emptypopup_upd_detail_survey.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.survey_id#';
			WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'hr.list_detail_survey_report&event=upd&survey_id=';
			
			WOStruct['#attributes.fuseaction#']['del'] = structNew();
			WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
			WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=objects.emptypopup_del_detail_survey&survey_main_id=#attributes.survey_id#';
			WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16/objects/query/del_detail_survey.cfm';
			WOStruct['#attributes.fuseaction#']['del']['extraParams'] = 'survey_id';
			WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/objects/query/del_detail_survey.cfm';
			WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'hr.list_detail_survey_report&action_type=6,7,10,14';
			
			WOStruct['#attributes.fuseaction#']['report'] = structNew();
			WOStruct['#attributes.fuseaction#']['report']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['report']['fuseaction'] = 'hr.list_participants_report';
			WOStruct['#attributes.fuseaction#']['report']['filePath'] = '/V16/objects/display/list_participants_report.cfm';
			WOStruct['#attributes.fuseaction#']['report']['queryPath'] = '/V16/objects/display/list_participants_report.cfm';
			WOStruct['#attributes.fuseaction#']['report']['Identity'] = '#attributes.survey_id#';
			WOStruct['#attributes.fuseaction#']['report']['nextEvent'] = 'hr.list_detail_survey_report&event=report&survey_id=';
			
		}
		
		
		WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
		WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'SURVEY_MAIN';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'SURVEY_MAIN_ID';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-active','item-type','item-head']";
	}
	else
	{
		fuseactController = caller.attributes.fuseaction;
		// Tab Menus //
		tabMenuStruct = StructNew();
	
		tabMenuStruct['#fuseactController#'] = structNew();
		tabMenuStruct['#fuseactController#']['tabMenus'] = structNew();
		
		getLang = caller.getLang;

		if(isdefined("attributes.event") and attributes.event is 'add')
		{
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=hr.list_detail_survey_report&action_type=#attributes.action_type#";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";	
		}
		else if(isdefined("attributes.event") and attributes.event is 'upd')
		{
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=hr.list_detail_survey_report&action_type=#caller.get_survey.type#";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('main',170)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=hr.list_detail_survey_report&event=add&action_type=#caller.get_survey.type#";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";	
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['copy']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['copy']['text'] = '#getLang('main',64)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['copy']['href'] = "#request.self#?fuseaction=objects.emptypopup_detail_survey_copy&survey_main_id=#attributes.survey_id#";
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][0]['text'] = '#getLang('main',2041)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][0]['onClick'] = "tumunu_iliskilendir()";
		}
		else if(isdefined("attributes.event") and attributes.event is 'report')
		{
			tabMenuStruct['#fuseactController#']['tabMenus']['report']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['report']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['report']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['report']['icons']['list-ul']['href'] = "#request.self#?fuseaction=hr.list_detail_survey_report&action_type=#attributes.action_type_#";
			tabMenuStruct['#fuseactController#']['tabMenus']['report']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['report']['icons']['check']['onClick'] = "buttonClickFunction()";	
		}
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
		
	}
</cfscript>
