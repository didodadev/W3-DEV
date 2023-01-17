<cfparam name="attributes.expense_cat" default="">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.search_date1" default=''>
<cfparam name="attributes.search_date2" default=''>
<cfparam name="attributes.expense_item_id" default="">
<cfparam name="attributes.expense_center_id" default="">
<cfparam name="attributes.activity_type" default="">
<cfparam name="attributes.form_exist" default="">
<cfparam name="attributes.asset_id" default="">
<cfparam name="attributes.asset" default="">
<cfparam name="attributes.project_id" default="">
<cfparam name="attributes.project" default="">
<cfparam name="attributes.expense_paper_type" default="">
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.member_type" default="">
<cfparam name="attributes.expense_part_id" default="">
<cfparam name="attributes.expense_cons_id" default="">
<cfparam name="attributes.expense_emp_id" default="">
<cfparam name="attributes.recorder_name" default="">
<cfparam name="attributes.ch_member_type" default="">
<cfparam name="attributes.ch_company_id" default="">
<cfparam name="attributes.ch_consumer_id" default="">
<cfparam name="attributes.ch_employee_id" default="">
<cfparam name="attributes.ch_company" default="">
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.maxrows" default="#session.ep.maxrows#">
<cfset attributes.startrow = ((attributes.page-1)*attributes.maxrows) + 1>
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
		<cfset attributes.record_date2 = dateadd('d',7,attributes.record_date1)>
	</cfif>
</cfif>
<cfif isdefined("attributes.search_date1") and isdate(attributes.search_date1)>
	<cf_date tarih = "attributes.search_date1">
	<cfelse>
		<cfif session.ep.our_company_info.UNCONDITIONAL_LIST>
		<cfset attributes.search_date1 = ''>
<cfelse>
	<cfset attributes.search_date1 = dateadd('d',-7,wrk_get_today())>
	</cfif>
</cfif>
<cfif isdefined("attributes.search_date2") and isdate(attributes.search_date2)>
	<cf_date tarih = "attributes.search_date2">
	<cfelse>
		<cfif session.ep.our_company_info.UNCONDITIONAL_LIST>
		<cfset attributes.search_date2 = ''>
<cfelse>
	<cfset attributes.search_date2 = dateadd('d',7,attributes.search_date1)>
	</cfif>
</cfif>
<cfquery name="GET_EXPENSE_CENTER" datasource="#dsn2#">
	SELECT EXPENSE_ID, EXPENSE,EXPENSE_CODE FROM EXPENSE_CENTER ORDER BY EXPENSE_CODE
</cfquery>
<cfif  isdefined("attributes.form_exist") and attributes.form_exist eq 1>
	<cfif len(attributes.expense_center_id)>
		<cfset attributes.expense_center_id_list=attributes.expense_center_id>
		<cfquery name="GET_EXPENSE_CODE" dbtype="query">
			SELECT EXPENSE_CODE FROM GET_EXPENSE_CENTER WHERE EXPENSE_ID=#attributes.expense_center_id#
		</cfquery>
		<cfquery name="GET_EXPENSE_LIKE" dbtype="query">
			SELECT EXPENSE_ID FROM GET_EXPENSE_CENTER WHERE EXPENSE_CODE LIKE '#GET_EXPENSE_CODE.EXPENSE_CODE#.%'
		</cfquery>
		<cfif GET_EXPENSE_LIKE.RECORDCOUNT>
			<cfset attributes.expense_center_id_list=listappend(attributes.expense_center_id_list,ValueList(GET_EXPENSE_LIKE.EXPENSE_ID,','),',')>
			<cfset attributes.expense_center_id_list=listdeleteduplicates(listsort(attributes.expense_center_id_list,"numeric","ASC"))>
		</cfif>
	</cfif>
	<cfif isdefined("attributes.ch_employee_id")>
	<cfscript>
		attributes.acc_type_id = '';
		if(listlen(attributes.ch_employee_id,'_') eq 2)
		{
			attributes.acc_type_id = listlast(attributes.ch_employee_id,'_');
			attributes.employee_id_ = listfirst(attributes.ch_employee_id,'_');
		}
		else
			attributes.employee_id_ = attributes.ch_employee_id;
	</cfscript>
