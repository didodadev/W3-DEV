<!--- gündem-ben altındaki harcamalarım sayfası querysi--->
<cfquery name="GET_EXPENSE_ITEM_ROW_ALL" datasource="#DSN2#">
	SELECT 
		EXPENSE_ITEMS_ROWS.EXPENSE_ID,
		EXPENSE_ITEMS_ROWS.EXPENSE_EMPLOYEE,
		EXPENSE_ITEMS_ROWS.EXP_ITEM_ROWS_ID,
		EXPENSE_ITEMS_ROWS.EXPENSE_DATE,
		EXPENSE_ITEMS_ROWS.AMOUNT,
		EXPENSE_ITEMS_ROWS.AMOUNT_KDV,
		EXPENSE_ITEMS_ROWS.MONEY_CURRENCY_ID,
		EXPENSE_ITEMS_ROWS.TOTAL_AMOUNT,
		EXPENSE_ITEMS_ROWS.MEMBER_TYPE,
		EXPENSE_ITEMS_ROWS.COMPANY_PARTNER_ID,
		EXPENSE_ITEMS_ROWS.COMPANY_ID,
		EXPENSE_ITEMS_ROWS.OTHER_MONEY_VALUE,
		EXPENSE_ITEMS_ROWS.EXPENSE_COST_TYPE,
		EXPENSE_ITEMS_ROWS.ACTION_ID,
		EXPENSE_ITEMS_ROWS.INVOICE_ID,
		EXPENSE_ITEMS.EXPENSE_ITEM_NAME,
		EXPENSE_CENTER.EXPENSE
	FROM 
		EXPENSE_ITEMS_ROWS,
		EXPENSE_ITEMS,
		EXPENSE_CENTER
	WHERE 
		EXPENSE_ITEMS_ROWS.IS_INCOME = 0 AND
		EXPENSE_ITEMS.EXPENSE_ITEM_ID = EXPENSE_ITEMS_ROWS.EXPENSE_ITEM_ID AND
		EXPENSE_CENTER.EXPENSE_ID = EXPENSE_ITEMS_ROWS.EXPENSE_CENTER_ID
		<cfif len(attributes.employee_id)>
			AND MEMBER_TYPE='employee'
			AND COMPANY_PARTNER_ID = #attributes.employee_id#
		</cfif>
		<cfif len(attributes.keyword)>AND EXPENSE_ITEMS_ROWS.PAPER_TYPE LIKE '%#attributes.keyword#%'</cfif>
		<cfif len(attributes.srch_date1)>AND EXPENSE_ITEMS_ROWS.EXPENSE_DATE >= #attributes.srch_date1#</cfif>
		<cfif len(attributes.srch_date2)>AND EXPENSE_ITEMS_ROWS.EXPENSE_DATE <= #attributes.srch_date2#</cfif>
		<cfif len(attributes.expense_employee) and len(attributes.employee_id)>AND EXPENSE_ITEMS_ROWS.EXPENSE_EMPLOYEE = #attributes.employee_id#</cfif>
		<cfif len(attributes.expense_item_id)>AND EXPENSE_ITEMS_ROWS.EXPENSE_ITEM_ID = #attributes.expense_item_id#</cfif>
		<cfif len(attributes.expense_center_id)>AND EXPENSE_ITEMS_ROWS.EXPENSE_CENTER_ID = #attributes.expense_center_id#</cfif>
		<cfif len(attributes.activity_type)>AND EXPENSE_ITEMS_ROWS.ACTIVITY_TYPE = #attributes.activity_type#</cfif>
		<cfif len(attributes.asset) and len(attributes.asset_id)>AND EXPENSE_ITEMS_ROWS.PYSCHICAL_ASSET_ID = #attributes.asset_id#</cfif>
		<cfif len(attributes.project) and len(attributes.project_id)>AND EXPENSE_ITEMS_ROWS.PROJECT_ID = #attributes.project_id#</cfif>
	ORDER BY 
		EXPENSE_ITEMS_ROWS.EXPENSE_DATE,
		EXPENSE_ITEMS_ROWS.EXP_ITEM_ROWS_ID
	DESC
</cfquery>
