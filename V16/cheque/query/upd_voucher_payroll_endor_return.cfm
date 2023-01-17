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
<cfquery name="CONTROL_NO" datasource="#DSN2#">
	SELECT 
		ACTION_ID 
	FROM 
		VOUCHER_PAYROLL
	WHERE 
		PAYROLL_NO = '#PAYROLL_NO#' AND
		ACTION_ID <> #attributes.ID#
</cfquery>
<cfif CONTROL_NO.RECORDCOUNT>
	<script type="text/javascript">
		alert("<cf_get_lang no='125.Aynı Bordro No lu Kayıt Var !'>");
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
		<cfquery name="UPD_PAYROLL" datasource="#dsn2#">
			UPDATE 
				VOUCHER_PAYROLL
			SET
				PROCESS_CAT=#form.process_cat#,
				PAYROLL_TYPE=#process_type#,
				COMPANY_ID = <cfif attributes.member_type eq "partner" and len(attributes.company_id)>#attributes.company_id#<cfelse>NULL</cfif>,
				CONSUMER_ID = <cfif attributes.member_type eq "consumer" and len(attributes.consumer_id)>#attributes.consumer_id#<cfelse>NULL</cfif>,
				EMPLOYEE_ID = <cfif attributes.member_type eq "employee" and len(attributes.employee_id)>#attributes.employee_id#<cfelse>NULL</cfif>,
				PAYROLL_TOTAL_VALUE=#attributes.payroll_total#,
				PAYROLL_OTHER_MONEY=<cfif isdefined("attributes.basket_money") and len(attributes.basket_money)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.basket_money#">,<cfelse>NULL,</cfif>
				PAYROLL_OTHER_MONEY_VALUE=<cfif isdefined("attributes.other_payroll_total") and len(attributes.other_payroll_total)>#attributes.other_payroll_total#,<cfelse>NULL,</cfif>
				PAYROLL_REVENUE_DATE=#attributes.PAYROLL_REVENUE_DATE#,
				NUMBER_OF_VOUCHER=#attributes.voucher_num#,
				PROJECT_ID = <cfif len(attributes.project_name) and len(attributes.project_id)>#attributes.project_id#<cfelse>NULL</cfif>,
				PAYROLL_AVG_DUEDATE=#attributes.pyrll_avg_duedate#,
				PAYROLL_AVG_AGE=<cfif len(attributes.pyrll_avg_age)>#attributes.pyrll_avg_age#,<cfelse>NULL,</cfif>
				PAYROLL_REV_MEMBER=#pro_employee_id#,
				<cfif len(attributes.PAYROLL_NO) >PAYROLL_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.PAYROLL_NO#">,</cfif>
				UPDATE_EMP=#session.ep.userid#,
				UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">,
				UPDATE_DATE=#NOW()#,
				VOUCHER_BASED_ACC_CARI = <cfif len(is_voucher_based)>#is_voucher_based#<cfelse>0</cfif>,
				ACTION_DETAIL = <cfif isDefined("attributes.action_detail") and len(attributes.action_detail)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.action_detail#"><cfelse>NULL</cfif>,
				BRANCH_ID = #branch_id_info#,
				SPECIAL_DEFINITION_ID = <cfif isdefined("attributes.special_definition_id") and len(attributes.special_definition_id)>#attributes.special_definition_id#<cfelse>NULL</cfif>,
				ASSETP_ID = <cfif isdefined("attributes.asset_id") and len(attributes.asset_id) and len(attributes.asset_name)>#attributes.asset_id#<cfelse>NULL</cfif>,
			    ACC_TYPE_ID = <cfif isdefined("attributes.acc_type_id") and len(attributes.acc_type_id)>#attributes.acc_type_id#<cfelse>NULL</cfif>
			WHERE
				ACTION_ID=#attributes.ID#
		</cfquery>
		<cfquery name="GET_REL_VOUCHERS" datasource="#dsn2#">
			SELECT VOUCHER_ID FROM VOUCHER_HISTORY WHERE PAYROLL_ID=#attributes.ID#
		</cfquery>
		<cfset ches=valuelist(get_rel_vouchers.VOUCHER_ID)>
		<!--- eski senetler kontrol ediliyor --->
		<cfloop list="#ches#" index="i">
			<cfset ctr=0>
			<cfloop from="1" to="#attributes.record_num#" index="k">
				<cfif i eq evaluate("attributes.voucher_id#k#") and evaluate("attributes.row_kontrol#k#")>
					<cfset ctr=1>
					<cf_date tarih='attributes.voucher_duedate#k#'>
				</cfif>
			</cfloop>
			<cfif ctr eq 0> 
				<!--- senet çıkış iade  bordrosundan cikarilmis, portföyde veya karsiliksiz durumuna geri dönecek--->
				<cfquery name="GET_FORMER_HIST_ID" datasource="#dsn2#">
					SELECT
						MAX(HISTORY_ID) AS H_ID
					FROM
						VOUCHER_HISTORY
					WHERE
						VOUCHER_ID=#i# AND
						(STATUS=1 OR STATUS=5 OR STATUS=10) AND
						PAYROLL_ID IS NOT NULL
				</cfquery>
				<cfquery name="GET_FORMER_INFO" datasource="#dsn2#">
					SELECT
						PAYROLL_ID,
						STATUS
					FROM
						VOUCHER_HISTORY
					WHERE
						HISTORY_ID=#GET_FORMER_HIST_ID.H_ID#		
				</cfquery>
				<cfquery name="UPD_VOUCHER" datasource="#dsn2#">
					UPDATE 
						VOUCHER
					SET
						VOUCHER_PAYROLL_ID=#GET_FORMER_INFO.PAYROLL_ID#,
						VOUCHER_STATUS_ID=#GET_FORMER_INFO.STATUS#
					WHERE
						VOUCHER_ID=#i#
				</cfquery>
				<cfquery name="DEL_CHE_HIST" datasource="#dsn2#">
					DELETE FROM	VOUCHER_HISTORY WHERE VOUCHER_ID=#i# AND PAYROLL_ID=#attributes.ID#
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
				<cfif ctr eq 0><!--- yeni eklenen senetse --->
					<cfquery name="UPD_VOUCHERS" datasource="#dsn2#">
						UPDATE VOUCHER SET VOUCHER_STATUS_ID=9 WHERE VOUCHER_ID= #evaluate("attributes.voucher_id#i#")#
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
									#attributes.ID#,
									9,
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
							OTHER_MONEY_VALUE=<cfif len(evaluate("attributes.voucher_system_currency_value#i#"))>#evaluate("attributes.voucher_system_currency_value#i#")#,<cfelse>NULL,</cfif>
							OTHER_MONEY=<cfif len(evaluate("attributes.system_money_info#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.system_money_info#i#")#'>,<cfelse>NULL,</cfif>
							OTHER_MONEY_VALUE2=<cfif len(evaluate("attributes.other_money_value2#i#"))>#evaluate("attributes.other_money_value2#i#")#,<cfelse>NULL,</cfif>
							OTHER_MONEY2=<cfif len(evaluate("attributes.other_money2#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.other_money2#i#")#'><cfelse>NULL</cfif>
						WHERE 
							VOUCHER_ID= #evaluate("attributes.voucher_id#i#")#AND
							PAYROLL_ID = #attributes.ID#
					</cfquery>
				</cfif>
			</cfif>
		</cfloop>
		<cfquery name="GET_VOUCHERS_LAST" datasource="#dsn2#">
			SELECT 
				VOUCHER.VOUCHER_NO 
			FROM
				VOUCHER, 
				VOUCHER_HISTORY 
			WHERE
				VOUCHER.VOUCHER_ID=VOUCHER_HISTORY.VOUCHER_ID
				AND PAYROLL_ID=#attributes.ID#
		</cfquery>
		
		<!--- update cari ve muhasebe--->	
		<cfscript>
			cheq_no_list=valuelist(GET_VOUCHERS_LAST.VOUCHER_NO);
			ches_2 = ches;
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
			if(is_cari eq 1 or is_account eq 1)
			{ /*bordrodan cıkarılan senetler bulunuyor*/
				for(cheq_x=1; cheq_x lte attributes.record_num; cheq_x=cheq_x+1)
				{
					if (evaluate("attributes.row_kontrol#cheq_x#"))
						if(len(evaluate("attributes.voucher_id#cheq_x#")) and ListFindNoCase(ches_2,evaluate("attributes.voucher_id#cheq_x#")))
							ches_2 = ListDeleteAt(ches_2,ListFindNoCase(ches_2,evaluate("attributes.voucher_id#cheq_x#"), ','), ',');
				}
			}
			payroll_total_ = 0;
			if(is_cari eq 1)
			{
				if(is_voucher_based eq 1) /*islem kategorisinde senet bazında carici secili*/
				{
					if(attributes.payroll_acc_cari_voucher_based neq 1)  //bordro ilk eklendiginde carici bordro bazında calıstırılmıs ise, silinir
						cari_sil(action_id:attributes.id,action_table:'VOUCHER_PAYROLL',process_type:form.old_process_type);
					
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
								action_table :'VOUCHER',
								workcube_process_type :process_type,
								workcube_old_process_type :form.old_process_type,		
								process_cat : form.process_cat,
								account_card_type :13,
								islem_tarihi :attributes.PAYROLL_REVENUE_DATE,
								islem_tutari :voucher_value,
								other_money_value : other_money_value,
								other_money : other_money,
								islem_belge_no : evaluate("attributes.voucher_no#cheq_i#"),
								currency_multiplier : currency_multiplier,
								due_date : iif(len(evaluate("attributes.voucher_duedate#cheq_i#")),'createodbcdatetime(evaluate("attributes.voucher_duedate#cheq_i#"))','attributes.pyrll_avg_duedate'),
								to_cmp_id : iif(attributes.member_type eq "partner",'attributes.company_id',de('')),
								to_consumer_id : iif(attributes.member_type eq "consumer",'attributes.consumer_id',de('')),
								to_employee_id : iif(attributes.member_type eq "employee",'attributes.employee_id',de('')),							
								payer_id :attributes.pro_employee_id,
								islem_detay : 'SENET ÇIKIŞ İADE BORDROSU(Senet Bazında)',
								acc_type_id : attributes.acc_type_id,
								action_detail : attributes.action_detail,
								project_id : attributes.project_id,
								to_branch_id : branch_id_info,
								payroll_id :attributes.id,
								special_definition_id : iif((isdefined("attributes.special_definition_id") and len(attributes.special_definition_id)),'attributes.special_definition_id',de('')),
								assetp_id : iif((isdefined("attributes.asset_id") and len(attributes.asset_id) and len(attributes.asset_name)),'attributes.asset_id',de('')),
								rate2:paper_currency_multiplier
								);					
						}
					}
					if(attributes.payroll_acc_cari_voucher_based eq 1)
					{ /*bordrodan cıkarılan senetlerin cari hareketleri siliniyor*/
						for(cheq_n=1;cheq_n lte listlen(ches_2);cheq_n=cheq_n+1)
							cari_sil(action_id:listgetat(ches_2,cheq_n,','),action_table:'VOUCHER',process_type:form.old_process_type,payroll_id :attributes.id);
					}
				}
				else
				{
					if(attributes.payroll_acc_cari_voucher_based eq 1)
					{ /*bordro ilk kaydedildiginde senet bazında cari islem yapılmıssa bu cari hareketler silinir*/
						for(cheq_k=1;cheq_k lte listlen(ches);cheq_k=cheq_k+1)
							cari_sil(action_id:listgetat(ches,cheq_k,','),action_table:'VOUCHER',process_type:form.old_process_type,payroll_id :attributes.id);
					}
					carici(
						action_table :'VOUCHER_PAYROLL',
						action_id :attributes.id,
						workcube_process_type :process_type,
						workcube_old_process_type :form.old_process_type,		
						process_cat : form.process_cat,
						account_card_type :13,
						islem_tarihi :attributes.PAYROLL_REVENUE_DATE,
						islem_tutari :attributes.payroll_total,
						other_money_value : iif(len(attributes.other_payroll_total),'attributes.other_payroll_total',de('')),
						other_money :iif(len(attributes.basket_money),'attributes.basket_money',de('')),
						islem_belge_no : attributes.payroll_no,
						currency_multiplier : currency_multiplier,
						due_date : attributes.pyrll_avg_duedate,
						to_cmp_id : iif(attributes.member_type eq "partner",'attributes.company_id',de('')),
						to_consumer_id : iif(attributes.member_type eq "consumer",'attributes.consumer_id',de('')),
						to_employee_id : iif(attributes.member_type eq "employee",'attributes.employee_id',de('')),							
						payer_id :attributes.pro_employee_id,
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
			else
			{
				if(attributes.payroll_acc_cari_voucher_based eq 1) /*bordro kaydedilirken cari-muhasebe hareketleri senet bazında yapılmış ise*/
				{
					for(che_q=1;che_q lte listlen(ches);che_q=che_q+1) /*her bir senet icin olusturulmus cari hareket siliniyor*/
						cari_sil(action_id:listgetat(ches,che_q,','),action_table:'VOUCHER',process_type:form.old_process_type,payroll_id :attributes.id);	
				}
				else /*bordro bazında cari hareket siliniyor*/
					cari_sil(action_id:attributes.id,action_table:'VOUCHER_PAYROLL',process_type:form.old_process_type);
			}		
			//Muhasebe kayıtları update ediliyor
			if(is_account eq 1)
			{
				if(is_voucher_based_acc neq 1) //Standart muhasebe islemi yapiliyor
				{
					alacakli_hesaplar = '';
					alacakli_tutarlar = '';
					other_currency_alacak_list= '';
					other_amount_alacak_list= '';
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
							if(evaluate("attributes.voucher_status_id#i#") eq 9) //bu bordro ile islem yapilmis senetler
							{
								GET_PREV_STATUS=cfquery(datasource:"#dsn2#",sqlstring:"SELECT TOP 1
										STATUS									
									FROM
										VOUCHER_HISTORY AS VH
									WHERE
										VOUCHER_ID=#evaluate("attributes.voucher_id#i#")# AND
										(STATUS=5 OR STATUS=10 OR STATUS=1 OR STATUS=11)
									ORDER BY
										HISTORY_ID DESC	
									");
								if(GET_PREV_STATUS.STATUS eq 5)
								{
									get_bank_acc_code=cfquery(datasource:"#dsn2#",sqlstring:"SELECT PROTESTOLU_SENETLER_CODE FROM CASH WHERE CASH_ID = #kasa_id#");
									senet_hesap = get_bank_acc_code.PROTESTOLU_SENETLER_CODE;
								}
								else
								{
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
										GET_ACC_CODE=cfquery(datasource:"#dsn2#",sqlstring:"
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
									senet_hesap = GET_ACC_CODE.A_VOUCHER_ACC_CODE;
								}
							alacakli_hesaplar=listappend(alacakli_hesaplar,senet_hesap,',');
							}
							else if(evaluate("attributes.voucher_status_id#i#") eq 5)
							{
								GET_ACC_CODE=cfquery(datasource:"#dsn2#",sqlstring:"SELECT PROTESTOLU_SENETLER_CODE FROM CASH WHERE CASH_ID = #kasa_id#"); //karsiliksiz senet ise, senet tanımlarındaki protestolu senet hesabı kullanılır
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
							action_id:attributes.id,
							workcube_process_type:process_type,
							workcube_old_process_type :form.old_process_type,
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
							other_currency_alacak :other_currency_alacak_list,
							currency_multiplier : currency_multiplier,
							fis_detay : 'SENET İADE ÇIKIŞ İŞLEMİ',
							fis_satir_detay : str_card_detail,
							belge_no : form.payroll_no,
							from_branch_id : branch_id_info,
							workcube_process_cat : form.process_cat,
							acc_project_id : attributes.project_id,
							is_account_group : is_account_group
						);
					}
					else
						muhasebe_sil(action_id:attributes.id,action_table:'VOUCHER_PAYROLL',process_type:form.old_process_type);
				}
				else		/* e-deftere uygun muhasebe hareketi yapiliyor */
				{
					// tum muhasebe kayıtlari silinir sonra yaniden eklenir.
					muhasebe_sil(action_id:attributes.id,action_table:'VOUCHER_PAYROLL',process_type:form.old_process_type);
	
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
							alacakli_tutarlar=voucher_value;
							
							if(evaluate("attributes.voucher_status_id#i#") eq 9) //bu bordro ile islem yapilmis senetler
							{
								GET_PREV_STATUS=cfquery(datasource:"#dsn2#",sqlstring:"SELECT TOP 1
										STATUS									
									FROM
										VOUCHER_HISTORY AS VH
									WHERE
										VOUCHER_ID=#evaluate("attributes.voucher_id#i#")# AND
										(STATUS=5 OR STATUS=10 OR STATUS=1 OR STATUS=11)
									ORDER BY
										HISTORY_ID DESC	
									");
								if(GET_PREV_STATUS.STATUS eq 5)
								{
									get_bank_acc_code=cfquery(datasource:"#dsn2#",sqlstring:"SELECT PROTESTOLU_SENETLER_CODE FROM CASH WHERE CASH_ID = #kasa_id#");
									senet_hesap = get_bank_acc_code.PROTESTOLU_SENETLER_CODE;
								}
								else
								{
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
										GET_ACC_CODE=cfquery(datasource:"#dsn2#",sqlstring:"
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
									senet_hesap = GET_ACC_CODE.A_VOUCHER_ACC_CODE;
								}
								alacakli_hesaplar=senet_hesap;
							}
							else if(evaluate("attributes.voucher_status_id#i#") eq 5)
							{
								GET_ACC_CODE=cfquery(datasource:"#dsn2#",sqlstring:"SELECT PROTESTOLU_SENETLER_CODE FROM CASH WHERE CASH_ID = #kasa_id#"); //karsiliksiz senet ise, senet tanımlarındaki protestolu senet hesabı kullanılır
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
								action_id:attributes.id,
								action_row_id : evaluate("attributes.VOUCHER_ID#i#"),
								due_date :iif(len(evaluate("attributes.VOUCHER_DUEDATE#i#")),'createodbcdatetime(evaluate("attributes.VOUCHER_DUEDATE#i#"))','attributes.pyrll_avg_duedate'),
								workcube_process_type:process_type,
								workcube_old_process_type :form.old_process_type,
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
								from_branch_id : branch_id_info,
								workcube_process_cat : form.process_cat,
								acc_project_id : attributes.project_id,
								is_account_group : is_account_group
							);
						}
					}
				}
			}
			else
				muhasebe_sil(action_id:attributes.id,action_table:'VOUCHER_PAYROLL',process_type:form.old_process_type);
		
			basket_kur_ekle(action_id:attributes.id,table_type_id:12,process_type:1);
		</cfscript>
        <cf_add_log log_type="0" action_id="#attributes.id#" action_name="#attributes.payroll_no# Güncellendi" paper_no="#form.payroll_no#" period_id="#session.ep.period_id#" process_type="#get_process_type.PROCESS_TYPE#" data_source="#dsn2#">
	</cftransaction>
</cflock> 
<script type="text/javascript">
	window.location.href="<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.add_voucher_payroll_endor_return&event=upd&ID=#attributes.ID#</cfoutput>";
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
