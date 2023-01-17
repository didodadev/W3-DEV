<cfscript>
    if(attributes.tabMenuController eq 0)
    {
        WOStruct = StructNew();
        
        WOStruct['#attributes.fuseaction#'] = structNew();
        
        WOStruct['#attributes.fuseaction#']['default'] = 'list';
        if(not isdefined('attributes.event'))
            attributes.event = WOStruct['#attributes.fuseaction#']['default'];

            WOStruct['#attributes.fuseaction#']['list'] = structNew();
            WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
            WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'watalogy.marketplace';
            WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/worknet/display/list_marketplace.cfm';

            WOStruct['#attributes.fuseaction#']['add'] = structNew();
            WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
            WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'watalogy.marketplace';
            WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/worknet/form/add_marketplace.cfm';
            WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'V16/worknet/query/add_marketplace.cfm';
    
            if(isdefined("attributes.wid"))
            {
            WOStruct['#attributes.fuseaction#']['det'] = structNew();
            WOStruct['#attributes.fuseaction#']['det']['window'] = 'normal';
            WOStruct['#attributes.fuseaction#']['det']['fuseaction'] = 'watalogy.marketplace';
            WOStruct['#attributes.fuseaction#']['det']['filePath'] = 'V16/worknet/form/upd_marketplace.cfm';
            WOStruct['#attributes.fuseaction#']['det']['queryPath'] = 'V16/worknet/query/upd_worknet.cfm';
            WOStruct['#attributes.fuseaction#']['det']['Identity'] = '#attributes.wid#';
            WOStruct['#attributes.fuseaction#']['det']['nextEvent'] = 'watalogy.marketplace&event=det&wid=';}

    
        
            }
    
    
</cfscript>
    
    