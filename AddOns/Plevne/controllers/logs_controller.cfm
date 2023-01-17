<cfinclude template="../config.cfm" runonce="true">
<cfscript>
    route = 'plevne.logs';

    if ( attributes.tabMenuController eq 0 ) {

    WOStruct = structNew();
    WOStruct['#attributes.fuseaction#'] = structNew();
    WOStruct['#attributes.fuseaction#']['default'] = 'list';
    if (not isDefined("attributes.event"))
        attributes.event = WOStruct['#attributes.fuseaction#']['default'];

    WOStruct['#attributes.fuseaction#']['list'] = structNew();
    WOStruct['#attributes.fuseaction#']['list']['windows'] = 'popup';
    WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = '#route#';
    WOStruct['#attributes.fuseaction#']['list']['filePath'] = '#addonpath#/views/logs/list.cfm';

    WOStruct['#attributes.fuseaction#']['det'] = structNew();
    WOStruct['#attributes.fuseaction#']['det']['widnows'] = 'popup';
    WOStruct['#attributes.fuseaction#']['det']['fuseaction'] = '#route#&event=det';
    WOStruct['#attributes.fuseaction#']['det']['filePath'] = '#addonpath#/views/logs/det.cfm';

    }
</cfscript>