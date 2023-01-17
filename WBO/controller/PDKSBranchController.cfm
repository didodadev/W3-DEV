<cfscript>
	if(attributes.tabMenuController eq 0)
	{
		WOStruct = StructNew();
		
		WOStruct['#attributes.fuseaction#'] = structNew();	
		
		WOStruct['#attributes.fuseaction#']['default'] = 'searchlist';
		if(not isdefined('attributes.event'))
			attributes.event = WOStruct['#attributes.fuseaction#']['default'];
	
		WOStruct['#attributes.fuseaction#']['searchlist'] = structNew();
		WOStruct['#attributes.fuseaction#']['searchlist']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['searchlist']['fuseaction'] = 'hr.branch_pdks_table';
		WOStruct['#attributes.fuseaction#']['searchlist']['filePath'] = 'V16/hr/display/branch_pdks_table.cfm';
	}
	else
	{
		fuseactController = caller.attributes.fuseaction;
		getLang = caller.getLang;
		//add//
		// Tab Menus //
			tabMenuStruct = StructNew();
			tabMenuStruct['#attributes.fuseaction#'] = structNew();
			tabMenuStruct['#attributes.fuseaction#']['tabMenus'] = structNew();
			//add//
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['searchlist'] = structNew();
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['searchlist']['menus'] = structNew();
				
				tabMenuStruct['#fuseactController#']['tabMenus']['searchlist']['icons']['fa fa-print']['target'] = "_blank";
				tabMenuStruct['#fuseactController#']['tabMenus']['searchlist']['icons']['fa fa-print']['text'] = '#getLang('main',97)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['searchlist']['icons']['fa fa-print']['onClick'] = "send_adres_info()";
				
				tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);

			
	}
</cfscript>
