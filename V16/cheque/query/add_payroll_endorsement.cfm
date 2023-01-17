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
	is_account_type_id = get_process_type.ACCOUNT_TYPE_ID;
	attributes.payroll_total = filterNum(attributes.payroll_total);
	attributes.other_payroll_total = filterNum(attributes.other_payroll_total);
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
				PAYROLL
			(
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
				CHEQUE_BASED_ACC_CARI,
				RECORD_EMP,
				RECORD_IP,
				RECORD_DATE,
				ACTION_DETAIL,
				BRANCH_ID,
				SPECIAL_DEFINITION_ID,
				ASSETP_ID,
				CONTRACT_ID,
				ACC_TYPE_ID
			)
			VALUES
			(
				#form.process_cat#,
				#process_type#,
				#attributes.payroll_total#,
				<cfif isdefined("attributes.basket_money") and len(attributes.basket_money)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.basket_money#"><cfelse>NULL</cfif>,
				<cfif isdefined("attributes.other_payroll_total") and len(attributes.other_payroll_total)>#attributes.other_payroll_total#<cfelse>NULL</cfif>,
				#attributes.cheque_num#,
				<cfif len(attributes.project_name) and len(attributes.project_id)>#attributes.project_id#<cfelse>NULL</cfif>,
				<cfif attributes.member_type eq "partner" and len(attributes.company_id)>#attributes.company_id#<cfelse>NULL</cfif>,
				<cfif attributes.member_type eq "consumer" and len(attributes.consumer_id)>#attributes.consumer_id#<cfelse>NULL</cfif>,
				<cfif attributes.member_type eq "employee" and len(attributes.employee_id)>#attributes.employee_id#<cfelse>NULL</cfif>,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money#">,
				#attributes.PAYROLL_REVENUE_DATE#,
				#attributes.pro_employee_id#,
				#attributes.pyrll_avg_duedate#,
				<cfif len(attributes.pyrll_avg_age)>#attributes.pyrll_avg_age#<cfelse>NULL</cfif>,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.PAYROLL_NO#">,
				<cfif len(is_cheque_based)>#is_cheque_based#<cfelse>0</cfif>,
				#session.ep.userid#,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
				#now()#,
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
			SELECT MAX(ACTION_ID) AS P_ID FROM PAYROLL
		</cfquery>
		<cfset p_id=get_bordro_id.P_ID> 
		<!--- çek durumlari çek tablosundan update edilecek--->
		<cfset portfoy_no = get_cheque_no(belge_tipi:'cheque')>
		<cfloop from="1" to="#attributes.record_num#" index="i">
			<cfif evaluate("attributes.row_kontrol#i#")>
				<cfif len(evaluate("attributes.cheque_id#i#"))><!--- portfoyde veya kendi cekimiz ama db ye kayitli --->
					<cfquery name="UPD_CHEQUES" datasource="#dsn2#">
						UPDATE
							CHEQUE
						SET
						<cfif evaluate("attributes.cheque_status_id#i#") eq 1>
							CHEQUE_STATUS_ID=4
						<cfelseif evaluate("attributes.cheque_status_id#i#") eq 6 and len(evaluate("attributes.cheque_id#i#"))>
							COMPANY_ID = <cfif attributes.member_type eq "partner" and len(attributes.company_id)>#attributes.company_id#<cfelse>NULL</cfif>,
							CONSUMER_ID = <cfif attributes.member_type eq "consumer" and len(attributes.consumer_id)>#attributes.consumer_id#<cfelse>NULL</cfif>,
							EMPLOYEE_ID = <cfif attributes.member_type eq "employee" and len(attributes.employee_id)>#attributes.employee_id#<cfelse>NULL</cfif>,
							CHEQUE_PAYROLL_ID = #p_id#,
							OTHER_MONEY_VALUE=<cfif len(evaluate("attributes.cheque_system_currency_value#i#"))>#evaluate("attributes.cheque_system_currency_value#i#")#<cfelse>NULL</cfif>,
							OTHER_MONEY=<cfif len(evaluate("attributes.system_money_info#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.system_money_info#i#")#'><cfelse>NULL</cfif>,
							OTHER_MONEY_VALUE2=<cfif len(evaluate("attributes.other_money_value2#i#"))>#evaluate("attributes.other_money_value2#i#")#<cfelse>NULL</cfif>,
							OTHER_MONEY2=<cfif len(evaluate("attributes.other_money2#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.other_money2#i#")#'><cfelse>NULL</cfif>,
							RECORD_DATE = #now()#
						</cfif>
						WHERE
							CHEQUE_ID= #evaluate("attributes.cheque_id#i#")#
					</cfquery>
					<cfif evaluate("attributes.cheque_status_id#i#") eq 6 and len(evaluate("attributes.cheque_id#i#"))>
						<cfquery name="del_cheque_money" datasource="#dsn2#">
							DELETE FROM CHEQUE_MONEY WHERE ACTION_ID = #evaluate("attributes.cheque_id#i#")#
						</cfquery>
						<cfif len(evaluate("attributes.money_list#i#"))>
							<cfloop from="1" to="#ListGetAt(evaluate("attributes.money_list#i#"),1,'-')#" index="j">
								<cfset money = ListGetAt(evaluate("attributes.money_list#i#"),j+1,'-')>
								<cfquery name="ADD_MONEY_INFO" datasource="#dsn2#">
									INSERT INTO CHEQUE_MONEY 
									(
										ACTION_ID,
										MONEY_TYPE,
										RATE2,
										RATE1,
										IS_SELECTED
									)
									VALUES
									(
										#evaluate("attributes.cheque_id#i#")#,
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
					<cf_date tarih='attributes.cheque_duedate#i#'>
					<cfquery name="ADD_SELF_CHEQUES" datasource="#dsn2#">
						INSERT INTO
							CHEQUE
						(
							CHEQUE_PAYROLL_ID,
							COMPANY_ID,
							CONSUMER_ID,
							EMPLOYEE_ID,
							CHEQUE_CODE,
							CHEQUE_DUEDATE,
							CHEQUE_NO,
							CHEQUE_VALUE,
							OTHER_MONEY_VALUE,
							OTHER_MONEY,
							OTHER_MONEY_VALUE2,
							OTHER_MONEY2,
							CHEQUE_STATUS_ID,
							BANK_NAME,
							BANK_BRANCH_NAME,
							ACCOUNT_ID,
							ACCOUNT_NO,
							CHEQUE_CITY,
							CHEQUE_PURSE_NO,
							CURRENCY_ID,
							DEBTOR_NAME,
							RECORD_EMP,
							RECORD_IP,
							RECORD_DATE,
							CH_OTHER_MONEY_VALUE,
							CH_OTHER_MONEY,
							ENTRY_DATE		
						)
						VALUES
						(
							#p_id#,
							<cfif attributes.member_type eq "partner" and len(attributes.company_id)>#attributes.company_id#<cfelse>NULL</cfif>,
							<cfif attributes.member_type eq "consumer" and len(attributes.consumer_id)>#attributes.consumer_id#<cfelse>NULL</cfif>,
							<cfif attributes.member_type eq "employee" and len(attributes.employee_id)>#attributes.employee_id#<cfelse>NULL</cfif>,
							<cfif len(evaluate("attributes.cheque_code#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.cheque_code#i#")#'><cfelse>NULL</cfif>,
							#evaluate("attributes.cheque_duedate#i#")#,
							<cfif len(evaluate("attributes.cheque_no#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.cheque_no#i#")#'><cfelse>NULL</cfif>,
							#evaluate("attributes.cheque_value#i#")#,
							<cfif len(evaluate("attributes.cheque_system_currency_value#i#"))>#evaluate("attributes.cheque_system_currency_value#i#")#<cfelse>NULL</cfif>,
							<cfif len(evaluate("attributes.system_money_info#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.system_money_info#i#")#'><cfelse>NULL</cfif>,
							<cfif len(evaluate("attributes.other_money_value2#i#"))>#evaluate("attributes.other_money_value2#i#")#<cfelse>NULL</cfif>,
							<cfif len(evaluate("attributes.other_money2#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.other_money2#i#")#'>,<cfelse>NULL,</cfif>
							6,
							<cfif len(evaluate("attributes.bank_name#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.bank_name#i#")#'><cfelse>NULL</cfif>,
							<cfif len(evaluate("attributes.bank_branch_name#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.bank_branch_name#i#")#'><cfelse>NULL</cfif>,
							<cfif len(evaluate("attributes.account_id#i#"))>#wrk_eval("attributes.account_id#i#")#<cfelse>NULL</cfif>,
							<cfif len(evaluate("attributes.account_no#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.account_no#i#")#'><cfelse>NULL</cfif>,
							<cfif len(evaluate("attributes.cheque_city#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.cheque_city#i#")#'><cfelse>NULL</cfif>,
							<cfqueryparam cfsqltype="cf_sql_varchar" value='#portfoy_no#'>,
							<cfif len(evaluate("attributes.currency_id#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.currency_id#i#")#'><cfelse>NULL</cfif>,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.company#">,
							#session.ep.userid#,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
							#now()#	,
							#wrk_round((evaluate("attributes.cheque_system_currency_value#i#")/attributes.basket_money_rate),4)#,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.basket_money#">,
							#attributes.PAYROLL_REVENUE_DATE#				
						)
					</cfquery>
					<cfquery name="GET_LAST_ID" datasource="#dsn2#">
						SELECT MAX(CHEQUE_ID) AS CHEQUE_ID FROM CHEQUE
					</cfquery>
					<cfif len(evaluate("attributes.money_list#i#"))>
						<cfloop from="1" to="#ListGetAt(evaluate("attributes.money_list#i#"),1,'-')#" index="j">
							<cfset money = ListGetAt(evaluate("attributes.money_list#i#"),j+1,'-')>
							<cfquery name="ADD_MONEY_INFO" datasource="#dsn2#">
								INSERT INTO CHEQUE_MONEY 
								(
									ACTION_ID,
									MONEY_TYPE,
									RATE2,
									RATE1,
									IS_SELECTED
								)
								VALUES
								(
									#GET_LAST_ID.CHEQUE_ID#,
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#ListGetAt(money,1,',')#">,
									#ListGetAt(money,3,',')#,					
									#ListGetAt(money,2,',')#,
									<cfif ListGetAt(money,1,',') is evaluate("attributes.currency_id#i#")>1<cfelse>0</cfif>
								)
							</cfquery>
						</cfloop>
					</cfif> 
					<cfset portfoy_no = portfoy_no+1>
				</cfif>
			<!-- durumu deðiþen çek bilgileri cheque_history tablosuna kaydedilecek--->
			<!--- Bordroya girilen çekler için cheque_history tablosuna giriþ yapýlýyor...--->
			<cfquery name="ADD_CHEQUE_HISTORY" datasource="#dsn2#">
				INSERT INTO
					CHEQUE_HISTORY
				(
					CHEQUE_ID,
					PAYROLL_ID,
				<cfif evaluate("attributes.cheque_status_id#i#") eq 6>
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
				<cfif len(evaluate("attributes.cheque_id#i#"))>#evaluate("attributes.cheque_id#i#")#<cfelse>#GET_LAST_ID.CHEQUE_ID#</cfif>,
					#p_id#,
				<cfif evaluate("attributes.cheque_status_id#i#") eq 6>
					<cfif attributes.member_type eq "partner" and len(attributes.company_id)>#attributes.company_id#<cfelse>NULL</cfif>,
					<cfif attributes.member_type eq "consumer" and len(attributes.consumer_id)>#attributes.consumer_id#<cfelse>NULL</cfif>,
					<cfif attributes.member_type eq "employee" and len(attributes.employee_id)>#attributes.employee_id#<cfelse>NULL</cfif>,
				</cfif>
				<cfif evaluate("attributes.cheque_status_id#i#") eq 1>4<cfelse>6</cfif>,
					#attributes.PAYROLL_REVENUE_DATE#,
				<cfif len(evaluate("attributes.cheque_system_currency_value#i#"))>#evaluate("attributes.cheque_system_currency_value#i#")#<cfelse>NULL</cfif>,
				<cfif len(evaluate("attributes.system_money_info#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.system_money_info#i#")#'><cfelse>NULL</cfif>,
				<cfif len(evaluate("attributes.other_money_value2#i#"))>#evaluate("attributes.other_money_value2#i#")#<cfelse>NULL</cfif>,
				<cfif len(evaluate("attributes.other_money2#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.other_money2#i#")#'><cfelse>NULL</cfif>,
					#now()#
				)
			</cfquery>
			</cfif>
		</cfloop>
		<cfset portfoy_no = get_cheque_no(belge_tipi:'cheque',belge_no:portfoy_no)>
        <!--- add cari --->
        <cfquery name="GET_CHEQUES_LAST" datasource="#dsn2#">
            SELECT 
                CHEQUE.*,
                CHEQUE_HISTORY.OTHER_MONEY_VALUE OTHER_MONEY_VALUE_LAST
            FROM
                CHEQUE, 
                CHEQUE_HISTORY 
            WHERE
                CHEQUE.CHEQUE_ID=CHEQUE_HISTORY.CHEQUE_ID
                AND PAYROLL_ID=#p_id#
        </cfquery>
        <cfset cheq_no_list=valuelist(GET_CHEQUES_LAST.CHEQUE_NO)>
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
							if(evaluate("attributes.currency_id#cheq_i#") is not session.ep.money)
							{
								other_money = evaluate("attributes.currency_id#cheq_i#"); //cek currency id 
								other_money_value = evaluate("attributes.cheque_value#cheq_i#"); //cek value
							}
							else if(len(attributes.basket_money) and len(attributes.basket_money_rate))
							{
								other_money = attributes.basket_money;
								other_money_value = wrk_round(evaluate("attributes.cheque_system_currency_value#cheq_i#")/attributes.basket_money_rate);
							}
							else if(len(evaluate("attributes.other_money_value2#cheq_i#")) and len(evaluate("attributes.other_money2#cheq_i#")) )
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
								action_id :iif(len(evaluate("attributes.cheque_id#cheq_i#")),'evaluate("attributes.cheque_id#cheq_i#")','GET_CHEQUES_LAST.CHEQUE_ID[listfind(cheq_no_list,evaluate("attributes.cheque_no#cheq_i#"))]'),
								action_table :'CHEQUE',
								process_cat :form.process_cat,
								workcube_process_type :process_type,
								account_card_type :13,
								islem_tarihi : attributes.PAYROLL_REVENUE_DATE,
								islem_tutari : evaluate("attributes.cheque_system_currency_value#cheq_i#"),
								other_money_value : other_money_value,
								other_money : other_money,
								islem_belge_no :evaluate("attributes.cheque_no#cheq_i#"),
								due_date : iif(len(GET_CHEQUES_LAST.CHEQUE_DUEDATE[listfind(cheq_no_list,evaluate("attributes.cheque_no#cheq_i#"))]),'createodbcdatetime(GET_CHEQUES_LAST.CHEQUE_DUEDATE[listfind(cheq_no_list,evaluate("attributes.cheque_no#cheq_i#"))])','attributes.pyrll_avg_duedate'),
								to_cmp_id : iif(attributes.member_type eq "partner",'attributes.company_id',de('')),
								to_consumer_id : iif(attributes.member_type eq "consumer",'attributes.consumer_id',de('')),
								to_employee_id : iif(attributes.member_type eq "employee",'attributes.employee_id',de('')),
								payer_id :attributes.pro_employee_id,
								islem_detay : 'ÇEK ÇIKIŞ BORDROSU(CİRO-Çek Bazında)',
								acc_type_id : attributes.acc_type_id,
								action_detail : attributes.action_detail,
								currency_multiplier : currency_multiplier,
								project_id : attributes.project_id,
								from_branch_id : branch_id_info,
								payroll_id :p_id,
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
						action_id :p_id,
						workcube_process_type :process_type,		
						process_cat : form.process_cat,
						account_card_type :13,
						action_table :'PAYROLL',
						islem_tarihi :attributes.PAYROLL_REVENUE_DATE,
						islem_tutari :attributes.payroll_total,
						other_money_value : iif(len(attributes.other_payroll_total),'attributes.other_payroll_total',de('')),
						other_money :iif(len(attributes.basket_money),'attributes.basket_money',de('')),
						action_currency : session.ep.money,
						payer_id :attributes.pro_employee_id,
						islem_belge_no : attributes.payroll_no,
						due_date : attributes.pyrll_avg_duedate,
						to_cmp_id : iif(attributes.member_type eq "partner",'attributes.company_id',de('')),
						to_consumer_id : iif(attributes.member_type eq "consumer",'attributes.consumer_id',de('')),
						to_employee_id : iif(attributes.member_type eq "employee",'attributes.employee_id',de('')),
						currency_multiplier : currency_multiplier,
						islem_detay : 'ÇEK ÇIKIŞ BORDROSU(CİRO)',
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
			if(is_account eq 1)//add_accound_card
			{
				if(is_cheque_based_acc neq 1)	/*standart muhasebe islemleri yapılıyor*/
				{
					alacak_tutarlar = '';
					alacak_hesaplar = '';
					other_currency_alacak_list= '';
					other_amount_alacak_list= '';
					satir_detay_list = ArrayNew(2);
					for(i=1; i lte attributes.record_num; i=i+1)
					{
						if (evaluate("attributes.row_kontrol#i#"))
						{
							if (evaluate("attributes.currency_id#i#") eq session.ep.money)
								alacak_tutarlar=listappend(alacak_tutarlar,evaluate("attributes.cheque_value#i#"),',');
							else
								alacak_tutarlar=listappend(alacak_tutarlar,evaluate("attributes.cheque_system_currency_value#i#"),',');
		
							other_currency_alacak_list = listappend(other_currency_alacak_list,evaluate("attributes.currency_id#i#"),',');
							other_amount_alacak_list =  listappend(other_amount_alacak_list,evaluate("attributes.cheque_value#i#"),',');
							if(evaluate("attributes.cheque_status_id#i#") eq 1)
							{//cek girisle , acilisla  veya cek iade giris banka ile portfoyde asamasına gelmis cek
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
									CH.CHEQUE_ID=#evaluate("attributes.cheque_id#i#")#
								ORDER BY
									CH.HISTORY_ID DESC");
								if(GET_ACC_CODE.recordcount eq 0)
								{
									GET_ACC_CODE=cfquery(datasource:"#dsn2#", sqlstring:"
										SELECT
											C.A_CHEQUE_ACC_CODE
										FROM
											PAYROLL AS P,
											CHEQUE_HISTORY AS CH,
											CASH AS C
										WHERE
											P.PAYROLL_CASH_ID = C.CASH_ID AND
											P.PAYROLL_TYPE IN (90,105,106) AND 
											P.ACTION_ID= CH.PAYROLL_ID AND
											CH.CHEQUE_ID=#evaluate("attributes.cheque_id#i#")#
										ORDER BY
											CH.HISTORY_ID DESC");
								}
								alacak_hesaplar=listappend(alacak_hesaplar, GET_ACC_CODE.A_CHEQUE_ACC_CODE, ',');
							}
							else if(evaluate("attributes.cheque_status_id#i#") eq 6)
							{
								GET_V_ACC_CODE=cfquery(datasource:"#dsn2#", sqlstring:"
									SELECT 
										V_CHEQUE_ACC_CODE
									FROM
										#dsn3_alias#.ACCOUNTS AS ACCOUNTS
									WHERE
										ACCOUNT_ID=#evaluate("attributes.account_id#i#")#");
								alacak_hesaplar=listappend(alacak_hesaplar ,GET_V_ACC_CODE.V_CHEQUE_ACC_CODE, ',');
							}
							if (is_account_group neq 1)
							{
								if(attributes.x_detail_acc_card neq 1) //detaylı muhasebe seçilmişse çek bilgilerini yazıyoruz
									satir_detay_list[2][listlen(alacak_tutarlar)]='Ç.Ç.B.:#attributes.payroll_no#:#evaluate("attributes.bank_name#i#")#:#evaluate("attributes.bank_branch_name#i#")#:#evaluate("attributes.account_no#i#")#'; //satır acıklamaları borc acıklama aray e set edilir.
								else if(isDefined("attributes.action_detail") and len(attributes.action_detail))
									satir_detay_list[2][listlen(alacak_tutarlar)] = ' #evaluate("attributes.cheque_no#i#")# - #attributes.company_name# - #attributes.action_detail#';
								else
									satir_detay_list[2][listlen(alacak_tutarlar)] = ' #evaluate("attributes.cheque_no#i#")# - #attributes.company_name# - ' & UCase(getLang('main',2737));
							}
							else
							{
								if(attributes.x_detail_acc_card neq 1) //detaylı muhasebe seçilmişse çek bilgilerini yazıyoruz
									satir_detay_list[2][listlen(alacak_tutarlar)]='Ç.Ç.B.:#attributes.payroll_no#:#evaluate("attributes.bank_name#i#")#:#evaluate("attributes.bank_branch_name#i#")#:#evaluate("attributes.account_no#i#")#'; //satır acıklamaları borc acıklama aray e set edilir.
								else if(isDefined("attributes.action_detail") and len(attributes.action_detail))
									satir_detay_list[2][listlen(alacak_tutarlar)] = ' #attributes.company_name# - #attributes.action_detail#';
								else
									satir_detay_list[2][listlen(alacak_tutarlar)] = ' #attributes.company_name# - ' & UCase(getLang('main',2737));
							}
						}
					}
					if(isDefined("attributes.action_detail") and len(attributes.action_detail))
						satir_detay_list[1][1] = ' #attributes.company_name# - #attributes.action_detail#';
					else
						satir_detay_list[1][1] = ' #attributes.company_name# - ' & UCase(getLang('main',2737));
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
						other_currency_borc : iif(len(attributes.basket_money),'attributes.basket_money',de('')),
						alacak_hesaplar: alacak_hesaplar,
						alacak_tutarlar: alacak_tutarlar,
						other_amount_alacak : other_amount_alacak_list,
						other_currency_alacak :other_currency_alacak_list,
						fis_detay : UCase(getLang('main',2737)),
						fis_satir_detay : satir_detay_list,
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
					alacak_hesap = '';
					alacak_tutar = '';
					satir_detay_list = ArrayNew(2);
					for(i=1; i lte get_cheques_last.recordcount; i=i+1)
					{
						if(get_cheques_last.CURRENCY_ID[i] neq session.ep.money)
							alacak_tutar = get_cheques_last.OTHER_MONEY_VALUE_LAST[i];
						else
							alacak_tutar = get_cheques_last.CHEQUE_VALUE[i];

						if(listfind('1,4',get_cheques_last.CHEQUE_STATUS_ID[i]))
						{//cek girisle , acilisla  veya cek iade giris banka ile portfoyde asamasına gelmis cek
							GET_ACC_CODE=cfquery(datasource:"#dsn2#",sqlstring:"SELECT
								C.A_CHEQUE_ACC_CODE
							FROM
								PAYROLL AS P,
								CHEQUE_HISTORY AS CH,
								CASH AS C
							WHERE
								P.TRANSFER_CASH_ID = C.CASH_ID AND
								P.PAYROLL_TYPE IN (135) AND
								P.ACTION_ID = CH.PAYROLL_ID AND
								CH.CHEQUE_ID = #get_cheques_last.CHEQUE_ID[i]# 
							ORDER BY
								CH.HISTORY_ID DESC");
							if(GET_ACC_CODE.recordcount eq 0)
							{
								GET_ACC_CODE=cfquery(datasource:"#dsn2#", sqlstring:"
									SELECT
										C.A_CHEQUE_ACC_CODE
									FROM
										PAYROLL AS P,
										CHEQUE_HISTORY AS CH,
										CASH AS C
									WHERE
										P.PAYROLL_CASH_ID = C.CASH_ID AND
										P.PAYROLL_TYPE IN (90,105,106) AND 
										P.ACTION_ID = CH.PAYROLL_ID AND
										CH.CHEQUE_ID = #get_cheques_last.CHEQUE_ID[i]# 
									ORDER BY
										CH.HISTORY_ID DESC");
							}
							alacak_hesap = GET_ACC_CODE.A_CHEQUE_ACC_CODE;
						}
						else if(get_cheques_last.CHEQUE_STATUS_ID[i] eq 6)
						{
							GET_V_ACC_CODE=cfquery(datasource:"#dsn2#", sqlstring:"
								SELECT 
									V_CHEQUE_ACC_CODE
								FROM
									#dsn3_alias#.ACCOUNTS AS ACCOUNTS
								WHERE
									ACCOUNT_ID = #get_cheques_last.ACCOUNT_ID[i]#");
							alacak_hesap = GET_V_ACC_CODE.V_CHEQUE_ACC_CODE;
						}
						if (is_account_group neq 1)
						{
							if(isDefined("attributes.action_detail") and len(attributes.action_detail))
								satir_detay_list[2][1] = ' #get_cheques_last.cheque_no[i]# - #attributes.company_name# - #attributes.action_detail#';
							else
								satir_detay_list[2][1] = ' #get_cheques_last.cheque_no[i]# - #attributes.company_name# - ' & UCase(getLang('main',2737));
						}
						else
						{
							if(isDefined("attributes.action_detail") and len(attributes.action_detail))
								satir_detay_list[2][1] = ' #attributes.company_name# - #attributes.action_detail#';
							else
								satir_detay_list[2][1] = ' #attributes.company_name# - ' & UCase(getLang('main',2737));
						}
						if(isDefined("attributes.action_detail") and len(attributes.action_detail))
							satir_detay_list[1][1] = ' #attributes.company_name# - #attributes.action_detail#';
						else
							satir_detay_list[1][1] = ' #attributes.company_name# - ' & UCase(getLang('main',2737));
							
						muhasebeci (
							action_id:p_id,
							action_row_id : get_cheques_last.CHEQUE_ID[i],
							due_date :iif(len(get_cheques_last.CHEQUE_DUEDATE[i]),'createodbcdatetime(get_cheques_last.CHEQUE_DUEDATE[i])','attributes.pyrll_avg_duedate'),
							workcube_process_type:process_type,
							account_card_type:13,
							action_table :'PAYROLL',
							islem_tarihi : attributes.PAYROLL_REVENUE_DATE,
							company_id : iif(attributes.member_type eq "partner",'attributes.company_id',de('')),
							consumer_id : iif(attributes.member_type eq "consumer",'attributes.consumer_id',de('')),
							employee_id : iif(attributes.member_type eq "employee",'attributes.employee_id',de('')),
							borc_hesaplar: acc,
							borc_tutarlar: alacak_tutar,
							other_amount_borc : get_cheques_last.OTHER_MONEY_VALUE_LAST[i]/paper_currency_multiplier,
							other_currency_borc : iif(len(attributes.basket_money),'attributes.basket_money',de('')),
							alacak_hesaplar: alacak_hesap,
							alacak_tutarlar: alacak_tutar,
							other_amount_alacak : get_cheques_last.CHEQUE_VALUE[i],
							other_currency_alacak : get_cheques_last.CURRENCY_ID[i],
							fis_detay : UCase(getLang('main',2737)),
							fis_satir_detay : satir_detay_list,
							currency_multiplier : currency_multiplier,
							belge_no : get_cheques_last.CHEQUE_NO[i],
							from_branch_id : branch_id_info,
							workcube_process_cat : form.process_cat,
							acc_project_id : attributes.project_id,
							is_account_group : is_account_group
						);		
					}
				}
			}
			basket_kur_ekle(action_id:GET_BORDRO_ID.P_ID,table_type_id:11,process_type:0);
		</cfscript>
		<!--- Ödeme emrinden eklenmişse kontroller yapılıyor --->
		<cfif isdefined("attributes.order_id") and len(attributes.order_id) and is_cari and isdefined("attributes.order_row_id") and len(attributes.order_row_id)>
			<cfif is_cheque_based eq 1>
				<cfquery name="GET_CARI_INFO" datasource="#dsn2#">
					SELECT * FROM CARI_ROWS WHERE ACTION_ID = #GET_CHEQUES_LAST.CHEQUE_ID# AND ACTION_TYPE_ID = #process_type# AND ACTION_TABLE='CHEQUE'
				</cfquery>
			<cfelse>
				<cfquery name="GET_CARI_INFO" datasource="#dsn2#">
					SELECT * FROM CARI_ROWS WHERE ACTION_ID = #GET_BORDRO_ID.P_ID# AND ACTION_TYPE_ID = #process_type# AND ACTION_TABLE = <cfqueryparam cfsqltype="cf_sql_varchar" value="PAYROLL">
				</cfquery>
			</cfif>
			<cfif len(GET_CARI_INFO.recordcount) and (isDefined("attributes.correspondence_info") and len(attributes.correspondence_info))>
				<cfquery name="GET_CLOSED" datasource="#dsn2#">
					SELECT P_ORDER_DEBT_AMOUNT_VALUE,P_ORDER_CLAIM_AMOUNT_VALUE FROM CARI_CLOSED WHERE CLOSED_ID = #attributes.order_id#
				</cfquery>
				<cfquery name="UPD_CLOSED" datasource="#dsn2#">
					UPDATE
						CARI_CLOSED
					SET
						IS_CLOSED = 1,
						<cfif GET_CLOSED.P_ORDER_DEBT_AMOUNT_VALUE neq 0>
							DEBT_AMOUNT_VALUE = P_ORDER_DEBT_AMOUNT_VALUE,
							CLAIM_AMOUNT_VALUE = P_ORDER_DEBT_AMOUNT_VALUE,
						<cfelse>
							DEBT_AMOUNT_VALUE = P_ORDER_CLAIM_AMOUNT_VALUE,
							CLAIM_AMOUNT_VALUE = P_ORDER_CLAIM_AMOUNT_VALUE,
						</cfif>
						DIFFERENCE_AMOUNT_VALUE = 0
					WHERE
						CLOSED_ID = #attributes.order_id#
				</cfquery>
				<cfquery name="UPD_CLOSED" datasource="#dsn2#">
					UPDATE
						CARI_CLOSED_ROW
					SET
						RELATED_CLOSED_ROW_ID = 0,
						RELATED_CARI_ACTION_ID = #GET_CARI_INFO.CARI_ACTION_ID#,
						CLOSED_AMOUNT = P_ORDER_VALUE,
						OTHER_CLOSED_AMOUNT = OTHER_P_ORDER_VALUE
					WHERE
						CLOSED_ID = #attributes.order_id#
				</cfquery>
			<cfelseif len(GET_CARI_INFO.recordcount)>
				<cfquery name="UPD_CLOSED" datasource="#dsn2#">
					INSERT INTO
						CARI_CLOSED_ROW
					(
						CLOSED_ID,
						CARI_ACTION_ID,
						ACTION_ID,
						ACTION_TYPE_ID,
						ACTION_VALUE,
						CLOSED_AMOUNT,
						OTHER_CLOSED_AMOUNT,
						P_ORDER_VALUE,
						OTHER_P_ORDER_VALUE,							
						OTHER_MONEY,
						DUE_DATE
					)
					VALUES
					(
						#attributes.order_id#,
						#GET_CARI_INFO.CARI_ACTION_ID#,
						#GET_CARI_INFO.ACTION_ID#,
						#process_type#,
						#GET_CARI_INFO.ACTION_VALUE#,
						#GET_CARI_INFO.ACTION_VALUE#,
						#GET_CARI_INFO.OTHER_CASH_ACT_VALUE#,
						#GET_CARI_INFO.ACTION_VALUE#,
						#GET_CARI_INFO.OTHER_CASH_ACT_VALUE#,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CARI_INFO.OTHER_MONEY#">,
						#createodbcdatetime(GET_CARI_INFO.DUE_DATE)#
					)
				</cfquery>
				<cfif isdefined("attributes.order_row_id") and len(attributes.order_row_id)>
					<cfquery name="GET_MAX_C_ID" datasource="#DSN2#">
						SELECT MAX(CLOSED_ROW_ID) C_MAX_ID FROM CARI_CLOSED_ROW
					</cfquery>
					<cfquery name="GET_CLOSED" datasource="#dsn2#">
						SELECT P_ORDER_DEBT_AMOUNT_VALUE,P_ORDER_CLAIM_AMOUNT_VALUE FROM CARI_CLOSED WHERE CLOSED_ID = #attributes.order_id#
					</cfquery>
					<cfquery name="UPD_CLOSED" datasource="#dsn2#">
						UPDATE
							CARI_CLOSED
						SET
							IS_CLOSED = 1,
							<cfif GET_CLOSED.P_ORDER_DEBT_AMOUNT_VALUE neq 0>
								DEBT_AMOUNT_VALUE = P_ORDER_DEBT_AMOUNT_VALUE,
								CLAIM_AMOUNT_VALUE = P_ORDER_DEBT_AMOUNT_VALUE,
							<cfelse>
								DEBT_AMOUNT_VALUE = P_ORDER_CLAIM_AMOUNT_VALUE,
								CLAIM_AMOUNT_VALUE = P_ORDER_CLAIM_AMOUNT_VALUE,
							</cfif>
							DIFFERENCE_AMOUNT_VALUE = 0
						WHERE
							CLOSED_ID = #attributes.order_id#
					</cfquery>
					<cfquery name="UPD_CLOSED" datasource="#dsn2#">
						UPDATE
							CARI_CLOSED_ROW
						SET
							RELATED_CLOSED_ROW_ID = #GET_MAX_C_ID.C_MAX_ID#,
							CLOSED_AMOUNT = P_ORDER_VALUE,
							OTHER_CLOSED_AMOUNT = OTHER_P_ORDER_VALUE
						WHERE
							CLOSED_ROW_ID IN (#attributes.order_row_id#) AND
							CLOSED_ID = #attributes.order_id#
					</cfquery>
				</cfif>
			</cfif>
		</cfif>
		<cf_workcube_process_cat 
			process_cat="#form.process_cat#"
			action_id = #p_id#
			is_action_file = 1
			action_db_type = '#dsn2#'
			action_page='#request.self#?fuseaction=cheque.form_add_payroll_endorsement&event=upd&IDs=#p_id#'
			action_file_name='#get_process_type.action_file_name#'
			is_template_action_file = '#get_process_type.action_file_from_template#'>
    <cf_add_log log_type="1" action_id="#p_id#" action_name="#attributes.payroll_no# Eklendi" paper_no="#attributes.payroll_no#" period_id="#session.ep.period_id#" process_type="#get_process_type.PROCESS_TYPE#" data_source="#dsn2#">
	</cftransaction>
</cflock>
<cfif isdefined("attributes.order_id") and len(attributes.order_id)>
	<script type="text/javascript">
		wrk_opener_reload();
		window.close();
	</script>
<cfelse>
	<script type="text/javascript">
		<cfif session.ep.our_company_info.is_paper_closer eq 1 and (len(attributes.company_id) or len(attributes.consumer_id) or len(attributes.employee_id))>
			window.open('<cfoutput>#request.self#?fuseaction=finance.list_payment_actions&event=add&act_type=1&member_id=#attributes.company_id#&consumer_id=#attributes.consumer_id#&employee_id_new=#attributes.employee_id#&acc_type_id=#attributes.acc_type_id#&money_type=#attributes.basket_money#&row_action_id=#p_id#&row_action_type=#process_type#</cfoutput>','page');
		</cfif>	
		window.location.href="<cfoutput>#request.self#?fuseaction=cheque.form_add_payroll_endorsement&event=upd&ID=#p_id#</cfoutput>";
	</script>
</cfif>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
