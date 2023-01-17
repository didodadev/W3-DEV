<cfif isdefined("form.invoice_id")>
	<cfquery name="GET_CASH_ACTION" datasource="#dsn2#">
		SELECT ACTION_ID FROM CASH_ACTIONS WHERE BILL_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.invoice_id#">
	</cfquery>
	<cfif get_cash_action.recordcount>
		<cfscript>
			cari_sil(action_id:GET_CASH_ACTION.ACTION_ID,process_type:32);
			muhasebe_sil (action_id:GET_CASH_ACTION.ACTION_ID,process_type:32);
		</cfscript>		
		<cfquery name="DEL_FROM_CASH_ACTIONS" datasource="#dsn2#">
			DELETE FROM CASH_ACTIONS WHERE ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_CASH_ACTION.ACTION_ID#">
		</cfquery>
	</cfif>
	<cfquery name="GET_BANK_ACTION" datasource="#dsn2#">
		SELECT ACTION_ID FROM BANK_ACTIONS WHERE BILL_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.invoice_id#">
	</cfquery>
	<cfif get_bank_action.recordcount>
		<cfscript>
			cari_sil(action_id:GET_BANK_ACTION.ACTION_ID,process_type:25);
			muhasebe_sil (action_id:GET_BANK_ACTION.ACTION_ID,process_type:25);
		</cfscript>		
		<cfquery name="DEL_FROM_BANK_ACTIONS" datasource="#dsn2#">
			DELETE FROM BANK_ACTIONS WHERE ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_BANK_ACTION.ACTION_ID#">
		</cfquery>
	</cfif>
	<cfquery name="GET_CREDIT_ACTIONS" datasource="#dsn2#">
		SELECT CREDITCARD_EXPENSE_ID FROM #dsn3_alias#.CREDIT_CARD_BANK_EXPENSE WHERE INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.invoice_id#"> AND ACTION_PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
	</cfquery>
	<cfif GET_CREDIT_ACTIONS.RECORDCOUNT>
		<cfscript>
			cari_sil(action_id:GET_CREDIT_ACTIONS.CREDITCARD_EXPENSE_ID,process_type:242);
			muhasebe_sil (action_id:GET_CREDIT_ACTIONS.CREDITCARD_EXPENSE_ID,process_type:242);
		</cfscript>
	</cfif>
<cfelse>
	<cfset get_credit_actions.recordcount = 0>
</cfif>
<cfscript>
	my_acc_result = string_acc_code;
	account_id_first = listgetat(attributes.credit_card_info,1,';');
	action_curreny = listgetat(attributes.credit_card_info,2,';');
	account_id_last = listgetat(attributes.credit_card_info,3,';');
	cc_rate=1;
	if(isDefined('attributes.kur_say') and len(attributes.kur_say))
	{
		for(mon=1;mon lte attributes.kur_say;mon=mon+1)
		{
			if(evaluate("attributes.hidden_rd_money_#mon#") is action_curreny)
				cc_rate = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
		}
	}
	attributes.system_amount = form.basket_net_total;
	attributes.action_value = wrk_round(form.basket_net_total/cc_rate);
	attributes.other_money_value = form.basket_net_total;
	attributes.money_type = attributes.BASKET_MONEY;
	attributes.action_date = attributes.invoice_date;
	attributes.action_detail = attributes.note;
	attributes.paper_number = form.invoice_number;
	process_type_credit = 242;
	old_process_type_credit = 242;
	if(get_credit_actions.recordcount gt 0)
	{
		invoice_id = form.invoice_id;
		attributes.creditcard_expense_id = get_credit_actions.creditcard_expense_id;
	}
	else
	{
		if (isdefined("form.invoice_id"))
			invoice_id = form.invoice_id;
		else
			invoice_id = get_invoice_id.max_id;
			attributes.creditcard_expense_id = '';
	}
	currency_multiplier = '';
