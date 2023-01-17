<!---
    File: HourlyAddfarePercantegeController.cfm
    Author: Esma R. Uysal <esmauysal@workcube.com>
    Date: 08.06.2021
    Description: Ödenek PDKS
        
    History:
        
    To Do:

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
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'ehesap.hourly_addfare_percantege';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/hr/ehesap/display/hourly_addfare_percantege.cfm';

        WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'emptypopup';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'ehesap.hourly_addfare_percantege';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/hr/ehesap/display/view_hourly_addfare_percantege.cfm';
	}
	else
	{
		/*fuseactController = caller.attributes.fuseaction;
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
        */
			
	}
</cfscript>
