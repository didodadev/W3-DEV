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
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'salesplan.list_plan';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/salesplan/display/dsp_sales_plan.cfm';
	
		if(isdefined("attributes.sz_id"))
		{
			WOStruct['#attributes.fuseaction#']['upd'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'salesplan.popup_add_sales_zones_team';
			WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'V16/salesplan/form/detail_sales_zone.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'V16/salesplan/query/upd_sales_zone.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.sz_id#';
			WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'salesplan.list_plan&event=upd&sz_id=';
		}
		
		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'salesplan.form_add_sales_zone';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = '/V16/salesplan/form/add_sales_zone.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = '/V16/salesplan/query/add_sales_zone.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'salesplan.list_plan&event=upd&sz_id=';
		
		WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
		WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'SALES_ZONES';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'SZ_ID';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-sz_name','item-responsible_branch_id','item-responsible_position_code']";
	
	}
	else
	{
		fuseactController = caller.attributes.fuseaction;
		// Tab Menus //
		
		tabMenuStruct = StructNew();
		tabMenuStruct['#fuseactController#'] = structNew();
		tabMenuStruct['#fuseactController#']['tabMenus'] = structNew();
		
		getLang = caller.getLang;
	
		if(caller.attributes.event is 'add')
		{			
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=salesplan.list_plan";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction();";
		}
		else if(caller.attributes.event is 'upd')
		{	
			denied_pages = caller.denied_pages;
			get_sales_zones_team = caller.get_sales_zones_team;
			get_sales_sub_zone = caller.get_sales_sub_zone;
			get_sales_zone = caller.get_sales_zone;
		
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('main',170)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=salesplan.list_plan&event=add";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=salesplan.list_plan";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction();";

			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['text'] = '#getLang('main',62)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_print_files&action_id=#attributes.sz_id#&print_type=340','page');";

			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['bell']['text'] = '#getlang('main',345)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['bell']['onclick'] ="window.open('#request.self#?fuseaction=objects.workflowpages&tab=3&action=#attributes.fuseaction#&action_name=offer_id&action_id=#attributes.sz_id#&wrkflow=1','Workflow')";
			
			i = 0;
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('salesplan',22)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=salesplan.popup_check_sales_quote_team_based&team_id=#sz_id#-#get_sales_zone.responsible_branch_id#&is_submit=1','wide');";
			i = i + 1;
			
			
			if(!listfindnocase(denied_pages,'salesplan.popup_add_sales_zones_team')){
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('salesplan',18)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=salesplan.list_sales_team&event=add&sz_id=#sz_id#&branch_id=#get_sales_zone.responsible_branch_id#','wide');";
				i = i + 1;
			}
			
			if(!listfindnocase(denied_pages,'salesplan.popup_list_sales_company')){
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('main',173)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=salesplan.popup_list_sales_company&sz_id=#sz_id#','project');";
				i = i + 1;
			}
			if(get_sales_zones_team.recordcount){
				if(!listfindnocase(denied_pages,'salesplan.popup_check_sales_quote_customer_based')){
					tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('salesplan',25)#';
					tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=salesplan.popup_check_sales_quote_customer_based&sales_zone_id=#sz_id#&branch_id=#get_sales_zone.responsible_branch_id#','wide');";
					i = i + 1;
				}
				if(!listfindnocase(denied_pages,'salesplan.popup_check_sales_quote_employee_based')){
					tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('salesplan',20)#';
					tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=salesplan.popup_check_sales_quote_employee_based&sales_zone_id=#sz_id#&branch_id=#get_sales_zone.responsible_branch_id#','wide');";
					i = i + 1;
				}
				if(!listfindnocase(denied_pages,'salesplan.popup_check_sales_quote_ims_based')){
					tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('salesplan',21)#';
					tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=salesplan.popup_check_sales_quote_ims_based&sales_zone_id=#sz_id#&branch_id=#get_sales_zone.responsible_branch_id#','wide');";
					i = i + 1;
				}
				
			}
			
			if(GET_SALES_SUB_ZONE.recordcount and !listfindnocase(denied_pages,'salesplan.popup_check_sales_quote_sub_zone_based')){
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('salesplan',23)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=salesplan.popup_check_sales_quote_sub_zone_based&sales_zone_id=#sz_id#&branch_id=#get_sales_zone.responsible_branch_id#&sz_hierarchy=#get_sales_zone.sz_hierarchy#','wide');";
				i = i + 1;
			}
			
		}
		
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
		
	}
</cfscript>