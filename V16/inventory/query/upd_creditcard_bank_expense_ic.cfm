<cfif not isdefined("is_row_project_based_cari")><cfset is_row_project_based_cari = 0></cfif>
<cfset id = attributes.CREDITCARD_EXPENSE_ID>

<cfif len(attributes.CREDITCARD_EXPENSE_ID)>
<cfquery name="ADDD_CREDITCARD_PAYMENT" datasource="#dsn2#">

	UPDATE
		#dsn3_alias#.CREDIT_CARD_BANK_EXPENSE
	SET
		PROCESS_TYPE = #process_type_credit#,
		PROCESS_CAT = #attributes.process_cat#,
		ACTION_TO_COMPANY_ID = <cfif len(attributes.action_to_company_id)>#attributes.action_to_company_id#,<cfelse>NULL,</cfif>
		PAR_ID = <cfif len(attributes.par_id)>#attributes.par_id#,<cfelse>NULL,</cfif>
		CONS_ID = <cfif len(cons_id)>#cons_id#,<cfelse>NULL,</cfif>
		ACCOUNT_ID = #account_id_first#,
		ACTION_CURRENCY_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#action_curreny#">,
		CREDITCARD_ID = #account_id_last#,
		TOTAL_COST_VALUE = #attributes.action_value#,
		OTHER_COST_VALUE = #attributes.other_money_value#,
		OTHER_MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.money_type#">,
		ACTION_DATE = #attributes.action_date#,
		DETAIL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.action_detail#">,
		PROJECT_ID = <cfif isdefined("attributes.project_id") and len(attributes.project_id) and isDefined("attributes.project_name") and len(attributes.project_name)>#attributes.project_id#,<cfelse>NULL,</cfif>
		PAPER_NO = <cfif len(attributes.paper_number)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.paper_number#">,<cfelse>NULL,</cfif>
		ASSETP_ID = <cfif isdefined("attributes.asset_id") and len(attributes.asset_id) and len(attributes.asset_name)>#attributes.asset_id#<cfelse>NULL</cfif>,
		UPDATE_EMP = #session.ep.userid#,
		UPDATE_DATE = #now()#,
		UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.REMOTE_ADDR#">,
		INSTALLMENT_NUMBER = <cfif len(attributes.inst_number)>#attributes.inst_number#<cfelse>NULL</cfif>,
		DELAY_INFO = <cfif isDefined("attributes.delay_info") and len(attributes.delay_info)>#attributes.delay_info#<cfelse>NUll</cfif>,
		ACTION_PERIOD_ID = #session.ep.period_id#,
		SPECIAL_DEFINITION_ID = <cfif isdefined("attributes.special_definition_id") and len(attributes.special_definition_id)>#attributes.special_definition_id#<cfelse>NULL</cfif>,
		EXPENSE_ID = NULL,
		INVOICE_ID = <cfif isdefined("attributes.invoice_id") and len(attributes.invoice_id)>#attributes.invoice_id#<cfelse>NULL</cfif>
		
	WHERE
		CREDITCARD_EXPENSE_ID = #attributes.CREDITCARD_EXPENSE_ID#
</cfquery>
<cfelse>
<cfquery name="ADDD_CREDITCARD_PAYMENT" datasource="#dsn2#" result="MAX_ID_">
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
		ASSETP_ID,
		RECORD_EMP,
		RECORD_DATE,
		RECORD_IP,
		FROM_BRANCH_ID,
		INSTALLMENT_NUMBER,
		DELAY_INFO,
		ACTION_PERIOD_ID,
		SPECIAL_DEFINITION_ID,
		EXPENSE_ID,
		INVOICE_ID
	)
	VALUES
	(
		#process_type_credit#,
		#attributes.process_cat#,
		<cfif len(attributes.action_to_company_id)>#attributes.action_to_company_id#,<cfelse>NULL,</cfif>
		<cfif len(attributes.par_id)>#attributes.par_id#<cfelse>NULL</cfif>,
		<cfif len(attributes.cons_id)>#attributes.cons_id#<cfelse>NULL</cfif>,
		#account_id_first#,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#action_curreny#">,
		#account_id_last#,
		#attributes.action_value#,
		#attributes.other_money_value#,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.money_type#">,
		#attributes.action_date#,
		<cfif isdefined("attributes.project_id") and len(attributes.project_id) and isDefined("attributes.project_name") and len(attributes.project_name)>#attributes.project_id#,<cfelse>NULL,</cfif>
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.action_detail#">,
		<cfif len(attributes.paper_number)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.paper_number#">,<cfelse>NULL,</cfif>
		<cfif isdefined("attributes.asset_id") and len(attributes.asset_id) and len(attributes.asset_name)>#attributes.asset_id#<cfelse>NULL</cfif>,
		#session.ep.userid#,
		#now()#,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
		#branch_id_info#,
		<cfif len(attributes.inst_number)>#attributes.inst_number#<cfelse>NULL</cfif>,
		<cfif isDefined("attributes.delay_info") and len(attributes.delay_info)>#attributes.delay_info#<cfelse>NUll</cfif>,
		#session.ep.period_id#,
		<cfif isdefined("attributes.special_definition_id") and len(attributes.special_definition_id)>#attributes.special_definition_id#<cfelse>NULL</cfif>,
		NULL,
		<cfif isdefined("attributes.invoice_id") and len(attributes.invoice_id)>#attributes.invoice_id#<cfelse>NULL</cfif>
	)
