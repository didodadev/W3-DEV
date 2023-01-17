<cfquery name="get_pos_process_cat" datasource="#dsn2#" maxrows="1">
	SELECT IS_ACCOUNT,IS_CARI,IS_ACCOUNT_GROUP,PROCESS_CAT_ID FROM #dsn3_alias#.SETUP_PROCESS_CAT WHERE PROCESS_TYPE = 245
</cfquery>
<cfif get_pos_process_cat.recordcount eq 0>
	<script type="text/javascript">
		alert("Lütfen Kredi Kartı Tahsilat İptal İşlem Kategorilerinizi Tanımlayınız !");
		window.close();
	</script>
	<cfabort>
</cfif>
<cfquery name="get_money_bskt" datasource="#dsn2#">
	SELECT * FROM SETUP_MONEY
</cfquery>
<cfquery name="get_pos_old" datasource="#dsn2#">
	SELECT * FROM #dsn3_alias#.CREDIT_CARD_BANK_PAYMENTS WHERE CREDITCARD_PAYMENT_ID = #get_payroll_actions.action_id#
</cfquery>
<cfquery name="GET_ACC_BRANCH" datasource="#dsn2#">
	SELECT * FROM #dsn3_alias#.ACCOUNTS WHERE ACCOUNT_ID = #get_pos_old.ACTION_TO_ACCOUNT_ID#
</cfquery>
<cfscript>
	action_to_account_id_first = GET_ACC_BRANCH.ACCOUNT_ID;
	account_currency_id = GET_ACC_BRANCH.ACCOUNT_CURRENCY_ID;
	payment_type_id = get_pos_old.PAYMENT_TYPE_ID;
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
	<cfset commission_multiplier_amount = wrk_round(get_pos_old.SALES_CREDIT * GET_CREDIT_PAYMENT.SERVICE_RATE /100)>
<cfelse>
	<cfset commission_multiplier_amount = 0>
</cfif>
<cfset credit_currency_multiplier = ''>
<cfoutput query="get_money_bskt">
	<cfif get_money_bskt.money is session.ep.money>
		<cfset credit_currency_multiplier = get_money_bskt.rate2/ get_money_bskt.rate1>
	</cfif>
	<cfif get_money_bskt.money is account_currency_id>
		<cfset credit_currency_multiplier2 = get_money_bskt.rate2/ get_money_bskt.rate1>
	</cfif>
</cfoutput>
<cfif is_account eq 1>
	<cfif len(get_pos_old.action_from_company_id)>
		<cfset MY_ACC_RESULT = GET_COMPANY_PERIOD(get_pos_old.action_from_company_id)>
	<cfelseif len(get_pos_old.consumer_id)>
		<cfset MY_ACC_RESULT = GET_CONSUMER_PERIOD(get_pos_old.consumer_id)>
	</cfif>
	<cfif not len(MY_ACC_RESULT)>
		<script type="text/javascript">
			alert("<cf_get_lang no ='126.Seçtiğiniz Üyenin Muhasebe Kodu Seçilmemiş'>!");
			history.back();	
		</script>
		<cfabort>
	</cfif>
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
			CONSUMER_ID,
			STORE_REPORT_DATE,
			SALES_CREDIT,
			COMMISSION_AMOUNT,
			ACTION_TYPE,
			OTHER_CASH_ACT_VALUE,
			OTHER_MONEY,
			IS_ACCOUNT,
			IS_ACCOUNT_TYPE,
			ACTION_PERIOD_ID,
			RECORD_EMP,
			RECORD_DATE,
			RECORD_IP,
			TO_BRANCH_ID,
			PAPER_NO
		)
		VALUES
		(
			0,
			245,
			'#wrk_id#',
			#payment_type_id#,
			<cfif len(get_credit_payment.number_of_instalment)>#get_credit_payment.number_of_instalment#,<cfelse>NULL,</cfif>
			#action_to_account_id_first#,
			'#account_currency_id#',
			<cfif len(get_pos_old.action_from_company_id)>#get_pos_old.action_from_company_id#,<cfelse>NULL,</cfif>
			<cfif len(get_pos_old.consumer_id)>#get_pos_old.consumer_id#,<cfelse>NULL,</cfif>
			#action_date#,
			#get_pos_old.sales_credit#,
			#commission_multiplier_amount#,
			'KREDİ KARTI TAHSİLAT İPTAL',
			#get_pos_old.other_cash_act_value#,
			'#get_pos_old.other_money#',
			<cfif is_account eq 1>1,13,<cfelse>0,13,</cfif>
			#session.ep.period_id#,
			#session.ep.userid#,
			#now()#,
			'#cgi.remote_addr#',
			#ListGetAt(session.ep.user_location,2,"-")#,
			'#attributes.head#'		
		)
