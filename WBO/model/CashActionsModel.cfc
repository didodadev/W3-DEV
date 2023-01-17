<!-----------------------------------------------------------------------
*************************************************************************
		Copyright Workcube E-Business Inc. www.workcube.com
*************************************************************************
Analys		: Fatih Ayık			Developer	: Deniz Taşdemir		
Analys Date : 01/04/2016			Dev Date	: 30/05/2016		
Description :
	Bu component CASH_ACTIONS tablosuna ait CRUD ve list fonksiyonlarını gerceklestirir.
----------------------------------------------------------------------->

<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
	<cfset dsn2 = '#dsn#_#session.ep.period_year#_#session.ep.company_id#'>
    <cfset dsn3 = '#dsn#_#session.ep.company_id#'>
	<cfinclude template="../fbx_workcube_funcs.cfm">
   
    <!--- list --->
    <cffunction name="list" access="remote" returntype="string" returnformat="plain">
    	<cfargument name="id" default="0" type="numeric"  required="yes" hint="Data ID">
        <cfargument name="acc_type_id" default="0" type="numeric"  required="yes" hint="Data ID">
        <cfargument name="employee_id" default="0" type="numeric"  required="yes" hint="Data ID">
        <cfargument name="emp_id" default="0" type="numeric"  required="yes" hint="Data ID">
        <cfargument name="record_date" default="0" type="date"  required="yes" hint="Data ID">
        <cfargument name="record_date2" default="0" type="date"  required="yes" hint="Data ID">
        <cfargument name="start_date" default="0" type="date"  required="yes" hint="Data ID">
        <cfargument name="finish_date" default="0" type="date"  required="yes" hint="Data ID">
        <cfargument name="page_action_type" default="0" type="numeric"  required="yes" hint="Data ID">
        <cfargument name="company_id" default="0" type="numeric"  required="yes" hint="Data ID">
        <cfargument name="consumer_id" default="0" type="numeric"  required="yes" hint="Data ID">
        <cfargument name="member_type" default="" type="string"  required="yes" hint="Data ID">
        <cfargument name="company" default="" type="string"  required="yes" hint="Data ID">
        <cfargument name="record_emp_id" default="0" type="numeric"  required="yes" hint="Data ID">
        <cfargument name="record_emp_name" default="" type="string"  required="yes" hint="Data ID">
        <cfargument name="keyword" default="" type="string"  required="yes" hint="Data ID">
        <cfargument name="paper_number"  default="" type="string"  required="yes" hint="Data ID">
        <cfargument name="cash" default="0" type="numeric"  required="yes" hint="Data ID">
        <cfargument name="action" default="0" type="numeric"  required="yes" hint="Data ID">
        <cfargument name="special_definition_id" default="0" type="numeric"  required="yes" hint="Data ID">
        <cfargument name="branch_id" default="0" type="numeric"  required="yes" hint="Data ID">
        <cfargument name="cash_status" default="-1" type="numeric"  required="yes" hint="Data ID">
        <cfargument name="action_cash" default="0" type="numeric"  required="yes" hint="Data ID">
        <cfargument name="project_head" default="" type="string"  required="yes" hint="Data ID">
        <cfargument name="project_id" default="0" type="numeric"  required="yes" hint="Data ID">
        <cfargument name="oby" default="0" type="numeric"  required="yes" hint="Data ID">
        <cfargument name="is_total" default="" type="string"  required="yes" hint="Data ID">
        <cfargument name="sortField" type="string" default="ACTION_ID" required="no" hint="Taşı">
        <cfargument name="sortType" type="string" default="DESC" required="no" hint="Sıralama Türü">
        <cfargument name="maxrows" type="numeric" default="0" required="no" hint="Sayfalama : Sayfa başına satır sayısı">
        <cfargument name="pagenum" type="numeric" default="0" required="no" hint="Sayfalama : Sayfa no">
        <cfargument name="module_power_user_ehesap" type="boolean" default="false"/>  
        
        <cfinclude template="../objects/query/get_acc_types.cfm">
        
        <cfif isDefined("arguments.page_action_type") and len(arguments.page_action_type)>
            <cfset ACT_TYPE = ListFirst(arguments.page_action_type,'-')>
            <cfset PROC_CAT = ListLast(arguments.page_action_type,'-')>
            <cfif ACT_TYPE eq 310>
                <cfset ACT_TYPE = '31'>
            <cfelseif ACT_TYPE eq 320>
                <cfset ACT_TYPE = '32'>
            </cfif>
        </cfif>
        <cfquery name="list" datasource="#dsn2#">
            WITH CTE1 AS (
                SELECT
                    CASE WHEN CA.CASH_ACTION_TO_CASH_ID IS NOT NULL THEN CA.CASH_ACTION_VALUE ELSE '' END AS DEBT,
                    CASE WHEN CA.CASH_ACTION_TO_CASH_ID IS NOT NULL THEN CA.CASH_ACTION_CURRENCY_ID ELSE '' END AS DEBT_CURR,
                    CASE WHEN CA.CASH_ACTION_FROM_CASH_ID IS NOT NULL THEN CA.CASH_ACTION_VALUE ELSE '' END AS CLAIM,
                    CASE WHEN CA.CASH_ACTION_FROM_CASH_ID IS NOT NULL THEN CA.CASH_ACTION_CURRENCY_ID ELSE '' END AS CLAIM_CURR,
                    CA.EXPENSE_ID,
                    CA.MULTI_ACTION_ID,
                    CA.ACTION_TYPE,
                    CA.ACTION_TYPE_ID,
                    CA.ACTION_ID,
                    CA.PAPER_NO,
                    CA.BANK_ACTION_ID,
                    CA.ACTION_DATE,
                    C.CASH_NAME + '-' + C.CASH_CURRENCY_ID CASH,
                    CMP.FULLNAME COMPANY,
                    CMP.COMPANY_ID COMP_ID,
                    EMP.EMPLOYEE_NAME + ' ' + EMP.EMPLOYEE_SURNAME EMPLOYEE,
                    EMP.EMPLOYEE_ID EMP_ID,
                    CNS.CONSUMER_NAME + ' ' + CNS.CONSUMER_SURNAME CONSUMER,
                    ISNULL(CMP.FULLNAME,ISNULL(CNS.CONSUMER_NAME + ' ' + CNS.CONSUMER_SURNAME,EMP.EMPLOYEE_NAME + ' ' + EMP.EMPLOYEE_SURNAME)) AS CARI,
                    CNS.CONSUMER_ID CONS_ID,
                    AC.ACCOUNT_NAME ACCOUNT,
                    EI.EXPENSE_ITEM_NAME EXPENSE_ITEM,
                    CA.CASH_ACTION_CURRENCY_ID,
                    CA.CASH_ACTION_VALUE,
                    CA.PAYROLL_ID,
                    CA.PROCESS_CAT,
                    CA.OTHER_MONEY,
                    CA.OTHER_CASH_ACT_VALUE,
                    CA.ORDER_ID,
                    REC_EMP.EMPLOYEE_NAME + ' ' + REC_EMP.EMPLOYEE_SURNAME RECORD_EMP,
                    REC_EMP.EMPLOYEE_ID REC_EMP_ID,
                    CA.RECORD_DATE,
                    CA.ACTION_DETAIL,
                    CA.CASH_ACTION_FROM_CASH_ID,
                    CA.CASH_ACTION_TO_CASH_ID,
                    CA.VOUCHER_ID,
                    CA.ACTION_VALUE SYSTEM_ACTION_VALUE,
                    CA.BILL_ID,
                    ISNULL(CA.WITH_NEXT_ROW,0) WITH_NEXT_ROW,
                    PR.PROJECT_HEAD AS PROJECT,
                    BR.BRANCH_NAME BRANCH,
                     ROW_NUMBER() OVER (
                    	<cfif len(sortField) and len(sortType)>
	                    	ORDER BY #arguments.sortField# #arguments.sortType#
                        <cfelse>
                        	ORDER BY (SELECT 0)
                        </cfif>
                    ) AS ROWNUM
                    <cf_extendedFields type="1" controllerFileName="cashActions" selectClause="1" mainTableAlias="CA">
                FROM
                    #dsn2#.CASH_ACTIONS CA
                    LEFT JOIN #dsn#.PRO_PROJECTS PR ON CA.PROJECT_ID=PR.PROJECT_ID
                    LEFT JOIN #dsn2#.CASH C ON ISNULL(CA.CASH_ACTION_FROM_CASH_ID,CA.CASH_ACTION_TO_CASH_ID)=C.CASH_ID
                    LEFT JOIN #dsn#.BRANCH BR ON C.BRANCH_ID=BR.BRANCH_ID
                    LEFT JOIN #dsn#.COMPANY CMP ON ISNULL(CA.CASH_ACTION_FROM_COMPANY_ID,CA.CASH_ACTION_TO_COMPANY_ID) = CMP.COMPANY_ID
                    LEFT JOIN #dsn#.CONSUMER CNS ON ISNULL(CA.CASH_ACTION_FROM_CONSUMER_ID,CA.CASH_ACTION_TO_CONSUMER_ID) = CNS.CONSUMER_ID
                    LEFT JOIN #dsn#.EMPLOYEES EMP ON ISNULL(CA.CASH_ACTION_FROM_EMPLOYEE_ID,CA.CASH_ACTION_TO_EMPLOYEE_ID) = EMP.EMPLOYEE_ID
                    LEFT JOIN #dsn2#.EXPENSE_ITEMS EI ON CA.EXPENSE_ITEM_ID=EI.EXPENSE_ITEM_ID
                    LEFT JOIN #dsn3#.ACCOUNTS AC ON ISNULL(CA.CASH_ACTION_FROM_ACCOUNT_ID,CA.CASH_ACTION_TO_ACCOUNT_ID) = AC.ACCOUNT_ID
                    LEFT JOIN #dsn#.EMPLOYEES REC_EMP ON CA.RECORD_EMP = REC_EMP.EMPLOYEE_ID
                    <cfif isDefined("ACT_TYPE") and  (ACT_TYPE eq 310 or ACT_TYPE eq 320)>
                    ,CASH_ACTIONS_MULTI CAM
                    </cfif>
                WHERE
                    CA.ACTION_ID IS NOT NULL	
                <cfif isDefined("ACT_TYPE") and  (ACT_TYPE eq 310 or ACT_TYPE eq 320)>
                    AND CA.MULTI_ACTION_ID = CAM.MULTI_ACTION_ID
                </cfif>
                <cfif len(hr_type_list) or len(ehesap_type_list) or len(other_type_list)><!--- İk veya ehesap süper kullanıcı yetkisine bakılacak tip varsa --->
                    AND #control_acc_type_list#
                <cfelseif not module_power_user_ehesap>
                    AND CA.CASH_ACTION_TO_EMPLOYEE_ID IS NULL
                    AND CA.CASH_ACTION_FROM_EMPLOYEE_ID IS NULL
                </cfif>
                <cfif arguments.employee_id neq 0 and len(arguments.company) and arguments.member_type eq 'employee'>
                    AND (CA.CASH_ACTION_FROM_EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.emp_id#"> OR CA.CASH_ACTION_TO_EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.emp_id#">)
                </cfif>
                <cfif arguments.company_id neq 0  and len(arguments.company) and arguments.member_type eq 'partner'>
                    AND (CA.CASH_ACTION_FROM_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#"> OR CA.CASH_ACTION_TO_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#">)
                </cfif>		
                <cfif arguments.consumer_id neq 0 and len(arguments.company) and arguments.member_type eq 'consumer'>
                    AND (CA.CASH_ACTION_FROM_CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.consumer_id#"> OR CA.CASH_ACTION_TO_CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.consumer_id#">)
                </cfif>	
                <cfif arguments.record_emp_id neq 0  and len(arguments.record_emp_name)>
                    AND CA.RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.record_emp_id#">
                </cfif>	
                <cfif ACT_TYPE neq 0 and len(ACT_TYPE) and PROC_CAT neq 0 and len(PROC_CAT)>
                    <cfif PROC_CAT eq 0>
                        AND CA.ACTION_TYPE_ID IN (#ACT_TYPE#)
                    <cfelseif PROC_CAT neq 0>
                        AND CA.PROCESS_CAT = <cfqueryparam cfsqltype="cf_sql_integer" value="#PROC_CAT#">
                    </cfif>
                </cfif>
                <cfif len(arguments.keyword)>
                    <cfif len(arguments.keyword) gt 3>
                        AND CA.ACTION_DETAIL LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%">
                    <cfelse>
                        AND CA.ACTION_DETAIL LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.keyword#%">
                    </cfif>
                </cfif>
                <cfif  len(arguments.paper_number)>
                    AND (CA.PAPER_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.paper_number#%">)
                </cfif>
                <cfif arguments.cash neq 0 >
                    AND
                    (
                    <cfif isdefined("arguments.action") and listfind('32,34,36',arguments.action,',')>
                        CA.CASH_ACTION_FROM_CASH_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.cash#">
                    <cfelseif listfind('31,33,35',arguments.action,',')> 
                        CA.CASH_ACTION_TO_CASH_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.cash#">
                    <cfelse>
                        CA.CASH_ACTION_FROM_CASH_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.cash#"> OR
                        CA.CASH_ACTION_TO_CASH_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.cash#">
                    </cfif>
                    )
                </cfif>
                <cfif arguments.special_definition_id neq 0  and arguments.special_definition_id eq '-1'>
                    AND CA.SPECIAL_DEFINITION_ID IN (SELECT SPECIAL_DEFINITION_ID FROM #dsn_alias#.SETUP_SPECIAL_DEFINITION WHERE SPECIAL_DEFINITION_TYPE = 1)
                <cfelseif arguments.special_definition_id neq 0   and arguments.special_definition_id eq '-2'>
                    AND CA.SPECIAL_DEFINITION_ID IN (SELECT SPECIAL_DEFINITION_ID FROM #dsn_alias#.SETUP_SPECIAL_DEFINITION WHERE SPECIAL_DEFINITION_TYPE = 2)
                <cfelseif arguments.special_definition_id neq 0 >
                    AND CA.SPECIAL_DEFINITION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.special_definition_id#">
                </cfif>
                <cfif arguments.start_date neq 0 and  isdate(arguments.start_date) and not isdate(arguments.finish_date)>
                    AND CA.ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.start_date#">
                <cfelseif arguments.finish_date neq 0 and isdate(arguments.finish_date) and not isdate(arguments.start_date)>
                    AND CA.ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.finish#">
                <cfelseif arguments.finish_date neq 0 and arguments.finish_date neq 0 and isdate(arguments.start_date) and  isdate(arguments.finish_date)>
                    AND CA.ACTION_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.start_date#"> AND <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.finish_date#">
                </cfif>
                <cfif arguments.record_date neq 0 and  isdate(arguments.record_date) and not isdate(arguments.record_date2)>
                    AND CA.RECORD_DATE >= <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.record_date#">
                <cfelseif arguments.record_date2 neq 0 and isdate(arguments.record_date2) and not isdate(arguments.record_date)>
                    AND CA.RECORD_DATE <= #DATEADD("d",1,arguments.record_date2)#
                <cfelseif  arguments.record_date2 neq 0 and arguments.record_date neq 0 and isdate(arguments.record_date) and  isdate(arguments.record_date2)>
                    AND CA.RECORD_DATE >= <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.record_date#"> AND CA.RECORD_DATE <= #DATEADD("d",1,arguments.record_date2)#
                </cfif>
                <cfif (session.ep.isBranchAuthorization) or (arguments.branch_id neq 0 and len(arguments.branch_id)) >
                    AND (
                            (CA.CASH_ACTION_FROM_CASH_ID IN (SELECT CASH_ID FROM CASH WHERE BRANCH_ID = <cfif isdefined('arguments.branch_id') and len(arguments.branch_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.branch_id#"><cfelse>#ListGetAt(session.ep.user_location,2,"-")#</cfif>) OR
                            CA.CASH_ACTION_TO_CASH_ID IN (SELECT CASH_ID FROM CASH WHERE BRANCH_ID = <cfif isdefined('arguments.branch_id') and len(arguments.branch_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.branch_id#"><cfelse>#ListGetAt(session.ep.user_location,2,"-")#</cfif>))
                        )
                </cfif>
                <cfif (arguments.cash_status neq -1 )>
                    AND ((CA.CASH_ACTION_FROM_CASH_ID IN(SELECT CASH_ID FROM CASH WHERE CASH_STATUS = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.cash_status#">)) OR (CA.CASH_ACTION_TO_CASH_ID IN(SELECT CASH_ID FROM CASH WHERE CASH_STATUS = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.cash_status#">)))
                </cfif>
                <cfif arguments.action_cash neq -1 and arguments.action_cash eq 1>
                    AND CA.CASH_ACTION_TO_CASH_ID IS NOT NULL
                <cfelseif arguments.action_cash neq -1 and arguments.action_cash eq 0>
                    AND CA.CASH_ACTION_FROM_CASH_ID IS NOT NULL
                </cfif>
                <cfif arguments.acc_type_id neq 0 >
                    AND CA.ACC_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.acc_type_id#">
                </cfif>
                <cfif len(arguments.project_head) and arguments.project_id neq 0 >
                    AND CA.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.project_id#">
                </cfif>
                <cf_extendedFields type="1" controllerFileName="cashActions" whereClause="1" mainTableAlias="CA">
                ),
                    CTE2 AS (
                    SELECT
                        SUM(CTE1.DEBT-CTE1.CLAIM) OVER (ORDER BY ACTION_DATE, RECORD_DATE,ACTION_ID DESC ) AS CUM_TOTAL,
                        CTE1.*,
                        (SELECT COUNT(*) FROM CTE1) AS QUERY_COUNT
                    FROM
                        CTE1
                )
                <cfif isdefined("arguments.is_total") and len(arguments.is_total)>
                    ,CTE3 AS(
                        SELECT
                            SUM(DEBT) DEBT_TOTAL,
                            DEBT_CURR
                        FROM
                            CTE2
                        GROUP BY
                            DEBT_CURR
                    ),
                    CTE4 AS (
                        SELECT
                            SUM(CLAIM) CLAIM_TOTAL,
                            CLAIM_CURR
                        FROM
                            CTE2
                        GROUP BY
                            CLAIM_CURR
                    )
                    SELECT
                        CTE3.*,
                        CTE4.*,
                        ISNULL(DEBT_TOTAL,0)-ISNULL(CLAIM_TOTAL,0) AS TOTAL
                    FROM
                        CTE3 FULL JOIN CTE4 ON CTE3.DEBT_CURR = CTE4.CLAIM_CURR
                    WHERE
                        CTE3.DEBT_TOTAL != 0 OR CTE4.CLAIM_TOTAL !=0
                        <cfif maxrows gt 0>
                            AND ROWNUM BETWEEN #pagenum * maxrows + 1# AND #(pagenum + 1) * maxrows#
                        </cfif>
                <cfelse>
                     SELECT
                            CTE2.*,
                			(SELECT COUNT(*) FROM CTE1) AS TOTALROWS
                        FROM
                            CTE2
                        WHERE
                            1 = 1
							<cfif maxrows gt 0>
                                AND ROWNUM BETWEEN #pagenum * maxrows + 1# AND #(pagenum + 1) * maxrows#
                            </cfif>
         		</cfif>
                
        </cfquery>
        
        <cfreturn SerializeJQXFormat(list)>
    </cffunction>
    
    <!--- get --->
    <cffunction name="get" access="remote" returntype="query">
    	<cfargument name="id" default="0" type="numeric"  required="yes" hint="Data ID">
        <cfquery name="get" datasource="#dsn2#">
            WITH CTE1 AS (
                SELECT
                    CASE WHEN CA.CASH_ACTION_TO_CASH_ID IS NOT NULL THEN CA.CASH_ACTION_VALUE ELSE '' END AS DEBT,
                    CASE WHEN CA.CASH_ACTION_TO_CASH_ID IS NOT NULL THEN CA.CASH_ACTION_CURRENCY_ID ELSE '' END AS DEBT_CURR,
                    CASE WHEN CA.CASH_ACTION_FROM_CASH_ID IS NOT NULL THEN CA.CASH_ACTION_VALUE ELSE '' END AS CLAIM,
                    CASE WHEN CA.CASH_ACTION_FROM_CASH_ID IS NOT NULL THEN CA.CASH_ACTION_CURRENCY_ID ELSE '' END AS CLAIM_CURR,
                    CA.EXPENSE_ID,
                    CA.MULTI_ACTION_ID,
                    CA.ACTION_TYPE,
                    CA.ACTION_TYPE_ID,
                    CA.ACTION_ID,
                    CA.PAPER_NO,
                    CA.BANK_ACTION_ID,
                    CA.ACTION_DATE,
                    CMP.FULLNAME COMPANY,
                    CMP.COMPANY_ID COMP_ID,
                    EMP.EMPLOYEE_NAME + ' ' + EMP.EMPLOYEE_SURNAME EMPLOYEE,
                    EMP.EMPLOYEE_ID EMP_ID,
                    CNS.CONSUMER_NAME + ' ' + CNS.CONSUMER_SURNAME CONSUMER,
                    ISNULL(CMP.FULLNAME,ISNULL(CNS.CONSUMER_NAME + ' ' + CNS.CONSUMER_SURNAME,EMP.EMPLOYEE_NAME + ' ' + EMP.EMPLOYEE_SURNAME)) AS CARI
                    CNS.CONSUMER_ID CONS_ID,
                    CA.CASH_ACTION_CURRENCY_ID,
                    CA.CASH_ACTION_VALUE,
                    CA.PAYROLL_ID,
                    CA.PROCESS_CAT,
                    CA.OTHER_MONEY,
                    CA.OTHER_CASH_ACT_VALUE,
                    CA.ORDER_ID,
                    CA.RECORD_DATE,
                    CA.ACTION_DETAIL,
                    CA.CASH_ACTION_FROM_CASH_ID,
                    CA.CASH_ACTION_TO_CASH_ID,
                    CA.VOUCHER_ID,
                    CA.ACTION_VALUE SYSTEM_ACTION_VALUE,
                    CA.BILL_ID
                FROM
                    CASH_ACTIONS CA
                    LEFT JOIN #dsn#.COMPANY CMP ON ISNULL(CA.CASH_ACTION_FROM_COMPANY_ID,CA.CASH_ACTION_TO_COMPANY_ID) = CMP.COMPANY_ID
                    LEFT JOIN #dsn#.CONSUMER CNS ON ISNULL(CA.CASH_ACTION_FROM_CONSUMER_ID,CA.CASH_ACTION_TO_CONSUMER_ID) = CNS.CONSUMER_ID
                    LEFT JOIN #dsn#.EMPLOYEES EMP ON ISNULL(CA.CASH_ACTION_FROM_EMPLOYEE_ID,CA.CASH_ACTION_TO_EMPLOYEE_ID) = EMP.EMPLOYEE_ID
                WHERE
                    CA.ACTION_ID =<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.id#">
                    <cfif session.ep.isBranchAuthorization >
                        AND	(TO_BRANCH_ID IN (SELECT BRANCH_ID FROM #dsn#.EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">) OR FROM_BRANCH_ID IN (SELECT BRANCH_ID FROM #dsn#.EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">))
                    </cfif>
                
        </cfquery>
        <cfreturn get>
    </cffunction>
    <!--- add --->
    <cffunction name="add" access="public" returntype="numeric">
    	<cfargument name="process_cat" type="numeric"  required="yes" hint="işlem Kategorisi">
        <cfargument name="action_type" type="string"  default="" required="yes" hint="İşlem Açıklama">
        <cfargument name="process_type" type="numeric" required="yes" hint="işlem Tipi">
        <cfargument name="action_value" type="numeric" default="0" required="yes" hint="Tutar">
    	<cfargument name="currency_id" type="string" default="0" required="yes" hint="Para Birimi">
        <cfargument name="action_date" type="string" default="" required="yes" hint="İşlem Tarihi">
        <cfargument name="from_account_id" type="numeric" default="0" required="yes" hint="Hesap ID">
        <cfargument name="to_account_id" type="numeric" default="0" required="yes" hint="Hesap ID">
        <cfargument name="TO_CASH_ID" type="numeric" default="0" required="yes" hint="Kasa ID">
        <cfargument name="FROM_CASH_ID" type="numeric" default="0" required="yes" hint="Kasa ID">
        <cfargument name="EMPLOYEE_ID" type="numeric" default="0" required="yes" hint="Çalışan ID">
        <cfargument name="action_detail" type="string" default="" required="no" hint="Açıklama">
        <cfargument name="other_cash_act_value" type="numeric" default="0" required="no" hint="Dövizli Tutar">
        <cfargument name="money_type" type="string" default="" required="no" hint="Döviz Para Birimi">
        <cfargument name="is_account" type="numeric" default="-1" required="yes" hint="Muahasebe İşlemi Yapıyor Mu">
        <cfargument name="is_account_type" type="numeric"  required="yes" hint="Muahasebe İşlemi Yapıyor Mu">
        <cfargument name="paper_number" type="string" required="no" hint="Belge No">
        <cfargument name="to_branch_id" type="numeric" default="0" required="yes" hint="Şube ID">
    	<cfargument name="from_branch_id" type="numeric" default="0" required="yes" hint="Şube ID">
        <cfargument name="system_amount" type="numeric" default="0" required="yes" hint="Sistem Tutarı">
        <cfargument name="action_value2" type="numeric" default="0" required="yes" hint="İşlem Para Birimi">
    	<cfargument name="payer_id" type="numeric"  default="0" required="yes" hint="işlem Kategorisi">
        <cfargument name="bank_action_id" type="numeric" default="0" required="no" hint="işlem Kategorisi">
       
        <cfquery name="add" datasource="#dsn2#" result="MAX_ID">
            INSERT INTO
                CASH_ACTIONS
                (
                    PROCESS_CAT,
                    ACTION_TYPE,
                    ACTION_TYPE_ID,
                    CASH_ACTION_VALUE,
                    CASH_ACTION_CURRENCY_ID,
                    ACTION_DATE,
                    CASH_ACTION_FROM_ACCOUNT_ID,
                    CASH_ACTION_TO_ACCOUNT_ID,
                    CASH_ACTION_TO_CASH_ID,
                    CASH_ACTION_FROM_CASH_ID,
                    REVENUE_COLLECTOR_ID,
                    PAYER_ID,
                    BANK_ACTION_ID,
                    ACTION_DETAIL,
                    OTHER_CASH_ACT_VALUE,
                    OTHER_MONEY,
                    IS_ACCOUNT,
                    IS_ACCOUNT_TYPE,
                    PAPER_NO,
                    RECORD_EMP,
                    RECORD_IP,
                    RECORD_DATE,
                    ACTION_VALUE,
                    ACTION_CURRENCY_ID
                    <cfif len(session.ep.money2)>
                        ,ACTION_VALUE_2
                        ,ACTION_CURRENCY_ID_2
                    </cfif>
                )
                VALUES
                (
                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.process_cat#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.action_type#">,
                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.process_type#">,
                    <cfqueryparam cfsqltype="cf_sql_numeric" null="#arguments.action_value eq 0#" value="#arguments.action_value#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" null="#not len(arguments.currency_id)#" value="#arguments.currency_id#">,
                    <cfif len(arguments.ACTION_DATE)>#arguments.ACTION_DATE#</cfif>,
                    <cfqueryparam cfsqltype="cf_sql_numeric" null="#arguments.from_account_id eq 0#"  value="#arguments.from_account_id#">,
                    <cfqueryparam cfsqltype="cf_sql_numeric" null="#arguments.to_account_id eq 0#"  value="#arguments.to_account_id#">,
                    <cfqueryparam cfsqltype="cf_sql_numeric" null="#arguments.TO_CASH_ID eq 0#"  value="#arguments.TO_CASH_ID#">,
                    <cfqueryparam cfsqltype="cf_sql_numeric" null="#arguments.FROM_CASH_ID eq 0#"  value="#arguments.FROM_CASH_ID#">,
                    <cfqueryparam cfsqltype="cf_sql_numeric" null="#arguments.EMPLOYEE_ID eq 0#"  value="#arguments.EMPLOYEE_ID#">,
                    <cfqueryparam cfsqltype="cf_sql_numeric" null="#arguments.payer_id eq 0#"  value="#arguments.payer_id#">,
                    <cfqueryparam cfsqltype="cf_sql_numeric" null="#arguments.bank_action_id eq 0#"  value="#arguments.bank_action_id#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" null="#not len(arguments.ACTION_DETAIL)#" value="#arguments.ACTION_DETAIL#">,
                    <cfqueryparam cfsqltype="cf_sql_float" null="#arguments.OTHER_CASH_ACT_VALUE eq 0#"  value="#arguments.OTHER_CASH_ACT_VALUE#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" null="#not len(arguments.money_type)#"  value="#arguments.money_type#">,
                    <cfif is_account neq -1><cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.is_account#">,<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.is_account_type#">,</cfif>
                    <cfqueryparam cfsqltype="cf_sql_varchar" null="#not len(arguments.paper_number)#"  value="#arguments.paper_number#">,
                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#SESSION.EP.USERID#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">,
                    <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
                    <cfqueryparam cfsqltype="cf_sql_numeric" null="#arguments.system_amount eq 0#"  value="#arguments.system_amount#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money#">
                    <cfif len(session.ep.money2)>
                        ,<cfqueryparam cfsqltype="cf_sql_numeric" null="#arguments.currency_multiplier eq 0#"  value="#arguments.currency_multiplier#">
                        ,<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money2#">
                    </cfif>		
                )
        </cfquery>
        <cfreturn MAX_ID.IDENTITYCOL>
    </cffunction>
    
    <!--- upd --->
    <cffunction name="upd" access="public" returntype="numeric">
    	<cfargument name="id" default="0" type="numeric"  required="yes" hint="Data ID">
    	<cfargument name="process_cat" type="numeric"  required="yes" hint="işlem Kategorisi">
        <cfargument name="process_type" type="numeric" required="yes" hint="işlem Tipi">
        <cfargument name="action_value" type="numeric" default="0" required="yes" hint="Tutar">
    	<cfargument name="currency_id" type="string" default="0" required="yes" hint="Para Birimi">
        <cfargument name="action_date" type="string" default="0" required="yes" hint="İşlem Tarihi">
        <cfargument name="from_account_id" type="numeric" default="0" required="yes" hint="Hesap ID">
        <cfargument name="to_account_id" type="numeric" default="0" required="yes" hint="Hesap ID">
        <cfargument name="TO_CASH_ID" type="numeric" default="0" required="yes" hint="Kasa ID">
        <cfargument name="FROM_CASH_ID" type="numeric" default="0" required="yes" hint="Kasa ID">
        <cfargument name="EMPLOYEE_ID" type="numeric" default="0" required="yes" hint="Çalışan ID">
        <cfargument name="action_detail" type="string" default="" required="no" hint="Açıklama">
        <cfargument name="other_cash_act_value" type="numeric" default="0" required="no" hint="Dövizli Tutar">
        <cfargument name="money_type" type="string" default="" required="no" hint="Döviz Para Birimi">
        <cfargument name="is_account" type="numeric" default="-1"  required="yes" hint="Muahasebe İşlemi Yapıyor Mu">
        <cfargument name="paper_number" type="string" required="no" hint="Belge No">
        <cfargument name="to_branch_id" type="numeric" default="0" required="yes" hint="Şube ID">
    	<cfargument name="from_branch_id" type="numeric" default="0" required="yes" hint="Şube ID">
        <cfargument name="system_amount" type="numeric" default="0" required="yes" hint="Sistem Tutarı">
        <cfargument name="action_value2" type="numeric" default="0" required="yes" hint="İşlem Para Birimi">
        <cfargument name="is_account_type" type="numeric" default="-1" required="yes" hint="Muahasebe İşlemi Yapıyor Mu">
        
        <cfquery name="updCash" datasource="#dsn2#">
            UPDATE
                CASH_ACTIONS
            SET
                PROCESS_CAT = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.process_cat#">,
                CASH_ACTION_VALUE = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.action_value#">,
                CASH_ACTION_CURRENCY_ID = <cfqueryparam cfsqltype="cf_sql_varchar" null="#not len(arguments.currency_id)#" value="#arguments.currency_id#">,
                ACTION_DATE = <cfif len(arguments.ACTION_DATE)>#arguments.ACTION_DATE#</cfif>,
                CASH_ACTION_FROM_ACCOUNT_ID = <cfqueryparam cfsqltype="cf_sql_numeric"  null="#arguments.from_account_id eq 0#" value="#arguments.from_account_id#">,
                CASH_ACTION_TO_CASH_ID = <cfqueryparam cfsqltype="cf_sql_numeric" null="#arguments.TO_CASH_ID eq 0#"  value="#arguments.TO_CASH_ID#">,
                CASH_ACTION_TO_ACCOUNT_ID = <cfqueryparam cfsqltype="cf_sql_numeric" null="#arguments.to_account_id eq 0#"  value="#arguments.to_account_id#">,
                CASH_ACTION_FROM_CASH_ID = <cfqueryparam cfsqltype="cf_sql_numeric" null="#arguments.FROM_CASH_ID eq 0#"  value="#arguments.FROM_CASH_ID#">,
                OTHER_CASH_ACT_VALUE = <cfqueryparam cfsqltype="cf_sql_float" null="#arguments.OTHER_CASH_ACT_VALUE eq 0#"  value="#arguments.OTHER_CASH_ACT_VALUE#">,
                OTHER_MONEY =<cfqueryparam cfsqltype="cf_sql_varchar" null="#not len(arguments.money_type)#" value="#arguments.money_type#">,
                IS_ACCOUNT =<cfqueryparam cfsqltype="cf_sql_numeric" null="#arguments.is_account eq -1#" value="#arguments.is_account#">,
                IS_ACCOUNT_TYPE = <cfqueryparam cfsqltype="cf_sql_numeric" null="#arguments.is_account_type eq -1#"  value="#arguments.is_account_type#">,
                PAPER_NO = <cfqueryparam cfsqltype="cf_sql_varchar"null="#not len(arguments.paper_number)#" value="#arguments.paper_number#">,
                UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_numeric" value="#SESSION.EP.USERID#">,
                UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">,
                UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
                ACTION_VALUE = <cfqueryparam cfsqltype="cf_sql_numeric" null="#arguments.system_amount eq 0#"  value="#arguments.system_amount#">,
                ACTION_CURRENCY_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money#">
                <cfif len(session.ep.money2)>
                    ,ACTION_VALUE_2 = <cfqueryparam cfsqltype="cf_sql_numeric" null="#arguments.currency_multiplier eq 0#"  value="#arguments.currency_multiplier#">
                    ,ACTION_CURRENCY_ID_2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money2#">
                </cfif>				
            WHERE
                BANK_ACTION_ID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.id#">
        </cfquery>
        <cfreturn arguments.id>
    </cffunction>
    
    <!--- del --->
     <cffunction name="del" access="public" returntype="boolean">
		<cfargument name="id" type="numeric"  required="yes" hint="CASH_ACTION Tablosu İçin Data ID">
        
		<cfquery name="del" datasource="#dsn2#">
			DELETE FROM CASH_ACTION_MONEY WHERE ACTION_ID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.id#">
            DELETE FROM CASH_ACTIONS WHERE BANK_ACTION_ID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.id#">
		</cfquery>	
        
		<cfreturn true>
	</cffunction>
</cfcomponent>