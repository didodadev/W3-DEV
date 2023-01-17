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
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'finance.form_add_cheque_exp';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/finance/display/add_cheque_exp.cfm';
		
	
		WOStruct['#attributes.fuseaction#']['add_cash'] = structNew();
		WOStruct['#attributes.fuseaction#']['add_cash']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add_cash']['fuseaction'] = 'finance.form_add_cheque_cash_exp';
		WOStruct['#attributes.fuseaction#']['add_cash']['filePath'] = 'V16/finance/form/add_cheque_cash_exp.cfm';
		WOStruct['#attributes.fuseaction#']['add_cash']['querypath'] = 'V16/finance/query/add_cheque_cash_exp.cfm';
		WOStruct['#attributes.fuseaction#']['add_cash']['nextEvent'] = 'finance.form_add_cheque_exp';
		
		WOStruct['#attributes.fuseaction#']['add_bank'] = structNew();
		WOStruct['#attributes.fuseaction#']['add_bank']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add_bank']['fuseaction'] = 'finance.form_add_cheque_bank_exp';
		WOStruct['#attributes.fuseaction#']['add_bank']['filePath'] = 'V16/finance/form/add_cheque_bank_exp.cfm';
		WOStruct['#attributes.fuseaction#']['add_bank']['querypath'] = 'V16/finance/query/add_cheque_bank_exp.cfm';
		WOStruct['#attributes.fuseaction#']['add_bank']['nextEvent'] = 'finance.form_add_cheque_exp';
		
		WOStruct['#attributes.fuseaction#']['add_payment'] = structNew();
		WOStruct['#attributes.fuseaction#']['add_payment']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add_payment']['fuseaction'] = 'finance.form_add_cheque_payment_exp';
		WOStruct['#attributes.fuseaction#']['add_payment']['filePath'] = 'V16/finance/form/add_cheque_payment_exp.cfm';
		WOStruct['#attributes.fuseaction#']['add_payment']['querypath'] = 'V16/finance/query/add_cheque_payment_exp.cfm';
		WOStruct['#attributes.fuseaction#']['add_payment']['nextEvent'] = 'finance.form_add_cheque_exp';
	}
	
	else
	{
		fuseactController = caller.attributes.fuseaction;
		getLang = caller.getLang;
		
		tabMenuStruct = StructNew();
		tabMenuStruct['#fuseactController#'] = structNew();
		tabMenuStruct['#fuseactController#']['tabMenus'] = structNew();
		
		if(caller.attributes.event is 'add_cash')
		{			
			tabMenuStruct['#fuseactController#']['tabMenus']['add_cash']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['add_cash']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['add_cash']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add_cash']['icons']['list-ul']['href'] = "#request.self#?fuseaction=finance.form_add_cheque_exp";
			tabMenuStruct['#fuseactController#']['tabMenus']['add_cash']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add_cash']['icons']['check']['onClick'] = "buttonClickFunction()";
		}
		else if(caller.attributes.event is 'add_bank')
		{
			tabMenuStruct['#fuseactController#']['tabMenus']['add_bank']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['add_bank']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['add_bank']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add_bank']['icons']['list-ul']['href'] = "#request.self#?fuseaction=finance.form_add_cheque_exp";
			tabMenuStruct['#fuseactController#']['tabMenus']['add_bank']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add_bank']['icons']['check']['onClick'] = "buttonClickFunction()";
		}
		else if(caller.attributes.event is 'add_payment')
		{
			tabMenuStruct['#fuseactController#']['tabMenus']['add_payment']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['add_payment']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['add_payment']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add_payment']['icons']['list-ul']['href'] = "#request.self#?fuseaction=finance.form_add_cheque_exp";
			tabMenuStruct['#fuseactController#']['tabMenus']['add_payment']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add_payment']['icons']['check']['onClick'] = "buttonClickFunction()";
		}
		else if(caller.attributes.event is 'add_giro')
		{
			tabMenuStruct['#fuseactController#']['tabMenus']['add_giro']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['add_giro']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['add_giro']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add_giro']['icons']['list-ul']['href'] = "#request.self#?fuseaction=finance.form_add_cheque_exp";
			tabMenuStruct['#fuseactController#']['tabMenus']['add_giro']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add_giro']['icons']['check']['onClick'] = "buttonClickFunction()";
		}
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
</cfscript>

