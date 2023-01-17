<cf_get_lang_set module_name="account">
<cfif isdefined('attributes.date1') and isdefined('attributes.date2') and isdate(attributes.date1) and isdate(attributes.date2)>
	<cfset tarih_1=attributes.date1 >
	<cfset tarih_2=attributes.date2 >
<cfelse>
	<cfset tarih_1="01/01/#session.ep.period_year#">
	<cfset tarih_2="31/12/#session.ep.period_year#">
</cfif>
<cf_date tarih='tarih_1'>
<cf_date tarih='tarih_2'>
<cfquery name="GET_FIN_TABLES" datasource="#DSN3#">
	SELECT 
		*
	FROM
		SAVE_ACCOUNT_TABLES
	WHERE
		PERIOD_ID = #session.ep.period_id# AND 
		TABLE_DATE >= #tarih_1# AND
		TABLE_DATE <= #tarih_2#		
		<cfif attributes.fuseaction is 'account.list_scale_record' or attributes.fuseaction is 'account.autoexcelpopuppage_list_scale_record'>
			AND TABLE_NAME='SCALE_TABLE' AND ( TABLE_DATE_LAST <= #tarih_2# OR TABLE_DATE_LAST IS NULL)
		<cfelseif attributes.fuseaction is 'account.list_income_table_record' or attributes.fuseaction is 'account.autoexcelpopuppage_list_income_table_record'>
			AND TABLE_NAME='INCOME_TABLE'
		<cfelseif attributes.fuseaction is 'account.list_cost_table_record' or attributes.fuseaction is 'account.autoexcelpopuppage_list_cost_table_record'>
			AND TABLE_NAME='COST_TABLE'
		<cfelseif attributes.fuseaction is 'account.list_balance_sheet_record' or attributes.fuseaction is 'account.autoexcelpopuppage_list_balance_sheet_record'>
			AND TABLE_NAME='BALANCE_TABLE'
		<cfelseif attributes.fuseaction is 'account.list_cash_flow_records' or attributes.fuseaction is 'account.autoexcelpopuppage_list_cash_flow_records'>
			AND TABLE_NAME='CASH_FLOW_TABLE'
		<cfelseif attributes.fuseaction is 'account.list_fund_flow_records' or attributes.fuseaction is 'account.autoexcelpopuppage_list_fund_flow_records'>
			AND TABLE_NAME='FUND_FLOW_TABLE'
		</cfif>
</cfquery>
<cfset date_1 = dateformat(tarih_1,'dd/mm/yyyy')>
<cfset date_2 = dateformat(tarih_2,'dd/mm/yyyy')>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.totalrecords" default="#GET_FIN_TABLES.recordcount#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfsavecontent variable="header_">
	<cfif attributes.fuseaction is 'account.list_scale_record' or attributes.fuseaction is 'account.autoexcelpopuppage_list_scale_record'>
		<cf_get_lang no='13.mizan tabloları'>
	<cfelseif attributes.fuseaction is 'account.list_income_table_record' or attributes.fuseaction is 'account.autoexcelpopuppage_list_income_table_record'>
		<cf_get_lang no='14.gelir tabloları'>
	<cfelseif attributes.fuseaction is 'account.list_cost_table_record' or attributes.fuseaction is 'account.autoexcelpopuppage_list_cost_table_record'>
		<cf_get_lang no='23.Satis maliyet tabloları'>
	<cfelseif attributes.fuseaction is 'account.list_balance_sheet_record' or attributes.fuseaction is 'account.autoexcelpopuppage_list_balance_sheet_record'>
		<cf_get_lang no='36.Bilançolar'>
	<cfelseif attributes.fuseaction is 'account.list_cash_flow_records' or attributes.fuseaction is 'account.autoexcelpopuppage_list_cash_flow_records'>
		<cf_get_lang no='5.Nakit Akım Tablosu'>
	<cfelseif attributes.fuseaction is 'account.list_fund_flow_records' or attributes.fuseaction is 'account.autoexcelpopuppage_list_fund_flow_records'>
		<cf_get_lang no='10.Fon Akım Tablosu'>
	</cfif>
</cfsavecontent>

<script>
	function kontrol()
	{
		if( !date_check(document.getElementById('date1'),document.getElementById('date2'), "<cf_get_lang_main no='1450.Başlangıç Tarihi Bitiş Tarihinden Büyük Olamaz'>!") )
			return false;
		else
			return true;
	}
</script>

<cfscript>
	// Switch //
	WOStruct = StructNew();
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	if(not isdefined('attributes.event'))
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];
		
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'account.list_income_table_record';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'account/display/list_fintab.cfm';
	
	WOStruct['#attributes.fuseaction#']['del'] = structNew();
	WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
	WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'account.list_income_table_record';
	WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'account/query/del_fintab.cfm';
	WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'account/query/del_fintab.cfm';
	WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'account.list_income_table_record';
	/*
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'finance.list_creditcard';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'finance/form/upd_creditcard.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'finance/query/upd_creditcard.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'finance.list_creditcard&event=upd';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'creditcard_id=##attributes.creditcard_id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.creditcard_id##';
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'finance.list_creditcard';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'finance/form/add_creditcard.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'finance/query/add_creditcard.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'finance.list_creditcard&event=upd';
	
	if(IsDefined("attributes.event") && attributes.event is 'upd')
	{
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#lang_array_main.item[170]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=finance.list_creditcard&event=add";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	} */
</cfscript>

