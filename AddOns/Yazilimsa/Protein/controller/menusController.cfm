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
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'protein.menus';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'AddOns/Yazilimsa/Protein/view/menus/formMenu.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = '';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'protein.menus&event=upd';

		WOStruct['#attributes.fuseaction#']['upd'] = structNew();
		WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'protein.menus';
		WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'AddOns/Yazilimsa/Protein/view/menus/formMenu.cfm';
		WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = '';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'protein.menus&event=upd';
		WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'site=##attributes.site##&menu=##attributes.menu##';

		WOStruct['#attributes.fuseaction#']['add_megamenu'] = structNew();
		WOStruct['#attributes.fuseaction#']['add_megamenu']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add_megamenu']['fuseaction'] = 'protein.menus';
		WOStruct['#attributes.fuseaction#']['add_megamenu']['filePath'] = 'AddOns/Yazilimsa/Protein/view/menus/formMegaMenu.cfm';
		WOStruct['#attributes.fuseaction#']['add_megamenu']['queryPath'] = '';
		WOStruct['#attributes.fuseaction#']['add_megamenu']['nextEvent'] = 'protein.menus&event=upd_megamenu';

		WOStruct['#attributes.fuseaction#']['upd_megamenu'] = structNew();
		WOStruct['#attributes.fuseaction#']['upd_megamenu']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['upd_megamenu']['fuseaction'] = 'protein.menus';
		WOStruct['#attributes.fuseaction#']['upd_megamenu']['filePath'] = 'AddOns/Yazilimsa/Protein/view/menus/formMegaMenu.cfm';
		WOStruct['#attributes.fuseaction#']['upd_megamenu']['queryPath'] = '';
		WOStruct['#attributes.fuseaction#']['upd_megamenu']['nextEvent'] = 'protein.menus&event=upd_megamenu';
		WOStruct['#attributes.fuseaction#']['upd_megamenu']['parameters'] = 'site=##attributes.site##&menu=##attributes.menu##&menu=##attributes.megamenu##';
	}
	else
	{
		fuseactController = caller.attributes.fuseaction;
		tabMenuStruct = StructNew();
        getLang = caller.getLang;
		


			tabMenuStruct['#fuseactController#']['tabMenus']['all']['icons']['add']['text'] = '#getLang('main',170)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['all']['icons']['add']['href'] = "#request.self#?fuseaction=protein.menus&event=add&site=#attributes.site#";
			tabMenuStruct['#fuseactController#']['tabMenus']['all']['icons']['add-on']['text'] = 'Widget';
			tabMenuStruct['#fuseactController#']['tabMenus']['all']['icons']['add-on']['href'] = "#request.self#?fuseaction=protein.widgets&site=#attributes.site#";
			i = 0;
			tabMenuStruct['#fuseactController#']['tabMenus']['all']['menus'][i]['text'] = 'Siteye Git';
			tabMenuStruct['#fuseactController#']['tabMenus']['all']['menus'][i]['href'] = "#request.self#?fuseaction=protein.site&event=upd&site=#attributes.site#";

		tabMenuData = SerializeJSON(tabMenuStruct['#fuseactController#']['tabMenus']);
	
	}
</cfscript>
