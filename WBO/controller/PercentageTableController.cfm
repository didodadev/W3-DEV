<cfscript>
	if(attributes.tabMenuController eq 0)
	{
		WOStruct = StructNew();
		
		WOStruct['#attributes.fuseaction#'] = structNew();
		
		WOStruct['#attributes.fuseaction#']['default'] = 'listForm';
		
		WOStruct['#attributes.fuseaction#']['listForm'] = structNew();
		WOStruct['#attributes.fuseaction#']['listForm']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['listForm']['fuseaction'] = 'ehesap.list_puantaj';
		WOStruct['#attributes.fuseaction#']['listForm']['filePath'] = 'V16/hr/ehesap/display/list_puantaj.cfm';
		
		
	}
	/* else
	{
		fuseactController = caller.attributes.fuseaction;
		getLang = caller.getLang;
		
		tabMenuStruct = StructNew();
		tabMenuStruct['#fuseactController#'] = structNew();
		tabMenuStruct['#fuseactController#']['tabMenus'] = structNew();
		
	
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	} */
	

</cfscript>
