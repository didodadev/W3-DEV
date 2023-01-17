<cf_get_lang_set module_name="invoice">
<cf_xml_page_edit fuseact="invoice.list_conract_comparison">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.pur_sales_info" default="">
<cfparam name="attributes.result_info" default="">
<cfparam name="attributes.inv_purchase_sales" default="">
<cfparam name="attributes.list_type" default="">
<cfparam name="attributes.diff_type" default="">
<cfparam name="attributes.company" default="">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.consumer_id" default="">
<cfparam name="attributes.partner_id" default="">
<cfparam name="attributes.product_id" default="">
<cfparam name="attributes.product_name" default="">
<cfparam name="attributes.project_id" default="">
<cfparam name="attributes.project_head" default="">
<cfparam name="attributes.date1" default="">
<cfparam name="attributes.date2" default="">
<cfif is_default_pur eq 1 and not len(attributes.inv_purchase_sales)>
	<cfset attributes.inv_purchase_sales = 0>
</cfif>
<cfif isdefined("attributes.date1") and isdate(attributes.date1)>
	<cf_date tarih = 'attributes.date1'>
<cfelse>
	<cfif session.ep.our_company_info.unconditional_list>
		<cfset attributes.date1 = ''>
	<cfelseif not len(attributes.company_id) and not len(attributes.company)>
		<cfset attributes.date1 = date_add('d',-7,wrk_get_today())>
	</cfif>
</cfif>
<cfif isdefined("attributes.date2") and isdate(attributes.date2)>
	<cf_date tarih = 'attributes.date2'>
<cfelse>
	<cfif session.ep.our_company_info.unconditional_list>
		<cfset attributes.date2 = ''>
	<cfelseif not len(attributes.company_id) and not len(attributes.company)>
		<cfset attributes.date2 = date_add('d',7,wrk_get_today())>
	</cfif>
