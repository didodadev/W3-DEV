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
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = '#listgetat(attributes.fuseaction,1,'.')#.list_quality_controls';
		WOStruct['#attributes.fuseaction#']['list']['Xmlfuseaction'] = 'prod.list_quality_controls';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/production_plan/display/list_quality_controls.cfm';
	
		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = '#listgetat(attributes.fuseaction,1,'.')#.popup_add_quality_control_report';
		WOStruct['#attributes.fuseaction#']['add']['Xmlfuseaction'] = 'prod.popup_add_quality_control_report';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/production_plan/form/add_quality_control_report.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'V16/production_plan/query/add_quality_control_report.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = '#listgetat(attributes.fuseaction,1,'.')#.list_quality_controls&event=upd&or_q_id=';
		
		if(isdefined("attributes.or_q_id")){
			WOStruct['#attributes.fuseaction#']['upd'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = '#listgetat(attributes.fuseaction,1,'.')#.popup_upd_quality_control_report_rows';
			WOStruct['#attributes.fuseaction#']['upd']['Xmlfuseaction'] = 'prod.popup_add_quality_control_report';
			WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'V16/production_plan/form/upd_quality_control_report_rows.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'V16/production_plan/query/upd_quality_control_report_row.cfm';
			
			
			WOStruct['#attributes.fuseaction#']['del'] = structNew();
			WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
			WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'stock.emptypopup_upd_quality_control_report_row&is_delete=1&OR_Q_ID=#attributes.OR_Q_ID#';
			WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16/production_plan/form/upd_quality_control_report_rows.cfm';
			WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/production_plan/query/upd_quality_control_report_row.cfm';
			/* WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = '#listgetat(attributes.fuseaction,1,'.')#.list_quality_controls'; */

		}
		
		WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
		WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'BUDGET';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'budget_id';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-process_cat']";
	}
	else
	{
		fuseactController = caller.attributes.fuseaction;
		// Tab Menus //
		tabMenuStruct = StructNew();
	
		tabMenuStruct['#fuseactController#'] = structNew();
		tabMenuStruct['#fuseactController#']['tabMenus'] = structNew();
		
		getLang = caller.getLang;
		
		if(isdefined("attributes.event") and attributes.event is 'add')
		{
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_quality_controls";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";	
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['detail']['text'] = '#getLang('','Ürün Detay','33929')#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['detail']['href'] = "#request.self#?fuseaction=product.list_product&event=det&pid=#attributes.pid#";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['print']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['print']['text'] = '#getLang('main',62)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['print']['href'] = "#request.self#?fuseaction=objects.popup_print_files&action_type=#attributes.process_cat#&action_row_id=#attributes.process_row_id#&print_type=34";
		}
		else if(isdefined("attributes.event") and attributes.event is 'upd'){
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_quality_controls";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";	
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['text'] = '#getLang('main',62)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['href'] = "#request.self#?fuseaction=objects.popup_print_files&action_id=#attributes.OR_Q_ID#&action_type=#attributes.process_cat#&action_row_id=#attributes.process_row_id#&print_type=34";	
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['archive']['text'] = '#getLang('main',1966)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['archive']['customtag'] = "<cf_get_workcube_related_acts period_id='#session.ep.period_id#' company_id='#session.ep.company_id#' asset_cat_id='-24' module_id='13' action_section='OR_Q_ID' action_id='#attributes.OR_Q_ID#'>";	
		
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][0]['text'] = '#getLang('prod',171)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][0]['onclick'] = "openBoxDraggable('#request.self#?fuseaction=stock.popup_form_upd_improper_products&quality_control_id=#attributes.OR_Q_ID#','','ui-draggable-box-medium');";	

		}
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
		
	}
</cfscript>
