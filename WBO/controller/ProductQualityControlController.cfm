
<cfsavecontent variable="detail"><cf_get_lang dictionary_id="33929.Ürün Detay"></cfsavecontent>

	<cfscript>
	
	if(attributes.tabMenuController eq 0)
	{
		WOStruct = StructNew();
		
		WOStruct['#attributes.fuseaction#'] = structNew();
		
		WOStruct['#attributes.fuseaction#']['default'] = 'det';
		
		WOStruct['#attributes.fuseaction#']['det'] = structNew();
		WOStruct['#attributes.fuseaction#']['det']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['det']['fuseaction'] = 'product.product_quality';
        WOStruct['#attributes.fuseaction#']['det']['filePath'] = 'V16/product/display/popup_product_quality.cfm';
		WOStruct['#attributes.fuseaction#']['det']['Identity'] = '#attributes.pid#';
		
	}
	else
	{
		fuseactController = caller.attributes.fuseaction;
		// Tab Menus //
		tabMenuStruct = StructNew();
		getLang = caller.getLang;
		
		tabMenuStruct['#fuseactController#'] = structNew();
		tabMenuStruct['#fuseactController#']['tabMenus'] = structNew();
	
			
        tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons'] = structNew();
        tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['detail']['text'] = '#detail#';
        tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['detail']['href'] = "#request.self#?fuseaction=product.list_product&event=det&pid=#attributes.pid#";
		tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['print']['text'] = '#getLang('','Yazdır','57474')#';
		tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['print']['target'] = 'blank_';
        tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['print']['href'] = "#request.self#?fuseaction=objects.popup_print_files&id=#attributes.pid#&print_type=371";
		
        tabMenuData = SerializeJSON(tabMenuStruct['#fuseactController#']['tabMenus']);
		
		
	}
</cfscript>