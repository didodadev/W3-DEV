<!-----------------------------------------------------------------------
*************************************************************************
		Copyright Workcube E-Business Inc. www.workcube.com
*************************************************************************	
Description :
	Banka Para Çekme Objesi
----------------------------------------------------------------------->

<cfscript>
	if(attributes.tabMenuController eq 0)
	{
		WOStruct = StructNew();
		
		WOStruct['#attributes.fuseaction#'] = structNew();
		
		WOStruct['#attributes.fuseaction#']['default'] = 'add';
		
		if(not isDefined("attributes.event"))
			attributes.event = WOStruct['#attributes.fuseaction#']['default'];
		
		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'bank.form_add_get_money';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/bank/form/add_get_money.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'V16/bank/query/add_get_money.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'bank.form_add_get_money&event=upd&id=';
		WOStruct['#attributes.fuseaction#']['add']['formName'] = 'get_money';
		
		WOStruct['#attributes.fuseaction#']['add']['buttons'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['buttons']['save'] = 1;
		WOStruct['#attributes.fuseaction#']['add']['buttons']['saveFunction'] = 'kontrol() && validate().check()';

		if(isdefined("attributes.id") and len(attributes.id))
		{		
			WOStruct['#attributes.fuseaction#']['upd'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'bank.popup_upd_get_money';
			WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'V16/bank/form/upd_get_money.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'V16/bank/query/upd_get_money.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'bank.form_add_get_money&event=upd&id=';
			WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'id=#attributes.id#';
			WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.id#';
			WOStruct['#attributes.fuseaction#']['upd']['formName'] = 'get_money';
			WOStruct['#attributes.fuseaction#']['upd']['recordQuery'] = 'get_action_detail';

			WOStruct['#attributes.fuseaction#']['upd']['buttons']['update'] = 1;
			WOStruct['#attributes.fuseaction#']['upd']['buttons']['updateFunction'] = 'kontrol() && validate().check()';
			WOStruct['#attributes.fuseaction#']['upd']['buttons']['delete'] = 1;
			WOStruct['#attributes.fuseaction#']['upd']['buttons']['deleteEvent'] = 'del';
			WOStruct['#attributes.fuseaction#']['upd']['buttons']['deleteFunction'] = 'del_kontrol()';

			WOStruct['#attributes.fuseaction#']['del'] = structNew();
			WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
			WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=bank.del_get_money&id=#attributes.id#&old_process_type=##caller.get_action_detail.action_type_id##&paper_no=##caller.get_action_detail.paper_no##';
			WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16/bank/query/del_get_money.cfm';
			WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/bank/query/del_get_money.cfm';
			WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'bank.list_bank_actions';
		}
		
		
		
	}
	else
	{
		getLang = caller.getLang;
		
		if(attributes.event is 'upd')
		{
			get_action_detail = caller.get_action_detail;
			
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd'] = structNew();
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'] = structNew();
			
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons'] = structNew();
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#getlang('main',170)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=bank.form_add_get_money&event=add";
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=bank.list_bank_actions";
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['text'] = '#getLang('main',62)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['onClick'] = "window.open('#request.self#?fuseaction=objects.popup_print_files&action_id=#attributes.id#&action_type=#get_action_detail.action_type_id#','page');";
		
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['fa fa-table']['text'] = '#getlang('main',1040)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['fa fa-table']['onClick'] = "windowopen('#request.self#?fuseaction=account.popup_list_card_rows&action_id=#attributes.id#&process_cat=#get_action_detail.ACTION_TYPE_ID#','page','upd_get_money');";
			
			tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
		}
		else if (attributes.event is 'add')
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=bank.list_bank_actions";
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";	
			
			tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
		}		
	}
	WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
	WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'BANK_ACTIONS';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'ACTION_ID';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-process_cat','item-TO_CASH_ID','item-account_id','item-ACTION_DATE','item-ACTION_VALUE','item-employee']";
</cfscript>