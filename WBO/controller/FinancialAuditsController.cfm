<cfsavecontent variable="Detay"><cf_get_lang dictionary_id="57771.Detay"></cfsavecontent>
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
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'account.financial_audit_table_definition';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/account/display/list_financial_table_definition.cfm';	
		WOStruct['#attributes.fuseaction#']['list']['queryPath'] = 'V16/account/display/list_financial_table_definition.cfm';	

		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'account.financial_audit_table_definition';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/account/form/add_financial_table_definition.cfm';	
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'V16/account/query/add_financial_audit_table_definition.cfm';	
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'account.financial_audit_table_definition';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'account.financial_audit_table_definition&event=upd&audit_id=';

		if(isdefined("attributes.audit_id")){
			WOStruct['#attributes.fuseaction#']['upd'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'account.financial_audit_table_definition';
			WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'V16/account/form/add_financial_table_definition.cfm';	
			WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'V16/account/query/add_financial_audit_table_definition.cfm';	
			WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.audit_id#';
			WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'account.financial_audit_table_definition&event=upd&audit_id=';

			WOStruct['#attributes.fuseaction#']['del'] = structNew();
			WOStruct['#attributes.fuseaction#']['del']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=account.emptypopup_financial_audit_table_definition&audit_id=#attributes.audit_id#';
			WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16/account/query/del_financial_audit_table_definition.cfm';
			WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/account/query/del_financial_audit_table_definition.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.audit_id#';
			WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'account.financial_audit_table_definition';
		}
		
		
	}else{
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
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=account.financial_audit_table_definition";

			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";
		}
		else if(caller.attributes.event is 'upd')
		{
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['target'] = "_blank";
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=account.financial_audit_table_definition";
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";

		}
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
</cfscript>