</cfif>
<cfif isdefined('attributes.is_submitted')>
	<cfquery name="GET_COMPARISON" datasource="#DSN2#">
		<cfif attributes.diff_type neq 11>
			SELECT 
				IC.DIFF_AMOUNT,
				IC.DIFF_RATE,
				IC.DIFF_TYPE,
				IC.DIFF_AMOUNT,
				IC.DIFF_AMOUNT_OTHER,
				IC.OTHER_MONEY,
				IC.TAX,
				IC.INVOICE_TYPE,
				IC.DEPARTMENT_ID,
				IC.LOCATION_ID,
				IC.AMOUNT,
				IC.COST_ID,
				IC.MAIN_STOCK_ID,
				IC.MAIN_PRODUCT_ID,
				IC.MAIN_INVOICE_ID,
				IC.MAIN_INVOICE_ROW_ID,
				IC.MAIN_INVOICE_NUMBER,
				IC.MAIN_INVOICE_DATE,
				IC.IS_DIFF_PRICE,
				IC.IS_DIFF_DISCOUNT,
				IC.COMPANY_ID,
				IC.CONSUMER_ID,
				IC.RECORD_EMP,
				IC.RECORD_DATE,
				IC.DUE_DIFF_ID,
				I.PURCHASE_SALES,
				IC.DIFF_INVOICE_ID,
				I.PROJECT_ID,
				IC.CONTRACT_COMPARISON_ROW_ID
			FROM 
				INVOICE_CONTRACT_COMPARISON IC,
				INVOICE I
			WHERE 
				IC.MAIN_INVOICE_ID = I.INVOICE_ID
				<cfif len(attributes.result_info)>
					<cfif attributes.result_info eq 0>
						AND IC.DIFF_INVOICE_ID IS NULL 
					<cfelse>
						AND IC.DIFF_INVOICE_ID IS NOT NULL 
					</cfif>
				</cfif>
				<cfif len(attributes.inv_purchase_sales)>
					AND I.PURCHASE_SALES = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.inv_purchase_sales#">
				</cfif>
				<cfif len(attributes.company_id) and len(attributes.company)>
					AND IC.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
				</cfif>
				<cfif len(attributes.consumer_id) and len(attributes.company)>
					AND IC.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
				</cfif>
				<cfif len(attributes.date1) and isdate(attributes.date1) and len(attributes.date2) and isdate(attributes.date2)>
					AND	IC.MAIN_INVOICE_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#">
				</cfif>
				<cfif len(attributes.keyword)>
					AND IC.MAIN_INVOICE_NUMBER LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
				</cfif>
				<cfif len(attributes.diff_type)>
					AND IC.DIFF_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.diff_type#">
				</cfif>
				<cfif len(attributes.product_id) and len(attributes.product_name)>
					AND IC.MAIN_PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id#">
				</cfif>
				<cfif len(attributes.project_id) and len(attributes.project_head)>
					AND I.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
				</cfif>
				<cfif len(attributes.pur_sales_info)>
					AND IC.INVOICE_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pur_sales_info#">
				</cfif>
			UNION ALL
			SELECT 
				IC.DIFF_AMOUNT,
				IC.DIFF_RATE,
				IC.DIFF_TYPE,
				IC.DIFF_AMOUNT,
				IC.DIFF_AMOUNT_OTHER,
				IC.OTHER_MONEY,
				IC.TAX,
				IC.INVOICE_TYPE,
				IC.DEPARTMENT_ID,
				IC.LOCATION_ID,
				IC.AMOUNT,
				IC.COST_ID,
				IC.MAIN_STOCK_ID,
				IC.MAIN_PRODUCT_ID,
				IC.MAIN_INVOICE_ID,
				IC.MAIN_INVOICE_ROW_ID,
				IC.MAIN_INVOICE_NUMBER,
				IC.RECORD_DATE MAIN_INVOICE_DATE,
				IC.IS_DIFF_PRICE,
				IC.IS_DIFF_DISCOUNT,
				IC.COMPANY_ID,
				IC.CONSUMER_ID,
				IC.RECORD_EMP,
				IC.RECORD_DATE,
				IC.DUE_DIFF_ID,
				S.IS_SALES_PURCHASE PURCHASE_SALES,
				IC.DIFF_INVOICE_ID,
				'' PROJECT_ID,
				IC.CONTRACT_COMPARISON_ROW_ID
			FROM 
				INVOICE_CONTRACT_COMPARISON IC,
				#dsn3_alias#.SALES_QUOTAS_ROW_RELATION SQR,
				#dsn3_alias#.SALES_QUOTAS_ROW SQ,
				#dsn3_alias#.SALES_QUOTAS S
			WHERE 
				IC.MAIN_INVOICE_ID IS NULL
				<cfif len(attributes.result_info)>
					<cfif attributes.result_info eq 0>
						AND IC.DIFF_INVOICE_ID IS NULL 
					<cfelse>
						AND IC.DIFF_INVOICE_ID IS NOT NULL 
					</cfif>
				</cfif>
				<cfif len(attributes.inv_purchase_sales)>
					AND 1 = 0
				</cfif>
				AND IC.CONTRACT_COMPARISON_ROW_ID = SQR.INVOICE_COMPARISON_ID
				AND SQR.SALES_QUOTAS_ROW_ID = SQ.SALES_QUOTA_ROW_ID
				AND SQ.SALES_QUOTA_ID = S.SALES_QUOTA_ID
				AND SQR.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
				<cfif len(attributes.company_id) and len(attributes.company)>
					AND IC.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
				</cfif>
				<cfif len(attributes.consumer_id) and len(attributes.company)>
					AND IC.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
				</cfif>
				<cfif len(attributes.date1) and isdate(attributes.date1) and len(attributes.date2) and isdate(attributes.date2)>
					AND	IC.MAIN_INVOICE_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#">
				</cfif>
				<cfif len(attributes.keyword)>
					AND IC.MAIN_INVOICE_NUMBER LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
				</cfif>
				<cfif len(attributes.diff_type)>
					AND IC.DIFF_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.diff_type#">
				</cfif>
				<cfif len(attributes.product_id) and len(attributes.product_name)>
					AND IC.MAIN_PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id#">
				</cfif>
				<cfif len(attributes.pur_sales_info)>
					AND IC.INVOICE_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pur_sales_info#">
				</cfif>
			UNION ALL
			SELECT 
				IC.DIFF_AMOUNT,
				IC.DIFF_RATE,
				IC.DIFF_TYPE,
				IC.DIFF_AMOUNT,
				IC.DIFF_AMOUNT_OTHER,
				IC.OTHER_MONEY,
				IC.TAX,
				IC.INVOICE_TYPE,
				IC.DEPARTMENT_ID,
				IC.LOCATION_ID,
				IC.AMOUNT,
				IC.COST_ID,
				IC.MAIN_STOCK_ID,
				IC.MAIN_PRODUCT_ID,
				IC.MAIN_INVOICE_ID,
				IC.MAIN_INVOICE_ROW_ID,
				IC.MAIN_INVOICE_NUMBER,
				IC.RECORD_DATE MAIN_INVOICE_DATE,
				IC.IS_DIFF_PRICE,
				IC.IS_DIFF_DISCOUNT,
				IC.COMPANY_ID,
				IC.CONSUMER_ID,
				IC.RECORD_EMP,
				IC.RECORD_DATE,
				IC.DUE_DIFF_ID,
				1 PURCHASE_SALES,
				IC.DIFF_INVOICE_ID,
				'' PROJECT_ID,
				IC.CONTRACT_COMPARISON_ROW_ID
			FROM 
				INVOICE_CONTRACT_COMPARISON IC
			WHERE 
				IC.COST_ID IS NOT NULL
				<cfif len(attributes.result_info)>
					<cfif attributes.result_info eq 0>
						AND IC.DIFF_INVOICE_ID IS NULL 
					<cfelse>
						AND IC.DIFF_INVOICE_ID IS NOT NULL 
					</cfif>
				</cfif>
				<cfif len(attributes.inv_purchase_sales)>
					AND 1 = 0
				</cfif>
				<cfif len(attributes.company_id) and len(attributes.company)>
					AND IC.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
				</cfif>
				<cfif len(attributes.consumer_id) and len(attributes.company)>
					AND IC.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
				</cfif>
				<cfif len(attributes.date1) and isdate(attributes.date1) and len(attributes.date2) and isdate(attributes.date2)>
					AND	IC.MAIN_INVOICE_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#">
				</cfif>
				<cfif len(attributes.keyword)>
					AND IC.MAIN_INVOICE_NUMBER LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
				</cfif>
				<cfif len(attributes.diff_type)>
					AND IC.DIFF_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.diff_type#">
				</cfif>
				<cfif len(attributes.product_id) and len(attributes.product_name)>
					AND IC.MAIN_PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id#">
				</cfif>
				<cfif len(attributes.pur_sales_info)>
					AND IC.INVOICE_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pur_sales_info#">
				</cfif>
			ORDER BY 
				IC.MAIN_INVOICE_NUMBER
		<cfelse>
			SELECT
				<cfif attributes.list_type eq 1><!--- Satır bazında --->
					0 DIFF_RATE,
					'11' DIFF_TYPE,
					ABS(((IR.NETTOTAL/IR.AMOUNT)-ISNULL(IR.COST_PRICE,0))*IR.AMOUNT) DIFF_AMOUNT,
					ABS(((IR.NETTOTAL/IR.AMOUNT)-ISNULL(IR.COST_PRICE,0))/IM.RATE2*IR.AMOUNT) DIFF_AMOUNT_OTHER,
					IR.NETTOTAL AS ROW_TOTAL,
					ISNULL(IR.COST_PRICE,0)*IR.AMOUNT COST_PRICE,
					IR.OTHER_MONEY,
					IR.TAX,
					CASE WHEN (((IR.NETTOTAL/IR.AMOUNT)-ISNULL(IR.COST_PRICE,0)) < 0) THEN 1 ELSE 0 END AS INVOICE_TYPE,
					I.DEPARTMENT_ID,
					I.DEPARTMENT_LOCATION LOCATION_ID,
					IR.AMOUNT,
					'' COST_ID,
					IR.STOCK_ID MAIN_STOCK_ID,
					IR.PRODUCT_ID MAIN_PRODUCT_ID,
					IR.INVOICE_ID MAIN_INVOICE_ID,
					IR.INVOICE_ROW_ID MAIN_INVOICE_ROW_ID,
					I.INVOICE_NUMBER MAIN_INVOICE_NUMBER,
					I.INVOICE_DATE MAIN_INVOICE_DATE,
					'' IS_DIFF_PRICE,
					'' IS_DIFF_DISCOUNT,
					I.COMPANY_ID,
					I.CONSUMER_ID,
					I.RECORD_EMP,
					I.RECORD_DATE,
					'' DUE_DIFF_ID,
					I.PURCHASE_SALES,
					(SELECT IC.DIFF_INVOICE_ID FROM INVOICE_CONTRACT_COMPARISON IC WHERE IC.MAIN_INVOICE_ROW_ID = IR.INVOICE_ROW_ID) DIFF_INVOICE_ID,
					I.PROJECT_ID,
					'' CONTRACT_COMPARISON_ROW_ID
				<cfelse><!--- Belge bazında --->
					0 DIFF_RATE,
					'11' DIFF_TYPE,
					SUM(ABS(((IR.NETTOTAL/IR.AMOUNT)-ISNULL(IR.COST_PRICE,0))*IR.AMOUNT)) DIFF_AMOUNT,
					SUM(ABS(((IR.NETTOTAL/IR.AMOUNT)-ISNULL(IR.COST_PRICE,0))/IM.RATE2*IR.AMOUNT)) DIFF_AMOUNT_OTHER,
					SUM(IR.NETTOTAL) AS ROW_TOTAL,
					SUM(ISNULL(IR.COST_PRICE,0)*IR.AMOUNT) COST_PRICE,
					'' OTHER_MONEY,
					'' TAX,
					CASE WHEN (SUM(((IR.NETTOTAL/IR.AMOUNT)-ISNULL(IR.COST_PRICE,0))) < 0) THEN 1 ELSE 0 END AS INVOICE_TYPE,
					I.DEPARTMENT_ID,
					I.DEPARTMENT_LOCATION LOCATION_ID,
					'' AMOUNT,
					'' COST_ID,
					'' MAIN_STOCK_ID,
					'' MAIN_PRODUCT_ID,
					'' MAIN_INVOICE_ID,
					'' MAIN_INVOICE_ROW_ID,
					I.INVOICE_NUMBER MAIN_INVOICE_NUMBER,
					I.INVOICE_DATE MAIN_INVOICE_DATE,
					'' IS_DIFF_PRICE,
					'' IS_DIFF_DISCOUNT,
					I.COMPANY_ID,
					I.CONSUMER_ID,
					I.RECORD_EMP,
					I.RECORD_DATE,
					'' DUE_DIFF_ID,
					I.PURCHASE_SALES,
					'' DIFF_INVOICE_ID,
					I.PROJECT_ID,
					'' CONTRACT_COMPARISON_ROW_ID
				</cfif>
			FROM 
				INVOICE_ROW IR,
				INVOICE I,
				INVOICE_MONEY IM
			WHERE 
				IR.INVOICE_ID = I.INVOICE_ID
				AND IM.ACTION_ID = I.INVOICE_ID
				AND IM.MONEY_TYPE = IR.OTHER_MONEY
				AND ((IR.NETTOTAL/IR.AMOUNT)-ISNULL(IR.COST_PRICE,0)) <> 0
				AND IR.STOCK_ID IS NOT NULL
				<cfif len(attributes.inv_purchase_sales)>
					AND I.PURCHASE_SALES = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.inv_purchase_sales#">
				</cfif>
				<cfif len(attributes.result_info)>
					<cfif attributes.result_info eq 0>
						AND 
						(
							IR.INVOICE_ROW_ID IN(SELECT IC.MAIN_INVOICE_ROW_ID FROM INVOICE_CONTRACT_COMPARISON IC WHERE IC.DIFF_INVOICE_ID IS NULL)
							OR
							IR.INVOICE_ROW_ID NOT IN(SELECT IC.MAIN_INVOICE_ROW_ID FROM INVOICE_CONTRACT_COMPARISON IC WHERE IC.MAIN_INVOICE_ROW_ID IS NOT NULL)
						)
					<cfelse>
						AND IR.INVOICE_ROW_ID IN(SELECT IC.MAIN_INVOICE_ROW_ID FROM INVOICE_CONTRACT_COMPARISON IC WHERE IC.DIFF_INVOICE_ID IS NOT NULL)
					</cfif>
				</cfif>
				<cfif len(attributes.company_id) and len(attributes.company)>
					AND I.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
				</cfif>
				<cfif len(attributes.consumer_id) and len(attributes.company)>
					AND I.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
				</cfif>
				<cfif len(attributes.date1) and isdate(attributes.date1) and len(attributes.date2) and isdate(attributes.date2)>
					AND	I.INVOICE_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#">
				</cfif>
				<cfif len(attributes.keyword)>
					AND I.INVOICE_NUMBER LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
				</cfif>
				<cfif len(attributes.product_id) and len(attributes.product_name)>
					AND IR.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id#">
				</cfif>
				<cfif len(attributes.project_id) and len(attributes.project_head)>
					AND I.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
				</cfif>
				<cfif len(attributes.pur_sales_info)>
					<cfif attributes.pur_sales_info eq 0>
						AND ((IR.NETTOTAL/IR.AMOUNT)-ISNULL(IR.COST_PRICE,0)) > 0
					<cfelse>
						AND ((IR.NETTOTAL/IR.AMOUNT)-ISNULL(IR.COST_PRICE,0)) < 0
					</cfif>
				</cfif>
			<cfif attributes.list_type eq 0>
				GROUP BY
					I.DEPARTMENT_ID,
					I.DEPARTMENT_LOCATION,
					I.INVOICE_NUMBER,
					I.INVOICE_DATE,
					I.COMPANY_ID,
					I.CONSUMER_ID,
					I.RECORD_EMP,
					I.RECORD_DATE,
					I.PURCHASE_SALES,
					I.PROJECT_ID
			</cfif>
			ORDER BY 
				I.INVOICE_NUMBER
		</cfif>
	</cfquery>
