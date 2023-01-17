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
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'ch.form_add_cari_to_cari';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = '/V16/ch/form/add_cari_to_cari.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = '/V16/ch/query/add_cari_to_cari.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'ch.form_add_cari_to_cari&event=upd&ID=';
		WOStruct['#attributes.fuseaction#']['add']['formName'] = 'add_cari_to_cari';
		
		WOStruct['#attributes.fuseaction#']['addMulti'] = structNew();
		WOStruct['#attributes.fuseaction#']['addMulti']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['addMulti']['fuseaction'] ='ch.form_collacted_cari_virman';
		WOStruct['#attributes.fuseaction#']['addMulti']['filePath'] = 'V16/ch/form/add_collacted_cari_virman.cfm';
		WOStruct['#attributes.fuseaction#']['addMulti']['queryPath'] = 'V16/ch/query/add_collacted_virman.cfm';
		WOStruct['#attributes.fuseaction#']['addMulti']['nextEvent'] = 'ch.form_add_cari_to_cari&event=updMulti&upd_id=';
		WOStruct['#attributes.fuseaction#']['addMulti']['js'] = "javascript:gizle_goster_ikili('collacted_virman','collacted_virman_sepet');";

		if(attributes.event is 'add' or attributes.event is 'upd')
		{
			WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
			WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd';
			WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'CARI_ACTIONS';
			WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'ACTION_ID';
			WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-survey_head','item-to_company_id','item-from_company_id','item-action_date','item-ACTION_CURRENCY_ID']";
		}
			
		if(isdefined("attributes.id"))
		{
			if(attributes.event is 'upd'){
				WOStruct['#attributes.fuseaction#']['upd'] = structNew();
				WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
				WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'ch.form_upd_cari_to_cari';
				WOStruct['#attributes.fuseaction#']['upd']['filePath'] = '/V16/ch/form/upd_cari_to_cari.cfm';
				WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = '/V16/ch/query/upd_cari_to_cari.cfm';
				WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.id#';
				WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'ch.form_add_cari_to_cari&event=upd&ID=';

				WOStruct['#attributes.fuseaction#']['del'] = structNew();
				WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
				WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=ch.emptypopup_del_debit_claim';
				WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16/ch/query/del_debit_claim.cfm';
				WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/ch/query/del_debit_claim.cfm';
				WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'ch.form_add_cari_to_cari&event=list';
			}
		}
		if(isdefined("attributes.upd_id"))
		{
			WOStruct['#attributes.fuseaction#']['updMulti'] = structNew();
			WOStruct['#attributes.fuseaction#']['updMulti']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['updMulti']['fuseaction'] = 'ch.form_collacted_cari_virman';
			WOStruct['#attributes.fuseaction#']['updMulti']['filePath'] = '/V16/ch/form/add_collacted_cari_virman.cfm';
			WOStruct['#attributes.fuseaction#']['updMulti']['queryPath'] = '/V16/ch/query/add_collacted_virman.cfm';
			WOStruct['#attributes.fuseaction#']['updMulti']['Identity'] = '#attributes.upd_id#';
			WOStruct['#attributes.fuseaction#']['updMulti']['nextEvent'] = 'ch.form_add_cari_to_cari&event=updMulti&upd_id=';
			WOStruct['#attributes.fuseaction#']['updMulti']['js'] = "javascript:gizle_goster_ikili('collacted_virman','collacted_virman_sepet');";
		}
		if(ListFind('updMulti,delMulti',attributes.event))
		{
			WOStruct['#attributes.fuseaction#']['delMulti'] = structNew();
			WOStruct['#attributes.fuseaction#']['delMulti']['window'] = 'emptypopup';
			if(isDefined('attributes.upd_id'))
				WOStruct['#attributes.fuseaction#']['delMulti']['fuseaction'] = '#request.self#?fuseaction=ch.emptypopup_collacted_cari_virman&upd_id=#attributes.upd_id#&is_del=1&active_period=#session.ep.period_id#';
			else
				WOStruct['#attributes.fuseaction#']['delMulti']['fuseaction'] = '#request.self#?fuseaction=ch.emptypopup_collacted_cari_virman&upd_id=#attributes.del_id#&is_del=1&active_period=#session.ep.period_id#';
			WOStruct['#attributes.fuseaction#']['delMulti']['filePath'] = 'V16/ch/query/add_collacted_virman.cfm';
			WOStruct['#attributes.fuseaction#']['delMulti']['queryPath'] = 'V16/ch/query/add_collacted_virman.cfm';
			WOStruct['#attributes.fuseaction#']['delMulti']['nextEvent'] = 'ch.list_caris';
		}
	}
	else
	{
		fuseactController = caller.attributes.fuseaction;
		// Tab Menus //
		tabMenuStruct = StructNew();
	
		tabMenuStruct['#fuseactController#'] = structNew();
		tabMenuStruct['#fuseactController#']['tabMenus'] = structNew();
		
		getLang = caller.getLang;
		
		if(attributes.event is 'add')
		{
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=ch.list_caris";
			
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";
			
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['menus'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['menus'][0]['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['menus'][0]['text'] = '#getLang('main',2530)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['menus'][0]['href'] = "#request.self#?fuseaction=ch.form_add_cari_to_cari&event=addMulti";			
		}
		else if(attributes.event is 'addMulti')
		{
			tabMenuStruct['#fuseactController#']['tabMenus']['addMulti']['icons'] = structNew();
			
			tabMenuStruct['#fuseactController#']['tabMenus']['addMulti']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['addMulti']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['addMulti']['icons']['list-ul']['href'] = "#request.self#?fuseaction=ch.list_caris";
			
			tabMenuStruct['#fuseactController#']['tabMenus']['addMulti']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['addMulti']['icons']['check']['onClick'] = "buttonClickFunction()";
			
			tabMenuStruct['#fuseactController#']['tabMenus']['addMulti']['menus'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['addMulti']['menus'][0]['text'] = '#getLang('main',2576)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['addMulti']['menus'][0]['onClick'] = "open_file();";			
		}
		else if(attributes.event is 'upd')
		{
			get_note = caller.get_note;
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-table']['text'] = '#getLang('main',1040)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-table']['onClick'] = "windowopen('#request.self#?fuseaction=account.popup_list_card_rows&action_id=#attributes.id#&process_cat=#get_note.action_type_id#','page','upd_cari_to_cari');";
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('main',170)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=ch.form_add_cari_to_cari";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=ch.list_caris";
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['text'] = '#getLang('main',62)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_print_files&action_id=#attributes.id#&print_type=211','page');";

			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['copy']['text'] = '#getLang('main',64,'kopyala')#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['copy']['href'] = "#request.self#?fuseaction=ch.form_add_cari_to_cari&event=add&event_id=#attributes.id#";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['copy']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['archive']['text'] = '#getLang('main',1966)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['archive']['customTag'] = "<cf_get_workcube_related_acts period_id='#session.ep.period_id#' company_id='#session.ep.company_id#' asset_cat_id='-17' module_id='23' action_section='ACTION_ID' action_id='#attributes.id#'>";
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
			tabMenuStruct['#fuseactController#']['tabMenus']['updMulti']['icons']['add']['href'] = "#request.self#?fuseaction=ch.form_add_cari_to_cari&event=addMulti";
			tabMenuStruct['#fuseactController#']['tabMenus']['updMulti']['icons']['add']['target'] = "_blank";
							
			tabMenuStruct['#fuseactController#']['tabMenus']['updMulti']['icons']['copy']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['updMulti']['icons']['copy']['text'] = '#getLang('main',64)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['updMulti']['icons']['copy']['href'] = "#request.self#?fuseaction=ch.form_add_cari_to_cari&event=addMulti&_copy_id=#attributes.upd_id#";

			tabMenuStruct['#fuseactController#']['tabMenus']['updMulti']['icons']['print']['text'] = '#getLang('main',62)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['updMulti']['icons']['print']['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_print_files&iid=#attributes.upd_id#&print_type=217','page','workcube_print');";

			tabMenuStruct['#fuseactController#']['tabMenus']['updMulti']['menus'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['updMulti']['icons']['archive']['text'] = '#getLang('main',1966)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['updMulti']['icons']['archive']['customTag'] = "<cf_get_workcube_related_acts period_id='#session.ep.period_id#' company_id='#session.ep.company_id#' asset_cat_id='-17' module_id='23' action_section='MULTI_ACTION_ID' action_id='#attributes.upd_id#'>";			
			
			tabMenuStruct['#fuseactController#']['tabMenus']['updMulti']['icons']['fa fa-table']['text'] = '#getLang('main',1040)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['updMulti']['icons']['fa fa-table']['onclick'] = "windowopen('#request.self#?fuseaction=account.popup_list_card_rows&action_id=#attributes.upd_id#&process_cat=430','page_horizantal','add_process');";
		}
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
		
	}
</cfscript>
