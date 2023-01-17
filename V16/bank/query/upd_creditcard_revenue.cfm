<cf_get_lang_set module_name="bank"><!--- sayfanin en altinda kapanisi var --->
<cfif attributes.action_period_id neq session.ep.period_id>
	<script type="text/javascript">
		alert("<cf_get_lang_main no='1659.İşlem Yapmak İstediğiniz Muhasebe Dönemi ile Aktif Muhasebe Döneminiz Farklı Muhasebe Döneminizi Kontrol Ediniz'>!");
		window.location.href='<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_creditcard_revenue</cfoutput>';
	</script>
	<cfabort>
</cfif>
<cfquery name="get_process_type" datasource="#dsn3#">
	SELECT PROCESS_TYPE,IS_CARI,IS_ACCOUNT,ACTION_FILE_NAME,ACTION_FILE_FROM_TEMPLATE FROM SETUP_PROCESS_CAT WHERE PROCESS_CAT_ID = #form.process_cat#
</cfquery>
<cfscript>
	process_type = get_process_type.process_type;
	is_cari = get_process_type.is_cari;
	is_account = get_process_type.is_account;
	attributes.sales_credit = filterNum(attributes.sales_credit);
	attributes.sales_credit_comm = filterNum(attributes.sales_credit_comm);
	attributes.other_value_sales_credit = filterNum(attributes.other_value_sales_credit);
	attributes.system_amount = filterNum(attributes.system_amount);
	for(z_sy=1; z_sy lte attributes.kur_say; z_sy = z_sy+1)
	{
		'attributes.txt_rate1_#z_sy#' = filterNum(evaluate('attributes.txt_rate1_#z_sy#'),session.ep.our_company_info.rate_round_num);
		'attributes.txt_rate2_#z_sy#' = filterNum(evaluate('attributes.txt_rate2_#z_sy#'),session.ep.our_company_info.rate_round_num);
	}
	
	/* FA-09102013 kredi kartı Gelişmiş şifreleme standartları ile şifrelenmesi. 
	Bu sistemin çalışması için sistem/güvenlik altında kredi kartı şifreleme anahtarlırının tanımlanması gerekmektedir 
	*/
	if(len(attributes.card_no))
	{
		getCCNOKey = createObject("component", "V16.settings.cfc.setupCcnoKey");
		getCCNOKey.dsn = dsn;
		getCCNOKey1 = getCCNOKey.getCCNOKey1();
		getCCNOKey2 = getCCNOKey.getCCNOKey2();
		
		if (len(attributes.action_from_company_id))//kredi kart bilgileri
			key_type = attributes.action_from_company_id;
		else if (len(attributes.cons_id))
			key_type = attributes.cons_id;
		
		if (getCCNOKey1.recordcount and getCCNOKey2.recordcount)
		{
			// anahtarlar decode ediliyor 
			ccno_key1 = contentEncryptingandDecodingAES(isEncode:0,accountKey:getCCNOKey1.record_emp,content:getCCNOKey1.ccnokey);
			ccno_key2 = contentEncryptingandDecodingAES(isEncode:0,accountKey:getCCNOKey2.record_emp,content:getCCNOKey2.ccnokey);
			// kart no encode ediliyor
			content = contentEncryptingandDecodingAES(isEncode:1,content:attributes.card_no,accountKey:key_type,key1:ccno_key1,key2:ccno_key2);
		}
		else
			content = Encrypt(attributes.card_no,key_type,"CFMX_COMPAT","Hex");
	}

	currency_multiplier = '';
	currency_multiplier_2 = '';
	currency_multiplier_other = '';
	if(isDefined('attributes.kur_say') and len(attributes.kur_say))
		for(mon=1;mon lte attributes.kur_say;mon=mon+1)
		{
			if(evaluate("attributes.hidden_rd_money_#mon#") is session.ep.money2)
				currency_multiplier = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
			if(evaluate("attributes.hidden_rd_money_#mon#") is attributes.currency_id)
				currency_multiplier_2 = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');			
			if(evaluate("attributes.hidden_rd_money_#mon#") is money_type)
				currency_multiplier_other = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');			
		}
	if(session.ep.our_company_info.project_followup neq 1 or not isdefined("attributes.project_id"))//isdefined lar altta functionlarda sıkıntı yaratıyordu buraya tanımlandı
	{
		attributes.project_id = "";
		attributes.project_name = "";
	}
	if(isdefined("attributes.branch_id") and len(attributes.branch_id))
		branch_id_info = attributes.branch_id;
	else
		branch_id_info = listgetat(session.ep.user_location,2,'-');
</cfscript>
<cfquery name="GET_CREDIT_PAYMENT" datasource="#dsn3#">
	SELECT 
		PAYMENT_TYPE_ID, 
		NUMBER_OF_INSTALMENT, 
		P_TO_INSTALMENT_ACCOUNT,
		ACCOUNT_CODE,
		SERVICE_RATE,
		PAYMENT_RATE,
		PAYMENT_RATE_ACC,
		IS_PESIN,
		COMPANY_ID
	FROM 
		CREDITCARD_PAYMENT_TYPE 
	WHERE 
		PAYMENT_TYPE_ID = #attributes.payment_type_id#
