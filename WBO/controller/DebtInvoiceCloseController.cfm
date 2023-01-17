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
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'finance.list_payment_actions';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/finance/display/list_payment_actions.cfm';
	
		if(isdefined("attributes.closed_id"))
		{
			WOStruct['#attributes.fuseaction#']['upd'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'finance.upd_payment_actions';
			WOStruct['#attributes.fuseaction#']['upd']['filePath'] = '/V16/finance/form/upd_payment_actions.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = '/V16/finance/query/upd_payment_actions.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'finance.list_payment_actions&event=upd&act_type=#attributes.act_type#&closed_id=';
			WOStruct['#attributes.fuseaction#']['upd']['js'] = "javascript:gizle_goster_ikili('payment_actions','payment_actions_bask')";
			WOStruct['#attributes.fuseaction#']['upd']['Identity'] = "#attributes.closed_id#";

			WOStruct['#attributes.fuseaction#']['det'] = structNew();
			WOStruct['#attributes.fuseaction#']['det']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['det']['fuseaction'] = 'finance.det_payment_actions';
			WOStruct['#attributes.fuseaction#']['det']['filePath'] = '/V16/finance/form/det_payment_actions.cfm';
			WOStruct['#attributes.fuseaction#']['det']['Identity'] = "#attributes.closed_id#";

			WOStruct['#attributes.fuseaction#']['del'] = structNew();
			WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
			WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#listgetat(attributes.fuseaction,1,'.')#.emptypopup_del_payment_actions&closed_id=#attributes.closed_id#&act_type=#attributes.act_type#';
			WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16/finance/query/del_payment_actions.cfm';
			WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/finance/query/del_payment_actions.cfm';
		}

		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'finance.add_payment_actions';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = '/V16/finance/form/add_payment_actions.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = '/V16/finance/query/add_payment_actions.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'finance.list_payment_actions&event=upd&closed_id=';
		WOStruct['#attributes.fuseaction#']['add']['formName'] = 'add_payment_actions';
		WOStruct['#attributes.fuseaction#']['add']['js'] = "javascript:gizle_goster_ikili('add_payment_actions')";

	}
	else
	{
		getLang = caller.getLang;
		tabMenuStruct = StructNew();
		tabMenuStruct['#attributes.fuseaction#'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus'] = structNew();

		if(isdefined("attributes.event") and attributes.event is 'add')
			{
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['icons']['check']['text'] = "#getLang('main',170)#";
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['icons']['list-ul']['text'] = '#getLang('main',97)#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['icons']['list-ul']['href'] ="#request.self#?fuseaction=#attributes.fuseaction#&act_type=#attributes.act_type#";
				
			}	
		
		if(isdefined("attributes.event") and attributes.event is 'upd')
		{
			get_invoice_close = caller.get_invoice_close;
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd'] = structNew();
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'] = structNew();
			
			if (not len(GET_INVOICE_CLOSE.EMPLOYEE_ID)){				
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['text'] = '#getlang('main',163)#';
				if (len(get_invoice_close.company_id))
					tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#get_invoice_close.company_id#','medium')";
				else
					tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#get_invoice_close.consumer_id#','medium')";
			}
			else {
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['text'] = '#getlang('main',2378)#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#get_invoice_close.employee_id#','medium')";				
			}

			if(not listfindnocase(caller.denied_pages,'finance.add_payment_actions')){
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#getlang('main',170)#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = '#request.self#?fuseaction=#attributes.fuseaction#&act_type=#attributes.act_type#&event=add';
			}
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['text'] =  '#getlang('main',62)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['onClick'] ="window.open('#request.self#?fuseaction=objects.popup_print_files&print_type=145&action_id=#get_invoice_close.CLOSED_ID#&action_type=#attributes.act_type#','woc');";

			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['list-ul']['href'] ="#request.self#?fuseaction=#attributes.fuseaction#&act_type=#attributes.act_type#";

			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['bell']['text'] = '#getlang('main',345)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['bell']['onclick'] =  "window.open('#request.self#?fuseaction=objects.workflowpages&tab=3&action=#attributes.fuseaction#&action_name=closed_id&action_id=#attributes.closed_id#&wrkflow=1','Workflow')";

			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['check']['text'] = "#getLang('main',170)#";
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";
			
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['detail']['text'] = '#getlang('main',359)#';
			if(len(GET_INVOICE_CLOSE.company_id))
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['detail']['href'] =  "#request.self#?fuseaction=#attributes.fuseaction#&event=det&closed_id=#attributes.closed_id#&company_id=#get_invoice_close.company_id#&act_type=#attributes.act_type#";
			else
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['detail']['href'] =  "#request.self#?fuseaction=#attributes.fuseaction#&event=det&closed_id=#attributes.closed_id#&emp_id=#get_invoice_close.employee_id#&act_type=#attributes.act_type#";

		}
		if(isdefined("attributes.event") and attributes.event is 'det')
		{
			get_invoice_close = caller.get_invoice_close;
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det'] = structNew();
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'] = structNew();

			if (not len(GET_INVOICE_CLOSE.EMPLOYEE_ID)){
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][0]['text'] = '#getlang('main',163)#';
			if ( isdefined("get_invoice_close.company_id") and len(get_invoice_close.company_id))
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][0]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#get_invoice_close.company_id#','medium')";
			else
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][0]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#get_invoice_close.consumer_id#','medium')";
			}
			else {
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][0]['text'] = '#getlang('main',2378)#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][0]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#get_invoice_close.employee_id#','medium')";				
			}
				
			if(not listfindnocase(caller.denied_pages,'finance.add_payment_actions')){
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['add']['text'] = '#getlang('main',170)#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['add']['href'] = '#request.self#?fuseaction=#attributes.fuseaction#&act_type=#attributes.act_type#&event=add';
			}
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['print']['text'] =  '#getlang('main',62)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['print']['onClick'] ="window.open('#request.self#?fuseaction=objects.popup_print_files&print_type=145&action_id=#GET_INVOICE_CLOSE.CLOSED_ID#&action_type=#attributes.act_type#','woc');";
			
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['list-ul']['href'] ="#request.self#?fuseaction=#attributes.fuseaction#&act_type=#attributes.act_type#";

			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['bell']['text'] = '#getlang('main',345)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['bell']['onclick'] =" window.open('#request.self#?fuseaction=objects.workflowpages&tab=3&action=#attributes.fuseaction#&action_name=closed_id&action_id=#attributes.closed_id#&wrkflow=1','Workflow')";

			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['update']['text'] = '#getlang('main',52)#';
			if(len(GET_INVOICE_CLOSE.company_id))
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['update']['href'] = '#request.self#?fuseaction=#attributes.fuseaction#&event=upd&closed_id=#attributes.closed_id#&company_id=#get_invoice_close.company_id#&act_type=#attributes.act_type#';
			else 
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['update']['href'] = '#request.self#?fuseaction=#attributes.fuseaction#&event=upd&closed_id=#attributes.closed_id#&emp_id=#get_invoice_close.employee_id#&act_type=#attributes.act_type#';
		}
					
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
</cfscript>
