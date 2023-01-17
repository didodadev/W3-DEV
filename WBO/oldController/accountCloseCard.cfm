<cf_get_lang_set module_name = 'settings'>
<cfquery name="get_period" datasource="#dsn#">
	SELECT PERIOD_ID, PERIOD FROM SETUP_PERIOD
</cfquery>
<cfquery name="get_acc_card_type" datasource="#dsn3#">
    SELECT PROCESS_TYPE,PROCESS_CAT_ID,PROCESS_CAT FROM SETUP_PROCESS_CAT WHERE PROCESS_TYPE IN (10,11,12,13,14) ORDER BY PROCESS_TYPE
</cfquery>
<cfscript>
	// Switch //
	WOStruct = StructNew();
	
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['default'] = 'add';
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'settings.form_add_acc_close_card';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'settings/form/add_acc_close_card.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'settings/query/add_acc_close_card.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'settings.form_add_acc_close_card';
	
	WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
	WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'accountCloseCard';
	WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'add';
	WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'ACCOUNT_CARD';
	WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'period';
	WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item-1']"; 
</cfscript>
<script type="text/javascript">
	function kontrol()
	{
		if(document.close_ch.acc_period.value == '')
		{
			alert("<cf_get_lang no='1291.Dönem Seçmelisiniz'>!");
			return false;
		}
		if (confirm("<cf_get_lang no='2944.Seçtiğiniz Dönem İçin Otomatik Kapanış Fişi Oluşturulacaktır Onaylıyor musunuz'>?")) 
			return true; 
		else 
			return false;
	}
</script>
