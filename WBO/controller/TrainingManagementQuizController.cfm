<cfscript>
    if(attributes.tabMenuController eq 0)
    {
        WOStruct = StructNew();
        WOStruct['#attributes.fuseaction#'] = structNew();
        WOStruct['#attributes.fuseaction#']['default'] = 'list';

        WOStruct['#attributes.fuseaction#']['list'] = structNew();
        WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'training_management.list_quizs';
        WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/training_management/display/list_quizs.cfm';
        WOStruct['#attributes.fuseaction#']['list']['queryPath'] = 'V16/training_management/display/list_quizs.cfm';
		
		WOStruct['#attributes.fuseaction#']['listQuestions'] = structNew();
		WOStruct['#attributes.fuseaction#']['listQuestions']['window'] = 'popup';
		WOStruct['#attributes.fuseaction#']['listQuestions']['fuseaction'] = 'training_management.list_quiz_questions';
		WOStruct['#attributes.fuseaction#']['listQuestions']['filePath'] = 'V16/training_management/display/list_quiz_questions.cfm';
		
		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'training_management.form_add_quiz';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/training_management/form/add_quiz.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'V16/training_management/query/add_quiz.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'training_management.list_quizs&event=det&quiz_id=';	

		if(isdefined("attributes.quiz_id"))
		{
			WOStruct['#attributes.fuseaction#']['upd'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'training_management.list_quizs';
			WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'V16/training_management/form/upd_quiz.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'V16/training_management/query/upd_quiz.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.quiz_id#';
			WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'training_management.list_quizs&event=upd&quiz_id=';

			WOStruct['#attributes.fuseaction#']['dashboard'] = structNew();
        	WOStruct['#attributes.fuseaction#']['dashboard']['window'] = 'normal';
        	WOStruct['#attributes.fuseaction#']['dashboard']['fuseaction'] = 'training_management.list_quizs';
        	WOStruct['#attributes.fuseaction#']['dashboard']['filePath'] = 'V16/training_management/display/quiz_results.cfm';
      		WOStruct['#attributes.fuseaction#']['dashboard']['queryPath'] = 'V16/training_management/display/quiz_results.cfm';
		
			WOStruct['#attributes.fuseaction#']['det'] = structNew();
			WOStruct['#attributes.fuseaction#']['det']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['det']['fuseaction'] = 'training_management.list_quizs';
			WOStruct['#attributes.fuseaction#']['det']['filePath'] = 'V16/training_management/display/quiz.cfm';
			WOStruct['#attributes.fuseaction#']['det']['queryPath'] = 'V16/training_management/query/get_tra_quiz.cfm';
			WOStruct['#attributes.fuseaction#']['det']['Identity'] = '#attributes.quiz_id#';
			WOStruct['#attributes.fuseaction#']['det']['nextEvent'] = 'training_management.list_quizs&event=det&quiz_id=';
		}
		
		if(isdefined("attributes.quiz_id"))
			{
				WOStruct['#attributes.fuseaction#']['del'] = structNew();
				WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
				WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=training_management.del_quiz&quiz_id=#attributes.quiz_id#';
				WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16/training_management/query/del_quiz.cfm';
				WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/training_management/query/del_quiz.cfm';
				WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'training_management.list_quizs';
			}
	  }	

	  	else
	{
		fuseactController = caller.attributes.fuseaction;
		tabMenuStruct = StructNew();
		getLang = caller.getLang;
		
		tabMenuStruct['#fuseactController#'] = structNew();
		tabMenuStruct['#fuseactController#']['tabMenus'] = structNew();
		
		if(isdefined("caller.attributes.event") and caller.attributes.event is 'det')
		{
			
			get_quiz = caller.get_quiz;
			denied_pages = caller.denied_pages;
			get_quiz_questions = caller.get_quiz_questions;
			get_user_join_quiz = caller.get_user_join_quiz;

			tabMenuStruct['#fuseactController#']['tabMenus']['det'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'] = structNew();
			
			i = 0;

			/* if(not listfindnocase(denied_pages,'training_management.quiz_results'))

			{
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['text'] = "#getLang('main',723,'Sonuçlar')#";
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['href'] = "#request.self#?fuseaction=training_management.list_quizs&event=results&quiz_id=#get_quiz.quiz_id#";
				i = i + 1;
			} */


			if(not listfindnocase(denied_pages,'training_management.popup_make_quiz') AND (get_quiz_questions.recordcount) AND (get_user_join_quiz.recordcount < get_quiz.take_limit)
			and ((dateformat(get_quiz.quiz_startdate,"yyyymmdd") <= dateformat(now(),"yyyymmdd")) and (dateformat(get_quiz.quiz_finishdate,"yyyymmdd") >= dateformat(now(),"yyyymmdd"))))

			{
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['text'] = "#getLang('training_management',94,'Sınav Yap')#";
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=training_management.popup_make_quiz&quiz_id=#attributes.quiz_id#&page_type=2','list');";
				i = i + 1;
			}

		if(caller.get_quiz_result_count.toplam != 1)
		{
			if(not listfindnocase(denied_pages,'training_management.popup_list_questions'))

			{
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['text'] = "#getLang('training_management',95,'Soru Bankasından Ekle')#";
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['onClick'] = "openBoxDraggable('#request.self#?fuseaction=training_management.popup_list_questions&quiz_id=#get_quiz.quiz_id#');";
				i = i + 1;
			}

			if(not listfindnocase(denied_pages,'training_management.popup_form_add_question'))

			{
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['text'] = "#getLang('training_management',96,'Yeni Soru Ekle')#";
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['onClick'] = "openBoxDraggable('#request.self#?fuseaction=training_management.popup_form_add_question&quiz_id=#get_quiz.quiz_id#&training_id=#get_quiz.training_id#&training_sec_id=#get_quiz.training_sec_id#&training_cat_id=#get_quiz.training_cat_id#','medium')";
				i = i + 1;
			}

			
		}
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['fa fa-pencil']['text'] = '#getLang('main',52,'güncelle')#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['fa fa-pencil']['href'] = "#request.self#?fuseaction=training_management.list_quizs&event=upd&quiz_id=#attributes.quiz_id#";
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['add']['text'] = '#getLang('main',170,'Ekle')#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['add']['href'] = "#request.self#?fuseaction=training_management.list_quizs&event=add";
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['add']['target'] = "_blank";

			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['copy']['text'] = '#getLang('main',64)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['copy']['href'] = "#request.self#?fuseaction=training_management.list_quizs&event=upd&quiz_id=#attributes.quiz_id#";
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['copy']['target'] = "_blank";

			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['print']['text'] = '#getLang('','Yazdır','57474')#';
            tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['print']['onClick'] = "window.open('#request.self#?fuseaction=objects.popup_print_files&action_id=#attributes.quiz_id#&print_type=321');";

			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['bell']['text'] = '#getLang('','Uyarılar','57757')#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['bell']['onclick'] =  "window.open('#request.self#?fuseaction=objects.workflowpages&tab=3&action=#attributes.fuseaction#&action_name=quiz_id&action_id=#attributes.quiz_id#','Workflow')";
	

			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['list-ul']['text'] = '#getLang('','Listele',58715)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['list-ul']['href'] = "#request.self#?fuseaction=training_management.list_quizs";
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['list-ul']['target'] = "_blank";
		
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['fa fa-bar-chart']['text'] = "#getLang('main',723,'Sonuçlar')#";
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['fa fa-bar-chart']['href'] = "#request.self#?fuseaction=training_management.list_quizs&event=dashboard&quiz_id=#get_quiz.quiz_id#";
			

			tabMenuData = SerializeJSON(tabMenuStruct['#fuseactController#']['tabMenus']);
		}

		if(isdefined("caller.attributes.event") and caller.attributes.event is 'upd')
		{

			tabMenuStruct['#fuseactController#']['tabMenus']['upd'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'] = structNew();
						
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['detail']['text'] = '#getLang('','Detaylar',52563)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['detail']['href'] = "#request.self#?fuseaction=training_management.list_quizs&event=det&quiz_id=#attributes.quiz_id#";
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('','Listele',58715)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=training_management.list_quizs";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['target'] = "_blank";

			/* tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-dashboard']['text'] = '#getLang('','Listele',58715)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-dashboard']['href'] = "#request.self#?fuseaction=training_management.list_quizs&event=dashboard&quiz_id=#attributes.quiz_id#";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-dashboard']['target'] = "_blank"; */

			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('main',170,'Ekle')#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=training_management.list_quizs&event=add";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";

			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['copy']['text'] = '#getLang('main',64)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['copy']['href'] = "#request.self#?fuseaction=training_management.list_quizs&event=upd&quiz_id=#attributes.quiz_id#";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['copy']['target'] = "_blank";

			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['print']['text'] = '#getLang('','Yazdır','57474')#';
            tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['print']['onClick'] = "window.open('#request.self#?fuseaction=objects.popup_print_files&action_id=#attributes.quiz_id#&print_type=321');";

			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['bell']['text'] = '#getLang('','Uyarılar','57757')#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['bell']['onclick'] =  "window.open('#request.self#?fuseaction=objects.workflowpages&tab=3&action=#attributes.fuseaction#&action_name=quiz_id&action_id=#attributes.quiz_id#','Workflow')";

			tabMenuData = SerializeJSON(tabMenuStruct['#fuseactController#']['tabMenus']);
		}

		if(isdefined("caller.attributes.event") and caller.attributes.event is 'dashboard')
		{

			tabMenuStruct['#fuseactController#']['tabMenus']['dashboard'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['dashboard']['menus'] = structNew();
						
			tabMenuStruct['#fuseactController#']['tabMenus']['dashboard']['icons']['detail']['text'] = '#getLang('','Detaylar',52563)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['dashboard']['icons']['detail']['href'] = "#request.self#?fuseaction=training_management.list_quizs&event=det&quiz_id=#attributes.quiz_id#";
			
			tabMenuStruct['#fuseactController#']['tabMenus']['dashboard']['icons']['list-ul']['text'] = '#getLang('','Listele',58715)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['dashboard']['icons']['list-ul']['href'] = "#request.self#?fuseaction=training_management.list_quizs";
			tabMenuStruct['#fuseactController#']['tabMenus']['dashboard']['icons']['list-ul']['target'] = "_blank";

			tabMenuStruct['#fuseactController#']['tabMenus']['dashboard']['icons']['add']['text'] = '#getLang('main',170,'Ekle')#';
			tabMenuStruct['#fuseactController#']['tabMenus']['dashboard']['icons']['add']['href'] = "#request.self#?fuseaction=training_management.list_quizs&event=add";
			tabMenuStruct['#fuseactController#']['tabMenus']['dashboard']['icons']['add']['target'] = "_blank";

			tabMenuStruct['#fuseactController#']['tabMenus']['dashboard']['icons']['copy']['text'] = '#getLang('main',64)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['dashboard']['icons']['copy']['href'] = "#request.self#?fuseaction=training_management.list_quizs&event=upd&quiz_id=#attributes.quiz_id#";
			tabMenuStruct['#fuseactController#']['tabMenus']['dashboard']['icons']['copy']['target'] = "_blank";

			tabMenuStruct['#fuseactController#']['tabMenus']['dashboard']['icons']['print']['text'] = "#getLang('main',62)#";
            tabMenuStruct['#fuseactController#']['tabMenus']['dashboard']['icons']['print']['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_print_files&action_id=#attributes.quiz_id#&print_type=321','page');";

			tabMenuStruct['#fuseactController#']['tabMenus']['dashboard']['icons']['fa fa-pencil']['text'] = '#getLang('main',52,'güncelle')#';
			tabMenuStruct['#fuseactController#']['tabMenus']['dashboard']['icons']['fa fa-pencil']['href'] = "#request.self#?fuseaction=training_management.list_quizs&event=upd&quiz_id=#attributes.quiz_id#";

			tabMenuData = SerializeJSON(tabMenuStruct['#fuseactController#']['tabMenus']);
		}
		
	} 
</cfscript>