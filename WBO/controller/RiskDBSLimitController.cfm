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
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'contract.list_contracts';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/contract/display/list_partner_contract.cfm';
	
		if(isdefined("attributes.consumer_id") and len(attributes.consumer_id))
		{
			getCreditLimit=QueryExecute(("SELECT COMPANY_CREDIT_ID FROM COMPANY_CREDIT WHERE CONSUMER_ID = ? AND OUR_COMPANY_ID = ?"),["#attributes.consumer_id#","#session.ep.company_id#"],{datasource="#dsn#"});
			WOStruct['#attributes.fuseaction#']['upd'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'contract.detail_contract_company';
			WOStruct['#attributes.fuseaction#']['upd']['filePath'] = '/V16/contract/query/detail_contract_company.cfm';
			if(getCreditLimit.recordcount and len(getCreditLimit.company_credit_id))
				WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = '/V16/contract/query/upd_company_credit.cfm';
			else
				WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = '/V16/contract/query/add_company_credit.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.consumer_id#';
			WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'contract.list_contracts&event=upd&consumer_id=';
		}
		else if(isdefined("attributes.company_id") and len(attributes.company_id))
		{
			getCreditLimit=QueryExecute(("SELECT COMPANY_CREDIT_ID FROM COMPANY_CREDIT WHERE COMPANY_ID = ? AND OUR_COMPANY_ID = ?"),["#attributes.company_id#","#session.ep.company_id#"],{datasource="#dsn#"});
			WOStruct['#attributes.fuseaction#']['upd'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'contract.detail_contract_company';
			WOStruct['#attributes.fuseaction#']['upd']['filePath'] = '/V16/contract/query/detail_contract_company.cfm';
			if(getCreditLimit.recordcount and len(getCreditLimit.company_credit_id))
				WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = '/V16/contract/query/upd_company_credit.cfm';
			else
				WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = '/V16/contract/query/add_company_credit.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.company_id#';
			WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'contract.list_contracts&event=upd&company_id=';
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
		
		if(caller.attributes.event is 'upd')
		{
			tabMenuStruct['#fuseactController#']['tabMenus']['upd'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'] = structNew();
			if(isdefined("attributes.company_id") and len(attributes.company_id))
			{
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][0]['text'] = '#getlang('main',61)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][0]['onClick'] = "windowopen('#request.self#?fuseaction=contract.popup_risc_contract_history&member_type=company&member_id=#attributes.company_id#','medium');";
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][1]['text'] = '#getlang('main',345)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][1]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_page_warnings&action=contract.detail_contract_company&action_name=company_id&action_id=#attributes.company_id#','list');";
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][2]['text'] = '#getlang('contract',313)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][2]['href'] = "#request.self#?fuseaction=member.form_list_company&event=upd&cpid=#attributes.company_id#";
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][3]['text'] = '#getlang('main',163)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][3]['href'] = "#request.self#?fuseaction=call.list_callcenter&event=det&cpid=#attributes.company_id#";
				if(not listfindnocase(denied_pages,'member.popup_list_securefund'))
				{
					tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][4]['text'] = '#getlang('main',264)#';
					tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][4]['onClick'] = "windowopen('#request.self#?fuseaction=member.popup_list_securefund&company_id=#attributes.company_id#','list');";
				}
			}
			else if(isdefined("attributes.consumer_id") and len(attributes.consumer_id))
			{
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][0]['text'] = '#getlang('main',61)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][0]['onClick'] = "openBoxDraggable('#request.self#?fuseaction=contract.popup_risc_contract_history&member_type=consumer&member_id=#attributes.consumer_id#');";
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][1]['text'] = '#getlang('contract',313)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][1]['href'] = "#request.self#?fuseaction=member.consumer_list&event=det&cid=#attributes.consumer_id#";
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][2]['text'] = '#getlang('main',163)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][2]['href'] = "#request.self#?fuseaction=call.list_callcenter&event=det&cid=#attributes.consumer_id#";
				if(not listfindnocase(denied_pages,'member.popup_list_securefund'))
				{
					tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][3]['text'] = '#getlang('main',264)#';
					tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][3]['onClick'] = "windowopen('#request.self#?fuseaction=member.popup_list_securefund&consumer_id=#attributes.consumer_id#','list');";
				}
			}
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?contract.list_contracts";
			if(isdefined("attributes.consumer_id") and len(attributes.consumer_id)){
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['bell']['text'] = '#getlang('','Uyarılar',57757)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['bell']['onClick'] = "window.open('#request.self#?fuseaction=objects.workflowpages&tab=3&action=contract.detail_contract_company&action_name=consumer_id&action_id=#attributes.consumer_id#','list');";
			}
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";
		}
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
</cfscript>