<cfinclude template="../config.cfm" runonce="true">
<cfscript>

    route = 'plevne.levelprocess_crud';
    
    if ( attributes.tabMenuController eq 0 ) {

        WOStruct = structNew();
        WOStruct['#attributes.fuseaction#'] = structNew();
        WOStruct['#attributes.fuseaction#']['default'] = 'list';
        if (not isDefined('attributes.event'))
            attributes.event = WOStruct[attributes.fuseaction]['default'];

        WOStruct['#attributes.fuseaction#']['list'] = structNew();
        WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = '#route#';
        WOStruct['#attributes.fuseaction#']['list']['filePath'] = '#addonpath#views/levelprocess/list.cfm';

        WOStruct['#attributes.fuseaction#']['add'] = structNew();
        WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = '#route#&event=add';
        WOStruct['#attributes.fuseaction#']['add']['filePath'] = '#addonpath#views/levelprocess/add.cfm';
        WOStruct['#attributes.fuseaction#']['add']['queryPath'] = '#addonpath#actions/levelprocess/add.cfm';
        WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = '#route#';
        
        WOStruct['#attributes.fuseaction#']['upd'] = structNew();
        WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = '#route#&event=upd';
        WOStruct['#attributes.fuseaction#']['upd']['filePath'] = '#addonpath#views/levelprocess/upd.cfm';
        WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = '#addonpath#actions/levelprocess/upd.cfm';
        WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = '#route#';
        
    } else {
        fuseactController = caller.attributes.fuseaction;

        tabMenuStruct = structNew();
        tabMenuStruct['#fuseactController#'] = structNew();
        tabMenuStruct['#fuseactController#']['tabMenus'] = structNew();

        tabMenuStruct['#fuseactController#']['tabMenus']['add']['menus'][0] = structNew();
        tabMenuStruct['#fuseactController#']['tabMenus']['add']['menus'][0]['text'] = caller.getLang('','','63565','plevne dashboard');
        tabMenuStruct['#fuseactController#']['tabMenus']['add']['menus'][0]['href'] = 'index.cfm?fuseaction=plevne.dashboard';

        tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['target'] = "_blank";
        tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#caller.getLang('','',63530,'Plevne İşlem Sınıflandırma')#';
        tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=plevne.levelprocess";

        tabMenuData = serializeJSON(tabMenuStruct['#fuseactController#']['tabMenus']);
    }

</cfscript>