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
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = '#listgetat(attributes.fuseaction,1,'.')#.list_emp_pdks';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/hr/display/list_emp_pdks.cfm';
		WOStruct['#attributes.fuseaction#']['list']['button'] = '0';
		
		WOStruct['#attributes.fuseaction#']['mail'] = structNew();
		WOStruct['#attributes.fuseaction#']['mail']['window'] = 'popup';
		WOStruct['#attributes.fuseaction#']['mail']['fuseaction'] = '#listgetat(attributes.fuseaction,1,'.')#.popup_send_pdks_mails';
		WOStruct['#attributes.fuseaction#']['mail']['filePath'] = 'V16/hr/display/send_pdks_mails.cfm';
		WOStruct['#attributes.fuseaction#']['mail']['queryPath'] = 'V16/hr/query/send_pdks_mails.cfm';
		WOStruct['#attributes.fuseaction#']['mail']['nextEvent'] = '#listgetat(attributes.fuseaction,1,'.')#.list_emp_pdks';	
	}
	else
	{
		fuseactController = caller.attributes.fuseaction;
		getLang = caller.getLang;
		
		tabMenuStruct = StructNew();
		tabMenuStruct['#fuseactController#'] = structNew();
		tabMenuStruct['#fuseactController#']['tabMenus'] = structNew();
		
		if(caller.attributes.event is 'mail')
		{			
			tabMenuStruct['#fuseactController#']['tabMenus']['mail']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['mail']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['mail']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['mail']['icons']['list-ul']['href'] = "#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_emp_pdks";
			tabMenuStruct['#fuseactController#']['tabMenus']['mail']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['mail']['icons']['check']['onClick'] = "buttonClickFunction()";
		}

		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
	WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'mail';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'EMPLOYEE_DAILY_IN_OUT_MAILS';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'ROW_ID';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-aktif_gun']";
</cfscript>
