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
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'campaign.list_survey';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/campaign/display/list_survey.cfm';	
		
		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'campaign.form_add_survey';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = '/V16/campaign/form/form_add_survey.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'V16/campaign/query/add_survey.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'campaign.list_survey&event=upd&survey_id=';	
		
		if(isdefined("attributes.survey_id"))
		{
			WOStruct['#attributes.fuseaction#']['upd'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'campaign.form_upd_survey';
			WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'V16/campaign/form/form_upd_survey.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'V16/campaign/query/upd_survey.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.survey_id#';
			WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'campaign.list_survey&event=upd&survey_id=';
			
			WOStruct['#attributes.fuseaction#']['del'] = structNew();
			WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
			WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=campaign.emptypopup_del_survey&survey_id=#attributes.survey_id#&head=##caller.get_survey.survey_head##';
			WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16/campaign/query/del_survey.cfm';
			WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/campaign/query/del_survey.cfm';
			WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'campaign.list_survey';
			
			WOStruct['#attributes.fuseaction#']['dashboard'] = structNew();
			WOStruct['#attributes.fuseaction#']['dashboard']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['dashboard']['fuseaction'] = 'campaign.form_vote_survey';
			WOStruct['#attributes.fuseaction#']['dashboard']['filePath'] = 'V16/campaign/form/form_vote_survey.cfm';
			WOStruct['#attributes.fuseaction#']['dashboard']['queryPath'] = 'V16/campaign/form/form_vote_survey.cfm';
			WOStruct['#attributes.fuseaction#']['dashboard']['Identity'] = '#attributes.survey_id#';
			WOStruct['#attributes.fuseaction#']['dashboard']['nextEvent'] = 'campaign.list_survey&event=upd&survey_id=';

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
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=campaign.list_survey";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";
		}
		else if(caller.attributes.event is 'upd')
		{
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['chart']['text'] = '#getlang('','Grafik','39741')#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['chart']['href'] = "#request.self#?fuseaction=campaign.list_survey&event=dashboard&survey_id=#survey_id#";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('','Ekle','57582')#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=campaign.list_survey&event=add";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('','Liste','57509')#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=campaign.list_survey";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('','Kaydet','59031')#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";
		}
		
		else if(caller.attributes.event is 'dashboard')
		{
			tabMenuStruct['#fuseactcontroller#']['tabMenus']['dashboard']['icons'] = structNew();
			tabMenuStruct['#fuseactcontroller#']['tabMenus']['dashboard']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactcontroller#']['tabMenus']['dashboard']['icons']['list-ul']['text'] = "#getLang('','Liste','57509')#";
			tabMenuStruct['#fuseactcontroller#']['tabMenus']['dashboard']['icons']['list-ul']['href'] = "#request.self#?fuseaction=campaign.list_survey";

			tabMenuStruct['#fuseactcontroller#']['tabMenus']['dashboard']['icons']['fa fa-pencil']['target'] = "_blank";
			tabMenuStruct['#fuseactcontroller#']['tabMenus']['dashboard']['icons']['fa fa-pencil']['text'] = "#getLang('','Güncelle','57464')#";
			tabMenuStruct['#fuseactcontroller#']['tabMenus']['dashboard']['icons']['fa fa-pencil']['href'] = "#request.self#?fuseaction=campaign.list_survey&event=upd&survey_id=#attributes.survey_id#";

		}
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}

</cfscript>
