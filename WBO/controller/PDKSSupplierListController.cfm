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
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = '#listGetAt(attributes.fuseaction,1,'.')#.list_emp_daily_in_out_row';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/hr/display/list_emp_daily_in_out_row.cfm';
		
		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = '#listGetAt(attributes.fuseaction,1,'.')#.list_emp_daily_in_out_row';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/hr/form/add_emp_daily_in_out.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = '/V16/hr/query/add_emp_daily_in_out.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = '#listGetAt(attributes.fuseaction,1,'.')#.list_emp_daily_in_out_row&event=upd&row_id=';	
		
		if(isdefined("attributes.row_id"))
		{
			WOStruct['#attributes.fuseaction#']['upd'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = '#listGetAt(attributes.fuseaction,1,'.')#.list_emp_daily_in_out_row';
			WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'V16/hr/form/upd_emp_daily_in_out.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'V16/hr/query/upd_emp_daily_in_out.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.row_id#';
			WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = '#listGetAt(attributes.fuseaction,1,'.')#.list_emp_daily_in_out_row&event=upd&row_id=';
			
			WOStruct['#attributes.fuseaction#']['del'] = structNew();
			WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
			WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=#fusebox.circuit#.emptypopup_del_emp_daily_in_out&row_id=#attributes.row_id#';
			WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16/hr/query/del_emp_daily_in_out.cfm';
			WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/hr/query/del_emp_daily_in_out.cfm';
			WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = '#listGetAt(attributes.fuseaction,1,'.')#.list_emp_daily_in_out_row';
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
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['text'] = '#getLang('main','Liste',57509)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=#listGetAt(attributes.fuseaction,1,'.')#.list_emp_daily_in_out_row";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";
		}
		
		else if(caller.attributes.event is 'upd')
		{
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main','Liste',57509)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=#listGetAt(attributes.fuseaction,1,'.')#.list_emp_daily_in_out_row";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('main','Ekle',57582)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=#listGetAt(attributes.fuseaction,1,'.')#.list_emp_daily_in_out_row&event=add";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main','Kaydet',57461)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][0]['text'] = '#getLang('main','Tarihçe',57473)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][0]['onClick'] = "windowopen('#request.self#?fuseaction=#listGetAt(attributes.fuseaction,1,'.')#.popup_daily_in_out_history&row_id=#attributes.row_id#','wide');";
		}
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
	WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'EMPLOYEE_DAILY_IN_OUT';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'ROW_ID';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-employee_id','item-startdate','item-finishdate']";
</cfscript>
