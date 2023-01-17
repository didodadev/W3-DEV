<cfscript>
	// Switch //
	if(attributes.tabMenuController eq 0)
	{
		WOStruct = StructNew();
		
		WOStruct['#attributes.fuseaction#'] = structNew();
		
		WOStruct['#attributes.fuseaction#']['default'] = 'upd';
		if(not isdefined('attributes.event')) attributes.event = 'upd';

		WOStruct['#attributes.fuseaction#']['upd'] = structNew();
		WOStruct['#attributes.fuseaction#']['upd']['window'] = 'popup';
		WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'protein.code_editor&isajax=1';
		WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'AddOns\Yazilimsa\Protein\view\code_editor\protein_code_editor.cfm';
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
