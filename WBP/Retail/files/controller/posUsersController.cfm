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
		WOStruct['#attributes.fuseaction#']['list']['fuseaction']	= 'retail.list_pos_users';
		WOStruct['#attributes.fuseaction#']['list']['filePath']		= '/WBP/Retail/files/display/list_pos_users.cfm';
        WOStruct['#attributes.fuseaction#']['list']['queryPath']	= '/WBP/Retail/files/display/list_pos_users.cfm';	

		WOStruct['#attributes.fuseaction#']['add']					= structNew();
		WOStruct['#attributes.fuseaction#']['add']['window']		= 'popup';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction']	= 'retail.list_pos_users';
		WOStruct['#attributes.fuseaction#']['add']['filePath']		= '/WBP/Retail/files/form/add_pos_user.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath']		= '/WBP/Retail/files/query/add_pos_user.cfm';
		WOStruct['#attributes.fuseaction#']['add']['parameters']    = 'branch_id=##attributes.branch_id##';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent']     = 'retail.list_pos_users&event=upd&row_id=';

		WOStruct['#attributes.fuseaction#']['upd']					= structNew();
		WOStruct['#attributes.fuseaction#']['upd']['window']		= 'popup';
		WOStruct['#attributes.fuseaction#']['upd']['fuseaction']	= 'retail.list_pos_users';
		WOStruct['#attributes.fuseaction#']['upd']['filePath']		= '/WBP/Retail/files/form/upd_pos_user.cfm';
        WOStruct['#attributes.fuseaction#']['upd']['queryPath']		= '/WBP/Retail/files/query/upd_pos_user.cfm';
		WOStruct['#attributes.fuseaction#']['upd']['nextEvent']     = 'retail.list_pos_users&event=upd&row_id=';
		WOStruct['#attributes.fuseaction#']['upd']['parameters']    = 'branch_id=##attributes.branch_id##&row_id=##attributes.row_id##';
		if(isdefined("attributes.row_id"))
			WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.row_id#';
		if(attributes.event is 'upd' or attributes.event is 'del'){
			WOStruct['#attributes.fuseaction#']['del']					= structNew();
			WOStruct['#attributes.fuseaction#']['del']['window']		= 'normal';
			WOStruct['#attributes.fuseaction#']['del']['fuseaction']	= 'retail.list_pos_users';
			WOStruct['#attributes.fuseaction#']['del']['filePath']		= '/WBP/Retail/files/query/del_pos_user.cfm';
			WOStruct['#attributes.fuseaction#']['del']['queryPath']		= '/WBP/Retail/files/query/del_pos_user.cfm';
			WOStruct['#attributes.fuseaction#']['del']['nextEvent']     = 'retail.list_pos_users';
		}
	}
	else {
		
		
	}
</cfscript>