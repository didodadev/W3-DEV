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
        WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'assetcare.list_ship_analysis';
		WOStruct['#attributes.fuseaction#']['list']['XmlFuseaction'] = 'assetcare.add_ship_analysis';
        WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/assetcare/display/list_ship_analysis.cfm';
        WOStruct['#attributes.fuseaction#']['list']['queryPath'] = 'V16/assetcare/display/list_ship_analysis.cfm';


        WOStruct['#attributes.fuseaction#']['add'] = structNew();
        WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'assetcare.add_ship_analysis';
        WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/assetcare/form/add_ship_analysis.cfm';
        WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'V16/assetcare/query/add_ship_analysis.cfm';
        WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'assetcare.list_ship_analysis&event=upd&ship_id=';

        if(isdefined("attributes.ship_id"))
        {
            WOStruct['#attributes.fuseaction#']['upd'] = structNew();
            WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
            WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'assetcare.upd_ship_analysis';
			WOStruct['#attributes.fuseaction#']['upd']['XmlFuseaction'] = 'assetcare.add_ship_analysis';
            WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'V16/assetcare/form/upd_ship_analysis.cfm';
            WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'V16/assetcare/query/upd_ship_analysis.cfm';
            WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.ship_id#';
            WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'assetcare.list_ship_analysis&event=upd&ship_id=';

            WOStruct['#attributes.fuseaction#']['del'] = structNew();
            WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
            WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'assetcare.emptypopup_del_ship_analysis&ship_id=#attributes.ship_id#';
            WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16/assetcare/query/del_ship_analysis.cfm';
            WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/assetcare/query/del_ship_analysis.cfm';
        }
    }
    
</cfscript>