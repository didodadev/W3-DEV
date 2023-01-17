<cfset form.active_period = session.ep.period_id>
<cfquery name="GET_MONEY_INFO" datasource="#dsn2#">
	SELECT 
    	MONEY_ID, 
        MONEY, 
        RATE1, 
        RATE2, 
        MONEY_STATUS, 
        PERIOD_ID, 
        COMPANY_ID, 
        ACCOUNT_950, 
        RATE3, 
        RECORD_DATE, 
        RECORD_EMP, 
        RECORD_IP, 
        UPDATE_DATE,
        UPDATE_EMP, 
        UPDATE_IP, 
        MONEY_NAME
    FROM 
	    SETUP_MONEY 
    WHERE 
    	MONEY_STATUS = 1
</cfquery>
<cfquery name="GET_PROCESS_MONEY" datasource="#dsn#">
	SELECT ISNULL(STANDART_PROCESS_MONEY,OTHER_MONEY) MONEY_TYPE FROM SETUP_PERIOD WHERE PERIOD_ID = #session.ep.period_id#
</cfquery>
<cfscript>
	is_from_makeage = 1;
	attributes.CONSUMER_ID = "";
	attributes.project_name = "";
	attributes.project_id = "";
	attributes.money_type = GET_PROCESS_MONEY.MONEY_TYPE;
	currency_mult_other = 1;
	currency_multiplier = "";
	attributes.kur_say = GET_MONEY_INFO.RECORDCOUNT;
	for(stp_mny=1;stp_mny lte GET_MONEY_INFO.RECORDCOUNT;stp_mny=stp_mny+1)
	{
		'attributes.hidden_rd_money_#stp_mny#'=GET_MONEY_INFO.MONEY[stp_mny];
		'attributes.txt_rate1_#stp_mny#'=GET_MONEY_INFO.RATE1[stp_mny];	
		'attributes.txt_rate2_#stp_mny#'=GET_MONEY_INFO.RATE2[stp_mny];
		if(attributes.currency_id eq GET_MONEY_INFO.MONEY[stp_mny])
			currency_mult_acc = (GET_MONEY_INFO.RATE2[stp_mny]/GET_MONEY_INFO.RATE1[stp_mny]);
		if(GET_PROCESS_MONEY.MONEY_TYPE eq GET_MONEY_INFO.MONEY[stp_mny])
			currency_mult_other = (GET_MONEY_INFO.RATE2[stp_mny]/GET_MONEY_INFO.RATE1[stp_mny]);
		if(GET_MONEY_INFO.MONEY[stp_mny] eq session.ep.money2)
			currency_multiplier = (GET_MONEY_INFO.RATE2[stp_mny]/GET_MONEY_INFO.RATE1[stp_mny]);
	}
</cfscript>
<cfif len(attributes.bank_order_list)>
	<cfloop list="#attributes.bank_order_list#" index="i">
		<cfscript>
			if(isdefined("attributes.bankorder_member_type#i#"))
				attributes.member_type = evaluate("attributes.bankorder_member_type#i#");
			else
				attributes.member_type = "company";
			if(attributes.member_type == "company")
				attributes.COMPANY_ID = evaluate("attributes.bankorder_comp_id#i#");
			else if(attributes.member_type == "consumer")
				attributes.consumer_id = evaluate("attributes.bankorder_comp_id#i#");
			else
				attributes.employee_id = evaluate("attributes.bankorder_comp_id#i#");		
			attributes.ACTION_DATE = evaluate("attributes.bankorder_act_date#i#");
			attributes.PAYMENT_DATE = evaluate("attributes.bankorder_due_date#i#");
			if(attributes.currency_id eq session.ep.money)
			{
				attributes.ORDER_AMOUNT = wrk_round(evaluate("attributes.acc_amount#i#"));
				attributes.OTHER_CASH_ACT_VALUE = wrk_round(evaluate("attributes.acc_amount#i#")/currency_mult_other);
				attributes.system_amount = wrk_round(evaluate("attributes.acc_amount#i#"));	
			}
			else
			{
				attributes.ORDER_AMOUNT = wrk_round(evaluate("attributes.acc_amount#i#"));
				attributes.system_amount = wrk_round(evaluate("attributes.acc_amount#i#")*currency_mult_acc);
				attributes.OTHER_CASH_ACT_VALUE = wrk_round(attributes.system_amount/currency_mult_other);
			}
		</cfscript>
		<cfinclude template="../../bank/query/add_assign_order.cfm">
	</cfloop>
</cfif>
<script type="text/javascript">
	wrk_opener_reload();
</script>
<cflocation url="#request.self#?fuseaction=bank.list_assign_order&account_id=#attributes.account_id#&form_varmi=1&is_havale=2" addtoken="no">