</cfquery>
<cfoutput query="get_money_bskt">
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
				'#get_money_bskt.money#',
				#rate2#,
				#rate1#,
				<cfif get_money_bskt.money is account_currency_id>1<cfelse>0</cfif>
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
	cari_sil(action_id:get_payroll_actions.action_id,process_type:241);//ödeme sözünün cari hareketleri siliniyor
	if(is_account eq 1)
	{
		borclu_hesaplar = '';
		borclu_tutarlar = '';
		other_amount_borc_list='';
		other_currency_borc_list='';
		for(i=1; i lte get_closed_voucher.recordcount; i=i+1)
		{
			get_voucher = cfquery(datasource:"#dsn2#",sqlstring:"SELECT * FROM VOUCHER WHERE VOUCHER_ID= #get_closed_voucher.ACTION_ID[i]#");
			borclu_tutarlar=listappend(borclu_tutarlar,get_closed_voucher.CLOSED_AMOUNT[i],',');
			other_currency_borc_list = listappend(other_currency_borc_list,session.ep.money,',');
			other_amount_borc_list =  listappend(other_amount_borc_list,get_closed_voucher.CLOSED_AMOUNT[i],',');
			if(get_closed_voucher.IS_VOUCHER_DELAY[i] eq 1 and len(exp_acc_code))
			{
				borclu_hesaplar=listappend(borclu_hesaplar,exp_acc_code, ',');
			}
			else
			{
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
							VH.VOUCHER_ID=#get_closed_voucher.ACTION_ID[i]#");
					borclu_hesaplar=listappend(borclu_hesaplar, GET_VOUCHER_ACC_CODE.A_VOUCHER_ACC_CODE, ',');
				}
				else
					borclu_hesaplar=listappend(borclu_hesaplar, MY_ACC_RESULT, ',');
			}
		}
		if(get_pos_old.cari_action_value gt 0)
		{
			borclu_tutarlar=listappend(borclu_tutarlar,get_pos_old.cari_action_value,',');
			other_currency_borc_list = listappend(other_currency_borc_list,session.ep.money,',');
			other_amount_borc_list =  listappend(other_amount_borc_list,get_pos_old.cari_action_value,',');
			borclu_hesaplar=listappend(borclu_hesaplar,MY_ACC_RESULT, ',');
		}
		str_card_detail = '#attributes.head# (TAHSİLAT iPTAL)';
		if(account_currency_id is session.ep.money)
		{
			muhasebeci (
				action_id: MAX_ID.IDENTITYCOL,
				workcube_process_type: 245,
				process_cat : get_pos_process_cat.process_cat_id,
				account_card_type: 13,
				company_id : get_pos_old.action_from_company_id,
				consumer_id : get_pos_old.consumer_id,
				islem_tarihi: action_date,
				fis_satir_detay: 'KREDİ KARTI TAHSİLAT İPTAL',
				borc_hesaplar: borclu_hesaplar,
				borc_tutarlar: borclu_tutarlar,
				alacak_hesaplar: GET_CREDIT_PAYMENT.account_code,
				alacak_tutarlar: get_pos_old.sales_credit,
				belge_no : attributes.head,
				fis_detay: 'KREDİ KARTI TAHSİLAT İPTAL',
				to_branch_id : to_branch_id,
				fis_satir_detay: str_card_detail,
				is_account_group : is_account_group
				);		
		}
		else
		{
			muhasebeci (
				action_id: MAX_ID.IDENTITYCOL,
				workcube_process_type: 245,
				process_cat : get_pos_process_cat.process_cat_id,
				account_card_type: 13,
				company_id : get_pos_old.action_from_company_id,
				consumer_id : get_pos_old.consumer_id,
				islem_tarihi: action_date,
				fis_satir_detay: 'KREDİ KARTI TAHSİLAT İPTAL',
				borc_hesaplar:  borclu_hesaplar,
				borc_tutarlar: borclu_tutarlar,
				other_amount_borc : other_amount_borc_list,
				other_currency_borc : other_currency_borc_list,
				alacak_hesaplar: GET_CREDIT_PAYMENT.account_code,
				alacak_tutarlar: get_pos_old.sales_credit,
				other_amount_alacak : get_pos_old.other_cash_act_value,
				other_currency_alacak : account_currency_id,
				belge_no : attributes.head,
				fis_detay: 'KREDİ KARTI TAHSİLAT İPTAL',
				to_branch_id : to_branch_id,
				fis_satir_detay: str_card_detail,
				is_account_group : is_account_group
				);		
		}
	}
</cfscript>