<cfelse>
	<cfset get_comparison.recordcount = 0>
</cfif>
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.maxrows" default="#session.ep.maxrows#"> 
<cfparam name="attributes.totalrecords" default="#get_comparison.recordcount#">
<cfset attributes.startrow = ((attributes.page-1)*attributes.maxrows) + 1>
<cfif get_comparison.recordcount>
	<cfset record_emp_list = "">
    <cfset company_id_list = "">
    <cfset consumer_id_list = "">
    <cfset main_product_id_list = "">
    <cfset project_id_list = "">
    <cfoutput query="get_comparison" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
        <cfif len(record_emp) and not listfind(record_emp_list, record_emp)>
            <cfset record_emp_list=listappend(record_emp_list, record_emp)>
        </cfif>
        <cfif len(company_id) and not listfind(company_id_list, company_id)>
            <cfset company_id_list=listappend(company_id_list, company_id)>
        </cfif>
        <cfif len(consumer_id) and not listfind(consumer_id_list,consumer_id)>
            <cfset consumer_id_list=listappend(consumer_id_list,consumer_id)>
        </cfif>
        <cfif len(project_id) and not listfind(project_id_list,project_id)>
            <cfset project_id_list=listappend(project_id_list,project_id)>
        </cfif>
        <cfif len(main_product_id) and not listfind(main_product_id_list, main_product_id)>
            <cfset main_product_id_list=listappend(main_product_id_list, main_product_id)>
        </cfif>
    </cfoutput>
    <cfif len(record_emp_list)>
        <cfset record_emp_list = listsort(record_emp_list,"numeric","ASC",",")>
        <cfquery name="get_record_detail" datasource="#dsn#">
            SELECT EMPLOYEE_ID,EMPLOYEE_NAME,EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#record_emp_list#">) ORDER BY EMPLOYEE_ID
        </cfquery>
        <cfset record_emp_list = listsort(listdeleteduplicates(valuelist(get_record_detail.employee_id,',')),'numeric','ASC',',')>
    </cfif>
    <cfif len(project_id_list)>
        <cfset project_id_list = listsort(project_id_list,"numeric","ASC",",")>
        <cfquery name="get_pro_detail" datasource="#dsn#">
            SELECT PROJECT_ID,PROJECT_HEAD FROM PRO_PROJECTS WHERE PROJECT_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#project_id_list#">) ORDER BY PROJECT_ID
        </cfquery>
        <cfset project_id_list = listsort(listdeleteduplicates(valuelist(get_pro_detail.project_id,',')),'numeric','ASC',',')>
    </cfif>
    <cfif len(company_id_list)>
        <cfset company_id_list = listsort(company_id_list,"numeric","ASC",",")>
        <cfquery name="get_company_detail" datasource="#dsn#">
            SELECT COMPANY_ID,NICKNAME FROM COMPANY WHERE COMPANY_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#company_id_list#">) ORDER BY COMPANY_ID
        </cfquery>
        <cfset company_id_list = listsort(listdeleteduplicates(valuelist(get_company_detail.company_id,',')),'numeric','ASC',',')>
    </cfif>
    <cfif len(consumer_id_list)>
        <cfset consumer_id_list = listsort(consumer_id_list,"numeric","ASC",",")>
        <cfquery name="get_consumer_detail" datasource="#dsn#">
            SELECT CONSUMER_ID,CONSUMER_NAME,CONSUMER_SURNAME FROM CONSUMER WHERE CONSUMER_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#consumer_id_list#">) ORDER BY CONSUMER_ID
        </cfquery>
        <cfset consumer_id_list = listsort(listdeleteduplicates(valuelist(get_consumer_detail.consumer_id,',')),'numeric','ASC',',')>
    </cfif>
    <cfif len(main_product_id_list)>
        <cfset main_product_id_list = listsort(main_product_id_list,"numeric","ASC",",")>
        <cfquery name="get_product_detail" datasource="#dsn1#">
            SELECT 
                PRODUCT_ID,PRODUCT_NAME FROM PRODUCT WHERE PRODUCT_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#main_product_id_list#">) ORDER BY PRODUCT_ID
        </cfquery>
        <cfset main_product_id_list = listsort(listdeleteduplicates(valuelist(get_product_detail.product_id,',')),'numeric','ASC',',')>
    </cfif>
