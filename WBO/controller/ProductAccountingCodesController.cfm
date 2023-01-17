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
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'product.list_prod_code_cat';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/product/display/list_prod_code_cat.cfm';
		
		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'product.form_add_prod_code_cat';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/product/form/add_prod_code_cat.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'V16/product/query/add_prod_code_cat.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'product.list_prod_code_cat';
	
		if(isdefined("attributes.cat_id"))
		{
			WOStruct['#attributes.fuseaction#']['upd'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'product.form_upd_prod_code_cat';
			WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'V16/product/form/upd_prod_code_cat.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'V16/product/query/upd_prod_code_cat.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.cat_id#';
			WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'product.list_prod_code_cat&event=upd&cat_id=';
			
			WOStruct['#attributes.fuseaction#']['del'] = structNew();
			WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
			WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=product.emptypopup_del_pro_per_cat&cat_id=#attributes.cat_id#&head=##caller.get_cat_detail.PRO_CODE_CAT_NAME##';
			WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16/product/query/del_prod_code_cat.cfm';
			WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/product/query/del_prod_code_cat.cfm';
			WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'product.list_prod_code_cat';
	
		}
	}
	else
	{
		getLang = caller.getLang;
		
		if(attributes.event is 'upd')
		{
			
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons'] = structNew();
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#getlang('main',170)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=product.list_prod_code_cat&event=add";
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=product.list_prod_code_cat";
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['copy']['text'] = '#getLang('main',64)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['copy']['href'] = "#request.self#?fuseaction=product.list_prod_code_cat&event=add&cat_id=#attributes.cat_id#";
			
		}
		else if (attributes.event is 'add')
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=product.list_prod_code_cat";
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";	
		}
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);		
	}
	WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
	WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'SETUP_PRODUCT_PERIOD_CAT';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'PRO_CODE_CATID';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-PRO_CODE_CAT_NAME']";
</cfscript>