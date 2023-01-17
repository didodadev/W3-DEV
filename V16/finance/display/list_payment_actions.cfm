<cf_get_lang_set module_name="finance">
<cf_xml_page_edit fuseact="finance.list_payment_actions">
<cfparam name="attributes.member_name" default="">
<cfparam name="attributes.member_name" default="">
<cfparam name="attributes.bank_order_status" default="">
<cfparam name="attributes.bank_account_status" default="">
<cfparam name="attributes.act_type" default="">
<cfparam name="attributes.paper_no" default="">
<cfparam name="attributes.member_id" default="">
<cfparam name="attributes.consumer_id" default="">
<cfparam name="attributes.employee_id" default="">
<cfparam name="attributes.acc_type_id" default="">
<cfparam name="attributes.other_money" default="">
<cfif not isdefined("attributes.act_type")>
                <cfset attributes.act_type = 2>
</cfif>
<cfif isdefined("attributes.act_type") and find(',',attributes.act_type)>
                <cfset attributes.act_type = listfirst(attributes.act_type)>
</cfif>

<cfif isdefined("attributes.start_date") and isdate(attributes.start_date)>
	<cf_date tarih = "attributes.start_date">
<cfelse>	
	<cfset attributes.start_date = ''>
</cfif>
<cfif isdefined("attributes.finish_date") and isdate(attributes.finish_date)>
	<cf_date tarih = "attributes.finish_date">
<cfelse>
	<cfset attributes.finish_date = ''>
</cfif>
<cfif isdefined("attributes.act_start_date") and isdate(attributes.act_start_date)>
	<cf_date tarih = "attributes.act_start_date">
<cfelse>	
	<cfset attributes.act_start_date = ''>
</cfif>
<cfif isdefined("attributes.act_finish_date") and isdate(attributes.act_finish_date)>
	<cf_date tarih = "attributes.act_finish_date">
<cfelse>
	<cfset attributes.act_finish_date = ''>
</cfif>
<cfif isdefined("attributes.record_start_date") and isdate(attributes.record_start_date)>
	<cf_date tarih = "attributes.record_start_date">
<cfelse>	
	<cfset attributes.record_start_date = ''>
</cfif>
<cfif isdefined("attributes.record_finish_date") and isdate(attributes.record_finish_date)>
	<cf_date tarih = "attributes.record_finish_date">
<cfelse>
	<cfset attributes.record_finish_date = ''>
