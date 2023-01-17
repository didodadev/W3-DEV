<cfif attributes.active_period neq session.ep.period_id>
	<script type="text/javascript">
		alert("<cf_get_lang_main no='1659.İşlem Yapmak İstediğiniz Muhasebe Dönemi ile Aktif Muhasebe Döneminiz Farklı Muhasebe Döneminizi Kontrol Ediniz'>");
		window.location.href='<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_bank_actions</cfoutput>';
	</script>
	<cfabort>
</cfif>
<cf_date tarih='attributes.action_date'>
<cfquery name="get_process_type" datasource="#dsn3#">
	SELECT 
		PROCESS_TYPE,
		IS_CARI,
		IS_ACCOUNT,
		ACTION_FILE_NAME,
		ACTION_FILE_FROM_TEMPLATE
	 FROM 
	 	SETUP_PROCESS_CAT 
	WHERE 
		PROCESS_CAT_ID = #form.process_cat#
</cfquery>
<cfscript>
	process_type_credit = get_process_type.process_type;
	old_process_type_credit = form.old_process_type;
	is_cari = get_process_type.is_cari;
	is_account = get_process_type.is_account;
	account_id_first = listgetat(attributes.credit_card_info,1,';');
	action_curreny = listgetat(attributes.credit_card_info,2,';');
	account_id_last = listgetat(attributes.credit_card_info,3,';');
	if(isdefined("attributes.branch_id") and len(attributes.branch_id))
		branch_id_info = attributes.branch_id;
	else
		branch_id_info = listgetat(session.ep.user_location,2,'-');
</cfscript>
<cfquery name="GET_CREDIT_CARD" datasource="#dsn3#"><!--- Seçilen kredi kartının ek bilgileri --->
	SELECT 
		ISNULL(CLOSE_ACC_DAY,1) CLOSE_ACC_DAY,
		ACCOUNT_CODE
	FROM 
		CREDIT_CARD 
	WHERE 
		CREDITCARD_ID = #account_id_last#
</cfquery>
<cfif is_account eq 1>
	<cfif len(attributes.action_to_company_id)><!--- firmanın muhasebe kodu --->
		<cfset my_acc_result = GET_COMPANY_PERIOD(attributes.action_to_company_id)>
	<cfelseif len(attributes.cons_id)><!---	bireysel uyenin muhasebe kodu--->
		<cfset my_acc_result = GET_CONSUMER_PERIOD(attributes.cons_id)>
	</cfif>
	<cfif not len(my_acc_result)>
		<script type="text/javascript">
			alert("<cf_get_lang no ='393.Seçtiğiniz Üyenin Muhasebe Kodu Seçilmemiş'>");
			history.back();	
		</script>
		<cfabort>
	</cfif>
	<cfif not len(GET_CREDIT_CARD.ACCOUNT_CODE)>
		<script type="text/javascript">
			alert("<cf_get_lang no ='395.Seçtiğiniz Kredi Kartının Muhasebe Kodu Seçilmemiş'>!");
			history.back();	
		</script>
		<cfabort>
	</cfif>
</cfif>
<cfscript>
	attributes.action_value = filterNum(attributes.action_value);
	attributes.other_money_value = filterNum(attributes.other_money_value);
	attributes.system_amount = filterNum(attributes.system_amount);
	paper_currency_multiplier = '';
	for(h_hy=1; h_hy lte attributes.kur_say; h_hy=h_hy+1)
	{
		'attributes.txt_rate1_#h_hy#' = filterNum(evaluate('attributes.txt_rate1_#h_hy#'),session.ep.our_company_info.rate_round_num);
		'attributes.txt_rate2_#h_hy#' = filterNum(evaluate('attributes.txt_rate2_#h_hy#'),session.ep.our_company_info.rate_round_num);
		if( evaluate("attributes.hidden_rd_money_#h_hy#") is attributes.money_type)
			paper_currency_multiplier = evaluate('attributes.txt_rate2_#h_hy#/attributes.txt_rate1_#h_hy#');
	}
	if (session.ep.our_company_info.project_followup neq 1)//isdefined lar altta functionlarda sıkıntı yaratıyordu buraya tanımlandı
	{
		attributes.project_id = "";
		attributes.project_name = "";
	}
</cfscript>
<cflock name="#CreateUUID()#" timeout="20">
	<cftransaction>
		<cfinclude template="upd_creditcard_bank_expense_ic.cfm">
		<cfif len(get_process_type.action_file_name)> <!--- secilen islem kategorisine bir action file eklenmisse --->
			<cf_workcube_process_cat 
				process_cat="#form.process_cat#"
				action_id = #attributes.CREDITCARD_EXPENSE_ID#
				is_action_file = 1
				action_file_name='#get_process_type.action_file_name#'
				action_page='#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_credit_card_expense&event=upd&id=#attributes.CREDITCARD_EXPENSE_ID#'
				action_db_type = '#dsn2#'
				is_template_action_file = '#get_process_type.action_file_from_template#'>
		</cfif>
        <cf_add_log employee_id="#session.ep.userid#" log_type="0" action_id="#attributes.CREDITCARD_EXPENSE_ID#" action_name= "Kredi Kartı Ödemesi Güncellendi" paper_no= "#attributes.paper_number#" period_id="#session.ep.period_id#" process_type="#get_process_type.process_type#" data_source="#dsn2#">
	</cftransaction>
</cflock>
<cfquery name="get_closed_id" datasource="#dsn2#">
	SELECT CLOSED_ID FROM CARI_CLOSED_ROW WHERE ACTION_ID = #attributes.CREDITCARD_EXPENSE_ID# AND ACTION_TYPE_ID = #process_type_credit#
</cfquery>
<script type="text/javascript">
	<cfif session.ep.our_company_info.is_paper_closer eq 1 and (len(attributes.action_to_company_id) or len(attributes.cons_id)) and session.ep.isBranchAuthorization eq 0>
		window.opener.list_credit_card_expense.submit();
		<cfif get_closed_id.recordcount gt 0>
			window.open('<cfoutput>#request.self#?fuseaction=finance.list_payment_actions&event=upd&closed_id=#get_closed_id.closed_id#&act_type=1</cfoutput>','page');
		<cfelse>
			window.open('<cfoutput>#request.self#?fuseaction=finance.list_payment_actions&event=add&act_type=1&member_id=#attributes.action_to_company_id#&consumer_id=#attributes.cons_id#&money_type=#form.money_type#&row_action_id=#attributes.CREDITCARD_EXPENSE_ID#&row_action_type=#process_type_credit#</cfoutput>','page');
		</cfif>	
	<cfelse>
		wrk_opener_reload();
	</cfif>
	window.close();
</script>
