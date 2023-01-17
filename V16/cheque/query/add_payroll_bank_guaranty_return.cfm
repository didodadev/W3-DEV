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
		IS_CHEQUE_BASED_ACTION,
		ACTION_FILE_NAME,
		ACTION_FILE_FROM_TEMPLATE
	 FROM 
	 	SETUP_PROCESS_CAT 
	WHERE 
		PROCESS_CAT_ID = #form.process_cat#
</cfquery>
<cfscript>
	process_type = get_process_type.PROCESS_TYPE;
	is_account = get_process_type.IS_ACCOUNT;
	is_account_group = get_process_type.IS_ACCOUNT_GROUP;
	is_cheque_based = get_process_type.IS_CHEQUE_BASED_ACTION;
	attributes.masraf = filterNum(attributes.masraf);
	attributes.payroll_total = filterNum(attributes.payroll_total);
	attributes.other_payroll_total = filterNum(attributes.other_payroll_total);
	for(ff=1; ff lte attributes.record_num; ff=ff+1)
	{
		if (evaluate("attributes.row_kontrol#ff#"))
			'attributes.cheque_system_currency_value#ff#' = filterNum(evaluate("attributes.cheque_system_currency_value#ff#"));
			'attributes.cheque_value#ff#' = filterNum(evaluate("attributes.cheque_value#ff#"));
	}
	for(rt = 1; rt lte attributes.kur_say; rt = rt + 1)
	{
		'attributes.txt_rate1_#rt#' = filterNum(evaluate('attributes.txt_rate1_#rt#'),session.ep.our_company_info.rate_round_num);
		'attributes.txt_rate2_#rt#' = filterNum(evaluate('attributes.txt_rate2_#rt#'),session.ep.our_company_info.rate_round_num);
	}
	branch_id_info = listgetat(session.ep.user_location,2,'-');
