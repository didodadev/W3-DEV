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
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'purchase.add_order_product_all_criteria';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/purchase/form/give_order_product_criteria.cfm';	

	}else{

		getLang = caller.getLang;

		if( isDefined('attributes.select_order_demand') and attributes.select_order_demand eq 0 ){

			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['list'] = structNew();
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['list']['menus'] = structNew();

			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['list']['menus'][0]['text'] = '#getLang('','Toplu Sipariş', 38614)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['list']['menus'][0]['href'] = "#request.self#?fuseaction=purchase.add_order_product_all_criteria";

			tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
		}
	}
</cfscript>