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
        WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'assetcare.list_vehicles';
        WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/assetcare/display/list_vehicles.cfm';
        WOStruct['#attributes.fuseaction#']['list']['queryPath'] = 'V16/assetcare/display/list_vehicles.cfm';

        WOStruct['#attributes.fuseaction#']['add'] = structNew();
        WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'assetcare.form_add_assetp_vehicle';
        WOStruct['#attributes.fuseaction#']['add']['Xmlfuseaction'] = 'assetcare.vehicle_detail';
        WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/assetcare/form/form_add_assetp_vehicle.cfm';
        WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'V16/assetcare/query/add_assetp_vehicle.cfm';
        WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'assetcare.list_vehicles&event=upd&assetp_id=';
           
        if(isdefined("attributes.assetp_id"))
        {
            WOStruct['#attributes.fuseaction#']['upd'] = structNew();
            WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
            WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'assetcare.upd_vehicle_info';
            WOStruct['#attributes.fuseaction#']['upd']['Xmlfuseaction'] = 'assetcare.vehicle_detail';
            WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'V16/assetcare/form/upd_vehicle_info_frame.cfm';
            WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'V16/assetcare/query/upd_vehicle_info_frame.cfm';
            WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.assetp_id#';
            WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'assetcare.list_vehicles&event=upd&assetp_id=';

            WOStruct['#attributes.fuseaction#']['lic_info'] = structNew();
            WOStruct['#attributes.fuseaction#']['lic_info']['window'] = 'normal';
            WOStruct['#attributes.fuseaction#']['lic_info']['fuseaction'] = 'assetcare.list_vehicles';
            WOStruct['#attributes.fuseaction#']['lic_info']['filePath'] = 'V16/assetcare/form/upd_vehicle_license_frame.cfm';
            WOStruct['#attributes.fuseaction#']['lic_info']['queryPath'] = 'V16/assetcare/query/upd_vehicle_license.cfm';
            WOStruct['#attributes.fuseaction#']['lic_info']['Identity'] = '#attributes.assetp_id#';
            WOStruct['#attributes.fuseaction#']['lic_info']['nextEvent'] = 'assetcare.list_vehicles&event=lic_info&assetp_id=';

            WOStruct['#attributes.fuseaction#']['his'] = structNew();
            WOStruct['#attributes.fuseaction#']['his']['window'] = 'normal';
            WOStruct['#attributes.fuseaction#']['his']['fuseaction'] = 'assetcare.list_vehicles';
            WOStruct['#attributes.fuseaction#']['his']['filePath'] = 'V16/assetcare/display/list_vehicle_history_frame.cfm';
            WOStruct['#attributes.fuseaction#']['his']['Identity'] = '#attributes.assetp_id#';

            WOStruct['#attributes.fuseaction#']['add_acc'] = structNew();
            WOStruct['#attributes.fuseaction#']['add_acc']['window'] = 'normal';
            WOStruct['#attributes.fuseaction#']['add_acc']['fuseaction'] = 'assetcare.form_add_accident';
            WOStruct['#attributes.fuseaction#']['add_acc']['filePath'] = 'V16/assetcare/form/form_add_accident.cfm';
            WOStruct['#attributes.fuseaction#']['add_acc']['querypath'] = 'V16/assetcare/query/add_accident.cfm';
            WOStruct['#attributes.fuseaction#']['add_acc']['Identity'] = '#attributes.assetp_id#';
            WOStruct['#attributes.fuseaction#']['add_acc']['nextEvent'] = 'assetcare.list_vehicles&event=add_acc&assetp_id=';
            
            WOStruct['#attributes.fuseaction#']['acc'] = structNew();
            WOStruct['#attributes.fuseaction#']['acc']['window'] = 'normal';
            WOStruct['#attributes.fuseaction#']['acc']['fuseaction'] = 'assetcare.list_vehicles';
            WOStruct['#attributes.fuseaction#']['acc']['filePath'] = 'V16/assetcare/display/list_vehicle_accident_frame.cfm';
            WOStruct['#attributes.fuseaction#']['acc']['Identity'] = '#attributes.assetp_id#';

            WOStruct['#attributes.fuseaction#']['pun'] = structNew();
            WOStruct['#attributes.fuseaction#']['pun']['window'] = 'normal';
            WOStruct['#attributes.fuseaction#']['pun']['fuseaction'] = 'assetcare.list_vehicles';
            WOStruct['#attributes.fuseaction#']['pun']['filePath'] = 'V16/assetcare/display/list_vehicle_punishment_frame.cfm';
            WOStruct['#attributes.fuseaction#']['pun']['Identity'] = '#attributes.assetp_id#';

            WOStruct['#attributes.fuseaction#']['add_pun'] = structNew();
            WOStruct['#attributes.fuseaction#']['add_pun']['window'] = 'normal';
            WOStruct['#attributes.fuseaction#']['add_pun']['fuseaction'] = 'assetcare.form_add_punishment';
            WOStruct['#attributes.fuseaction#']['add_pun']['filePath'] = 'V16/assetcare/form/form_add_punishment.cfm';
            WOStruct['#attributes.fuseaction#']['add_pun']['querypath'] = 'V16/assetcare/query/add_fuel.cfm';
            WOStruct['#attributes.fuseaction#']['add_pun']['Identity'] = '#attributes.assetp_id#';

            WOStruct['#attributes.fuseaction#']['care'] = structNew();
            WOStruct['#attributes.fuseaction#']['care']['window'] = 'normal';
            WOStruct['#attributes.fuseaction#']['care']['fuseaction'] = 'assetcare.list_vehicles';
            WOStruct['#attributes.fuseaction#']['care']['filePath'] = 'V16/assetcare/display/list_vehicle_care_frame.cfm';
            WOStruct['#attributes.fuseaction#']['care']['Identity'] = '#attributes.assetp_id#';

            WOStruct['#attributes.fuseaction#']['rent'] = structNew();
            WOStruct['#attributes.fuseaction#']['rent']['window'] = 'normal';
            WOStruct['#attributes.fuseaction#']['rent']['fuseaction'] = 'assetcare.list_vehicles';
            WOStruct['#attributes.fuseaction#']['rent']['filePath'] = 'V16/assetcare/form/upd_vehicle_rent_contract_frame.cfm';
            WOStruct['#attributes.fuseaction#']['rent']['queryPath'] = 'V16/assetcare/query/upd_vehicle_rent_contract.cfm';
            WOStruct['#attributes.fuseaction#']['rent']['Identity'] = '#attributes.assetp_id#';
            WOStruct['#attributes.fuseaction#']['rent']['nextEvent'] = 'assetcare.list_vehicles&event=rent&assetp_id=';

            WOStruct['#attributes.fuseaction#']['ins'] = structNew();
            WOStruct['#attributes.fuseaction#']['ins']['window'] = 'normal';
            WOStruct['#attributes.fuseaction#']['ins']['fuseaction'] = 'assetcare.list_vehicles';
            WOStruct['#attributes.fuseaction#']['ins']['filePath'] = 'V16/assetcare/display/list_asset_vehicle_insurance.cfm';
            WOStruct['#attributes.fuseaction#']['ins']['Identity'] = '#attributes.assetp_id#';

        }
		
		WOStruct['#attributes.fuseaction#']['fuel'] = structNew();
		WOStruct['#attributes.fuseaction#']['fuel']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['fuel']['fuseaction'] = 'assetcare.list_vehicles';
		WOStruct['#attributes.fuseaction#']['fuel']['filePath'] = 'V16/assetcare/display/list_vehicle_fuel_frame.cfm';

		WOStruct['#attributes.fuseaction#']['add_fuel'] = structNew();
		WOStruct['#attributes.fuseaction#']['add_fuel']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add_fuel']['fuseaction'] = 'assetcare.form_add_fuel';
		WOStruct['#attributes.fuseaction#']['add_fuel']['filePath'] = 'V16/assetcare/form/form_add_fuel.cfm';
		WOStruct['#attributes.fuseaction#']['add_fuel']['querypath'] = 'V16/assetcare/query/add_fuel.cfm';
		WOStruct['#attributes.fuseaction#']['add_fuel']['nextEvent'] = 'assetcare.list_vehicles&event=upd_fuel&fuel_id=';

		if(IsDefined("attributes.fuel_id") and len(attributes.fuel_id))
		{
			WOStruct['#attributes.fuseaction#']['upd_fuel'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd_fuel']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['upd_fuel']['fuseaction'] = 'assetcare.form_upd_fuel';
			WOStruct['#attributes.fuseaction#']['upd_fuel']['filePath'] = 'V16/assetcare/form/form_upd_fuel.cfm';
			WOStruct['#attributes.fuseaction#']['upd_fuel']['queryPath'] = 'V16/assetcare/query/upd_fuel.cfm';
			WOStruct['#attributes.fuseaction#']['upd_fuel']['Identity'] = '#attributes.fuel_id#';
			WOStruct['#attributes.fuseaction#']['upd_fuel']['nextEvent'] = 'assetcare.list_vehicles&event=upd_fuel&fuel_id=';
			
			WOStruct['#attributes.fuseaction#']['del'] = structNew();
			WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
			WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=assetcare.emptypopup_del_fuel&fuel_id=#attributes.fuel_id#&plaka=##caller.get_fuel_upd.assetp##&is_detail=1&is_popup=0';
			WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16/assetcare/query/del_fuel.cfm';
			WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/assetcare/query/del_fuel.cfm';
			WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'assetcare.list_vehicles&event=fuel';

		}
		
		WOStruct['#attributes.fuseaction#']['km'] = structNew();
		WOStruct['#attributes.fuseaction#']['km']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['km']['fuseaction'] = 'assetcare.form_search_km';
		WOStruct['#attributes.fuseaction#']['km']['filePath'] = 'V16/assetcare/form/form_search_km.cfm';
		
		WOStruct['#attributes.fuseaction#']['add_km'] = structNew();
		WOStruct['#attributes.fuseaction#']['add_km']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add_km']['fuseaction'] = 'assetcare.list_vehicles';
		WOStruct['#attributes.fuseaction#']['add_km']['filePath'] = 'V16/assetcare/form/form_add_km.cfm';
		WOStruct['#attributes.fuseaction#']['add_km']['queryPath'] = 'V16/assetcare/query/add_km.cfm';
		WOStruct['#attributes.fuseaction#']['add_km']['nextEvent'] = 'assetcare.list_vehicles&event=upd_km&km_control_id=';
		
		if(IsDefined("attributes.km_control_id"))
		{
			WOStruct['#attributes.fuseaction#']['upd_km'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd_km']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['upd_km']['fuseaction'] = 'assetcare.form_upd_km';
			WOStruct['#attributes.fuseaction#']['upd_km']['filePath'] = 'V16/assetcare/form/form_upd_km.cfm';
			WOStruct['#attributes.fuseaction#']['upd_km']['queryPath'] = 'V16/assetcare/query/upd_km.cfm';
			WOStruct['#attributes.fuseaction#']['upd_km']['Identity'] = '#attributes.km_control_id#';
			WOStruct['#attributes.fuseaction#']['upd_km']['nextEvent'] = 'assetcare.list_vehicles&event=upd_km&km_control_id=#attributes.km_control_id#&assetp_id=';
			
			WOStruct['#attributes.fuseaction#']['del'] = structNew();
			WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
			WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=assetcare.emptypopup_del_km&km_control_id=#attributes.km_control_id#&plaka=##caller.get_km_upd.assetp##&assetp_id=#attributes.assetp_id#&is_detail=1';
			WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16/assetcare/query/del_km.cfm';
			WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/assetcare/query/del_km.cfm';
			WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'assetcare.list_vehicles&event=add_km&assetp_id=#attributes.assetp_id#';
		}
		
		WOStruct['#attributes.fuseaction#']['tr'] = structNew();
		WOStruct['#attributes.fuseaction#']['tr']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['tr']['fuseaction'] = 'assetcare.vehicle_transport';
		WOStruct['#attributes.fuseaction#']['tr']['filePath'] = 'V16/assetcare/form/vehicle_transport.cfm';
		WOStruct['#attributes.fuseaction#']['tr']['querypath'] = '';
		WOStruct['#attributes.fuseaction#']['tr']['nextEvent'] = 'assetcare.list_vehicles&event=tr&assetp_id=';
		
		WOStruct['#attributes.fuseaction#']['add_tr'] = structNew();
		WOStruct['#attributes.fuseaction#']['add_tr']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add_tr']['fuseaction'] = 'assetcare.add_vehicle_transport';
		WOStruct['#attributes.fuseaction#']['add_tr']['filePath'] = 'V16/assetcare/form/add_vehicle_transport_frame.cfm';
		WOStruct['#attributes.fuseaction#']['add_tr']['querypath'] = 'V16/assetcare/query/add_vehicle_transport_frame.cfm';
		WOStruct['#attributes.fuseaction#']['add_tr']['nextEvent'] = 'assetcare.list_vehicles&event=add_tr';
		
		if(IsDefined("attributes.ship_id") and len(attributes.ship_id))
		{
			WOStruct['#attributes.fuseaction#']['upd_tr'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd_tr']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['upd_tr']['fuseaction'] = 'assetcare.upd_vehicle_transport';
			WOStruct['#attributes.fuseaction#']['upd_tr']['filePath'] = 'V16/assetcare/form/upd_vehicle_transport_frame.cfm';
			WOStruct['#attributes.fuseaction#']['upd_tr']['querypath'] = 'V16/assetcare/query/upd_vehicle_transport_frame.cfm';
			WOStruct['#attributes.fuseaction#']['upd_tr']['nextEvent'] = 'assetcare.list_vehicles&event=upd_tr&ship_id=';
			
			WOStruct['#attributes.fuseaction#']['del'] = structNew();
			WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
			WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'assetcare.emptypopup_del_vehicle_transport&ship_id=#attributes.ship_id#&head=##caller.get_transport.document_num##&is_detail=0';
			WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16/assetcare/query/del_vehicle_transport.cfm';
			WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/assetcare/query/del_vehicle_transport.cfm';
			WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'assetcare.list_vehicles&event=tr';
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
            tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=assetcare.list_vehicles";
            tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main', 49)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";
            tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);

        }
        
        if (isdefined('attributes.assetp_id') and (caller.attributes.event is 'upd' or caller.attributes.event is 'lic_info' or caller.attributes.event is 'his' or caller.attributes.event is 'acc'
        or caller.attributes.event is 'pun' or caller.attributes.event is 'care' or caller.attributes.event is 'rent' or caller.attributes.event is 'ins'
        or caller.attributes.event is 'add_acc' or caller.attributes.event is 'add_km'
        or caller.attributes.event is 'upd_km' or caller.attributes.event is 'add_pun' or caller.attributes.event is 'add_tr' or caller.attributes.event is 'upd_tr' 
		or caller.attributes.event is 'add_fuel' or caller.attributes.event is 'upd_fuel'))
        {
            event=caller.attributes.event;

            tabMenuStruct['#fuseactController#']['tabMenus']['#event#']['icons'] = structNew();
            tabMenuStruct['#fuseactController#']['tabMenus']['#event#']['icons']['add']['text'] = "#getLang('main', 170)#";
            tabMenuStruct['#fuseactController#']['tabMenus']['#event#']['icons']['add']['href'] = "#request.self#?fuseaction=assetcare.list_vehicles&event=add";
            tabMenuStruct['#fuseactController#']['tabMenus']['#event#']['icons']['add']['target'] = "_blank";
            tabMenuStruct['#fuseactController#']['tabMenus']['#event#']['icons']['copy']['text'] = "#getLang('main', 64)#";
            tabMenuStruct['#fuseactController#']['tabMenus']['#event#']['icons']['copy']['href'] = "#request.self#?fuseaction=assetcare.list_vehicles&event=add&assetp_id=#attributes.assetp_id#";
            tabMenuStruct['#fuseactController#']['tabMenus']['#event#']['icons']['copy']['target'] = "_blank";
            tabMenuStruct['#fuseactController#']['tabMenus']['#event#']['icons']['print']['text'] = '#getLang('','Yazdır','57474')#';
            tabMenuStruct['#fuseactController#']['tabMenus']['#event#']['icons']['print']['onClick'] = "window.open('#request.self#?fuseaction=objects.popup_print_files&iid=#attributes.assetp_id#&print_type=74')";
            tabMenuStruct['#fuseactController#']['tabMenus']['#event#']['icons']['list-ul']['target'] = "_blank";
            tabMenuStruct['#fuseactController#']['tabMenus']['#event#']['icons']['list-ul']['text'] = '#getLang('main', 1303)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['#event#']['icons']['list-ul']['href'] = "#request.self#?fuseaction=assetcare.list_vehicles";
            tabMenuStruct['#fuseactController#']['tabMenus']['#event#']['icons']['check']['text'] = '#getLang('main', 52)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['#event#']['icons']['check']['onClick'] = "buttonClickFunction()";
            tabMenuStruct['#fuseactController#']['tabMenus']['#event#']['icons']['bell']['text'] = '#getLang('','Uyarılar','57757')#';
            tabMenuStruct['#fuseactController#']['tabMenus']['#event#']['icons']['bell']['onclick'] =  "window.open('#request.self#?fuseaction=objects.workflowpages&tab=3&action=#attributes.fuseaction#&action_name=assetp_id&action_id=#attributes.assetp_id#','Workflow')";

            i=0;
           /*  tabMenuStruct['#fuseactController#']['tabMenus']['#event#']['menus'][i]['text'] = '#getLang('main',568)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['#event#']['menus'][i]['href'] ="#request.self#?fuseaction=assetcare.list_vehicles&event=upd&assetp_id=#attributes.assetp_id#";
            i=i+1; */
                tabMenuStruct['#fuseactController#']['tabMenus']['#event#']['menus'][i]['text'] = '#getLang('assetcare', 106)#';
                tabMenuStruct['#fuseactController#']['tabMenus']['#event#']['menus'][i]['href'] = "#request.self#?fuseaction=assetcare.list_vehicles&event=add_acc&assetp_id=#attributes.assetp_id#";
            i=i+1;
            if(isDefined("url.assetp_id") and not listfindnocase(denied_pages,'assetcare.popup_list_asset_care_nonperiod'))
            {
                tabMenuStruct['#fuseactController#']['tabMenus']['#event#']['menus'][i]['text'] = '#getLang('assetcare', 29)#';
                tabMenuStruct['#fuseactController#']['tabMenus']['#event#']['menus'][i]['onclick'] ="windowopen('#request.self#?fuseaction=assetcare.popup_list_asset_care_nonperiod&assetp_id=#url.assetp_id#','list')";
            i=i+1;
            }
            if (isDefined("url.assetp_id") and not listfindnocase(denied_pages,'assetcare.popup_asset_reserve_history'))
            { 
                
                tabMenuStruct['#fuseactController#']['tabMenus']['#event#']['menus'][i]['text'] = '#getLang('main', 1160)#';
                tabMenuStruct['#fuseactController#']['tabMenus']['#event#']['menus'][i]['onclick'] ="windowopen('#request.self#?fuseaction=assetcare.popup_asset_reserve_history&assetp_id=#url.assetp_id#','medium')";
                i=i+1;
            }
            
            tabMenuStruct['#fuseactController#']['tabMenus']['#event#']['menus'][i]['text'] = '#getLang('assetcare',157)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['#event#']['menus'][i]['href'] ="#request.self#?fuseaction=assetcare.list_vehicles&event=tr&assetp_id=#attributes.assetp_id#";
            i=i+1;

            tabMenuStruct['#fuseactController#']['tabMenus']['#event#']['menus'][i]['text'] = '#getLang('assetcare',100)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['#event#']['menus'][i]['href'] ="#request.self#?fuseaction=assetcare.list_vehicles&event=add_km&assetp_id=#attributes.assetp_id#";
            i=i+1;
            tabMenuStruct['#fuseactController#']['tabMenus']['#event#']['menus'][i]['target'] = "_blank";;
            tabMenuStruct['#fuseactController#']['tabMenus']['#event#']['menus'][i]['text'] = '#getLang('assetcare',198)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['#event#']['menus'][i]['href'] ="#request.self#?fuseaction=assetcare.list_vehicles&event=add_fuel&assetp_id=#attributes.assetp_id#";
            i=i+1;

            tabMenuStruct['#fuseactController#']['tabMenus']['#event#']['menus'][i]['text'] = '#getLang('assetcare',150)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['#event#']['menus'][i]['href'] ="#request.self#?fuseaction=assetcare.form_add_punishment&assetp_id=#attributes.assetp_id#";
            i=i+1;

            tabMenuStruct['#fuseactController#']['tabMenus']['#event#']['menus'][i]['text'] = '#getLang('assetcare',420)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['#event#']['menus'][i]['target'] = '_blank';
            tabMenuStruct['#fuseactController#']['tabMenus']['#event#']['menus'][i]['href'] ="#request.self#?fuseaction=assetcare.list_asset_care&event=add&asset_id=#attributes.assetp_id#";
            i=i+1;

            tabMenuStruct['#fuseactController#']['tabMenus']['#event#']['menus'][i]['text'] = '#getLang('assetcare',525)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['#event#']['menus'][i]['href'] ="#request.self#?fuseaction=assetcare.list_vehicles&event=lic_info&assetp_id=#attributes.assetp_id#";
            
            i=i+1;
            tabMenuStruct['#fuseactController#']['tabMenus']['#event#']['menus'][i]['text'] = '#getLang('main',61)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['#event#']['menus'][i]['href'] ="#request.self#?fuseaction=assetcare.list_vehicles&event=his&assetp_id=#attributes.assetp_id#";
            i=i+1; 
            tabMenuStruct['#fuseactController#']['tabMenus']['#event#']['menus'][i]['target'] = "_blank";
            tabMenuStruct['#fuseactController#']['tabMenus']['#event#']['menus'][i]['text'] = '#getLang('assetcare',132)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['#event#']['menus'][i]['href'] ="#request.self#?fuseaction=assetcare.list_vehicles&event=km&assetp_id=#attributes.assetp_id#";
             i=i+1;
            tabMenuStruct['#fuseactController#']['tabMenus']['#event#']['menus'][i]['target'] = "_blank";
            tabMenuStruct['#fuseactController#']['tabMenus']['#event#']['menus'][i]['text'] = '#getLang('','Yakıt Harcamaları',47252)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['#event#']['menus'][i]['href'] ="#request.self#?fuseaction=assetcare.form_search_fuel&assetp_id=#attributes.assetp_id#&is_submitted=1";
             i=i+1;
            tabMenuStruct['#fuseactController#']['tabMenus']['#event#']['menus'][i]['text'] = '#getLang('assetcare',456)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['#event#']['menus'][i]['href'] ="#request.self#?fuseaction=assetcare.list_vehicles&event=acc&assetp_id=#attributes.assetp_id#";
            i=i+1;
            tabMenuStruct['#fuseactController#']['tabMenus']['#event#']['menus'][i]['text'] = '#getLang('assetcare',455)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['#event#']['menus'][i]['href'] ="#request.self#?fuseaction=assetcare.list_vehicles&event=pun&assetp_id=#attributes.assetp_id#";
            i=i+1;
            tabMenuStruct['#fuseactController#']['tabMenus']['#event#']['menus'][i]['text'] = '#getLang('assetcare',34)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['#event#']['menus'][i]['href'] ="#request.self#?fuseaction=assetcare.list_vehicles&event=care&assetp_id=#attributes.assetp_id#";
            i=i+1;
            tabMenuStruct['#fuseactController#']['tabMenus']['#event#']['menus'][i]['text'] = '#getLang('main',25)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['#event#']['menus'][i]['href'] ="#request.self#?fuseaction=assetcare.list_vehicles&event=rent&assetp_id=#attributes.assetp_id#";
            i=i+1;
            tabMenuStruct['#fuseactController#']['tabMenus']['#event#']['menus'][i]['text'] = '#getLang('assetcare',48)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['#event#']['menus'][i]['href'] ="#request.self#?fuseaction=assetcare.list_vehicles&event=ins&assetp_id=#attributes.assetp_id#";
            tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);

        }
    }

    WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
    WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd';
    WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'ASSET_P';
    WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'ASSETP_ID';
    WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-assetp','item-sup_comp_name','item-sup_partner_name','item-vehicle_type','item-assetp_sub_catid','item-branch_name','item-employee_name','item-make_year','item-brand_model']";
</cfscript>