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
		IS_CARI,
		IS_ACCOUNT,
		IS_ACCOUNT_GROUP,
		IS_CHEQUE_BASED_ACTION,
		IS_CHEQUE_BASED_ACC_ACTION,
		ACTION_FILE_NAME,
		ACTION_FILE_FROM_TEMPLATE,
		ACCOUNT_TYPE_ID
	 FROM 
	 	SETUP_PROCESS_CAT 
	WHERE 
		PROCESS_CAT_ID = #form.process_cat#
</cfquery>
<cfscript>
	process_type = get_process_type.PROCESS_TYPE;
	is_cari =get_process_type.IS_CARI;
	is_account = get_process_type.IS_ACCOUNT;
	is_account_group = get_process_type.IS_ACCOUNT_GROUP;
	is_cheque_based = get_process_type.IS_CHEQUE_BASED_ACTION;
	is_cheque_based_acc = get_process_type.IS_CHEQUE_BASED_ACC_ACTION;
	attributes.payroll_total = filterNum(attributes.payroll_total);
	attributes.other_payroll_total = filterNum(attributes.other_payroll_total);
	is_account_type_id = get_process_type.ACCOUNT_TYPE_ID;
	for(ff=1; ff lte attributes.record_num; ff=ff+1)
	{
		if (evaluate("attributes.row_kontrol#ff#"))
		{
			'attributes.cheque_system_currency_value#ff#' = filterNum(evaluate("attributes.cheque_system_currency_value#ff#"));
			'attributes.cheque_value#ff#' = filterNum(evaluate("attributes.cheque_value#ff#"));
		}
	}
	for(rt = 1; rt lte attributes.kur_say; rt = rt + 1)
	{
		'attributes.txt_rate1_#rt#' = filterNum(evaluate('attributes.txt_rate1_#rt#'),session.ep.our_company_info.rate_round_num);
		'attributes.txt_rate2_#rt#' = filterNum(evaluate('attributes.txt_rate2_#rt#'),session.ep.our_company_info.rate_round_num);
	}
	branch_id_info = listgetat(form.cash_id,2,';');
	
	if(listlen(attributes.employee_id,'_') eq 2)
	{
		attributes.acc_type_id = listlast(attributes.employee_id,'_');
		attributes.employee_id = listfirst(attributes.employee_id,'_');
	}
