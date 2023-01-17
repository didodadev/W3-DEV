<cfcomponent displayname="Budget Expense Category" output="true" hint="Butce Kategorilerini Yonetir">
    <cfset dsn = application.systemParam.systemParam().dsn>
    <cfset dsn2 = '#dsn#_#session.ep.period_year#_#session.ep.company_id#'>
    <cffunction name = "GetBudgetCats" returnType = "query" hint = "">
		<cfargument name="expense_category_id" default="">
        <cfargument name="not_upper_cats" default="">
        <cfquery name="BUDGET_CATS" datasource="#dsn2#">
            SELECT
                EXPENSE_CAT_ID,
                #dsn#.Get_Dynamic_Language(EXPENSE_CAT_ID,'#session.ep.language#','EXPENSE_CATEGORY','EXPENSE_CAT_NAME',NULL,NULL,EXPENSE_CAT_NAME) AS EXPENSE_CAT_NAME,
                EXPENSE_CAT_DETAIL,
                EXPENSE_CAT_CODE,
                IS_SUB_EXPENSE_CAT
            FROM 
                EXPENSE_CATEGORY
                <cfif isdefined("arguments.not_upper_cats") and arguments.not_upper_cats eq 1>
                WHERE 
                    EXPENSE_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.expense_category_id#">
            </cfif>
            ORDER BY
                EXPENSE_CAT_CODE
                
        </cfquery>
        <cfreturn BUDGET_CATS>
    </cffunction>
    <cffunction name="getBudgetItems" access="remote" returntype="string" returnFormat="plain">
        <cfargument name="dsn" required="yes">
        <cfargument name="expense_id" required="yes">
        <cfset is_accounting_budget = "">
        <cfset expense_item_id_list = "0">
        <cfset account_code_list = "0">
        <cfquery name="EXPENSE_ROW" datasource="#dsn2#">
            SELECT 
                EXPENSE_CENTER_ROW.EXPENSE_ITEM_ID,
                EXPENSE_CENTER_ROW.ACCOUNT_ID,
                EXPENSE_CENTER_ROW.ACCOUNT_CODE,
                EXPENSE_ITEMS.EXPENSE_ITEM_NAME,
                EXPENSE_CENTER.IS_ACCOUNTING_BUDGET
            FROM 
                EXPENSE_CENTER,
                EXPENSE_CENTER_ROW
                LEFT JOIN EXPENSE_ITEMS ON EXPENSE_CENTER_ROW.EXPENSE_ITEM_ID = EXPENSE_ITEMS.EXPENSE_ITEM_ID
            WHERE 
                EXPENSE_CENTER.EXPENSE_ID = EXPENSE_CENTER_ROW.EXPENSE_ID AND 
                EXPENSE_CENTER_ROW.EXPENSE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listfirst(arguments.expense_id,';')#">
            GROUP BY
                EXPENSE_CENTER_ROW.EXPENSE_ITEM_ID,
                EXPENSE_CENTER_ROW.ACCOUNT_ID,
                EXPENSE_CENTER_ROW.ACCOUNT_CODE,
                EXPENSE_ITEMS.EXPENSE_ITEM_NAME,
                EXPENSE_CENTER.IS_ACCOUNTING_BUDGET					
        </cfquery>
        <cfif EXPENSE_ROW.recordcount and len(EXPENSE_ROW.IS_ACCOUNTING_BUDGET)>
            <cfset is_accounting_budget = EXPENSE_ROW.IS_ACCOUNTING_BUDGET>
            <cfset expense_item_id_list = valuelist(EXPENSE_ROW.EXPENSE_ITEM_ID,',')>
            <cfset account_code_list = valuelist(EXPENSE_ROW.ACCOUNT_CODE,',')>
        </cfif>
        <cfquery name="getBudgetItems" datasource="#arguments.dsn#">
            SELECT
                CONVERT(varchar, EXPENSE_ITEM_ID) + ';' +  CONVERT(varchar, EXPENSE_ITEM_NAME) as NAME,            
                EI.EXPENSE_ITEM_NAME,
                EI.EXPENSE_ITEM_ID,
                EI.ACCOUNT_CODE
            FROM
                EXPENSE_ITEMS EI
                LEFT JOIN EXPENSE_CATEGORY EC ON EC.EXPENSE_CAT_ID = EI.EXPENSE_CATEGORY_ID
            WHERE
                IS_ACTIVE=1
                <cfif len(is_accounting_budget)>
                    <cfif is_accounting_budget eq 0>
                        <cfif len(expense_item_id_list)>
                            AND EXPENSE_ITEM_ID IN (#expense_item_id_list#)
                        </cfif>
                    <cfelseif is_accounting_budget eq 1>
                        <cfif len(account_code_list)>
                            AND (
                                <cfloop list="#account_code_list#" delimiters="," index="_account_code_">					
                                    (
                                        EI.ACCOUNT_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#_account_code_#"> OR EI.ACCOUNT_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#_account_code_#.%">
                                    )
                                    <cfif _account_code_ neq listlast(account_code_list,',') and listlen(account_code_list,',') gte 1> OR </cfif>
                                </cfloop>
                                )
                        </cfif>
                    </cfif>
                <cfelse>
                    AND 1 = 2
                </cfif>
        </cfquery>
        <cfreturn Replace(serializeJSON(getBudgetItems),'//','')>
    </cffunction>
    <cffunction name = "GetBudgetItems_" returnType = "query" hint = "">
        <cfargument name="dsn" required="yes">
        <cfargument name="expense_id" required="yes">
        <cfset is_accounting_budget = "">
        <cfset expense_item_id_list = "0">
        <cfset account_code_list = "0">
        <cfquery name="EXPENSE_ROW" datasource="#dsn2#">
            SELECT 
                EXPENSE_CENTER_ROW.EXPENSE_ITEM_ID,
                EXPENSE_CENTER_ROW.ACCOUNT_ID,
                EXPENSE_CENTER_ROW.ACCOUNT_CODE,
                EXPENSE_ITEMS.EXPENSE_ITEM_NAME,
                EXPENSE_CENTER.IS_ACCOUNTING_BUDGET
            FROM 
                EXPENSE_CENTER,
                EXPENSE_CENTER_ROW
                LEFT JOIN EXPENSE_ITEMS ON EXPENSE_CENTER_ROW.EXPENSE_ITEM_ID = EXPENSE_ITEMS.EXPENSE_ITEM_ID
            WHERE 
                EXPENSE_CENTER.EXPENSE_ID = EXPENSE_CENTER_ROW.EXPENSE_ID AND 
                EXPENSE_CENTER_ROW.EXPENSE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listfirst(arguments.expense_id,';')#">
            GROUP BY
                EXPENSE_CENTER_ROW.EXPENSE_ITEM_ID,
                EXPENSE_CENTER_ROW.ACCOUNT_ID,
                EXPENSE_CENTER_ROW.ACCOUNT_CODE,
                EXPENSE_ITEMS.EXPENSE_ITEM_NAME,
                EXPENSE_CENTER.IS_ACCOUNTING_BUDGET					
        </cfquery>
        <cfif EXPENSE_ROW.recordcount and len(EXPENSE_ROW.IS_ACCOUNTING_BUDGET)>
            <cfset is_accounting_budget = EXPENSE_ROW.IS_ACCOUNTING_BUDGET>
            <cfset expense_item_id_list = valuelist(EXPENSE_ROW.EXPENSE_ITEM_ID,',')>
            <cfset account_code_list = valuelist(EXPENSE_ROW.ACCOUNT_CODE,',')>
        </cfif>
        <cfquery name="getBudgetItems" datasource="#arguments.dsn#">
            SELECT
                EI.EXPENSE_ITEM_ID,            
                EI.EXPENSE_ITEM_NAME,
                EI.ACCOUNT_CODE
            FROM
                EXPENSE_ITEMS EI
                LEFT JOIN EXPENSE_CATEGORY EC ON EC.EXPENSE_CAT_ID = EI.EXPENSE_CATEGORY_ID
            WHERE
                IS_ACTIVE=1
                <cfif len(is_accounting_budget)>
                    <cfif is_accounting_budget eq 0>
                        <cfif len(expense_item_id_list)>
                            AND EXPENSE_ITEM_ID IN (#expense_item_id_list#)
                        </cfif>
                    <cfelseif is_accounting_budget eq 1>
                        <cfif len(account_code_list)>
                            AND (
                                <cfloop list="#account_code_list#" delimiters="," index="_account_code_">					
                                    (
                                        EI.ACCOUNT_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#_account_code_#"> OR EI.ACCOUNT_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#_account_code_#.%">
                                    )
                                    <cfif _account_code_ neq listlast(account_code_list,',') and listlen(account_code_list,',') gte 1> OR </cfif>
                                </cfloop>
                                )
                        </cfif>
                    </cfif>
                <cfelse>
                    AND 1 = 2
                </cfif>
        </cfquery>
        <cfreturn getBudgetItems>
    </cffunction>
    <cffunction name = "GetIemsBudgetCats" returnType = "query" hint = "">
		<cfargument name="cat_id" default="">
        <cfquery name="GetIemsBudgetCats" datasource="#dsn2#">
            SELECT 
                EXPENSE_CAT_ID
            FROM
                EXPENSE_CATEGORY
            WHERE
                EXPENSE_CAT_ID IN (SELECT EXPENSE_CATEGORY_ID FROM EXPENSE_ITEMS WHERE EXPENSE_CATEGORY_ID = #arguments.cat_id#)
            ORDER BY
                EXPENSE_CAT_ID
        </cfquery>
        <cfreturn GetIemsBudgetCats>
    </cffunction>
</cfcomponent>