</cfif>
<cfquery name="GET_EXPENSE_ITEM_ROW_ALL" datasource="#DSN2#">
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
            EXPENSE_ITEMS_ROWS.MEMBER_TYPE,
            EXPENSE_ITEMS_ROWS.DETAIL,
            EXPENSE_ITEMS_ROWS.COMPANY_PARTNER_ID,
            EXPENSE_ITEMS_ROWS.OTHER_MONEY_VALUE,
            EXPENSE_ITEMS_ROWS.OTHER_MONEY_GROSS_TOTAL,
            EXPENSE_ITEMS_ROWS.EXPENSE_COST_TYPE,
            EXPENSE_ITEMS_ROWS.ACTION_ID,
            EXPENSE_ITEMS_ROWS.INVOICE_ID,
            EXPENSE_ITEMS_ROWS.QUANTITY,
            
            CASE WHEN ISNULL(EXPENSE_ITEMS_ROWS.EXPENSE_ID,0) = 0 AND ISNULL(EXPENSE_ITEMS_ROWS.INVOICE_ID,0) = 0 AND EXPENSE_ITEMS_ROWS.MEMBER_TYPE = 'partner'
            THEN EXPENSE_ITEMS_ROWS.COMPANY_ID
            ELSE ISNULL((SELECT INV.COMPANY_ID FROM INVOICE INV WHERE INV.INVOICE_ID = EXPENSE_ITEMS_ROWS.INVOICE_ID),(SELECT EXP.CH_COMPANY_ID FROM EXPENSE_ITEM_PLANS EXP WHERE EXP.EXPENSE_ID = EXPENSE_ITEMS_ROWS.EXPENSE_ID)) 
            END COMPANY_ID,
            
            CASE WHEN ISNULL(EXPENSE_ITEMS_ROWS.EXPENSE_ID,0) = 0 AND ISNULL(EXPENSE_ITEMS_ROWS.INVOICE_ID,0) = 0 AND EXPENSE_ITEMS_ROWS.MEMBER_TYPE = 'consumer'
            THEN EXPENSE_ITEMS_ROWS.COMPANY_PARTNER_ID
            ELSE ISNULL((SELECT INV.CONSUMER_ID FROM INVOICE INV WHERE INV.INVOICE_ID = EXPENSE_ITEMS_ROWS.INVOICE_ID),(SELECT EXP.CH_CONSUMER_ID FROM EXPENSE_ITEM_PLANS EXP WHERE EXP.EXPENSE_ID = EXPENSE_ITEMS_ROWS.EXPENSE_ID))
            END CONSUMER_ID,
            
            CASE WHEN ISNULL(EXPENSE_ITEMS_ROWS.EXPENSE_ID,0) = 0 AND ISNULL(EXPENSE_ITEMS_ROWS.INVOICE_ID,0) = 0 AND EXPENSE_ITEMS_ROWS.MEMBER_TYPE = 'employee'
            THEN EXPENSE_ITEMS_ROWS.COMPANY_ID
            ELSE ISNULL((SELECT INV.EMPLOYEE_ID FROM INVOICE INV WHERE INV.INVOICE_ID = EXPENSE_ITEMS_ROWS.INVOICE_ID),(SELECT EXP.CH_EMPLOYEE_ID FROM EXPENSE_ITEM_PLANS EXP WHERE EXP.EXPENSE_ID = EXPENSE_ITEMS_ROWS.EXPENSE_ID))
            END EMPLOYEE_ID,
            
            ISNULL(ROW_PAPER_NO,ISNULL((SELECT EXP.PAPER_NO FROM EXPENSE_ITEM_PLANS EXP WHERE EXP.EXPENSE_ID = EXPENSE_ITEMS_ROWS.EXPENSE_ID),(SELECT II.INVOICE_NUMBER FROM INVOICE II WHERE II.INVOICE_ID = EXPENSE_ITEMS_ROWS.INVOICE_ID))) PAPER_NO,
            EXPENSE_ITEMS.EXPENSE_ITEM_NAME,
            EXPENSE_CENTER.EXPENSE,
            (SELECT SF.FIS_ID FROM STOCK_FIS_ROW SF WHERE SF.STOCK_FIS_ROW_ID = EXPENSE_ITEMS_ROWS.ACTION_ID) FIS_ID
        FROM 
            EXPENSE_ITEMS_ROWS,
            EXPENSE_ITEMS,
            EXPENSE_CENTER
        WHERE 
            EXPENSE_ITEMS_ROWS.IS_INCOME = 0 AND
            EXPENSE_ITEMS.EXPENSE_ITEM_ID = EXPENSE_ITEMS_ROWS.EXPENSE_ITEM_ID AND
            EXPENSE_CENTER.EXPENSE_ID = EXPENSE_ITEMS_ROWS.EXPENSE_CENTER_ID
            <cfif not get_module_power_user(48)>
                AND EXPENSE_ITEMS.EXPENSE_CATEGORY_ID NOT IN (SELECT EC.EXPENSE_CAT_ID FROM EXPENSE_CATEGORY EC WHERE ISNULL(EC.EXPENCE_IS_HR,0) = 1)
            </cfif>
            <cfif isdefined("attributes.expense_cat") and len(attributes.expense_cat)>AND EXPENSE_ITEMS.EXPENSE_CATEGORY_ID = #attributes.expense_cat#</cfif>
            <cfif len(attributes.keyword)>
                AND 
                (
                    (EXPENSE_ITEMS_ROWS.ROW_PAPER_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">) OR
                    (EXPENSE_ITEMS_ROWS.PAPER_TYPE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">) OR
                    (EXPENSE_ITEMS_ROWS.DETAIL LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">) OR
                    (EXPENSE_ITEMS_ROWS.EXPENSE_ID IN
                                (SELECT 
                                    EXP.EXPENSE_ID 
                                FROM 
                                    EXPENSE_ITEM_PLANS EXP 
                                WHERE 
                                    EXP.EXPENSE_ID = EXPENSE_ITEMS_ROWS.EXPENSE_ID
                                    AND EXP.PAPER_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">))
                )
            </cfif>		
            <cfif len(attributes.search_date1)>AND EXPENSE_ITEMS_ROWS.EXPENSE_DATE >= #attributes.search_date1#</cfif>
            <cfif len(attributes.search_date2)>AND EXPENSE_ITEMS_ROWS.EXPENSE_DATE < #dateadd("d",1,attributes.search_date2)#</cfif>
            <cfif len(attributes.record_date1)>
                AND EXPENSE_ITEMS_ROWS.RECORD_DATE >= #attributes.record_date1#
            </cfif>
            <cfif len(attributes.record_date2)>
                AND EXPENSE_ITEMS_ROWS.RECORD_DATE < #dateadd("d",1,attributes.record_date2)#
            </cfif>
    
            <cfif attributes.member_type is 'partner' and len(attributes.expense_part_id) and len(attributes.recorder_name)>
                AND EXPENSE_ITEMS_ROWS.MEMBER_TYPE = 'partner'
                AND EXPENSE_ITEMS_ROWS.COMPANY_PARTNER_ID = #attributes.expense_part_id#
            <cfelseif attributes.member_type is 'consumer' and len(attributes.expense_cons_id) and len(attributes.recorder_name)>
                AND EXPENSE_ITEMS_ROWS.MEMBER_TYPE = 'consumer'
                AND EXPENSE_ITEMS_ROWS.COMPANY_PARTNER_ID = #attributes.expense_cons_id#
            <cfelseif attributes.member_type is 'employee' and len(attributes.expense_emp_id) and len(attributes.recorder_name)>
                AND EXPENSE_ITEMS_ROWS.MEMBER_TYPE = 'employee'
                AND EXPENSE_ITEMS_ROWS.COMPANY_PARTNER_ID = #attributes.expense_emp_id#
            </cfif> 
            <cfif attributes.ch_member_type is 'partner' and len(attributes.ch_company_id) and len(attributes.ch_company)>
                AND 
                (
                    (EXPENSE_ITEMS_ROWS.MEMBER_TYPE='partner' AND EXPENSE_ITEMS_ROWS.COMPANY_ID=#attributes.ch_company_id#) OR
                    ISNULL((SELECT INV.COMPANY_ID FROM INVOICE INV WHERE INV.INVOICE_ID = EXPENSE_ITEMS_ROWS.INVOICE_ID),(SELECT EXP.CH_COMPANY_ID FROM EXPENSE_ITEM_PLANS EXP WHERE EXP.EXPENSE_ID = EXPENSE_ITEMS_ROWS.EXPENSE_ID))=#attributes.ch_company_id#
                )
            <cfelseif attributes.ch_member_type is 'consumer' and len(attributes.ch_consumer_id) and len(attributes.ch_company)>
                AND 
                (
                    (EXPENSE_ITEMS_ROWS.MEMBER_TYPE='consumer' AND EXPENSE_ITEMS_ROWS.COMPANY_PARTNER_ID=#attributes.ch_consumer_id#) OR
                    ISNULL((SELECT INV.CONSUMER_ID FROM INVOICE INV WHERE INV.INVOICE_ID = EXPENSE_ITEMS_ROWS.INVOICE_ID),(SELECT EXP.CH_CONSUMER_ID FROM EXPENSE_ITEM_PLANS EXP WHERE EXP.EXPENSE_ID = EXPENSE_ITEMS_ROWS.EXPENSE_ID))=#attributes.ch_consumer_id#
                )
            <cfelseif attributes.ch_member_type is 'employee' and len(attributes.ch_employee_id) and len(attributes.ch_company)>
                AND 
                (
                    (EXPENSE_ITEMS_ROWS.MEMBER_TYPE='employee' AND EXPENSE_ITEMS_ROWS.COMPANY_PARTNER_ID=#attributes.employee_id_#) OR
                    ISNULL((SELECT INV.EMPLOYEE_ID FROM INVOICE INV WHERE INV.INVOICE_ID = EXPENSE_ITEMS_ROWS.INVOICE_ID),(SELECT EXP.CH_EMPLOYEE_ID FROM EXPENSE_ITEM_PLANS EXP WHERE EXP.EXPENSE_ID = EXPENSE_ITEMS_ROWS.EXPENSE_ID))=#attributes.employee_id_#
                )
            </cfif>
            <cfif not get_module_power_user(48)><!--- Ehesap Yetkisi Yoksa Calisanlari Gormesin --->
                AND
                (	(ISNULL(EXPENSE_ITEMS_ROWS.INVOICE_ID,0) <> 0 AND ISNULL((SELECT INV.EMPLOYEE_ID FROM INVOICE INV WHERE INV.INVOICE_ID = EXPENSE_ITEMS_ROWS.INVOICE_ID),0)= 0) OR
                    (ISNULL(EXPENSE_ITEMS_ROWS.EXPENSE_ID,0) <> 0 AND ISNULL((SELECT EXP.CH_EMPLOYEE_ID FROM EXPENSE_ITEM_PLANS EXP WHERE EXP.EXPENSE_ID = EXPENSE_ITEMS_ROWS.EXPENSE_ID),0) = 0) OR
                    (ISNULL(EXPENSE_ITEMS_ROWS.EXPENSE_ID,0) = 0 AND (ISNULL(EXPENSE_ITEMS_ROWS.MEMBER_TYPE,0) <> 'employee'))
                )
            </cfif>
            <cfif len(attributes.expense_item_id)>AND EXPENSE_ITEMS_ROWS.EXPENSE_ITEM_ID = #attributes.expense_item_id#</cfif>
            <cfif isdefined("attributes.expense_center_id_list") and len(attributes.expense_center_id_list)>AND EXPENSE_ITEMS_ROWS.EXPENSE_CENTER_ID IN (#attributes.expense_center_id_list#)</cfif>
            <cfif len(attributes.activity_type)>AND EXPENSE_ITEMS_ROWS.ACTIVITY_TYPE = #attributes.activity_type#</cfif>
            <cfif len(attributes.asset) and len(attributes.asset_id)>AND EXPENSE_ITEMS_ROWS.PYSCHICAL_ASSET_ID = #attributes.asset_id#</cfif>
            <cfif len(attributes.project) and len(attributes.project_id)>AND EXPENSE_ITEMS_ROWS.PROJECT_ID = #attributes.project_id#</cfif>
            <cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>
                AND EXPENSE_ITEMS_ROWS.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#">
            </cfif>
            <cfif isdefined("attributes.acc_type_id") and len(attributes.acc_type_id)>
                AND EXPENSE_ITEMS_ROWS.EXPENSE_ID IN
                                (SELECT 
                                    EXP.EXPENSE_ID 
                                FROM 
                                    EXPENSE_ITEM_PLANS EXP 
                                WHERE 
                                    EXP.EXPENSE_ID = EXPENSE_ITEMS_ROWS.EXPENSE_ID
                                    AND EXP.ACC_TYPE_ID = #attributes.acc_type_id#)
            </cfif>
            <cfif isdefined("attributes.expense_paper_type") and len(attributes.expense_paper_type)>
                AND EXPENSE_ITEMS_ROWS.PAPER_TYPE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.expense_paper_type#">
            </cfif>
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
                                    SUM((AMOUNT*ISNULL(QUANTITY,1))) AS toplam1,
                                    SUM(amount_kdv) AS toplam2,
                                    SUM(amount_otv) AS toplam8, 
                                    SUM((AMOUNT*ISNULL(QUANTITY,1))+amount_kdv+amount_otv) AS toplam3
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
	<cfif get_expense_item_row_all.recordcount>
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
<cfquery name="get_document_type" datasource="#dsn#">
	SELECT
		SETUP_DOCUMENT_TYPE.DOCUMENT_TYPE_ID,
		SETUP_DOCUMENT_TYPE.DOCUMENT_TYPE_NAME
	FROM
		SETUP_DOCUMENT_TYPE,
		SETUP_DOCUMENT_TYPE_ROW
	WHERE
		SETUP_DOCUMENT_TYPE_ROW.DOCUMENT_TYPE_ID =  SETUP_DOCUMENT_TYPE.DOCUMENT_TYPE_ID AND
		SETUP_DOCUMENT_TYPE_ROW.FUSEACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%cost.form_add_expense_cost%">
	ORDER BY
		DOCUMENT_TYPE_NAME
</cfquery>
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
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'cost.list_expense_management';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'cost/display/list_expense_management.cfm';
</cfscript>
