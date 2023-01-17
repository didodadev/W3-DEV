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
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'protein.design_blocks';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'AddOns\Yazilimsa\Protein\view\design_blocks\designBlocks.cfm';

		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'protein.design_blocks';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'AddOns\Yazilimsa\Protein\view\design_blocks\formDesignBlocks.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = '';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'protein.design_blocks&event=upd';

		WOStruct['#attributes.fuseaction#']['upd'] = structNew();
		WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'protein.design_blocks';
		WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'AddOns\Yazilimsa\Protein\view\design_blocks\formDesignBlocks.cfm';
		WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = '';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'protein.design_blocks&event=upd';
		WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'design_block_id=##attributes.design_block_id##';
	}
	else
	{
		fuseactController = caller.attributes.fuseaction;
		tabMenuStruct = StructNew();
        getLang = caller.getLang;		
		if (caller.attributes.event is 'upd' or caller.attributes.event is 'add'){
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['sa fa fa-globe']['text'] = 'Sites';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['sa fa fa-globe']['href'] = "#request.self#?fuseaction=protein.site";

			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['sa fa fa-paint-brush']['text'] = '#getLang('main',65346)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['sa fa fa-paint-brush']['href'] = "#request.self#?fuseaction=protein.design_blocks";
		}else{
			tabMenuStruct['#fuseactController#']['tabMenus']['list']['icons']['sa fa fa-globe']['text'] = 'Sites';
			tabMenuStruct['#fuseactController#']['tabMenus']['list']['icons']['sa fa fa-globe']['href'] = "#request.self#?fuseaction=protein.site";
		}
		tabMenuData = SerializeJSON(tabMenuStruct['#fuseactController#']['tabMenus']);
	
	}
</cfscript>
