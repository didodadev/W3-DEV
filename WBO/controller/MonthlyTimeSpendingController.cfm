<cfscript>
	if(attributes.tabMenuController eq 0)
	{

		WOStruct = StructNew();
		
		WOStruct['#attributes.fuseaction#'] = structNew();
		
		WOStruct['#attributes.fuseaction#']['default'] = 'list';
		
		WOStruct['#attributes.fuseaction#']['list'] = structNew();
		WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'myhome.timecost_calendar';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/myhome/display/time_cost_calendar.cfm';
    }

    else
	{			
			
			getLang = caller.getLang;
			denied_pages = caller.denied_pages;
			
			tabMenuStruct = StructNew();
			tabMenuStruct['#attributes.fuseaction#'] = structNew();
			tabMenuStruct['#attributes.fuseaction#']['tabMenus'] = structNew();
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['list'] = structNew();
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['list']['menus'] = structNew();
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['list']['menus'][0]['text'] = '#getLang('','Zaman Harcamaları','57561')#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['list']['menus'][0]['href'] = "#request.self#?fuseaction=myhome.mytime_management";

            tabMenuStruct['#attributes.fuseaction#']['tabMenus']['list']['menus'][1]['text'] = '#getLang('','Haftalık Zaman Harcaması','31368')#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['list']['menus'][1]['href'] = "#request.self#?fuseaction=myhome.upd_myweek";

            tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);

	}

</cfscript>

