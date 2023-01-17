<cfparam name="attributes.income_cat" default="">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.employee_id" default="">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.consumer_id" default="">
<cfparam name="attributes.member_type" default="">
<cfparam name="attributes.member_name" default="">
<cfparam name="attributes.expense_employee" default="">
<cfparam name="attributes.expense_item_id" default="">
<cfparam name="attributes.expense_center_id" default="">
<cfparam name="attributes.activity_type" default="">
<cfparam name="attributes.form_submitted" default="">
<cfparam name="attributes.asset_id" default="">
<cfparam name="attributes.asset" default="">
<cfparam name="attributes.project_id" default="">
<cfparam name="attributes.project" default="">
<cfparam name="attributes.branch_id" default="">
<cfif isDefined("attributes.record_date1") and isDate(attributes.record_date1)>
	<cf_date tarih = "attributes.record_date1">
<cfelse>
	<cfif session.ep.our_company_info.UNCONDITIONAL_LIST>
		<cfset attributes.record_date1=''>
	<cfelse>
		<cfset attributes.record_date1 = dateadd('d',-7,wrk_get_today())>
	</cfif>
</cfif>
<cfif isDefined("attributes.record_date2") and isDate(attributes.record_date2)>
	<cf_date tarih = "attributes.record_date2">
<cfelse>
	<cfif session.ep.our_company_info.UNCONDITIONAL_LIST>
		<cfset attributes.record_date2=''>
	<cfelse>
		<cfset attributes.record_date2 = dateadd('d',-7,wrk_get_today())>
	</cfif>
</cfif>
<cfif isdefined("attributes.search_date1") and isdate(attributes.search_date1)>
	<cf_date tarih = "attributes.search_date1">
<cfelse>	
	<cfif session.ep.our_company_info.UNCONDITIONAL_LIST>
		<cfset attributes.search_date1 = ''>
	<cfelse>
		<cfset attributes.search_date1 = date_add('d',-7,createodbcdatetime('#session.ep.period_year#-#month(now())#-#day(now())#'))>
	</cfif>
</cfif>
<cfif isdefined("attributes.search_date2") and isdate(attributes.search_date2)>
	<cf_date tarih = "attributes.search_date2">
<cfelse>
	<cfif session.ep.our_company_info.UNCONDITIONAL_LIST>
		<cfset attributes.search_date2 = ''>
	<cfelse>
		<cfset attributes.search_date2 = date_add('d',7,attributes.search_date1)>
	</cfif>
</cfif>
<cfquery name="GET_EXPENSE_CENTER" datasource="#dsn2#">
	SELECT EXPENSE_ID, EXPENSE FROM EXPENSE_CENTER ORDER BY EXPENSE
