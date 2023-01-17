<cfscript>
	if(attributes.tabMenuController eq 0)
	{
		WOStruct = StructNew();
		
		WOStruct['#attributes.fuseaction#'] = structNew();	
		
		WOStruct['#attributes.fuseaction#']['default'] = 'list';
		
		WOStruct['#attributes.fuseaction#']['list'] = structNew();
		WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'finance.list_payment_actions_order';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/finance/display/list_payment_actions.cfm';


		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'finance.add_payment_actions';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = '/V16/finance/form/add_payment_actions.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = '/V16/finance/query/add_payment_actions.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'finance.list_payment_actions_order&event=upd&closed_id=';
		WOStruct['#attributes.fuseaction#']['add']['formName'] = 'add_payment_actions';


		if(isdefined("attributes.closed_id"))
		{
			WOStruct['#attributes.fuseaction#']['upd'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'finance.upd_payment_actions';
			WOStruct['#attributes.fuseaction#']['upd']['filePath'] = '/V16/finance/form/upd_payment_actions.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = '/V16/finance/query/upd_payment_actions.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'finance.list_payment_actions_order&act_type=#attributes.act_type#&event=upd&closed_id=';
			WOStruct['#attributes.fuseaction#']['upd']['js'] = "javascript:gizle_goster_ikili('payment_actions','payment_actions_bask')";
			WOStruct['#attributes.fuseaction#']['upd']['Identity'] = "#attributes.closed_id#";

			WOStruct['#attributes.fuseaction#']['det'] = structNew();
			WOStruct['#attributes.fuseaction#']['det']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['det']['fuseaction'] = 'finance.det_payment_actions';
			WOStruct['#attributes.fuseaction#']['det']['filePath'] = '/V16/finance/form/det_payment_actions.cfm';
			WOStruct['#attributes.fuseaction#']['det']['Identity'] = "#attributes.closed_id#";

			
			WOStruct['#attributes.fuseaction#']['del'] = structNew();
			WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
			WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'finance.emptypopup_del_payment_actions&closed_id=#attributes.closed_id#&act_type=#attributes.act_type#';
			WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16/finance/query/del_payment_actions.cfm';
			WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/finance/query/del_payment_actions.cfm';
		
		}
	}
	else{
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
				get_closed_ = caller.get_closed_;
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd'] = structNew();
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'] = structNew();
				i = 0;
				if (not len(GET_INVOICE_CLOSE.EMPLOYEE_ID))
				{
					tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#getlang('main',163)#';
					if (len(get_invoice_close.company_id))
						tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#get_invoice_close.company_id#','medium')";
					else
						tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#get_invoice_close.consumer_id#','medium')";
				}
				else {
					tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#getlang('main',2378)#';
					tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#get_invoice_close.employee_id#','medium')";
					
				}
				i = i + 1;

				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#getlang('main',61)#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['customTag'] ="<cf_wrk_history act_type='2' act_id='#attributes.closed_id#' action_type='#attributes.act_type#' boxwidth='600' boxheight='400'>";
				i = i + 1;

				if(len(GET_INVOICE_CLOSE.acc_type_id))
					new_employee_id = "#GET_INVOICE_CLOSE.employee_id#_#GET_INVOICE_CLOSE.acc_type_id#";
				else	
					new_employee_id = GET_INVOICE_CLOSE.employee_id;
				adres_ = "cash.form_add_cash_payment&event=popupAdd&order_row_id='+document.getElementById('order_row_id_info').value+'&order_id=#GET_INVOICE_CLOSE.CLOSED_ID#&ORDER_AMOUNT='+filterNum(document.getElementById('hidden_total_difference_amount').value)+'&company_id=#GET_INVOICE_CLOSE.COMPANY_ID#&consumer_id=#GET_INVOICE_CLOSE.CONSUMER_ID#&employee_id=#new_employee_id#&money_type=#GET_INVOICE_CLOSE.OTHER_MONEY#";
				if( Len(GET_INVOICE_CLOSE.project_id)) adres_ = "#adres_#&project_id=#GET_INVOICE_CLOSE.project_id#"; 
				if(get_closed_.action_id eq 0) adres_ = "#adres_#&correspondence_info=1";
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#getlang('finance',76)#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=#adres_#','medium')";
				i = i + 1;

				adres_ ="bank.form_add_gidenh&order_row_id='+document.getElementById('order_row_id_info').value+'&order_id=#GET_INVOICE_CLOSE.CLOSED_ID#&paymethod_id=#GET_INVOICE_CLOSE.PAYMETHOD_ID#&to_consumer_id=#GET_INVOICE_CLOSE.CONSUMER_ID#&to_employee_id=#new_employee_id#&to_company_id=#GET_INVOICE_CLOSE.COMPANY_ID#&ORDER_AMOUNT='+filterNum(document.getElementById('hidden_total_difference_amount').value)+'&money_type=#GET_INVOICE_CLOSE.OTHER_MONEY#";
				if( Len(GET_INVOICE_CLOSE.project_id)) adres_ = "#adres_#&project_id=#GET_INVOICE_CLOSE.project_id#"; 
				if(get_closed_.action_id eq 0) adres_ = "#adres_#&correspondence_info=1";
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#getlang('main',423)#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=#adres_#','project')";
				i = i + 1;

				adres_ = "cheque.form_add_payroll_endorsement&order_row_id='+document.getElementById('order_row_id_info').value+'&order_id=#GET_INVOICE_CLOSE.CLOSED_ID#&paymethod_id=#GET_INVOICE_CLOSE.PAYMETHOD_ID#&to_consumer_id=#GET_INVOICE_CLOSE.CONSUMER_ID#&to_employee_id=#new_employee_id#&to_company_id=#GET_INVOICE_CLOSE.COMPANY_ID#&ORDER_AMOUNT='+filterNum(document.getElementById('hidden_total_difference_amount').value)+'&money_type=#GET_INVOICE_CLOSE.OTHER_MONEY#";
				if( Len(GET_INVOICE_CLOSE.project_id)) adres_ = "#adres_#&project_id=#GET_INVOICE_CLOSE.project_id#"; 
				if(get_closed_.action_id eq 0) adres_ = "#adres_#&correspondence_info=1";
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#getlang('main',2292)#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=#adres_#','wide')";
													
				if(not len(GET_INVOICE_CLOSE.EMPLOYEE_ID)){
					i = i + 1;
					adres_ = "bank.list_assign_order&event=add_assign&order_row_id='+document.getElementById('order_row_id_info').value+'&order_id=#GET_INVOICE_CLOSE.CLOSED_ID#&paymethod_id=#GET_INVOICE_CLOSE.PAYMETHOD_ID#&consumer_id=#GET_INVOICE_CLOSE.CONSUMER_ID#&employee_id=#GET_INVOICE_CLOSE.EMPLOYEE_ID#&company_id=#GET_INVOICE_CLOSE.COMPANY_ID#&ORDER_AMOUNT='+filterNum(document.getElementById('hidden_total_difference_amount').value)+'&money_type=#GET_INVOICE_CLOSE.OTHER_MONEY#";
					if( Len(GET_INVOICE_CLOSE.project_id)) adres_ = "#adres_#&project_id=#GET_INVOICE_CLOSE.project_id#"; 
					if(get_closed_.action_id eq 0) adres_ = "#adres_#&correspondence_info=1";
					tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#getlang('finance',77)#';
					tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=#adres_#','medium')";
				}
					
				if(not listfindnocase(caller.denied_pages,'finance.add_payment_actions')){
					tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#getlang('main',170)#';
					tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = '#request.self#?fuseaction=#attributes.fuseaction#&act_type=#attributes.act_type#&event=add';
				}
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['text'] =  '#getlang('main',62)#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['onClick'] ="window.open('#request.self#?fuseaction=objects.popup_print_files&print_type=145&action_id=#GET_INVOICE_CLOSE.CLOSED_ID#&action_type=#attributes.act_type#','woc');";
				
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['list-ul']['href'] ="#request.self#?fuseaction=#attributes.fuseaction#&act_type=#attributes.act_type#";
				
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['check']['text'] = "#getLang('main',170)#";
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";
				
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['bell']['text'] = '#getlang('main',345)#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['bell']['onclick'] = "window.open('#request.self#?fuseaction=objects.workflowpages&tab=3&action=#attributes.fuseaction#&action_name=closed_id&action_id=#attributes.closed_id#&wrkflow=1','Workflow')";
		
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['detail']['text'] = '#getlang('main',359)#';
				if(len(GET_INVOICE_CLOSE.company_id))
					tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['detail']['href'] = '#request.self#?fuseaction=#attributes.fuseaction#&event=det&closed_id=#attributes.closed_id#&act_type=#attributes.act_type#&company_id=#GET_INVOICE_CLOSE.COMPANY_ID#';
				else
					tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['detail']['href'] = '#request.self#?fuseaction=#attributes.fuseaction#&event=det&closed_id=#attributes.closed_id#&act_type=#attributes.act_type#&emp_id=#GET_INVOICE_CLOSE.EMPLOYEE_ID#';

			}	

			if(isdefined("attributes.event") and attributes.event is 'det')
			{
				get_invoice_close = caller.get_invoice_close;
				get_closed_ = caller.get_closed_;
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det'] = structNew();
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'] = structNew();

				i = 0;
				if (not len(GET_INVOICE_CLOSE.EMPLOYEE_ID))
				{
					tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][i]['text'] = '#getlang('main',163)#';
					if (len(get_invoice_close.company_id))
						tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#get_invoice_close.company_id#','medium')";
					else
						tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#get_invoice_close.consumer_id#','medium')";
				   i = i + 1;
				}
				else {
					tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][i]['text'] = '#getlang('main',2378)#';
					tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#get_invoice_close.employee_id#','medium')";
					i = i + 1;
				}

				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][i]['text'] = '#getlang('main',61)#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][i]['customTag'] ="<cf_wrk_history act_type='2' act_id='#attributes.closed_id#' action_type='#attributes.act_type#' boxwidth='600' boxheight='400'>";
								
				if(not listfindnocase(caller.denied_pages,'finance.add_payment_actions')){
					tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['add']['text'] = '#getlang('main',170)#';
					tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['add']['href'] = '#request.self#?fuseaction=#attributes.fuseaction#&act_type=#attributes.act_type#&event=add';
				}
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['list-ul']['text'] =  '#getLang('main',97)#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['list-ul']['href'] ="#request.self#?fuseaction=#attributes.fuseaction#&act_type=#attributes.act_type#";

				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['print']['text'] =  '#getlang('main',62)#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['print']['onClick'] ="window.open('#request.self#?fuseaction=objects.popup_print_files&print_type=145&action_id=#GET_INVOICE_CLOSE.CLOSED_ID#&action_type=#attributes.act_type#','woc');";
				
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['bell']['text'] = '#getlang('main',345)#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['bell']['onclick'] = "window.open('#request.self#?fuseaction=objects.workflowpages&tab=3&action=#attributes.fuseaction#&action_name=closed_id&action_id=#attributes.closed_id#&wrkflow=1','Workflow')";

				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['update']['text'] = '#getlang('main',52)#';
				if(len(GET_INVOICE_CLOSE.company_id))
					tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['update']['href'] = '#request.self#?fuseaction=#attributes.fuseaction#&event=upd&closed_id=#attributes.closed_id#&act_type=#attributes.act_type#&company_id=#GET_INVOICE_CLOSE.company_id#';
				else 
					tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['update']['href'] = '#request.self#?fuseaction=#attributes.fuseaction#&event=upd&closed_id=#attributes.closed_id#&act_type=#attributes.act_type#&emp_id=#GET_INVOICE_CLOSE.employee_id#';

			}	
			tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	
</cfscript>
