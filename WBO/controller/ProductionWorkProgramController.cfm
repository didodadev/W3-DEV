<cfscript>	
	if(attributes.tabMenuController eq 0)
		{
			WOStruct = StructNew();
			WOStruct['#attributes.fuseaction#'] = structNew();
			WOStruct['#attributes.fuseaction#']['default'] = 'list';
			WOStruct['#attributes.fuseaction#']['list'] = structNew();
			WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'prod.list_ws_time';
			WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/production_plan/display/list_ws_time.cfm';
			
			WOStruct['#attributes.fuseaction#']['add'] = structNew();
			WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'ehesap.popup_form_add_shift';
			WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/hr/ehesap/form/form_add_shift.cfm';
			WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'V16/hr/ehesap/query/add_shift.cfm';
			WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'prod.list_ws_time&event=upd&shift_id';
			
			if(isdefined("attributes.shift_id"))
			{
			
				WOStruct['#attributes.fuseaction#']['upd'] = structNew();
				WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
				WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'ehesap.popup_form_upd_shift';
				WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'V16/hr/ehesap/form/form_upd_shift.cfm';
				WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'V16/hr/ehesap/query/upd_shift.cfm';
				WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'prod.list_ws_time&event=upd&shift_id';
				WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'shift_id=##attributes.shift_id##';
				WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.shift_id##';
				
				WOStruct['#attributes.fuseaction#']['del'] = structNew();
				WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
				WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=ehesap.emptypopup_del_shift&SHIFT_ID=##caller.attributes.shift_id##';
				WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16/hr/ehesap/query/del_shift.cfm';
				WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/hr/ehesap/query/del_shift.cfm';
				WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'prod.list_ws_time';
					
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
				tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=prod.list_ws_time";
				tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";
			}
			else if(caller.attributes.event is 'upd')
			{
				
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('main',170)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['onClick'] = "window.location.href='#request.self#?fuseaction=prod.list_ws_time&event=add';";
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['target'] = "_blank";
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=prod.list_ws_time";
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main',49)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";

				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['bell']['text'] = '#getlang(345,'Uyarılar',57757)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['bell']['onClick'] = "window.open('#request.self#?fuseaction=objects.workflowpages&tab=3&action=#attributes.fuseaction#&action_name=shift_id&action_id=#attributes.shift_id#&wrkflow=1','Workflow')";
			}
			tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
		}
	WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
	WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'SETUP_SHIFTS';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'SHIFT_ID';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-date','item-branch_id','item-startdate','item-branch_id']";

</cfscript>
