<cfscript>
    if(attributes.tabMenuController eq 0)
    {
        WOStruct = StructNew();
        WOStruct['#attributes.fuseaction#'] = structNew();
        WOStruct['#attributes.fuseaction#']['default'] = 'list';

        WOStruct['#attributes.fuseaction#']['list'] = structNew();
        WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'ehesap.shift';
        WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/hr/ehesap/display/shift.cfm';
        WOStruct['#attributes.fuseaction#']['list']['queryPath'] = 'V16/hr/ehesap/display/shift.cfm';

        WOStruct['#attributes.fuseaction#']['add'] = structNew();
        WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'ehesap.shift';
        WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/hr/ehesap/form/form_add_shift.cfm';
        WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'V16/hr/ehesap/query/add_shift.cfm';
        WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'ehesap.shift&event=upd&shift_id=';
        
        if(isdefined("attributes.shift_id"))
        {
            WOStruct['#attributes.fuseaction#']['upd'] = structNew();
            WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
            WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'ehesap.shift';
            WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'V16/hr/ehesap/form/form_upd_shift.cfm';
            WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'V16/hr/ehesap/query/upd_shift.cfm';
            WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.shift_id#';
            WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'ehesap.shift&event=upd&shift_id=';
	
            WOStruct['#attributes.fuseaction#']['del'] = structNew();
            WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
            WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=#fusebox.circuit#.ehesap.emptypopup_del_shift&SHIFT_ID=#attributes.shift_id#';
            WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16/hr/ehesap/query/del_shift.cfm';
            WOStruct['#attributes.fuseaction#']['del']['extraParams'] = 'shift_id';
            WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/hr/ehesap/query/del_shift.cfm';
            WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'ehesap.shift';
       }
    }
	
    	
</cfscript>