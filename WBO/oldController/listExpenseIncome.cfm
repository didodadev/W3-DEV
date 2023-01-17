<cf_get_lang_set module_name="cost">
<cf_xml_page_edit fuseact="cost.list_expense_income">
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
<cfparam name="attributes.reference_no" default="">
<cfparam name="attributes.expense_action_type" default="">
<cfparam name="attributes.listing_type" default="">
<cfparam name="attributes.project_id" default="">
<cfparam name="attributes.project_head" default="">
<cfparam name="attributes.process_cat_type" default="">
<cfparam name="attributes.member_type" default="">
<cfparam name="attributes.efatura_type" default="">
<cfparam name="attributes.earchive_type" default="">
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
	SELECT PROCESS_CAT_ID, PROCESS_CAT, PROCESS_TYPE FROM SETUP_PROCESS_CAT WHERE PROCESS_TYPE IN (120,121,122) ORDER BY PROCESS_TYPE, PROCESS_CAT
</cfquery>
<cfquery name="get_branchs" datasource="#dsn#">
	SELECT 
		BRANCH_ID,BRANCH_NAME 
	FROM 
		BRANCH 
	WHERE
		BRANCH_STATUS = 1
		<cfif listgetat(attributes.fuseaction,1,'.') is 'store'>
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
			SPC.INVOICE_TYPE_CODE,
			EXPENSE_ITEM_PLANS.SERIAL_NUMBER,
			EXPENSE_ITEM_PLANS.SERIAL_NO,
			EXPENSE_ITEM_PLANS.PAPER_NO,
			EXPENSE_ITEM_PLANS.RECORD_EMP,
			EXPENSE_ITEM_PLANS.ACTION_TYPE,
			EXPENSE_ITEM_PLANS.PROCESS_CAT,
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
            <cfelse>
                EXPENSE_ITEM_PLANS.OTHER_MONEY_NET_TOTAL,
                EXPENSE_ITEM_PLANS.TOTAL_AMOUNT,
                EXPENSE_ITEM_PLANS.TOTAL_AMOUNT_KDVLI,
                EXPENSE_ITEM_PLANS.KDV_TOTAL,
                EXPENSE_ITEM_PLANS.OTV_TOTAL,
                EXPENSE_ITEM_PLANS.OTHER_MONEY,
            </cfif>
			EXPENSE_ITEM_PLANS.RECORD_DATE,
			EXPENSE_ITEM_PLANS.EMP_ID,
			EXPENSE_ITEM_PLANS.EXPENSE_DATE,
			EXPENSE_ITEM_PLANS.PAPER_TYPE,
			EXPENSE_ITEM_PLANS.EXPENSE_ID,
			EXPENSE_ITEM_PLANS.ACTION_TYPE,
			EXPENSE_ITEM_PLANS.CH_COMPANY_ID,
			EXPENSE_ITEM_PLANS.CH_CONSUMER_ID,
			EXPENSE_ITEM_PLANS.CH_EMPLOYEE_ID,
            COMPANY.FULLNAME,
            CONSUMER.CONSUMER_NAME,
            CONSUMER.CONSUMER_SURNAME,
            EMPLOYEES.EMPLOYEE_NAME,
            EMPLOYEES.EMPLOYEE_SURNAME,
			(SELECT COUNT(RECEIVING_DETAIL_ID) FROM EINVOICE_RECEIVING_DETAIL ESD WHERE ESD.EXPENSE_ID = EXPENSE_ITEM_PLANS.EXPENSE_ID) EFATURA_COUNT,
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
                ,(SELECT COUNT(SENDING_DETAIL_ID) FROM EINVOICE_SENDING_DETAIL ESD WHERE ESD.ACTION_ID = EXPENSE_ITEM_PLANS.EXPENSE_ID AND ESD.ACTION_TYPE = 'EXPENSE_ITEM_PLANS') EINVOICE_COUNT
            </cfif>
            <cfif (session.ep.our_company_info.is_earchive)>
                ,ERA.PATH PATH_EINVOICE
                ,ERA.STATUS STATUS_EINVOICE
                ,ERA.EARCHIVE_ID
                ,ISNULL(ERA.IS_CANCEL,0) IS_CANCEL
                ,(SELECT COUNT(SENDING_DETAIL_ID) FROM EARCHIVE_SENDING_DETAIL ESD WHERE ESD.ACTION_ID = EXPENSE_ITEM_PLANS.EXPENSE_ID AND ESD.ACTION_TYPE = 'EXPENSE_ITEM_PLANS') EARCHIVE_COUNT
            </cfif>
            ,BR.BRANCH_NAME BRANCH
			,PR.PROJECT_HEAD PROJECT
		FROM
			EXPENSE_ITEM_PLANS
            	LEFT JOIN #dsn_alias#.COMPANY ON COMPANY.COMPANY_ID = EXPENSE_ITEM_PLANS.CH_COMPANY_ID <cfif len(attributes.efatura_type) and attributes.efatura_type eq 1>AND COMPANY.USE_EFATURA = 1 AND COMPANY.EFATURA_DATE <= EXPENSE_ITEM_PLANS.EXPENSE_DATE</cfif>
          	<cfif len(attributes.earchive_type)> 
				LEFT JOIN #dsn_alias#.COMPANY C2 ON C2.COMPANY_ID = EXPENSE_ITEM_PLANS.CH_COMPANY_ID AND COMPANY.USE_EFATURA = 1 AND COMPANY.EFATURA_DATE <= EXPENSE_ITEM_PLANS.EXPENSE_DATE
			</cfif>
                LEFT JOIN #dsn_alias#.CONSUMER ON CONSUMER.CONSUMER_ID = EXPENSE_ITEM_PLANS.CH_CONSUMER_ID <cfif len(attributes.efatura_type) and attributes.efatura_type eq 1>AND CONSUMER.USE_EFATURA = 1 AND CONSUMER.EFATURA_DATE <= EXPENSE_ITEM_PLANS.EXPENSE_DATE</cfif>
                LEFT JOIN #dsn_alias#.EMPLOYEES ON EMPLOYEES.EMPLOYEE_ID = EXPENSE_ITEM_PLANS.CH_EMPLOYEE_ID
                LEFT JOIN #dsn_alias#.BRANCH BR ON EXPENSE_ITEM_PLANS.BRANCH_ID=BR.BRANCH_ID
				LEFT JOIN #dsn_alias#.PRO_PROJECTS PR ON EXPENSE_ITEM_PLANS.PROJECT_ID=PR.PROJECT_ID
			 <cfif session.ep.our_company_info.is_efatura>
                LEFT JOIN EINVOICE_RELATION ER ON ER.ACTION_ID = EXPENSE_ITEM_PLANS.EXPENSE_ID AND ER.ACTION_TYPE = 'EXPENSE_ITEM_PLANS'
                LEFT JOIN EINVOICE_RECEIVING_DETAIL ERD ON ERD.EXPENSE_ID = EXPENSE_ITEM_PLANS.EXPENSE_ID
            </cfif>
            <cfif session.ep.our_company_info.is_earchive>
                LEFT JOIN EARCHIVE_RELATION ERA ON ERA.ACTION_ID = EXPENSE_ITEM_PLANS.EXPENSE_ID AND ERA.ACTION_TYPE = 'EXPENSE_ITEM_PLANS'
            </cfif>                 
			<cfif (isdefined('attributes.listing_type') and attributes.listing_type eq 2)><!--- Eğer satır bazında listeleme yapılıyorsa --->
                ,EXPENSE_ITEMS_ROWS
                ,EXPENSE_ITEMS
                ,EXPENSE_CENTER
            </cfif>
			,#dsn3_alias#.SETUP_PROCESS_CAT SPC
		WHERE
			EXPENSE_ITEM_PLANS.EXPENSE_ID IS NOT NULL
			AND SPC.PROCESS_CAT_ID = EXPENSE_ITEM_PLANS.PROCESS_CAT
			<cfif (isdefined('attributes.listing_type') and attributes.listing_type eq 2)><!--- Eğer satır bazında listeleme yapılıyorsa --->
				AND EXPENSE_ITEM_PLANS.EXPENSE_ID = EXPENSE_ITEMS_ROWS.EXPENSE_ID
				AND EXPENSE_ITEMS.EXPENSE_ITEM_ID = EXPENSE_ITEMS_ROWS.EXPENSE_ITEM_ID
				AND EXPENSE_CENTER.EXPENSE_ID = EXPENSE_ITEMS_ROWS.EXPENSE_CENTER_ID
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
			<cfelseif listgetat(attributes.fuseaction,1,'.') is 'store'>
				AND EXPENSE_ITEM_PLANS.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(session.ep.user_location,2,'-')#">
			</cfif>
			<cfif isdefined("attributes.record_date1") and isdate(attributes.record_date1)>AND EXPENSE_ITEM_PLANS.RECORD_DATE >= #attributes.record_date1#</cfif>
			<cfif isdefined("attributes.record_date2") and isdate(attributes.record_date2)>AND EXPENSE_ITEM_PLANS.RECORD_DATE < #dateadd("d",1,attributes.record_date2)#</cfif>
			<cfif isdefined("attributes.acc_type_id") and len(attributes.acc_type_id)>
				AND EXPENSE_ITEM_PLANS.ACC_TYPE_ID = #attributes.acc_type_id#
			</cfif>
			<cfif len(attributes.efatura_type) and attributes.efatura_type neq 5>
            	AND ((COMPANY.COMPANY_ID IS NOT NULL OR CONSUMER.CONSUMER_ID IS NOT NULL) AND (SPC.INVOICE_TYPE_CODE IS NOT NULL OR EXPENSE_ITEM_PLANS.ACTION_TYPE = 120))
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
                    AND (ER.STATUS = 1 OR ER.PROFILE_ID = 'TEMELFATURA')
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
						AND (ER.STATUS IS NULL AND ER.PROFILE_ID <> 'TEMELFATURA')
					)
                </cfif>
            </cfif>
            <cfif attributes.efatura_type eq 5>
            	AND COMPANY.COMPANY_ID IS NULL AND CONSUMER.CONSUMER_ID IS NULL
            </cfif>
            <cfif len(attributes.earchive_type)>
            	AND SPC.INVOICE_TYPE_CODE IS NOT NULL
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
						)
					)
                <cfelseif attributes.earchive_type eq 3>
                	AND 
					(
						(
							(SELECT COUNT(SENDING_DETAIL_ID) FROM EARCHIVE_SENDING_DETAIL ESD WHERE ESD.ACTION_ID = EXPENSE_ITEM_PLANS.EXPENSE_ID AND ESD.ACTION_TYPE = 'EXPENSE_ITEM_PLANS' AND STATUS_CODE = 1) > 0 
							AND ERA.STATUS_CODE = 999
						)
					)
               </cfif>
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
<cfif listgetat(attributes.fuseaction,1,'.') is 'store'>
	<cfset new_page = 'store.list_expense_income'>
<cfelse>
	<cfset new_page = 'cost.list_expense_income'>
</cfif>
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.maxrows" default="#session.ep.maxrows#">
<cfparam name="attributes.totalrecords" default="#get_expense.recordcount#">
<cfset attributes.startrow = ((attributes.page-1)*attributes.maxrows) + 1>
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
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'cost.list_expense_income';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'cost/display/list_expense_income.cfm';
</cfscript>