</cfscript>
<cfquery name="GET_CREDIT_CARD" datasource="#dsn2#"><!--- Seçilen kredi kartının ek bilgileri --->
	SELECT 
		ISNULL(CLOSE_ACC_DAY,1) CLOSE_ACC_DAY,
		ACCOUNT_CODE
	FROM 
		#dsn3_alias#.CREDIT_CARD 
	WHERE 
		CREDITCARD_ID = #account_id_last#
</cfquery>

<cfif not len(attributes.creditcard_expense_id)>
	<cfquery name="ADD_CREDITCARD_PAYMENT" datasource="#dsn2#" result="MAX_ID_">
		INSERT INTO
			#dsn3_alias#.CREDIT_CARD_BANK_EXPENSE
		(
			PROCESS_TYPE,
			PROCESS_CAT,
			ACTION_TO_COMPANY_ID,
			PAR_ID,
			CONS_ID,
			ACCOUNT_ID,
			ACTION_CURRENCY_ID,
			CREDITCARD_ID,
			TOTAL_COST_VALUE,
			OTHER_COST_VALUE,
			OTHER_MONEY,
			ACTION_DATE,
			PROJECT_ID,
			DETAIL,
			PAPER_NO,
			RECORD_EMP,
			RECORD_DATE,
			RECORD_IP,
			FROM_BRANCH_ID,
			INSTALLMENT_NUMBER,
			DELAY_INFO,
			ACTION_PERIOD_ID,
			INVOICE_ID
		)
		VALUES
		(
			#process_type_credit#,
			#attributes.process_cat#,
			<cfif len(attributes.company_id)>#attributes.company_id#,<cfelse>NULL,</cfif>
			<cfif len(attributes.partner_id)>#attributes.partner_id#<cfelse>NULL</cfif>,
			<cfif len(attributes.consumer_id)>#attributes.consumer_id#<cfelse>NULL</cfif>,
			#account_id_first#,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#action_curreny#">,
			#account_id_last#,
			#attributes.action_value#,
			#attributes.other_money_value#,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.money_type#">,
			#attributes.action_date#,
			<cfif isdefined("attributes.project_id") and len(attributes.project_id) and isdefined("attributes.project_head") and len(attributes.project_head)>#attributes.project_id#,<cfelse>NULL,</cfif>
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.action_detail#">,
			<cfif len(attributes.paper_number)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.paper_number#">,<cfelse>NULL,</cfif>
			#session.ep.userid#,
			#now()#,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
			#listgetat(session.ep.user_location,2,'-')#,
			<cfif len(attributes.inst_number)>#attributes.inst_number#<cfelse>NULL</cfif>,
			<cfif isDefined("attributes.delay_info") and len(attributes.delay_info)>#attributes.delay_info#<cfelse>NUll</cfif>,
			#session.ep.period_id#,
			<cfif isdefined("invoice_id") and len(invoice_id)>#invoice_id#<cfelse>NULL</cfif>
		)
	</cfquery>
	<cfset attributes.CREDITCARD_EXPENSE_ID = MAX_ID_.IDENTITYCOL>
