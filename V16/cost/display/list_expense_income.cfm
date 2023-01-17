<!---
    File: list_expense_income.cfm
    Folder: V16\cost\display\
	Controller: HealthExpensesController.cfm
    Author:
    Date:
    Description:
        Anlaşmalı kurum fatura listeleme sayfasıdır
    History:
		 23.12.2019 Gramoni-Mahmut mahmut.cifci@gramoni.com
		 Listelemede görsel düzenleme yapıldı
    To Do:

--->

<cfsetting showdebugoutput="no">
<cf_get_lang_set module_name="cost">
<cf_xml_page_edit fuseact="cost.list_expense_income">
<cfset components = createObject('component','V16.hr.cfc.assurance_type')>
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.employee_id" default="">
<cfparam name="attributes.ch_company_id" default="">
<cfparam name="attributes.ch_consumer_id" default="">
<cfparam name="attributes.ch_employee_id" default="">
<cfparam name="attributes.ch_company" default="">
<cfparam name="attributes.expense_employee" default="">
<cfparam name="attributes.record_emp_id" default="">
<cfparam name="attributes.record_emp_name" default="">
<cfparam name="attributes.form_submitted" default="">
<cfparam name="attributes.document_type" default="">
<cfparam name="attributes.date_filter" default="1">
<cfparam name="attributes.is_expense_item_plans_requests" default="">
<cfparam name="attributes.reference_no" default="">
<cfparam name="attributes.expense_action_type" default="">
<cfparam name="attributes.listing_type" default="">
<cfparam name="attributes.project_id" default="">
<cfparam name="attributes.project_head" default="">
<cfparam name="attributes.process_cat_type" default="">
<cfparam name="attributes.member_type" default="">
<cfparam name="attributes.efatura_type" default="">
<cfparam name="attributes.earchive_type" default="">
<cfparam name="attributes.iptal_invoice" default="">
<cfparam name="attributes.department_id" default="">
<cfparam name="attributes.process_stage" default="">
<cfparam name="attributes.expense_center_name" default="">
<cfparam name="attributes.expense_center_id" default="">
<cfparam name="attributes.expense_item_name" default="">
<cfparam name="attributes.expense_item_id" default="">
<cfif isdefined("attributes.start_date")>
	<cfparam name="attributes.search_date1" default="#attributes.start_date#">
<cfelse>
	<cfparam name="attributes.search_date1" default="">
</cfif>
<cfif isdefined("attributes.finish_date")>
	<cfparam name="attributes.search_date2" default="#attributes.finish_date#">
<cfelse>
	<cfparam name="attributes.search_date2" default="">
</cfif>
<cfif isDefined("attributes.record_date1") and isDate(attributes.record_date1)>
	<cf_date tarih = "attributes.record_date1">
<cfelse>
	<cfif session.ep.our_company_info.unconditional_list>
		<cfset attributes.record_date1=''>
	<cfelse>
		<cfset attributes.record_date1 = dateadd('d',-7,wrk_get_today())>
	</cfif>
</cfif>
<cfif isDefined("attributes.record_date2") and isDate(attributes.record_date2)>
	<cf_date tarih = "attributes.record_date2">
<cfelse>
	<cfif session.ep.our_company_info.unconditional_list>
		<cfset attributes.record_date2=''>
	<cfelse>
		<cfset attributes.record_date2 = dateadd('d',-7,wrk_get_today())>
	</cfif>
</cfif>
<cfif isdefined("attributes.search_date1") and isdate(attributes.search_date1)>
	<cf_date tarih = "attributes.search_date1">
<cfelse>
	<cfif session.ep.our_company_info.unconditional_list>
		<cfset attributes.search_date1=''>
	<cfelse>
		<cfset attributes.search_date1 = dateadd('d',-7,wrk_get_today())>
	</cfif>
</cfif>
<cfif isdefined("attributes.search_date2") and isdate(attributes.search_date2)>
	<cf_date tarih = "attributes.search_date2">
<cfelse>
	<cfif session.ep.our_company_info.unconditional_list>
		<cfset attributes.search_date2=''>
	<cfelse>
		<cfset attributes.search_date2 = dateadd('d',7,attributes.search_date1)>
	</cfif>
</cfif>
<cfquery name="GET_DOCUMENT_TYPE" datasource="#dsn#">
	SELECT
		SETUP_DOCUMENT_TYPE.DOCUMENT_TYPE_ID,
		SETUP_DOCUMENT_TYPE.DOCUMENT_TYPE_NAME
	FROM
		SETUP_DOCUMENT_TYPE,
		SETUP_DOCUMENT_TYPE_ROW
	WHERE
		SETUP_DOCUMENT_TYPE_ROW.DOCUMENT_TYPE_ID =  SETUP_DOCUMENT_TYPE.DOCUMENT_TYPE_ID AND
		SETUP_DOCUMENT_TYPE_ROW.FUSEACTION LIKE '%#fuseaction#%'
	ORDER BY
		DOCUMENT_TYPE_NAME
</cfquery>
<cfquery name="get_process_cat" datasource="#dsn3#">
	SELECT PROCESS_CAT_ID, PROCESS_CAT, PROCESS_TYPE FROM SETUP_PROCESS_CAT WHERE 
	<cfif fusebox.circuit is 'health'>
		PROCESS_TYPE IN (1201) 
	<cfelse>
		PROCESS_TYPE IN (120,121,122) 
	</cfif>
	ORDER BY PROCESS_TYPE, PROCESS_CAT
</cfquery>
<cfquery name="get_processType" datasource="#dsn#">
	SELECT
		PTR.PROCESS_ROW_ID,
		PTR.STAGE
	FROM
		PROCESS_TYPE PT,
		PROCESS_TYPE_ROWS PTR,
		PROCESS_TYPE_OUR_COMPANY PTOC
	WHERE
		PT.IS_ACTIVE = 1 AND
		PT.PROCESS_ID = PTOC.PROCESS_ID AND
		PTOC.OUR_COMPANY_ID = #session.ep.company_id# AND
		PTR.PROCESS_ID = PT.PROCESS_ID AND
		CAST(PT.FACTION AS NVARCHAR(2500))+',' LIKE '%health.expenses,%'
	ORDER BY
		PTOC.OUR_COMPANY_ID,
		PT.PROCESS_ID
</cfquery>
<cfquery name="get_branchs" datasource="#dsn#">
	SELECT 
		BRANCH_ID,BRANCH_NAME 
	FROM 
		BRANCH 
	WHERE
		BRANCH_STATUS = 1
		<cfif session.ep.isBranchAuthorization>
			AND BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#)
		</cfif>
	ORDER BY 
		BRANCH_NAME
