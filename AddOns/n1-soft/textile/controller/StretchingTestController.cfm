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
        WOStruct['#attributes.fuseaction#']['list']['filePath'] = '/AddOns/N1-Soft/textile/sales/view/list_stretching_tests.cfm';

        WOStruct['#attributes.fuseaction#']['add'] = structNew();
        WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'textile.stretching_test&event=add';
        WOStruct['#attributes.fuseaction#']['add']['filePath'] = '/AddOns/N1-Soft/textile/sales/view/add_stretching_test.cfm';
        WOStruct['#attributes.fuseaction#']['add']['queryPath'] = '/AddOns/N1-Soft/textile/sales/model/add_stretching_test.cfm';
        WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = WOStruct['#attributes.fuseaction#']['list']['fuseaction'];


        WOStruct['#attributes.fuseaction#']['list_stretching_fabric'] = structNew();
        WOStruct['#attributes.fuseaction#']['list_stretching_fabric']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['list_stretching_fabric']['fuseaction'] = 'textile.stretching_test&event=list_stretching_fabric';
        WOStruct['#attributes.fuseaction#']['list_stretching_fabric']['filePath'] = '/AddOns/N1-Soft/textile/sales/view/list_stretching_fabric.cfm';
        WOStruct['#attributes.fuseaction#']['list_stretching_fabric']['queryPath'] = '/AddOns/N1-Soft/textile/sales/model/list_stretching_fabric.cfm';
        WOStruct['#attributes.fuseaction#']['list_stretching_fabric']['nextEvent'] = 'textile.stretching_test&event=list_stretching_fabric';

        WOStruct['#attributes.fuseaction#']['measurement'] = structNew();
        WOStruct['#attributes.fuseaction#']['measurement']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['measurement']['fuseaction'] = 'textile.stretching_test&event=measurement';
        WOStruct['#attributes.fuseaction#']['measurement']['filePath'] = '/AddOns/N1-Soft/textile/sales/view/measurement.cfm';
		 WOStruct['#attributes.fuseaction#']['measurement']['queryPath'] = '/AddOns/N1-Soft/textile/sales/model/measurement.cfm';
        WOStruct['#attributes.fuseaction#']['measurement']['nextEvent'] = '/AddOns/N1-Soft/textile/sales/view/measurement.cfm';
		 
		 
        WOStruct['#attributes.fuseaction#']['measure_form'] = structNew();
        WOStruct['#attributes.fuseaction#']['measure_form']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['measure_form']['fuseaction'] = 'textile.stretching_test&event=measure_form';
        WOStruct['#attributes.fuseaction#']['measure_form']['filePath'] = '/AddOns/N1-Soft/textile/sales/view/measure_form.cfm';
        WOStruct['#attributes.fuseaction#']['measure_form']['queryPath'] = '/AddOns/N1-Soft/textile/sales/model/measure_form.cfm';
        WOStruct['#attributes.fuseaction#']['measure_form']['nextEvent'] = '/AddOns/N1-Soft/textile/sales/view/measure_form.cfm';
		
		WOStruct['#attributes.fuseaction#']['measure_list'] = structNew();
        WOStruct['#attributes.fuseaction#']['measure_list']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['measure_list']['fuseaction'] = 'textile.stretching_text&event=measure_list';
        WOStruct['#attributes.fuseaction#']['measure_list']['filePath'] = '/AddOns/N1-Soft/textile/sales/view/measure_list.cfm';

        WOStruct['#attributes.fuseaction#']['measure_copy'] = structNew();
        WOStruct['#attributes.fuseaction#']['measure_copy']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['measure_copy']['fuseaction'] = 'textile.stretching_text&event=measure_copy';
        WOStruct['#attributes.fuseaction#']['measure_copy']['filePath'] = '/AddOns/N1-Soft/textile/sales/model/measure_copy.cfm';
		
		WOStruct['#attributes.fuseaction#']['request_selector'] = structNew();
        WOStruct['#attributes.fuseaction#']['request_selector']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['request_selector']['fuseaction'] = 'textile.stretching_test&event=request_selector';
        WOStruct['#attributes.fuseaction#']['request_selector']['filePath'] = '/AddOns/N1-Soft/textile/sales/view/list_sample_request_selector.cfm';


        WOStruct['#attributes.fuseaction#']['gantt'] = structNew();
        WOStruct['#attributes.fuseaction#']['gantt']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['gantt']['fuseaction'] = 'textile.stretching_test&event=gantt';
        WOStruct['#attributes.fuseaction#']['gantt']['filePath'] = '/AddOns/N1-Soft/textile/sales/view/gantt.cfm';

        WOStruct['#attributes.fuseaction#']['gantt_update'] = structNew();
        WOStruct['#attributes.fuseaction#']['gantt_update']['window'] = 'ajax';
        WOStruct['#attributes.fuseaction#']['gantt_update']['fuseaction'] = 'textile.stretching_test&event=gantt_update';
        WOStruct['#attributes.fuseaction#']['gantt_update']['filePath'] = '/AddOns/N1-Soft/textile/sales/view/gantt.cfm';

    }

</cfscript>