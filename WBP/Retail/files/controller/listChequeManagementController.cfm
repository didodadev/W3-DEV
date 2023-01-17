<cfscript>
	if(attributes.tabMenuController eq 0)
	{
		WOStruct = StructNew();
		
		WOStruct['#attributes.fuseaction#'] = structNew();	
		
		WOStruct['#attributes.fuseaction#']['default'] = 'list';
		if(not isdefined('attributes.event'))
			attributes.event = WOStruct['#attributes.fuseaction#']['default'];


		WOStruct['#attributes.fuseaction#']['list']					= structNew();
		WOStruct['#attributes.fuseaction#']['list']['window']		= 'normal';
		WOStruct['#attributes.fuseaction#']['list']['fuseaction']	= 'retail.list_cheque_management';
		WOStruct['#attributes.fuseaction#']['list']['filePath']		= '/WBP/Retail/files/display/list_cheque_management.cfm';
		WOStruct['#attributes.fuseaction#']['list']['queryPath']	= '/WBP/Retail/files/display/list_cheque_management.cfm';
		
		WOStruct['#attributes.fuseaction#']['add']					= structNew();
		WOStruct['#attributes.fuseaction#']['add']['window']		= 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction']	= 'retail.list_cheque_management';
		WOStruct['#attributes.fuseaction#']['add']['filePath']		= '/WBP/Retail/files/form/cheque_management.cfm';
        WOStruct['#attributes.fuseaction#']['add']['queryPath']		= '/WBP/Retail/files/query/save_cheque_management.cfm';
		WOStruct['#attributes.fuseaction#']['upd']['nextEvent']     = 'retail.list_cheque_management&event=upd&is_submit=1&is_bank=1&table_code=';

		WOStruct['#attributes.fuseaction#']['upd']					= structNew();
		WOStruct['#attributes.fuseaction#']['upd']['window']		= 'normal';
		WOStruct['#attributes.fuseaction#']['upd']['fuseaction']	= 'retail.list_cheque_management';
		WOStruct['#attributes.fuseaction#']['upd']['filePath']		= '/WBP/Retail/files/form/cheque_management.cfm';
        WOStruct['#attributes.fuseaction#']['upd']['queryPath']		= '/WBP/Retail/files/query/save_cheque_management.cfm';
		WOStruct['#attributes.fuseaction#']['upd']['nextEvent']     = 'retail.list_cheque_management&event=upd&is_submit=1&is_bank=1&table_code=';
		WOStruct['#attributes.fuseaction#']['upd']['parameters']    = 'table_code=##attributes.table_code##';
		if(isdefined("attributes.table_code"))
			WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.table_code#';

		if(attributes.event is 'upd' or attributes.event is 'del'){
			WOStruct['#attributes.fuseaction#']['del']					= structNew();
			WOStruct['#attributes.fuseaction#']['del']['window']		= 'normal';
			WOStruct['#attributes.fuseaction#']['del']['fuseaction']	= 'retail.list_cheque_management';
			WOStruct['#attributes.fuseaction#']['del']['filePath']		= '/WBP/Retail/files/query/del_cheque_management.cfm';
			WOStruct['#attributes.fuseaction#']['del']['queryPath']		= '/WBP/Retail/files/query/del_cheque_management.cfm';
			WOStruct['#attributes.fuseaction#']['del']['nextEvent']     = 'retail.list_cheque_management';
			WOStruct['#attributes.fuseaction#']['del']['parameters']    = 'table_code=##attributes.table_code##';
			if(isdefined("attributes.table_code"))
				WOStruct['#attributes.fuseaction#']['del']['Identity'] = '#attributes.table_code#';
		}
	
	}
	else {
		fuseactController = caller.attributes.fuseaction;
		getLang = caller.getLang;
		// Tab Menus //
		tabMenuStruct = StructNew();
		tabMenuStruct['#attributes.fuseaction#'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus'] = structNew();
		
		if(isdefined("attributes.event") and attributes.event is 'add')
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add'] = structNew();
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['menus'] = structNew();
			
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=retail.list_cheque_management";
			
		}
		else if(isDefined("attributes.event") and attributes.event is 'upd'){

			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();    
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['target'] = '_self';
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main', 97)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = '#request.self#?fuseaction=retail.list_cheque_management';
		}
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
</cfscript>