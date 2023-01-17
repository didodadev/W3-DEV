<cfscript>
    if(attributes.tabMenuController eq 0)
    {
        WOStruct = StructNew();
        WOStruct['#attributes.fuseaction#'] = structNew();

            WOStruct['#attributes.fuseaction#']['default'] = 'add';
            if(not isdefined('attributes.event'))
            attributes.event = WOStruct['#attributes.fuseaction#']['default'];

                WOStruct['#attributes.fuseaction#']['add'] = structNew();
                WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
                WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'settings.list_oiv';
                WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/settings/form/add_oiv.cfm';
                WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'V16/settings/query/add_oiv.cfm';
                WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'settings.list_oiv&event=upd&oid=';

            if(isDefined("attributes.event") and listFind('upd', attributes.event)){
                WOStruct['#attributes.fuseaction#']['upd'] = structNew();
                WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
                WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'settings.list_oiv';
                WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'V16/settings/form/upd_oiv.cfm';
                WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'V16/settings/query/upd_oiv.cfm';
                WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'settings.list_oiv&event=upd&oid=';
                WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.oid#';

            }
    }
</cfscript>