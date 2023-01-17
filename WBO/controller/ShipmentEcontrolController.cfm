<cfsavecontent variable="edetail"><cf_get_lang dictionary_id="60905.E-İrsaliye Önizleme"></cfsavecontent>

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
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'stock.received_eshipment';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/e_government/display/received_eshipment.cfm';

		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'popup';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'stock.received_eshipment';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/e_government/form/add_eshipment_xml.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'V16/e_government/query/add_eshipment_xml.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = '';

		if(isdefined("attributes.receiving_detail_id")){
			WOStruct['#attributes.fuseaction#']['det'] = structNew();
			WOStruct['#attributes.fuseaction#']['det']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['det']['fuseaction'] = 'stock.received_eshipment';
			WOStruct['#attributes.fuseaction#']['det']['filePath'] = 'V16/e_government/display/upd_eshipment_detail.cfm';
			WOStruct['#attributes.fuseaction#']['det']['queryPath'] = 'V16/e_government/query/upd_eshipment_detail.cfm';
			WOStruct['#attributes.fuseaction#']['det']['Identity'] = '#attributes.receiving_detail_id#';
			WOStruct['#attributes.fuseaction#']['det']['nextEvent'] = 'stock.received_eshipment&event=det&receiving_detail_id=';
		}
	}
	else
	{
		fuseactController = caller.attributes.fuseaction;
		getLang = caller.getLang;
		
		tabMenuStruct = StructNew();
		tabMenuStruct['#fuseactController#'] = structNew();
		tabMenuStruct['#fuseactController#']['tabMenus'] = structNew();
		
		if(caller.attributes.event is 'det')
		{		
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons'] = structNew();
			
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['list-ul']['href'] = "#request.self#?fuseaction=stock.received_eshipment";

			tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus']['0']['text'] = '#edetail#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus']['0']['onclick'] = "windowopen('#request.self#?fuseaction=objects.popup_dsp_eshipment_detail&is_display=1&receiving_detail_id=#attributes.receiving_detail_id#&type=1&row=1','wide')";
			
		}
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
</cfscript>