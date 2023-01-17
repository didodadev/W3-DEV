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
<cfquery name="check_our_company" datasource="#dsn#">
	SELECT IS_REMAINING_AMOUNT FROM OUR_COMPANY_INFO WHERE COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
</cfquery>
<cfquery name="get_process_type" datasource="#dsn3#">
	SELECT 
		PROCESS_TYPE,
		IS_CARI,
		IS_ACCOUNT,
		IS_ACCOUNT_GROUP,
		IS_CHEQUE_BASED_ACTION,
		IS_CHEQUE_BASED_ACC_ACTION,
		ACCOUNT_TYPE_ID
	 FROM 
	 	SETUP_PROCESS_CAT 
	WHERE 
		PROCESS_CAT_ID = #form.process_cat#
</cfquery>
<cfscript>
	process_type = get_process_type.PROCESS_TYPE;
	is_account = get_process_type.IS_ACCOUNT;
	is_account_group = get_process_type.IS_ACCOUNT_GROUP;
	is_cari =get_process_type.IS_CARI;
	is_voucher_based = get_process_type.IS_CHEQUE_BASED_ACTION;
	is_voucher_based_acc = get_process_type.IS_CHEQUE_BASED_ACC_ACTION;
	is_account_type_id = get_process_type.ACCOUNT_TYPE_ID;
	attributes.payroll_total = filterNum(attributes.payroll_total);
	attributes.other_payroll_total = filterNum(attributes.other_payroll_total);
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
	kasa_id = listfirst(attributes.cash_id,';');
	if(listlen(attributes.employee_id,'_') eq 2)
	{
		attributes.acc_type_id = listlast(attributes.employee_id,'_');
		attributes.employee_id = listfirst(attributes.employee_id,'_');
	}
</cfscript>
<cfif not isdefined("attributes.acc_type_id")><cfset attributes.acc_type_id = len(is_account_type_id) ? is_account_type_id : ""></cfif>
<cfquery name="control_no" datasource="#dsn2#">
	SELECT ACTION_ID FROM VOUCHER_PAYROLL WHERE PAYROLL_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.PAYROLL_NO#"> 
</cfquery>
<cfif control_no.RECORDCOUNT>
	<script type="text/javascript">
		alert("<cf_get_lang no='125.Aynı Bordro No ya Ait Kayıt Var !'>");
		history.back();
	</script>
	<cfabort>
