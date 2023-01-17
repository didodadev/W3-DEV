<cfscript>

	if(attributes.tabMenuController eq 0)
	{	
		WOStruct = StructNew();
		WOStruct['#attributes.fuseaction#'] = structNew();
		WOStruct['#attributes.fuseaction#']['default'] = 'list';
		
		WOStruct['#attributes.fuseaction#']['list'] = structNew();
		WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'account.list_bills_process_groups';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/account/display/list_bills_process_groups.cfm';
		
		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'popup';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'account.popup_form_add_bills_process_groups';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = '/V16/account/form/form_add_bills_process_group.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = '/V16/account/query/add_bill_process_group.cfm';
		WOStruct['#attributes.fuseaction#']['add']['formName'] = 'Add_Form_List_Bills';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'account.list_bills_process_groups&event=upd';
			
		if(isdefined("attributes.id"))
		{
			WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	  		WOStruct['#attributes.fuseaction#']['upd']['window'] = 'popup';
	  		WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'account.popup_form_upd_bill_process_grp';
	  		WOStruct['#attributes.fuseaction#']['upd']['filePath'] = '/V16/account/form/form_upd_bill_process_grp.cfm';
	  		WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = '/V16/account/query/upt_bills_process_group.cfm';
	  		WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'account.list_bills_process_groups&event=upd';
	  		WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.id#'; 
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
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=account.list_bills_process_groups";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";
		}
		else if(caller.attributes.event is 'upd')
		{
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('main',170)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['onClick'] = "windowopen('#request.self#?fuseaction=account.list_bills_process_groups&event=add','medium');";		
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=account.list_bills_process_groups";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";
			
		}
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	
	WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
	WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'BILLS_PROCESS_GROUP';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'PROCESS_TYPE_GROUP_ID';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-process_name','item-get_pro_cat']";
	
</cfscript>