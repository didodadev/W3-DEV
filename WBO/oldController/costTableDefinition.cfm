<cf_get_lang_set module_name="account">
<cfinclude template="../account/query/get_cost_table.cfm">
<cfscript>
	// Switch //
	WOStruct = StructNew();
	
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['default'] = 'addUpd';
	
	if(not isDefined("attributes.event"))
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];
	
	WOStruct['#attributes.fuseaction#']['addUpd'] = structNew();
	WOStruct['#attributes.fuseaction#']['addUpd']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['addUpd']['fuseaction'] = 'account.form_add_cost_table_def';
	WOStruct['#attributes.fuseaction#']['addUpd']['filePath'] = 'account/form/add_cost_table_def.cfm';
	WOStruct['#attributes.fuseaction#']['addUpd']['queryPath'] = 'account/query/add_cost_table_def.cfm';
	WOStruct['#attributes.fuseaction#']['addUpd']['nextEvent'] = 'account.form_add_cost_table_def';
	WOStruct['#attributes.fuseaction#']['addUpd']['Identity'] = '';
	
</cfscript>
