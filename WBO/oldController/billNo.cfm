<cf_get_lang_set module_name="account">
<cfinclude template="../account/query/get_bill_no.cfm">
<cfscript>
	// Switch //
	WOStruct = StructNew();
	
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['default'] = 'addUpd';
	
	if(not isdefined('attributes.event'))
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];
	
	WOStruct['#attributes.fuseaction#']['addUpd'] = structNew();
	WOStruct['#attributes.fuseaction#']['addUpd']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['addUpd']['fuseaction'] = 'account.bill_no';
	WOStruct['#attributes.fuseaction#']['addUpd']['filePath'] = 'account/form/bill_no.cfm';
	WOStruct['#attributes.fuseaction#']['addUpd']['queryPath'] = 'account/query/add_bill_no.cfm';
	WOStruct['#attributes.fuseaction#']['addUpd']['nextEvent'] = 'account.bill_no';
	WOStruct['#attributes.fuseaction#']['addUpd']['Identity'] = '';

</cfscript>
