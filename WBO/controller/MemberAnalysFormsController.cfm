<cfscript>
	if(attributes.tabMenuController eq 0)
	{
		WOStruct = StructNew();
		
		WOStruct['#attributes.fuseaction#'] = structNew();	
		
		WOStruct['#attributes.fuseaction#']['default'] = 'list';
		if(not isdefined('attributes.event'))
			attributes.event = WOStruct['#attributes.fuseaction#']['default'];
	
		WOStruct['#attributes.fuseaction#']['list'] = structNew();
		WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'member.list_analysis';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = '/V16/member/display/list_analysis.cfm';

		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'member.popup_form_add_analysis&popup_page=0';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = '/V16/member/form/add_analysis.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = '/V16/member/query/add_analysis.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'member.list_analysis&event=upd&analysis_id=';
		WOStruct['#attributes.fuseaction#']['add']['formName'] = 'add_analysis';
	
		if(isdefined("attributes.analysis_id"))
		{
			WOStruct['#attributes.fuseaction#']['upd'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'member.analysis';
			WOStruct['#attributes.fuseaction#']['upd']['filePath'] = '/V16/member/display/analysis.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = '/V16/member/query/upd_analysis.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.analysis_id#';
			WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'member.list_analysis&event=upd&analysis_id=';

			WOStruct['#attributes.fuseaction#']['addSub'] = structNew();
			WOStruct['#attributes.fuseaction#']['addSub']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['addSub']['fuseaction'] = 'member.popup_form_add_question';
			WOStruct['#attributes.fuseaction#']['addSub']['filePath'] = '/V16/member/form/add_question.cfm';
			WOStruct['#attributes.fuseaction#']['addSub']['queryPath'] = '/V16/member/query/add_question.cfm';
			WOStruct['#attributes.fuseaction#']['addSub']['nextEvent'] = 'member.list_analysis&event=addSub&analysis_id=';
			WOStruct['#attributes.fuseaction#']['addSub']['formName'] = 'add_question';

			WOStruct['#attributes.fuseaction#']['dashboard'] = structNew();
			WOStruct['#attributes.fuseaction#']['dashboard']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['dashboard']['fuseaction'] = 'member.list_analysis';
			WOStruct['#attributes.fuseaction#']['dashboard']['filePath'] = '/V16/member/display/dsp_analyse_result.cfm';
			WOStruct['#attributes.fuseaction#']['dashboard']['queryPath'] = '/V16/member/display/dsp_analyse_result.cfm';
			WOStruct['#attributes.fuseaction#']['dashboard']['Identity'] = '#attributes.analysis_id#';
			WOStruct['#attributes.fuseaction#']['dashboard']['nextEvent'] = 'member.list_analysis&event=dashboard&analysis_id=';


			/* WOStruct['#attributes.fuseaction#']['det'] = structNew();
			WOStruct['#attributes.fuseaction#']['det']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['det']['fuseaction'] = 'member.list_analysis';
			WOStruct['#attributes.fuseaction#']['det']['filePath'] = '/V16/member/display/dsp_analyse_result.cfm';
			WOStruct['#attributes.fuseaction#']['det']['queryPath'] = '/V16/member/display/dsp_analyse_result.cfm';
			WOStruct['#attributes.fuseaction#']['det']['Identity'] = '#attributes.analysis_id#';
			WOStruct['#attributes.fuseaction#']['det']['nextEvent'] = 'member.list_analysis&event=det&analysis_id=';
 */
			WOStruct['#attributes.fuseaction#']['det'] = structNew();
			WOStruct['#attributes.fuseaction#']['det']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['det']['fuseaction'] = 'member.list_analysis';
			WOStruct['#attributes.fuseaction#']['det']['filePath'] = '/V16/member/display/analysis_results.cfm';
			WOStruct['#attributes.fuseaction#']['det']['queryPath'] = '/V16/member/display/analysis_results.cfm';
			WOStruct['#attributes.fuseaction#']['det']['Identity'] = '#attributes.analysis_id#';
			WOStruct['#attributes.fuseaction#']['det']['nextEvent'] = 'member.list_analysis&event=det&analysis_id=';	




			if(isdefined("attributes.question_id")){
				WOStruct['#attributes.fuseaction#']['updSub'] = structNew();
				WOStruct['#attributes.fuseaction#']['updSub']['window'] = 'normal';
				WOStruct['#attributes.fuseaction#']['updSub']['fuseaction'] = 'member.popup_form_upd_question';
				WOStruct['#attributes.fuseaction#']['updSub']['filePath'] = '/V16/member/form/upd_question.cfm';
				WOStruct['#attributes.fuseaction#']['updSub']['queryPath'] = '/V16/member/query/upd_question.cfm';
				WOStruct['#attributes.fuseaction#']['updSub']['Identity'] = '#attributes.question_id#';
				WOStruct['#attributes.fuseaction#']['updSub']['nextEvent'] = 'member.list_analysis&event=addSub&analysis_id=';
				WOStruct['#attributes.fuseaction#']['addSub']['formName'] = 'upd_question';
			}

			

			WOStruct['#attributes.fuseaction#']['add-result'] = structNew();
			WOStruct['#attributes.fuseaction#']['add-result']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['add-result']['fuseaction'] = 'member.popup_analysis_results_only_member';
			WOStruct['#attributes.fuseaction#']['add-result']['filePath'] = '/V16/member/display/analysis_results_only_member.cfm';
			WOStruct['#attributes.fuseaction#']['add-result']['queryPath'] = '/V16/member/display/analysis_results_only_member.cfm';
			WOStruct['#attributes.fuseaction#']['add-result']['nextEvent'] = 'member.list_analysis&event=det&analysis_id=';
			WOStruct['#attributes.fuseaction#']['add-result']['formName'] = 'analysis_result';

			if(isdefined("attributes.result_id")){
				WOStruct['#attributes.fuseaction#']['upd-result'] = structNew();
				WOStruct['#attributes.fuseaction#']['upd-result']['window'] = 'popup';
				WOStruct['#attributes.fuseaction#']['upd-result']['fuseaction'] = 'member.list_analysis';
				WOStruct['#attributes.fuseaction#']['upd-result']['filePath'] = '/V16/member/display/upd_member_analysis_result.cfm';
				WOStruct['#attributes.fuseaction#']['upd-result']['queryPath'] = '/V16/member/query/upd_member_analysis_result.cfm';
				WOStruct['#attributes.fuseaction#']['upd-result']['nextEvent'] = 'member.list_analysis&event=det&analysis_id=';

				

				WOStruct['#attributes.fuseaction#']['del'] = structNew();
				WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
				WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=member.emptypopup_del_member_analysis_result&result_id=#attributes.result_id#&analysis_id=#attributes.analysis_id#';
				WOStruct['#attributes.fuseaction#']['del']['filePath'] = '/V16/member/query/del_member_analysis_result.cfm';
				WOStruct['#attributes.fuseaction#']['del']['queryPath'] = '/V16/member/query/del_member_analysis_result.cfm';
				WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'member.list_analysis&event=det&analysis_id=';
			}

		}

		WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
		WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'MEMBER_ANALYSIS';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'analysis_id';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-analysis_head','item-analysis_average']";
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
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['text'] = '#getLang('','Liste','57509')#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=member.list_analysis";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('','Kaydet','57461')#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";
		}
		else if(caller.attributes.event is 'upd')
		{
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('','Ekle','57582')#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=member.list_analysis&event=add";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('','Liste','57509')#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=member.list_analysis";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('','Kaydet','57461')#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['chart']['text'] = '#getLang('','Sonuçlar','58135')#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['chart']['href'] = "#request.self#?fuseaction=member.list_analysis&event=det&analysis_id=#attributes.analysis_id#";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['chart']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['bell']['text'] = '#getlang('','Uyarılar','57757')#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['bell']['onClick'] = "window.open('#request.self#?fuseaction=objects.workflowpages&tab=3&action=#attributes.fuseaction#&action_name=analysis_id&action_id=#attributes.analysis_id#&wrkflow=1','Workflow')";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['text'] = '#getLang('','Yazdır','57474')#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['onClick'] = "window.open('#request.self#?fuseaction=objects.popup_print_files&action_id=#attributes.analysis_id#&action=#attributes.fuseaction#', 'woc');";			
		}

		else if(caller.attributes.event is 'addSub')
		{
			tabMenuStruct['#fuseactController#']['tabMenus']['addSub']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['addSub']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['addSub']['icons']['list-ul']['text'] = '#getLang('','Liste','57509')#';
			tabMenuStruct['#fuseactController#']['tabMenus']['addSub']['icons']['list-ul']['href'] = "#request.self#?fuseaction=member.list_analysis";
			tabMenuStruct['#fuseactController#']['tabMenus']['addSub']['icons']['check']['text'] = '#getLang('','Kaydet','57461')#';
			tabMenuStruct['#fuseactController#']['tabMenus']['addSub']['icons']['check']['onClick'] = "buttonClickFunction()";
		}

		else if(caller.attributes.event is 'updSub')
		{
			tabMenuStruct['#fuseactController#']['tabMenus']['updSub']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['updSub']['icons']['add']['text'] = '#getLang('','Ekle','57582')#';
			tabMenuStruct['#fuseactController#']['tabMenus']['updSub']['icons']['add']['onClick'] = "windowopen('#request.self#?fuseaction=member.list_analysis&event=addSub&analysis_id=#analysis_id#', 'medium','popup_form_add_question');";
			tabMenuStruct['#fuseactController#']['tabMenus']['updSub']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['updSub']['icons']['list-ul']['text'] = '#getLang('','Liste','57509')#';
			tabMenuStruct['#fuseactController#']['tabMenus']['updSub']['icons']['list-ul']['href'] = "#request.self#?fuseaction=member.list_analysis";
			tabMenuStruct['#fuseactController#']['tabMenus']['updSub']['icons']['check']['text'] = '#getLang('','Kaydet','57461')#';
			tabMenuStruct['#fuseactController#']['tabMenus']['updSub']['icons']['check']['onClick'] = "buttonClickFunction()";
		}

	/* 	else if(caller.attributes.event is 'result')
		{
			tabMenuStruct['#fuseactController#']['tabMenus']['result']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['result']['icons']['chart']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['result']['icons']['chart']['text'] = '#getLang('','Sonuçlar','58135')';
			tabMenuStruct['#fuseactController#']['tabMenus']['result']['icons']['chart']['href'] = "#request.self#?fuseaction=member.list_analysis&event=det&analysis_id=#attributes.analysis_id#";

		} */

		else if(caller.attributes.event is 'det')
		{
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['add']['text'] = '#getLang('','Ekle','57582')#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['add']['href'] = "#request.self#?fuseaction=member.list_analysis&event=add";
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['chart']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['chart']['text'] = '#getLang('','Dashboards','55731')#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['chart']['href'] = "#request.self#?fuseaction=member.list_analysis&event=dashboard&analysis_id=#attributes.analysis_id#";
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['list-ul']['text'] = '#getLang('','Liste','57509')#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['list-ul']['href'] = "#request.self#?fuseaction=member.list_analysis";
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['fa fa-pencil']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['fa fa-pencil']['text'] = '#getLang('','Güncelle','57464')#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['fa fa-pencil']['href'] = "#request.self#?fuseaction=member.list_analysis&event=upd&analysis_id=#attributes.analysis_id#";
		}
		else if(caller.attributes.event is 'dashboard')
		{
			tabMenuStruct['#fuseactController#']['tabMenus']['dashboard']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['dashboard']['icons']['add']['text'] = '#getLang('','Ekle','57582')#';
			tabMenuStruct['#fuseactController#']['tabMenus']['dashboard']['icons']['add']['href'] = "#request.self#?fuseaction=member.list_analysis&event=add";
			tabMenuStruct['#fuseactController#']['tabMenus']['dashboard']['icons']['list-ul']['text'] = '#getLang('','Liste','57509')#';
			tabMenuStruct['#fuseactController#']['tabMenus']['dashboard']['icons']['list-ul']['href'] = "#request.self#?fuseaction=member.list_analysis";
			tabMenuStruct['#fuseactController#']['tabMenus']['dashboard']['icons']['fa fa-pencil']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['dashboard']['icons']['fa fa-pencil']['text'] = '#getLang('','Güncelle','57464')#';
			tabMenuStruct['#fuseactController#']['tabMenus']['dashboard']['icons']['fa fa-pencil']['href'] = "#request.self#?fuseaction=member.list_analysis&event=upd&analysis_id=#attributes.analysis_id#";
		}
		else if(caller.attributes.event is 'add-result')
		{
			tabMenuStruct['#fuseactController#']['tabMenus']['add-result']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['add-result']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['add-result']['icons']['list-ul']['text'] = '#getLang('','Liste','57509')#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add-result']['icons']['list-ul']['href'] = "#request.self#?fuseaction=member.list_analysis";
			tabMenuStruct['#fuseactController#']['tabMenus']['add-result']['icons']['check']['text'] = '#getLang('','Kaydet','57461')#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add-result']['icons']['check']['onClick'] = "buttonClickFunction()";
		}
		
		else if(caller.attributes.event is 'upd-result')
		{
			tabMenuStruct['#fuseactController#']['tabMenus']['upd-result']['icons'] = structNew();

			if(not listfindnocase(caller.denied_pages,'member.popup_analysis_results_only_member'))
			{
				tabMenuStruct['#fuseactController#']['tabMenus']['upd-result']['icons']['add']['text'] = '#getLang('','Ekle','57582')#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd-result']['icons']['add']['onClick'] = "windowopen('#request.self#?fuseaction=member.list_analysis&event=add-result&analysis_id=#attributes.analysis_id#','page','popup_analysis_results_only_member');";
			}			

			tabMenuStruct['#fuseactController#']['tabMenus']['upd-result']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd-result']['icons']['list-ul']['text'] = '#getLang('','Liste','57509')#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd-result']['icons']['list-ul']['href'] = "#request.self#?fuseaction=member.list_analysis";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd-result']['icons']['check']['text'] = '#getLang('','Kaydet','57461')#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd-result']['icons']['check']['onClick'] = "buttonClickFunction()";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd-result']['icons']['print']['target'] = '_blank';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd-result']['icons']['print']['text'] = '#getLang('','Yazdır','57474')#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd-result']['icons']['print']['onclick'] = "window.open('#request.self#?fuseaction=objects.popup_print_files&action_id=#url.analysis_id#&action=#attributes.fuseaction#&action_row_id=#url.result_id#', 'woc');";
			
		}
		
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	
</cfscript>
