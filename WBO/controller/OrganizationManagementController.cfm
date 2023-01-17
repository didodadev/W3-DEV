<!---
File: OrganizationManagementController.cfm
Author: Workcube-Esma Uysal <esmauysal@workcube.com>
Controller: -
Description: Organizasyonel Yönetimi Controller Sayfasıdır.
--->
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
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'hr.organization_management';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = '/V16/hr/display/organization_management.cfm';
		
		WOStruct['#attributes.fuseaction#']['ajaxSub'] = structNew();
		WOStruct['#attributes.fuseaction#']['ajaxSub']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['ajaxSub']['filePath'] = '/V16/hr/display/ajax_sub_elements.cfm';

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

