<cfscript>
    if (attributes.tabMenuController eq 0)
    {

        WOStruct['#attributes.fuseaction#']['default'] = 'list';
		if(not isdefined('attributes.event'))
			attributes.event = WOStruct['#attributes.fuseaction#']['default'];
	
			WOStruct['#attributes.fuseaction#']['list'] = structNew();
			WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'gdpr.approve';
			WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'AddOns/Devonomy/GDPR/display/list_gdpr_approve.cfm';	
			
			WOStruct['#attributes.fuseaction#']['add'] = structNew();
			WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'gdpr.approve';
			WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'AddOns/Devonomy/GDPR/display/gdpr_approve.cfm';
	}
   
	
</cfscript>