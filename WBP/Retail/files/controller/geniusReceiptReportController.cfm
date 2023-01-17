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
		WOStruct['#attributes.fuseaction#']['list']['fuseaction']	= 'retail.genius_fis';
		WOStruct['#attributes.fuseaction#']['list']['filePath']		= '/WBP/Retail/files/report/genius_fis.cfm';
		WOStruct['#attributes.fuseaction#']['list']['queryPath']	= '/WBP/Retail/files/report/genius_fis.cfm';

		WOStruct['#attributes.fuseaction#']['upd']					= structNew();
		WOStruct['#attributes.fuseaction#']['upd']['window']		= 'popup';
		WOStruct['#attributes.fuseaction#']['upd']['fuseaction']	= 'retail.genius_fis';
		WOStruct['#attributes.fuseaction#']['upd']['filePath']		= '/WBP/Retail/files/form/update_fis.cfm';
        WOStruct['#attributes.fuseaction#']['upd']['queryPath']		= '/WBP/Retail/files/query/update_fis.cfm';
		WOStruct['#attributes.fuseaction#']['upd']['nextEvent']     = 'retail.genius_fis&event=upd&action_id=';
		WOStruct['#attributes.fuseaction#']['upd']['parameters']    = 'action_id=##attributes.action_id##';
		if(isdefined("attributes.action_id"))
			WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.action_id#';		
	
	}
	else {
	}
</cfscript>