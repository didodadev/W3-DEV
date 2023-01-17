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
		WOStruct['#attributes.fuseaction#']['list']['fuseaction']	= 'retail.price_types';
		WOStruct['#attributes.fuseaction#']['list']['filePath']		= '/WBP/Retail/files/display/price_types.cfm';
		WOStruct['#attributes.fuseaction#']['list']['queryPath']	= '/WBP/Retail/files/display/price_types.cfm';

		WOStruct['#attributes.fuseaction#']['add']					= structNew();
		WOStruct['#attributes.fuseaction#']['add']['window']		= 'popup';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction']	= 'retail.price_types';
		WOStruct['#attributes.fuseaction#']['add']['filePath']		= '/WBP/Retail/files/form/upd_price_type.cfm';
        WOStruct['#attributes.fuseaction#']['add']['queryPath']		= '/WBP/Retail/files/query/upd_price_type.cfm';
		WOStruct['#attributes.fuseaction#']['upd']['nextEvent']     = 'retail.price_types&event=upd&pos_id=';

		WOStruct['#attributes.fuseaction#']['upd']					= structNew();
		WOStruct['#attributes.fuseaction#']['upd']['window']		= 'popup';
		WOStruct['#attributes.fuseaction#']['upd']['fuseaction']	= 'retail.price_types';
		WOStruct['#attributes.fuseaction#']['upd']['filePath']		= '/WBP/Retail/files/form/upd_price_type.cfm';
        WOStruct['#attributes.fuseaction#']['upd']['queryPath']		= '/WBP/Retail/files/query/upd_price_type.cfm';
		WOStruct['#attributes.fuseaction#']['upd']['nextEvent']     = 'retail.price_types&event=upd&type_id=';
		WOStruct['#attributes.fuseaction#']['upd']['parameters']    = 'type_id=##attributes.type_id##';
		if(isdefined("attributes.type_id"))
			WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.type_id#';

		
	
	}
	else {
	}
</cfscript>