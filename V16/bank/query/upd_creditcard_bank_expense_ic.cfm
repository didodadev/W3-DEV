<cfif not isdefined("is_row_project_based_cari")><cfset is_row_project_based_cari = 0></cfif>
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
		SPECIAL_DEFINITION_ID = <cfif isdefined("attributes.special_definition_id") and len(attributes.special_definition_id)>#attributes.special_definition_id#<cfelse>NULL</cfif>
	WHERE
		CREDITCARD_EXPENSE_ID = #attributes.CREDITCARD_EXPENSE_ID#
</cfquery>
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
			for(mon=1;mon lte attributes.kur_say;mon=mon+1)
				if(evaluate("attributes.hidden_rd_money_#mon#") is session.ep.money2)
					currency_multiplier = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');	
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
					islem_detay : UCase('#getLang('main',1756)#'),
					action_detail : attributes.action_detail,
					account_card_type : 13,
					to_cmp_id : action_to_company_id,
					to_consumer_id : attributes.cons_id,
					subscription_id : iif((isdefined("attributes.subscription_id") and len(attributes.subscription_id) and len(attributes.subscription_no)),attributes.subscription_id,de('')),
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
					islem_detay : iif((process_type_credit eq 249),de(UCase('#getLang('','Kredi Kartıyla Ödeme İade',61771)#')),de(UCase('#getLang('','Kredi Kartıyla Ödeme İptal',29554)#'))),
					action_detail : attributes.action_detail,
					account_card_type : 13,
					subscription_id : iif((isdefined("attributes.subscription_id") and len(attributes.subscription_id) and len(attributes.subscription_no)),attributes.subscription_id,de('')),
					from_cmp_id : action_to_company_id,
					from_consumer_id : attributes.cons_id,
					project_id : iif((isdefined("attributes.project_id") and len(attributes.project_id) and isDefined("attributes.project_name") and len(attributes.project_name)),attributes.project_id,de('')),
					islem_belge_no : attributes.paper_number,
					due_date : attributes.action_date,
					special_definition_id : iif((isdefined("attributes.special_definition_id") and len(attributes.special_definition_id)),'attributes.special_definition_id',de('')),
					assetp_id : iif((isdefined("attributes.asset_id") and len(attributes.asset_id) and len(attributes.asset_name)),'attributes.asset_id',de('')),
					rate2:paper_currency_multiplier
					);
			}
		}
		else if(is_row_project_based_cari eq 0)
			cari_sil(action_id:attributes.CREDITCARD_EXPENSE_ID,process_type:old_process_type_credit);
		
		if(is_account eq 1)
		{
			if (process_type_credit eq 242)//kredi kartı tahsilat
			{
				borc_hesap = my_acc_result;
				alacak_hesap =GET_CREDIT_CARD.ACCOUNT_CODE;
				fis_detail = UCase('#getLang('main',1756)# #getLang('main',2610)#');
			}
			else//kredi kartı tahsilat iptal
			{
				borc_hesap = GET_CREDIT_CARD.ACCOUNT_CODE;
				alacak_hesap = my_acc_result;
				fis_detail = UCase('#getLang('main',1757)# #getLang('main',2610)#');
			}
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
			if(not isdefined("acc_department_id")) acc_department_id = '';
			muhasebeci (
				action_id:attributes.CREDITCARD_EXPENSE_ID,
				workcube_process_type: process_type_credit,
				workcube_old_process_type : old_process_type_credit,
				workcube_process_cat:iif((session.ep.our_company_info.is_edefter eq 1 and isdefined("expense_id") and len(expense_id)),0,form.process_cat),
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
				acc_project_id : iif((isdefined("attributes.project_id") and len(attributes.project_id) and isDefined("attributes.project_name") and len(attributes.project_name)),attributes.project_id,de('')),
				from_branch_id : branch_id_info
			);
		}
		else
			muhasebe_sil (action_id:attributes.CREDITCARD_EXPENSE_ID,process_type:old_process_type_credit);
	</cfscript>
<cfelse>
	<cfscript>
		cari_sil(action_id:attributes.creditcard_expense_id,process_type:process_type_credit);
		muhasebe_sil (action_id:attributes.creditcard_expense_id,process_type:process_type_credit);
	</cfscript>
</cfif>
<cfscript>
	f_kur_ekle_action(action_id:attributes.CREDITCARD_EXPENSE_ID,process_type:1,action_table_name:'CREDIT_CARD_BANK_EXPENSE_MONEY',action_table_dsn:'#dsn3#',transaction_dsn='#dsn2#');
</cfscript>
