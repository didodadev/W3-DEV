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
        WOStruct['#attributes.fuseaction#']['list']['fuseaction'] ='account.government_audit';
        WOStruct['#attributes.fuseaction#']['list']['filePath'] ='WBP/GAudit/files/objects/display/government_audit.cfm';
        WOStruct['#attributes.fuseaction#']['list']['queryPath'] ='';
        WOStruct['#attributes.fuseaction#']['list']['nextevent'] = '';
		
		WOStruct['#attributes.fuseaction#']['ajaxSub'] = structNew();
		WOStruct['#attributes.fuseaction#']['ajaxSub']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['ajaxSub']['filePath'] = 'WBP/GAudit/files/objects/display/ajax_sub_elements.cfm';
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