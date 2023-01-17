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
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'account.add_acc_to_acc';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/account/form/add_acc_to_acc.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = '/V16/account/query/add_acc_to_acc.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = '';
	
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
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";
		}
		
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	
	WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
	WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'ACCOUNT_PLAN';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'ACCOUNT_ID';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-ACTION_DATE','item-START_DATE','item-FINISH_DATE','item-FROM_ACC_NAME','item-TO_ACC_NAME']";
	
</cfscript>

