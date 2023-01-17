<cfcomponent extends="cfc.queryJSONConverter">

    <cfset dsn = application.systemParam.systemParam().dsn>
    <cfset dsn2 = '#dsn#_#session.ep.period_year#_#session.ep.company_id#'>
    <cfset dsn3 = '#dsn#_#session.ep.company_id#'>

    <cffunction name="add_budgetDemand" returntype="any">
        <cfquery name="add_budgetDemand" datasource="#dsn2#">
            INSERT INTO 
                BUDGET_TRANSFER_DEMAND
                (
                    DEMAND_NO,
                    BUDGET_ID,
                    DETAIL,
                    DEMAND_STAGE,
                    DEMAND_DATE,
                    DEMAND_EMP_ID,
                    RECORD_DATE,
                    RECORD_EMP,
                    RECORD_IP,
                    REFERENCE,
                    RESPONSIBLE_EMP
                )
                VALUES
                (
                    <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.demand_no#">,
                    <cfif len(arguments.budget_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.budget_id#"><cfelse><cfqueryparam null="yes" value="" cfsqltype="cf_sql_integer"></cfif>,
                    <cfif len(arguments.detail)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.detail#"><cfelse><cfqueryparam null="yes" value="" cfsqltype="cf_sql_integer"></cfif>,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.demand_stage#">,
                    <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.demand_date#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.employee_id#">,
                    #now()#,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                    <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#cgi.remote_addr#">,
                    <cfif len(arguments.reference_no)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.reference_no#"><cfelse><cfqueryparam null="yes" value="" cfsqltype="cf_sql_nvarchar"></cfif>,
                    <cfif len(arguments.responsible_emp_id)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.responsible_emp_id#"><cfelse><cfqueryparam null="yes" value="" cfsqltype="cf_sql_nvarchar"></cfif>
                )
                SELECT SCOPE_IDENTITY() AS MAX_ID
        </cfquery>
        <cfreturn add_budgetDemand.max_id>
    </cffunction>

    <cffunction name="add_demand_row" returntype="any">
    
        <cfquery name="add_demand_row" datasource="#dsn2#">
            INSERT INTO
                BUDGET_TRANSFER_DEMAND_ROWS
                (
                    DEMAND_ID,
                    DEMAND_EXP_CENTER,
                    DEMAND_EXP_ITEM,
                    DEMAND_PROJECT_ID,
                    AMOUNT,
                    USABLE_MONEY,
                    MONEY_CURRENCY,
                    TRANSFER_EXP_CENTER,
                    TRANSFER_EXP_ITEM,
                    TRANSFER_PROJECT_ID,
                    DEMAND_ACTIVITY_TYPE,
                    TRANSFER_ACTIVITY_TYPE,
                    USABLE_TRANSFER_MONEY,
                    RECORD_EMP,
                    RECORD_IP,
                    RECORD_DATE,
                    TRANSFER_STATUS,
                    INTERNAL_ID,
                    OFFER_ID,
                    ORDER_ID,
                    EXPENSE_ID,
                    BLOCK_TYPE
                )
                VALUES
                (
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.demand_id#">,
                    <cfif len(arguments.expense_center)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.expense_center#"><cfelse><cfqueryparam null="yes" value="" cfsqltype="cf_sql_integer"></cfif>,
                    <cfif len(arguments.expense_item)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.expense_item#"><cfelse><cfqueryparam null="yes" value="" cfsqltype="cf_sql_integer"></cfif>,
                    <cfif len(arguments.project_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.project_id#"><cfelse><cfqueryparam null="yes" value="" cfsqltype="cf_sql_integer"></cfif>,
                    <cfqueryparam cfsqltype="cf_sql_float" value="#arguments.rate#">,
                    <cfqueryparam cfsqltype="cf_sql_float" value="#arguments.serbest_budget#">,
                    <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.money_type#">,
                    <cfif len(arguments.transfer_expense_center)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.transfer_expense_center#"><cfelse><cfqueryparam null="yes" value="" cfsqltype="cf_sql_integer"></cfif>,
                    <cfif len(arguments.transfer_expense_item)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.transfer_expense_item#"><cfelse><cfqueryparam null="yes" value="" cfsqltype="cf_sql_integer"></cfif>,
                    <cfif len(arguments.transfer_project_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.transfer_project_id#"><cfelse><cfqueryparam null="yes" value="" cfsqltype="cf_sql_integer"></cfif>,
                    <cfif len(arguments.activity_type)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.activity_type#"><cfelse><cfqueryparam null="yes" value="" cfsqltype="cf_sql_integer"></cfif>,
                    <cfif len(arguments.transfer_activity_type)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.transfer_activity_type#"><cfelse><cfqueryparam null="yes" value="" cfsqltype="cf_sql_integer"></cfif>,
                    <cfqueryparam cfsqltype="cf_sql_float" value="#arguments.transfer_serbest_budget#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                    <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#cgi.remote_addr#">,
                    #now()#,
                    <cfif isdefined("arguments.transfer_status") and len(arguments.transfer_status)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.transfer_status#"><cfelse><cfqueryparam null="yes" value="" cfsqltype="cf_sql_integer"></cfif>,
                    <cfif isdefined("arguments.internaldemand_id") and len(arguments.internaldemand_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.internaldemand_id#"><cfelse><cfqueryparam null="yes" value="" cfsqltype="cf_sql_integer"></cfif>,
                    <cfif isdefined("arguments.offer_id") and len(arguments.offer_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.offer_id#"><cfelse><cfqueryparam null="yes" value="" cfsqltype="cf_sql_integer"></cfif>,
                    <cfif isdefined("arguments.order_id") and len(arguments.order_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.order_id#"><cfelse><cfqueryparam null="yes" value="" cfsqltype="cf_sql_integer"></cfif>,
                    <cfif isdefined("arguments.expense_") and len(arguments.expense_)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.expense_#"><cfelse><cfqueryparam null="yes" value="" cfsqltype="cf_sql_integer"></cfif>,
                    <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.block_type#">
                )
        </cfquery>
    </cffunction>

    <cffunction name="det_demand" returntype="any" returnFormat="json">
        <cfquery name="det_demand" datasource = "#dsn2#">
            SELECT
                BTD.DEMAND_ID,
                BTD.REFERENCE,
                BTD.DEMAND_NO,
                BTD.DEMAND_EMP_ID,
                BTD.RESPONSIBLE_EMP,
                BTD.DETAIL,
                BTD.BUDGET_ID,
                E.EMPLOYEE_NAME + ' ' + E.EMPLOYEE_SURNAME AS EMPLOYEE_FULLNAME,
                BTD.DEMAND_STAGE,
                CONVERT(nvarchar(10),BTD.DEMAND_DATE,103) AS DEMAND_DATE,
                BTDR.DEMAND_ROWS_ID,
                BTDR.DEMAND_EXP_CENTER,
                BTDR.DEMAND_EXP_ITEM,
                BTDR.DEMAND_PROJECT_ID,
                BTDR.AMOUNT,
                BTDR.USABLE_MONEY,
                BTDR.MONEY_CURRENCY,
                BTDR.TRANSFER_EXP_CENTER,
                BTDR.TRANSFER_EXP_ITEM,
                BTDR.TRANSFER_PROJECT_ID,
                BTDR.DEMAND_ACTIVITY_TYPE,
                BTDR.TRANSFER_ACTIVITY_TYPE,
                BTDR.USABLE_TRANSFER_MONEY,
                BTDR.BLOCK_TYPE,
                BTD.RECORD_EMP,
                BTD.RECORD_DATE,
                BTD.RECORD_IP,
                BTD.UPDATE_EMP,
                BTD.UPDATE_DATE,
                BTD.UPDATE_IP,
                EC.EXPENSE,
                EC1.EXPENSE AS TRA_EXPENSE,
                EI.EXPENSE_ITEM_NAME,
                EI1.EXPENSE_ITEM_NAME AS TRA_EXPENSE_ITEM_NAME,
                P.PROJECT_HEAD,
                P1.PROJECT_HEAD AS TRA_PROJECT_HEAD,
                P1.PROCESS_CAT AS TRA_PROCESS_CAT,
                P.PROCESS_CAT,
                B.BUDGET_NAME,
                EI.ACCOUNT_CODE AS ACCOUNT_CODE,
                EI1.ACCOUNT_CODE AS TRA_ACCOUNT_CODE,
                EC.EXPENSE_DEPARTMENT_ID AS DEPARTMENT_ID,
                EC1.EXPENSE_DEPARTMENT_ID AS TRA_DEPARTMENT_ID,
                BTDR.INTERNAL_ID,
                BTDR.TRANSFER_STATUS,
                BTDR.OFFER_ID,
                BTDR.ORDER_ID,
                BTDR.EXPENSE_ID,
                ISNULL(EC.RESPONSIBLE1,0) AS RESPONSIBLE1,
				ISNULL(EC.RESPONSIBLE2,0) AS RESPONSIBLE2,
				ISNULL(EC.RESPONSIBLE3,0) AS RESPONSIBLE3
            FROM
                BUDGET_TRANSFER_DEMAND BTD
                    LEFT JOIN #dsn#.EMPLOYEES E ON E.EMPLOYEE_ID = BTD.DEMAND_EMP_ID
                    LEFT JOIN BUDGET_TRANSFER_DEMAND_ROWS BTDR ON BTDR.DEMAND_ID = BTD.DEMAND_ID
                    LEFT JOIN EXPENSE_CENTER EC ON EC.EXPENSE_ID = BTDR.DEMAND_EXP_CENTER 
                    LEFT JOIN EXPENSE_CENTER EC1 ON EC1.EXPENSE_ID = BTDR.TRANSFER_EXP_CENTER 
                    LEFT JOIN EXPENSE_ITEMS EI ON EI.EXPENSE_ITEM_ID = BTDR.DEMAND_EXP_ITEM
                    LEFT JOIN EXPENSE_ITEMS EI1 ON EI1.EXPENSE_ITEM_ID = BTDR.TRANSFER_EXP_ITEM
                    LEFT JOIN #dsn#.PRO_PROJECTS P ON P.PROJECT_ID = BTDR.DEMAND_PROJECT_ID
                    LEFT JOIN #dsn#.PRO_PROJECTS P1 ON P1.PROJECT_ID = BTDR.TRANSFER_PROJECT_ID
                    LEFT JOIN #dsn#.BUDGET B ON B.BUDGET_ID = BTD.BUDGET_ID
            WHERE
                BTD.DEMAND_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.DEMAND_ID#">
            ORDER BY
                BTD.DEMAND_ID,
                BTDR.DEMAND_ROWS_ID
        </cfquery>
        	<cfset getJSON = returnData(serializeJSON(det_demand))>
        <cfreturn Replace(serializeJSON(getJSON),'//','') />
    </cffunction>

    <cffunction name="get_BudgetDemandList" returntype="any">
        <cfquery name="get_BudgetDemandList" datasource="#dsn2#">
            SELECT 
            BTD.*,
                E.EMPLOYEE_NAME + ' ' + E.EMPLOYEE_SURNAME AS DEMAND_EMPLOYEE_FULLNAME,
                PTR.STAGE
            FROM
                BUDGET_TRANSFER_DEMAND BTD
                /* LEFT JOIN BUDGET_TRANSFER_DEMAND_ROWS BTDR ON BTDR.DEMAND_ID = BTD.DEMAND_ID */
                LEFT JOIN #dsn#.EMPLOYEES E ON E.EMPLOYEE_ID = BTD.DEMAND_EMP_ID
                LEFT JOIN #dsn#.PROCESS_TYPE_ROWS PTR ON PTR.PROCESS_ROW_ID = BTD.DEMAND_STAGE
            WHERE
                1 = 1
                <cfif len(arguments.keyword)>
                    AND BTD.DEMAND_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%">
                </cfif>
                <cfif isdefined("arguments.employee_id") and len(arguments.employee_id)>
                    AND BTD.DEMAND_EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.employee_id#">
                </cfif>
                <cfif isdefined("arguments.responsible_emp_id") and len(arguments.responsible_emp_id) and isdefined("arguments.responsible_emp") and len(arguments.responsible_emp)>
                    AND BTD.RESPONSIBLE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.responsible_emp_id#">
                </cfif>
        </cfquery>
        <cfreturn get_BudgetDemandList>
    </cffunction>

    <cffunction name="GetBudgetStatus" returntype="any">
        <cfquery name="GetBudgetStatus" datasource="#dsn2#">
            SELECT 
                *
            FROM
                BUDGET_TRANSFER_DEMAND_ROWS
            WHERE
                1 = 1
                <cfif len(arguments.expense_id)>
                    AND TRANSFER_EXP_CENTER = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.expense_id#">
                </cfif>
                <cfif isdefined("arguments.expense_item_id") and len(arguments.expense_item_id)>
                    AND TRANSFER_EXP_ITEM = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.expense_item_id#">
                </cfif>
                <cfif len(arguments.expense_)>
                    AND EXPENSE_ID = <cfqueryparam cfsqltype="cf_sql_float" value="#arguments.expense_#">
                </cfif>
                <cfif len(arguments.internaldemand_id)>
                    AND INTERNAL_ID = <cfqueryparam cfsqltype="cf_sql_float" value="#arguments.internaldemand_id#">
                </cfif>
                <cfif  len(arguments.order_id)>
                    AND ORDER_ID = <cfqueryparam cfsqltype="cf_sql_float" value="#arguments.order_id#">
                </cfif>
                <cfif len(arguments.offer_id)>
                    AND OFFER_ID = <cfqueryparam cfsqltype="cf_sql_float" value="#arguments.offer_id#">
                </cfif>
        </cfquery>
        <cfreturn GetBudgetStatus>
    </cffunction>
    <cffunction name = "get_money" returnType = "any" hint = "Para Birimlerini Getir">
       <cfquery name="GET_MONEY" datasource="#dsn#">
            SELECT
                MONEY,
                RATE2,
                RATE1,
                0 AS IS_SELECTED
            FROM
                SETUP_MONEY
            WHERE
                PERIOD_ID = <cfqueryparam value = "#SESSION.EP.PERIOD_ID#" CFSQLType = "cf_sql_integer">  AND
                MONEY_STATUS = <cfqueryparam value = "1" CFSQLType = "cf_sql_integer">
            ORDER BY 
                MONEY_ID
        </cfquery> 
        <cfreturn get_money>
    </cffunction>

    <cffunction name="GET_ACTIVITY" returntype="any">
        <cfquery name="GET_ACTIVITY" datasource="#DSN#">
            SELECT
                #dsn#.Get_Dynamic_Language(ACTIVITY_ID,'#session.ep.language#','SETUP_ACTIVITY','ACTIVITY_NAME',NULL,NULL,ACTIVITY_NAME) AS activity_name,
                ACTIVITY_ID,
                ACTIVITY_NAME
            FROM 
                SETUP_ACTIVITY
            WHERE
                ACTIVITY_STATUS = 1 
            ORDER BY 
                ACTIVITY_NAME
        </cfquery>
        <cfreturn GET_ACTIVITY>
    </cffunction>

    <cffunction name="upd_budgetDemand" returntype="any">
        <cfquery name="upd_budgetDemand" datasource="#dsn2#">
            UPDATE
                BUDGET_TRANSFER_DEMAND
            SET
                BUDGET_ID = <cfif len(arguments.budget_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.budget_id#"><cfelse><cfqueryparam null="yes" value="" cfsqltype="cf_sql_integer"></cfif>,
                DEMAND_NO = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.demand_no#">,
                DETAIL = <cfif len(arguments.detail)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.detail#"><cfelse><cfqueryparam null="yes" value="" cfsqltype="cf_sql_integer"></cfif>,
                DEMAND_STAGE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.demand_stage#">,
                DEMAND_DATE = <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.demand_date#">,
                DEMAND_EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.employee_id#">,
                UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#cgi.remote_addr#">,
                UPDATE_DATE = #now()#,
                REFERENCE = <cfif len(arguments.reference_no)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.reference_no#"><cfelse><cfqueryparam null="yes" value="" cfsqltype="cf_sql_nvarchar"></cfif>,
                RESPONSIBLE_EMP = <cfif len(arguments.responsible_emp_id)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.responsible_emp_id#"><cfelse><cfqueryparam null="yes" value="" cfsqltype="cf_sql_nvarchar"></cfif>
            WHERE
                DEMAND_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.demand_id#">
        </cfquery>
        <cfreturn 1>
    </cffunction>

    <cffunction name="get_demand_" returntype="any">
        <cfquery name = "get_demand_" datasource = "#dsn2#">
            SELECT DEMAND_ID FROM BUDGET_TRANSFER_DEMAND WHERE DEMAND_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.demand_id#">
        </cfquery>
        <cfreturn get_demand_>
    </cffunction>

    <cffunction name="get_demand_kontrol" returntype="any">
        <cfquery name = "get_demand_kontrol" datasource = "#dsn#">
            SELECT DEMAND_ID,IS_TRANSFER,BUDGET_PLAN_ID FROM BUDGET_PLAN WHERE DEMAND_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.demand_id#">
        </cfquery>
        <cfreturn get_demand_kontrol>
    </cffunction>

    <cffunction name="del_demand_row" returntype="any">
        <cfquery name = "del_demand_row" datasource = "#dsn2#">
            DELETE FROM BUDGET_TRANSFER_DEMAND_ROWS WHERE DEMAND_ID IN (#arguments.demand_id#)
        </cfquery>
        <cfreturn 1>
    </cffunction>

    <cffunction name="del_demand" returntype="any">
        <cfquery name = "del_demand" datasource = "#dsn2#">
            DELETE FROM BUDGET_TRANSFER_DEMAND WHERE DEMAND_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.demand_id#">
        </cfquery>
        <cfreturn 1>
    </cffunction>

    <cffunction name="GET_EXPENSE_BUDGET" access="public" returntype="query" hint="Planlanan - Gerçekleşen - Revize Edilen Bütçe Durumları">
        <cfquery name="GET_EXPENSE_BUDGET" datasource="#dsn2#">
            WITH CTE1 AS
            (
                SELECT      
                    GEC.EXPENSE_ID,
                    GEC.EXPENSE,
                    <cfif len(arguments.expense_cat)>GEC.EXPENSE_CAT_ID,</cfif>
                    <cfif len(arguments.project_id)>GEC.PROJECT_ID,</cfif>
                    ISNULL(ROW_TOTAL_INCOME,0) ROW_TOTAL_INCOME,
                    ISNULL(ROW_TOTAL_INCOME_2,0) ROW_TOTAL_INCOME_2,
                    ISNULL(ROW_TOTAL_EXPENSE,0) ROW_TOTAL_EXPENSE,
                    ISNULL(ROW_TOTAL_EXPENSE_2,0) ROW_TOTAL_EXPENSE_2,
                    ISNULL(TOTAL_AMOUNT_BORC,0) AS TOTAL_AMOUNT_BORC,
                    ISNULL(TOTAL_AMOUNT_2_BORC,0) AS TOTAL_AMOUNT_BORC_2,
                    ISNULL(REZ_TOTAL_AMOUNT_BORC,0) AS REZ_TOTAL_AMOUNT_BORC,
                    ISNULL(REZ_TOTAL_AMOUNT_2_BORC,0) AS REZ_TOTAL_AMOUNT_2_BORC,
                    ISNULL(REZ_TOTAL_AMOUNT_ALACAK,0) AS REZ_TOTAL_AMOUNT_ALACAK,
                    ISNULL(REZ_TOTAL_AMOUNT_2_ALACAK,0) AS REZ_TOTAL_AMOUNT_2_ALACAK,
                    ISNULL(TOTAL_AMOUNT_ALACAK,0)  AS TOTAL_AMOUNT_ALACAK,
                    ISNULL(TOTAL_AMOUNT_2_ALACAK,0) AS TOTAL_AMOUNT_ALACAK_2
                FROM
                    (
                        SELECT  
                            EXPENSE.EXPENSE_ID
                            ,EXPENSE.EXPENSE
                            ,EXPENSE.EXPENSE_CODE
                            <cfif len(arguments.expense_cat)>,EXPENSE_CAT.EXPENSE_CAT_ID</cfif>
                            <cfif len(arguments.project_id)>,PROJECTS.PROJECT_ID</cfif>
                        FROM 
                        (
                            SELECT 
                                EXPENSE_ID
                                ,EXPENSE
                                ,EXPENSE_CODE
                            FROM 
                                EXPENSE_CENTER
                            WHERE 
                                EXPENSE_ID IS NOT NULL
                                AND EXPENSE_ACTIVE = 1
                                <cfif IsDefined("arguments.expense_id") and len(arguments.expense_id)>
                                    AND  EXPENSE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.expense_id#">
                                </cfif>
                        ) AS EXPENSE
                        <cfif len(arguments.expense_cat)>
                        ,(
                                SELECT 
                                    EXPENSE_CAT_ID
                                    ,EXPENSE_CAT_NAME
                                FROM 
                                    EXPENSE_CATEGORY 
                                WHERE 
                                    EXPENSE_CAT_ID IS NOT NULL 
                                    <cfif len(arguments.expense_cat)>
                                        AND EXPENSE_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.expense_cat#">
                                    </cfif>
                        ) AS EXPENSE_CAT
                        </cfif>
                        <cfif len(arguments.project_id)>
                        ,(
                                SELECT 
                                    PROJECT_ID
                                FROM 
                                    #dsn#.PRO_PROJECTS 
                                WHERE 1=1
                                    <cfif len(arguments.project_id)>
                                        AND PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.project_id#">
                                    </cfif>
                         ) AS PROJECTS
                         </cfif>
                    ) AS GEC 
                 LEFT JOIN
                (
                    SELECT 
                        ISNULL(SUM(BUDGET_PLAN_ROW.ROW_TOTAL_EXPENSE),0) ROW_TOTAL_EXPENSE,
                        ISNULL(SUM(BUDGET_PLAN_ROW.ROW_TOTAL_EXPENSE_2),0) ROW_TOTAL_EXPENSE_2,
                        ISNULL(SUM(BUDGET_PLAN_ROW.ROW_TOTAL_INCOME),0) ROW_TOTAL_INCOME,
                        ISNULL(SUM(BUDGET_PLAN_ROW.ROW_TOTAL_INCOME_2),0) ROW_TOTAL_INCOME_2,
                        BUDGET_PLAN_ROW.EXP_INC_CENTER_ID
                        <cfif len(arguments.project_id)>
                            ,BUDGET_PLAN_ROW.PROJECT_ID
                        </cfif> 
                        <cfif len(arguments.expense_cat)> 
                            ,EXPENSE_CATEGORY.EXPENSE_CAT_ID
                        </cfif>
                    FROM
                        #dsn#.BUDGET_PLAN,
                        #dsn#.BUDGET_PLAN_ROW,
                        #dsn#.BUDGET 
                        <cfif len(arguments.expense_cat)> 
                        ,EXPENSE_CATEGORY EXPENSE_CATEGORY 
                        </cfif>
                    WHERE 
                        BUDGET_PLAN.PROCESS_TYPE <> 161 AND 
                        BUDGET_PLAN.BUDGET_PLAN_ID = BUDGET_PLAN_ROW.BUDGET_PLAN_ID AND
                        BUDGET_PLAN.BUDGET_ID = BUDGET.BUDGET_ID AND
                        BUDGET_PLAN_ROW.EXP_INC_CENTER_ID IS NOT NULL
                        AND BUDGET.PERIOD_YEAR = #session.ep.period_year#
                        <cfif len(arguments.project_id)>  
                            AND BUDGET_PLAN_ROW.PROJECT_ID IS NOT NULL 
                        </cfif>
                        <cfif len(arguments.expense_cat)> 
                            AND EXPENSE_CATEGORY.EXPENSE_CAT_ID IS NOT NULL
                        </cfif>
                        <cfif len(arguments.expense_cat)>  
                            AND BUDGET_PLAN_ROW.BUDGET_ITEM_ID IN(SELECT EXPENSE_ITEM_ID FROM EXPENSE_ITEMS WHERE EXPENSE_CATEGORY_ID = EXPENSE_CATEGORY.EXPENSE_CAT_ID)
                        </cfif>
                    GROUP BY
                        BUDGET_PLAN_ROW.EXP_INC_CENTER_ID
                        <cfif len(arguments.project_id)> 
                            ,BUDGET_PLAN_ROW.PROJECT_ID
                        </cfif> 
                        <cfif len(arguments.expense_cat)> 
                            ,EXPENSE_CATEGORY.EXPENSE_CAT_ID
                        </cfif>
                        
                ) AS PLANLANAN
            ON PLANLANAN.EXP_INC_CENTER_ID = GEC.EXPENSE_ID <cfif len(arguments.project_id)> AND PLANLANAN.PROJECT_ID =  GEC.PROJECT_ID </cfif> <cfif len(arguments.expense_cat)>  AND PLANLANAN.EXPENSE_CAT_ID = GEC.EXPENSE_CAT_ID </cfif>
              LEFT JOIN
                (
                    SELECT
                        SUM(CASE WHEN IS_INCOME = 0 THEN TOTAL_AMOUNT ELSE 0 END) AS TOTAL_AMOUNT_BORC,
                        SUM(CASE WHEN IS_INCOME = 0 THEN TOTAL_AMOUNT_2 ELSE 0 END) AS TOTAL_AMOUNT_2_BORC,
                        SUM(CASE WHEN IS_INCOME = 1 THEN TOTAL_AMOUNT ELSE 0 END) AS  TOTAL_AMOUNT_ALACAK,
                        SUM( CASE WHEN IS_INCOME = 1 THEN TOTAL_AMOUNT_2 ELSE 0 END) TOTAL_AMOUNT_2_ALACAK,
                        EXPENSE_CENTER_ID
                        <cfif len(arguments.project_id)> 
                        ,PROJECT_ID
                        </cfif>
                       <cfif len(arguments.expense_cat)> 
                        ,EXPENSE_CAT_ID
                        </cfif>                        
                    FROM
                    (
                        SELECT 
                            (EXPENSE_ITEMS_ROWS.TOTAL_AMOUNT - EXPENSE_ITEMS_ROWS.AMOUNT_KDV) TOTAL_AMOUNT,
                            EXPENSE_ITEMS_ROWS.OTHER_MONEY_VALUE_2 TOTAL_AMOUNT_2,
                            EXPENSE_ITEMS_ROWS.IS_INCOME,
                            EXPENSE_ITEMS_ROWS.ACTIVITY_TYPE,
                            EXPENSE_ITEMS_ROWS.EXPENSE_CENTER_ID
                            <cfif len(arguments.project_id)> 
                            ,PROJECT_ID
                            </cfif>
                            <cfif len(arguments.expense_cat)> 
                            ,EXPENSE_CATEGORY.EXPENSE_CAT_ID
                            </cfif>
                        FROM
                            EXPENSE_ITEMS_ROWS
                            <cfif len(arguments.expense_cat)> 
                            ,EXPENSE_CATEGORY EXPENSE_CATEGORY
                            </cfif>
                        WHERE
                            TOTAL_AMOUNT > 0 
                            AND EXPENSE_CENTER_ID IS NOT NULL 
                            <cfif len(arguments.project_id)> AND PROJECT_ID IS NOT NULL </cfif> 
                            <cfif len(arguments.expense_cat)>  AND EXPENSE_CAT_ID IS NOT NULL</cfif> 
                            <cfif len(arguments.expense_cat)> 
                            AND EXPENSE_ITEMS_ROWS.EXPENSE_ITEM_ID IN(SELECT EXPENSE_ITEM_ID FROM EXPENSE_ITEMS WHERE EXPENSE_CATEGORY_ID = EXPENSE_CATEGORY.EXPENSE_CAT_ID)
                            </cfif>
                    )T1
                    GROUP BY
                        EXPENSE_CENTER_ID
                    <cfif len(arguments.project_id)>
                        ,PROJECT_ID
                   </cfif>
                   <cfif len(arguments.expense_cat)>
                        ,EXPENSE_CAT_ID
                    </cfif>
                        
                        
                ) AS GERCEKLESEN  
            ON GERCEKLESEN.EXPENSE_CENTER_ID = GEC.EXPENSE_ID <cfif len(arguments.project_id)> AND GERCEKLESEN.PROJECT_ID =  GEC.PROJECT_ID </cfif> <cfif len(arguments.expense_cat)>  AND GEC.EXPENSE_CAT_ID = GERCEKLESEN.EXPENSE_CAT_ID </cfif>
            LEFT JOIN
                (
                    SELECT
                        SUM(CASE WHEN IS_INCOME = 0 THEN TOTAL_AMOUNT ELSE 0 END) AS REZ_TOTAL_AMOUNT_BORC,
                        SUM(CASE WHEN IS_INCOME = 0 THEN TOTAL_AMOUNT_2 ELSE 0 END) AS REZ_TOTAL_AMOUNT_2_BORC,
                        SUM(CASE WHEN IS_INCOME = 1 THEN TOTAL_AMOUNT ELSE 0 END) AS REZ_TOTAL_AMOUNT_ALACAK,
                        SUM(CASE WHEN IS_INCOME = 1 THEN TOTAL_AMOUNT_2 ELSE 0 END) REZ_TOTAL_AMOUNT_2_ALACAK,
                        EXPENSE_CENTER_ID
                        <cfif len(arguments.project_id)>
                            ,PROJECT_ID
                        </cfif>
                        <cfif len(arguments.expense_cat)>
                            ,EXPENSE_CAT_ID
                        </cfif>
                        
                        
                    FROM
                    (
                        SELECT 
                           (ERR.TOTAL_AMOUNT- ERR.AMOUNT_KDV) TOTAL_AMOUNT ,
                            ERR.OTHER_MONEY_VALUE_2 TOTAL_AMOUNT_2,
                            ERR.IS_INCOME,
                            ERR.ACTIVITY_TYPE,
                            ERR.EXPENSE_CENTER_ID
                            <cfif len(arguments.project_id)>
                                ,ERR.PROJECT_ID
                            </cfif>
                            <cfif len(arguments.expense_cat)>
                                ,EXPENSE_CATEGORY.EXPENSE_CAT_ID
                            </cfif> 
                        FROM
                            EXPENSE_RESERVED_ROWS AS ERR
                            <cfif len(arguments.expense_cat)>
                            ,EXPENSE_CATEGORY EXPENSE_CATEGORY
                            </cfif>
                        WHERE
                            TOTAL_AMOUNT > 0 
                            AND EXPENSE_CENTER_ID IS NOT NULL 
                            <cfif len(arguments.project_id)> AND PROJECT_ID IS NOT NULL </cfif> 
                            <cfif len(arguments.expense_cat)> AND EXPENSE_CAT_ID IS NOT NULL</cfif> 
                            <cfif len(arguments.expense_cat)>
                            AND ERR.EXPENSE_ITEM_ID IN(SELECT EXPENSE_ITEM_ID FROM EXPENSE_ITEMS WHERE EXPENSE_CATEGORY_ID = EXPENSE_CATEGORY.EXPENSE_CAT_ID)
                            </cfif>
                    )T1
                    GROUP BY
                        EXPENSE_CENTER_ID
                    <cfif len(arguments.project_id)>
                        ,PROJECT_ID
                   </cfif>
                   <cfif len(arguments.expense_cat)>
                        ,EXPENSE_CAT_ID
                    </cfif>
                        
                        
                ) AS RESERVED  
            ON  RESERVED.EXPENSE_CENTER_ID = GEC.EXPENSE_ID <cfif len(arguments.project_id)> AND RESERVED.PROJECT_ID =  GEC.PROJECT_ID  </cfif> <cfif len(arguments.expense_cat)>  AND GEC.EXPENSE_CAT_ID = RESERVED.EXPENSE_CAT_ID </cfif> 
            ),
            
                CTE2 AS (
                        SELECT
                            *
                        FROM
                            CTE1
                    )
                    SELECT
                        ( SELECT SUM(ROW_TOTAL_INCOME) FROM CTE2 ) ALL_ROW_TOTAL_INCOME,
                        ( SELECT SUM(ROW_TOTAL_EXPENSE) FROM CTE2 ) ALL_ROW_TOTAL_EXPENSE,
                        ( SELECT SUM(ROW_TOTAL_INCOME_2) FROM CTE2 ) ALL_ROW_TOTAL_INCOME_2,
                        ( SELECT SUM(ROW_TOTAL_EXPENSE_2) FROM CTE2 ) ALL_ROW_TOTAL_EXPENSE_2,
                        ( SELECT SUM(TOTAL_AMOUNT_BORC) FROM CTE2 ) ALL_TOTAL_AMOUNT_BORC,
                        ( SELECT SUM(TOTAL_AMOUNT_ALACAK) FROM CTE2 ) ALL_TOTAL_AMOUNT_ALACAK,
                        ( SELECT SUM(TOTAL_AMOUNT_BORC_2) FROM CTE2 ) ALL_TOTAL_AMOUNT_BORC_2,
                        ( SELECT SUM(TOTAL_AMOUNT_ALACAK_2) FROM CTE2 ) ALL_TOTAL_AMOUNT_ALACAK_2,
                        ( SELECT SUM(REZ_TOTAL_AMOUNT_ALACAK) FROM CTE2 ) ALL_REZ_TOTAL_AMOUNT_ALACAK,
                        ( SELECT SUM(REZ_TOTAL_AMOUNT_2_ALACAK) FROM CTE2 ) ALL_REZ_TOTAL_AMOUNT_2_ALACAK,
                        ( SELECT SUM(REZ_TOTAL_AMOUNT_BORC) FROM CTE2 ) ALL_REZ_TOTAL_AMOUNT_BORC,
                        ( SELECT SUM(REZ_TOTAL_AMOUNT_2_BORC) FROM CTE2 ) ALL_REZ_TOTAL_AMOUNT_2_BORC,
                        CTE2.*
                    FROM
                        CTE2                		
        </cfquery>
        <cfreturn GET_EXPENSE_BUDGET>
    </cffunction>

    <cffunction name="get_exp_detail" access="remote" returntype="any">
        <cfquery name="get_exp_detail" datasource="#dsn2#">
            SELECT
                EI.EXPENSE_ITEM_NAME,
                EI.ACCOUNT_CODE,
                EI.EXPENSE_ITEM_ID,
                EC.EXPENSE_CAT_NAME,
                EC.EXPENSE_CAT_ID
            FROM
                EXPENSE_ITEMS EI
                LEFT JOIN EXPENSE_CATEGORY EC ON EC.EXPENSE_CAT_ID = EI.EXPENSE_CATEGORY_ID
            WHERE
                EXPENSE_ITEM_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.expense_item_id#">
            ORDER BY
                EXPENSE_ITEM_ID
        </cfquery>
        <cfreturn get_exp_detail>
    </cffunction>

    <cffunction name="UPD_DEMAND_STAGE" access="remote" returntype="any">
        <cfquery name="UPD_DEMAND_STAGE" datasource="#dsn2#">
            UPDATE
                BUDGET_TRANSFER_DEMAND
            SET
                DEMAND_STAGE  = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.stage_id#">
            WHERE
                DEMAND_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.action_id#">
        </cfquery>
    </cffunction>

    <cffunction name="get_expenseCenter_Emp" access="remote" returntype="any" hint="Talep Edilen Masraf Merkezine Bağlı Yetkili Kişileri Getir">
        <cfquery name="get_expenseCenter_Emp" datasource="#dsn2#">
            SELECT
                RESPONSIBLE1,
                RESPONSIBLE2,
                RESPONSIBLE3
            FROM
                EXPENSE_CENTER
            WHERE
                EXPENSE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.expense_id#">
        </cfquery>
        <cfreturn get_expenseCenter_Emp>
    </cffunction>
    <!--- <cfset get_expenseCenter_Emp = demand.get_expenseCenter_Emp(
                                        expense_id : demand_val[1]["DEMAND_EXP_CENTER"]
                                     )><!--- talep edilen masraf merkezlerine bağl ıyetkililer  ---> --->
</cfcomponent>