<cfelse>
	<cfquery name="ADD_CREDITCARD_PAYMENT" datasource="#dsn2#">
		UPDATE
			#dsn3_alias#.CREDIT_CARD_BANK_EXPENSE
		SET
			PROCESS_TYPE = #process_type_credit#,
			PROCESS_CAT = #attributes.process_cat#,
			ACTION_TO_COMPANY_ID = <cfif len(attributes.company_id)>#attributes.company_id#,<cfelse>NULL,</cfif>
			PAR_ID = <cfif len(attributes.partner_id)>#attributes.partner_id#,<cfelse>NULL,</cfif>
			CONS_ID = <cfif len(attributes.consumer_id)>#attributes.consumer_id#,<cfelse>NULL,</cfif>
			ACCOUNT_ID = #account_id_first#,
			ACTION_CURRENCY_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#action_curreny#">,
			CREDITCARD_ID = #account_id_last#,
			TOTAL_COST_VALUE = #attributes.action_value#,
			OTHER_COST_VALUE = #attributes.other_money_value#,
			OTHER_MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.money_type#">,
			ACTION_DATE = #attributes.action_date#,
			DETAIL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.action_detail#">,
			PROJECT_ID = <cfif isdefined("attributes.project_id") and len(attributes.project_id) and isdefined("attributes.project_head") and len(attributes.project_head)>#attributes.project_id#,<cfelse>NULL,</cfif>
			PAPER_NO = <cfif len(attributes.paper_number)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.paper_number#">,<cfelse>NULL,</cfif>
			UPDATE_EMP = #session.ep.userid#,
			UPDATE_DATE = #now()#,
			UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.REMOTE_ADDR#">,
			INSTALLMENT_NUMBER = <cfif len(attributes.inst_number)>#attributes.inst_number#<cfelse>NULL</cfif>,
			DELAY_INFO = <cfif isDefined("attributes.delay_info") and len(attributes.delay_info)>#attributes.delay_info#<cfelse>NUll</cfif>,
			ACTION_PERIOD_ID = #session.ep.period_id#,
			INVOICE_ID = <cfif isdefined("invoice_id") and len(invoice_id)>#invoice_id#<cfelse>NULL</cfif>
		WHERE
			CREDITCARD_EXPENSE_ID = #attributes.CREDITCARD_EXPENSE_ID#
	</cfquery>
	<cfquery name="DEL_CARD_ROWS" datasource="#dsn2#">
		DELETE FROM #dsn3_alias#.CREDIT_CARD_BANK_EXPENSE_ROWS WHERE CREDITCARD_EXPENSE_ID = #attributes.CREDITCARD_EXPENSE_ID#
	</cfquery>
</cfif>
<cfquery name="GET_CREDIT_CARD_BANK_EXPENSE" datasource="#dsn2#">
	SELECT 
		TOTAL_COST_VALUE,
		CREDITCARD_ID,
		ACTION_DATE,
		CREDITCARD_EXPENSE_ID,
		ISNULL(INSTALLMENT_NUMBER,0) INSTALLMENT_NUMBER
	FROM 
		#dsn3_alias#.CREDIT_CARD_BANK_EXPENSE 
	WHERE
		CREDITCARD_EXPENSE_ID = #attributes.CREDITCARD_EXPENSE_ID#
</cfquery>
<cfif GET_CREDIT_CARD_BANK_EXPENSE.INSTALLMENT_NUMBER eq 0>
	<cfset satir_sayisi = 1>
	<cfset inst_detail = 'Tek Ödeme'>
	<cfset tutar = GET_CREDIT_CARD_BANK_EXPENSE.TOTAL_COST_VALUE>
<cfelse>
	<cfset satir_sayisi = GET_CREDIT_CARD_BANK_EXPENSE.INSTALLMENT_NUMBER>
	<cfset tutar = (GET_CREDIT_CARD_BANK_EXPENSE.TOTAL_COST_VALUE/ GET_CREDIT_CARD_BANK_EXPENSE.INSTALLMENT_NUMBER)>
