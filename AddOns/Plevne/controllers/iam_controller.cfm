<cfinclude template="../config.cfm" runonce="true">
<cfscript>
    route = 'plevne.iam';

    if ( attributes.tabMenuController eq 0 ) {

    WOStruct = structNew();
    WOStruct['#attributes.fuseaction#'] = structNew();
    WOStruct['#attributes.fuseaction#']['default'] = 'list';
    if (not isDefined("attributes.event"))
        attributes.event = WOStruct['#attributes.fuseaction#']['default'];

        WOStruct['#attributes.fuseaction#']['list'] = structNew();
        WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = '#route#';
        WOStruct['#attributes.fuseaction#']['list']['filePath'] = '#addonpath#/views/iam/list_iam.cfm';

        WOStruct['#attributes.fuseaction#']['add'] = structNew();
        WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = '#route#&event=add';
        WOStruct['#attributes.fuseaction#']['add']['filePath'] = '#addonpath#/views/iam/add_iam.cfm';
        WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = '#route#';

        if(isdefined("attributes.iam_id"))
		{
            WOStruct['#attributes.fuseaction#']['upd'] = structNew();
            WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
            WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = '#route#&event=upd';
            WOStruct['#attributes.fuseaction#']['upd']['filePath'] = '#addonpath#/views/iam/upd_iam.cfm';
            WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = '#route#';
            WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.iam_id#';
        }
   
} else {
    fuseactController = caller.attributes.fuseaction;
    tabMenuStruct = structNew();
    getLang = caller.getLang;
    tabMenuStruct['#fuseactController#'] = structNew();
    tabMenuStruct['#fuseactController#']['tabMenus'] = structNew();
    if(caller.attributes.event is 'add')
		{
		    tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['text'] = '#getLang('','Liste','57509')#';
            tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=#route#";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main','Kaydet','57461')#';
            tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";
        }
        if(caller.attributes.event is 'upd')
		{
		    tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('','Ekle','57582')#';
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=#route#&event=add";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('','Liste','57509')#';
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=#route#";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main','Kaydet','57461')#';
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";
        }
    tabMenuData = serializeJSON(tabMenuStruct['#fuseactController#']['tabMenus']);
}
</cfscript>