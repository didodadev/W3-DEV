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
	is_account_type_id= get_process_type.ACCOUNT_TYPE_ID;
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
<cfif not isdefined("attributes.acc_type_id")>
	<cfset attributes.acc_type_id = len(is_account_type_id) ? is_account_type_id : "">
</cfif>
<cfquery name="CONTROL_NO" datasource="#DSN2#">
	SELECT 
		ACTION_ID 
	FROM 
		PAYROLL 
	WHERE 
		PAYROLL_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#PAYROLL_NO#"> AND
		ACTION_ID <> #attributes.id#
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
				PAYROLL
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
				NUMBER_OF_CHEQUE=#attributes.cheque_num#,
				PROJECT_ID = <cfif len(attributes.project_name) and len(attributes.project_id)>#attributes.project_id#<cfelse>NULL</cfif>,
				<cfif len(attributes.pyrll_avg_duedate)>PAYROLL_AVG_DUEDATE=#attributes.pyrll_avg_duedate#,</cfif>
				PAYROLL_AVG_AGE=<cfif len(attributes.pyrll_avg_age)>#attributes.pyrll_avg_age#,<cfelse>NULL,</cfif>
				PAYROLL_REV_MEMBER=#attributes.pro_employee_id#,
				<cfif len(attributes.PAYROLL_NO) >PAYROLL_NO=<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.PAYROLL_NO#">,</cfif>
				CHEQUE_BASED_ACC_CARI = <cfif len(is_cheque_based)>#is_cheque_based#<cfelse>0</cfif>,
				BRANCH_ID = #branch_id_info#,
				UPDATE_EMP=#session.ep.userid#,
				UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">,
				UPDATE_DATE=#NOW()#	,
				ACTION_DETAIL = <cfif isDefined("attributes.action_detail") and len(attributes.action_detail)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.action_detail#"><cfelse>NULL</cfif>,
				SPECIAL_DEFINITION_ID = <cfif isdefined("attributes.special_definition_id") and len(attributes.special_definition_id)>#attributes.special_definition_id#<cfelse>NULL</cfif>,
				ASSETP_ID = <cfif isdefined("attributes.asset_id") and len(attributes.asset_id) and len(attributes.asset_name)>#attributes.asset_id#<cfelse>NULL</cfif>,
			    ACC_TYPE_ID = <cfif isdefined("attributes.acc_type_id") and len(attributes.acc_type_id)>#attributes.acc_type_id#<cfelse>NULL</cfif>
			WHERE
				ACTION_ID=#attributes.id#
		</cfquery>
		<cfquery name="GET_REL_CHEQUES" datasource="#dsn2#">
			SELECT CHEQUE_ID FROM CHEQUE_HISTORY WHERE PAYROLL_ID=#attributes.id#
		</cfquery>
		<cfset ches=valuelist(get_rel_cheques.CHEQUE_ID)>
		<cfloop list="#ches#" index="i">
			<cfset ctr=0>
			<cfloop from="1" to="#attributes.record_num#" index="k">
				<cfif evaluate("attributes.row_kontrol#k#")>
					<cfif i eq evaluate("attributes.cheque_id#k#")>
						<cfset ctr=1>
					</cfif>
				</cfif>
			</cfloop>
			<cfif ctr eq 0> 
				<cfquery name="GET_FORMER_HIST_ID" datasource="#dsn2#">
					SELECT
						MAX(HISTORY_ID) AS H_ID
					FROM
						CHEQUE_HISTORY
					WHERE
						CHEQUE_ID=#i# AND
						(STATUS=1 OR STATUS=5 OR STATUS=10) AND
						PAYROLL_ID IS NOT NULL
				</cfquery>
				<cfquery name="GET_FORMER_INFO" datasource="#dsn2#">
					SELECT
						PAYROLL_ID,
						STATUS
					FROM
						CHEQUE_HISTORY
					WHERE
						HISTORY_ID=#GET_FORMER_HIST_ID.H_ID#		
				</cfquery>
				<cfquery name="UPD_CHEQUE" datasource="#dsn2#">
					UPDATE 
						CHEQUE
					SET
						<!--- CHEQUE_PAYROLL_ID=#GET_FORMER_INFO.PAYROLL_ID#, --->
						CHEQUE_STATUS_ID=#GET_FORMER_INFO.STATUS#
					WHERE
						CHEQUE_ID=#i#
				</cfquery>
				<cfquery name="DEL_CHE_HIST" datasource="#dsn2#">
					DELETE FROM	CHEQUE_HISTORY WHERE CHEQUE_ID=#i# AND PAYROLL_ID=#attributes.id#
				</cfquery>
			</cfif>
		</cfloop>
		<cfloop from="1" to="#attributes.record_num#" index="i">
			<cfif evaluate("attributes.row_kontrol#i#")>
				<cf_date tarih='attributes.cheque_duedate#i#'>
				<cfset ctr=0>
				<cfloop list="#ches#" index="k">
					<cfif k eq evaluate("attributes.cheque_id#i#")>
						<cfset ctr=1>
					</cfif>
				</cfloop>
				<cfif ctr eq 0>
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
									#attributes.id#,
									9,
									#attributes.PAYROLL_REVENUE_DATE#,
									<cfif len(evaluate("attributes.cheque_system_currency_value#i#"))>#evaluate("attributes.cheque_system_currency_value#i#")#,<cfelse>NULL,</cfif>
									<cfif len(evaluate("attributes.system_money_info#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.system_money_info#i#")#'>,<cfelse>NULL,</cfif>
									<cfif len(evaluate("attributes.other_money_value2#i#"))>#evaluate("attributes.other_money_value2#i#")#,<cfelse>NULL,</cfif>
									<cfif len(evaluate("attributes.other_money2#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.other_money2#i#")#'>,<cfelse>NULL,</cfif>
									#NOW()#
								)
					</cfquery>
				<cfelseif ctr eq 1>
					<cfquery name="UPD_CHEQUE_HISTORY" datasource="#dsn2#">
						UPDATE 
							CHEQUE_HISTORY
						SET 
							ACT_DATE = #attributes.PAYROLL_REVENUE_DATE#,
							OTHER_MONEY_VALUE=<cfif len(evaluate("attributes.cheque_system_currency_value#i#"))>#evaluate("attributes.cheque_system_currency_value#i#")#,<cfelse>NULL,</cfif>
							OTHER_MONEY=<cfif len(evaluate("attributes.system_money_info#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.system_money_info#i#")#'>,<cfelse>NULL,</cfif>
							OTHER_MONEY_VALUE2=<cfif len(evaluate("attributes.other_money_value2#i#"))>#evaluate("attributes.other_money_value2#i#")#,<cfelse>NULL,</cfif>
							OTHER_MONEY2=<cfif len(evaluate("attributes.other_money2#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.other_money2#i#")#'><cfelse>NULL</cfif>
						WHERE 
							CHEQUE_ID= #evaluate("attributes.cheque_id#i#")# AND
							PAYROLL_ID = #attributes.id#
					</cfquery>
				</cfif>
			</cfif>
		</cfloop>
		<cfquery name="GET_CHEQUES_LAST" datasource="#dsn2#">
			SELECT 
				CHEQUE.* 
			FROM
				CHEQUE, 
				CHEQUE_HISTORY 
			WHERE
				CHEQUE.CHEQUE_ID=CHEQUE_HISTORY.CHEQUE_ID
				AND PAYROLL_ID=#attributes.id#
		</cfquery>
		<cfscript>
			cheq_no_list=valuelist(GET_CHEQUES_LAST.CHEQUE_NO);
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
			{
				for(cheq_x=1; cheq_x lte attributes.record_num; cheq_x=cheq_x+1)
				{
					if(evaluate("attributes.row_kontrol#cheq_x#"))
						{
							if(ListFindNoCase(ches_2,evaluate("attributes.cheque_id#cheq_x#")))
								ches_2 = ListDeleteAt(ches_2,ListFindNoCase(ches_2,evaluate("attributes.cheque_id#cheq_x#"), ','), ',');
						}
				}
			}				
			if(is_cari eq 1)
			{
				if(is_cheque_based eq 1) /*islem kategorisinde cek bazında carici secili*/
				{
					if(attributes.payroll_acc_cari_cheque_based neq 1) //bordro ilk eklendiginde carici bordro bazında calıstırılmıs ise, silinir
						cari_sil(action_id:attributes.id,action_table:'PAYROLL',process_type:form.old_process_type);
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
								other_money =evaluate("attributes.currency_id#k#"); //cek currency id 
								other_money_value =evaluate("attributes.cheque_value#k#"); //cek value
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
								action_table :'CHEQUE',
								workcube_process_type :process_type,
								workcube_old_process_type :form.old_process_type,		
								process_cat : form.process_cat,
								account_card_type :13,
								islem_tarihi :attributes.PAYROLL_REVENUE_DATE,
								islem_tutari :evaluate("attributes.cheque_system_currency_value#k#"),
								other_money_value : other_money_value,
								other_money : other_money,
								islem_belge_no : evaluate("attributes.cheque_no#k#"),
								currency_multiplier : currency_multiplier,
								due_date : iif(len(evaluate("attributes.cheque_duedate#k#")),'createodbcdatetime(evaluate("attributes.cheque_duedate#k#"))','attributes.pyrll_avg_duedate'),
								to_cmp_id : iif(attributes.member_type eq "partner",'attributes.company_id',de('')),
								to_consumer_id : iif(attributes.member_type eq "consumer",'attributes.consumer_id',de('')),
								to_employee_id : iif(attributes.member_type eq "employee",'attributes.employee_id',de('')),
								payer_id :form.pro_employee_id,
								islem_detay : 'ÇEK İADE ÇIKIŞ BORDROSU(Çek Bazında)',
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
					if(attributes.payroll_acc_cari_cheque_based eq 1)
					{ /*bordrodan cıkarılan ceklerin cari hareketleri siliniyor*/
						for(cheq_n=1;cheq_n lte listlen(ches_2);cheq_n=cheq_n+1)
							cari_sil(action_id:listgetat(ches_2,cheq_n,','),action_table:'CHEQUE',process_type:form.old_process_type,payroll_id :attributes.id);
					}
				}
				else
				{
					if(attributes.payroll_acc_cari_cheque_based eq 1)
					{ /*bordro ilk kaydedildiginde cek bazında cari islem yapılmıssa bu cari hareketler silinir*/
						for(cheq_k=1;cheq_k lte listlen(ches);cheq_k=cheq_k+1)
							cari_sil(action_id:listgetat(ches,cheq_k,','),action_table:'CHEQUE',process_type:form.old_process_type,payroll_id :attributes.id);
					}
					carici(
						action_table :'PAYROLL',
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
						payer_id :form.pro_employee_id,
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
			else
			{
				if(attributes.payroll_acc_cari_cheque_based eq 1) /*bordro kaydedilirken cari-muhasebe hareketleri çek bazında yapılmış ise*/
				{
					for(che_q=1;che_q lte listlen(ches);che_q=che_q+1) /*her bir cek icin olusturulmus cari hareket siliniyor*/
						cari_sil(action_id:listgetat(ches,che_q,','),action_table:'CHEQUE',process_type:form.old_process_type,payroll_id :attributes.id);	
				}
				else /*bordro bazında cari hareket siliniyor*/
					cari_sil(action_id:attributes.id,action_table:'PAYROLL',process_type:form.old_process_type);
			}
			if(is_account eq 1)
			{
				if(is_cheque_based_acc neq 1)	/*standart muhasebe islemleri yapılıyor*/
				{
					alacakli_hesaplar = '';
					alacakli_tutarlar = '';
					other_currency_alacak_list= '';
					other_amount_alacak_list= '';
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
							if(evaluate("attributes.cheque_status_id#k#") eq 9) //bu bordro ile islem yapilmis cekler
							{
								GET_PREV_STATUS=cfquery(datasource:"#dsn2#",sqlstring:"SELECT TOP 1
										STATUS									
									FROM
										CHEQUE_HISTORY AS CH
									WHERE
										CHEQUE_ID=#evaluate("attributes.cheque_id#k#")# AND
										(STATUS=5 OR STATUS=10 OR STATUS=1)
									ORDER BY
										HISTORY_ID DESC	
									");
								if(GET_PREV_STATUS.STATUS eq 5)
								{
									get_bank_acc_code=cfquery(datasource:"#dsn2#",sqlstring:"SELECT KARSILIKSIZ_CEKLER_CODE FROM CASH WHERE CASH_ID = #kasa_id#");
									cek_hesap = get_bank_acc_code.KARSILIKSIZ_CEKLER_CODE;
								}
								else
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
									cek_hesap = GET_ACC_CODE.A_CHEQUE_ACC_CODE;
								}
							alacakli_hesaplar=listappend(alacakli_hesaplar,cek_hesap,',');
							}
							else if(evaluate("attributes.cheque_status_id#k#") eq 5)
							{
								GET_ACC_CODE=cfquery(datasource:"#dsn2#",sqlstring:"SELECT KARSILIKSIZ_CEKLER_CODE FROM CASH WHERE CASH_ID = #kasa_id#");
								alacakli_hesaplar=listappend(alacakli_hesaplar, GET_ACC_CODE.KARSILIKSIZ_CEKLER_CODE, ',');
							}	
							else if(evaluate("attributes.cheque_status_id#k#") eq 1 or evaluate("attributes.cheque_status_id#k#") eq 10) //guncelleme islemi sırasında bordroya yeni eklenen portfoydeki cekler icin
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
						action_id:attributes.id,
						workcube_process_type:process_type,
						workcube_old_process_type :form.old_process_type,
						company_id : iif(attributes.member_type eq "partner",'attributes.company_id',de('')),
						consumer_id : iif(attributes.member_type eq "consumer",'attributes.consumer_id',de('')),
						employee_id : iif(attributes.member_type eq "employee",'attributes.employee_id',de('')),
						account_card_type:13,
						action_table :'PAYROLL',
						islem_tarihi:attributes.PAYROLL_REVENUE_DATE,
						borc_hesaplar: acc,
						borc_tutarlar: attributes.payroll_total,
						other_amount_borc : iif(len(attributes.other_payroll_total),'attributes.other_payroll_total',de('')),
						other_currency_borc : iif(len(attributes.basket_money),'attributes.basket_money',de('')),
						alacak_hesaplar: alacakli_hesaplar,
						alacak_tutarlar: alacakli_tutarlar,
						other_amount_alacak : other_amount_alacak_list,
						other_currency_alacak :other_currency_alacak_list,
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
					// tum muhasebe kayıtlari silinir sonra yaniden eklenir.
					muhasebe_sil(action_id:attributes.id,action_table:'PAYROLL',process_type:form.old_process_type);
					
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
							
							if(evaluate("attributes.cheque_status_id#k#") eq 9) //bu bordro ile islem yapilmis cekler
							{
								GET_PREV_STATUS=cfquery(datasource:"#dsn2#",sqlstring:"SELECT TOP 1
										STATUS									
									FROM
										CHEQUE_HISTORY AS CH
									WHERE
										CHEQUE_ID=#evaluate("attributes.cheque_id#k#")# AND
										(STATUS=5 OR STATUS=10 OR STATUS=1)
									ORDER BY
										HISTORY_ID DESC	
									");
								if(GET_PREV_STATUS.STATUS eq 5)
								{
									get_bank_acc_code=cfquery(datasource:"#dsn2#",sqlstring:"SELECT KARSILIKSIZ_CEKLER_CODE FROM CASH WHERE CASH_ID = #kasa_id#");
									cek_hesap = get_bank_acc_code.KARSILIKSIZ_CEKLER_CODE;
								}
								else
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
									cek_hesap = GET_ACC_CODE.A_CHEQUE_ACC_CODE;
								}
								alacakli_hesaplar=cek_hesap;
							}
							else if(evaluate("attributes.cheque_status_id#k#") eq 5)
							{
								GET_ACC_CODE=cfquery(datasource:"#dsn2#",sqlstring:"SELECT KARSILIKSIZ_CEKLER_CODE FROM CASH WHERE CASH_ID = #kasa_id#");
								alacakli_hesaplar=GET_ACC_CODE.KARSILIKSIZ_CEKLER_CODE;
							}	
							else if(evaluate("attributes.cheque_status_id#k#") eq 1 or evaluate("attributes.cheque_status_id#k#") eq 10) //guncelleme islemi sırasında bordroya yeni eklenen portfoydeki cekler icin
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
								action_id:attributes.id,
								action_row_id : evaluate("attributes.CHEQUE_ID#k#"),
								due_date :iif(len(evaluate("attributes.CHEQUE_DUEDATE#k#")),'createodbcdatetime(evaluate("attributes.CHEQUE_DUEDATE#k#"))','attributes.pyrll_avg_duedate'),
								workcube_process_type:process_type,
								workcube_old_process_type :form.old_process_type,
								company_id : iif(attributes.member_type eq "partner",'attributes.company_id',de('')),
								consumer_id : iif(attributes.member_type eq "consumer",'attributes.consumer_id',de('')),
								employee_id : iif(attributes.member_type eq "employee",'attributes.employee_id',de('')),
								account_card_type:13,
								action_table :'PAYROLL',
								islem_tarihi:attributes.PAYROLL_REVENUE_DATE,
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
		else
		{
			muhasebe_sil(action_id:attributes.id,action_table:'PAYROLL',process_type:form.old_process_type);
		}
		basket_kur_ekle(action_id:attributes.id,table_type_id:11,process_type:1);	
	</cfscript>
	<cf_workcube_process_cat 
			process_cat="#form.process_cat#"
			old_process_cat_id = "#attributes.old_process_cat_id#"
			action_id = #attributes.id#
			is_action_file = 1
			action_db_type = '#dsn2#'
			action_page='#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_add_payroll_endor_return&event=upd&ID=#attributes.ID#'
			action_file_name='#get_process_type.action_file_name#'
			is_template_action_file = '#get_process_type.action_file_from_template#'>
</cftransaction>
</cflock>
<script type="text/javascript">
	window.location.href="<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_add_payroll_endor_return&event=upd&ID=#attributes.ID#</cfoutput>";
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">

