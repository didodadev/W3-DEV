<cfsavecontent variable="export_title"><cf_get_lang dictionary_id ='60009.Veri aktarım'></cfsavecontent>
	<cfsavecontent variable="invoice_"><cf_get_lang dictionary_id="57821.İhracat Faturası"></cfsavecontent>
<cfscript>
	if(attributes.tabMenuController eq 0)
	{
		WOStruct = StructNew();
		
		WOStruct['#attributes.fuseaction#'] = structNew();	
		
		WOStruct['#attributes.fuseaction#']['default'] = 'list';
		
		WOStruct['#attributes.fuseaction#']['list'] = structNew();
		WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'invoice.list_bill_FTexport';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/invoice/display/list_custom_export.cfm';

		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'invoice.list_bill_FTexport';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = '/V16/invoice/form/add_custom_export.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = '/V16/invoice/cfc/custom_export.cfc?method=add_custom_export';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'invoice.list_bill_FTexport&event=upd&export_id=';
		WOStruct['#attributes.fuseaction#']['add']['formName'] = 'add_custom_export';

		if(isdefined("attributes.export_id"))
		{
			WOStruct['#attributes.fuseaction#']['upd'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'invoice.list_bill_FTexport';
			WOStruct['#attributes.fuseaction#']['upd']['filePath'] = '/V16/invoice/form/upd_custom_export.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = '/V16/invoice/cfc/custom_export.cfc?method=upd_custom_export';
			WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'invoice.list_bill_FTexport&event=upd&export_id=';
			WOStruct['#attributes.fuseaction#']['upd']['identity'] = '#attributes.export_id#';
		}

		WOStruct['#attributes.fuseaction#']['det'] = structNew();
		WOStruct['#attributes.fuseaction#']['det']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['det']['fuseaction'] = 'invoice.list_bill_FTexport';
		WOStruct['#attributes.fuseaction#']['det']['filePath'] = 'V16/invoice/display/detail_custom_export.cfm';
		WOStruct['#attributes.fuseaction#']['det']['parameters'] = 'export_invoice_id=##attributes.export_invoice_id##';
	}
	else 
	{
		fuseactController = caller.attributes.fuseaction;
		getLang = caller.getLang;
		
		tabMenuStruct = StructNew();
		tabMenuStruct['#fuseactController#'] = structNew();
		tabMenuStruct['#fuseactController#']['tabMenus'] = structNew();
		
        tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();
        tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons'] = structNew();

		if(caller.attributes.event is 'add')
		{
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";	
		}
		else if(caller.attributes.event is 'det')
		{
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['print']['text'] = '#getLang('main',62)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['print']['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_print_files&iid=#url.export_invoice_id#&print_type=20','page');";
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['fa fa-upload']['text'] = '#export_title#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['fa fa-table']['onclick'] = "windowopen('#request.self#?fuseaction=objects.popup_list_order_account_cards&invoice_id=#url.export_invoice_id#','page','upd_bill');";// Mahsup Fişi
			
			i=0;
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['text'] = '#invoice_#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['href'] = "#request.self#?fuseaction=invoice.form_add_bill&event=upd&iid=#url.export_invoice_id#";
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['target'] = "_blank";
				 
			i = i + 1;
		}

		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);		
	}
	WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm']				= true;
	WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList']	= 'add,upd';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName']			= 'CUSTOM_DECLERATION';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn']		= 'CUSTOM_DECLERATION_ID';
	/* WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings']				= "['item-custom_stage','item-custom_date']"; */
</cfscript>