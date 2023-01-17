<cfscript>
	if(attributes.tabMenuController eq 0)
	{
				// Switch //
		WOStruct = StructNew();
		
		WOStruct['#attributes.fuseaction#'] = structNew();	
		
		WOStruct['#attributes.fuseaction#']['default'] = 'add';
		if(not isdefined('attributes.event'))
			attributes.event = WOStruct['#attributes.fuseaction#']['default'];
				
		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'product.conditions';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = '/V16/product/form/product_conditions.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = '/V16/product/query/add_conditions.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'product.conditions';
		WOStruct['#attributes.fuseaction#']['add']['formName'] = 'search_product';
				
	}
	else
	{
		fuseactController = caller.attributes.fuseaction;
		getLang = caller.getLang;

		if(isDefined("attributes.form_varmi"))
		{
			page_code = caller.page_code;
			
			tabMenuStruct = StructNew();
			tabMenuStruct['#fuseactController#'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus'] = structNew();
			
			tabMenuStruct['#fuseactController#']['tabMenus']['add'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['print']['text'] = '#getLang('main',62)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['print']['onclick'] = "windowopen('#request.self#?fuseaction=product.popup_temp_conditions#page_code#&all_conditions=1','page')";
			tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
		}
	}
</cfscript>
