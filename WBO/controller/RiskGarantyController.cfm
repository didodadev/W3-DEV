<cfscript>
	if(attributes.fuseaction contains 'finance')
		moduleShortName = 'finance';
	else
		moduleShortName = 'member';
		
	if(attributes.tabMenuController eq 0)
	{
		WOStruct = StructNew();
		
		WOStruct['#attributes.fuseaction#'] = structNew();	
		
		WOStruct['#attributes.fuseaction#']['default'] = 'list';
		if(not isdefined('attributes.event'))
			attributes.event = WOStruct['#attributes.fuseaction#']['default'];
	
		WOStruct['#attributes.fuseaction#']['list'] = structNew();
		WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = '#moduleShortName#.list_securefund';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/finance/display/list_securefund.cfm';	
		
		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'member.popup_form_add_securefund';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = '/V16/member/form/add_securefund.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'V16/member/query/add_securefund.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = '#moduleShortName#.list_securefund&event=upd&securefund_id=';	
		
		if(isdefined("attributes.securefund_id"))
		{
			WOStruct['#attributes.fuseaction#']['upd'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'member.popup_form_upd_securefund';
			WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'V16/member/form/upd_securefund.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'V16/member/query/upd_securefund.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.securefund_id#';
			WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = '#moduleShortName#.list_securefund&event=upd&securefund_id=';
			
			WOStruct['#attributes.fuseaction#']['del'] = structNew();
			WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
			WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=member.emptypopup_del_securefund&securefund_id=#ATTRIBUTES.SECUREFUND_ID#';
			WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16/member/query/del_securefund.cfm';
			WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/member/query/del_securefund.cfm';
			WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = '#moduleShortName#.list_securefund';
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
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=#moduleShortName#.list_securefund";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";
		}
		else if(caller.attributes.event is 'upd')
		{
			GET_COMPANY_SECUREFUND = caller.GET_COMPANY_SECUREFUND;
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'] = structNew();
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][0]['text'] = '#getLang('main',1858)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][0]['onClick'] = "openBoxDraggable('#request.self#?fuseaction=member.popup_add_securefund_return&securefund_id=#attributes.securefund_id#');";
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('main',170)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=#moduleShortName#.list_securefund&event=add";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=#moduleShortName#.list_securefund";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['copy']['text'] = '#getLang('main',64)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['copy']['href'] = "#request.self#?fuseaction=#moduleShortName#.list_securefund&event=add&securefund_id=#attributes.SECUREFUND_ID#";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-history']['text'] = '#getLang('main',61)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-history']['onClick'] = "windowopen('#request.self#?fuseaction=member.popup_securefund_history&securefund_id=#attributes.securefund_id#','page','popup_securefund_history');";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-table']['text'] = '#getLang('main',1040)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-table']['onClick'] = "windowopen('#request.self#?fuseaction=account.popup_list_card_rows&action_id=#attributes.securefund_id#&process_cat=#GET_COMPANY_SECUREFUND.ACTION_TYPE_ID#&period_id=#GET_COMPANY_SECUREFUND.ACTION_PERIOD_ID#','page','add_secure');";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['archive']['text'] = '';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['archive']['customTag'] = "<cf_get_workcube_related_acts company_id='#session.ep.company_id#' asset_cat_id='-17' module_id='4' action_section='SECUREFUND_ID' action_id='#attributes.securefund_id#'>";				
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['bell']['text'] = '#getlang('main',345)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['bell']['onClick'] = "window.open('#request.self#?fuseaction=objects.workflowpages&tab=3&action=#attributes.fuseaction#&action_name=securefund_id&action_id=#attributes.securefund_id#','Workflow')";
	
		}
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	
	WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
	WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'COMPANY_SECUREFUND';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'SECUREFUND_ID';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-member_id','item-process_cat','item-SECUREFUND_CAT_ID','item-START_DATE','item-FINISH_DATE','item-action_value','item-action_value_2']";
</cfscript>
