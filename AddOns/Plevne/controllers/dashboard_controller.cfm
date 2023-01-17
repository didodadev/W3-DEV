<cfinclude template="../config.cfm">
<cfscript>

    route = 'plevne.dashboard';

    if(attributes.tabMenuController eq 0)
	{

        WOStruct = structNew();
        WOStruct['#attributes.fuseaction#'] = structNew();
        WOStruct['#attributes.fuseaction#']['default'] = 'add';
        if (not isDefined("attributes.event")) {
            attributes.event = WOStruct['#attributes.fuseaction#']['default'];
        }

        WOStruct['#attributes.fuseaction#']['add'] = structNew();
        WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = '#route#';
        WOStruct['#attributes.fuseaction#']['add']['filePath'] = '#addonpath#/views/dashboard/list.cfm';

        WOStruct['#attributes.fuseaction#']['error'] = structNew();
        WOStruct['#attributes.fuseaction#']['error']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['error']['fuseaction'] = '#route#&event=error';
        WOStruct['#attributes.fuseaction#']['error']['filePath'] = '#addonpath#/views/dashboard/error.cfm';

    }
    else 
    {
        fuseactController = route;

        tabMenuStruct = structNew();
        tabMenuStruct['#fuseactController#'] = structNew();
        tabMenuStruct['#fuseactController#']['tabMenus'] = structNew();

        tabMenuStruct['#fuseactController#']['tabMenus']['add'] = structNew();
        tabMenuStruct['#fuseactController#']['tabMenus']['add']['menus'] = structNew();

        tabMenuStruct['#fuseactController#']['tabMenus']['add']['menus'][0] = structNew();
        tabMenuStruct['#fuseactController#']['tabMenus']['add']['menus'][0]['text'] = caller.getLang(dictionary_id: 63530);
        tabMenuStruct['#fuseactController#']['tabMenus']['add']['menus'][0]['href'] = 'index.cfm?fuseaction=plevne.levelprocess';
        
        tabMenuStruct['#fuseactController#']['tabMenus']['add']['menus'][1] = structNew();
        tabMenuStruct['#fuseactController#']['tabMenus']['add']['menus'][1]['text'] = caller.getLang(dictionary_id: 63532);
        tabMenuStruct['#fuseactController#']['tabMenus']['add']['menus'][1]['href'] = 'index.cfm?fuseaction=plevne.expressioncategory';
    
        tabMenuStruct['#fuseactController#']['tabMenus']['add']['menus'][2] = structNew();
        tabMenuStruct['#fuseactController#']['tabMenus']['add']['menus'][2]['text'] = caller.getLang(dictionary_id: 42988);
        tabMenuStruct['#fuseactController#']['tabMenus']['add']['menus'][2]['href'] = 'index.cfm?fuseaction=plevne.interceptorcategory';

        tabMenuStruct['#fuseactController#']['tabMenus']['add']['menus'][3] = structNew();
        tabMenuStruct['#fuseactController#']['tabMenus']['add']['menus'][3]['text'] = 'Settings';
        tabMenuStruct['#fuseactController#']['tabMenus']['add']['menus'][3]['href'] = 'index.cfm?fuseaction=plevne.settings';
        

        tabMenuData = SerializeJSON(tabMenuStruct['#fuseactController#']['tabMenus']);
    }


</cfscript>