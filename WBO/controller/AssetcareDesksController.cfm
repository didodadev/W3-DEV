<cfscript>
    if(attributes.tabMenuController eq 0){
        WOStruct = StructNew();

        WOStruct['#attributes.fuseaction#'] = structNew();

        WOStruct['#attributes.fuseaction#']['default'] = 'list';
        if(not isdefined('attributes.event'))
            attributes.event = WOStruct['#attributes.fuseaction#']['default'];

        WOStruct['#attributes.fuseaction#']['list'] = structNew();
        WOStruct['#attributes.fuseaction#']['list']['windows'] = 'normal';
        WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'assetcare.desks';
        WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/assetcare/display/list_assetp_place.cfm';

        WOStruct['#attributes.fuseaction#']['add'] = structNew();
        WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'assetcare.desks';
        WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/assetcare/form/form_add_assetp_desk.cfm';
        WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'V16/assetcare/query/add_assetp_desk.cfm';
        WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'assetcare.desks&event=upd&assetp_id=';

        if(isdefined('attributes.asset_p_space_id')){
            WOStruct['#attributes.fuseaction#']['upd'] = structNew();
            WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
            WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'assetcare.desks';
            WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'V16/assetcare/form/form_upd_assetp_desk.cfm';
            WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'V16/assetcare/query/upd_assetp_desk.cfm';
            WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.asset_p_space_id#';
            WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'assetcare.desks&event=upd&assetp_id=';

            WOStruct['#attributes.fuseaction#']['del'] = structNew();
            WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
            WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'assetcare.desks&event=upd&del=1&assetp_id=#attributes.asset_p_space_id#';
            WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16/assetcare/query/upd_assetp_desk.cfm';
            WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/assetcare/query/upd_assetp_desk.cfm';
        }
    }
</cfscript>