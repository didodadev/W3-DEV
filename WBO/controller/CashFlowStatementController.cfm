<cfsavecontent  variable="add"><cf_get_lang dictionary_id="54389.Gelir-gider ekle"></cfsavecontent>
<cfsavecontent  variable="list"><cf_get_lang dictionary_id="54388.Gelir-giderler"></cfsavecontent>
<cfscript>
	if(attributes.tabMenuController eq 0)
	{
		WOStruct = StructNew();
		
		WOStruct['#attributes.fuseaction#'] = structNew();	
		
		WOStruct['#attributes.fuseaction#']['default'] = 'detlist';
		if(not isdefined('attributes.event'))
			attributes.event = WOStruct['#attributes.fuseaction#']['default'];
	
		WOStruct['#attributes.fuseaction#']['detlist'] = structNew();
		WOStruct['#attributes.fuseaction#']['detlist']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['detlist']['fuseaction'] = 'finance.scenario';
		WOStruct['#attributes.fuseaction#']['detlist']['filePath'] = 'V16/finance/display/dsp_scenario_menu.cfm';
		WOStruct['#attributes.fuseaction#']['detlist']['js'] = "javascript:gizle_goster_ikili('finance_scenario','finance_scenario_bask');";		
	}
	else
	{
		fuseactController = caller.attributes.fuseaction;
		getLang = caller.getLang;
		
		tabMenuStruct = StructNew();
		tabMenuStruct['#fuseactController#'] = structNew();
		tabMenuStruct['#fuseactController#']['tabMenus'] = structNew();
		
			
		tabMenuStruct['#fuseactController#']['tabMenus']['detlist']['icons'] = structNew();
		tabMenuStruct['#fuseactController#']['tabMenus']['detlist']['icons']['add']['target'] = "_blank";
		tabMenuStruct['#fuseactController#']['tabMenus']['detlist']['icons']['add']['text'] = '#add#';
		tabMenuStruct['#fuseactController#']['tabMenus']['detlist']['icons']['add']['href'] = "#request.self#?fuseaction=finance.list_scen_expense&event=add";
		tabMenuStruct['#fuseactController#']['tabMenus']['detlist']['icons']['list-ul']['target'] = "_blank";
		tabMenuStruct['#fuseactController#']['tabMenus']['detlist']['icons']['list-ul']['text'] = '#list#';
		tabMenuStruct['#fuseactController#']['tabMenus']['detlist']['icons']['list-ul']['href'] = "#request.self#?fuseaction=finance.list_scen_expense";
		tabMenuStruct['#fuseactController#']['tabMenus']['detlist']['icons']['print']['text'] = '#getLang('main',62)#';
		tabMenuStruct['#fuseactController#']['tabMenus']['detlist']['icons']['print']['onClick'] = "printSa()";

	
		
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	
</cfscript>
