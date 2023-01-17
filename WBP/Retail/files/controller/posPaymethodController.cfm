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
		WOStruct['#attributes.fuseaction#']['list']['fuseaction']	= 'retail.list_pos_pay_methods';
		WOStruct['#attributes.fuseaction#']['list']['filePath']		= '/WBP/Retail/files/display/list_pos_pay_methods.cfm';
        WOStruct['#attributes.fuseaction#']['list']['queryPath']	= '/WBP/Retail/files/display/list_pos_pay_methods.cfm';	

		WOStruct['#attributes.fuseaction#']['add']					= structNew();
		WOStruct['#attributes.fuseaction#']['add']['window']		= 'popup';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction']	= 'retail.list_pos_pay_methods';
		WOStruct['#attributes.fuseaction#']['add']['filePath']		= '/WBP/Retail/files/form/add_pos_pay_method.cfm';
        WOStruct['#attributes.fuseaction#']['add']['queryPath']		= '/WBP/Retail/files/query/add_pos_pay_method.cfm';
		WOStruct['#attributes.fuseaction#']['upd']['nextEvent']     = 'retail.list_pos_pay_methods&event=upd&row_id=';

		WOStruct['#attributes.fuseaction#']['upd']					= structNew();
		WOStruct['#attributes.fuseaction#']['upd']['window']		= 'popup';
		WOStruct['#attributes.fuseaction#']['upd']['fuseaction']	= 'retail.list_pos_pay_methods';
		WOStruct['#attributes.fuseaction#']['upd']['filePath']		= '/WBP/Retail/files/form/upd_pos_pay_method.cfm';
        WOStruct['#attributes.fuseaction#']['upd']['queryPath']		= '/WBP/Retail/files/query/upd_pos_pay_method.cfm';
		WOStruct['#attributes.fuseaction#']['upd']['nextEvent']     = 'retail.list_pos_pay_methods&event=upd&row_id=';
		WOStruct['#attributes.fuseaction#']['upd']['parameters']    = 'row_id=##attributes.row_id##';
		if(isdefined("attributes.row_id"))
			WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.row_id#';

		WOStruct['#attributes.fuseaction#']['copy']					= structNew();
		WOStruct['#attributes.fuseaction#']['copy']['window']		= 'popup';
		WOStruct['#attributes.fuseaction#']['copy']['fuseaction']	= 'retail.list_pos_pay_methods';
		WOStruct['#attributes.fuseaction#']['copy']['filePath']		= '/WBP/Retail/files/form/copy_pos_pay_method.cfm';
        WOStruct['#attributes.fuseaction#']['copy']['queryPath']		= '/WBP/Retail/files/query/copy_pos_pay_method.cfm';
		WOStruct['#attributes.fuseaction#']['copy']['nextEvent']     = 'retail.list_pos_pay_methods&event=copy&row_id=';
		WOStruct['#attributes.fuseaction#']['copy']['parameters']    = 'row_id=##attributes.row_id##';
		if(isdefined("attributes.row_id"))
			WOStruct['#attributes.fuseaction#']['copy']['Identity'] = '#attributes.row_id#';
	
	}
	else {
	}
</cfscript>