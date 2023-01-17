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
        WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'textile.stretching_test';
        WOStruct['#attributes.fuseaction#']['list']['filePath'] = '/WBP/Fashion/files/sales/view/list_stretching_tests.cfm';

        WOStruct['#attributes.fuseaction#']['add'] = structNew();
        WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'textile.stretching_test&event=add';
        WOStruct['#attributes.fuseaction#']['add']['filePath'] = '/WBP/Fashion/files/sales/view/add_stretching_test.cfm';
        WOStruct['#attributes.fuseaction#']['add']['queryPath'] = '/WBP/Fashion/files/sales/model/add_stretching_test.cfm';
        WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = WOStruct['#attributes.fuseaction#']['list']['fuseaction'];

        WOStruct['#attributes.fuseaction#']['upd'] = structNew();
        WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'textile.stretching_test&event=upd';
        WOStruct['#attributes.fuseaction#']['upd']['filePath'] = '/WBP/Fashion/files/sales/view/upd_stretching_test.cfm';
        WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = '/WBP/Fashion/files/sales/model/upd_stretching_test.cfm';
        WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] & "&st_id=" & iif(isdefined("attributes.stretching_test_id"),"attributes.stretching_test_id",de("1"));

        WOStruct['#attributes.fuseaction#']['upload'] = structNew();
        WOStruct['#attributes.fuseaction#']['upload']['window'] = 'popup';
        WOStruct['#attributes.fuseaction#']['upload']['fuseaction'] = 'textile.stretching_test&event=upload';
        WOStruct['#attributes.fuseaction#']['upload']['filepath'] = '/WBP/Fashion/files/sales/model/updload_stretching_test.cfm';
        WOStruct['#attributes.fuseaction#']['upload']['querypath'] = '/WBP/Fashion/files/sales/model/updload_stretching_test.cfm';
        WOStruct['#attributes.fuseaction#']['upload']['nextEvent'] = '';

        WOStruct['#attributes.fuseaction#']['list_stretching_fabric'] = structNew();
        WOStruct['#attributes.fuseaction#']['list_stretching_fabric']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['list_stretching_fabric']['fuseaction'] = 'textile.stretching_test&event=list_stretching_fabric';
        WOStruct['#attributes.fuseaction#']['list_stretching_fabric']['filePath'] = '/WBP/Fashion/files/sales/view/list_stretching_fabric.cfm';
        WOStruct['#attributes.fuseaction#']['list_stretching_fabric']['queryPath'] = '/WBP/Fashion/files/sales/model/list_stretching_fabric.cfm';
        WOStruct['#attributes.fuseaction#']['list_stretching_fabric']['nextEvent'] = 'textile.stretching_test&event=list_stretching_fabric';

        WOStruct['#attributes.fuseaction#']['measurement'] = structNew();
        WOStruct['#attributes.fuseaction#']['measurement']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['measurement']['fuseaction'] = 'textile.stretching_test&event=measurement';
        WOStruct['#attributes.fuseaction#']['measurement']['filePath'] = '/WBP/Fashion/files/sales/view/measurement.cfm';
		 WOStruct['#attributes.fuseaction#']['measurement']['queryPath'] = '/WBP/Fashion/files/sales/model/measurement.cfm';
        WOStruct['#attributes.fuseaction#']['measurement']['nextEvent'] = '/WBP/Fashion/files/sales/view/measurement.cfm';
		 
		 
        WOStruct['#attributes.fuseaction#']['measure_form'] = structNew();
        WOStruct['#attributes.fuseaction#']['measure_form']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['measure_form']['fuseaction'] = 'textile.stretching_test&event=measure_form';
        WOStruct['#attributes.fuseaction#']['measure_form']['filePath'] = '/WBP/Fashion/files/sales/view/measure_form.cfm';
        WOStruct['#attributes.fuseaction#']['measure_form']['queryPath'] = '/WBP/Fashion/files/sales/model/measure_form.cfm';
        WOStruct['#attributes.fuseaction#']['measure_form']['nextEvent'] = '/WBP/Fashion/files/sales/view/measure_form.cfm';
		
		WOStruct['#attributes.fuseaction#']['measure_list'] = structNew();
        WOStruct['#attributes.fuseaction#']['measure_list']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['measure_list']['fuseaction'] = 'textile.stretching_text&event=measure_list';
        WOStruct['#attributes.fuseaction#']['measure_list']['filePath'] = '/WBP/Fashion/files/sales/view/measure_list.cfm';

        WOStruct['#attributes.fuseaction#']['measure_copy'] = structNew();
        WOStruct['#attributes.fuseaction#']['measure_copy']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['measure_copy']['fuseaction'] = 'textile.stretching_text&event=measure_copy';
        WOStruct['#attributes.fuseaction#']['measure_copy']['filePath'] = '/WBP/Fashion/files/sales/model/measure_copy.cfm';
		
		WOStruct['#attributes.fuseaction#']['request_selector'] = structNew();
        WOStruct['#attributes.fuseaction#']['request_selector']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['request_selector']['fuseaction'] = 'textile.stretching_test&event=request_selector';
        WOStruct['#attributes.fuseaction#']['request_selector']['filePath'] = '/WBP/Fashion/files/sales/view/list_sample_request_selector.cfm';


        WOStruct['#attributes.fuseaction#']['gantt'] = structNew();
        WOStruct['#attributes.fuseaction#']['gantt']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['gantt']['fuseaction'] = 'textile.stretching_test&event=gantt';
        WOStruct['#attributes.fuseaction#']['gantt']['filePath'] = '/WBP/Fashion/files/sales/display/gantt_plan.cfm';

        WOStruct['#attributes.fuseaction#']['gantt_update'] = structNew();
        WOStruct['#attributes.fuseaction#']['gantt_update']['window'] = 'ajax';
        WOStruct['#attributes.fuseaction#']['gantt_update']['fuseaction'] = 'textile.stretching_test&event=gantt_update';
        WOStruct['#attributes.fuseaction#']['gantt_update']['filePath'] = '/WBP/Fashion/files/sales/display/gantt_plan.cfm';

        WOStruct['#attributes.fuseaction#']['sarf'] = structNew();
        WOStruct['#attributes.fuseaction#']['sarf']['window'] = 'popup';
        WOStruct['#attributes.fuseaction#']['sarf']['fuseaction'] = 'textile.stretching_test&event=sarf';
        WOStruct['#attributes.fuseaction#']['sarf']['filePath'] = '/WBP/Fashion/files/sales/query/sarf.cfm';

    }
    else {
        fuseactController = caller.attributes.fuseaction;
		// Tab Menus //
        tabMenuStruct = StructNew();
        getLang = caller.getLang;

        tabMenuStruct['#fuseactController#'] = structNew();
        tabMenuStruct['#fuseactController#']['tabMenus'] = structNew();
        
        tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();

        tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['text'] = '#getLang('main',62)#';
        tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_print_files&iid=#iif(isDefined('attributes.st_id'), 'attributes.st_id', de(''))##iif(isDefined('attributes.mh_id'), 'attributes.mh_id', de(''))#&print_type=#370#','page');";

        tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
    }

</cfscript>