</cfquery>
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.maxrows" default="#session.ep.maxrows#">
<cfset attributes.startrow = ((attributes.page-1)*attributes.maxrows) + 1>
<cfif len(attributes.form_submitted)>
	<cfquery name="GET_EXPENSE_ITEM_ROW_ALL" datasource="#dsn2#">
		WITH CTE1 AS ( 
        SELECT 
			EXPENSE_ITEMS_ROWS.EXPENSE_ID,
			EXPENSE_ITEMS_ROWS.EXPENSE_EMPLOYEE,
			EXPENSE_ITEMS_ROWS.EXP_ITEM_ROWS_ID,
			EXPENSE_ITEMS_ROWS.EXPENSE_DATE,
			EXPENSE_ITEMS_ROWS.AMOUNT,
			EXPENSE_ITEMS_ROWS.AMOUNT_KDV,
			EXPENSE_ITEMS_ROWS.AMOUNT_OTV,
			EXPENSE_ITEMS_ROWS.MONEY_CURRENCY_ID,
			EXPENSE_ITEMS_ROWS.TOTAL_AMOUNT,
			EXPENSE_ITEMS_ROWS.COMPANY_PARTNER_ID,
			EXPENSE_ITEMS_ROWS.OTHER_MONEY_VALUE,
			EXPENSE_ITEMS_ROWS.OTHER_MONEY_GROSS_TOTAL,
			EXPENSE_ITEMS_ROWS.EXPENSE_COST_TYPE,
			EXPENSE_ITEMS_ROWS.ACTION_ID,
			EXPENSE_ITEMS_ROWS.INVOICE_ID,
			EXPENSE_ITEMS_ROWS.DETAIL,
			EXPENSE_ITEMS_ROWS.MEMBER_TYPE,
			ISNULL(ISNULL((SELECT INV.COMPANY_ID FROM INVOICE INV WHERE INV.INVOICE_ID = EXPENSE_ITEMS_ROWS.INVOICE_ID),(SELECT EXP.CH_COMPANY_ID FROM EXPENSE_ITEM_PLANS EXP WHERE EXP.EXPENSE_ID = EXPENSE_ITEMS_ROWS.EXPENSE_ID)),EXPENSE_ITEMS_ROWS.COMPANY_ID) COMPANY_ID,
			ISNULL((SELECT INV.CONSUMER_ID FROM INVOICE INV WHERE INV.INVOICE_ID = EXPENSE_ITEMS_ROWS.INVOICE_ID),(SELECT EXP.CH_CONSUMER_ID FROM EXPENSE_ITEM_PLANS EXP WHERE EXP.EXPENSE_ID = EXPENSE_ITEMS_ROWS.EXPENSE_ID)) CONSUMER_ID,
            (SELECT CH_EMPLOYEE_ID FROM EXPENSE_ITEM_PLANS WHERE EXPENSE_ID=EXPENSE_ITEMS_ROWS.EXPENSE_ID) EMPLOYEE_ID,
			ISNULL(ROW_PAPER_NO,ISNULL((SELECT EXP.PAPER_NO FROM EXPENSE_ITEM_PLANS EXP WHERE EXP.EXPENSE_ID = EXPENSE_ITEMS_ROWS.EXPENSE_ID),(SELECT II.INVOICE_NUMBER FROM INVOICE II WHERE II.INVOICE_ID = EXPENSE_ITEMS_ROWS.INVOICE_ID))) PAPER_NO,
			EXPENSE_ITEMS.EXPENSE_ITEM_NAME,
			EXPENSE_CENTER.EXPENSE
		FROM 
			EXPENSE_ITEMS_ROWS,
			EXPENSE_ITEMS,
			EXPENSE_CENTER
		WHERE 
			EXPENSE_ITEMS_ROWS.IS_INCOME = 1 AND
			EXPENSE_ITEMS.EXPENSE_ITEM_ID = EXPENSE_ITEMS_ROWS.EXPENSE_ITEM_ID AND
			EXPENSE_CENTER.EXPENSE_ID = EXPENSE_ITEMS_ROWS.EXPENSE_CENTER_ID
			<cfif len(attributes.keyword)>
			AND 
			(
				(EXPENSE_ITEMS_ROWS.ROW_PAPER_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">) OR
				(EXPENSE_ITEMS_ROWS.PAPER_TYPE LIKE '%#attributes.keyword#%') OR
				(EXPENSE_ITEMS_ROWS.DETAIL LIKE '%#attributes.keyword#%') OR
				(EXPENSE_ITEMS_ROWS.EXPENSE_ID IN
							(SELECT 
								EXP.EXPENSE_ID 
							FROM 
								EXPENSE_ITEM_PLANS EXP 
							WHERE 
								EXP.EXPENSE_ID = EXPENSE_ITEMS_ROWS.EXPENSE_ID
								AND EXP.PAPER_NO LIKE '%#attributes.keyword#%'))
			)
			</cfif>
			<cfif len(attributes.search_date1)>AND EXPENSE_ITEMS_ROWS.EXPENSE_DATE >= #attributes.search_date1#</cfif>
			<cfif len(attributes.search_date2)>AND EXPENSE_ITEMS_ROWS.EXPENSE_DATE < #dateadd("d",1,attributes.search_date2)#</cfif>
			<cfif len(attributes.record_date1)>
				AND 
				(
					(EXPENSE_ITEMS_ROWS.EXPENSE_ID IN
						(SELECT 
							EXP.EXPENSE_ID 
						FROM 
							EXPENSE_ITEM_PLANS EXP 
						WHERE 
							EXP.EXPENSE_ID = EXPENSE_ITEMS_ROWS.EXPENSE_ID
							AND EXP.RECORD_DATE >= #attributes.record_date1#)
					)
				OR
					(
					EXPENSE_ITEMS_ROWS.RECORD_DATE >= #attributes.record_date1#
					)
				)
			</cfif>
			<cfif len(attributes.record_date2)>
				AND 
				(	
					(EXPENSE_ITEMS_ROWS.EXPENSE_ID IN
						(SELECT 
							EXP.EXPENSE_ID 
						FROM 
							EXPENSE_ITEM_PLANS EXP 
						WHERE 
							EXP.EXPENSE_ID = EXPENSE_ITEMS_ROWS.EXPENSE_ID
							AND EXP.RECORD_DATE < #dateadd("d",1,attributes.record_date2)#)
					)
				OR
					(
					EXPENSE_ITEMS_ROWS.RECORD_DATE < #dateadd("d",1,attributes.record_date2)#
					)
				)
			</cfif>
			<cfif len(attributes.employee_id)>
				AND MEMBER_TYPE='employee'
				AND COMPANY_PARTNER_ID = #attributes.employee_id#
			</cfif>			
			<cfif len(attributes.expense_item_id)>AND EXPENSE_ITEMS_ROWS.EXPENSE_ITEM_ID = #attributes.expense_item_id#</cfif>
			<cfif len(attributes.expense_center_id)>AND EXPENSE_ITEMS_ROWS.EXPENSE_CENTER_ID = #attributes.expense_center_id#</cfif>
			<cfif len(attributes.activity_type)>AND EXPENSE_ITEMS_ROWS.ACTIVITY_TYPE = #attributes.activity_type#</cfif>
			<cfif len(attributes.asset) and len(attributes.asset_id)>AND EXPENSE_ITEMS_ROWS.PYSCHICAL_ASSET_ID = #attributes.asset_id#</cfif>
			<cfif len(attributes.project) and len(attributes.project_id)>AND EXPENSE_ITEMS_ROWS.PROJECT_ID = #attributes.project_id#</cfif>
			<cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>
				AND EXPENSE_ITEMS_ROWS.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#">
			</cfif>
			<cfif isdefined("attributes.member_type") and (attributes.member_type is 'partner') and len(attributes.member_name) and len(attributes.company_id)>
				AND ISNULL(ISNULL((SELECT INV.COMPANY_ID FROM INVOICE INV WHERE INV.INVOICE_ID = EXPENSE_ITEMS_ROWS.INVOICE_ID),(SELECT EXP.CH_COMPANY_ID FROM EXPENSE_ITEM_PLANS EXP WHERE EXP.EXPENSE_ID = EXPENSE_ITEMS_ROWS.EXPENSE_ID)),EXPENSE_ITEMS_ROWS.COMPANY_ID) = #attributes.company_id#
			</cfif>
			<cfif isdefined("attributes.member_type") and (attributes.member_type is 'consumer') and len(attributes.member_name) and len(attributes.consumer_id)>
				AND	ISNULL(ISNULL((SELECT INV.CONSUMER_ID FROM INVOICE INV WHERE INV.INVOICE_ID = EXPENSE_ITEMS_ROWS.INVOICE_ID),(SELECT EXP.CH_CONSUMER_ID FROM EXPENSE_ITEM_PLANS EXP WHERE EXP.EXPENSE_ID = EXPENSE_ITEMS_ROWS.EXPENSE_ID)),EXPENSE_ITEMS_ROWS.COMPANY_PARTNER_ID) = #attributes.consumer_id#
			</cfif> 
            <cfif isdefined("attributes.income_cat") and len(attributes.income_cat)>AND EXPENSE_ITEMS.EXPENSE_CATEGORY_ID = #attributes.income_cat#</cfif>
            
            ),
            CTE2 AS (
				SELECT
					CTE1.*,
					ROW_NUMBER() OVER (ORDER BY EXPENSE_DATE,EXP_ITEM_ROWS_ID DESC) AS RowNum,(SELECT COUNT(*) FROM CTE1) AS QUERY_COUNT,
					XXX.*
                FROM
					CTE1
                    	OUTER APPLY
						(
							SELECT 
                                SUM(AMOUNT) AS TOPLAM1,
                                SUM(AMOUNT_KDV) AS TOPLAM2,
                                SUM(AMOUNT_OTV) AS TOPLAM7, 
                                SUM(TOTAL_AMOUNT) AS TOPLAM3
							FROM CTE1 
						) AS XXX
			)
			SELECT
				CTE2.*
			FROM
				CTE2
			WHERE
				RowNum BETWEEN #attributes.startrow# and #attributes.startrow#+(#attributes.maxrows#-1)
		
	</cfquery>
    <cfparam name="attributes.totalrecords" default="#get_expense_item_row_all.query_count#">
	<cfif GET_EXPENSE_ITEM_ROW_ALL.recordcount>
		<cfset company_id_list=''>
		<cfset consumer_id_list=''>
        <cfset employee_id_list=''>
		<cfoutput query="get_expense_item_row_all">
			<cfif isdefined('company_id') and len(company_id) and not listfind(company_id_list,company_id)>
				<cfset company_id_list=listappend(company_id_list,company_id)>
			</cfif>
			<cfif isdefined('consumer_id') and len(consumer_id) and not listfind(consumer_id_list,consumer_id)>
				<cfset consumer_id_list=listappend(consumer_id_list,consumer_id)>
			</cfif>
            <cfif isdefined('employee_id') and len(employee_id) and not listfind(employee_id_list,employee_id)>
				<cfset employee_id_list=listappend(employee_id_list,employee_id)>
			</cfif>
		</cfoutput>
		<cfif listlen(company_id_list)>
			<cfset company_id_list=listsort(company_id_list,"numeric","ASC",",")>
			<cfquery name="get_company" datasource="#DSN#">
				SELECT COMPANY_ID,FULLNAME FROM COMPANY WHERE COMPANY_ID IN(#company_id_list#) ORDER BY COMPANY_ID
			</cfquery>
			<cfset company_id_list = listsort(listdeleteduplicates(valuelist(get_company.COMPANY_ID,',')),'numeric','ASC',',')>
		</cfif>
		<cfif listlen(consumer_id_list)>
			<cfset consumer_id_list=listsort(consumer_id_list,"numeric","ASC",",")>
			<cfquery name="get_consumer" datasource="#dsn#">
				SELECT CONSUMER_ID,CONSUMER_NAME,CONSUMER_SURNAME FROM CONSUMER WHERE CONSUMER_ID IN (#consumer_id_list#) ORDER BY CONSUMER_ID
			</cfquery>
			<cfset consumer_id_list = listsort(listdeleteduplicates(valuelist(get_consumer.CONSUMER_ID,',')),'numeric','ASC',',')>
		</cfif>
        <cfif listlen(employee_id_list)>
			<cfset employee_id_list=listsort(employee_id_list,"numeric","ASC",",")>
			<cfquery name="get_employee" datasource="#dsn#">
				SELECT EMPLOYEE_ID,EMPLOYEE_NAME,EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID IN (#employee_id_list#) ORDER BY EMPLOYEE_ID
			</cfquery>
			<cfset employee_id_list = listsort(listdeleteduplicates(valuelist(get_employee.EMPLOYEE_ID,',')),'numeric','ASC',',')>
		</cfif>
	</cfif>
<cfelse>
	<cfparam name="attributes.totalrecords" default="0">
</cfif>
<script type="text/javascript">
	$( document ).ready(function() {
		document.getElementById('keyword').focus();
	});
</script>
<cfscript>
	// Switch //
	WOStruct = StructNew();
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'budget.budget_income_summery';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'budget/display/budget_income_summery.cfm';
</cfscript>
