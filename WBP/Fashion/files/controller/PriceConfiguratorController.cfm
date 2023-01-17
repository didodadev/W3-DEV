<cfscript>

    if (attributes.tabMenuController eq 0) {

        WOStruct = structNew();
        WOStruct['#attributes.fuseaction#'] = structNew();

        WOStruct['#attributes.fuseaction#']['default'] = 'list';
        if (not isDefined("attributes.event")) attributes.event = WOStruct['#attributes.fuseaction#']['default'];

        WOStruct['#attributes.fuseaction#']['list'] = structNew();
        WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'textile.price_configurator';
        WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'WBP/Fashion/files/sales/view/list_configurator.cfm';

        WOStruct['#attributes.fuseaction#']['upd'] = structNew();
        WOStruct['#attributes.fuseaction#']['upd']['window'] = 'popup';
        WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'textile.price_configurator&event=upd';
        WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'WBP/Fashion/files/objects/form/price_configurator.cfm';
        WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'WBP/Fashion/files/objects/query/price_configurator.cfm';
        WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'WBP/Fashion/files/objects/query/price_configurator.cfm';
        WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.req_id##';

    }

</cfscript>