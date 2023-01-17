<cfscript>
	// Switch //
	if(attributes.tabMenuController eq 0)
	{	
		WOStruct = StructNew();
		WOStruct['#attributes.fuseaction#'] = structNew();
		WOStruct['#attributes.fuseaction#']['default'] = 'list';
		
		WOStruct['#attributes.fuseaction#']['list'] = structNew();
		WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'campaign.list_organization';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/campaign/display/list_organization.cfm';
		
		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'campaign.form_add_organization';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = '/V16/campaign/form/add_organization.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = '/V16/campaign/query/add_organization.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'campaign.list_organization&event=upd';
			
		if(isdefined("attributes.org_id"))
		{
	  		
			WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	  		WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
	  		WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'campaign.form_upd_organization';
	  		WOStruct['#attributes.fuseaction#']['upd']['filePath'] = '/V16/campaign/form/upd_organization.cfm';
	  		WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = '/V16/campaign/query/upd_organization.cfm';
	  		WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'campaign.list_organization&event=upd';
	  		WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.org_id#'; 
		
			WOStruct['#attributes.fuseaction#']['del'] = structNew();
			WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
			WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=campaign.emptypopup_del_organization&org_id=#attributes.org_id#';
			WOStruct['#attributes.fuseaction#']['del']['filePath'] = '/V16/campaign/query/del_organization.cfm';
			WOStruct['#attributes.fuseaction#']['del']['queryPath'] = '/V16/campaign/query/del_organization.cfm';
			WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'campaign.list_organization';
		}	 
	}
	else
	{
		i = 0;
		fuseactController = caller.attributes.fuseaction;
		getLang = caller.getLang;
		
		tabMenuStruct = StructNew();
		tabMenuStruct['#fuseactController#'] = structNew();
		tabMenuStruct['#fuseactController#']['tabMenus'] = structNew();
		
		if(caller.attributes.event is 'add')
		{			
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=campaign.list_organization";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";
		}
		else if(caller.attributes.event is 'upd')
		{
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('main',170)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=campaign.list_organization&event=add";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=campaign.list_organization";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['text'] = '#getLang('','Yazdır','57474')#';
      		tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['onClick'] = "window.open('#request.self#?fuseaction=objects.popup_print_files&action_id=#attributes.org_id#&action=campaign.list_organization','page');";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['bell']['text'] = '#getlang('main',345)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['bell']['target'] = 'blank_';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['bell']['href']  = "#request.self#?fuseaction=objects.workflowpages&tab=3&action=#attributes.fuseaction#&action_name=org_id&action_id=#attributes.org_id#";

            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('','Katılımcılar','57590')#';
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onClick'] = "openBoxDraggable('#request.self#?fuseaction=campaign.popup_list_organization_attenders&organization_id=#attributes.org_id#','attenders_box')";
            i = i + 1;

			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('','Etkinlik Sonuç Raporu','63733')#';
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onClick'] = "openBoxDraggable('#request.self#?fuseaction=campaign.popup_organization_result_report&organization_id=#attributes.org_id#')";
            i = i + 1;
			
		}
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	
	WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
	WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'CAMPAIGNS';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'CAMP_ID';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-organization_cat_id','item-organization_head','item-emp_par_name','item-start_date','item-start_date','item-start_date','item-finish_date','is_site_display','item-view_to_all','item-is_active']";
</cfscript>