<cfscript>
    if(attributes.tabMenuController eq 0){
        WOStruct = StructNew();

        WOStruct['#attributes.fuseaction#'] = structNew();

        WOStruct['#attributes.fuseaction#']['default'] = 'list';
        if(not isdefined('attributes.event'))
            attributes.event = WOStruct['#attributes.fuseaction#']['default'];

        WOStruct['#attributes.fuseaction#']['list'] = structNew();
        WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'hr.list_total_performances';
        WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/hr/display/list_total_performances.cfm';
        WOStruct['#attributes.fuseaction#']['list']['queryPath'] = 'V16/hr/display/list_total_performances.cfm';

        WOStruct['#attributes.fuseaction#']['addinfo'] = structNew();
        WOStruct['#attributes.fuseaction#']['addinfo']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['addinfo']['fuseaction'] = 'hr.form_add_total_performance_info';
        WOStruct['#attributes.fuseaction#']['addinfo']['filePath'] = 'V16/hr/form/add_total_performance_info.cfm';
        WOStruct['#attributes.fuseaction#']['addinfo']['queryPath'] = 'V16/hr/form/add_total_performance_info.cfm';
        WOStruct['#attributes.fuseaction#']['addinfo']['nextEvent'] = 'hr.list_total_performances&event=add';

        WOStruct['#attributes.fuseaction#']['add'] = structNew();
        WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'hr.form_add_total_performance';
        WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/hr/form/form_add_total_performance.cfm';
        WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'V16/hr/query/add_total_performance.cfm';
        WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'hr.list_total_performances';

        if(isdefined("attributes.performance_id")){
            WOStruct['#attributes.fuseaction#']['upd'] = structNew();
            WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
            WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'hr.form_upd_total_performance';
            WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'V16/hr/form/form_upd_total_performance.cfm';
            WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'V16/hr/query/upd_total_performance.cfm';
            WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'hr.list_total_performances&event=upd&performance_id=';
        }
    }

    WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
    WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd,addinfo';
    WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'EMPLOYEE_TOTAL_PERFORMANCE';
    WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'PERFORMANCE_ID';
    WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "[]";

</cfscript>