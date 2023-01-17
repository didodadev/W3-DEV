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
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'protein.pages';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'AddOns/Yazilimsa/Protein/view/pages/formPage.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = '';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'protein.templates&event=upd';

		WOStruct['#attributes.fuseaction#']['upd'] = structNew();
		WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'protein.pages';
		WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'AddOns/Yazilimsa/Protein/view/pages/formPage.cfm';
		WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = '';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'protein.pages&event=upd';
		WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'site=##attributes.site##&page=##attributes.##';

		WOStruct['#attributes.fuseaction#']['denied'] = structNew();
		WOStruct['#attributes.fuseaction#']['denied']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['denied']['fuseaction'] = 'protein.pages';
		WOStruct['#attributes.fuseaction#']['denied']['filePath'] = 'AddOns/Yazilimsa/Protein/view/pages/formPageDenied.cfm';
		WOStruct['#attributes.fuseaction#']['denied']['queryPath'] = '';
		WOStruct['#attributes.fuseaction#']['denied']['nextEvent'] = 'protein.pages&event=denied';
		WOStruct['#attributes.fuseaction#']['denied']['parameters'] = 'site=##attributes.site##&page=##attributes.##';
		
	}
	else
	{
		fuseactController = caller.attributes.fuseaction;
		tabMenuStruct = StructNew();
        getLang = caller.getLang;
		


			tabMenuStruct['#fuseactController#']['tabMenus']['all']['icons']['add']['text'] = '#getLang('main',170)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['all']['icons']['add']['href'] = "#request.self#?fuseaction=protein.pages&event=add&site=#attributes.site#";
			tabMenuStruct['#fuseactController#']['tabMenus']['all']['icons']['add-on']['text'] = 'Widget';
			tabMenuStruct['#fuseactController#']['tabMenus']['all']['icons']['add-on']['href'] = "#request.self#?fuseaction=protein.widgets&site=#attributes.site#";
			i = 0;
			tabMenuStruct['#fuseactController#']['tabMenus']['all']['menus'][i]['text'] = 'Siteye Git';
			tabMenuStruct['#fuseactController#']['tabMenus']['all']['menus'][i]['href'] = "#request.self#?fuseaction=protein.site&event=upd&site=#attributes.site#";

     

		tabMenuData = SerializeJSON(tabMenuStruct['#fuseactController#']['tabMenus']);
	
	}
</cfscript>
