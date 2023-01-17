<cfscript>
	if(attributes.tabMenuController eq 0)
	{
		WOStruct = StructNew();
		
		WOStruct['#attributes.fuseaction#'] = structNew();	
		
		WOStruct['#attributes.fuseaction#']['default'] = 'add';
		if(not isdefined('attributes.event'))
			attributes.event = WOStruct['#attributes.fuseaction#']['default'];
	

	/*	WOStruct['#attributes.fuseaction#']['list']					= structNew();
		WOStruct['#attributes.fuseaction#']['list']['window']		= 'popup';
		WOStruct['#attributes.fuseaction#']['list']['fuseaction']	= 'retail.popup_make_process_action';
		WOStruct['#attributes.fuseaction#']['list']['filePath']		= '/WBP/Retail/files/form/make_process_action.cfm';
		WOStruct['#attributes.fuseaction#']['list']['queryPath']	= '/WBP/Retail/files/form/make_process_action.cfm';*/

		WOStruct['#attributes.fuseaction#']['add']					= structNew();
		WOStruct['#attributes.fuseaction#']['add']['window']		= 'popup';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction']	= 'retail.popup_make_process_action';
		WOStruct['#attributes.fuseaction#']['add']['filePath']		= '/WBP/Retail/files/form/make_process_action.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath']		= '/WBP/Retail/files/query/make_process_action.cfm';

		WOStruct['#attributes.fuseaction#']['upd']					= structNew();
		WOStruct['#attributes.fuseaction#']['upd']['window']		= 'popup';
		WOStruct['#attributes.fuseaction#']['upd']['fuseaction']	= 'retail.popup_make_process_action';
		WOStruct['#attributes.fuseaction#']['upd']['filePath']		= '/WBP/Retail/files/form/upd_make_process_action.cfm';
		WOStruct['#attributes.fuseaction#']['upd']['queryPath']		= '/WBP/Retail/files/query/upd_make_process_action.cfm';
		
		WOStruct['#attributes.fuseaction#']['delRow']					= structNew();
		WOStruct['#attributes.fuseaction#']['delRow']['window']		= 'popup';
		WOStruct['#attributes.fuseaction#']['delRow']['fuseaction']	= 'retail.popup_make_process_action';
		WOStruct['#attributes.fuseaction#']['delRow']['filePath']		= '/WBP/Retail/files/query/del_make_process_action.cfm';
		WOStruct['#attributes.fuseaction#']['delRow']['queryPath']		= '/WBP/Retail/files/query/del_make_process_action.cfm';
	
	}
	else {
	}
</cfscript>