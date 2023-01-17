<cfset wrk_id = dateformat(now(),'YYYYMMDD')&timeformat(now(),'HHmmss')&'_#session.ep.userid#_'&round(rand()*100)>
<cfquery name="get_pos_process_cat" datasource="#dsn2#" maxrows="1">
	SELECT IS_ACCOUNT,IS_CARI,IS_ACCOUNT_GROUP,PROCESS_CAT_ID FROM #dsn3_alias#.SETUP_PROCESS_CAT WHERE PROCESS_TYPE = 241
</cfquery>
<cfscript>
	action_to_account_id_first = listfirst(attributes.pos,';');
	account_currency_id = listgetat(attributes.pos,2,';');
	payment_type_id = listgetat(attributes.pos,4,';');
	temp_pos_tutar = attributes.system_pos_amount;
	to_branch_id = listgetat(session.ep.user_location,2,'-');
</cfscript>
<cfquery name="GET_CREDIT_PAYMENT" datasource="#dsn2#">
	SELECT 
		PAYMENT_TYPE_ID, 
		NUMBER_OF_INSTALMENT, 
		P_TO_INSTALMENT_ACCOUNT,
		ACCOUNT_CODE,
		SERVICE_RATE,
		IS_PESIN
	FROM 
		#dsn3_alias#.CREDITCARD_PAYMENT_TYPE 
	WHERE 
		PAYMENT_TYPE_ID = #payment_type_id#
</cfquery>
<cfif len(GET_CREDIT_PAYMENT.SERVICE_RATE) and GET_CREDIT_PAYMENT.SERVICE_RATE neq 0>
	<cfset commission_multiplier_amount = wrk_round(attributes.pos_amount * GET_CREDIT_PAYMENT.SERVICE_RATE /100)>
<cfelse>
	<cfset commission_multiplier_amount = 0>
</cfif>
<cfset credit_currency_multiplier = ''>
<cfif isDefined('attributes.kur_say') and len(attributes.kur_say)>
	<cfloop from="1" to="#attributes.kur_say#" index="mon">
		<cfif evaluate("attributes.hidden_rd_money_#mon#") is session.ep.money>
			<cfset credit_currency_multiplier = filterNum(evaluate('attributes.txt_rate2_#mon#'),session.ep.our_company_info.rate_round_num)/filterNum(evaluate('attributes.txt_rate1_#mon#'),session.ep.our_company_info.rate_round_num)>
		</cfif>
		<cfif evaluate("attributes.hidden_rd_money_#mon#") is account_currency_id>
			<cfset credit_currency_multiplier2 = filterNum(evaluate('attributes.txt_rate2_#mon#'),session.ep.our_company_info.rate_round_num)/filterNum(evaluate('attributes.txt_rate1_#mon#'),session.ep.our_company_info.rate_round_num)>
		</cfif>
	</cfloop>	
</cfif>
<cfquery name="ADD_CREDIT_PAYMENT" datasource="#dsn2#" result="MAX_ID">
	INSERT INTO
		#dsn3_alias#.CREDIT_CARD_BANK_PAYMENTS
		(
			PROCESS_CAT,
			ACTION_TYPE_ID,
			WRK_ID,
			PAYMENT_TYPE_ID,
			NUMBER_OF_INSTALMENT,
			ACTION_TO_ACCOUNT_ID,
			ACTION_CURRENCY_ID,
			ACTION_FROM_COMPANY_ID,
			PARTNER_ID,
			CONSUMER_ID,
			STORE_REPORT_DATE,
			SALES_CREDIT,
			COMMISSION_AMOUNT,
			ACTION_TYPE,
			OTHER_CASH_ACT_VALUE,
			OTHER_MONEY,
			PAPER_NO,
			IS_ACCOUNT,
			IS_ACCOUNT_TYPE,
			ACTION_PERIOD_ID,
			CARI_ACTION_VALUE,
			RECORD_EMP,
			RECORD_DATE,
			RECORD_IP,
			TO_BRANCH_ID,
			VOUCHER_PAYROLL_ID 			
		)
		VALUES
		(
			0,
			241,
			'#wrk_id#',
			#payment_type_id#,
			<cfif len(get_credit_payment.number_of_instalment)>#get_credit_payment.number_of_instalment#,<cfelse>NULL,</cfif>
			#action_to_account_id_first#,
			'#account_currency_id#',
			<cfif isdefined("attributes.company_id") and len(attributes.company_id)>#attributes.company_id#,<cfelse>NULL,</cfif>
			<cfif isdefined("attributes.partner_id") and len(attributes.partner_id)>#attributes.partner_id#,<cfelse>NULL,</cfif>
			<cfif isdefined("attributes.consumer_id") and len(attributes.consumer_id)>#attributes.consumer_id#,<cfelse>NULL,</cfif>
			#action_date#,
			#attributes.pos_amount#,
			#commission_multiplier_amount#,
			'KREDİ KARTI TAHSİLAT',
			#attributes.system_pos_amount#,
			'#session.ep.money#',
			'#my_payroll_no#',
			<cfif is_account eq 1>1,13,<cfelse>0,13,</cfif>
			#session.ep.period_id#,
			#attributes.system_com_amount#,
			#session.ep.userid#,
			#now()#,
			'#cgi.remote_addr#',
			#ListGetAt(session.ep.user_location,2,"-")#,
			#P_ID#				
		)
