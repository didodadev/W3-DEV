<cfscript>
	// Switch //
	if(attributes.tabMenuController eq 0)
	{
		WOStruct = StructNew();
		
		WOStruct['#attributes.fuseaction#'] = structNew();
		
		WOStruct['#attributes.fuseaction#']['default'] = 'add';
		if(not isdefined('attributes.event')) attributes.event = 'add';


		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'protein.templates';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'AddOns/Yazilimsa/Protein/view/templates/formTemplate.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = '';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'protein.templates&event=upd';

		WOStruct['#attributes.fuseaction#']['upd'] = structNew();
		WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'protein.templates';
		WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'AddOns/Yazilimsa/Protein/view/templates/formTemplate.cfm';
		WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = '';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'protein.templates&event=upd';
		WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'site=##attributes.site##&template=##attributes.template##';
	}
	else
	{
		fuseactController = caller.attributes.fuseaction;
		tabMenuStruct = StructNew();
        getLang = caller.getLang;
		
			tabMenuStruct['#fuseactController#']['tabMenus']['all']['icons']['add']['text'] = '#getLang('main',170)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['all']['icons']['add']['href'] = "#request.self#?fuseaction=protein.templates&event=add&site=#attributes.site#";
			tabMenuStruct['#fuseactController#']['tabMenus']['all']['icons']['add-on']['text'] = 'Widget';
			tabMenuStruct['#fuseactController#']['tabMenus']['all']['icons']['add-on']['href'] = "#request.self#?fuseaction=protein.widgets&site=#attributes.site#";
			i = 0;
			tabMenuStruct['#fuseactController#']['tabMenus']['all']['menus'][i]['text'] = 'Siteye Git';
			tabMenuStruct['#fuseactController#']['tabMenus']['all']['menus'][i]['href'] = "#request.self#?fuseaction=protein.site&event=upd&site=#attributes.site#";
     

		tabMenuData = SerializeJSON(tabMenuStruct['#fuseactController#']['tabMenus']);
	
	}
</cfscript>
