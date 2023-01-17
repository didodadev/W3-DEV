<cfinclude template="../config.cfm" runonce="true">
<cfscript>

    route = 'plevne.settings';
    
    if ( attributes.tabMenuController eq 0 ) {

        WOStruct = structNew();
        WOStruct['#attributes.fuseaction#'] = structNew();
        WOStruct['#attributes.fuseaction#']['default'] = 'list';
        if (not isDefined('attributes.event'))
            attributes.event = WOStruct[attributes.fuseaction]['default'];

        WOStruct['#attributes.fuseaction#']['list'] = structNew();
        WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = '#route#';
        WOStruct['#attributes.fuseaction#']['list']['filePath'] = '#addonpath#/views/settings/list.cfm';

    } else {
        fuseactController = caller.attributes.fuseaction;

        tabMenuStruct = structNew();
        tabMenuStruct['#fuseactController#'] = structNew();
        tabMenuStruct['#fuseactController#']['tabMenus'] = structNew();

        tabMenuData = serializeJSON(tabMenuStruct['#fuseactController#']['tabMenus']);
    }

</cfscript>