<cfif isdefined("attributes.emp_id")>
	<cfscript>
    	attributes.acc_type_id = '';
		if(listlen(attributes.emp_id,'_') eq 2)
		{
			attributes.acc_type_id = listlast(attributes.emp_id,'_');
			attributes.employee_id = listfirst(attributes.emp_id,'_');
		}
		else
			attributes.employee_id = attributes.emp_id;
    </cfscript>
</cfif>
<cfif (session.ep.isBranchAuthorization) or (isdefined('attributes.branch_id') and len(attributes.branch_id))>
	<cfquery name="GET_ALL_CASH" datasource="#DSN2#">
		SELECT CASH_ID FROM CASH WHERE BRANCH_ID = <cfif isdefined('attributes.branch_id') and len(attributes.branch_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="#ListGetAt(session.ep.user_location,2,"-")#"></cfif>
	</cfquery>
	<cfset cash_list = valuelist(get_all_cash.cash_id)>
	<cfif not listlen(cash_list)><cfset cash_list = 0></cfif>
	<cfif isdefined('attributes.branch_id') and len(attributes.branch_id)>
		<cfset control_branch_id = attributes.branch_id>
	<cfelse>
		<cfset control_branch_id = ListGetAt(session.ep.user_location,2,"-")>
	</cfif>
</cfif>
<cfinclude template="../../objects/query/get_acc_types.cfm">
<cfif isdefined("attributes.record_date") and isdate(attributes.record_date)>
	<cf_date tarih="attributes.record_date">
</cfif>
<cfif isdefined("attributes.record_date2") and isdate(attributes.record_date2)>
	<cf_date tarih="attributes.record_date2">
</cfif>
<!--- SELECTBOX İŞLEM KATEGORİLERİ İLE DE FİLTRELENECEK ŞEKİLDE DÜZENLENDİ. ACT_TYPE İŞLEM TİPİ, PROC_CAT İŞLEM KATEGORİSİ.--->
<cfif isDefined("attributes.page_action_type") and len(attributes.page_action_type)>
	<cfset ACT_TYPE = ListFirst(attributes.page_action_type,'-')>
    <cfset PROC_CAT = ListLast(attributes.page_action_type,'-')>
	<cfif ACT_TYPE eq 104>
        <cfset ACT_TYPE = '1052,1053,1054,1051'>
    <cfelseif ACT_TYPE eq 105>
    	<cfset ACT_TYPE = '1040,1043,1044,1045'>
    <cfelseif ACT_TYPE eq 240>
    	<cfset ACT_TYPE = '24'>
    <cfelseif ACT_TYPE eq 250>
    	<cfset ACT_TYPE = '25'>
    </cfif>
</cfif>
<cfquery name="GET_ACTIONS" datasource="#DSN2#" cachedwithin="#fusebox.general_cached_time#">
SELECT  ACTION_VALUE
	,SYSTEM_ACTION_VALUE
	,EXPENSE_ID
	,WITH_NEXT_ROW
	,MULTI_ACTION_ID
	,ACC_TYPE_ID
	,#dsn#.Get_Dynamic_Language(ACTION_TYPE_ID,'#session.ep.language#','BANK_ACTIONS','BANK_ACTIONS.ACTION_TYPE',NULL,NULL,ACTION_TYPE) AS ACTION_TYPE
	,PAPER_NO
	,ACTION_DETAIL
	,MASRAF
	,ACTION_CURRENCY_ID
	,OTHER_MONEY
	,OTHER_CASH_ACT_VALUE
	,ACTION_DATE
	,RECORD_DATE
	,ACTION_TYPE_ID
	,ACTION_FROM_CASH_ID
	,ACTION_TO_CASH_ID
	,ACTION_FROM_ACCOUNT_ID
	,ACTION_TO_ACCOUNT_ID
	,ACTION_FROM_COMPANY_ID
	,ACTION_TO_COMPANY_ID
	,ACTION_FROM_CONSUMER_ID
	,ACTION_TO_CONSUMER_ID
	,ACTION_FROM_EMPLOYEE_ID
	,ACTION_TO_EMPLOYEE_ID
	,PROCESS_CAT
	,ACTION_ID
	,CREDITCARD_ID
	,OTHER_COST
	, PROJECT
	, BRANCH
	,#dsn#.Get_Dynamic_Language(ACTION_TYPE_ID,'#session.ep.language#','BANK_ACTIONS','BANK_ACTIONS.STAGE',NULL,NULL,STAGE) AS STAGE,
	MULTI_COUNT,
	MULTI_VALUE,
	MULTI_SYSTEM_VALUE
FROM 
        (
		SELECT
					ACTION_VALUE,
					SYSTEM_ACTION_VALUE,
					EXPENSE_ID,
					WITH_NEXT_ROW,
					BA.MULTI_ACTION_ID,
					BA.ACC_TYPE_ID,
					#dsn#.Get_Dynamic_Language(BA.ACTION_TYPE_ID,'#session.ep.language#','BANK_ACTIONS','BANK_ACTIONS.ACTION_TYPE',NULL,NULL,BA.ACTION_TYPE) AS ACTION_TYPE,
					PAPER_NO,
					ACTION_DETAIL,
					MASRAF,
					BA.ACTION_CURRENCY_ID,
					BA.OTHER_MONEY,
					OTHER_CASH_ACT_VALUE,
					BA.ACTION_DATE,
					BA.RECORD_DATE,
					BA.ACTION_TYPE_ID,
					BA.ACTION_FROM_CASH_ID,
					BA.ACTION_TO_CASH_ID,
					BA.ACTION_FROM_ACCOUNT_ID,
					BA.ACTION_TO_ACCOUNT_ID,
					BA.ACTION_FROM_COMPANY_ID,
					BA.ACTION_TO_COMPANY_ID,
					BA.ACTION_FROM_CONSUMER_ID,
					BA.ACTION_TO_CONSUMER_ID,
					BA.ACTION_FROM_EMPLOYEE_ID,
					BA.ACTION_TO_EMPLOYEE_ID,
					BA.PROCESS_CAT,
					BA.ACTION_ID,
					BA.CREDITCARD_ID,
					BA.OTHER_COST,
					PR.PROJECT_HEAD PROJECT,
					BR.BRANCH_NAME BRANCH,
					#dsn#.Get_Dynamic_Language(PC.PROCESS_CAT_ID,'#session.ep.language#','SETUP_PROCESS_CAT','PROCESS_CAT',NULL,NULL,PC.PROCESS_CAT) AS STAGE,
					(SELECT COUNT(ACTION_ID) FROM BANK_ACTIONS where MULTI_ACTION_ID IS NOT NULL AND MULTI_ACTION_ID = BA.MULTI_ACTION_ID) AS MULTI_COUNT,
					(SELECT SUM(ACTION_VALUE) FROM BANK_ACTIONS where MULTI_ACTION_ID IS NOT NULL AND MULTI_ACTION_ID = BA.MULTI_ACTION_ID) AS MULTI_VALUE,
					(SELECT SUM(SYSTEM_ACTION_VALUE) FROM BANK_ACTIONS where MULTI_ACTION_ID IS NOT NULL AND MULTI_ACTION_ID = BA.MULTI_ACTION_ID) AS MULTI_SYSTEM_VALUE
			FROM
				BANK_ACTIONS BA
				LEFT JOIN #dsn_alias#.PRO_PROJECTS PR ON BA.PROJECT_ID=PR.PROJECT_ID
				LEFT JOIN #dsn_alias#.BRANCH BR ON ISNULL(BA.FROM_BRANCH_ID,BA.TO_BRANCH_ID)=BR.BRANCH_ID AND BR.COMPANY_ID = #session.ep.company_id#
				LEFT JOIN #dsn3_alias#.SETUP_PROCESS_CAT PC ON PC.PROCESS_CAT_ID = BA.PROCESS_CAT
			<cfif isDefined("ACT_TYPE") and ListFind("240,253,250",ACT_TYPE)>
				,BANK_ACTIONS_MULTI BAM
			</cfif>
			WHERE
				BA.ACTION_ID > 0
				AND 
				(BA.ACTION_FROM_EMPLOYEE_ID IS NOT NULL OR 
				BA.ACTION_TO_EMPLOYEE_ID IS NOT NULL)
			<cfif isDefined("ACT_TYPE") and ListFind("240,253,250",ACT_TYPE)>
				AND BA.MULTI_ACTION_ID = BAM.MULTI_ACTION_ID
			</cfif>
			<cfif len(hr_type_list) or len(ehesap_type_list) or len(other_type_list)><!--- İk veya ehesap süper kullanıcı yetkisine bakılacak tip varsa --->
				AND
				(
					(
						#control_acc_type_list#
						<cfif (not module_power_user_hr or not module_power_user_ehesap) or isdefined("x_ehesap_records_show") and x_ehesap_records_show eq 0>
							AND ACTION_TYPE_ID NOT IN (25,250)
						</cfif>
					)
					<cfif (not module_power_user_hr or not module_power_user_ehesap) and isdefined("x_ehesap_records_show") and x_ehesap_records_show eq 1>
						OR (ACTION_TYPE_ID IN (25,250))
					</cfif>
					
				)
			<cfelseif not get_module_power_user(48)>
				AND BA.ACTION_TO_EMPLOYEE_ID IS NULL 
				AND BA.ACTION_FROM_EMPLOYEE_ID IS NULL
			</cfif>
			<cfif isDefined("ACT_TYPE") and len(ACT_TYPE) and isDefined("PROC_CAT") and len(PROC_CAT)>
				<cfif PROC_CAT eq 0>
					AND BA.ACTION_TYPE_ID IN (#ACT_TYPE#)
				<cfelseif PROC_CAT neq 0>
					AND BA.PROCESS_CAT = <cfqueryparam cfsqltype="cf_sql_integer" value="#PROC_CAT#">
				</cfif>
			</cfif>
			<cfif isDefined("attributes.keyword") and len(attributes.keyword)>
				AND
					(
						<cfif len(attributes.keyword) gt 3>
							BA.ACTION_TYPE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI
						<cfelse>
							BA.ACTION_TYPE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#"> COLLATE SQL_Latin1_General_CP1_CI_AI
						</cfif> OR
						<cfif len(attributes.keyword) gt 3>
							BA.PAPER_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI
						<cfelse>
							BA.PAPER_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI
						</cfif> OR
						<cfif len(attributes.keyword) gt 3>
							BA.ACTION_DETAIL LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI
						<cfelse>
							BA.ACTION_DETAIL LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI
						</cfif>
					)
			</cfif>
			<cfif isDefined("attributes.paper_number") and len(attributes.paper_number)>
				<cfif len(attributes.paper_number) gt 3>
					AND BA.PAPER_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.paper_number#%">
				<cfelse>
					AND BA.PAPER_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.paper_number#%">
				</cfif>
			</cfif>
			<cfif isDefined("attributes.ACCOUNT") and len(attributes.ACCOUNT)>
				AND 
					(
						BA.ACTION_FROM_ACCOUNT_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ACCOUNT#"> OR
						BA.ACTION_TO_ACCOUNT_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ACCOUNT#">
					)
			</cfif>
			<cfif len(attributes.date1)>
				AND BA.ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.DATE1#">
			</cfif>
			<cfif len(attributes.date2)>
				AND BA.ACTION_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#dateadd('d',1,attributes.DATE2)#">
			</cfif>
			<cfif isdate(attributes.record_date) and not isdate(attributes.record_date2)>
				AND BA.RECORD_DATE >= #attributes.record_date#
			<cfelseif isdate(attributes.record_date2) and not isdate(attributes.record_date)>
				AND BA.RECORD_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#dateadd('d',1,attributes.record_date2)#">
			<cfelseif isdate(attributes.record_date) and  isdate(attributes.record_date2)>
				AND BA.RECORD_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.record_date#"> AND BA.RECORD_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#dateadd('d',1,attributes.record_date2)#">
			</cfif>
			<cfif isdefined("attributes.record_emp_id") and len(attributes.record_emp_id) and isdefined("attributes.record_emp_name") and len(attributes.record_emp_name)>
				AND BA.RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.record_emp_id#">
			</cfif>
			<cfif isdefined("attributes.emp_id") and len(attributes.emp_id) and isdefined("attributes.emp_name") and len(attributes.emp_name)>
				AND (BA.ACTION_TO_EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#"> OR BA.ACTION_FROM_EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">)
			<cfelseif isdefined("attributes.search_type") and len(attributes.search_type) and (attributes.search_type is "partner") and len(attributes.emp_name) and isdefined("attributes.emp_name")>
				AND 
					(
						BA.ACTION_FROM_COMPANY_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.search_id#"> OR
						BA.ACTION_TO_COMPANY_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.search_id#"> 
					)
			<cfelseif isdefined("attributes.search_type") and len(attributes.search_type) and (attributes.search_type is "consumer") and len(attributes.emp_name) and isdefined("attributes.emp_name")>
				AND
					(	
						BA.ACTION_FROM_CONSUMER_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.search_id#"> OR
						BA.ACTION_TO_CONSUMER_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.search_id#">
					)
			</cfif>
			<cfif (isDefined("attributes.account_status") and len(attributes.account_status))>
				AND ((BA.ACTION_FROM_ACCOUNT_ID IN(SELECT ACCOUNT_ID FROM #dsn3_alias#.ACCOUNTS WHERE ACCOUNT_STATUS = <cfqueryparam cfsqltype="cf_sql_bit" value="#attributes.account_status#">)) OR (BA.ACTION_TO_ACCOUNT_ID IN(SELECT ACCOUNT_ID FROM #dsn3_alias#.ACCOUNTS WHERE ACCOUNT_STATUS = <cfqueryparam cfsqltype="cf_sql_bit" value="#attributes.account_status#">)))
			</cfif>
			<cfif isDefined("attributes.special_definition_id") and len(attributes.special_definition_id) and attributes.special_definition_id eq '-1'>
				AND BA.SPECIAL_DEFINITION_ID IN (SELECT SPECIAL_DEFINITION_ID FROM #dsn_alias#.SETUP_SPECIAL_DEFINITION WHERE SPECIAL_DEFINITION_TYPE = 1)
			<cfelseif isDefined("attributes.special_definition_id") and len(attributes.special_definition_id) and attributes.special_definition_id eq '-2'>
				AND BA.SPECIAL_DEFINITION_ID IN (SELECT SPECIAL_DEFINITION_ID FROM #dsn_alias#.SETUP_SPECIAL_DEFINITION WHERE SPECIAL_DEFINITION_TYPE = 2)
			<cfelseif isDefined("attributes.special_definition_id") and len(attributes.special_definition_id)>
				AND BA.SPECIAL_DEFINITION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.special_definition_id#">
			</cfif>
			<cfif (session.ep.isBranchAuthorization) or (isdefined('attributes.branch_id') and len(attributes.branch_id))>
				AND (
						(
							BA.ACTION_TYPE_ID = 21 AND<!--- Para yatırma işlemi için banka ve kasanın şubeye ait olmadığını kontrol ediyor --->
							BA.TO_BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#control_branch_id#"> AND
							BA.ACTION_FROM_CASH_ID IN (#cash_list#)
						) OR
						(
							BA.ACTION_TYPE_ID = 22 AND<!--- Para çekme işlemi için banka ve kasanın şubeye ait olmadığını kontrol ediyor --->
							BA.FROM_BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#control_branch_id#"> AND
							BA.ACTION_TO_CASH_ID IN (#cash_list#)
						) OR
						(
							BA.ACTION_TYPE_ID NOT IN (21,22<!--- ,23 --->) AND<!--- Diğer işlemlerde to veya from account_id ye bakmak yeterli --->
							(BA.FROM_BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#control_branch_id#"> OR
							BA.TO_BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#control_branch_id#">)
						)
					)
			</cfif>
			<cfif isdefined("attributes.action_bank") and attributes.action_bank eq 1>
				AND BA.ACTION_TO_ACCOUNT_ID IS NOT NULL
			<cfelseif isdefined("attributes.action_bank") and attributes.action_bank eq 0>
				AND BA.ACTION_FROM_ACCOUNT_ID IS NOT NULL
			</cfif>
			<cfif isdefined("attributes.acc_type_id") and len(attributes.acc_type_id)>
				AND BA.ACC_TYPE_ID = #attributes.acc_type_id#
			</cfif>
			<cfif isdefined("attributes.project_id") and len(attributes.project_head) and len(attributes.project_id)>
				AND BA.PROJECT_ID = #attributes.project_id#
			</cfif>
			UNION ALL
			SELECT
					ACTION_VALUE,
					SYSTEM_ACTION_VALUE,
					EXPENSE_ID,
					WITH_NEXT_ROW,
					BA.MULTI_ACTION_ID,
					BA.ACC_TYPE_ID,
					#dsn#.Get_Dynamic_Language(BA.ACTION_TYPE_ID,'#session.ep.language#','BANK_ACTIONS','BANK_ACTIONS.ACTION_TYPE',NULL,NULL,BA.ACTION_TYPE) AS ACTION_TYPE,
					PAPER_NO,
					ACTION_DETAIL,
					MASRAF,
					BA.ACTION_CURRENCY_ID,
					BA.OTHER_MONEY,
					OTHER_CASH_ACT_VALUE,
					BA.ACTION_DATE,
					BA.RECORD_DATE,
					BA.ACTION_TYPE_ID,
					BA.ACTION_FROM_CASH_ID,
					BA.ACTION_TO_CASH_ID,
					BA.ACTION_FROM_ACCOUNT_ID,
					BA.ACTION_TO_ACCOUNT_ID,
					BA.ACTION_FROM_COMPANY_ID,
					BA.ACTION_TO_COMPANY_ID,
					BA.ACTION_FROM_CONSUMER_ID,
					BA.ACTION_TO_CONSUMER_ID,
					BA.ACTION_FROM_EMPLOYEE_ID,
					BA.ACTION_TO_EMPLOYEE_ID,
					BA.PROCESS_CAT,
					BA.ACTION_ID,
					BA.CREDITCARD_ID,
					BA.OTHER_COST,
					PR.PROJECT_HEAD PROJECT,
					BR.BRANCH_NAME BRANCH,
					#dsn#.Get_Dynamic_Language(PC.PROCESS_CAT_ID,'#session.ep.language#','SETUP_PROCESS_CAT','PROCESS_CAT',NULL,NULL,PC.PROCESS_CAT) AS STAGE,
					(SELECT COUNT(ACTION_ID) FROM BANK_ACTIONS where MULTI_ACTION_ID IS NOT NULL AND MULTI_ACTION_ID = BA.MULTI_ACTION_ID) AS MULTI_COUNT,
					(SELECT SUM(ACTION_VALUE) FROM BANK_ACTIONS where MULTI_ACTION_ID IS NOT NULL AND MULTI_ACTION_ID = BA.MULTI_ACTION_ID) AS MULTI_VALUE,
					(SELECT SUM(SYSTEM_ACTION_VALUE) FROM BANK_ACTIONS where MULTI_ACTION_ID IS NOT NULL AND MULTI_ACTION_ID = BA.MULTI_ACTION_ID) AS MULTI_SYSTEM_VALUE
			FROM
				BANK_ACTIONS BA
				LEFT JOIN #dsn_alias#.PRO_PROJECTS PR ON BA.PROJECT_ID=PR.PROJECT_ID
				LEFT JOIN #dsn_alias#.BRANCH BR ON ISNULL(BA.FROM_BRANCH_ID,BA.TO_BRANCH_ID)=BR.BRANCH_ID AND BR.COMPANY_ID = #session.ep.company_id#
				LEFT JOIN #dsn3_alias#.SETUP_PROCESS_CAT PC ON PC.PROCESS_CAT_ID = BA.PROCESS_CAT
			<cfif isDefined("ACT_TYPE") and ListFind("240,253,250",ACT_TYPE)>
				,BANK_ACTIONS_MULTI BAM
			</cfif>
			WHERE
				BA.ACTION_ID > 0
				AND 
				(BA.ACTION_FROM_EMPLOYEE_ID IS NULL AND 
				BA.ACTION_TO_EMPLOYEE_ID IS NULL)
			<cfif isDefined("ACT_TYPE") and ListFind("240,253,250",ACT_TYPE)>
				AND BA.MULTI_ACTION_ID = BAM.MULTI_ACTION_ID
			</cfif>
			<cfif isDefined("ACT_TYPE") and len(ACT_TYPE) and isDefined("PROC_CAT") and len(PROC_CAT)>
				<cfif PROC_CAT eq 0>
					AND BA.ACTION_TYPE_ID IN (#ACT_TYPE#)
				<cfelseif PROC_CAT neq 0>
					AND BA.PROCESS_CAT = <cfqueryparam cfsqltype="cf_sql_integer" value="#PROC_CAT#">
				</cfif>
			</cfif>
			<cfif isDefined("attributes.keyword") and len(attributes.keyword)>
				AND
					(
						<cfif len(attributes.keyword) gt 3>
							BA.ACTION_TYPE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI
						<cfelse>
							BA.ACTION_TYPE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#"> COLLATE SQL_Latin1_General_CP1_CI_AI
						</cfif> OR
						<cfif len(attributes.keyword) gt 3>
							BA.PAPER_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI
						<cfelse>
							BA.PAPER_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI
						</cfif> OR
						<cfif len(attributes.keyword) gt 3>
							BA.ACTION_DETAIL LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI
						<cfelse>
							BA.ACTION_DETAIL LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI
						</cfif>
					)
			</cfif>
			<cfif isDefined("attributes.paper_number") and len(attributes.paper_number)>
				<cfif len(attributes.paper_number) gt 3>
					AND BA.PAPER_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.paper_number#%">
				<cfelse>
					AND BA.PAPER_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.paper_number#%">
				</cfif>
			</cfif>
			<cfif isDefined("attributes.ACCOUNT") and len(attributes.ACCOUNT)>
				AND 
					(
						BA.ACTION_FROM_ACCOUNT_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ACCOUNT#"> OR
						BA.ACTION_TO_ACCOUNT_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ACCOUNT#">
					)
			</cfif>
			<cfif len(attributes.date1)>
				AND BA.ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.DATE1#">
			</cfif>
			<cfif len(attributes.date2)>
				AND BA.ACTION_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#dateadd('d',1,attributes.DATE2)#">
			</cfif>
			<cfif isdate(attributes.record_date) and not isdate(attributes.record_date2)>
				AND BA.RECORD_DATE >= #attributes.record_date#
			<cfelseif isdate(attributes.record_date2) and not isdate(attributes.record_date)>
				AND BA.RECORD_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#dateadd('d',1,attributes.record_date2)#">
			<cfelseif isdate(attributes.record_date) and  isdate(attributes.record_date2)>
				AND BA.RECORD_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.record_date#"> AND BA.RECORD_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#dateadd('d',1,attributes.record_date2)#">
			</cfif>
			<cfif isdefined("attributes.record_emp_id") and len(attributes.record_emp_id) and isdefined("attributes.record_emp_name") and len(attributes.record_emp_name)>
				AND BA.RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.record_emp_id#">
			</cfif>
			<cfif isdefined("attributes.emp_id") and len(attributes.emp_id) and isdefined("attributes.emp_name") and len(attributes.emp_name)>
				AND (BA.ACTION_TO_EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#"> OR BA.ACTION_FROM_EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">)
			<cfelseif isdefined("attributes.search_type") and len(attributes.search_type) and (attributes.search_type is "partner") and len(attributes.emp_name) and isdefined("attributes.emp_name")>
				AND 
					(
						BA.ACTION_FROM_COMPANY_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.search_id#"> OR
						BA.ACTION_TO_COMPANY_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.search_id#"> 
					)
			<cfelseif isdefined("attributes.search_type") and len(attributes.search_type) and (attributes.search_type is "consumer") and len(attributes.emp_name) and isdefined("attributes.emp_name")>
				AND
					(	
						BA.ACTION_FROM_CONSUMER_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.search_id#"> OR
						BA.ACTION_TO_CONSUMER_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.search_id#">
					)
			</cfif>
			<cfif (isDefined("attributes.account_status") and len(attributes.account_status))>
				AND ((BA.ACTION_FROM_ACCOUNT_ID IN(SELECT ACCOUNT_ID FROM #dsn3_alias#.ACCOUNTS WHERE ACCOUNT_STATUS = <cfqueryparam cfsqltype="cf_sql_bit" value="#attributes.account_status#">)) OR (BA.ACTION_TO_ACCOUNT_ID IN(SELECT ACCOUNT_ID FROM #dsn3_alias#.ACCOUNTS WHERE ACCOUNT_STATUS = <cfqueryparam cfsqltype="cf_sql_bit" value="#attributes.account_status#">)))
			</cfif>
			<cfif isDefined("attributes.special_definition_id") and len(attributes.special_definition_id) and attributes.special_definition_id eq '-1'>
				AND BA.SPECIAL_DEFINITION_ID IN (SELECT SPECIAL_DEFINITION_ID FROM #dsn_alias#.SETUP_SPECIAL_DEFINITION WHERE SPECIAL_DEFINITION_TYPE = 1)
			<cfelseif isDefined("attributes.special_definition_id") and len(attributes.special_definition_id) and attributes.special_definition_id eq '-2'>
				AND BA.SPECIAL_DEFINITION_ID IN (SELECT SPECIAL_DEFINITION_ID FROM #dsn_alias#.SETUP_SPECIAL_DEFINITION WHERE SPECIAL_DEFINITION_TYPE = 2)
			<cfelseif isDefined("attributes.special_definition_id") and len(attributes.special_definition_id)>
				AND BA.SPECIAL_DEFINITION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.special_definition_id#">
			</cfif>
			<cfif (session.ep.isBranchAuthorization) or (isdefined('attributes.branch_id') and len(attributes.branch_id))>
				AND (
						(
							BA.ACTION_TYPE_ID = 21 AND<!--- Para yatırma işlemi için banka ve kasanın şubeye ait olmadığını kontrol ediyor --->
							BA.TO_BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#control_branch_id#"> AND
							BA.ACTION_FROM_CASH_ID IN (#cash_list#)
						) OR
						(
							BA.ACTION_TYPE_ID = 22 AND<!--- Para çekme işlemi için banka ve kasanın şubeye ait olmadığını kontrol ediyor --->
							BA.FROM_BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#control_branch_id#"> AND
							BA.ACTION_TO_CASH_ID IN (#cash_list#)
						) OR
						(
							BA.ACTION_TYPE_ID NOT IN (21,22<!--- ,23 --->) AND<!--- Diğer işlemlerde to veya from account_id ye bakmak yeterli --->
							(BA.FROM_BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#control_branch_id#"> OR
							BA.TO_BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#control_branch_id#">)
						)
					)
			</cfif>
			<cfif isdefined("attributes.action_bank") and attributes.action_bank eq 1>
				AND BA.ACTION_TO_ACCOUNT_ID IS NOT NULL
			<cfelseif isdefined("attributes.action_bank") and attributes.action_bank eq 0>
				AND BA.ACTION_FROM_ACCOUNT_ID IS NOT NULL
			</cfif>
			<cfif isdefined("attributes.acc_type_id") and len(attributes.acc_type_id)>
				AND BA.ACC_TYPE_ID = #attributes.acc_type_id#
			</cfif>
			<cfif isdefined("attributes.project_id") and len(attributes.project_head) and len(attributes.project_id)>
				AND BA.PROJECT_ID = #attributes.project_id#
			</cfif>
		) T
			ORDER BY 
			<cfif isDefined('attributes.oby') and attributes.oby eq 2>
				ACTION_DATE,
				RECORD_DATE,
			<cfelseif isDefined('attributes.oby') and attributes.oby eq 3>
				CASE WHEN (CHARINDEX('-',PAPER_NO) = 0) THEN PAPER_NO ELSE CAST(SUBSTRING(PAPER_NO, (CHARINDEX('-', PAPER_NO) +1), LEN(PAPER_NO) ) as int) END asc,
			<cfelseif isDefined('attributes.oby') and attributes.oby eq 4>
				CASE WHEN (CHARINDEX('-',PAPER_NO) = 0) THEN PAPER_NO ELSE CAST(SUBSTRING(PAPER_NO, (CHARINDEX('-', PAPER_NO) +1), LEN(PAPER_NO) ) as int) END desc,
			<cfelse>
				ACTION_DATE DESC,
				RECORD_DATE DESC,
			</cfif>
				ACTION_ID DESC
</cfquery>