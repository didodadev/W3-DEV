<cfif form.active_period neq session.ep.period_id>
	<script type="text/javascript">
		alert("İşlem Yapmak İstediğiniz Muhasebe Dönemi ile Aktif Muhasebe Döneminiz Farklı Muhasebe Döneminizi Kontrol Ediniz!");
		wrk_opener_reload();
		window.close();
	</script>
	<cfabort>
</cfif>
<cf_get_lang_set module_name="cheque"><!--- sayfanin en altinda kapanisi var --->
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
	if(isdefined("attributes.branch_id") and len(attributes.branch_id))
		branch_id_info = attributes.branch_id;
	else
		branch_id_info = listgetat(session.ep.user_location,2,'-');
	if(listlen(attributes.employee_id,'_') eq 2)
	{
		attributes.acc_type_id = listlast(attributes.employee_id,'_');
		attributes.employee_id = listfirst(attributes.employee_id,'_');
	}
</cfscript>
<cfif not isdefined("attributes.acc_type_id")><cfset attributes.acc_type_id = len(is_account_type_id) ? is_account_type_id : ""></cfif>
<cfquery name="control_no" datasource="#dsn2#">
	SELECT ACTION_ID FROM VOUCHER_PAYROLL WHERE PAYROLL_NO = '#attributes.PAYROLL_NO#' 
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
		<cfset acc = get_company_period(company_id: attributes.company_id,acc_type_id: len(is_account_type_id) ? is_account_type_id : "")>
	<cfelseif attributes.member_type eq "consumer" and len(attributes.consumer_id)>
		<cfset acc = get_consumer_period(consumer_id : attributes.consumer_id, acc_type_id : len(is_account_type_id) ? is_account_type_id : "")>
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
<cflock name="#createUUID()#" timeout="20">
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
					COMPANY_ID,
					CONSUMER_ID,
					EMPLOYEE_ID,
					CURRENCY_ID,
					PROJECT_ID,
					PAYROLL_REVENUE_DATE,
					PAYROLL_REV_MEMBER,
					PAYROLL_AVG_DUEDATE,
					PAYROLL_AVG_AGE,
					PAYROLL_NO,
					RECORD_EMP,
					RECORD_IP,
					RECORD_DATE,
					VOUCHER_BASED_ACC_CARI,
					ACTION_DETAIL,
					BRANCH_ID,
					SPECIAL_DEFINITION_ID,
					ASSETP_ID,
					CONTRACT_ID,
					ACC_TYPE_ID
				)
				VALUES(
					#form.process_cat#,
					#process_type#,
					#attributes.payroll_total#,
					<cfif isdefined("attributes.basket_money") and len(attributes.basket_money)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.basket_money#">,<cfelse>NULL,</cfif>
					<cfif isdefined("attributes.other_payroll_total") and len(attributes.other_payroll_total)>#attributes.other_payroll_total#,<cfelse>NULL,</cfif>
					#attributes.voucher_num#,
					<cfif attributes.member_type eq "partner" and len(attributes.company_id)>#attributes.company_id#<cfelse>NULL</cfif>,
					<cfif attributes.member_type eq "consumer" and len(attributes.consumer_id)>#attributes.consumer_id#<cfelse>NULL</cfif>,
					<cfif attributes.member_type eq "employee" and len(attributes.employee_id)>#attributes.employee_id#<cfelse>NULL</cfif>,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money#">,
					<cfif len(attributes.project_name) and len(attributes.project_id)>#attributes.project_id#<cfelse>NULL</cfif>,
					#attributes.PAYROLL_REVENUE_DATE#,
					#attributes.pro_employee_id#,
					<cfif len(attributes.pyrll_avg_duedate)>#attributes.pyrll_avg_duedate#,<cfelse>NULL,</cfif>
					<cfif len(attributes.pyrll_avg_age)>#attributes.pyrll_avg_age#,<cfelse>NULL,</cfif>
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.PAYROLL_NO#">,
					#session.ep.userid#,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">,
					#NOW()#,
					<cfif len(is_voucher_based)>#is_voucher_based#<cfelse>0</cfif>,
					<cfif isDefined("attributes.action_detail") and len(attributes.action_detail)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.action_detail#"><cfelse>NULL</cfif>,
					#branch_id_info#,
					<cfif isdefined("attributes.special_definition_id") and len(attributes.special_definition_id)>#attributes.special_definition_id#<cfelse>NULL</cfif>,
					<cfif isdefined("attributes.asset_id") and len(attributes.asset_id) and len(attributes.asset_name)>#attributes.asset_id#<cfelse>NULL</cfif>,
					<cfif isdefined("attributes.contract_id") and len(attributes.contract_id) and len(attributes.contract_head)>#attributes.contract_id#<cfelse>NULL</cfif>,
					<cfif isdefined("attributes.acc_type_id") and len(attributes.acc_type_id)>#attributes.acc_type_id#<cfelse>NULL</cfif>
				)
		</cfquery>
		<!--- bordro cari tablosuna kaydedilek--->
		<cfquery name="GET_BORDRO_ID" datasource="#dsn2#">
			SELECT MAX(ACTION_ID) AS P_ID FROM VOUCHER_PAYROLL
		</cfquery>
		<cfset P_ID=get_bordro_id.P_ID>
		<!--- Senet durumları Senet Tablosundan Update Edilecek--->
		<cfset portfoy_no = get_cheque_no(belge_tipi:'voucher')>
		<cfloop from="1" to="#attributes.record_num#" index="i">
			<cfif evaluate("attributes.row_kontrol#i#")>
				<cf_date tarih='attributes.voucher_duedate#i#'>
				<cfif len(evaluate("attributes.voucher_id#i#"))>
					<cfquery name="UPD_VOUCHERS" datasource="#dsn2#">
						UPDATE
							VOUCHER
						SET 
						<cfif evaluate("attributes.voucher_status_id#i#") eq 1>
							VOUCHER_STATUS_ID=4,
						</cfif>
						<cfif evaluate("attributes.voucher_status_id#i#") eq 6>
							VOUCHER_PAYROLL_ID=#P_ID#,
							COMPANY_ID = <cfif attributes.member_type eq "partner" and len(attributes.company_id)>#attributes.company_id#<cfelse>NULL</cfif>,
							CONSUMER_ID = <cfif attributes.member_type eq "consumer" and len(attributes.consumer_id)>#attributes.consumer_id#<cfelse>NULL</cfif>,
							EMPLOYEE_ID = <cfif attributes.member_type eq "employee" and len(attributes.employee_id)>#attributes.employee_id#<cfelse>NULL</cfif>,
						<cfelseif evaluate("attributes.voucher_status_id#i#") eq 6 and len(evaluate("attributes.voucher_id#i#"))>
							OTHER_MONEY_VALUE = <cfif len(evaluate("attributes.voucher_system_currency_value#i#"))>#evaluate("attributes.voucher_system_currency_value#i#")#,<cfelse>NULL,</cfif>
							OTHER_MONEY=<cfif len(evaluate("attributes.system_money_info#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.system_money_info#i#")#'>,<cfelse>NULL,</cfif>
							OTHER_MONEY_VALUE2 = <cfif len(evaluate("attributes.other_money_value2#i#"))>#evaluate("attributes.other_money_value2#i#")#,<cfelse>NULL,</cfif>
							OTHER_MONEY2=<cfif len(evaluate("attributes.other_money2#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.other_money2#i#")#'>,<cfelse>NULL,</cfif>
						</cfif>
							RECORD_DATE=#now()#
						WHERE
							VOUCHER_ID= #evaluate("attributes.voucher_id#i#")#
					</cfquery>
					<cfif evaluate("attributes.voucher_status_id#i#") eq 6 and len(evaluate("attributes.voucher_id#i#"))>
						<cfquery name="del_voucher_money" datasource="#dsn2#">
							DELETE FROM VOUCHER_MONEY WHERE ACTION_ID = #evaluate("attributes.voucher_id#i#")#
						</cfquery>
						<cfif len(evaluate("attributes.money_list#i#"))>
							<cfloop from="1" to="#ListGetAt(evaluate("attributes.money_list#i#"),1,'-')#" index="j">
								<cfset money = ListGetAt(evaluate("attributes.money_list#i#"),j+1,'-')>
								<cfquery name="ADD_MONEY_INFO" datasource="#dsn2#">
									INSERT INTO VOUCHER_MONEY 
									(
										ACTION_ID,
										MONEY_TYPE,
										RATE2,
										RATE1,
										IS_SELECTED
									)
									VALUES
									(
										#evaluate("attributes.voucher_id#i#")#,
										<cfqueryparam cfsqltype="cf_sql_varchar" value="#ListGetAt(money,1,',')#">,
										#ListGetAt(money,3,',')#,					
										#ListGetAt(money,2,',')#,
										<cfif ListGetAt(money,1,',') is evaluate("attributes.currency_id#i#")>1<cfelse>0</cfif>
									)
								</cfquery>
							</cfloop>
						</cfif>
					</cfif>
				<cfelse>
					<cfquery name="ADD_SELF_VOUCHERS" datasource="#dsn2#">
						INSERT INTO
							VOUCHER
							(
								VOUCHER_PAYROLL_ID,
								COMPANY_ID,
								CONSUMER_ID,
								EMPLOYEE_ID,
								VOUCHER_CODE,
								VOUCHER_DUEDATE,
								VOUCHER_NO,
								VOUCHER_VALUE,
								OTHER_MONEY_VALUE,
								OTHER_MONEY,
								OTHER_MONEY_VALUE2,
								OTHER_MONEY2,
								VOUCHER_STATUS_ID,
								VOUCHER_CITY,
								VOUCHER_PURSE_NO,
								CURRENCY_ID,
								DEBTOR_NAME,
								ACCOUNT_CODE,
								RECORD_EMP,
								RECORD_IP,
								RECORD_DATE,
								CH_OTHER_MONEY_VALUE,
								CH_OTHER_MONEY,
								CASH_ID,
								ENTRY_DATE
							)
							VALUES
							(
								#P_ID#,
								<cfif attributes.member_type eq "partner" and len(attributes.company_id)>#attributes.company_id#<cfelse>NULL</cfif>,
								<cfif attributes.member_type eq "consumer" and len(attributes.consumer_id)>#attributes.consumer_id#<cfelse>NULL</cfif>,
								<cfif attributes.member_type eq "employee" and len(attributes.employee_id)>#attributes.employee_id#<cfelse>NULL</cfif>,
								<cfif len(evaluate("attributes.voucher_code#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.voucher_code#i#")#'>,<cfelse>NULL,</cfif>
								#evaluate("attributes.voucher_duedate#i#")#,
								<cfif len(evaluate("attributes.voucher_no#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.voucher_no#i#")#'>,<cfelse>NULL,</cfif>
								#evaluate("attributes.voucher_value#i#")#,
								<cfif len(evaluate("attributes.voucher_system_currency_value#i#"))>#evaluate("attributes.voucher_system_currency_value#i#")#,<cfelse>NULL,</cfif>
								<cfif len(evaluate("attributes.system_money_info#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.system_money_info#i#")#'>,<cfelse>NULL,</cfif>
								<cfif len(evaluate("attributes.other_money_value2#i#"))>#evaluate("attributes.other_money_value2#i#")#,<cfelse>NULL,</cfif>
								<cfif len(evaluate("attributes.other_money2#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.other_money2#i#")#'>,<cfelse>NULL,</cfif>
								6,
								<cfif len(evaluate("attributes.voucher_city#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.voucher_city#i#")#'>,<cfelse>NULL,</cfif>
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#portfoy_no#">,
								<cfif len(evaluate("attributes.currency_id#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.currency_id#i#")#'>,<cfelse>NULL,</cfif>
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#SESSION.EP.COMPANY#">,
								<cfif len(evaluate("attributes.acc_code#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.acc_code#i#")#'>,<cfelse>NULL,</cfif>
								#session.ep.userid#,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
								#NOW()#,
								#wrk_round((evaluate("attributes.voucher_system_currency_value#i#")/attributes.basket_money_rate),4)#,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.basket_money#">,
								<cfif len(evaluate("attributes.cash_id#i#"))><cfqueryparam cfsqltype="cf_sql_integer" value='#wrk_eval("attributes.cash_id#i#")#'><cfelse>NULL</cfif>,
								#attributes.PAYROLL_REVENUE_DATE#
							)
					</cfquery>
					<cfquery name="GET_LAST_ID" datasource="#dsn2#">
						SELECT MAX(VOUCHER_ID) AS VOUCHER_ID FROM VOUCHER
					</cfquery>
					<cfif len(evaluate("attributes.money_list#i#"))>
						<cfloop from="1" to="#ListGetAt(evaluate("attributes.money_list#i#"),1,'-')#" index="j">
							<cfset money = ListGetAt(evaluate("attributes.money_list#i#"),j+1,'-')>
							<cfquery name="ADD_MONEY_INFO" datasource="#dsn2#">
								INSERT INTO VOUCHER_MONEY 
								(
									ACTION_ID,
									MONEY_TYPE,
									RATE2,
									RATE1,
									IS_SELECTED
								)
								VALUES
								(
									#GET_LAST_ID.VOUCHER_ID#,
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#ListGetAt(money,1,',')#">,
									#ListGetAt(money,3,',')#,					
									#ListGetAt(money,2,',')#,
									<cfif ListGetAt(money,1,',') is evaluate("attributes.currency_id#i#")>1<cfelse>0</cfif>
								)
							</cfquery>
						</cfloop>
					</cfif>
				</cfif>
				<cfset portfoy_no = portfoy_no+1>
				<cfquery name="ADD_VOUCHER_HISTORY" datasource="#dsn2#">
					INSERT INTO
						VOUCHER_HISTORY
						(
							VOUCHER_ID,
							PAYROLL_ID,
							<cfif evaluate("attributes.voucher_status_id#i#") eq 6>
								COMPANY_ID,
								CONSUMER_ID,
								EMPLOYEE_ID,
							</cfif>
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
							<cfif evaluate("attributes.voucher_status_id#i#") eq 6>
								<cfif attributes.member_type eq "partner" and len(attributes.company_id)>#attributes.company_id#<cfelse>NULL</cfif>,
								<cfif attributes.member_type eq "consumer" and len(attributes.consumer_id)>#attributes.consumer_id#<cfelse>NULL</cfif>,
								<cfif attributes.member_type eq "employee" and len(attributes.employee_id)>#attributes.employee_id#<cfelse>NULL</cfif>,
							</cfif>
							<cfif evaluate("attributes.voucher_status_id#i#") eq 1>4,<cfelse>6,</cfif>
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
		<cfset portfoy_no = get_cheque_no(belge_tipi:'voucher',belge_no:portfoy_no)>
		<cfquery name="GET_VOUCHERS_LAST" datasource="#dsn2#">
			SELECT 
				VOUCHER.*,
                VOUCHER_HISTORY.OTHER_MONEY_VALUE OTHER_MONEY_VALUE_LAST
			FROM
				VOUCHER, 
				VOUCHER_HISTORY 
			WHERE
				VOUCHER.VOUCHER_ID=VOUCHER_HISTORY.VOUCHER_ID
				AND VOUCHER_HISTORY.PAYROLL_ID=#p_id#
		</cfquery>
		<cfset voucher_no_list=valuelist(GET_VOUCHERS_LAST.VOUCHER_NO)>
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
				if (is_cari eq 1)
				{
					if(is_voucher_based eq 1) /*cari hareket senet bazında yapılıyor.senet bazında carici calıstırılırken ACTION_TABLE parametresine dikkat plz...*/
					{				
						for(cheq_i=1; cheq_i lte attributes.record_num; cheq_i=cheq_i+1)
						{
							if (evaluate("attributes.row_kontrol#cheq_i#"))
							{
								if(len(attributes.basket_money) and len(attributes.basket_money_rate))
								{
									other_money = attributes.basket_money;
									other_money_value = wrk_round(evaluate("attributes.voucher_system_currency_value#cheq_i#")/attributes.basket_money_rate);
								}
								else if(evaluate("attributes.currency_id#cheq_i#") is not session.ep.money)
								{
									other_money = evaluate("attributes.currency_id#cheq_i#"); 
									other_money_value = evaluate("attributes.voucher_value#cheq_i#"); 
								}
								else if(len(evaluate("attributes.other_money_value2#cheq_i#")) and len(evaluate("attributes.other_money2#cheq_i#")) )
								{
									other_money = evaluate("attributes.other_money2#cheq_i#");
									other_money_value = evaluate("attributes.other_money_value2#cheq_i#");
								}
								else
								{
									other_money = evaluate("attributes.system_money_info#cheq_i#"); 
									other_money_value = evaluate("attributes.voucher_system_currency_value#cheq_i#"); 
								}
								paper_currency_multiplier = '';
								if(isDefined('attributes.kur_say') and len(attributes.kur_say))
									for(mon=1;mon lte attributes.kur_say;mon=mon+1)
									{
										if(evaluate("attributes.hidden_rd_money_#mon#") is other_money)
											paper_currency_multiplier = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
									}
								carici(
									action_id :iif(len(evaluate("attributes.voucher_id#cheq_i#")),'evaluate("attributes.voucher_id#cheq_i#")','GET_VOUCHERS_LAST.VOUCHER_ID[listfind(voucher_no_list,evaluate("attributes.voucher_no#cheq_i#"))]'),
									action_table :'VOUCHER',
									process_cat :form.process_cat,
									workcube_process_type :process_type,
									account_card_type :13,
									islem_tarihi :attributes.PAYROLL_REVENUE_DATE,
									islem_tutari : evaluate("attributes.voucher_system_currency_value#cheq_i#"),
									other_money_value : other_money_value,
									other_money : other_money,
									islem_belge_no :iif(len(evaluate("attributes.voucher_no#cheq_i#")),evaluate("attributes.voucher_no#cheq_i#"),de('')),
									due_date : iif(len(GET_VOUCHERS_LAST.VOUCHER_DUEDATE[listfind(voucher_no_list,evaluate("attributes.voucher_no#cheq_i#"))]),'createodbcdatetime(GET_VOUCHERS_LAST.VOUCHER_DUEDATE[listfind(voucher_no_list,evaluate("attributes.voucher_no#cheq_i#"))])','attributes.pyrll_avg_duedate'),
									to_cmp_id : iif(attributes.member_type eq "partner",'attributes.company_id',de('')),
									to_consumer_id : iif(attributes.member_type eq "consumer",'attributes.consumer_id',de('')),
									to_employee_id : iif(attributes.member_type eq "employee",'attributes.employee_id',de('')),
									payer_id : attributes.pro_employee_id,
									islem_detay : 'SENET ÇIKIŞ BORDROSU(CİRO-Senet Bazında)',
									acc_type_id : attributes.acc_type_id,
									action_detail : attributes.action_detail,
									currency_multiplier : currency_multiplier,
									project_id : attributes.project_id,
									from_branch_id : branch_id_info,
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
							other_money :iif(len(attributes.basket_money),'attributes.basket_money',de('')),
							action_currency :session.ep.money,
							payer_id :attributes.pro_employee_id,
							due_date : attributes.pyrll_avg_duedate,
							islem_belge_no :attributes.payroll_no,
							to_cmp_id : iif(attributes.member_type eq "partner",'attributes.company_id',de('')),
							to_consumer_id : iif(attributes.member_type eq "consumer",'attributes.consumer_id',de('')),
							to_employee_id : iif(attributes.member_type eq "employee",'attributes.employee_id',de('')),
							currency_multiplier : currency_multiplier,
							islem_detay : 'SENET ÇIKIŞ BORDROSU(CİRO)',
							acc_type_id : attributes.acc_type_id,
							action_detail : attributes.action_detail,
							project_id : attributes.project_id,
							from_branch_id : branch_id_info,
							special_definition_id : iif((isdefined("attributes.special_definition_id") and len(attributes.special_definition_id)),'attributes.special_definition_id',de('')),
							assetp_id : iif((isdefined("attributes.asset_id") and len(attributes.asset_id) and len(attributes.asset_name)),'attributes.asset_id',de('')),
							rate2:paper_currency_multiplier
							);
					}
				}
			if (is_account eq 1)
			{
				if(is_voucher_based_acc neq 1)	/*standart muhasebe islemleri yapılıyor*/
				{
					alacak_tutarlar = '';
					alacak_hesaplar = '';
					other_currency_alacak_list= '';
					other_amount_alacak_list= '';
					for(i=1; i lte attributes.record_num; i=i+1)
					{
						if (evaluate("attributes.row_kontrol#i#"))
						{
							if(evaluate("attributes.currency_id#i#") eq session.ep.money)
								alacak_tutarlar=listappend(alacak_tutarlar,evaluate("attributes.voucher_value#i#"),',');
							else
								alacak_tutarlar=listappend(alacak_tutarlar,evaluate("attributes.voucher_system_currency_value#i#"),',');
							
							other_amount_alacak_list = listappend(other_amount_alacak_list,evaluate("attributes.voucher_value#i#"),',');
							other_currency_alacak_list = listappend(other_currency_alacak_list,evaluate("attributes.currency_id#i#"),',');
							if(len(evaluate("attributes.acc_code#i#")))//özel muhasebe hesabı secilmis ise
								alacak_hesaplar=listappend(alacak_hesaplar,evaluate("attributes.acc_code#i#"),',');
							else if(evaluate("attributes.voucher_status_id#i#") eq 1)
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
									GET_ACC_CODE=cfquery(datasource:"#dsn2#", sqlstring:"
										SELECT 
											A_VOUCHER_ACC_CODE
										FROM
											VOUCHER_HISTORY VH,
											VOUCHER_PAYROLL VP,
											CASH C
										WHERE
											VP.PAYROLL_CASH_ID = C.CASH_ID AND
											VP.PAYROLL_TYPE IN (97,107,109) AND 
											VP.ACTION_ID= VH.PAYROLL_ID AND
											VH.VOUCHER_ID=#evaluate("attributes.voucher_id#i#")#");
								}
								alacak_hesaplar=listappend(alacak_hesaplar, GET_ACC_CODE.A_VOUCHER_ACC_CODE, ',');
							}
							else if(evaluate("attributes.voucher_status_id#i#") eq 6) //odenmedi ise voucher_status_id = 6
							{	
								GET_V_ACC_CODE = cfquery(datasource:"#dsn2#",sqlstring:"
									SELECT 
										V_VOUCHER_ACC_CODE
									FROM
										CASH C
									WHERE
										C.CASH_ID=#evaluate("attributes.cash_id#i#")#");
								alacak_hesaplar=listappend(alacak_hesaplar ,GET_V_ACC_CODE.V_VOUCHER_ACC_CODE, ',');
							}
							if (is_account_group neq 1)
							{
								if (isDefined("attributes.action_detail") and len(attributes.action_detail))
									str_card_detail[2][listlen(alacak_tutarlar)] = ' #evaluate("attributes.voucher_no#i#")# - #attributes.company_name# - #attributes.action_detail#';
								else
									str_card_detail[2][listlen(alacak_tutarlar)] = ' #evaluate("attributes.voucher_no#i#")# - #attributes.company_name# - SENET ÇIKIŞ İŞLEMİ';
							}
							else
							{
								if (isDefined("attributes.action_detail") and len(attributes.action_detail))
									str_card_detail[2][listlen(alacak_tutarlar)] = ' #attributes.company_name# - #attributes.action_detail#';
								else
									str_card_detail[2][listlen(alacak_tutarlar)] = ' #attributes.company_name# - SENET ÇIKIŞ İŞLEMİ';
							}
						}
					}
					if(isDefined("attributes.action_detail") and len(attributes.action_detail))
						str_card_detail[1][1] = ' #attributes.company_name# - #attributes.action_detail#';
					else
						str_card_detail[1][1] = ' #attributes.company_name# - SENET ÇIKIŞ İŞLEMİ';
					muhasebeci (
						action_id:p_id,
						workcube_process_type:process_type,
						account_card_type:13,
						action_table :'VOUCHER_PAYROLL',
						islem_tarihi:attributes.PAYROLL_REVENUE_DATE,
						company_id : iif(attributes.member_type eq "partner",'attributes.company_id',de('')),
						consumer_id : iif(attributes.member_type eq "consumer",'attributes.consumer_id',de('')),
						employee_id : iif(attributes.member_type eq "employee",'attributes.employee_id',de('')),
						borc_hesaplar : acc,
						borc_tutarlar : attributes.payroll_total,
						other_amount_borc : iif(len(attributes.other_payroll_total),'attributes.other_payroll_total',de('')),
						other_currency_borc : iif(len(attributes.basket_money),'attributes.basket_money',de('')),
						alacak_hesaplar : alacak_hesaplar,
						alacak_tutarlar : alacak_tutarlar,
						other_amount_alacak : other_amount_alacak_list,
						other_currency_alacak :other_currency_alacak_list,
						fis_detay : 'SENET ÇIKIŞ İŞLEMİ',
						fis_satir_detay : str_card_detail,
						currency_multiplier : currency_multiplier,
						belge_no : form.payroll_no,
						from_branch_id : branch_id_info,
						workcube_process_cat : form.process_cat,
						acc_project_id : attributes.project_id,
						is_account_group : is_account_group
					);
				}
				else		/*e-deftere uygun muhasebe islemleri yapılıyor*/
				{
					for(i=1; i lte GET_VOUCHERS_LAST.recordcount; i=i+1)
					{
						if(GET_VOUCHERS_LAST.CURRENCY_ID[i] neq session.ep.money)
							alacak_tutarlar = GET_VOUCHERS_LAST.OTHER_MONEY_VALUE_LAST[i];
						else
							alacak_tutarlar = GET_VOUCHERS_LAST.VOUCHER_VALUE[i];
						
						if(len(GET_VOUCHERS_LAST.ACCOUNT_CODE[i]))//özel muhasebe hesabı secilmis ise
							alacak_hesaplar = GET_VOUCHERS_LAST.ACCOUNT_CODE[i];
						else if(listfind('1,4',GET_VOUCHERS_LAST.VOUCHER_STATUS_ID[i]))
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
									CH.VOUCHER_ID = #GET_VOUCHERS_LAST.VOUCHER_ID[i]#");
							if(GET_ACC_CODE.recordcount eq 0)
							{
								GET_ACC_CODE=cfquery(datasource:"#dsn2#", sqlstring:"
									SELECT 
										A_VOUCHER_ACC_CODE
									FROM
										VOUCHER_HISTORY VH,
										VOUCHER_PAYROLL VP,
										CASH C
									WHERE
										VP.PAYROLL_CASH_ID = C.CASH_ID AND
										VP.PAYROLL_TYPE IN (97,107,109) AND 
										VP.ACTION_ID= VH.PAYROLL_ID AND
										VH.VOUCHER_ID = #GET_VOUCHERS_LAST.VOUCHER_ID[i]#");
							}
							alacak_hesaplar = GET_ACC_CODE.A_VOUCHER_ACC_CODE;
						}
						else if(GET_VOUCHERS_LAST.VOUCHER_STATUS_ID[i] eq 6) //odenmedi ise voucher_status_id = 6
						{	
							GET_V_ACC_CODE = cfquery(datasource:"#dsn2#",sqlstring:"
								SELECT 
									V_VOUCHER_ACC_CODE
								FROM
									CASH C
								WHERE
									C.CASH_ID = #GET_VOUCHERS_LAST.CASH_ID[i]#");
							alacak_hesaplar = GET_V_ACC_CODE.V_VOUCHER_ACC_CODE;
						}
						if (is_account_group neq 1)
						{
							if (isDefined("attributes.action_detail") and len(attributes.action_detail))
								str_card_detail[2][1] = ' #GET_VOUCHERS_LAST.VOUCHER_NO[i]# - #attributes.company_name# - #attributes.action_detail#';
							else
								str_card_detail[2][1] = ' #GET_VOUCHERS_LAST.VOUCHER_NO[i]# - #attributes.company_name# - SENET ÇIKIŞ İŞLEMİ';
						}
						else
						{
							if (isDefined("attributes.action_detail") and len(attributes.action_detail))
								str_card_detail[2][1] = ' #attributes.company_name# - #attributes.action_detail#';
							else
								str_card_detail[2][1] = ' #attributes.company_name# - SENET ÇIKIŞ İŞLEMİ';
						}
						if(isDefined("attributes.action_detail") and len(attributes.action_detail))
							str_card_detail[1][1] = ' #attributes.company_name# - #attributes.action_detail#';
						else
							str_card_detail[1][1] = ' #attributes.company_name# - SENET ÇIKIŞ İŞLEMİ';
						muhasebeci (
							action_id:p_id,
							action_row_id : GET_VOUCHERS_LAST.VOUCHER_ID[i],
							due_date :iif(len(GET_VOUCHERS_LAST.VOUCHER_DUEDATE[i]),'createodbcdatetime(GET_VOUCHERS_LAST.VOUCHER_DUEDATE[i])','attributes.pyrll_avg_duedate'),
							workcube_process_type:process_type,
							account_card_type:13,
							action_table :'VOUCHER_PAYROLL',
							islem_tarihi:attributes.PAYROLL_REVENUE_DATE,
							company_id : iif(attributes.member_type eq "partner",'attributes.company_id',de('')),
							consumer_id : iif(attributes.member_type eq "consumer",'attributes.consumer_id',de('')),
							employee_id : iif(attributes.member_type eq "employee",'attributes.employee_id',de('')),
							borc_hesaplar : acc,
							borc_tutarlar : alacak_tutarlar,
							other_amount_borc : GET_VOUCHERS_LAST.OTHER_MONEY_VALUE_LAST[i]/paper_currency_multiplier,
							other_currency_borc : iif(len(attributes.basket_money),'attributes.basket_money',de('')),
							alacak_hesaplar : alacak_hesaplar,
							alacak_tutarlar : alacak_tutarlar,
							other_amount_alacak : GET_VOUCHERS_LAST.VOUCHER_VALUE[i],
							other_currency_alacak : GET_VOUCHERS_LAST.CURRENCY_ID[i],
							fis_detay : 'SENET ÇIKIŞ İŞLEMİ',
							fis_satir_detay : str_card_detail,
							currency_multiplier : currency_multiplier,
							belge_no : GET_VOUCHERS_LAST.VOUCHER_NO[i],
							from_branch_id : branch_id_info,
							workcube_process_cat : form.process_cat,
							acc_project_id : attributes.project_id,
							is_account_group : is_account_group
						);
					}
				}
			}
			basket_kur_ekle(action_id:GET_BORDRO_ID.P_ID,table_type_id:12,process_type:0);
		</cfscript>
        <cf_workcube_process_cat 
            process_cat="#form.process_cat#"
            action_id = #p_id#
            is_action_file = 1
            action_db_type = '#dsn2#'
            action_page='#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_add_voucher_payroll_endorsement&event=upd&ID=#p_id#'
            action_file_name='#get_process_type.action_file_name#'
            is_template_action_file = '#get_process_type.action_file_from_template#'>
        <cf_add_log employee_id="#session.ep.userid#" log_type="1" action_id="#p_id#" action_name="#PAYROLL_NO# Eklendi" paper_no="#PAYROLL_NO#" period_id="#session.ep.period_id#"  process_type="#get_process_type.PROCESS_TYPE#" data_source="#dsn2#">
	</cftransaction>
</cflock>
<script type="text/javascript">
	window.location.href="<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_add_voucher_payroll_endorsement&event=upd&ID=#p_id#</cfoutput>";
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
