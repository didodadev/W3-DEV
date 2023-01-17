<!---
    File: project_allowance.cfc
    Author: Esma R. Uysal <esmauysal@workcube.com>
    Date: 28.06.2021
    Description: Proje Bazlı Ödenek ve Bordro fonksiyonları
        
    History:
        
    To Do:

--->
 
<cfcomponent displayname="EMPLOYEES_IN_OUT">
    <cfset dsn = application.systemParam.systemParam().dsn>
    <cfset dsn_alias = application.systemParam.systemParam().dsn>
    <cfset dsn2 = "#dsn#_#session.ep.period_year#_#session.ep.company_id#">
    <cfset dsn3 = '#dsn#_#session.ep.company_id#'>
    <cfset fusebox.dynamic_hierarchy = application.systemParam.systemParam().fusebox.dynamic_hierarchy>
    <cfset fusebox.process_tree_control = application.systemParam.systemParam().fusebox.process_tree_control>
    <cfset attributes.fuseaction = 'index.cfm?fuseaction=hr.project_allowance'>

    <cffunction  name="GET_WORKGROUPS"  returntype="any">
        <cfquery name="GET_WORKGROUPS" datasource="#DSN#">
            SELECT 
                WORKGROUP_ID,
                WORKGROUP_NAME,
            FROM
                WORK_GROUP WG
        </cfquery>
        <cfreturn GET_WORKGROUPS>
    </cffunction>

    <cffunction name="get_project" access="public" returntype="any">
        <cfparam name="branch_id" default="">
        <cfparam name="expense_center_id" default="">
        <cfparam name="expense_center" default="">
        <cfparam name="project_id" default="">
        <cfquery name="get_project" datasource="#DSN#">
            SELECT 
                PRO_PROJECTS.*,
                WG.WORKGROUP_name
            FROM 
                PRO_PROJECTS
                LEFT JOIN WORK_GROUP WG ON WG.WORKGROUP_ID = PRO_PROJECTS.WORKGROUP_ID
            WHERE
                1 = 1
                <cfif isdefined("arguments.branch_id") and len(arguments.branch_id)>
                    AND PRO_PROJECTS.BRANCH_ID = <cfqueryparam value = "#arguments.branch_id#" CFSQLType = "cf_sql_integer">
                </cfif>
               <!----  <cfif isdefined("arguments.expense_center") and len(arguments.expense_center) and len(arguments.expense_center_id)>
                    AND EXPENSE_CODE = <cfqueryparam value = "#arguments.expense_center_id#" CFSQLType = "cf_sql_nvarchar">
                </cfif>---->
                <cfif isdefined("arguments.project_id") and len(arguments.project_id)>
                    AND PRO_PROJECTS.PROJECT_ID = <cfqueryparam value = "#arguments.project_id#" CFSQLType = "cf_sql_integer">
                </cfif> 
        </cfquery>
        <cfreturn get_project>
    </cffunction>

    <cffunction name="get_salaryparam" access="public" returntype="any">
        <cfparam name="start_date" default="">
        <cfparam name="finish_date" default="">
        <cfparam name="project_id" default="">
        <cfquery name="get_salaryparam" datasource="#DSN#">
            SELECT 
               ISNULL(SUM(AMOUNT_PAY),0) TOTAL_PAY,
               MONEY
            FROM 
                SALARYPARAM_PAY
            WHERE
                PROJECT_ID = <cfqueryparam value = "#arguments.project_id#" CFSQLType = "cf_sql_integer"> 
                <cfif (YEAR(arguments.start_date) eq YEAR(arguments.finish_date) and month(arguments.finish_date) gt month(arguments.start_date)) or (YEAR(arguments.start_date) lt YEAR(arguments.finish_date) and month(arguments.finish_date) gt month(arguments.start_date)) >
                    AND START_SAL_MON >= <cfqueryparam value = "#month(arguments.start_date)#" CFSQLType = "cf_sql_integer"> 
                    AND END_SAL_MON <= <cfqueryparam value = "#month(arguments.finish_date)#" CFSQLType = "cf_sql_integer"> 
                    AND TERM BETWEEN <cfqueryparam value = "#YEAR(arguments.start_date)#" CFSQLType = "cf_sql_integer">  AND <cfqueryparam value = "#YEAR(arguments.finish_date)#" CFSQLType = "cf_sql_integer">
                <cfelseif YEAR(arguments.start_date) lt YEAR(arguments.finish_date) and month(arguments.finish_date) lt month(arguments.start_date)>
                    AND START_SAL_MON <= <cfqueryparam value = "#month(arguments.start_date)#" CFSQLType = "cf_sql_integer"> 
                    AND END_SAL_MON >= <cfqueryparam value = "#month(arguments.finish_date)#" CFSQLType = "cf_sql_integer">
                    AND TERM BETWEEN <cfqueryparam value = "#YEAR(arguments.start_date)#" CFSQLType = "cf_sql_integer">  AND <cfqueryparam value = "#YEAR(arguments.finish_date)#" CFSQLType = "cf_sql_integer">
                </cfif>
            group by MONEY
        </cfquery>
        <cfreturn get_salaryparam>
    </cffunction>

    <cffunction name="get_budget_center" access="public" returntype="any">
        <cfparam name="general_budget_id" default="">
        <cfquery name="get_budget_center" datasource="#dsn#">
            SELECT 
                BUDGET_NAME,
                D.DEPARTMENT_HEAD
            FROM 
                BUDGET B
                LEFT JOIN DEPARTMENT D ON D.DEPARTMENT_ID = B.DEPARTMENT_ID
            WHERE
                BUDGET_ID = <cfqueryparam value = "#arguments.general_budget_id#" CFSQLType = "cf_sql_integer">
        </cfquery>
        <cfreturn get_budget_center>
    </cffunction>
    
    <cffunction name="get_project_actions" access="public" returntype="any">
        <cfparam name="project_id" default="">
        <cfquery name="GET_BANK_ACTIONS" datasource="#dsn2#">
            SELECT
				ISNULL(SUM(TOTAL_VALUE),0) TOTAL_VALUE,
				ACTION_CURRENCY_ID
			FROM
            (
                    SELECT 
                        ISNULL(SUM(ACTION_VALUE),0) TOTAL_VALUE,
                        ACTION_CURRENCY_ID 
                    FROM 
                        BANK_ACTIONS 
                    WHERE 
                        PROJECT_ID = <cfqueryparam value = "#arguments.project_id#" CFSQLType = "cf_sql_integer">
                    GROUP BY
                        ACTION_CURRENCY_ID
                UNION ALL
                    SELECT 
                        ISNULL(SUM(ACTION_VALUE),0) TOTAL_VALUE,
                        ACTION_CURRENCY_ID 
                    FROM 
                        CASH_ACTIONS 
                    WHERE 
                        PROJECT_ID = <cfqueryparam value = "#arguments.project_id#" CFSQLType = "cf_sql_integer">
                    GROUP BY
                        ACTION_CURRENCY_ID
                UNION ALL
                    SELECT 
                        ISNULL(SUM(ACTION_VALUE),0) TOTAL_VALUE,
                        ACTION_CURRENCY_ID 
                    FROM 
                        CARI_ACTIONS 
                    WHERE 
                        PROJECT_ID = <cfqueryparam value = "#arguments.project_id#" CFSQLType = "cf_sql_integer">
                    GROUP BY
                        ACTION_CURRENCY_ID
                UNION ALL
                    SELECT 
                        ISNULL(SUM(PAYROLL_TOTAL_VALUE),0) TOTAL_VALUE,
                        CURRENCY_ID ACTION_CURRENCY_ID  
                    FROM 
                        PAYROLL 
                    WHERE 
                        PROJECT_ID = <cfqueryparam value = "#arguments.project_id#" CFSQLType = "cf_sql_integer">
                    GROUP BY
                    CURRENCY_ID
                UNION ALL
                    SELECT 
                        ISNULL(SUM(PAYROLL_TOTAL_VALUE),0) TOTAL_VALUE,
                        CURRENCY_ID ACTION_CURRENCY_ID 
                    FROM 
                        VOUCHER_PAYROLL 
                    WHERE 
                        PROJECT_ID = <cfqueryparam value = "#arguments.project_id#" CFSQLType = "cf_sql_integer">
                    GROUP BY
                        CURRENCY_ID
                UNION ALL
                    SELECT 
                        ISNULL(SUM(SALES_CREDIT),0) TOTAL_VALUE,
                        ACTION_CURRENCY_ID 
                    FROM 
                        #dsn3#.CREDIT_CARD_BANK_PAYMENTS 
                    WHERE 
                        PROJECT_ID = <cfqueryparam value = "#arguments.project_id#" CFSQLType = "cf_sql_integer">
                    GROUP BY
                    ACTION_CURRENCY_ID
                UNION ALL
                    SELECT 
                        ISNULL(SUM(ACTION_VALUE),0) TOTAL_VALUE,
                        MONEY_CAT ACTION_CURRENCY_ID 
                    FROM 
                        #dsn#.COMPANY_SECUREFUND 
                    WHERE 
                        PROJECT_ID = <cfqueryparam value = "#arguments.project_id#" CFSQLType = "cf_sql_integer">
                    GROUP BY
                        MONEY_CAT
                UNION ALL
                    SELECT 
                        ISNULL(SUM(ACTION_VALUE),0) TOTAL_VALUE,
                        ACTION_MONEY ACTION_CURRENCY_ID 
                    FROM 
                        BANK_ORDERS 
                    WHERE 
                        PROJECT_ID = <cfqueryparam value = "#arguments.project_id#" CFSQLType = "cf_sql_integer">
                    GROUP BY
                    ACTION_MONEY
            )MAIN_QUERY
			GROUP BY
            ACTION_CURRENCY_ID
        </cfquery>
        <cfset total= structNew()>
        
        <cfset total.value = GET_BANK_ACTIONS.TOTAL_VALUE>
        <cfset total.currency = GET_BANK_ACTIONS.ACTION_CURRENCY_ID>
        <cfreturn total>
    </cffunction>

    <cffunction name="get_income_expense" access="public" returntype="any">
        <cfparam name="project_id" default="">
        <cfparam name="is_income" default="">
        <cfparam name="start_date" default="">
        <cfparam name="finish_date" default="">
        <cfparam name="process_cat_id" default="">
        <cfparam name="is_income_type" default="">
        <cfparam name="is_type" default="1">
        <cfquery name="get_income_expense" datasource="#dsn2#">
            SELECT
				TYPE,
				ISNULL(SUM(PRICE),0) PRICE,
				ISNULL(SUM(OTHER_PRICE),0) OTHER_PRICE
			FROM
			(
				SELECT
					1 TYPE,
					ISNULL(SUM(INVOICE_ROW.NETTOTAL),0) AS PRICE
					<cfif len(session.ep.money2)>
						,ISNULL(SUM(INVOICE_ROW.NETTOTAL/INVOICE_MONEY.RATE2),0) OTHER_PRICE
					<cfelse>
						,0 OTHER_PRICE
					</cfif>
				FROM 
					INVOICE,
					INVOICE_ROW 
                    <cfif len(session.ep.money2)>
						,INVOICE_MONEY
					</cfif>
                WHERE
                    ISNULL(INVOICE.PROJECT_ID,INVOICE_ROW.ROW_PROJECT_ID) = <cfqueryparam value = "#arguments.project_id#" CFSQLType = "cf_sql_integer">
                    AND INVOICE.INVOICE_ID = INVOICE_ROW.INVOICE_ID 
                    <cfif isdefined("arguments.process_cat_id") and len(arguments.process_cat_id)>AND INVOICE.INVOICE_CAT IN (<cfqueryparam value = "#arguments.process_cat_id#" CFSQLType = "cf_sql_integer" list="yes">) </cfif>
                    AND INVOICE_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.start_date#">
                    AND INVOICE_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.finish_date#">
					<cfif len(session.ep.money2)>
						AND INVOICE.INVOICE_ID = INVOICE_MONEY.ACTION_ID
						AND INVOICE_MONEY.MONEY_TYPE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money2#">
                    </cfif>
            <cfif is_type eq 1>
            UNION ALL
                SELECT
                        <!--- Gelir Fisi --->
                        1 TYPE,
                        ISNULL(SUM(EIR.AMOUNT),0) AS PRICE
                        <cfif len(session.ep.money2)>
                            ,ISNULL(SUM((EIR.AMOUNT)/#dsn#.IS_ZERO((EIR.TOTAL_AMOUNT/#dsn#.IS_ZERO(OTHER_MONEY_VALUE_2,1)),1)),0) OTHER_PRICE
                        <cfelse>
                            ,0 OTHER_PRICE
                        </cfif>
                    FROM
                        EXPENSE_ITEM_PLANS EIP,
                        EXPENSE_ITEMS_ROWS EIR
                    WHERE 
                        EIR.INVOICE_ID IS NULL AND <!--- Faturadan otomatik oluşturulmuş olan masraflar buraya gelmesin,çünkü zaten satışlar kısmına yansıyor buraya yansımaması lazım. --->
                        EIR.IS_INCOME = <cfqueryparam value = "#arguments.is_income#" CFSQLType = "cf_sql_bit"> AND
                        EIP.EXPENSE_ID = EIR.EXPENSE_ID AND
                        <cfif isDefined("arguments.is_income_type") and len(arguments.is_income_type)>
                            EIP.ACTION_TYPE = <cfqueryparam value = "#arguments.is_income_type#" CFSQLType = "cf_sql_integer"> AND <!--- Gelir Fisi Islem Tipi --->
                        </cfif>
                        ISNULL(EIP.PROJECT_ID,EIR.PROJECT_ID) =  <cfqueryparam value = "#arguments.project_id#" CFSQLType = "cf_sql_integer">
                        AND EIP.EXPENSE_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.start_date#">
                        AND EIP.EXPENSE_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.finish_date#">
                </cfif>
            )MAIN_QUERY
			GROUP BY
				TYPE
        </cfquery>
        <cfreturn get_income_expense>
    </cffunction>

    <cffunction name="get_project_team" access="public" returntype="any">
        <cfparam name="project_id" default="">
        <cfparam name="general_budget_id" default="">
        <cfparam name="statue_type" default="">
        <cfparam name="ssk_statue" default="">
        <cfparam name="sal_mon" default = "">
        <cfparam name="sal_year" default = "">
        <cfparam name="from_draggable" default = "0">
        <cfparam name="type" default = "">
        <cfquery name="get_project_team" datasource="#dsn#">
            SELECT 
                DISTINCT
                SPI.ODKES_ID,
                EIO.IN_OUT_ID,
                E.EMPLOYEE_ID,
                E.EMPLOYEE_NO,
                WGP.ROLE_HEAD,
                SPI.AMOUNT_PAY,
                SPI.COMMENT_PAY,
                ISNULL(PER_HOUR_SALARY,0) PER_HOUR_SALARY,
                E.EMPLOYEE_NAME,
                WGP.PRODUCT_MONEY,
                E.EMPLOYEE_SURNAME,
                WGP.PRODUCT_UNIT_PRICE,
                ISNULL(SUM(TOTAL_TIME),0) TOTAL_TIME
            FROM  
                WORKGROUP_EMP_PAR WGP
                INNER JOIN EMPLOYEES_IN_OUT EIO ON EIO.EMPLOYEE_ID = WGP.EMPLOYEE_ID AND EIO.FINISH_DATE IS NULL
                INNER JOIN EMPLOYEES E ON E.EMPLOYEE_ID = WGP.EMPLOYEE_ID
                LEFT JOIN TIME_COST TC ON TC.EMPLOYEE_ID = WGP.EMPLOYEE_ID 
                    AND YEAR(EVENT_DATE) =  <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.sal_year#">
                    AND MONTH(EVENT_DATE) = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.sal_mon#">
                    AND TC.PROJECT_ID = WGP.PROJECT_ID
                <cfif arguments.from_draggable neq 1>
                    INNER JOIN PROJECT_ALLOWANCE PA ON PA.PROJECT_ID =  WGP.PROJECT_ID
                        <cfif len(arguments.sal_year) and len(arguments.sal_mon)>
                            AND PA.SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.sal_year#">
                            AND PA.SAL_MON = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.sal_mon#">
                        </cfif>
                        <!----<cfif len(arguments.general_budget_id)>
                            AND PA.BUDGET_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.general_budget_id#">
                        </cfif>--->
                    LEFT JOIN PROJECT_ALLOWANCE_ROW PAR ON PAR.PROJECT_ALLOWANCE_ID =  PA.PROJECT_ALLOWANCE_ID 
                        <cfif isdefined("arguments.type")> AND PAR.TYPE = <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.type#"></cfif>
                </cfif>
                ,SETUP_PAYMENT_INTERRUPTION SPI
            WHERE
                WGP.PROJECT_ID = <cfqueryparam value = "#arguments.project_id#" CFSQLType = "cf_sql_integer">
                AND SPI.SSK_STATUE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.ssk_statue#"> 
                <cfif isdefined("arguments.statue_type") and len("arguments.statue_type") and arguments.ssk_statue eq 2>
                    AND SPI.STATUE_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.statue_type#">
                </cfif>
            GROUP BY
                ODKES_ID,
                EIO.IN_OUT_ID,
                E.EMPLOYEE_ID,
                E.EMPLOYEE_NO,
                WGP.ROLE_HEAD,
                SPI.AMOUNT_PAY,
                SPI.COMMENT_PAY,
                PER_HOUR_SALARY,
                E.EMPLOYEE_NAME,
                WGP.PRODUCT_MONEY,
                E.EMPLOYEE_SURNAME,
                WGP.PRODUCT_UNIT_PRICE
        </cfquery>
        <cfreturn get_project_team>
    </cffunction>

    <cffunction name="get_project_detail" access="public" returntype="any">
        <cfparam name="project_id" default="">
        <cfparam name="general_budget_id" default="">
        <cfparam name="statue_type" default="">
        <cfparam name="ssk_statue" default="">
        <cfparam name="sal_mon" default = "">
        <cfparam name="sal_year" default = "">
        <cfparam name="from_draggable" default = "0">
        <cfparam name="type" default = "">
        <cfparam name="is_print" default = "0"> 
        <cfquery name="get_project_detail" datasource="#dsn#">
            SELECT 
                PA.*,
                PAR.*,
                E.EMPLOYEE_NO,
                WGP.ROLE_HEAD,
                SPI.COMMENT_PAY
            FROM  
                PROJECT_ALLOWANCE PA
                INNER JOIN PROJECT_ALLOWANCE_ROW PAR ON PAR.PROJECT_ALLOWANCE_ID =  PA.PROJECT_ALLOWANCE_ID
                INNER JOIN EMPLOYEES E ON E.EMPLOYEE_ID = PAR.EMPLOYEE_ID
                INNER JOIN WORKGROUP_EMP_PAR WGP ON WGP.PROJECT_ID = PA.PROJECT_ID
                INNER JOIN SETUP_PAYMENT_INTERRUPTION SPI ON SPI.ODKES_ID = PAR.COMMENT_PAY_ID AND WGP.EMPLOYEE_ID = PAR.EMPLOYEE_ID
            WHERE
                <cfif isdefined("arguments.is_print") and len(arguments.is_print) and arguments.is_print eq 1>
                    PAPER_NO = <cfqueryparam value = "#arguments.paper_no#" CFSQLType = "cf_sql_nvarchar">
                <cfelse>
                    PA.PROJECT_ID = <cfqueryparam value = "#arguments.project_id#" CFSQLType = "cf_sql_integer">
                    AND PA.SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.sal_year#">
                    AND PA.SAL_MON = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.sal_mon#">
                    <cfif isdefined("arguments.general_budget_id") and len(arguments.general_budget_id)>
                        AND PA.BUDGET_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.general_budget_id#">
                    </cfif>
                    AND PA.SSK_STATUE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.ssk_statue#"> 
                    <cfif isdefined("arguments.statue_type") and len("arguments.statue_type") and arguments.ssk_statue eq 2>
                        AND PA.STATUE_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.statue_type#">
                    </cfif>
                </cfif> 
                    AND PAR.TYPE = #arguments.type#
            ORDER BY 
                EMPLOYEE_NAME,
                EMPLOYEE_SURNAME
        </cfquery>
        <cfreturn get_project_detail>
    </cffunction>

    <cffunction name="get_main_project_allowance" access="public" returntype="any">
        <cfparam name="project_id" default="">
        <cfparam name="general_budget_id" default="">
        <cfparam name="statue_type" default="">
        <cfparam name="ssk_statue" default="">
        <cfparam name="sal_mon" default = "">
        <cfparam name="sal_year" default = "">
        <cfparam name="from_draggable" default = "0">
        <cfparam name="type" default = "">
        <cfparam name="is_print" default = "0"> 
        <cfquery name="get_main_project_allowance" datasource="#dsn#">
            SELECT 
                *
            FROM  
                PROJECT_ALLOWANCE 
            WHERE
                <cfif isdefined("arguments.is_print") and len(arguments.is_print) and arguments.is_print eq 1>
                    PAPER_NO = <cfqueryparam value = "#arguments.paper_no#" CFSQLType = "cf_sql_nvarchar">
                <cfelse>
                    PROJECT_ID = <cfqueryparam value = "#arguments.project_id#" CFSQLType = "cf_sql_integer">
                    AND SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.sal_year#">
                    AND SAL_MON = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.sal_mon#">
                    <cfif len(arguments.general_budget_id)>
                        AND BUDGET_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.general_budget_id#">
                    </cfif>
                    AND SSK_STATUE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.ssk_statue#"> 
                    <cfif isdefined("arguments.statue_type") and len("arguments.statue_type") and arguments.ssk_statue eq 2>
                        AND STATUE_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.statue_type#">
                    </cfif>
                </cfif>
        </cfquery>
        <cfreturn get_main_project_allowance>
    </cffunction>

    <cffunction name="add_project_detail_info" access="public" returntype="any">
        <cftry>
            <cfset responseStruct = structNew()>
            <cfset action_list_id = "">
            <cfset totalValues = structNew()>   
            <cfquery name="add_" datasource="#dsn#" result="MAX_ID">
                INSERT INTO 
                    PROJECT_ALLOWANCE
                    (
                        PAPER_NO
                        ,SAL_YEAR
                        ,SAL_MON
                        ,SSK_STATUE
                        ,STATUE_TYPE
                        ,DIRECTOR_SHARE
                        ,DISTRIBUTION
                        ,DIRECTOR_AMOUNT
                        ,EMPLOYEE_AMOUNT
                        ,TOTAL_AMOUNT
                        ,CURRENCY_UNIT
                        ,PROJECT_ID
                        ,BUDGET_ID
                        ,PROCESS_ID
                        ,BRANCH_ID
                        ,RECORD_DATE
                        ,RECORD_EMP
                        ,RECORD_IP
                    )
                VALUES
                    (
                        <cfqueryparam value = "#arguments.general_paper_no#" CFSQLType = "cf_sql_nvarchar">
                        ,<cfqueryparam value = "#arguments.sal_year#" CFSQLType = "cf_sql_integer">
                        ,<cfqueryparam value = "#arguments.sal_mon#" CFSQLType = "cf_sql_integer">
                        ,<cfqueryparam value = "#arguments.ssk_statue#" CFSQLType = "cf_sql_integer">
                        ,<cfqueryparam value = "#arguments.statue_type#" CFSQLType = "cf_sql_integer">
                        ,<cfqueryparam value = "#arguments.director_share#" CFSQLType = "cf_sql_float">
                        ,<cfqueryparam value = "#arguments.distribution#" CFSQLType = "cf_sql_float">
                        ,<cfqueryparam value = "#arguments.director_amount#" CFSQLType = "cf_sql_float">
                        ,<cfqueryparam value = "#arguments.employee_amount#" CFSQLType = "cf_sql_float">
                        ,<cfqueryparam value = "#arguments.total#" CFSQLType = "cf_sql_float">
                        ,<cfqueryparam value = "#arguments.money#" CFSQLType = "cf_sql_nvarchar">
                        ,<cfqueryparam value = "#arguments.project_id#" CFSQLType = "cf_sql_integer">
                        ,<cfif len(arguments.general_budget_id) and arguments.general_budget_id neq ''><cfqueryparam value = "#arguments.general_budget_id#" CFSQLType = "cf_sql_integer"><cfelse>NULL</cfif>
                        ,<cfqueryparam value = "#arguments.process_stage#" CFSQLType = "cf_sql_integer">
                        ,<cfqueryparam value = "#arguments.branch_id#" CFSQLType = "cf_sql_integer">
                        ,<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
                        ,<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
                        ,<cfqueryparam cfsqltype="cf_sql_varchar" value='#cgi.remote_addr#'>
                    )
            </cfquery>

            <cfloop index="i" from="1" to="#arguments.row_count#">
                <cfif evaluate("arguments.satir#i#") eq 1>
                    <cfquery name="add_row" datasource="#dsn#">
                        INSERT INTO 
                            PROJECT_ALLOWANCE_ROW
                            (
                                IN_OUT_ID
                                ,EMPLOYEE_ID
                                ,HOUR_PAYMENT
                                ,HOURLY_WORK
                                ,AMOUNT
                                ,IS_ALLOWANCE
                                ,TYPE
                                ,COMMENT_PAY_ID
                                ,PROJECT_ALLOWANCE_ID
                                ,SHARE
                            )
                            VALUES
                            (
                                <cfqueryparam value = "#evaluate("arguments.in_out_id#i#")#" CFSQLType = "cf_sql_integer">
                                ,<cfqueryparam value = "#evaluate("arguments.employee_id#i#")#" CFSQLType = "cf_sql_integer">
                                ,<cfif isdefined("arguments.per_hour_salary#i#") and len(evaluate("arguments.per_hour_salary#i#"))><cfqueryparam value = "#evaluate("arguments.per_hour_salary#i#")#" CFSQLType = "cf_sql_float"><cfelse>NULL</cfif>
                                ,<cfif isdefined("arguments.total_time#i#") and len(evaluate("arguments.total_time#i#"))><cfqueryparam value = "#evaluate("arguments.total_time#i#")#" CFSQLType = "cf_sql_float"><cfelse>NULL</cfif>
                                ,<cfif isdefined("arguments.total_value#i#") and len(evaluate("arguments.total_value#i#"))><cfqueryparam value = "#evaluate("arguments.total_value#i#")#" CFSQLType = "cf_sql_float"><cfelse>NULL</cfif>
                                ,<cfqueryparam value = "0" CFSQLType = "cf_sql_bit"> 
                                ,<cfqueryparam value = "#evaluate("arguments.type#i#")#" CFSQLType = "cf_sql_integer">                          
                                ,<cfif isdefined("arguments.comment_pay_id#i#") and len(evaluate("arguments.comment_pay_id#i#"))><cfqueryparam value = "#evaluate("arguments.comment_pay_id#i#")#" CFSQLType = "cf_sql_integer"><cfelse>NULL</cfif>
                                ,<cfqueryparam value = "#MAX_ID.IDENTITYCOL#" CFSQLType = "cf_sql_integer">
                                ,<cfif isdefined("arguments.share#i#") and len(evaluate("arguments.share#i#"))><cfqueryparam value = "#evaluate("arguments.share#i#")#" CFSQLType = "cf_sql_integer"><cfelse>NULL</cfif>
                            )
                    </cfquery>
                </cfif>
            </cfloop>
            <cfset allowance_expense_list = {"TOTAL_AMOUNT":"#arguments.total#","BORDRO_TYPE":"#arguments.statue_type#","SSK_STATUE":"#arguments.ssk_statue#"}>
            <cfset StructAppend(totalValues,allowance_expense_list,false)>
            <cf_workcube_general_process
                mode = "query"
                general_paper_parent_id = "#(isDefined("arguments.general_paper_parent_id") and len(arguments.general_paper_parent_id)) ? arguments.general_paper_parent_id : 0#"
                general_paper_no = "#arguments.general_paper_no#"
                general_paper_date = "#arguments.general_paper_date#"
                action_list_id = "#action_list_id#"
                process_stage = "#arguments.process_stage#"
                responsible_employee_id = "#(isDefined("arguments.responsible_employee_id") and len(arguments.responsible_employee_id) and isDefined("arguments.responsible_employee") and len(arguments.responsible_employee)) ? arguments.responsible_employee_id : 0#"
                responsible_employee_pos = "#(isDefined("arguments.responsible_employee_pos") and len(arguments.responsible_employee_pos) and isDefined("arguments.responsible_employee") and len(arguments.responsible_employee)) ? arguments.responsible_employee_pos : 0#"
                action_table = 'PROJECT_ALLOWANCE'
                action_column = 'PROJECT_ALLOWANCE_ID'
                action_page = 'index.cfm?fuseaction=hr.project_allowance'
                total_values = '#totalValues#'
                >

            <cfset responseStruct.message = "İşlem Başarılı">
            <cfset responseStruct.status = true>
            <cfset responseStruct.error = {}>
            <cfset responseStruct.identity = ''>
        <cfcatch type="database">
            <cftransaction action="rollback">
            <cfset responseStruct.message = "İşlem Hatalı">
            <cfset responseStruct.status = false>
            <cfset responseStruct.error = cfcatch>
        </cfcatch>
        </cftry>
        <cfreturn responseStruct>
    </cffunction>

    <cffunction name="upd_project_detail_info" access="public" returntype="any">
        <cftry>
            <cfset responseStruct = structNew()>
            <cfset action_list_id = "">
            <cfset totalValues = structNew()>
            <cfquery name="upd_" datasource="#dsn#" result="MAX_ID">
                UPDATE 
                    PROJECT_ALLOWANCE
                SET 
                    PAPER_NO = <cfqueryparam value = "#arguments.general_paper_no#" CFSQLType = "cf_sql_nvarchar">
                    ,SAL_YEAR = <cfqueryparam value = "#arguments.sal_year#" CFSQLType = "cf_sql_integer">
                    ,SAL_MON = <cfqueryparam value = "#arguments.sal_mon#" CFSQLType = "cf_sql_integer">
                    ,SSK_STATUE = <cfqueryparam value = "#arguments.ssk_statue#" CFSQLType = "cf_sql_integer">
                    ,STATUE_TYPE = <cfif arguments.ssk_statue eq 2 and len(arguments.statue_type)><cfqueryparam value = "#arguments.statue_type#" CFSQLType = "cf_sql_integer"><cfelse>NULL</cfif>
                    ,DIRECTOR_SHARE = <cfqueryparam value = "#arguments.director_share#" CFSQLType = "cf_sql_float">
                    ,DISTRIBUTION = <cfqueryparam value = "#arguments.distribution#" CFSQLType = "cf_sql_float">
                    ,DIRECTOR_AMOUNT = <cfqueryparam value = "#arguments.director_amount#" CFSQLType = "cf_sql_float">
                    ,EMPLOYEE_AMOUNT = <cfqueryparam value = "#arguments.employee_amount#" CFSQLType = "cf_sql_float">
                    ,TOTAL_AMOUNT = <cfqueryparam value = "#arguments.total#" CFSQLType = "cf_sql_float">
                    ,CURRENCY_UNIT =<cfqueryparam value = "#arguments.money#" CFSQLType = "cf_sql_nvarchar">
                    ,PROJECT_ID = <cfqueryparam value = "#arguments.project_id#" CFSQLType = "cf_sql_integer">
                    ,BUDGET_ID = <cfif len(arguments.general_budget_id) and arguments.general_budget_id neq ''><cfqueryparam value = "#arguments.general_budget_id#" CFSQLType = "cf_sql_integer"><cfelse>NULL</cfif>
                    ,PROCESS_ID = <cfqueryparam value = "#arguments.process_stage#" CFSQLType = "cf_sql_integer">
                    ,BRANCH_ID = <cfqueryparam value = "#arguments.branch_id#" CFSQLType = "cf_sql_integer">
                    ,UPDATE_DATE = <cfqueryparam value="#NOW()#" cfsqltype="cf_sql_timestamp">
                    ,UPDATE_EMP = <cfqueryparam value="#SESSION.EP.USERID#" cfsqltype="cf_sql_integer">
                    ,UPDATE_IP =  <cfqueryparam value="#CGI.REMOTE_ADDR#" cfsqltype="cf_sql_nvarchar">
                WHERE 
                    PROJECT_ALLOWANCE_ID = <cfqueryparam value = "#arguments.project_allowance_id#" CFSQLType = "cf_sql_integer">
            </cfquery>
            <cfif arguments.director_row_count+arguments.employee_row_count gt 0>
                <cfloop index="j" from="1" to="#arguments.director_row_count+arguments.employee_row_count#">
                    <cfset action_list_id = listAppend(action_list_id, evaluate("arguments.in_out_id_fixed#j#"))>
                    <cfif evaluate("arguments.fixed#j#") eq 1>
                        <cfquery name="upd_row" datasource="#dsn#">
                            UPDATE 
                                PROJECT_ALLOWANCE_ROW
                            SET 
                                HOUR_PAYMENT = <cfif isdefined("arguments.per_hour_salary_fixed#j#") and len(evaluate("arguments.per_hour_salary_fixed#j#"))><cfqueryparam value = "#evaluate("arguments.per_hour_salary_fixed#j#")#" CFSQLType = "cf_sql_float"><cfelse>NULL</cfif>
                                ,HOURLY_WORK = <cfif isdefined("arguments.total_time_fixed#j#") and len(evaluate("arguments.total_time_fixed#j#"))><cfqueryparam value = "#evaluate("arguments.total_time_fixed#j#")#" CFSQLType = "cf_sql_float"><cfelse>NULL</cfif>
                                ,AMOUNT = <cfif isdefined("arguments.total_value_fixed#j#") and len(evaluate("arguments.total_value_fixed#j#"))><cfqueryparam value = "#evaluate("arguments.total_value_fixed#j#")#" CFSQLType = "cf_sql_float"><cfelse>NULL</cfif>
                                ,IS_ALLOWANCE = <cfqueryparam value = "0" CFSQLType = "cf_sql_bit"> 
                                ,TYPE = <cfif isdefined("arguments.type_fixed#j#") and len(evaluate("arguments.type_fixed#j#"))><cfqueryparam value = "#evaluate("arguments.type_fixed#j#")#" CFSQLType = "cf_sql_bit"><cfelse>NULL</cfif>
                                ,COMMENT_PAY_ID = <cfif isdefined("arguments.comment_pay_id_fixed#j#") and len(evaluate("arguments.comment_pay_id_fixed#j#"))><cfqueryparam value = "#evaluate("arguments.comment_pay_id_fixed#j#")#" CFSQLType = "cf_sql_integer"><cfelse>NULL</cfif>
                                ,PROJECT_ALLOWANCE_ID = <cfqueryparam value = "#arguments.project_allowance_id#" CFSQLType = "cf_sql_integer">
                                ,SHARE = <cfif isdefined("arguments.share_fixed#j#") and len(evaluate("arguments.share_fixed#j#"))><cfqueryparam value = "#evaluate("arguments.share_fixed#j#")#" CFSQLType = "cf_sql_integer"><cfelse>NULL</cfif>
                            WHERE 
                                PROJECT_ALLOWANCE_ROW_ID = <cfqueryparam value = "#evaluate("arguments.project_allowance_row_id_fixed#j#")#" CFSQLType = "cf_sql_integer">
                                AND TYPE = <cfqueryparam value = "#evaluate("arguments.type_fixed#j#")#" CFSQLType = "cf_sql_bit"> 
                                AND PROJECT_ALLOWANCE_ID = <cfqueryparam value = "#arguments.project_allowance_id#" CFSQLType = "cf_sql_integer">
                        </cfquery>
                    <cfelse>
                        <cfquery name="del_row" datasource="#dsn#">
                            DELETE FROM
                                PROJECT_ALLOWANCE_ROW 
                            WHERE 
                                PROJECT_ALLOWANCE_ROW_ID = <cfqueryparam value = "#evaluate("arguments.project_allowance_row_id_fixed#j#")#" CFSQLType = "cf_sql_integer"> 
                                AND TYPE = <cfqueryparam value = "#evaluate("arguments.type_fixed#j#")#" CFSQLType = "cf_sql_bit">  
                                AND PROJECT_ALLOWANCE_ID = <cfqueryparam value = "#arguments.project_allowance_id#" CFSQLType = "cf_sql_integer">
                        </cfquery>
                    </cfif>
                </cfloop>
            </cfif>
            <cfif arguments.row_count gt 0>
                <cfloop index="i" from="1" to="#arguments.row_count#">
                    <cfset action_list_id = listAppend(action_list_id, evaluate("arguments.in_out_id#i#"))>
                    <cfif evaluate("arguments.satir#i#") eq 1>
                        <cfquery name="add_row" datasource="#dsn#">
                            INSERT INTO 
                                PROJECT_ALLOWANCE_ROW
                                (
                                    IN_OUT_ID
                                    ,EMPLOYEE_ID
                                    ,HOUR_PAYMENT
                                    ,HOURLY_WORK
                                    ,AMOUNT
                                    ,IS_ALLOWANCE
                                    ,TYPE
                                    ,COMMENT_PAY_ID
                                    ,PROJECT_ALLOWANCE_ID
                                    ,SHARE                                
                                )
                            VALUES
                            (
                                <cfqueryparam value = "#evaluate("arguments.in_out_id#i#")#" CFSQLType = "cf_sql_integer">
                                ,<cfqueryparam value = "#evaluate("arguments.employee_id#i#")#" CFSQLType = "cf_sql_integer">
                                ,<cfif isdefined("arguments.per_hour_salary#i#") and len(evaluate("arguments.per_hour_salary#i#"))><cfqueryparam value = "#evaluate("arguments.per_hour_salary#i#")#" CFSQLType = "cf_sql_float"><cfelse>NULL</cfif>
                                ,<cfif isdefined("arguments.total_time#i#") and len(evaluate("arguments.total_time#i#"))><cfqueryparam value = "#evaluate("arguments.total_time#i#")#" CFSQLType = "cf_sql_float"><cfelse>NULL</cfif>
                                ,<cfif isdefined("arguments.total_value#i#") and len(evaluate("arguments.total_value#i#"))><cfqueryparam value = "#evaluate("arguments.total_value#i#")#" CFSQLType = "cf_sql_float"><cfelse>NULL</cfif>
                                ,<cfqueryparam value = "0" CFSQLType = "cf_sql_bit"> 
                                ,<cfqueryparam value = "#evaluate("arguments.type#i#")#" CFSQLType = "cf_sql_bit">                           
                                ,<cfif isdefined("arguments.comment_pay_id#i#") and len(evaluate("arguments.comment_pay_id#i#"))><cfqueryparam value = "#evaluate("arguments.comment_pay_id#i#")#" CFSQLType = "cf_sql_integer"><cfelse>NULL</cfif>
                                ,<cfif isdefined("arguments.project_allowance_id") and len(evaluate("arguments.project_allowance_id"))><cfqueryparam value = "#arguments.project_allowance_id#" CFSQLType = "cf_sql_integer"><cfelse>NULL</cfif>
                                ,<cfif isdefined("arguments.share#i#") and len(evaluate("arguments.share#i#"))><cfqueryparam value = "#evaluate("arguments.share#i#")#" CFSQLType = "cf_sql_integer"><cfelse>NULL</cfif>
                            )
                        </cfquery>
                    </cfif>
                </cfloop>
            </cfif>
            <cfset allowance_expense_list = {"TOTAL_AMOUNT":"#arguments.total#","BORDRO_TYPE":"#arguments.statue_type#","SSK_STATUE":"#arguments.ssk_statue#"}>
            <cfset StructAppend(totalValues,allowance_expense_list,false)>
            <cf_workcube_general_process
                mode = "query"
                general_paper_parent_id = "#(isDefined("arguments.general_paper_parent_id") and len(arguments.general_paper_parent_id)) ? arguments.general_paper_parent_id : 0#"
                general_paper_no = "#arguments.general_paper_no#"
                general_paper_date = "#arguments.general_paper_date#"
                action_list_id = "#action_list_id#"
                process_stage = "#arguments.process_stage#"
                responsible_employee_id = "#(isDefined("arguments.responsible_employee_id") and len(arguments.responsible_employee_id) and isDefined("arguments.responsible_employee") and len(arguments.responsible_employee)) ? arguments.responsible_employee_id : 0#"
                responsible_employee_pos = "#(isDefined("arguments.responsible_employee_pos") and len(arguments.responsible_employee_pos) and isDefined("arguments.responsible_employee") and len(arguments.responsible_employee)) ? arguments.responsible_employee_pos : 0#"
                action_table = 'PROJECT_ALLOWANCE'
                action_column = 'PROJECT_ALLOWANCE_ID'
                action_page = 'index.cfm?fuseaction=hr.project_allowance'
                total_values = '#totalValues#'
                >
            <cfset responseStruct.message = "İşlem Başarılı">
            <cfset responseStruct.status = true>
            <cfset responseStruct.error = {}>
            <cfset responseStruct.identity = ''>
        <cfcatch type="database">
            <cftransaction action="rollback">
            <cfset responseStruct.message = "İşlem Hatalı">
            <cfset responseStruct.status = false>
            <cfset responseStruct.error = cfcatch>
        </cfcatch>
        </cftry>
        <cfreturn responseStruct>
    </cffunction>

     <!--- Ödenek bilgileri --->
     <cffunction name="get_allowance" access="public" returntype="query">
        <cfparam name="statue_type" default="">
        <cfparam name="ssk_statue" default="">
        <cfparam name="odkes_id" default="">
        <cfparam name="from_payment" default="0">
        <cfquery name="get_allowance" datasource="#dsn#">
            SELECT 
                *
            FROM 
                SETUP_PAYMENT_INTERRUPTION 
            WHERE 
                <cfif isdefined("arguments.statue_type") and len(arguments.statue_type)>
                    SSK_STATUE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.ssk_statue#"> AND
                    STATUE_TYPE =  <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.statue_type#">
                </cfif>
                <cfif isdefined("arguments.odkes_id") and len(arguments.odkes_id)>
                    ODKES_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.odkes_id#">
                </cfif>
                <cfif isdefined("arguments.from_payment") and arguments.from_payment eq 1>
                    IS_ODENEK = 1 AND
                    ISNULL(IS_BES,0) = 0 AND
                    STATUS = 1
                </cfif>
        </cfquery>
        <cfreturn get_allowance>
    </cffunction>

    <cffunction name="add_project_allowance" access="remote" returntype="any">
        <cftry>
            <cfset responseStruct = structNew()> 
            <cfset allowance_expense_cmp = createObject("component","V16.myhome.cfc.allowance_expense") /><!--- Ek Ödenek --->
            <cfquery name="DELETE_SALARYPARAM_PAY" datasource="#dsn#">
                DELETE FROM SALARYPARAM_PAY WHERE SPECIAL_CODE = <cfqueryparam value = "PROJECTALLOWANCE_#arguments.project_allowance_id#" CFSQLType = "cf_sql_nvarchar">
            </cfquery>
            <cfif arguments.director_row_count+arguments.employee_row_count gt 0>
                <cfloop index="j" from="1" to="#arguments.director_row_count+arguments.employee_row_count#">
                    <cfif evaluate("arguments.fixed#j#") eq 1>
                        <cfset get_allowance_property = this.get_allowance(odkes_id: evaluate("arguments.comment_pay_id_fixed#j#"))>
                        <cfif evaluate("arguments.type_fixed#j#") eq 0>
                            <cfset total_value_row = arguments.distribution * evaluate("arguments.total_value_fixed#j#") / 100>
                        <cfelse>
                            <cfset total_value_row = evaluate("arguments.total_value_fixed#j#")>
                        </cfif>
                        
                        <cfset add_allowance_expense = allowance_expense_cmp.ADD_SALARYPARAM_PAY(
                                comment_pay :  get_allowance_property.comment_pay,<!--- Ödenek İsmi --->
                                comment_pay_id : get_allowance_property.odkes_id,<!---Ödenek Id --->
                                amount_pay : total_value_row,<!--- Ödenek (Kurum Payı) --->
                                ssk : get_allowance_property.ssk,<!--- ssk 1 : muaf, 2: muaf değil ---> 
                                tax : get_allowance_property.tax,<!--- vergi 1 : muaf, 2: muaf değil---> 
                                is_damga : get_allowance_property.is_damga,<!--- damga vergisi --->
                                is_issizlik : get_allowance_property.is_issizlik,<!--- işsizlik ---> 
                                show : get_allowance_property.show,<!--- bordroda görünsün ---> 
                                method_pay : get_allowance_property.method_pay,<!--- 1: artı, 2 : ay , 3 : gün, 4 : saat, 5: saat x ödenek tutarı---> 
                                period_pay : get_allowance_property.period_pay,<!--- 1: ayda 1, 2 : 3 ayda 1 , 3 : 6 ayda 1, 4 : yılda 1---> 
                                start_sal_mon : arguments.sal_mon,<!--- Başlangıç Ayı --->
                                end_sal_mon : arguments.sal_mon,<!--- Bitiş Ayı --->
                                employee_id : evaluate("arguments.employee_id_fixed#j#"),<!--- çalışan id --->
                                term : arguments.sal_year,<!--- yıl --->
                                calc_days : get_allowance_property.calc_days,<!---tutar günü 0 : tümü, 1: gün,2 : fiili gün --->
                                is_kidem : get_allowance_property.is_kidem,<!--- kıdeme dahil 1:kıdeme ahil,0 kıdeme dahil değil ??? sorulacak--->
                                in_out_id : evaluate("arguments.in_out_id_fixed#j#"),<!--- Giriş çıkış id --->
                                from_salary : get_allowance_property.from_salary, <!--- 0 :net,1 : brüt --->
                                is_ehesap : get_allowance_property.is_ehesap,<!--- üst düzey ik yetkisi 1 : dahi, 0 :dahil değil--->
                                is_ayni_yardim : get_allowance_property.is_ayni_yardim,<!--- ayni yardım --->
                                tax_exemption_value : get_allowance_property.tax_exemption_value,<!--- Gelir Vergisi Muafiyet Tutarı --->
                                tax_exemption_rate : get_allowance_property.tax_exemption_rate,<!--- Gelir Vergisi Muafiyet Oranı--->
                                money : get_allowance_property.MONEY,<!--- Para birimi--->
                                is_income : get_allowance_property.is_income,<!--- kazançlara dahil--->
                                is_not_execution : get_allowance_property.is_not_execution,<!--- İcraya Dahil Değil --->
                                comment_type : get_allowance_property.comment_type,<!--- 1: ek ödenek, 2: kazanc --->
                                special_code : 'PROJECTALLOWANCE_'&arguments.project_allowance_id,
                                total_hour : isdefined("arguments.total_time_fixed#j#") ? evaluate("arguments.total_time_fixed#j#") : 0,
                                paper_no : arguments.general_paper_no,
                                ssk_statue : arguments.ssk_statue,
                                statue_type : listfirst(arguments.statue_type),
                                project_id : arguments.project_id
                                ) />
                        <cfquery name="upd_row" datasource="#dsn#">
                            UPDATE 
                                PROJECT_ALLOWANCE_ROW
                            SET 
                                IS_ALLOWANCE = <cfqueryparam value = "1" CFSQLType = "cf_sql_bit"> 
                            WHERE 
                                PROJECT_ALLOWANCE_ROW_ID = <cfqueryparam value = "#evaluate("arguments.project_allowance_row_id_fixed#j#")#" CFSQLType = "cf_sql_integer">
                                AND TYPE = <cfqueryparam value = "#evaluate("arguments.type_fixed#j#")#" CFSQLType = "cf_sql_bit"> 
                                AND PROJECT_ALLOWANCE_ID = <cfqueryparam value = "#arguments.project_allowance_id#" CFSQLType = "cf_sql_integer">
                        </cfquery>
                    </cfif>
                </cfloop>
            </cfif>
                    
            <cfset responseStruct.message = "İşlem Başarılı">
            <cfset responseStruct.status = true>
            <cfset responseStruct.error = {}>
            <cfset responseStruct.identity = ''>
            <script>
                window.location.href='/index.cfm?fuseaction=hr.project_allowance';
            </script>
        <cfcatch type="database">
            <cftransaction action="rollback">
            <cfset responseStruct.message = "İşlem Hatalı">
            <cfset responseStruct.status = false>
            <cfset responseStruct.error = cfcatch>
        </cfcatch>
        </cftry>
        <cfreturn responseStruct>
    </cffunction>

    <cffunction name="del_project" access="public" returntype="any">
        <cftry>
            <cfset responseStruct = structNew()> 
            <!--- Ödenek silme --->
            <cfquery name="DELETE_SALARYPARAM_PAY" datasource="#dsn#">
                DELETE FROM SALARYPARAM_PAY WHERE SPECIAL_CODE = <cfqueryparam value = "PROJECTALLOWANCE_#arguments.project_allowance_id#" CFSQLType = "cf_sql_nvarchar">
            </cfquery>
            <!--- Main --->
            <cfquery name="PROJECT_ALLOWANCE" datasource="#dsn#">
                DELETE FROM PROJECT_ALLOWANCE WHERE PROJECT_ALLOWANCE_ID = <cfqueryparam value = "#arguments.project_allowance_id#" CFSQLType = "cf_sql_integer">
            </cfquery>
            <!--- Row --->
            <cfquery name="PROJECT_ALLOWANCE" datasource="#dsn#">
                DELETE FROM PROJECT_ALLOWANCE_ROW WHERE PROJECT_ALLOWANCE_ID = <cfqueryparam value = "#arguments.project_allowance_id#" CFSQLType = "cf_sql_integer">
            </cfquery>
            <cfset responseStruct.message = "İşlem Başarılı">
            <cfset responseStruct.status = true>
            <cfset responseStruct.error = {}>
            <cfset responseStruct.identity = ''>
        <cfcatch type="database">
            <cftransaction action="rollback">
            <cfset responseStruct.message = "İşlem Hatalı">
            <cfset responseStruct.status = false>
            <cfset responseStruct.error = cfcatch>
        </cfcatch>
        </cftry>
        <cfreturn responseStruct>
    </cffunction>
</cfcomponent>