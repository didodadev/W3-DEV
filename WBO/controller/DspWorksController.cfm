<cfsavecontent variable="update_record"><cf_get_lang dictionary_id="58494.Kaydı Güncelle"></cfsavecontent>
<cfsavecontent variable="deatils"><cf_get_lang dictionary_id="33077.Detaylar"></cfsavecontent>
<cfscript>
	if(attributes.tabMenuController eq 0)
	{
		WOStruct = StructNew();
		
		WOStruct['#attributes.fuseaction#'] = structNew();
		
		WOStruct['#attributes.fuseaction#']['default'] = 'list';
		
		WOStruct['#attributes.fuseaction#']['list'] = structNew();
		WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'project.works';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/project/display/dsp_works.cfm';
		
		
		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'project.addwork';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/project/form/add_work.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'V16/project/query/add_work.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'project.works&event=det&id=';
		WOStruct['#attributes.fuseaction#']['add']['formName'] = 'add_work';

		if(isdefined("attributes.id"))
		{
			WOStruct['#attributes.fuseaction#']['det'] = structNew();
			WOStruct['#attributes.fuseaction#']['det']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['det']['fuseaction'] = 'project.addwork';
			WOStruct['#attributes.fuseaction#']['det']['filePath'] = 'V16/project/form/upd_work.cfm';
			WOStruct['#attributes.fuseaction#']['det']['parameters'] = 'id=##attributes.id##';
			WOStruct['#attributes.fuseaction#']['det']['Identity'] = '#attributes.id#';

			WOStruct['#attributes.fuseaction#']['upd'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'project.addwork';
			WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'V16/project/form/dsp_upd_work.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'V16/project/query/upd_work.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'project.works&event=upd&id=';
			WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'id=##attributes.id##';
			WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.id##';
				
			WOStruct['#attributes.fuseaction#']['del'] = structNew();
			WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
			WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=project.emptypopup_delwork&id=#attributes.id#';
			WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16/project/query/del_work.cfm';
			WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/project/query/del_work.cfm';
			WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'project.works';
			WOStruct['#attributes.fuseaction#']['del']['parameters'] = 'id=##attributes.id##';
			WOStruct['#attributes.fuseaction#']['del']['Identity'] = '##attributes.id##';
		}
		
		if(isdefined("attributes.event") and attributes.event is 'gui')
		{
			WOStruct['#attributes.fuseaction#']['gui'] = structNew();
			WOStruct['#attributes.fuseaction#']['gui']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['gui']['filePath'] = 'V16/project/display/dsp_works_gui.cfm';
		}
		
	}
	else
	{			
			
			getLang = caller.getLang;
			denied_pages = caller.denied_pages;
			fuseactController = caller.attributes.fuseaction;
			dsn = caller.dsn;
			
			tabMenuStruct = StructNew();
			tabMenuStruct['#attributes.fuseaction#'] = structNew();
			tabMenuStruct['#attributes.fuseaction#']['tabMenus'] = structNew();
			if(isdefined("attributes.event") and attributes.event is 'upd' or(isdefined("attributes.event") and attributes.event is 'det'))
			{
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd'] = structNew();
				
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['target'] = "_blank";
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=project.works";
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main',49)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['text'] = '#getLang('main',62)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['onClick'] = "window.open('#request.self#?fuseaction=objects.popup_print_files&action_id=#attributes.id#&print_type=311','WOC')";

				

				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['bell']['text'] = '#getlang('main',345)#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['bell']['href']  = "#request.self#?fuseaction=objects.workflowpages&tab=3&action=#attributes.fuseaction#&action_name=id&action_id=#attributes.id#";
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('main',170)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=project.works&event=add&work_fuse=#attributes.fuseaction#";	
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['target'] = '_blank';
				
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'] = structNew();
				i = 0;
				UPD_WORK = caller.UPD_WORK;
				
				if(not listfindnocase(denied_pages,'objects.popup_form_add_info_plus'))
				{
					tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['fa fa-info-circle']['text'] = '#getLang('main',398)#';
					if(len(UPD_WORK.WORK_CAT_ID))
					tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['fa fa-info-circle']['onclick'] = "cfmodal('#request.self#?fuseaction=objects.popup_list_comp_add_info&info_id=#attributes.id#&type_id=-18&work_catid=#UPD_WORK.WORK_CAT_ID#','warning_modal')";
					else
						tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['fa fa-info-circle']['onclick'] = "cfmodal('#request.self#?fuseaction=objects.popup_list_comp_add_info&info_id=#attributes.id#&type_id=-18','warning_modal')";
				}
				
				if (not listfindnocase(denied_pages,'project.popup_add_work_asset'))
				{
					tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('main',2207)#';
					tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['onclick'] = "window.open('#request.self#?fuseaction=project.popup_add_work_asset&work_id=#upd_work.work_id#','Workflow')";
					i++;
				}
				
				if (isdefined("caller.xml_add_fis") and caller.xml_add_fis eq 1 and len(upd_work.project_id)) 
			    {
				   GET_MATERIAL_LIST = caller.GET_MATERIAL_LIST;
				   if (GET_MATERIAL_LIST.recordcount)
					{
						tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('prod',279)#';
						tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['onclick'] = "get_convert_values()";
						i++;
					}
				   else 
				    {
						tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('prod',279)#';
						tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['onclick'] = "windowopen('#request.self#?fuseaction=stock.form_add_fis&is_from_work=1&work_id=#upd_work.work_id#&service_id=#upd_work.service_id#&pj_id=#upd_work.project_id#&project_head=#caller.get_project_name(upd_work.project_id)#','wwide')";
						i++;
					}
			    }
				
				if (isdefined("caller.xml_add_fis") and caller.xml_add_fis eq 1 and len(upd_work.project_id)) 
			    {
				   GET_MATERIAL_LIST = caller.GET_MATERIAL_LIST;
				   if (GET_MATERIAL_LIST.recordcount)
					{
						tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('project',206)#';
						tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['onclick'] = "windowopen('#request.self#?fuseaction=project.popup_upd_project_material&upd_id=#GET_MATERIAL_LIST.PRO_MATERIAL_ID#&from_work=1','wide')";
						tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['target'] = '_blank';
						i++;
					}
				   else 
				    {
						tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('project',206)#';
						tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['onclick'] = "windowopen('#request.self#?fuseaction=project.popup_add_project_material&project_id=#upd_work.project_id#&work_id=#upd_work.work_id#&from_work=1','wide')";
						tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['target'] = '_blank';
						i++;
					}
			    } 
				
				if (isdefined("caller.xml_production_order") and caller.xml_production_order eq 1)
				{
					tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('prod',65)#';
					tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['href'] = "#request.self#?fuseaction=prod.order&event=add&work_id=#upd_work.work_id#&project_id=#upd_work.project_id#&project_head=#iif(len(upd_work.project_id),'caller.get_project_name(upd_work.project_id)',DE(''))#";
					i++;
				}
				
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('main',1575)#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['href'] = "#request.self#?fuseaction=myhome.list_my_expense_requests&event=add&work_id=#upd_work.work_id#";
				i++;				
				
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('project',49)#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['href'] = "#request.self#?fuseaction=purchase.list_offer&event=Add&work_id=#attributes.id#&company_id=#upd_work.company_id#&partner_id=#upd_work.company_partner_id#";
				i++;
				
				
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('project',51)#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['href'] = "#request.self#?fuseaction=sales.list_offer&event=Add&work_id=#attributes.id#&company_id=#upd_work.company_id#&partner_id=#upd_work.company_partner_id#";
				i++;
				if(isdefined("attributes.event") and attributes.event is 'det'){
					tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['fa fa-pencil']['text'] = '#update_record#';
					tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['fa fa-pencil']['href'] = "#request.self#?fuseaction=project.works&event=upd&id=#attributes.id#";
				}
				else if(isdefined("attributes.event") and attributes.event is 'upd'){
					
					tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('objects2',1129)#';
					tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['onclick'] = "windowopen('#request.self#?fuseaction=agenda.view_daily&event=add&work_id=#attributes.id#&project_id=#upd_work.project_id#','page')";
					i++;

					tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['detail']['text'] = '#deatils#';
					tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['detail']['href'] = "#request.self#?fuseaction=project.works&event=det&id=#attributes.id#";
				}
				tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
			}
			else if(isdefined("attributes.event") and attributes.event is 'add')
			{
				tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons'] = structNew();
				tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['target'] = "_blank";
				tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['text'] = '#getLang('main',97)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=project.works";
				tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";	
				
				tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);

			}
	}
	WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
	WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'PRO_WORKS';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'WORK_ID';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['form_ul_pro_work_cat','form_ul_responsable_name','form_ul_process_stage','form_ul_priority_cat','form_ul_finishdate_plan','form_ul_startdate_plan','form_ul_work_head']";
</cfscript>