</cfquery>
<cfif not len(GET_CREDIT_PAYMENT.ACCOUNT_CODE) and is_account eq 1>
	<script type="text/javascript">
		alert("<cf_get_lang no ='396.Seçtiğiniz Ödeme Yönteminin Muhasebe Kodu Seçilmemiş'>!");
		history.back();	
	</script>
	<cfabort>
</cfif>
<cfif len(attributes.action_from_company_id)>
	<cfset my_acc_result = get_company_period(attributes.action_from_company_id)>
	<cfquery name="get_comp_name" datasource="#dsn#">
		SELECT FULLNAME FROM COMPANY WHERE COMPANY_ID = #attributes.action_from_company_id#
	</cfquery>
	<cfset member_name_ = get_comp_name.FULLNAME>
<cfelse>
	<cfset my_acc_result = get_consumer_period(attributes.cons_id)>
	<cfquery name="get_cons_name" datasource="#dsn#">
		SELECT CONSUMER_NAME + ' ' + CONSUMER_SURNAME FULLNAME FROM CONSUMER WHERE CONSUMER_ID = #attributes.cons_id#
	</cfquery>
	<cfset member_name_ = get_cons_name.FULLNAME>
</cfif>
<cfif not len(my_acc_result) and is_account eq 1><!--- isşlem kategorisinde muhasebe işlemi seçili ise --->
	<script type="text/javascript">
		alert("<cf_get_lang no ='393.Seçtiğiniz Üyenin Muhasebe Kodu Seçilmemiş'>!");
		history.back();	
	</script>
	<cfabort>
</cfif>
<cf_date tarih='attributes.action_date'>
<cf_date tarih='attributes.due_start_date'>
<!--- Ödeme yöntemindeki hesaba geçiş gününe göre vade hesaplanıyor --->

<cfif get_credit_payment.recordcount and len(get_credit_payment.p_to_instalment_account)>
	<cfset due_value_date = dateadd("d",get_credit_payment.p_to_instalment_account,attributes.due_start_date)>
<cfelse>
	<cfset due_value_date = attributes.due_start_date>
</cfif>

<cflock name="#createUUID()#" timeout="20">
	<cftransaction>		
		<cfinclude template="upd_creditcard_revenue_ic.cfm">
		<cf_workcube_process_cat 
			process_cat="#form.process_cat#"
			old_process_cat_id = "#attributes.old_process_cat_id#"
			action_id = #attributes.id#
			is_action_file = 1
			action_page='#request.self#?fuseaction=bank.list_creditcard_revenue&event=upd&id=#attributes.id#'
			action_file_name='#get_process_type.action_file_name#'
			is_template_action_file = '#get_process_type.action_file_from_template#'>
    	<cf_add_log employee_id="#session.ep.userid#" log_type="0" action_id="#attributes.id#" action_name= "Kredi Kartı Tahsilatı Güncellendi" paper_no= "#attributes.paper_number#" period_id="#session.ep.period_id#" process_type="#get_process_type.process_type#" data_source="#dsn3#">
	</cftransaction>
</cflock>
<cfquery name="get_closed_id" datasource="#dsn2#">
	SELECT CLOSED_ID FROM CARI_CLOSED_ROW WHERE ACTION_ID = #attributes.id# AND ACTION_TYPE_ID = #process_type#
</cfquery>

<script type="text/javascript">
	<cfif isdefined("attributes.is_from_payroll")>
		window.opener.payment_with_voucher.creditcard_revenue_id.value = <cfoutput>#attributes.id#</cfoutput>;
		window.opener.payment_with_voucher.submit();
		window.close(); 
	<cfelse>
		<cfif session.ep.our_company_info.is_paper_closer eq 1 and (len(attributes.action_from_company_id) or len(attributes.cons_id))>
			//window.opener.search_form.submit();
			<cfif get_closed_id.recordcount gt 0>
				window.open('<cfoutput>#request.self#?fuseaction=finance.upd_payment_actions&closed_id=#get_closed_id.closed_id#&act_type=1</cfoutput>','page');
			<cfelse>
				window.open('<cfoutput>#request.self#?fuseaction=finance.list_payment_actions&event=add&act_type=1&member_id=#attributes.action_from_company_id#&consumer_id=#attributes.cons_id#&money_type=#form.money_type#&row_action_id=#attributes.id#&row_action_type=#process_type#</cfoutput>','page');
			</cfif>	
		<cfelse>
			window.location.href='<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_creditcard_revenue&event=upd&id=#attributes.id#</cfoutput>';
			wrk_opener_reload();
		</cfif>
		window.close();
	</cfif>
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
