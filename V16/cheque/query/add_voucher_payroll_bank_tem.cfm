<cfif form.active_period neq session.ep.period_id>
	<script type="text/javascript">
		alert("İşlem Yapmak İstediğiniz Muhasebe Dönemi ile Aktif Muhasebe Döneminiz Farklı Muhasebe Döneminizi Kontrol Ediniz!");
		wrk_opener_reload();
		window.close();
	</script>
	<cfabort>
</cfif>
<cf_get_lang_set module_name="cheque">
<cf_date tarih="attributes.PAYROLL_REVENUE_DATE">
<cf_date tarih='attributes.pyrll_avg_duedate'>
<cfquery name="get_process_type" datasource="#dsn3#">
	SELECT 
		PROCESS_TYPE,
		IS_ACCOUNT,
		IS_ACCOUNT_GROUP,
		IS_CHEQUE_BASED_ACTION
	 FROM 
	 	SETUP_PROCESS_CAT 
	WHERE 
		PROCESS_CAT_ID = #form.process_cat#
</cfquery>
<cfscript>
	process_type = get_process_type.PROCESS_TYPE;
	is_account = get_process_type.IS_ACCOUNT;
	is_account_group = get_process_type.IS_ACCOUNT_GROUP;
	is_voucher_based = get_process_type.IS_CHEQUE_BASED_ACTION;
	attributes.payroll_total = filterNum(attributes.payroll_total);
	attributes.other_payroll_total = filterNum(attributes.other_payroll_total);
	attributes.masraf = filterNum(attributes.masraf);
	for(ff=1; ff lte attributes.record_num; ff=ff+1)
	{
		if (evaluate("attributes.row_kontrol#ff#"))
		{
			'attributes.voucher_system_currency_value#ff#' = filterNum(evaluate("attributes.voucher_system_currency_value#ff#"));
			'attributes.voucher_value#ff#' = filterNum(evaluate("attributes.voucher_value#ff#"));
		}
	}
	for(rt = 1; rt lte attributes.kur_say; rt = rt + 1)
	{
		'attributes.txt_rate1_#rt#' = filterNum(evaluate('attributes.txt_rate1_#rt#'),session.ep.our_company_info.rate_round_num);
		'attributes.txt_rate2_#rt#' = filterNum(evaluate('attributes.txt_rate2_#rt#'),session.ep.our_company_info.rate_round_num);
	}
	if (isdefined("attributes.cash_id"))
		branch_id_info = ListGetAt(attributes.cash_id,2,";");
	else if(isdefined("attributes.branch_id") and len(attributes.branch_id))
		branch_id_info = attributes.branch_id;
	else
		branch_id_info = listgetat(session.ep.user_location,2,'-');
</cfscript>
<cfquery name="control_no" datasource="#dsn2#">
	SELECT ACTION_ID FROM VOUCHER_PAYROLL WHERE PAYROLL_NO = '#attributes.PAYROLL_NO#' 
</cfquery>
<cfif control_no.recordcount>
	<script type="text/javascript">
		alert("<cf_get_lang no='125.Aynı Bordro No ya Ait Kayıt Var !'>");
		history.back();
	</script>
	<cfabort>
