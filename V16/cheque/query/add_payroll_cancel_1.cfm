<cfquery name="get_cash_process_cat" datasource="#dsn2#" maxrows="1">
	SELECT IS_ACCOUNT,IS_CARI,IS_ACCOUNT_GROUP,PROCESS_CAT_ID FROM #dsn3_alias#.SETUP_PROCESS_CAT WHERE PROCESS_TYPE = 32
</cfquery>
<cfif get_cash_process_cat.recordcount eq 0>
	<script type="text/javascript">
		alert("Lütfen Kasa Ödeme İşlem Kategorilerinizi Tanımlayınız !");
		window.close();
	</script>
	<cfabort>
</cfif>
<cfquery name="get_cash_old" datasource="#dsn2#">
	SELECT * FROM CASH_ACTIONS WHERE ACTION_ID = #get_payroll_actions.action_id#
</cfquery>
<cfquery name="get_cash_code" datasource="#dsn2#">
	SELECT CASH_ACC_CODE,BRANCH_ID FROM CASH WHERE CASH_ID=#get_cash_old.cash_action_to_cash_id#
</cfquery>
<cfif len(get_cash_code.BRANCH_ID)>
	<cfset cash_branch_id = get_cash_code.BRANCH_ID>
<cfelse>
	<cfset cash_branch_id = ''>
</cfif>
<cfquery name="add_cash_action" datasource="#dsn2#">
	INSERT INTO 
		CASH_ACTIONS
		(
			CASH_ACTION_FROM_CASH_ID,
			ACTION_TYPE,
			ACTION_TYPE_ID,
			<cfif len(get_cash_old.cash_action_from_company_id)>
				CASH_ACTION_TO_COMPANY_ID,
			<cfelse>
				CASH_ACTION_TO_CONSUMER_ID,
			</cfif>
			CASH_ACTION_VALUE,
			CASH_ACTION_CURRENCY_ID,
			OTHER_CASH_ACT_VALUE,
			OTHER_MONEY,				
			ACTION_DATE,
			ACTION_DETAIL,
			PAPER_NO,
			IS_ACCOUNT,
			IS_ACCOUNT_TYPE,
			REVENUE_COLLECTOR_ID,
			RECORD_EMP,
			RECORD_IP,
			RECORD_DATE,
			PROCESS_CAT,
			ACTION_VALUE,
			ACTION_CURRENCY_ID
			<cfif len(session.ep.money2)>
				,ACTION_VALUE_2
				,ACTION_CURRENCY_ID_2
			</cfif>
		)
	VALUES
		(
			#get_cash_old.cash_action_to_cash_id#,
			'ÖDEME',
			32,
			<cfif len(get_cash_old.cash_action_from_company_id)>
				#get_cash_old.cash_action_from_company_id#,
			<cfelse>
				#get_cash_old.cash_action_from_consumer_id#,
			</cfif>
			#get_cash_old.cash_action_value#,
			'#get_cash_old.cash_action_currency_id#',
			#get_cash_old.other_cash_act_value#,
			'#get_cash_old.other_money#',
			#action_date#,
			'#attributes.head# (TAHSİLAT iPTAL)',
			'#attributes.head#',
			<cfif is_account eq 1>
				1,
				12,
			<cfelse>
				0,
				12,
			</cfif>
			#SESSION.EP.USERID#,
			#SESSION.EP.USERID#,
			'#CGI.REMOTE_ADDR#',
			#NOW()#,
			0,
			#get_cash_old.action_value#,
			'#session.ep.money#'
			<cfif len(session.ep.money2)>
				,#get_cash_old.action_value_2#
				,'#session.ep.money2#'
			</cfif>
		)
</cfquery>
<cfquery name="get_act_id" datasource="#dsn2#">
	SELECT MAX(ACTION_ID) AS ACT_ID	FROM CASH_ACTIONS
</cfquery>
<cfset act_id=get_act_id.act_id>
<cfscript>
	cari_sil(action_id:get_payroll_actions.action_id,process_type:31);//ödeme sözünün cari hareketleri siliniyor
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
			if(get_closed_voucher.IS_VOUCHER_DELAY eq 1 and len(exp_acc_code))
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
		muhasebeci(
			action_id : ACT_ID,
			workcube_process_type : 32,
			account_card_type : 12, 
			company_id : get_cash_old.cash_action_from_company_id,
			consumer_id : get_cash_old.cash_action_from_consumer_id,
			islem_tarihi : action_date,
			borc_hesaplar : borclu_hesaplar,
			borc_tutarlar : borclu_tutarlar,
			other_amount_borc : other_amount_borc_list,
			other_currency_borc : other_currency_borc_list,
			alacak_hesaplar : get_cash_code.cash_acc_code,
			alacak_tutarlar : get_cash_old.cash_action_value,
			other_amount_alacak : get_cash_old.other_cash_act_value,
			other_currency_alacak : get_cash_old.other_money,
			to_branch_id :iif(len(cash_branch_id),de('#cash_branch_id#'),de('')),
			fis_detay: 'ÖDEME',
			fis_satir_detay: str_card_detail,
			belge_no : attributes.head,
			is_account_group : is_account_group
			);
	}
</cfscript>		
