<cfcomponent>
    <cfset dsn = application.systemParam.systemParam().dsn>
    <cfset dsn2="#dsn#_#session.ep.period_year#_#session.ep.company_id#">
    <cffunction name="Select" access="public">
        <cfquery name="get_tax" datasource="#dsn2#">
            SELECT 
                TAX.TAX_ID, 
                TAX.TAX, 
                TAX.DETAIL, 
                TAX.SALE_CODE, 
                TAX.PURCHASE_CODE, 
                TAX.SALE_CODE_IADE, 
                TAX.PURCHASE_CODE_IADE, 
                TAX.INVENTORY_SALE_CODE, 
                TAX.INVENTORY_PURCHASE_CODE, 
                TAX.PURCHASE_PRICE_DIFF_CODE, 
                TAX.SALE_PRICE_DIFF_CODE,
                TAX.DIRECT_EXPENSE_CODE,
                TAX.RECORD_DATE,
                TAX.RECORD_EMP, 
                TAX.RECORD_IP, 
                TAX.UPDATE_DATE, 
                TAX.UPDATE_EMP, 
                TAX.UPDATE_IP,
                EXP_ITEM.EXPENSE_ITEM_ID,
                EXP_ITEM.EXPENSE_ITEM_NAME
            FROM 
                SETUP_TAX AS TAX
                LEFT JOIN EXPENSE_ITEMS AS EXP_ITEM ON TAX.EXPENSE_ITEM_ID = EXP_ITEM.EXPENSE_ITEM_ID
            ORDER BY 
                TAX
        </cfquery>
        <cfreturn get_tax>
    </cffunction>
    <cffunction name="SelectID" access="public">
        <cfargument name="tid" default="">
        <cfquery name="CATEGORY" datasource="#DSN2#">
            SELECT 
                TAX.TAX_ID, 
                TAX.TAX, 
                TAX.DETAIL, 
                TAX.SALE_CODE, 
                TAX.PURCHASE_CODE, 
                TAX.SALE_CODE_IADE, 
                TAX.PURCHASE_CODE_IADE, 
                TAX.INVENTORY_SALE_CODE, 
                TAX.INVENTORY_PURCHASE_CODE, 
                TAX.PURCHASE_PRICE_DIFF_CODE, 
                TAX.SALE_PRICE_DIFF_CODE, 
                TAX.TAX_CODE,
                TAX.RECORD_DATE,
                TAX.RECORD_EMP, 
                TAX.RECORD_IP, 
                TAX.UPDATE_DATE, 
                TAX.UPDATE_EMP, 
                TAX.UPDATE_IP,
                TAX.EXP_SALES_CODE,
                TAX.EXP_PURCHASE_CODE,
                TAX.INWARD_PROCESS_CODE,
                TAX.DIRECT_EXPENSE_CODE,
                EXP_ITEM.EXPENSE_ITEM_ID,
                EXP_ITEM.EXPENSE_ITEM_NAME
            FROM 
                SETUP_TAX AS TAX
                LEFT JOIN EXPENSE_ITEMS AS EXP_ITEM ON TAX.EXPENSE_ITEM_ID = EXP_ITEM.EXPENSE_ITEM_ID
            WHERE 
                TAX_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.tid#">
        </cfquery>
        <cfreturn CATEGORY>
    </cffunction> 
    <cffunction name="INSERT" access="public" returnType="any">
        <cfargument name="ACCOUNT_CODE" type="string" default="">
        <cfargument name="ACCOUNT_CODE_S" type="string" default="">
        <cfargument name="ACCOUNT_CODE_IADE" type="string" default="">
        <cfargument name="ACCOUNT_CODE_S_IADE" type="string" default="">
        <cfargument name="tax" type="numeric" default="">
        <cfargument name="tax_code" type="string" default="">
        <cfargument name="TAX_CODE_NAME" type="string" default="">
        <cfargument name="DETAIL" type="string" default="">
        <cfargument name="INVENTORY_ACCOUNT_CODE_S" type="string" default="">
        <cfargument name="INVENTORY_ACCOUNT_CODE" type="string" default="">
        <cfargument name="REC_PRICE_DIF_ACCOUNT_CODE" type="string" default="">
        <cfargument name="PRO_PRICE_DIF_ACCOUNT_CODE" type="string" default="">
        <cfargument name="exp_reg_sales_dif_Account_Code" type="string" default="">
        <cfargument name="exp_reg_purchase_dif_Account_Code" type="string" default="">
        <cfargument name="inward_process_dif_Account_Code" type="string" default="">
        <cfargument name="direct_expense_Account_Code" type="string" default="">
        <cfargument name="EXPENSE_ITEM_ID" type="string" default="">
       <cfquery name="INSTAX" datasource="#DSN2#" result="result">
            INSERT INTO 
                SETUP_TAX 
            (
                PURCHASE_CODE,
                SALE_CODE,
                PURCHASE_CODE_IADE,
                SALE_CODE_IADE,
                TAX,
                TAX_CODE,
                TAX_CODE_NAME,
                DETAIL,
                INVENTORY_SALE_CODE,
                INVENTORY_PURCHASE_CODE,
                PURCHASE_PRICE_DIFF_CODE,
                SALE_PRICE_DIFF_CODE,
                RECORD_IP,
                RECORD_DATE,
                RECORD_EMP,
                EXP_SALES_CODE,
                EXP_PURCHASE_CODE,
                INWARD_PROCESS_CODE,
                DIRECT_EXPENSE_CODE,
                EXPENSE_ITEM_ID
            ) 
            VALUES 
            (
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.ACCOUNT_CODE#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.ACCOUNT_CODE_S#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.ACCOUNT_CODE_IADE#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.ACCOUNT_CODE_S_IADE#">,
                <cfqueryparam cfsqltype="cf_sql_float" value="#arguments.TAX#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tax_code#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tax_code_name#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.DETAIL#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.INVENTORY_ACCOUNT_CODE_S#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.INVENTORY_ACCOUNT_CODE#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.REC_PRICE_DIF_ACCOUNT_CODE#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.PRO_PRICE_DIF_ACCOUNT_CODE#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
                #now()#,
                #session.ep.userid#,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.exp_reg_sales_dif_Account_Code#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.exp_reg_purchase_dif_Account_Code#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.inward_process_dif_Account_Code#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.direct_expense_Account_Code#">,
                <cfif len( arguments.EXPENSE_ITEM_ID )><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.EXPENSE_ITEM_ID#"><cfelse>NULL</cfif>
            )
        </cfquery>
        <cfset response = result>
		<cfreturn response>
    </cffunction>
    <cffunction name="Update" access="public">
        <cfargument name="tid" default="">
        <cfargument name="ACCOUNT_CODE_S" type="string" default="">
        <cfargument name="ACCOUNT_CODE" type="string" default="">
        <cfargument name="ACCOUNT_CODE_S_IADE" type="string" default="">
        <cfargument name="ACCOUNT_CODE_IADE" type="string" default="">
        <cfargument name="tax" default="">
        <cfargument name="tax_code" type="string" default="">
        <cfargument name="tax_code_name" type="string" default="">
        <cfargument name="DETAIL" type="string" default="">
        <cfargument name="INVENTORY_ACCOUNT_CODE_S" type="string" default="">
        <cfargument name="INVENTORY_ACCOUNT_CODE" type="string" default="">
        <cfargument name="REC_PRICE_DIF_ACCOUNT_CODE" type="string" default="">
        <cfargument name="PRO_PRICE_DIF_ACCOUNT_CODE" type="string" default="">
        <cfargument name="exp_reg_sales_dif_Account_Code" type="string" default="">
        <cfargument name="exp_reg_purchase_dif_Account_Code" type="string" default="">
        <cfargument name="inward_process_dif_Account_Code" type="string" default="">
        <cfargument name="direct_expense_Account_Code" type="string" default="">
        <cfargument name="EXPENSE_ITEM_ID" type="string" default="">
        <cfquery name="UPDTAX" datasource="#dsn2#" debug="yes">
            UPDATE 
                SETUP_TAX
            SET 
                SALE_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.ACCOUNT_CODE_S#">,
                PURCHASE_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.ACCOUNT_CODE#">,
                SALE_CODE_IADE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.ACCOUNT_CODE_S_IADE#">,
                PURCHASE_CODE_IADE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.ACCOUNT_CODE_IADE#">,
                TAX = <cfqueryparam cfsqltype="cf_sql_float" value="#arguments.tax#">,
                TAX_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tax_code#">,
                TAX_CODE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tax_code_name#">,
                DETAIL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.DETAIL#">,
                INVENTORY_SALE_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.INVENTORY_ACCOUNT_CODE_S#">,
                INVENTORY_PURCHASE_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.INVENTORY_ACCOUNT_CODE#">,
                PURCHASE_PRICE_DIFF_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.REC_PRICE_DIF_ACCOUNT_CODE#">,
                SALE_PRICE_DIFF_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.PRO_PRICE_DIF_ACCOUNT_CODE#">,
                UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
                UPDATE_DATE = #now()#,
                UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                EXP_SALES_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.exp_reg_sales_dif_Account_Code#">,
                EXP_PURCHASE_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.exp_reg_purchase_dif_Account_Code#">,
                INWARD_PROCESS_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.inward_process_dif_Account_Code#">,
                DIRECT_EXPENSE_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.direct_expense_Account_Code#">,
                EXPENSE_ITEM_ID = <cfif len( arguments.EXPENSE_ITEM_ID )><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.EXPENSE_ITEM_ID#"><cfelse>NULL</cfif>
            WHERE
                TAX_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.tid#">
        </cfquery>
    </cffunction>
    <cffunction name="Delete" access="public" returntype="any">
       <cfargument name="tid" default="">
        <cfquery name="DELTAX" datasource="#dsn2#">
            DELETE 
            FROM 
                SETUP_TAX 
            WHERE 
                TAX_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.tid#">
        </cfquery>
    </cffunction>
</cfcomponent>