<cfscript>
	if(attributes.tabMenuController eq 0)
	{
		WOStruct = StructNew();
		
		WOStruct['#attributes.fuseaction#'] = structNew();
		
		WOStruct['#attributes.fuseaction#']['default'] = 'list';
		
		WOStruct['#attributes.fuseaction#']['list'] = structNew();
		WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'call.helpdesk';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/callcenter/display/helpdesk.cfm';
		
		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		if(isdefined('attributes.window') && attributes.window EQ 'popup'){
			WOStruct['#attributes.fuseaction#']['add']['window'] = 'popup';
		}else{
			WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
		}		
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'call.popup_add_helpdesk';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/callcenter/form/add_helpdesk.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'V16/callcenter/query/add_helpdesk.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'call.helpdesk&event=upd&cus_help_id=';
		WOStruct['#attributes.fuseaction#']['add']['formName'] = 'add_helpdesk';

		if(isdefined('attributes.cus_help_id') and len(attributes.cus_help_id))
		{
			WOStruct['#attributes.fuseaction#']['upd'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'call.upd_helpdesk';
			WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'V16/callcenter/form/upd_helpdesk.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'V16/callcenter/query/upd_helpdesk.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'call.helpdesk&event=upd&cus_help_id=';
			WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'cus_help_id=#attributes.cus_help_id#';
			WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.cus_help_id#';
			
			WOStruct['#attributes.fuseaction#']['del'] = structNew();
			WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
			WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=call.emptypopup_del_helpdesk&cus_help_id=#attributes.cus_help_id#';
			WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16/callcenter/query/del_helpdesk.cfm';
			WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/callcenter/query/del_helpdesk.cfm';
			WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'call.helpdesk';
		}
	}
	else
	{			
		getLang = caller.getLang;
		denied_pages = caller.denied_pages;
		
		tabMenuStruct = StructNew();
		tabMenuStruct['#attributes.fuseaction#'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus'] = structNew();
		
		if(caller.attributes.event is 'add')
		{			
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['icons'] = structNew();
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=call.helpdesk";

		}
		
		else if(isdefined("attributes.event") and attributes.event is 'upd')
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd'] = structNew();
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'] = structNew();
			i = 0;
			get_help = caller.get_help;

			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('main',1077)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['href'] = "#request.self#?fuseaction=sales.list_opportunity&event=add&cus_help_id=#attributes.cus_help_id#";
			i++;
			
			if (len(get_help.company_id) and len(get_help.partner_id))
			{
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('call',25)#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['href'] = "#request.self#?fuseaction=myhome.mytime_management&event=add&cus_help_id=#url.cus_help_id#&comp_id=#get_help.company_id#&partner_id=#get_help.partner_id#&subscription_id=#get_help.subscription_id#&is_cus_help=1;";
				i++;
			}
			else if (len(get_help.consumer_id))
			{
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('call',25)#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['href'] = "#request.self#?fuseaction=myhome.mytime_management&event=add&cus_help_id=#url.cus_help_id#&cons_id=#get_help.consumer_id#&subscription_id=#get_help.subscription_id#&is_cus_help=1;";
				i++;
			}
			
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('call',96)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['href'] = "#request.self#?fuseaction=service.list_service&event=add&cus_help_id=#attributes.cus_help_id#";
			i++;
			
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('call',46)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['href'] ="#request.self#?fuseaction=call.list_service&event=add&cus_help_id=#attributes.cus_help_id#";
			i++;
			
			if (len(get_help.company_id))
			{
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('main',163)#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['href'] ="#request.self#?fuseaction=call.list_callcenter&event=det&cpid=#get_help.company_id#";
				i++;
			}
			else if (len(get_help.consumer_id))
			{
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('main',163)#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['href'] ="#request.self#?fuseaction=call.list_callcenter&event=det&cid=#get_help.consumer_id#";
				i++;
			}
			
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('main',521)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['onclick'] = "windowopen('#request.self#?fuseaction=project.works&event=add&cus_help_id=#attributes.cus_help_id#&work_fuse=#attributes.fuseaction#','wwide1');";
			i++;
						
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons'] = structNew();
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('main',170)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=call.helpdesk&event=add";
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=call.helpdesk";
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";

		}
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	
	WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
	WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd,list';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'CUSTOMER_HELP';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'CUS_HELP_ID';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-interaction_date','item-commethod','item-process_cat','item-company_name','item-member_name','item-detail','item-subject']";
</cfscript>