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
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'cheque.list_payment_voucher';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = '/V16/cheque/display/list_payment_voucher.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = '/V16/cheque/display/list_payment_voucher.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = '';
		WOStruct['#attributes.fuseaction#']['add']['formName'] = 'add_voucher_action';	
	}
	
	else
	{
		get_module_user = caller.get_module_user;
		denied_pages = caller.denied_pages;
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
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=cheque.list_voucher_actions";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";
			
			i = 0;
			
			if(isdefined("attributes.company_id") and len(attributes.company_id) and len(attributes.company))
			{
				if(get_module_user(33) and not listfindnocase(denied_pages,'report.bsc_company'))
				{
					tabMenuStruct['#fuseactController#']['tabMenus']['add']['menus'][i]['text'] =  '#getLang('cheque',207)#';
					tabMenuStruct['#fuseactController#']['tabMenus']['add']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=report.popup_bsc_company&member_type=partner&company_id=#attributes.company_id#&member_name=#attributes.company#&finance=1','wide' );";
					i = i + 1;
				}
				if(not listfindnocase(denied_pages,'myhome.my_company_details'))
				{
					tabMenuStruct['#fuseactController#']['tabMenus']['add']['menus'][i]['target'] = "_blank";
					tabMenuStruct['#fuseactController#']['tabMenus']['add']['menus'][i]['text'] = '#getLang('main',163)#';
					tabMenuStruct['#fuseactController#']['tabMenus']['add']['menus'][i]['href'] = "#request.self#?fuseaction=myhome.my_company_details&cpid=#attributes.company_id#";
					i = i + 1;
				}
				if(not listfindnocase(denied_pages,'member.detail_company'))
				{
					tabMenuStruct['#fuseactController#']['tabMenus']['add']['menus'][i]['target'] = "_blank";
					tabMenuStruct['#fuseactController#']['tabMenus']['add']['menus'][i]['text'] = '#getLang('cheque',208)#';
					tabMenuStruct['#fuseactController#']['tabMenus']['add']['menus'][i]['href'] = "#request.self#?fuseaction=member.form_list_company&event=det&cpid=#attributes.company_id#";
					i = i + 1;
				}
				if(not listfindnocase(denied_pages,'contract.detail_contract_company'))
				{
					tabMenuStruct['#fuseactController#']['tabMenus']['add']['menus'][i]['target'] = "_blank";
					tabMenuStruct['#fuseactController#']['tabMenus']['add']['menus'][i]['text'] = '#getLang('cheque',209)#';
					tabMenuStruct['#fuseactController#']['tabMenus']['add']['menus'][i]['href'] = "#request.self#?fuseaction=finance.list_credits&event=upd&company_id=#attributes.company_id#";
					i = i + 1;
				}
				
				tabMenuStruct['#fuseactController#']['tabMenus']['add']['menus'][i]['target'] = "_blank";
				tabMenuStruct['#fuseactController#']['tabMenus']['add']['menus'][i]['text'] = '#getLang('main',397)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['add']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_list_comp_extre&member_type=partner&member_id=#attributes.company_id#','page')";
			}
			else if(isdefined("attributes.consumer_id") and len(attributes.consumer_id) and len(attributes.company))
			{
				if(get_module_user(3) and not listfindnocase(denied_pages,'report.bsc_company'))
				{
					tabMenuStruct['#fuseactController#']['tabMenus']['add']['menus'][i]['text'] =  '#getLang('cheque',207)#';
					tabMenuStruct['#fuseactController#']['tabMenus']['add']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=report.popup_bsc_company&member_type=consumer&consumer_id=#attributes.consumer_id#&member_name=#attributes.company#&finance=1','wide' );";
					i = i + 1;
				}
				if(not listfindnocase(denied_pages,'myhome.my_consumer_details'))
				{
					tabMenuStruct['#fuseactController#']['tabMenus']['add']['menus'][i]['target'] = "_blank";
					tabMenuStruct['#fuseactController#']['tabMenus']['add']['menus'][i]['text'] = '#getLang('main',163)#';
					tabMenuStruct['#fuseactController#']['tabMenus']['add']['menus'][i]['href'] = "#request.self#?fuseaction=call.list_callcenter&event=det&cid=#attributes.consumer_id#";
					i = i + 1;
				}
				if(not listfindnocase(denied_pages,'member.detail_company'))
				{
					tabMenuStruct['#fuseactController#']['tabMenus']['add']['menus'][i]['target'] = "_blank";
					tabMenuStruct['#fuseactController#']['tabMenus']['add']['menus'][i]['text'] = '#getLang('cheque',208)#';
					tabMenuStruct['#fuseactController#']['tabMenus']['add']['menus'][i]['href'] = "#request.self#?fuseaction=member.detail_consumer&cid=#attributes.consumer_id#";
					i = i + 1;
				}
				if(not listfindnocase(denied_pages,'contract.detail_contract_company'))
				{
					tabMenuStruct['#fuseactController#']['tabMenus']['add']['menus'][i]['target'] = "_blank";
					tabMenuStruct['#fuseactController#']['tabMenus']['add']['menus'][i]['text'] = '#getLang('cheque',209)#';
					tabMenuStruct['#fuseactController#']['tabMenus']['add']['menus'][i]['href'] = "#request.self#?fuseaction=finance.list_credits&event=upd&consumer_id=#attributes.consumer_id#";
					i = i + 1;
				}
				
				tabMenuStruct['#fuseactController#']['tabMenus']['add']['menus'][i]['text'] = '#getLang('main',397)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['add']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_list_comp_extre&member_type=consumer&member_id=#attributes.consumer_id#','page')";
				i = i + 1;
				
			}
		}
		
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
</cfscript>
