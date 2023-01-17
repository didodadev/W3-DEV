<cfscript>
    if(attributes.tabMenuController eq 0)
    {
        WOStruct = StructNew();
        WOStruct['#attributes.fuseaction#'] = structNew();
        WOStruct['#attributes.fuseaction#']['default'] = 'list';

        WOStruct['#attributes.fuseaction#']['list'] = structNew();
        WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'training_management.list_class_announcements';
        WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/training_management/display/list_class_announcements.cfm';

        WOStruct['#attributes.fuseaction#']['add'] = structNew();
        WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'training_management.list_class_announcements';
        WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/training_management/form/form_add_train_announce.cfm';
        WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'V16/training_management/query/add_announce.cfm';
        WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'training_management.list_class_announcements&event=upd&announce_id=';

        if(isdefined("attributes.announce_id"))
        {
            WOStruct['#attributes.fuseaction#']['upd'] = structNew();
            WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
            WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'training_management.list_class_announcements';
            WOStruct['#attributes.fuseaction#']['upd']['filePath'] = '/V16/training_management/display/detail_train_announce.cfm';
            WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = '/V16/training_management/query/upd_announce.cfm';
            WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'training_management.list_class_announcements&event=upd&announce_id=';
            WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.announce_id#';
        }

        if(isdefined("attributes.event") and listFind('del',attributes.event))
        {
            WOStruct['#attributes.fuseaction#']['del'] = structNew();
            WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
            WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,".")#.del_announce&announce_id=#attributes.announce_id#';
            WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16/training_management/query/del_announce.cfm';
            WOStruct['#attributes.fuseaction#']['del']['extraParams'] = 'announce_id';
            WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/training_management/query/del_announce.cfm';
            WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'training_management.list_class_announcements';
        }

    }
    else{
        fuseactController = caller.attributes.fuseaction;
		// Tab Menus //
		tabMenuStruct = StructNew();
		getLang = caller.getLang;
		
		tabMenuStruct['#fuseactController#'] = structNew();
		tabMenuStruct['#fuseactController#']['tabMenus'] = structNew();
		// Upd //
        if(isdefined("caller.attributes.event") and caller.attributes.event is 'upd')
            {
               // get_list_class_announcements = caller.get_list_class_announcements;
                
                tabMenuStruct['#fuseactController#']['tabMenus']['upd'] = structNew();
                tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'] = structNew();

                tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][0]['text'] = '#getLang('','Duyuruya Eklenenler','46672')#';
                tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][0]['onClick'] = "windowopen('#request.self#?fuseaction=training_management.popup_list_announce_emps&announce_id=#attributes.announce_id#','medium');";

                tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][1]['text'] = '#getLang('training_management',494,'Duyuru Listesindekilere Mail Gönder')#';
                tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][1]['onclick'] = "window.location.href='#request.self#?fuseaction=training_management.popup_send_mail&announce_id=#attributes.announce_id#','medium';";
                
                tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][2]['text'] ="#getLang('main',52,'Güncelle')#";
                tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][2]['onClick'] = "windowopen('#request.self#?fuseaction=training_management.popup_upd_train_announce&announce_id=#attributes.announce_id#','page');";
               
                tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][3]['text'] = "#getLang('main',170,'Ekle')#";
                tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][3]['onClick'] = "windowopen('#request.self#?fuseaction=training_management.list_class_announcements&event=add','small')";
            }

        tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
    }
</cfscript>