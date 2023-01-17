<cfsavecontent variable="Detay"><cf_get_lang dictionary_id="57771.Detay"></cfsavecontent>
<cfsavecontent variable="Muhasebefişi"><cf_get_lang dictionary_id="58215.Muhasebefişi"></cfsavecontent>
<cfsavecontent variable="veriaktarim"><cf_get_lang dictionary_id="60009.Veri Aktarım"></cfsavecontent>
<cfscript>
	if(attributes.tabMenuController eq 0)
	{
		WOStruct = StructNew();
		
		WOStruct['#attributes.fuseaction#'] = structNew();	
		
		WOStruct['#attributes.fuseaction#']['default'] = 'add';
		if(not isdefined('attributes.event'))
			attributes.event = WOStruct['#attributes.fuseaction#']['default'];
			nextFuseaction = ( attributes.fuseaction contains 'assetcare' ) ? 'assetcare' : 'cost' ;
		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'objects.form_add_expense_cost';
		WOStruct['#attributes.fuseaction#']['add']['xmlfuseaction'] = 'cost.form_add_expense_cost';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/objects/form/form_add_expense_cost.cfm';	
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'V16/objects/query/add_collacted_expense_cost.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = '#nextFuseaction#.form_add_expense_cost&event=upd&expense_id=';
	/* 	WOStruct['#attributes.fuseaction#']['add']['js'] = "javascript:gizle_goster_ikili('add_cost','list_plan_rows_cost_div');basket_set_height_list_plan_rows_cost_div();";	 */	
		
		if(isdefined("attributes.expense_id") and listFind('upd,del,det',attributes.event))
		{
			WOStruct['#attributes.fuseaction#']['upd'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'objects.form_upd_expense_cost';
			WOStruct['#attributes.fuseaction#']['upd']['xmlfuseaction'] = 'cost.form_add_expense_cost';
			WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'V16/objects/form/form_upd_expense_cost.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'V16/objects/query/upd_collacted_expense_cost.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.expense_id#';
			WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = '#nextFuseaction#.form_add_expense_cost&event=upd&expense_id=';
			WOStruct['#attributes.fuseaction#']['upd']['js'] = "javascript:gizle_goster_ikili('upd_cost','upd_cost_bask');basket_set_height_upd_cost_bask();";
			
			WOStruct['#attributes.fuseaction#']['det'] = structNew();
			WOStruct['#attributes.fuseaction#']['det']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['det']['fuseaction'] = 'objects.form_det_expense_cost';
			WOStruct['#attributes.fuseaction#']['det']['xmlfuseaction'] = 'cost.form_add_expense_cost';
			WOStruct['#attributes.fuseaction#']['det']['filePath'] = 'V16/objects/form/form_det_expense_cost.cfm';
			WOStruct['#attributes.fuseaction#']['det']['Identity'] = '#attributes.expense_id#';

			WOStruct['#attributes.fuseaction#']['del'] = structNew();
			WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
			WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=cost.emptypopup_del_collacted_expense_cost&expense_id=#attributes.expense_id#&process_cat=##caller.get_expense.process_cat##&head=##caller.get_expense.paper_no##&active_period=#session.ep.period_id#&is_from_credit=##caller.is_from_credit##';
			WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16/objects/query/del_collacted_expense_cost.cfm';
			WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/objects/query/del_collacted_expense_cost.cfm';
			WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'cost.list_expense_income';
		}
		
	}else{
		fuseactController = caller.attributes.fuseaction;
		getLang = caller.getLang;
		
		tabMenuStruct = StructNew();
		tabMenuStruct['#fuseactController#'] = structNew();
		tabMenuStruct['#fuseactController#']['tabMenus'] = structNew();
		

		if(caller.attributes.event is 'add')
		{			
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['fa fa-magic']['text'] = '#getLang('',4170)#';//Planlama Sihirbazı
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['fa fa-magic']['onClick'] = "openBoxDraggable('#request.self#?fuseaction=objects.popup_budget_row_calculator&type=expense&draggable=1')"; 
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['download']['text'] = '#veriaktarim#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['download']['onclick'] = "openBoxDraggable('#request.self#?fuseaction=objects.popup_add_expense_cost_file&draggable=1#iif(isdefined("attributes.expense_id") and len(attributes.expense_id),DE("&expense_id=##attributes.expense_id##"),DE(""))#')";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=cost.list_expense_income";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";
			
		}
		else if(caller.attributes.event is 'det')
		{			
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['list-ul']['href'] = "#request.self#?fuseaction=cost.list_expense_income";
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['add']['text'] = '#getLang('main',170)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['add']['href'] = "#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_add_expense_cost";
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['fa fa-pencil']['text'] = '#getLang('main',52,'güncelle')#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['fa fa-pencil']['href'] = "#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_add_expense_cost&event=upd&expense_id=#attributes.expense_id#";
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['bell']['text'] = '#getlang('main',345)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['bell']['onclick'] = "window.open('#request.self#?fuseaction=objects.workflowpages&tab=3&action=#attributes.fuseaction#&event=det&action_name=expense_id&action_id=#attributes.expense_id#&wrkflow=1','Workflow')";
			
		}
		else if(caller.attributes.event is 'upd')
		{
			get_efatura_det = caller.get_efatura_det;
			get_expense = caller.get_expense;
			denied_pages = caller.denied_pages;
			dsn2 = caller.dsn2;
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('main',170)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_add_expense_cost";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['copy']['text'] = '#getLang('main',64)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['copy']['href'] = "#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_add_expense_cost&expense_id=#attributes.expense_id#";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=cost.list_expense_income";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['text'] = '#getLang('main',62)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['onClick'] = "window.open('#request.self#?fuseaction=objects.popup_print_files&action=#attributes.fuseaction#&iid=#expense_id#&print_type=230','woc');";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['bell']['text'] = '#getlang('main',345)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['bell']['onclick'] = "window.open('#request.self#?fuseaction=objects.workflowpages&tab=3&action=#attributes.fuseaction#&event=upd&action_name=expense_id&action_id=#attributes.expense_id#&wrkflow=1','Workflow')";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['detail']['text'] = '#detay#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['detail']['href'] = "#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_add_expense_cost&event=det&expense_id=#attributes.expense_id#";

			if(get_efatura_det.recordcount)
			{	
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['bell']['text'] = '#getlang('main',345)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['bell']['onclick'] = "window.open('#request.self#?fuseaction=objects.workflowpages&tab=3&action=#attributes.fuseaction#&event=upd&action_name=expense_id&action_id=#attributes.expense_id#&wrkflow=1','Workflow')";
			}
			
			
			if(listfindnocase(denied_pages, 'invoice.popup_form_add_info-plus')){

				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-info-circle']['text'] = '#getLang('main',398)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-info-circle']['onclick'] = "windowopen('#request.self#?fuseaction=objects.popup_list_comp_add_info&info_id=#attributes.expense_id#&type_id=-17','list');";

			}

			if(len(get_expense.ch_company_id)){
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['icn-md wrk-uF0134']['text'] = '#getLang('main',397)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['icn-md wrk-uF0134']['onclick'] = "windowopen('#request.self#?fuseaction=ch.list_company_extre&popup_page=1&member_type=partner&member_id=#get_expense.ch_company_id#','wwide1','popup_list_comp_extre')";
			}
			
			else if(len(get_expense.ch_consumer_id)){
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['icn-md wrk-uF0134']['text'] = '#getLang('main',397)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['icn-md wrk-uF0134']['onclick'] = "windowopen('#request.self#?fuseaction=objects.popup_list_comp_extre&member_type=consumer&member_id=#get_expense.ch_consumer_id#','wwide1','popup_list_comp_extre');";
			}
			
			else if(len(get_expense.ch_employee_id)){
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['icn-md wrk-uF0134']['text'] = '#getLang('main',397)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['icn-md wrk-uF0134']['onclick'] = "windowopen('#request.self#?fuseaction=objects.popup_list_comp_extre&member_type=employee&member_id=#get_expense.ch_employee_id#','wwide1','popup_list_comp_extre');";
			}

			asset="";
			if(fuseactController contains 'assetcare')
				asset="&is_asset=1";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-table']['text'] = '#Muhasebefişi#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-table']['onclick'] = "windowopen('#request.self#?fuseaction=objects.popup_list_order_account_cards&expense_id=#attributes.expense_id##asset#','page','upd_bill');";


			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'] = structNew();
			i=0;
			if(len(get_expense.paymethod_id) and not listfindnocase(denied_pages, 'objects.popup_payment_with_voucher')){
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('objects',109)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onclick'] = "send_popup_voucher();";
				i = i + 1;
			}

			if(not len(CALLER.isClosed('EXPENSE_ITEM_PLANS',attributes.expense_id))){
				link = "";
				action_type_id = get_expense.action_type;
				act_type = 3;
				if( len(get_expense.ch_company_id) and get_expense.ch_company_id neq 0)
					link = "#request.self#?fuseaction=finance.list_payment_actions_order&act_type=#act_type#&event=add&member_id=#get_expense.ch_company_id#&row_action_id=#attributes.expense_id#&row_action_type=#action_type_id#";                         
				else if( len(get_expense.ch_CONSUMER_ID)  and get_expense.ch_CONSUMER_ID neq 0)
					link = "#request.self#?fuseaction=finance.list_payment_actions_order&act_type=#act_type#&event=add&consumer_id=#get_expense.ch_CONSUMER_ID#&row_action_id=#attributes.expense_id#&row_action_type=#action_type_id#";  
				else if( len(get_expense.ch_EMPLOYEE_ID)  and get_expense.ch_EMPLOYEE_ID neq 0)
					link = "#request.self#?fuseaction=finance.list_payment_actions_order&act_type=#act_type#&event=add&employee_id_new=#get_expense.ch_EMPLOYEE_ID#&row_action_id=#attributes.expense_id#&row_action_type=#action_type_id#";
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = "#getLang('cash',13,'Ödeme Emri Ver')#";
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['href'] = "#link#";
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['target'] = "_blank";
				i = i + 1;
				
				link = "";
				action_type_id = get_expense.action_type;
				act_type = 2;
				if( len(get_expense.ch_company_id) and get_expense.ch_company_id neq 0)
					link = "#request.self#?fuseaction=finance.list_payment_actions_demand&act_type=#act_type#&event=add&member_id=#get_expense.ch_company_id#&row_action_id=#attributes.expense_id#&row_action_type=#action_type_id#";                         
				else if( len(get_expense.ch_CONSUMER_ID)  and get_expense.ch_CONSUMER_ID neq 0)
					link = "#request.self#?fuseaction=finance.list_payment_actions_demand&act_type=#act_type#&event=add&consumer_id=#get_expense.ch_CONSUMER_ID#&row_action_id=#attributes.expense_id#&row_action_type=#action_type_id#";  
				else if( len(get_expense.ch_EMPLOYEE_ID)  and get_expense.ch_EMPLOYEE_ID neq 0)
					link = "#request.self#?fuseaction=finance.list_payment_actions_demand&act_type=#act_type#&event=add&employee_id_new=#get_expense.ch_EMPLOYEE_ID#&row_action_id=#attributes.expense_id#&row_action_type=#action_type_id#";
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = "#getLang('myhome',676,'Ödeme Talebi Ver')#";
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['href'] = "#link#";
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['target'] = "_blank";
				i = i + 1;
			}
		}
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
	WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'EXPENSE_ITEM_PLANS';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'EXPENSE_ID';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-process_cat','item-serial_number','item-expense_date']";
</cfscript>