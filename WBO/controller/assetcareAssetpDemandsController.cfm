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
        WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'assetcare.list_assetp_demands';
        WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/assetcare/display/list_assetp_demands.cfm';
       
        
        WOStruct['#attributes.fuseaction#']['add'] = structNew();
        WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'assetcare.list_assetp_demands&event=add';
        WOStruct['#attributes.fuseaction#']['add']['filePath'] = '/V16/correspondence/form/add_assetp_demand.cfm';
        WOStruct['#attributes.fuseaction#']['add']['queryPath'] = '/V16/correspondence/query/add_assetp_demand.cfm';
        WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'assetcare.list_assetp_demands';

       
      if(isdefined("attributes.demand_id")){
           
        WOStruct['#attributes.fuseaction#']['upd'] = structNew();
        WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'assetcare.list_assetp_demands&event=upd';
        WOStruct['#attributes.fuseaction#']['upd']['filepath'] = '/V16/myhome/form/form_upd_assetp_demand.cfm';
        WOStruct['#attributes.fuseaction#']['upd']['querypath'] = '/V16/myhome/query/upd_assetp_demand.cfm';
        WOStruct['#attributes.fuseaction#']['upd']['nextevent']  = 'assetcare.list_assetp_demands&event=upd&demand_id=';
        WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.demand_id#';

        WOStruct['#attributes.fuseaction#']['del'] = structNew();
        WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
        WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'assetcare.emptypopup_del_assetp_demand';
        WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16/assetcare/query/del_assetp_demand.cfm';
        WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/assetcare/query/del_assetp_demand.cfm';
        WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'assetcare.list_assetp_demands';
        WOStruct['#attributes.fuseaction#']['del']['Identity'] = '#attributes.demand_id#';
        }
    }
    else
    {
        fuseactController = caller.attributes.fuseaction;
        getLang = caller.getLang;

        tabMenuStruct = StructNew();
        tabMenuStruct['#fuseactController#'] = structNew();
        tabMenuStruct['#fuseactController#']['tabMenus'] = structNew();
  if (caller.attributes.event is 'upd') {
    tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['target'] = "_self";
    tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=assetcare.list_assetp_demands";
    tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';

        tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['bell']['text'] = '#getLang('','Uyarılar','57757')#';
        tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['bell']['onclick'] =  "window.open('#request.self#?fuseaction=objects.workflowpages&tab=3&action=#attributes.fuseaction#&action_name=demand_id&action_id=#attributes.demand_id#','Workflow')";

        tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['text'] = '#getLang('','Yazdır','57474')#';
        tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['onClick'] = "window.open('#request.self#?fuseaction=objects.popup_print_files&print_type=186&action_type=#attributes.demand_id#&action_id=#attributes.demand_id#')";
    
        tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
    }
    }


    WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
    WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd,del';
    WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'ASSET_P_DEMAND';
    WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'DEMAND_ID';
    WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-cat_id', 'item-employee', 'item-usage_purpose_id', 'item-request_date']";

</cfscript>