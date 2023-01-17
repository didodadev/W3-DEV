<cf_xml_page_edit>
<cfinclude template="../account/query/get_money.cfm">
<cfquery name="get_branchs" datasource="#dsn#">
	SELECT 
		BRANCH_ID,BRANCH_NAME 
	FROM 
		BRANCH 
	WHERE
		BRANCH_STATUS = 1 
		AND COMPANY_ID = #session.ep.company_id#
	<cfif listgetat(attributes.fuseaction,1,'.') is 'store'>
		AND BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#)
	</cfif>
	ORDER BY BRANCH_NAME
</cfquery>
<cfscript>
	// Switch //
	WOStruct = StructNew();
	
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['default'] = 'add';
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'account.popup_add_account_to_account';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'account/form/add_bill_account_to_account.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'account/query/add_bill_account_to_account_act.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'account.list_cards';
	
	WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
	WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'accountCardAcc2Acc';
	WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'add';
	WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'ACCOUNT_CARD';
	WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'period';
	WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item-2','item-3','item-4']"; 
</cfscript>
<script type="text/javascript">
	function unformat_fields()
	{
		fld=document.acc2Acc.ACTION_VALUE;
		fld.value=filterNum(fld.value);
		document.acc2Acc.to_account_value.value = filterNum(document.acc2Acc.to_account_value.value);
		document.acc2Acc.from_account_value.value = filterNum(document.acc2Acc.from_account_value.value);
	}
	function open_acc_list()
	{
	   windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_id=acc2Acc.to_account_id&field_name=acc2Acc.to_account_name','list');
	}
	
	function kontrol()
	{
		if (!chk_period(document.acc2Acc.ACTION_DATE,'İşlem')) return false;
		if (document.acc2Acc.to_account_id.value == document.acc2Acc.from_account_id.value && document.acc2Acc.from_account_id.value !='' )				
		{
			alert('<cf_get_lang dictionary_id="47303.Seçtiğiniz Hesaplar Aynı">!');		
			return false; 
		}
		unformat_fields();
		return true;
	}
</script>
