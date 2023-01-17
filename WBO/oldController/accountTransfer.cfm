<cf_xml_page_edit>
<cf_get_lang_set module_name = "account">
<cfquery name="get_acc_card_type" datasource="#dsn3#">
    SELECT PROCESS_TYPE,PROCESS_CAT_ID,PROCESS_CAT FROM SETUP_PROCESS_CAT WHERE PROCESS_TYPE IN (10,11,12,13,14,19) ORDER BY PROCESS_TYPE
</cfquery>
<cfscript>
	// Switch //
	WOStruct = StructNew();
	
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['default'] = 'add';
	
	if(not isdefined('attributes.event'))
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'account.add_acc_to_acc';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'account/form/add_acc_to_acc.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'account/query/add_acc_to_acc.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'account.add_acc_to_acc';
	
	WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
	WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'accountTransfer';
	WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'add';
	WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'ACCOUNT_CARD';
	WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'period';
	WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item-2'']"; 
</cfscript>
<script type="text/javascript">
	function pencere_ac(isim)
	{
		temp_account_code = eval('add_acc_to_acc.'+isim);
		if(isim=='FROM_ACC_ID')
		{
			<cfif isdefined('xml_dsp_top_account') and xml_dsp_top_account eq 1>
				windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan_all&field_id=add_acc_to_acc.'+isim+'&field_name=add_acc_to_acc.FROM_ACC_NAME&keyword='+ temp_account_code.value,'list');
			<cfelse>
				windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_id=add_acc_to_acc.'+isim+'&field_name=add_acc_to_acc.FROM_ACC_NAME&account_code=' + temp_account_code.value, 'list');
			</cfif>
		}
		else
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_id=add_acc_to_acc.'+isim+'&field_name=add_acc_to_acc.TO_ACC_NAME&account_code=' + temp_account_code.value, 'list');
	}
	
	function kontrol()
	{
		if(document.add_acc_to_acc.is_acc_remainder_transfer.checked==true)
		{
			if (!chk_period(document.add_acc_to_acc.ACTION_DATE,'İşlem')) return false;
		}
		else
		{
			if (!confirm('<cf_get_lang dictionary_id="59054.Seçtiğiniz Hesaba Ait Tüm Hareketler Aktarılacaktır. İşlem Geri Alınamaz.">')) return false;
		}
	
		if (document.add_acc_to_acc.TO_ACC_ID.value == document.add_acc_to_acc.FROM_ACC_ID.value && document.add_acc_to_acc.FROM_ACC_ID.value !='' )				
		{
			alert("<cf_get_lang no='41.Seçtiğiniz Hesaplar Aynı'>!");		
			return false; 
		}
		return true;
	}
</script>
