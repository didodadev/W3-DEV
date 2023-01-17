
<cfscript>
	// Switch //
	if(attributes.tabMenuController eq 0)
	{	
		WOStruct = StructNew();
		WOStruct['#attributes.fuseaction#'] = structNew();
		WOStruct['#attributes.fuseaction#']['default'] = 'list';
		
		WOStruct['#attributes.fuseaction#']['list'] = structNew();
		WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'settings.list_detail_survey';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/objects/display/list_detail_survey.cfm';
        WOStruct['#attributes.fuseaction#']['list']['queryPath'] = 'V16/objects/display/list_detail_survey.cfm';

		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'settings.form_add_detail_survey';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/objects/form/form_add_detail_survey.cfm';		
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'V16/objects/query/emptypopup_add_detail_survey.cfm';
        WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'settings.list_detail_survey&event=upd&survey_id=';


        if(isdefined("attributes.survey_id"))
		{	
			WOStruct['#attributes.fuseaction#']['upd'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'settings.form_upd_detail_survey';
			WOStruct['#attributes.fuseaction#']['upd']['filePath'] = '/V16/objects/form/form_upd_detail_survey.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = '/V16/objects/query/emptypopup_upd_detail_survey.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.survey_id#';
			WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'settings.list_detail_survey&event=upd&survey_id=';
			
			
			WOStruct['#attributes.fuseaction#']['del'] = structNew();
			WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
			WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=objects.emptypopup_del_detail_survey&survey_main_id=#attributes.survey_id#';
			WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16/objects/query/del_detail_survey.cfm';
			WOStruct['#attributes.fuseaction#']['del']['extraParams'] = 'survey_id';
			WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/objects/query/del_detail_survey.cfm';
			WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'settings.list_detail_survey';
		
			WOStruct['#attributes.fuseaction#']['report'] = structNew();
			WOStruct['#attributes.fuseaction#']['report']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['report']['fuseaction'] = 'objects.list_detail_survey_report';
			WOStruct['#attributes.fuseaction#']['report']['filePath'] = '/V16/objects/display/list_detail_survey_report.cfm';
			WOStruct['#attributes.fuseaction#']['report']['queryPath'] = '/V16/objects/display/list_detail_survey_report.cfm';
			WOStruct['#attributes.fuseaction#']['report']['Identity'] = '#attributes.survey_id#';
			WOStruct['#attributes.fuseaction#']['report']['nextEvent'] = 'settings.list_detail_survey&event=report&survey_id=';
			
		}
	
        
	}
	else
	{
		fuseactController = caller.attributes.fuseaction;
		// Tab Menus //
		tabMenuStruck = StructNew();

		tabMenuStruck['fuseactController'] = structNew();
		tabMenuStruct['#fuseactController#']['tabMenus'] = structNew();

		getLang = caller.getLang;

		if(isdefined("attributes.event") and attributes.event is 'add')
		{
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=settings.list_detail_survey";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";	
		}
		else if(isdefined("attributes.event") and attributes.event is 'upd')
		{
			get_survey = caller.get_survey;
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=settings.list_detail_survey";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('main',170)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=settings.list_detail_survey&event=add";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";	
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['copy']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['copy']['text'] = '#getLang('main',64)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['copy']['href'] = "#request.self#?fuseaction=settings.list_detail_survey&event=add&survey_id=#attributes.survey_id#";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['icon-md wrk-uF0020']['text'] = '#getlang("","",57434)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['icon-md wrk-uF0020']['href'] = "#request.self#?fuseaction=settings.list_detail_survey_employee&survey_id=#attributes.survey_id#&type=#get_survey.type#&form_submitted=1";

		}

		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);

	}
	
	
	WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
	WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'SURVEY_MAIN';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'SURVEY_MAIN_ID';
</cfscript>