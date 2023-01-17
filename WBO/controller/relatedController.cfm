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
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'contract.list_related_contracts';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/contract/display/list_related_contracts.cfm';
	
		if(isdefined("attributes.contract_id"))
		{
			WOStruct['#attributes.fuseaction#']['upd'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'contract.popup_add_contract';
			WOStruct['#attributes.fuseaction#']['upd']['filePath'] = '/V16/contract/form/form_upd_contract.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = '/V16/contract/query/upd_contract.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.contract_id#';
			WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'contract.list_related_contracts&event=upd&contract_id=';

			WOStruct['#attributes.fuseaction#']['det'] = structNew();
			WOStruct['#attributes.fuseaction#']['det']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['det']['fuseaction'] = 'contract.popup_add_contract';
			WOStruct['#attributes.fuseaction#']['det']['filePath'] = '/V16/contract/form/form_det_contract.cfm';
			WOStruct['#attributes.fuseaction#']['det']['queryPath'] = '/V16/contract/query/det_contract.cfm';
			WOStruct['#attributes.fuseaction#']['det']['Identity'] = '#attributes.contract_id#';
			WOStruct['#attributes.fuseaction#']['det']['nextEvent'] = 'contract.list_related_contracts&event=det&contract_id=';
		} 
		
		if(IsDefined("attributes.event") && (attributes.event is 'upd' or attributes.event is 'del') and isdefined("attributes.contract_id"))
		{	
			WOStruct['#attributes.fuseaction#']['del'] = structNew();
			WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
			WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=contract.del&CONTRACT_ID=#attributes.CONTRACT_ID#&is_popup=1';
			WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16/invoice/query/delete_contract.cfm';
			WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/invoice/query/delete_contract.cfm';
			WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'invoice.list_related_contracts';
		}
		
		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'contract.popup_add_contract';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = '/V16/contract/form/form_add_contract.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = '/V16/contract/query/add_contract.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'contract.list_related_contracts&event=upd&contract_id=';
		WOStruct['#attributes.fuseaction#']['add']['formName'] = 'add_contract';
		
		WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
		WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'RELATED_CONTRACT';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'contract_id';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-contract_head','item-member_name','item-contract_cat_id','item-contract_no','item-start','item-finish']";
		
	}
	else
	{
		fuseactController = caller.attributes.fuseaction;
		// Tab Menus //
		tabMenuStruct = StructNew();
	
		tabMenuStruct['#fuseactController#'] = structNew();
		tabMenuStruct['#fuseactController#']['tabMenus'] = structNew();
		// Upd //
		if(isdefined("attributes.event") and attributes.event is 'upd')
		{
			getLang = caller.getLang;

			
			tabMenuStruct = StructNew();
			tabMenuStruct['#fuseactController#'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus'] = structNew();
				
//			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][1]['text'] = '#getLang('main',170)#';
//			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][1]['href'] = "#request.self#?fuseaction=contract.list_related_contracts&event=add";
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('main',170)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=contract.list_related_contracts&event=add";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['text'] = '#getLang('main',62)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['onClick'] = "window.open('#request.self#?fuseaction=objects.popup_print_files&action_id=#attributes.contract_id#','woc')";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_related_contracts";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";	
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-info-circle']['text'] = '#getLang('main',398)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-info-circle']['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_list_comp_add_info&info_id=#attributes.contract_id#&type_id=-21','list','cont')";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['bell']['text'] = '#getlang('main',345)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['bell']['onclick'] =  "window.open('#request.self#?fuseaction=objects.workflowpages&tab=3&action=#attributes.fuseaction#&action_name=contract_id&action_id=#attributes.contract_id#&wrkflow=1','Workflow')";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['detail']['text'] = '#getLang('main',359)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['detail']['href'] = "#request.self#?fuseaction=contract.list_related_contracts&event=det&contract_id=#attributes.contract_id#";	
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['history']['text'] = '#getLang('main',61)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['history']['customtag'] ="<cf_wrk_history act_type='8' act_id='#attributes.contract_id#' boxwidth='700' boxheight='800'>";			
			tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
		}
		else if(attributes.event is 'add')
		{
			getLang = caller.getLang;
			tabMenuStruct['#fuseactController#']['tabMenus']['add'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_related_contracts";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";	
			
			tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
		}
		else if(attributes.event is 'det')
		{
			getLang = caller.getLang;
			tabMenuStruct = StructNew();
			tabMenuStruct['#fuseactController#'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus'] = structNew();

			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['add']['text'] = '#getLang('main',170)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['add']['href'] = "#request.self#?fuseaction=contract.list_related_contracts&event=add";
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['print']['text'] = '#getLang('main',62)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['print']['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_print_files&action_id=#attributes.contract_id#&print_type=480','page')";
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['list-ul']['href'] = "#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_related_contracts";
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['fa fa-info-circle']['text'] = '#getLang('main',398)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['fa fa-info-circle']['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_list_comp_add_info&info_id=#attributes.contract_id#&type_id=-21','list','cont')";
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['bell']['text'] = '#getlang('main',345)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['bell']['onclick'] =  "window.open('#request.self#?fuseaction=objects.workflowpages&tab=3&action=#attributes.fuseaction#&action_name=contract_id&action_id=#attributes.contract_id#&wrkflow=1','Workflow')";
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['fa fa-pencil']['text'] = '#getLang('main',52,'güncelle')#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['fa fa-pencil']['href'] = "#request.self#?fuseaction=contract.list_related_contracts&event=upd&contract_id=#attributes.contract_id#";	
			
			tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
		
	}
</cfscript>
