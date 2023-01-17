<cfscript>
	if(attributes.tabMenuController eq 0)
	{
		WOStruct = StructNew();
		
		WOStruct['#attributes.fuseaction#'] = structNew();
		
		WOStruct['#attributes.fuseaction#']['default'] = 'list';
		
		WOStruct['#attributes.fuseaction#']['list'] = structNew();
		WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'product.list_product_segment';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/product/display/list_product_segment.cfm';
		
		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'popup';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'product.popup_add_product_segment';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/product/form/add_product_segment.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'V16/product/query/add_product_segment.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'product.list_product_segment';
	
		if(isdefined("attributes.id"))
		{
			WOStruct['#attributes.fuseaction#']['updSegment'] = structNew();
			WOStruct['#attributes.fuseaction#']['updSegment']['window'] = 'popup';
			WOStruct['#attributes.fuseaction#']['updSegment']['fuseaction'] = 'product.popup_upd_product_segment';
			WOStruct['#attributes.fuseaction#']['updSegment']['filePath'] = 'V16/product/form/upd_product_segment.cfm';
			WOStruct['#attributes.fuseaction#']['updSegment']['queryPath'] = 'V16/product/query/upd_product_segment.cfm';
			WOStruct['#attributes.fuseaction#']['updSegment']['Identity'] = '#attributes.id#';
			WOStruct['#attributes.fuseaction#']['updSegment']['nextEvent'] = 'product.list_product_segment';
			
			WOStruct['#attributes.fuseaction#']['del'] = structNew();
			WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
			WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=product.emptypopup_del_product_segment&product_segment_id=##caller.attributes.ID##';
			WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16/product/query/del_product_segment.cfm';
			WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/product/query/del_product_segment.cfm';
			WOStruct['#attributes.fuseaction#']['del']['extraParams'] = 'attributes.id';
			WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'cheque.list_cheque_actions';
	
			WOStruct['#attributes.fuseaction#']['updBranch'] = structNew();
			WOStruct['#attributes.fuseaction#']['updBranch']['window'] = 'popup';
			WOStruct['#attributes.fuseaction#']['updBranch']['fuseaction'] = 'product.popup_upd_seg_branch';
			WOStruct['#attributes.fuseaction#']['updBranch']['filePath'] = 'V16/product/form/form_upd_seg_branch.cfm';
			WOStruct['#attributes.fuseaction#']['updBranch']['queryPath'] = 'V16/product/query/upd_pro_seg.cfm';
			WOStruct['#attributes.fuseaction#']['updBranch']['Identity'] = '#attributes.id#';
			WOStruct['#attributes.fuseaction#']['updBranch']['nextEvent'] = 'product.list_product_segment';
			
			WOStruct['#attributes.fuseaction#']['addBranch'] = structNew();
			WOStruct['#attributes.fuseaction#']['addBranch']['window'] = 'popup';
			WOStruct['#attributes.fuseaction#']['addBranch']['fuseaction'] = 'product.popup_add_seg_branch';
			WOStruct['#attributes.fuseaction#']['addBranch']['filePath'] = 'V16/product/form/form_add_seg_branch.cfm';
			WOStruct['#attributes.fuseaction#']['addBranch']['queryPath'] = 'V16/product/query/add_pro_seg_branch.cfm';
			WOStruct['#attributes.fuseaction#']['addBranch']['Identity'] = '#attributes.id#';
			WOStruct['#attributes.fuseaction#']['addBranch']['nextEvent'] = 'product.list_product_segment';
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
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";
		}
		
		else if(caller.attributes.event is 'updSegment')
		{
			tabMenuStruct['#fuseactController#']['tabMenus']['updSegment']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['updSegment']['icons']['add']['text'] = '#getLang('main',170)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['updSegment']['icons']['add']['onclick'] = "windowopen('#request.self#?fuseaction=product.list_product_segment&event=add','small');";
			tabMenuStruct['#fuseactController#']['tabMenus']['updSegment']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['updSegment']['icons']['check']['onClick'] = "buttonClickFunction()";
		}
		
		else if(caller.attributes.event is 'updBranch')
		{
			tabMenuStruct['#fuseactController#']['tabMenus']['updBranch']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['updBranch']['icons']['add']['text'] = '#getLang('main',170)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['updBranch']['icons']['add']['onclick'] = "windowopen('#request.self#?fuseaction=product.list_product_segment&event=addBranch&id=#attributes.id#','small');";
			tabMenuStruct['#fuseactController#']['tabMenus']['updBranch']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['updBranch']['icons']['check']['onClick'] = "buttonClickFunction()";
		}
		
		else if(caller.attributes.event is 'addBranch')
		{
			tabMenuStruct['#fuseactController#']['tabMenus']['addBranch']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['addBranch']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['addBranch']['icons']['check']['onClick'] = "buttonClickFunction()";
		}
		tabMenuData = SerializeJSON(tabMenuStruct['#fuseactController#']['tabMenus']);
	}
	
	WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
	WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'PRODUCT_SEGMENT_BRANCH';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'PRODUCT_SEGMENT_ID';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-PRO_SEG']";

</cfscript>
