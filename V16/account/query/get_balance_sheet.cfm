<cfquery name="GET_BALANCE_SHEET" datasource="#dsn2#">
	<cfif isdefined("attributes.no_process_accounts") and len(attributes.no_process_accounts)>
        IF OBJECT_ID('tempdb..##temp_balance_sheet') IS NOT NULL
            DROP TABLE ##temp_balance_sheet
                
        SELECT ACCOUNT_ID INTO ##temp_balance_sheet FROM 
        <cfif attributes.table_code_type eq 0>
                ACCOUNT_CARD_ROWS
            <cfelseif attributes.table_code_type eq 1>
                ACCOUNT_ROWS_IFRS
            </cfif>
            
        SELECT DISTINCT
            BST2.*
        FROM
            BALANCE_SHEET_TABLE BST2
        INNER JOIN (
            SELECT DISTINCT
                BST.CODE CODE
            FROM
                BALANCE_SHEET_TABLE BST
            INNER JOIN ##temp_balance_sheet TBS ON TBS.ACCOUNT_ID LIKE BST.ACCOUNT_CODE + '.%' OR TBS.ACCOUNT_ID = BST.ACCOUNT_CODE <!--- kendisi veya alt hesabı account_card_rows'ta olması gerekiyor --->
            ) TTT ON TTT.CODE LIKE BST2.CODE + '.%' OR TTT.CODE = BST2.CODE <!--- kendisi veya üst hesabı (account_id değil code olarak) geliyor --->
        ORDER BY
        	CODE 
            
       IF OBJECT_ID('tempdb..##temp_balance_sheet') IS NOT NULL
            DROP TABLE ##temp_balance_sheet   
    <cfelse>
        SELECT
            *
        FROM
            BALANCE_SHEET_TABLE
        ORDER BY 
			CODE        
    </cfif>   
</cfquery>
<cfquery name="GET_BALANCE_DEF" datasource="#dsn2#">
	SELECT
		DEF_SELECTED_ROWS,
		INVERSE_REMAINDER
	FROM
		ACCOUNT_DEFINITIONS
	WHERE
		DEF_TYPE_ID = 8
</cfquery>
<cfif get_balance_def.recordcount and len(get_balance_def.def_selected_rows)>
	<cfset selected_list=get_balance_def.def_selected_rows>
<cfelse>
	<cfset selected_list=ValueList(get_balance_sheet.balance_id)>
</cfif>
<cfset bal_def_sel_rows = selected_list>
<cfset inv_rem = get_balance_def.inverse_remainder>
<cfset view_amount_type = get_balance_sheet.view_amount_type>
