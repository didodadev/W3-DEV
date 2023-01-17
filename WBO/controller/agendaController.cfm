<cfscript>
    if(attributes.tabMenuController eq 0)
    {
        WOStruct = StructNew();
        WOStruct['#attributes.fuseaction#'] = structNew();
        WOStruct['#attributes.fuseaction#']['default'] = 'list';

        WOStruct['#attributes.fuseaction#']['list'] = structNew();
        WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'agenda.view_daily';
        WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/agenda/display/view_daily.cfm';
        WOStruct['#attributes.fuseaction#']['list']['queryPath'] = 'V16/agenda/query/view_daily.cfm';

        WOStruct['#attributes.fuseaction#']['add'] = structNew();
        WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'agenda.form_add_event';
        WOStruct['#attributes.fuseaction#']['add']['xmlfuseaction'] = 'agenda.form_add_event';
        WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/agenda/form/form_add_event.cfm';
        WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'V16/agenda/query/popup_add_event.cfm';
        WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'agenda.view_daily&event=upd&event_id=';

        WOStruct['#attributes.fuseaction#']['det'] = structNew();
        WOStruct['#attributes.fuseaction#']['det']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['det']['fuseaction'] = 'agenda.form_det_event';        
        WOStruct['#attributes.fuseaction#']['det']['filePath'] = 'V16/agenda/form/form_det_event.cfm';
        WOStruct['#attributes.fuseaction#']['det']['queryPath'] = 'V16/agenda/query/get_emp_events.cfm';        
     
        WOStruct['#attributes.fuseaction#']['upd'] = structNew();
        WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'agenda.form_upd_event';
        WOStruct['#attributes.fuseaction#']['upd']['xmlfuseaction'] = 'agenda.form_add_event';
        WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'V16/agenda/form/form_upd_event.cfm';
        WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'V16/agenda/query/popup_upd_event.cfm';
        WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'agenda.view_daily&event=upd&event_id=';

        WOStruct['#attributes.fuseaction#']['popupUpd'] = structNew();
        WOStruct['#attributes.fuseaction#']['popupUpd']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['popupUpd']['fuseaction'] = 'objects.upd_event';
        WOStruct['#attributes.fuseaction#']['popupUpd']['xmlfuseaction'] = 'agenda.form_add_event';
        WOStruct['#attributes.fuseaction#']['popupUpd']['filePath'] = 'V16/agenda/form/form_upd_event.cfm';
        WOStruct['#attributes.fuseaction#']['popupUpd']['queryPath'] = 'V16/agenda/query/popup_upd_event.cfm';
        WOStruct['#attributes.fuseaction#']['popupUpd']['nextEvent'] = 'agenda.view_daily&event=upd&event_id=';

        WOStruct['#attributes.fuseaction#']['del'] = structNew();
        WOStruct['#attributes.fuseaction#']['del']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=agenda.emptypopup_del_event&event_id=';
        WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16/agenda/query/del_event.cfm';
        WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/agenda/query/del_event.cfm';
        WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'agenda.view_daily';
        
        WOStruct['#attributes.fuseaction#']['search'] = structNew();
        WOStruct['#attributes.fuseaction#']['search']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['search']['fuseaction'] = 'agenda.view_daily';
        WOStruct['#attributes.fuseaction#']['search']['xmlfuseaction'] = 'agenda.form_add_event';
        WOStruct['#attributes.fuseaction#']['search']['filePath'] = 'V16/agenda/display/list_events.cfm';
        WOStruct['#attributes.fuseaction#']['search']['queryPath'] = 'V16/agenda/query/get_event_search.cfm';  
    }
    else{
        fuseactController = caller.attributes.fuseaction;
		// Tab Menus //
		tabMenuStruct = StructNew();
		getLang = caller.getLang;
		
		tabMenuStruct['#fuseactController#'] = structNew();
		tabMenuStruct['#fuseactController#']['tabMenus'] = structNew();
        if((isdefined("caller.attributes.event") and caller.attributes.event is 'upd') or (isdefined("caller.attributes.event") and caller.attributes.event is 'popupUpd'))
		{
        
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'] = structNew();
			
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['copy']['text'] = '#getLang('main',64,'kopyala')#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['copy']['href'] = "#request.self#?fuseaction=agenda.view_daily&event=add&event_id=#attributes.event_id#";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['copy']['target'] = "_blank";
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('main',170,'ekle')#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=agenda.view_daily&event=add";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";

			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][0]['text'] = "#getLang('agenda',14,'başvuru ekle')#";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][0]['href'] = "#request.self#?fuseaction=service.list_service&event=add&event_id=#attributes.event_id#";
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][0]['target'] = "_blank";



            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][1]['text'] = '#getLang('main',179,'olay tutanağı')#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][1]['onClick'] = "windowopen('#request.self#?fuseaction=agenda.popup_event_result&event_id=#url.event_id#','wide')";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][1]['target'] = "_blank";

            tabMenuData = SerializeJSON(tabMenuStruct['#fuseactController#']['tabMenus']);
        }
    }
</cfscript>