</cfif>
<cfloop from="1" to="#satir_sayisi#" index="i">
	<!--- işlem tarihi üstüne hesaba geçiş tarihi eklenerek rowlara yazılır --->
	<cfif day(GET_CREDIT_CARD_BANK_EXPENSE.ACTION_DATE) gt GET_CREDIT_CARD.CLOSE_ACC_DAY><!--- sonraki aya geçecek işlemler --->
		<cfset sonraki_ay = dateadd('m',i,GET_CREDIT_CARD_BANK_EXPENSE.ACTION_DATE)>
		<cfset gun_ = GET_CREDIT_CARD.CLOSE_ACC_DAY>
		<cfif gun_ gt daysinmonth(sonraki_ay)>
			<cfset gun_ = daysinmonth(sonraki_ay)>
			<cfset bank_action_date = createodbcdatetime(createdate(year(sonraki_ay),month(sonraki_ay),gun_))>
		<cfelse>
			<cfset bank_action_date = CreateODBCDateTime('#year(dateadd('m',i,GET_CREDIT_CARD_BANK_EXPENSE.ACTION_DATE))#-#month(dateadd('m',i,GET_CREDIT_CARD_BANK_EXPENSE.ACTION_DATE))#-#GET_CREDIT_CARD.CLOSE_ACC_DAY#')>
		</cfif>
	<cfelse>
		<cfset sonraki_ay = dateadd('m',i-1,GET_CREDIT_CARD_BANK_EXPENSE.ACTION_DATE)>
		<cfset gun_ = GET_CREDIT_CARD.CLOSE_ACC_DAY>
		<cfif gun_ gt daysinmonth(sonraki_ay)>
			<cfset gun_ = daysinmonth(sonraki_ay)>
			<cfset bank_action_date = createodbcdatetime(createdate(year(sonraki_ay),month(sonraki_ay),gun_))>
		<cfelse>
			<cfset bank_action_date = CreateODBCDateTime('#year(dateadd('m',i-1,GET_CREDIT_CARD_BANK_EXPENSE.ACTION_DATE))#-#month(dateadd('m',i-1,GET_CREDIT_CARD_BANK_EXPENSE.ACTION_DATE))#-#GET_CREDIT_CARD.CLOSE_ACC_DAY#')>
		</cfif>
	</cfif>
	<cfquery name="ADD_CREDIT_CARD_BANK_EXPENSE_ROWS" datasource="#dsn2#">
		INSERT INTO
			#dsn3_alias#.CREDIT_CARD_BANK_EXPENSE_ROWS
		(
			CC_ACTION_DATE,<!--- ödeme işlem tarihi --->
			ACC_ACTION_DATE,<!--- borç ödeme tarihi --->
			CREDITCARD_EXPENSE_ID,<!--- ödeme id si --->
			CREDITCARD_ID,<!--- kredi kartı id si --->
			INSTALLMENT_DETAIL,<!--- taksit açıklaması --->
			INSTALLMENT_AMOUNT<!--- taksit tutarı --->
		)
		VALUES
		(
			#CreateODBCDateTime(GET_CREDIT_CARD_BANK_EXPENSE.ACTION_DATE)#,
			<cfif isDefined("attributes.delay_info") and len(attributes.delay_info)>#dateadd('m',attributes.delay_info,bank_action_date)#,<cfelse>#bank_action_date#,</cfif><!--- erteleme bilgisine göre tekrar hesaplanıyor, sıkıntı olursa incelenecek --->
			#GET_CREDIT_CARD_BANK_EXPENSE.CREDITCARD_EXPENSE_ID#,
			#GET_CREDIT_CARD_BANK_EXPENSE.CREDITCARD_ID#,
			<cfif isDefined("inst_detail")><cfqueryparam cfsqltype="cf_sql_varchar" value="#inst_detail#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="#i#. Taksit"></cfif>,
			#tutar#
		)
	</cfquery>
</cfloop>

