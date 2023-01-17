<cfscript>
	if(attributes.tabMenuController eq 0)
	{
		WOStruct = StructNew();
		
		WOStruct['#attributes.fuseaction#'] = structNew();	
		
		WOStruct['#attributes.fuseaction#']['default'] = 'list';
		if(not isdefined('attributes.event'))
			attributes.event = WOStruct['#attributes.fuseaction#']['default'];

		WOStruct['#attributes.fuseaction#']['list'] = structNew();
		WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'account.product_cost_rate_paper';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = '/V16/account/display/product_cost_rate_paper.cfm';

		if(isdefined("attributes.expense_id"))
		{
			WOStruct['#attributes.fuseaction#']['report'] = structNew();
			WOStruct['#attributes.fuseaction#']['report']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['report']['fuseaction'] = 'report.cost_analyse_report';
			WOStruct['#attributes.fuseaction#']['report']['filePath'] = '/V16/report/standart/cost_analyse_report.cfm';
			WOStruct['#attributes.fuseaction#']['report']['queryPath'] = '/V16/report/standart/cost_analyse_report.cfm';
			WOStruct['#attributes.fuseaction#']['report']['Identity'] = '#attributes.expense_id#';
			WOStruct['#attributes.fuseaction#']['report']['nextEvent'] = 'report.cost_analyse_report';
			WOStruct['#attributes.fuseaction#']['report']['js'] = "javascript:gizle_goster_ikili('analyse_report','analyse_report_bask');";
		}				
	}
	else
	{
		fuseactController = caller.attributes.fuseaction;
		getLang = caller.getLang;
		
		tabMenuStruct = StructNew();
		tabMenuStruct['#fuseactController#'] = structNew();
		tabMenuStruct['#fuseactController#']['tabMenus'] = structNew();
			
		if(attributes.event is 'report')
		{			
			tabMenuStruct['#fuseactController#']['tabMenus']['report']['icons'] = structNew();					
			tabMenuStruct['#fuseactController#']['tabMenus']['report']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['report']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['report']['icons']['list-ul']['href'] = "#request.self#?fuseaction=account.product_cost_rate_paper";
			tabMenuStruct['#fuseactController#']['tabMenus']['report']['icons']['fileAction']['text'] = '';
			tabMenuStruct['#fuseactController#']['tabMenus']['report']['icons']['fileAction']['customTag'] = "<cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'>";
		}
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
</cfscript>
