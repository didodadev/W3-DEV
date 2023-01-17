<cfscript>
	if(attributes.tabMenuController eq 0)
	{
		WOStruct = StructNew();
		
		WOStruct['#attributes.fuseaction#'] = structNew();	
		
		WOStruct['#attributes.fuseaction#']['default'] = 'add';
		if(not isdefined('attributes.event'))
			attributes.event = WOStruct['#attributes.fuseaction#']['default'];
	
		
		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'cost.add_income_cost';
		WOStruct['#attributes.fuseaction#']['add']['xmlfuseaction'] = 'cost.add_income_cost';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = '/V16/objects/form/add_income_cost.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'V16/objects/query/add_income_cost.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'cost.add_income_cost';
		/* WOStruct['#attributes.fuseaction#']['add']['js'] = "javascript:gizle_goster_ikili('income_cost','income_cost_bask');";	 */
		
		if(isdefined("attributes.expense_id") and listFind('upd,del,det',attributes.event))
		{
			WOStruct['#attributes.fuseaction#']['upd'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'cost.add_income_cost&event=upd&expense_id';
			WOStruct['#attributes.fuseaction#']['upd']['xmlfuseaction'] = 'cost.add_income_cost';
			WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'V16/objects/form/upd_income_cost.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'V16/objects/query/upd_income_cost.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.expense_id#';
			WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'cost.add_income_cost&event=upd&expense&id=';
			WOStruct['#attributes.fuseaction#']['upd']['js'] = "javascript:gizle_goster_ikili('income_cost','income_cost_bask');";

			WOStruct['#attributes.fuseaction#']['det'] = structNew();
			WOStruct['#attributes.fuseaction#']['det']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['det']['fuseaction'] = 'cost.add_income_cost&event=det&expense_id';
			WOStruct['#attributes.fuseaction#']['det']['xmlfuseaction'] = 'cost.add_income_cost';
			WOStruct['#attributes.fuseaction#']['det']['filePath'] = 'V16/objects/form/det_income_cost.cfm';
			WOStruct['#attributes.fuseaction#']['det']['Identity'] = '#attributes.expense_id#';
			WOStruct['#attributes.fuseaction#']['det']['nextEvent'] = 'cost.add_income_cost&event=det&expense&id=';
			
			
			WOStruct['#attributes.fuseaction#']['del'] = structNew();
			WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
			WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=objects.emptypopup_del_collacted_expense_cost&expense_id=#attributes.expense_id#&head=##caller.get_expense.paper_no##&process_cat=##caller.get_expense.process_cat##&active_period=#session.ep.period_id#';
			WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16/objects/query/del_collacted_expense_cost.cfm';
			WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/objects/query/del_collacted_expense_cost.cfm';
			WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'cost.list_expense_income';
		}
	}
	else
	{
		fuseactController = caller.attributes.fuseaction;
		getLang = caller.getLang;
		denied_pages = caller.denied_pages;
		
		tabMenuStruct = StructNew();
		tabMenuStruct['#fuseactController#'] = structNew();
		tabMenuStruct['#fuseactController#']['tabMenus'] = structNew();
		
		if(caller.attributes.event is 'add')
		{			
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=cost.list_expense_income";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['fa fa-magic']['text'] = '#getLang('',4170)#';//Planlama Sihirbazı
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['fa fa-magic']['onClick'] = "open_wizard()";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['menus'] = structNew(); // Phl
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['menus'][0]['text'] = '#getLang('','Veri Aktarım',60009)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['menus'][0]['onClick'] = "open_file();";
		}
		else if(caller.attributes.event is 'upd')
		{
			get_expense = caller.get_expense;
			if(len(get_expense.ch_company_id) and get_expense.ch_company_id neq 0){
				get_expense_comp = caller.get_expense_comp;
			}else if(len(get_expense.ch_consumer_id)){
				get_cons_name = caller.get_cons_name;
			}
			
			control_einvoice = caller.control_einvoice;
			control_earchive = caller.control_earchive;
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=cost.list_expense_income";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('main',170)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=cost.add_income_cost";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['text'] = '#getLang('main',62)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['onClick'] = "window.open('#request.self#?fuseaction=objects.popup_print_files&action=#attributes.fuseaction#&iid=#attributes.expense_id#&print_type=230','woc');";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['copy']['text'] = '#getLang('main',64)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['copy']['href'] = "#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.add_income_cost&expense_id=#attributes.expense_id#";
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['bell']['text'] = '#getLang('main',345)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['bell']['onclick'] ="window.open('#request.self#?fuseaction=objects.workflowpages&tab=3&action=#attributes.fuseaction#&action_name=expense_id&action_id=#attributes.expense_id#&wrkflow=1','Workflow')";
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-table']['text'] = '#getLang('main',803)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-table']['onclick'] = "windowopen('#request.self#?fuseaction=objects.popup_list_order_account_cards&expense_id=#attributes.expense_id#&is_income=1','page','upd_bill');";

			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['detail']['text'] = '#getlang('main',359)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['detail']['href'] = "#request.self#?fuseaction=cost.add_income_cost&event=det&expense_id=#attributes.expense_id#";

			if (not listfindnocase(denied_pages,'invoice.popup_form_add_info_plus'))
			{
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-info-circle']['text'] = '#getLang('main',398)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-info-circle']['onclick'] = "windowopen('#request.self#?fuseaction=objects.popup_list_comp_add_info&info_id=#attributes.expense_id#&type_id=-17','list');";
			}

			i = 0;
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'] = structNew();
			
			if(session.ep.our_company_info.is_earchive eq 1)
			{
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('main',1338)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onclick'] = "windowopen('#request.self#?fuseaction=invoice.popup_cancel_invoice&expense_id=#attributes.expense_id#','small','popup_cancel_invoice');";
				i=i+1;
			}	
			
			if (len(get_expense.paymethod_id) and not listfindnocase(denied_pages,'objects.popup_payment_with_voucher'))
			{
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('objects',109)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onclick'] = "windowopen('#request.self#?fuseaction=objects.popup_payment_with_voucher&is_purchase_=0&payment_process_id=#attributes.expense_id#&str_table=EXPENSE_ITEM_PLANS&branch_id='+branch_id_,'page','form_upd_expense_cost');";
				i=i+1;
			}
		
			
			if ((get_expense.invoice_type_code eq 'SATIS' or get_expense.invoice_type_code eq 'IADE') and (len(get_expense.ch_company_id) and get_expense_comp.use_efatura eq 1 and datediff('d',get_expense_comp.efatura_date,get_expense.expense_date) gte 0) or (len(get_expense.ch_consumer_id) and get_cons_name.use_efatura eq 1 and datediff('d',get_cons_name.efatura_date,get_expense.expense_date) gte 0))
			{
				transformations['#fuseactController#']['upd']['icons']['customTag'] = structNew();
				if (control_earchive.recordcount)
					transformations['#fuseactController#']['upd']['icons']['customTag'] = "<cf_wrk_earchive_display action_id='#attributes.expense_id#' action_type='EXPENSE_ITEM_PLANS' action_date='#get_expense.expense_date#'>";
				else
					transformations['#fuseactController#']['upd']['icons']['customTag'] = "<cf_wrk_efatura_display action_id='#attributes.expense_id#' action_type='EXPENSE_ITEM_PLANS' action_date='#get_expense.expense_date#'>";
			}
			else if ((get_expense.invoice_type_code eq 'SATIS' or get_expense.invoice_type_code eq 'IADE') and session.ep.our_company_info.is_earchive eq 1 and datediff('d',session.ep.our_company_info.earchive_date,get_expense.expense_date) gte 0)
			{
				transformations['#fuseactController#']['upd']['icons']['customTag'] = structNew();
				if (control_einvoice.recordcount)
					transformations['#fuseactController#']['upd']['icons']['customTag'] = "<cf_wrk_efatura_display action_id='#attributes.expense_id#' action_type='EXPENSE_ITEM_PLANS' action_date='#get_expense.expense_date#'>";
				else
					transformations['#fuseactController#']['upd']['icons']['customTag'] = "<cf_wrk_earchive_display action_id='#attributes.expense_id#' action_type='EXPENSE_ITEM_PLANS' action_date='#get_expense.expense_date#'>";
			}
			
		}

		else if(caller.attributes.event is 'det')
		{
		
			get_expense = caller.get_expense;
			if(len(get_expense.ch_company_id) and get_expense.ch_company_id neq 0){
				get_expense_comp = caller.get_expense_comp;
			}else if(len(get_expense.ch_consumer_id)){
				get_cons_name = caller.get_cons_name;
			}
			control_einvoice = caller.control_einvoice;
			control_earchive = caller.control_earchive;
			
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['list-ul']['href'] = "#request.self#?fuseaction=cost.list_expense_income";
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['add']['text'] = '#getLang('main',170)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['add']['href'] = "#request.self#?fuseaction=cost.add_income_cost";
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['print']['text'] = '#getLang('main',62)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['print']['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_print_files&iid=#attributes.expense_id#&print_type=230','page','workcube_print');";
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['copy']['text'] = '#getLang('main',64)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['copy']['href'] = "#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.add_income_cost&expense_id=#attributes.expense_id#";
			
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['bell']['text'] = '#getLang('main',345)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['bell']['onclick'] ="window.open('#request.self#?fuseaction=objects.workflowpages&tab=3&action=#attributes.fuseaction#&action_name=expense_id&action_id=#attributes.expense_id#&wrkflow=1','Workflow')";
			
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['fa fa-table']['text'] = '#getLang('main',803)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['fa fa-table']['onclick'] = "windowopen('#request.self#?fuseaction=objects.popup_list_order_account_cards&expense_id=#attributes.expense_id#&is_income=1','page','upd_bill');";

			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['fa fa-pencil']['text'] = '#getLang('main',52,'güncelle')#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['fa fa-pencil']['href'] = "#request.self#?fuseaction=cost.add_income_cost&event=upd&expense_id=#attributes.expense_id#";

			if (not listfindnocase(denied_pages,'invoice.popup_form_add_info_plus'))
			{
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['fa fa-info-circle']['text'] = '#getLang('main',398)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['fa fa-info-circle']['onclick'] = "windowopen('#request.self#?fuseaction=objects.popup_list_comp_add_info&info_id=#attributes.expense_id#&type_id=-17','list');";
			}
			
			if ((get_expense.invoice_type_code eq 'SATIS' or get_expense.invoice_type_code eq 'IADE') and (len(get_expense.ch_company_id) and get_expense_comp.use_efatura eq 1 and datediff('d',get_expense_comp.efatura_date,get_expense.expense_date) gte 0) or (len(get_expense.ch_consumer_id) and get_cons_name.use_efatura eq 1 and datediff('d',get_cons_name.efatura_date,get_expense.expense_date) gte 0))
			{
				transformations['#fuseactController#']['det']['icons']['customTag'] = structNew();
				if (control_earchive.recordcount)
					transformations['#fuseactController#']['det']['icons']['customTag'] = "<cf_wrk_earchive_display action_id='#attributes.expense_id#' action_type='EXPENSE_ITEM_PLANS' action_date='#get_expense.expense_date#'>";
				else
					transformations['#fuseactController#']['det']['icons']['customTag'] = "<cf_wrk_efatura_display action_id='#attributes.expense_id#' action_type='EXPENSE_ITEM_PLANS' action_date='#get_expense.expense_date#'>";
			}
			else if ((get_expense.invoice_type_code eq 'SATIS' or get_expense.invoice_type_code eq 'IADE') and session.ep.our_company_info.is_earchive eq 1 and datediff('d',session.ep.our_company_info.earchive_date,get_expense.expense_date) gte 0)
			{
				transformations['#fuseactController#']['det']['icons']['customTag'] = structNew();
				if (control_einvoice.recordcount)
					transformations['#fuseactController#']['det']['icons']['customTag'] = "<cf_wrk_efatura_display action_id='#attributes.expense_id#' action_type='EXPENSE_ITEM_PLANS' action_date='#get_expense.expense_date#'>";
				else
					transformations['#fuseactController#']['det']['icons']['customTag'] = "<cf_wrk_earchive_display action_id='#attributes.expense_id#' action_type='EXPENSE_ITEM_PLANS' action_date='#get_expense.expense_date#'>";
			}
			
		}
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	
	WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
	WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'EXPENSE_ITEM_PLANS';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'EXPENSE_ID';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-process_cat','item-serial_number','item-expense_employee_id','item-expense_date']";
</cfscript>