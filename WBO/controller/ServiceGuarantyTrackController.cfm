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
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'service.list_guaranty';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/service/display/list_guaranty.cfm';
		WOStruct['#attributes.fuseaction#']['list']['queryPath'] = 'V16/service/display/list_guaranty.cfm';	

		
		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'service.list_guaranty';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = '/V16/objects/form/add_serial_no_guaranty.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'V16/objects/query/add_serialno_guaranty.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'service.list_guaranty&event=upd&id=';	
		
		if(isdefined("attributes.id"))
		{
		WOStruct['#attributes.fuseaction#']['upd'] = structNew();
		WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'service.list_guaranty';
		WOStruct['#attributes.fuseaction#']['upd']['formName'] = 'form_basket';
		WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'V16/objects/form/upd_serial_no_guaranty.cfm';
		WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'V16/objects/query/upd_serialno_guaranty.cfm';
		WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.id#';
		WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'service.list_guaranty&event=upd&id='; 
		}
		
	}
	else
	{
		fuseactController = caller.attributes.fuseaction;
		getLang = caller.getLang;
		
		tabMenuStruct = StructNew();
		tabMenuStruct['#fuseactController#'] = structNew();
		tabMenuStruct['#fuseactController#']['tabMenus'] = structNew();
		
		if(caller.attributes.event is 'add')
		{			
		tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons'] = structNew();
		tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['text'] = '#getLang('','Liste','57509')#';
		tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=service.list_guaranty";
		}
		
		else if(caller.attributes.event is 'upd')
		{
		tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('','Liste','57509')#';
		tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=service.list_guaranty";
		tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('','Ekle','57582')#';
		tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=service.list_guaranty&event=add";
		tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['text'] = '#getLang('','Yazdır','57474')#';
		tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['target'] = '_blank';
		tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['href'] = "#request.self#?fuseaction=objects.popup_print_files&action_id=#attributes.id#";
		}
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
</cfscript>
