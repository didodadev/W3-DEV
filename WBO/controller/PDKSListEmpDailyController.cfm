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
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'hr.list_emp_daily_in_out_mails';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/hr/display/list_emp_daily_in_out_mails.cfm';
		WOStruct['#attributes.fuseaction#']['list']['nextEvent'] = 'hr.list_emp_daily_in_out_mails';

	}
	else
	{

	}
</cfscript>