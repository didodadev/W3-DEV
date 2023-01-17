<cfscript>
    if (attributes.tabMenuController eq 0) {

        WOStruct = structNew();

        WOStruct['#attributes.fuseaction#'] = structNew();

        WOStruct['#attributes.fuseaction#']['default'] = 'list';
        if (not isDefined("attributes.event"))
            attributes.event = WOStruct['#attributes.fuseaction#']['default'];

        WOStruct['#attributes.fuseaction#']['list'] = structNew();
        WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'textile.cutplan';
        WOStruct['#attributes.fuseaction#']['list']['filePath'] = '/WBP/Fashion/files/sales/view/list_cutplan.cfm';

        WOStruct['#attributes.fuseaction#']['add'] = structNew();
        WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'textile.cutplan&event=add';
        WOStruct['#attributes.fuseaction#']['add']['filePath'] = '/WBP/Fashion/files/sales/view/add_cutplan.cfm';
        WOStruct['#attributes.fuseaction#']['add']['queryPath'] = '/WBP/Fashion/files/sales/model/add_cutplan.cfm';
        WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = WOStruct['#attributes.fuseaction#']['add']['fuseaction'] & "&id=" & iif(isDefined("attributes.cutplan_id"), "attributes.cutplan_id", "1");
        WOStruct['#attributes.fuseaction#']['add']['actionId'] = '';

        WOStruct['#attributes.fuseaction#']['copy'] = structNew();
        WOStruct['#attributes.fuseaction#']['copy']['window'] = 'popup';
        WOStruct['#attributes.fuseaction#']['copy']['fuseaction'] = 'textile.cutplan&event=copy';
        WOStruct['#attributes.fuseaction#']['copy']['filepath'] = '/WBP/Fashion/files/sales/model/create_works_cutactual.cfm';
        WOStruct['#attributes.fuseaction#']['copy']['querypath'] = '/WBP/Fashion/files/sales/model/create_works_cutactual.cfm';
        WOStruct['#attributes.fuseaction#']['copy']['nextevent'] = WOStruct['#attributes.fuseaction#']['add']['fuseaction'] & "&id=" & iif(isDefined("attributes.cutplan_id"), "attributes.cutplan_id", "1");
        WOStruct['#attributes.fuseaction#']['copy']['actionId'] = '';

        WOStruct['#attributes.fuseaction#']['upload'] = structNew();
        WOStruct['#attributes.fuseaction#']['upload']['window'] = 'popup';
        WOStruct['#attributes.fuseaction#']['upload']['fuseaction'] = 'textile.cutplan&event=upload';
        WOStruct['#attributes.fuseaction#']['upload']['filePath'] = '/WBP/Fashion/files/sales/model/upload_cutplan.cfm';
        WOStruct['#attributes.fuseaction#']['upload']['queryPath'] = '/WBP/Fashion/files/sales/model/upload_cutplan.cfm';

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