</cfif> 
<cfset url_str = "&is_submitted=1">
<cfif len(attributes.keyword)><cfset url_str = "#url_str#&keyword=#attributes.keyword#"></cfif>
<cfif len(attributes.pur_sales_info)><cfset url_str = "#url_str#&pur_sales_info=#attributes.pur_sales_info#"></cfif>
<cfif len(attributes.result_info)><cfset url_str = "#url_str#&result_info=#attributes.result_info#"></cfif>
<cfif len(attributes.inv_purchase_sales)><cfset url_str = "#url_str#&inv_purchase_sales=#attributes.inv_purchase_sales#"></cfif>
<cfif len(attributes.list_type)><cfset url_str = "#url_str#&list_type=#attributes.list_type#"></cfif>
<cfif len(attributes.diff_type)><cfset url_str = "#url_str#&diff_type=#attributes.diff_type#"></cfif>
<cfif len(attributes.company) and len(attributes.consumer_id)><cfset url_str = "#url_str#&company=#attributes.company#&consumer_id=#attributes.consumer_id#"></cfif>
<cfif len(attributes.company) and len(attributes.partner_id)><cfset url_str = "#url_str#&company=#attributes.company#&company_id=#attributes.company_id#&partner_id=#attributes.partner_id#"></cfif>
<cfif len(attributes.product_name) and len(attributes.product_id)><cfset url_str = "#url_str#&product_name=#attributes.product_name#&product_id=#attributes.product_id#"></cfif>
<cfif len(attributes.project_head) and len(attributes.project_id)><cfset url_str = "#url_str#&project_head=#attributes.project_head#&project_id=#attributes.project_id#"></cfif>
<cfif len(attributes.date1)><cfset url_str = "#url_str#&date1=#attributes.date1#"></cfif>
<cfif len(attributes.date2)><cfset url_str = "#url_str#&date2=#attributes.date2#"></cfif>
<cfscript>
	// Switch //
	WOStruct = StructNew();
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'invoice.list_conract_comparison';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'invoice/display/list_contract_comparisons.cfm';
	
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
	}*/
