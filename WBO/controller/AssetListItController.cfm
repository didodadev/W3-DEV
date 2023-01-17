
<cfscript>
    if(attributes.tabMenuController eq 0)
    {
        WOStruct = StructNew();
        
        WOStruct['#attributes.fuseaction#'] = structNew();
        
        WOStruct['#attributes.fuseaction#']['default'] = 'list';
        if(not isdefined('attributes.event'))
            attributes.event = WOStruct['#attributes.fuseaction#']['default'];
    
    
            WOStruct['#attributes.fuseaction#']['list'] = structNew();
            WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
            WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'asset.library';
            WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/asset/display/list_it.cfm';
            WOStruct['#attributes.fuseaction#']['list']['queryPath'] = 'V16/asset/display/list_it.cfm';
            WOStruct['#attributes.fuseaction#']['list']['nextEvent'] = 'asset.library';
            WOStruct['#attributes.fuseaction#']['list']['formName'] = 'form'; 

            WOStruct['#attributes.fuseaction#']['add'] = structNew();
            WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
            WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'asset.library';
            WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/asset/display/add_library_asset.cfm';
            WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'V16/asset/query/add_library_asset.cfm';   
            WOStruct['#attributes.fuseaction#']['add']['formName'] = 'add_asset_care';
            WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'asset.library';

            
            if(isdefined("attributes.lib_asset_id"))
        {
            WOStruct['#attributes.fuseaction#']['upd'] = structNew();
            WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
            WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'asset.library';
            WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'V16/asset/display/upd_library_asset.cfm';
            WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'V16/asset/query/upd_lib_asset.cfm';
            WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.lib_asset_id#';
            WOStruct['#attributes.fuseaction#']['upd']['formName'] = 'upd_asset_care';
            WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'asset.library';

            WOStruct['#attributes.fuseaction#']['del'] = structNew();
			WOStruct['#attributes.fuseaction#']['del']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=assetcare.emptypopup_del_vehicle_allocate&km_control_id=';
			WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16/asset/query/del_lib_asset.cfm';
			WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/asset/query/del_lib_asset.cfm';
			WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'asset.library';
    
        }
        
    }
    
</cfscript>

