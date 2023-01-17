<cfscript>
	if(attributes.tabMenuController eq 0)
	{
		WOStruct = StructNew();
		
		WOStruct['#attributes.fuseaction#'] = structNew();
		
		WOStruct['#attributes.fuseaction#']['default'] = 'list';
		
		WOStruct['#attributes.fuseaction#']['list'] = structNew();
		WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'credit.list_credit_limit';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/credit/display/list_credit_limit.cfm';
		
		
		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'popup';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'popup_form_add_credit_limit';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/credit/form/add_credit_limit.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'V16/credit/query/add_credit_limit.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'credit.list_credit_limit';
		WOStruct['#attributes.fuseaction#']['add']['formName'] = 'add_work';



		WOStruct['#attributes.fuseaction#']['upd'] = structNew();
		WOStruct['#attributes.fuseaction#']['upd']['window'] = 'popup';
		WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'popup_form_add_credit_limit';
		WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'V16/credit/form/add_credit_limit.cfm';
		WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'V16/credit/query/add_credit_limit.cfm';
		WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'credit.list_credit_limit&event=upd&event=upd';
		WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'credit_limit_id=##attributes.credit_limit_id##';
		WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.credit_limit_id##';
		
		
	/*	if(IsDefined("attributes.event") && (attributes.event is 'upd' || attributes.event is 'del'))
		{
			//WOStruct['#attributes.fuseaction#']['del'] = structNew();
			WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
			WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'project.emptypopup_delwork';
			WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16/project/query/del_work.cfm';
			WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/project/query/del_work.cfm';
			WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'project.works';
		}*/
		
		
		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
		WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'credit.emptypopup_del_credit_limit';
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16/credit/query/del_credit_limit.cfm';
		WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/credit/query/del_credit_limit.cfm';
		WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'project.works&event=list';
		WOStruct['#attributes.fuseaction#']['del']['parameters'] = 'credit_limit_id=##attributes.credit_limit_id##';
		WOStruct['#attributes.fuseaction#']['del']['Identity'] = '##attributes.credit_limit_id##';
		
	}
	else{
		fuseactController = caller.attributes.fuseaction;
		// Tab Menus //
		tabMenuStruct = StructNew();
	
		tabMenuStruct['#fuseactController#'] = structNew();
		tabMenuStruct['#fuseactController#']['tabMenus'] = structNew();
		
		if(isdefined("attributes.event") and (attributes.event is 'add'))
		{
			getLang = caller.getLang;
			
			tabMenuStruct['#fuseactController#']['tabMenus']['add'] = structNew();
			
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['text'] = '#getLang(97,"Liste",57509)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=credit.list_credit_limit";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction();";
		}

		if(isdefined("attributes.event") and (attributes.event is 'upd'))
		{			
			getLang = caller.getLang;
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd'] = structNew();
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('main',170)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=credit.list_credit_limit&event=add";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=credit.list_credit_limit";
			
		}

		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	

</cfscript>
