<cfinclude template="../config.cfm" runonce="true">
<cfscript>

    route = 'plevne.interceptor';
    
    if ( attributes.tabMenuController eq 0 ) {

        WOStruct = structNew();
        WOStruct['#attributes.fuseaction#'] = structNew();
        WOStruct['#attributes.fuseaction#']['default'] = 'list';
        if (not isDefined('attributes.event'))
            attributes.event = WOStruct[attributes.fuseaction]['default'];

        WOStruct['#attributes.fuseaction#']['list'] = structNew();
        WOStruct['#attributes.fuseaction#']['list']['window'] = 'popup';
        WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = '#route#';
        WOStruct['#attributes.fuseaction#']['list']['filePath'] = '#addonpath#/views/interceptors/list.cfm';

        WOStruct['#attributes.fuseaction#']['add'] = structNew();
        WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = '#route#&event=add';
        WOStruct['#attributes.fuseaction#']['add']['filePath'] = '#addonpath#/views/interceptors/add.cfm';
        WOStruct['#attributes.fuseaction#']['add']['queryPath'] = '#addonpath#/actions/interceptors/add.cfm';
        WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = '#route#';

        WOStruct['#attributes.fuseaction#']['upd'] = structNew();
        WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = '#route#&event=upd';
        WOStruct['#attributes.fuseaction#']['upd']['filePath'] = '#addonpath#/views/interceptors/upd.cfm';
        WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = '#addonpath#/actions/interceptors/upd.cfm';
        WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = '#route#';

        WOStruct['#attributes.fuseaction#']['del'] = structNew();
        WOStruct['#attributes.fuseaction#']['del']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#route#&event=del';
        WOStruct['#attributes.fuseaction#']['del']['filePath'] = '#addonpath#/actions/interceptors/del.cfm';
        WOStruct['#attributes.fuseaction#']['del']['queryPath'] = '#addonpath#/actions/interceptors/del.cfm';
        WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = '#route#';


    } else {
        fuseactController = caller.attributes.fuseaction;

        tabMenuStruct = structNew();
        tabMenuStruct['#fuseactController#'] = structNew();
        tabMenuStruct['#fuseactController#']['tabMenus'] = structNew();

        tabMenuData = serializeJSON(tabMenuStruct['#fuseactController#']['tabMenus']);
    }

</cfscript>