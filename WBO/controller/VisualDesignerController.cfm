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
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'process.designer';
        WOStruct['#attributes.fuseaction#']['list']['filePath'] = '/V16/process/display/list_designer.cfm';

        WOStruct['#attributes.fuseaction#']['main'] = structNew();
		WOStruct['#attributes.fuseaction#']['main']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['main']['fuseaction'] = 'process.designer';
		WOStruct['#attributes.fuseaction#']['main']['filePath'] = '/V16/process/display/visual_editor.cfm';
		WOStruct['#attributes.fuseaction#']['main']['queryPath'] = '/V16/process/query/visual_designer.cfm';
        WOStruct['#attributes.fuseaction#']['main']['nextEvent'] = '';

        WOStruct['#attributes.fuseaction#']['sub'] = structNew();
		WOStruct['#attributes.fuseaction#']['sub']['window'] = 'popup';
		WOStruct['#attributes.fuseaction#']['sub']['fuseaction'] = 'process.designer';
		WOStruct['#attributes.fuseaction#']['sub']['filePath'] = '/V16/process/display/visualdesigner.cfm';
		WOStruct['#attributes.fuseaction#']['sub']['queryPath'] = '/V16/process/query/visual_designer.cfm';		
        WOStruct['#attributes.fuseaction#']['sub']['nextEvent'] = '';


        WOStruct['#attributes.fuseaction#']['concept'] = structNew();
		WOStruct['#attributes.fuseaction#']['concept']['window'] = 'popup';
		WOStruct['#attributes.fuseaction#']['concept']['fuseaction'] = 'process.designer';
		WOStruct['#attributes.fuseaction#']['concept']['filePath'] = '/V16/process/display/visualdesigner.cfm';
		WOStruct['#attributes.fuseaction#']['concept']['queryPath'] = '/V16/process/query/visual_designer.cfm';		
        WOStruct['#attributes.fuseaction#']['concept']['nextEvent'] = '';
	}
	else
	{
		fuseactController = caller.attributes.fuseaction;
		getLang = caller.getLang;
		
		tabMenuStruct = StructNew();
		tabMenuStruct['#fuseactController#'] = structNew();
		tabMenuStruct['#fuseactController#']['tabMenus'] = structNew();

		
		
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
</cfscript>

