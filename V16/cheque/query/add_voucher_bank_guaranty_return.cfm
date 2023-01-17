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
					PAYROLL_CASH_ID,
					PAYROLL_ACCOUNT_ID,
					CURRENCY_ID,
					PAYROLL_REVENUE_DATE,
					PAYROLL_REV_MEMBER,
					PAYROLL_AVG_DUEDATE,
					PAYROLL_AVG_AGE,
					<cfif len(attributes.PAYROLL_NO)>PAYROLL_NO,</cfif>
					MASRAF,
					EXP_CENTER_ID,
					EXP_ITEM_ID,
					MASRAF_CURRENCY,
					RECORD_EMP,
					RECORD_IP,
					RECORD_DATE,
					VOUCHER_BASED_ACC_CARI,
					ACTION_DETAIL,
					BRANCH_ID
				)
				VALUES
				(
					#form.process_cat#,
					#process_type#,
					#attributes.payroll_total#,
					<cfif isdefined("attributes.basket_money") and len(attributes.basket_money)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.basket_money#">,<cfelse>NULL,</cfif>
					<cfif isdefined("attributes.other_payroll_total") and len(attributes.other_payroll_total)>#attributes.other_payroll_total#,<cfelse>NULL,</cfif>
					#attributes.voucher_num#,
					#listfirst(form.cash_id,';')#,
					#attributes.account_id#,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money#">,
					#ATTRIBUTES.PAYROLL_REVENUE_DATE#,
					#EMPLOYEE_ID#,
					#attributes.pyrll_avg_duedate#,
					<cfif len(attributes.pyrll_avg_age)>#attributes.pyrll_avg_age#,<cfelse>NULL,</cfif>
					<cfif len(attributes.PAYROLL_NO) ><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.PAYROLL_NO#">,</cfif>
					<cfif attributes.masraf gt 0>#attributes.masraf#<cfelse>0</cfif>,
					<cfif isdefined("attributes.expense_center") and len(attributes.expense_center)>#attributes.expense_center#<cfelse>NULL</cfif>,
					<cfif isdefined("attributes.exp_item_id") and len(attributes.exp_item_id) and len(attributes.exp_item_name)>#attributes.exp_item_id#<cfelse>NULL</cfif>,
					<cfif len(attributes.masraf_currency)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.masraf_currency#"><cfelse>NULL</cfif>,
					#session.ep.userid#,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">,
					#NOW()#,
					<cfif len(is_voucher_based)>#is_voucher_based#<cfelse>0</cfif>,
					<cfif isDefined("attributes.action_detail") and len(attributes.action_detail)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.action_detail#"><cfelse>NULL</cfif>,
					#branch_id_info#
				)
		</cfquery>
			<cfquery name="GET_BORDRO_ID" datasource="#dsn2#">
			SELECT MAX(ACTION_ID) AS P_ID FROM VOUCHER_PAYROLL
		</cfquery>
		<cfset p_id=get_bordro_id.P_ID>
		<cfloop from="1" to="#attributes.record_num#" index="i">
			<cfif evaluate("attributes.row_kontrol#i#")>
				<cfquery name="UPD_VOUCHERS" datasource="#dsn2#">
					UPDATE 
						VOUCHER
					SET
					<cfif evaluate("attributes.voucher_status_id#i#") eq 2 or evaluate("attributes.voucher_status_id#i#") eq 13><!--- bankada ve teminatta--->
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
								#p_id#,
								<cfif evaluate("attributes.voucher_status_id#i#") eq 2 or evaluate("attributes.voucher_status_id#i#") eq 13>1,<cfelse>10,</cfif>
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
		<cfquery name="get_bank_acc_code_general" datasource="#dsn2#">
			SELECT VOUCHER_GUARANTY_CODE FROM #dsn3_alias#.ACCOUNTS AS ACCOUNTS WHERE ACCOUNT_ID = #attributes.account_id#
		</cfquery>		
		<cfset acc_general = get_bank_acc_code_general.VOUCHER_GUARANTY_CODE>
		<cfscript>
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
					action_id : p_id,
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
			if(is_account eq 1)//karşılıksız değilse
			{
				if(session.ep.our_company_info.is_edefter eq 0) //Standart muhasebe islemi yapiliyor
				{
					alacak_tutarlar = '';
					alacak_hesaplar = '';
					other_amount_alacak_list = '';
					other_currency_alacak_list = '';
					acc = '';
					toplam ='';
					other_amount_borc_list='';
					other_currency_borc_list= '';
					get_bank_acc_code = cfquery(datasource:"#dsn2#",sqlstring:"SELECT ACCOUNT_ACC_CODE,VOUCHER_EXCHANGE_CODE,VOUCHER_GUARANTY_CODE FROM #dsn3_alias#.ACCOUNTS AS ACCOUNTS WHERE ACCOUNT_ID=#attributes.account_id#");
					get_v_acc_code = cfquery(datasource:"#dsn2#",sqlstring:"SELECT PROTESTOLU_SENETLER_CODE FROM #dsn3_alias#.ACCOUNTS AS ACCOUNTS WHERE ACCOUNT_ID=#attributes.account_id#");	//banka tanimlarindaki protestolu senetler hesabi kullanilir
					get_cash_acc_code=cfquery(datasource:"#dsn2#",sqlstring:"SELECT A_VOUCHER_ACC_CODE FROM CASH WHERE CASH_ID=#listfirst(form.cash_id,';')#");
					for(k=1; k lte attributes.record_num; k=k+1)
					{
						if (evaluate("attributes.row_kontrol#k#"))
						{
							if(evaluate("attributes.currency_id#k#") is session.ep.money)
								alacak_tutarlar=listappend(alacak_tutarlar,evaluate("attributes.voucher_value#k#"),',');
							else
								alacak_tutarlar=listappend(alacak_tutarlar,evaluate("attributes.voucher_system_currency_value#k#"),',');
					
							other_currency_alacak_list = listappend(other_currency_alacak_list,attributes.currency_id,',');
							other_amount_alacak_list =  listappend(other_amount_alacak_list,evaluate("attributes.voucher_value#k#"),',');
							if(evaluate("attributes.voucher_status_id#k#") eq 2)
								alacak_hesaplar=listappend(alacak_hesaplar,get_bank_acc_code.VOUCHER_EXCHANGE_CODE,',');
							else if(evaluate("attributes.voucher_status_id#k#") eq 13)
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
									str_card_detail[2][listlen(alacak_tutarlar)] = ' #evaluate("attributes.voucher_no#k#")# - #attributes.action_detail#';
								else
									str_card_detail[2][listlen(alacak_tutarlar)] = ' #evaluate("attributes.voucher_no#k#")# - SENET İADE GİRİŞ BANKA İŞLEMİ';
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
					/* borc_tutarlar muhasebe aciklama satiri */
					if(isDefined("attributes.action_detail") and len(attributes.action_detail))
						str_card_detail[1][1] = ' #attributes.action_detail#';
					else
						str_card_detail[1][1] = ' SENET İADE GİRİŞ BANKA İŞLEMİ';
						
					muhasebeci(
						action_id:P_ID,
						workcube_process_type:process_type,
						account_card_type:13,
						action_table :'VOUCHER_PAYROLL',
						islem_tarihi:attributes.PAYROLL_REVENUE_DATE,
						borc_hesaplar: acc,
						borc_tutarlar:toplam,
						other_amount_borc: other_amount_borc_list,
						other_currency_borc: other_currency_borc_list,
						alacak_hesaplar:alacak_hesaplar,
						alacak_tutarlar:alacak_tutarlar,
						other_amount_alacak: other_amount_alacak_list,
						other_currency_alacak: other_currency_alacak_list,
						currency_multiplier : currency_multiplier,
						fis_detay : 'SENET İADE GİRİŞ BANKA İŞLEMİ',
						fis_satir_detay:str_card_detail,
						belge_no : form.payroll_no,
						from_branch_id : branch_id_info,
						to_branch_id : branch_id_info,
						workcube_process_cat : form.process_cat,
						is_account_group : is_account_group
					);
				}
				else		/* e-deftere uygun muhasebe hareketi yapiliyor */
				{
					alacak_tutarlar = '';
					alacak_hesaplar = '';
					project_id = '';
					get_bank_acc_code = cfquery(datasource:"#dsn2#",sqlstring:"SELECT ACCOUNT_ACC_CODE,VOUCHER_EXCHANGE_CODE,VOUCHER_GUARANTY_CODE FROM #dsn3_alias#.ACCOUNTS AS ACCOUNTS WHERE ACCOUNT_ID=#attributes.account_id#");
					get_v_acc_code = cfquery(datasource:"#dsn2#",sqlstring:"SELECT PROTESTOLU_SENETLER_CODE FROM #dsn3_alias#.ACCOUNTS AS ACCOUNTS WHERE ACCOUNT_ID=#attributes.account_id#");	//banka tanimlarindaki protestolu senetler hesabi kullanilir
					get_cash_acc_code=cfquery(datasource:"#dsn2#",sqlstring:"SELECT A_VOUCHER_ACC_CODE FROM CASH WHERE CASH_ID=#listfirst(form.cash_id,';')#");
					for(k=1; k lte attributes.record_num; k=k+1)
					{
						if (evaluate("attributes.row_kontrol#k#"))
						{
							if(evaluate("attributes.currency_id#k#") is session.ep.money)
								alacak_tutarlar=evaluate("attributes.voucher_value#k#");
							else
								alacak_tutarlar=evaluate("attributes.voucher_system_currency_value#k#");
					
							if(evaluate("attributes.voucher_status_id#k#") eq 2)
								alacak_hesaplar=get_bank_acc_code.VOUCHER_EXCHANGE_CODE;
							else if(evaluate("attributes.voucher_status_id#k#") eq 13)
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
                                    VOUCHER AS V
                                WHERE
                                    P.ACTION_ID= V.VOUCHER_PAYROLL_ID AND
                                    V.VOUCHER_ID=#evaluate("attributes.voucher_id#k#")#");
                            
                            project_id = GET_VOUCHER_PROJECT.PROJECT_ID;    															
								
							/* alacak_tutarlar muhasebe satirlari aciklama bilgileri */ 	
							if (is_account_group neq 1)
							{ 
								if(isDefined("attributes.action_detail") and len(attributes.action_detail))
									str_card_detail[2][1] = ' #evaluate("attributes.voucher_no#k#")# - #attributes.action_detail#';
								else
									str_card_detail[2][1] = ' #evaluate("attributes.voucher_no#k#")# - SENET İADE GİRİŞ BANKA İŞLEMİ';
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
								
							muhasebeci(
								action_id:P_ID,
								action_row_id : evaluate("attributes.VOUCHER_ID#k#"),
								due_date :iif(len(evaluate("attributes.VOUCHER_DUEDATE#k#")),'createodbcdatetime(evaluate("attributes.VOUCHER_DUEDATE#k#"))','attributes.pyrll_avg_duedate'),
								workcube_process_type:process_type,
								account_card_type:13,
								action_table :'VOUCHER_PAYROLL',
								islem_tarihi:attributes.PAYROLL_REVENUE_DATE,
								borc_hesaplar: get_cash_acc_code.A_VOUCHER_ACC_CODE,
								borc_tutarlar: alacak_tutarlar,
								other_amount_borc: wrk_round(alacak_tutarlar/acc_currency_rate),
								other_currency_borc: attributes.currency_id,
								alacak_hesaplar:alacak_hesaplar,
								alacak_tutarlar:alacak_tutarlar,
								other_amount_alacak: evaluate("attributes.voucher_value#k#"),
								other_currency_alacak: attributes.currency_id,
								currency_multiplier : currency_multiplier,
								fis_detay : 'SENET İADE GİRİŞ BANKA İŞLEMİ',
								fis_satir_detay:str_card_detail,
								belge_no : evaluate("attributes.voucher_no#k#"),
								from_branch_id : branch_id_info,
								to_branch_id : branch_id_info,
								workcube_process_cat : form.process_cat,
								is_account_group : is_account_group,
								acc_project_id = project_id
							);
						}
					}	
					if(len(attributes.exp_item_id) and len(attributes.exp_item_name) and isdefined("attributes.masraf") and (attributes.masraf gt 0) and len(attributes.expense_center))
					{
						if(isDefined("attributes.action_detail") and len(attributes.action_detail))
						{
							str_card_detail[1][2] = ' #attributes.action_detail#';
							str_card_detail[2][1] = ' #attributes.action_detail#';
						}
						else
						{
							str_card_detail[1][2] = ' SENET İADE GİRİŞ BANKA MASRAFI';
							str_card_detail[2][1] = ' SENET İADE GİRİŞ BANKA MASRAFI';
						}
						muhasebeci(
							action_id:P_ID,
							workcube_process_type:process_type,
							account_card_type:13,
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
							fis_satir_detay:str_card_detail,
							belge_no : form.payroll_no,
							from_branch_id : branch_id_info,
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
	</cftransaction>
</cflock>
<script type="text/javascript">
	window.location.href="<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_add_voucher_bank_guaranty_return&event=upd&id=#p_id#</cfoutput>";
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
