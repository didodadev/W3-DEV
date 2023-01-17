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
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'ehesap.list_emp_bes';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/hr/ehesap/display/list_emp_bes.cfm';	
		
		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'popup';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'ehesap.list_emp_bes';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/hr/ehesap/form/form_add_bes_single.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'V16/hr/ehesap/query/add_bes_single.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'ehesap.list_emp_bes';

		WOStruct['#attributes.fuseaction#']['addMulti'] = structNew();
		WOStruct['#attributes.fuseaction#']['addMulti']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['addMulti']['fuseaction'] = 'ehesap.list_emp_bes';
		WOStruct['#attributes.fuseaction#']['addMulti']['filePath'] = 'V16/hr/ehesap/form/popup_form_add_bes_all.cfm';
		WOStruct['#attributes.fuseaction#']['addMulti']['queryPath'] = 'V16/hr/ehesap/query/add_bes_all.cfm';
		WOStruct['#attributes.fuseaction#']['addMulti']['nextEvent'] = 'ehesap.list_emp_bes';
		
	}
</cfscript>
