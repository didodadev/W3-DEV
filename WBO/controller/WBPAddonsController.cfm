<cfscript>
    if(attributes.tabMenuController eq 0)
    {
        WOStruct = StructNew();
        WOStruct['#attributes.fuseaction#'] = structNew();
        WOStruct['#attributes.fuseaction#']['default'] = 'list';

        WOStruct['#attributes.fuseaction#']['list'] = structNew();
        WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'settings.wbp_addons';
        WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/settings/display/wbp_addons.cfm';

        WOStruct['#attributes.fuseaction#']['det'] = structNew();
        WOStruct['#attributes.fuseaction#']['det']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['det']['fuseaction'] = 'settings.wbp_addons';
        WOStruct['#attributes.fuseaction#']['det']['filePath'] = 'V16/settings/display/det_wbp_addons.cfm';
    }
</cfscript>