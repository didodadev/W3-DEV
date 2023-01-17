<cfsavecontent variable="seri"><cf_get_lang dictionary_id="33860.Seri No ara"></cfsavecontent>
<cfsavecontent variable="garanti"><cf_get_lang dictionary_id ='33859.Garanti Bilgisi'></cfsavecontent>
<cfsavecontent variable="barcod"><cf_get_lang dictionary_id='57633.Barkod'></cfsavecontent>
<cfsavecontent variable="aktar"><cf_get_lang dictionary_id ='60009.Veri aktarım'></cfsavecontent>
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
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'stock.list_serial_operations';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = '/V16/stock/display/list_serial_operations.cfm';
	
		if(isdefined("attributes.process_id"))
		{
		WOStruct['#attributes.fuseaction#']['det'] = structNew();
		WOStruct['#attributes.fuseaction#']['det']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['det']['fuseaction'] = 'objects.popup_upd_stock_serialno';
		WOStruct['#attributes.fuseaction#']['det']['filePath'] = '/V16/objects/form/upd_stock_serial_no.cfm';
		WOStruct['#attributes.fuseaction#']['det']['queryPath'] = '/V16/objects/query/upd_stock_serialno.cfm';
		WOStruct['#attributes.fuseaction#']['det']['nextEvent'] = '';
		}
	}
	else
	{
		fuseactController = caller.attributes.fuseaction;
		// Tab Menus //
		tabMenuStruct = StructNew();
		getLang = caller.getLang;
		
		tabMenuStruct['#fuseactController#'] = structNew();
		tabMenuStruct['#fuseactController#']['tabMenus'] = structNew();
		// Upd //
		if(isdefined("caller.attributes.event") and caller.attributes.event is 'det')
		{
			PRODUCT_NAME=caller.product_name;
			process_cat=caller.attributes.process_cat;
			process_number=caller.attributes.process_number;
			process_id=caller.attributes.process_id;
			STOCK_ID=caller.attributes.STOCK_ID;
			product_id=caller.attributes.product_id;
			recorded_count=caller.attributes.recorded_count;
			product_amount=caller.attributes.product_amount;
			
			if(isdefined("caller.attributes.is_store") and caller.attributes.is_store eq 1 ){
				is_store=1;
			}
			else is_store='';
			if(isdefined("caller.attributes.wrk_row_id")){
				wrk_row_id=caller.attributes.wrk_row_id;
			}
			else wrk_row_id='';
			if(isdefined("caller.attributes.spect_id")){
				spect_id=caller.attributes.spect_id;
			}
			else spect_id='';

			tabMenuStruct['#fuseactController#']['tabMenus']['det'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons'] = structNew();

			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['fa fa-barcode']['text'] = '#barcod#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['fa fa-barcode']['onClick'] = "openBoxDraggable('#request.self#?fuseaction=objects.popup_form_add_stock_barcode&stock_id=#PRODUCT_NAME.STOCK_ID#&is_terazi=#PRODUCT_NAME.IS_TERAZI#');";

			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['fa fa-download']['text'] = '#aktar#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['fa fa-download']['href'] = "#request.self#?fuseaction=objects.emptypopup_add_serial_to_file&wrk_row_id=#wrk_row_id#&product_amount=#product_amount#&recorded_count=#recorded_count#&product_id=#product_id#&stock_id=#stock_id#&process_number=#process_number#&process_cat=#process_cat#&process_id=#process_id#&is_serial_no=1&spect_id=#spect_id#&isAjax=1";

			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['fa fa-certificate']['text'] = '#garanti#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['fa fa-certificate']['onClick'] = "openBoxDraggable('#request.self#?fuseaction=objects.popup_dsp_product_guaranty&pid=#product_id#&draggable=1');";

			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['fa fa-search']['text'] = '#seri#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['fa fa-search']['onClick'] = "openBoxDraggable('#request.self#?fuseaction=objects.popup_serial_no_search&product_id=#product_id#&is_store=#is_store#&draggable=1');";

			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['print']['text'] = '#getLang('main',62)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['print']['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_print_files&action_type=#process_cat#&action_id=#process_id#&action_row_id=#STOCK_ID#&print_type=192','page');";

			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['list-ul']['href'] = "#request.self#?fuseaction=stock.list_serial_operations";
			tabMenuData = SerializeJSON(tabMenuStruct['#fuseactController#']['tabMenus']);
		}

	}
	
</cfscript>

