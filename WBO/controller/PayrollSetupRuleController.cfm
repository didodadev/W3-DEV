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
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'ehesap.list_program_parameters';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/hr/ehesap/display/list_program_parameters.cfm';
		
		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'ehesap.form_add_program_parameters';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/hr/ehesap/form/add_program_parameters.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'V16/hr/ehesap/query/add_program_parameters.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'ehesap.list_program_parameters&event=upd&parameter_id=';	
		
		if(isdefined("attributes.parameter_id"))
		{
			WOStruct['#attributes.fuseaction#']['upd'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'ehesap.form_upd_program_parameters';
			WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'V16/hr/ehesap/form/upd_program_parameters.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'V16/hr/ehesap/query/upd_program_parameters.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.parameter_id#';
			WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'ehesap.list_program_parameters&event=upd&parameter_id=';
			
			WOStruct['#attributes.fuseaction#']['copy'] = structNew();
			WOStruct['#attributes.fuseaction#']['copy']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['copy']['fuseaction'] = 'ehesap.form_copy_program_parameters';
			WOStruct['#attributes.fuseaction#']['copy']['filePath'] = 'V16/hr/ehesap/form/copy_program_parameters.cfm';
			WOStruct['#attributes.fuseaction#']['copy']['queryPath'] = 'V16/hr/ehesap/query/copy_program_parameters.cfm';
			WOStruct['#attributes.fuseaction#']['copy']['Identity'] = '#attributes.parameter_id#';
			WOStruct['#attributes.fuseaction#']['copy']['nextEvent'] = 'ehesap.list_program_parameters&event=upd&parameter_id=';
			
			WOStruct['#attributes.fuseaction#']['del'] = structNew();
			WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
			WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=ehesap.emptypopup_del_program_parameters&parameter_id=#parameter_id#';
			WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16/hr/ehesap/query/del_program_parameters.cfm';
			WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/hr/ehesap/query/del_program_parameters.cfm';
			WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'ehesap.list_program_parameters';
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
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=ehesap.list_program_parameters";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";
		}
		else if(caller.attributes.event is 'upd')
		{
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=ehesap.list_program_parameters";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('main',170)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=ehesap.list_program_parameters&event=add";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['copy']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['copy']['href'] = "#request.self#?fuseaction=ehesap.list_program_parameters&event=copy&parameter_id=#attributes.parameter_id#";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['copy']['target'] = "_blank";
		}
		else if(caller.attributes.event is 'copy')
		{
			tabMenuStruct['#fuseactController#']['tabMenus']['copy']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['copy']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['copy']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['copy']['icons']['list-ul']['href'] = "#request.self#?fuseaction=ehesap.list_program_parameters";
			tabMenuStruct['#fuseactController#']['tabMenus']['copy']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['copy']['icons']['check']['onClick'] = "buttonClickFunction()";
			tabMenuStruct['#fuseactController#']['tabMenus']['copy']['icons']['add']['text'] = '#getLang('main',170)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['copy']['icons']['add']['href'] = "#request.self#?fuseaction=ehesap.list_program_parameters&event=add";
			tabMenuStruct['#fuseactController#']['tabMenus']['copy']['icons']['add']['target'] = "_blank";
		}
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
	WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd,copy';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'SETUP_PROGRAM_PARAMETERS';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'PARAMETER_ID';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-parameter_name','item-date','item-stamp_tax_binde','item-DENUNCIATION_1','item-DENUNCIATION_2','item-DENUNCIATION_3','item-DENUNCIATION_4','item-DENUNCIATION_5','item-DENUNCIATION_6'
																			,'item-EX_TIME_LIMIT','item-OVERTIME_YEARLY_HOURS','item-overtime_hours','item-yearly_payment_count','item-yearly_payment_limit','item-sakat_alt','item-sakat_percent','item-eski_hukumlu_percent','item-teror_magduru_percent']";
</cfscript>
