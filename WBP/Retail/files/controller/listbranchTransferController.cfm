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
		WOStruct['#attributes.fuseaction#']['list']['fuseaction']	= 'retail.transfer_branch_list';
		WOStruct['#attributes.fuseaction#']['list']['filePath']		= '/WBP/Retail/files/display/transfer_branch_list.cfm';
		WOStruct['#attributes.fuseaction#']['list']['queryPath']	= '/WBP/Retail/files/form/transfer_branch2.cfm';

		if(isdefined("attributes.row_id"))
		{
			WOStruct['#attributes.fuseaction#']['del'] = structNew();
			WOStruct['#attributes.fuseaction#']['del']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'retail.transfer_branch_list&row_id=#attributes.row_id#';
			WOStruct['#attributes.fuseaction#']['del']['filePath'] = '/WBP/Retail/files/objects/query/del_transfer_stock.cfm';
			WOStruct['#attributes.fuseaction#']['del']['queryPath'] = '/WBP/Retail/files/objects/query/del_transfer_stock.cfm';
			WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'retail.transfer_branch_list';
		}

		if(isdefined("attributes.department_id"))
		{
			WOStruct['#attributes.fuseaction#']['del'] = structNew();
			WOStruct['#attributes.fuseaction#']['del']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'retail.transfer_branch_list&department_id=#attributes.department_id#';
			WOStruct['#attributes.fuseaction#']['del']['filePath'] = '/WBP/Retail/files/objects/query/del_transfer_stock.cfm';
			WOStruct['#attributes.fuseaction#']['del']['queryPath'] = '/WBP/Retail/files/objects/query/del_transfer_stock.cfm';
			WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'retail.transfer_branch_list';
		}
	
	}
	else {
	}
</cfscript>