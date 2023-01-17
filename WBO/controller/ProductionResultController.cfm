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
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'prod.list_results';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/production_plan/display/list_prod_order_results.cfm';
		
		if(attributes.event is 'add')
		{
			WOStruct['#attributes.fuseaction#']['add'] = structNew();
			WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'prod.upd_prod_order_result';
			WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/production_plan/form/add_prod_order_result.cfm';
			WOStruct['#attributes.fuseaction#']['add']['queryPath'] = '/V16/production_plan/query/add_prod_order_result.cfm';
			WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'prod.list_results&event=upd&p_order_id=#attributes.p_order_id#&pr_order_id=';
			WOStruct['#attributes.fuseaction#']['add']['js'] = "javascript:gizle_goster_ikili('order_result','order_result_bask');";
		}
		
		if(isdefined("attributes.p_order_id") and isdefined("attributes.pr_order_id"))
		{
			
			WOStruct['#attributes.fuseaction#']['upd'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'prod.upd_prod_order_result';
			WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'V16/production_plan/form/upd_prod_order_result.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = '/V16/production_plan/query/upd_prod_order_result.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.pr_order_id#';
			WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'prod.list_results&event=upd&p_order_id=#attributes.p_order_id#&pr_order_id=';
			WOStruct['#attributes.fuseaction#']['upd']['js'] = "javascript:gizle_goster_ikili('order_result','order_result_bask');";
				
		}
		
		if(IsDefined("attributes.event") && (attributes.event is 'upd' || attributes.event is 'del'))
		{
			WOStruct['#attributes.fuseaction#']['del'] = structNew();
			WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
			WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=prod.emptypopup_upd_prod_order_result_act&event=del&is_demontaj=##caller.get_detail.is_demontaj##&process_stage=##caller.get_detail.prod_ord_result_stage##&del_pr_order_id=#attributes.pr_order_id#&production_order_no=##caller.get_detail.production_order_no##&old_process_type=##caller.get_detail.process_id##&process_cat=##caller.get_detail.process_id##&finish_date=##caller.get_detail.finish_date##&pr_order_id=#attributes.pr_order_id#&p_order_id=#attributes.p_order_id#';
			WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16/production_plan/query/upd_prod_order_result.cfm';
			WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/production_plan/query/upd_prod_order_result.cfm';
			WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'prod.list_results';
		}
	}
	else
	{
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
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=prod.list_results";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";
		}
		
		if(caller.attributes.event is 'upd')
		{
			Product_cat_List = caller.Product_cat_List;
			get_detail.finish_date =caller.get_detail.finish_date;
			get_detail.p_order_id = caller.get_detail.p_order_id;
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=prod.list_results";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['text'] = '#getLang('main',62)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['onClick'] = "window.open('#request.self#?fuseaction=objects.popup_print_files&action_id=#attributes.pr_order_id#&iid=#attributes.p_order_id#&action=#attributes.fuseaction#','woc')";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['icon-fa fa-table']['text'] = '#getLang('main',1040)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['icon-fa fa-table']['onClick'] = "windowopen('#request.self#?fuseaction=account.popup_list_card_rows&action_id=#attributes.pr_order_id#&process_cat='+form_basket.old_process_type.value,'page','upd_prod_order_result');";
			
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'] = structNew();
			i=0;
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getlang('','Paketleme',63751)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['href'] = "#request.self#?fuseaction=stock.packeting&event=add&pr_order_id=#url.pr_order_id#";
			i=i + 1;

			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('prod',672)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onClick'] = "openBoxDraggable('#request.self#?fuseaction=prod.popup_add_prod_pause&Product_cat_List=#Product_cat_List#&action_id=#attributes.pr_order_id#&draggable=1&p_order_id=#attributes.p_order_id#&action_date=#get_detail.finish_date#');";
			i=i+1;

			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('main',2252)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['href'] = "#request.self#?fuseaction=prod.order&event=upd&upd=#get_detail.p_order_id#";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['target'] = "blank_";
			i=i+1;

			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('prod',637)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onClick'] ="openBoxDraggable('#request.self#?fuseaction=prod.popup_add_prod_result_asset&draggable=1&id=#attributes.pr_order_id#');";
			i=i+1;			
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('myhome',67)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['href'] = "#request.self#?fuseaction=myhome.mytime_management&event=add&p_order_result_id=#attributes.pr_order_id#&is_p_order_result=1";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['target'] = "blank_";
			i=i+1;

			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['bell']['text'] = '#getLang('main',345)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['bell']['onClick'] = "window.open('#request.self#?fuseaction=objects.workflowpages&tab=3&action=#attributes.fuseaction#&action_name=p_order_id&action_id=#attributes.p_order_id#&action_name2=pr_order_id&action_id2=#attributes.pr_order_id#&relation_papers_type=P_ORDER_ID','Workflow')";			
		}
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	
	}
	
	WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
	WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'PRODUCTION_ORDER_RESULTS';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'PR_ORDER_ID';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-process_cat','item-production_order_no','item-start_date','item-finish_date','item-station_name','item-','item-']";
</cfscript>
