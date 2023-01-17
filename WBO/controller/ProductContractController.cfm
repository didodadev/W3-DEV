<cfscript>
	if(attributes.tabMenuController eq 0)
	{
		WOStruct = StructNew();
		
		WOStruct['#attributes.fuseaction#'] = structNew();
		
		WOStruct['#attributes.fuseaction#']['default'] = 'upd';
		
		WOStruct['#attributes.fuseaction#']['upd'] = structNew();
		WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'product.popup_product_contract';
		WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'V16/product/display/product_contract.cfm';
		
	}
	
	else
	{
		fuseactController = caller.attributes.fuseaction;
		// Tab Menus //
		tabMenuStruct = StructNew();
		getLang = caller.getLang;
		
		tabMenuStruct['#fuseactController#'] = structNew();
		tabMenuStruct['#fuseactController#']['tabMenus'] = structNew();
	
			
        tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();
        tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('main',170)#';
        tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['onclick'] = "windowopen('#request.self#?fuseaction=product.popup_add_purchase_sales_condition&pid=#attributes.pid#','project');";
        
        tabMenuData = SerializeJSON(tabMenuStruct['#fuseactController#']['tabMenus']);
		
		
	}
</cfscript>