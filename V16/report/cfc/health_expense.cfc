<cfcomponent>
    <cfset dsn = application.systemParam.systemParam().dsn>
    <cfset dsn2= "#dsn#_#session.ep.period_year#_#session.ep.company_id#">
    <cfset dsn3 = "#dsn#_#session.ep.company_id#">
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
    <cffunction name="GET_EXPENSE_LIST" returntype="query">
            <cfargument name="search_date1" default="">
            <cfargument name="search_date2" default="">
            <cfargument name="startrow" default="">
            <cfargument name="acc_code1_1" default="">
            <cfargument name="acc_code2_1" default="">
            <cfargument name="maxrows" default="">
            <cfargument name="keyword" default="">
            <cfargument name="module_name" type="string" required="false" default="" />
            <cfargument name="is_account" default="">
            <cfargument name="is_excel" default="">
            <cfquery name="GET_EXPENSE" datasource="#dsn2#">
                WITH CTE1 AS(
                    SELECT
							E.PAPER_TYPE PAPER_TYPE
                            ,E.EMP_ID
                            ,E.MONEY
                            ,EMPLOYEES.EMPLOYEE_NAME + ' ' + EMPLOYEES.EMPLOYEE_SURNAME AS EMP_FULLNAME
                            ,E.ASSURANCE_ID
                            ,E.TREATMENT_ID
                            ,E.TOTAL_AMOUNT
                            ,ISNULL(E.TREATMENT_AMOUNT,0) AS TREATMENT_AMOUNT
                            ,ISNULL(E.OUR_COMPANY_HEALTH_AMOUNT,0) AS OUR_COMPANY_HEALTH_AMOUNT
                            ,ISNULL(E.EMPLOYEE_HEALTH_AMOUNT,0) AS EMPLOYEE_HEALTH_AMOUNT
                            ,E.EXPENSE_DATE EXP_DATE
                            ,EMPLOYEES.EMPLOYEE_NO
                            ,E.RECORD_DATE  RECORD_DATE
                            ,E.UPDATE_DATE  UPDATE_DATE
                            ,E.EXPENSE_DATE
                            ,E.EXPENSE_ID  EXPENSE
                            ,E.PAPER_NO
                            ,ER.NAME + ' ' + ER.SURNAME AS FULLNAME,
							E.TREATED,
                            E.RELATIVE_ID,
                            E.EXPENSE_ITEM_PLANS_ID,
                            ER.RELATIVE_LEVEL,
                            E.COMPANY_ID,
                            E.CONSUMER_ID,
                            E.COMPANY_NAME,
                            E.INVOICE_NO,
                            C.FULLNAME AS COMPANY_FULLNAME
                            , E.SYSTEM_RELATION
                            ,AC.CARD_ID
                            ,ACR.AMOUNT
                            ,ACR.ACCOUNT_ID
                            ,AC.ACTION_DATE
                          --  ,(SELECT AMOUNT_PAY FROM #dsn#.SALARYPARAM_PAY WHERE EXPENSE_HEALTH_ID =  E.EXPENSE_ID) AS S_PAY
                           -- ,(SELECT AMOUNT_GET FROM #dsn#.SALARYPARAM_GET WHERE EXPENSE_HEALTH_ID =  E.EXPENSE_ID) AS S_GET
                            ,ISNULL(AMOUNT_KDV_1,0) AMOUNT_KDV_1
                            ,ISNULL(AMOUNT_KDV_2,0) AMOUNT_KDV_2
                            ,ISNULL(AMOUNT_KDV_3,0) AMOUNT_KDV_3
                            ,ISNULL(AMOUNT_KDV_4,0) AMOUNT_KDV_4
                            ,ISNULL(E.AMOUNT_1,0) AMOUNT_1
                            ,ISNULL(E.AMOUNT_2,0) AMOUNT_2
                            ,ISNULL(E.AMOUNT_3,0) AMOUNT_3
                            ,ISNULL(E.AMOUNT_4,0) AMOUNT_4
                            ,ISNULL(NET_TOTAL_AMOUNT,0) NET_TOTAL_AMOUNT
							,NET_KDV_AMOUNT
                            ,ISNULL(PAYMENT_INTERRUPTION_VALUE,0) AS  PAYMENT_INTERRUPTION_VALUE
                        FROM EXPENSE_ITEM_PLAN_REQUESTS E
                        LEFT JOIN #dsn#.EMPLOYEES ON EMPLOYEES.EMPLOYEE_ID = E.EMP_ID
                        LEFT JOIN #dsn#.EMPLOYEES_RELATIVES  ER on ER.RELATIVE_ID = E.RELATIVE_ID
                        LEFT JOIN #dsn#.COMPANY C ON C.COMPANY_ID = E.COMPANY_ID
                        LEFT JOIN ACCOUNT_CARD AC ON AC.ACTION_ID = E.EXPENSE_ID AND AC.ACTION_TYPE = 2503
                        JOIN ACCOUNT_CARD_ROWS ACR ON ACR.CARD_ID = AC.CARD_ID AND ACCOUNT_ID LIKE '770%' 
						AND ACCOUNT_ID NOT IN ('770.03.10.0005') 
						<!--- AND (e.treated = 1 or (E.TREATED = 2 AND ACCOUNT_ID <> '770.01.04.0003')) --->
                    WHERE
                        1=1
                        <cfif len(arguments.search_date1)>
                            AND AC.ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.search_date1#">
                        </cfif>
                        <cfif len(arguments.search_date2)>
                            AND  AC.ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.search_date2#">
                        </cfif>
                        <cfif len(arguments.acc_code1_1)>
                            AND  ACR.ACCOUNT_ID >= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.acc_code1_1#">
                        </cfif>
                        <cfif len(arguments.acc_code2_1)>
                            AND  ACR.ACCOUNT_ID <= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.acc_code2_1#">
                        </cfif>
                        <cfif len(arguments.is_account) AND arguments.is_account eq 0>
                            AND AC.CARD_ID IS NULL
                        <cfELSEif len(arguments.is_account) AND arguments.is_account eq 1>
                            AND AC.CARD_ID IS NOT NULL
                        </cfif>
                    ),
                CTE2 AS (
                        SELECT
                            CTE1.*,
                                ROW_NUMBER() OVER (
                                                    ORDER BY  
                                                        EXPENSE_DATE DESC,EXPENSE DESC
                    ) AS RowNum,(SELECT COUNT(*) FROM CTE1) AS QUERY_COUNT
                        FROM
                            CTE1
                    )
                    SELECT
                        CTE2.*
                    FROM
                        CTE2
                    <cfif not (isdefined('arguments.is_excel') and arguments.is_excel eq 1)>
                    WHERE
                        RowNum BETWEEN #arguments.startrow# and #arguments.startrow#+(#arguments.maxrows#-1)     
                    </cfif>
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
    <cffunction name="GetAssurance" returntype="query">
        <cfquery name="get_assurance" datasource="#dsn#">
            SELECT
                HAT.ASSURANCE_ID,
                HAT.ASSURANCE,
                (SELECT TOP 1 RATE FROM SETUP_HEALTH_ASSURANCE_TYPE_SUPPORT WHERE ASSURANCE_ID = HAT.ASSURANCE_ID ORDER BY ISNULL(MIN,0)) AS RATE,
                (SELECT TOP 1 PRIVATE_COMP_RATE FROM SETUP_HEALTH_ASSURANCE_TYPE_SUPPORT WHERE ASSURANCE_ID = HAT.ASSURANCE_ID ORDER BY ISNULL(MIN,0)) AS PRIVATE_RATE
            FROM 
                SETUP_HEALTH_ASSURANCE_TYPE HAT 
            WHERE 
                HAT.IS_ACTIVE = 1 
            ORDER BY 
                HAT.ASSURANCE
        </cfquery>
        <cfreturn get_assurance>
    </cffunction>
</cfcomponent>