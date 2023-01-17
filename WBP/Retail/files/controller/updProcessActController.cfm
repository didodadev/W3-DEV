<cfscript>
	if(attributes.tabMenuController eq 0)
	{
		WOStruct = StructNew();
		
		WOStruct['#attributes.fuseaction#'] = structNew();	
		
		WOStruct['#attributes.fuseaction#']['default'] = 'upd';
		if(not isdefined('attributes.event'))
			attributes.event = WOStruct['#attributes.fuseaction#']['default'];


		WOStruct['#attributes.fuseaction#']['upd']					= structNew();
		WOStruct['#attributes.fuseaction#']['upd']['window']		= 'normal';
		WOStruct['#attributes.fuseaction#']['upd']['fuseaction']	= 'retail.emptypopup_upd_make_process_action';
		WOStruct['#attributes.fuseaction#']['upd']['filePath']		= '/WBP/Retail/files/query/upd_make_process_action.cfm';
		WOStruct['#attributes.fuseaction#']['upd']['queryPath']		= '/WBP/Retail/files/query/upd_make_process_action.cfm';

	
	}
	else {
	}
</cfscript>