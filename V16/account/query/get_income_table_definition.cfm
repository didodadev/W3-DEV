<cfquery name="GET_INCOME_DEF" datasource="#dsn2#">
	SELECT
		DEF_SELECTED_ROWS,
		INVERSE_REMAINDER
	FROM
		ACCOUNT_DEFINITIONS
	WHERE
		DEF_TYPE_ID=7
		AND DEF_SELECTED_ROWS IS NOT NULL
		AND DEF_SELECTED_ROWS <> ''
</cfquery>
<cfif GET_INCOME_DEF.RECORDCOUNT>
	<cfset selected_list=get_income_def.DEF_SELECTED_ROWS>
	<cfset inv_rem=get_income_def.INVERSE_REMAINDER>
	<cfquery name="GET_INCOME_TABLE" datasource="#dsn2#">
		SELECT
			INCOME_ID,CODE,NAME,NAME_LANG_NO,IFRS_CODE,ACCOUNT_CODE,
			<!---<cfif isdefined('attributes.table_code_type') and attributes.table_code_type eq 1>
				IFRS_CODE AS ACCOUNT_CODE,
			<cfelse>
				ACCOUNT_CODE,
			</cfif>--->
			SIGN,BA,VIEW_AMOUNT_TYPE
		FROM
			INCOME_TABLE
		ORDER BY 
			INCOME_TABLE.CODE 
	</cfquery>
	<cfset view_amount_type=get_income_table.VIEW_AMOUNT_TYPE>
<cfelse>
	<cfset selected_list = ''>
	<cfset inv_rem = ''>
	<cfquery name="GET_INCOME_TABLE" datasource="#dsn2#">
		SELECT
			INCOME_ID,CODE,NAME,NAME_LANG_NO,IFRS_CODE,ACCOUNT_CODE,
			<!---<cfif isdefined('attributes.table_code_type') and attributes.table_code_type eq 1>
				IFRS_CODE AS ACCOUNT_CODE,
			<cfelse>
				ACCOUNT_CODE,
			</cfif>--->
			SIGN,BA,VIEW_AMOUNT_TYPE
		FROM
			INCOME_TABLE
		ORDER BY 
			INCOME_TABLE.CODE 
	</cfquery>
</cfif>
