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
        WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'assetcare.list_asset_it';
        WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/assetcare/display/list_asset_it.cfm';
        WOStruct['#attributes.fuseaction#']['list']['queryPath'] = 'V16/assetcare/display/list_asset_it.cfm';

        WOStruct['#attributes.fuseaction#']['add'] = structNew();
        WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'assetcare.form_add_assetp_it';
        WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/assetcare/form/form_add_assetp_it.cfm';
        WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'V16/assetcare/query/add_assetp_it.cfm';
        WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'assetcare.list_asset_it&event=upd&assetp_id=';

        if (isdefined("attributes.assetp_id"))
        {
            WOStruct['#attributes.fuseaction#']['upd'] = structNew();
            WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
            WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'assetcare.form_upd_assetp_it';
            WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'V16/assetcare/form/form_upd_assetp_it.cfm';
            WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'V16/assetcare/query/upd_assetp_it.cfm';
           /*  WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.assetp_id#'; */
            WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'assetcare.list_asset_it&event=upd&assetp_id=';

            /*WOStruct['#attributes.fuseaction#']['del'] = structNew();
            WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
            WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'assetcare.emptypopup_del_asset_failure&failure_id=#attributes.failure_id#';
            WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16/assetcare/query/del_asset_failure.cfm';
            WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/assetcare/query/del_asset_failure.cfm';
*/
        }
    }
    else  {
        fuseactController = caller.attributes.fuseaction;
        getLang = caller.getLang;

        tabMenuStruct = StructNew();
        tabMenuStruct['#fuseactController#'] = structNew();
        tabMenuStruct['#fuseactController#']['tabMenus'] = structNew();
        if (caller.attributes.event is 'add')
        {

            tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons'] = structNew();
            tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['target'] = "_blank";
            tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['text'] = '#getLang('main',97)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=assetcare.list_asset_it";
            tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";
        }
        if (caller.attributes.event is 'upd')
        {
            
            denied_pages=caller.denied_pages;
            get_assetp.assetp_catid=caller.get_assetp.assetp_catid;
            get_assetp=caller.get_assetp;
            get_assetp_it=caller.get_assetp_it;
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['target'] = "_blank";
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=assetcare.list_asset_it";
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('main', 170)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=assetcare.list_asset_it&event=add";
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['copy']['text'] = '#getLang('main', 64)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['copy']['href'] = "#request.self#?fuseaction=assetcare.list_asset_it&event=add&assetp_id=#attributes.assetp_id#";
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['copy']['target'] = "_blank";
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['text'] = '#getLang('','Yazdır','57474')#';
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['onClick'] = "window.open('#request.self#?fuseaction=objects.popup_print_files&print_type=250&action_type=#attributes.assetp_id#&action_id=#attributes.assetp_id#')";
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main',49)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";
            
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['bell']['text'] = '#getLang('','Uyarılar','57757')#';
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['bell']['onclick'] =  "window.open('#request.self#?fuseaction=objects.workflowpages&tab=3&action=#attributes.fuseaction#&action_name=assetp_id&action_id=#attributes.assetp_id#','Workflow')";

            if(not listfindnocase(denied_pages,'assetcare.popup_asset_history'))
            {
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-history']['text'] = "#getLang('main','Tarihçe',57473)#";
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-history']['onClick'] = "openBoxDraggable('#request.self#?fuseaction=assetcare.popup_asset_history&&asset_id=#url.assetp_id#')";
            }


            i=0;
            if(not listfindnocase(denied_pages,'assetcare.popup_form_add_info_plus'))
            {         
                tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('main', 398)#';
                tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onclick'] = "windowopen('#request.self#?fuseaction=objects.popup_list_comp_add_info&info_id=#attributes.assetp_id#&type_id=-19&<if len(get_assetp.assetp_catid)>assetp_catid=#get_assetp.assetp_catid#</if>','list')";
                i=i+1;
            }
            
            if (get_assetp.property eq 2)
            {
				if (not listfindnocase(denied_pages,'assetcare.popup_upd_asset_contract1'))
                {
                    tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('assetcare', 332)#';
                    tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onclick'] = "windowopen('#request.self#?fuseaction=assetcare.popup_upd_asset_contract1&asset_id=#url.assetp_id#&property=4','medium')";
                    i=i+1; 
                }
            }                       
            else if (get_assetp.property eq 4)
            {
				if (not listfindnocase(denied_pages,'assetcare.popup_upd_asset_contract1'))
                {
                    tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('assetcare', 491)#';
                    tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onclick'] = "windowopen('#request.self#?fuseaction=assetcare.popup_upd_asset_contract1&asset_id=#url.assetp_id#&property=2','medium')";
                    i=i+1;
                }
            }            
			
			if (get_assetp.motorized_vehicle and not(get_assetp.it_asset))
            {
				if (not listfindnocase(denied_pages,'assetcare.popup_vehicle_ship_detail'))
                {
                    tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('assetcare', 114)#';
                    tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onclick'] = "windowopen('#request.self#?fuseaction=logistic.popup_vehicle_ship_detail&assetp_id=#url.assetp_id#','list');";
                    i=i+1;
                }
				if (not listfindnocase(denied_pages,'assetcare.popup_list_vehicle_km_control'))
                {
                    tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('assetcare', 132)#';
                    tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onclick'] = "windowopen('#request.self#?fuseaction=assetcare.popup_add_vehicle_km_control&assetp_id=#url.assetp_id#','small');";
                    i=i+1;
                }
                if (not listfindnocase(denied_pages,'assetcare.popup_add_vehicle_km_control'))
                {
                    tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('assetcare', 134)#';
                    tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onclick'] ="windowopen('#request.self#?fuseaction=assetcare.popup_add_vehicle_km_control&assetp_id=#url.assetp_id#','small')";
                    i=i+1;
                }
            }
            if (not listfindnocase(denied_pages,'assetcare.popup_upd_it_asset'))
            {
                tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('assetcare', 29)#';
                tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onclick'] ="windowopen('#request.self#?fuseaction=assetcare.popup_list_asset_care_nonperiod&asset_id=#url.assetp_id#','list');";
            }

			if (get_assetp.assetp_reserve and not listfindnocase(denied_pages,'assetcare.popup_asset_reserve_history'))
            {				                    
                    tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('main', 1160)#';
                    tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onclick'] ="windowopen('#request.self#?fuseaction=assetcare.popup_asset_reserve_history&asset_id=#url.assetp_id#','list');";
                    i=i+1;              
                
            }
			if (not listfindnocase(denied_pages,'assetcare.popup_list_asset_care_nonperiod'))
            {
                    tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('assetcare', 29)#';
                    tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onclick'] ="windowopen('#request.self#?fuseaction=assetcare.popup_list_asset_care_nonperiod&asset_id=#url.assetp_id#','list');";
                    i=i+1;
            }
			if (not listfindnocase(denied_pages,'assetcare.popup_list_asset_cares_report'))
            {                
                    tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('assetcare', 34)#';
                    tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['href'] ="#request.self#?fuseaction=assetcare.list_asset_care&event=add&asset_id=#url.assetp_id#";
					tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['target'] = '_blank';
                    i=i+1;
            }          
          
         
        }
                    
        tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);

    }
    WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
    WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd';
    WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'ASSET_P';
    WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'ASSETP_ID';
    WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-form_ul_assetp' , 'item-form_ul_sup_comp_name' , 'item-form_ul_sup_partner_name' , 'item-form_ul_assetp_catid', 'item-form_ul_department','item-form_ul_start_date']";
</cfscript>