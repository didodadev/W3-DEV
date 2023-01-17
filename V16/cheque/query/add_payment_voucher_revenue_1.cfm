<cfset cash_currency_rate = 1>
<cfquery name="get_cash_code" datasource="#dsn2#">
	SELECT CASH_ACC_CODE,BRANCH_ID,DUE_DIFF_ACC_CODE FROM CASH WHERE CASH_ID=#listfirst(attributes.kasa,';')#
</cfquery>
<cfif len(get_cash_code.BRANCH_ID)>
	<cfset cash_branch_id = get_cash_code.BRANCH_ID>
<cfelse>
	<cfset cash_branch_id = ''>
</cfif>
<cfquery name="get_cash_process_cat" datasource="#dsn2#" maxrows="1">
	SELECT IS_ACCOUNT,IS_CARI,IS_ACCOUNT_GROUP,PROCESS_CAT_ID FROM #dsn3_alias#.SETUP_PROCESS_CAT WHERE PROCESS_TYPE = 31
</cfquery>
<cfquery name="ADD_BORDRO_TO_CASH" datasource="#dsn2#" result="MAX_ID">
	INSERT INTO
		CASH_ACTIONS
		(
			PROCESS_CAT,
			PAPER_NO,
			ACTION_TYPE,
			ACTION_TYPE_ID,
			CASH_ACTION_VALUE,
			CASH_ACTION_CURRENCY_ID,
			CASH_ACTION_FROM_COMPANY_ID,
			CASH_ACTION_FROM_CONSUMER_ID,
			CASH_ACTION_TO_CASH_ID,
			ACTION_DATE,
			OTHER_CASH_ACT_VALUE,
			OTHER_MONEY,
			REVENUE_COLLECTOR_ID,
			ACTION_DETAIL,
			IS_ACCOUNT,
			IS_ACCOUNT_TYPE,
			RECORD_EMP,
			RECORD_IP,
			RECORD_DATE,
			ACTION_VALUE,
			ACTION_CURRENCY_ID,
			VOUCHER_ID
			<cfif len(session.ep.money2)>
				,ACTION_VALUE_2
				,ACTION_CURRENCY_ID_2
			</cfif>
		)
		VALUES
		(
			0,
			'#PAPER#',
			'NAKİT TAHSİLAT',
			31,
			#attributes.cash_amount#,
			'#attributes.CURRENCY_TYPE#',
			<cfif len(attributes.company_id)>#attributes.company_id#<cfelse>NULL</cfif>,
			<cfif len(attributes.consumer_id)>#attributes.consumer_id#<cfelse>NULL</cfif>,
			#listfirst(attributes.kasa,';')#,
			#action_date#,
			#attributes.system_total_amounts#,
			'#session.ep.money#',				
			#session.ep.userid#,
			'SENET TAHSİLAT İŞLEMİ',
			<cfif is_account eq 1>1<cfelse>0</cfif>,
			11,
			#SESSION.EP.USERID#,
			'#CGI.REMOTE_ADDR#',
			#NOW()#,
			#attributes.cash_amount#,
			'#session.ep.money#',
			#p_id#
			<cfif len(session.ep.money2)>
				,#wrk_round(attributes.cash_amount/currency_multiplier,4)#
				,'#session.ep.money2#'
			</cfif>
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
			#P_ID#,
			#MAX_ID.IDENTITYCOL#,
			31
		)
</cfquery>
<!---makbuz no kontrol edilip update edilecek--->
<cfquery name="CHK_PAPER_NO" datasource="#dsn2#">
	UPDATE
		#dsn3_alias#.PAPERS_NO
	SET
		REVENUE_RECEIPT_NUMBER=#FORM.PAPER_NUMBER#
	WHERE
		<cfif isdefined('attributes.paper_printer_id') and len(attributes.paper_printer_id)>
			PRINTER_ID = #attributes.paper_printer_id#
		<cfelse>
			EMPLOYEE_ID = #session.ep.userid#
		</cfif>
</cfquery>
<cfscript>
	if(is_cari eq 1 and total_pay_term_value gt 0)//eğer ödeme sözü varsa cari işlem yapılıyor
	{
		carici(
				action_id :MAX_ID.IDENTITYCOL,
				workcube_process_type : 31,
				process_cat : 0,
				account_card_type :11,
				action_table :'CASH_ACTIONS',
				islem_tarihi : action_date,
				islem_tutari : attributes.system_total_amounts,
				islem_belge_no :PAPER,
				action_currency : session.ep.money,
				to_cash_id : listfirst(attributes.kasa,';'),
				from_cmp_id : attributes.company_id,
				from_consumer_id : attributes.consumer_id,
				revenue_collector_id :session.ep.userid,
				other_money_value : attributes.system_total_amounts,
				other_money : session.ep.money,
				action_detail : 'ÖDEME SÖZÜ TAHSİLAT İŞLEMİ',
				currency_multiplier : currency_multiplier,
				islem_detay : 'NAKİT TAHSİLAT',
				to_branch_id : cash_branch_id
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
		GET_ACC_CODE = cfquery(datasource:"#dsn2#",sqlstring:"SELECT CASH_ACC_CODE FROM CASH WHERE CASH_ID=#listfirst(attributes.kasa,';')#");
		acc = GET_ACC_CODE.CASH_ACC_CODE;
		satir_detay_list = ArrayNew(2);
		for(jj=1; jj lte attributes.record_num; jj=jj+1)
		{
			if (listfind('1,11',evaluate("attributes.voucher_status_#jj#")) and isdefined("attributes.is_pay_#jj#") and listfind(attributes.voucher_ids_2,evaluate("attributes.voucher_id_#jj#"),','))
			{
				senet_tutar = evaluate("attributes.system_total_amounts");			
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
				borclu_hesaplar=listappend(borclu_hesaplar,GET_ACC_CODE.CASH_ACC_CODE,',');
				borclu_tutarlar=listappend(borclu_tutarlar,attributes.system_total_amounts,',');
				other_amount_borc_list = listappend(other_amount_borc_list,attributes.cash_amount,',');
				other_currency_borc_list = listappend(other_currency_borc_list,'#get_voucher.currency_id#',',');
				satir_detay_list[1][1] = 'SENET TAHSİLAT İŞLEMİ';
			}
		}
		muhasebeci (
			action_id:MAX_ID.IDENTITYCOL,
			workcube_process_type:31,
			account_card_type:11,
			company_id : attributes.company_id,
			consumer_id : attributes.consumer_id,
			action_table :'CASH_ACTIONS',
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
			fis_detay:'NAKİT TAHSİLAT',
			fis_satir_detay: satir_detay_list,
			belge_no : PAPER,
			from_branch_id : cash_branch_id,
			is_account_group : is_account_group
			);
	}
</cfscript>

