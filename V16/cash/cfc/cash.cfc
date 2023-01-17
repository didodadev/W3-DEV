<!---KASA İŞLEMLERİ LİSTELEME, EXCEL VE TOPLAM FONKSİYONLARI SK 20150910--->
<!---
	is_excel : formdan gönderilen is_excel değerine göre fonksiyon çalışır. 0 ise listeleme query si çalışır. 1 ise excel querysi çalışır ve fonksiyonun içinde exceli oluşturur.
	is_total : getTotalValue fonksiyonundan gönderilir. 1 ise GET_CASH_ACTIONS querysinden, gönderilen filtrelere göre genel toplamları getirir.
 	Excel oluştururken, yazılacak veriler tek bir queryden döndürülür. Query çekilirken, oluşturulacak sütunlar da query içinde set edilir.
 --->
<cfcomponent>
	<cffunction name="getCashActions" access="public" returntype="query">
		<cfargument name="is_excel">
        <cfargument name="startrow" type="numeric">
        <cfargument name="maxrows" type="numeric">
        <cfargument name="acc_type_id">
        <cfargument name="employee_id">
        <cfargument name="emp_id">
        <cfargument name="record_date">
        <cfargument name="record_date2">
        <cfargument name="start_date">
        <cfargument name="finish_date">
        <cfargument name="page_action_type">
        <cfargument name="company_id">
        <cfargument name="consumer_id">
        <cfargument name="member_type">
        <cfargument name="company">
        <cfargument name="record_emp_id">
        <cfargument name="record_emp_name">
        <cfargument name="keyword">
        <cfargument name="paper_number">
        <cfargument name="cash">
        <cfargument name="action">
        <cfargument name="special_definition_id">
        <cfargument name="branch_id">
        <cfargument name="cash_status">
        <cfargument name="action_cash">
        <cfargument name="project_head">
        <cfargument name="project_id">
        <cfargument name="oby">
        <cfargument name="fuseaction">
        <cfargument name="is_money">
        <cfargument name="is_total">
		<cfargument name="module_power_user_ehesap" default=""/>
        <cfset dsn = this.dsn>
        <cfset dsn_alias = this.dsn_alias>
        <cfset dsn3_alias = this.dsn3_alias>
        <cfset get_module_power_user = application.functions.get_module_power_user>
        <cfinclude template="../../objects/query/get_acc_types.cfm">
        <cfif isDefined("arguments.page_action_type") and len(arguments.page_action_type)>
            <cfset ACT_TYPE = ListFirst(arguments.page_action_type,'-')>
            <cfset PROC_CAT = ListLast(arguments.page_action_type,'-')>
            <cfif ACT_TYPE eq 310>
                <cfset ACT_TYPE = '31'>
            <cfelseif ACT_TYPE eq 320>
                <cfset ACT_TYPE = '32'>
            </cfif>
        </cfif>
        <cfif not (isdefined("arguments.is_excel") and arguments.is_excel eq 1)>
            <cfquery name="GET_CASH_ACTIONS" datasource="#this.dsn2#">
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
                        PC.PROCESS_CAT_ID,
                        PC.PROCESS_CAT as STAGE
                    FROM
                        CASH_ACTIONS CA
                        LEFT JOIN #dsn_alias#.PRO_PROJECTS PR ON CA.PROJECT_ID=PR.PROJECT_ID
                        LEFT JOIN CASH C ON ISNULL(CA.CASH_ACTION_FROM_CASH_ID,CA.CASH_ACTION_TO_CASH_ID)=C.CASH_ID
                        LEFT JOIN #dsn_alias#.BRANCH BR ON C.BRANCH_ID=BR.BRANCH_ID
                        LEFT JOIN #dsn_alias#.COMPANY CMP ON ISNULL(CA.CASH_ACTION_FROM_COMPANY_ID,CA.CASH_ACTION_TO_COMPANY_ID) = CMP.COMPANY_ID
                        LEFT JOIN #dsn_alias#.CONSUMER CNS ON ISNULL(CA.CASH_ACTION_FROM_CONSUMER_ID,CA.CASH_ACTION_TO_CONSUMER_ID) = CNS.CONSUMER_ID
                        LEFT JOIN #dsn_alias#.EMPLOYEES EMP ON ISNULL(CA.CASH_ACTION_FROM_EMPLOYEE_ID,CA.CASH_ACTION_TO_EMPLOYEE_ID) = EMP.EMPLOYEE_ID
                        LEFT JOIN EXPENSE_ITEMS EI ON CA.EXPENSE_ITEM_ID=EI.EXPENSE_ITEM_ID
                        LEFT JOIN #dsn3_alias#.ACCOUNTS AC ON ISNULL(CA.CASH_ACTION_FROM_ACCOUNT_ID,CA.CASH_ACTION_TO_ACCOUNT_ID) = AC.ACCOUNT_ID
                        LEFT JOIN #dsn_alias#.EMPLOYEES REC_EMP ON CA.RECORD_EMP = REC_EMP.EMPLOYEE_ID
                        LEFT JOIN #dsn3_alias#.SETUP_PROCESS_CAT PC ON PC.PROCESS_CAT_ID = CA.PROCESS_CAT
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
                    <cfif isDefined("arguments.employee_id") and len(arguments.employee_id) and len(arguments.company) and arguments.member_type eq 'employee'>
                        AND (CA.CASH_ACTION_FROM_EMPLOYEE_ID = #arguments.emp_id# OR CA.CASH_ACTION_TO_EMPLOYEE_ID = #arguments.emp_id#)
                    </cfif>
                    <cfif isDefined("arguments.company_id") and len(arguments.company_id) and len(arguments.company) and arguments.member_type eq 'partner'>
                        AND (CA.CASH_ACTION_FROM_COMPANY_ID = #arguments.company_id# OR CA.CASH_ACTION_TO_COMPANY_ID = #arguments.company_id#)
                    </cfif>		
                    <cfif isDefined("arguments.consumer_id") and len(arguments.consumer_id) and len(arguments.company) and arguments.member_type eq 'consumer'>
                        AND (CA.CASH_ACTION_FROM_CONSUMER_ID = #arguments.consumer_id# OR CA.CASH_ACTION_TO_CONSUMER_ID = #arguments.consumer_id#)
                    </cfif>	
                    <cfif isDefined("arguments.record_emp_id") and len(arguments.record_emp_id) and len(arguments.record_emp_name)>
                        AND CA.RECORD_EMP = #arguments.record_emp_id#
                    </cfif>	
                    <cfif isDefined("ACT_TYPE") and len(ACT_TYPE) and isDefined("PROC_CAT") and len(PROC_CAT)>
                        <cfif PROC_CAT eq 0>
                            AND CA.ACTION_TYPE_ID IN (#ACT_TYPE#)
                        <cfelseif PROC_CAT neq 0>
                            AND CA.PROCESS_CAT = <cfqueryparam cfsqltype="cf_sql_integer" value="#PROC_CAT#">
                        </cfif>
                    </cfif>
                    <cfif isDefined("arguments.keyword") and len(arguments.keyword)>
                        <cfif len(arguments.keyword) gt 3>
                            AND CA.ACTION_DETAIL LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI
                        <cfelse>
                            AND CA.ACTION_DETAIL LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI
                        </cfif>
                    </cfif>
                    <cfif isDefined("arguments.paper_number") and len(arguments.paper_number)>
                        AND (CA.PAPER_NO LIKE '<cfif len(arguments.paper_number) gt 3>%</cfif>#arguments.paper_number#%')
                    </cfif>
                    <cfif isDefined("arguments.cash") and len(arguments.cash)>
                        AND
                        (
                        <cfif isdefined("arguments.action") and listfind('32,34,36',arguments.action,',')>
                            CA.CASH_ACTION_FROM_CASH_ID=#arguments.cash#
                        <cfelseif isdefined("arguments.action") and listfind('31,33,35',arguments.action,',')> 
                            CA.CASH_ACTION_TO_CASH_ID=#arguments.cash#
                        <cfelse>
                            CA.CASH_ACTION_FROM_CASH_ID=#arguments.cash# OR
                            CA.CASH_ACTION_TO_CASH_ID=#arguments.cash#
                        </cfif>
                        )
                    </cfif>
                    <cfif isDefined("arguments.special_definition_id") and len(arguments.special_definition_id) and arguments.special_definition_id eq '-1'>
                        AND CA.SPECIAL_DEFINITION_ID IN (SELECT SPECIAL_DEFINITION_ID FROM #dsn_alias#.SETUP_SPECIAL_DEFINITION WHERE SPECIAL_DEFINITION_TYPE = 1)
                    <cfelseif isDefined("arguments.special_definition_id") and len(arguments.special_definition_id) and arguments.special_definition_id eq '-2'>
                        AND CA.SPECIAL_DEFINITION_ID IN (SELECT SPECIAL_DEFINITION_ID FROM #dsn_alias#.SETUP_SPECIAL_DEFINITION WHERE SPECIAL_DEFINITION_TYPE = 2)
                    <cfelseif isDefined("arguments.special_definition_id") and len(arguments.special_definition_id)>
                        AND CA.SPECIAL_DEFINITION_ID = #arguments.special_definition_id#
                    </cfif>
                    <cfif isdate(arguments.start_date) and not isdate(arguments.finish_date)>
                        AND CA.ACTION_DATE >= #arguments.start_date#
                    <cfelseif isdate(arguments.finish_date) and not isdate(arguments.start_date)>
                        AND CA.ACTION_DATE <= #arguments.finish_date#
                    <cfelseif isdate(arguments.start_date) and  isdate(arguments.finish_date)>
                        AND CA.ACTION_DATE BETWEEN #arguments.start_date# AND #arguments.finish_date#
                    </cfif>
                    <cfif isdate(arguments.record_date) and not isdate(arguments.record_date2)>
                        AND CA.RECORD_DATE >= #arguments.record_date#
                    <cfelseif isdate(arguments.record_date2) and not isdate(arguments.record_date)>
                        AND CA.RECORD_DATE <= #DATEADD("d",1,arguments.record_date2)#
                    <cfelseif isdate(arguments.record_date) and  isdate(arguments.record_date2)>
                        AND CA.RECORD_DATE >= #arguments.record_date# AND CA.RECORD_DATE <= #DATEADD("d",1,arguments.record_date2)#
                    </cfif>
                    <cfif (session.ep.isBranchAuthorization) or (isdefined('arguments.branch_id') and len(arguments.branch_id)) >
                        AND (
                                (CA.CASH_ACTION_FROM_CASH_ID IN (SELECT CASH_ID FROM CASH WHERE BRANCH_ID IN (<cfif isdefined('arguments.branch_id') and len(arguments.branch_id)>#arguments.branch_id#<cfelse> SELECT BRANCH_ID FROM #dsn#.EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#</cfif>)) OR
                                CA.CASH_ACTION_TO_CASH_ID IN (SELECT CASH_ID FROM CASH WHERE BRANCH_ID IN (<cfif isdefined('arguments.branch_id') and len(arguments.branch_id)>#arguments.branch_id#<cfelse>SELECT BRANCH_ID FROM #dsn#.EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#</cfif>)))
                            )
                    </cfif>
                    <cfif (isDefined("arguments.cash_status") and len(arguments.cash_status))>
                        AND ((CA.CASH_ACTION_FROM_CASH_ID IN(SELECT CASH_ID FROM CASH WHERE CASH_STATUS = #arguments.cash_status#)) OR (CA.CASH_ACTION_TO_CASH_ID IN(SELECT CASH_ID FROM CASH WHERE CASH_STATUS = #arguments.cash_status#)))
                    </cfif>
                    <cfif isdefined("arguments.action_cash") and arguments.action_cash eq 1>
                        AND CA.CASH_ACTION_TO_CASH_ID IS NOT NULL
                    <cfelseif isdefined("arguments.action_cash") and arguments.action_cash eq 0>
                        AND CA.CASH_ACTION_FROM_CASH_ID IS NOT NULL
                    </cfif>
                    <cfif isdefined("arguments.acc_type_id") and len(arguments.acc_type_id)>
                        AND CA.ACC_TYPE_ID = #arguments.acc_type_id#
                    </cfif>
                    <cfif len(arguments.project_head) and isdefined("arguments.project_id") and len(arguments.project_id)>
                        AND CA.PROJECT_ID = #arguments.project_id#
                    </cfif>
                    ),
                        CTE2 AS (
                        SELECT
                        	SUM(CTE1.DEBT-CTE1.CLAIM) OVER (ORDER BY ACTION_DATE, RECORD_DATE,ACTION_ID DESC ) AS CUM_TOTAL,
                            CTE1.*,
                            ROW_NUMBER() OVER (
                                ORDER BY 
                                    <cfif isDefined('arguments.oby') and arguments.oby eq 2>
                                        ACTION_DATE,
                                        RECORD_DATE,
                                    <cfelseif isDefined('arguments.oby') and arguments.oby eq 3>
                                        PAPER_NO,
                                    <cfelseif isDefined('arguments.oby') and arguments.oby eq 4>
                                        PAPER_NO DESC,
                                    <cfelse>
                                        ACTION_DATE DESC,
                                        RECORD_DATE DESC,
                                    </cfif>
                                    ACTION_ID DESC
                            ) AS RowNum,(SELECT COUNT(*) FROM CTE1) AS QUERY_COUNT
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
                   	<cfelse>
                        SELECT
                            CTE2.*
                        FROM
                            CTE2
                        WHERE
                            RowNum BETWEEN #arguments.startrow# and #arguments.startrow#+(#arguments.maxrows#-1)
                    </cfif>

            </cfquery>
            <cfset returnValue = get_cash_actions>
        <cfelseif isdefined("arguments.is_excel") and arguments.is_excel eq 1>
            <cfset columnlist = ''>
            <cfquery name="GET_EXCEL" datasource="#this.dsn2#">
                WITH CTE1 AS (
                         SELECT
                         	CASE WHEN CA.CASH_ACTION_TO_CASH_ID IS NOT NULL THEN CA.CASH_ACTION_VALUE ELSE '' END AS DEBT,
                            CASE WHEN CA.CASH_ACTION_TO_CASH_ID IS NOT NULL THEN CA.CASH_ACTION_CURRENCY_ID ELSE '' END AS DEBT_CURR,
                            CASE WHEN CA.CASH_ACTION_FROM_CASH_ID IS NOT NULL THEN CA.CASH_ACTION_VALUE ELSE '' END AS CLAIM,
                            CASE WHEN CA.CASH_ACTION_FROM_CASH_ID IS NOT NULL THEN CA.CASH_ACTION_CURRENCY_ID ELSE '' END AS CLAIM_CURR,
                            CASE WHEN CA.CASH_ACTION_TO_CASH_ID IS NOT NULL THEN CA.ACTION_VALUE ELSE '' END AS SYSTEM_DEBT,
                            CASE WHEN CA.CASH_ACTION_FROM_CASH_ID IS NOT NULL THEN CA.ACTION_VALUE ELSE '' END AS SYSTEM_CLAIM,
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
                                   ORDER BY 
                                    <cfif isDefined('arguments.oby') and arguments.oby eq 2>
                                        CA.ACTION_DATE,
                                        CA.RECORD_DATE,
                                    <cfelseif isDefined('arguments.oby') and arguments.oby eq 3>
                                        CA.PAPER_NO,
                                    <cfelseif isDefined('arguments.oby') and arguments.oby eq 4>
                                        CA.PAPER_NO DESC,
                                    <cfelse>
                                        CA.ACTION_DATE DESC,
                                        CA.RECORD_DATE DESC,
                                    </cfif>
                                    CA.ACTION_ID DESC
                            ) AS ROWNUM
                        FROM
                            CASH_ACTIONS CA
                            LEFT JOIN #dsn_alias#.PRO_PROJECTS PR ON CA.PROJECT_ID=PR.PROJECT_ID
                            LEFT JOIN CASH C ON ISNULL(CA.CASH_ACTION_FROM_CASH_ID,CA.CASH_ACTION_TO_CASH_ID)=C.CASH_ID
                            LEFT JOIN #dsn_alias#.BRANCH BR ON C.BRANCH_ID=BR.BRANCH_ID
                            LEFT JOIN #dsn_alias#.COMPANY CMP ON ISNULL(CA.CASH_ACTION_FROM_COMPANY_ID,CA.CASH_ACTION_TO_COMPANY_ID) = CMP.COMPANY_ID
                            LEFT JOIN #dsn_alias#.CONSUMER CNS ON ISNULL(CA.CASH_ACTION_FROM_CONSUMER_ID,CA.CASH_ACTION_TO_CONSUMER_ID) = CNS.CONSUMER_ID
                            LEFT JOIN #dsn_alias#.EMPLOYEES EMP ON ISNULL(CA.CASH_ACTION_FROM_EMPLOYEE_ID,CA.CASH_ACTION_TO_EMPLOYEE_ID) = EMP.EMPLOYEE_ID
                            LEFT JOIN EXPENSE_ITEMS EI ON CA.EXPENSE_ITEM_ID=EI.EXPENSE_ITEM_ID
                            LEFT JOIN #dsn3_alias#.ACCOUNTS AC ON ISNULL(CA.CASH_ACTION_FROM_ACCOUNT_ID,CA.CASH_ACTION_TO_ACCOUNT_ID) = AC.ACCOUNT_ID
                            LEFT JOIN #dsn_alias#.EMPLOYEES REC_EMP ON CA.RECORD_EMP = REC_EMP.EMPLOYEE_ID
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
                        <cfif isDefined("arguments.employee_id") and len(arguments.employee_id) and len(arguments.company) and arguments.member_type eq 'employee'>
                            AND (CA.CASH_ACTION_FROM_EMPLOYEE_ID = #arguments.emp_id# OR CA.CASH_ACTION_TO_EMPLOYEE_ID = #arguments.emp_id#)
                        </cfif>
                        <cfif isDefined("arguments.company_id") and len(arguments.company_id) and len(arguments.company) and arguments.member_type eq 'partner'>
                            AND (CA.CASH_ACTION_FROM_COMPANY_ID = #arguments.company_id# OR CA.CASH_ACTION_TO_COMPANY_ID = #arguments.company_id#)
                        </cfif>		
                        <cfif isDefined("arguments.consumer_id") and len(arguments.consumer_id) and len(arguments.company) and arguments.member_type eq 'consumer'>
                            AND (CA.CASH_ACTION_FROM_CONSUMER_ID = #arguments.consumer_id# OR CA.CASH_ACTION_TO_CONSUMER_ID = #arguments.consumer_id#)
                        </cfif>	
                        <cfif isDefined("arguments.record_emp_id") and len(arguments.record_emp_id) and len(arguments.record_emp_name)>
                            AND CA.RECORD_EMP = #arguments.record_emp_id#
                        </cfif>	
                        <cfif isDefined("ACT_TYPE") and len(ACT_TYPE) and isDefined("PROC_CAT") and len(PROC_CAT)>
                            <cfif PROC_CAT eq 0>
                                AND CA.ACTION_TYPE_ID IN (#ACT_TYPE#)
                            <cfelseif PROC_CAT neq 0>
                                AND CA.PROCESS_CAT = <cfqueryparam cfsqltype="cf_sql_integer" value="#PROC_CAT#">
                            </cfif>
                        </cfif>
                        <cfif isDefined("arguments.keyword") and len(arguments.keyword)>
                            <cfif len(arguments.keyword) gt 3>
                                AND CA.ACTION_DETAIL LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI
                            <cfelse>
                                AND CA.ACTION_DETAIL LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI
                            </cfif>
                        </cfif>
                        <cfif isDefined("arguments.paper_number") and len(arguments.paper_number)>
                            AND (CA.PAPER_NO LIKE '<cfif len(arguments.paper_number) gt 3>%</cfif>#arguments.paper_number#%')
                        </cfif>
                        <cfif isDefined("arguments.cash") and len(arguments.cash)>
                            AND
                            (
                            <cfif isdefined("arguments.action") and listfind('32,34,36',arguments.action,',')>
                                CA.CASH_ACTION_FROM_CASH_ID=#arguments.cash#
                            <cfelseif isdefined("arguments.action") and listfind('31,33,35',arguments.action,',')> 
                                CA.CASH_ACTION_TO_CASH_ID=#arguments.cash#
                            <cfelse>
                                CA.CASH_ACTION_FROM_CASH_ID=#arguments.cash# OR
                                CA.CASH_ACTION_TO_CASH_ID=#arguments.cash#
                            </cfif>
                            )
                        </cfif>
                        <cfif isDefined("arguments.special_definition_id") and len(arguments.special_definition_id) and arguments.special_definition_id eq '-1'>
                            AND CA.SPECIAL_DEFINITION_ID IN (SELECT SPECIAL_DEFINITION_ID FROM #dsn_alias#.SETUP_SPECIAL_DEFINITION WHERE SPECIAL_DEFINITION_TYPE = 1)
                        <cfelseif isDefined("arguments.special_definition_id") and len(arguments.special_definition_id) and arguments.special_definition_id eq '-2'>
                            AND CA.SPECIAL_DEFINITION_ID IN (SELECT SPECIAL_DEFINITION_ID FROM #dsn_alias#.SETUP_SPECIAL_DEFINITION WHERE SPECIAL_DEFINITION_TYPE = 2)
                        <cfelseif isDefined("arguments.special_definition_id") and len(arguments.special_definition_id)>
                            AND CA.SPECIAL_DEFINITION_ID = #arguments.special_definition_id#
                        </cfif>
                        <cfif isdate(arguments.start_date) and not isdate(arguments.finish_date)>
                            AND CA.ACTION_DATE >= #arguments.start_date#
                        <cfelseif isdate(arguments.finish_date) and not isdate(arguments.start_date)>
                            AND CA.ACTION_DATE <= #arguments.finish_date#
                        <cfelseif isdate(arguments.start_date) and  isdate(arguments.finish_date)>
                            AND CA.ACTION_DATE BETWEEN #arguments.start_date# AND #arguments.finish_date#
                        </cfif>
                        <cfif isdate(arguments.record_date) and not isdate(arguments.record_date2)>
                            AND CA.RECORD_DATE >= #arguments.record_date#
                        <cfelseif isdate(arguments.record_date2) and not isdate(arguments.record_date)>
                            AND CA.RECORD_DATE <= #DATEADD("d",1,arguments.record_date2)#
                        <cfelseif isdate(arguments.record_date) and  isdate(arguments.record_date2)>
                            AND CA.RECORD_DATE >= #arguments.record_date# AND CA.RECORD_DATE <= #DATEADD("d",1,arguments.record_date2)#
                        </cfif>
                        <cfif (session.ep.isBranchAuthorization) or (isdefined('arguments.branch_id') and len(arguments.branch_id)) >
                            AND (
                                    (CA.CASH_ACTION_FROM_CASH_ID IN (SELECT CASH_ID FROM CASH WHERE BRANCH_ID IN (<cfif isdefined('arguments.branch_id') and len(arguments.branch_id)>#arguments.branch_id#<cfelse>SELECT BRANCH_ID FROM #dsn#.EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#</cfif>)) OR
                                    CA.CASH_ACTION_TO_CASH_ID IN (SELECT CASH_ID FROM CASH WHERE BRANCH_ID IN (<cfif isdefined('arguments.branch_id') and len(arguments.branch_id)>#arguments.branch_id#<cfelse>SELECT BRANCH_ID FROM #dsn#.EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#</cfif>)))
                                )
                        </cfif>
                        <cfif (isDefined("arguments.cash_status") and len(arguments.cash_status))>
                            AND ((CA.CASH_ACTION_FROM_CASH_ID IN(SELECT CASH_ID FROM CASH WHERE CASH_STATUS = #arguments.cash_status#)) OR (CA.CASH_ACTION_TO_CASH_ID IN(SELECT CASH_ID FROM CASH WHERE CASH_STATUS = #arguments.cash_status#)))
                        </cfif>
                        <cfif isdefined("arguments.action_cash") and arguments.action_cash eq 1>
                            AND CA.CASH_ACTION_TO_CASH_ID IS NOT NULL
                        <cfelseif isdefined("arguments.action_cash") and arguments.action_cash eq 0>
                            AND CA.CASH_ACTION_FROM_CASH_ID IS NOT NULL
                        </cfif>
                        <cfif isdefined("arguments.acc_type_id") and len(arguments.acc_type_id)>
                            AND CA.ACC_TYPE_ID = #arguments.acc_type_id#
                        </cfif>
                        <cfif len(arguments.project_head) and isdefined("arguments.project_id") and len(arguments.project_id)>
                            AND CA.PROJECT_ID = #arguments.project_id#
                        </cfif>
                ),
                CTE2 AS (
                    SELECT
                        CTE1.ROWNUM,
                        CTE1.PAPER_NO,
                        CTE1.ACTION_DATE,
                        CTE1.RECORD_DATE,
                        CTE1.ACTION_TYPE,
                        CASE WHEN CTE1.CASH IS NOT NULL THEN CTE1.CASH ELSE '' END AS CASH,
                        CASE 
                            WHEN CTE1.COMPANY IS NOT NULL THEN CTE1.COMPANY
                            WHEN CTE1.CONSUMER IS NOT NULL THEN CTE1.CONSUMER
                            WHEN CTE1.EMPLOYEE IS NOT NULL THEN CTE1.EMPLOYEE
                            WHEN CTE1.ACCOUNT IS NOT NULL THEN CTE1.ACCOUNT
                            WHEN CTE1.EXPENSE_ITEM IS NOT NULL THEN CTE1.EXPENSE_ITEM
                        ELSE
                                ''
                        END AS CH,
                        CTE1.ACTION_DETAIL,
                        CTE1.BRANCH,
                        CTE1.PROJECT,
                        CTE1.RECORD_EMP,
                        CTE1.DEBT,
                        CTE1.DEBT_CURR,
                        CTE1.CLAIM,
                        CTE1.CLAIM_CURR
                        <cfif isdefined("arguments.cash") and len(arguments.cash) and arguments.oby eq 2>
                        	,SUM(CTE1.DEBT-CTE1.CLAIM) OVER (ORDER BY ACTION_DATE, RECORD_DATE,ACTION_ID DESC ) AS CUM_TOTAL
                        </cfif>
                        <cfif isdefined("arguments.is_money")>
							<cfif isdefined("arguments.action_cash") and ((arguments.action_cash eq 1) or (arguments.action_cash eq 2))>
                            	,CTE1.SYSTEM_DEBT
                            </cfif>
							<cfif isdefined("arguments.action_cash") and ((arguments.action_cash eq 0) or (arguments.action_cash eq 2))>
                            	,CTE1.SYSTEM_CLAIM
                            </cfif>
                        </cfif>
                    FROM
                        CTE1
                    ),
                    CTE3 AS (
						SELECT 
							SUM(CTE2.DEBT) TOPLAM1,
							CTE2.DEBT_CURR,
                            ROW_NUMBER() OVER (ORDER BY DEBT_CURR) AS CTE2_RN
						FROM
							CTE2
						GROUP BY
							CTE2.DEBT_CURR
                        HAVING
							SUM(CTE2.DEBT) !=0
					),
					CTE4 AS (
						SELECT
							SUM(CTE2.CLAIM) TOPLAM2,
							CTE2.CLAIM_CURR,
                            ROW_NUMBER() OVER (ORDER BY CLAIM_CURR) AS CTE2_RN
						FROM
							CTE2
						GROUP BY
							CTE2.CLAIM_CURR
                        HAVING
							SUM(CTE2.CLAIM) != 0
					)
						SELECT
                            ROWNUM, <cfset columnlist = columnlist & 'No,'>
                            PAPER_NO, <cfset columnlist = columnlist & 'Belge No,'>
                            CONVERT(VARCHAR(10),ACTION_DATE,103), <cfset columnlist = columnlist & 'İşlem Tarihi,'>
                            CONVERT(VARCHAR(10),RECORD_DATE,103), <cfset columnlist = columnlist & 'Kayıt Tarihi,'>
                            ACTION_TYPE, <cfset columnlist = columnlist & 'İşlem Tipi,'>
                            CASH, <cfset columnlist = columnlist & 'Kasa,'>
                            CH, <cfset columnlist = columnlist & 'Cari Hesap,'>
                            ACTION_DETAIL, <cfset columnlist = columnlist & 'Açıklama,'>
                            	BRANCH, <cfset columnlist = columnlist & 'Şube,'>
                            	PROJECT, <cfset columnlist = columnlist & 'Proje,'>
                            RECORD_EMP <cfset columnlist = columnlist & 'Kaydeden'>
                            <cfif isdefined("arguments.action_cash") and ((arguments.action_cash eq 1) or (arguments.action_cash eq 2))>
                                ,CASE DEBT_CURR WHEN '' THEN '' ELSE DEBT END DEBT <cfset columnlist = columnlist & ',Borç'>
                                ,DEBT_CURR <cfset columnlist = columnlist & ',Para Birimi'>
                            </cfif>
                            <cfif isdefined("arguments.action_cash") and ((arguments.action_cash eq 0) or (arguments.action_cash eq 2))>
                                ,CASE CLAIM_CURR WHEN '' THEN '' ELSE  CLAIM END CLAIM <cfset columnlist = columnlist & ',Alacak'>
                                ,CLAIM_CURR <cfset columnlist = columnlist & ',Para Birimi'>
                            </cfif>
                            <cfif isdefined("arguments.cash") and len(arguments.cash) and arguments.oby eq 2>
                            	,CASE 
                                	WHEN CUM_TOTAL > 0 THEN CUM_TOTAL + '(B)'
                                    WHEN CUM_TOTAL < 0 THEN CUM_TOTAL + '(A)'
                                    ELSE CUM_TOTAL
                                 END AS CUM_TOTAL <cfset columnlist = columnlist & ',Bakiye'>
                            </cfif>
							<cfif isdefined("arguments.is_money")>
                                <cfif isdefined("arguments.action_cash") and ((arguments.action_cash eq 1) or (arguments.action_cash eq 2))>
                                    ,CASE DEBT_CURR WHEN '' THEN '' ELSE  SYSTEM_DEBT END SYSTEM_DEBT <cfset columnlist = columnlist & ',TL Borç'>
                                </cfif>
                                <cfif isdefined("arguments.action_cash") and ((arguments.action_cash eq 0) or (arguments.action_cash eq 2))>
                                    ,CASE CLAIM_CURR WHEN '' THEN '' ELSE  SYSTEM_CLAIM END SYSTEM_CLAIM <cfset columnlist = columnlist & ',TL Alacak'>
                                </cfif>
                            </cfif>
						FROM
							CTE2
                       	UNION ALL
                        SELECT
                            (SELECT COUNT(*) FROM CTE1) + 1 AS ROWNUM ,
                            '',
                           	'',
                            '',
                            '',
                            '',
                            '',
                            '',
							'',
							'', 
                            ''
                            <cfif isdefined("arguments.action_cash") and ((arguments.action_cash eq 1) or (arguments.action_cash eq 2))>
                                ,''
                                ,''
                            </cfif>
                            <cfif isdefined("arguments.action_cash") and ((arguments.action_cash eq 0) or (arguments.action_cash eq 2))>
                                ,''
                                ,''
                            </cfif>
                            <cfif isdefined("arguments.cash") and len(arguments.cash) and arguments.oby eq 2>
                            	,''
                            </cfif>
							<cfif isdefined("arguments.is_money")>
                                <cfif isdefined("arguments.action_cash") and ((arguments.action_cash eq 1) or (arguments.action_cash eq 2))>
                                    ,''
                                </cfif>
                                <cfif isdefined("arguments.action_cash") and ((arguments.action_cash eq 0) or (arguments.action_cash eq 2))>
                                    ,''
                                </cfif>
                            </cfif>
						UNION ALL
						SELECT 
							(SELECT COUNT(*) FROM CTE1) + ISNULL(CTE3.CTE2_RN,CTE4.CTE2_RN) AS ROWNUM, 
							'', 
							'', 
							'', 
							'', 
							'',
                            '', 
							'',
							'',
							'',
                           
							CASE ISNULL(CTE3.CTE2_RN,CTE4.CTE2_RN) WHEN 1 THEN 'Toplam' ELSE '' END
                            <cfif isdefined("arguments.action_cash") and ((arguments.action_cash eq 1) or (arguments.action_cash eq 2))>
                                ,CTE3.TOPLAM1
                                ,CTE3.DEBT_CURR
                            </cfif>
                            <cfif isdefined("arguments.action_cash") and ((arguments.action_cash eq 0) or (arguments.action_cash eq 2))>
                                ,CTE4.TOPLAM2
                                ,CTE4.CLAIM_CURR
                            </cfif>
                            <cfif isdefined("arguments.cash") and len(arguments.cash) and arguments.oby eq 2>
                            	,CASE 
                                	WHEN TOPLAM1 > TOPLAM2 THEN TOPLAM1-TOPLAM2 + '(B)'
                                    WHEN TOPLAM1 < TOPLAM2 THEN TOPLAM1-TOPLAM2 + '(A)'
                                    ELSE TOPLAM1-TOPLAM2
                                 END AS CUM_TOTAL
                            </cfif>
                           	<cfif isdefined("arguments.is_money")>
                                <cfif isdefined("arguments.action_cash") and ((arguments.action_cash eq 1) or (arguments.action_cash eq 2))>
                                    ,''
                                </cfif>
                                <cfif isdefined("arguments.action_cash") and ((arguments.action_cash eq 0) or (arguments.action_cash eq 2))>
                                    ,''
                                </cfif>
                            </cfif>  
						FROM CTE3 
							FULL JOIN CTE4 ON CTE3.DEBT_CURR=CTE4.CLAIM_CURR 
						WHERE
                        	CTE3.TOPLAM1 != 0 OR CTE4.TOPLAM2 !=0
                        ORDER BY
                        	CTE2.ROWNUM
                        
            </cfquery>
           
			<cfscript>
                theSheet = SpreadsheetNew("CASH");
                SpreadsheetAddRow(theSheet,columnlist,1,1);
                SpreadsheetAddRows(theSheet,get_excel);
                format1 = StructNew();
                format1.font="Courier";
                format1.fontsize="10";
                format1.bold="true";
                format1.alignment="left";
                format1.textwrap="true";
                
                paperNoFormat = StructNew();
                paperNoFormat.alignment = "left";
                
                myDateFormat = StructNew();
                myDateFormat.alignment = "left";
                myDateFormat.dataformat = "DD.MM.YYYY";
                
                moneyFormat = StructNew();
                moneyFormat.alignment = "right";
                moneyFormat.dataformat = "##,##0.00";
                
                amountcolumns = "Borç,Alacak,Bakiye,TL Borç,TL Alacak";
                columncount = listlen(columnlist,',');
                moneyformattedcolumns = ArrayNew(1);

                for(var i=1; i<=columncount ; i++)
                {
                    for(var j=1; j<=5 ; j++)
                    {
                        if(listgetat(columnlist,i,',') == listgetat(amountcolumns,j,','))
                        {
                            ArrayAppend(moneyformattedcolumns, i);		
                        }
                    }
                    
                }
                SpreadsheetFormatColumn(theSheet,paperNoFormat,2);
                SpreadsheetFormatColumn(theSheet,myDateFormat,3);
                SpreadsheetFormatColumn(theSheet,myDateFormat,4);
                for(var i=1; i<= arrayLen(moneyformattedcolumns); i++)
                {
                    SpreadsheetFormatColumn(theSheet,moneyFormat,moneyformattedcolumns[i]);
                }
                SpreadsheetFormatRow(theSheet,format1,1);
					
				prepareDirectory(this.upload_folder);
            </cfscript>
            <cfset uuid=CreateUUID()>
            <cfspreadsheet action="write" filename="#this.upload_folder#/reserve_files/#session.ep.userid#/cash_actions_#session.ep.userid#_#uuid#.xls" name="theSheet" sheet=1 sheetname="Kasa İşlemleri" overwrite=true>
            <script type="text/javascript">
                <cfoutput>
                    get_wrk_message_div("Excel","Excel","/documents/reserve_files/#session.ep.userid#/cash_actions_#session.ep.userid#_#uuid#.xls") ;
                </cfoutput>
            </script>
            <cfset returnValue = get_excel>
        </cfif>
		<cfreturn returnValue>
	</cffunction>
    <cffunction name="getCashActionTotal" access="public" returntype="query">
    	<cfargument name="is_excel">
        <cfargument name="acc_type_id">
        <cfargument name="employee_id">
        <cfargument name="emp_id">
        <cfargument name="record_date">
        <cfargument name="record_date2">
        <cfargument name="start_date">
        <cfargument name="finish_date">
        <cfargument name="page_action_type">
        <cfargument name="company_id">
        <cfargument name="consumer_id">
        <cfargument name="member_type">
        <cfargument name="company">
        <cfargument name="record_emp_id">
        <cfargument name="record_emp_name">
        <cfargument name="keyword">
        <cfargument name="paper_number">
        <cfargument name="cash">
        <cfargument name="action">
        <cfargument name="special_definition_id">
        <cfargument name="branch_id">
        <cfargument name="cash_status">
        <cfargument name="action_cash">
        <cfargument name="project_head">
        <cfargument name="project_id">
        <cfargument name="oby">
        <cfargument name="fuseaction">
		<cfargument name="module_power_user_ehesap" default=""/>        
        <cfscript>
			cashActions = createobject("component","V16.cash.cfc.cash");
			cashActions.dsn2 = this.dsn2;
			cashActions.dsn = this.dsn;
			cashActions.dsn_alias = this.dsn_alias;
			cashActions.dsn3_alias = this.dsn3_alias;
		</cfscript>
		<cfscript>
            get_cash_actions = cashActions.getCashActions
            (
                is_excel : 0,
                acc_type_id : arguments.acc_type_id,
                employee_id : arguments.employee_id,
                emp_id : arguments.emp_id,
                record_date : arguments.record_date,
                record_date2 : arguments.record_date2,
                start_date : arguments.start_date,
                finish_date : arguments.finish_date,
                page_action_type : arguments.page_action_type,
                company_id : arguments.company_id,
                consumer_id : arguments.consumer_id,
                member_type : arguments.member_type,
                company : arguments.company,
                record_emp_id : arguments.record_emp_id,
                record_emp_name : arguments.record_emp_name,
                keyword : arguments.keyword,
                paper_number : arguments.paper_number,
                cash : arguments.cash,
                action : arguments.action,
                special_definition_id : arguments.special_definition_id,
                branch_id : arguments.branch_id,
                cash_status : arguments.cash_status,
                action_cash : arguments.action_cash,
                project_head : arguments.project_head,
                project_id : arguments.project_id,
                oby : arguments.oby,
                fuseaction : arguments.fuseaction,
				is_total : 1,
				module_power_user_ehesap : arguments.module_power_user_ehesap
            );
        </cfscript>
        <cfreturn get_cash_actions>
    </cffunction>
    <cffunction name="prepareDirectory" access="private" returntype="any">
    	<cfargument name="upload_folder">
        <cftry>
			<cfif DirectoryExists("#upload_folder#reserve_files/#session.ep.userid#")>
                <cfdirectory action="delete" directory="#arguments.upload_folder#reserve_files/#session.ep.userid#" recurse="yes">
            </cfif>
            <cfset Sleep(3000)>
            <cfdirectory action="create" directory="#arguments.upload_folder#reserve_files/#session.ep.userid#">
        <cfcatch>
            <script type="text/javascript">
                alert('Klasorlerin silinmesi/olusturulmasi sirasinda bir hata olustu. Dosyalar ya da klasorler kullanimda olabilir.');
                window.history.back();
            </script>
        	<cfabort>
        </cfcatch>
        </cftry>
    </cffunction>
</cfcomponent>
