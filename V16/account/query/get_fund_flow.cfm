<cfquery name="GET_FUND_FLOW" datasource="#DSN2#">
	SELECT
		*
	FROM
		FUND_FLOW_TABLE		
	ORDER BY 
		CODE
</cfquery>
<cfquery name="GET_FUND_FLOW_DEF" datasource="#DSN2#">
	SELECT
		DEF_SELECTED_ROWS,
		INVERSE_REMAINDER
	FROM
		ACCOUNT_DEFINITIONS
	WHERE
		DEF_TYPE_ID = 11
</cfquery>

<cfif get_fund_flow_def.recordcount>
	<cfset selected_list = get_fund_flow_def.def_selected_rows>
<cfelse>
	<cfset selected_list = ValueList(get_fund_flow.fund_flow_id)>
</cfif>

<cfset inv_rem = get_fund_flow_def.inverse_remainder>
<cfset view_amount_type = get_fund_flow.view_amount_type>
