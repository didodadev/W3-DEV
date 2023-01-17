<cfscript>
    event="";
    if(attributes.tabMenuController eq 0)
    {
        WOStruct = StructNew();

        WOStruct['#attributes.fuseaction#'] = structNew();

        WOStruct['#attributes.fuseaction#']['default'] = 'list';
        if(not isdefined('attributes.event'))
            attributes.event = WOStruct['#attributes.fuseaction#']['default'];

        WOStruct['#attributes.fuseaction#']['list'] = structNew();
		WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'assetcare.vehicle_transport';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/assetcare/form/vehicle_transport.cfm';
		WOStruct['#attributes.fuseaction#']['list']['querypath'] = 'V16/assetcare/form/vehicle_transport.cfm';

		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'assetcare.add_vehicle_transport';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/assetcare/form/add_vehicle_transport_frame.cfm';
		WOStruct['#attributes.fuseaction#']['add']['querypath'] = 'V16/assetcare/query/add_vehicle_transport_frame.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'assetcare.vehicle_transport&event=add';
		
		if(IsDefined("attributes.ship_id") and len(attributes.ship_id))
		{
			WOStruct['#attributes.fuseaction#']['upd'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'assetcare.upd_vehicle_transport';
			WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'V16/assetcare/form/upd_vehicle_transport_frame.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['querypath'] = 'V16/assetcare/query/upd_vehicle_transport_frame.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'assetcare.vehicle_transport&event=upd&ship_id=';
			
			WOStruct['#attributes.fuseaction#']['del'] = structNew();
			WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
			WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'assetcare.emptypopup_del_vehicle_transport&ship_id=#attributes.ship_id#&head=##caller.get_transport.document_num##&is_detail=0';
			WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16/assetcare/query/del_vehicle_transport.cfm';
			WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/assetcare/query/del_vehicle_transport.cfm';
			WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'assetcare.vehicle_transport&event=tr';
		}
    }
    else  {
        fuseactController = caller.attributes.fuseaction;
        denied_pages=caller.denied_pages;
        getLang = caller.getLang;

        tabMenuStruct = StructNew();
        tabMenuStruct['#fuseactController#'] = structNew();
        tabMenuStruct['#fuseactController#']['tabMenus'] = structNew();

        if (caller.attributes.event is 'add'  ) {

            tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons'] = structNew();
            tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['target'] = "_blank";
            tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['text'] = '#getLang('main', 1303)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=assetcare.vehicle_transport";
            tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main', 49)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";
            tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);

        }
        
        if (caller.attributes.event is 'upd' )
        {
            event=caller.attributes.event;

            tabMenuStruct['#fuseactController#']['tabMenus']['#event#']['icons'] = structNew();
            tabMenuStruct['#fuseactController#']['tabMenus']['#event#']['icons']['add']['text'] = "#getLang('main', 170)#";
            tabMenuStruct['#fuseactController#']['tabMenus']['#event#']['icons']['add']['href'] = "#request.self#?fuseaction=assetcare.vehicle_transport&event=add";
            tabMenuStruct['#fuseactController#']['tabMenus']['#event#']['icons']['add']['target'] = "_blank";
            tabMenuStruct['#fuseactController#']['tabMenus']['#event#']['icons']['list-ul']['target'] = "_blank";
            tabMenuStruct['#fuseactController#']['tabMenus']['#event#']['icons']['list-ul']['text'] = '#getLang('main', 1303)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['#event#']['icons']['list-ul']['href'] = "#request.self#?fuseaction=assetcare.vehicle_transport";
            tabMenuStruct['#fuseactController#']['tabMenus']['#event#']['icons']['check']['text'] = '#getLang('main', 52)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['#event#']['icons']['check']['onClick'] = "buttonClickFunction()";
        }
    }

    WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
    WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd';
    WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'ASSET_P';
    WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'ASSETP_ID';
    WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-assetp','item-sup_comp_name','item-sup_partner_name','item-vehicle_type','item-assetp_sub_catid','item-branch_name','item-employee_name','item-make_year','item-brand_model']";
</cfscript>