<cfscript>
	if(attributes.tabMenuController eq 0)
	{

		WOStruct = StructNew();
		
		WOStruct['#attributes.fuseaction#'] = structNew();
		
		WOStruct['#attributes.fuseaction#']['default'] = 'list';
		
		WOStruct['#attributes.fuseaction#']['list'] = structNew();
		WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'myhome.upd_myweek';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/myhome/form/list_myweek.cfm';
		WOStruct['#attributes.fuseaction#']['list']['queryPath'] = 'V16/myhome/query/add_my_week_timecost.cfm';

    }

    else
	{			
			
			getLang = caller.getLang;
			
			tabMenuStruct = StructNew();
			tabMenuStruct['#attributes.fuseaction#'] = structNew();
			tabMenuStruct['#attributes.fuseaction#']['tabMenus'] = structNew();
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['list'] = structNew();
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['list']['menus'] = structNew();
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['list']['menus'][0]['text'] = '#getLang('','Zaman Harcamaları','57561')#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['list']['menus'][0]['href'] = "#request.self#?fuseaction=myhome.mytime_management";

			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['list']['menus'][1]['text'] = '#getLang('','Aylık Zaman Harcaması','31156')#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['list']['menus'][1]['href'] = "#request.self#?fuseaction=myhome.mytime_management";

            tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);

	}

</cfscript>

