<cfscript>
    if(attributes.tabMenuController eq 0)
    {
        WOStruct = StructNew();
        WOStruct['#attributes.fuseaction#'] = structNew();
        WOStruct['#attributes.fuseaction#']['default'] = 'list';

        WOStruct['#attributes.fuseaction#']['list'] = structNew();
        WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'training_management.list_training_groups';
        WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/training_management/display/list_training_groups.cfm';
        WOStruct['#attributes.fuseaction#']['list']['queryPath'] = 'V16/training_management/display/list_training_groups.cfm';

        WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'training_management.list_training_groups';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/training_management/form/add_train_group.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'V16/training_management/query/add_train_group.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'training_management.list_training_groups&event=upd&train_group_id=';

        WOStruct['#attributes.fuseaction#']['removeSubject'] = structNew();
		WOStruct['#attributes.fuseaction#']['removeSubject']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['removeSubject']['fuseaction'] = 'training_management.list_training_groups';
		WOStruct['#attributes.fuseaction#']['removeSubject']['filePath'] = 'V16/training_management/display/remove_training_subject.cfm';
		WOStruct['#attributes.fuseaction#']['removeSubject']['queryPath'] = 'V16/training_management/display/remove_training_subject.cfm';

        WOStruct['#attributes.fuseaction#']['addNote'] = structNew();
		WOStruct['#attributes.fuseaction#']['addNote']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['addNote']['fuseaction'] = 'training_management.list_training_groups';
		WOStruct['#attributes.fuseaction#']['addNote']['filePath'] = 'V16/training_management/display/add_note.cfm';
		WOStruct['#attributes.fuseaction#']['addNote']['queryPath'] = 'V16/training_management/display/add_note.cfm';

		if(isdefined("attributes.train_group_id"))
		{
			WOStruct['#attributes.fuseaction#']['upd'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'training_management.list_training_groups';
			WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'V16/training_management/form/upd_train_group.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'V16/training_management/query/upd_train_group.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'training_management.list_training_groups&event=upd&train_group_id=';
			WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.train_group_id#';
		}

		if(isdefined("attributes.train_group_id"))
		{
			WOStruct['#attributes.fuseaction#']['det'] = structNew();
			WOStruct['#attributes.fuseaction#']['det']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['det']['fuseaction'] = 'training_management.list_training_groups';
			WOStruct['#attributes.fuseaction#']['det']['filePath'] = 'V16/training_management/form/det_train_group.cfm';
			WOStruct['#attributes.fuseaction#']['det']['nextEvent'] = 'training_management.list_training_groups&event=det&train_group_id=';
			WOStruct['#attributes.fuseaction#']['det']['Identity'] = '#attributes.train_group_id#';
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
		// Upd //
		if(isdefined("caller.attributes.event") and caller.attributes.event is 'upd')
		{	
			tabMenuStruct['#fuseactController#']['tabMenus']['upd'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();

			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][0]['text'] = "#getLang('main',22,'Rapor')#";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][0]['onClick'] = "windowopen('#request.self#?fuseaction=training_management.popup_list_report_group_criteria&train_group_id=#attributes.train_group_id#','page')";
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][1]['text'] = "#getLang("","Mazeretliler",46306)#";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][1]['onClick'] = "windowopen('#request.self#?fuseaction=training_management.popup_list_group_excuseds&train_group_id=#attributes.train_group_id#','medium')";

			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][2]['text'] = '#getlang('training_management',330,'Katılımcı Profili')#';
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][2]['onClick'] = "windowopen('#request.self#?fuseaction=training_management.popup_form_class_attender_report&train_group_id=#attributes.train_group_id#','page')";
	
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['detail']['text'] = '#getLang('','',34326)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['detail']['href'] = "#request.self#?fuseaction=training_management.list_training_groups&event=det&train_group_id=#attributes.train_group_id#";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['detail']['target'] = "_blank";
	
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('main',170)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=training_management.list_training_groups&event=add";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
	
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('','',58715)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=training_management.list_training_groups";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['target'] = "_blank";

			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['bell']['text'] = '#getLang('','Uyarılar','57757')#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['bell']['onclick'] = "window.open('#request.self#?fuseaction=objects.workflowpages&tab=3&action=#attributes.fuseaction#&action_name=train_group_id&action_id=#attributes.train_group_id#','Workflow')";

			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['text'] = '#getLang('','Yazdır','57474')#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['onClick'] = "window.open('#request.self#?fuseaction=objects.popup_print_files&print_type=321&action_type=#attributes.train_group_id#&action_id=#attributes.train_group_id#')";

			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-leanpub']['text'] = '#getLang('','Sınıfı Aç','65245')#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-leanpub']['onClick'] = "window.open('#request.self#?fuseaction=training.list_training_groups&event=upd&train_group_id=#attributes.train_group_id#')";

			tabMenuData = SerializeJSON(tabMenuStruct['#fuseactController#']['tabMenus']);
		}
		if(isdefined("caller.attributes.event") and caller.attributes.event is 'det')
		{	
			tabMenuStruct['#fuseactController#']['tabMenus']['det'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons'] = structNew();
	
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['add']['text'] = '#getLang('main',170)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['add']['href'] = "#request.self#?fuseaction=training_management.list_training_groups&event=add";
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['add']['target'] = "_blank";
	
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['fa fa-pencil']['text'] = '#getLang(1034,'Güncelle',57464)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['fa fa-pencil']['href'] = "#request.self#?fuseaction=training_management.list_training_groups&event=upd&train_group_id=#attributes.train_group_id#";
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['fa fa-pencil']['target'] = "_blank";

			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['list-ul']['text'] = '#getLang('','',58715)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['list-ul']['href'] = "#request.self#?fuseaction=training_management.list_training_groups";
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['list-ul']['target'] = "_blank";

			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['bell']['text'] = '#getLang('','Uyarılar','57757')#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['bell']['onclick'] = "window.open('#request.self#?fuseaction=objects.workflowpages&tab=3&action=#attributes.fuseaction#&action_name=train_group_id&action_id=#attributes.train_group_id#','Workflow')";

			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['print']['text'] = '#getLang('','Yazdır','57474')#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['print']['onClick'] = "window.open('#request.self#?fuseaction=objects.popup_print_files&print_type=321&action_type=#attributes.train_group_id#&action_id=#attributes.train_group_id#')";


			tabMenuData = SerializeJSON(tabMenuStruct['#fuseactController#']['tabMenus']);
		}
		
	} 
</cfscript>