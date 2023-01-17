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
	branch_id_info = listgetat(session.ep.user_location,2,'-');
</cfscript>
<cfquery name="CONTROL_NO" datasource="#DSN2#">
	SELECT ACTION_ID FROM VOUCHER_PAYROLL WHERE PAYROLL_NO = '#PAYROLL_NO#' AND ACTION_ID <> #attributes.id#
</cfquery>
<cfif control_no.recordcount>
	<script type="text/javascript">
		alert("<cf_get_lang no='125.Aynı Bordro No lu Kayıt Var !'>");
		history.back();
	</script>
	<cfabort>
</cfif>
<cflock name="#createUUID()#" timeout="60">	
	<cftransaction>
		<cfquery name="UPD_PAYROLL" datasource="#dsn2#">
			UPDATE 
				VOUCHER_PAYROLL
			SET
				PROCESS_CAT=#form.process_cat#,
				PAYROLL_TYPE=#process_type#,
				PAYROLL_ACCOUNT_ID=#attributes.account_id#,
				PAYROLL_CASH_ID = #listfirst(form.cash_id,';')#,
				PAYROLL_REV_MEMBER=#EMPLOYEE_ID#,
				PAYROLL_TOTAL_VALUE=#attributes.payroll_total#,
				PAYROLL_OTHER_MONEY=<cfif isdefined("attributes.basket_money") and len(attributes.basket_money)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.basket_money#">,<cfelse>NULL,</cfif>
				PAYROLL_OTHER_MONEY_VALUE=<cfif isdefined("attributes.other_payroll_total") and len(attributes.other_payroll_total)>#attributes.other_payroll_total#,<cfelse>NULL,</cfif>
				PAYROLL_REVENUE_DATE=#attributes.PAYROLL_REVENUE_DATE#,
				NUMBER_OF_VOUCHER=#attributes.voucher_num#,
				PAYROLL_AVG_DUEDATE=#attributes.pyrll_avg_duedate#,
				PAYROLL_AVG_AGE=<cfif len(attributes.pyrll_avg_age)>#attributes.pyrll_avg_age#,<cfelse>NULL,</cfif>
				PAYROLL_NO=<cfif len(attributes.PAYROLL_NO)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.PAYROLL_NO#">,<cfelse>NULL,</cfif>
				MASRAF=<cfif attributes.masraf gt 0>#attributes.masraf#<cfelse>0</cfif>,
				EXP_CENTER_ID = <cfif isdefined("attributes.expense_center") and len(attributes.expense_center)>#attributes.expense_center#<cfelse>NULL</cfif>,
				EXP_ITEM_ID = <cfif isdefined("attributes.exp_item_id") and len(attributes.exp_item_id) and len(attributes.exp_item_name)>#attributes.exp_item_id#<cfelse>NULL</cfif>,
				MASRAF_CURRENCY = <cfif len(attributes.masraf_currency)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.masraf_currency#"><cfelse>NULL</cfif>,
				UPDATE_EMP=#session.ep.userid#,
				UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">,
				UPDATE_DATE=#NOW()#,
				VOUCHER_BASED_ACC_CARI = <cfif len(is_voucher_based)>#is_voucher_based#<cfelse>0</cfif>,
				ACTION_DETAIL = <cfif isDefined("attributes.action_detail") and len(attributes.action_detail)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.action_detail#"><cfelse>NULL</cfif>,
				BRANCH_ID = #branch_id_info#
			WHERE
				ACTION_ID=#attributes.id#
		</cfquery>
		<cfquery name="GET_REL_VOUCHERS" datasource="#dsn2#">
			SELECT VOUCHER_ID FROM VOUCHER_HISTORY WHERE PAYROLL_ID=#attributes.id#
		</cfquery>
		<cfset ches=valuelist(get_rel_vouchers.VOUCHER_ID)>
		<cfloop list="#ches#" index="i">
			<cfset ctr=0>
			<cfloop from="1" to="#attributes.record_num#" index="k">
				<cfif i eq evaluate("attributes.voucher_id#k#") and evaluate("attributes.row_kontrol#k#")>
					<cfset ctr=1>
				</cfif>
			</cfloop>
			<cfif ctr eq 0>
				<cfquery name="GET_VOUCHER_STATUS" datasource="#dsn2#">
					SELECT VOUCHER_STATUS_ID FROM VOUCHER WHERE VOUCHER_ID=#i#
				</cfquery>
				<cfif GET_VOUCHER_STATUS.VOUCHER_STATUS_ID eq 1><!--- portfoyde icin --->
					<cfquery name="GET_LAST_HIST" datasource="#dsn2#">
						SELECT TOP 1 STATUS FROM VOUCHER_HISTORY WHERE VOUCHER_ID=#i# AND PAYROLL_ID <> #attributes.id# ORDER BY RECORD_DATE DESC
					</cfquery>
					<cfif GET_LAST_HIST.STATUS eq 2>
						<cfquery name="UPD_VOUCHER" datasource="#dsn2#">
							UPDATE VOUCHER SET VOUCHER_STATUS_ID=2 WHERE VOUCHER_ID=#i#<!---bankada  --->
						</cfquery>
					<cfelse>
						<cfquery name="UPD_VOUCHER" datasource="#dsn2#">
							UPDATE VOUCHER SET VOUCHER_STATUS_ID=13 WHERE VOUCHER_ID=#i#<!---teminatta  --->
						</cfquery>
					</cfif>
				<cfelseif GET_VOUCHER_STATUS.VOUCHER_STATUS_ID eq 10><!--- protestolu portföyde icin --->
					<cfquery name="UPD_CHEQUE" datasource="#dsn2#">
						UPDATE VOUCHER SET VOUCHER_STATUS_ID=5 WHERE VOUCHER_ID=#i#<!---karşılıksız  --->
					</cfquery>
				</cfif>
				<cfquery name="DEL_VOU_HIST" datasource="#dsn2#">
					DELETE FROM	VOUCHER_HISTORY WHERE VOUCHER_ID=#i# AND PAYROLL_ID=#attributes.id#
				</cfquery>
			</cfif>
		</cfloop>
		<cfloop from="1" to="#attributes.record_num#" index="i">
			<cfif evaluate("attributes.row_kontrol#i#")>
				<cfset ctr=0>
				<cfloop list="#ches#" index="k">
					<cfif k eq evaluate("attributes.voucher_id#i#")>
						<cfset ctr=1>
					</cfif>
				</cfloop>
				<cfif ctr eq 0>
					<cfquery name="UPD_VOUCHERS" datasource="#dsn2#">
						UPDATE 
							VOUCHER
						SET
						<cfif evaluate("attributes.voucher_status_id#i#") eq 2 or evaluate("attributes.voucher_status_id#i#") eq 13><!--- bankada ve teninatt--->
							VOUCHER_STATUS_ID = 1<!--- portfoyde --->
						<cfelse>
							VOUCHER_STATUS_ID = 10<!--- protestolu portföyde --->
						</cfif>
						WHERE
							VOUCHER_ID= #evaluate("attributes.voucher_id#i#")#
					</cfquery>
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
								#evaluate("attributes.voucher_id#i#")#,
								#attributes.id#,
								<cfif evaluate("attributes.voucher_status_id#i#") eq 2 or evaluate("attributes.voucher_status_id#i#") eq 13>1,<cfelse>10,</cfif>
								#attributes.PAYROLL_REVENUE_DATE#,
								<cfif len(evaluate("attributes.voucher_system_currency_value#i#"))>#evaluate("attributes.voucher_system_currency_value#i#")#,<cfelse>NULL,</cfif>
								<cfif len(evaluate("attributes.system_money_info#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.system_money_info#i#")#'>,<cfelse>NULL,</cfif>
								<cfif len(evaluate("attributes.other_money_value2#i#"))>#evaluate("attributes.other_money_value2#i#")#,<cfelse>NULL,</cfif>
								<cfif len(evaluate("attributes.other_money2#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.other_money2#i#")#'>,<cfelse>NULL,</cfif>
								#NOW()#
							)
					</cfquery>
				<cfelseif ctr eq 1>
					<cfquery name="UPD_VOUCHER_HISTORY" datasource="#dsn2#">
						UPDATE 
							VOUCHER_HISTORY
						SET 
							ACT_DATE = #attributes.PAYROLL_REVENUE_DATE#,
							OTHER_MONEY_VALUE= <cfif len(evaluate("attributes.voucher_system_currency_value#i#"))>#evaluate("attributes.voucher_system_currency_value#i#")#,<cfelse>NULL,</cfif>
							OTHER_MONEY= <cfif len(evaluate("attributes.system_money_info#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.system_money_info#i#")#'>,<cfelse>NULL,</cfif>
							OTHER_MONEY_VALUE2= <cfif len(evaluate("attributes.other_money_value2#i#"))>#evaluate("attributes.other_money_value2#i#")#,<cfelse>NULL,</cfif>
							OTHER_MONEY2= <cfif len(evaluate("attributes.other_money2#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.other_money2#i#")#'><cfelse>NULL</cfif>
						WHERE 
							VOUCHER_ID= #evaluate("attributes.voucher_id#i#")# AND
							PAYROLL_ID = #attributes.id#
					</cfquery>
				</cfif>
			</cfif>
		</cfloop>
		<cfquery name="get_bank_acc_code_general" datasource="#dsn2#">
			SELECT VOUCHER_GUARANTY_CODE FROM #dsn3_alias#.ACCOUNTS AS ACCOUNTS WHERE ACCOUNT_ID = #attributes.account_id#
		</cfquery>		
		<cfset acc_general = get_bank_acc_code_general.VOUCHER_GUARANTY_CODE>
		<cfscript>
			butce_sil(action_id:attributes.id,process_type:form.old_process_type);
			currency_multiplier = '';//sistem ikinci para biriminin kurunu sayfadan alıyor
			acc_currency_rate = '';
			masraf_curr_multiplier = '';
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
					action_id : attributes.id,
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
					detail : 'SENET İADE GİRİŞ BANKA MASRAFI',
					paper_no : form.payroll_no,
					branch_id : branch_id_info,
					insert_type : 1//banka vs den eklenen masraflar için farklı ekleme metodu tanımlar
				);
				GET_EXP_ACC = cfquery(datasource : "#dsn2#", sqlstring : "SELECT ACCOUNT_CODE FROM EXPENSE_ITEMS WHERE EXPENSE_ITEM_ID = #attributes.exp_item_id#");
			}
			if(is_account eq 1)
			{
				if(session.ep.our_company_info.is_edefter eq 0) //Standart muhasebe islemi yapiliyor
				{
					//varsa butce mahsup kaydi silinmeli
					muhasebe_sil(action_id:attributes.id,action_table:'VOUCHER_PAYROLL',process_type:form.old_process_type);
					
					alacak_hesaplar = '';
					alacak_tutarlar = '';
					other_amount_alacak_list = '';
					other_currency_alacak_list = '';
					acc = '';
					toplam = '';
					other_amount_borc_list='';
					other_currency_borc_list= '';
					get_cash_acc_code=cfquery(datasource:"#dsn2#",sqlstring:"SELECT A_VOUCHER_ACC_CODE FROM CASH WHERE CASH_ID=#listfirst(form.cash_id,';')#");
					get_v_acc_code = cfquery(datasource:"#dsn2#",sqlstring:"SELECT PROTESTOLU_SENETLER_CODE FROM #dsn3_alias#.ACCOUNTS AS ACCOUNTS WHERE ACCOUNT_ID=#attributes.account_id#");
					get_bank_acc_code = cfquery(datasource:"#dsn2#",sqlstring:"SELECT ACCOUNT_ACC_CODE,VOUCHER_EXCHANGE_CODE,VOUCHER_GUARANTY_CODE FROM #dsn3_alias#.ACCOUNTS AS ACCOUNTS WHERE ACCOUNT_ID=#attributes.account_id#");
					for(i=1; i lte attributes.record_num; i=i+1)
					{
						if (evaluate("attributes.row_kontrol#i#"))
						{
							if(evaluate("attributes.currency_id#i#") is session.ep.money)
								alacak_tutarlar=listappend(alacak_tutarlar,evaluate("attributes.voucher_value#i#"),',');
							else
								alacak_tutarlar=listappend(alacak_tutarlar,evaluate("attributes.voucher_system_currency_value#i#"),',');
							other_currency_alacak_list = listappend(other_currency_alacak_list,attributes.currency_id,',');
							other_amount_alacak_list =  listappend(other_amount_alacak_list,evaluate("attributes.voucher_value#i#"),',');
							if(evaluate("attributes.voucher_status_id#i#") eq 1)
							{
								get_voucher_status = cfquery(datasource:"#dsn2#",sqlstring:"SELECT TOP 1 STATUS FROM VOUCHER_HISTORY WHERE VOUCHER_ID=#evaluate("attributes.voucher_id#i#")# AND PAYROLL_ID <> #attributes.id# ORDER BY RECORD_DATE DESC");
								if(get_voucher_status.STATUS eq 2)
									alacak_hesaplar=listappend(alacak_hesaplar,get_bank_acc_code.VOUCHER_EXCHANGE_CODE,',');
								else
								{
									if(len(get_bank_acc_code.VOUCHER_GUARANTY_CODE))
										alacak_hesaplar=listappend(alacak_hesaplar,get_bank_acc_code.VOUCHER_GUARANTY_CODE,',');
									else
										alacak_hesaplar=listappend(alacak_hesaplar,acc_general,',');
								}
							}
							else if(evaluate("attributes.voucher_status_id#i#") eq 2)
								alacak_hesaplar=listappend(alacak_hesaplar,get_bank_acc_code.VOUCHER_EXCHANGE_CODE,',');
							else if(evaluate("attributes.voucher_status_id#i#") eq 13)
							{
								if(len(get_bank_acc_code.VOUCHER_GUARANTY_CODE))
									alacak_hesaplar=listappend(alacak_hesaplar,get_bank_acc_code.VOUCHER_GUARANTY_CODE,',');
								else
									alacak_hesaplar=listappend(alacak_hesaplar,acc_general,',');
							}
							else
								alacak_hesaplar=listappend(alacak_hesaplar,get_v_acc_code.PROTESTOLU_SENETLER_CODE,',');
							/* alacak_tutarlar muhasebe satirlari aciklama bilgileri */ 	
							if (is_account_group neq 1)
							{ 
								if(isDefined("attributes.action_detail") and len(attributes.action_detail))
									str_card_detail[2][listlen(alacak_tutarlar)] = ' #evaluate("attributes.voucher_no#i#")# - #attributes.action_detail#';
								else
									str_card_detail[2][listlen(alacak_tutarlar)] = ' #evaluate("attributes.voucher_no#i#")# - SENET İADE GİRİŞ BANKA İŞLEMİ';
							}
							else
							{
								if(isDefined("attributes.action_detail") and len(attributes.action_detail))
									str_card_detail[2][listlen(alacak_tutarlar)] = ' #attributes.action_detail#';
								else
									str_card_detail[2][listlen(alacak_tutarlar)] = ' SENET İADE GİRİŞ BANKA İŞLEMİ';
							}
						}
					}
					acc = get_cash_acc_code.A_VOUCHER_ACC_CODE;
					toplam = attributes.payroll_total;
					other_amount_borc_list=wrk_round(attributes.payroll_total/acc_currency_rate);
					other_currency_borc_list = attributes.currency_id;
					/* borc_tutarlar muhasebe aciklama satiri */
					if(isDefined("attributes.action_detail") and len(attributes.action_detail))
						str_card_detail[1][1] = ' #attributes.action_detail#';
					else
						str_card_detail[1][1] = ' SENET İADE GİRİŞ BANKA İŞLEMİ';
					if(len(attributes.exp_item_id) and len(attributes.exp_item_name) and isdefined("attributes.masraf") and (attributes.masraf gt 0) and len(attributes.expense_center))
					{
						alacak_hesaplar=listappend(alacak_hesaplar,get_bank_acc_code.ACCOUNT_ACC_CODE, ',');
						alacak_tutarlar=listappend(alacak_tutarlar,attributes.sistem_masraf_tutari,',');
						other_amount_alacak_list=listappend(other_amount_alacak_list,attributes.masraf,',');
						other_currency_alacak_list=listappend(other_currency_alacak_list,attributes.masraf_currency,',');
						acc=listappend(acc,GET_EXP_ACC.ACCOUNT_CODE,',');
						toplam=listappend(toplam,attributes.sistem_masraf_tutari,',');
						other_amount_borc_list=listappend(other_amount_borc_list,attributes.masraf,',');
						other_currency_borc_list=listappend(other_currency_borc_list,attributes.masraf_currency,',');
						if(isDefined("attributes.action_detail") and len(attributes.action_detail))
						{
							str_card_detail[1][2] = ' #attributes.action_detail#';
							str_card_detail[2][listlen(alacak_tutarlar)] = ' #attributes.action_detail#';
						}
						else
						{
							str_card_detail[1][2] = ' SENET İADE GİRİŞ BANKA İŞLEMİ';
							str_card_detail[2][listlen(alacak_tutarlar)] = ' SENET İADE GİRİŞ BANKA İŞLEMİ';
						}
					}
						
					muhasebeci (
						action_id: attributes.id,
						workcube_process_type: process_type,
						workcube_old_process_type : form.old_process_type,
						account_card_type: 13,
						action_table :'VOUCHER_PAYROLL',
						islem_tarihi: attributes.PAYROLL_REVENUE_DATE,
						borc_hesaplar: acc,
						borc_tutarlar: toplam,
						other_amount_borc: other_amount_borc_list,
						other_currency_borc: other_currency_borc_list,
						alacak_hesaplar: alacak_hesaplar,
						alacak_tutarlar: alacak_tutarlar,
						other_amount_alacak: other_amount_alacak_list,
						other_currency_alacak: other_currency_alacak_list,
						currency_multiplier : currency_multiplier,
						fis_detay : 'SENET İADE GİRİŞ BANKA İŞLEMİ',
						fis_satir_detay : str_card_detail,
						belge_no : form.payroll_no,
						from_branch_id : branch_id_info,
						to_branch_id : branch_id_info,
						workcube_process_cat : form.process_cat,
						is_account_group : is_account_group
					);
				}
				else		/* e-deftere uygun muhasebe hareketi yapiliyor */
				{
					// tum muhasebe kayıtlari silinir sonra yaniden eklenir.
					muhasebe_sil(action_id:attributes.id,action_table:'VOUCHER_PAYROLL',process_type:form.old_process_type);
					
					alacak_hesaplar = '';
					alacak_tutarlar = '';
					project_id = '';
					get_cash_acc_code=cfquery(datasource:"#dsn2#",sqlstring:"SELECT A_VOUCHER_ACC_CODE FROM CASH WHERE CASH_ID=#listfirst(form.cash_id,';')#");
					get_v_acc_code = cfquery(datasource:"#dsn2#",sqlstring:"SELECT PROTESTOLU_SENETLER_CODE FROM #dsn3_alias#.ACCOUNTS AS ACCOUNTS WHERE ACCOUNT_ID=#attributes.account_id#");
					get_bank_acc_code = cfquery(datasource:"#dsn2#",sqlstring:"SELECT ACCOUNT_ACC_CODE,VOUCHER_EXCHANGE_CODE,VOUCHER_GUARANTY_CODE FROM #dsn3_alias#.ACCOUNTS AS ACCOUNTS WHERE ACCOUNT_ID=#attributes.account_id#");
					for(i=1; i lte attributes.record_num; i=i+1)
					{
						if (evaluate("attributes.row_kontrol#i#"))
						{
							if(evaluate("attributes.currency_id#i#") is session.ep.money)
								alacak_tutarlar=evaluate("attributes.voucher_value#i#");
							else
								alacak_tutarlar=evaluate("attributes.voucher_system_currency_value#i#");
							if(evaluate("attributes.voucher_status_id#i#") eq 1)
							{
								get_voucher_status = cfquery(datasource:"#dsn2#",sqlstring:"SELECT TOP 1 STATUS FROM VOUCHER_HISTORY WHERE VOUCHER_ID=#evaluate("attributes.voucher_id#i#")# AND PAYROLL_ID <> #attributes.id# ORDER BY RECORD_DATE DESC");
								if(get_voucher_status.STATUS eq 2)
									alacak_hesaplar=get_bank_acc_code.VOUCHER_EXCHANGE_CODE;
								else
								{
									if(len(get_bank_acc_code.VOUCHER_GUARANTY_CODE))
										alacak_hesaplar=get_bank_acc_code.VOUCHER_GUARANTY_CODE;
									else
										alacak_hesaplar=acc_general;
								}
							}
							else if(evaluate("attributes.voucher_status_id#i#") eq 2)
								alacak_hesaplar=get_bank_acc_code.VOUCHER_EXCHANGE_CODE;
							else if(evaluate("attributes.voucher_status_id#i#") eq 13)
							{
								if(len(get_bank_acc_code.VOUCHER_GUARANTY_CODE))
									alacak_hesaplar=get_bank_acc_code.VOUCHER_GUARANTY_CODE;
								else
									alacak_hesaplar=acc_general;
							}
							else
								alacak_hesaplar=get_v_acc_code.PROTESTOLU_SENETLER_CODE;
								
                            GET_VOUCHER_PROJECT=cfquery(datasource:"#dsn2#",sqlstring:"SELECT
                                    P.PROJECT_ID
                                FROM
                                    VOUCHER_PAYROLL AS P,
                                    VOUCHER AS VC
                                WHERE
                                    P.ACTION_ID= VC.VOUCHER_PAYROLL_ID AND
                                    VC.VOUCHER_ID=#evaluate("attributes.voucher_id#i#")#");
                            
                            project_id = GET_VOUCHER_PROJECT.PROJECT_ID;    																							
								
							/* alacak_tutarlar muhasebe satirlari aciklama bilgileri */ 	
							if (is_account_group neq 1)
							{ 
								if(isDefined("attributes.action_detail") and len(attributes.action_detail))
									str_card_detail[2][1] = ' #evaluate("attributes.voucher_no#i#")# - #attributes.action_detail#';
								else
									str_card_detail[2][1] = ' #evaluate("attributes.voucher_no#i#")# - SENET İADE GİRİŞ BANKA İŞLEMİ';
							}
							else
							{
								if(isDefined("attributes.action_detail") and len(attributes.action_detail))
									str_card_detail[2][1] = ' #attributes.action_detail#';
								else
									str_card_detail[2][1] = ' SENET İADE GİRİŞ BANKA İŞLEMİ';
							}
							/* borc_tutarlar muhasebe aciklama satiri */
							if(isDefined("attributes.action_detail") and len(attributes.action_detail))
								str_card_detail[1][1] = ' #attributes.action_detail#';
							else
								str_card_detail[1][1] = ' SENET İADE GİRİŞ BANKA İŞLEMİ';
							muhasebeci (
								action_id: attributes.id,
								action_row_id : evaluate("attributes.VOUCHER_ID#i#"),
								due_date :iif(len(evaluate("attributes.VOUCHER_DUEDATE#i#")),'createodbcdatetime(evaluate("attributes.VOUCHER_DUEDATE#i#"))','attributes.pyrll_avg_duedate'),
								workcube_process_type: process_type,
								workcube_old_process_type : form.old_process_type,
								account_card_type: 13,
								action_table :'VOUCHER_PAYROLL',
								islem_tarihi: attributes.PAYROLL_REVENUE_DATE,
								borc_hesaplar: get_cash_acc_code.A_VOUCHER_ACC_CODE,
								borc_tutarlar: alacak_tutarlar,
								other_amount_borc: wrk_round(alacak_tutarlar/acc_currency_rate),
								other_currency_borc: attributes.currency_id,
								alacak_hesaplar:alacak_hesaplar,
								alacak_tutarlar:alacak_tutarlar,
								other_amount_alacak: evaluate("attributes.voucher_value#i#"),
								other_currency_alacak: attributes.currency_id,
								currency_multiplier : currency_multiplier,
								fis_detay : 'SENET İADE GİRİŞ BANKA İŞLEMİ',
								fis_satir_detay : str_card_detail,
								belge_no : evaluate("attributes.voucher_no#i#"),
								from_branch_id : branch_id_info,
								to_branch_id : branch_id_info,
								workcube_process_cat : form.process_cat,
								is_account_group : is_account_group,
								acc_project_id : project_id
							);
						}
					}
					if(len(attributes.exp_item_id) and len(attributes.exp_item_name) and isdefined("attributes.masraf") and (attributes.masraf gt 0) and len(attributes.expense_center))
					{
						if(isDefined("attributes.action_detail") and len(attributes.action_detail))
						{
							str_card_detail[1][2] = ' #attributes.action_detail#';
							str_card_detail[2][listlen(alacak_tutarlar)] = ' #attributes.action_detail#';
						}
						else
						{
							str_card_detail[1][2] = ' SENET İADE GİRİŞ BANKA MASRAFI';
							str_card_detail[2][listlen(alacak_tutarlar)] = ' SENET İADE GİRİŞ BANKA MASRAFI';
						}
						muhasebeci (
							action_id: attributes.id,
							workcube_process_type: process_type,
							workcube_old_process_type : form.old_process_type,
							account_card_type: 13,
							action_table :'VOUCHER_PAYROLL',
							islem_tarihi: attributes.PAYROLL_REVENUE_DATE,
							borc_hesaplar: GET_EXP_ACC.ACCOUNT_CODE,
							borc_tutarlar: attributes.sistem_masraf_tutari,
							other_amount_borc: attributes.masraf,
							other_currency_borc: attributes.masraf_currency,
							alacak_hesaplar: get_bank_acc_code.ACCOUNT_ACC_CODE,
							alacak_tutarlar: attributes.sistem_masraf_tutari,
							other_amount_alacak: attributes.masraf,
							other_currency_alacak: attributes.masraf_currency,
							currency_multiplier : currency_multiplier,
							fis_detay : 'SENET İADE GİRİŞ BANKA MASRAFI',
							fis_satir_detay : str_card_detail,
							belge_no : form.payroll_no,
							from_branch_id : branch_id_info,
							to_branch_id : branch_id_info,
							workcube_process_cat : form.process_cat
						);
					}
				}
			}
			else
				muhasebe_sil(action_id:attributes.id,action_table:'VOUCHER_PAYROLL',process_type:form.old_process_type);
			basket_kur_ekle(action_id:attributes.id,table_type_id:12,process_type:1);
		</cfscript>
		<!--- eger masraf tutarı girilmiş ise ve gider kalemi seçili ise bankaya ait kayıt oluşturur --->
		<cfset is_upd_action = 1>
		<cfif len(attributes.exp_item_id) and len(attributes.exp_item_name) and (attributes.masraf gt 0) and len(attributes.expense_center)>
			<cfinclude template="add_voucher_bank_masraf.cfm">
		<cfelse>
		<cfquery name="DEL_BANK_ACTIONS" datasource="#dsn2#">
			DELETE FROM BANK_ACTIONS WHERE VOUCHER_PAYROLL_ID = #attributes.id#
		</cfquery>
		</cfif> 	
	</cftransaction>
</cflock> 
<script type="text/javascript">
	window.location.href="<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_add_voucher_bank_guaranty_return&event=upd&id=#attributes.ID#</cfoutput>";
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
