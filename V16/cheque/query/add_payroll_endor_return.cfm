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
			'attributes.cheque_system_currency_value#ff#' = filterNum(evaluate("attributes.cheque_system_currency_value#ff#"));
			'attributes.cheque_value#ff#' = filterNum(evaluate("attributes.cheque_value#ff#"));
	}
	for(rt = 1; rt lte attributes.kur_say; rt = rt + 1)
	{
		'attributes.txt_rate1_#rt#' = filterNum(evaluate('attributes.txt_rate1_#rt#'),session.ep.our_company_info.rate_round_num);
		'attributes.txt_rate2_#rt#' = filterNum(evaluate('attributes.txt_rate2_#rt#'),session.ep.our_company_info.rate_round_num);
	}
	branch_id_info = listgetat(attributes.cash_id,2,';');
	kasa_id = listfirst(attributes.cash_id,';');
	
	if(listlen(attributes.employee_id,'_') eq 2)
	{
		attributes.acc_type_id = listlast(attributes.employee_id,'_');
		attributes.employee_id = listfirst(attributes.employee_id,'_');
	}
</cfscript>
<cfif not isdefined("attributes.acc_type_id")><cfset attributes.acc_type_id = len(is_account_type_id) ? is_account_type_id : ""></cfif>
<cfquery name="control_no" datasource="#dsn2#">
	SELECT ACTION_ID FROM PAYROLL WHERE PAYROLL_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.PAYROLL_NO#"> 
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
				PAYROLL(
					PROCESS_CAT,
					PAYROLL_TYPE,
					PAYROLL_TOTAL_VALUE,
					PAYROLL_OTHER_MONEY,
					PAYROLL_OTHER_MONEY_VALUE,
					NUMBER_OF_CHEQUE,
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
					PAYROLL_CASH_ID,
					CHEQUE_BASED_ACC_CARI,
					RECORD_EMP,
					RECORD_IP,
					RECORD_DATE,
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
					#attributes.cheque_num#,
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
					<cfif isdefined('attributes.cash_id') and len(attributes.cash_id)>#listfirst(attributes.cash_id,';')#<cfelse>NULL</cfif>,
					<cfif len(is_cheque_based)>#is_cheque_based#<cfelse>0</cfif>,
					#session.ep.userid#,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">,
					#NOW()#,
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
		<cfloop from="1" to="#attributes.record_num#" index="i">
			<cfif evaluate("attributes.row_kontrol#i#")>
				<cf_date tarih='attributes.cheque_duedate#i#'>
				<cfquery name="UPD_CHEQUES" datasource="#dsn2#">
					UPDATE CHEQUE SET CHEQUE_STATUS_ID=9 WHERE CHEQUE_ID= #evaluate("attributes.cheque_id#i#")#
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
							9,
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
				if(is_cheque_based eq 1)
				{
					for(k=1; k lte attributes.record_num; k=k+1)
					{
						if(evaluate("attributes.row_kontrol#k#"))
						{
							if(len(attributes.basket_money) and len(attributes.basket_money_rate))
							{
								other_money = attributes.basket_money;
								other_money_value = wrk_round(evaluate("attributes.cheque_system_currency_value#k#")/attributes.basket_money_rate);
							}
							else if(evaluate("attributes.currency_id#k#") is not session.ep.money)
							{
								other_money =evaluate("attributes.currency_id#k#");
								other_money_value =evaluate("attributes.cheque_value#k#");
							}
							else if(len(evaluate("attributes.other_money_value2#k#")) and len(evaluate("attributes.other_money2#k#")))
							{
								other_money = listappend(other_currency_alacak_list,evaluate("attributes.other_money2#k#"),',');
								other_money_value = listappend(other_amount_alacak_list,evaluate("attributes.other_money_value2#k#"),',');
							}
							else
							{
								other_money = listappend(other_currency_alacak_list,evaluate("attributes.system_money_info#k#"),','); //cek sistem para birimi tutarı
								other_money_value =  listappend(other_amount_alacak_list,evaluate("attributes.cheque_system_currency_value#k#"),',');
							}
							paper_currency_multiplier = '';
							if(isDefined('attributes.kur_say') and len(attributes.kur_say))
								for(mon=1;mon lte attributes.kur_say;mon=mon+1)
								{
									if(evaluate("attributes.hidden_rd_money_#mon#") is other_money)
										paper_currency_multiplier = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
								}
							carici(
								action_id :evaluate("attributes.cheque_id#k#"),
								workcube_process_type :process_type,		
								process_cat : form.process_cat,
								account_card_type :13,
								action_table :'CHEQUE',
								islem_tarihi :attributes.PAYROLL_REVENUE_DATE,
								islem_tutari :evaluate("attributes.cheque_system_currency_value#k#"),
								other_money_value : other_money_value,
								other_money : other_money,
								islem_belge_no : evaluate("attributes.cheque_no#k#"),
								action_currency : session.ep.money,
								payer_id :form.pro_employee_id,
								to_cmp_id : iif(attributes.member_type eq "partner",'attributes.company_id',de('')),
								to_consumer_id : iif(attributes.member_type eq "consumer",'attributes.consumer_id',de('')),
								to_employee_id : iif(attributes.member_type eq "employee",'attributes.employee_id',de('')),
								due_date : iif(len(evaluate("attributes.cheque_duedate#k#")),'createodbcdatetime(evaluate("attributes.cheque_duedate#k#"))','attributes.pyrll_avg_duedate'),
								currency_multiplier : currency_multiplier,
								islem_detay : 'ÇEK İADE ÇIKIŞ BORDROSU(Çek Bazında)',
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
						islem_belge_no : attributes.payroll_no,
						action_currency : session.ep.money,
						payer_id :form.pro_employee_id,
						to_cmp_id : iif(attributes.member_type eq "partner",'attributes.company_id',de('')),
						to_consumer_id : iif(attributes.member_type eq "consumer",'attributes.consumer_id',de('')),
						to_employee_id : iif(attributes.member_type eq "employee",'attributes.employee_id',de('')),
						due_date : attributes.pyrll_avg_duedate,
						currency_multiplier : currency_multiplier,
						islem_detay : 'ÇEK İADE ÇIKIŞ BORDROSU',
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
		if(is_account eq 1)
		{
			if(is_cheque_based_acc neq 1)	/*standart muhasebe islemleri yapılıyor*/
			{
				alacakli_hesaplar = '';
				alacakli_tutarlar = '';
				other_amount_alacak_list = '';
				other_currency_alacak_list = '';
				satir_detay_list = ArrayNew(2);
				for(k=1; k lte attributes.record_num; k=k+1)
				{
					if(evaluate("attributes.row_kontrol#k#"))
					{
						if(evaluate("attributes.currency_id#k#") is session.ep.money)
							alacakli_tutarlar=listappend(alacakli_tutarlar,evaluate("attributes.cheque_value#k#"),',');
						else
							alacakli_tutarlar=listappend(alacakli_tutarlar,evaluate("attributes.cheque_system_currency_value#k#"),',');
						other_currency_alacak_list = listappend(other_currency_alacak_list,listgetat(form.cash_id,3,';'));
						other_amount_alacak_list =  listappend(other_amount_alacak_list,evaluate("attributes.cheque_value#k#"),',');
						if(evaluate("attributes.cheque_status_id#k#") eq 5)
						{
							GET_ACC_CODE=cfquery(datasource:"#dsn2#",sqlstring:"SELECT KARSILIKSIZ_CEKLER_CODE FROM CASH WHERE CASH_ID = #kasa_id#");
							alacakli_hesaplar=listappend(alacakli_hesaplar, GET_ACC_CODE.KARSILIKSIZ_CEKLER_CODE, ',');
						}	
						else if(evaluate("attributes.cheque_status_id#k#") eq 1 or evaluate("attributes.cheque_status_id#k#") eq 10)
						{
							GET_ACC_CODE=cfquery(datasource:"#dsn2#",sqlstring:"SELECT
										C.A_CHEQUE_ACC_CODE
									FROM
										PAYROLL AS P,
										CHEQUE_HISTORY AS CH,
										CASH AS C
									WHERE
										P.TRANSFER_CASH_ID = C.CASH_ID AND
										P.PAYROLL_TYPE IN (135) AND
										P.ACTION_ID= CH.PAYROLL_ID AND
										CH.CHEQUE_ID=#evaluate("attributes.cheque_id#k#")#
									ORDER BY
										CH.HISTORY_ID DESC");
							if(GET_ACC_CODE.recordcount eq 0)
							{
								GET_ACC_CODE=cfquery(datasource:"#dsn2#",sqlstring:"SELECT
											C.A_CHEQUE_ACC_CODE
										FROM
											PAYROLL AS P,
											CHEQUE_HISTORY AS CH,
											CASH AS C
										WHERE
											P.PAYROLL_CASH_ID = C.CASH_ID AND
											P.PAYROLL_TYPE IN (90,106,105) AND
											P.ACTION_ID= CH.PAYROLL_ID AND
											CH.CHEQUE_ID=#evaluate("attributes.cheque_id#k#")#
										ORDER BY
											CH.HISTORY_ID DESC");
							}
							alacakli_hesaplar=listappend(alacakli_hesaplar, GET_ACC_CODE.A_CHEQUE_ACC_CODE, ',');
						}	
						if (is_account_group neq 1)
						{ 
							if(attributes.x_detail_acc_card eq 1) //detaylı muhasebe seçilmişse çek bilgilerini yazıyoruz
								satir_detay_list[2][listlen(alacakli_tutarlar)]='Ç.İ.Ç.B.:#attributes.payroll_no#:#evaluate("attributes.bank_name#k#")#:#evaluate("attributes.bank_branch_name#k#")#:#evaluate("attributes.account_no#k#")#'; //satır acıklamaları borc acıklama aray e set edilir.
							else if(isDefined("attributes.action_detail") and len(attributes.action_detail))
								satir_detay_list[2][listlen(alacakli_tutarlar)] = ' #evaluate("attributes.cheque_no#k#")# - #attributes.company_name# - #attributes.action_detail#';
							else
								satir_detay_list[2][listlen(alacakli_tutarlar)] = ' #evaluate("attributes.cheque_no#k#")# - #attributes.company_name# - ÇEK İADE ÇIKIŞ İŞLEMİ';
						}
						else
						{
							if(attributes.x_detail_acc_card eq 1) //detaylı muhasebe seçilmişse çek bilgilerini yazıyoruz
								satir_detay_list[2][listlen(alacakli_tutarlar)]='Ç.İ.Ç.B.:#attributes.payroll_no#:#evaluate("attributes.bank_name#k#")#:#evaluate("attributes.bank_branch_name#k#")#:#evaluate("attributes.account_no#k#")#'; //satır acıklamaları borc acıklama aray e set edilir.
							else if(isDefined("attributes.action_detail") and len(attributes.action_detail))
								satir_detay_list[2][listlen(alacakli_tutarlar)] = ' #attributes.company_name# - #attributes.action_detail#';
							else
								satir_detay_list[2][listlen(alacakli_tutarlar)] = ' #attributes.company_name# - ÇEK İADE ÇIKIŞ İŞLEMİ';
						}
					}	
				}
				if(isDefined("attributes.action_detail") and len(attributes.action_detail))
					satir_detay_list[1][1] = ' #attributes.company_name# - #attributes.action_detail#';
				else
					satir_detay_list[1][1] = ' #attributes.company_name# - ÇEK İADE ÇIKIŞ İŞLEMİ';
				muhasebeci (
					action_id:p_id,
					workcube_process_type:process_type,
					account_card_type:13,
					action_table :'PAYROLL',
					islem_tarihi:attributes.PAYROLL_REVENUE_DATE,
					company_id : iif(attributes.member_type eq "partner",'attributes.company_id',de('')),
					consumer_id : iif(attributes.member_type eq "consumer",'attributes.consumer_id',de('')),
					employee_id : iif(attributes.member_type eq "employee",'attributes.employee_id',de('')),
					borc_hesaplar: acc,
					borc_tutarlar: attributes.payroll_total,
					other_amount_borc : iif(len(attributes.other_payroll_total),'attributes.other_payroll_total',de('')),
					other_currency_borc : iif(len(form.basket_money),'form.basket_money',de('')),
					alacak_hesaplar: alacakli_hesaplar,
					alacak_tutarlar: alacakli_tutarlar,
					other_amount_alacak : other_amount_alacak_list,
					other_currency_alacak : other_currency_alacak_list,
					currency_multiplier : currency_multiplier,
					fis_detay:'ÇEK İADE ÇIKIŞ İŞLEMİ',
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
				alacakli_hesaplar = '';
				alacakli_tutarlar = '';
				satir_detay_list = ArrayNew(2);
				for(k=1; k lte attributes.record_num; k=k+1)
				{
					if(evaluate("attributes.row_kontrol#k#"))
					{
						if(evaluate("attributes.currency_id#k#") is session.ep.money)
							alacakli_tutarlar=evaluate("attributes.cheque_value#k#");
						else
							alacakli_tutarlar=evaluate("attributes.cheque_system_currency_value#k#");

						if(evaluate("attributes.cheque_status_id#k#") eq 5)
						{
							GET_ACC_CODE=cfquery(datasource:"#dsn2#",sqlstring:"SELECT KARSILIKSIZ_CEKLER_CODE FROM CASH WHERE CASH_ID = #kasa_id#");
							alacakli_hesaplar=GET_ACC_CODE.KARSILIKSIZ_CEKLER_CODE;
						}	
						else if(evaluate("attributes.cheque_status_id#k#") eq 1 or evaluate("attributes.cheque_status_id#k#") eq 10)
						{
							GET_ACC_CODE=cfquery(datasource:"#dsn2#",sqlstring:"SELECT
										C.A_CHEQUE_ACC_CODE
									FROM
										PAYROLL AS P,
										CHEQUE_HISTORY AS CH,
										CASH AS C
									WHERE
										P.TRANSFER_CASH_ID = C.CASH_ID AND
										P.PAYROLL_TYPE IN (135) AND
										P.ACTION_ID= CH.PAYROLL_ID AND
										CH.CHEQUE_ID=#evaluate("attributes.cheque_id#k#")#
									ORDER BY
										CH.HISTORY_ID DESC");
							if(GET_ACC_CODE.recordcount eq 0)
							{
								GET_ACC_CODE=cfquery(datasource:"#dsn2#",sqlstring:"SELECT
											C.A_CHEQUE_ACC_CODE
										FROM
											PAYROLL AS P,
											CHEQUE_HISTORY AS CH,
											CASH AS C
										WHERE
											P.PAYROLL_CASH_ID = C.CASH_ID AND
											P.PAYROLL_TYPE IN (90,106,105) AND
											P.ACTION_ID= CH.PAYROLL_ID AND
											CH.CHEQUE_ID=#evaluate("attributes.cheque_id#k#")#
										ORDER BY
											CH.HISTORY_ID DESC");
							}
							alacakli_hesaplar=GET_ACC_CODE.A_CHEQUE_ACC_CODE;
						}	
						if (is_account_group neq 1)
						{ 
							if(isDefined("attributes.action_detail") and len(attributes.action_detail))
								satir_detay_list[2][1] = ' #evaluate("attributes.cheque_no#k#")# - #attributes.company_name# - #attributes.action_detail#';
							else
								satir_detay_list[2][1] = ' #evaluate("attributes.cheque_no#k#")# - #attributes.company_name# - ÇEK İADE ÇIKIŞ İŞLEMİ';
						}
						else
						{
							if(isDefined("attributes.action_detail") and len(attributes.action_detail))
								satir_detay_list[2][1] = ' #attributes.company_name# - #attributes.action_detail#';
							else
								satir_detay_list[2][1] = ' #attributes.company_name# - ÇEK İADE ÇIKIŞ İŞLEMİ';
						}
						if(isDefined("attributes.action_detail") and len(attributes.action_detail))
							satir_detay_list[1][1] = ' #attributes.company_name# - #attributes.action_detail#';
						else
							satir_detay_list[1][1] = ' #attributes.company_name# - ÇEK İADE ÇIKIŞ İŞLEMİ';
							
						muhasebeci (
							action_id:p_id,
							action_row_id : evaluate("attributes.CHEQUE_ID#k#"),
							due_date :iif(len(evaluate("attributes.CHEQUE_DUEDATE#k#")),'createodbcdatetime(evaluate("attributes.CHEQUE_DUEDATE#k#"))','attributes.pyrll_avg_duedate'),
							workcube_process_type:process_type,
							account_card_type:13,
							action_table :'PAYROLL',
							islem_tarihi:attributes.PAYROLL_REVENUE_DATE,
							company_id : iif(attributes.member_type eq "partner",'attributes.company_id',de('')),
							consumer_id : iif(attributes.member_type eq "consumer",'attributes.consumer_id',de('')),
							employee_id : iif(attributes.member_type eq "employee",'attributes.employee_id',de('')),
							borc_hesaplar: acc,
							borc_tutarlar: alacakli_tutarlar,
							other_amount_borc : wrk_round(evaluate("attributes.cheque_system_currency_value#k#")/paper_currency_multiplier),
							other_currency_borc : iif(len(form.basket_money),'form.basket_money',de('')),
							alacak_hesaplar: alacakli_hesaplar,
							alacak_tutarlar: alacakli_tutarlar,
							other_amount_alacak : evaluate("attributes.cheque_value#k#"),
							other_currency_alacak : listgetat(form.cash_id,3,';'),
							currency_multiplier : currency_multiplier,
							fis_detay:'ÇEK İADE ÇIKIŞ İŞLEMİ',
							fis_satir_detay:satir_detay_list,
							belge_no : evaluate("attributes.cheque_no#k#"),
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
			action_page='#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_add_payroll_endor_return&ID=#p_id#'
			action_file_name='#get_process_type.action_file_name#'
			is_template_action_file = '#get_process_type.action_file_from_template#'>
	</cftransaction>
</cflock> 
<script type="text/javascript">
	window.location.href="<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_add_payroll_endor_return&event=upd&ID=#p_id#</cfoutput>";
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