</cfscript>
<cfquery name="control_no" datasource="#dsn2#">
	SELECT ACTION_ID FROM PAYROLL WHERE PAYROLL_NO = '#attributes.PAYROLL_NO#' 
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
				PAYROLL
				(
					PROCESS_CAT,
					PAYROLL_TYPE,
					PAYROLL_TOTAL_VALUE,
					PAYROLL_OTHER_MONEY,
					PAYROLL_OTHER_MONEY_VALUE,
					NUMBER_OF_CHEQUE,
					PAYROLL_ACCOUNT_ID,
					PAYROLL_CASH_ID,
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
					CHEQUE_BASED_ACC_CARI,
					RECORD_EMP,
					RECORD_IP,
					RECORD_DATE,
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
					#attributes.cheque_num#,
					#attributes.account_id#,
					#listfirst(form.cash_id,';')#,
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
					<cfif len(is_cheque_based)>#is_cheque_based#<cfelse>0</cfif>,
					#session.ep.userid#,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">,
					#NOW()#,
					<cfif isDefined("attributes.action_detail") and len(attributes.action_detail)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.action_detail#"><cfelse>NULL</cfif>,
					#branch_id_info#
				)
		</cfquery>
		<cfquery name="GET_BORDRO_ID" datasource="#dsn2#">
			SELECT MAX(ACTION_ID) AS P_ID FROM PAYROLL
		</cfquery>
		<cfset p_id=get_bordro_id.P_ID>
		<cfloop from="1" to="#attributes.record_num#" index="i">
			<cfif evaluate("attributes.row_kontrol#i#")>
				<cfquery name="UPD_CHEQUES" datasource="#dsn2#">
					UPDATE 
						CHEQUE
					SET
					<cfif evaluate("attributes.cheque_status_id#i#") eq 2 or evaluate("attributes.cheque_status_id#i#") eq 13><!--- bankada --->
						CHEQUE_STATUS_ID = 1<!--- portfoyde --->
					<cfelse>
						CHEQUE_STATUS_ID = 10<!--- karşılıksız portföyde--->
					</cfif>
					,CASH_ID = #listfirst(form.cash_id,';')#
					WHERE
						CHEQUE_ID= #evaluate("attributes.cheque_id#i#")#
				</cfquery>
				<cfquery name="ADD_CHEQUE_HISTORY" datasource="#dsn2#">
					INSERT INTO
						CHEQUE_HISTORY
							(
								CHEQUE_ID,
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
								#evaluate("attributes.cheque_id#i#")#,
								#p_id#,
								<cfif evaluate("attributes.cheque_status_id#i#") eq 2 or evaluate("attributes.cheque_status_id#i#") eq 13>1,<cfelse>10,</cfif>
								#attributes.PAYROLL_REVENUE_DATE#,
								<cfif len(evaluate("attributes.cheque_system_currency_value#i#"))>#evaluate("attributes.cheque_system_currency_value#i#")#,<cfelse>NULL,</cfif>
								<cfif len(evaluate("attributes.system_money_info#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.system_money_info#i#")#'>,<cfelse>NULL,</cfif>
								<cfif len(evaluate("attributes.other_money_value2#i#"))>#evaluate("attributes.other_money_value2#i#")#,<cfelse>NULL,</cfif>
								<cfif len(evaluate("attributes.other_money2#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.other_money2#i#")#'>,<cfelse>NULL,</cfif>
								#NOW()#
							)
				</cfquery>
			</cfif>
		</cfloop>
		<cfquery name="get_bank_acc_code_general" datasource="#dsn2#">
			SELECT CHEQUE_GUARANTY_CODE FROM #dsn3_alias#.ACCOUNTS AS ACCOUNTS WHERE ACCOUNT_ID=#attributes.account_id#
		</cfquery>		
		<cfset acc_general = get_bank_acc_code_general.CHEQUE_GUARANTY_CODE>
		<cfscript>
			currency_multiplier = '';//sistem ikinci para biriminin kurunu sayfadan alıyor
			masraf_curr_multiplier = '';
			cash_currency_rate = '';
				if(isDefined('attributes.kur_say') and len(attributes.kur_say))
					for(mon=1;mon lte attributes.kur_say;mon=mon+1)
					{
						if(evaluate("attributes.hidden_rd_money_#mon#") is session.ep.money2)
							currency_multiplier = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
						if(evaluate("attributes.hidden_rd_money_#mon#") is attributes.masraf_currency)
							masraf_curr_multiplier = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');	
						if (evaluate("attributes.hidden_rd_money_#mon#") is listgetat(form.cash_id,3,';'))
							cash_currency_rate = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
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
					detail : 'ÇEK İADE GİRİŞ MASRAFI',
					paper_no : form.payroll_no,
					branch_id : branch_id_info,
					insert_type : 1//banka vs den eklenen masraflar için farklı ekleme metodu tanımlar
				);
				GET_EXP_ACC = cfquery(datasource : "#dsn2#", sqlstring : "SELECT ACCOUNT_CODE FROM EXPENSE_ITEMS WHERE EXPENSE_ITEM_ID = #attributes.exp_item_id#");
			}		
			if(is_account eq 1)//karşılıksız değilse ve muhasebe islemi yapiliyorsa
			{
				if(session.ep.our_company_info.is_edefter eq 0)	/*standart muhasebe islemleri yapılıyor*/
				{
					alacak_tutarlar = '';
					alacak_hesaplar = '';
					other_amount_alacak_list = '';
					other_currency_alacak_list = '';
					satir_detay_list = ArrayNew(2);
					acc = '';
					toplam ='';
					other_amount_borc_list='';
					other_currency_borc_list= '';
					get_bank_acc_code = cfquery(datasource:"#dsn2#",sqlstring:"SELECT ACCOUNT_ACC_CODE,CHEQUE_EXCHANGE_CODE,CHEQUE_GUARANTY_CODE FROM #dsn3_alias#.ACCOUNTS AS ACCOUNTS WHERE ACCOUNT_ID=#attributes.account_id#");
					get_cheque_acc_code = cfquery(datasource:"#dsn2#",sqlstring:"SELECT KARSILIKSIZ_CEKLER_CODE FROM #dsn3_alias#.ACCOUNTS AS ACCOUNTS WHERE ACCOUNT_ID=#attributes.account_id#");
					get_cash_acc_code=cfquery(datasource:"#dsn2#",sqlstring:"SELECT A_CHEQUE_ACC_CODE FROM CASH WHERE CASH_ID=#listfirst(form.cash_id,';')#");
					for(k=1; k lte attributes.record_num; k=k+1)
					{
						if(evaluate("attributes.row_kontrol#k#"))
						{
							if(evaluate("attributes.currency_id#k#") is session.ep.money)
								alacak_tutarlar=listappend(alacak_tutarlar,evaluate("attributes.cheque_value#k#"),',');
							else
								alacak_tutarlar=listappend(alacak_tutarlar,evaluate("attributes.cheque_system_currency_value#k#"),',');
			
							other_currency_alacak_list = listappend(other_currency_alacak_list,attributes.currency_id,',');
							other_amount_alacak_list =  listappend(other_amount_alacak_list,evaluate("attributes.cheque_value#k#"),',');
							if(evaluate("attributes.cheque_status_id#k#") eq 2)
								alacak_hesaplar=listappend(alacak_hesaplar,get_bank_acc_code.CHEQUE_EXCHANGE_CODE,',');
							else if(evaluate("attributes.cheque_status_id#k#") eq 13)
							{	
								if(len(get_bank_acc_code.CHEQUE_GUARANTY_CODE))
									alacak_hesaplar=listappend(alacak_hesaplar,get_bank_acc_code.CHEQUE_GUARANTY_CODE,',');
								else
									alacak_hesaplar=listappend(alacak_hesaplar,acc_general,',');
							}
							else
								alacak_hesaplar=listappend(alacak_hesaplar,get_cheque_acc_code.KARSILIKSIZ_CEKLER_CODE,',');
							
							if (is_account_group neq 1)
							{ 
								if(attributes.x_detail_acc_card eq 1) //detaylı muhasebe seçilmişse çek bilgilerini yazıyoruz
									satir_detay_list[2][listlen(alacak_tutarlar)]='Ç.İ.G.B.B.:#attributes.payroll_no#:#evaluate("attributes.bank_name#k#")#:#evaluate("attributes.bank_branch_name#k#")#:#evaluate("attributes.account_no#k#")#'; //satır acıklamaları borc acıklama aray e set edilir.
								else if(isDefined("attributes.action_detail") and len(attributes.action_detail))
									satir_detay_list[2][listlen(alacak_tutarlar)] = ' #evaluate("attributes.cheque_no#k#")# - #attributes.action_detail#';
								else
									satir_detay_list[2][listlen(alacak_tutarlar)] = ' #evaluate("attributes.cheque_no#k#")# - ÇEK İADE GİRİŞ BANKA İŞLEMİ';
							}
							else
							{
								if(attributes.x_detail_acc_card eq 1) //detaylı muhasebe seçilmişse çek bilgilerini yazıyoruz
									satir_detay_list[2][listlen(alacak_tutarlar)]='Ç.İ.G.B.B.:#attributes.payroll_no#:#evaluate("attributes.bank_name#k#")#:#evaluate("attributes.bank_branch_name#k#")#:#evaluate("attributes.account_no#k#")#'; //satır acıklamaları borc acıklama aray e set edilir.
								else if(isDefined("attributes.action_detail") and len(attributes.action_detail))
									satir_detay_list[2][listlen(alacak_tutarlar)] = ' #attributes.action_detail#';
								else
									satir_detay_list[2][listlen(alacak_tutarlar)] = ' ÇEK İADE GİRİŞ BANKA İŞLEMİ';
							}
						}
					}
					acc = get_cash_acc_code.A_CHEQUE_ACC_CODE;
					toplam = attributes.payroll_total;
					other_amount_borc_list=wrk_round(attributes.payroll_total/cash_currency_rate);
					other_currency_borc_list= listgetat(form.cash_id,3,';');
					if(isDefined("attributes.action_detail") and len(attributes.action_detail))
						satir_detay_list[1][1] = ' #attributes.action_detail#';
					else
						satir_detay_list[1][1] = ' ÇEK İADE GİRİŞ BANKA İŞLEMİ';
					if(len(attributes.exp_item_id) and len(attributes.exp_item_name) and isdefined("attributes.masraf") and (attributes.masraf gt 0) and len(attributes.expense_center))
					{
						alacak_hesaplar=listappend(alacak_hesaplar,GET_EXP_ACC.ACCOUNT_CODE, ',');
						alacak_tutarlar=listappend(alacak_tutarlar,attributes.sistem_masraf_tutari,',');
						other_amount_alacak_list=listappend(other_amount_alacak_list,attributes.masraf,',');
						other_currency_alacak_list=listappend(other_currency_alacak_list,attributes.masraf_currency,',');
						acc=listappend(acc,GET_EXP_ACC.ACCOUNT_CODE,',');
						toplam=listappend(toplam,attributes.sistem_masraf_tutari,',');
						other_amount_borc_list=listappend(other_amount_borc_list,attributes.masraf,',');
						other_currency_borc_list=listappend(other_currency_borc_list,attributes.masraf_currency,',');
						if(isDefined("attributes.action_detail") and len(attributes.action_detail))
						{
							satir_detay_list[1][2] = ' #attributes.action_detail#';
							satir_detay_list[2][listlen(alacak_tutarlar)] = ' #attributes.action_detail#';
						}
						else
						{
							satir_detay_list[1][2] = ' ÇEK İADE GİRİŞ BANKA İŞLEMİ';
							satir_detay_list[2][listlen(alacak_tutarlar)] = ' ÇEK İADE GİRİŞ BANKA İŞLEMİ';
						}
					}
					muhasebeci(
						action_id:P_ID,
						workcube_process_type:process_type,
						account_card_type:13,
						action_table :'PAYROLL',
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
						fis_detay:'ÇEK İADE GİRİŞ BANKA İŞLEMİ',
						fis_satir_detay:satir_detay_list,
						belge_no : form.payroll_no,
						from_branch_id : listgetat(form.cash_id,2,';'),
						to_branch_id : branch_id_info,
						workcube_process_cat : form.process_cat,
						is_account_group : is_account_group
					);
				}
				else		/*e-deftere uygun muhasebe islemleri yapılıyor*/
				{
					alacak_tutarlar = '';
					alacak_hesaplar = '';
					project_id = '';
					satir_detay_list = ArrayNew(2);
					get_bank_acc_code = cfquery(datasource:"#dsn2#",sqlstring:"SELECT ACCOUNT_ACC_CODE,CHEQUE_EXCHANGE_CODE,CHEQUE_GUARANTY_CODE FROM #dsn3_alias#.ACCOUNTS AS ACCOUNTS WHERE ACCOUNT_ID=#attributes.account_id#");
					get_cheque_acc_code = cfquery(datasource:"#dsn2#",sqlstring:"SELECT KARSILIKSIZ_CEKLER_CODE FROM #dsn3_alias#.ACCOUNTS AS ACCOUNTS WHERE ACCOUNT_ID=#attributes.account_id#");
					get_cash_acc_code=cfquery(datasource:"#dsn2#",sqlstring:"SELECT A_CHEQUE_ACC_CODE FROM CASH WHERE CASH_ID=#listfirst(form.cash_id,';')#");
					for(k=1; k lte attributes.record_num; k=k+1)
					{
						if(evaluate("attributes.row_kontrol#k#"))
						{
							if(evaluate("attributes.currency_id#k#") is session.ep.money)
								alacak_tutarlar=evaluate("attributes.cheque_value#k#");
							else
								alacak_tutarlar=evaluate("attributes.cheque_system_currency_value#k#");
			
							if(evaluate("attributes.cheque_status_id#k#") eq 2)
								alacak_hesaplar=get_bank_acc_code.CHEQUE_EXCHANGE_CODE;
							else if(evaluate("attributes.cheque_status_id#k#") eq 13)
							{	
								if(len(get_bank_acc_code.CHEQUE_GUARANTY_CODE))
									alacak_hesaplar=get_bank_acc_code.CHEQUE_GUARANTY_CODE;
								else
									alacak_hesaplar=acc_general;
							}
							else
								alacak_hesaplar=get_cheque_acc_code.KARSILIKSIZ_CEKLER_CODE;							
							
							GET_CHEQUE_PROJECT=cfquery(datasource:"#dsn2#",sqlstring:"SELECT
									P.PROJECT_ID
								FROM
									PAYROLL AS P,
									CHEQUE AS C
								WHERE
									P.ACTION_ID= C.CHEQUE_PAYROLL_ID AND
									C.CHEQUE_ID=#evaluate("attributes.cheque_id#k#")#");
							
							project_id = GET_CHEQUE_PROJECT.PROJECT_ID;		
							
							if (is_account_group neq 1)
							{ 
								if(isDefined("attributes.action_detail") and len(attributes.action_detail))
									satir_detay_list[2][1] = ' #evaluate("attributes.cheque_no#k#")# - #attributes.action_detail#';
								else
									satir_detay_list[2][1] = ' #evaluate("attributes.cheque_no#k#")# - ÇEK İADE GİRİŞ BANKA İŞLEMİ';
							}
							else
							{
								if(isDefined("attributes.action_detail") and len(attributes.action_detail))
									satir_detay_list[2][1] = ' #attributes.action_detail#';
								else
									satir_detay_list[2][1] = ' ÇEK İADE GİRİŞ BANKA İŞLEMİ';
							}
							if(isDefined("attributes.action_detail") and len(attributes.action_detail))
								satir_detay_list[1][1] = ' #attributes.action_detail#';
							else
								satir_detay_list[1][1] = ' ÇEK İADE GİRİŞ BANKA İŞLEMİ';
							muhasebeci(
								action_id:P_ID,
								action_row_id : evaluate("attributes.CHEQUE_ID#k#"),
								due_date :iif(len(evaluate("attributes.CHEQUE_DUEDATE#k#")),'createodbcdatetime(evaluate("attributes.CHEQUE_DUEDATE#k#"))','attributes.pyrll_avg_duedate'),
								workcube_process_type:process_type,
								account_card_type:13,
								action_table:'PAYROLL',
								islem_tarihi:attributes.PAYROLL_REVENUE_DATE,
								borc_hesaplar: get_cash_acc_code.A_CHEQUE_ACC_CODE,
								borc_tutarlar:alacak_tutarlar,
								other_amount_borc: wrk_round(evaluate("attributes.cheque_system_currency_value#k#")/cash_currency_rate),
								other_currency_borc: listgetat(form.cash_id,3,';'),
								alacak_hesaplar:alacak_hesaplar,
								alacak_tutarlar:alacak_tutarlar,
								other_amount_alacak: evaluate("attributes.cheque_value#k#"),
								other_currency_alacak: attributes.currency_id,
								currency_multiplier : currency_multiplier,
								fis_detay:'ÇEK İADE GİRİŞ BANKA İŞLEMİ',
								fis_satir_detay:satir_detay_list,
								belge_no : evaluate("attributes.cheque_no#k#"),
								from_branch_id : listgetat(form.cash_id,2,';'),
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
							satir_detay_list[1][2] = ' #attributes.action_detail#';
							satir_detay_list[2][1] = ' #attributes.action_detail#';
						}
						else
						{
							satir_detay_list[1][2] = ' ÇEK İADE GİRİŞ BANKA MASRAFI';
							satir_detay_list[2][1] = ' ÇEK İADE GİRİŞ BANKA MASRAFI';
						}
						muhasebeci(
							action_id:P_ID,
							workcube_process_type:process_type,
							account_card_type:13,
							action_table :'PAYROLL',
							islem_tarihi:attributes.PAYROLL_REVENUE_DATE,
							borc_hesaplar:GET_EXP_ACC.ACCOUNT_CODE,
							borc_tutarlar:attributes.sistem_masraf_tutari,
							other_amount_borc: attributes.masraf,
							other_currency_borc: attributes.masraf_currency,
							alacak_hesaplar:GET_EXP_ACC.ACCOUNT_CODE,
							alacak_tutarlar:attributes.sistem_masraf_tutari,
							other_amount_alacak: attributes.masraf,
							other_currency_alacak: attributes.masraf_currency,
							currency_multiplier : currency_multiplier,
							fis_detay:'ÇEK İADE GİRİŞ BANKA MASRAFI',
							fis_satir_detay:satir_detay_list,
							belge_no : form.payroll_no,
							from_branch_id : listgetat(form.cash_id,2,';'),
							to_branch_id : branch_id_info,
							workcube_process_cat : form.process_cat
						);	
					}
				}
			}
			basket_kur_ekle(action_id:GET_BORDRO_ID.P_ID,table_type_id:11,process_type:0);
		</cfscript>
		<!--- eger masraf tutarı girilmiş ise ve gider kalemi seçili ise bankaya ait kayıt oluşturur --->
		<cfif len(attributes.exp_item_id) and len(attributes.exp_item_name) and (attributes.masraf gt 0) and len(attributes.expense_center)>
			<cfinclude template="add_cheque_bank_masraf.cfm">
		</cfif>
		<cf_workcube_process_cat 
			process_cat="#form.process_cat#"
			action_id = #p_id#
			is_action_file = 1
			action_db_type = '#dsn2#'
			action_page='#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_add_payroll_bank_guaranty_return&event=upd&id=#p_id#'
			action_file_name='#get_process_type.action_file_name#'
			is_template_action_file = '#get_process_type.action_file_from_template#'>
    <cf_add_log log_type="1" action_id="#p_id#" action_name="#attributes.payroll_no# Eklendi" paper_no="#form.payroll_no#" period_id="#session.ep.period_id#" process_type="#get_process_type.process_type#" data_source="#dsn2#">            
	</cftransaction>
</cflock>
<cfset attributes.actionId=p_id>
<script type="text/javascript">
	window.location.href="<cfoutput>#request.self#?fuseaction=cheque.form_add_payroll_bank_guaranty_return&event=upd&id=#p_id#</cfoutput>";
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
