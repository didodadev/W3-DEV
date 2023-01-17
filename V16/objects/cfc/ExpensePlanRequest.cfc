<!--- 
    Author : Melek KOCABEY
    Create Date : 22/10/2021
    Desc :  Harcama Talepleri cfc sayfasıdır
--->
<cfcomponent extends="cfc.queryJSONConverter">
    <cfset dsn = application.systemParam.systemParam().dsn>
    <cfset dsn2="#dsn#_#session.ep.period_year#_#session.ep.company_id#">
    <cffunction name="GET_EXPENSE_ITEM" access="remote" returnformat="JSON">
            <cfargument name="expense_center_id" default="">
            <cfargument name="is_accounting_budget" default="">
            <cfargument name="expense_item_id_list" default="0">
            <cfargument name="account_code_list" default="0">
	
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
                    EXPENSE_CENTER_ROW.EXPENSE_ID = #arguments.expense_center_id#
                GROUP BY
                    EXPENSE_CENTER_ROW.EXPENSE_ITEM_ID,
                    EXPENSE_CENTER_ROW.ACCOUNT_ID,
                    EXPENSE_CENTER_ROW.ACCOUNT_CODE,
                    EXPENSE_ITEMS.EXPENSE_ITEM_NAME,
                    EXPENSE_CENTER.IS_ACCOUNTING_BUDGET					
            </cfquery>
            <cfif EXPENSE_ROW.recordcount and len(EXPENSE_ROW.IS_ACCOUNTING_BUDGET)>
                <cfset arguments.is_accounting_budget = EXPENSE_ROW.IS_ACCOUNTING_BUDGET>
                <cfset arguments.expense_item_id_list = valuelist(EXPENSE_ROW.EXPENSE_ITEM_ID,',')>
                <cfset arguments.account_code_list = valuelist(EXPENSE_ROW.ACCOUNT_CODE,',')>
            </cfif>
            <cfquery name="GET_EXPENSE_ITEM" datasource="#dsn2#">
                SELECT
                    EI.EXPENSE_ITEM_NAME,
                    EI.EXPENSE_ITEM_ID
                FROM
                    EXPENSE_ITEMS EI
                    LEFT JOIN EXPENSE_CATEGORY EC ON EC.EXPENSE_CAT_ID = EI.EXPENSE_CATEGORY_ID
                WHERE
                    IS_ACTIVE=1
                    <cfif len(arguments.is_accounting_budget)>
                        <cfif arguments.is_accounting_budget eq 0>
                            <cfif len(arguments.expense_item_id_list)>
                                AND EXPENSE_ITEM_ID IN (#expense_item_id_list#)
                            </cfif>
                        <cfelseif arguments.is_accounting_budget eq 1>
                            <cfif len(arguments.account_code_list)>
                                AND (
                                    <cfloop list="#arguments.account_code_list#" delimiters="," index="_account_code_">					
                                        (
                                            EI.ACCOUNT_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#_account_code_#"> OR EI.ACCOUNT_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#_account_code_#.%">
                                        )
                                        <cfif _account_code_ neq listlast(arguments.account_code_list,',') and listlen(arguments.account_code_list,',') gte 1> OR </cfif>
                                    </cfloop>
                                    )
                            </cfif>
                        </cfif>
                    <cfelse>
                        AND 1 = 2
                    </cfif>	
                ORDER BY
                    EXPENSE_ITEM_NAME
            </cfquery>
        <cfif GET_EXPENSE_ITEM.recordcount><cfreturn Replace(SerializeJson(this.returnData( Replace( SerializeJson( GET_EXPENSE_ITEM ), "//", "" ))), "//", "") /><cfelse>[]</cfif>
    </cffunction>
</cfcomponent>