<cfscript>

    if(attributes.tabMenuController eq 0)
    {
        WOStruct = StructNew();

        WOStruct['#attributes.fuseaction#'] = structNew();

        WOStruct['#attributes.fuseaction#']['default'] = 'list';
        if (not isdefined('attributes.event'))
            attributes.event = WOStruct['#attributes.fuseaction#']['default'];

        WOStruct['#attributes.fuseaction#']['list'] = structNew();
        WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'hr.list_position_names';
        WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/hr/display/list_position_names.cfm';
        WOStruct['#attributes.fuseaction#']['list']['queryPath'] = 'V16/hr/display/list_position_names.cfm';

        WOStruct['#attributes.fuseaction#']['add'] = structNew();
        WOStruct['#attributes.fuseaction#']['add']['window'] = 'popup';
        WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'hr.popup_add_position_name';
        WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/hr/form/add_position_name.cfm';
        WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'V16/hr/query/add_position_name.cfm';
        WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'hr.popup_add_position_name&event=upd&id=';

        if (isdefined("attributes.id"))
        {
            WOStruct['#attributes.fuseaction#']['upd'] = structNew();
            WOStruct['#attributes.fuseaction#']['upd']['window'] = 'popup';
            WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'hr.popup_upd_position_name';
            WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'V16/hr/form/upd_position_name.cfm';
            WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'V16/hr/query/upd_position_name.cfm';
            WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.id#';
            WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'hr.popup_upd_position_name&event=upd&id=';

            WOStruct['#attributes.fuseaction#']['del'] = structNew();
            WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
            WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'hr.emptypopup_del_position_name&id=#attributes.id#';
            WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16/hr/query/del_position_name.cfm';
            WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/hr/query/del_position_name.cfm';

        }
    }
    </cfscript>