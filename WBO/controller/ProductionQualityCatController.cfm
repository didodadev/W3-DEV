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
			WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'quality.control_standarts';
			WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/settings/display/list_quality_control_types.cfm';
			
			WOStruct['#attributes.fuseaction#']['add'] = structNew();
			WOStruct['#attributes.fuseaction#']['add']['window'] = 'popup';
			WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'quality.control_standarts';
			WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/settings/form/add_qualty_control_type.cfm';
			WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'V16/settings/query/add_quality_type.cfm';
			WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'quality.control_standarts';
			WOStruct['#attributes.fuseaction#']['add']['formName'] = 'add_qualty_type';
			
			WOStruct['#attributes.fuseaction#']['addResult'] = structNew();
			WOStruct['#attributes.fuseaction#']['addResult']['window'] = 'popup';
			WOStruct['#attributes.fuseaction#']['addResult']['fuseaction'] = 'quality.control_standarts';
			WOStruct['#attributes.fuseaction#']['addResult']['filePath'] = 'V16/settings/form/add_quality_control_result.cfm';
			WOStruct['#attributes.fuseaction#']['addResult']['queryPath'] = 'V16/settings/query/add_quality_control_result.cfm';
			WOStruct['#attributes.fuseaction#']['addResult']['nextEvent'] = 'quality.control_standarts';
			WOStruct['#attributes.fuseaction#']['addResult']['formName'] = 'upd_quality_type';
			
			if(isdefined("attributes.type_id"))
			{
				WOStruct['#attributes.fuseaction#']['upd'] = structNew();
				WOStruct['#attributes.fuseaction#']['upd']['window'] = 'popup';
				WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'quality.control_standarts';
				WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'V16/settings/form/add_qualty_control_type.cfm';
				WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'V16/settings/query/add_quality_type.cfm';
				WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'quality.control_standarts&event=upd&type_id';
				WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.type_id#';

				WOStruct['#attributes.fuseaction#']['del'] = structNew();
				WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
				WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=settings.emptypopup_del_q_control_result&type_id=#attributes.type_id#';
				WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16/settings/query/del_quality_control_type.cfm';
				WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/settings/query/del_quality_control_type.cfm';
				WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'quality.control_standarts';
				WOStruct['#attributes.fuseaction#']['del']['Identity'] = '#attributes.type_id#';
			}
			if(isdefined("attributes.result_id"))
			{
				WOStruct['#attributes.fuseaction#']['updResult'] = structNew();
				WOStruct['#attributes.fuseaction#']['updResult']['window'] = 'popup';
				WOStruct['#attributes.fuseaction#']['updResult']['fuseaction'] = 'quality.control_standarts';
				WOStruct['#attributes.fuseaction#']['updResult']['filePath'] = 'V16/settings/form/add_quality_control_result.cfm';
				WOStruct['#attributes.fuseaction#']['updResult']['queryPath'] = 'V16/settings/query/add_quality_control_result.cfm';
				WOStruct['#attributes.fuseaction#']['updResult']['nextEvent'] = 'quality.control_standarts&event=updResult&result_id';
				WOStruct['#attributes.fuseaction#']['updResult']['Identity'] = '#attributes.result_id#';	
				
				if(listFind('updResult,del',attributes.event))
				{
					WOStruct['#attributes.fuseaction#']['del'] = structNew();
					WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
					WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=settings.emptypopup_del_q_control_result&id=#attributes.result_id#&result_id=#attributes.result_id#';
					WOStruct['#attributes.fuseaction#']['del']['extraParams'] = 'type_id';
					WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16/settings/query/del_quality_control_result.cfm';
					WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/settings/query/del_quality_control_result.cfm';
					WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'quality.control_standarts';
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
					tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=quality.control_standarts";
					tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
					tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";
				}
			else if(caller.attributes.event is 'upd')
				{
					tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();
					tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('main',170)#';
					tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=quality.control_standarts&event=add";
					tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
					tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['target'] = "_blank";
					tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
					tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=quality.control_standarts";
					tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main',49)#';
					tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";
				}
				else if(caller.attributes.event is 'addResult')
				{
					tabMenuStruct['#fuseactController#']['tabMenus']['addResult']['icons'] = structNew();
					tabMenuStruct['#fuseactController#']['tabMenus']['addResult']['icons']['list-ul']['target'] = "_blank";
					tabMenuStruct['#fuseactController#']['tabMenus']['addResult']['icons']['list-ul']['text'] = '#getLang('main',97)#';
					tabMenuStruct['#fuseactController#']['tabMenus']['addResult']['icons']['list-ul']['href'] = "#request.self#?fuseaction=quality.control_standarts";
					tabMenuStruct['#fuseactController#']['tabMenus']['addResult']['icons']['check']['text'] = '#getLang('main',49)#';
					tabMenuStruct['#fuseactController#']['tabMenus']['addResult']['icons']['check']['onClick'] = "buttonClickFunction()";
				}
				else if(caller.attributes.event is 'updResult')
				{
					tabMenuStruct['#fuseactController#']['tabMenus']['updResult']['icons'] = structNew();
					tabMenuStruct['#fuseactController#']['tabMenus']['updResult']['icons']['add']['text'] = '#getLang('main',170)#';
					tabMenuStruct['#fuseactController#']['tabMenus']['updResult']['icons']['add']['href'] = "#request.self#?fuseaction=quality.control_standarts&event=addResult&type_id";
					tabMenuStruct['#fuseactController#']['tabMenus']['updResult']['icons']['add']['target'] = "_blank";
					tabMenuStruct['#fuseactController#']['tabMenus']['updResult']['icons']['list-ul']['target'] = "_blank";
					tabMenuStruct['#fuseactController#']['tabMenus']['updResult']['icons']['list-ul']['text'] = '#getLang('main',97)#';
					tabMenuStruct['#fuseactController#']['tabMenus']['updResult']['icons']['list-ul']['href'] = "#request.self#?fuseaction=quality.control_standarts";
					tabMenuStruct['#fuseactController#']['tabMenus']['updResult']['icons']['check']['text'] = '#getLang('main',49)#';
					tabMenuStruct['#fuseactController#']['tabMenus']['updResult']['icons']['check']['onClick'] = "buttonClickFunction()";
				}
			tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
		}
			WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
			WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd,addResult,updResult,del';
			WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'QUALITY_CONTROL_TYPE,QUALITY_CONTROL_ROW';
			WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'PROCESS_CAT_ID,QUALITY_CONTROL_ROW_ID';
			WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-status','item-default_value','item-meausure_value','item-tolerans_value','item-control_type']";
</cfscript>

