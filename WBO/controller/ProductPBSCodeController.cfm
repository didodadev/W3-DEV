<cfscript>
    if (attributes.tabMenuController eq 0) 
    {
        WOStruct = structNew();
        WOStruct['#attributes.fuseaction#'] = structNew();

        WOStruct['#attributes.fuseaction#']['default'] = 'list';
        if (not isDefined("attributes.event")) {
            attributes.event = WOStruct['#attributes.fuseaction#']['default'];
        }

        WOStruct['#attributes.fuseaction#']['list'] = structNew();
        WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'product.list_pbs_code';
        WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/product/display/list_pbs_code.cfm';

        WOStruct['#attributes.fuseaction#']['add'] = structNew();
        WOStruct['#attributes.fuseaction#']['add']['window'] = 'popup';
        WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'product.list_pbs_code&event=add';
        WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/product/form/add_pbs_code.cfm';
        WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'V16/product/query/add_pbs_code.cfm';
        WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'product.list_pbs_codee&event=upd&pbs_id=';

        if (isDefined("attributes.pbs_id")) {

            WOStruct['#attributes.fuseaction#']['upd'] = structNew();
            WOStruct['#attributes.fuseaction#']['upd']['window'] = 'popup';
            WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'product.list_pbs_codee&event=upd&pbs_id=';
            WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'V16/product/form/upd_pbs_code.cfm';
            WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'V16/product/query/upd_pbs_code.cfm';
            WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'product.list_pbs_codee&event=upd&pbs_id='; 
            WOStruct['#attributes.fuseaction#']['upd']['pbs_identity'] = '#attributes.pbs_id#';    
        
        }
    } 
    else
	{
		getLang = caller.getLang;
		
		if(attributes.event is 'upd')
		{
			
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons'] = structNew();
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#getlang('main',170)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['onClick'] = "windowopen('#request.self#?fuseaction=product.list_pbs_code&event=add','medium');";
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=product.list_pbs_code";
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";
			
		}
		else if (attributes.event is 'add')
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=product.list_pbs_code";
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";	
		}
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);		
	}
	WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
	WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'SETUP_PBS_CODE';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'PBS_ID';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-pbs_detail','item-pbs_code']";
</cfscript>