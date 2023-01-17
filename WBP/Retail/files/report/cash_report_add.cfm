
<cfinclude template="../../../../V16/cash/query/get_cashes_list.cfm">
<cfset attribues.active_period = session.ep.period_id>
<cfset attribues.my_fuseaction = fusebox.fuseaction>
<cfquery name="get_process_type" datasource="#dsn3#">
    SELECT * FROM SETUP_PROCESS_CAT WHERE PROCESS_TYPE = 33
</cfquery>
<cfquery name="GET_MONEY_INFO" datasource="#dsn2#">
    SELECT MONEY MONEY_TYPE,* FROM SETUP_MONEY WHERE MONEY_STATUS = 1
</cfquery>
<cfset attributes.process_cat = get_process_type.PROCESS_CAT_ID>
<cfset form.process_cat = get_process_type.PROCESS_CAT_ID>
<cfset 'attributes.ct_process_type_#get_process_type.PROCESS_CAT_ID#' = 33>
<cfscript>
    for(stp_mny=1;stp_mny lte GET_MONEY_INFO.RECORDCOUNT;stp_mny=stp_mny+1)
		{
			'attributes.hidden_rd_money_#stp_mny#'=GET_MONEY_INFO.MONEY_TYPE[stp_mny];
			'attributes.txt_rate1_#stp_mny#'=GET_MONEY_INFO.RATE1[stp_mny];	
			'attributes.txt_rate2_#stp_mny#'=GET_MONEY_INFO.RATE2[stp_mny];
			'attributes.t_txt_rate1_#GET_MONEY_INFO.MONEY_TYPE[stp_mny]#'=GET_MONEY_INFO.RATE1[stp_mny];	
			'attributes.t_txt_rate2_#GET_MONEY_INFO.MONEY_TYPE[stp_mny]#'=GET_MONEY_INFO.RATE2[stp_mny];
        }
</cfscript>
<cfset attributes.kur_say = GET_MONEY_INFO.RECORDCOUNT>
<cfquery name="get_c" dbtype="query">
    SELECT * FROM get_cashes WHERE CASH_ID = #attributes.TO_CASH_ID#
</cfquery>
<cfset attributes.TO_CASH_ID = "#get_c.cash_id#;#get_c.cash_currency_id#;#get_c.branch_id#">

<cfoutput>
    <cfloop list="#attributes.CASH_LIST#" index="FROM_CASH_ID">
        <cf_papers paper_type="cash_to_cash">
        #paper_code & '-' & paper_number# #attributes.ACTION_DATE#
        <cfquery name="get_c" dbtype="query">
            SELECT * FROM get_cashes WHERE CASH_ID = #FROM_CASH_ID#
        </cfquery>
        <cfset attributes.FROM_CASH_ID = "#FROM_CASH_ID#;#get_c.cash_currency_id#;#get_c.branch_id#">
		<cfset attributes.paper_number = paper_code & '-' & paper_number>
		<cfset attributes.CASH_ACTION_VALUE = filternum(evaluate("attributes.CASH_VALUE_#FROM_CASH_ID#"))>
        <cfset attributes.OTHER_CASH_ACT_VALUE =  filternum(evaluate("attributes.CASH_VALUE_#FROM_CASH_ID#"))>
        <cfset attributes.ACTION_DETAIL = "#get_c.cash_name# VIRMAN">
        <cfset ACTION_DETAIL = "#get_c.cash_name# VIRMAN">
        <cfset money_type = 'TL'>
        <cfset attributes.money_type = 'TL'>
        <cfset attributes.system_amount = attributes.CASH_ACTION_VALUE>
        <cfinclude template="query/add_cash_to_cash.cfm">
    </cfloop>
</cfoutput>
<script>
    window.location.href="<cfoutput>#request.self#?fuseaction=cash.list_cash_actions</cfoutput>";
</script>