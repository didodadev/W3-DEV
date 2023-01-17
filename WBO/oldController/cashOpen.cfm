<cf_get_lang_set module_name="cash">
<cfif not isdefined("attributes.event")>
	<cfset attributes.event = "add">
</cfif>
<cfif not isdefined("attributes.id")>
	<cfset attributes.id = "">
</cfif>
<cfset processCat = "">
<cfset date_info = now()>
<cfset actionValue = "">
<cfset otherValue = "">
<cfset actionDetail = "">
<cfinclude template="../cash/query/get_cashes.cfm">
<cfif attributes.event eq "add">
	<cfset cash_status = 1>
    <cfset change_money_info = "change_money_info">
<cfelseif attributes.event eq "upd">
	<cfset attributes.TABLE_NAME = "CASH_ACTIONS">
    <cfinclude template="../cash/query/get_action_detail.cfm">
    <cfset processCat = get_action_detail.process_cat>
    <cfset date_info = get_action_detail.action_date>
    <cfset change_money_info = "">
    <cfset actionValue = TLFormat(get_action_detail.CASH_ACTION_VALUE)>
    <cfset otherValue = TLFormat(get_action_detail.OTHER_CASH_ACT_VALUE)>
    <cfset actionDetail = get_action_detail.ACTION_DETAIL>
</cfif>
<script type="text/javascript">
	$(document).ready(function(){
		<cfif attributes.event eq "add">
			change_currency_info();
		</cfif>
		kur_ekle_f_hesapla('CASH_ACTION_TO_CASH_ID');
	});
	
	function unformat_fields()
	{
		document.getElementById('CASH_ACTION_VALUE').value = filterNum(document.getElementById('CASH_ACTION_VALUE').value);
		document.getElementById('OTHER_CASH_ACT_VALUE').value = filterNum(document.getElementById('OTHER_CASH_ACT_VALUE').value);
		document.getElementById('system_amount').value = filterNum(document.getElementById('system_amount').value);
		for(var i=1;i<=open_cash.kur_say.value;i++)
		{
			document.getElementById('txt_rate1_' + i).value = filterNum(document.getElementById('txt_rate1_' + i).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
			document.getElementById('txt_rate2_' + i).value = filterNum(document.getElementById('txt_rate2_' + i).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
		}
		<cfif attributes.event eq "upd">
			document.getElementById('CASH_ACTION_TO_CASH_ID').disabled = false;
		</cfif>
		return true;
	}
	<cfif attributes.event eq "add">
		function change_currency_info()
		{
			if(document.getElementById("CASH_ACTION_TO_CASH_ID") != undefined)
			{
				new_kur_say = document.all.kur_say.value;
				var currency_type_2 = list_getat(open_cash.CASH_ACTION_TO_CASH_ID.options[open_cash.CASH_ACTION_TO_CASH_ID.options.selectedIndex].value,2,';');
				for(var i=1;i<=new_kur_say;i++)
				{
					if(eval('document.all.hidden_rd_money_'+i) != undefined && eval('document.all.hidden_rd_money_'+i).value == currency_type_2)
						eval('document.all.rd_money['+(i-1)+']').checked = true;
				}
				kur_ekle_f_hesapla('CASH_ACTION_TO_CASH_ID');
			}
		}
	</cfif>
	function kontrol()
	{
		if(!chk_process_cat('open_cash')) return false;
		if(!check_display_files('open_cash')) return false;
		<cfif attributes.event eq "add">
			if(!chk_period(open_cash.ACTION_DATE,'<cf_get_lang_main no="280.İşlem">')) return false;
		</cfif>
		unformat_fields();
		return true;
	}
</script>
<cfscript>
	// Switch //
	WOStruct = StructNew();
	
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['default'] = 'add';
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'cash.form_add_cash_open';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'cash/form/form_cash_open.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'cash/query/add_cash_open.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'cash.form_add_cash_open&event=upd';
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'cash.form_add_cash_open';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'cash/form/form_cash_open.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'cash/query/upd_cash_open.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'cash.form_add_cash_open&event=upd';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'id=##attributes.id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.id##';
	
	if(attributes.event is 'upd')
	{
		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'cash.del_cash_open&event=del&id=#attributes.id#';
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'cash/query/del_cash_open.cfm';
		WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'cash/query/del_cash_open.cfm';
		WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'cash.list_cash_actions';
		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#lang_array_main.item[170]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=cash.form_add_cash_open";
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
	WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'CashOpen';
	WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'CASH_ACTIONS';
	WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'period';
	WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item-processCat','item-CASH_ACTION_TO_CASH_ID','item-ACTION_DATE','item-CASH_ACTION_VALUE']";
</cfscript>
