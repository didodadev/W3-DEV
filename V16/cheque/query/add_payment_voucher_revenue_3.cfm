<cfquery name="GET_ACCOUNTS" datasource="#DSN2#">
	SELECT 
		<cfif session.ep.period_year lt 2009>
			CASE WHEN(ACCOUNTS.ACCOUNT_CURRENCY_ID = 'TL') THEN 'YTL' ELSE ACCOUNTS.ACCOUNT_CURRENCY_ID END AS  ACCOUNT_CURRENCY_ID,
		<cfelse>
			ACCOUNTS.ACCOUNT_CURRENCY_ID,
		</cfif>
		ACCOUNT_ACC_CODE
	FROM
		#dsn3_alias#.ACCOUNTS
	WHERE
		ACCOUNT_ID = #listfirst(attributes.action_to_account_id,';')#
</cfquery>
<cfset to_branch_id = listlast(attributes.action_to_account_id,';')>
<cfquery name="get_bank_process_cat" datasource="#dsn2#" maxrows="1">
	SELECT IS_ACCOUNT,IS_CARI,IS_ACCOUNT_GROUP,PROCESS_CAT_ID FROM #dsn3_alias#.SETUP_PROCESS_CAT WHERE PROCESS_TYPE = 24
</cfquery>
<cfquery name="ADD_GELENH" datasource="#DSN2#">
	INSERT INTO
		BANK_ACTIONS
	(
		ACTION_TYPE,
		PROCESS_CAT,
		ACTION_TYPE_ID,
		ACTION_FROM_COMPANY_ID,
		ACTION_FROM_CONSUMER_ID,
		ACTION_TO_ACCOUNT_ID,
		ACTION_VALUE,
		ACTION_DATE,
		ACTION_CURRENCY_ID,
		ACTION_DETAIL,
		OTHER_CASH_ACT_VALUE,
		OTHER_MONEY,
		IS_ACCOUNT,
		IS_ACCOUNT_TYPE,
		PAPER_NO,
		RECORD_EMP,
		RECORD_IP,
		RECORD_DATE,
		TO_BRANCH_ID,
		SYSTEM_ACTION_VALUE,
		VOUCHER_PAYROLL_ID,
		SYSTEM_CURRENCY_ID
		<cfif len(session.ep.money2)>
			,ACTION_VALUE_2
			,ACTION_CURRENCY_ID_2
		</cfif>
	)
	VALUES
	(
		'GELEN HAVALE',
		0,
		24,
		<cfif len(attributes.company_id)>#attributes.company_id#<cfelse>NULL</cfif>,
		<cfif len(attributes.consumer_id)>#attributes.consumer_id#<cfelse>NULL</cfif>,
		#listfirst(attributes.action_to_account_id,';')#,
		#attributes.bank_amount#,
		#action_date#,
		'#GET_ACCOUNTS.ACCOUNT_CURRENCY_ID#',
		'SENET TAHSİLAT İŞLEMİ',
		#attributes.system_bank_amount#,
		'#session.ep.money#',
		<cfif is_account eq 1>1<cfelse>0</cfif>,
		13,
		'#my_payroll_no#',
		#SESSION.EP.USERID#,
		'#CGI.REMOTE_ADDR#',
		#NOW()#,
		#listgetat(session.ep.user_location,2,'-')#	,
		#attributes.bank_amount#,
		#p_id#,
		'#session.ep.money#'
		<cfif len(session.ep.money2)>
			,#wrk_round(attributes.bank_amount/currency_multiplier,4)#
			,'#session.ep.money2#'
		</cfif>		
	)
</cfquery>
<cfquery name="GET_ACT_ID" datasource="#dsn2#">
	SELECT MAX(ACTION_ID) AS ACTION_ID FROM BANK_ACTIONS
</cfquery>
<cfquery name="ADD_REL_ACT" datasource="#dsn2#">
	INSERT INTO
		VOUCHER_PAYROLL_ACTIONS
		(
			PAYROLL_ID,
			ACTION_ID,
			ACTION_TYPE_ID
		)
		VALUES
		(
			#P_ID#,
			#GET_ACT_ID.ACTION_ID#,
			24
		)
