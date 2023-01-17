<cfcomponent>
    <cfparam name="attributes.module_power_user_ehesap" default="">
    <cfparam name="attributes.module_power_user_hr" default="">
    <cffunction name="get_caris_fnc" returntype="any">
        <cfargument name="action_type_ch" default=""/>
        <cfargument name="start_date" default=""/>
        <cfargument name="finish_date" default=""/>
        <cfargument name="keyword" default=""/>
        <cfargument name="consumer_id" default=""/>
        <cfargument name="company_name" default=""/>
        <cfargument name="company_id" default=""/>
        <cfargument name="emp_id" default=""/>
        <cfargument name="employee_name" default=""/>
        <cfargument name="member_cat_type" default=""/>
        <cfargument name="branch_id" default=""/>
        <cfargument name="record_name" default=""/>
        <cfargument name="record_emp" default=""/>
        <cfargument name="asset_id" default=""/>
        <cfargument name="asset_name" default=""/>
        <cfargument name="expense_center_id" default=""/>
        <cfargument name="expense_center_name" default=""/>
        <cfargument name="expense_item_id" default=""/>
        <cfargument name="expense_item_name" default=""/>
        <cfargument name="special_definition_id" default=""/>
        <cfargument name="acc_type_id" default=""/>
        <cfargument name="project_id" default=""/>
        <cfargument name="project_head" default=""/>
        <cfargument name="module_power_user_ehesap" default=""/>
        <cfargument name="module_power_user_hr" default=""/>
        <cfargument name="oby" default=""/>
        <cfargument name="fuseaction_" default=""/>
        <cfargument name="list_company" default=""/>
        <cfargument name="list_consumer" default=""/>
        <cfargument name="list_acc_type_id" default=""/>
        <cfargument name="startrow" default="0">
        <cfargument name="maxrows" default="">
        <cfargument name="dsn" default="">
        <cfargument name="dsn_alias" default="">
        <cfargument name="dsn2_alias" default="">
        <cfargument name="dsn3_alias" default="">
        <cfargument name="pos_code" default=""/>
        <cfargument name="pos_code_text" default=""/>
        <cfargument name="x_branch_info"/>
        <cfargument name="x_project_info"/>
        <cfargument name="x_control_ims"/>
        <cfargument name="is_excel" default="0">
        <cfargument name="subscription_id">
        <cfargument name="subscription_no">
        <cfargument name="acc_type">
        <cfset dsn = arguments.dsn>
        <cfset ch_alias = 'CR.'>
        <cfset action_type_ch_ = listLast(action_type_ch, '-')>
        <cfset action_cat_ch_ = listfirst(action_type_ch, '-')>
        <cfset attributes.module_power_user_ehesap=module_power_user_ehesap>
        <cfset attributes.module_power_user_hr=module_power_user_hr>
        <cfinclude template="../../objects/query/get_acc_types.cfm">
        <cfif isdefined("x_control_ims") and x_control_ims eq 1 and  session.ep.our_company_info.sales_zone_followup eq 1>
            <cfinclude template="../../member/query/get_ims_control.cfm">
            </cfif>
        <cfif not (isdefined("arguments.is_excel") and arguments.is_excel eq 1)>
            <cfquery name="GET_CARIS" datasource="#this.dsn2#" cachedwithin="#this.fusebox.general_cached_time#">
               WITH CTE1 AS (
                   <!---Kurumsal-Bireysel --->
                SELECT 
                    CR.CARI_ACTION_ID,
                    CR.ACTION_ID, 
                    CR.ACTION_TABLE,
                    CR.PAPER_NO,
                    CR.ACTION_TYPE_ID,
                    CR.ACTION_NAME,
                    CR.TO_CMP_ID,
                    CR.FROM_CMP_ID,
                    CR.TO_ACCOUNT_ID,
                    CR.FROM_ACCOUNT_ID,
                    CR.FROM_CASH_ID,
                    CR.TO_CASH_ID,
                    CR.FROM_EMPLOYEE_ID,
                    CR.TO_EMPLOYEE_ID,
                    CR.FROM_CONSUMER_ID,
                    CR.TO_CONSUMER_ID,
                    CR.ACTION_VALUE,
                    CR.ACTION_DATE,
                    CR.RECORD_DATE,
                    CR.OTHER_CASH_ACT_VALUE,
                    CR.OTHER_MONEY,
                    CR.ACTION_CURRENCY_ID,
                    CR.REVENUE_COLLECTOR_ID,
                    CR.IS_PROCESSED,
                    CR.ACTION_DETAIL,
                    CR.RECORD_EMP,
                    CR.ACC_TYPE_ID,
                    CR.SUBSCRIPTION_ID,
                    ISNULL(CR.TO_CMP_ID,CR.FROM_CMP_ID) COMP_ID,
                    ISNULL(CR.TO_CONSUMER_ID,CR.FROM_CONSUMER_ID) CONS_ID,
                    ISNULL(CR.TO_EMPLOYEE_ID,CR.FROM_EMPLOYEE_ID) EMP_ID,
                    SETUP_ACC_TYPE.ACC_TYPE_NAME,
                    COMPANY.NICKNAME, 
                    COMPANY.MEMBER_CODE,
                    CONSUMER_NAME + ' ' + CONSUMER_SURNAME AS FULLNAME, 
                    CONSUMER.MEMBER_CODE AS  CONSUMER_MEMBER_CODE,
                    '' AS EMPLOYEE_FULLNAME, 
                   '' AS EMPLOYEE_MEMBER_CODE,
                    CASH.CASH_NAME,
                    ACCOUNTS.ACCOUNT_NAME,
                    CASE WHEN CR.ACTION_TYPE_ID in ('41','42','45','46','410','420','31','32','310','320','43') THEN CARI_ACTIONS.MULTI_ACTION_ID ELSE NULL END AS  MULTI_ACTION_ID,
                    BR.BRANCH_NAME BRANCH,
                    PR.PROJECT_HEAD PROJECT,
                    ACCOUNT_TYPE
                FROM
                    CARI_ROWS CR
                    <cfif is_paper_closer eq -1>
                        JOIN  CARI_CLOSED_ROW ICR ON CR.ACTION_ID = ICR.ACTION_ID AND CR.ACTION_TYPE_ID = ICR.ACTION_TYPE_ID AND CR.CARI_ACTION_ID = ICR.CARI_ACTION_ID
					    JOIN  CARI_CLOSED ON CARI_CLOSED.CLOSED_ID = ICR.CLOSED_ID
                    </cfif>
                        LEFT JOIN #dsn_alias#.SETUP_ACC_TYPE ON CR.ACC_TYPE_ID=SETUP_ACC_TYPE.ACC_TYPE_ID 
                        LEFT JOIN #dsn_alias#.COMPANY ON ISNULL(CR.FROM_CMP_ID,CR.TO_CMP_ID) = COMPANY.COMPANY_ID 
                        LEFT JOIN #dsn_alias#.CONSUMER ON ISNULL(CR.FROM_CONSUMER_ID,CR.TO_CONSUMER_ID) = CONSUMER.CONSUMER_ID  
                        LEFT JOIN #dsn2_alias#.CASH ON CASH.CASH_ID = ISNULL(CR.FROM_CASH_ID,CR.TO_CASH_ID)
                        LEFT JOIN #dsn3_alias#.ACCOUNTS ON ACCOUNTS.ACCOUNT_ID = ISNULL(CR.FROM_ACCOUNT_ID,CR.TO_ACCOUNT_ID)   
                        LEFT JOIN #dsn2_alias#.CARI_ACTIONS ON CARI_ACTIONS.ACTION_ID = CR.ACTION_ID
                        LEFT JOIN #dsn_alias#.BRANCH BR ON ISNULL(CR.FROM_BRANCH_ID,CR.TO_BRANCH_ID)=BR.BRANCH_ID
                        LEFT JOIN #dsn_alias#.PRO_PROJECTS PR ON CR.PROJECT_ID=PR.PROJECT_ID
                    <cfif action_type_ch_ eq 410 or action_type_ch_ eq 420 or action_type_ch_ eq 430> 
                        ,CARI_ACTIONS CA
                        ,CARI_ACTIONS_MULTI CAM
                    </cfif>
                    <cfif action_type_ch_ eq 310 or action_type_ch_ eq 320>
                        ,CASH_ACTIONS CA
                        ,CASH_ACTIONS_MULTI CAM
                    </cfif>
                    <cfif action_type_ch_ eq 240 or action_type_ch_ eq 253>
                        ,BANK_ACTIONS BA
                        ,BANK_ACTIONS_MULTI BAM
                    </cfif>
                WHERE
                    <cfif len(arguments.emp_id) and len(arguments.employee_name)><!--- EMPLOYEE SECILDI ISE KURUMSAL BIREYSEL KAYIT GETIRMEZ --->
					CR.CARI_ACTION_ID = 0 AND
					</cfif>
					CR.CARI_ACTION_ID > 0
                    AND not (CR.TO_EMPLOYEE_ID IS NOT NULL OR CR.FROM_EMPLOYEE_ID IS NOT NULL)
                <cfif is_paper_closer eq 0>
                    AND (CR.ACTION_ID NOT IN (SELECT ACTION_ID FROM CARI_CLOSED_ROW CHR WHERE CR.ACTION_ID = CHR.ACTION_ID AND CR.ACTION_TYPE_ID = CHR.ACTION_TYPE_ID AND CR.CARI_ACTION_ID = CHR.CARI_ACTION_ID)
                    OR CR.ACTION_ID IN (SELECT ACTION_ID FROM CARI_CLOSED_ROW CHR WHERE CR.ACTION_ID = CHR.ACTION_ID AND CR.ACTION_TYPE_ID = CHR.ACTION_TYPE_ID AND CR.CARI_ACTION_ID = CHR.CARI_ACTION_ID GROUP BY ACTION_ID HAVING SUM(ACTION_VALUE-CLOSED_AMOUNT) > 0)
                    )
                </cfif>
                <cfif action_type_ch_ eq 410 or action_type_ch_ eq 420 or action_type_ch_ eq 430>
                    AND CR.ACTION_ID = CA.ACTION_ID
                    AND CAM.MULTI_ACTION_ID = CA.MULTI_ACTION_ID
                </cfif>
                <cfif action_type_ch_ eq 310 or action_type_ch_ eq 320>
                    AND CR.ACTION_ID = CA.ACTION_ID
                    AND CAM.MULTI_ACTION_ID = CA.MULTI_ACTION_ID
                </cfif>
                <cfif action_type_ch_ eq 240 or action_type_ch_ eq 253>
                    AND CR.ACTION_ID = BA.ACTION_ID
                    AND BA.MULTI_ACTION_ID = BAM.MULTI_ACTION_ID
                </cfif>
                <cfif isdate(arguments.start_date) and not isdate(arguments.finish_date)>
                    AND CR.ACTION_DATE >= #arguments.start_date#
                <cfelseif isdate(arguments.finish_date) and not isdate(arguments.start_date)>
                    AND CR.ACTION_DATE <= #arguments.finish_date#
                <cfelseif isdate(arguments.start_date) and  isdate(arguments.finish_date)>
                    AND CR.ACTION_DATE >= #arguments.start_date#
                    AND CR.ACTION_DATE <= #arguments.finish_date#
                </cfif>
                <cfif isDefined("action_type_ch_") and len(action_cat_ch_)>
                    AND CR.PROCESS_CAT = #action_cat_ch_#
                </cfif>
                <cfif len(arguments.keyword)>
                    AND (
                            CR.ACTION_NAME LIKE '<cfif len(arguments.keyword) gt 2>%</cfif>#arguments.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI OR
                            CR.PAPER_NO LIKE '<cfif len(arguments.keyword) gt 2>%</cfif>#arguments.keyword#%' OR
                            CR.ACTION_DETAIL LIKE '<cfif len(arguments.keyword) gt 2>%</cfif>#arguments.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI
                        )
                </cfif>
                <cfif isdefined("arguments.consumer_id") and len(arguments.consumer_id) and isdefined("arguments.company_name") and len(arguments.company_name)>
                    AND ( CR.TO_CONSUMER_ID = #arguments.consumer_id# OR CR.FROM_CONSUMER_ID = #arguments.consumer_id# )
                </cfif>
                <cfif isdefined("arguments.company_id") and len(arguments.company_id) and isdefined("arguments.company_name") and len(arguments.company_name)>
                    AND ( CR.TO_CMP_ID = #arguments.company_id# OR CR.FROM_CMP_ID = #arguments.company_id# )
                </cfif>
                <cfif isdefined("arguments.subscription_id") and len(arguments.subscription_id) and isdefined("arguments.subscription_no") and len(arguments.subscription_no)>
                    AND CR.SUBSCRIPTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.subscription_id#">
                </cfif>
                <cfif len(list_company) or len(list_consumer)>
                    AND (
                        <cfif len(list_company)>
                            CR.TO_CMP_ID IN (SELECT COMPANY_ID FROM #this.dsn_alias#.COMPANY WHERE COMPANYCAT_ID IN (#list_company#))
                            OR CR.FROM_CMP_ID IN (SELECT COMPANY_ID FROM #this.dsn_alias#.COMPANY WHERE COMPANYCAT_ID IN (#list_company#))
                        </cfif>
                        <cfif len(list_company) and len(list_consumer)>
                            OR
                        </cfif>
                        <cfif len(list_consumer)>
                            CR.TO_CONSUMER_ID IN (SELECT CONSUMER_ID FROM #this.dsn_alias#.CONSUMER WHERE CONSUMER_CAT_ID IN (#list_consumer#))
                            OR CR.FROM_CONSUMER_ID IN (SELECT CONSUMER_ID FROM #this.dsn_alias#.CONSUMER WHERE CONSUMER_CAT_ID IN (#list_consumer#))
                        </cfif>
                        <cfif ((not len(list_consumer) and len(list_company)) or (len(list_consumer) and len(list_company)) or (len(list_consumer) and not len(list_company))) and len(list_acc_type_id)>
                            OR
                        </cfif>
                       
                    )
                </cfif>
                <cfif session.ep.isBranchAuthorization>
                    AND	(CR.TO_BRANCH_ID IN (SELECT BRANCH_ID FROM #dsn_alias#.EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">) OR CR.FROM_BRANCH_ID IN (SELECT BRANCH_ID FROM #dsn_alias#.EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">))
                </cfif>
                <cfif isdefined('arguments.branch_id') and len(arguments.branch_id)>
                    AND	(CR.TO_BRANCH_ID = #arguments.branch_id# OR CR.FROM_BRANCH_ID = #arguments.branch_id#)
                </cfif>
                <cfif len(arguments.record_emp) and len(arguments.record_name)>
                    AND CR.RECORD_EMP = #arguments.record_emp#
                </cfif>
                <cfif isdefined("arguments.asset_id") and len(arguments.asset_id) and len(arguments.asset_name)>
                    AND CR.ASSETP_ID = #arguments.asset_id#
                </cfif>
                <cfif isdefined("arguments.expense_center_id") and len(arguments.expense_center_id) and len(arguments.expense_center_name)>
                    AND CR.EXPENSE_CENTER_ID = #arguments.expense_center_id#
                </cfif>
                <cfif isdefined("arguments.expense_item_id") and len(arguments.expense_item_id) and len(arguments.expense_item_name)>
                    AND CR.EXPENSE_ITEM_ID = #arguments.expense_item_id#
                </cfif>
                <cfif isDefined("arguments.special_definition_id") and len(arguments.special_definition_id) and arguments.special_definition_id eq '-1'>
                    AND CR.SPECIAL_DEFINITION_ID IN (SELECT SPECIAL_DEFINITION_ID FROM #this.dsn_alias#.SETUP_SPECIAL_DEFINITION WHERE SPECIAL_DEFINITION_TYPE = 1)
                <cfelseif isDefined("arguments.special_definition_id") and len(arguments.special_definition_id) and arguments.special_definition_id eq '-2'>
                    AND CR.SPECIAL_DEFINITION_ID IN (SELECT SPECIAL_DEFINITION_ID FROM #this.dsn_alias#.SETUP_SPECIAL_DEFINITION WHERE SPECIAL_DEFINITION_TYPE = 2)
                <cfelseif isDefined("arguments.special_definition_id") and len(arguments.special_definition_id)>
                    AND CR.SPECIAL_DEFINITION_ID = #arguments.special_definition_id#
                </cfif>
                <cfif isdefined("arguments.acc_type") and len(arguments.acc_type)>
                    AND CR.ACC_TYPE_ID = #arguments.acc_type#
                <cfelseif isdefined("arguments.acc_type_id") and len(arguments.acc_type_id)>
                    AND CR.ACC_TYPE_ID = #arguments.acc_type_id#
                </cfif>
                <cfif len(arguments.project_head) and isdefined("arguments.project_id") and len(arguments.project_id)>
                    AND CR.PROJECT_ID = #arguments.project_id#
                </cfif>
                <cfif isdefined("arguments.pos_code") and len(arguments.pos_code) and len(arguments.pos_code_text)>
                    AND
                    (
                        CR.TO_CMP_ID IN (SELECT COMPANY_ID FROM #this.dsn_alias#.WORKGROUP_EMP_PAR WHERE POSITION_CODE = #arguments.pos_code# AND IS_MASTER=1 AND OUR_COMPANY_ID = #session.ep.company_id#) OR
                        CR.FROM_CMP_ID IN (SELECT COMPANY_ID FROM #this.dsn_alias#.WORKGROUP_EMP_PAR WHERE POSITION_CODE = #arguments.pos_code# AND IS_MASTER=1 AND OUR_COMPANY_ID = #session.ep.company_id#)
                    )
                </cfif>
                <cfif isdefined("x_control_ims") and x_control_ims eq 1 and  session.ep.our_company_info.sales_zone_followup eq 1>		
					AND
					(
						(COMPANY.COMPANY_ID IS NULL) 
						OR (COMPANY.COMPANY_ID IN (#PreserveSingleQuotes(my_ims_comp_list)#))
					)
				</cfif>
                <cfif not len(arguments.company_id) and not len(arguments.company_name) and not len(arguments.consumer_id)>
                    UNION ALL <!--- çALIŞANLAR İÇİN --->
                    SELECT 
                        CR.CARI_ACTION_ID,
                        CR.ACTION_ID, 
                        CR.ACTION_TABLE,
                        CR.PAPER_NO,
                        CR.ACTION_TYPE_ID,
                        CR.ACTION_NAME,
                        CR.TO_CMP_ID,
                        CR.FROM_CMP_ID,
                        CR.TO_ACCOUNT_ID,
                        CR.FROM_ACCOUNT_ID,
                        CR.FROM_CASH_ID,
                        CR.TO_CASH_ID,
                        CR.FROM_EMPLOYEE_ID,
                        CR.TO_EMPLOYEE_ID,
                        CR.FROM_CONSUMER_ID,
                        CR.TO_CONSUMER_ID,
                        CR.ACTION_VALUE,
                        CR.ACTION_DATE,
                        CR.RECORD_DATE,
                        CR.OTHER_CASH_ACT_VALUE,
                        CR.OTHER_MONEY,
                        CR.ACTION_CURRENCY_ID,
                        CR.REVENUE_COLLECTOR_ID,
                        CR.IS_PROCESSED,
                        CR.ACTION_DETAIL,
                        CR.RECORD_EMP,
                        CR.ACC_TYPE_ID,
                        CR.SUBSCRIPTION_ID,
                        ISNULL(CR.TO_CMP_ID,CR.FROM_CMP_ID) COMP_ID,
                        ISNULL(CR.TO_CONSUMER_ID,CR.FROM_CONSUMER_ID) CONS_ID,
                        ISNULL(CR.TO_EMPLOYEE_ID,CR.FROM_EMPLOYEE_ID) EMP_ID,
                        SETUP_ACC_TYPE.ACC_TYPE_NAME,
                        '' as NICKNAME, 
                        '' as MEMBER_CODE,
                        '' AS FULLNAME, 
                        '' AS  CONSUMER_MEMBER_CODE,
                        EMPLOYEE_NAME + ' ' + EMPLOYEE_SURNAME AS EMPLOYEE_FULLNAME, 
                        EMPLOYEES.MEMBER_CODE AS EMPLOYEE_MEMBER_CODE,
                        CASH.CASH_NAME,
                        ACCOUNTS.ACCOUNT_NAME,
                        CASE WHEN CR.ACTION_TYPE_ID in ('41','42','45','46','410','420','31','32','310','320','43') THEN CARI_ACTIONS.MULTI_ACTION_ID ELSE NULL END AS  MULTI_ACTION_ID,
                        BR.BRANCH_NAME BRANCH,
                        PR.PROJECT_HEAD PROJECT,
                        ACCOUNT_TYPE
                    FROM
                        CARI_ROWS CR
                        <cfif is_paper_closer eq -1>
                            JOIN  CARI_CLOSED_ROW ICR ON CR.ACTION_ID = ICR.ACTION_ID AND CR.ACTION_TYPE_ID = ICR.ACTION_TYPE_ID AND CR.CARI_ACTION_ID = ICR.CARI_ACTION_ID
                            JOIN  CARI_CLOSED ON CARI_CLOSED.CLOSED_ID = ICR.CLOSED_ID
                        </cfif>
                            LEFT JOIN #dsn_alias#.SETUP_ACC_TYPE ON CR.ACC_TYPE_ID=SETUP_ACC_TYPE.ACC_TYPE_ID 
                            LEFT JOIN #dsn_alias#.EMPLOYEES ON ISNULL(CR.FROM_EMPLOYEE_ID,CR.TO_EMPLOYEE_ID) = EMPLOYEES.EMPLOYEE_ID       
                            LEFT JOIN #dsn2_alias#.CASH ON CASH.CASH_ID = ISNULL(CR.FROM_CASH_ID,CR.TO_CASH_ID)
                            LEFT JOIN #dsn3_alias#.ACCOUNTS ON ACCOUNTS.ACCOUNT_ID = ISNULL(CR.FROM_ACCOUNT_ID,CR.TO_ACCOUNT_ID)   
                            LEFT JOIN #dsn2_alias#.CARI_ACTIONS ON CARI_ACTIONS.ACTION_ID = CR.ACTION_ID
                            LEFT JOIN #dsn_alias#.BRANCH BR ON ISNULL(CR.FROM_BRANCH_ID,CR.TO_BRANCH_ID)=BR.BRANCH_ID
                            LEFT JOIN #dsn_alias#.PRO_PROJECTS PR ON CR.PROJECT_ID=PR.PROJECT_ID
                        <cfif action_type_ch_ eq 410 or action_type_ch_ eq 420 or action_type_ch_ eq 430> 
                            ,CARI_ACTIONS CA
                            ,CARI_ACTIONS_MULTI CAM
                        </cfif>
                        <cfif action_type_ch_ eq 310 or action_type_ch_ eq 320>
                            ,CASH_ACTIONS CA
                            ,CASH_ACTIONS_MULTI CAM
                        </cfif>
                        <cfif action_type_ch_ eq 240 or action_type_ch_ eq 253>
                            ,BANK_ACTIONS BA
                            ,BANK_ACTIONS_MULTI BAM
                        </cfif>
                    WHERE
                        CR.CARI_ACTION_ID > 0
                          AND (CR.TO_EMPLOYEE_ID IS NOT NULL OR CR.FROM_EMPLOYEE_ID IS NOT NULL)
                    <cfif is_paper_closer eq 0>
                        AND (CR.ACTION_ID NOT IN (SELECT ACTION_ID FROM CARI_CLOSED_ROW CHR WHERE CR.ACTION_ID = CHR.ACTION_ID AND CR.ACTION_TYPE_ID = CHR.ACTION_TYPE_ID AND CR.CARI_ACTION_ID = CHR.CARI_ACTION_ID)
                        OR CR.ACTION_ID IN (SELECT ACTION_ID FROM CARI_CLOSED_ROW CHR WHERE CR.ACTION_ID = CHR.ACTION_ID AND CR.ACTION_TYPE_ID = CHR.ACTION_TYPE_ID AND CR.CARI_ACTION_ID = CHR.CARI_ACTION_ID GROUP BY ACTION_ID HAVING SUM(ACTION_VALUE-CLOSED_AMOUNT) > 0)
                        )
                    </cfif>
                    <cfif action_type_ch_ eq 410 or action_type_ch_ eq 420 or action_type_ch_ eq 430>
                        AND CR.ACTION_ID = CA.ACTION_ID
                        AND CAM.MULTI_ACTION_ID = CA.MULTI_ACTION_ID
                    </cfif>
                    <cfif action_type_ch_ eq 310 or action_type_ch_ eq 320>
                        AND CR.ACTION_ID = CA.ACTION_ID
                        AND CAM.MULTI_ACTION_ID = CA.MULTI_ACTION_ID
                    </cfif>
                    <cfif action_type_ch_ eq 240 or action_type_ch_ eq 253>
                        AND CR.ACTION_ID = BA.ACTION_ID
                        AND BA.MULTI_ACTION_ID = BAM.MULTI_ACTION_ID
                    </cfif>
                    <cfif (len(hr_type_list) or len(ehesap_type_list) or len(other_type_list)) and not ( (isdefined("arguments.company_id") and len(arguments.company_id) and isdefined("arguments.company_name") and len(arguments.company_name)) or (isdefined("arguments.consumer_id") and len(arguments.consumer_id) and isdefined("arguments.company_name") and len(arguments.company_name)))><!--- İk veya ehesap süper kullanıcı yetkisine bakılacak tip varsa --->
                        AND #control_acc_type_list#
                    <cfelseif not module_power_user_ehesap>
                        AND CR.TO_EMPLOYEE_ID IS NULL
                        AND CR.FROM_EMPLOYEE_ID IS NULL
                    </cfif>
                    <cfif isdate(arguments.start_date) and not isdate(arguments.finish_date)>
                        AND CR.ACTION_DATE >= #arguments.start_date#
                    <cfelseif isdate(arguments.finish_date) and not isdate(arguments.start_date)>
                        AND CR.ACTION_DATE <= #arguments.finish_date#
                    <cfelseif isdate(arguments.start_date) and  isdate(arguments.finish_date)>
                        AND CR.ACTION_DATE >= #arguments.start_date#
                        AND CR.ACTION_DATE <= #arguments.finish_date#
                    </cfif>
                    <cfif isDefined("action_type_ch_") and len(action_cat_ch_)>
                        AND CR.PROCESS_CAT = #action_cat_ch_#
                    </cfif>
                    <cfif len(arguments.keyword)>
                        AND (
                                CR.ACTION_NAME LIKE '<cfif len(arguments.keyword) gt 2>%</cfif>#arguments.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI OR
                                CR.PAPER_NO LIKE '<cfif len(arguments.keyword) gt 2>%</cfif>#arguments.keyword#%' OR
                                CR.ACTION_DETAIL LIKE '<cfif len(arguments.keyword) gt 2>%</cfif>#arguments.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI
                            )
                    </cfif>
                    <cfif isdefined("arguments.emp_id") and len(arguments.emp_id) and isdefined("arguments.employee_name") and len(arguments.employee_name)>
                        AND ( CR.TO_EMPLOYEE_ID = #arguments.emp_id# OR CR.FROM_EMPLOYEE_ID = #arguments.emp_id# )
                    </cfif>
                    <cfif isdefined("arguments.subscription_id") and len(arguments.subscription_id) and isdefined("arguments.subscription_no") and len(arguments.subscription_no)>
                        AND CR.SUBSCRIPTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.subscription_id#">
                    </cfif>
                    <cfif len(list_acc_type_id)>
                        AND (
                            <cfif len(list_acc_type_id)>
                                CR.TO_EMPLOYEE_ID IN (SELECT EMPLOYEE_ID FROM #this.dsn_alias#.EMPLOYEES_ACCOUNTS WHERE EMPLOYEES_ACCOUNTS.ACC_TYPE_ID IN (#list_acc_type_id#) AND CR.ACC_TYPE_ID IN (#list_acc_type_id#))
                                OR CR.FROM_EMPLOYEE_ID IN (SELECT EMPLOYEE_ID FROM #this.dsn_alias#.EMPLOYEES_ACCOUNTS WHERE EMPLOYEES_ACCOUNTS.ACC_TYPE_ID IN (#list_acc_type_id#) AND CR.ACC_TYPE_ID IN (#list_acc_type_id#))
                            </cfif>
                        )
                    </cfif>
                    <cfif session.ep.isBranchAuthorization>
                        AND	(CR.TO_BRANCH_ID IN (SELECT BRANCH_ID FROM #dsn_alias#.EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">) OR CR.FROM_BRANCH_ID IN (SELECT BRANCH_ID FROM #dsn_alias#.EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">))
                    </cfif>
                    <cfif isdefined('arguments.branch_id') and len(arguments.branch_id)>
                        AND	(CR.TO_BRANCH_ID = #arguments.branch_id# OR CR.FROM_BRANCH_ID = #arguments.branch_id#)
                    </cfif>
                    <cfif len(arguments.record_emp) and len(arguments.record_name)>
                        AND CR.RECORD_EMP = #arguments.record_emp#
                    </cfif>
                    <cfif isdefined("arguments.asset_id") and len(arguments.asset_id) and len(arguments.asset_name)>
                        AND CR.ASSETP_ID = #arguments.asset_id#
                    </cfif>
                    <cfif isdefined("arguments.expense_center_id") and len(arguments.expense_center_id) and len(arguments.expense_center_name)>
                        AND CR.EXPENSE_CENTER_ID = #arguments.expense_center_id#
                    </cfif>
                    <cfif isdefined("arguments.expense_item_id") and len(arguments.expense_item_id) and len(arguments.expense_item_name)>
                        AND CR.EXPENSE_ITEM_ID = #arguments.expense_item_id#
                    </cfif>
                    <cfif isDefined("arguments.special_definition_id") and len(arguments.special_definition_id) and arguments.special_definition_id eq '-1'>
                        AND CR.SPECIAL_DEFINITION_ID IN (SELECT SPECIAL_DEFINITION_ID FROM #this.dsn_alias#.SETUP_SPECIAL_DEFINITION WHERE SPECIAL_DEFINITION_TYPE = 1)
                    <cfelseif isDefined("arguments.special_definition_id") and len(arguments.special_definition_id) and arguments.special_definition_id eq '-2'>
                        AND CR.SPECIAL_DEFINITION_ID IN (SELECT SPECIAL_DEFINITION_ID FROM #this.dsn_alias#.SETUP_SPECIAL_DEFINITION WHERE SPECIAL_DEFINITION_TYPE = 2)
                    <cfelseif isDefined("arguments.special_definition_id") and len(arguments.special_definition_id)>
                        AND CR.SPECIAL_DEFINITION_ID = #arguments.special_definition_id#
                    </cfif>
                    <cfif isdefined("arguments.acc_type") and len(arguments.acc_type)>
                        AND CR.ACC_TYPE_ID = #arguments.acc_type#
                    <cfelseif isdefined("arguments.acc_type_id") and len(arguments.acc_type_id)>
                        AND CR.ACC_TYPE_ID = #arguments.acc_type_id#
                    </cfif>
                    <cfif len(arguments.project_head) and isdefined("arguments.project_id") and len(arguments.project_id)>
                        AND CR.PROJECT_ID = #arguments.project_id#
                    </cfif>
                    <cfif isdefined("x_control_ims") and x_control_ims eq 1 and  session.ep.our_company_info.sales_zone_followup eq 1>			
                        AND
                        (
                            (CONSUMER_ID IS NULL) 
                            OR (CONSUMER_ID IN (#PreserveSingleQuotes(my_ims_cons_list)#))
                        )
				    </cfif>
                </cfif>
                ),
                    CTE2 AS (
                        SELECT
                            CTE1.*,
                            ROW_NUMBER() OVER (
                                <cfif isDefined('arguments.oby') and arguments.oby eq 2>
                                    ORDER BY ACTION_DATE
                                <cfelseif isDefined('arguments.oby') and arguments.oby eq 3>
                                    ORDER BY PAPER_NO
                                <cfelseif isDefined('arguments.oby') and arguments.oby eq 4>
                                    ORDER BY PAPER_NO DESC
                                <cfelse>
                                    ORDER BY ACTION_DATE DESC
                                </cfif>
                    ) AS RowNum,(SELECT COUNT(*) FROM CTE1) AS QUERY_COUNT
                        FROM
                            CTE1
                    )
                    SELECT
                        CTE2.*
                    FROM
                        CTE2
                    WHERE
                        RowNum BETWEEN #startrow# and #startrow#+(#maxrows#-1)
                    <cfif isDefined('arguments.oby') and arguments.oby eq 2>
                        ORDER BY CTE2.ACTION_DATE, CTE2.RECORD_DATE
                    <cfelseif isDefined('arguments.oby') and arguments.oby eq 3>
                        ORDER BY CTE2.PAPER_NO
                    <cfelseif isDefined('arguments.oby') and arguments.oby eq 4>
                        ORDER BY CTE2.PAPER_NO DESC
                    <cfelse>
                        ORDER BY CTE2.ACTION_DATE DESC, CTE2.RECORD_DATE DESC
                    </cfif>
            </cfquery>
            <cfset returnValue = GET_CARIS>
        <cfelseif isdefined("arguments.is_excel") and arguments.is_excel eq 1>
            <cfset sheet = 1>
            <cfset sheetsize = 60000>
            <cfset querycount = 70000>
            <cfscript>
            	prepareDirectory(this.upload_folder);
            </cfscript>
            <cfset uuid=CreateUUID()>
            <cfloop condition="sheet lte (Int(querycount/sheetsize)+1)">
            	<cfset columnlist = ''>
                <cfset startrow = (sheet-1)*sheetsize +1>
                <cfset maxrows = sheet * sheetsize>
                <cfif maxrows gt querycount>
                	<cfset maxrows = querycount>
                </cfif>
                <cfquery name="GET_EXCEL" datasource="#this.dsn2#">
                    WITH CTE1 AS (
                        SELECT 
                            CR.CARI_ACTION_ID,
                            CR.ACTION_ID, 
                            CR.ACTION_TABLE,
                            CR.PAPER_NO,
                            CR.ACTION_TYPE_ID,
                            CR.ACTION_NAME,
                            CR.TO_CMP_ID,
                            CR.FROM_CMP_ID,
                            CR.TO_ACCOUNT_ID,
                            CR.FROM_ACCOUNT_ID,
                            CR.FROM_CASH_ID,
                            CR.TO_CASH_ID,
                            CR.FROM_EMPLOYEE_ID,
                            CR.TO_EMPLOYEE_ID,
                            CR.FROM_CONSUMER_ID,
                            CR.TO_CONSUMER_ID,
                            CR.ACTION_VALUE,
                            CR.ACTION_DATE,
                            CR.RECORD_DATE,
                            CR.OTHER_CASH_ACT_VALUE,
                            CR.OTHER_MONEY,
                            CR.ACTION_CURRENCY_ID,
                            CR.REVENUE_COLLECTOR_ID,
                            CR.IS_PROCESSED,
                            CR.ACTION_DETAIL,
                            CR.RECORD_EMP,
                            CR.ACC_TYPE_ID,
                            ISNULL(CR.TO_CMP_ID,CR.FROM_CMP_ID) COMP_ID,
                            ISNULL(CR.TO_CONSUMER_ID,CR.FROM_CONSUMER_ID) CONS_ID,
                            ISNULL(CR.TO_EMPLOYEE_ID,CR.FROM_EMPLOYEE_ID) EMP_ID,
                            SETUP_ACC_TYPE.ACC_TYPE_NAME,
                            COMPANY.NICKNAME, 
                            COMPANY.MEMBER_CODE,
                            CONSUMER_NAME + ' ' + CONSUMER_SURNAME AS FULLNAME, 
                            CONSUMER.MEMBER_CODE AS  CONSUMER_MEMBER_CODE,
                            EMPLOYEE_NAME + ' ' + EMPLOYEE_SURNAME AS EMPLOYEE_FULLNAME, 
                            EMPLOYEES.MEMBER_CODE AS EMPLOYEE_MEMBER_CODE,
                            CASH.CASH_NAME,
                            ACCOUNTS.ACCOUNT_NAME,
                            CASE WHEN CR.ACTION_TYPE_ID in ('41','42','45','46','410','420','31','32','310','320','43') THEN CARI_ACTIONS.MULTI_ACTION_ID ELSE NULL END AS  MULTI_ACTION_ID,
                            BR.BRANCH_NAME BRANCH,
                            PR.PROJECT_HEAD PROJECT,
                            ACCOUNT_TYPE,
                            ROW_NUMBER() OVER (
                                    <cfif isDefined('arguments.oby') and arguments.oby eq 2>
                                        ORDER BY CR.ACTION_DATE
                                    <cfelseif isDefined('arguments.oby') and arguments.oby eq 3>
                                        ORDER BY CR.PAPER_NO
                                    <cfelseif isDefined('arguments.oby') and arguments.oby eq 4>
                                        ORDER BY CR.PAPER_NO DESC
                                    <cfelse>
                                        ORDER BY CR.ACTION_DATE DESC
                                    </cfif>
                            ) AS RowNum
                        FROM
                            CARI_ROWS CR
                                LEFT JOIN #dsn_alias#.SETUP_ACC_TYPE ON CR.ACC_TYPE_ID=SETUP_ACC_TYPE.ACC_TYPE_ID 
                                LEFT JOIN #dsn_alias#.COMPANY ON ISNULL(CR.FROM_CMP_ID,CR.TO_CMP_ID) = COMPANY.COMPANY_ID 
                                LEFT JOIN #dsn_alias#.CONSUMER ON ISNULL(CR.FROM_CONSUMER_ID,CR.TO_CONSUMER_ID) = CONSUMER.CONSUMER_ID
                                LEFT JOIN #dsn_alias#.EMPLOYEES ON ISNULL(CR.FROM_EMPLOYEE_ID,CR.TO_EMPLOYEE_ID) = EMPLOYEES.EMPLOYEE_ID       
                                LEFT JOIN #dsn2_alias#.CASH ON CASH.CASH_ID = ISNULL(CR.FROM_CASH_ID,CR.TO_CASH_ID)
                                LEFT JOIN #dsn3_alias#.ACCOUNTS ON ACCOUNTS.ACCOUNT_ID = ISNULL(CR.FROM_ACCOUNT_ID,CR.TO_ACCOUNT_ID)   
                                LEFT JOIN #dsn2_alias#.CARI_ACTIONS ON CARI_ACTIONS.ACTION_ID = CR.ACTION_ID
                                LEFT JOIN #dsn_alias#.BRANCH BR ON ISNULL(CR.FROM_BRANCH_ID,CR.TO_BRANCH_ID)=BR.BRANCH_ID
                                LEFT JOIN #dsn_alias#.PRO_PROJECTS PR ON CR.PROJECT_ID=PR.PROJECT_ID
                            <cfif action_type_ch_ eq 410 or action_type_ch_ eq 420 or action_type_ch_ eq 430>
                                ,CARI_ACTIONS CA
                                ,CARI_ACTIONS_MULTI CAM
                            </cfif>
                            <cfif action_type_ch_ eq 310 or action_type_ch_ eq 320>
                                ,CASH_ACTIONS CA
                                ,CASH_ACTIONS_MULTI CAM
                            </cfif>
                            <cfif action_type_ch_ eq 240 or action_type_ch_ eq 253>
                                ,BANK_ACTIONS BA
                                ,BANK_ACTIONS_MULTI BAM
                            </cfif>
                        WHERE
                            CR.CARI_ACTION_ID > 0
                        <cfif action_type_ch_ eq 410 or action_type_ch_ eq 420 or action_type_ch_ eq 430>
                            AND CR.ACTION_ID = CA.ACTION_ID
                            AND CAM.MULTI_ACTION_ID = CA.MULTI_ACTION_ID
                        </cfif>
                        <cfif action_type_ch_ eq 310 or action_type_ch_ eq 320>
                            AND CR.ACTION_ID = CA.ACTION_ID
                            AND CAM.MULTI_ACTION_ID = CA.MULTI_ACTION_ID
                        </cfif>
                        <cfif action_type_ch_ eq 240 or action_type_ch_ eq 253>
                            AND CR.ACTION_ID = BA.ACTION_ID
                            AND BA.MULTI_ACTION_ID = BAM.MULTI_ACTION_ID
                        </cfif>
                        <cfif len(hr_type_list) or len(ehesap_type_list) or len(other_type_list)><!--- İk veya ehesap süper kullanıcı yetkisine bakılacak tip varsa --->
                            AND #control_acc_type_list#
                        <cfelseif not module_power_user_ehesap>
                            AND CR.TO_EMPLOYEE_ID IS NULL
                            AND CR.FROM_EMPLOYEE_ID IS NULL
                        </cfif>
                        <cfif isdate(arguments.start_date) and not isdate(arguments.finish_date)>
                            AND CR.ACTION_DATE >= #arguments.start_date#
                        <cfelseif isdate(arguments.finish_date) and not isdate(arguments.start_date)>
                            AND CR.ACTION_DATE <= #arguments.finish_date#
                        <cfelseif isdate(arguments.start_date) and  isdate(arguments.finish_date)>
                            AND CR.ACTION_DATE >= #arguments.start_date#
                            AND CR.ACTION_DATE <= #arguments.finish_date#
                        </cfif>
                        <cfif isDefined("action_type_ch_") and len(action_cat_ch_)>
                            AND CR.PROCESS_CAT = #action_cat_ch_#
                        </cfif>
                        <cfif len(arguments.keyword)>
                            AND (
                                    CR.ACTION_NAME LIKE '<cfif len(arguments.keyword) gt 2>%</cfif>#arguments.keyword#%' OR
                                    CR.PAPER_NO LIKE '<cfif len(arguments.keyword) gt 2>%</cfif>#arguments.keyword#%' OR
                                    CR.ACTION_DETAIL LIKE '<cfif len(arguments.keyword) gt 2>%</cfif>#arguments.keyword#%'
                                )
                        </cfif>
                        <cfif isdefined("arguments.consumer_id") and len(arguments.consumer_id) and isdefined("arguments.company_name") and len(arguments.company_name)>
                            AND ( CR.TO_CONSUMER_ID = #arguments.consumer_id# OR CR.FROM_CONSUMER_ID = #arguments.consumer_id# )
                        </cfif>
                        <cfif isdefined("arguments.company_id") and len(arguments.company_id) and isdefined("arguments.company_name") and len(arguments.company_name)>
                            AND ( CR.TO_CMP_ID = #arguments.company_id# OR CR.FROM_CMP_ID = #arguments.company_id# )
                        </cfif>
                        <cfif isdefined("arguments.emp_id") and len(arguments.emp_id) and isdefined("arguments.employee_name") and len(arguments.employee_name)>
                            AND ( CR.TO_EMPLOYEE_ID = #arguments.emp_id# OR CR.FROM_EMPLOYEE_ID = #arguments.emp_id# )
                        </cfif>
                        <cfif len(list_company) or len(list_consumer) or len(list_acc_type_id)>
                            AND (
                                <cfif len(list_company)>
                                    CR.TO_CMP_ID IN (SELECT COMPANY_ID FROM #this.dsn_alias#.COMPANY WHERE COMPANYCAT_ID IN (#list_company#))
                                    OR CR.FROM_CMP_ID IN (SELECT COMPANY_ID FROM #this.dsn_alias#.COMPANY WHERE COMPANYCAT_ID IN (#list_company#))
                                </cfif>
                                <cfif len(list_company) and len(list_consumer)>
                                    OR
                                </cfif>
                                <cfif len(list_consumer)>
                                    CR.TO_CONSUMER_ID IN (SELECT CONSUMER_ID FROM #this.dsn_alias#.CONSUMER WHERE CONSUMER_CAT_ID IN (#list_consumer#))
                                    OR CR.FROM_CONSUMER_ID IN (SELECT CONSUMER_ID FROM #this.dsn_alias#.CONSUMER WHERE CONSUMER_CAT_ID IN (#list_consumer#))
                                </cfif>
                                <cfif ((not len(list_consumer) and len(list_company)) or (len(list_consumer) and len(list_company)) or (len(list_consumer) and not len(list_company))) and len(list_acc_type_id)>
                                    OR
                                </cfif>
                                <cfif len(list_acc_type_id)>
                                    CR.TO_EMPLOYEE_ID IN (SELECT EMPLOYEE_ID FROM #this.dsn_alias#.EMPLOYEES_ACCOUNTS WHERE EMPLOYEES_ACCOUNTS.ACC_TYPE_ID IN (#list_acc_type_id#) AND CR.ACC_TYPE_ID IN (#list_acc_type_id#))
                                    OR CR.FROM_EMPLOYEE_ID IN (SELECT EMPLOYEE_ID FROM #this.dsn_alias#.EMPLOYEES_ACCOUNTS WHERE EMPLOYEES_ACCOUNTS.ACC_TYPE_ID IN (#list_acc_type_id#) AND CR.ACC_TYPE_ID IN (#list_acc_type_id#))
                                </cfif>
                            )
                        </cfif>
                        <cfif session.ep.isBranchAuthorization>
                            AND	(CR.TO_BRANCH_ID IN (SELECT BRANCH_ID FROM #dsn_alias#.EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">) OR CR.FROM_BRANCH_ID IN (SELECT BRANCH_ID FROM #dsn_alias#.EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">))
                        </cfif>
                        <cfif isdefined('arguments.branch_id') and len(arguments.branch_id)>
                            AND	(CR.TO_BRANCH_ID = #arguments.branch_id# OR CR.FROM_BRANCH_ID = #arguments.branch_id#)
                        </cfif>
                        <cfif len(arguments.record_emp) and len(arguments.record_name)>
                            AND CR.RECORD_EMP = #arguments.record_emp#
                        </cfif>
                        <cfif isdefined("arguments.asset_id") and len(arguments.asset_id) and len(arguments.asset_name)>
                            AND CR.ASSETP_ID = #arguments.asset_id#
                        </cfif>
                        <cfif isdefined("arguments.expense_center_id") and len(arguments.expense_center_id) and len(arguments.expense_center_name)>
                            AND CR.EXPENSE_CENTER_ID = #arguments.expense_center_id#
                        </cfif>
                        <cfif isdefined("arguments.expense_item_id") and len(arguments.expense_item_id) and len(arguments.expense_item_name)>
                            AND CR.EXPENSE_ITEM_ID = #arguments.expense_item_id#
                        </cfif>
                        <cfif isDefined("arguments.special_definition_id") and len(arguments.special_definition_id) and arguments.special_definition_id eq '-1'>
                            AND CR.SPECIAL_DEFINITION_ID IN (SELECT SPECIAL_DEFINITION_ID FROM #this.dsn_alias#.SETUP_SPECIAL_DEFINITION WHERE SPECIAL_DEFINITION_TYPE = 1)
                        <cfelseif isDefined("arguments.special_definition_id") and len(arguments.special_definition_id) and arguments.special_definition_id eq '-2'>
                            AND CR.SPECIAL_DEFINITION_ID IN (SELECT SPECIAL_DEFINITION_ID FROM #this.dsn_alias#.SETUP_SPECIAL_DEFINITION WHERE SPECIAL_DEFINITION_TYPE = 2)
                        <cfelseif isDefined("arguments.special_definition_id") and len(arguments.special_definition_id)>
                            AND CR.SPECIAL_DEFINITION_ID = #arguments.special_definition_id#
                        </cfif>
                        <cfif isdefined("arguments.acc_type_id") and len(arguments.acc_type_id)>
                            AND CR.ACC_TYPE_ID = #arguments.acc_type_id#
                        </cfif>
                        <cfif len(arguments.project_head) and isdefined("arguments.project_id") and len(arguments.project_id)>
                            AND CR.PROJECT_ID = #arguments.project_id#
                        </cfif>
                        <cfif isdefined("arguments.pos_code") and len(arguments.pos_code) and len(arguments.pos_code_text)>
                            AND
                            (
                                CR.TO_CMP_ID IN (SELECT COMPANY_ID FROM #this.dsn_alias#.WORKGROUP_EMP_PAR WHERE POSITION_CODE = #arguments.pos_code# AND IS_MASTER=1 AND OUR_COMPANY_ID = #session.ep.company_id#) OR
                                CR.FROM_CMP_ID IN (SELECT COMPANY_ID FROM #this.dsn_alias#.WORKGROUP_EMP_PAR WHERE POSITION_CODE = #arguments.pos_code# AND IS_MASTER=1 AND OUR_COMPANY_ID = #session.ep.company_id#)
                            )
                        <cfif isdefined("x_control_ims") and x_control_ims eq 1 and  session.ep.our_company_info.sales_zone_followup eq 1>		
                            AND
                            (
                                (COMPANY.COMPANY_ID IS NULL) 
                                OR (COMPANY.COMPANY_ID IN (#PreserveSingleQuotes(my_ims_comp_list)#))
                            )
				        </cfif>
                        </cfif>
                        ),
                        CTE2 AS (
                            SELECT
                                ROWNUM,
                                PAPER_NO,
                                ACTION_NAME,
                                BRANCH,
                                PROJECT,
                                CASE
                                    WHEN ISNULL(FROM_ACCOUNT_ID,TO_ACCOUNT_ID) IS NOT NULL THEN ACCOUNT_NAME
                                    WHEN ISNULL(FROM_CASH_ID,TO_CASH_ID) IS NOT NULL THEN CASH_NAME
                                ELSE
                                    ''
                                END AS ACCOUNT,
                                ISNULL(MEMBER_CODE,ISNULL(CONSUMER_MEMBER_CODE,EMPLOYEE_MEMBER_CODE)) AS MEMBER_CODE,
                                CASE
                                    WHEN ACC_TYPE_NAME IS NOT NULL THEN ISNULL(NICKNAME,ISNULL(FULLNAME,EMPLOYEE_FULLNAME)) + ' - ' +  ACC_TYPE_NAME
                                ELSE
                                    ISNULL(NICKNAME,ISNULL(FULLNAME,EMPLOYEE_FULLNAME))
                                END AS MEMBER_NAME,
                                ACTION_VALUE,
                                ACTION_CURRENCY_ID, 
                                OTHER_CASH_ACT_VALUE,
                                OTHER_MONEY,
                                ACTION_DETAIL,
                                ACTION_DATE,
                                (SELECT COUNT(*) FROM CTE1) AS QUERY_COUNT
                            FROM
                                CTE1
                            WHERE
                            	ROWNUM BETWEEN #startrow# AND #maxrows#
                        ),
                         CTE3 AS (
                            SELECT
                                SUM(ACTION_VALUE) TOTAL,
                                ACTION_CURRENCY_ID,
                                ROW_NUMBER() OVER (ORDER BY ACTION_CURRENCY_ID) AS ACTION_RN
                            FROM
                                CTE1
                            GROUP BY
                                ACTION_CURRENCY_ID
                        ),
                        CTE4 AS (
                            SELECT
                                SUM(OTHER_CASH_ACT_VALUE) OTHER_TOTAL,
                                OTHER_MONEY,
                                ROW_NUMBER() OVER (ORDER BY OTHER_MONEY) AS OTHER_RN
                            FROM
                                CTE1
                            GROUP BY
                                OTHER_MONEY
                        )
                        SELECT
                                ROWNUM 'No', <cfset columnlist = columnlist & 'No,'>
                                PAPER_NO 'Belge No', <cfset columnlist = columnlist & 'Belge No,'>
                                ACTION_NAME 'İşlem', <cfset columnlist = columnlist & 'İşlem,'>
                                <cfif x_branch_info>
                                    BRANCH 'Şube', <cfset columnlist = columnlist & 'Şube,'>
                                </cfif>
                                <cfif x_project_info>
                                    PROJECT 'Proje', <cfset columnlist = columnlist & 'Proje,'>
                                </cfif>
                                ACCOUNT 'Hesap', <cfset columnlist = columnlist & 'Hesap,'>
                                MEMBER_CODE 'Üye No', <cfset columnlist = columnlist & 'Üye No,'>
                                MEMBER_NAME 'Cari Hesap', <cfset columnlist = columnlist & 'Cari Hesap,'>
                                CONVERT(VARCHAR,ACTION_VALUE,1) 'Tutar', <cfset columnlist = columnlist & 'Tutar,'>
                                ACTION_CURRENCY_ID 'Para Birimi', <cfset columnlist = columnlist & 'Para Birimi,'>
                                CONVERT(VARCHAR,OTHER_CASH_ACT_VALUE,1) 'Dövizli Tutar', <cfset columnlist = columnlist & 'Dövizli Tutar,'>
                                OTHER_MONEY 'Para Birimi', <cfset columnlist = columnlist & 'Para Birimi,'>
                                ACTION_DETAIL 'Açıklama', <cfset columnlist = columnlist & 'Açıklama,'>
                                CONVERT(VARCHAR(10),ACTION_DATE,103) 'Tarih', <cfset columnlist = columnlist & 'Tarih'>
                                QUERY_COUNT
                        FROM
                            CTE2
                        UNION ALL
                        SELECT
                            (SELECT TOP 1 ROWNUM FROM CTE2 ORDER BY ROWNUM DESC) +1 AS ROWNUM,
                            '',
                            '',
                            <cfif x_branch_info>
                                '',
                            </cfif>
                            <cfif x_project_info>
                                '',
                            </cfif>
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
                        UNION ALL
                        SELECT
                            (SELECT TOP 1 ROWNUM FROM CTE2 ORDER BY ROWNUM DESC) + ACTION_RN +1 AS ROWNUM,
                            '',
                            '',
                            <cfif x_branch_info>
                                '',
                            </cfif>
                            <cfif x_project_info>
                                '',
                            </cfif>
                            '',
                            '',
                            CASE ACTION_RN WHEN 1 THEN 'Toplam' ELSE '' END,
                            CONVERT(VARCHAR,TOTAL,1),
                            ACTION_CURRENCY_ID,
                            '',
                            '',
                            '',
                            '',
                            ''
                        FROM
                            CTE3
        
                        UNION ALL 
                                        
                        SELECT
                            (SELECT TOP 1 ROWNUM FROM CTE2 ORDER BY ROWNUM DESC) + OTHER_RN +2 AS ROWNUM,
                            '',
                            '',
                            <cfif x_branch_info>
                                '',
                            </cfif>
                            <cfif x_project_info>
                                '',
                            </cfif>
                            '',
                            '',
                            CASE OTHER_RN WHEN 1 THEN 'Dövizli Toplam' ELSE '' END,
                            '',
                            '',
                            CONVERT(VARCHAR,OTHER_TOTAL,1),
                            OTHER_MONEY,
                            '',
                            '',
                            ''
                        FROM
                            CTE4
                        ORDER BY
                            ROWNUM
                </cfquery>
                
				<cfset runtime = createObject("java","java.lang.Runtime").getRuntime()>
                <cfset objSys = createObject("java","java.lang.System")/>
                
             	<cfset querycount = GET_EXCEL.QUERY_COUNT>
                <cfset tempPath = GetTempDirectory() & CreateUUID() & ".xls">
                <cfspreadsheet action="write" filename="#tempPath#" query="get_excel" sheetname="Cari Hareketler #sheet#" overwrite="true">
                <cfscript>
					var theSheet = SpreadsheetRead(tempPath);
					columncount = listlen(columnlist,',');
					SpreadsheetDeleteColumn(theSheet, columncount+1);
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
		
					SpreadsheetFormatColumn(theSheet,paperNoFormat,2);
					SpreadsheetFormatColumn(theSheet,myDateFormat,columncount);
					SpreadsheetFormatColumn(theSheet,moneyFormat,columncount-3);
					SpreadsheetFormatColumn(theSheet,moneyFormat,columncount-5);
					SpreadsheetFormatRow(theSheet,format1,1);
					
				</cfscript>
				
				<cfspreadsheet action="write" filename="#this.upload_folder#/reserve_files/#session.ep.userid#/ch_actions_#sheet#.xls" name="theSheet" sheetname="Cari Hareketler #sheet#" overwrite=true>
				
                <cfset sheet = sheet +1>
                <cfset objSys.gc() />
            </cfloop>
            <cfset objSys.runFinalization()/>
            <cfzip file="#this.upload_folder#/reserve_files/#session.ep.userid#/cari_hareketler_#session.ep.userid#.zip" action="zip" 
               source="#this.upload_folder#/reserve_files/#session.ep.userid#" 
               recurse="No" >
            <script type="text/javascript">
                <cfoutput>
                    get_wrk_message_div("Zip","Zip","/documents/reserve_files/#session.ep.userid#/cari_hareketler_#session.ep.userid#.zip") ;
                </cfoutput>
            </script>
            <cfset returnValue = GET_EXCEL>
        </cfif>	
        <cfreturn returnValue/>
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
