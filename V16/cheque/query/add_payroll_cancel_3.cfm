<cfquery name="get_bank_process_cat" datasource="#dsn2#" maxrows="1">
	SELECT IS_ACCOUNT,IS_CARI,IS_ACCOUNT_GROUP,PROCESS_CAT_ID FROM #dsn3_alias#.SETUP_PROCESS_CAT WHERE PROCESS_TYPE = 25
</cfquery>
<cfif get_bank_process_cat.recordcount eq 0>
	<script type="text/javascript">
		alert("Lütfen Giden Havale İşlem Kategorilerinizi Tanımlayınız !");
		window.close();
	</script>
	<cfabort>
</cfif>
<cfquery name="get_bank_old" datasource="#dsn2#">
	SELECT * FROM BANK_ACTIONS WHERE ACTION_ID = #get_payroll_actions.action_id#
</cfquery>
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
		ACCOUNT_ID = #get_bank_old.ACTION_TO_ACCOUNT_ID#
</cfquery>
<cfquery name="ADD_GELENH" datasource="#DSN2#">
	INSERT INTO
		BANK_ACTIONS
	(
		ACTION_TYPE,
		PROCESS_CAT,
		ACTION_TYPE_ID,
		ACTION_TO_COMPANY_ID,
		ACTION_TO_CONSUMER_ID,
		ACTION_FROM_ACCOUNT_ID,
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
		FROM_BRANCH_ID,
		SYSTEM_ACTION_VALUE,
		SYSTEM_CURRENCY_ID
		<cfif len(session.ep.money2)>
			,ACTION_VALUE_2
			,ACTION_CURRENCY_ID_2
		</cfif>
	)
	VALUES
	(
		'GİDEN HAVALE',
		0,
		25,
		<cfif len(get_bank_old.action_from_company_id)>#get_bank_old.action_from_company_id#<cfelse>NULL</cfif>,
		<cfif len(get_bank_old.action_from_consumer_id)>#get_bank_old.action_from_consumer_id#<cfelse>NULL</cfif>,
		#get_bank_old.action_to_account_id#,
		#get_bank_old.action_value#,
		#action_date#,
		'#GET_ACCOUNTS.ACCOUNT_CURRENCY_ID#',
		'#attributes.head# (TAHSİLAT iPTAL)',
		#get_bank_old.other_cash_act_value#,
		'#get_bank_old.other_money#',
		<cfif is_account eq 1>1<cfelse>0</cfif>,
		13,
		'#attributes.head#',
		#SESSION.EP.USERID#,
		'#CGI.REMOTE_ADDR#',
		#NOW()#,
		#listgetat(session.ep.user_location,2,'-')#	,	
		#get_bank_old.system_action_value#,
		'#session.ep.money#'
		<cfif len(session.ep.money2)>
			,#get_bank_old.action_value_2#
			,'#session.ep.money2#'
		</cfif>	
	)
</cfquery>
<cfquery name="GET_ACT_ID" datasource="#dsn2#">
	SELECT MAX(ACTION_ID) AS ACTION_ID FROM BANK_ACTIONS
</cfquery>
<cfscript>
	cari_sil(action_id:get_payroll_actions.action_id,process_type:24);//ödeme sözünün cari hareketleri siliniyor
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
		str_card_detail = '#attributes.head# (TAHSİLAT iPTAL)';
		muhasebeci (
			action_id:GET_ACT_ID.ACTION_ID,
			belge_no : attributes.head,
			workcube_process_type:25,
			account_card_type:13,
			action_table :'BANK_ACTIONS',
			islem_tarihi: action_date,
			borc_hesaplar: borclu_hesaplar,
			borc_tutarlar: borclu_tutarlar,
			other_amount_borc: other_amount_borc_list,
			other_currency_borc: other_currency_borc_list,
			alacak_hesaplar: get_accounts.account_acc_code,
			alacak_tutarlar: get_bank_old.action_value,
			other_amount_alacak: get_bank_old.other_cash_act_value,
			other_currency_alacak: get_bank_old.other_money,
			fis_detay: 'GİDEN HAVALE',
			fis_satir_detay: str_card_detail,
			from_branch_id : listgetat(session.ep.user_location,2,'-'),
			is_account_group : is_account_group
			);
	}
</cfscript>

