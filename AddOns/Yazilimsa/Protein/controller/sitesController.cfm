<cfscript>
	// Switch //
	if(attributes.tabMenuController eq 0)
	{
		WOStruct = StructNew();
		
		WOStruct['#attributes.fuseaction#'] = structNew();
		
		WOStruct['#attributes.fuseaction#']['default'] = 'list';
		if(not isdefined('attributes.event')) attributes.event = 'list';

		WOStruct['#attributes.fuseaction#']['list'] = structNew();
		WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'protein.site';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'AddOns/Yazilimsa/Protein/view/sites/sites.cfm';

		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'protein.site';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'AddOns/Yazilimsa/Protein/view/sites/site.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = '';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'protein.site&event=upd';

		WOStruct['#attributes.fuseaction#']['upd'] = structNew();
		WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'protein.site';
		WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'AddOns/Yazilimsa/Protein/view/sites/site.cfm';
		WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = '';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'protein.site&event=upd';
		WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'site=##attributes.site##';
	}
	else
	{
		fuseactController = caller.attributes.fuseaction;
		tabMenuStruct = StructNew();
        getLang = caller.getLang;
		

		if (caller.attributes.event is 'upd'){
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('main',170)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=protein.site&event=add";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add-on']['text'] = 'Widget';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add-on']['href'] = "#request.self#?fuseaction=protein.widgets&site=#attributes.site#";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=protein.site";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['link']['text'] = 'Friendly URL';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['link']['href'] = "#request.self#?fuseaction=protein.friendly_url&site=#attributes.site#";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['link']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['sa fa fa-paint-brush']['text'] = '#getLang('main',65346)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['sa fa fa-paint-brush']['href'] = "#request.self#?fuseaction=protein.design_blocks";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['sa fa fa-paint-brush']['target'] = "_blank";
        }else{
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=protein.site";
		}

		tabMenuData = SerializeJSON(tabMenuStruct['#fuseactController#']['tabMenus']);
	
	}
</cfscript>