</cfscript>
<script type="text/javascript">
$( document ).ready(function() {
	document.getElementById('keyword').focus();
});
function input_control()
	{
		if(inv_form.diff_type.value == 11)
		{
			if((inv_form.consumer_id.value == "" || inv_form.company_id.value == "") &&  (inv_form.company.value == ""))
			{
				alert("<cf_get_lang no='181.Cari Hesap Seçmelisiniz'> !");
				return false;
			}
		}
		<cfif not session.ep.our_company_info.unconditional_list>
			if ((inv_form.date1.value == "" || inv_form.date2.value == "") && (inv_form.consumer_id.value == "" || inv_form.company_id.value == "" || inv_form.company.value == ""))
				{
					alert("<cf_get_lang_main no='114.En az bir alanda filtre etmelisiniz'>");
					return false;
				}
			else return true;
		<cfelse>
			return true;
		</cfif>
	}	
	function sil_islem()
	{
		var row_ = 0;
		var inv_id_list = 0;
		var inv_row_id_list = 0;
		var cost_id_list = 0;
		var all_id_list = "";
		<cfif get_comparison.recordcount>
			
			for (var i=0; i < <cfoutput>#get_comparison.recordcount#</cfoutput>; i++)
			{
				if((document.add_fark_faturasi.line_id[i]!=undefined && document.add_fark_faturasi.line_id[i].checked == true) || (document.add_fark_faturasi.line_id!=undefined && document.add_fark_faturasi.line_id.checked == true))
				{
					var row_ = i + 1;
					if(eval("document.add_fark_faturasi.invoice_id_" + row_ + ".value") != '')
						inv_id_list = eval("document.add_fark_faturasi.invoice_id_" + row_ + ".value");
						
					if(eval("document.add_fark_faturasi.invoice_row_id_" + row_ + ".value") != '')
						inv_row_id_list = eval("document.add_fark_faturasi.invoice_row_id_" + row_ + ".value");
						
					if(eval("document.add_fark_faturasi.cost_id_" + row_ + ".value") != '')
						cost_id_list = eval("document.add_fark_faturasi.cost_id_" + row_ + ".value");
					if(all_id_list == "")
						all_id_list = inv_id_list + '-' + inv_row_id_list + '-' + cost_id_list;
					else
						all_id_list = all_id_list + ';' + inv_id_list + '-' + inv_row_id_list + '-' + cost_id_list;
				}
			}
			if(row_ == 0)
			{
				alert("En Az Bir Satır Seçmelisiniz!");
				return false;
			}
			else if(all_id_list != "")
			{
				document.getElementById('del_id_list').value = all_id_list;
				document.getElementById('del_url_list').value = "<cfoutput>#url_str#</cfoutput>";
				document.del_invoice.submit();
			}
		</cfif>
	}	
	
	function hepsi_view()
	{
		if (document.add_fark_faturasi.all_view.checked)
		{
			if(<cfoutput>#get_comparison.recordcount#</cfoutput> == 1)
			{
				if(add_fark_faturasi.line_id!=undefined) document.add_fark_faturasi.line_id.checked = true;
			}
			else
			{
				for (var i=0; i < <cfoutput>#get_comparison.recordcount#</cfoutput>; i++) 
				{
					if(add_fark_faturasi.line_id[i]!=undefined) document.add_fark_faturasi.line_id[i].checked = true;
					
				}
			}
		}
		else
		{
			if(<cfoutput>#get_comparison.recordcount#</cfoutput> == 1)
			{
				if(add_fark_faturasi.line_id!=undefined) document.add_fark_faturasi.line_id.checked = false;
			}
			else
			{
				for (var i=0; i < <cfoutput>#get_comparison.recordcount#</cfoutput>; i++) 
					if(add_fark_faturasi.line_id[i]!=undefined)	document.add_fark_faturasi.line_id[i].checked = false;
			}
		}
	}	
	<cfif isdefined('attributes.is_submitted')>
		function KontrolEt_Gonder(i_type)	
		{
			var bool_i = 0 ;
			var inv_type_ ='';
			document.add_fark_faturasi.inv_type.value=i_type;
			<cfif get_comparison.recordcount eq 1>
				if(add_fark_faturasi.line_id.checked==false)
				{
					alert("<cf_get_lang no='278.Seçim Yapınız'>!");
					return false;
				} 
				else 
				{
					if(i_type != 4)//fark kaydı yapılmayacaksa
					{
						windowopen('','list','favourites_window');
						add_fark_faturasi.target='favourites_window';
						add_fark_faturasi.action="<cfoutput>#request.self#?fuseaction=invoice.popup_add_contract_compare_product</cfoutput>";
						add_fark_faturasi.submit();
						if(add_fark_faturasi.invoice_type_1.value == 0)
							window.location.href='<cfoutput>#request.self#?fuseaction=invoice.form_add_bill</cfoutput>';<!--- add_new_diff_invoice --->
						else
							window.location.href='<cfoutput>#request.self#?fuseaction=invoice.form_add_bill_purchase</cfoutput>';
					}
					else
					{
						gizle_goster(quota_result_info);
						AjaxFormSubmit('add_fark_faturasi','show_quota_result_info',0,'<cf_get_lang_main no="1477.Kaydediliyor">','<cf_get_lang_main no="1478.Kaydedildi">!',"","",1);
						add_fark_faturasi.action="";
						row_info_2.style.display='';
						row_info_1.style.display='none';
					}
				}
			<cfelse>	
				for (var i=0; i < <cfoutput>#get_comparison.recordcount#</cfoutput>; i++) 
				{
					if(add_fark_faturasi.line_id[i]!=undefined && add_fark_faturasi.line_id[i].checked)
					{
						bool_i = 1;
						if(inv_type_!='' && eval('add_fark_faturasi.invoice_type_'+add_fark_faturasi.line_id[i].value).value != inv_type_)
						{
							alert("<cf_get_lang no='401.Fatura Tipler Uyuşmuyor'>");
							return false;		
						}
						inv_type_=eval('add_fark_faturasi.invoice_type_'+add_fark_faturasi.line_id[i].value).value;
					}
				}
				if (bool_i == 0)
				{
					alert("<cf_get_lang no='278.Seçim Yapınız'>!");
					return false;			
				} 
				else 
				{
					if(i_type != 4)//fark kaydı yapılmayacaksa
					{
						windowopen('','list','favourites_window');
						add_fark_faturasi.target='favourites_window';
						add_fark_faturasi.action="<cfoutput>#request.self#?fuseaction=invoice.popup_add_contract_compare_product</cfoutput>";
						add_fark_faturasi.submit();
						if(inv_type_ == 0)
							inv_form.action="<cfoutput>#request.self#?fuseaction=invoice.form_add_bill</cfoutput>";
						else
							inv_form.action="<cfoutput>#request.self#?fuseaction=invoice.form_add_bill_purchase</cfoutput>";
						inv_form.submit();
						return true;
					}
					else
					{
						gizle_goster(quota_result_info);
						AjaxFormSubmit('add_fark_faturasi','show_quota_result_info',0,'<cf_get_lang_main no="1477.Kaydediliyor">','<cf_get_lang_main no="1478.Kaydedildi">!',"","",1);
						add_fark_faturasi.action="";
						row_info_2.style.display='';
						row_info_1.style.display='none';
					}
				}
			</cfif>
		}
	</cfif>
</script>
