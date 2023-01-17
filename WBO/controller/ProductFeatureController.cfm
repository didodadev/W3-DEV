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
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'product.list_property';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = '/V16/product/display/list_property.cfm';

		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'popup';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'product.popup_add_property_main';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = '/V16/product/form/add_property_main.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = '/V16/product/query/add_property_main.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'product.list_property&event=upd&prpt_id=';
		WOStruct['#attributes.fuseaction#']['add']['formName'] = 'add_property_main';
	
		if(isdefined("attributes.prpt_id"))
		{
			WOStruct['#attributes.fuseaction#']['upd'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd']['window'] = 'popup';
			WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'product.popup_upd_property_main';
			WOStruct['#attributes.fuseaction#']['upd']['filePath'] = '/V16/product/form/upd_property_main.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = '/V16/product/query/upd_property_main.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.prpt_id#';
			WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'product.list_property&event=upd&prpt_id=';
			
			WOStruct['#attributes.fuseaction#']['del'] = structNew();
			WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
			WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=product.emptypopup_del_property&prpt_id=#attributes.prpt_id#';
			WOStruct['#attributes.fuseaction#']['del']['filePath'] = '/V16/product/query/del_product_property_main.cfm';
			WOStruct['#attributes.fuseaction#']['del']['queryPath'] = '/V16/product/query/del_product_property_main.cfm';
			WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'product.list_property';

			WOStruct['#attributes.fuseaction#']['add-sub-property'] = structNew();
			WOStruct['#attributes.fuseaction#']['add-sub-property']['window'] = 'popup';
			WOStruct['#attributes.fuseaction#']['add-sub-property']['fuseaction'] = 'product.popup_add_property';
			WOStruct['#attributes.fuseaction#']['add-sub-property']['filePath'] = '/V16/product/form/add_property.cfm';
			WOStruct['#attributes.fuseaction#']['add-sub-property']['queryPath'] = '/V16/product/query/add_property_act.cfm';
			WOStruct['#attributes.fuseaction#']['add-sub-property']['nextEvent'] = 'product.list_property';
				
		}
		if(isdefined("attributes.property_detail_id"))
		{
			WOStruct['#attributes.fuseaction#']['upd-sub-property'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd-sub-property']['window'] = 'popup';
			WOStruct['#attributes.fuseaction#']['upd-sub-property']['fuseaction'] = 'product.popup_upd_sub_property';
			WOStruct['#attributes.fuseaction#']['upd-sub-property']['filePath'] = '/V16/product/form/upd_sub_property.cfm';
			WOStruct['#attributes.fuseaction#']['upd-sub-property']['queryPath'] = '/V16/product/query/upd_product_property.cfm';
			WOStruct['#attributes.fuseaction#']['upd-sub-property']['Identity'] = '#attributes.property_detail_id#';
			WOStruct['#attributes.fuseaction#']['upd-sub-property']['nextEvent'] = 'product.list_property&event=add-sub-property&prpt_id=';
		}

		WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
		WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'PRODUCT_PROPERTY';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'PROPERTY_ID';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-property']";
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
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=product.list_property";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";
		}
		else if(caller.attributes.event is 'upd')
		{
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('main',170)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['onClick'] = "windowopen('#request.self#?fuseaction=product.list_property&event=add','small');";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=product.list_property";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";
			
		}
		else if(caller.attributes.event is 'add-sub-property')
		{
			tabMenuStruct['#fuseactController#']['tabMenus']['add-sub-property']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['add-sub-property']['icons']['add']['text'] = '#getLang('main',170)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add-sub-property']['icons']['add']['onClick'] = "windowopen('#request.self#?fuseaction=product.list_property&event=add','small');";
			tabMenuStruct['#fuseactController#']['tabMenus']['add-sub-property']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['add-sub-property']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add-sub-property']['icons']['list-ul']['href'] = "#request.self#?fuseaction=product.list_property";
			tabMenuStruct['#fuseactController#']['tabMenus']['add-sub-property']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add-sub-property']['icons']['check']['onClick'] = "buttonClickFunction()";
			
		}
		else if(caller.attributes.event is 'upd-sub-property')
		{
			tabMenuStruct['#fuseactController#']['tabMenus']['upd-sub-property']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['upd-sub-property']['icons']['add']['text'] = '#getLang('main',170)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd-sub-property']['icons']['add']['onClick'] = "windowopen('#request.self#?fuseaction=product.list_property&event=add','small');";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd-sub-property']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd-sub-property']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd-sub-property']['icons']['list-ul']['href'] = "#request.self#?fuseaction=product.list_property";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd-sub-property']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd-sub-property']['icons']['check']['onClick'] = "buttonClickFunction()";
			
		}
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	
</cfscript>
