<cf_get_lang_set module_name="account">
<cfinclude template="../account/query/get_balance_sheet.cfm">
<cfinclude template="../account/query/get_balance_setup.cfm">
<cfscript>
	// Switch //
	WOStruct = StructNew();
	
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['default'] = 'addUpd';
	
	if(not isdefined('attributes.event'))
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];
	
	WOStruct['#attributes.fuseaction#']['addUpd'] = structNew();
	WOStruct['#attributes.fuseaction#']['addUpd']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['addUpd']['fuseaction'] = 'account.form_add_balance_sheet_def';
	WOStruct['#attributes.fuseaction#']['addUpd']['filePath'] = 'account/form/add_balance_sheet_def.cfm';
	WOStruct['#attributes.fuseaction#']['addUpd']['queryPath'] = 'account/query/add_balance_sheet_def.cfm';
	WOStruct['#attributes.fuseaction#']['addUpd']['nextEvent'] = 'account.form_add_balance_sheet_def';
	WOStruct['#attributes.fuseaction#']['addUpd']['Identity'] = '';

</cfscript>
