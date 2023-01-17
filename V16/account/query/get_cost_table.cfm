<cfquery name="GET_COST_DEF" datasource="#dsn2#">
	SELECT
		DEF_SELECTED_ROWS,
		INVERSE_REMAINDER
	FROM
		ACCOUNT_DEFINITIONS
	WHERE
		DEF_TYPE_ID=9
</cfquery>
<cfset selected_list=get_cost_def.DEF_SELECTED_ROWS>
<cfset inv_rem=get_cost_def.INVERSE_REMAINDER>
<cfquery name="GET_COST_TABLE" datasource="#dsn2#">
	SELECT 
    	COST_ID, 
        CODE, 
        NAME, 
        ACCOUNT_CODE, 
        SIGN, 
        BA, 
        VIEW_AMOUNT_TYPE, 
        ZERO, 
        ADD_, 
        IFRS_CODE, 
        NAME_LANG_NO 
    FROM 
    	COST_TABLE			
</cfquery>
<cfset view_amount_type=get_cost_table.VIEW_AMOUNT_TYPE>
