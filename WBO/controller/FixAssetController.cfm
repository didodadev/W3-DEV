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
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'invent.list_inventory';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/inventory/display/list_inventory.cfm';	
				
		if(isdefined("attributes.inventory_id"))
		{
			WOStruct['#attributes.fuseaction#']['det'] = structNew();
			WOStruct['#attributes.fuseaction#']['det']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['det']['fuseaction'] = 'invent.detail_invent';
			WOStruct['#attributes.fuseaction#']['det']['filePath'] = 'V16/inventory/display/detail_invent.cfm';
			WOStruct['#attributes.fuseaction#']['det']['Identity'] = '#attributes.inventory_id#';
		}
		
			if(IsDefined("attributes.event") && (attributes.event is 'det' || attributes.event is 'del'))
			{
				WOStruct['#attributes.fuseaction#']['del'] = structNew();
				WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
				WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=invent.emptypopup_del_invent&inventory_id=#attributes.inventory_id#';
				WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16/inventory/query/del_invent.cfm';
				WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/inventory/query/del_invent.cfm';
				WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'invent.list_inventory';
			}
			WOStruct['#attributes.fuseaction#']['to_asset'] = structNew();
			WOStruct['#attributes.fuseaction#']['to_asset']['window'] = 'popup';
			WOStruct['#attributes.fuseaction#']['to_asset']['fuseaction'] = 'invent.popup_add_inventory_stock_to_asset';
			WOStruct['#attributes.fuseaction#']['to_asset']['filePath'] = 'V16/inventory/form/add_inventory_stock_to_asset.cfm';
			WOStruct['#attributes.fuseaction#']['to_asset']['queryPath'] = 'V16/inventory/query/add_inventory_stock_to_asset.cfm';
			WOStruct['#attributes.fuseaction#']['to_asset']['nextEvent'] = '';
	}
	else
	{
		fuseactController = caller.attributes.fuseaction;
		getLang = caller.getLang;
		
		
		tabMenuStruct = StructNew();
		tabMenuStruct['#fuseactController#'] = structNew();
		tabMenuStruct['#fuseactController#']['tabMenus'] = structNew();
		
		if(caller.attributes.event is 'to_asset')
		{	
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['list-ul']['href'] = "#request.self#?fuseaction=invent.list_inventory";
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['check']['onClick'] = "buttonClickFunction()";
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['print']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['print']['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_print_files&action_id=#attributes.inventory_id#&print_type=351','page');";
		}
		
		if(caller.attributes.event is 'det')
		{			
			get_invent = caller.get_invent;
			get_module_user = caller.get_module_user;
			get_asset_type = caller.get_asset_type;
			
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons'] = structNew();
			
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['print']['text'] = '#getLang('main',62)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['print']['onClick'] = "window.open('#request.self#?fuseaction=objects.popup_print_files&action_id=#attributes.inventory_id#','woc');";
			
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['list-ul']['href'] = "#request.self#?fuseaction=invent.list_inventory";
			
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['bell']['text'] = '#getLang('main',345)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['bell']['onclick'] = "window.open('#request.self#?fuseaction=objects.workflowpages&tab=3&action=#attributes.fuseaction#&action_name=inventory_id&action_id=#attributes.inventory_id#','Workflow')";
			
			
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][0]['text'] = '#getLang('invent',45)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][0]['onclick'] = "openBoxDraggable('#request.self#?fuseaction=invent.list_inventory&event=to_asset&inventory_id=#attributes.inventory_id#&invoice_date=#get_invent.entry_date#&company_id=#caller.company_id#&consumer_id=#caller.consumer_id#&partner_id=#caller.partner_id#');";

			i = 1;
			if(get_invent.to_asset eq 1){
				if(get_module_user(40)){
					if(get_asset_type.motorized_vehicle eq 0 and  get_asset_type.it_asset eq 0){
						tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['text'] = '#getLang('invent',43)#';
						tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['href'] = "#request.self#?fuseaction=assetcare.list_assetp&keyword=#get_invent.inventory_number#&form_submitted=1";
						tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['target'] = "_blank";
						i = i + 1;
					}else if(get_asset_type.it_asset eq 1 and( get_asset_type.motorized_vehicle eq 1 or get_asset_type.motorized_vehicle eq 0)){
						tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['text'] = '#getLang('invent',43)#';
						tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['href'] = "#request.self#?fuseaction=assetcare.list_asset_it&keyword=#get_invent.inventory_number#&form_submitted=1";
						tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['target'] = "_blank";
						i = i + 1;
					}else if(get_asset_type.motorized_vehicle eq 1 and (get_asset_type.it_asset eq 0 or get_asset_type.it_asset eq 1)){
						tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['text'] = '#getLang('invent',43)#';
						tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['href'] = "#request.self#?fuseaction=assetcare.list_vehicles&keyword=#get_invent.inventory_number#&form_submitted=1";
						tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['target'] = "_blank";
						i = i + 1;
					}
				}
			}
		}
		
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
</cfscript>