</cfquery>
<cfscript>
	if(is_cari eq 1 and total_pay_term_value gt 0)//eğer ödeme sözü varsa cari işlem yapılıyor
	{
		carici(
				action_id : GET_ACT_ID.ACTION_ID,
				action_table : 'BANK_ACTIONS',
				workcube_process_type : 24,		
				process_cat : 0,	
				islem_tarihi : action_date,
				to_account_id : listfirst(attributes.action_to_account_id,';'),
				islem_tutari : attributes.system_bank_amount,
				action_currency : session.ep.money,
				other_money_value : attributes.system_bank_amount,
				other_money : session.ep.money,
				currency_multiplier : currency_multiplier,
				islem_detay : 'GELEN HAVALE',
				action_detail : 'SENET TAHSİLAT İŞLEMİ',
				account_card_type : 13,
				due_date: action_date,
				from_cmp_id : attributes.company_id,
				from_consumer_id : attributes.consumer_id,
				to_branch_id : listgetat(session.ep.user_location,2,'-')
				);
	}
	if(is_account eq 1)
	{
		alacakli_hesaplar = '';
		alacakli_tutarlar = '';
		other_amount_alacak_list = '';
		other_currency_alacak_list = '';
		borclu_hesaplar = '';
		borclu_tutarlar = '';
		other_amount_borc_list='';
		other_currency_borc_list='';
		GET_ACC_CODE = cfquery(datasource:"#dsn2#",sqlstring:"SELECT ACCOUNT_ACC_CODE FROM #dsn3_alias#.ACCOUNTS WHERE ACCOUNT_ID = #listfirst(attributes.action_to_account_id,';')#");
		acc = GET_ACC_CODE.ACCOUNT_ACC_CODE;
		satir_detay_list = ArrayNew(2);
		for(jj=1; jj lte attributes.record_num; jj=jj+1)
		{
			if (listfind('1,11',evaluate("attributes.voucher_status_#jj#")) and isdefined("attributes.is_pay_#jj#") and listfind(attributes.voucher_ids_2,evaluate("attributes.voucher_id_#jj#"),','))
			{
				senet_tutar = evaluate("attributes.system_bank_amount");
				get_voucher = cfquery(datasource:"#dsn2#",sqlstring:"SELECT * FROM VOUCHER WHERE VOUCHER_ID= #evaluate("attributes.voucher_id_#jj#")#");
				alacakli_tutarlar=listappend(alacakli_tutarlar,senet_tutar,',');
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
					satir_detay_list[2][listlen(alacakli_tutarlar)] = '#attributes.company# - #dateformat(now(),dateformat_style)# VADELİ SENET TAHSİL İŞLEMİ';
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
		borclu_hesaplar=listappend(borclu_hesaplar,GET_ACC_CODE.ACCOUNT_ACC_CODE,',');
		borclu_tutarlar=listappend(borclu_tutarlar,attributes.system_bank_amount,',');
		other_amount_borc_list = listappend(other_amount_borc_list,attributes.bank_amount,',');
		other_currency_borc_list = listappend(other_currency_borc_list,'#get_voucher.currency_id#',',');
		satir_detay_list[1][1] = 'SENET TAHSİLAT İŞLEMİ';
		muhasebeci (
			action_id:GET_ACT_ID.ACTION_ID,
			belge_no : my_payroll_no,
			workcube_process_type:24,
			company_id : attributes.company_id,
			consumer_id : attributes.consumer_id,
			account_card_type:13,
			action_table :'BANK_ACTIONS',
			islem_tarihi: action_date,
			borc_hesaplar: borclu_hesaplar,
			borc_tutarlar: borclu_tutarlar,
			other_amount_borc: other_amount_borc_list,
			other_currency_borc: other_currency_borc_list,
			alacak_hesaplar: alacakli_hesaplar,
			alacak_tutarlar: alacakli_tutarlar,
			other_amount_alacak: other_amount_alacak_list,
			other_currency_alacak: other_currency_alacak_list,
			currency_multiplier : currency_multiplier,
			fis_detay:'GELEN HAVALE',
			fis_satir_detay:satir_detay_list,
			to_branch_id : to_branch_id,
			is_account_group : is_account_group
			);
	}
</cfscript>

