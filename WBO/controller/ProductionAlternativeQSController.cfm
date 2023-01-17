<cfscript>
	if(attributes.tabMenuController eq 0)
		{
			WOStruct = StructNew();
			
			WOStruct['#attributes.fuseaction#'] = structNew();
			
			WOStruct['#attributes.fuseaction#']['default'] = 'list';
			
			WOStruct['#attributes.fuseaction#']['list'] = structNew();
			WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'prod.list_alternative_questions';
			WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/production_plan/display/list_alternative_questions.cfm';
			
			
			WOStruct['#attributes.fuseaction#']['add'] = structNew();
			WOStruct['#attributes.fuseaction#']['add']['window'] = 'popup';
			WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'prod.popup_add_alternative_questions';
			WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/production_plan/form/add_alternative_questions.cfm';
			WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'V16/production_plan/query/add_alternative_questions.cfm';
			WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'prod.list_alternative_questions';
			WOStruct['#attributes.fuseaction#']['add']['formName'] = 'add_work';
			
			if(isdefined("attributes.question_id"))
			{
				WOStruct['#attributes.fuseaction#']['upd'] = structNew();
				WOStruct['#attributes.fuseaction#']['upd']['window'] = 'popup';
				WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'prod.popup_upd_alternative_questions';
				WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'V16/production_plan/form/upd_alternative_questions.cfm';
				WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'V16/production_plan/query/upd_alternative_questions.cfm';
				WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'prod.list_alternative_questions&event=upd&question_id';
				WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'id=##attributes.question_id##';
				WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.question_id##';
					if(listFind('upd,del',attributes.event))
						{
						WOStruct['#attributes.fuseaction#']['del'] = structNew();
						WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
						WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=prod.emptypopup_del_alternative_questions&question_id=#attributes.question_id#';
						WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16/production_plan/query/del_alternative_questions.cfm';
						WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/production_plan/query/del_alternative_questions.cfm';
						WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'prod.list_alternative_questions';
						}	
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
				tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['target'] = "_blank";
				tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['text'] = '#getLang('main',97)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=prod.list_alternative_questions";
				tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";
			}
			else if(caller.attributes.event is 'upd')
			{
				
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('main',170)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['onClick'] = "windowopen('#request.self#?fuseaction=prod.list_alternative_questions&event=add','small');";	
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['target'] = "_blank";
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=prod.list_alternative_questions";
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main',49)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";
			}
			tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
		}
			WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
			WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd,del';
			WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'SETUP_ALTERNATIVE_QUESTIONS ';
			WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'QUESTION_ID';
			WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-question_no','item-question_name','item-question_detail']";
</cfscript>
