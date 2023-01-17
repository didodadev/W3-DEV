<cfscript>
if(attributes.tabMenuController eq 0)
	{
		WOStruct = StructNew();
		
		WOStruct['#attributes.fuseaction#'] = structNew();
		
		WOStruct['#attributes.fuseaction#']['default'] = 'list';
		
		WOStruct['#attributes.fuseaction#']['list'] = structNew();
		WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'project.projects';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/project/display/dsp_projects.cfm';
		
		
		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'project.addpro';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/project/form/add_project.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'V16/project/query/add_project.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'project.projects&event=det&id=';
		WOStruct['#attributes.fuseaction#']['add']['formName'] = 'add_pro';

		if(isdefined("attributes.id")){
			WOStruct['#attributes.fuseaction#']['upd'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'project.popup_updpro';
			WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'V16/project/form/upd_project.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'V16/project/query/upd_project.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'project.projects&event=upd&id=';
			WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'id=##attributes.id##';
			WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.id##';
						
			WOStruct['#attributes.fuseaction#']['det'] = structNew();
			WOStruct['#attributes.fuseaction#']['det']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['det']['fuseaction'] = 'project.projects';
			WOStruct['#attributes.fuseaction#']['det']['filePath'] = 'V16/project/display/dsp_project_detail.cfm';
			WOStruct['#attributes.fuseaction#']['det']['queryPath'] = 'V16/project/query/get_prodetail.cfm';
			WOStruct['#attributes.fuseaction#']['det']['nextEvent'] = 'project.projects&event=det';
			WOStruct['#attributes.fuseaction#']['det']['parameters'] = 'id=##attributes.id##';
			WOStruct['#attributes.fuseaction#']['det']['Identity'] = '##attributes.id##';
			
			WOStruct['#attributes.fuseaction#']['del'] = structNew();
			WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
			WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'project.emptypopup_del_pro';
			WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16/project/query/del_project.cfm';
			WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/project/query/del_project.cfm';
			WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'project.projects&event=list';
			WOStruct['#attributes.fuseaction#']['del']['parameters'] = 'id=##attributes.id##';
			WOStruct['#attributes.fuseaction#']['del']['Identity'] = '##attributes.id##';
			
			WOStruct['#attributes.fuseaction#']['kanban'] = structNew();
			WOStruct['#attributes.fuseaction#']['kanban']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['kanban']['fuseaction'] = 'project.kanban_board';
			WOStruct['#attributes.fuseaction#']['kanban']['filePath'] = 'V16/report/standart/kanban_board.cfm';
			WOStruct['#attributes.fuseaction#']['kanban']['queryPath'] = 'V16/report/cfc/kanban_board.cfc';
			WOStruct['#attributes.fuseaction#']['kanban']['parameters'] = 'project_id=##attributes.id##';
			WOStruct['#attributes.fuseaction#']['kanban']['Identity'] = '##attributes.id##';

		}
		WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
		WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'PRO_PROJECTS';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'PROJECT_ID';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['form_ul_main_process_cat','form_ul_process_stage','form_ul_about_company','form_ul_pro_h_start','form_ul_pro_h_finish','form_ul_responsable_name','form_ul_project_head']";
	}
	else
	{			
		getLang = caller.getLang;
		denied_pages = caller.denied_pages;
		dsn = caller.dsn;

	
		
		tabMenuStruct = StructNew();
		tabMenuStruct['#attributes.fuseaction#'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus'] = structNew();
		
		if(isdefined("attributes.event") and attributes.event is 'det')
		{
			project_detail = caller.project_detail;
		
			
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det'] = structNew();
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'] = structNew();
			i = 0;
			
			if (not listfindnocase(denied_pages,'project.popup_list_project_financial_actions'))
			{
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][i]['text'] = '#getLang('project',103)#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][i]['onclick'] = "windowopen('#request.self#?fuseaction=project.popup_list_project_financial_actions&id=#project_detail.PROJECT_ID#','list')";
				i++;
			}
			if (not listfindnocase(denied_pages,'project.popup_list_project_actions'))
			{
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][i]['text'] = '#getLang('project',160)#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][i]['onclick'] = "openBoxDraggable('#request.self#?fuseaction=project.popup_list_project_actions&id=#project_detail.PROJECT_ID#')";
				i++;
			}
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][i]['text'] = '#getLang('','WorkBoard','50967')#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][i]['href'] = "#request.self#?fuseaction=report.project_work_board&project_id=#project_detail.project_id#&form_varmi=1&project_head=#project_detail.project_head#";
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][i]['target'] = "blank_"
			i++;

			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][i]['text'] = '#getLang('project',152,'kanban')#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][i]['href'] = "#request.self#?fuseaction=project.kanban_board&id=#project_detail.project_id#";
			i++;

			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][i]['text'] = '#getLang('project',153,'gantt')#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][i]['href'] = "#request.self#?fuseaction=project.gantt_chart&id=#project_detail.project_id#";

			i++;

			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][i]['text'] = '#getLang('myhome',1380,'takvim')#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][i]['href'] = "#request.self#?fuseaction=agenda.view_daily&action_id=#project_detail.project_id#&action_section=PROJECT_ID";

			i++;
			
			if (not listfindnocase(denied_pages,'report.project_accounts_report'))
			{
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][i]['text'] = '#getLang('','Proje İcmal Raporu',39568)#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][i]['href'] = "#request.self#?fuseaction=report.project_accounts_report&project_id=#project_detail.project_id#";
				i++;
			}
			
			if (not listfindnocase(denied_pages,'myhome.popup_add_timecost_project_all'))
			{
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][i]['text'] = '#getLang('project',200)#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][i]['onclick'] = "windowopen('#request.self#?fuseaction=myhome.popup_add_timecost_project_all&id=#project_detail.PROJECT_ID#&comp_id=#project_detail.company_id#&cons_id=#project_detail.consumer_id#&partner_id=#project_detail.PARTNER_ID#&expense_code=#project_detail.EXPENSE_CODE#','wwide')";
				i++;
			}
			
			if (not listfindnocase(denied_pages,'project.popup_project_history'))
			{
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['fa fa-history']['text'] = '#getLang('','Uyarılar','57757')#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['fa fa-history']['onclick'] = "openBoxDraggable('#request.self#?fuseaction=project.popup_project_history&id=#project_detail.PROJECT_ID#','wide')";
			}
			if (not listfindnocase(denied_pages,'objects.popup_list_mail_relation'))
			{
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][i]['text'] = '#getLang('project',201)#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][i]['onclick'] = "openBoxDraggable('#request.self#?fuseaction=objects.popup_list_mail_relation&relation_type=PROJECT_ID&relation_type_id=#project_detail.PROJECT_ID#')";
				i++;
			}
			
			if (not listfindnocase(denied_pages,'project.popup_project_prod_discounts'))
			{
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][i]['text'] = '#getLang('objects2',1636)#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][i]['onclick'] = "windowopen('#request.self#?fuseaction=project.popup_project_prod_discounts&project_id=#project_detail.PROJECT_ID#','wide')";
				i++;
			}
			
			if (not listfindnocase(denied_pages,'project.popup_add_project_asset'))
			{
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][i]['text'] = '#getLang('main',2207)#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][i]['onclick'] = "windowopen('#request.self#?fuseaction=project.popup_add_project_asset&id=#project_detail.PROJECT_ID#','list')";
				i++;
			}
			
			/* Sayfalar yeniden tasarlanana kadar kapalı
			if (not listfindnocase(denied_pages,'project.graph'))
			{
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][i]['text'] = '#getLang('project',102)#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][i]['href'] = "#request.self#?fuseaction=project.graph&project_id=#project_detail.PROJECT_ID#";
				i++;
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][i]['text'] = '#getLang('project',102)# #getLang('report',1453)#' ;
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][i]['href'] = "#request.self#?fuseaction=project.employee_work_graph&project_id=#project_detail.PROJECT_ID#";
				i++;
			}
			*/
			if(listFindNoCase(session.ep.user_level,22)) 
			{
			   if (not listfindnocase(denied_pages,'project.popup_list_period'))
				{
					tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][i]['text'] = '#getLang('main',1399)#';
					tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][i]['onclick'] = "windowopen('#request.self#?fuseaction=project.popup_list_period&id=#project_detail.PROJECT_ID#','wide')";
					i++;
				}
			}
			/* if (not listfindnocase(denied_pages,'project.popup_add_workgroup'))
			{
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][i]['text'] = '#getLang('project',107)#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][i]['onclick'] = "windowopen('#request.self#?fuseaction=project.popup_add_workgroup&project_id=#PROJECT_DETAIL.PROJECT_ID#','list')";
				i++;
			} */
			
			
			if (not listfindnocase(denied_pages,'report.cost_analyse_report'))
			{
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][i]['text'] = '#getLang('project',202)#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][i]['href'] = "#request.self#?fuseaction=report.cost_analyse_report&project_id=#project_detail.PROJECT_ID#&project=#URLEncodedFormat(project_detail.PROJECT_HEAD)#";
				i++;
			}
			
	
			if (listFindNoCase(session.ep.user_level,3) and not listfindnocase(denied_pages,'report.pro_material_result'))
			{
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][i]['text'] = '#getLang('project',203)#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][i]['href'] = "#request.self#?fuseaction=report.pro_material_result&project_id=#project_detail.PROJECT_ID#";
				i++;
			}
			
			
			if (not listfindnocase(denied_pages,'report.time_cost_report'))
			{
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][i]['text'] = '#getLang('project',204)#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][i]['href'] = "#request.self#?fuseaction=report.time_cost_report&project_id=#project_detail.PROJECT_ID#&real_start_date_=#Dateformat(project_detail.target_start,'dd/mm/yyyy')#&real_finish_date_=#Dateformat(project_detail.target_finish,'dd/mm/yyyy')#";
				i++;
			}
	
		   if (listFindNoCase(session.ep.user_level,11)  and session.ep.our_company_info.subscription_contract eq 1) 
			{
			   if (len(project_detail.COMPANY_ID))
				{
					tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][i]['text'] = '#getLang('main',2206)#';
					tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][i]['onclick'] = "windowopen('#request.self#?fuseaction=member.popup_list_subscription_contract&cpid=#project_detail.COMPANY_ID#&member_name=#URLEncodedFormat(caller.get_par_info(PROJECT_DETAIL.COMPANY_ID,1,1,0))#&project_id=#attributes.id#','list')";
					i++;
				}
			   else if (len(project_detail.CONSUMER_ID))
				{
					tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][i]['text'] = '#getLang('main',2206)#';
					tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][i]['onclick'] = "windowopen('#request.self#?fuseaction=member.popup_list_subscription_contract&cid=#project_detail.CONSUMER_ID#&member_name=#URLEncodedFormat(caller.get_cons_info(PROJECT_DETAIL.CONSUMER_ID,0,0))#&project_id=#attributes.id#','list')";
					i++;
				}
			}
	
			if (listFindNoCase(session.ep.user_level,23) and not listfindnocase(denied_pages,'ch.list_duty_claim'))
			{
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][i]['text'] = '#getLang('project',205)#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][i]['href'] = "#request.self#?fuseaction=ch.list_duty_claim&project_id=#project_detail.project_id#&project_head=#project_detail.project_head#&is_submitted=1";
				i++;
			}
			
			 if (isdefined('xml_dsp_project_discounts') and xml_dsp_project_discounts eq 1 and not listfindnocase(denied_pages,'project.popup_project_prod_discounts'))
			{
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][i]['text'] = '#getLang('objects2',1636)#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][i]['onclick'] = "windowopen('#request.self#?fuseaction=project.popup_project_prod_discounts&project_id=#project_detail.project_id#','list_horizantal','dsp_project_detail')";
				i++;
			}
	
			if (not listfindnocase(denied_pages,'project.form_add_relation_pbs') and session.ep.our_company_info.workcube_sector is 'tersane')
			{
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][i]['text'] = '#getLang('main',2580)#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][i]['href'] = "#request.self#?fuseaction=project.form_add_relation_pbs&project_id=#attributes.id#";
				i++;
			}
			
			if (not listfindnocase(denied_pages,'project.ms_project_export'))
			{
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][i]['text'] = 'MS Project Export';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][i]['onclick'] = "windowopen('#request.self#?fuseaction=project.emptypopup_ms_project_export&id=#project_detail.project_id#&IsAjax=1','project')";
				i++;
			}
		
