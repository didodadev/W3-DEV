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
                WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'settings.list_tax';
                WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/settings/form/add_tax.cfm';
                WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'V16/settings/query/add_tax.cfm';
                WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'settings.list_tax&event=add&tid=';

            if(isDefined("attributes.event") and listFind('del,upd', attributes.event)){
                WOStruct['#attributes.fuseaction#']['upd'] = structNew();
                WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
                WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'settings.list_tax';
                WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'V16/settings/form/upd_tax.cfm';
                WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'V16/settings/query/upd_tax.cfm';
                WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.tid#';
                WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'settings.list_tax&event=upd&tid=';

                WOStruct['#attributes.fuseaction#']['del'] = structNew();
                WOStruct['#attributes.fuseaction#']['del']['window'] = 'normal';
                WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'settings.list_tax';
                WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16/settings/query/del_tax.cfm';
                WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/settings/query/del_tax.cfm';
                WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'settings.list_tax';
            }
    }
</cfscript>