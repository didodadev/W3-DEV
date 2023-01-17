<cfscript>
	if(attributes.tabMenuController eq 0)
	{
		WOStruct = StructNew();
		
		WOStruct['#attributes.fuseaction#'] = structNew();	
		
		WOStruct['#attributes.fuseaction#']['default'] = 'add';
		if(not isdefined('attributes.event'))
			attributes.event = WOStruct['#attributes.fuseaction#']['default'];
			WOStruct['#attributes.fuseaction#']['add'] = structNew();
			WOStruct['#attributes.fuseaction#']['add']['window'] = 'popup';
			WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = '#listgetat(attributes.fuseaction,1,'.')#.employee_relative';
			WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/hr/form/add_relative.cfm';
			WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'V16/hr/query/add_relative.cfm';
		
	 	if(isdefined("attributes.employee_id"))
			
		{
			WOStruct['#attributes.fuseaction#']['upd'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd']['window'] = 'popup';
			WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = '#listgetat(attributes.fuseaction,1,'.')#.employee_relative';
			WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'V16/hr/form/upd_relative.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'V16/hr/query/upd_relative.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.employee_id#'; 
			WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = '#listgetat(attributes.fuseaction,1,'.')#.employee_relative&event=upd&employee_id=';

			WOStruct['#attributes.fuseaction#']['del'] = structNew();
			WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
			WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#listgetat(attributes.fuseaction,1,'.')#.employee_relative';
			WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16/hr/query/del_relative.cfm';
			WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/hr/query/del_relative.cfm';
			WOStruct['#attributes.fuseaction#']['del']['Identity'] = '#attributes.employee_id#'; 

			WOStruct['#attributes.fuseaction#']['list'] = structNew();
			WOStruct['#attributes.fuseaction#']['list']['window'] = 'popup';
			WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = '#listgetat(attributes.fuseaction,1,'.')#.employee_relative';
			WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/hr/display/list_emp_relatives.cfm';
			WOStruct['#attributes.fuseaction#']['list']['Identity'] = '#attributes.employee_id#'; 
	
		}
	}
	else 
	{
		fuseactController = caller.attributes.fuseaction;
		getLang = caller.getLang;
		tabMenuStruct = StructNew();
		tabMenuStruct['#fuseactController#'] = structNew();
		tabMenuStruct['#fuseactController#']['tabMenus'] = structNew();
		tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();
		tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons'] = structNew();
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);	
	}
</cfscript>