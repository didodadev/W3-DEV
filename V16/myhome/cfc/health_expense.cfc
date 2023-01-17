<cfcomponent>
    <cfset dsn = application.systemParam.systemParam().dsn>
    <cfset dsn2= "#dsn#_#session.ep.period_year#_#session.ep.company_id#">
    <cfset dsn3 = "#dsn#_#session.ep.company_id#">
    <cffunction name="HEALTH_INVOICE_CONTROL" returntype="query">
        <cfargument name="invoice_id" default="">
        <cfargument name="invoice_no" default="">
        <cfquery name="HEALTH_INVOICE_CONTROL" datasource="#dsn2#">
            SELECT
                *
            FROM
                INVOICE_CONTRACT_COMPARISON
            WHERE
                1 = 1
                <cfif len(arguments.invoice_id)>
                    AND MAIN_INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.invoice_id#">
                </cfif>
                <cfif len(arguments.invoice_no)>
                    AND MAIN_INVOICE_NUMBER = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.invoice_no#">
                </cfif>
        </cfquery>
        <cfreturn HEALTH_INVOICE_CONTROL>
    </cffunction>
    <cffunction name="GET_MONEY" returntype="query">
        <cfquery name="GET_MONEY" datasource="#dsn2#">
            SELECT * FROM SETUP_MONEY WHERE MONEY_STATUS = 1 ORDER BY MONEY
        </cfquery>
        <cfreturn GET_MONEY>
    </cffunction>
    <cffunction name="GET_EXPENSE" returntype="query">
        <cfargument name="health_id" default="">
        <cfargument name="emp_id" default="">
        <cfquery name="GET_EXPENSE" datasource="#dsn2#">
            SELECT 
             * 
            FROM 
              EXPENSE_ITEM_PLAN_REQUESTS 
            WHERE 
              EXPENSE_ID =<cfif isDefined("arguments.health_id") and len(arguments.health_id)> <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.health_id#"><cfelse>NULL</cfif>
              <cfif len(arguments.emp_id)>AND EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"></cfif>
        </cfquery>
        <cfreturn GET_EXPENSE>
    </cffunction>
    <cffunction name="GET_EXPENSE_PROCESS" returntype="query">
        <cfargument name="health_id" default="">
        <cfquery name="GET_EXPENSE_PROCESS" datasource="#dsn2#">
            SELECT 
                EXPENSE_STAGE,
                PAPER_NO
            FROM 
                EXPENSE_ITEM_PLAN_REQUESTS 
            WHERE 
                EXPENSE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.health_id#">
        </cfquery>
        <cfreturn GET_EXPENSE_PROCESS>
    </cffunction>
    <cffunction name="UPDATE_EXPENSE_PROCESS" returntype="any">
        <cfargument name="health_id" default="">
        <cfargument name="process_stage" default="">
        <cfquery name="UPDATE_EXPENSE_PROCESS" datasource="#dsn2#">
            UPDATE
                EXPENSE_ITEM_PLAN_REQUESTS
            SET
                EXPENSE_STAGE = <cfif isdefined("arguments.process_stage") and len(arguments.process_stage)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.process_stage#"><cfelse>NULL</cfif>
            WHERE
                EXPENSE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.health_id#">
        </cfquery>
    </cffunction>
    <cffunction name="GET_DOCUMENT_TYPE" returntype="query">
        <cfargument name="fuseaction" default="">
        <cfquery name="GET_DOCUMENT_TYPE" datasource="#dsn#">
            SELECT
                SETUP_DOCUMENT_TYPE.DOCUMENT_TYPE_ID,
                SETUP_DOCUMENT_TYPE.DOCUMENT_TYPE_NAME
            FROM
                SETUP_DOCUMENT_TYPE,
                SETUP_DOCUMENT_TYPE_ROW
            WHERE
                SETUP_DOCUMENT_TYPE_ROW.DOCUMENT_TYPE_ID =  SETUP_DOCUMENT_TYPE.DOCUMENT_TYPE_ID AND
                SETUP_DOCUMENT_TYPE_ROW.FUSEACTION LIKE '%#arguments.fuseaction#%'
            ORDER BY
                DOCUMENT_TYPE_NAME
        </cfquery>
        <cfreturn GET_DOCUMENT_TYPE>
    </cffunction>
    <cffunction name="GetAssurance" returntype="query">
        <cfargument name="is_requested" default="">
        <cfquery name="get_assurance" datasource="#dsn#">
            SELECT
                HAT.ASSURANCE_ID,
                HAT.ASSURANCE,
                (SELECT TOP 1 RATE FROM SETUP_HEALTH_ASSURANCE_TYPE_SUPPORT WHERE ASSURANCE_ID = HAT.ASSURANCE_ID ORDER BY ISNULL(MIN,0)) AS RATE,
                (SELECT TOP 1 PRIVATE_COMP_RATE FROM SETUP_HEALTH_ASSURANCE_TYPE_SUPPORT WHERE ASSURANCE_ID = HAT.ASSURANCE_ID ORDER BY ISNULL(MIN,0)) AS PRIVATE_RATE
            FROM 
                SETUP_HEALTH_ASSURANCE_TYPE HAT 
            WHERE 
                HAT.IS_ACTIVE = 1 AND
                (HAT.IS_MAIN IS NULL OR HAT.IS_MAIN = 0)
                <cfif len(arguments.is_requested)>
                    AND HAT.IS_REQUESTED = <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.is_requested#">
                </cfif>
            ORDER BY 
                HAT.ASSURANCE
        </cfquery>
        <cfreturn get_assurance>
    </cffunction>
    <cffunction name="GetTreatment" returntype="query">
        <cfargument name="assurance_id" type="numeric" required="false" default="-1" />
        <cfquery name="get_treatment" datasource="#dsn#">
            SELECT
                TREATMENT_ID,
                TREATMENT
            FROM
                SETUP_HEALTH_ASSURANCE_TYPE_TREATMENTS
            <cfif arguments.assurance_id Neq -1> WHERE ASSURANCE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.assurance_id#"></cfif>
        </cfquery>
        <cfreturn get_treatment>
    </cffunction>
    <cffunction name="GetTax" returntype="query">
        <cfquery name="get_tax" datasource="#dsn2#">
            select TAX_ID, TAX from SETUP_TAX
        </cfquery>
        <cfreturn get_tax>
    </cffunction>
    <cffunction name="GET_EXPENSE_LIST" returntype="query">
            <cfargument name="search_date1" default="">
            <cfargument name="search_date2" default="">
            <cfargument name="payment_date1" default="">
            <cfargument name="payment_date2" default="">
            <cfargument name="startrow" default="">
            <cfargument name="maxrows" default="">
            <cfargument name="keyword" default="">
            <cfargument name="expense_stage" default="">
            <cfargument name="expense_branch" default="">
            <cfargument name="assurance_id" default="">
            <cfargument name="arguments" default="">
            <cfargument name="treatment_id" default="">
            <cfargument name="expense_department" default="">
            <cfargument name="sortType" default="">
            <cfargument name="company_id" default="">
            <cfargument name="module_name" type="string" required="false" default="" />
            <cfargument name="expense_employee" type="numeric" required="false" default="-1" />
            <cfargument name="expense_type" default="">
            <cfargument name="process_cat" default="">
            <cfargument name="row_expense_id" default="">
            <cfargument name="group_paper_no" default="">
            <cfargument name="is_relative" default="">
            <cfargument name="is_invoice" default="">
            <cfargument name="update_employee" default="">
            <cfquery name="GET_EXPENSE" datasource="#dsn2#">
                WITH CTE1 AS(
                    SELECT E.PAPER_TYPE PAPER_TYPE
                            ,SETUP_DOCUMENT_TYPE.DOCUMENT_TYPE_NAME
                            ,E.EMP_ID
                            ,EMPLOYEES.EMPLOYEE_NO
                            ,E.MEMBER_TYPE
                            ,E.MONEY
                            ,EMPLOYEES.EMPLOYEE_NAME + ' ' + EMPLOYEES.EMPLOYEE_SURNAME AS EMP_FULLNAME
                            ,E.ASSURANCE_ID
                            ,E.TREATMENT_ID
                            ,E.TREATED  TREATED
                            ,E.TOTAL_AMOUNT
                            ,ISNULL(E.NET_TOTAL_AMOUNT,0) AS AMOUNT
                            ,ISNULL(E.TREATMENT_AMOUNT,0) AS TREATMENT_AMOUNT
                            ,ISNULL(E.OUR_COMPANY_HEALTH_AMOUNT,0) AS OUR_COMPANY_HEALTH_AMOUNT
                            ,ISNULL(E.EMPLOYEE_HEALTH_AMOUNT,0) AS EMPLOYEE_HEALTH_AMOUNT
                            ,T.TREATMENT  TREATMENT 
                            ,H.ASSURANCE ASSURANCE
                            ,E.EXPENSE_DATE EXP_DATE
                            ,E.RECORD_DATE  RECORD_DATE
                            ,E.UPDATE_DATE  UPDATE_DATE
                            ,E.EXPENSE_DATE
                            ,E.EXPENSE_ID  EXPENSE
                            ,E.PAPER_NO
                            ,E.DEPARTMENT_ID
                            ,E.BRANCH_ID
                            ,BRANCH.BRANCH_NAME BRANCH_NAME 
                            ,DEPARTMENT.DEPARTMENT_HEAD DEPARTMENT_HEAD
                            ,E.RECORD_EMP RECORD_EMP
                            ,E.EXPENSE_STAGE
                            ,ER.NAME + ' ' + ER.SURNAME AS FULLNAME,
                            E.RELATIVE_ID,
                            E.EXPENSE_ITEM_PLANS_ID,
                            ER.RELATIVE_LEVEL,
                            E.COMPANY_AMOUNT_RATE,
                            E.COMPANY_ID,
                            E.CONSUMER_ID,
                            E.PARTNER_ID,
                            E.COMPANY_NAME,
                            E.INVOICE_NO,
                            C.FULLNAME AS COMPANY_FULLNAME,
                            C.MEMBER_CODE,
                            CNS.MEMBER_CODE AS CNS_MEMBER_CODE,
                            P_EMP.EMPLOYEE_NO AS PARTNER_MEMBER_CODE,
                            E.PROCESS_CAT,
                            (
                                SELECT
                                    TOP 1
                                    GENERAL_PAPER.GENERAL_PAPER_NO 
                                FROM
                                    #dsn#.GENERAL_PAPER
                                    LEFT JOIN #dsn#.PAGE_WARNINGS ON PAGE_WARNINGS.GENERAL_PAPER_ID = GENERAL_PAPER.GENERAL_PAPER_ID
                                WHERE
                                    <!--- E.EXPENSE_ID IN (SELECT * FROM #dsn#.fnSplit((GENERAL_PAPER.ACTION_LIST_ID), ',')) --->
                                    ','+GENERAL_PAPER.ACTION_LIST_ID+',' LIKE '%[,]'+convert(nvarchar(100), E.EXPENSE_ID)+'[,]%'
                                    <cfif len(arguments.group_paper_no)>
                                        AND GENERAL_PAPER.GENERAL_PAPER_NO = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.group_paper_no#">
                                    </cfif>
                                    AND PAGE_WARNINGS.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
                                    AND PAGE_WARNINGS.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
                                ORDER BY
                                    GENERAL_PAPER.GENERAL_PAPER_ID DESC
                            ) AS GENERAL_PAPER_NO,
                            E.ASSURANCE_TYPE_ID,
                             E.SYSTEM_RELATION
                            <cfif isdefined("arguments.row_expense_id") and len(arguments.row_expense_id)>
                                ,(SELECT SUM(OUR_COMPANY_HEALTH_AMOUNT) AS COMP_HEALTH_AMOUNT FROM EXPENSE_ITEM_PLAN_REQUESTS WHERE EXPENSE_ID IN ( #arguments.row_expense_id# )) AS TOTAL_COMP_HEALTH_AMOUNT
                                ,EMPLOYEES_BANK_ACCOUNTS.BANK_ACCOUNT_NO
                                ,EMPLOYEES_BANK_ACCOUNTS.BANK_BRANCH_CODE
                                ,EMPLOYEES_BANK_ACCOUNTS.IBAN_NO
                                ,EI.TC_IDENTY_NO
                            </cfif>
                        FROM EXPENSE_ITEM_PLAN_REQUESTS E
                        LEFT JOIN #dsn#.SETUP_DOCUMENT_TYPE ON SETUP_DOCUMENT_TYPE.DOCUMENT_TYPE_ID = E.PAPER_TYPE
                        LEFT JOIN #dsn#.EMPLOYEES ON EMPLOYEES.EMPLOYEE_ID = E.EMP_ID
                        LEFT JOIN #dsn#.SETUP_HEALTH_ASSURANCE_TYPE H ON H.ASSURANCE_ID = E.ASSURANCE_ID
                        LEFT JOIN #dsn#.SETUP_HEALTH_ASSURANCE_TYPE_TREATMENTS T ON T.TREATMENT_ID = E.TREATMENT_ID
                        LEFT JOIN #dsn#.DEPARTMENT ON DEPARTMENT.DEPARTMENT_ID = E.DEPARTMENT_ID
                        LEFT JOIN #dsn#.BRANCH ON BRANCH.BRANCH_ID = E.BRANCH_ID
                        LEFT JOIN #dsn#.PROCESS_TYPE_ROWS PTR on PTR.PROCESS_ROW_ID=E.EXPENSE_STAGE
                        LEFT JOIN #dsn#.EMPLOYEES_RELATIVES  ER on ER.RELATIVE_ID = E.RELATIVE_ID
                        LEFT JOIN #dsn#.COMPANY C ON C.COMPANY_ID = E.COMPANY_ID
                        LEFT JOIN #dsn#.CONSUMER CNS ON CNS.CONSUMER_ID = E.CONSUMER_ID
                        LEFT JOIN #dsn#.EMPLOYEES P_EMP ON P_EMP.EMPLOYEE_ID = E.PARTNER_ID
                        <cfif isdefined("arguments.row_expense_id") and len(arguments.row_expense_id)>
                            LEFT JOIN #dsn#.EMPLOYEES_BANK_ACCOUNTS ON EMPLOYEES.EMPLOYEE_ID = EMPLOYEES_BANK_ACCOUNTS.EMPLOYEE_ID    
                            INNER JOIN #dsn#.EMPLOYEES_IDENTY AS EI ON EMPLOYEES.EMPLOYEE_ID = EI.EMPLOYEE_ID
                        </cfif>
                    WHERE
                        1=1
                        AND TREATED IS NOT NULL
                        <cfif isdefined("arguments.keyword") and len(arguments.keyword)>
                            AND  ( 
                                EMPLOYEES.EMPLOYEE_NAME + ' ' + EMPLOYEES.EMPLOYEE_SURNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%">
                                OR EMPLOYEES.EMPLOYEE_NO = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.keyword#">
                                OR E.PAPER_NO LIKE <cfqueryparam cfsqltype="nvarchar" value="%#arguments.keyword#%">
                                )
                        </cfif>
                        <cfif len(arguments.expense_stage)>
                            AND E.EXPENSE_STAGE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.expense_stage#">
                        </cfif>
                        <cfif len(arguments.expense_branch)>
                            AND E.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.expense_branch#">
                        </cfif>
                        <cfif len(arguments.assurance_id)>
                            AND E.ASSURANCE_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.assurance_id#" list="true">)
                        </cfif>
                        <cfif len(arguments.treatment_id)>
                            AND E.TREATMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.treatment_id#">
                        </cfif>
                        <cfif len(arguments.expense_department)>
                            AND E.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.expense_department#">
                        </cfif>
                        <cfif len(arguments.search_date1)>
                            AND E.EXPENSE_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.search_date1#">
                        </cfif>
                        <cfif len(arguments.search_date2)>
                            AND E.EXPENSE_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.search_date2#">
                        </cfif>
                        <cfif len(arguments.payment_date1)>
                            AND E.PAYMENT_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.payment_date1#">
                        </cfif>
                        <cfif len(arguments.payment_date2)>
                            AND E.PAYMENT_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.payment_date2#">
                        </cfif>
                        <cfif isDefined('arguments.expense_employee') and len(arguments.expense_employee) and arguments.expense_employee neq -1>
                            AND E.EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.expense_employee#" />
                        <cfelseif arguments.module_name is 'myhome'>
                            AND E.EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#" />
                        </cfif>
                        <cfif len(arguments.update_employee)>
                            AND E.UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.update_employee#">
                        </cfif>
                        <cfif len(arguments.expense_type)>
                            AND E.EXPENSE_TYPE <= <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.expense_type#">
                        </cfif>
                        <cfif len(arguments.company_id)>
                            AND E.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#">
                        </cfif>
                        <cfif len(arguments.sortType) and arguments.sortType eq 1>
                            AND (E.COMPANY_ID IS NULL AND E.CONSUMER_ID IS NULL)
                        <cfelseif len(arguments.sortType) and arguments.sortType eq 2>
                            AND (E.COMPANY_ID IS NOT NULL OR E.CONSUMER_ID IS NOT NULL)
                        </cfif>
                        <cfif isdefined("arguments.process_cat_id") and len(arguments.process_cat_id)>
                            AND E.PROCESS_CAT = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.process_cat_id#">
                        </cfif>
                        <cfif len(arguments.is_relative)>
                            AND E.TREATED = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.is_relative#">
                        </cfif>
                        <cfif len(arguments.is_invoice) and arguments.is_invoice eq 1>
                            AND E.INVOICE_NO IS NOT NULL
                        <cfelseif len(arguments.is_invoice) and arguments.is_invoice eq 2>
                            AND E.INVOICE_NO IS NULL
                        </cfif>
                        <cfif isdefined("arguments.row_expense_id") and len(arguments.row_expense_id)>
                            AND E.EXPENSE_ID IN ( #arguments.row_expense_id# )
                        </cfif>
                        <cfif len(arguments.group_paper_no)>
                            AND E.EXPENSE_ID IN (SELECT * FROM #dsn#.fnSplit((SELECT TOP 1 ACTION_LIST_ID FROM #dsn#.GENERAL_PAPER WHERE GENERAL_PAPER_NO = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.group_paper_no#"> AND STAGE_ID = E.EXPENSE_STAGE ORDER BY GENERAL_PAPER_ID DESC), ','))
                        </cfif>
                    ),
                CTE2 AS (
                        SELECT
                            CTE1.*,
                                ROW_NUMBER() OVER (
                                                    ORDER BY  
                                                    <cfif len(arguments.sortType) and arguments.sortType eq 1>
                                                        EMP_FULLNAME,
                                                    <cfelseif len(arguments.sortType) and arguments.sortType eq 2>
                                                        COMPANY_FULLNAME,
                                                    </cfif>
                                                        EXPENSE_DATE DESC,EXPENSE DESC
                    ) AS RowNum,(SELECT COUNT(*) FROM CTE1) AS QUERY_COUNT
                        FROM
                            CTE1
                    )
                    SELECT
                        CTE2.*
                    FROM
                        CTE2
                    WHERE
                        RowNum BETWEEN #arguments.startrow# and #arguments.startrow#+(#arguments.maxrows#-1)     
            </cfquery>
            <cfreturn GET_EXPENSE>
    </cffunction> 
     <cffunction name="GetProcesssCat" returntype="query">
        <cfargument name="PROCESS_CAT_ID" default="">
        <cfquery name="get_process_type" datasource="#dsn3#">
            SELECT 
                PROCESS_TYPE,
                IS_CARI,
                IS_BUDGET,
                IS_ACCOUNT,
                IS_ALLOWANCE_DEDUCTION,
                IS_DEDUCTION,
                ACTION_FILE_NAME,
                ACTION_FILE_FROM_TEMPLATE
            FROM 
                SETUP_PROCESS_CAT 
            WHERE 
                PROCESS_CAT_ID = #arguments.process_cat#
        </cfquery>
        <cfreturn get_process_type>
    </cffunction>
    <cffunction name="GetProcessType" returntype="query">
        <cfargument name="fuseaction" default="">
        <cfargument name="expense_stage" required="no" default="">
        <cfquery name="get_process_type" datasource="#dsn#">
            SELECT
                PTR.STAGE,
                PTR.PROCESS_ROW_ID
            FROM
                PROCESS_TYPE_ROWS PTR,
                PROCESS_TYPE_OUR_COMPANY PTO,
                PROCESS_TYPE PT
            WHERE
                PT.IS_ACTIVE = 1 AND
                PTR.PROCESS_ID = PT.PROCESS_ID AND
                PT.PROCESS_ID = PTO.PROCESS_ID AND
                PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
                PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#listfirst(arguments.fuseaction,'.')#.health_expense_approve%">
                <cfif IsDefined("arguments.expense_stage") and len(arguments.expense_stage)>
                   AND PTR.PROCESS_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.expense_stage#">
                </cfif>
            ORDER BY
                PTR.LINE_NUMBER
        </cfquery>
        <cfreturn get_process_type>
    </cffunction>
    <cffunction name="GetBranch" returntype="query">
        <cfquery name="get_branch" datasource="#dsn#">
            SELECT BRANCH_ID, BRANCH_NAME FROM BRANCH ORDER BY BRANCH_NAME
        </cfquery>
        <cfreturn get_branch>
    </cffunction>
    <cffunction name="GetDepartment" returntype="query">
        <cfquery name="get_department" datasource="#dsn#">
            SELECT DEPARTMENT_ID ,DEPARTMENT_HEAD FROM DEPARTMENT ORDER BY DEPARTMENT_HEAD
       </cfquery>
       <cfreturn get_department>
    </cffunction>
  <!---   <cffunction name="GetStage" returntype="query">
        <cfargument name="expense_stage_list" default="">
        <cfquery name="get_stage" datasource="#dsn#">
            SELECT STAGE, PROCESS_ROW_ID FROM PROCESS_TYPE_ROWS WHERE PROCESS_ROW_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.expense_stage_list#" list="yes">) 
        </cfquery>
    </cffunction> --->
    <cffunction name="GET_ACC_CODE" returntype="query">
        <cfargument name="expense_item_id" default="">
        <cfquery name="GET_ACC_CODE" datasource="#dsn2#">
            select * FROM EXPENSE_ITEMS WHERE EXPENSE_ITEM_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.expense_item_id#">
        </cfquery>
       <cfreturn GET_ACC_CODE>
    </cffunction>

    <cffunction name="GET_ACC_CODE_KDV" returntype="query">
        <cfargument name="kdv_rate" default="">
        <cfquery name="GET_ACC_CODE_KDV" datasource="#dsn2#">
            SELECT PURCHASE_CODE,DIRECT_EXPENSE_CODE FROM SETUP_TAX WHERE TAX =  <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.kdv_rate#">
        </cfquery>
       <cfreturn GET_ACC_CODE_KDV>
    </cffunction>
    <cffunction name="GET_ACC_CODE_EMPLOYEE" returntype="query">
        <cfargument name="in_out_id" default="">
        <cfquery name="GET_ACC_CODE_EMPLOYEE" datasource="#dsn2#">
            SELECT ACCOUNT_CODE FROM #dsn#.EMPLOYEES_IN_OUT_PERIOD WHERE IN_OUT_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.in_out_id#"> AND PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
        </cfquery>
       <cfreturn GET_ACC_CODE_EMPLOYEE>
    </cffunction>
    <cffunction name="GET_ACC_CODE_CH" returntype="query">
        <cfargument name="company_id" default="">
        <cfquery name="GET_ACC_CODE_CH" datasource="#dsn2#">
            SELECT ISNULL(PURCHASE_ACCOUNT,ACCOUNT_CODE) AS ACCOUNT_CODE FROM #DSN#.COMPANY_PERIOD WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#"> AND PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
        </cfquery>
       <cfreturn GET_ACC_CODE_CH>
    </cffunction>
    <cffunction name="GET_ACC_CODE_CONSUMER" returntype="query">
        <cfargument name="consumer_id" default="">
        <cfquery name="GET_ACC_CODE_CONSUMER" datasource="#dsn2#">
            SELECT ISNULL(PURCHASE_ACCOUNT,ACCOUNT_CODE) AS ACCOUNT_CODE FROM #DSN#.CONSUMER_PERIOD WHERE CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.consumer_id#"> AND PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
        </cfquery>
       <cfreturn GET_ACC_CODE_CONSUMER>
    </cffunction>
    <cffunction name="GET_ACC_CODE_EMPLOYEE_IN_OUT" returntype="query">
        <cfargument name="employee_id" default="">
        <cfquery name="GET_ACC_CODE_EMPLOYEE_IN_OUT" datasource="#dsn2#">
            SELECT 
                EIOP.ACCOUNT_CODE 
            FROM 
                #dsn#.EMPLOYEES_IN_OUT EIO
                LEFT JOIN #dsn#.EMPLOYEES_IN_OUT_PERIOD EIOP ON EIOP.IN_OUT_ID = EIO.IN_OUT_ID AND EIOP.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
            WHERE 
                EIO.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.employee_id#"> AND
                EIO.FINISH_DATE IS NULL
        </cfquery>
       <cfreturn GET_ACC_CODE_EMPLOYEE_IN_OUT>
    </cffunction>
    <cffunction name="GET_EXPENSE_ROWS" returntype="query">
        <cfargument name="health_id" default="">
        <cfquery name="GET_EXPENSE_ROWS" datasource="#dsn2#">
            select KDV_RATE,sum(AMOUNT_KDV) as AMOUNT_KDV  FROM EXPENSE_ITEMS_ROWS WHERE  EXPENSE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.health_id#"> group by KDV_RATE
        </cfquery>
       <cfreturn GET_EXPENSE_ROWS>
    </cffunction>
    <cffunction name="GET_EXPENSE_INVOICE" returntype="query">
        <cfargument name="expense_id" default="">
        <cfquery name="GET_EXPENSE_INVOICE" datasource="#dsn2#">
            select RECEIVING_DETAIL_ID FROM EINVOICE_RECEIVING_DETAIL WHERE  EXPENSE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.expense_id#">
        </cfquery>
       <cfreturn GET_EXPENSE_INVOICE>
    </cffunction>
    <cffunction name="UPD_SET_EXPENSE_ROWS" returntype="any">
        <cfargument name="expense_item_id" default="">
        <cfargument name="expense_center_id" default="">
        <cfargument name="expense_account_code" default="">
        <cfargument name="health_id" default="">
        <cfargument name="total_amount" default="">

        <cfquery name="UPD_SET_EXPENSE_ROWS" datasource="#dsn2#">
            UPDATE
                EXPENSE_ITEMS_ROWS
            SET
                EXPENSE_CENTER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.expense_center_id#">,
                EXPENSE_ITEM_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.expense_item_id#">,
                EXPENSE_ACCOUNT_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.expense_account_code#">
                <cfif len(arguments.total_amount)>
                    ,AMOUNT =  <cfqueryparam cfsqltype="cf_sql_float" value="#arguments.total_amount#">
                    ,TOTAL_AMOUNT =  <cfqueryparam cfsqltype="cf_sql_float" value="#arguments.total_amount#">
                     ,DISCOUNT_TOTAL =  <cfqueryparam cfsqltype="cf_sql_float" value="#arguments.total_amount#">
                    ,AMOUNT_KDV =  <cfqueryparam cfsqltype="cf_sql_integer" value="0">
                    ,KDV_RATE = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
                    ,other_money_gross_total = <cfqueryparam cfsqltype="cf_sql_float" value="#arguments.total_amount#">
                </cfif>
            WHERE
                EXPENSE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.health_id#">
        </cfquery>
         <cfif len(arguments.total_amount)>
         <cfquery name="UPD_SET_EXPENSE_ROWS" datasource="#dsn2#">
            UPDATE
                EXPENSE_ITEM_PLANS
            SET
                OTHER_MONEY_AMOUNT =  <cfqueryparam cfsqltype="cf_sql_float" value="#arguments.total_amount#">
                ,TOTAL_AMOUNT =  <cfqueryparam cfsqltype="cf_sql_float" value="#arguments.total_amount#">
                ,TOTAL_AMOUNT_KDVLI =  <cfqueryparam cfsqltype="cf_sql_float" value="#arguments.total_amount#">
                ,KDV_TOTAL = 0
                ,OTHER_MONEY_NET_TOTAL =  <cfqueryparam cfsqltype="cf_sql_float" value="#arguments.total_amount#">
                ,OTHER_MONEY_KDV = <cfqueryparam cfsqltype="cf_sql_float" value="#arguments.total_amount#">
            WHERE
                EXPENSE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.health_id#">
        </cfquery>
        </cfif>
       <cfreturn 1>
    </cffunction>
    <cffunction name="EXPENSE_ITEM_PLAN_REQUESTS_HEALTH_APPROVE" returntype="any">
        <cfargument name="health_id" default="">
        <cfquery name="EXPENSE_ITEM_PLAN_REQUESTS_HEALTH_APPROVE" datasource="#dsn2#">
            UPDATE
                EXPENSE_ITEM_PLAN_REQUESTS
            SET
                HEALTH_APPROVE = 1
            WHERE
                EXPENSE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.health_id#">
        </cfquery>
       <cfreturn 1>
    </cffunction>
    <cffunction name="GET_DET_FORM" returntype="any" access="public">
        <cfquery name="GET_DET_FORM" datasource="#dsn#">
            SELECT 
                DISTINCT SPF.FORM_ID,
                SPF.IS_XML,
                SPF.TEMPLATE_FILE,
                SPF.FORM_ID,
                SPF.IS_DEFAULT,
                SPF.NAME,
                SPF.PROCESS_TYPE,
                SPF.MODULE_ID,
                SPFC.PRINT_NAME
            FROM
                #dsn3#.SETUP_PRINT_FILES AS SPF
                LEFT JOIN SETUP_PRINT_FILES_CATS AS SPFC ON SPF.PROCESS_TYPE = SPFC.PRINT_TYPE
                LEFT JOIN WRK_MODULE AS WM ON WM.MODULE_ID = SPF.MODULE_ID
                LEFT JOIN SETUP_PRINT_FILES_POSITION AS SPFP ON SPFP.FORM_ID = SPF.FORM_ID
            WHERE
                SPF.ACTIVE = 1 AND
                SPFC.PRINT_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="490"> AND
                SPFP.FORM_ID IS NULL
            UNION ALL
                SELECT 
                    DISTINCT SPF.FORM_ID,
                    SPF.IS_XML,
                    SPF.TEMPLATE_FILE,
                    SPF.FORM_ID,
                    SPF.IS_DEFAULT,
                    SPF.NAME,
                    SPF.PROCESS_TYPE,
                    SPF.MODULE_ID,
                    SPFC.PRINT_NAME
                FROM
                    #dsn3#.SETUP_PRINT_FILES AS SPF
                    LEFT JOIN SETUP_PRINT_FILES_CATS AS SPFC ON SPF.PROCESS_TYPE = SPFC.PRINT_TYPE
                    LEFT JOIN WRK_MODULE AS WM ON WM.MODULE_ID = SPF.MODULE_ID
                    LEFT JOIN SETUP_PRINT_FILES_POSITION AS SPFP ON SPFP.FORM_ID = SPF.FORM_ID
                    LEFT JOIN EMPLOYEE_POSITIONS EMP ON SPFP.POS_CAT_ID = EMP.POSITION_CAT_ID OR SPFP.POS_CODE = EMP.POSITION_CODE
                WHERE
                    SPF.ACTIVE = 1 AND
                    SPFC.PRINT_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="490"> AND
                    SPFP.FORM_ID IS NOT NULL AND 
                    EMP.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> AND 
                    EMP.IS_MASTER = 1
                ORDER BY
                    SPF.IS_XML,
                    SPF.NAME
      </cfquery>
      <cfreturn GET_DET_FORM>
    </cffunction>
    <cffunction name="GET_ACCOUNTS" returntype="any" access="public">
        <cfquery name="GET_ACCOUNTS" datasource="#DSN#">
            SELECT
                *
            FROM
                SETUP_BANK_TYPES
            WHERE 
                EXPORT_TYPE IS NOT NULL
            ORDER BY
                BANK_NAME
        </cfquery>
        <cfreturn GET_ACCOUNTS>
    </cffunction>
    <cffunction name="GET_SUM_HEALTH_EXPENSE" access="public" returntype="any">
        <cfargument name="employee_id" default="">
        <cfargument name="treated" default="">
        <cfquery name="GET_SUM_HEALTH_EXPENSE" datasource="#dsn2#">
            SELECT
                ISNULL(SUM(NET_TOTAL_AMOUNT),0) AS NET_TOTAL_AMOUNT
            FROM
                EXPENSE_ITEM_PLAN_REQUESTS
            WHERE
                TREATED IS NOT NULL
                AND IS_APPROVE = 1
                AND IS_PAYMENT = 1
                AND YEAR(EXPENSE_DATE) = #session.ep.PERIOD_YEAR#
                <cfif len(arguments.employee_id)>
                    AND EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.employee_id#">
                </cfif>
                <cfif len(arguments.treated)>
                    AND TREATED = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.treated#">
                </cfif>
        </cfquery>
        <cfreturn GET_SUM_HEALTH_EXPENSE>
    </cffunction>
</cfcomponent>