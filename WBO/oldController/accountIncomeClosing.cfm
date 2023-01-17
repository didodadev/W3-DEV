<cfset url_str = ''>
<cfif isdefined("attributes.start_date") and len(attributes.start_date)>
	<cfset url_str = "#url_str#&start_date=#attributes.start_date#">
</cfif>
<cfif isdefined("attributes.finish_date") and len(attributes.finish_date)>
	<cfset url_str = "#url_str#&finish_date=#attributes.finish_date#">
</cfif> 
<cfinclude template="../account/query/account_closed_definition_end.cfm">
<cfscript>
	// Switch //
	WOStruct = StructNew();
	
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['default'] = 'add';
	
	if(not isdefined('attributes.event'))
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'account.account_closed_definition_end';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'account/form/account_closed_definition_end.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'account/query/account_closed_definition_end.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'account.account_closed_definition_end';
	
	WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
	WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'accountIncomeClosing';
	WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'add';
	WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'ACCOUNT_CARD';
	WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'period';
	WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item-1','item-2']"; 
</cfscript>
<script type="text/javascript">
	function control()
	{
		if(document.getElementById('process_date').value == '')
		{
			alert('<cf_get_lang dictionary_id="59298.Lütfen işlem tarihi giriniz">!');		
			return false;
		}
		if(document.getElementById('card_type').value == '')
		{
			alert('<cf_get_lang dictionary_id="59299.Lütfen fiş türü seçiniz !">!');
			return false;
		}
		document.getElementById('save_record').value = 1;
		return true;
	}
</script>