</cfquery>
<cfquery name="add_rel_action" datasource="#dsn2#">
	INSERT INTO
		VOUCHER_PAYROLL_ACTIONS
		(
			PAYROLL_ID,
			ACTION_ID,
			ACTION_TYPE_ID
		)
		VALUES
		(
			#p_id#,
			#MAX_ID.IDENTITYCOL#,
			241
		)
</cfquery>
<cfoutput query="get_moneys">
	<cfquery name="ADD_CREDIT_MONEY" datasource="#dsn2#">
		INSERT INTO
			#dsn3_alias#.CREDIT_CARD_BANK_PAYMENT_MONEY
			(
				ACTION_ID,
				MONEY_TYPE,
				RATE2,
				RATE1,
				IS_SELECTED
			)
			VALUES
			(
				#MAX_ID.IDENTITYCOL#,
				'#get_moneys.money#',
				#get_moneys.rate2#,
				#get_moneys.rate1#,
				<cfif get_moneys.money is session.ep.money>1<cfelse>0</cfif>					
			)
	</cfquery>
</cfoutput>
<cfquery name="GET_CREDIT_CARD_BANK_PAYMENT" datasource="#DSN2#">
	SELECT 
		SALES_CREDIT,
		COMMISSION_AMOUNT,
		PAYMENT_TYPE_ID,
		STORE_REPORT_DATE,
		CREDITCARD_PAYMENT_ID
	FROM 
		#dsn3_alias#.CREDIT_CARD_BANK_PAYMENTS 
	WHERE 
		CREDITCARD_PAYMENT_ID = #MAX_ID.IDENTITYCOL#
</cfquery>
<cfset bank_action_date = dateadd("d", GET_CREDIT_PAYMENT.P_TO_INSTALMENT_ACCOUNT,GET_CREDIT_CARD_BANK_PAYMENT.STORE_REPORT_DATE)>
<cfif (GET_CREDIT_PAYMENT.IS_PESIN eq 1) or (not len(GET_CREDIT_PAYMENT.NUMBER_OF_INSTALMENT)) or (GET_CREDIT_PAYMENT.NUMBER_OF_INSTALMENT eq 0)>
	<cfset satir_sayisi = 1>
	<cfset operation_type = 'Peşin Giriş'>
	<cfset tutar = GET_CREDIT_CARD_BANK_PAYMENT.SALES_CREDIT>
	<cfif (GET_CREDIT_CARD_BANK_PAYMENT.COMMISSION_AMOUNT) gt 0>
		<cfset komsiyon_tutar = GET_CREDIT_CARD_BANK_PAYMENT.COMMISSION_AMOUNT>
	<cfelse>
		<cfset komsiyon_tutar = 0>
	</cfif>
<cfelse>
	<cfset satir_sayisi = GET_CREDIT_PAYMENT.NUMBER_OF_INSTALMENT>
	<cfset tutar = (GET_CREDIT_CARD_BANK_PAYMENT.SALES_CREDIT/GET_CREDIT_PAYMENT.NUMBER_OF_INSTALMENT)>
	<cfif (GET_CREDIT_CARD_BANK_PAYMENT.COMMISSION_AMOUNT) gt 0>
		<cfset komsiyon_tutar = (GET_CREDIT_CARD_BANK_PAYMENT.COMMISSION_AMOUNT/GET_CREDIT_PAYMENT.NUMBER_OF_INSTALMENT)>
	<cfelse>
		<cfset komsiyon_tutar = 0>
	</cfif>
