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
