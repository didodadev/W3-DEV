<cfcomponent>

    <cfset dsn = application.systemParam.systemParam().dsn>
    <cfset dsn2 = '#dsn#_#session.ep.period_year#_#session.ep.company_id#'>
    <cfset dsn3 = '#dsn#_#session.ep.company_id#'>

    <cffunction name="GET_MONEY" returntype="any">
        <cfquery name="GET_MONEY" datasource="#dsn#">
            SELECT * FROM SETUP_MONEY WHERE PERIOD_ID = #SESSION.EP.PERIOD_ID# AND MONEY_STATUS = 1
        </cfquery>
        <cfreturn GET_MONEY>
    </cffunction>

    <!--- add tarafı sorguları --->
    
    <cffunction name="ADD_INTEREST_YIELD_PLAN" returntype="any">
        <cfquery name="ADD_INTEREST_YIELD_PLAN" datasource="#DSN2#">
            INSERT INTO INTEREST_YIELD_PLAN
            (
                BANK_ACTION_ID,
                ACTION_TYPE,
                DUE_VALUE,
                DUE_VALUE_DATE,
                YIELD_RATE,
                YIELD_AMOUNT,
                YIELD_PAYMENT_PERIOD,
                YGS,
                SPECIAL_DAY,
                NUMBER_YIELD_COLLECTION,
                YIELD_COLLECTION_AMOUNT,
                RECORD_DATE,
                RECORD_EMP,
                RECORD_IP
            )
            VALUES
            (
                <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.bank_action_id#">,
                NULL,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.due_value#">,
                <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.due_value_date#">,
                <cfqueryparam cfsqltype="cf_sql_float" value="#arguments.getiri_orani#">,
                <cfqueryparam cfsqltype="cf_sql_float" value="#arguments.getiri_tutari#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.yield_payment_period#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.ygs#">,
                <cfif isdefined("arguments.special_day") and len(arguments.special_day)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.special_day#"><cfelse>NULL</cfif>,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.getiri_tahsil_sayisi#">,
                <cfqueryparam cfsqltype="cf_sql_float" value="#arguments.getiri_tahsil_tutari#">,
                #NOW()#,
                #session.ep.USERID#,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">
            )
        </cfquery>
        <cfreturn 1>
    </cffunction>
    
    <!--- add tarafı sorguları --->

    <!--- update tarafı sorguları --->

    <cffunction name="UPD_INTEREST_REVENUE" returntype="any">
        <cfquery name="UPD_INTEREST_REVENUE" datasource="#dsn2#">
            UPDATE 
                BANK_ACTIONS
            SET
                PROCESS_CAT = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.process_cat#">,
                ACTION_VALUE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.action_value#">,
                ACTION_DATE = <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.action_date#">,
                ACTION_CURRENCY_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.action_currency_id#">,
                ACTION_FROM_ACCOUNT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.action_from_account_id#">,
                ACTION_DETAIL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.action_detail#">,
                OTHER_CASH_ACT_VALUE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.other_cash_act_value#">,
                OTHER_MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.other_money#">,
                IS_ACCOUNT = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.is_account#">,
                IS_ACCOUNT_TYPE = 13,
                PAPER_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.paper_no#">,
                PROCESS_STAGE = <cfif len(arguments.process_stage)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.process_stage#"><cfelse>NULL</cfif>,
                MASRAF = <cfqueryparam cfsqltype="cf_sql_float" value="#arguments.masraf#">,
                EXPENSE_ITEM_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.expense_item_id#">,
                EXPENSE_CENTER_ID = <cfif len(arguments.expense_center_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.expense_center_id#"><cfelse>NULL</cfif>,
                UPDATE_EMP = #session.ep.userid#,
                UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">,
                UPDATE_DATE = #NOW()#,
                FROM_BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.from_branch_id#">,
                SYSTEM_ACTION_VALUE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.system_action_value#">,
                SYSTEM_CURRENCY_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money#">
                <cfif len(session.ep.money2)>
                    ,ACTION_VALUE_2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.action_value_2#">
                    ,ACTION_CURRENCY_ID_2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money2#">
                </cfif>
                <cfif len(arguments.project_id)>
                    ,PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.project_id#">
                </cfif>
            WHERE
                ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.action_id#">
        </cfquery>
        <cfreturn 1>
    </cffunction>

    <cffunction name="UPD_INTEREST_REVENUE2" returntype="any">
        <cfquery name="UPD_INTEREST_REVENUE2" datasource="#dsn2#">
            UPDATE 
                BANK_ACTIONS
            SET
                PROCESS_CAT = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.process_cat#">,
                ACTION_VALUE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.action_value#">,
                ACTION_DATE = <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.action_date#">,
                ACTION_CURRENCY_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.action_currency_id#">,
                ACTION_TO_ACCOUNT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.action_to_account_id#">,
                ACTION_DETAIL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.action_detail#">,
                OTHER_CASH_ACT_VALUE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.other_cash_act_value#">,
                OTHER_MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.other_money#">,
                IS_ACCOUNT = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.is_account#">,
                IS_ACCOUNT_TYPE = 13,
                PAPER_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.paper_no#">,
                MASRAF = <cfqueryparam cfsqltype="cf_sql_float" value="#arguments.masraf#">,
                EXPENSE_ITEM_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.expense_item_id#">,
                EXPENSE_CENTER_ID = <cfif len(arguments.expense_center_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.expense_center_id#"><cfelse>NULL</cfif>,
                UPDATE_EMP = #session.ep.userid#,
                UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">,
                UPDATE_DATE = #NOW()#,
                TO_BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.to_branch_id#">,
                SYSTEM_ACTION_VALUE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.system_action_value#">,
                SYSTEM_CURRENCY_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money#">
                <cfif len(session.ep.money2)>
                    ,ACTION_VALUE_2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.action_value_2#">
                    ,ACTION_CURRENCY_ID_2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money2#">
                </cfif>
                <cfif len(arguments.project_id)>
                    ,PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.project_id#">
                </cfif>
            WHERE
                ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.action_id#">
        </cfquery>
        <cfreturn 1>
    </cffunction>

    <cffunction name="UPD_INTEREST_YIELD" returntype="any">
        <cfquery name="UPD_INTEREST_YIELD" datasource="#DSN2#">
            UPDATE INTEREST_YIELD_PLAN
             SET
                 ACTION_TYPE = NULL,
                 DUE_VALUE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.due_value#">,
                 DUE_VALUE_DATE = <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.due_value_date#">,
                 YIELD_RATE = <cfqueryparam cfsqltype="cf_sql_float" value="#arguments.getiri_orani#">,
                 YIELD_AMOUNT = <cfqueryparam cfsqltype="cf_sql_float" value="#arguments.getiri_tutari#">,
                 YIELD_PAYMENT_PERIOD = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.yield_payment_period#">,
                 YGS = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.ygs#">,
                 SPECIAL_DAY = <cfif isdefined("arguments.special_day") and len(arguments.special_day)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.special_day#"><cfelse>NULL</cfif>,
                 NUMBER_YIELD_COLLECTION = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.getiri_tahsil_sayisi#">,
                 YIELD_COLLECTION_AMOUNT = <cfqueryparam cfsqltype="cf_sql_float" value="#arguments.getiri_tahsil_tutari#">,
                 FINANCIAL_SCENARIO_ID = <cfif isdefined("arguments.finansal_senaryo") and len(arguments.finansal_senaryo)> <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.finansal_senaryo#"><cfelse>NULL</cfif>,
                 UPDATE_DATE = #NOW()#,
                 UPDATE_EMP = #session.ep.USERID#,
                 UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">
             WHERE
                 BANK_ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.id#">
         </cfquery>
         <cfreturn 1>
    </cffunction>

    <cffunction name="GET_INTEREST_YIELD" returntype="any">
        <cfquery name="GET_INTEREST_YIELD" datasource="#DSN2#">
            SELECT BA.ACTION_DATE, IYP.YIELD_ID, IYP.BUDGET_PLAN_ID FROM BANK_ACTIONS AS BA 
            LEFT JOIN INTEREST_YIELD_PLAN AS IYP ON IYP.BANK_ACTION_ID = BA.ACTION_ID 
            WHERE ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.id#">
        </cfquery>
        <cfreturn GET_INTEREST_YIELD>
    </cffunction>

    <cffunction name="DELETE_INTEREST_YIELD_ROWS" returntype="any">
        <cfquery name="DELETE_INTEREST_YIELD_ROWS" datasource="#dsn2#"> 
            DELETE FROM INTEREST_YIELD_PLAN_ROWS 
            WHERE YIELD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.id#">
        </cfquery>
        <cfreturn 1>
    </cffunction>

    <cffunction name="ADD_INTEREST_YIELD_ROWS" returntype="any">
        <cfquery name="ADD_INTEREST_YIELD_ROWS" datasource=#dsn2#>
            INSERT INTO INTEREST_YIELD_PLAN_ROWS
            (
                YIELD_ID, <!--- Belge No --->
                OPERATION_NAME, <!--- Getiri Periyot İsmi --->
                IS_PAYMENT, <!--- Hesaba Geçiş Kontrolü --->
                BANK_ACTION_DATE, <!--- Hesaba Geçiş Tarihi --->
                AMOUNT, <!--- Miktar --->
                STORE_REPORT_DATE, <!--- Hesaba geçirildiği tarih --->
                EXPENSE_ITEM_TAHAKKUK_ID <!--- Bütçe Kalemi --->
            )
            VALUES
            (
                #arguments.YIELD_ID#,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.getiri#">,
                0,
                <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.bank_action_date#">,
                <cfqueryparam cfsqltype="cf_sql_float" value="#arguments.getiri_tahsil_tutari#">,
                NULL,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.expense_item_tahakkuk_id#">
            )
        </cfquery>
        <cfreturn 1>
    </cffunction>

    <!--- update tarafı sorguları --->
    <cf_date tarih='arguments.date1'>
    <cf_date tarih='arguments.date2'>
    <cffunction name="GET_YIELD_PLAN_ROWS" returntype="any"> <!--- Vadeli Mevduat Liste --->
        <cfquery name="GET_YIELD_PLAN_ROWS" datasource="#dsn2#">
            SELECT IYPR.*, IYP.*, BA.ACTION_ID, BA.ACTION_VALUE, BA.MASRAF, BA.ACTION_TYPE_ID, BA.PAPER_NO, BA.ACTION_DATE,
                (SELECT TOP 1 YIELD_VALUATION_DATE FROM INTEREST_YIELD_VALUATION WHERE YIELD_ROWS_ID = IYPR.YIELD_ROWS_ID ORDER BY YIELD_VALUATION_ID DESC ) AS REESKONT_DATE
                FROM INTEREST_YIELD_PLAN_ROWS AS IYPR 
                LEFT JOIN INTEREST_YIELD_PLAN AS IYP ON IYPR.YIELD_ID = IYP.YIELD_ID
                INNER JOIN BANK_ACTIONS AS BA ON IYP.BANK_ACTION_ID = BA.ACTION_ID
            WHERE 
                1=1
                <cfif len(arguments.date1) and not len(arguments.date2)>
                    AND IYPR.BANK_ACTION_DATE >= #arguments.date1#
                <cfelseif not len(arguments.date1) and len(arguments.date2)>
                    AND IYPR.BANK_ACTION_DATE <= #arguments.date2#
                <cfelseif len(arguments.date1) and len(arguments.date2)>
                    AND IYPR.BANK_ACTION_DATE >= #arguments.date1# AND IYPR.BANK_ACTION_DATE <= #arguments.date2#
                </cfif>
                <cfif len(arguments.record_date) and not len(arguments.record_date2)>
                    AND BA.ACTION_DATE >= #arguments.record_date#
                <cfelseif not len(arguments.record_date) and len(arguments.record_date2)>
                    AND BA.ACTION_DATE <= #arguments.record_date2#
                <cfelseif len(arguments.record_date) and len(arguments.record_date2)>
                    AND BA.ACTION_DATE >= #arguments.record_date# AND BA.ACTION_DATE <= #arguments.record_date2#
                </cfif>
                <cfif len(arguments.tahsil_status)>
                    AND  IYPR.IS_PAYMENT = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.tahsil_status#">
                </cfif>
                <cfif len(arguments.keyword) gt 3>
                    AND BA.PAPER_NO LIKE <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.keyword#">
                </cfif>
                <cfif len(arguments.record_emp_id)>
                    AND BA.RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.record_emp_id#">
                </cfif>
            ORDER BY IYPR.BANK_ACTION_DATE ASC
        </cfquery>
        <cfreturn GET_YIELD_PLAN_ROWS>
    </cffunction>

    <cffunction name="get_process_type" returntype="any">
        <cfquery name="get_process_type" datasource="#dsn3#">
            SELECT 
                PROCESS_TYPE,
                IS_CARI,
                IS_ACCOUNT,
                IS_BUDGET,
                NEXT_PERIODS_ACCRUAL_ACTION,
                ACCRUAL_BUDGET_ACTION,
                ACTION_FILE_NAME,
                ACTION_FILE_FROM_TEMPLATE
             FROM 
                 SETUP_PROCESS_CAT 
            WHERE 
                PROCESS_CAT_ID = #arguments.process_cat#
        </cfquery>
        <cfreturn get_process_type>
    </cffunction>

    <cffunction name="get_acc_code_exp" returntype="any">
        <cfquery name="get_acc_code_exp" datasource="#dsn2#">
            SELECT 
                ACCOUNT_CODE
             FROM 
                EXPENSE_ITEMS 
            WHERE 
                EXPENSE_ITEM_ID = #arguments.expense_item_id#
        </cfquery>
        <cfreturn get_acc_code_exp>
    </cffunction>

    <cffunction name="GET_PROCESS_CAT" returntype="any">
        <cfquery name="GET_PROCESS_CAT" datasource="#DSN3#">
            SELECT PROCESS_TYPE,PROCESS_CAT_ID,PROCESS_CAT FROM SETUP_PROCESS_CAT WHERE PROCESS_TYPE IN (#arguments.cat_list#) ORDER BY PROCESS_TYPE
        </cfquery>
        <cfreturn GET_PROCESS_CAT>
    </cffunction>

    <cffunction name="GET_ACTION_DETAIL" returntype="any"> <!--- VADELİ MEVDUAT DETAY BİLGİLERİ --->
        <cfquery name="GET_ACTION_DETAIL" datasource="#dsn2#">
            SELECT
                BANK_ACTIONS.*,
                PP.PROJECT_HEAD,
                IYP.*,
                IYPR.EXPENSE_ITEM_TAHAKKUK_ID
            FROM
                BANK_ACTIONS
                LEFT JOIN #dsn#.PRO_PROJECTS PP ON PP.PROJECT_ID = BANK_ACTIONS.PROJECT_ID
                LEFT JOIN INTEREST_YIELD_PLAN IYP ON BANK_ACTIONS.ACTION_ID = IYP.BANK_ACTION_ID
                LEFT JOIN INTEREST_YIELD_PLAN_ROWS IYPR ON IYP.YIELD_ID = IYPR.YIELD_ID
            WHERE
                (ACTION_ID = #arguments.id# OR ACTION_ID = #arguments.ID+1#) AND
                ACTION_TYPE_ID IN (2311,2312)
                <cfif (session.ep.isBranchAuthorization)>
                    AND 
                        (
                            FROM_BRANCH_ID = #ListGetAt(session.ep.user_location,2,"-")# OR
                            TO_BRANCH_ID = #ListGetAt(session.ep.user_location,2,"-")#
                        )
                </cfif>
            ORDER BY
                ACTION_ID ASC
        </cfquery>
        <cfreturn GET_ACTION_DETAIL>
    </cffunction>   

    <cffunction name="GET_SCENARIO" returntype="any"> <!--- SENARYO TİPLERİ --->
        <cfquery name="GET_SCENARIO" datasource="#DSN#">
            SELECT 
                SCENARIO_ID, 
                SCENARIO 
            FROM 
                SETUP_SCENARIO
        </cfquery>
        <cfreturn GET_SCENARIO>
    </cffunction>

    <cffunction name="GET_ACCOUNTS" returntype="any"> <!--- Banka Hesapları // Listeleme Sayfası --->
        <cfquery name="GET_ACCOUNTS" datasource="#dsn3#">
            SELECT
                ACCOUNT_ID,
            <cfif session.ep.period_year lt 2009>
                CASE WHEN(ACCOUNT_CURRENCY_ID = 'TL') THEN 'YTL' ELSE ACCOUNT_CURRENCY_ID END AS ACCOUNT_CURRENCY_ID,
            <cfelse>
                ACCOUNT_CURRENCY_ID,
            </cfif>
                ACCOUNT_NAME
            FROM
                ACCOUNTS
            WHERE
                ACCOUNT_STATUS = 1
            <cfif session.ep.isBranchAuthorization>
                AND ACCOUNT_ID IN(SELECT AB.ACCOUNT_ID FROM ACCOUNTS_BRANCH AB WHERE AB.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ListGetAt(session.ep.user_location,2,"-")#">)
            </cfif>
            ORDER BY
                ACCOUNT_NAME
        </cfquery>
        <cfreturn GET_ACCOUNTS>
    </cffunction>
</cfcomponent>