</cfscript>
<cfif not isdefined("attributes.acc_type_id")><cfset attributes.acc_type_id = len(is_account_type_id) ? is_account_type_id : ""></cfif>
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
		<!--- Önce bordro tablosuna kaydediliyor--->
		<cfquery name="ADD_PAYROLL" datasource="#dsn2#">
			INSERT INTO
				PAYROLL
				(
					PROCESS_CAT,
					PAYROLL_TYPE,
					COMPANY_ID,
					CONSUMER_ID,
					EMPLOYEE_ID,
					PAYROLL_AVG_DUEDATE,
					PAYROLL_TOTAL_VALUE,
					PAYROLL_OTHER_MONEY,
					PAYROLL_OTHER_MONEY_VALUE,
					PAYROLL_AVG_AGE,
					NUMBER_OF_CHEQUE,
					PROJECT_ID,	
					PAYROLL_CASH_ID,
					CURRENCY_ID,
					PAYROLL_REVENUE_DATE,
					PAYROLL_NO,
					RECORD_EMP,
					RECORD_IP,
					RECORD_DATE,		
					REVENUE_COLLECTOR_ID,
					CHEQUE_BASED_ACC_CARI,
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
					<cfif attributes.member_type eq "partner" and len(attributes.company_id)>#attributes.company_id#<cfelse>NULL</cfif>,
					<cfif attributes.member_type eq "consumer" and len(attributes.consumer_id)>#attributes.consumer_id#<cfelse>NULL</cfif>,
					<cfif attributes.member_type eq "employee" and len(attributes.employee_id)>#attributes.employee_id#<cfelse>NULL</cfif>,
					#attributes.pyrll_avg_duedate#,
					#attributes.payroll_total#,
					<cfif isdefined("attributes.basket_money") and len(attributes.basket_money)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.basket_money#">,<cfelse>NULL,</cfif>
					<cfif isdefined("attributes.other_payroll_total") and len(attributes.other_payroll_total)>#attributes.other_payroll_total#,<cfelse>NULL,</cfif>
					<cfif len(attributes.pyrll_avg_age)>#attributes.pyrll_avg_age#,<cfelse>NULL,</cfif>
					#attributes.cheque_num#,
					<cfif len(attributes.project_name) and len(attributes.project_id)>#attributes.project_id#<cfelse>NULL</cfif>,
					#listfirst(cash_id,';')#,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money#">,
					#attributes.payroll_revenue_date#,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.PAYROLL_NO#">,
					#session.ep.userid#,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">,
					#NOW()#,
					#attributes.REVENUE_COLLECTOR_ID#,
					<cfif len(is_cheque_based)>#is_cheque_based#<cfelse>0</cfif>,
					<cfif isDefined("attributes.action_detail") and len(attributes.action_detail)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.action_detail#"><cfelse>NULL</cfif>,
					#branch_id_info#,
					<cfif isdefined("attributes.special_definition_id") and len(attributes.special_definition_id)>#attributes.special_definition_id#<cfelse>NULL</cfif>,
					<cfif isdefined("attributes.asset_id") and len(attributes.asset_id) and len(attributes.asset_name)>#attributes.asset_id#<cfelse>NULL</cfif>,
					<cfif isdefined("attributes.acc_type_id") and len(attributes.acc_type_id)>#attributes.acc_type_id#<cfelse>NULL</cfif>
				)
		</cfquery>
		<cfquery name="GET_BORDRO_ID" datasource="#dsn2#">
			SELECT MAX(ACTION_ID) AS P_ID FROM PAYROLL
		</cfquery>
		<cfset p_id=get_bordro_id.P_ID>
		<!--- çek durumlari çek tablosundan update edilecek--->
		<cfloop from="1" to="#attributes.record_num#" index="i">
			<cfif evaluate("attributes.row_kontrol#i#")>
				<cf_date tarih='attributes.cheque_duedate#i#'>
				<cfquery name="UPD_CHEQUES" datasource="#dsn2#">
					UPDATE CHEQUE
						SET
						<cfif evaluate("attributes.cheque_status_id#i#") eq 4>
							CHEQUE_STATUS_ID=1
						<cfelseif evaluate("attributes.cheque_status_id#i#") eq 6>
							CHEQUE_STATUS_ID=8
						</cfif>
					WHERE
						CHEQUE_ID = #evaluate("attributes.cheque_id#i#")#
				</cfquery>
				<cfquery name="add_history" datasource="#dsn2#">
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
							<cfif evaluate("attributes.cheque_status_id#i#") eq 4>
								1,
							<cfelseif evaluate("attributes.cheque_status_id#i#") eq 6>
								8,
							</cfif>
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
						
			if(is_cari eq 1)
			{
				if(is_cheque_based eq 1) /*cari hareket cek bazında yapılıyor.cek bazında carici calıstırılırken ACTION_TABLE parametresine dikkat plz...*/
				{
					for(cheq_i=1; cheq_i lte attributes.record_num; cheq_i=cheq_i+1)
					{
						if (evaluate("attributes.row_kontrol#cheq_i#"))
						{
							if(len(attributes.basket_money) and len(attributes.basket_money_rate))
							{
								other_money = attributes.basket_money;
								other_money_value = wrk_round(evaluate("attributes.cheque_system_currency_value#cheq_i#")/attributes.basket_money_rate);
							}
							else if(evaluate("attributes.currency_id#cheq_i#") is not session.ep.money)
							{
								other_money = evaluate("attributes.currency_id#cheq_i#");
								other_money_value = evaluate("attributes.cheque_value#cheq_i#");
							}
							else if(len(evaluate("attributes.other_money_value2#cheq_i#")) and len(evaluate("attributes.other_money2#cheq_i#")))
							{
								other_money = evaluate("attributes.other_money2#cheq_i#");
								other_money_value = evaluate("attributes.other_money_value2#cheq_i#");
							}
							else
							{
								other_money = evaluate("attributes.system_money_info#cheq_i#"); //cek sistem para birimi tutarı
								other_money_value = evaluate("attributes.cheque_system_currency_value#cheq_i#");
							}
							paper_currency_multiplier = '';
							if(isDefined('attributes.kur_say') and len(attributes.kur_say))
								for(mon=1;mon lte attributes.kur_say;mon=mon+1)
								{
									if(evaluate("attributes.hidden_rd_money_#mon#") is other_money)
										paper_currency_multiplier = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
								}
							carici(
								action_id :evaluate("attributes.cheque_id#cheq_i#"),
								workcube_process_type :process_type,		
								process_cat : form.process_cat,
								account_card_type :13,
								action_table :'CHEQUE',
								islem_tarihi :attributes.PAYROLL_REVENUE_DATE,
								islem_tutari :evaluate("attributes.cheque_system_currency_value#cheq_i#"),
								other_money_value : other_money_value,
								other_money : other_money,
								action_currency :session.ep.money,
								currency_multiplier : currency_multiplier,
								due_date : iif(len(evaluate("attributes.cheque_duedate#cheq_i#")),'createodbcdatetime(evaluate("attributes.cheque_duedate#cheq_i#"))','attributes.pyrll_avg_duedate'),
								from_cmp_id : iif(attributes.member_type eq "partner",'attributes.company_id',de('')),
								from_consumer_id : iif(attributes.member_type eq "consumer",'attributes.consumer_id',de('')),
								from_employee_id : iif(attributes.member_type eq "employee",'attributes.employee_id',de('')),
								to_cash_id : listfirst(form.cash_id,';'),
								islem_belge_no : evaluate("attributes.cheque_no#cheq_i#"),
								islem_detay : 'ÇEK İADE GİRİŞ BORDROSU(Çek Bazında)',
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
						action_table :'PAYROLL',
						islem_tarihi :attributes.PAYROLL_REVENUE_DATE,
						islem_tutari :attributes.payroll_total,
						other_money_value : iif(len(attributes.other_payroll_total),'attributes.other_payroll_total',de('')),
						other_money : iif(len(attributes.basket_money),'attributes.basket_money',de('')),
						action_currency :session.ep.money,
						currency_multiplier : currency_multiplier,
						due_date : attributes.pyrll_avg_duedate,
						from_cmp_id : iif(attributes.member_type eq "partner",'attributes.company_id',de('')),
						from_consumer_id : iif(attributes.member_type eq "consumer",'attributes.consumer_id',de('')),
						from_employee_id : iif(attributes.member_type eq "employee",'attributes.employee_id',de('')),
						to_cash_id : listfirst(form.cash_id,';'),
						islem_belge_no :attributes.payroll_no,
						islem_detay : 'ÇEK İADE GİRİŞ BORDROSU',
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
			/*<!--- add account_card : burada kasa "borçlu", firma "alacakli" olacak--->*/
			if(is_account eq 1)
			{
				if(is_cheque_based_acc neq 1)	/*standart muhasebe islemleri yapılıyor*/
				{
					borc_tutarlar = '';
					borc_hesaplar = '';
					other_currency_borc_list = '';
					other_amount_borc_list = '';
					satir_detay_list = ArrayNew(2);
					for(i=1; i lte attributes.record_num; i=i+1)
					{
						if (evaluate("attributes.row_kontrol#i#"))
						{
							if(evaluate("attributes.currency_id#i#") is session.ep.money)
								borc_tutarlar=listappend(borc_tutarlar,evaluate("attributes.cheque_value#i#"),',');
							else
								borc_tutarlar=listappend(borc_tutarlar,evaluate("attributes.cheque_system_currency_value#i#"),',');
							if (evaluate("attributes.cheque_status_id#i#") eq 4)
							{
								GET_ACC_CODE=cfquery(datasource:"#dsn2#",sqlstring:"SELECT
									C.A_CHEQUE_ACC_CODE CHEQUE_ACC_CODE
								FROM
									PAYROLL AS P,
									CHEQUE_HISTORY AS CH,
									CASH AS C
								WHERE
									P.TRANSFER_CASH_ID = C.CASH_ID AND
									P.PAYROLL_TYPE IN (135) AND
									P.ACTION_ID= CH.PAYROLL_ID AND
									CH.CHEQUE_ID=#evaluate("attributes.cheque_id#i#")#
								ORDER BY
									CH.HISTORY_ID DESC");
								if(GET_ACC_CODE.recordcount eq 0)
								{
									GET_ACC_CODE=cfquery(datasource:"#dsn2#",sqlstring:"SELECT
												C.A_CHEQUE_ACC_CODE CHEQUE_ACC_CODE
											FROM
												PAYROLL AS P,
												CHEQUE_HISTORY AS CH,
												CASH AS C
											WHERE
												P.PAYROLL_CASH_ID = C.CASH_ID AND
												P.PAYROLL_TYPE IN (90,106,105) AND
												P.ACTION_ID= CH.PAYROLL_ID AND
												CH.CHEQUE_ID=#evaluate("attributes.cheque_id#i#")#");
								}
							}
							else if (evaluate("attributes.cheque_status_id#i#") eq 6)
								GET_ACC_CODE=cfquery(datasource:"#dsn2#",sqlstring:"SELECT V_CHEQUE_ACC_CODE CHEQUE_ACC_CODE FROM #dsn3_alias#.ACCOUNTS AS ACCOUNTS WHERE ACCOUNT_ID=#evaluate("attributes.account_id#i#")#");
							else
								GET_ACC_CODE=cfquery(datasource:"#dsn2#",sqlstring:"SELECT A_CHEQUE_ACC_CODE CHEQUE_ACC_CODE FROM CASH WHERE CASH_ID=#listfirst(form.cash_id,';')#");
							borc_hesaplar=listappend(borc_hesaplar,GET_ACC_CODE.CHEQUE_ACC_CODE,',');
							other_currency_borc_list = listappend(other_currency_borc_list,listgetat(form.cash_id,3,';'),',');
							other_amount_borc_list =  listappend(other_amount_borc_list,evaluate("attributes.cheque_value#i#"),',');
							
							if (is_account_group neq 1)
							{ 
								if(attributes.x_detail_acc_card eq 1) //detaylı muhasebe seçilmişse çek bilgilerini yazıyoruz
									satir_detay_list[1][listlen(borc_tutarlar)]='Ç.İ.G.B.:#attributes.payroll_no#:#evaluate("attributes.bank_name#i#")#:#evaluate("attributes.bank_branch_name#i#")#:#evaluate("attributes.account_no#i#")#'; //satır acıklamaları borc acıklama aray e set edilir.
								else if(isDefined("attributes.action_detail") and len(attributes.action_detail))
									satir_detay_list[1][listlen(borc_tutarlar)] = ' #evaluate("attributes.cheque_no#i#")# - #attributes.company_name# - #attributes.action_detail#';
								else
									satir_detay_list[1][listlen(borc_tutarlar)] = ' #evaluate("attributes.cheque_no#i#")# - #attributes.company_name# - ÇEK İADE GİRİŞ İŞLEMİ';
							}
							else
							{
								if(attributes.x_detail_acc_card eq 1) //detaylı muhasebe seçilmişse çek bilgilerini yazıyoruz
									satir_detay_list[1][listlen(borc_tutarlar)]='Ç.İ.G.B.:#attributes.payroll_no#:#evaluate("attributes.bank_name#i#")#:#evaluate("attributes.bank_branch_name#i#")#:#evaluate("attributes.account_no#i#")#'; //satır acıklamaları borc acıklama aray e set edilir.
								else if(isDefined("attributes.action_detail") and len(attributes.action_detail))
									satir_detay_list[1][listlen(borc_tutarlar)] = ' #attributes.company_name# - #attributes.action_detail#';
								else
									satir_detay_list[1][listlen(borc_tutarlar)] = ' #attributes.company_name# - ÇEK İADE GİRİŞ İŞLEMİ';
							}
						}
					}
					if(isDefined("attributes.action_detail") and len(attributes.action_detail))
						satir_detay_list[2][1] = ' #attributes.company_name# - #attributes.action_detail#';
					else
						satir_detay_list[2][1] = ' #attributes.company_name# - ÇEK İADE GİRİŞ İŞLEMİ';
					muhasebeci (
						action_id:P_ID,
						workcube_process_type:process_type,
						account_card_type:13,
						action_table :'PAYROLL',
						islem_tarihi:attributes.PAYROLL_REVENUE_DATE,
						company_id : iif(attributes.member_type eq "partner",'attributes.company_id',de('')),
						consumer_id : iif(attributes.member_type eq "consumer",'attributes.consumer_id',de('')),
						employee_id : iif(attributes.member_type eq "employee",'attributes.employee_id',de('')),
						borc_hesaplar: borc_hesaplar,
						borc_tutarlar: borc_tutarlar,
						other_amount_borc: other_amount_borc_list,
						other_currency_borc: other_currency_borc_list,
						alacak_hesaplar: acc,
						alacak_tutarlar: attributes.payroll_total,
						other_amount_alacak : iif(len(attributes.other_payroll_total),'attributes.other_payroll_total',de('')),
						other_currency_alacak : iif(len(attributes.basket_money),'attributes.basket_money',de('')),
						currency_multiplier : currency_multiplier,
						fis_detay:'ÇEK İADE GİRİŞ İŞLEMİ',
						fis_satir_detay:satir_detay_list,
						belge_no : form.payroll_no,
						to_branch_id : branch_id_info,
						workcube_process_cat : form.process_cat,
						acc_project_id : attributes.project_id,
						is_account_group : is_account_group
					);
				}
				else		/*e-deftere uygun muhasebe islemleri yapılıyor*/
				{
					borc_tutar = '';
					satir_detay_list = ArrayNew(2);
					for(i=1; i lte attributes.record_num; i=i+1)
					{
						if (evaluate("attributes.row_kontrol#i#"))
						{
							if(evaluate("attributes.currency_id#i#") is session.ep.money)
								borc_tutar = evaluate("attributes.cheque_value#i#");
							else
								borc_tutar = evaluate("attributes.cheque_system_currency_value#i#");
							if (evaluate("attributes.cheque_status_id#i#") eq 4)
							{
								GET_ACC_CODE=cfquery(datasource:"#dsn2#",sqlstring:"SELECT
									C.A_CHEQUE_ACC_CODE CHEQUE_ACC_CODE
								FROM
									PAYROLL AS P,
									CHEQUE_HISTORY AS CH,
									CASH AS C
								WHERE
									P.TRANSFER_CASH_ID = C.CASH_ID AND
									P.PAYROLL_TYPE IN (135) AND
									P.ACTION_ID= CH.PAYROLL_ID AND
									CH.CHEQUE_ID=#evaluate("attributes.cheque_id#i#")#
								ORDER BY
									CH.HISTORY_ID DESC");
								if(GET_ACC_CODE.recordcount eq 0)
								{
									GET_ACC_CODE=cfquery(datasource:"#dsn2#",sqlstring:"SELECT
												C.A_CHEQUE_ACC_CODE CHEQUE_ACC_CODE
											FROM
												PAYROLL AS P,
												CHEQUE_HISTORY AS CH,
												CASH AS C
											WHERE
												P.PAYROLL_CASH_ID = C.CASH_ID AND
												P.PAYROLL_TYPE IN (90,106,105) AND
												P.ACTION_ID= CH.PAYROLL_ID AND
												CH.CHEQUE_ID=#evaluate("attributes.cheque_id#i#")#");
								}
							}
							else if (evaluate("attributes.cheque_status_id#i#") eq 6)
								GET_ACC_CODE=cfquery(datasource:"#dsn2#",sqlstring:"SELECT V_CHEQUE_ACC_CODE CHEQUE_ACC_CODE FROM #dsn3_alias#.ACCOUNTS AS ACCOUNTS WHERE ACCOUNT_ID=#evaluate("attributes.account_id#i#")#");
							else
								GET_ACC_CODE=cfquery(datasource:"#dsn2#",sqlstring:"SELECT A_CHEQUE_ACC_CODE CHEQUE_ACC_CODE FROM CASH WHERE CASH_ID=#listfirst(form.cash_id,';')#");
							
							if (is_account_group neq 1)
							{ 
								if(isDefined("attributes.action_detail") and len(attributes.action_detail))
									satir_detay_list[1][1] = ' #evaluate("attributes.cheque_no#i#")# - #attributes.company_name# - #attributes.action_detail#';
								else
									satir_detay_list[1][1] = ' #evaluate("attributes.cheque_no#i#")# - #attributes.company_name# - ÇEK İADE GİRİŞ İŞLEMİ';
							}
							else
							{
								if(isDefined("attributes.action_detail") and len(attributes.action_detail))
									satir_detay_list[1][1] = ' #attributes.company_name# - #attributes.action_detail#';
								else
									satir_detay_list[1][1] = ' #attributes.company_name# - ÇEK İADE GİRİŞ İŞLEMİ';
							}
							if(isDefined("attributes.action_detail") and len(attributes.action_detail))
								satir_detay_list[2][1] = ' #attributes.company_name# - #attributes.action_detail#';
							else
								satir_detay_list[2][1] = ' #attributes.company_name# - ÇEK İADE GİRİŞ İŞLEMİ';
								
							muhasebeci (
								action_id:P_ID,
								action_row_id : evaluate("attributes.CHEQUE_ID#i#"),
								due_date :iif(len(evaluate("attributes.CHEQUE_DUEDATE#i#")),'createodbcdatetime(evaluate("attributes.CHEQUE_DUEDATE#i#"))','attributes.pyrll_avg_duedate'),
								workcube_process_type:process_type,
								account_card_type:13,
								action_table :'PAYROLL',
								islem_tarihi:attributes.PAYROLL_REVENUE_DATE,
								company_id : iif(attributes.member_type eq "partner",'attributes.company_id',de('')),
								consumer_id : iif(attributes.member_type eq "consumer",'attributes.consumer_id',de('')),
								employee_id : iif(attributes.member_type eq "employee",'attributes.employee_id',de('')),
								borc_hesaplar: GET_ACC_CODE.CHEQUE_ACC_CODE,
								borc_tutarlar: borc_tutar,
								other_amount_borc: evaluate("attributes.cheque_value#i#"),
								other_currency_borc: listgetat(form.cash_id,3,';'),
								alacak_hesaplar: acc,
								alacak_tutarlar: borc_tutar,
								other_amount_alacak : wrk_round(evaluate("attributes.cheque_system_currency_value#i#")/paper_currency_multiplier),
								other_currency_alacak : iif(len(attributes.basket_money),'attributes.basket_money',de('')),
								currency_multiplier : currency_multiplier,
								fis_detay:'ÇEK İADE GİRİŞ İŞLEMİ',
								fis_satir_detay:satir_detay_list,
								belge_no : evaluate("attributes.cheque_no#i#"),
								to_branch_id : branch_id_info,
								workcube_process_cat : form.process_cat,
								acc_project_id : attributes.project_id,
								is_account_group : is_account_group
							);		
						}
					}
				}
			}
			basket_kur_ekle(action_id:GET_BORDRO_ID.P_ID,table_type_id:11,process_type:0);
		</cfscript>
		<cf_workcube_process_cat 
			process_cat="#form.process_cat#"
			action_id = #p_id#
			is_action_file = 1
			action_db_type = '#dsn2#'
			action_page='#request.self#?fuseaction=cheque.form_add_payroll_entry_return&event=upd&id=#p_id#'
			action_file_name='#get_process_type.action_file_name#'
			is_template_action_file = '#get_process_type.action_file_from_template#'>
    <cf_add_log log_type="1" action_id="#p_id#" action_name="#attributes.payroll_no# Eklendi" paper_no="#form.payroll_no#" period_id="#session.ep.period_id#" process_type="#get_process_type.process_type#" data_source="#dsn2#">
	</cftransaction>
</cflock>
<cfset attributes.actionId=p_id> 
<script type="text/javascript">
	window.location.href="<cfoutput>#request.self#?fuseaction=cheque.form_add_payroll_entry_return&event=upd&id=#p_id#</cfoutput>";
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