</cfif>
<cflock name="#createUUID()#" timeout="60">
	<cftransaction>
		<!---/kasa  id leri aliniyor--->
		<cfquery name="ADD_REVENUE_TO_PAYROLL" datasource="#dsn2#">
			INSERT INTO
				VOUCHER_PAYROLL
				(
					PROCESS_CAT,
					PAYROLL_TYPE,
					PAYROLL_TOTAL_VALUE,
					PAYROLL_OTHER_MONEY,
					PAYROLL_OTHER_MONEY_VALUE,
					NUMBER_OF_VOUCHER,
					PAYROLL_ACCOUNT_ID,
					CURRENCY_ID,
					PAYROLL_REVENUE_DATE,
					PAYROLL_REV_MEMBER,
					PAYROLL_AVG_DUEDATE,
					PAYROLL_AVG_AGE,
					PAYROLL_NO,
					MASRAF,
					EXP_CENTER_ID,
					EXP_ITEM_ID,
					MASRAF_CURRENCY,
					RECORD_EMP,
					RECORD_IP,
					RECORD_DATE,
					VOUCHER_BASED_ACC_CARI,
					ACTION_DETAIL,
					BRANCH_ID,
					CONTRACT_ID,
					CREDIT_LIMIT
				)
				VALUES
				(
					#form.process_cat#,
					#process_type#,
					#attributes.payroll_total#,
					<cfif isdefined("attributes.basket_money") and len(attributes.basket_money)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.basket_money#">,<cfelse>NULL,</cfif>
					<cfif isdefined("attributes.other_payroll_total") and len(attributes.other_payroll_total)>#attributes.other_payroll_total#,<cfelse>NULL,</cfif>
					#attributes.voucher_num#,
					#attributes.account_id#,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money#">,
					#ATTRIBUTES.PAYROLL_REVENUE_DATE#,
					#EMPLOYEE_ID#,
					#attributes.pyrll_avg_duedate#,
					<cfif len(attributes.pyrll_avg_age)>#attributes.pyrll_avg_age#,<cfelse>NULL,</cfif>
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.PAYROLL_NO#">,
					<cfif attributes.masraf gt 0>#attributes.masraf#<cfelse>0</cfif>,
					<cfif isdefined("attributes.expense_center") and len(attributes.expense_center)>#attributes.expense_center#<cfelse>NULL</cfif>,
					<cfif isdefined("attributes.exp_item_id") and len(attributes.exp_item_id) and len(attributes.exp_item_name)>#attributes.exp_item_id#<cfelse>NULL</cfif>,
					<cfif len(attributes.masraf_currency)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.masraf_currency#"><cfelse>NULL</cfif>,
					#session.ep.userid#,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">,
					#NOW()#,
					<cfif len(is_voucher_based)>#is_voucher_based#<cfelse>0</cfif>,
					<cfif isDefined("attributes.action_detail") and len(attributes.action_detail)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.action_detail#"><cfelse>NULL</cfif>,
					#branch_id_info#,
					<cfif isdefined("attributes.contract_id") and len(attributes.contract_id) and len(attributes.contract_head)>#attributes.contract_id#<cfelse>NULL</cfif>,
					<cfif len(attributes.credit_limit_id) and len(attributes.credit_limit_name)>#attributes.credit_limit_id#<cfelse>NULL</cfif>
				)
		</cfquery>
		<!--- bordro cari tablosuna kaydedilecek--->
		<cfquery name="GET_BORDRO_ID" datasource="#dsn2#">
			SELECT MAX(ACTION_ID) AS P_ID FROM VOUCHER_PAYROLL
		</cfquery>
		<cfset P_ID = get_bordro_id.P_ID>
		<!--- senet durumları senet tablosundan update edilecek--->
		<cfset portfoy_no = get_cheque_no(belge_tipi:'voucher')>
		<cfloop from="1" to="#attributes.record_num#" index="i">
			<cfif evaluate("attributes.row_kontrol#i#")>
				<cf_date tarih='attributes.voucher_duedate#i#'>
				<cfif len(evaluate("attributes.voucher_id#i#")) and evaluate("attributes.voucher_id#i#") neq 0>
					<cfquery name="UPD_VOUCHERS" datasource="#dsn2#">
						UPDATE VOUCHER SET VOUCHER_STATUS_ID=13 WHERE VOUCHER_ID= #evaluate("attributes.voucher_id#i#")#
					</cfquery>
				<cfelse>
					<cfquery name="ADD_VOUCHER" datasource="#dsn2#">
						INSERT INTO
							VOUCHER(
								VOUCHER_PAYROLL_ID,
								VOUCHER_CODE,
								VOUCHER_DUEDATE,
								VOUCHER_NO,
								VOUCHER_VALUE,
								OTHER_MONEY_VALUE,
								OTHER_MONEY,
								OTHER_MONEY_VALUE2,
								OTHER_MONEY2,
								RECORD_DATE,
								RECORD_EMP,
								RECORD_IP,
								DEBTOR_NAME,
								VOUCHER_STATUS_ID,
								VOUCHER_CITY,
								VOUCHER_PURSE_NO,
								CURRENCY_ID,
								ACCOUNT_CODE
							)
							VALUES
							(
								#P_ID#,
								<cfif len(evaluate("attributes.voucher_code#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.voucher_code#i#")#'>,<cfelse>NULL,</cfif>
								#evaluate("attributes.voucher_duedate#i#")#,
								<cfif len(evaluate("attributes.voucher_no#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.voucher_no#i#")#'>,<cfelse>NULL,</cfif>
								#evaluate("attributes.voucher_value#i#")#,
								<cfif len(evaluate("attributes.voucher_system_currency_value#i#"))>#evaluate("attributes.voucher_system_currency_value#i#")#,<cfelse>NULL,</cfif>
								<cfif len(evaluate("attributes.system_money_info#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.system_money_info#i#")#'>,<cfelse>NULL,</cfif>
								<cfif len(evaluate("attributes.other_money_value2#i#"))>#evaluate("attributes.other_money_value2#i#")#,<cfelse>NULL,</cfif>
								<cfif len(evaluate("attributes.other_money2#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.other_money2#i#")#'>,<cfelse>NULL,</cfif>
								#NOW()#,
								#session.ep.userid#,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
								<cfif len(evaluate("attributes.debtor_name#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.debtor_name#i#")#'>,<cfelse>NULL,</cfif>
								13,
								<cfif len(evaluate("attributes.voucher_city#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.voucher_city#i#")#'>,<cfelse>NULL,</cfif>
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#portfoy_no#">,
								<cfif len(evaluate("attributes.currency_id#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.currency_id#i#")#'>,<cfelse>NULL,</cfif>
								<cfif len(evaluate("attributes.acc_code#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.acc_code#i#")#'><cfelse>NULL</cfif>
							)
					</cfquery>
				</cfif>
				<cfquery name="GET_LAST_ID" datasource="#dsn2#">
					SELECT MAX(VOUCHER_ID) AS VOUCHER_ID FROM VOUCHER
				</cfquery>
				<cfset portfoy_no = portfoy_no+1>
				<cfquery name="ADD_VOUCHER_HISTORY" datasource="#dsn2#">
					INSERT INTO
						VOUCHER_HISTORY
							(
								VOUCHER_ID,
								PAYROLL_ID,
								STATUS,
								ACT_DATE,
								OTHER_MONEY_VALUE,
								OTHER_MONEY,
								OTHER_MONEY_VALUE2,
								OTHER_MONEY2,
								RECORD_DATE
							)
						VALUES
							(
								<cfif len(evaluate("attributes.voucher_id#i#"))>#evaluate("attributes.voucher_id#i#")#,<cfelse>#GET_LAST_ID.VOUCHER_ID#,</cfif>
								#p_id#,
								13,
								#ATTRIBUTES.PAYROLL_REVENUE_DATE#,
								<cfif len(evaluate("attributes.voucher_system_currency_value#i#"))>#evaluate("attributes.voucher_system_currency_value#i#")#,<cfelse>NULL,</cfif>
								<cfif len(evaluate("attributes.system_money_info#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.system_money_info#i#")#'>,<cfelse>NULL,</cfif>
								<cfif len(evaluate("attributes.other_money_value2#i#"))>#evaluate("attributes.other_money_value2#i#")#,<cfelse>NULL,</cfif>
								<cfif len(evaluate("attributes.other_money2#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.other_money2#i#")#'>,<cfelse>NULL,</cfif>
								#NOW()#
							)
				</cfquery>
			</cfif>
		</cfloop>
		<cfset portfoy_no = get_cheque_no(belge_tipi:'voucher',belge_no:portfoy_no)>
		<cfquery name="GET_VOUCHERS_LAST" datasource="#dsn2#">
			SELECT 
				VOUCHER.* 
			FROM
				VOUCHER, 
				VOUCHER_HISTORY 
			WHERE
				VOUCHER.VOUCHER_ID=VOUCHER_HISTORY.VOUCHER_ID
				AND VOUCHER_HISTORY.PAYROLL_ID=#p_id#
		</cfquery>
		<cfset voucher_no_list=valuelist(GET_VOUCHERS_LAST.VOUCHER_NO)>
		<cfquery name="get_bank_acc_code_general" datasource="#dsn2#">
			SELECT VOUCHER_GUARANTY_CODE FROM #dsn3_alias#.ACCOUNTS AS ACCOUNTS WHERE ACCOUNT_ID = #attributes.account_id#
		</cfquery>		
		<cfset acc_general = get_bank_acc_code_general.VOUCHER_GUARANTY_CODE>
		<cfscript>
			currency_multiplier = '';//sistem ikinci para biriminin kurunu sayfadan alıyor
			acc_currency_rate = '';
			if(isDefined('attributes.kur_say') and len(attributes.kur_say))
				for(mon=1;mon lte attributes.kur_say;mon=mon+1)
				{
					if(evaluate("attributes.hidden_rd_money_#mon#") is session.ep.money2)
						currency_multiplier = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
					if(evaluate("attributes.hidden_rd_money_#mon#") is attributes.masraf_currency)
						masraf_curr_multiplier = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');	
					if (evaluate("attributes.hidden_rd_money_#mon#") is attributes.currency_id)
						acc_currency_rate = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
					if (evaluate("attributes.hidden_rd_money_#mon#") is attributes.rd_money)
						dovizli_islem_multiplier = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
				}
			if(len(attributes.exp_item_id) and len(attributes.exp_item_name) and (attributes.masraf gt 0) and len(attributes.expense_center))
			{
				butceci(
					action_id : GET_LAST_ID.VOUCHER_ID,
					muhasebe_db : dsn2,
					is_income_expense : false,
					process_type : process_type,
					nettotal : wrk_round(attributes.masraf*masraf_curr_multiplier),
					other_money_value : attributes.masraf,
					action_currency : attributes.masraf_currency,
					currency_multiplier : currency_multiplier,
					expense_date : attributes.PAYROLL_REVENUE_DATE,
					expense_center_id : attributes.expense_center,
					expense_item_id : attributes.exp_item_id,
					detail : 'SENET ÇIKIŞ-BANKA TEMİNAT MASRAFI',
					paper_no : form.payroll_no,
					branch_id : branch_id_info,
					insert_type : 1
				);
				GET_EXP_ACC = cfquery(datasource : "#dsn2#", sqlstring : "SELECT ACCOUNT_CODE FROM EXPENSE_ITEMS WHERE EXPENSE_ITEM_ID = #attributes.exp_item_id#");
			}
			if (is_account eq 1)
			{
				if(session.ep.our_company_info.is_edefter eq 0) //Standart muhasebe islemi yapiliyor
				{
					alacakli_tutarlar = '';
					alacakli_hesaplar = '';
					other_currency_alacak_list= '';
					other_amount_alacak_list= '';
					borclu_hesaplar = '';
					borclu_tutarlar = '';
					other_amount_borc_list='';
					other_currency_borc_list='';
					//str_card_detail = ArrayNew(2);
					get_bank_acc_code = cfquery(datasource:"#dsn2#",sqlstring:"SELECT VOUCHER_GUARANTY_CODE,ACCOUNT_ACC_CODE FROM #dsn3_alias#.ACCOUNTS AS ACCOUNTS WHERE ACCOUNT_ID=#attributes.account_id#");
					for(i=1; i lte attributes.record_num; i=i+1)
					{
						if (evaluate("attributes.row_kontrol#i#"))
						{
							if(evaluate("attributes.currency_id#i#") eq session.ep.money)
								alacakli_tutarlar=listappend(alacakli_tutarlar,evaluate("attributes.voucher_value#i#"),',');
							else
								alacakli_tutarlar=listappend(alacakli_tutarlar,evaluate("attributes.voucher_system_currency_value#i#"),',');
							
							other_amount_alacak_list = listappend(other_amount_alacak_list,evaluate("attributes.voucher_value#i#"),',');
							other_currency_alacak_list = listappend(other_currency_alacak_list,attributes.currency_id,',');
							GET_ACC_CODE=cfquery(datasource:"#dsn2#",sqlstring:"
								SELECT
									C.A_VOUCHER_ACC_CODE
								FROM
									VOUCHER_PAYROLL AS P,
									VOUCHER_HISTORY AS CH,
									CASH AS C
								WHERE
									P.TRANSFER_CASH_ID = C.CASH_ID AND
									P.PAYROLL_TYPE IN(137) AND
									P.ACTION_ID= CH.PAYROLL_ID AND
									CH.VOUCHER_ID=#evaluate("attributes.voucher_id#i#")#");
							if(GET_ACC_CODE.recordcount eq 0)
							{
								GET_ACC_CODE=cfquery(datasource:"#dsn2#", sqlstring:"
									SELECT
										C.A_VOUCHER_ACC_CODE
									FROM
										VOUCHER_PAYROLL AS VP,
										VOUCHER_HISTORY AS VH,
										CASH AS C
									WHERE
										VP.PAYROLL_CASH_ID = C.CASH_ID AND
										(VP.PAYROLL_TYPE=97 OR (VP.PAYROLL_TYPE=107 AND VP.PAYROLL_NO='-1') OR VP.PAYROLL_TYPE = 109) AND
										VP.ACTION_ID= VH.PAYROLL_ID AND
										VH.VOUCHER_ID=#evaluate("attributes.voucher_id#i#")#");
								alacakli_hesaplar=listappend(alacakli_hesaplar, GET_ACC_CODE.A_VOUCHER_ACC_CODE, ',');
							}
							else if(evaluate("attributes.voucher_status_id#i#") eq 6)
							{	
								GET_V_ACC_CODE = cfquery(datasource:"#dsn2#",sqlstring:"
									SELECT 
										V_VOUCHER_ACC_CODE
									FROM
										CASH C
									WHERE
										C.CASH_ID=#listfirst(form.cash_id,';')#");
								alacakli_hesaplar=listappend(alacakli_hesaplar ,GET_V_ACC_CODE.V_VOUCHER_ACC_CODE, ',');
							}
							/* Muhasebe satirlari icin aciklama bilgisi duzenleniyor */
							if (is_account_group neq 1)
							{
								 if(isDefined("attributes.action_detail") and len(attributes.action_detail))
									str_card_detail[2][listlen(alacakli_tutarlar)] = ' #evaluate("attributes.voucher_no#i#")# - #attributes.action_detail#';
								else
									str_card_detail[2][listlen(alacakli_tutarlar)] = ' #evaluate("attributes.voucher_no#i#")# - SENET BANKA TEMİNAT ÇIKIŞ İŞLEMİ';
							}
							else
							{
								if (isDefined("attributes.action_detail") and len(attributes.action_detail))
									str_card_detail[2][listlen(alacakli_tutarlar)] = ' #attributes.action_detail#';
								else
									str_card_detail[2][listlen(alacakli_tutarlar)] = ' SENET BANKA TEMİNAT ÇIKIŞ İŞLEMİ';
							}
						}
					}
					if(len(get_bank_acc_code.VOUCHER_GUARANTY_CODE))
						acc = get_bank_acc_code.VOUCHER_GUARANTY_CODE;
					else
						acc = acc_general;
					borclu_hesaplar=listappend(borclu_hesaplar,acc,',');
					borclu_tutarlar=listappend(borclu_tutarlar,attributes.payroll_total,',');
					other_amount_borc_list = listappend(other_amount_borc_list,wrk_round(attributes.payroll_total/acc_currency_rate),',');
					other_currency_borc_list = listappend(other_currency_borc_list,attributes.currency_id,',');
					if(isDefined("attributes.action_detail") and len(attributes.action_detail))
						str_card_detail[1][listlen(borclu_tutarlar)] = ' #attributes.action_detail#';
					else
						str_card_detail[1][listlen(borclu_tutarlar)] = ' SENET BANKA TEMİNAT ÇIKIŞ İŞLEMİ';
					if (len(attributes.exp_item_id) and len(attributes.exp_item_name) and isdefined("attributes.masraf") and (attributes.masraf gt 0) and len(attributes.expense_center))
					{ /* masraf hesaplarini da muhasebe hesap ve tutarlara dahil edelim */
						borclu_hesaplar = listappend(borclu_hesaplar,GET_EXP_ACC.ACCOUNT_CODE,',');
						borclu_tutarlar = listappend(borclu_tutarlar,attributes.sistem_masraf_tutari,',');
						other_amount_borc_list=listappend(other_amount_borc_list,attributes.masraf,',');
						other_currency_borc_list=listappend(other_currency_borc_list,attributes.masraf_currency,',');
						if(isDefined("attributes.action_detail") and len(attributes.action_detail))
							str_card_detail[1][listlen(borclu_tutarlar)] = ' #attributes.action_detail#';
						else
							str_card_detail[1][listlen(borclu_tutarlar)] = ' SENET BANKA TEMİNAT ÇIKIŞ İŞLEMİ';
						alacakli_hesaplar=listappend(alacakli_hesaplar,get_bank_acc_code.ACCOUNT_ACC_CODE, ',');
						alacakli_tutarlar=listappend(alacakli_tutarlar,attributes.sistem_masraf_tutari,',');
						other_amount_alacak_list=listappend(other_amount_alacak_list,attributes.masraf,',');
						other_currency_alacak_list=listappend(other_currency_alacak_list,attributes.masraf_currency,',');
						if(isDefined("attributes.action_detail") and len(attributes.action_detail))
							str_card_detail[2][listlen(alacakli_hesaplar)] = ' #attributes.action_detail#';
						else
							str_card_detail[2][listlen(alacakli_hesaplar)] = ' SENET BANKA TEMİNAT ÇIKIŞ İŞLEMİ';
					} 
					muhasebeci (
						action_id:P_ID,
						workcube_process_type:process_type,
						account_card_type:13,
						action_table :'VOUCHER_PAYROLL',
						islem_tarihi:attributes.PAYROLL_REVENUE_DATE,
						borc_hesaplar : borclu_hesaplar,
						borc_tutarlar : borclu_tutarlar,
						other_amount_borc : other_amount_borc_list,
						other_currency_borc : other_currency_borc_list,
						alacak_hesaplar : alacakli_hesaplar,
						alacak_tutarlar : alacakli_tutarlar,
						other_amount_alacak : other_amount_alacak_list,
						other_currency_alacak : other_currency_alacak_list,
						currency_multiplier : currency_multiplier,
						fis_detay : 'SENET BANKA TEMİNAT ÇIKIŞ İŞLEMİ',
						fis_satir_detay : str_card_detail,
						belge_no : form.payroll_no,
						to_branch_id : branch_id_info,
						workcube_process_cat : form.process_cat,
						is_account_group : is_account_group
					);
				}
				else		/* e-deftere uygun muhasebe islemi yapiliyor */
				{
					alacakli_tutarlar = '';
					alacakli_hesaplar = '';
					project_id = '';
					get_bank_acc_code = cfquery(datasource:"#dsn2#",sqlstring:"SELECT VOUCHER_GUARANTY_CODE,ACCOUNT_ACC_CODE FROM #dsn3_alias#.ACCOUNTS AS ACCOUNTS WHERE ACCOUNT_ID=#attributes.account_id#");
					for(i=1; i lte attributes.record_num; i=i+1)
					{
						if (evaluate("attributes.row_kontrol#i#"))
						{
							if(evaluate("attributes.currency_id#i#") eq session.ep.money)
								alacakli_tutarlar = evaluate("attributes.voucher_value#i#");
							else
								alacakli_tutarlar = evaluate("attributes.voucher_system_currency_value#i#");
								
								
							if(len(get_bank_acc_code.VOUCHER_GUARANTY_CODE))
								acc = get_bank_acc_code.VOUCHER_GUARANTY_CODE;
							else
								acc = acc_general;
							
							GET_ACC_CODE=cfquery(datasource:"#dsn2#",sqlstring:"
								SELECT
									C.A_VOUCHER_ACC_CODE,
									P.PROJECT_ID
								FROM
									VOUCHER_PAYROLL AS P,
									VOUCHER_HISTORY AS CH,
									CASH AS C
								WHERE
									P.TRANSFER_CASH_ID = C.CASH_ID AND
									P.PAYROLL_TYPE IN(137) AND
									P.ACTION_ID= CH.PAYROLL_ID AND
									CH.VOUCHER_ID=#evaluate("attributes.voucher_id#i#")#");
							if(GET_ACC_CODE.recordcount eq 0)
							{
								GET_ACC_CODE=cfquery(datasource:"#dsn2#", sqlstring:"
									SELECT
										C.A_VOUCHER_ACC_CODE,
										VP.PROJECT_ID
									FROM
										VOUCHER_PAYROLL AS VP,
										VOUCHER_HISTORY AS VH,
										CASH AS C
									WHERE
										VP.PAYROLL_CASH_ID = C.CASH_ID AND
										(VP.PAYROLL_TYPE=97 OR (VP.PAYROLL_TYPE=107 AND VP.PAYROLL_NO='-1') OR VP.PAYROLL_TYPE = 109) AND
										VP.ACTION_ID= VH.PAYROLL_ID AND
										VH.VOUCHER_ID=#evaluate("attributes.voucher_id#i#")#");
								alacakli_hesaplar = GET_ACC_CODE.A_VOUCHER_ACC_CODE;
							}							
							else if(evaluate("attributes.voucher_status_id#i#") eq 6)
							{	
								GET_V_ACC_CODE = cfquery(datasource:"#dsn2#",sqlstring:"
									SELECT 
										V_VOUCHER_ACC_CODE
									FROM
										CASH C
									WHERE
										C.CASH_ID=#listfirst(form.cash_id,';')#");
								alacakli_hesaplar = GET_V_ACC_CODE.V_VOUCHER_ACC_CODE;
							}
							project_id = GET_ACC_CODE.PROJECT_ID;
							/* Muhasebe satirlari icin aciklama bilgisi duzenleniyor */
							if (is_account_group neq 1)
							{
								 if(isDefined("attributes.action_detail") and len(attributes.action_detail))
									str_card_detail[2][1] = ' #evaluate("attributes.voucher_no#i#")# - #attributes.action_detail#';
								else
									str_card_detail[2][1] = ' #evaluate("attributes.voucher_no#i#")# - SENET BANKA TEMİNAT ÇIKIŞ İŞLEMİ';
							}
							else
							{
								if (isDefined("attributes.action_detail") and len(attributes.action_detail))
									str_card_detail[2][1] = ' #attributes.action_detail#';
								else
									str_card_detail[2][1] = ' SENET BANKA TEMİNAT ÇIKIŞ İŞLEMİ';
							}
							if(isDefined("attributes.action_detail") and len(attributes.action_detail))
								str_card_detail[1][1] = ' #attributes.action_detail#';
							else
								str_card_detail[1][1] = ' SENET BANKA TEMİNAT ÇIKIŞ İŞLEMİ';
							
							muhasebeci (
								action_id:P_ID,
								action_row_id : evaluate("attributes.VOUCHER_ID#i#"),
								due_date :iif(len(evaluate("attributes.VOUCHER_DUEDATE#i#")),'createodbcdatetime(evaluate("attributes.VOUCHER_DUEDATE#i#"))','attributes.pyrll_avg_duedate'),
								workcube_process_type:process_type,
								account_card_type:13,
								action_table :'VOUCHER_PAYROLL',
								islem_tarihi:attributes.PAYROLL_REVENUE_DATE,
								borc_hesaplar : acc,
								borc_tutarlar : alacakli_tutarlar,
								other_amount_borc : wrk_round(evaluate("attributes.voucher_system_currency_value#i#")/acc_currency_rate),
								other_currency_borc : attributes.currency_id,
								alacak_hesaplar : alacakli_hesaplar,
								alacak_tutarlar : alacakli_tutarlar,
								other_amount_alacak : evaluate("attributes.voucher_value#i#"),
								other_currency_alacak : attributes.currency_id,
								currency_multiplier : currency_multiplier,
								fis_detay : 'SENET BANKA TEMİNAT ÇIKIŞ İŞLEMİ',
								fis_satir_detay : str_card_detail,
								belge_no : evaluate("attributes.voucher_no#i#"),
								to_branch_id : branch_id_info,
								workcube_process_cat : form.process_cat,
								is_account_group : is_account_group,
								acc_project_id : project_id
							);	
						}
					}
					/* masraf hesaplarini da muhasebe hesap ve tutarlara dahil edelim */
					if (len(attributes.exp_item_id) and len(attributes.exp_item_name) and isdefined("attributes.masraf") and (attributes.masraf gt 0) and len(attributes.expense_center))
					{ 
						if(isDefined("attributes.action_detail") and len(attributes.action_detail))
                        {
                            str_card_detail[2][1] = ' #attributes.action_detail#';
                            str_card_detail[1][2] = ' #attributes.action_detail#';
                        }
                        else
                        {
                            str_card_detail[2][1] = ' SENET BANKA TEMİNAT ÇIKIŞ MASRAFI';
                            str_card_detail[1][2] = ' SENET BANKA TEMİNAT ÇIKIŞ MASRAFI';
                        }
						muhasebeci (
							action_id:P_ID,
							workcube_process_type:process_type,
							account_card_type:13,
							action_table :'VOUCHER_PAYROLL',
							islem_tarihi:attributes.PAYROLL_REVENUE_DATE,
							borc_hesaplar : GET_EXP_ACC.ACCOUNT_CODE,
							borc_tutarlar : attributes.sistem_masraf_tutari,
							other_amount_borc : attributes.masraf,
							other_currency_borc : attributes.masraf_currency,
							alacak_hesaplar : get_bank_acc_code.ACCOUNT_ACC_CODE,
							alacak_tutarlar : attributes.sistem_masraf_tutari,
							other_amount_alacak : attributes.masraf,
							other_currency_alacak : attributes.masraf_currency,
							currency_multiplier : currency_multiplier,
							fis_detay : 'SENET BANKA TEMİNAT ÇIKIŞ MASRAFI',
							fis_satir_detay : str_card_detail,
							belge_no : form.payroll_no,
							to_branch_id : branch_id_info,
							workcube_process_cat : form.process_cat
						);	
					} 
				}
			}
			basket_kur_ekle(action_id:GET_BORDRO_ID.P_ID,table_type_id:12,process_type:0);
		</cfscript>
		<!--- eger masraf tutarı girilmiş ise ve gider kalemi seçili ise bankaya ait kayıt oluşturur --->
		<cfif len(attributes.exp_item_id) and len(attributes.exp_item_name) and (attributes.masraf gt 0) and len(attributes.expense_center)>
			<cfinclude template="add_voucher_bank_masraf.cfm">
		</cfif>
        <cf_add_log employee_id="#session.ep.userid#" log_type="1" action_id="#P_ID#" action_name= "#form.payroll_no# Eklendi" paper_no= "#form.payroll_no#" period_id="#session.ep.period_id#" process_type="#get_process_type.PROCESS_TYPE#" data_source="#dsn2#">
	</cftransaction>
</cflock> 
<cfset attributes.actionid=p_id> 
<script type="text/javascript">
	window.location.href="<cfoutput>#request.self#?fuseaction=#nextEvent#&ID=#p_id#</cfoutput>";
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
