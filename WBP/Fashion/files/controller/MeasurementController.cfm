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
        WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'textile.measurement';
        WOStruct['#attributes.fuseaction#']['list']['filepath'] = '/WBP/Fashion/files/sales/view/measure_list.cfm';
        WOStruct['#attributes.fuseaction#']['list']['querypath'] = '/WBP/Fashion/files/sales/view/measure_list.cfm';
        WOStruct['#attributes.fuseaction#']['list']['nextevent'] = 'textile.measurement';

        WOStruct['#attributes.fuseaction#']['upd'] = structNew();
        WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'textile.measurement&event=upd';
        WOStruct['#attributes.fuseaction#']['upd']['filePath'] = '/WBP/Fashion/files/sales/view/measure_form.cfm';
        WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = '/WBP/Fashion/files/sales/model/measure_form.cfm';
        WOStruct['#attributes.fuseaction#']['upd']['nextevent'] = 'textile.measurement';

    }
</cfscript>