</cfquery>
<cfif len(attributes.form_submitted)>
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
	<cfquery name="GET_EXPENSE" datasource="#dsn2#">
		SELECT 
			<cfif fusebox.circuit is 'health'>
				E.EMPLOYEE_NO,
				E.EMPLOYEE_NAME + ' ' + E.EMPLOYEE_SURNAME AS EMP_NAME,
				--select (NAME + ' ' + SURNAME) AS PATIENT_NAME from #DSN_ALIAS#.EMPLOYEES_RELATIVES WHERE RELATIVE_ID = EXPENSE_ITEM_PLANS.RELATIVE_ID,
			</cfif>
 			SPC.INVOICE_TYPE_CODE,
			EXPENSE_ITEM_PLANS.SERIAL_NUMBER,
			EXPENSE_ITEM_PLANS.COMPANY_HEALTH_AMOUNT,
			EXPENSE_ITEM_PLANS.EMPLOYEE_HEALTH_AMOUNT,
			EXPENSE_ITEM_PLANS.SERIAL_NO,
			EXPENSE_ITEM_PLANS.PAPER_NO,
			EXPENSE_ITEM_PLANS.RECORD_EMP,
			EXPENSE_ITEM_PLANS.ACTION_TYPE,
			EXPENSE_ITEM_PLANS.PROCESS_CAT,
			EXPENSE_ITEM_PLANS.ASSURANCE_ID,
            EXPENSE_ITEM_PLANS.IS_IPTAL,
			EXPENSE_ITEM_PLANS.EXPENSE_ITEM_PLANS_ID,
		<cfif (isdefined('attributes.listing_type') and attributes.listing_type eq 2)><!--- Eğer satır bazında listeleme yapılıyorsa --->
        	EXPENSE_ITEMS_ROWS.OTHER_MONEY_GROSS_TOTAL OTHER_MONEY_NET_TOTAL,
			EXPENSE_ITEMS_ROWS.EXP_ITEM_ROWS_ID,
			EXPENSE_ITEMS.EXPENSE_ITEM_NAME,
			EXPENSE_CENTER.EXPENSE,
			EXPENSE_ITEMS_ROWS.DETAIL,
			EXPENSE_ITEMS_ROWS.AMOUNT TOTAL_AMOUNT,
			EXPENSE_ITEMS_ROWS.TOTAL_AMOUNT TOTAL_AMOUNT_KDVLI,
			EXPENSE_ITEMS_ROWS.AMOUNT_KDV KDV_TOTAL,
			EXPENSE_ITEMS_ROWS.AMOUNT_OTV OTV_TOTAL,
            EXPENSE_ITEMS_ROWS.MONEY_CURRENCY_ID,
			EXPENSE_ITEMS_ROWS.EXPENSE_DATE,
		<cfelse>
        	EXPENSE_ITEM_PLANS.OTHER_MONEY_NET_TOTAL,
			EXPENSE_ITEM_PLANS.TOTAL_AMOUNT,
			EXPENSE_ITEM_PLANS.TOTAL_AMOUNT_KDVLI,
			EXPENSE_ITEM_PLANS.KDV_TOTAL,
			EXPENSE_ITEM_PLANS.OTV_TOTAL,
            EXPENSE_ITEM_PLANS.OTHER_MONEY,
			EXPENSE_ITEM_PLANS.EXPENSE_DATE,
		</cfif>
			EXPENSE_ITEM_PLANS.RECORD_DATE,
			EXPENSE_ITEM_PLANS.EMP_ID,
			EXPENSE_ITEM_PLANS.PAPER_TYPE,
			EXPENSE_ITEM_PLANS.EXPENSE_ID,
			EXPENSE_ITEM_PLANS.CH_COMPANY_ID,
			EXPENSE_ITEM_PLANS.CH_CONSUMER_ID,
			EXPENSE_ITEM_PLANS.CH_EMPLOYEE_ID,
			EXPENSE_ITEM_PLANS.DEPARTMENT_ID,
            COMPANY.FULLNAME,
			COMPANY.IS_CIVIL_COMPANY,
            CONSUMER.CONSUMER_NAME,
            CONSUMER.CONSUMER_SURNAME,
            EMPLOYEES.EMPLOYEE_NAME,
            EMPLOYEES.EMPLOYEE_SURNAME,
            CASE
            	WHEN COMPANY.COMPANY_ID IS NOT NULL THEN COMPANY.USE_EFATURA
                WHEN CONSUMER.CONSUMER_ID IS NOT NULL THEN CONSUMER.USE_EFATURA
            END AS 
            	USE_EFATURA
			<cfif (session.ep.our_company_info.is_efatura)>
                ,ER.PATH
                ,ER.STATUS
                ,ER.PROFILE_ID
                ,ER.EINVOICE_ID
                ,ER.STATUS_CODE
				,ER.SENDER_TYPE
                ,(SELECT COUNT(SENDING_DETAIL_ID) FROM EINVOICE_SENDING_DETAIL ESD WHERE ESD.ACTION_ID = EXPENSE_ITEM_PLANS.EXPENSE_ID AND ESD.ACTION_TYPE = 'EXPENSE_ITEM_PLANS') EINVOICE_COUNT
                ,(SELECT COUNT(RECEIVING_DETAIL_ID) FROM EINVOICE_RECEIVING_DETAIL ESD WHERE ESD.EXPENSE_ID = EXPENSE_ITEM_PLANS.EXPENSE_ID) EFATURA_COUNT
                ,(SELECT COUNT(*) COUNT FROM EINVOICE_RELATION ER WHERE ER.ACTION_ID = EXPENSE_ITEM_PLANS.EXPENSE_ID AND ER.ACTION_TYPE = 'EXPENSE_ITEM_PLANS') EINVOICE_CONTROL
            </cfif>
            <cfif (session.ep.our_company_info.is_earchive)>
                ,ERA.PATH PATH_EINVOICE
                ,ERA.STATUS STATUS_EINVOICE
                ,ERA.EARCHIVE_ID
                ,ISNULL(ERA.IS_CANCEL,0) IS_CANCEL
                ,(SELECT COUNT(*) COUNT FROM EARCHIVE_RELATION ER WHERE ER.ACTION_ID = EXPENSE_ITEM_PLANS.EXPENSE_ID AND ER.ACTION_TYPE = 'EXPENSE_ITEM_PLANS') EARCHIVE_CONTROL
            </cfif>
            ,BR.BRANCH_NAME BRANCH
			,PR.PROJECT_HEAD PROJECT
			,(SELECT STAGE FROM #dsn_alias#.PROCESS_TYPE_ROWS PTR WHERE PROCESS_ROW_ID = EXPENSE_ITEM_PLANS.PROCESS_STAGE ) as PSTAGE
			,EXPENSE_ITEM_PLANS.PROCESS_STAGE   
		FROM
			EXPENSE_ITEM_PLANS
			LEFT JOIN #DSN_ALIAS#.EMPLOYEES E ON E.EMPLOYEE_ID = EXPENSE_ITEM_PLANS.EMP_ID
            	LEFT JOIN #dsn_alias#.COMPANY ON COMPANY.COMPANY_ID = EXPENSE_ITEM_PLANS.CH_COMPANY_ID <cfif len(attributes.efatura_type) and attributes.efatura_type eq 1>AND COMPANY.USE_EFATURA = 1 AND COMPANY.EFATURA_DATE <= EXPENSE_ITEM_PLANS.EXPENSE_DATE</cfif>
          	<cfif len(attributes.earchive_type)> 
				LEFT JOIN #dsn_alias#.COMPANY C2 ON C2.COMPANY_ID = EXPENSE_ITEM_PLANS.CH_COMPANY_ID AND COMPANY.USE_EFATURA = 1 AND COMPANY.EFATURA_DATE <= EXPENSE_ITEM_PLANS.EXPENSE_DATE
			</cfif>
                LEFT JOIN #dsn_alias#.CONSUMER ON CONSUMER.CONSUMER_ID = EXPENSE_ITEM_PLANS.CH_CONSUMER_ID <cfif len(attributes.efatura_type) and attributes.efatura_type eq 1>AND CONSUMER.USE_EFATURA = 1 AND CONSUMER.EFATURA_DATE <= EXPENSE_ITEM_PLANS.EXPENSE_DATE</cfif>
                LEFT JOIN #dsn_alias#.EMPLOYEES ON EMPLOYEES.EMPLOYEE_ID = EXPENSE_ITEM_PLANS.CH_EMPLOYEE_ID
                LEFT JOIN #dsn_alias#.BRANCH BR ON EXPENSE_ITEM_PLANS.BRANCH_ID=BR.BRANCH_ID
				LEFT JOIN #dsn_alias#.DEPARTMENT D ON EXPENSE_ITEM_PLANS.DEPARTMENT_ID=D.DEPARTMENT_ID
			<cfif (isdefined('attributes.listing_type') and attributes.listing_type eq 1)><!--- Eğer belge bazında listeleme yapılıyorsa --->	
				LEFT JOIN #dsn_alias#.PRO_PROJECTS PR ON EXPENSE_ITEM_PLANS.PROJECT_ID=PR.PROJECT_ID
			</cfif>	
			<cfif session.ep.our_company_info.is_efatura>
                LEFT JOIN EINVOICE_RELATION ER ON ER.ACTION_ID = EXPENSE_ITEM_PLANS.EXPENSE_ID AND ER.ACTION_TYPE = 'EXPENSE_ITEM_PLANS'
                LEFT JOIN EINVOICE_RECEIVING_DETAIL ERD ON ERD.EXPENSE_ID = EXPENSE_ITEM_PLANS.EXPENSE_ID
            </cfif>
            <cfif session.ep.our_company_info.is_earchive>
                LEFT JOIN EARCHIVE_RELATION ERA ON ERA.ACTION_ID = EXPENSE_ITEM_PLANS.EXPENSE_ID AND ERA.ACTION_TYPE = 'EXPENSE_ITEM_PLANS'
            </cfif>                 
		<cfif (isdefined('attributes.listing_type') and attributes.listing_type eq 2)><!--- Eğer satır bazında listeleme yapılıyorsa --->
			,EXPENSE_ITEMS_ROWS LEFT JOIN #dsn_alias#.PRO_PROJECTS PR ON EXPENSE_ITEMS_ROWS.PROJECT_ID=PR.PROJECT_ID
			,EXPENSE_ITEMS
			,EXPENSE_CENTER
		</cfif>
			,#dsn3_alias#.SETUP_PROCESS_CAT SPC
		WHERE
			EXPENSE_ITEM_PLANS.EXPENSE_ID IS NOT NULL AND 
            SPC.PROCESS_CAT_ID = EXPENSE_ITEM_PLANS.PROCESS_CAT
			<cfif isdefined('attributes.process_stage') and len(attributes.process_stage)>
				AND EXPENSE_ITEM_PLANS.PROCESS_STAGE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_stage#">
			</cfif>
			<cfif (isdefined('attributes.listing_type') and attributes.listing_type eq 2)><!--- Eğer satır bazında listeleme yapılıyorsa --->
				AND EXPENSE_ITEM_PLANS.EXPENSE_ID = EXPENSE_ITEMS_ROWS.EXPENSE_ID
				AND EXPENSE_ITEMS.EXPENSE_ITEM_ID = EXPENSE_ITEMS_ROWS.EXPENSE_ITEM_ID
				AND EXPENSE_CENTER.EXPENSE_ID = EXPENSE_ITEMS_ROWS.EXPENSE_CENTER_ID
			</cfif>
			<cfif len(attributes.is_expense_item_plans_requests) and attributes.is_expense_item_plans_requests eq 1>
				AND EXPENSE_ITEM_PLANS.EXPENSE_ITEM_PLANS_ID IS NOT NULL
			<cfelseif len(attributes.is_expense_item_plans_requests) and attributes.is_expense_item_plans_requests eq 2>
				AND EXPENSE_ITEM_PLANS.EXPENSE_ITEM_PLANS_ID IS NULL
			</cfif> 
			<cfif Len(attributes.project_id) and Len(attributes.project_head)>
				<cfif Len(attributes.listing_type) and attributes.listing_type eq 2>
					AND ISNULL(EXPENSE_ITEMS_ROWS.PROJECT_ID,EXPENSE_ITEM_PLANS.PROJECT_ID) = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
				<cfelse>
					AND EXPENSE_ITEM_PLANS.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
				</cfif>
			</cfif>
			<cfif len(attributes.process_cat_type) and listlast(attributes.process_cat_type,'-') eq 0>
				AND EXPENSE_ITEM_PLANS.ACTION_TYPE = #listfirst(attributes.process_cat_type,'-')#
			<cfelseif len(attributes.process_cat_type) and listlast(attributes.process_cat_type,'-') neq 0>
				AND EXPENSE_ITEM_PLANS.PROCESS_CAT = #listlast(attributes.process_cat_type,'-')#
			</cfif>
			<cfif len(attributes.department_id)>
				AND EXPENSE_ITEM_PLANS.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department_id#"> 
			</cfif>
			<cfif len(attributes.keyword)>
				<cfif (isdefined('attributes.listing_type') and attributes.listing_type eq 2)><!--- Eğer satır bazında listeleme yapılıyorsa --->
					AND
					(
						EXPENSE_ITEMS_ROWS.DETAIL LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR
						EXPENSE_ITEM_PLANS.PAPER_NO LIKE <cfif len(attributes.keyword) gt 2><cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#%"></cfif>
					)
				<cfelse>
					AND EXPENSE_ITEM_PLANS.PAPER_NO LIKE <cfif len(attributes.keyword) gt 2><cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#%"></cfif>
				</cfif>
			</cfif>
			<cfif (isdefined('attributes.listing_type') and attributes.listing_type eq 2)><!--- Satır bazında listeleme yapıyorsak satırdaki tarihe baksın --->
				<cfif len(attributes.search_date1)>AND EXPENSE_ITEMS_ROWS.EXPENSE_DATE >= #attributes.search_date1#</cfif>
				<cfif len(attributes.search_date2)>AND EXPENSE_ITEMS_ROWS.EXPENSE_DATE < #dateadd("d",1,attributes.search_date2)#</cfif>
				<cfif len(attributes.expense_center_id) and len(attributes.expense_center_name)> AND EXPENSE_ITEMS_ROWS.EXPENSE_CENTER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.expense_center_id#"></cfif>
				<cfif len(attributes.expense_item_id) and len(attributes.expense_item_name)> AND EXPENSE_ITEMS_ROWS.EXPENSE_ITEM_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.expense_item_id#"></cfif>
			<cfelse>
				<cfif len(attributes.search_date1)>AND EXPENSE_ITEM_PLANS.EXPENSE_DATE >= #attributes.search_date1#</cfif>
				<cfif len(attributes.search_date2)>AND EXPENSE_ITEM_PLANS.EXPENSE_DATE < #dateadd("d",1,attributes.search_date2)#</cfif>
			</cfif>
			<cfif len(attributes.expense_employee) and len(attributes.employee_id)>AND EXPENSE_ITEM_PLANS.EMP_ID = #attributes.employee_id#</cfif>
			<cfif len(attributes.document_type)>AND EXPENSE_ITEM_PLANS.PAPER_TYPE = #attributes.document_type#</cfif>
			<cfif len(attributes.reference_no)>AND EXPENSE_ITEM_PLANS.SYSTEM_RELATION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.reference_no#%"></cfif>
			<cfif attributes.member_type is 'partner' and len(attributes.ch_company_id) and len(attributes.ch_company)>
				AND EXPENSE_ITEM_PLANS.CH_COMPANY_ID = #attributes.ch_company_id#
			<cfelseif attributes.member_type is 'consumer' and len(attributes.ch_consumer_id) and len(attributes.ch_company)>
				AND EXPENSE_ITEM_PLANS.CH_CONSUMER_ID = #attributes.ch_consumer_id#
			<cfelseif attributes.member_type is 'employee' and len(attributes.ch_employee_id) and len(attributes.ch_company)>
				AND EXPENSE_ITEM_PLANS.CH_EMPLOYEE_ID = #attributes.employee_id_#
			</cfif>
			<cfif len(attributes.record_emp_id) and len(attributes.record_emp_name)>AND EXPENSE_ITEM_PLANS.RECORD_EMP = #attributes.record_emp_id#</cfif>
			<cfif len(attributes.expense_action_type)>AND EXPENSE_ITEM_PLANS.ACTION_TYPE = #attributes.expense_action_type#</cfif>
			<cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>
				AND EXPENSE_ITEM_PLANS.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#">
			<cfelseif session.ep.isBranchAuthorization>
				AND EXPENSE_ITEM_PLANS.BRANCH_ID IN (SELECT BRANCH_ID FROM #dsn#.EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#)
			</cfif>
			
			<cfif isdefined("attributes.record_date1") and isdate(attributes.record_date1)>AND EXPENSE_ITEM_PLANS.RECORD_DATE >= #attributes.record_date1#</cfif>
			<cfif isdefined("attributes.record_date2") and isdate(attributes.record_date2)>AND EXPENSE_ITEM_PLANS.RECORD_DATE < #dateadd("d",1,attributes.record_date2)#</cfif>
			<cfif isdefined("attributes.acc_type_id") and len(attributes.acc_type_id)>
				AND EXPENSE_ITEM_PLANS.ACC_TYPE_ID = #attributes.acc_type_id#
			</cfif>
            <cfif len(attributes.iptal_invoice)>
                AND EXPENSE_ITEM_PLANS.IS_IPTAL = #attributes.iptal_invoice#
            </cfif>
			<cfif len(attributes.efatura_type) and attributes.efatura_type neq 5>
            	AND COMPANY.USE_EFATURA = 1
                AND (PROCESS_TYPE = 121 OR PROCESS_TYPE = 120 OR PROCESS_TYPE = 1201)
            	AND ((COMPANY.COMPANY_ID IS NOT NULL OR CONSUMER.CONSUMER_ID IS NOT NULL) AND (SPC.INVOICE_TYPE_CODE IS NOT NULL OR EXPENSE_ITEM_PLANS.ACTION_TYPE = 120 OR EXPENSE_ITEM_PLANS.ACTION_TYPE = 1201))
				<cfif attributes.efatura_type eq 1>
                    AND ((ER.STATUS IS NULL AND SPC.INVOICE_TYPE_CODE IS NOT NULL
					AND (SELECT COUNT(SENDING_DETAIL_ID) FROM EINVOICE_SENDING_DETAIL ESD WHERE ESD.ACTION_ID = EXPENSE_ITEM_PLANS.EXPENSE_ID AND ESD.ACTION_TYPE = 'EXPENSE_ITEM_PLANS' AND STATUS_CODE = 1) = 0) OR ER.STATUS_CODE IN (50,60,80,110))
					AND EXPENSE_ITEM_PLANS.EXPENSE_DATE >= #createodbcdatetime(session.ep.our_company_info.efatura_date)#                   
                <cfelseif attributes.efatura_type eq 2>
                    AND 
					(
						(
							(SELECT COUNT(SENDING_DETAIL_ID) FROM EINVOICE_SENDING_DETAIL ESD WHERE ESD.ACTION_ID = EXPENSE_ITEM_PLANS.EXPENSE_ID AND ESD.ACTION_TYPE = 'EXPENSE_ITEM_PLANS' AND STATUS_CODE = 1) > 0 
							AND ER.PATH IS NOT NULL
						)
						OR
						(SELECT COUNT(RECEIVING_DETAIL_ID) FROM EINVOICE_RECEIVING_DETAIL ESD WHERE ESD.EXPENSE_ID = EXPENSE_ITEM_PLANS.EXPENSE_ID) > 0
					)
                <cfelseif attributes.efatura_type eq 3>
                    AND ER.STATUS = 1
                <cfelseif attributes.efatura_type eq 4>
                    AND ER.STATUS = 0
				<cfelseif attributes.efatura_type eq 6>
                    AND 
					(
						(
							(SELECT COUNT(SENDING_DETAIL_ID) FROM EINVOICE_SENDING_DETAIL ESD WHERE ESD.ACTION_ID = EXPENSE_ITEM_PLANS.EXPENSE_ID AND ESD.ACTION_TYPE = 'EXPENSE_ITEM_PLANS' AND STATUS_CODE = 1) = 0 
							AND (SELECT COUNT(SENDING_DETAIL_ID) FROM EINVOICE_SENDING_DETAIL ESD WHERE ESD.ACTION_ID = EXPENSE_ITEM_PLANS.EXPENSE_ID AND ESD.ACTION_TYPE = 'EXPENSE_ITEM_PLANS' AND STATUS_CODE <> 1) > 0 
						)
					)
                <cfelseif attributes.efatura_type eq 7>
                    AND 
					(
						(
							(SELECT COUNT(SENDING_DETAIL_ID) FROM EINVOICE_SENDING_DETAIL ESD WHERE ESD.ACTION_ID = EXPENSE_ITEM_PLANS.EXPENSE_ID AND ESD.ACTION_TYPE = 'EXPENSE_ITEM_PLANS' AND STATUS_CODE = 1) > 0 
							AND ER.PATH IS NOT NULL
						)
						AND (ER.STATUS IS NULL)
					)
                </cfif>
            </cfif>
            <cfif attributes.efatura_type eq 5>
            	AND 
                (
                  (COMPANY.USE_EFATURA != 1 OR CONSUMER.USE_EFATURA != 1)
                AND (SELECT COUNT(RECEIVING_DETAIL_ID) FROM EINVOICE_RECEIVING_DETAIL ESD WHERE ESD.EXPENSE_ID = EXPENSE_ITEM_PLANS.EXPENSE_ID) = 0
                )
            </cfif>
            <cfif len(attributes.earchive_type)>
				<cfif attributes.earchive_type neq 5> 
					AND SPC.INVOICE_TYPE_CODE IS NOT NULL
				</cfif>
				<cfif attributes.earchive_type eq 1>
                    AND EXPENSE_ITEM_PLANS.EXPENSE_DATE >=#createodbcdatetime(session.ep.our_company_info.earchive_date)#
                    AND C2.COMPANY_ID IS NULL 
                    AND 
                    (
                        (
                            ERA.STATUS IS NULL
                            AND SPC.INVOICE_TYPE_CODE IS NOT NULL
                            AND (SELECT COUNT(SENDING_DETAIL_ID) FROM EARCHIVE_SENDING_DETAIL ESD WHERE ESD.ACTION_ID = EXPENSE_ITEM_PLANS.EXPENSE_ID AND ESD.ACTION_TYPE = 'EXPENSE_ITEM_PLANS' AND STATUS_CODE = 1) = 0
                        )
                    )                
				<cfelseif attributes.earchive_type eq 2>
                    AND 
					(
						(
							(SELECT COUNT(SENDING_DETAIL_ID) FROM EARCHIVE_SENDING_DETAIL ESD WHERE ESD.ACTION_ID = EXPENSE_ITEM_PLANS.EXPENSE_ID AND ESD.ACTION_TYPE = 'EXPENSE_ITEM_PLANS' AND STATUS_CODE = 1) > 0 
							AND ERA.PATH IS NOT NULL
                            AND ERA.EARCHIVE_SENDING_TYPE = 0
                            AND ERA.STATUS <> 0
						)
					)
                <cfelseif attributes.earchive_type eq 3>
                	AND 
					(
						(
							(SELECT COUNT(SENDING_DETAIL_ID) FROM EARCHIVE_SENDING_DETAIL ESD WHERE ESD.ACTION_ID = EXPENSE_ITEM_PLANS.EXPENSE_ID AND ESD.ACTION_TYPE = 'EXPENSE_ITEM_PLANS' AND STATUS_CODE = 1) > 0 
							AND ERA.STATUS = 0
						)
					)
                <cfelseif attributes.earchive_type eq 4>
                	AND 
					(
						(
							(SELECT COUNT(SENDING_DETAIL_ID) FROM EARCHIVE_SENDING_DETAIL ESD WHERE ESD.ACTION_ID = EXPENSE_ITEM_PLANS.EXPENSE_ID AND ESD.ACTION_TYPE = 'EXPENSE_ITEM_PLANS' AND STATUS_CODE = 1) > 0 
							AND ERA.PATH IS NOT NULL
                            AND ERA.EARCHIVE_SENDING_TYPE = 1
                            AND ERA.STATUS <> 0
						)
					)
				<cfelseif attributes.earchive_type eq 5>
                	AND EXPENSE_ITEM_PLANS.IS_EARCHIVE = 1
                </cfif>
            </cfif> 
			<cfif fusebox.circuit is 'health'>
				AND PROCESS_TYPE IN (1201) 
			<cfelseif isDefined("attributes.type") and attributes.type eq 120>
				AND PROCESS_TYPE IN (120) 
			<cfelseif isDefined("attributes.type") and attributes.type eq 121>
				AND PROCESS_TYPE IN (121) 
			<cfelse>
				AND PROCESS_TYPE IN (120,121,122) 
			</cfif>
		ORDER BY  
			<cfif len(attributes.date_filter) and attributes.date_filter eq 2>EXPENSE_ITEM_PLANS.EXPENSE_DATE
			<cfelseif len(attributes.date_filter) and attributes.date_filter eq 1>EXPENSE_ITEM_PLANS.EXPENSE_DATE DESC
			<cfelseif len(attributes.date_filter) and attributes.date_filter eq 3>EXPENSE_ITEM_PLANS.PAPER_NO DESC
			<cfelseif len(attributes.date_filter) and attributes.date_filter eq 4>EXPENSE_ITEM_PLANS.PAPER_NO
			</cfif>
	 </cfquery>  
<cfelse>
	 <cfset get_expense.recordcount = 0>
</cfif>
<cfif fusebox.circuit is 'health'>
	<cfset new_page = 'health.expenses'>
<cfelse>
	<cfset new_page = 'cost.list_expense_income'>
</cfif>
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.maxrows" default="#session.ep.maxrows#">
<cfparam name="attributes.totalrecords" default="#get_expense.recordcount#">
<cfset attributes.startrow = ((attributes.page-1)*attributes.maxrows) + 1>
<cfif fusebox.circuit is 'health'>
	<cfset box_title = getLang('training_management',402,'Sağlık Harcama Fişleri')>
<cfelse>
	<cfset box_title = getLang('main',1591)>
</cfif>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cfform name="search_cost" action="#request.self#?fuseaction=#new_page#" method="post">
		<cf_box id="list_cost_search">
			<cf_box_search>
				<div class="form-group">
					<cfinput type="hidden" name="form_submitted" value="1"> 
					<cfinput type="text" name="keyword" id="keyword" placeholder="#getLang(48,'Filtre',57460)#" value="#attributes.keyword#" maxlength="50">
				</div>
				<div class="form-group">
					<cfinput type="text" name="reference_no" id="reference_no" placeholder="#getLang(1372,'Referans',58784)#" value="#attributes.reference_no#" maxlength="50">
				</div>
				<div class="form-group">
					<select name="listing_type" id="listing_type" style="width:100px;" onchange="show_center_item();">
						<option value="1" <cfif attributes.listing_type eq 1>selected</cfif>><cf_get_lang dictionary_id='57660.Belge Bazında'></option>
						<option value="2" <cfif attributes.listing_type eq 2>selected</cfif>><cf_get_lang dictionary_id='29539.Satır Bazında'></option>
					</select>
				</div>
				<div class="form-group small">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" onKeyUp="isNumber(this)" message="#message#" maxlength="3">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4">
				</div>
			</cf_box_search>
			<cf_box_search_detail>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" sort="true" index="1">
					<cfif xml_show_process_stage eq 1>
						<div class="form-group" id="item-process_stage">
							<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='58859.Süreç'></label>
							<div class="col col-12 col-xs-12">
								<cf_workcube_process is_upd='0' select_value='#attributes.process_stage#' process_cat_width='150' is_detail='0' is_select_text="1">
							</div>
						</div>
					</cfif>
					<div class="form-group" id="item-document_type">
						<label class="col col-12"><cfoutput>#getLang(1166,'Belge Türü',58578)#</cfoutput></label>
						<div class="col col-12">
							<select name="document_type" id="document_type">
								<option value=""><cfoutput>#getLang(322,'Seçiniz',57734)#</cfoutput></option>
								<cfoutput query="get_document_type">
									<option value="#document_type_id#" <cfif document_type_id eq attributes.document_type>selected</cfif>>#document_type_name#</option>
								</cfoutput>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-process_cat_type">
						<label class="col col-12"><cf_get_lang dictionary_id='47348.Fiş Türü'></label>
						<div class="col col-12">
							<select name="process_cat_type" id="process_cat_type">
								<option value=""><cfoutput>#getLang(322,'Seçiniz',57734)#</cfoutput></option>
								<cfoutput query="get_process_cat" group="process_type">
									<option value="#process_type#-0" <cfif '#process_type#-0' is attributes.process_cat_type>selected</cfif>>#get_process_name(process_type)#</option>
									<cfoutput>
										<option value="#process_type#-#process_cat_id#" <cfif attributes.process_cat_type is '#process_type#-#process_cat_id#'>selected</cfif>>&nbsp;&nbsp;&nbsp;#process_cat#</option>
									</cfoutput>
								</cfoutput>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-branch_id">
						<label class="col col-12"><cfoutput>#getLang(41,'Şube',57453)#</cfoutput></label>
						<div class="col col-12">
							<cfsavecontent variable="opt_value"><cfoutput>#getLang(322,'Seçiniz',57734)#</cfoutput></cfsavecontent>
							<cf_wrkDepartmentBranch fieldId='branch_id' is_branch='1' width='150' selected_value='#attributes.branch_id#' option_value='#opt_value#'>
						</div>
					</div>
					<div class="form-group" id="item-department_id">
						<label class="col col-12"><cf_get_lang dictionary_id='57572.Departman'></label>
						<div class="col col-12">
							<cf_wrkdepartmentbranch fieldid='department_id' is_department='1' width='135' is_deny_control='0' selected_value='#attributes.department_id#'>
						</div>
					</div> 
				</div>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" sort="true" index="2">
					<div class="form-group" id="item-date_filter">
						<label class="col col-12"><cfoutput>#getLang(330,'Tarih',57742)# #getLang(48,'Filtre',57460)#</cfoutput></label>
						<div class="col col-12">
							<select name="date_filter" id="date_filter">
								<option value="1" <cfif attributes.date_filter eq 1>selected</cfif>><cf_get_lang dictionary_id='57926.Azalan Tarih'></option>
								<option value="2" <cfif attributes.date_filter eq 2>selected</cfif>><cf_get_lang dictionary_id='57925.Artan Tarih'></option>
								<option value="3" <cfif attributes.date_filter eq 3>selected</cfif>><cf_get_lang dictionary_id='29458.Azalan No'></option>
								<option value="4" <cfif attributes.date_filter eq 4>selected</cfif>><cf_get_lang dictionary_id='29459.Artan No'></option>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-project">
						<label class="col col-12"><cfoutput>#getLang(4,'Proje',57416)#</cfoutput></label>
						<div class="col col-12">
							<div class="input-group">
								<cfif Len(attributes.project_id) and Len(attributes.project_head)><cfset attributes.project_head = get_project_name(attributes.project_id)></cfif><!--- Buraya baska sayfalardan da erisiliyor, kaldirmayin FBS 20110607 --->
								<input type="hidden" name="project_id" id="project_id" value="<cfif len (attributes.project_id)><cfoutput>#attributes.project_id#</cfoutput></cfif>">
								<input type="text" name="project_head" id="project_head" style="width:120px;" value="<cfif len(attributes.project_head)><cfoutput>#attributes.project_head#</cfoutput></cfif>" onfocus="AutoComplete_Create('project_head','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','','3','150');" autocomplete="off">
								<span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_projects&project_id=search_cost.project_id&project_head=search_cost.project_head');" title="<cfoutput>#getLang(4,'Proje',57416)#</cfoutput>"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-ch_company">
						<label class="col col-12"><cfoutput>#getLang(107,'Cari Hesap',57519)#</cfoutput></label>
						<div class="col col-12">
							<div class="input-group">
								<input type="hidden" name="ch_company_id" id="ch_company_id" value="<cfif isdefined("attributes.ch_company_id") and len(attributes.ch_company_id) and isdefined("attributes.member_type") and len(attributes.member_type) and attributes.member_type is 'partner'><cfoutput>#attributes.ch_company_id#</cfoutput></cfif>">
								<input type="hidden" name="ch_consumer_id" id="ch_consumer_id" value="<cfif isdefined("attributes.ch_consumer_id") and len(attributes.ch_consumer_id) and isdefined("attributes.member_type") and len(attributes.member_type) and attributes.member_type is 'consumer'><cfoutput>#attributes.ch_consumer_id#</cfoutput></cfif>">
								<input type="hidden" name="ch_employee_id"  id="ch_employee_id"value="<cfif isdefined("attributes.ch_employee_id") and len(attributes.ch_employee_id) and isdefined("attributes.member_type") and len(attributes.member_type) and attributes.member_type is 'employee'><cfoutput>#attributes.ch_employee_id#</cfoutput></cfif>">
								<input type="hidden" name="member_type" id="member_type" value="<cfif isdefined("attributes.member_type") and len(attributes.member_type)><cfoutput>#attributes.member_type#</cfoutput></cfif>">
								<input name="ch_company" type="text" id="ch_company" style="width:120px;" onfocus="AutoComplete_Create('ch_company','MEMBER_NAME,MEMBER_CODE','MEMBER_NAME,MEMBER_CODE,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2,3\',\'0\',\'0\',\'0\',\'2\',\'0\',\'0\',\'1\'','COMPANY_ID,CONSUMER_ID,EMPLOYEE_ID,MEMBER_TYPE','ch_company_id,ch_consumer_id,ch_employee_id,member_type','','3','225');" value="<cfif  isdefined("attributes.ch_company") and len(attributes.ch_company)><cfoutput>#attributes.ch_company#</cfoutput></cfif>" autocomplete="off">
								<span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&field_name=search_cost.ch_company&is_cari_action=1&field_type=search_cost.member_type&field_comp_name=search_cost.ch_company&field_consumer=search_cost.ch_consumer_id&field_emp_id=search_cost.ch_employee_id&field_comp_id=search_cost.ch_company_id&select_list=2,3,1,9</cfoutput>','list');" title="<cfoutput>#getLang(107,'Cari Hesap',57519)#</cfoutput>"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-expense_employee">
						<label class="col col-12"><cfoutput>#getLang('cost',9)#</cfoutput></label>
						<div class="col col-12">
							<div class="input-group">
								<input type="hidden" name="employee_id" id="employee_id" value="<cfoutput>#attributes.employee_id#</cfoutput>">
								<input name="expense_employee" type="text" id="expense_employee" style="width:120px;" onfocus="AutoComplete_Create('expense_employee','MEMBER_NAME,','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','employee_id','search_cost','3','135')" value="<cfoutput>#attributes.expense_employee#</cfoutput>" autocomplete="off" >
								<span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=search_cost.employee_id&field_name=search_cost.expense_employee&select_list=1,9','list');" title="<cfoutput>#getLang('cost',9)#</cfoutput>"></span>
							</div>
						</div>
					</div>
					<cfif (isDefined("x_is_health_expense") and x_is_health_expense eq 1) or (listFirst(attributes.fuseaction,'.') eq "health")>
						<div class="form-group" id="item-expense_item_plans_requests">
							<label class="col col-12"><cf_get_lang dictionary_id='33706.Sağlık Harcaması'></label>
							<div class="col col-12">
								<select name="is_expense_item_plans_requests" id="is_expense_item_plans_requests">
									<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
									<option value="1" <cfif attributes.is_expense_item_plans_requests eq 1>selected</cfif>><cf_get_lang dictionary_id='36640.Oluşturulmuş'></option>
									<option value="2" <cfif attributes.is_expense_item_plans_requests eq 2>selected</cfif>><cf_get_lang dictionary_id='36641.Oluşturulmamış'></option>
								</select>
							</div>
						</div>
					</cfif>
				</div>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" sort="true" index="3">
					<div class="form-group" id="item-record_emp_name">
						<label class="col col-12"><cfoutput>#getLang(487,'Kaydeden',57899)#</cfoutput></label>
						<div class="col col-12">
							<div class="input-group">
								<input type="hidden" name="record_emp_id" id="record_emp_id" value="<cfif len(attributes.record_emp_id)><cfoutput>#attributes.record_emp_id#</cfoutput></cfif>">
								<input name="record_emp_name" type="text"  id="record_emp_name" style="width:120px;" onfocus="AutoComplete_Create('record_emp_name','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','record_emp_id','search_cost','3','135')" value="<cfif len(attributes.record_emp_name)><cfoutput>#attributes.record_emp_name#</cfoutput></cfif>" autocomplete="off">
								<span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_name=search_cost.record_emp_name&field_emp_id=search_cost.record_emp_id<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&select_list=1,9','list');return false" title="<cfoutput>#getLang(487,'Kaydeden',57899)#</cfoutput>"></span>
							</div>
						</div>
					</div>
					<cfif session.ep.our_company_info.is_efatura>
						<div class="form-group" id="item-efatura_type">
							<label class="col col-12"><cf_get_lang dictionary_id="29872.E-Fatura"></label>
							<div class="col col-12">
								<select name="efatura_type" id="efatura_type">
									<option value=""><cf_get_lang dictionary_id="29872.E-Fatura"></option>
									<option value="1" <cfif attributes.efatura_type eq 1>selected</cfif>><cfoutput>#getLang("main",2792,"Gönderilecekler(Gelir)")#</cfoutput></option>
									<option value="2" <cfif attributes.efatura_type eq 2>selected</cfif>><cfoutput>#getLang("main",2793,"E-Fatura Kesilenler(Masraf-Gelir)")#</cfoutput></option>
									<option value="3" <cfif attributes.efatura_type eq 3>selected</cfif>><cfoutput>#getLang("main",2794,"Onay(Gelir)")#</cfoutput></option>
									<option value="4" <cfif attributes.efatura_type eq 4>selected</cfif>><cfoutput>#getLang("main",2795,"Red(Gelir)")#</cfoutput></option>
									<option value="6" <cfif attributes.efatura_type eq 6>selected</cfif>><cfoutput>#getLang("main",2791,"Gönderilemeyenler")#</cfoutput></option>
									<option value="7" <cfif attributes.efatura_type eq 7>selected</cfif>><cfoutput>#getLang("main",2796,"Onay Bekleyenler")#</cfoutput></option>
									<option value="5" <cfif attributes.efatura_type eq 5>selected</cfif>><cfoutput>#getLang("main",2797,"E-Fatura Olmayanlar")#</cfoutput></option>
								</select>
							</div>
						</div>
					</cfif>
					<cfif session.ep.our_company_info.is_earchive>
						<div class="form-group" id="item-earchive_type">
							<label class="col col-12"><cfoutput>#getLang(2787,"E-Arşiv",59328)#</cfoutput></label>
							<div class="col col-12">
								<select name="earchive_type" id="earchive_type">
									<option value=""><cfoutput>#getLang(2787,"E-Arşiv",59328)#</cfoutput></option>
									<option value="1" <cfif attributes.earchive_type eq 1>selected</cfif>><cfoutput>#getLang("main",2788,"Gönderilecekler")#</cfoutput></option>
									<option value="2" <cfif attributes.earchive_type eq 2>selected</cfif>><cfoutput>#getLang("main",2789,"Gönderilenler(KAĞIT)")#</cfoutput></option>
									<option value="4" <cfif attributes.earchive_type eq 4>selected</cfif>><cfoutput>#getLang("main",2790,"Gönderilenler(ELEKTRONİK)")#</cfoutput></option>
									<option value="3" <cfif attributes.earchive_type eq 3>selected</cfif>><cfoutput>#getLang("main",2791,"Gönderilemeyenler")#</cfoutput></option>
									<option value="5" <cfif attributes.earchive_type eq 5>selected</cfif>><cf_get_lang dictionary_id='64100.Alınanlar (ELEKTRONİK)'></option>
								</select>
							</div>
						</div>
					</cfif>
					<div class="form-group" id="item-iptal_invoice">
						<label class="col col-12"><cf_get_lang dictionary_id='58816.İptal Edilenler'></label>
						<div class="col col-12">
							<select name="iptal_invoice" id="iptal_invoice">
								<option value=""><cf_get_lang dictionary_id ='57708.Tümü'></option>
								<option value="1" <cfif attributes.iptal_invoice eq 1>selected</cfif>><cf_get_lang dictionary_id='58816.İptal Edilenler'></option>
								<option value="0" <cfif attributes.iptal_invoice eq 0>selected</cfif>><cf_get_lang dictionary_id='58817.İptal Edilmeyenler'></option>
							</select>
						</div>
					</div>
				</div>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" sort="true" index="4">
					<div class="form-group" id="item-record_date">
						<label class="col col-12"><cfoutput>#getLang(215,'Kayıt Tarihi',57627)#</cfoutput></label>
						<div class="col col-12">
							<div class="col col-6">
								<div class="input-group">
									<cfsavecontent variable="txt"><cf_get_lang dictionary_id="57782.Tarih Değerini Kontrol Ediniz">!</cfsavecontent>
									<cfinput type="text" name="record_date1" value="#dateformat(attributes.record_date1,dateformat_style)#" maxlength="10" validate="#validate_style#" message="#txt#">
									<span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="record_date1"></span>
								</div>
							</div>
							<div class="col col-6">
								<div class="input-group">
									<cfinput type="text" name="record_date2" value="#dateformat(attributes.record_date2,dateformat_style)#" maxlength="10" validate="#validate_style#" message="#txt#">
									<span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="record_date2"></span>
								</div>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-search_date">
						<label class="col col-12"><cfoutput>#getLang(89,'Başlangıç',57501)#-#getLang(90,'Bitiş',57502)# #getLang(1181,'Tarihi',58593)#</cfoutput></label>
						<div class="col col-12">
							<div class="col col-6">
								<div class="input-group">
									<cfsavecontent variable="txt1"><cf_get_lang dictionary_id="57782.Tarih Değerini Kontrol Ediniz">!</cfsavecontent>
									<cfinput type="text" name="search_date1" value="#dateformat(attributes.search_date1, dateformat_style)#" validate="#validate_style#" maxlength="10" message="#txt1#">
									<span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="search_date1"></span>
								</div>
							</div>
							<div class="col col-6">
								<div class="input-group">
									<cfinput type="text" name="search_date2" value="#dateformat(attributes.search_date2, dateformat_style)#" validate="#validate_style#" maxlength="10" message="#txt1#">
									<span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="search_date2"></span>
								</div>
							</div>
						</div>
					</div>
					<div class="form-group" id="exp_center">
						<label class="col col-12"><cfoutput>#getLang(1048,'Masraf Merkezi',58460)#</cfoutput></label>
						<div class="col col-12">
							<div class="input-group">
								<input type="hidden" name="expense_center_id" id="expense_center_id" value="<cfif len(attributes.expense_center_id)><cfoutput>#attributes.expense_center_id#</cfoutput></cfif>">
								<input type="text" name="expense_center_name" id="expense_center_name" onfocus="AutoComplete_Create('expense_center_name','EXPENSE','EXPENSE','get_expense_center','3','EXPENSE_ID','expense_center_id','search_cost','3','150');" autocomplete="off" value="<cfif len(attributes.expense_center_name)><cfoutput>#attributes.expense_center_name#</cfoutput></cfif>">
								<span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_expense_center&is_invoice=1&field_id=search_cost.expense_center_id'+'&field_name=search_cost.expense_center_name','list');"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="exp_item">
						<label class="col col-12"><cfoutput>#getLang(1139,'Gider Kalemi',58551)#</cfoutput></label>
						<div class="col col-12">
							<div class="input-group">
								<input type="hidden" name="expense_item_id" id="expense_item_id" value="<cfif len(attributes.expense_item_id)><cfoutput>#attributes.expense_item_id#</cfoutput></cfif>">
								<input type="text" name="expense_item_name" id="expense_item_name" onfocus="AutoComplete_Create('expense_item_name','EXPENSE_ITEM_NAME','EXPENSE_ITEM_NAME','get_expense_item','3','EXPENSE_ITEM_ID','expense_item_id','search_cost','3','150');" autocomplete="off" value="<cfif len(attributes.expense_item_name)><cfoutput>#attributes.expense_item_name#</cfoutput></cfif>">
								<span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_exp_item&is_invoice=1&field_id=search_cost.expense_item_id'+'&field_name=search_cost.expense_item_name','list');"></span>
							</div>
						</div>
					</div> 
				</div>
			</cf_box_search_detail>
		</cf_box>
	</cfform>
	<cf_box id="list_cost_" title="#box_title#" hide_table_column="1" uidrop="1" woc_setting = "#{ checkbox_name : 'print_expence_id', print_type : 230}#">
		<cf_grid_list sort="1">
			<thead>
				<tr>
					<cfif fusebox.circuit is 'health'>
						<th><cf_get_lang dictionary_id="57576.Çalışan"></th>
						<th><cf_get_lang dictionary_id="57880.Belge no"></th>
						<th><cf_get_lang dictionary_id="33203.Belge tarihi"></th>	
						<th><cf_get_lang dictionary_id="57519.Cari Hesap"></th>
						<th class="text-center" title="<cf_get_lang dictionary_id='34758.Anlaşmalı Kurumlar'><cf_get_lang dictionary_id='30111.Durumu'>"><cf_get_lang dictionary_id='33873.D'></th>
						<th><cf_get_lang dictionary_id="58923.Belge tutarı"></th>
						<th><cf_get_lang dictionary_id="33214.kdv tutar"></th>
						<th nowrap="nowrap"><cf_get_lang dictionary_id ='57489.Para Br'></th>
						<th><cf_get_lang dictionary_id="47944.Kayıt Yapan"></th>
						<th><cf_get_lang dictionary_id="57627.Kayıt Tarihi"></th>
						<th class="text-center"><cf_get_lang dictionary_id='58553.E'></th>
						<cfif session.ep.our_company_info.is_efatura>
							<th class="text-center"><i class="fa fa-etsy" title="<cf_get_lang dictionary_id="29872.E-Fatura">" alt="<cf_get_lang dictionary_id="29872.E-Fatura">"></i></th>
						</cfif>
						<cfif fusebox.circuit is 'health'>
							<!-- sil --><th width="20" class="header_icn_none"><a href="index.cfm?fuseaction=health.expenses&event=add"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th><!-- sil -->
						<cfelse>
							<!-- sil --><th width="20" class="header_icn_none"></th><!-- sil -->
						</cfif>
					<cfelse>
						<th width="20"><cf_get_lang dictionary_id='58577.no'></th>
						<th width="20"><cf_get_lang dictionary_id='29412.Seri'></th>
						<th><cf_get_lang dictionary_id='57880.Fatura No'></th>
						<th><cf_get_lang dictionary_id='57630.Tip'></th>
						<cfif xml_show_process_stage eq 1>
							<th><cf_get_lang dictionary_id='58859.Süreç'></th>
						</cfif> 
						<cfif (isdefined('attributes.listing_type') and attributes.listing_type eq 2)><!--- Eğer satır bazında listeleme yapılıyorsa --->
							<th><cf_get_lang dictionary_id ='57629.Açıklama'></th>
							<th><cf_get_lang dictionary_id='58235.Masraf/Gelir Merkezi'></th>
							<th><cf_get_lang dictionary_id='58551.Gider Kalemi'></th>
						</cfif>
						<th><cf_get_lang dictionary_id='57800.İşlem Tipi'></th>
						<th><cf_get_lang dictionary_id='57742.Tarih'></th>
						<th nowrap="nowrap"><cf_get_lang dictionary_id ='57519.Cari Hesap'></th>
						<cfif isdefined("x_paying_emp") and x_paying_emp eq 1>
							<th nowrap="nowrap">
								<cfif fusebox.circuit is 'health'>
									<cf_get_lang dictionary_id="57576.ÇAlışan">
								<cfelse>
									<cf_get_lang dictionary_id='51313.Ödeme Yapan'></cfif>
							</th>
						</cfif>
						<cfif x_branch_info>
							<th><cf_get_lang dictionary_id='57453.Şube'></th>
						</cfif>
						<cfif x_project_info>
							<th><cf_get_lang dictionary_id='57416.Proje'></th>
						</cfif>
						<cfif isdefined("x_is_record_emp") and x_is_record_emp eq 1><th nowrap><cf_get_lang dictionary_id='57899.Kaydeden'></th></cfif></th>
						<th><cf_get_lang dictionary_id='57492.Toplam'></th>
						<th nowrap="nowrap"><cf_get_lang dictionary_id ='57489.Para Br'></th>
						<th><cf_get_lang dictionary_id="51317.Toplam KDV"></th>
						<th nowrap="nowrap"><cf_get_lang dictionary_id ='57489.Para Br'></th>
						<cfif isdefined("x_total_otv") and x_total_otv eq 1>
							<th><cf_get_lang dictionary_id='57492.Toplam'> <cf_get_lang dictionary_id='58021.ÖTV'></th>
							<th nowrap="nowrap"><cf_get_lang dictionary_id ='57489.Para Br'></th>
						</cfif>
						<th><cf_get_lang dictionary_id='57644.Son Toplam'></th>
						<th nowrap="nowrap"><cf_get_lang dictionary_id ='57489.Para Br'></th>
						<cfif isdefined("x_transaction_currency") and x_transaction_currency eq 1>
							<th><cf_get_lang dictionary_id='57677.Döviz'><cf_get_lang dictionary_id='51316.KDVli Toplam'></th>
							<th><cf_get_lang dictionary_id='58121.İşlem Dövizi'></th>
						</cfif>
						<cfif attributes.iptal_invoice neq 0><th><cf_get_lang dictionary_id="58506.İptal"></th></cfif>
						<cfif session.ep.our_company_info.is_efatura>
						<th class="text-center"><i class="fa fa-etsy" title="<cf_get_lang dictionary_id="29872.E-Fatura">" alt="<cf_get_lang dictionary_id="29872.E-Fatura">"></i></th>
						</cfif>
						<!-- sil -->
						<cfif fusebox.circuit is 'health'>
							<th width="20" class="header_icn_none text-center"><a href="index.cfm?fuseaction=health.expenses&event=add"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
						<!--- <cfelse>
							<th width="20" class="header_icn_none text-center"><i class="fa fa-print" alt="<cf_get_lang dictionary_id='57474.Yazdır'>" title="<cf_get_lang dictionary_id='57474.Yazdır'>"></i></th> --->
						</cfif> 
						<cfif  get_expense.recordcount>
							<th width="20" class="text-center header_icn_none">
								<cfif  get_expense.recordcount eq 1><a href="javascript://" onclick="send_print_reset();"><i class="fa fa-print" alt="<cf_get_lang dictionary_id='57389.Print Sayisi Sifirla'>" title="<cf_get_lang dictionary_id='57389.Print Sayisi Sifirla'>"></i></a></cfif>
								<input type="checkbox" name="allSelectDemand" id="allSelectDemand" onclick="wrk_select_all('allSelectDemand','print_expence_id');">
							</th>
						</cfif> 
						<!-- sil -->
					</cfif>
				</tr>
			</thead> 
			<tbody> 
				<cfif (isdefined('attributes.listing_type') and attributes.listing_type eq 2)>
					<cfset colspan = 19>
					<cfset colspan_= 10>
				<cfelse>
					<cfset colspan = 17>
					<cfset colspan_= 7>
				</cfif>
				<cfif isdefined("x_transaction_currency") and x_transaction_currency eq 1>
					<cfset colspan += 2>
				</cfif>
				<cfif isdefined("x_total_otv") and x_total_otv eq 1>
					<cfset colspan += 2>
				</cfif>
				<cfif isdefined("x_paying_emp") and x_paying_emp eq 1>
					<cfset colspan += 1>
					<cfset colspan_+= 1>
				</cfif>
				<cfif isdefined("x_is_record_emp") and x_is_record_emp eq 1>
					<cfset colspan += 1>
					<cfset colspan_+= 1>
				</cfif>
				<cfif x_branch_info>
					<cfset colspan += 1>
					<cfset colspan_+= 1>
				</cfif>
				<cfif x_project_info>
					<cfset colspan += 1>
					<cfset colspan_+= 1>
				</cfif>
				<cfif get_expense.recordcount>
					<cfset employee_id_list=''>
					<cfset consumer_id_list = ''>
					<cfset process_cat_list = "">
					<cfset record_emp_id_list=''>
					<cfscript>
						toplam1 = 0;
						toplam2 = 0;
						toplam3 = 0;
						toplam4 = 0;
						toplam5 = 0;
						toplam6 = 0;
						toplam7 = 0;
						toplam8 = 0;
					</cfscript>
					<cfoutput query="get_expense" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<cfscript>
							toplam4 = toplam4 + total_amount;				
							toplam5 = toplam5 + kdv_total;
							toplam6 = toplam6 + total_amount_kdvli;
							if(len(otv_total))
							toplam7 = toplam7 + otv_total;
						</cfscript>
						<cfif len(ch_employee_id) and not listfind(employee_id_list,ch_employee_id)>
							<cfset employee_id_list=listappend(employee_id_list,ch_employee_id)>
						</cfif>
						<cfif len(record_emp) and not listfind(employee_id_list,record_emp)>
							<cfset employee_id_list=listappend(employee_id_list,record_emp)>
						</cfif>
						<cfif len(emp_id) and not listfind(employee_id_list,emp_id)>
							<cfset employee_id_list=listappend(employee_id_list,emp_id)>
						</cfif>
						<cfif len(ch_consumer_id) and not listfind(consumer_id_list,ch_consumer_id)>
							<cfset consumer_id_list=listappend(consumer_id_list,ch_consumer_id)>
						</cfif>
						<cfif len(process_cat) and not listfind(process_cat_list,process_cat)>
							<cfset process_cat_list=listappend(process_cat_list,process_cat)>
						</cfif>
						<cfif len(record_emp) and not listfind(record_emp_id_list,record_emp)>
							<cfset record_emp_id_list=listappend(record_emp_id_list,record_emp)>
						</cfif>
					</cfoutput>
					<cfif len(employee_id_list)>
						<cfset employee_id_list=listsort(employee_id_list,"numeric","ASC",",")>
						<cfquery name="get_emp_detail" datasource="#dsn#">
							SELECT EMPLOYEE_NAME, EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID IN (#employee_id_list#) ORDER BY EMPLOYEE_ID
						</cfquery>
					</cfif>
					<cfif len(consumer_id_list)>
						<cfset consumer_id_list=listsort(consumer_id_list,"numeric","ASC",",")>
						<cfquery name="get_cons_detail" datasource="#dsn#">
							SELECT CONSUMER_ID,CONSUMER_NAME,CONSUMER_SURNAME FROM CONSUMER WHERE CONSUMER_ID IN (#consumer_id_list#) ORDER BY CONSUMER_ID
						</cfquery>
					</cfif>
					<cfif len(process_cat_list)>
						<cfset process_cat_list=listsort(process_cat_list,"numeric","ASC",",")>
						<cfquery name="get_cat_name" datasource="#dsn3#">
							SELECT PROCESS_CAT_ID, PROCESS_CAT FROM SETUP_PROCESS_CAT WHERE PROCESS_CAT_ID IN (#process_cat_list#) ORDER BY PROCESS_CAT_ID
						</cfquery>
					</cfif>
					<cfif len(record_emp_id_list)>
						<cfset record_emp_id_list=listsort(record_emp_id_list,'numeric','asc',',')>
						<cfquery name="get_rec_emp" datasource="#DSN#">
							SELECT EMPLOYEE_ID,EMPLOYEE_NAME+' '+EMPLOYEE_SURNAME EMPLOYEE FROM EMPLOYEES WHERE EMPLOYEE_ID IN (<cfqueryparam list="yes" value="#record_emp_id_list#">) ORDER BY EMPLOYEE_ID
						</cfquery>
						<cfset record_emp_id_list = listsort(listdeleteduplicates(valuelist(get_rec_emp.employee_id,',')),'numeric','ASC',',')>
					</cfif>
						<cfoutput query="get_expense">
							<cfscript>
								toplam1 = toplam1 + total_amount;				
								toplam2 = toplam2 + kdv_total;
								toplam3 = toplam3 + total_amount_kdvli;
								if(len(otv_total))
								toplam8 = toplam8 + otv_total;
							</cfscript>
						</cfoutput>
						<cfoutput query="get_expense" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<cfif fusebox.circuit is 'health'>
							<tr>
								<td>#EMP_name#</td>
								<td><a href="#request.self#?fuseaction=health.expenses&event=upd&expense_id=#expense_id#" target="blank">#paper_no#</a></td>
								<td>#dateformat(expense_date,dateformat_style)#</td>
								<td><cfif len(ch_company_id)>
										<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#ch_company_id#','medium');">#fullname#</a>
									<cfelseif len(ch_consumer_id)>
										<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#ch_consumer_id#','medium');"> #consumer_name# #consumer_surname#</a>
									<cfelseif len(ch_employee_id)>
										<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#ch_employee_id#','medium');"> #get_emp_detail.employee_name[listfind(employee_id_list,ch_employee_id,',')]# #get_emp_detail.employee_surname[listfind(employee_id_list,ch_employee_id,',')]#</a>
									</cfif></td>
								<td class="text-center">
									<label
									<cfif len(ch_company_id)>
										<cfif is_civil_company eq 1> title="<cf_get_lang dictionary_id='41536.Kamu'>"><cf_get_lang dictionary_id='64640.K'><cfelse> title="<cf_get_lang dictionary_id='41542.Anlaşmalı'>"><cf_get_lang dictionary_id='29684.A'></cfif>
									<cfelseif len(ch_consumer_id)>
										title="<cf_get_lang dictionary_id='41542.Anlaşmalı'>"><cf_get_lang dictionary_id='29684.A'>
									<cfelseif len(ch_employee_id)>
										title="<cf_get_lang dictionary_id='41541.Harici'>"><cf_get_lang dictionary_id='64641.H'>
									</cfif>
									</label>
								</td>
								<td class="text-right">
									<input type="hidden" name="totalAmount#currentrow#" id="totalAmount#currentrow#" value="#total_amount#">
									#TLFormat(total_amount)#
								</td>
								<td class="text-right">
									<input type="hidden" name="kdvTotal#currentrow#" id="kdvTotal#currentrow#" value="#kdv_total#">
									#TLFormat(kdv_total)#
								</td>
								<td class="text-center">#session.ep.money#</td>
								<td><a href="javascript://" onclick="nModal({head: 'Profil',page:'#request.self#?fuseaction=objects.popup_emp_det&emp_id=#RECORD_EMP#'});">#get_emp_info(RECORD_EMP,0,0)#</a></td>
								<td>#dateformat(RECORD_DATE,dateformat_style)#</td>
								<td>
									<cfif EXPENSE_ITEM_PLANS_ID neq "">
										<a href="#request.self#?fuseaction=hr.health_expense_approve&event=upd&health_id=#EXPENSE_ITEM_PLANS_ID#&expense_id=#expense_id#" target="_blank"><i class="fa fa-link" style="color:green !important;"  title="<cf_get_lang dictionary_id='36951.Sağlık Harcaması Detay'>"></i></a>
									<cfelse>
										<a href="javascript://"><i class="fa fa-link" style="color:red !important;cursor:default !important;" title="<cf_get_lang dictionary_id='33077.Detaylar'>"></i></a>
									</cfif>
								</td>
								<cfif session.ep.our_company_info.is_efatura>
									<td class="header_icn_none">
										<cfif ((len(use_efatura) and use_efatura and len(invoice_type_code) and action_type eq 121) or einvoice_control gt 0) and not (isdefined("earchive_control") and earchive_control gt 0)>
											<cfif listfind('50,60,80,110',get_expense.status_code) and sender_type eq 5>
												<a title="#profile_id# <cf_get_lang dictionary_id='61159.Tekrar Gönderilecek'>"><img src="images/icons/efatura_purple.gif" align="absmiddle"/></a>
											<cfelseif get_expense.status_code eq 40 and sender_type eq 7>
												<a title="#profile_id# <cf_get_lang dictionary_id='58699.Onaylandı'>"><img src="images/icons/efatura_purple.gif" /></a>
											<cfelseif status eq 1>
												<a title="<cf_get_lang dictionary_id='61160.E-Fatura Kesildi'>"><img src="images/icons/efatura_green.gif" /></a>
											<cfelseif len(efatura_count) and efatura_count gt 0>
												<a title="<cf_get_lang dictionary_id='61160.E-Fatura Kesildi'>"><img src="images/icons/efatura_green.gif" /></a>
											<cfelseif status eq 0>
												<a title="<cf_get_lang dictionary_id='29537.Red'>"><img src="images/icons/efatura_red.gif" /></a>
											<cfelseif (einvoice_count gt 0 or einvoice_control gt 0) and len(path)>
												<a title="<cf_get_lang dictionary_id='57615.Onay Bekliyor'>"><img src="images/icons/efatura_yellow.gif" /></a>
											<cfelseif datediff('d',createodbcdatetime('#year(session.ep.our_company_info.efatura_date)#-#month(session.ep.our_company_info.efatura_date)#-#day(session.ep.our_company_info.efatura_date)#'),expense_date) gt 0>
												<a title="<cf_get_lang dictionary_id='40103.Gönderilmedi'>"><img title="<cf_get_lang dictionary_id='40103.Gönderilmedi'>" alt="<cf_get_lang dictionary_id='40103.Gönderilmedi'>" src="images/icons/efatura_blue.gif" /></a>
											</cfif>
										<cfelseif len(efatura_count) and efatura_count and action_type eq 120>
											<a title="<cf_get_lang dictionary_id='61160.E-Fatura Kesildi'>"><img src="images/icons/efatura_green.gif" /></a>
										<cfelseif session.ep.our_company_info.is_earchive>
											<cfif len(invoice_type_code)>
												<cfif is_cancel eq 1>
													<a title="<cf_get_lang dictionary_id='58506.İptal'>"><img src="images/icons/earchive_red.gif" /></a>
												<cfelseif status_einvoice eq 1>
													<a title="<cf_get_lang dictionary_id='61158.E-Arşiv gönderildi'>"><img src="images/icons/earchive_green.gif" /></a>
												<cfelseif status_einvoice eq 0>
													<a title="<cf_get_lang dictionary_id='57541.Hata'>"><img src="images/icons/earchive_purple.gif" /></a>
												<cfelseif len(earchive_id)>
													<a title="<cf_get_lang dictionary_id='57615.Onay Bekliyor'>"><img src="images/icons/earchive_yellow.gif" /></a>
												<cfelse>
													<a title="<cf_get_lang dictionary_id='40103.Gönderilmedi'>"><img title="Gönderilmedi" alt="Gönderilmedi" src="images/icons/earchive_blue.gif" /></a>
												</cfif>
											</cfif>
										</cfif>
									</td>
								</cfif>
								<td><a href="#request.self#?fuseaction=health.expenses&event=upd&expense_id=#expense_id#" target="blank"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td>
							</tr>
							<tr style="display:none">
								<td colspan="18">
									<div id="tr_#currentrow#" class = "open_div"></div>
								</td>
							</tr>
						<cfelse> 
							<tr>
								<td>#currentrow#</td>
								<td><cfif get_expense.action_type eq 120>
										<a href="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_add_expense_cost&event=upd&expense_id=#expense_id#">&nbsp;#serial_number#</a>
									<cfelseif get_expense.action_type eq 122>
										<a href="#request.self#?fuseaction=assetcare.form_add_expense_cost&event=upd&expense_id=#expense_id#">&nbsp;#serial_number#</a>
									<cfelseif get_expense.action_type eq 1201>
										<a href="#request.self#?fuseaction=health.expenses&event=upd&expense_id=#expense_id#">&nbsp;#serial_number#</a>
									<cfelse>
										<a href="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.add_income_cost&event=upd&expense_id=#expense_id#">&nbsp;#serial_number#</a>
									</cfif>
								</td>
								<td><cfif get_expense.action_type eq 120>
										<a href="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_add_expense_cost&event=upd&expense_id=#expense_id#">&nbsp;#serial_no#</a>
									<cfelseif get_expense.action_type eq 122>
										<a href="#request.self#?fuseaction=assetcare.form_add_expense_cost&event=upd&expense_id=#expense_id#">&nbsp;#serial_no#</a>
									<cfelseif get_expense.action_type eq 1201>
										<a href="#request.self#?fuseaction=health.expenses&event=upd&expense_id=#expense_id#">&nbsp;#serial_number#</a>
									<cfelse>
										<a href="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.add_income_cost&event=upd&expense_id=#expense_id#">&nbsp;#serial_no#</a>
									</cfif>
								</td>
								<td><cfif get_expense.action_type eq 120>
										<a href="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_add_expense_cost&event=upd&expense_id=#expense_id#"><cf_get_lang dictionary_id='58064.Masraf Fişi'></a>
									<cfelseif get_expense.action_type eq 122>
										<a href="#request.self#?fuseaction=assetcare.form_add_expense_cost&event=upd&expense_id=#expense_id#"><cf_get_lang dictionary_id='29644.Bakım Fişi'></a>
									<cfelseif get_expense.action_type eq 1201>
										<a href="#request.self#?fuseaction=health.expenses&event=upd&expense_id=#expense_id#">&nbsp;#serial_number#</a>
									<cfelse>
										<a href="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.add_income_cost&event=upd&expense_id=#expense_id#"><cf_get_lang dictionary_id='58065.Gelir Fişi'></a>
									</cfif>
								</td>
								<cfif xml_show_process_stage eq 1>
									<td>#PSTAGE#</td>
								</cfif> 
								<cfif (isdefined('attributes.listing_type') and attributes.listing_type eq 2)><!--- Eğer satır bazında listeleme yapılıyorsa --->
									<td>#DETAIL#</td>
									<td>#EXPENSE#</td>
									<td>#EXPENSE_ITEM_NAME#</td>
								</cfif>
								<td><cfif len(process_cat)>
										#get_cat_name.process_cat[listfind(process_cat_list,process_cat,',')]#
									</cfif>
								</td>
								<td>#dateformat(expense_date,dateformat_style)#</td>
								<td><cfif len(ch_company_id)>
										<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#ch_company_id#','medium');">#fullname#</a>
									<cfelseif len(ch_consumer_id)>
										<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#ch_consumer_id#','medium');"> #consumer_name# #consumer_surname#</a>
									<cfelseif len(ch_employee_id)>
										<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#ch_employee_id#','medium');"> #get_emp_detail.employee_name[listfind(employee_id_list,ch_employee_id,',')]# #get_emp_detail.employee_surname[listfind(employee_id_list,ch_employee_id,',')]#</a>
									</cfif>
								</td>
								<cfif isDefined("x_paying_emp") and x_paying_emp eq 1>
									<td>
										<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#emp_id#','medium');"> 
											#get_emp_detail.employee_name[listfind(employee_id_list,emp_id,',')]#&nbsp; #get_emp_detail.employee_surname[listfind(employee_id_list,emp_id,',')]#
										</a>
									</td>
								</cfif>
								<!---Şube ve Proje Sütunları --->
								<cfif x_branch_info>
									<td>#get_expense.BRANCH#</td>
								</cfif>
								<cfif x_project_info>
									<td>#get_expense.PROJECT#</td>
								</cfif>
								<cfif isdefined("x_is_record_emp") and x_is_record_emp eq 1>
									<td><cfif len(record_emp)><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#record_emp#','medium');">#get_rec_emp.employee[listfind(record_emp_id_list,record_emp,',')]#</a></cfif></td>
								</cfif>
								<td class="text-right">#TLFormat(total_amount)#</td>
								<td>&nbsp;#session.ep.money#</td>
								<td class="text-right">#TLFormat(kdv_total)#</td>
								<td>&nbsp;#session.ep.money#</td>
								<cfif isDefined("x_total_otv") and x_total_otv eq 1>
									<td class="text-right"><cfif len(otv_total)>#TLFormat(otv_total)#<cfelse>#TLFormat(0)#</cfif></td>
									<td>&nbsp;#session.ep.money#</td>
								</cfif>
								<td class="text-right">#TLFormat(total_amount_kdvli)# </td>
								<td>&nbsp;#session.ep.money#</td>
								<cfif isdefined("x_transaction_currency") and x_transaction_currency eq 1>
										<td>#TLFormat(other_money_net_total)#</td>
									<cfif (isdefined('attributes.listing_type') and attributes.listing_type eq 2)><!--- Eğer satır bazında listeleme yapılıyorsa --->
										<td>#money_currency_id#</td>
									<cfelse>
										<td>#other_money#</td>
									</cfif>
								</cfif>
								<cfif attributes.iptal_invoice neq 0>
									<cfif is_iptal eq 1><td class="text-center"><img src="/images/caution_small.gif" title="<cf_get_lang dictionary_id ='58506.İptal'>"></td><cfelse><td></td></cfif>
								</cfif>
								<!-- sil -->
								<cfif session.ep.our_company_info.is_efatura>
									<td class="header_icn_none text-center">
										<cfif ((len(use_efatura) and use_efatura and len(invoice_type_code) and action_type eq 121) or einvoice_control gt 0) and not (isdefined("earchive_control") and earchive_control gt 0)>
											<cfif listfind('50,60,80,110',get_expense.status_code) and sender_type eq 5>
												<a title="#profile_id# <cf_get_lang dictionary_id='61159.Tekrar Gönderilecek'>"><img src="images/icons/efatura_purple.gif" align="absmiddle"/></a>
											<cfelseif get_expense.status_code eq 40 and sender_type eq 7>
												<a title="#profile_id# <cf_get_lang dictionary_id='58699.Onaylandı'>"><img src="images/icons/efatura_purple.gif" /></a>
											<cfelseif status eq 1>
												<a title="<cf_get_lang dictionary_id='61160.E-Fatura Kesildi'>"><img src="images/icons/efatura_green.gif" /></a>
											<cfelseif len(efatura_count) and efatura_count gt 0>
												<a title="<cf_get_lang dictionary_id='61160.E-Fatura Kesildi'>"><img src="images/icons/efatura_green.gif" /></a>
											<cfelseif status eq 0>
												<a title="<cf_get_lang dictionary_id='29537.Red'>"><img src="images/icons/efatura_red.gif" /></a>
											<cfelseif (einvoice_count gt 0 or einvoice_control gt 0) and len(path)>
												<a title="<cf_get_lang dictionary_id='57615.Onay Bekliyor'>"><img src="images/icons/efatura_yellow.gif" /></a>
											<cfelseif datediff('d',createodbcdatetime('#year(session.ep.our_company_info.efatura_date)#-#month(session.ep.our_company_info.efatura_date)#-#day(session.ep.our_company_info.efatura_date)#'),expense_date) gt 0>
												<a title="<cf_get_lang dictionary_id='40103.Gönderilmedi'>"><img title="<cf_get_lang dictionary_id='40103.Gönderilmedi'>" alt="<cf_get_lang dictionary_id='40103.Gönderilmedi'>" src="images/icons/efatura_blue.gif" /></a>
											</cfif>
										<cfelseif len(efatura_count) and efatura_count and action_type eq 120>
											<a title="<cf_get_lang dictionary_id='61160.E-Fatura Kesildi'>"><img src="images/icons/efatura_green.gif" /></a>
										<cfelseif session.ep.our_company_info.is_earchive>
											<cfif len(invoice_type_code)>
												<cfif is_cancel eq 1>
													<a title="<cf_get_lang dictionary_id='58506.İptal'>"><img src="images/icons/earchive_red.gif" /></a>
												<cfelseif status_einvoice eq 1>
													<a title="<cf_get_lang dictionary_id='61158.E-Arşiv gönderildi'>"><img src="images/icons/earchive_green.gif" /></a>
												<cfelseif status_einvoice eq 0>
													<a title="<cf_get_lang dictionary_id='57541.Hata'>"><img src="images/icons/earchive_purple.gif" /></a>
												<cfelseif len(earchive_id)>
													<a title="<cf_get_lang dictionary_id='57615.Onay Bekliyor'>"><img src="images/icons/earchive_yellow.gif" /></a>
												<cfelse>
													<a title="<cf_get_lang dictionary_id='40103.Gönderilmedi'>"><img title="<cf_get_lang dictionary_id='40103.Gönderilmedi'>" alt="<cf_get_lang dictionary_id='40103.Gönderilmedi'>" src="images/icons/earchive_blue.gif" /></a>
												</cfif>
											</cfif>
										</cfif>
									</td>
								</cfif>
								<td class="text-center"><input type="checkbox" name="print_expence_id" id="print_expence_id"  value="#expense_id#"></td>
								<!--- 	<td width="20"><a href="javascript://" target="" onclick="windowopen('#request.self#?fuseaction=objects.popup_print_files&iid=#expense_id#&print_type=230','print_page','workcube_print');"><i class="fa fa-print" alt="<cf_get_lang dictionary_id='57474.Yazdır'>" title="<cf_get_lang dictionary_id='57474.Yazdır'>"></i></a></td> --->
								
								<!-- sil -->
							</tr>
						</cfif>
						</cfoutput>
						</tbody>
						<cfif fusebox.circuit neq 'health'>
						<tfoot>
						<tr>
							<td colspan="<cfoutput>#colspan_#</cfoutput>" class="txtbold" class="text-right" ><cf_get_lang dictionary_id='51312.Sayfa Toplam'></td>
							<td class="txtbold" class="text-right"><cfoutput>#TLFormat(toplam4)#</cfoutput></td>
							<td class="txtbold">&nbsp;<cfoutput>#session.ep.money#</cfoutput></td>
							<td class="txtbold" class="text-right"><cfoutput>#TLFormat(toplam5)#</cfoutput></td>
							<td class="txtbold">&nbsp;<cfoutput>#session.ep.money#</cfoutput></td>
							<cfif isDefined("x_total_otv") and x_total_otv eq 1>
								<td class="txtbold" class="text-right"><cfoutput>#TLFormat(toplam7)#</cfoutput></td>
								<td class="txtbold">&nbsp;<cfoutput>#session.ep.money#</cfoutput></td>
							</cfif>
							<td class="txtbold" class="text-right"><cfoutput>#TLFormat(toplam6)#</cfoutput></td>
							<td class="txtbold" colspan="5">&nbsp;<cfoutput>#session.ep.money#</cfoutput></td>
							
							
							<!-- sil -->
							<!-- sil -->
						</tr>
						<tr>
							<td colspan="<cfoutput>#colspan_#</cfoutput>" class="txtbold" class="text-right"> <cf_get_lang dictionary_id='57680.GenelToplam'></td>
							<td class="txtbold" class="text-right"><cfoutput>#TLFormat(toplam1)#</cfoutput></td>
							<td class="txtbold">&nbsp;<cfoutput>#session.ep.money#</cfoutput></td>
							<td class="txtbold" class="text-right"><cfoutput>#TLFormat(toplam2)#</cfoutput></td>
							<td class="txtbold">&nbsp;<cfoutput>#session.ep.money#</cfoutput></td>
							<cfif isDefined("x_total_otv") and x_total_otv eq 1>
								<td class="txtbold" class="text-right"><cfoutput>#TLFormat(toplam8)#</cfoutput></td>
								<td class="txtbold">&nbsp;<cfoutput>#session.ep.money#</cfoutput></td>
							</cfif>
							<td class="txtbold" class="text-right"><cfoutput>#TLFormat(toplam3)#</cfoutput></td>
							<td class="txtbold" colspan="5">&nbsp;<cfoutput>#session.ep.money#</cfoutput></td>
							
							<!-- sil -->
							<!-- sil -->
						</tr>
						</tfoot>
						</cfif>
				<cfelse>
					<tr>
						<td colspan="<cfoutput>#colspan#</cfoutput>"><cfif len(attributes.form_submitted)><cf_get_lang dictionary_id='57484.Kayıt Yok'>!<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'>!</cfif></td>
					</tr>
				</cfif>
		</cf_grid_list>
		<cfscript>
			url_str = "" ;
			if (len(attributes.keyword)) url_str = "#url_str#&keyword=#attributes.keyword#";
			if (len(attributes.search_date1)) url_str = "#url_str#&search_date1=#dateformat(attributes.search_date1,dateformat_style)#";
			if (len(attributes.search_date2)) url_str = "#url_str#&search_date2=#dateformat(attributes.search_date2,dateformat_style)#";
			if (len(attributes.record_date1)) url_str = "#url_str#&record_date1=#dateformat(attributes.record_date1,dateformat_style)#";
			if (len(attributes.record_date2)) url_str = "#url_str#&record_date2=#dateformat(attributes.record_date2,dateformat_style)#";
			if (len(attributes.employee_id)) url_str = "#url_str#&employee_id=#attributes.employee_id#";
			if (len(attributes.expense_action_type)) url_str = "#url_str#&expense_action_type=#attributes.expense_action_type#";
			if (len(attributes.expense_employee)) url_str = "#url_str#&expense_employee=#attributes.expense_employee#";
			if (len(attributes.form_submitted)) url_str = "#url_str#&form_submitted=#attributes.form_submitted#";
			if (len(attributes.date_filter)) url_str = "#url_str#&date_filter=#attributes.date_filter#";
			if (len(attributes.is_expense_item_plans_requests)) url_str = "#url_str#&is_expense_item_plans_requests=#attributes.is_expense_item_plans_requests#";
			if (len(attributes.reference_no)) url_str = "#url_str#&reference_no=#attributes.reference_no#";
			if (len(attributes.ch_company_id)) url_str = "#url_str#&ch_company_id=#attributes.ch_company_id#";
			if (len(attributes.ch_consumer_id)) url_str = "#url_str#&ch_consumer_id=#attributes.ch_consumer_id#";
			if (len(attributes.ch_employee_id)) url_str = "#url_str#&ch_employee_id=#attributes.ch_employee_id#";
			if (len(attributes.ch_company)) url_str = "#url_str#&ch_company=#attributes.ch_company#";
			if (len(attributes.document_type)) url_str = "#url_str#&document_type=#attributes.document_type#";
			if (len(attributes.record_emp_id)) url_str = "#url_str#&record_emp_id=#attributes.record_emp_id#";
			if (len(attributes.record_emp_name)) url_str = "#url_str#&record_emp_name=#attributes.record_emp_name#";
			if (len(attributes.listing_type)) url_str = "#url_str#&listing_type=#attributes.listing_type#";
			if (len(attributes.process_cat_type)) url_str = "#url_str#&process_cat_type=#attributes.process_cat_type#";
			if (len(attributes.expense_center_id)) url_str = "#url_str#&expense_center_id=#attributes.expense_center_id#";
			if (len(attributes.expense_item_id)) url_str = "#url_str#&expense_item_id=#attributes.expense_item_id#";
			if (len(attributes.expense_center_name)) url_str = "#url_str#&expense_center_name=#attributes.expense_center_name#";
			if (len(attributes.expense_item_name)) url_str = "#url_str#&expense_item_name=#attributes.expense_item_name#";
			if (len(attributes.member_type)) url_str = "#url_str#&member_type=#attributes.member_type#";
			if (len(attributes.branch_id)) url_str = "#url_str#&branch_id=#attributes.branch_id#";
			if (len(attributes.process_stage)) url_str = "#url_str#&process_stage=#attributes.process_stage#";
			if (len(attributes.project_id) and len(attributes.project_head)) url_str = "#url_str#&project_id=#attributes.project_id#&project_head=#attributes.project_head#";
			if (isdefined("attributes.efatura_type") and len(attributes.efatura_type)) url_str = "#url_str#&efatura_type=#attributes.efatura_type#";
			if (isdefined("attributes.earchive_type") and len(attributes.earchive_type)) url_str = "#url_str#&earchive_type=#attributes.earchive_type#";
		</cfscript>
		<cf_paging 
			page="#attributes.page#"
			maxrows="#attributes.maxrows#"
			totalrecords="#attributes.totalrecords#"
			startrow="#attributes.startrow#"
			adres="#new_page#&#url_str#">
	</cf_box>
</div>
<script type="text/javascript">
	window.onload = show_center_item;
	document.getElementById('keyword').focus();
	function getRelatives(emp_id,count){
		is_relative = $("#is_relative"+count).val();
		if(emp_id=='')
		{
			alert('<cf_get_lang dictionary_id="46197.Çalışan seçiniz">');
			return false;
		}
		if(is_relative == 2)
		{
			var listparam = emp_id;
			 $('#relative_id'+count).show();
			var getRelatives = wrk_safe_query('get_employees_relatives','dsn',0,listparam);
			 $('#relative_id'+count)
				.find('option')
				.remove()
				.end()
			;
			for(i = 0;i<getRelatives.recordcount;++i)
            {
                $('#relative_id'+count).append(new Option(getRelatives.FULLNAME[i], getRelatives.RELATIVE_ID[i])); 
			}
		}		
	}
	function show_center_item()
	{
		if(document.getElementById('listing_type').value==2)
		{
			document.getElementById('exp_center').style.display="";
			document.getElementById('exp_item').style.display="";
		}	
		else
		{
			document.getElementById('exp_center').style.display="none";
			document.getElementById('exp_item').style.display="none";
		}
	}
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">