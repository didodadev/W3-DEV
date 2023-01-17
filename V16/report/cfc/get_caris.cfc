<cffunction name="get_caris_fnc" returntype="query">
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
	<cfset dsn = arguments.dsn>
	<cfset ch_alias = 'CR.'>
	<cfinclude template="../../objects/query/get_acc_types.cfm">
    <cfquery name="GET_CARIS" datasource="#this.dsn2#" cachedwithin="#this.fusebox.general_cached_time#">
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
            CASE WHEN CR.ACTION_TYPE_ID in ('41','42','45','46','410','420','31','32','310','320') THEN CARI_ACTIONS.MULTI_ACTION_ID ELSE NULL END AS  MULTI_ACTION_ID
            
        FROM
            CARI_ROWS CR
        LEFT JOIN
        	#dsn_alias#.SETUP_ACC_TYPE
        ON
        	CR.ACC_TYPE_ID=SETUP_ACC_TYPE.ACC_TYPE_ID 
        LEFT JOIN
        	#dsn_alias#.COMPANY
        ON
        	ISNULL(CR.FROM_CMP_ID,CR.TO_CMP_ID) = COMPANY.COMPANY_ID 
        LEFT JOIN
        	#dsn_alias#.CONSUMER
        ON
        	ISNULL(CR.FROM_CONSUMER_ID,CR.TO_CONSUMER_ID) = CONSUMER.CONSUMER_ID
        LEFT JOIN
        	#dsn_alias#.EMPLOYEES
        ON
        	ISNULL(CR.FROM_EMPLOYEE_ID,CR.TO_EMPLOYEE_ID) = EMPLOYEES.EMPLOYEE_ID       
            
        LEFT JOIN
        	#dsn2_alias#.CASH
        ON
        	CASH.CASH_ID = ISNULL(CR.FROM_CASH_ID,CR.TO_CASH_ID)      
        LEFT JOIN
        	#dsn3_alias#.ACCOUNTS
        ON
        	ACCOUNTS.ACCOUNT_ID = ISNULL(CR.FROM_ACCOUNT_ID,CR.TO_ACCOUNT_ID)   
        LEFT JOIN
        	#dsn2_alias#.CARI_ACTIONS 
        ON
        	CARI_ACTIONS.ACTION_ID = CR.ACTION_ID        
            <cfif arguments.action_type_ch eq 410 or arguments.action_type_ch eq 420>
                ,CARI_ACTIONS CA
                ,CARI_ACTIONS_MULTI CAM
            </cfif>
            <cfif arguments.action_type_ch eq 310 or arguments.action_type_ch eq 320>
                ,CASH_ACTIONS CA
                ,CASH_ACTIONS_MULTI CAM
            </cfif>
            <cfif arguments.action_type_ch eq 240 or arguments.action_type_ch eq 253>
                ,BANK_ACTIONS BA
                ,BANK_ACTIONS_MULTI BAM
            </cfif>
        WHERE
            CR.CARI_ACTION_ID > 0
        <cfif arguments.action_type_ch eq 410 or arguments.action_type_ch eq 420>
            AND CR.ACTION_ID = CA.ACTION_ID
            AND CAM.MULTI_ACTION_ID = CA.MULTI_ACTION_ID
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
        <cfif isDefined("arguments.action_type_ch") and len(arguments.action_type_ch) and (arguments.action_type_ch neq 410) and (arguments.action_type_ch neq 420) and (arguments.action_type_ch neq 310) and (arguments.action_type_ch neq 320) and (arguments.action_type_ch neq 240) and (arguments.action_type_ch neq 253)>
            AND CR.ACTION_TYPE_ID IN (#arguments.action_type_ch#)
        <cfelseif isDefined("arguments.action_type_ch") and arguments.action_type_ch eq 410>
            AND CR.ACTION_TYPE_ID = 41
        <cfelseif isDefined("arguments.action_type_ch") and arguments.action_type_ch eq 420>
            AND CR.ACTION_TYPE_ID = 42
        <cfelseif isDefined("arguments.action_type_ch") and arguments.action_type_ch eq 310>
            AND CR.ACTION_TYPE_ID = 31
        <cfelseif isDefined("arguments.action_type_ch") and arguments.action_type_ch eq 320>
            AND CR.ACTION_TYPE_ID = 32
        <cfelseif isDefined("arguments.action_type_ch") and arguments.action_type_ch eq 240>
            AND CR.ACTION_TYPE_ID = 24
        <cfelseif isDefined("arguments.action_type_ch") and arguments.action_type_ch eq 253>
            AND CR.ACTION_TYPE_ID = 25
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
            AND	(CR.TO_BRANCH_ID = #listgetat(session.ep.user_location,2,'-')# OR CR.FROM_BRANCH_ID = #listgetat(session.ep.user_location,2,'-')#)
        <cfelseif isdefined('arguments.branch_id') and len(arguments.branch_id)>
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
			ORDER BY
				CTE2.ACTION_DATE,
				CTE2.RECORD_DATE
    </cfquery>
    <cfreturn GET_CARIS/>
</cffunction>
