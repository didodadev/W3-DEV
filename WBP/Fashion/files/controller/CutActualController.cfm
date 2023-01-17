<cfscript>
    if (attributes.tabMenuController eq 0) {

        WOStruct = structNew();

        WOStruct['#attributes.fuseaction#'] = structNew();

        WOStruct['#attributes.fuseaction#']['default'] = 'list';
        if (not isDefined("attributes.event"))
            attributes.event = WOStruct['#attributes.fuseaction#']['default'];

        WOStruct['#attributes.fuseaction#']['list'] = structNew();
        WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'textile.cutactual';
        WOStruct['#attributes.fuseaction#']['list']['filePath'] = '/WBP/Fashion/files/sales/view/list_cutactual.cfm';

        WOStruct['#attributes.fuseaction#']['add'] = structNew();
        WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'textile.cutactual&event=add';
        WOStruct['#attributes.fuseaction#']['add']['filePath'] = '/WBP/Fashion/files/sales/view/add_cutactual.cfm';
        WOStruct['#attributes.fuseaction#']['add']['queryPath'] = '/WBP/Fashion/files/sales/model/add_cutactual.cfm';
        WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = WOStruct['#attributes.fuseaction#']['list']['fuseaction'] & "&id=" & iif(isDefined("attributes.cutactual_id"), "attributes.cutactual_id", "1");

        WOStruct['#attributes.fuseaction#']['upload'] = structNew();
        WOStruct['#attributes.fuseaction#']['upload']['window'] = 'popup';
        WOStruct['#attributes.fuseaction#']['upload']['fuseaction'] = 'textile.cutplan&event=upload';
        WOStruct['#attributes.fuseaction#']['upload']['filePath'] = '/WBP/Fashion/files/sales/model/upload_cutplan.cfm';
        WOStruct['#attributes.fuseaction#']['upload']['queryPath'] = '/WBP/Fashion/files/sales/model/upload_cutplan.cfm';

        WOStruct['#attributes.fuseaction#']['cutstretch'] = structNew();
        WOStruct['#attributes.fuseaction#']['cutstretch']['window'] = 'popup';
        WOStruct['#attributes.fuseaction#']['cutstretch']['fuseaction'] = 'textile.cutactual&event=cutstretch';
        WOStruct['#attributes.fuseaction#']['cutstretch']['filePath'] = '/WBP/Fashion/files/sales/view/add_cutstretch.cfm';
        WOStruct['#attributes.fuseaction#']['cutstretch']['queryPath'] = '/WBP/Fashion/files/sales/query/add_cutstretch.cfm';
        WOStruct['#attributes.fuseaction#']['cutstretch']['nextEvent'] = '';

    } else {
        fuseactController = caller.attributes.fuseaction;
		// Tab Menus //
        tabMenuStruct = StructNew();
        getLang = caller.getLang;

        tabMenuStruct['#fuseactController#'] = structNew();
        tabMenuStruct['#fuseactController#']['tabMenus'] = structNew();
        
        tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons'] = structNew();

        tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['print']['text'] = '#getLang('main',62)#';
        tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['print']['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_print_files&iid=&print_type=#500#','page');";

        tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
    }
</cfscript>