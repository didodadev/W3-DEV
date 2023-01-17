<cfscript>
    if(attributes.tabMenuController eq 0)
    {
        WOStruct = StructNew();
        WOStruct['#attributes.fuseaction#'] = structNew();
        WOStruct['#attributes.fuseaction#']['default'] = 'list';

        WOStruct['#attributes.fuseaction#']['list'] = structNew();
        WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'training_management.list_class_requests';
        WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/training_management/display/list_class_requests.cfm';
        WOStruct['#attributes.fuseaction#']['list']['queryPath'] = 'V16/training_management/display/list_class_requests.cfm';

        if(isdefined("attributes.train_req_id"))
        {
            WOStruct['#attributes.fuseaction#']['upd'] = structNew();
            WOStruct['#attributes.fuseaction#']['upd']['window'] = 'popup';
            WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'training_management.list_class_requests';
            WOStruct['#attributes.fuseaction#']['upd']['filePath'] = '/V16/training/form/form_upd_training_request.cfm';
            WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = '/V16/training/query/upd_training_request_emp.cfm';
            WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.train_req_id#';
            WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'training_management.list_class_requests&event=upd&train_req_id=';
		
	
            WOStruct['#attributes.fuseaction#']['del'] = structNew();
            WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
            WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=#fusebox.circuit#.emptypopup_del_request_training&request_id=#attributes.train_req_id#';
            WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16/training_management/query/del_training_request.cfm';
            WOStruct['#attributes.fuseaction#']['del']['extraParams'] = 'train_req_id';
            WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/training_management/query/del_training_request.cfm';
            WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'training_management.list_class_requests';
       }
    }
	
    	
</cfscript>