<cfscript>
	// Switch //
	if(attributes.tabMenuController eq 0)
	{
	
		WOStruct = StructNew();
		WOStruct['#attributes.fuseaction#'] = structNew();	
		
		WOStruct['#attributes.fuseaction#']['default'] = 'add';
		if(not isdefined('attributes.event'))
			attributes.event = WOStruct['#attributes.fuseaction#']['default'];
		
		WOStruct['#attributes.fuseaction#']['list'] = structNew();
		WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'ch.list_caris';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = '/V16/ch/display/list_caris.cfm';
		
		
		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'ch.form_add_debit_claim_note';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/ch/form/add_debit_claim_note.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'V16/ch/query/add_debit_claim_note.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'ch.form_add_debit_claim_note&event=upd&id';
		
		WOStruct['#attributes.fuseaction#']['addMulti'] = structNew();
		WOStruct['#attributes.fuseaction#']['addMulti']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['addMulti']['fuseaction'] ='ch.form_add_debit_claim_note';
		WOStruct['#attributes.fuseaction#']['addMulti']['filePath'] = 'V16/ch/form/add_collacted_dekont.cfm';
		WOStruct['#attributes.fuseaction#']['addMulti']['queryPath'] = 'V16/ch/query/add_collacted_dekont.cfm';
		WOStruct['#attributes.fuseaction#']['addMulti']['nextEvent'] = 'ch.form_add_debit_claim_note&event=updMulti&multi_id=';
		WOStruct['#attributes.fuseaction#']['addMulti']['js'] = "javascript:gizle_goster_ikili('collacted_dekont','collacted_dekont_bask');";
		
		if(isdefined("attributes.id") or isdefined("attributes.action_id"))
		{
			WOStruct['#attributes.fuseaction#']['upd'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'ch.popup_form_upd_debit_claim_note';
			WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'V16/ch/form/upd_debit_claim_note.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'V16/ch/query/upd_debit_claim_note.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'ch.form_add_debit_claim_note&event=upd&id=';
			if(isdefined("attributes.id"))
				WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.id#';	
			else
				WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.action_id#';	
			
			if(listFind('upd,del',attributes.event))
				{
					WOStruct['#attributes.fuseaction#']['del'] = structNew();
					WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
					WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_del_debit_claim&action_id=##caller.get_note.action_id##&process_type=##caller.get_note.action_type_id##&head=##caller.get_note.paper_no##&old_process_type=##caller.get_note.action_type_id##';
					WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16/ch/query/del_debit_claim.cfm';
					WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/ch/query/del_debit_claim.cfm';
					WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'ch.list_caris';
				}
		}
		if(isdefined("attributes.multi_id"))
		{
			WOStruct['#attributes.fuseaction#']['updMulti'] = structNew();
			WOStruct['#attributes.fuseaction#']['updMulti']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['updMulti']['fuseaction'] = 'ch.upd_collacted_dekont';
			WOStruct['#attributes.fuseaction#']['updMulti']['filePath'] = '/V16/ch/form/upd_collacted_dekont.cfm';
			WOStruct['#attributes.fuseaction#']['updMulti']['queryPath'] = '/V16/ch/query/upd_collacted_dekont.cfm';
			WOStruct['#attributes.fuseaction#']['updMulti']['Identity'] = '#attributes.multi_id#';
			WOStruct['#attributes.fuseaction#']['updMulti']['nextEvent'] = 'ch.form_add_debit_claim_note&event=updMulti&multi_id=';
			WOStruct['#attributes.fuseaction#']['updMulti']['js'] = "javascript:gizle_goster_ikili('collacted_dekont','collacted_dekont_bask');";
			
			if(ListFind('updMulti,delMulti',attributes.event))
			{
				WOStruct['#attributes.fuseaction#']['delMulti'] = structNew();
				WOStruct['#attributes.fuseaction#']['delMulti']['window'] = 'emptypopup';
				WOStruct['#attributes.fuseaction#']['delMulti']['fuseaction'] = '#request.self#?fuseaction=ch.emptypopup_del_collacted_dekont_multi&multi_id=#attributes.multi_id#&old_process_type=##caller.get_action_detail.action_type_id##';
				WOStruct['#attributes.fuseaction#']['delMulti']['filePath'] = 'V16/ch/query/del_collacted_dekont_multi.cfm';
				WOStruct['#attributes.fuseaction#']['delMulti']['queryPath'] = 'V16/ch/query/del_collacted_dekont_multi.cfm';
				WOStruct['#attributes.fuseaction#']['delMulti']['nextEvent'] = 'ch.list_caris';
			}
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
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=ch.list_caris";
			
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";
			
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['menus'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['menus'][0]['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['menus'][0]['text'] = '#getLang('main',1849)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['menus'][0]['href'] = "#request.self#?fuseaction=ch.form_add_debit_claim_note&event=addMulti";
		}
		else if(caller.attributes.event is 'addMulti')
		{
			tabMenuStruct['#fuseactController#']['tabMenus']['addMulti']['icons'] = structNew();
			
			tabMenuStruct['#fuseactController#']['tabMenus']['addMulti']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['addMulti']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['addMulti']['icons']['list-ul']['href'] = "#request.self#?fuseaction=ch.list_caris";
			
			tabMenuStruct['#fuseactController#']['tabMenus']['addMulti']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['addMulti']['icons']['check']['onClick'] = "buttonClickFunction()";
			
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['fa fa-download']['text'] = '#getLang('main',2576)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['fa fa-download']['onClick'] = "open_file();";				
		}
		else if(caller.attributes.event is 'upd')
		{
			get_note = caller.get_note;
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('main',170)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=ch.form_add_debit_claim_note";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=ch.list_caris";
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['text'] = "#getLang('main',62)#";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_print_files&action_id=#attributes.id#&print_type=212','page');";
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['copy']['text'] = "#getLang('main',64)#";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['copy']['href'] ="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_add_debit_claim_note&event=add&id=#attributes.id#";

			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][0]['text'] = "#getLang('main',1040)#";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][0]['onclick'] = "windowopen('#request.self#?fuseaction=account.popup_list_card_rows&action_id=#attributes.id#&process_cat=#get_note.action_type_id#','page','emptypopup_upd_debit_claim_note');";
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][1]['text'] = "#getLang('main',1966)#";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][1]['customtag'] ="<cf_get_workcube_related_acts period_id='#session.ep.period_id#' company_id='#session.ep.company_id#' asset_cat_id='-17' module_id='23' action_section='ACTION_ID' action_id='#attributes.id#'>";
			
		}
		else if(caller.attributes.event is 'updMulti')
		{
			get_action_detail = caller.get_action_detail;
			tabMenuStruct['#fuseactController#']['tabMenus']['updMulti']['icons'] = structNew();
			
			tabMenuStruct['#fuseactController#']['tabMenus']['updMulti']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['updMulti']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['updMulti']['icons']['list-ul']['href'] = "#request.self#?fuseaction=ch.list_caris";
			
			tabMenuStruct['#fuseactController#']['tabMenus']['updMulti']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['updMulti']['icons']['check']['onClick'] = "buttonClickFunction()";
			
			tabMenuStruct['#fuseactController#']['tabMenus']['updMulti']['icons']['add']['text'] = '#getLang('main',170)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['updMulti']['icons']['add']['href'] = "#request.self#?fuseaction=ch.form_add_debit_claim_note&event=addMulti";
			tabMenuStruct['#fuseactController#']['tabMenus']['updMulti']['icons']['add']['target'] = "_blank";
							
			tabMenuStruct['#fuseactController#']['tabMenus']['updMulti']['icons']['copy']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['updMulti']['icons']['copy']['text'] = '#getLang('main',64)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['updMulti']['icons']['copy']['href'] = "#request.self#?fuseaction=#listGetAt(attributes.fuseaction,1,'.')#.form_add_debit_claim_note&event=addMulti&multi_id=#attributes.multi_id#";

			tabMenuStruct['#fuseactController#']['tabMenus']['updMulti']['icons']['print']['text'] = '#getLang('main',62)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['updMulti']['icons']['print']['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_print_files&print_type=212&action_id=#URLEncodedFormat(caller.page_code)#','page','popup_print_files');";

			tabMenuStruct['#fuseactController#']['tabMenus']['updMulti']['icons']['fa fa-table']['text'] = '#getLang('main',1040)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['updMulti']['icons']['fa fa-table']['onclick'] = "windowopen('#request.self#?fuseaction=account.popup_list_card_rows&action_id=#attributes.multi_id#&process_cat=#get_action_detail.action_type_id#','page_horizantal','add_process');";
		
			tabMenuStruct['#fuseactController#']['tabMenus']['updMulti']['menus'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['updMulti']['menus'][0]['text'] = '#getLang('main',1966)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['updMulti']['menus'][0]['customTag'] = "<cf_get_workcube_related_acts period_id='#session.ep.period_id#' company_id='#session.ep.company_id#' asset_cat_id='-17' module_id='23' action_section='MULTI_ACTION_ID' action_id='#attributes.multi_id#'>";			
			
		}
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	if(not attributes.event contains 'Multi')
	{
		WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
		WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'CARI_ACTIONS';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'CARI_ACTION_ID';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-process_cat','item-company_id','item-paper_number','item-ACTION_CURRENCY_ID','item-action_account_code','item-action_date']";
	}
	else
	{
		WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
		WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'addMulti,updMulti';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'CARI_ACTIONS_MULTI';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'MULTI_ACTION_ID';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-process_cat','item-action_date']";		
	}
</cfscript>		