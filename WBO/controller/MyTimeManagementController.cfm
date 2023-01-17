<cfscript>
	if(attributes.tabMenuController eq 0)
	{

		WOStruct = StructNew();
		
		WOStruct['#attributes.fuseaction#'] = structNew();
		
		WOStruct['#attributes.fuseaction#']['default'] = 'list';
		
		WOStruct['#attributes.fuseaction#']['list'] = structNew();
		WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'myhome.mytime_management';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/myhome/display/mytime_management.cfm';
		
		
		if(isdefined("attributes.event") and attributes.event is 'add')
		{
			WOStruct['#attributes.fuseaction#']['add'] = structNew();
			WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'myhome.emptypopup_form_add_timecost';
			WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/myhome/display/time_cost.cfm';
			WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'V16/myhome/query/add_time_cost.cfm';
			WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'myhome.mytime_management';
		}
		
		
		if( ( isdefined("attributes.event") and (attributes.event is 'upd' OR attributes.event is 'del')))
		{
			WOStruct['#attributes.fuseaction#']['upd'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'myhome.emptypopup_form_add_timecost';
			WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'V16/myhome/display/upd_time_cost.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'V16/myhome/query/upd_time_cost.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'myhome.mytime_management&event=upd&event=upd';
			WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'time_cost_id=##time_cost_id_##';
			WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.time_cost_id##';
		
			WOStruct['#attributes.fuseaction#']['del'] = structNew();
			WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
			WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'myhome.emptypopup_del_time_cost';
			WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16/myhome/query/del_time_cost.cfm';
			WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/myhome/query/del_time_cost.cfm';
			WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'myhome.mytime_management&event=list';
			WOStruct['#attributes.fuseaction#']['del']['parameters'] = 'time_cost_id=##attributes.time_cost_id##';
			WOStruct['#attributes.fuseaction#']['del']['Identity'] = '##attributes.time_cost_id##';
			WOStruct['#attributes.fuseaction#']['del']['extraParams'] = 'active_period&old_process_type&del_time_cost_id';
			
		}
		
		
		//WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
//		WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'MyTimeManagmentController';
//		WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'add,upd';
//		WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'TIME_COST';
//		WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'main';
//		WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item-comment','item-total_time_hour']"; // Bu atama yapılmazsa sayfada her alan değiştirilebilir olur.


	}
	else
	{			
			
			getLang = caller.getLang;
			denied_pages = caller.denied_pages;
			
			tabMenuStruct = StructNew();
			tabMenuStruct['#attributes.fuseaction#'] = structNew();
			tabMenuStruct['#attributes.fuseaction#']['tabMenus'] = structNew();
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['list'] = structNew();
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['list']['menus'] = structNew();
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['list']['icons']['fa fa-plus']['text'] = '#getLang('','Ekle','57582')#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['list']['icons']['fa fa-plus']['onclick'] = "openBoxDraggable('#request.self#?fuseaction=myhome.mytime_management&event=add')";
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['list']['menus'][0]['text'] = '#getLang('','Haftalık Zaman Harcaması','31368')#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['list']['menus'][0]['href'] = "#request.self#?fuseaction=myhome.upd_myweek";

			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['list']['menus'][1]['text'] = '#getLang('','Aylık Zaman Harcaması','31156')#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['list']['menus'][1]['href'] = "#request.self#?fuseaction=myhome.timecost_calendar";
			if(isdefined("attributes.event") and attributes.event is 'upd')
			{
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd'] = structNew();
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'] = structNew();
				i = 0;
				/*UPD_WORK = caller.UPD_WORK;*/
				
				
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('main',170)#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['href'] = "#request.self#?fuseaction=myhome.time_cost";
				i++;
				
			
			}
			tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);

	}

</cfscript>


