<cfscript>

    if (attributes.tabMenuController eq 0)
    {

        WOStruct = structNew();

        WOStruct['#attributes.fuseaction#'] = structNew();

        WOStruct['#attributes.fuseaction#']['default'] = 'list';
        if (not isDefined('attributes.event'))
            attributes.event = WOStruct['#attributes.fuseaction#']['default'];

        WOStruct['#attributes.fuseaction#']['list'] = structNew();
        WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'jedi.package';
        WOStruct['#attributes.fuseaction#']['list']['filePath'] = '/AddOns/Jedi/packagemanager/views/list.cfm';

        WOStruct['#attributes.fuseaction#']['add'] = structNew();
        WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'jedi.package&event=add';
        WOStruct['#attributes.fuseaction#']['add']['filePath'] = '/AddOns/Jedi/packagemanager/views/add.cfm';
        WOStruct['#attributes.fuseaction#']['add']['queryPath'] = '/AddOns/Jedi/packagemanager/actions/add.cfm';
        WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = WOStruct['#attributes.fuseaction#']['list']['fuseaction'];
		
		WOStruct['#attributes.fuseaction#']['upd'] = structNew();
        WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'jedi.package&event=upd';
        WOStruct['#attributes.fuseaction#']['upd']['filePath'] = '/AddOns/Jedi/packagemanager/views/upd.cfm';
        WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = '/AddOns/Jedi/packagemanager/actions/upd.cfm';
        WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = WOStruct['#attributes.fuseaction#']['list']['fuseaction'];

    }

</cfscript>