</cfif>
<cfif is_account eq 1>
	<cfif attributes.member_type eq "partner" and len(attributes.company_id)>
		<cfset acc = get_company_period(company_id:attributes.company_id,acc_type_id:len(is_account_type_id) ? is_account_type_id : "")>
	<cfelseif attributes.member_type eq "consumer" and len(attributes.consumer_id)>
		<cfset acc = get_consumer_period(consumer_id:attributes.consumer_id,acc_type_id:len(is_account_type_id) ? is_account_type_id : "")>
	<cfelseif attributes.member_type eq "employee" and len(attributes.employee_id)>
		<cfset acc = get_employee_period(attributes.employee_id,attributes.acc_type_id)>
	</cfif>
	<cfif not len(acc)>
		<script type="text/javascript">
			alert("<cf_get_lang no='126.Seçtiğiniz Üyenin Muhasebe Kodu Secilmemiş !'>");
			history.back();	
		</script>
		<cfabort>
	</cfif>
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
					PROJECT_ID,
					COMPANY_ID,
					CONSUMER_ID,
					EMPLOYEE_ID,
					CURRENCY_ID,
					PAYROLL_REVENUE_DATE,
					PAYROLL_REV_MEMBER,
					PAYROLL_AVG_DUEDATE,
					PAYROLL_AVG_AGE,
					PAYROLL_NO,
					RECORD_EMP,
					RECORD_IP,
					RECORD_DATE,
					PAYROLL_CASH_ID,
					VOUCHER_BASED_ACC_CARI,
					ACTION_DETAIL,
					BRANCH_ID,
					SPECIAL_DEFINITION_ID,
					ASSETP_ID,
					ACC_TYPE_ID
				)
				VALUES
				(
					#form.process_cat#,
					#process_type#,
					#attributes.payroll_total#,
					<cfif isdefined("attributes.basket_money") and len(attributes.basket_money)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.basket_money#">,<cfelse>NULL,</cfif>
					<cfif isdefined("attributes.other_payroll_total") and len(attributes.other_payroll_total)>#attributes.other_payroll_total#,<cfelse>NULL,</cfif>
					#attributes.voucher_num#,
					<cfif len(attributes.project_name) and len(attributes.project_id)>#attributes.project_id#<cfelse>NULL</cfif>,
					<cfif attributes.member_type eq "partner" and len(attributes.company_id)>#attributes.company_id#<cfelse>NULL</cfif>,
					<cfif attributes.member_type eq "consumer" and len(attributes.consumer_id)>#attributes.consumer_id#<cfelse>NULL</cfif>,
					<cfif attributes.member_type eq "employee" and len(attributes.employee_id)>#attributes.employee_id#<cfelse>NULL</cfif>,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money#">,
					#attributes.PAYROLL_REVENUE_DATE#,
					#attributes.pro_employee_id#,
					#attributes.pyrll_avg_duedate#,
					<cfif len(attributes.pyrll_avg_age)>#attributes.pyrll_avg_age#,<cfelse>NULL,</cfif>
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.PAYROLL_NO#">,
					#session.ep.userid#,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">,
					#NOW()#,
					<cfif isdefined('attributes.cash_id') and len(attributes.cash_id)>#listfirst(attributes.cash_id,';')#<cfelse>NULL</cfif>,
					<cfif len(is_voucher_based)>#is_voucher_based#<cfelse>0</cfif>,
					<cfif isDefined("attributes.action_detail") and len(attributes.action_detail)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.action_detail#"><cfelse>NULL</cfif>,
					#branch_id_info#,
					<cfif isdefined("attributes.special_definition_id") and len(attributes.special_definition_id)>#attributes.special_definition_id#<cfelse>NULL</cfif>,
					<cfif isdefined("attributes.asset_id") and len(attributes.asset_id) and len(attributes.asset_name)>#attributes.asset_id#<cfelse>NULL</cfif>,
					<cfif isdefined("attributes.acc_type_id") and len(attributes.acc_type_id)>#attributes.acc_type_id#<cfelse>NULL</cfif>
				)
		</cfquery>
		<cfquery name="GET_BORDRO_ID" datasource="#dsn2#">
			SELECT MAX(ACTION_ID) AS P_ID FROM VOUCHER_PAYROLL
		</cfquery>
		<cfset p_id=get_bordro_id.P_ID> 			
		<cfloop from="1" to="#attributes.record_num#" index="i">
			<cfif evaluate("attributes.row_kontrol#i#")>
				<cf_date tarih='attributes.voucher_duedate#i#'>
				<cfquery name="UPD_VOUCHERS" datasource="#dsn2#">
					UPDATE VOUCHER SET VOUCHER_STATUS_ID=9 WHERE VOUCHER_ID = #evaluate("attributes.voucher_id#i#")#
				</cfquery>
				<!-- durumu degisen senet bilgileri voucher_history tablosuna kaydedilecek--->
				<!--- Bordroya girilen senetler için voucher_history tablosuna giris yapiliyor...--->
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
							9,
							#attributes.PAYROLL_REVENUE_DATE#,
							<cfif len(evaluate("attributes.voucher_system_currency_value#i#"))>#evaluate("attributes.voucher_system_currency_value#i#")#,<cfelse>NULL,</cfif>
							<cfif len(evaluate("attributes.system_money_info#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.system_money_info#i#")#'>,<cfelse>NULL,</cfif>
							<cfif len(evaluate("attributes.other_money_value2#i#"))>#evaluate("attributes.other_money_value2#i#")#,<cfelse>NULL,</cfif>
							<cfif len(evaluate("attributes.other_money2#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.other_money2#i#")#'>,<cfelse>NULL,</cfif>
							#NOW()#
						)
				</cfquery>
			</cfif>
		</cfloop>
		<!--- add cari --->
		<cfscript>
			currency_multiplier = ''; //sistem ikinci para biriminin kurunu sayfadan alıyor
			paper_currency_multiplier = '';
			if(isDefined('attributes.kur_say') and len(attributes.kur_say))
				for(mon=1;mon lte attributes.kur_say;mon=mon+1)
				{
					if(evaluate("attributes.hidden_rd_money_#mon#") is session.ep.money2)
						currency_multiplier = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
					if(evaluate("attributes.hidden_rd_money_#mon#") is attributes.basket_money)
						paper_currency_multiplier = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
				}
		payroll_total_ = 0;
		if(is_cari eq 1)
			{
				if(is_voucher_based eq 1) /*cari hareket senet bazında yapılıyor.senet bazında carici calıstırılırken ACTION_TABLE parametresine dikkat plz...*/
				{
					for(cheq_i=1; cheq_i lte attributes.record_num; cheq_i=cheq_i+1)
					{
						if (evaluate("attributes.row_kontrol#cheq_i#") and evaluate("attributes.is_pay_term#cheq_i#") eq 0)
						{
							if (check_our_company.is_remaining_amount eq 1)
								voucher_value = evaluate("attributes.voucher_system_currency_value#cheq_i#");
							else
							{
								GET_VOUCHER=cfquery(datasource:"#dsn2#", sqlstring:"SELECT ISNULL(SUM(CLOSED_AMOUNT),0) CLOSED_AMOUNT FROM VOUCHER_CLOSED WHERE IS_VOUCHER_DELAY IS NULL AND ACTION_ID=#evaluate("attributes.voucher_id#cheq_i#")#");
								voucher_value = evaluate("attributes.voucher_system_currency_value#cheq_i#") - GET_VOUCHER.CLOSED_AMOUNT;
							}
							if(len(attributes.basket_money) and len(attributes.basket_money_rate))
							{
								other_money = attributes.basket_money;
								other_money_value = wrk_round(voucher_value/attributes.basket_money_rate);
							}
							else if(evaluate("attributes.currency_id#cheq_i#") is not session.ep.money)
							{
								other_money = evaluate("attributes.currency_id#cheq_i#");
								other_money_value = wrk_round(voucher_value/attributes.basket_money_rate);
							}
							else
							{
								other_money = evaluate("attributes.system_money_info#cheq_i#"); //senet sistem para birimi tutarı
								other_money_value = voucher_value;
							}
							paper_currency_multiplier = '';
							if(isDefined('attributes.kur_say') and len(attributes.kur_say))
								for(mon=1;mon lte attributes.kur_say;mon=mon+1)
								{
									if(evaluate("attributes.hidden_rd_money_#mon#") is other_money)
										paper_currency_multiplier = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
								}
							carici(
								action_id :evaluate("attributes.voucher_id#cheq_i#"),
								workcube_process_type :process_type,		
								process_cat : form.process_cat,
								account_card_type :13,
								action_table :'VOUCHER',
								islem_tarihi :attributes.PAYROLL_REVENUE_DATE,
								islem_tutari :voucher_value,
								other_money_value : other_money_value,
								other_money : other_money,
								islem_belge_no : evaluate("attributes.voucher_no#cheq_i#"),
								action_currency : session.ep.money,
								payer_id :attributes.pro_employee_id,
								to_cmp_id : iif(attributes.member_type eq "partner",'attributes.company_id',de('')),
								to_consumer_id : iif(attributes.member_type eq "consumer",'attributes.consumer_id',de('')),
								to_employee_id : iif(attributes.member_type eq "employee",'attributes.employee_id',de('')),							
								due_date : iif(len(evaluate("attributes.voucher_duedate#cheq_i#")),'createodbcdatetime(evaluate("attributes.voucher_duedate#cheq_i#"))','attributes.pyrll_avg_duedate'),
								currency_multiplier : currency_multiplier,
								islem_detay : 'SENET İADE ÇIKIŞ BORDROSU(Senet Bazında)',
								acc_type_id : attributes.acc_type_id,
								action_detail : attributes.action_detail,
								project_id : attributes.project_id,
								to_branch_id : branch_id_info,
								payroll_id :P_ID,
								special_definition_id : iif((isdefined("attributes.special_definition_id") and len(attributes.special_definition_id)),'attributes.special_definition_id',de('')),
								assetp_id : iif((isdefined("attributes.asset_id") and len(attributes.asset_id) and len(attributes.asset_name)),'attributes.asset_id',de('')),
								rate2:paper_currency_multiplier
								);
						}
					}
				}
				else
				{
					carici(
						action_id :P_ID,
						workcube_process_type :process_type,		
						process_cat : form.process_cat,
						account_card_type :13,
						action_table :'VOUCHER_PAYROLL',
						islem_tarihi :attributes.PAYROLL_REVENUE_DATE,
						islem_tutari :attributes.payroll_total,
						other_money_value : iif(len(attributes.other_payroll_total),'attributes.other_payroll_total',de('')),
						other_money : iif(len(attributes.basket_money),'attributes.basket_money',de('')),
						islem_belge_no : attributes.payroll_no,
						action_currency : session.ep.money,
						payer_id :attributes.pro_employee_id,
						to_cmp_id : iif(attributes.member_type eq "partner",'attributes.company_id',de('')),
						to_consumer_id : iif(attributes.member_type eq "consumer",'attributes.consumer_id',de('')),
						to_employee_id : iif(attributes.member_type eq "employee",'attributes.employee_id',de('')),							
						due_date : attributes.pyrll_avg_duedate,
						currency_multiplier : currency_multiplier,
						islem_detay : 'SENET İADE ÇIKIŞ BORDROSU',
						acc_type_id : attributes.acc_type_id,
						action_detail : attributes.action_detail,
						project_id : attributes.project_id,
						to_branch_id : branch_id_info,
						special_definition_id : iif((isdefined("attributes.special_definition_id") and len(attributes.special_definition_id)),'attributes.special_definition_id',de('')),
						assetp_id : iif((isdefined("attributes.asset_id") and len(attributes.asset_id) and len(attributes.asset_name)),'attributes.asset_id',de('')),
						rate2:paper_currency_multiplier
						);
				}
			}
		// add_accound_card 
		if (is_account eq 1)
		{
			if(is_voucher_based_acc neq 1) //Standart muhasebe islemi yapiliyor
			{
				alacakli_hesaplar = '';
				alacakli_tutarlar = '';
				other_amount_alacak_list = '';
				other_currency_alacak_list = '';
				kontrol_row = 0;
				payroll_total_ = 0;
				for(i=1; i lte attributes.record_num; i=i+1)
				{
					if (evaluate("attributes.row_kontrol#i#") and evaluate("attributes.is_pay_term#i#") eq 0)
					{
						kontrol_row = 1;
						if (check_our_company.is_remaining_amount eq 1)
							voucher_value = evaluate("attributes.voucher_system_currency_value#i#");
						else
						{
							GET_VOUCHER=cfquery(datasource:"#dsn2#", sqlstring:"SELECT ISNULL(SUM(CLOSED_AMOUNT),0) CLOSED_AMOUNT FROM VOUCHER_CLOSED WHERE IS_VOUCHER_DELAY IS NULL AND ACTION_ID=#evaluate("attributes.voucher_id#i#")#");
							voucher_value = evaluate("attributes.voucher_system_currency_value#i#") - GET_VOUCHER.CLOSED_AMOUNT;
						}
						alacakli_tutarlar=listappend(alacakli_tutarlar,voucher_value,',');
						other_currency_alacak_list = listappend(other_currency_alacak_list,listgetat(form.cash_id,3,';'),',');
						other_amount_alacak_list =  listappend(other_amount_alacak_list,wrk_round(voucher_value/attributes.basket_money_rate),',');
						payroll_total_ = payroll_total_ + voucher_value;
						if(evaluate("attributes.voucher_status_id#i#") eq 5)
						{
							GET_ACC_CODE=cfquery(datasource:"#dsn2#",sqlstring:"SELECT PROTESTOLU_SENETLER_CODE FROM CASH WHERE CASH_ID = #kasa_id#"); //karsiliksiz senet ise, kasa tanimlarindaki protestolu senet hesabı kullanılır
							alacakli_hesaplar=listappend(alacakli_hesaplar, GET_ACC_CODE.PROTESTOLU_SENETLER_CODE, ',');
						}	
						else if(evaluate("attributes.voucher_status_id#i#") eq 1 or evaluate("attributes.voucher_status_id#i#") eq 10 or evaluate("attributes.voucher_status_id#i#") eq 11)
						{
							GET_ACC_CODE_3=cfquery(datasource:"#dsn2#",sqlstring:"
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
							if(GET_ACC_CODE_3.recordcount eq 0)
							{
								GET_ACC_CODE_3=cfquery(datasource:"#dsn2#",sqlstring:"
									SELECT
										C.A_VOUCHER_ACC_CODE
									FROM
										VOUCHER_PAYROLL AS P,
										VOUCHER_HISTORY AS CH,
										CASH AS C
									WHERE
										P.PAYROLL_CASH_ID = C.CASH_ID AND
										P.PAYROLL_TYPE IN(97,107,109) AND
										P.ACTION_ID= CH.PAYROLL_ID AND
										CH.VOUCHER_ID=#evaluate("attributes.voucher_id#i#")#");
							}
							alacakli_hesaplar=listappend(alacakli_hesaplar, GET_ACC_CODE_3.A_VOUCHER_ACC_CODE, ',');
						}
						if (is_account_group neq 1)
						{ 
							if(isDefined("attributes.action_detail") and len(attributes.action_detail))
								str_card_detail[2][listlen(alacakli_tutarlar)] = ' #evaluate("attributes.voucher_no#i#")# - #attributes.company_name# - #attributes.action_detail#';
							else
								str_card_detail[2][listlen(alacakli_tutarlar)] = ' #evaluate("attributes.voucher_no#i#")# - #attributes.company_name# - SENET İADE ÇIKIŞ İŞLEMİ';
						}
						else
						{
							if(isDefined("attributes.action_detail") and len(attributes.action_detail))
								str_card_detail[2][listlen(alacakli_tutarlar)] = ' #attributes.company_name# - #attributes.action_detail#';
							else
								str_card_detail[2][listlen(alacakli_tutarlar)] = ' #attributes.company_name# - SENET İADE ÇIKIŞ İŞLEMİ';
						}
					}
				}
				if(kontrol_row == 1)
				{
					if(isDefined("attributes.action_detail") and len(attributes.action_detail))
						str_card_detail[1][1] = ' #attributes.company_name# - #attributes.action_detail#';
					else
						str_card_detail[1][1] = ' #attributes.company_name# - SENET İADE ÇIKIŞ İŞLEMİ';
						
					muhasebeci (
						action_id:p_id,
						workcube_process_type:process_type,
						account_card_type:13,
						action_table :'VOUCHER_PAYROLL',
						islem_tarihi:attributes.PAYROLL_REVENUE_DATE,
						company_id : iif(attributes.member_type eq "partner",'attributes.company_id',de('')),
						consumer_id : iif(attributes.member_type eq "consumer",'attributes.consumer_id',de('')),
						employee_id : iif(attributes.member_type eq "employee",'attributes.employee_id',de('')),
						borc_hesaplar: acc,
						borc_tutarlar: payroll_total_,
						other_amount_borc : wrk_round(payroll_total_/paper_currency_multiplier),
						other_currency_borc : iif(len(attributes.basket_money),'attributes.basket_money',de('')),
						alacak_hesaplar: alacakli_hesaplar,
						alacak_tutarlar: alacakli_tutarlar,
						other_amount_alacak : other_amount_alacak_list,
						other_currency_alacak : other_currency_alacak_list,
						currency_multiplier : currency_multiplier,
						fis_detay : 'SENET İADE ÇIKIŞ İŞLEMİ',
						fis_satir_detay : str_card_detail,
						belge_no : form.payroll_no,
						to_branch_id : branch_id_info,
						workcube_process_cat : form.process_cat,
						acc_project_id : attributes.project_id,
						is_account_group : is_account_group
					);
				}
			}
			else		/* e-deftere uygun muhasebe hareketi yapiliyor */
			{
				alacakli_hesaplar = '';
				alacakli_tutarlar = '';
				for(i=1; i lte attributes.record_num; i=i+1)
				{
					if (evaluate("attributes.row_kontrol#i#") and evaluate("attributes.is_pay_term#i#") eq 0)
					{
						if (check_our_company.is_remaining_amount eq 1)
							voucher_value = evaluate("attributes.voucher_system_currency_value#i#");
						else
						{
							GET_VOUCHER=cfquery(datasource:"#dsn2#", sqlstring:"SELECT ISNULL(SUM(CLOSED_AMOUNT),0) CLOSED_AMOUNT FROM VOUCHER_CLOSED WHERE IS_VOUCHER_DELAY IS NULL AND ACTION_ID=#evaluate("attributes.voucher_id#i#")#");
							voucher_value = evaluate("attributes.voucher_system_currency_value#i#") - GET_VOUCHER.CLOSED_AMOUNT;
						}
						alacakli_tutarlar = voucher_value;
						if(evaluate("attributes.voucher_status_id#i#") eq 5)
						{
							GET_ACC_CODE=cfquery(datasource:"#dsn2#",sqlstring:"SELECT PROTESTOLU_SENETLER_CODE FROM CASH WHERE CASH_ID = #kasa_id#"); //karsiliksiz senet ise, kasa tanimlarindaki protestolu senet hesabı kullanılır
							alacakli_hesaplar=GET_ACC_CODE.PROTESTOLU_SENETLER_CODE;
						}	
						else if(evaluate("attributes.voucher_status_id#i#") eq 1 or evaluate("attributes.voucher_status_id#i#") eq 10 or evaluate("attributes.voucher_status_id#i#") eq 11)
						{
							GET_ACC_CODE_3=cfquery(datasource:"#dsn2#",sqlstring:"
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
							if(GET_ACC_CODE_3.recordcount eq 0)
							{
								GET_ACC_CODE_3=cfquery(datasource:"#dsn2#",sqlstring:"
									SELECT
										C.A_VOUCHER_ACC_CODE
									FROM
										VOUCHER_PAYROLL AS P,
										VOUCHER_HISTORY AS CH,
										CASH AS C
									WHERE
										P.PAYROLL_CASH_ID = C.CASH_ID AND
										P.PAYROLL_TYPE IN(97,107,109) AND
										P.ACTION_ID= CH.PAYROLL_ID AND
										CH.VOUCHER_ID=#evaluate("attributes.voucher_id#i#")#");
							}
							alacakli_hesaplar=GET_ACC_CODE_3.A_VOUCHER_ACC_CODE;
						}
						if (is_account_group neq 1)
						{ 
							if(isDefined("attributes.action_detail") and len(attributes.action_detail))
								str_card_detail[2][1] = ' #evaluate("attributes.voucher_no#i#")# - #attributes.company_name# - #attributes.action_detail#';
							else
								str_card_detail[2][1] = ' #evaluate("attributes.voucher_no#i#")# - #attributes.company_name# - SENET İADE ÇIKIŞ İŞLEMİ';
						}
						else
						{
							if(isDefined("attributes.action_detail") and len(attributes.action_detail))
								str_card_detail[2][1] = ' #attributes.company_name# - #attributes.action_detail#';
							else
								str_card_detail[2][1] = ' #attributes.company_name# - SENET İADE ÇIKIŞ İŞLEMİ';
						}
						if(isDefined("attributes.action_detail") and len(attributes.action_detail))
							str_card_detail[1][1] = ' #attributes.company_name# - #attributes.action_detail#';
						else
							str_card_detail[1][1] = ' #attributes.company_name# - SENET İADE ÇIKIŞ İŞLEMİ';
							
						muhasebeci (
							action_id:p_id,
							action_row_id : evaluate("attributes.VOUCHER_ID#i#"),
							due_date :iif(len(evaluate("attributes.VOUCHER_DUEDATE#i#")),'createodbcdatetime(evaluate("attributes.VOUCHER_DUEDATE#i#"))','attributes.pyrll_avg_duedate'),
							workcube_process_type:process_type,
							account_card_type:13,
							action_table :'VOUCHER_PAYROLL',
							islem_tarihi:attributes.PAYROLL_REVENUE_DATE,
							company_id : iif(attributes.member_type eq "partner",'attributes.company_id',de('')),
							consumer_id : iif(attributes.member_type eq "consumer",'attributes.consumer_id',de('')),
							employee_id : iif(attributes.member_type eq "employee",'attributes.employee_id',de('')),
							borc_hesaplar: acc,
							borc_tutarlar: alacakli_tutarlar,
							other_amount_borc : wrk_round(alacakli_tutarlar/paper_currency_multiplier),
							other_currency_borc : iif(len(attributes.basket_money),'attributes.basket_money',de('')),
							alacak_hesaplar: alacakli_hesaplar,
							alacak_tutarlar: alacakli_tutarlar,
							other_amount_alacak : evaluate("attributes.voucher_value#i#"),
							other_currency_alacak : listgetat(form.cash_id,3,';'),
							currency_multiplier : currency_multiplier,
							fis_detay : 'SENET İADE ÇIKIŞ İŞLEMİ',
							fis_satir_detay : str_card_detail,
							belge_no : evaluate("attributes.voucher_no#i#"),
							to_branch_id : branch_id_info,
							workcube_process_cat : form.process_cat,
							acc_project_id : attributes.project_id,
							is_account_group : is_account_group
						);
					}
				}
			}
		}
		basket_kur_ekle(action_id:GET_BORDRO_ID.P_ID,table_type_id:12,process_type:0);
	  </cfscript>
      <cf_add_log log_type="1" action_id="#p_id#" action_name="#form.payroll_no# Eklendi" paper_no="#form.payroll_no#" period_id="#session.ep.period_id#" process_type="#get_process_type.PROCESS_TYPE#" data_source="#dsn2#">
	</cftransaction>
</cflock> 
<script type="text/javascript">
	window.location.href="<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.add_voucher_payroll_endor_return&event=upd&ID=#p_id#</cfoutput>";
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
