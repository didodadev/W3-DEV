<cfscript>
	if(attributes.tabMenuController eq 0)
	{
		WOStruct = StructNew();
		
		WOStruct['#attributes.fuseaction#'] = structNew();	
		
		WOStruct['#attributes.fuseaction#']['default'] = 'list';
		
		WOStruct['#attributes.fuseaction#']['list'] = structNew();
		WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'correspondence.list_payment_actions_demand&act_type=2&correspondence_info=1';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/finance/display/list_payment_actions.cfm';

		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'correspondence.add_payment_actions';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = '/V16/finance/form/add_payment_actions.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = '/V16/finance/query/add_payment_actions.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'correspondence.list_payment_actions_demand&event=upd&closed_id=';
		WOStruct['#attributes.fuseaction#']['add']['formName'] = 'add_payment_actions';

		if(isdefined("attributes.closed_id"))
		{
			
			WOStruct['#attributes.fuseaction#']['upd'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'correspondence.upd_payment_actions';
			WOStruct['#attributes.fuseaction#']['upd']['filePath'] = '/V16/finance/form/upd_payment_actions.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = '/V16/finance/query/upd_payment_actions.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'correspondence.list_payment_actions_demand&event=upd&act_type=#attributes.act_type#&closed_id=';
			WOStruct['#attributes.fuseaction#']['upd']['js'] = "javascript:gizle_goster_ikili('payment_actions','payment_actions_bask')";
			WOStruct['#attributes.fuseaction#']['upd']['Identity'] = "#attributes.closed_id#";

			WOStruct['#attributes.fuseaction#']['det'] = structNew();
			WOStruct['#attributes.fuseaction#']['det']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['det']['fuseaction'] = 'correspondence.det_payment_actions';
			WOStruct['#attributes.fuseaction#']['det']['filePath'] = '/V16/finance/form/det_payment_actions.cfm';
			WOStruct['#attributes.fuseaction#']['det']['nextEvent'] = 'correspondence.list_payment_actions_demand&event=upd&closed_id=';
			WOStruct['#attributes.fuseaction#']['det']['js'] = "javascript:gizle_goster_ikili('payment_actions','payment_actions_bask')";
			WOStruct['#attributes.fuseaction#']['det']['Identity'] = "#attributes.closed_id#";

			WOStruct['#attributes.fuseaction#']['del'] = structNew();
			WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
			WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'correspondence.emptypopup_del_payment_actions&closed_id=#attributes.closed_id#&act_type=#attributes.act_type#';
			WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16/finance/query/del_payment_actions.cfm';
			WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/finance/query/del_payment_actions.cfm';
		}
	}
	else{
			getLang = caller.getLang;
			tabMenuStruct = StructNew();
			tabMenuStruct['#attributes.fuseaction#'] = structNew();
			tabMenuStruct['#attributes.fuseaction#']['tabMenus'] = structNew();

			if(isdefined("attributes.event") and attributes.event is 'upd')
			{
				get_invoice_close = caller.get_invoice_close;
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd'] = structNew();			
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'] = structNew();
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons'] = structNew();

				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['text'] = '#getlang('main',163)#';
				if (len(get_invoice_close.company_id))
					tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#get_invoice_close.company_id#','medium')";
				else
					tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#get_invoice_close.consumer_id#','medium')";
								
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['text'] = '#getlang('main',61)#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['customTag'] = "<cf_wrk_history act_type='2' act_id='#attributes.closed_id#' action_type='#attributes.act_type#' boxwidth='600' boxheight='500'>";
					if(not listfindnocase(caller.denied_pages,'finance.add_payment_actions')){
					tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#getlang('main',170)#';
				
					tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = '#request.self#?fuseaction=#caller.fusebox.circuit#.list_payment_actions_demand&event=add&act_type=2&correspondence_info=1';
					tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
				}
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['text'] =  '#getlang('main',62)#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['onClick'] ="windowopen('#request.self#?fuseaction=objects.popup_print_files&print_type=145&action_id=#GET_INVOICE_CLOSE.CLOSED_ID#&action_type=#attributes.act_type#','page');";

				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['bell']['text'] = '#getlang('main',345)#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['bell']['href'] = "#request.self#?fuseaction=objects.workflowpages&tab=3&action=#attributes.fuseaction#&action_name=closed_id&action_id=#attributes.closed_id#&is_payment=1";
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['bell']['target'] = "_blank";

				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['detail']['text'] = '#getlang('main',359)#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['detail']['href'] = '#request.self#?fuseaction=#caller.fusebox.circuit#.list_payment_actions_demand&event=det&closed_id=#attributes.closed_id#&act_type=2&mail_control=1';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['detail']['target'] = "_blank";
			}
			
			if(isdefined("attributes.event") and attributes.event is 'det')
			{
				get_invoice_close = caller.get_invoice_close;
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det'] = structNew();
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'] = structNew();


				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][0]['text'] = '#getlang('main',163)#';
				if (len(get_invoice_close.company_id))
					tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][0]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#get_invoice_close.company_id#','medium')";
				else
					tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][0]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#get_invoice_close.consumer_id#','medium')";
								
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][1]['text'] = '#getlang('main',61)#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][1]['customTag'] = "<cf_wrk_history act_type='2' act_id='#attributes.closed_id#' action_type='#attributes.act_type#' boxwidth='600' boxheight='500'>";
					if(not listfindnocase(caller.denied_pages,'finance.add_payment_actions')){
					tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['add']['text'] = '#getlang('main',170)#';
				
					tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['add']['href'] = '#request.self#?fuseaction=#attributes.fuseaction#&event=add&act_type=2&correspondence_info=1';
					tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['add']['target'] = "_blank";
				}
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['print']['text'] =  '#getlang('main',62)#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['print']['onClick'] ="windowopen('#request.self#?fuseaction=objects.popup_print_files&print_type=145&action_id=#GET_INVOICE_CLOSE.CLOSED_ID#&action_type=#attributes.act_type#','page');";

				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['bell']['text'] = '#getlang('main',345)#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['bell']['href'] = "#request.self#?fuseaction=objects.workflowpages&tab=3&action=#attributes.fuseaction#&action_name=closed_id&action_id=#attributes.closed_id#&is_payment=1";
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['bell']['target'] = "_blank";

				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['update']['text'] = '#getlang('main',52)#';
			    tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['update']['href'] = '#request.self#?fuseaction=#caller.fusebox.circuit#.list_payment_actions_demand&event=upd&closed_id=#attributes.closed_id#&act_type=2&mail_control=1';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['update']['target'] = "_blank";		 					
			}
				
       tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);

	}
	
</cfscript>
