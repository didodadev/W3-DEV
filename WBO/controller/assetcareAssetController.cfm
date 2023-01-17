<cfscript>
    if(attributes.tabMenuController eq 0){
        WOStruct = StructNew();

        WOStruct['#attributes.fuseaction#'] = structNew();

        WOStruct['#attributes.fuseaction#']['default'] = 'list';
        if(not isdefined('attributes.event'))
            attributes.event = WOStruct['#attributes.fuseaction#']['default'];

        WOStruct['#attributes.fuseaction#']['list'] = structNew();
        WOStruct['#attributes.fuseaction#']['list']['windows'] = 'normal';
        WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'assetcare.list_assetp';
        WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/assetcare/display/list_assetp.cfm';
        WOStruct['#attributes.fuseaction#']['list']['queryPath'] = 'V16/assetcare/display/list_assetp.cfm';

        WOStruct['#attributes.fuseaction#']['add'] = structNew();
        WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'assetcare.form_add_assetp';
        WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/assetcare/form/form_add_assetp.cfm';
        WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'V16/assetcare/query/add_assetp.cfm';
        WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'assetcare.list_assetp&event=upd&assetp_id=';

        WOStruct['#attributes.fuseaction#']['googleMap'] = structNew();
		WOStruct['#attributes.fuseaction#']['googleMap']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['googleMap']['fuseaction'] = 'assetcare.list_assetp';
		WOStruct['#attributes.fuseaction#']['googleMap']['filePath'] = 'V16/assetcare/form/google_map.cfm';
        WOStruct['#attributes.fuseaction#']['googleMap']['queryPath'] = 'V16/assetcare/form/google_map.cfm';
        WOStruct['#attributes.fuseaction#']['googleMap']['nextEvent'] = '';
    
        WOStruct['#attributes.fuseaction#']['detlist'] = structNew();
        WOStruct['#attributes.fuseaction#']['detlist']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['detlist']['fuseaction'] = 'assetcare.list_assetp';
        WOStruct['#attributes.fuseaction#']['detlist']['filePath'] = 'V16/assetcare/display/list_assetp_widget.cfm';

        if(isdefined('attributes.assetp_id')){
            WOStruct['#attributes.fuseaction#']['upd'] = structNew();
            WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
            WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'assetcare.form_upd_assetp';
			WOStruct['#attributes.fuseaction#']['upd']['Xmlfuseaction'] = 'assetcare.form_add_assetp';
            WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'V16/assetcare/form/form_upd_assetp.cfm';
            WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'V16/assetcare/query/upd_assetp.cfm';
            WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.assetp_id#';
            WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'assetcare.list_assetp&event=upd&assetp_id=';
        }
    }else{
        fuseactController = caller.attributes.fuseaction;
        getLang = caller.getLang;

        tabMenuStruct = StructNew();
        tabMenuStruct['#fuseactController#'] = structNew();
        tabMenuStruct['#fuseactController#']['tabMenus'] = structNew();
    
        if(caller.attributes.event is 'add'){
            tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons'] = structNew();
            tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['target'] = "_blank";
            tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['text'] = '#getLang('sales', 154)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=assetcare.list_assetp";
            tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main', 49)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";
            tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['fa fa-download']['text'] = '#getLang('main',2576)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['fa fa-download']['onClick'] =  "open_tab('#request.self#?fuseaction=settings.form_add_assetp_import&control_fus=1','assetp_import');";			
	
            tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
        }
        if(caller.attributes.event is 'upd'){
            get_assetp = caller.get_assetp;
            get_assetp_it = caller.get_assetp_it;
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['target'] = "_blank";
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('sales', 154)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=assetcare.list_assetp";
            i=0;
            if(len(get_assetp.inventory_id)){ // and (caller.get_module_user(31) 
                tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('main', 1190)#';
                tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['href'] = "#request.self#?fuseaction=invent.list_inventory&event=det&inventory_id=#get_assetp.inventory_id#";
                tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['target'] = "";
                i=i+1;
            }
            if(get_assetp.property eq 2){
                if(not listfindnocase(caller.denied_pages,'assetcare.popup_upd_asset_contract1')){
                    tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('main', 740)#';
                    tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onclick'] = "windowopen('#request.self#?fuseaction=assetcare.popup_asset_history&asset_id=#url.assetp_id#','wide')";
                    i=i+1;
                }
            }else if(get_assetp.property eq 4){
                if(not listfindnocase(caller.denied_pages,'assetcare.popup_upd_asset_contract1')){
                    tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('assetcare', 491)#';
                    tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onclick'] = "windowopen('#request.self#?fuseaction=assetcare.popup_upd_asset_contract1&asset_id=#url.assetp_id#&property=2','medium')";
                    i=i+1;
                }
            }
            if(get_assetp.motorized_vehicle and not get_assetp.it_asset){
                if(not listfindnocase(caller.denied_pages,'assetcare.popup_vehicle_ship_detail')){
                    tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('main', 114)#';
                    tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onclick'] = "windowopen('#request.self#?fuseaction=logistic.popup_vehicle_ship_detail&assetp_id=#url.assetp_id#','list');";
                    i=i+1;
                }
                if(not listfindnocase(caller.denied_pages,'assetcare.popup_list_kaza_detail')){
                    tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('main', 131)#';
                    tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onclick'] = "windowopen('#request.self#?fuseaction=assetcare.popup_list_kaza_detail&assetp_id=#attributes.assetp_id#','list');";
                    i=i+1;
                }
                if(not listfindnocase(caller.denied_pages,'assetcare.popup_list_km_control_detail')){
                    tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('main', 132)#';
                    tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onclick'] = "windowopen('#request.self#?fuseaction=assetcare.popup_list_km_control_detail&assetp_id=#url.assetp_id#','list');";
                    i=i+1;
                }
                if(not listfindnocase(caller.denied_pages,'assetcare.popup_list_punishment_detail')){
                    tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('main', 133)#';
                    tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onclick'] = "windowopen('#request.self#?fuseaction=assetcare.popup_list_punishment_detail&assetp_id=#url.assetp_id#','project');";
                    i=i+1;
                }
                if(not listfindnocase(caller.denied_pages,'assetcare.popup_list_oil_detail')){
                    tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('main', 134)#';
                    tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onclick'] = "windowopen('#request.self#?fuseaction=assetcare.popup_list_oil_detail&assetp_id=#url.assetp_id#','project');";
                    i=i+1;
                }
            }
            if(get_assetp.it_asset and not get_assetp.motorized_vehicle){
                if(len(get_assetp_it.assetp_id)){
                    if(not listfindnocase(caller.denied_pages,'assetcare.popup_upd_it_asset')){
                        tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('main', 32)#';
                        tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onclick'] = "windowopen('#request.self#?fuseaction=assetcare.popup_upd_it_asset&asset_id=#url.assetp_id#','medium');";
                        i=i+1;
                    }
                }else{
                    if(not listfindnocase(caller.denied_pages,'assetcare.popup_upd_it_asset')){
                        tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('assetcare', 32)#';
                        tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onclick'] = "windowopen('#request.self#?fuseaction=assetcare.popup_add_it_asset&asset_id=#url.assetp_id#','medium');";
                        i=i+1;
                    }
                }
            }
            if(get_assetp.assetp_reserve){
                if(not listfindnocase(caller.denied_pages,'assetcare.popup_asset_reserve_history')){
                    tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('main', 1160)#';
                    tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onclick'] = "windowopen('#request.self#?fuseaction=assetcare.popup_asset_reserve_history&asset_id=#url.assetp_id#','medium');";
                    i=i+1;
                }
            }
            if(not listfindnocase(caller.denied_pages,'assetcare.popup_list_asset_care_nonperiod')){
                tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('assetcare','Harcamalar','47900')#';
                tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onclick'] = "openBoxDraggable('#request.self#?fuseaction=assetcare.popup_list_asset_care_nonperiod&asset_id=#url.assetp_id#');";
                i=i+1;
            }
            if(not listfindnocase(caller.denied_pages,'assetcare.list_asset_cares_report')){
                tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('assetcare','Tamir Bakım Sonuçları','47877')#';
                tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['target'] = '_blank';
                tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['href'] = "#request.self#?fuseaction=assetcare.list_asset_care&asset_id=#url.assetp_id#&submit=1";
                i=i+1;
            }
            if(not listfindnocase(caller.denied_pages,'assetcare.popup_list_asset_cares_report')){
                tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('','Bakım Sonucu', '47905')#';
                tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['target'] = '_blank';
                tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['href'] = "#request.self#?fuseaction=assetcare.list_asset_care&event=add&asset_id=#url.assetp_id#";
                i=i+1;
            }
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('main', 170)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=assetcare.list_assetp&event=add";
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['copy']['text'] = 'Kopyala';
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['copy']['href'] = "#request.self#?fuseaction=assetcare.list_assetp&event=add&assetp_id=#attributes.assetp_id#";
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['copy']['target'] = "_blank";
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['text'] = '#getLang('main', 62)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_print_files&iid=#attributes.assetp_id#&print_type=250','page','workcube_print');";
            if(not listfindnocase(caller.denied_pages,'assetcare.popup_asset_history')){
                tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-history']['text'] = '#getLang('main', 61)#';
                tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-history']['onclick'] = "openBoxDraggable('#request.self#?fuseaction=assetcare.popup_asset_history&asset_id=#url.assetp_id#')";
            }
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['bell']['target'] = "_blank";
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['bell']['text'] = '#getLang('main', 345)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['bell']['href'] = "#request.self#?fuseaction=objects.workflowpages&tab=3&action=assetcare.form_upd_assetp&action_name=assetp_id&action_id=#attributes.assetp_id#";
            if(not listfindnocase(caller.denied_pages,'assetcare.popup_form_add_info_plus')){
                tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['info-circle']['text'] = '#getLang('main', 398)#';
                if(len(get_assetp.assetp_catid))
                    tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['info-circle']['onclick'] = "openBoxDraggable('#request.self#?fuseaction=objects.popup_list_comp_add_info&info_id=#attributes.assetp_id#&type_id=-13&assetp_catid=#get_assetp.assetp_catid#');";
                else
                    tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['info-circle']['onclick'] = "openBoxDraggable('#request.self#?fuseaction=objects.popup_list_comp_add_info&info_id=#attributes.assetp_id#&type_id=-13');";
            }
        }
            tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
    }
    WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
    WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd';
    WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'ASSET_P';
    WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'ASSETP_ID';
    WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-assetp', 'item-sup_company', 'item-sup_partner', 'item-assetp_catid', 'item-department', 'item-position_code', 'item-start_date', 'employee_name', 'item-get_date']";
</cfscript>