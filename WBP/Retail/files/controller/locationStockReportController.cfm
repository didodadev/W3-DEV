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
		WOStruct['#attributes.fuseaction#']['list']['fuseaction']	= 'retail.depo_stock_report';
		WOStruct['#attributes.fuseaction#']['list']['filePath']		= '/WBP/Retail/files/report/depo_stock_report.cfm';
        WOStruct['#attributes.fuseaction#']['list']['queryPath']	= '/WBP/Retail/files/report/depo_stock_report.cfm';

		WOStruct['#attributes.fuseaction#']['ReportCat']					= structNew();
		WOStruct['#attributes.fuseaction#']['ReportCat']['window']			= 'normal';
		WOStruct['#attributes.fuseaction#']['ReportCat']['fuseaction']		= 'retail.depo_stock_report';
		WOStruct['#attributes.fuseaction#']['ReportCat']['filePath']		= '/WBP/Retail/files/report/depo_stock_product_report.cfm';
        WOStruct['#attributes.fuseaction#']['ReportCat']['queryPath']		= '/WBP/Retail/files/report/depo_stock_product_report.cfm';
		
	
	}
	else {
	}
</cfscript>