/* 			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][i]['text'] = '#getLang('main',345)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][i]['onclick'] = "windowopen('#request.self#?fuseaction=objects.popup_page_warnings&action=project.prodetail&action_name=id&action_id=#attributes.id#','list')"; */
/* 			i++;
 */			
		
			if (not listfindnocase(denied_pages,'project.popup_project_work'))
			{
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['copy']['text'] = '#getLang('main',64)#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['copy']['onclick'] = "windowopen('#request.self#?fuseaction=project.popup_project_work&main_project_id=#attributes.id#','wwide')";
				i++;
			}
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['fa fa-pencil']['text'] = '#getLang('main',52,'güncelle')#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['fa fa-pencil']['href'] = "#request.self#?fuseaction=project.projects&event=upd&id=#project_detail.PROJECT_ID#";
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['list-ul']['href'] = "#request.self#?fuseaction=project.projects";
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['add']['text'] = '#getLang('main',170)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['add']['href'] = "#request.self#?fuseaction=project.projects&event=add";
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['print']['target'] = "_blank";
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['print']['text'] = '#getLang('main',62)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['print']['href'] = '#request.self#?fuseaction=objects.popup_print_files&action_id=#attributes.id#&action=project.projects';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['bell']['text'] = '#getLang('main',345)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['bell']['onClick'] ="window.open('#request.self#?fuseaction=objects.workflowpages&tab=3&action=#attributes.fuseaction#&action_name=project_id&action_id=#project_detail.project_id#&wrkflow=1','Workflow')";
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['fa fa-info-circle']['text'] = '#getLang('main',398)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['fa fa-info-circle']['onclick'] = "openBoxDraggable('#request.self#?fuseaction=objects.popup_list_comp_add_info&info_id=#project_detail.project_id#&type_id=-10')";
			tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);	
		}
		else if(isdefined("attributes.event") and attributes.event is 'add')
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=project.projects";
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";
			tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);	
		}
		else if(isdefined("attributes.event") and attributes.event is 'upd')
		{
			getLang = caller.getLang;
			
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=project.projects";
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('main',170)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=project.projects&event=add";
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['detail']['text'] = '#getLang('main',359)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['detail']['href'] = "#request.self#?fuseaction=project.projects&event=det&id=#attributes.id#";
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['bell']['text'] = '#getLang('main',345)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['bell']['onClick'] ="window.open('#request.self#?fuseaction=objects.workflowpages&tab=3&action=#attributes.fuseaction#&action_name=project_id&action_id=#attributes.id#&wrkflow=1','Workflow')";
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['target'] = "_blank";
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['text'] = '#getLang('','Yazdır','57474')#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['href'] = '#request.self#?fuseaction=objects.popup_print_files&action_id=#attributes.id#&print_type=310';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['fa fa-history']['text'] = '#getLang('','Uyarılar','57757')#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['fa fa-history']['onclick'] = "openBoxDraggable('#request.self#?fuseaction=project.popup_project_history&id=#attributes.id#')";
			
			tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);	
		}
	}
</cfscript>
