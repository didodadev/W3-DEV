<cfscript>
	if(attributes.tabMenuController eq 0)
	{
		// Switch //
		WOStruct = StructNew();
		
		WOStruct['#attributes.fuseaction#'] = structNew();
		
		WOStruct['#attributes.fuseaction#']['default'] = 'list';
		if(not isdefined('attributes.event'))
			attributes.event = WOStruct['#attributes.fuseaction#']['default'];
		
		WOStruct['#attributes.fuseaction#']['list'] = structNew();
		WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'prod.tracking';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = '/V16/production_plan/display/list_order.cfm';
		
		WOStruct['#attributes.fuseaction#']['det'] = structNew();
		WOStruct['#attributes.fuseaction#']['det']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['det']['fuseaction'] = 'prod.detail_order';
		WOStruct['#attributes.fuseaction#']['det']['filePath'] = 'V16/production_plan/display/detail_order.cfm';
		
	}
	else
	{
		fuseactController = caller.attributes.fuseaction;
		getLang = caller.getLang;
		ORDER_DETAIL = caller.ORDER_DETAIL;
		
		tabMenuStruct = StructNew();
		tabMenuStruct['#fuseactController#'] = structNew();
		tabMenuStruct['#fuseactController#']['tabMenus'] = structNew();
		
		if(caller.attributes.event is 'det')
		{			
			if(caller.get_module_user(11)){
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'] = structNew();
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][0]['text'] = '#getLang('','Sipariş Detay',63617)#';
				if (len(order_detail.IS_INSTALMENT) and order_detail.IS_INSTALMENT eq 1)
					tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][0]['href'] = "#request.self#?fuseaction=sales.upd_fast_sale&order_id=#attributes.order_id#";
				else
					tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][0]['href'] = "#request.self#?fuseaction=sales.list_order&event=upd&order_id=#attributes.order_id#";
			}
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['print']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['print']['text'] = '#getLang('','Yazdır','57474')#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['print']['href'] = '#request.self#?fuseaction=objects.popup_print_files&action_id=#attributes.order_id#&print_type=73';
		
			
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['bell']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['bell']['text'] = '#getLang('','Uyarılar','57757')#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['bell']['href'] = '#request.self#?fuseaction=objects.workflowpages&tab=3&action=myhome.my_extre&action_name=order_id&action_id=#attributes.order_id#';				
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=prod.tracking";
		}
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
		
	}
</cfscript>
<!---
                            start_date_order<cfsavecontent variable="message"><cf_get_lang_main no='59.Eksik Veri'> : <cf_get_lang_main no='243.Başlama Tarihi'></cfsavecontent>
                            start_date<cfsavecontent variable="message"><cf_get_lang_main no='59.Eksik Veri'> : <cf_get_lang_main no='243.Başlama Tarihi'></cfsavecontent>
                            finish_date_order<cfsavecontent variable="message"><cf_get_lang_main no='288.Eksik Veri'> : <cf_get_lang_main no='288.Bitiş Tarihi'></cfsavecontent>
                            finish_date<cfsavecontent variable="message"><cf_get_lang_main no='288.Eksik Veri'> : <cf_get_lang_main no='288.Bitiş Tarihi'></cfsavecontent>

--->