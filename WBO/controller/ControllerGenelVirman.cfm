<cfsavecontent variable="copys"><cf_get_lang dictionary_id="57476.Kopyala"></cfsavecontent>
<cfscript> 
	// Switch //
	if(attributes.tabMenuController eq 0)
	{
	
		WOStruct = StructNew();
		WOStruct['#attributes.fuseaction#'] = structNew();
		WOStruct['#attributes.fuseaction#']['default'] = 'list';
		
		WOStruct['#attributes.fuseaction#']['list'] = structNew();
		WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'finance.list_genel_virman';
        WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/finance/display/list_genel_virman.cfm';
        
        WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'finance.add_genel_virman';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/finance/form/add_genel_virman.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'V16/finance/cfc/genel_virman.cfc?method=add_genel_virman';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'finance.list_genel_virman&event=upd&virman_id=';
	
		if(isdefined("attributes.virman_id"))
		{
			WOStruct['#attributes.fuseaction#']['upd'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'sales.form_add_order';
			WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'V16/finance/form/upd_genel_virman.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'finance.list_genel_virman&event=upd&virman_id=#attributes.virman_id#';
			WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.virman_id#';	
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

            if(isdefined("attributes.event") and attributes.event is 'add')
            {	
                tabMenuStruct['#fuseactController#']['tabMenus']['add'] = structNew();
                tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons'] = structNew();
                tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['text'] = '#getLang('main',97)#';
                tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=finance.list_genel_virman";
                tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
                tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";
            }

            if(isdefined("attributes.event") and attributes.event is 'upd')
            {	
				get_data = caller.get_data;
                tabMenuStruct['#fuseactController#']['tabMenus']['upd'] = structNew();
                tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();
                tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
                tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=finance.list_genel_virman";
                tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main',49)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('main',170)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=finance.list_genel_virman&event=add";
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['bell']['text'] = '#getlang('main',345)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['bell']['onclick'] = "window.open('#request.self#?fuseaction=objects.workflowpages&tab=3&action=#attributes.fuseaction#&action_name=virman_id&action_id=#attributes.virman_id#&wrkflow=1','Workflow')";
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-table']['text'] = '#getLang('main',1040)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-table']['onClick'] = "windowopen('#request.self#?fuseaction=account.popup_list_card_rows&action_id=#url.virman_id#&process_cat=#get_data.process_type#','page','upd_bill')";
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['copy']['text'] = '#copys#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['copy']['href'] = "#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_genel_virman&event=add&virman_id=#url.virman_id#";
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['copy']['target'] = "_blank";
            }

            tabMenuData = SerializeJSON(tabMenuStruct['#fuseactController#']['tabMenus']);
        		
	}
</cfscript>