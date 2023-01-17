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
			  WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'protein.list_product_vision';
			  WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'AddOns/Atwork/protein/display/list_product_vision.cfm';	
			
			if(IsDefined("attributes.event") && attributes.event is 'upd')
			{
				WOStruct['#attributes.fuseaction#']['upd'] = structNew();
				WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
				WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'product.popup_upd_product_vision';
				WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'product/form/upd_product_vision.cfm';
				WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'product/query/upd_product_vision.cfm';
				/* WOStruct['#attributes.fuseaction#']['upd']['nextevent'] = 'protein.sites&event=upd&menu_id='; */
			}
			
			
				WOStruct['#attributes.fuseaction#']['add'] = structNew();
				WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
				WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'product.popup_add_product_vision';
				WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'product/form/add_product_vision.cfm';
				WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'product/query/add_product_vision.cfm';
			/* 	WOStruct['#attributes.fuseaction#']['add']['nextevent'] = 'protein.list_product_vision'; */
			
	  }
	</cfscript>