</cfif>
<cfloop from="1" to="#satir_sayisi#" index="i">
	<cfquery name="ADD_CREDIT_CARD_BANK_PAYMENT_ROWS" datasource="#dsn2#">
		INSERT INTO
			#dsn3_alias#.CREDIT_CARD_BANK_PAYMENTS_ROWS
			(
				STORE_REPORT_DATE,
				BANK_ACTION_DATE,
				CREDITCARD_PAYMENT_ID,
				PAYMENT_TYPE_ID,
				OPERATION_NAME,
				AMOUNT,
				COMMISSION_AMOUNT
			)
		VALUES
			(
				#CreateODBCDateTime(GET_CREDIT_CARD_BANK_PAYMENT.STORE_REPORT_DATE)#,
				#bank_action_date#,
				#GET_CREDIT_CARD_BANK_PAYMENT.CREDITCARD_PAYMENT_ID#,
				#GET_CREDIT_CARD_BANK_PAYMENT.PAYMENT_TYPE_ID#,
				<cfif isDefined("operation_type")>'#operation_type#'<cfelse>'#i#. Taksit'</cfif>,
				#tutar#,
				#komsiyon_tutar#
			)
	</cfquery>
	<cfset bank_action_date = dateadd("m",1,bank_action_date)>
</cfloop>
<cfscript>
	if(is_cari eq 1 and total_pay_term_value gt 0)//eğer ödeme sözü varsa cari işlem yapılıyor
	{
		carici(
				action_id : MAX_ID.IDENTITYCOL,
				action_table : 'CREDIT_CARD_BANK_PAYMENTS',
				workcube_process_type : 241,
				process_cat : 0,
				islem_tarihi : action_date,
				due_date : action_date,
				to_account_id : action_to_account_id_first,
				islem_tutari : total_pay_term_value,
				action_currency : session.ep.money,
				other_money_value : total_pay_term_value,
				other_money : session.ep.money,
				currency_multiplier : currency_multiplier,
				islem_detay : 'KREDİ KARTI TAHSİLAT',
				action_detail : 'SENET TAHSİLAT İŞLEMİ',
				account_card_type : 13,
				from_cmp_id : attributes.company_id,
				from_consumer_id : attributes.consumer_id,
				to_branch_id : to_branch_id
				);
	}
	if(is_account eq 1)
	{
		alacakli_hesaplar = '';
		alacakli_tutarlar = '';
		other_amount_alacak_list = '';
		other_currency_alacak_list = '';
		borclu_tutarlar = '';
		borclu_hesaplar = '';
		satir_detay_list = ArrayNew(2);
		for(i=1; i lte attributes.record_num; i=i+1)
		{
			if (listfind('1,11',evaluate("attributes.voucher_status_#i#")) and isdefined("attributes.is_pay_#i#") and listfind(attributes.voucher_ids_2,evaluate("attributes.voucher_id_#i#"),','))
			{
				senet_tutar = attributes.system_pos_amount;
				get_voucher = cfquery(datasource:"#dsn2#",sqlstring:"SELECT * FROM VOUCHER WHERE VOUCHER_ID= #evaluate("attributes.voucher_id_#i#")#");
				alacakli_tutarlar=listappend(alacakli_tutarlar,senet_tutar,',');
				borclu_tutarlar=listappend(borclu_tutarlar,senet_tutar,',');
				borclu_hesaplar = listappend(borclu_hesaplar, GET_CREDIT_PAYMENT.account_code, ',');
				other_currency_alacak_list = listappend(other_currency_alacak_list,attributes.basket_money,',');
				other_amount_alacak_list =  listappend(other_amount_alacak_list,senet_tutar,',');
				if(get_voucher.IS_PAY_TERM eq 0)
				{
					GET_VOUCHER_ACC_CODE=cfquery(datasource:"#dsn2#", sqlstring:"
						SELECT
							C.A_VOUCHER_ACC_CODE
						FROM
							VOUCHER_PAYROLL AS VP,
							VOUCHER_HISTORY AS VH,
							CASH AS C
						WHERE
							VP.PAYROLL_CASH_ID = C.CASH_ID AND
							(VP.PAYROLL_TYPE=97 OR VP.PAYROLL_TYPE = 109 OR (VP.PAYROLL_TYPE=107 AND VP.PAYROLL_NO='-1')) AND
							VP.ACTION_ID= VH.PAYROLL_ID AND
							VH.VOUCHER_ID=#get_voucher.voucher_id#");
					alacakli_hesaplar=listappend(alacakli_hesaplar, GET_VOUCHER_ACC_CODE.A_VOUCHER_ACC_CODE, ',');
					satir_detay_list[2][listlen(alacakli_tutarlar)] = '#attributes.company# #dateformat(now(),dateformat_style)# VADELİ SENET TAHSİL İŞLEMİ';
				}
				else
				{
					alacakli_hesaplar=listappend(alacakli_hesaplar, MY_ACC_RESULT, ',');
					satir_detay_list[2][listlen(alacakli_tutarlar)] = '#attributes.company# - #dateformat(now(),dateformat_style)# VADELİ ÖDEME SÖZÜ TAHSİL İŞLEMİ';
				}
			}
		}
		//Eğer gecikme faizi varsa gelir kaleminin muhasebe koduna atıyor
		if(attributes.total_interest_amount gt 0)
		{
			GET_EXP_ACC = cfquery(datasource : "#dsn2#", sqlstring : "SELECT ACCOUNT_CODE FROM EXPENSE_ITEMS WHERE EXPENSE_ITEM_ID = #attributes.expense_item_id#");
			alacakli_tutarlar=listappend(alacakli_tutarlar,attributes.total_interest_amount,',');
			other_currency_alacak_list = listappend(other_currency_alacak_list,attributes.basket_money,',');
			other_amount_alacak_list =  listappend(other_amount_alacak_list,attributes.total_interest_amount,',');
			alacakli_hesaplar=listappend(alacakli_hesaplar,GET_EXP_ACC.ACCOUNT_CODE, ',');
			satir_detay_list[2][listlen(alacakli_tutarlar)] = '#attributes.company# - #dateformat(now(),dateformat_style)# VADELİ SENET TAHSİL İŞLEMİ';
		}
		if(attributes.system_com_amount gt 0)
		{
			alacakli_tutarlar=listappend(alacakli_tutarlar,attributes.system_com_amount,',');
			borclu_tutarlar = borclu_tutarlar + attributes.system_com_amount;
			other_currency_alacak_list = listappend(other_currency_alacak_list,account_currency_id,',');
			other_amount_alacak_list =  listappend(other_amount_alacak_list,attributes.com_amount,',');
			alacakli_hesaplar=listappend(alacakli_hesaplar,MY_ACC_RESULT, ',');
			temp_pos_tutar =  temp_pos_tutar + attributes.system_com_amount;
			satir_detay_list[2][listlen(alacakli_tutarlar)] = '#attributes.company# - #dateformat(now(),dateformat_style)# VADELİ SENET TAHSİL İŞLEMİ';
		}
		satir_detay_list[1][1] = 'SENET TAHSİLAT İŞLEMİ';		
		if(account_currency_id is session.ep.money)
		{
			muhasebeci (
				action_id: MAX_ID.IDENTITYCOL,
				action_table : 'CREDIT_CARD_BANK_PAYMENTS',
				workcube_process_type: 241,
				process_cat : 0,
				account_card_type: 13,
				company_id : attributes.company_id,
				consumer_id : attributes.consumer_id,
				islem_tarihi: action_date,
				borc_hesaplar: borclu_hesaplar,
				borc_tutarlar: temp_pos_tutar,
				alacak_hesaplar: alacakli_hesaplar,
				alacak_tutarlar: alacakli_tutarlar,
				fis_detay: 'KREDİ KARTI TAHSİLAT',
				fis_satir_detay:satir_detay_list,
				currency_multiplier : currency_multiplier,
				to_branch_id : to_branch_id,
				is_account_group : is_account_group
				);		
		}
		else
		{	
			muhasebeci (
				action_id: MAX_ID.IDENTITYCOL,
				action_table : 'CREDIT_CARD_BANK_PAYMENTS',
				workcube_process_type: 241,
				process_cat : 0,
				account_card_type: 13,
				company_id : attributes.company_id,
				consumer_id : attributes.consumer_id,
				islem_tarihi: action_date,
				borc_hesaplar: borclu_hesaplar,
				borc_tutarlar: borclu_tutarlar,
				other_amount_borc : attributes.pos_amount,
				other_currency_borc : account_currency_id,
				alacak_hesaplar: alacakli_hesaplar,
				alacak_tutarlar: alacakli_tutarlar,
				other_amount_alacak : other_amount_alacak_list,
				other_currency_alacak : other_currency_alacak_list,
				fis_detay: 'KREDİ KARTI TAHSİLAT',
				fis_satir_detay:satir_detay_list,
				currency_multiplier : currency_multiplier,
				to_branch_id : to_branch_id,
				is_account_group : is_account_group
				);		
		}
	}
</cfscript>