</cfquery>
 <cfquery name="GET_CREDIT_ACTIONS" datasource="#dsn2#">
    SELECT CREDITCARD_EXPENSE_ID FROM #dsn3_alias#.CREDIT_CARD_BANK_EXPENSE WHERE INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.invoice_id#"> 
</cfquery>
<cfset attributes.creditcard_expense_id = get_credit_actions.creditcard_expense_id>
</cfif>
<cfquery name="DEL_CARD_ROWS" datasource="#dsn2#">
	DELETE FROM #dsn3_alias#.CREDIT_CARD_BANK_EXPENSE_ROWS WHERE CREDITCARD_EXPENSE_ID = #attributes.CREDITCARD_EXPENSE_ID#
</cfquery>
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
			ACC_ACTION_DATE,<!--- hesap kesim tarihi --->
			CREDITCARD_EXPENSE_ID,<!--- ödeme id si --->
			CREDITCARD_ID,<!--- kredş kartı id si --->
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
<cfif (isdefined("is_from_expense") and is_cari_acc eq 1) or not isdefined("is_from_expense")>
	<cfscript>
		currency_multiplier = '';
		if(isDefined('attributes.kur_say') and len(attributes.kur_say))
			for(mon=1;mon lte attributes.kur_say;mon=mon+1){
				if(evaluate("attributes.hidden_rd_money_#mon#") is session.ep.money2)
					currency_multiplier = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');	}
		if(is_cari eq 1 and is_row_project_based_cari eq 0)
		{
			if (process_type_credit eq 242)//kredi kartı ödeme
			{
				carici(
					action_id : attributes.CREDITCARD_EXPENSE_ID,
					action_table : 'CREDIT_CARD_BANK_EXPENSE',
					workcube_process_type : process_type_credit,
					workcube_old_process_type : old_process_type_credit,
					process_cat : attributes.process_cat,	
					islem_tarihi : attributes.action_date,
					from_account_id : account_id_first,
					from_branch_id : branch_id_info,
					islem_tutari : attributes.system_amount,
					action_currency : session.ep.money,
					other_money_value : attributes.other_money_value,
					other_money : attributes.money_type,
					currency_multiplier : currency_multiplier,
					islem_detay : 'KREDİ KARTIYLA ÖDEME',
					action_detail : attributes.action_detail,
					account_card_type : 13,
					to_cmp_id : action_to_company_id,
					to_consumer_id : attributes.cons_id,
					project_id : iif((isdefined("attributes.project_id") and len(attributes.project_id) and isDefined("attributes.project_name") and len(attributes.project_name)),attributes.project_id,de('')),
					islem_belge_no : attributes.paper_number,
					due_date : attributes.action_date,
					special_definition_id : iif((isdefined("attributes.special_definition_id") and len(attributes.special_definition_id)),'attributes.special_definition_id',de('')),
					assetp_id : iif((isdefined("attributes.asset_id") and len(attributes.asset_id) and len(attributes.asset_name)),'attributes.asset_id',de('')),
					rate2:paper_currency_multiplier
					);
			}
			else
			{
				carici(
					action_id : attributes.CREDITCARD_EXPENSE_ID,
					action_table : 'CREDIT_CARD_BANK_EXPENSE',
					workcube_process_type : process_type_credit,
					workcube_old_process_type : old_process_type_credit,
					process_cat : attributes.process_cat,	
					islem_tarihi : attributes.action_date,
					to_account_id : account_id_first,
					to_branch_id : branch_id_info,
					islem_tutari : attributes.system_amount,
					action_currency : session.ep.money,
					other_money_value : attributes.other_money_value,
					other_money : attributes.money_type,
					currency_multiplier : currency_multiplier,
					islem_detay : 'KREDİ KARTIYLA ÖDEME İPTAL',
					action_detail : attributes.action_detail,
					account_card_type : 13,
					from_cmp_id : action_to_company_id,
					from_consumer_id : attributes.cons_id,
					project_id : iif((isdefined("attributes.project_id") and len(attributes.project_id) and isDefined("attributes.project_name") and len(attributes.project_name)),attributes.project_id,de('')),
					islem_belge_no : attributes.paper_number,
					due_date :attributes.invoice_date,
					special_definition_id : iif((isdefined("attributes.special_definition_id") and len(attributes.special_definition_id)),'attributes.special_definition_id',de('')),
					assetp_id : iif((isdefined("attributes.asset_id") and len(attributes.asset_id) and len(attributes.asset_name)),'attributes.asset_id',de('')),
					rate2:paper_currency_multiplier
					);
			}
		}
		else if(is_row_project_based_cari eq 0)
			cari_sil(action_id:id,process_type:old_process_type_credit);
		
		if(is_account eq 1)
		{
			if (process_type_credit eq 242)//kredi kartı tahsilat
			{
				borc_hesap = my_acc_result;
				alacak_hesap =GET_CREDIT_CARD.ACCOUNT_CODE;
				fis_detail = 'KREDİ KARTIYLA ÖDEME İŞLEMI';
			}
			else//kredi kartı tahsilat iptal
			{
				borc_hesap = GET_CREDIT_CARD.ACCOUNT_CODE;
				alacak_hesap = my_acc_result;
				fis_detail = 'KREDİ KARTIYLA ÖDEME İŞLEMI İPTAL';
			}
			if(isDefined("attributes.ACTION_DETAIL") and len(attributes.ACTION_DETAIL))
				str_card_detail = '#attributes.ACTION_DETAIL#';
			else if(action_curreny is session.ep.money)
			{
				if(process_type_credit eq 242) 
					str_card_detail = 'KREDİ KARTIYLA ÖDEME İŞLEMİ';
				else 
					str_card_detail = 'KREDİ KARTIYLA ÖDEME İŞLEMİ İPTAL';
			}
			else
			{
				if(process_type_credit eq 242) 
					str_card_detail = 'DÖVİZLİ KREDİ KARTIYLA ÖDEME İŞLEMİ';
				else 
					str_card_detail = 'DÖVİZLİ KREDİ KARTIYLA ÖDEME İŞLEMİ İPTAL';
			}
			if(not isdefined("acc_department_id")) acc_department_id = '';
			
			muhasebeci (
				action_id:attributes.CREDITCARD_EXPENSE_ID,
				workcube_process_type: process_type_credit,
				workcube_old_process_type : old_process_type_credit,
				workcube_process_cat:iif((session.ep.our_company_info.is_edefter eq 1 and isdefined("invoice_id") and len(invoice_id)),0,form.process_cat),
				acc_department_id:acc_department_id,
				account_card_type: 13,
				islem_tarihi: attributes.ACTION_DATE,
				fis_satir_detay: str_card_detail,
				company_id : attributes.action_to_company_id,
				consumer_id : attributes.cons_id,
				borc_hesaplar: borc_hesap,
				borc_tutarlar: attributes.system_amount,
				other_amount_borc : iif(len(attributes.other_money_value),'attributes.other_money_value',de('')),
				other_currency_borc : attributes.money_type,
				alacak_hesaplar: alacak_hesap,
				alacak_tutarlar: attributes.system_amount,
				other_amount_alacak : attributes.ACTION_VALUE,
				other_currency_alacak : action_curreny,
				currency_multiplier : currency_multiplier,
				belge_no : attributes.paper_number,
				fis_detay: fis_detail,
				workcube_process_cat : form.process_cat,
				acc_project_id : iif((isdefined("attributes.project_id") and len(attributes.project_id) and isDefined("attributes.project_name") and len(attributes.project_name)),attributes.project_id,de('')),
				from_branch_id : branch_id_info
			);
		}
		else
			muhasebe_sil (action_id:id,process_type:old_process_type_credit);
	</cfscript>
<cfelse>
	<cfscript>
		cari_sil(action_id:attributes.creditcard_expense_id,process_type:process_type_credit);
		muhasebe_sil (action_id:attributes.creditcard_expense_id,process_type:process_type_credit);
	</cfscript>
</cfif>
<cfscript>
	f_kur_ekle_action(action_id:attributes.creditcard_expense_id,process_type:1,action_table_name:'CREDIT_CARD_BANK_EXPENSE_MONEY',action_table_dsn:'#dsn3#',transaction_dsn='#dsn2#');
</cfscript>