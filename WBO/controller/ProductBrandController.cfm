<!-----------------------------------------------------------------------
*************************************************************************
		Copyright Workcube E-Business Inc. www.workcube.com
*************************************************************************	
Description :
	Banka Para Yatırma Objesi
----------------------------------------------------------------------->
<cfscript>
	if(attributes.tabMenuController eq 0)
	{
		WOStruct = StructNew();
		
		WOStruct['#attributes.fuseaction#'] = structNew();
		
		WOStruct['#attributes.fuseaction#']['default'] = 'list';
		
		if(not isDefined("attributes.event"))
			attributes.event = WOStruct['#attributes.fuseaction#']['default'];
		
		WOStruct['#attributes.fuseaction#']['list'] = structNew();
		WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'product.list_product_brands';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/product/display/list_product_brands.cfm';
		WOStruct['#attributes.fuseaction#']['list']['queryPath'] = 'V16/product/display/list_product_brands.cfm';
		
		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'popup';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'objects.popup_add_product_brands';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/objects/form/add_product_brands.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'V16/objects/query/add_product_brands.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'objects.popup_add_product_brands&event=upd&id=';
	
		if(isdefined("attributes.id"))
		{
			WOStruct['#attributes.fuseaction#']['upd'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'objects.popup_upd_product_brands';
			WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'V16/objects/form/upd_product_brands.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'V16/objects/query/upd_product_brands.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.id#';
			WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'objects.popup_upd_product_brands&event=upd&id=';
			
			WOStruct['#attributes.fuseaction#']['del'] = structNew();
			WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
			WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=objects.emptypopup_del_product_brands&id=#attributes.id#&head=##caller.get_brand.brand_code##';
			WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16/objects/query/del_product_brands.cfm';
			WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/objects/query/del_product_brands.cfm';
			WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'product.list_product_brands';
	
		}
	}
	else
	{
		getLang = caller.getLang;
		
		if(attributes.event is 'upd')
		{
			
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons'] = structNew();
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#getlang('main',170)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['onClick'] = "windowopen('index.cfm?fuseaction=product.list_product_brands&event=add','medium');";
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=product.list_product_brands";
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['text'] = '#getLang('main',62)#';
     		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['onClick'] = "window.open('#request.self#?fuseaction=objects.popup_print_files&id=#attributes.id#&print_type=218','WOC');";
   
			
		}
		else if (attributes.event is 'add')
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=product.list_product_brands";
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";	
		}
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);		
	}
	WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
	WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'PRODUCT_BRANDS';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'BRAND_ID';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-brand_name','item-brand_code']";
</cfscript>