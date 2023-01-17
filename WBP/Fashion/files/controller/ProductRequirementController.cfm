<cfscript>

    if (attributes.tabMenuController eq 0) 
    {
        WOStruct = structNew();

        WOStruct['#attributes.fuseaction#'] = structNew();

        WOStruct['#attributes.fuseaction#']['default'] = 'list';
        if (not isDefined("attributes.event")) attributes.event = WOStruct['#attributes.fuseaction#']['default'];

        WOStruct['#attributes.fuseaction#']['list'] = structNew();
        WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'textile.product_requirements';
        WOStruct['#attributes.fuseaction#']['list']['filePath'] = '/WBP/Fashion/files/production/view/list_requirements.cfm';

        WOStruct['#attributes.fuseaction#']['det'] = structNew();
        WOStruct['#attributes.fuseaction#']['det']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['det']['fuseaction'] = 'textile.product_requirements&event=det';
        WOStruct['#attributes.fuseaction#']['det']['filePath'] = '/WBP/Fashion/files/production/view/det_requirements.cfm';
        WOStruct['#attributes.fuseaction#']['det']['queryPath'] = '/WBP/Fashion/files/production/model/det_requirements.cfm';
        WOStruct['#attributes.fuseaction#']['det']['nextEvent'] = WOStruct['#attributes.fuseaction#']['list']['fuseaction'];
    }

</cfscript>