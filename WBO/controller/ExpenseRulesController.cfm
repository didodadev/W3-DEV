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
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'ehesap.list_expense_rules';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = '/V16/hr/ehesap/form/add_expense_rules_form.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'ehesap.list_expense_rules';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = '/V16/hr/ehesap/cfc/expense_rules.cfc';

		WOStruct['#attributes.fuseaction#']['upd'] = structNew();
		WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'ehesap.list_expense_rules';
		WOStruct['#attributes.fuseaction#']['upd']['filePath'] = '/V16/hr/ehesap/form/upd_expense_rules_form.cfm';
		WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'ehesap.list_expense_rules';
		WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = '/V16/hr/ehesap/cfc/expense_rules.cfm';
	}
		else
		{
			fuseactController = caller.attributes.fuseaction;
			getLang = caller.getLang;
			
			tabMenuStruct = StructNew();
			tabMenuStruct['#fuseactController#'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus'] = structNew();

			
		}						
</cfscript>

