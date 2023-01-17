<cfscript>
    if(attributes.tabMenuController eq 0)
    {
        WOStruct = StructNew();
        WOStruct['#attributes.fuseaction#'] = structNew();
        WOStruct['#attributes.fuseaction#']['default'] = 'list';

        WOStruct['#attributes.fuseaction#']['list'] = structNew();
        WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'training_management.list_class';
        WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/training_management/display/list_class.cfm';
        WOStruct['#attributes.fuseaction#']['list']['queryPath'] = 'V16/training_management/display/list_class.cfm';
		
		WOStruct['#attributes.fuseaction#']['scorm_result'] = structNew();
        WOStruct['#attributes.fuseaction#']['scorm_result']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['scorm_result']['fuseaction'] = 'training_management.list_class';
        WOStruct['#attributes.fuseaction#']['scorm_result']['filePath'] = 'V16/training_management/display/list_class_scorm_results.cfm';
        WOStruct['#attributes.fuseaction#']['scorm_result']['queryPath'] = 'V16/training_management/display/list_class_scorm_results.cfm';

        WOStruct['#attributes.fuseaction#']['add'] = structNew();
        WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'training_management.form_add_class';
        WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/training_management/form/add_class.cfm';
        WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'V16/training_management/query/add_class.cfm';
        WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'training_management.list_class&event=upd&training_sec_id=';

        if(isdefined("attributes.homework_id"))
        {
            WOStruct['#attributes.fuseaction#']['updHomework'] = structNew();
            WOStruct['#attributes.fuseaction#']['updHomework']['window'] = 'normal';
            WOStruct['#attributes.fuseaction#']['updHomework']['fuseaction'] = 'training_management.form_upd_class';
            WOStruct['#attributes.fuseaction#']['updHomework']['filePath'] = '/V16/training_management/form/upd_class_homeworks.cfm';
            WOStruct['#attributes.fuseaction#']['updHomework']['Identity'] = '#attributes.homework_id#';
        }

        if(isdefined("attributes.class_id"))
        {
            WOStruct['#attributes.fuseaction#']['upd'] = structNew();
            WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
            WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'training_management.form_upd_class';
            WOStruct['#attributes.fuseaction#']['upd']['filePath'] = '/V16/training_management/form/upd_class.cfm';
            WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = '/V16/training_management/query/upd_class.cfm';
            WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.class_id#';
            WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'training_management.list_class&event=upd&class_id=';

            WOStruct['#attributes.fuseaction#']['addHomework'] = structNew();
            WOStruct['#attributes.fuseaction#']['addHomework']['window'] = 'normal';
            WOStruct['#attributes.fuseaction#']['addHomework']['fuseaction'] = 'training_management.form_upd_class';
            WOStruct['#attributes.fuseaction#']['addHomework']['filePath'] = '/V16/training_management/form/add_class_homeworks.cfm';
            WOStruct['#attributes.fuseaction#']['addHomework']['Identity'] = '#attributes.class_id#';

            WOStruct['#attributes.fuseaction#']['addClassToTrainGroup'] = structNew();
            WOStruct['#attributes.fuseaction#']['addClassToTrainGroup']['window'] = 'normal';
            WOStruct['#attributes.fuseaction#']['addClassToTrainGroup']['fuseaction'] = 'training_management.list_class';
            WOStruct['#attributes.fuseaction#']['addClassToTrainGroup']['filePath'] = 'V16/training_management/query/add_class_to_train_group.cfm';
            WOStruct['#attributes.fuseaction#']['addClassToTrainGroup']['Identity'] = '#attributes.class_id#';

            WOStruct['#attributes.fuseaction#']['det'] = structNew();
			WOStruct['#attributes.fuseaction#']['det']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['det']['fuseaction'] = 'training_management.list_class';
			WOStruct['#attributes.fuseaction#']['det']['filePath'] = 'V16/training_management/display/detail_training_management.cfm';
            WOStruct['#attributes.fuseaction#']['det']['parameters'] = '#attributes.class_id#';
            
            WOStruct['#attributes.fuseaction#']['del'] = structNew();
            WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
            WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=training_management.emptypopup_del_training_section&training_sec_id=#attributes.class_id#';
            WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16/training_management/query/del_training_section.cfm';
            WOStruct['#attributes.fuseaction#']['del']['extraParams'] = 'training_sec_id';
            WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/training_management/query/del_training_section.cfm';
            WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'training_management.definitions';

            WOStruct['#attributes.fuseaction#']['dashboard'] = structNew();
			WOStruct['#attributes.fuseaction#']['dashboard']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['dashboard']['fuseaction'] = 'training_management.list_class';
			WOStruct['#attributes.fuseaction#']['dashboard']['filePath'] = 'V16/training_management/display/list_report_criteria.cfm';
            WOStruct['#attributes.fuseaction#']['dashboard']['parameters'] = '#attributes.class_id#';
        }
    }
    else{
       
        fuseactController = caller.attributes.fuseaction;
        // Tab Menus //
        tabMenuStruck = StructNew();
        getLang = caller.getLang;
       
        
        
        tabMenuStruck['fuseactController'] = structNew();
        tabMenuStruct['#fuseactController#']['tabMenus'] = structNew();

        if(isdefined("attributes.event") and attributes.event is 'upd')
        {
            get_class = caller.get_class;
            get_trainer = caller.get_trainer; 
            get_workcube_app_user = caller.get_workcube_app_user;
            get_class_cost = caller.get_class_cost;
            get_class_attender = caller.get_class_attender;
            get_class_results = caller.get_class_results;
            get_class_attender_eval = caller.get_class_attender_eval;
            xml_is_scorm_content_upload = caller.xml_is_scorm_content_upload;
            get_module_user = caller.get_module_user;

            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'] = structNew();
            

            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['target'] = "_blank";
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=training_management.list_class";
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('main',170)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=training_management.list_class&event=add";
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main',49)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['text'] = '#getLang('main',62)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['onclick'] = "window.open('#request.self#?fuseaction=objects.popup_print_files&action_id=#attributes.class_id#&print_type=320','woc')";
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['copy']['text'] = '#getLang('main',64)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['copy']['onClick'] = "windowopen('#request.self#?fuseaction=training_management.popup_add_new_training_class&class_id=#attributes.class_id#','medium')";
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['bell']['text'] = '#getLang('','Uyarılar','57757')#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['bell']['onClick']  = "window.open('#request.self#?fuseaction=objects.workflowpages&tab=3&action=#attributes.fuseaction#&action_name=class_id&action_id=#attributes.class_id#')";
				
            i=0;

            if(get_class_cost.RecordCount)
            {
                tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getlang('main',846,'Maliyet')#';
                tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onClick'] = "openBoxDraggable('#request.self#?fuseaction=training_management.popup_upd_training_cost&class_id=#attributes.class_id#&is_class_type=0','training_cost_box','ui-draggable-box-large')";
                i = i + 1;
            }
            else{
                tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getlang('main',846,'Maliyet')#';
                tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onClick'] = "openBoxDraggable('#request.self#?fuseaction=training_management.popup_add_training_cost&class_id=#attributes.class_id#&is_class_type=0','training_cost_box','ui-draggable-box-large')";
                i = i + 1;
            }
	
            /* tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getlang('','Eğitimi Talep Edenler',46423)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onClick'] = "openBoxDraggable('#request.self#?fuseaction=training_management.popup_list_train_request_class&class_id=#attributes.class_id#','train_request_box','ui-draggable-box-medium')";
            i = i + 1; */

            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getlang('','Yoklama',46381)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onClick'] = "openBoxDraggable('#request.self#?fuseaction=training_management.popup_list_class_attenders&training_id=#attributes.training_id#&class_id=#attributes.class_id#','class_attender_box','ui-draggable-box-medium')";
            i = i + 1;
            
            /* if(get_class_attender.recordcount)
            {
                tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getlang('training_management',174,'Yoklama')#';
                tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=training_management.popup_list_class_attendance&class_id=#attributes.class_id#','list')";
                i = i + 1;
            } */
			
            /* if(get_class_results.RecordCount)
            {
                tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getlang('main',723,'Sonuçlar')#';
                tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=training_management.popup_form_upd_class_results&class_id=#attributes.class_id#','medium')";
                i = i + 1;
            }
            else{
                tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getlang('main',723,'Sonuçlar')#';
                tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=training_management.popup_form_add_class_results&class_id=#attributes.class_id#','medium')";
                i = i + 1;
            } */

            /* if(get_class_attender_eval.RecordCount)
            {
                tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getlang('training_management',224,'Katılımcı Değerlendirme Formu')#';
                tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=training_management.popup_form_upd_class_attender_eval&class_id=#attributes.class_id#','project')";
                i = i + 1;
            }
            else{
                tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getlang('training_management',224,'Katılımcı Değerlendirme Formu')#';
                tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=training_management.popup_form_add_class_attender_eval&class_id=#attributes.class_id#','project')";
                i = i + 1;
            } */
               
            /* tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getlang('training_management',271,'Çalışan Eğitim Değerlendirme Formu')#';
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=training_management.popup_add_class_eval_note&class_id=#attributes.class_id#','list')";
            i = i + 1;
				
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getlang('training_management',272,'Eğitmen Değerlendirme Formu')#';
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=training_management.popup_add_class_trainer_eval&class_id=#attributes.class_id#','list')";
            i = i + 1;

			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getlang('training_management',37,'Olay Sonuç')#';
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=training_management.popup_class_result_report&class_id=#attributes.class_id#','list')";
            i = i + 1; */

			
           /*  tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getlang('bank',375,'Scorm Uyumlu İçerik EKle')#';
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=training_management.popup_dsp_courses&class_id=#attributes.class_id#&xml_is_scorm_content_upload=#xml_is_scorm_content_upload#','list')";
            i = i + 1; */
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang("","",39078)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['href'] = "#request.self#?fuseaction=training_management.list_class&event=scorm_result&class_id=#attributes.class_id#";
            i = i + 1;
            

            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-share-alt']['text'] = '#getlang('training',20,'Eğitimi Öner')#';
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-share-alt']['onClick'] = "openBoxDraggable('#request.self#?fuseaction=training.popup_form_add_suggested&class_id=#attributes.class_id#','','ui-draggable-box-medium')";
            i = i + 1;

           /*  tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getlang('training_management',534,'Katılımcı Yazdır')#';  
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_print_files&action_id=#attributes.class_id#&print_type=321','print_page','workcube_print')";
            i = i + 1; */

            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-envelope']['text'] = '#getLang('','Mail',29463)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-envelope']['onclick'] = "windowopen('index.cfm?fuseaction=objects.popup_mail&module=content&trail=1','list','popup_mail')";
            i = i + 1;

            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-clipboard']['text'] = '#getlang('','Eğitimciye Mesaj At',46561)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-clipboard']['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_add_nott&public=1&employee_id=#get_trainer.emp_id#','small')";
            i = i + 1;

            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['chart']['text'] = '#getlang('main',22,'Rapor')#';
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['chart']['href'] = "#request.self#?fuseaction=training_management.list_class&event=dashboard&class_id=#attributes.class_id#";
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['chart']['target'] = "_blank";
            i = i + 1;

            tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['detail']['text'] = '#getLang("","",33077)#';
            tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['detail']['href'] = "#request.self#?fuseaction=training_management.list_class&event=det&class_id=#attributes.class_id#";
            i = i + 1;
            		
        }
        if(isdefined("attributes.event") and attributes.event is 'add')
        {
            tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons'] = structNew();
            tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['target'] = "_blank";
            tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['text'] = '#getLang('main',97)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=training_management.list_class";
            tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";
        }
    
        if(isdefined("attributes.event") and (attributes.event is 'det' or attributes.event is 'dashboard')){
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['list-ul']['target'] = "_blank";
            tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['bell']['text'] = '#getLang('','Uyarılar','57757')#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['bell']['onClick']  = "window.open('#request.self#?fuseaction=objects.workflowpages&tab=3&action=#attributes.fuseaction#&action_name=class_id&action_id=#attributes.class_id#')";
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['list-ul']['href'] = "#request.self#?fuseaction=training_management.list_class";
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['check']['onClick'] = "buttonClickFunction()";
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['fa fa-pencil']['text'] = '#getlang(1034,'Güncelle',57464)#'; 
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['fa fa-pencil']['href'] = "#request.self#?fuseaction=training_management.list_class&event=upd&class_id=#attributes.class_id#";
            tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['print']['text'] = '#getLang('main',62)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['print']['onclick'] = "window.open('#request.self#?fuseaction=objects.popup_print_files&action_id=#attributes.class_id#&print_type=320','woc')";
		}
        tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']); 
    }	
    WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
    WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd';
    WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'TRAINING_CLASS';
    WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'CLASS_ID';
    WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-start_date','item-finish_date','item-training_cat_id','item-max_participation','item-date_no']";
</cfscript>