<cfscript>
	if(is_cari eq 1)//kredi kartı carici
	{
		carici(
			action_id : attributes.CREDITCARD_EXPENSE_ID,
			action_table : 'CREDIT_CARD_BANK_EXPENSE',
			workcube_process_type : process_type_credit,		
			process_cat : attributes.process_cat,	
			islem_tarihi : attributes.action_date,
			from_account_id : account_id_first,
			from_branch_id : listgetat(session.ep.user_location,2,'-'),
			islem_tutari : attributes.system_amount,
			action_currency : session.ep.money,
			other_money_value : attributes.other_money_value,
			other_money : attributes.money_type,
			currency_multiplier : currency_multiplier_money2,
			islem_detay : UCase('#getLang('main',1756)#'),
			action_detail : attributes.action_detail,
			account_card_type : 13,
			subscription_id : '',
			project_id : iif((isdefined("attributes.project_id") and len(attributes.project_id) and len(attributes.project_head)),'attributes.project_id',de('')),
			islem_belge_no : attributes.paper_number,
			due_date: attributes.action_date,
			to_cmp_id : attributes.company_id,
			to_consumer_id : attributes.consumer_id,
			special_definition_id : '',
			assetp_id : '',
			rate2:paper_currency_multiplier
		);
	}
	else if(isdefined("invoice_id"))
	{
		cari_sil(action_id:attributes.CREDITCARD_EXPENSE_ID,process_type:old_process_type_credit);
	}

	if(is_account eq 1)
	{
		borc_hesap = my_acc_result;
		alacak_hesap =GET_CREDIT_CARD.ACCOUNT_CODE;
		fis_detail = UCase('#getLang('main',1756)# #getLang('main',2610)#');
		other_amount_borc = attributes.other_money_value;
		other_currency_borc = attributes.money_type;
		other_amount_alacak = attributes.action_value;
		other_currency_alacak = action_curreny;

		if(isDefined("attributes.ACTION_DETAIL") and len(attributes.ACTION_DETAIL))
			str_card_detail = '#attributes.ACTION_DETAIL#';
		else if(action_curreny is session.ep.money)
		{
			if(process_type_credit eq 242) 
				str_card_detail = UCase('#getLang('main',1756)# #getLang('main',2610)#');
			else 
				str_card_detail = UCase('#getLang('main',1757)# #getLang('main',2610)#');
		}
		else
		{
			if(process_type_credit eq 242) 
				str_card_detail = UCase('#getLang('main',2657)#');
			else 
				str_card_detail = UCase('#getLang('main',2658)#');
		}
		
		muhasebeci (
			action_id:attributes.CREDITCARD_EXPENSE_ID,
			workcube_old_process_type : 242,
			workcube_process_type: process_type_credit,
			workcube_process_cat: iif((session.ep.our_company_info.is_edefter eq 1 and isdefined("expense_id") and len(expense_id)),0,attributes.process_cat),
			acc_department_id : iif((isdefined("attributes.acc_department_id") and len(attributes.acc_department_id)),'attributes.acc_department_id',de('')),
			account_card_type: 13,
			islem_tarihi: attributes.ACTION_DATE,
			fis_satir_detay: str_card_detail,
			company_id : attributes.company_id,
			consumer_id : attributes.consumer_id,
			borc_hesaplar: borc_hesap,
			borc_tutarlar: attributes.system_amount,
			other_amount_borc : other_amount_borc,
			other_currency_borc : other_currency_borc,
			alacak_hesaplar: alacak_hesap,
			alacak_tutarlar: attributes.system_amount,
			other_amount_alacak : other_amount_alacak,
			other_currency_alacak : other_currency_alacak,
			currency_multiplier : currency_multiplier_money2,
			belge_no : attributes.paper_number,
			acc_project_id : iif((isdefined("attributes.project_id") and len(attributes.project_id) and isDefined("attributes.project_name") and len(attributes.project_name)),attributes.project_id,de('')),
			fis_detay: fis_detail,
			from_branch_id : listgetat(session.ep.user_location,2,'-')
		);
	}
	else if(isdefined("invoice_id"))
	{
		muhasebe_sil(action_id:attributes.CREDITCARD_EXPENSE_ID,process_type:old_process_type_credit);
	}

	f_kur_ekle_action(action_id:attributes.CREDITCARD_EXPENSE_ID,process_type:0,action_table_name:'CREDIT_CARD_BANK_EXPENSE_MONEY',action_table_dsn:'#dsn3#',transaction_dsn='#dsn2#');
</cfscript>