</cfif>
<cfif isdefined("attributes.is_submitted")>
	<cfif listlen(attributes.employee_id,'_') eq 2>
		<cfset attributes.acc_type_id = listlast(attributes.employee_id,'_')>
		<cfset attributes.employee_id = listfirst(attributes.employee_id,'_')>
	</cfif>
	<cfset ch_alias = "CC.">
	<cfinclude template="../../objects/query/get_acc_types.cfm">
	<cfquery name="GET_CLOSED_INVOICE" datasource="#DSN2#">
		SELECT
			CC.CLOSED_ID,
			CC.COMPANY_ID,
			CC.CONSUMER_ID,
			CC.EMPLOYEE_ID,
			CC.ACTION_DETAIL,
			ISNULL(CC.PAYMENT_DIFF_AMOUNT_VALUE,0) PAYMENT_DIFF_AMOUNT_VALUE,
			ISNULL(CC.P_ORDER_DIFF_AMOUNT_VALUE,0) P_ORDER_DIFF_AMOUNT_VALUE,
			(SELECT SUM(ISNULL(CRR.OTHER_CLOSED_AMOUNT,0)) FROM CARI_CLOSED_ROW CRR WHERE CRR.CLOSED_ID = CC.CLOSED_ID) DEBT_AMOUNT_VALUE,
			CC.PAPER_DUE_DATE,
			CC.RECORD_DATE,
			CC.RECORD_EMP,
			CC.OTHER_MONEY,
			CC.PROCESS_STAGE,
			ISNULL(CC.IS_BANK_ORDER,0) IS_BANK_ORDER,
			CC.ACC_TYPE_ID,
			SAT.ACC_TYPE_NAME,
			COM.FULLNAME,
			CON.CONSUMER_NAME+' '+CON.CONSUMER_SURNAME CONSUMER_NAME,
			EMP.EMPLOYEE_NAME+' '+EMP.EMPLOYEE_SURNAME EMPLOYEE_NAME,
			(SELECT IS_BLACKLIST FROM #dsn_alias#.COMPANY_CREDIT WHERE COMPANY_CREDIT.COMPANY_ID = COM.COMPANY_ID AND COMPANY_CREDIT.OUR_COMPANY_ID=#session.ep.company_id#) IS_BLACKLIST,
			CB.COMPANY_IBAN_CODE,
			CONB.CONSUMER_IBAN_CODE,
			EBA.IBAN_NO AS EMPLOYEE_IBAN_CODE
		FROM
			CARI_CLOSED CC
				LEFT JOIN #dsn_alias#.COMPANY COM ON COM.COMPANY_ID = CC.COMPANY_ID
			 	LEFT JOIN #dsn_alias#.CONSUMER CON ON CON.CONSUMER_ID = CC.CONSUMER_ID
				LEFT JOIN #dsn_alias#.EMPLOYEES EMP ON EMP.EMPLOYEE_ID = CC.EMPLOYEE_ID
				LEFT JOIN #dsn_alias#.SETUP_ACC_TYPE SAT ON SAT.ACC_TYPE_ID = CC.ACC_TYPE_ID
				LEFT JOIN #dsn_alias#.COMPANY_BANK CB ON CB.COMPANY_ID = COM.COMPANY_ID AND CB.COMPANY_ACCOUNT_DEFAULT = 1 <!--- ( CB.COMPANY_BANK_MONEY = CC.OTHER_MONEY OR --->
				LEFT JOIN #dsn_alias#.CONSUMER_BANK CONB ON CONB.CONSUMER_ID = CC.CONSUMER_ID AND CONB.CONSUMER_ACCOUNT_DEFAULT = 1<!--- ( CONB.MONEY = CC.OTHER_MONEY OR --->
				LEFT JOIN #dsn_alias#.EMPLOYEES_BANK_ACCOUNTS EBA ON EBA.EMPLOYEE_ID = CC.EMPLOYEE_ID AND EBA.DEFAULT_ACCOUNT = 1 <!--- ( EBA.MONEY = CC.OTHER_MONEY OR  --->
		WHERE
			CC.CLOSED_ID IS NOT NULL
			AND CLOSED_ID IN(SELECT CCR.CLOSED_ID FROM CARI_CLOSED_ROW CCR WHERE CCR.CLOSED_ID = CC.CLOSED_ID AND CCR.ACTION_ID=0)
		<!--- yazışmalardan girildiğinde kendi kaydettiği talepleri görebilsin diye --->
		<cfif (isDefined("attributes.correspondence_info") and len(attributes.correspondence_info)) or listfind(attributes.fuseaction,'correspondence','.')>
			AND CC.RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
		</cfif>
		<cfif isdefined("attributes.member_name") and len(attributes.member_id) and len(attributes.member_name)>
			AND CC.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.member_id#">
		<cfelseif isdefined("attributes.member_name") and len(attributes.consumer_id) and len(attributes.member_name)>
			AND CC.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
		<cfelseif isdefined("attributes.member_name") and len(attributes.employee_id) and len(attributes.member_name)>
			AND CC.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
		</cfif>
		<cfif isdefined("attributes.member_name") and len(attributes.member_name) and isdefined("attributes.acc_type_id") and len(attributes.acc_type_id)>
			AND CC.ACC_TYPE_ID = #attributes.acc_type_id#
		</cfif>
		<cfif len(hr_type_list) or len(ehesap_type_list) or len(other_type_list)><!--- İk veya ehesap süper kullanıcı yetkisine bakılacak tip varsa --->
			AND #control_acc_type_list#
		</cfif>
		<cfif isdefined("attributes.bank_account_status") and len(attributes.bank_account_status) and attributes.bank_account_status eq 1 and attributes.act_type eq 3>
			AND (CC.COMPANY_ID IN (SELECT COMB.COMPANY_ID FROM #dsn_alias#.COMPANY_BANK COMB WHERE COMB.COMPANY_ACCOUNT_DEFAULT = 1)
			OR CC.CONSUMER_ID IN (SELECT CONB.CONSUMER_ID FROM #dsn_alias#.CONSUMER_BANK CONB WHERE CONB.CONSUMER_ACCOUNT_DEFAULT = 1)
			OR CC.EMPLOYEE_ID IN (SELECT EBA.EMPLOYEE_ID FROM #dsn_alias#.EMPLOYEES_BANK_ACCOUNTS EBA WHERE EBA.DEFAULT_ACCOUNT = 1))
		<cfelseif isdefined("attributes.bank_account_status") and len(attributes.bank_account_status) and attributes.bank_account_status eq 0 and attributes.act_type eq 3>
			AND ISNULL(CC.COMPANY_ID,0) NOT IN (SELECT COMB.COMPANY_ID FROM #dsn_alias#.COMPANY_BANK COMB WHERE COMB.COMPANY_ACCOUNT_DEFAULT = 1)
			AND ISNULL(CC.CONSUMER_ID,0) NOT IN (SELECT CONB.CONSUMER_ID FROM #dsn_alias#.CONSUMER_BANK CONB WHERE CONB.CONSUMER_ACCOUNT_DEFAULT = 1)
			AND ISNULL(CC.EMPLOYEE_ID,0) NOT IN (SELECT EBA.EMPLOYEE_ID FROM #dsn_alias#.EMPLOYEES_BANK_ACCOUNTS EBA WHERE EBA.DEFAULT_ACCOUNT = 1)
		</cfif>
		<cfif isdefined("attributes.paper_no") and len(attributes.paper_no)>
			AND
			(
				CC.CLOSED_ID IN (SELECT CLOSED_ID FROM CARI_CLOSED_ROW CCR,CARI_ROWS CR WHERE CCR.ACTION_ID = CR.ACTION_ID AND CCR.ACTION_TYPE_ID = CR.ACTION_TYPE_ID AND CR.PAPER_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.paper_no#%">)
				<cfif isnumeric(attributes.paper_no)>
					OR CC.CLOSED_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.paper_no#">
				</cfif>
				OR CC.CLOSED_ID IN (SELECT CLOSED_ID FROM CARI_CLOSED_ROW CCR,CARI_ROWS CR WHERE CCR.ACTION_ID = CR.ACTION_ID AND CCR.ACTION_TYPE_ID = CR.ACTION_TYPE_ID AND CR.ACTION_TABLE = 'INVOICE' AND CR.ACTION_ID IN(SELECT IR.INVOICE_ID FROM INVOICE_ROW IR WHERE IR.NAME_PRODUCT LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.paper_no#%">))
				OR CC.ACTION_DETAIL LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.paper_no#%">
			)
		</cfif>
		<cfif attributes.act_type eq 1><!--- Kapama İşlemi İse --->
			AND IS_CLOSED = 1							
		<cfelseif attributes.act_type eq 2><!--- Ödeme talebi İse --->
			AND IS_DEMAND = 1
		<cfelseif attributes.act_type eq 3><!--- Ödeme emri İse --->
			AND IS_ORDER = 1
		</cfif>
		<cfif isdefined("attributes.process_stage") and len(attributes.process_stage)>
			AND CC.PROCESS_STAGE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_stage#">
		</cfif>
		<cfif isdefined("attributes.bank_order_status") and len(attributes.bank_order_status)>
			AND ISNULL(CC.IS_BANK_ORDER,0) = #attributes.bank_order_status#
		</cfif>
		<cfif isdate(attributes.start_date) and isdate(attributes.finish_date)>
			AND CC.PAPER_DUE_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#">
		<cfelseif isdate(attributes.start_date)>
			AND CC.PAPER_DUE_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#">
		<cfelseif isdate(attributes.finish_date)>
			AND CC.PAPER_DUE_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#">
		</cfif>
		<cfif isdate(attributes.act_start_date) and isdate(attributes.act_finish_date)>
			AND CC.PAPER_ACTION_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.act_start_date#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.act_finish_date#">
		<cfelseif isdate(attributes.act_start_date)>
			AND CC.PAPER_ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.act_start_date#">
		<cfelseif isdate(attributes.act_finish_date)>
			AND CC.PAPER_ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.act_finish_date#">
		</cfif>
		<cfif isdate(attributes.record_start_date)  and not isdate(attributes.record_finish_date)>
			AND CC.RECORD_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.record_start_date#">
		<cfelseif isdate(attributes.record_finish_date) and not isdate(attributes.record_start_date)>
			AND CC.RECORD_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DATEADD("d",1,attributes.record_finish_date)#">
		<cfelseif isdate(attributes.record_start_date) and isdate(attributes.record_finish_date)>
			AND CC.RECORD_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.record_start_date#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#date_add("d",1,attributes.record_finish_date)#">
		</cfif>
		<cfif attributes.act_type eq 3 and isdefined("attributes.closed_type_info") and len(attributes.closed_type_info)>
			<cfif attributes.closed_type_info eq 1>
				AND IS_CLOSED IS NOT NULL
			<cfelseif attributes.closed_type_info eq 2>
				AND IS_CLOSED IS NULL
			</cfif>
		<cfelseif attributes.act_type eq 2 and isdefined("attributes.closed_type_info") and len(attributes.closed_type_info)>
			<cfif attributes.closed_type_info eq 1>
				AND IS_ORDER IS NOT NULL
			<cfelseif attributes.closed_type_info eq 2>
				AND IS_ORDER IS NULL
			</cfif>
		</cfif>
		<cfif len(attributes.other_money)>
			AND OTHER_MONEY = '#attributes.other_money#'
		</cfif>
		UNION ALL
		SELECT
			CC.CLOSED_ID,
			CC.COMPANY_ID,
			CC.CONSUMER_ID,
			CC.EMPLOYEE_ID,
			CC.ACTION_DETAIL,
			ISNULL(CC.PAYMENT_DIFF_AMOUNT_VALUE,0) PAYMENT_DIFF_AMOUNT_VALUE,
			ISNULL(CC.P_ORDER_DIFF_AMOUNT_VALUE,0) P_ORDER_DIFF_AMOUNT_VALUE,
			#dsn_alias#.IS_ZERO(ISNULL(CC.DEBT_AMOUNT_VALUE,0),ISNULL(CC.CLAIM_AMOUNT_VALUE,0)) DEBT_AMOUNT_VALUE,
			CC.PAPER_DUE_DATE,
			CC.RECORD_DATE,
			CC.RECORD_EMP,
			CC.OTHER_MONEY,
			CC.PROCESS_STAGE,
			ISNULL(CC.IS_BANK_ORDER,0) IS_BANK_ORDER,
			CC.ACC_TYPE_ID,
			SAT.ACC_TYPE_NAME,
			COM.FULLNAME,
			CON.CONSUMER_NAME+' '+CON.CONSUMER_SURNAME CONSUMER_NAME,
			EMP.EMPLOYEE_NAME+' '+EMP.EMPLOYEE_SURNAME EMPLOYEE_NAME,
			(SELECT IS_BLACKLIST FROM #dsn_alias#.COMPANY_CREDIT WHERE COMPANY_CREDIT.COMPANY_ID = COM.COMPANY_ID AND COMPANY_CREDIT.OUR_COMPANY_ID=#session.ep.company_id#) IS_BLACKLIST,
			CB.COMPANY_IBAN_CODE,
			CONB.CONSUMER_IBAN_CODE,
			EBA.IBAN_NO AS EMPLOYEE_IBAN_CODE
		FROM
			CARI_CLOSED CC
				LEFT JOIN #dsn_alias#.COMPANY COM ON COM.COMPANY_ID = CC.COMPANY_ID
			 	LEFT JOIN #dsn_alias#.CONSUMER CON ON CON.CONSUMER_ID = CC.CONSUMER_ID
				LEFT JOIN #dsn_alias#.EMPLOYEES EMP ON EMP.EMPLOYEE_ID = CC.EMPLOYEE_ID
				LEFT JOIN #dsn_alias#.SETUP_ACC_TYPE SAT ON SAT.ACC_TYPE_ID = CC.ACC_TYPE_ID 
				LEFT JOIN #dsn_alias#.COMPANY_BANK CB ON CB.COMPANY_ID = CC.COMPANY_ID AND CB.COMPANY_ACCOUNT_DEFAULT = 1 <!--- ( CB.COMPANY_BANK_MONEY = CC.OTHER_MONEY OR --->
				LEFT JOIN #dsn_alias#.CONSUMER_BANK CONB ON CONB.CONSUMER_ID = CC.CONSUMER_ID AND CONB.CONSUMER_ACCOUNT_DEFAULT = 1 <!--- ( CONB.MONEY = CC.OTHER_MONEY OR --->
				LEFT JOIN #dsn_alias#.EMPLOYEES_BANK_ACCOUNTS EBA ON EBA.EMPLOYEE_ID = CC.EMPLOYEE_ID AND EBA.DEFAULT_ACCOUNT = 1<!--- ( EBA.MONEY = CC.OTHER_MONEY OR --->
		WHERE 
		
			CC.CLOSED_ID IS NOT NULL
			AND CLOSED_ID NOT IN(SELECT CCR.CLOSED_ID FROM CARI_CLOSED_ROW CCR WHERE CCR.CLOSED_ID = CC.CLOSED_ID AND CCR.ACTION_ID=0)
		<cfif (isDefined("attributes.correspondence_info") and len(attributes.correspondence_info)) or listfind(attributes.fuseaction,'correspondence','.')>
			AND CC.RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"><!--- yazışmalardan girildiğinde kendi kaydettiği talepleri görebilsn diye --->
		</cfif>
		<cfif isdefined("attributes.member_name") and len(attributes.member_id) and len(attributes.member_name)>
			AND CC.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.member_id#">
		<cfelseif isdefined("attributes.member_name") and len(attributes.consumer_id) and len(attributes.member_name)>
			AND CC.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
		<cfelseif isdefined("attributes.member_name") and len(attributes.employee_id) and len(attributes.member_name)>
			AND CC.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
		</cfif>
		<cfif isdefined("attributes.member_name") and len(attributes.member_name) and isdefined("attributes.acc_type_id") and len(attributes.acc_type_id)>
			AND CC.ACC_TYPE_ID = #attributes.acc_type_id#
		</cfif>
		<cfif len(hr_type_list) or len(ehesap_type_list) or len(other_type_list)><!--- İk veya ehesap süper kullanıcı yetkisine bakılacak tip varsa --->
			AND #control_acc_type_list#
		</cfif>
		<cfif isdefined("attributes.bank_account_status") and len(attributes.bank_account_status) and attributes.bank_account_status eq 1 and attributes.act_type eq 3>
			AND (CC.COMPANY_ID IN (SELECT COMB.COMPANY_ID FROM #dsn_alias#.COMPANY_BANK COMB WHERE COMB.COMPANY_ACCOUNT_DEFAULT = 1)
			OR CC.CONSUMER_ID IN (SELECT CONB.CONSUMER_ID FROM #dsn_alias#.CONSUMER_BANK CONB WHERE CONB.CONSUMER_ACCOUNT_DEFAULT = 1)
			OR CC.EMPLOYEE_ID IN (SELECT EBA.EMPLOYEE_ID FROM #dsn_alias#.EMPLOYEES_BANK_ACCOUNTS EBA WHERE EBA.DEFAULT_ACCOUNT = 1))
		<cfelseif isdefined("attributes.bank_account_status") and len(attributes.bank_account_status) and attributes.bank_account_status eq 0 and attributes.act_type eq 3>
			AND ISNULL(CC.COMPANY_ID,0) NOT IN (SELECT COMB.COMPANY_ID FROM #dsn_alias#.COMPANY_BANK COMB WHERE COMB.COMPANY_ACCOUNT_DEFAULT = 1)
			AND ISNULL(CC.CONSUMER_ID,0) NOT IN (SELECT CONB.CONSUMER_ID FROM #dsn_alias#.CONSUMER_BANK CONB WHERE CONB.CONSUMER_ACCOUNT_DEFAULT = 1)
			AND ISNULL(CC.EMPLOYEE_ID,0) NOT IN (SELECT EBA.EMPLOYEE_ID FROM #dsn_alias#.EMPLOYEES_BANK_ACCOUNTS EBA WHERE EBA.DEFAULT_ACCOUNT = 1)
		</cfif>
		<cfif isdefined("attributes.bank_order_status") and len(attributes.bank_order_status)>
			AND ISNULL(CC.IS_BANK_ORDER,0) = #attributes.bank_order_status#
		</cfif>
		<cfif isdefined("attributes.paper_no") and len(attributes.paper_no)>
			AND
			(
				CC.CLOSED_ID IN (SELECT CLOSED_ID FROM CARI_CLOSED_ROW CCR,CARI_ROWS CR WHERE CCR.ACTION_ID = CR.ACTION_ID AND CCR.ACTION_TYPE_ID = CR.ACTION_TYPE_ID AND CR.PAPER_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.paper_no#%">)
				<cfif isnumeric(attributes.paper_no)>
					OR
					CC.CLOSED_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.paper_no#">
				</cfif>
				OR CC.CLOSED_ID IN (SELECT CLOSED_ID FROM CARI_CLOSED_ROW CCR,CARI_ROWS CR WHERE CCR.ACTION_ID = CR.ACTION_ID AND CCR.ACTION_TYPE_ID = CR.ACTION_TYPE_ID AND CR.ACTION_TABLE = 'INVOICE' AND CR.ACTION_ID IN(SELECT IR.INVOICE_ID FROM INVOICE_ROW IR WHERE IR.NAME_PRODUCT LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.paper_no#%">))
				OR CC.ACTION_DETAIL LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.paper_no#%">
			)
		</cfif>
		<cfif attributes.act_type eq 1><!--- Kapama İşlemi İse --->
			AND IS_CLOSED = 1							
		<cfelseif attributes.act_type eq 2><!--- Ödeme talebi İse --->
			AND IS_DEMAND = 1
		<cfelseif attributes.act_type eq 3><!--- Ödeme emri İse --->
			AND IS_ORDER = 1
		</cfif>
		<cfif isdefined("attributes.process_stage") and len(attributes.process_stage)>
			AND CC.PROCESS_STAGE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_stage#">
		</cfif>
		<cfif isdate(attributes.start_date) and isdate(attributes.finish_date)>
			AND CC.PAPER_DUE_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#">
		<cfelseif isdate(attributes.start_date)>
			AND CC.PAPER_DUE_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#">
		<cfelseif isdate(attributes.finish_date)>
			AND CC.PAPER_DUE_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#">
		</cfif>
		<cfif isdate(attributes.act_start_date) and isdate(attributes.act_finish_date)>
			AND CC.PAPER_ACTION_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.act_start_date#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.act_finish_date#">
		<cfelseif isdate(attributes.act_start_date)>
			AND CC.PAPER_ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.act_start_date#">
		<cfelseif isdate(attributes.act_finish_date)>
			AND CC.PAPER_ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.act_finish_date#">
		</cfif>
		<cfif isdate(attributes.record_start_date)  and not isdate(attributes.record_finish_date)>
			AND CC.RECORD_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.record_start_date#">
		<cfelseif isdate(attributes.record_finish_date) and not isdate(attributes.record_start_date)>
			AND CC.RECORD_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DATEADD("d",1,attributes.record_finish_date)#">
		<cfelseif isdate(attributes.record_start_date) and isdate(attributes.record_finish_date)>
			AND CC.RECORD_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.record_start_date#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#date_add("d",1,attributes.record_finish_date)#">
		</cfif>
		<cfif attributes.act_type eq 3 and isdefined("attributes.closed_type_info") and len(attributes.closed_type_info)>
			<cfif attributes.closed_type_info eq 1>
				AND IS_CLOSED IS NOT NULL
			<cfelseif attributes.closed_type_info eq 2>
				AND IS_CLOSED IS NULL
			</cfif>
		<cfelseif attributes.act_type eq 2 and isdefined("attributes.closed_type_info") and len(attributes.closed_type_info)>
			<cfif attributes.closed_type_info eq 1>
				AND IS_ORDER IS NOT NULL
			<cfelseif attributes.closed_type_info eq 2>
				AND IS_ORDER IS NULL
			</cfif>
		</cfif>
		<cfif len(attributes.other_money)>
			AND OTHER_MONEY = '#attributes.other_money#'
		</cfif>
		ORDER BY CC.CLOSED_ID DESC
	</cfquery>
<cfelse>
	<cfset get_closed_invoice.recordcount = 0>
</cfif>
<cfquery name="GET_MONEY" datasource="#dsn#">
	SELECT 
		MONEY,
		RATE2,
		RATE1 
	FROM 
		SETUP_MONEY 
	WHERE 
		PERIOD_ID = #session.ep.PERIOD_ID# 
		AND MONEY_STATUS = 1
	<cfif session.ep.period_year gt 2008>
	UNION ALL
		SELECT TOP 1
			'YTL',1,1
		FROM
			SETUP_MONEY
	<cfelse>
	UNION ALL
		SELECT TOP 1
			'TL',1,1
		FROM
			SETUP_MONEY
	</cfif>		
</cfquery>
<cfquery name="GET_ACCOUNTS" datasource="#DSN#">
	SELECT 
		* 
	FROM 
		SETUP_BANK_TYPES SB,
		OUR_COMPANY_BANK_RELATION ORR 
	WHERE 
		EXPORT_TYPE IS NOT NULL 
		AND SB.BANK_ID = ORR.BANK_ID
		AND ORR.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
	ORDER BY 
		BANK_NAME
</cfquery>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.totalrecords" default="#get_closed_invoice.recordcount#">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow = ((attributes.page-1)*attributes.maxrows) + 1 >
<cfsavecontent variable="header_">
<cfif attributes.act_type eq 1>
	<cfset list_action ="finance.list_payment_actions">
	<cf_get_lang dictionary_id ='54773.Fatura Kapama Belgeleri'>
<cfelseif attributes.act_type eq 2>
	<cfset list_action ="#fusebox.circuit#.list_payment_actions_demand">
	<cf_get_lang dictionary_id ='54396.Ödeme Talepleri'>
<cfelse>
	<cfset list_action ="finance.list_payment_actions_order">
	<cf_get_lang dictionary_id ='54648.Ödeme Emirleri'>
</cfif>
</cfsavecontent>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
		<cfform name="list_closed_invoice" id="list_closed_invoice" method="post" action="#request.self#?fuseaction=#list_action#">
		<input name="is_submitted" id="is_submitted" value="1" type="hidden">
			<cf_box_search>
				<cfif isDefined("attributes.correspondence_info") and len(attributes.correspondence_info)>
					<input type="hidden" name="correspondence_info" id="correspondence_info" value="1">
				</cfif>
				<div class="form-group">
					<input type="text" name="paper_no" id="paper_no" value="<cfoutput>#attributes.paper_no#</cfoutput>" placeholder="<cfoutput>#getLang(48,'Filtre',57460)#</cfoutput>">
				</div>
				<div class="form-group">
					<cf_workcube_process_info>
					<cfquery name="get_process_types" datasource="#DSN#">
						SELECT
							PTR.STAGE,
							PTR.PROCESS_ROW_ID 
						FROM
							PROCESS_TYPE_ROWS PTR,
							PROCESS_TYPE_OUR_COMPANY PTO,
							PROCESS_TYPE PT
						WHERE
							IS_ACTIVE = 1 AND
							PT.PROCESS_ID = PTR.PROCESS_ID AND
							PT.PROCESS_ID = PTO.PROCESS_ID AND
							PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
							PTR.PROCESS_ROW_ID IN (#process_rowid_list#) AND
							PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.fuseaction#%">
					</cfquery>
					<select name="process_stage" id="process_stage">
						<option value="" selected><cf_get_lang dictionary_id='57482.Aşama'></option>
						<cfoutput query="GET_PROCESS_TYPES">
							<option value="#PROCESS_ROW_ID#" <cfif isdefined("attributes.process_stage") and (attributes.process_stage eq PROCESS_ROW_ID)>selected</cfif>>#stage#</option>
						</cfoutput>
					</select>                
				</div>
				<div class="form-group">
					<select name="act_type" id="act_type">
						<option value=""><cf_get_lang dictionary_id ='57800.İşlem Tipi'></option>
						<option value="1" <cfif attributes.act_type eq 1>selected</cfif>><cf_get_lang dictionary_id ='58787.Belge Kapama'></option>
						<option value="2" <cfif attributes.act_type eq 2>selected</cfif>><cf_get_lang dictionary_id ='54429.Ödeme Talebi'></option>
						<option value="3" <cfif attributes.act_type eq 3>selected</cfif>><cf_get_lang dictionary_id ='54651.Ödeme Emri'></option>
					</select>
				</div>
				<cfif attributes.act_type eq 3>
				<div class="form-group">
					<select name="bank_order_status" id="bank_order_status">
						<option value=""><cfoutput>#getLang(77,'Banka Talimati',54463)#</cfoutput></option>
						<option value="1" <cfif attributes.bank_order_status eq 1>selected</cfif>><cfoutput>#getLang(64,'Oluşturulmuş',54450)#</cfoutput></option>
						<option value="0" <cfif attributes.bank_order_status eq 0>selected</cfif>><cfoutput>#getLang(78,'Oluşturulmamış',54464)#</cfoutput></option>
					</select>
				</div>
				<div class="form-group">
					<select name="closed_type_info" id="closed_type_info">
						<option value="0" <cfif isDefined("attributes.closed_type_info") and attributes.closed_type_info eq 0>selected</cfif>><cf_get_lang dictionary_id ='57734.Seçiniz'></option>
						<option value="1" <cfif isDefined("attributes.closed_type_info") and attributes.closed_type_info eq 1>selected</cfif>><cf_get_lang dictionary_id ='54513.Kapanmışlar'></option>
						<option value="2" <cfif isDefined("attributes.closed_type_info") and attributes.closed_type_info eq 2>selected</cfif>><cf_get_lang dictionary_id ='54449.Kapanmamışlar'></option>
					</select>
				</div>
				<cfelseif attributes.act_type eq 2>
				<div class="form-group">
					<select name="closed_type_info" id="closed_type_info">
						<option value="0" <cfif isDefined("attributes.closed_type_info") and attributes.closed_type_info eq 0>selected</cfif>><cf_get_lang dictionary_id ='57756.Durum'></option>
						<option value="1" <cfif isDefined("attributes.closed_type_info") and attributes.closed_type_info eq 1>selected</cfif>><cf_get_lang dictionary_id ='54519.Ödeme Emri Verilenler'></option>
						<option value="2" <cfif isDefined("attributes.closed_type_info") and attributes.closed_type_info eq 2>selected</cfif>><cf_get_lang dictionary_id ='54521.Ödeme Emri Verilmeyenler'></option>
					</select>
				</div>
					<cfelse>
					<cfset attributes.closed_type_info = 0>
				</cfif>
				<cfif attributes.act_type eq 3>
				<div class="form-group">
					<select name="bank_account_status" id="bank_account_status">
						<option value=""><cf_get_lang dictionary_id='29449.Banka Hesabı'></option>
						<option value="1" <cfif attributes.bank_account_status eq 1>selected</cfif>><cfoutput>#getLang(2258,'Olanlar',30055)#</cfoutput></option>
						<option value="0" <cfif attributes.bank_account_status eq 0>selected</cfif>><cfoutput>#getLang(2259,'Olmayanlar',30056)#</cfoutput></option>
					</select>
				</div>
				</cfif>
				<div class="form-group">
					<select name="other_money" id="other_money">
						<option value=""><cf_get_lang dictionary_id='57489.Para Birimi'></option>
						<cfoutput query="get_money">
							<option value="#money#" <cfif attributes.other_money eq money>selected</cfif>>#money#</option>
						</cfoutput>
					</select>
				</div>
				<div class="form-group small">
					<cfinput type="text" name="maxrows" id="maxrows" value="#attributes.maxrows#" validate="integer" range="1,250" required="yes" message="#getLang('','Kayıt Sayısı Hatalı',57537)#">
				</div>
					<div class="form-group">
					<cf_wrk_search_button button_type="4" search_function='control_type_info_()'>
					<cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'>
				</div>
				<div class="form-group">
					<cfoutput><a href="javascript://" class="ui-btn ui-btn-gray2" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_print_files&print_type=146&action_id=#URLEncodedFormat(page_code)#</cfoutput>','page','popup_print_files');"><i class="fa fa-print" alt="<cf_get_lang dictionary_id='57474.Yazdir'>" title="<cf_get_lang dictionary_id='57474.Yazdir'>"></i></a></cfoutput>
				</div>
			</cf_box_search>
			<cf_box_search_detail>
				<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group" id="item-member_name">
						<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57519.Cari Hesap'></label>
						<div class="col col-12">
							<div class="input-group">
								<cfif isdefined("attributes.employee_id")>
									<cfif isdefined("attributes.acc_type_id") and len(attributes.acc_type_id)>
										<cfset attributes.employee_id = "#attributes.employee_id#_#attributes.acc_type_id#">
									</cfif>
								</cfif>
								<input type="hidden" name="member_id" id="member_id" value="<cfif isdefined("attributes.member_id")><cfoutput>#attributes.member_id#</cfoutput></cfif>">
								<input type="hidden" name="consumer_id" id="consumer_id" value="<cfif isdefined("attributes.consumer_id")><cfoutput>#attributes.consumer_id#</cfoutput></cfif>">
								<input type="hidden" name="employee_id" id="employee_id" value="<cfif isdefined("attributes.employee_id")><cfoutput>#attributes.employee_id#</cfoutput></cfif>">
								<input type="text" name="member_name" id="member_name" onfocus="AutoComplete_Create('member_name','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2,3\',\'0\',\'0\',\'0\',\'\',\'\',\'\',\'1\'','COMPANY_ID,CONSUMER_ID,EMPLOYEE_ID','member_id,consumer_id,employee_id','','3','250');"  value="<cfif isdefined("attributes.member_name")><cfoutput>#attributes.member_name#</cfoutput></cfif>" autocomplete="off">
								<cfset str_linke_ait="field_comp_id=list_closed_invoice.member_id&field_comp_name=list_closed_invoice.member_name&field_consumer=list_closed_invoice.consumer_id&field_emp_id=list_closed_invoice.employee_id&field_name=list_closed_invoice.member_name&field_member_name=list_closed_invoice.member_name&select_list=1,2,3,9">
								<span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&is_cari_action=1&#str_linke_ait#'</cfoutput>);" title="<cf_get_lang dictionary_id='57519.Cari Hesap'>"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-due_date">
						<label class="col col-12"><cf_get_lang dictionary_id ='57881.Vade Tarihi'></label>
						<div class="col col-12">
							<div class="input-group">
								<cfinput type="text" name="start_date" id="start_date" value="#dateformat(attributes.start_date, dateformat_style)#" validate="#validate_style#" maxlength="10">
								<span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
								<span class="input-group-addon no-bg"></span>
								<cfinput type="text" name="finish_date" id="finish_date" value="#dateformat(attributes.finish_date, dateformat_style)#" validate="#validate_style#" maxlength="10">
								<span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>
							</div>
						</div>
					</div>
				</div>
				<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
					<div class="form-group" id="item-transaction_date">
						<label class="col col-12"><cf_get_lang dictionary_id='57879.İşlem Tarihi'></label>
						<div class="col col-12">
							<div class="input-group">
								<cfinput type="text" name="act_start_date" id="act_start_date" value="#dateformat(attributes.act_start_date, dateformat_style)#" validate="#validate_style#" maxlength="10">
								<span class="input-group-addon"><cf_wrk_date_image date_field="act_start_date"></span>
								<span class="input-group-addon no-bg"></span>
								<cfinput type="text" name="act_finish_date" id="act_finish_date" value="#dateformat(attributes.act_finish_date, dateformat_style)#" validate="#validate_style#" maxlength="10">
								<span class="input-group-addon"><cf_wrk_date_image date_field="act_finish_date"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-record_date">
						<label class="col col-12"><cf_get_lang dictionary_id='57627.Kayıt Tarihi'></label>
						<div class="col col-12">
							<div class="input-group">
								<cfinput type="text" name="record_start_date" id="record_start_date" value="#dateformat(attributes.record_start_date, dateformat_style)#" validate="#validate_style#" maxlength="10">
								<span class="input-group-addon"><cf_wrk_date_image date_field="record_start_date"></span>
								<span class="input-group-addon no-bg"></span>
								<cfinput type="text" name="record_finish_date" id="record_finish_date" value="#dateformat(attributes.record_finish_date, dateformat_style)#" validate="#validate_style#" maxlength="10">
								<span class="input-group-addon"><cf_wrk_date_image date_field="record_finish_date"></span>
							</div>
						</div>
					</div>
				</div>					
			</cf_box_search_detail>
		</cfform>
	</cf_box>
	<cf_box title="#header_#" uidrop="1" hide_table_column="1" scroll="1" woc_setting = "#{ checkbox_name : 'print_payment_id', print_type : 145 }#">
		<cfset cols = 18>
		<cf_grid_list>
			<thead>
				<tr>
					<th width="20"><cf_get_lang dictionary_id ='57487.No'></th>
					<th><cf_get_lang dictionary_id ='57880.Belge No'></th>
					<th><cf_get_lang dictionary_id='58533.Belge Tipi'></th>
					<th><cf_get_lang dictionary_id='57519.Cari Hesap'></th>
					<th>Standart IBAN</th>
					<th><cf_get_lang dictionary_id ='57629.Açıklama'></th>
					<cfif show_paper_no eq 1>
						<th><cf_get_lang dictionary_id='57880.Belge No'></th><cfset cols = cols +1>
					</cfif>
					<th><cf_get_lang dictionary_id ='57482.Aşama'></th>
					<th><cf_get_lang dictionary_id ='54403.Talep'></th>
					<th><cf_get_lang dictionary_id ='57489.Para Birimi'></th>
					<th><cf_get_lang dictionary_id ='54410.Emir'></th>
					<th><cf_get_lang dictionary_id ='57489.Para Birimi'></th>
					<th><cf_get_lang dictionary_id ='54411.Kapama'> </th>
					<th><cf_get_lang dictionary_id ='57489.Para Birimi'></th>
					<th><cf_get_lang dictionary_id ='30027.O Vade'></th>
					<th><cf_get_lang dictionary_id ='57899.Kaydeden'></th>
					<th><cf_get_lang dictionary_id ='57627.Kayıt Tarihi'></th>
					<!-- sil --><th width="20" class="header_icn_none text-center"><a href="<cfoutput>#request.self#?fuseaction=#list_action#&event=add&act_type=#attributes.act_type#<cfif isDefined("attributes.correspondence_info") and len(attributes.correspondence_info)>&correspondence_info=1</cfif></cfoutput>"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
						<cfif  get_closed_invoice.recordcount>
							<th width="20" nowrap="nowrap" class="text-center header_icn_none text-center">
								<a href="javascript://" onclick="send_print_reset();"><i class="fa fa-print" alt="<cf_get_lang dictionary_id='57389.Print Sayisi Sifirla'>" title="<cf_get_lang dictionary_id='57389.Print Sayisi Sifirla'>"></i></a>
								<input type="checkbox" name="allSelectDemand" id="allSelectDemand" onclick="wrk_select_all('allSelectDemand','print_payment_id');">
							</th>
						</cfif>
					<cfif attributes.act_type eq 3>
						<th width="100" class="text-center header_icn_none"><cf_get_lang dictionary_id='35376.Banka Talimatı'><input type="checkbox" name="allSelectDemand" id="allSelectDemand" onclick="wrk_select_all('allSelectDemand','row_demand');"></th><cfset cols = cols +1>
					</cfif>	
					<!-- sil -->
				</tr>
			</thead>
			<tbody>
				<cfif isdefined("attributes.is_submitted") and get_closed_invoice.recordcount>
					<cfset emp_id_list=''>
					<cfset process_list=''>
					<cfset closed_list=''>
					<cfoutput query="get_closed_invoice" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<cfif len(CLOSED_ID) and not listfind(closed_list,CLOSED_ID)>
							<cfset closed_list=listappend(closed_list,CLOSED_ID)>
						</cfif>
						<cfif len(RECORD_EMP) and not listfind(emp_id_list,RECORD_EMP)>
							<cfset emp_id_list=listappend(emp_id_list,RECORD_EMP)>
						</cfif>
						<cfif len(process_stage) and not listfind(process_list,process_stage)>
							<cfset process_list = listappend(process_list,process_stage)>
						</cfif>
					</cfoutput>
					<cfif len(closed_list)>
						<cfset closed_list=listsort(closed_list,"numeric","ASC",",")>
						<cfquery name="get_paper_no" datasource="#dsn2#">
							SELECT
								CCR.CLOSED_ID,
								CR.PAPER_NO 
							FROM
								CARI_CLOSED_ROW CCR,
								CARI_ROWS CR 
							WHERE 
								CCR.CLOSED_ID IN (#closed_list#)
								<cfif attributes.act_type eq 1><!--- Kapama İşlemi İse --->
									AND CCR.CLOSED_AMOUNT <> 0
								<cfelseif attributes.act_type eq 2><!--- Ödeme talebi İse --->
									AND CCR.PAYMENT_VALUE <> 0
								<cfelseif attributes.act_type eq 3><!--- Ödeme emri İse --->
									AND CCR.P_ORDER_VALUE <> 0
								</cfif>
								AND CR.PAPER_NO IS NOT NULL 
								AND CCR.CARI_ACTION_ID = CR.CARI_ACTION_ID 
							ORDER BY 
								CLOSED_ID
						</cfquery>
					</cfif>
					<cfif len(emp_id_list)>
						<cfset emp_id_list=listsort(emp_id_list,"numeric","ASC",",")>
						<cfquery name="get_emp_detail" datasource="#dsn#">
							SELECT EMPLOYEE_NAME, EMPLOYEE_SURNAME, EMPLOYEE_ID FROM EMPLOYEES WHERE EMPLOYEE_ID IN (#emp_id_list#) ORDER BY EMPLOYEE_ID
						</cfquery>
						<cfset emp_id_list = valuelist(get_emp_detail.EMPLOYEE_ID)>
					</cfif>
					<cfif len(process_list)>
						<cfset process_list=listsort(process_list,"numeric","ASC",",")>
						<cfquery name="GET_PROCESS_TYPE" datasource="#DSN#">
							SELECT STAGE,PROCESS_ROW_ID FROM PROCESS_TYPE_ROWS WHERE PROCESS_ROW_ID IN (#process_list#) ORDER BY PROCESS_ROW_ID
						</cfquery>
						<cfset process_list = listsort(listdeleteduplicates(valuelist(get_process_type.process_row_id,',')),'numeric','ASC',',')>
					</cfif>
					<cfoutput query="get_closed_invoice" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<tr>
							<td>#currentrow#</td>
							<td>#closed_id#</td>
							<td><a href="#request.self#?fuseaction=#list_action#&event=upd&closed_id=#closed_id#&act_type=#attributes.act_type#<cfif len(company_id)>&company_id=#COMPANY_ID#<cfelseif len(consumer_id)>&con_id=#CONSUMER_ID#<cfelseif len(employee_id)>&emp_id=#EMPLOYEE_ID#</cfif><cfif isDefined("attributes.correspondence_info") and len(attributes.correspondence_info)>&correspondence_info=1</cfif>" class="tableyazi"><cfif attributes.act_type eq 1><cf_get_lang dictionary_id ='58787.Belge Kapama'><cfelseif attributes.act_type eq 2><cf_get_lang dictionary_id ='54429.Ödeme Talebi'><cfelse><cf_get_lang dictionary_id ='54651.Ödeme Emri'></cfif></a></td>
							<td width="200">
								<cfif len(company_id)>
									<a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#COMPANY_ID#','medium');">#FULLNAME#<cfif is_blacklist eq 1>- <font color="##FF0000"><cf_get_lang dictionary_id='49645.Kara Listede'></font></cfif></a>
								<cfelseif len(consumer_id)>
									<a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#CONSUMER_ID#','medium');">#CONSUMER_NAME#</a>
								<cfelseif len(employee_id)>
									<a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#EMPLOYEE_ID#','medium');">#EMPLOYEE_NAME# <cfif len(acc_type_name)> - #ACC_TYPE_NAME# </cfif></a>
								</cfif>
							</td>
							<td>
								<cfif len(company_id)>
									#COMPANY_IBAN_CODE#
								<cfelseif len(consumer_id)>
									#CONSUMER_IBAN_CODE#
								<cfelseif len(employee_id)>
									#EMPLOYEE_IBAN_CODE#
								</cfif>
							</td>
							<td>#ACTION_DETAIL#</td>
							<cfif show_paper_no eq 1>
								<td>
									<cfif isdefined("get_paper_no")>
										<cfquery name="get_row_paper" dbtype="query">
											SELECT PAPER_NO FROM get_paper_no WHERE CLOSED_ID = #CLOSED_ID#
										</cfquery>
										<cfloop query="get_row_paper">
											#paper_no#<br/>
										</cfloop>
									</cfif>
								</td>
							</cfif>	
							<td>
								<cfif len(process_list)>#get_process_type.stage[listfind(process_list,process_stage,',')]#</cfif>
							</td>
							<td class="text-right">
								<cfif PAYMENT_DIFF_AMOUNT_VALUE lte 0>
									<font color="FF0000">#TLFormat(PAYMENT_DIFF_AMOUNT_VALUE)#</font>
								<cfelse>
									<font color="0033FF">#TLFormat(PAYMENT_DIFF_AMOUNT_VALUE)#</font>
								</cfif>
							</td>
							<td class="text-left">
								<cfif PAYMENT_DIFF_AMOUNT_VALUE lte 0>
									<font color="FF0000">#OTHER_MONEY#</font>
								<cfelse>
									<font color="0033FF">#OTHER_MONEY#</font>
								</cfif>
							</td>
							<td class="text-right">
								<cfif PAYMENT_DIFF_AMOUNT_VALUE lte 0>
									<font color="FF0000">#TLFormat(P_ORDER_DIFF_AMOUNT_VALUE)#</font>
								<cfelse>
									<font color="0033FF">#TLFormat(P_ORDER_DIFF_AMOUNT_VALUE)#</font>
								</cfif>
							</td>
							<td class="text-left">
								<cfif PAYMENT_DIFF_AMOUNT_VALUE lte 0>
									<font color="FF0000">#OTHER_MONEY#</font>
								<cfelse>
									<font color="0033FF">#OTHER_MONEY#</font>
								</cfif>
							</td>
							<td class="text-right">#TLFormat(DEBT_AMOUNT_VALUE)#</td>
							<td class="text-left">#OTHER_MONEY#</td>
							<td><cfif len(PAPER_DUE_DATE)>#dateformat(PAPER_DUE_DATE,dateformat_style)#</cfif></td>
							<td>
								<cfif len(record_emp)>
									<a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&EMP_ID=#record_emp#','medium');">#get_emp_detail.EMPLOYEE_NAME[listfind(emp_id_list,record_emp,',')]# #get_emp_detail.EMPLOYEE_SURNAME[listfind(emp_id_list,record_emp,',')]#</a>
								</cfif>
							</td>
							<td>#dateformat(record_date,dateformat_style)#</td>
							<!-- sil --><td><a href="#request.self#?fuseaction=#list_action#&event=upd&closed_id=#closed_id#&act_type=#attributes.act_type#<cfif len(company_id)>&company_id=#COMPANY_ID#<cfelseif len(consumer_id)>&con_id=#CONSUMER_ID#<cfelseif len(employee_id)>&emp_id=#EMPLOYEE_ID#</cfif><cfif isDefined("attributes.correspondence_info") and len(attributes.correspondence_info)>&correspondence_info=1</cfif>" class="tableyazi"> <cfif isDefined('attributes.is_excel') and attributes.is_excel eq 1> &nbsp; <cfelse><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></cfif> </a></td>
								<td style="text-align:center"><input type="checkbox" name="print_payment_id" data-action-type ="#attributes.act_type#" id="print_payment_id" value="#closed_id#"></td>
							<cfif attributes.act_type eq 3>
								<td>
									<input type="hidden" name="money_info#currentrow#" id="money_info#currentrow#" value="#other_money#">
									<input type="checkbox" name="row_demand" id="row_demand#currentrow#" value="#CLOSED_ID#" <cfif is_bank_order eq 1>disabled</cfif>>
								</td>
							</cfif>
							<!-- sil -->
						</tr>
					</cfoutput>
				<cfelse>
					<tr>
						<td colspan="<cfoutput>#cols#</cfoutput>"><cfif isdefined("attributes.is_submitted")><cf_get_lang dictionary_id='57484.Kayıt Yok'><cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif>!</td>
					</tr>
				</cfif>
			</tbody>
		</cf_grid_list>
		<cfif attributes.act_type eq 3 and isdefined("attributes.is_submitted") and get_closed_invoice.recordcount>
			<form name="upd_all_action" id="upd_all_action" method="post" action="<cfoutput>#request.self#?</cfoutput>fuseaction=<cfoutput>#fusebox.circuit#</cfoutput>.emptypopup_add_bankorder_from_orders">		
				<input type="hidden" name="closeIdList" id="closeIdList" value="">
				<div class="ui-info-bottom">
					<div class="col col-12 ui-form-list  ui-form-block">
						<div class="form-group col col-3 col-md-3 col-sm-5 col-xs-12">
							<label><cf_get_lang dictionary_id ='57800.İşlem Tipi'></label>
							<cf_workcube_process_cat>
						</div>
						<div class="form-group col col-3 col-md-3 col-sm-5 col-xs-12">
							<label><cf_get_lang dictionary_id ='57521.Banka'></label>
							<cf_wrkbankaccounts control_status='1' currency_id_info='#attributes.other_money#'>
						</div>
						<div class="form-group col col-2 col-md-3 col-sm-5 col-xs-12">
							<label><cf_get_lang dictionary_id ='57879.İşlem Tarihi'> *</label>
							<div class="input-group">
								<cfsavecontent  variable="message"> <cf_get_lang dictionary_id ='57879.İşlem Tarihi'> *</cfsavecontent>				
								<input type="text" name="action_date" id="action_date" placeholder="<cfoutput>#message#</cfoutput>" value="<cfoutput>#dateformat(now(),dateformat_style)#</cfoutput>">
								<span class="input-group-addon"><cf_wrk_date_image date_field="action_date"></span>
							</div>
						</div>
						<div class="form-group col col-2 col-md-3 col-sm-5 col-xs-12">
							<label><cf_get_lang dictionary_id ='58851.ödeme Tarihi'></label>
							<div class="input-group">
								<cfsavecontent  variable="message"> <cf_get_lang dictionary_id ='58851.ödeme Tarihi'></cfsavecontent>
								<input type="text" name="payment_date" id="payment_date" placeholder="<cfoutput>#message#</cfoutput>" value="<cfoutput>#dateformat(now(),dateformat_style)#</cfoutput>">
								<span class="input-group-addon"><cf_wrk_date_image date_field="payment_date"></span>
							</div>
						</div>
					</div>
					<div class="col col-12 ui-form-list-btn">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id ="38838.Banka Talimatı Oluştur"></cfsavecontent>
						<cf_workcube_buttons type_format="1" is_upd='0' insert_info="#message#" is_cancel='0' add_function='bankTypeFileFormat()'>
					</div>
				</div>
			</form>
			<div id="user_message_demand"></div>
		</cfif>
	  	<cfset adres="#attributes.fuseaction#&is_submitted=1">
		<cfif len(attributes.member_name) and len(attributes.member_id)>
			<cfset adres = "#adres#&member_id=#attributes.member_id#">
			<cfset adres = "#adres#&member_name=#attributes.member_name#">
		<cfelseif len(attributes.member_name) and len(attributes.consumer_id)>
			<cfset adres = "#adres#&consumer_id=#attributes.consumer_id#">
			<cfset adres = "#adres#&member_name=#attributes.member_name#">
		<cfelseif len(attributes.member_name) and len(attributes.employee_id)>
			<cfset adres = "#adres#&employee_id=#attributes.employee_id#">
			<cfset adres = "#adres#&member_name=#attributes.member_name#">
			<cfset adres = "#adres#&employee_id=#attributes.acc_type_id#">
		</cfif>
		<cfif len(attributes.paper_no)>
			<cfset adres = "#adres#&paper_no=#attributes.paper_no#">
		</cfif>
		<cfif len(attributes.act_type)>
			<cfset adres = "#adres#&act_type=#attributes.act_type#">
		</cfif>
		<cfif len(attributes.bank_order_status)>
			<cfset adres = "#adres#&bank_order_status=#attributes.bank_order_status#">
		</cfif>
		<cfif len(attributes.bank_account_status)>
			<cfset adres = "#adres#&bank_account_status=#attributes.bank_account_status#">
		</cfif>
		<cfif isdefined("attributes.process_stage") and len(attributes.process_stage)>
			<cfset adres = "#adres#&process_stage=#attributes.process_stage#">
		</cfif>
		<cfif isdate(attributes.start_date)>
			<cfset adres = "#adres#&start_date=#dateformat(attributes.start_date,dateformat_style)#">
		</cfif>
		<cfif isdate(attributes.finish_date)>
			<cfset adres = "#adres#&finish_date=#dateformat(attributes.finish_date,dateformat_style)#">
		</cfif>
		<cfif isdate(attributes.act_start_date)>
			<cfset adres = "#adres#&act_start_date=#dateformat(attributes.act_start_date,dateformat_style)#">
		</cfif>
		<cfif isdate(attributes.act_finish_date)>
			<cfset adres = "#adres#&act_finish_date=#dateformat(attributes.act_finish_date,dateformat_style)#">
		</cfif>
		<cfif isdate(attributes.record_start_date)>
			<cfset adres = "#adres#&record_start_date=#dateformat(attributes.record_start_date,dateformat_style)#">
		</cfif>
		<cfif isDefined("attributes.closed_type_info") and len(attributes.closed_type_info)>
			<cfset adres = "#adres#&closed_type_info=#attributes.closed_type_info#">
		</cfif>
		<cfif isdate(attributes.record_finish_date)>
			<cfset adres = "#adres#&record_finish_date=#dateformat(attributes.record_finish_date,dateformat_style)#">
		</cfif>
		<cfif isDefined("attributes.correspondence_info") and len(attributes.correspondence_info)>
			<cfset adres = "#adres#&correspondence_info=#attributes.correspondence_info#">
		</cfif>
	    <cf_paging page="#attributes.page#" 
			maxrows="#attributes.maxrows#" 
			totalrecords="#attributes.totalrecords#" 
			startrow="#attributes.startrow#" 
			adres="#adres#">
	</cf_box>
</div>
<script type="text/javascript">
document.getElementById('paper_no').focus();
function control_type_info_()
{
	if(document.getElementById('act_type').value == '')
	{
		alert("<cf_get_lang dictionary_id ="58770.Lütfen İşlem Tipi Seçiniz">!");
		return false;
	}
	return true;
}
//banka dosyasi
function bankTypeFileFormat()
{
	if(!chk_process_cat('upd_all_action')) return false;
	if(!acc_control()) return false;
	var is_selected=0;
	if(document.getElementById('action_date').value == '')
	{
		alert("<cf_get_lang dictionary_id='51422.Lütfen İşlem Tarihi Seçiniz'>");
		return false;
	}
	if(document.getElementById('payment_date').value == '')
	{
		alert("<cf_get_lang dictionary_id='51424.Lütfen Ödeme Tarihi Seçiniz'>");
		return false;
	}
	if(document.getElementsByName('row_demand').length > 0)
	{
		var closed_id_list="";
		for (i=1;i<=document.getElementsByName('row_demand').length;i++)
		{
			if(document.getElementById('row_demand'+i).checked==true)
			{ 
				closed_id_list += document.getElementById('row_demand'+i).value+',';
				is_selected=1;
			}
		}
				
		if(is_selected==1)
		{
			money_list = '';
			var uzunluk = document.getElementsByName('row_demand').length;
			for(ci=1;ci<=uzunluk;ci++){
				check_my_obj=document.getElementById('row_demand'+ci);
				money_info=eval('document.all.money_info'+ci).value;
				if(check_my_obj.checked==true)
				{
					if(money_info != document.getElementById('currency_id').value)
					{
						alert("<cf_get_lang dictionary_id='51438.Seçtiğiniz İşlemin Para Birimi Banka Hesabıyla Aynı Olmalıdır'> <cf_get_lang dictionary_id='58508.Satır:'>" + parseInt(ci+1)+"");
						return false;
					}
				}
			}		
			if(confirm("<cf_get_lang dictionary_id='51692.Seçtiğiniz İşlemlerin Banka Talimatı Oluşturulacak Emin misiniz ?'>"))
			{
				if(list_len(closed_id_list,',') > 1)
				{
					document.getElementById('closeIdList').value = closed_id_list;
					user_message="<cf_get_lang dictionary_id='51443.Banka Talimatları Ekleniyor Lütfen Bekleyiniz !'>";
					AjaxFormSubmit(upd_all_action,'user_message_demand',1,user_message,'<cf_get_lang dictionary_id="58786.Tamamlandı">!','','',1);
					return false;
				}
			}
			else
				return false;
		}
		else
		{
			alert("<cf_get_lang dictionary_id='38840.Lütfen İşlem Seçiniz!'>");
			return false;
		}
	}			
}
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
