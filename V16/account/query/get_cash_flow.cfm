<cfquery name="GET_CASH_FLOW" datasource="#DSN2#">
	SELECT 
		CASH_FLOW_ID,
		CODE,
		NAME,
		ACCOUNT_CODE,
		SIGN,
		BA,
		VIEW_AMOUNT_TYPE,
		IFRS_CODE,
		NAME_LANG_NO
	FROM 
		CASH_FLOW_TABLE 
	ORDER BY 
		CODE
</cfquery>
<cfquery name="GET_CASH_FLOW_DEF" datasource="#dsn2#">
	SELECT
		DEF_SELECTED_ROWS,
		INVERSE_REMAINDER,
		IS_DEPT_CLAIM_DETAIL
	FROM
		ACCOUNT_DEFINITIONS
	WHERE
		DEF_TYPE_ID = 10
</cfquery>
<cfscript>
	if(get_cash_flow_def.recordcount neq 0)
		selected_list = get_cash_flow_def.def_selected_rows;
	else
		selected_list = ValueList(get_cash_flow.cash_flow_id);
	inv_rem = get_cash_flow_def.inverse_remainder;

	if(len(get_cash_flow_def.is_dept_claim_detail)) //borc-alacak durumu detaylı gosterim, suanda sadece nakit akım tablosunda kullanılıyor
		dsp_dept_claim_ = get_cash_flow_def.is_dept_claim_detail;
	else
		dsp_dept_claim_ = 0;
</cfscript>

