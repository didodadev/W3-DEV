<!--- toplu provizyon import lardan gelen kredi kartı tahsilatları için include sayfadır
transaction vs ön sayfadadır
Ayşenur 20060427 --->		
<cfquery name="ADD_CC_BANK_PAY" datasource="#dsn2#" result="MAX_ID">
	INSERT INTO 
		#dsn3_alias#.CREDIT_CARD_BANK_PAYMENTS
		(
			WRK_ID,
			ACTION_CURRENCY_ID,
			ACTION_TO_ACCOUNT_ID,
			ACTION_FROM_COMPANY_ID,
			ACTION_TYPE,
			PROCESS_CAT,
			ACTION_TYPE_ID,
			PAYMENT_TYPE_ID,
			STORE_REPORT_DATE,
			SALES_CREDIT,
			COMMISSION_AMOUNT,
			NUMBER_OF_INSTALMENT,
			OTHER_MONEY,
			OTHER_CASH_ACT_VALUE,
			ACTION_DETAIL,
			RECORD_EMP,
			RECORD_DATE,
			RECORD_IP,
			CARD_NO,
			IS_ACCOUNT,
			IS_ACCOUNT_TYPE,
			CONSUMER_ID,
			FILE_IMPORT_ID,
			ACTION_PERIOD_ID,
			TO_BRANCH_ID
		)
		VALUES
		( 
			'#wrk_id#',
			'#account_currency_id#',
			#action_to_account_id_first#,
			<cfif len(GET_SUBSCRIPTION_DETAIL.COMPANY_ID)>#GET_SUBSCRIPTION_DETAIL.COMPANY_ID#,<cfelse>NULL,</cfif>
			'KREDİ KARTI TAHSİLAT(T.P)',
			#attributes.process_cat#,
			#process_type#,
			#payment_type_id#,
			#islem_tarihi#,
			#val(nettotal)#,
			0,
			1,
			'#session.ep.money2#',
			<cfif len(currency_multiplier)>#wrk_round(val(nettotal)/currency_multiplier)#,<cfelse>NULL,</cfif>
			<cfif isdefined("attributes.action_detail") and len(attributes.action_detail)>'#attributes.action_detail#',<cfelse>NULL,</cfif>
			#session.ep.userid#,
			#now()#,
			'#cgi.remote_addr#',
			'#content#',
			<cfif is_account eq 1>1,13,<cfelse>0,13,</cfif>
			<cfif len(GET_SUBSCRIPTION_DETAIL.CONSUMER_ID)>#GET_SUBSCRIPTION_DETAIL.CONSUMER_ID#,<cfelse>NULL,</cfif>
			#attributes.i_id#,
			#session.ep.period_id#,
			#ListGetAt(session.ep.user_location,2,"-")#
		)
</cfquery>
<cfquery name="PAYMENT_ROWS" datasource="#dsn2#">
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
			#islem_tarihi#,
			#islem_tarihi#,
			#MAX_ID.IDENTITYCOL#,
			#payment_type_id#,
			'Peşin Giriş',
			#val(nettotal)#,
			0
		)
</cfquery>
<cfscript>
	if(is_cari eq 1)
	{
		carici
		(
			action_id : MAX_ID.IDENTITYCOL,
			action_table : 'CREDIT_CARD_BANK_PAYMENTS',
			workcube_process_type : process_type,		
			process_cat : form.process_cat,	
			islem_tarihi : islem_tarihi,
			due_date : islem_tarihi,
			to_account_id : action_to_account_id_first,
			to_branch_id : to_branch_id,
			islem_tutari : val(nettotal),
			action_currency : session.ep.money,
			other_money_value : iif(len(currency_multiplier),'#wrk_round(val(nettotal)/currency_multiplier)#',de('')),
			other_money : session.ep.money2,
			islem_detay : 'KREDİ KARTI TAHSİLAT(T.P)',
			action_detail : attributes.action_detail,
			account_card_type : 13,
			currency_multiplier : currency_multiplier,
			from_cmp_id : iif(len(GET_SUBSCRIPTION_DETAIL.COMPANY_ID),de('#GET_SUBSCRIPTION_DETAIL.COMPANY_ID#'),de('')),
			from_consumer_id : iif(len(GET_SUBSCRIPTION_DETAIL.CONSUMER_ID),de('#GET_SUBSCRIPTION_DETAIL.CONSUMER_ID#'),de('')),
			rate2:currency_multiplier
		);
	}

	if (is_account eq 1)
	{
		GET_ACC_CODE = cfquery(datasource:"#dsn2#",sqlstring:"SELECT ACCOUNT_CODE FROM #dsn3_alias#.CREDITCARD_PAYMENT_TYPE WHERE PAYMENT_TYPE_ID = #payment_type_id#");
			if (isDefined("attributes.ACTION_DETAIL") and len(attributes.ACTION_DETAIL))
				str_card_detail = '#attributes.ACTION_DETAIL#';
			else
				str_card_detail = 'KREDİ KARTI TAHSİLAT(T.P)';
			muhasebeci 
			(
				wrk_id : wrk_id,
				action_id: MAX_ID.IDENTITYCOL,
				workcube_process_type: process_type,
				workcube_process_cat:form.process_cat,
				account_card_type: 13,
				islem_tarihi: islem_tarihi,
				company_id : iif(len(GET_SUBSCRIPTION_DETAIL.COMPANY_ID),de('#GET_SUBSCRIPTION_DETAIL.COMPANY_ID#'),de('')),
				consumer_id : iif(len(GET_SUBSCRIPTION_DETAIL.CONSUMER_ID),de('#GET_SUBSCRIPTION_DETAIL.CONSUMER_ID#'),de('')),
				fis_satir_detay: str_card_detail,
				borc_hesaplar: get_acc_code.account_code,
				borc_tutarlar: val(nettotal),
				other_amount_borc : val(nettotal),//bankanın para biriminden çalışack, tahsilatlarda zaten sadece sistem para birimi çalışır
				other_currency_borc : session.ep.money,
				alacak_hesaplar: MY_ACC_RESULT,
				alacak_tutarlar: val(nettotal),
				other_amount_alacak : iif(len(currency_multiplier),'#wrk_round(val(nettotal)/currency_multiplier)#',de('')),
				other_currency_alacak : session.ep.money2,
				currency_multiplier : currency_multiplier,
				to_branch_id : to_branch_id,
				fis_detay: 'KREDİ KARTI TAHSİLAT(T.P)'
			);
	}
</cfscript>
<cfif GET_MONEY_INFO.recordcount>
	<cfoutput query="GET_MONEY_INFO">
		<cfquery name="INSERT_MONEY_INFO" datasource="#dsn2#">
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
				'#GET_MONEY_INFO.MONEY#',
				#GET_MONEY_INFO.RATE2#,
				#GET_MONEY_INFO.RATE1#,
				<cfif GET_MONEY_INFO.MONEY eq session.ep.money2>1<cfelse>0</cfif>
			)
		</cfquery>
	</cfoutput>
</cfif>
<cfquery name="get_cari_rows" datasource="#dsn2#">
	SELECT CARI_ACTION_ID,ACTION_TYPE_ID,ACTION_ID,ACTION_TABLE FROM CARI_ROWS WHERE ACTION_ID = #MAX_ID.IDENTITYCOL# AND ACTION_TYPE_ID = #process_type#
</cfquery>
<cfif get_cari_rows.recordcount>
	<cfset cari_act_id_inf = get_cari_rows.cari_action_id>
<cfelse>
	<cfset cari_act_id_inf = ''>
</cfif>
