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
		WOStruct['#attributes.fuseaction#']['list']['fuseaction']	= 'retail.popup_add_row_to_speed_manage_product_in';
		WOStruct['#attributes.fuseaction#']['list']['filePath']		= '/WBP/Retail/files/form/add_row_to_speed_manage_product_inner.cfm';	
		WOStruct['#attributes.fuseaction#']['list']['queryPath']	= '/WBP/Retail/files/form/add_row_to_speed_manage_product_inner.cfm';	

	
	}
	else {
	}
</cfscript>