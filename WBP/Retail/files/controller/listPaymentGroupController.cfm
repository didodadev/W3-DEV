<cfscript>
	if(attributes.tabMenuController eq 0)
	{
		WOStruct = StructNew();
		
		WOStruct['#attributes.fuseaction#'] = structNew();	
		WOStruct['#attributes.fuseaction#']['default'] = 'list';
		if(not isdefined('attributes.event'))
			attributes.event = WOStruct['#attributes.fuseaction#']['default'];
	

		WOStruct['#attributes.fuseaction#']['list']					= structNew();
		WOStruct['#attributes.fuseaction#']['list']['window']		= 'normal';
		WOStruct['#attributes.fuseaction#']['list']['fuseaction']	= 'retail.list_payment_group';
		WOStruct['#attributes.fuseaction#']['list']['filePath']		= '/WBP/Retail/files/display/list_payment_group.cfm';
		WOStruct['#attributes.fuseaction#']['list']['queryPath']	= '/WBP/Retail/files/display/list_payment_group.cfm';

		WOStruct['#attributes.fuseaction#']['add']					= structNew();
		WOStruct['#attributes.fuseaction#']['add']['window']		= 'popup';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction']	= 'retail.list_payment_group';
		WOStruct['#attributes.fuseaction#']['add']['filePath']		= '/WBP/Retail/files/form/add_payment_group.cfm';
        WOStruct['#attributes.fuseaction#']['add']['queryPath']		= '/WBP/Retail/files/query/add_payment_group.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent']     = 'retail.list_payment_group&event=upd&pos_id=';

		WOStruct['#attributes.fuseaction#']['upd']					= structNew();
		WOStruct['#attributes.fuseaction#']['upd']['window']		= 'popup';
		WOStruct['#attributes.fuseaction#']['upd']['fuseaction']	= 'retail.list_payment_group';
		WOStruct['#attributes.fuseaction#']['upd']['filePath']		= '/WBP/Retail/files/form/upd_payment_group.cfm';
        WOStruct['#attributes.fuseaction#']['upd']['queryPath']		= '/WBP/Retail/files/query/upd_payment_group.cfm';
		WOStruct['#attributes.fuseaction#']['upd']['nextEvent']     = 'retail.list_payment_group&event=upd&is_form_submitted=1&group_id=';
		WOStruct['#attributes.fuseaction#']['upd']['parameters']    = 'group_id=##attributes.group_id##';
		if(isdefined("attributes.group_id"))
			WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.group_id#';
	
		if(listFind('upd,del',attributes.event))
			{
				WOStruct['#attributes.fuseaction#']['del'] = structNew();
				WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
				WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=retail.emptypopup_del_payment_group&group_id=#attributes.group_id#';
				WOStruct['#attributes.fuseaction#']['del']['filePath'] = '/WBP/Retail/files/query/del_payment_group.cfm';
				WOStruct['#attributes.fuseaction#']['del']['queryPath'] = '/WBP/Retail/files/query/del_payment_group.cfm';
				WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'bank.list_payment_group';
			}
	}
	else {
	}
</cfscript>