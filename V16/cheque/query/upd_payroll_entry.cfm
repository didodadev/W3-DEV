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
		IS_UPD_CARI_ROW,
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
	is_upd_cari_row = get_process_type.IS_UPD_CARI_ROW;
	is_account_type_id = get_process_type.ACCOUNT_TYPE_ID;
	currency_multiplier = '';//sistem ikinci para biriminin kurunu sayfadan alıyor, muhasebeci ve carici de kullanılıyor
	attributes.payroll_total = filterNum(attributes.payroll_total);
	attributes.other_payroll_total = filterNum(attributes.other_payroll_total);
	paper_currency_multiplier = '';
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
		if(evaluate("attributes.hidden_rd_money_#rt#") is session.ep.money2)
			currency_multiplier = evaluate('attributes.txt_rate2_#rt#/attributes.txt_rate1_#rt#');
		if(evaluate("attributes.hidden_rd_money_#rt#") is attributes.basket_money)
			paper_currency_multiplier = evaluate('attributes.txt_rate2_#rt#/attributes.txt_rate1_#rt#');
	}
	branch_id_info = listgetat(form.cash_id,2,';');
	if(listlen(attributes.employee_id,'_') eq 2)
	{
		attributes.acc_type_id = listlast(attributes.employee_id,'_');
		attributes.employee_id = listfirst(attributes.employee_id,'_');
	}
</cfscript>
<cfif not isdefined("attributes.acc_type_id")><cfset attributes.acc_type_id = len(is_account_type_id) ? is_account_type_id : ""></cfif>
<cfquery name="CONTROL_NO" datasource="#DSN2#">
	SELECT ACTION_ID FROM PAYROLL WHERE PAYROLL_NO = '#PAYROLL_NO#' AND ACTION_ID <> #attributes.id#
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
			alert("<cf_get_lang no='126.Seçtiğiniz Üyenin Muhasebe Kodu Seçilmemiş !'>");
			history.back();	
		</script>
		<cfabort>
	</cfif>
</cfif>
<cflock name="#createUUID()#" timeout="60">
	<cftransaction><!--- update payroll--->
		<cfquery name="UPD_PAYROLL" datasource="#dsn2#">
			UPDATE 
				PAYROLL
			SET
				PROCESS_CAT = #form.process_cat#,
				PAYROLL_TYPE = #process_type#,
                <cfif not attributes.del_flag>
                    COMPANY_ID = <cfif attributes.member_type eq "partner" and len(attributes.company_id)>#attributes.company_id#<cfelse>NULL</cfif>,
                    CONSUMER_ID = <cfif attributes.member_type eq "consumer" and len(attributes.consumer_id)>#attributes.consumer_id#<cfelse>NULL</cfif>,
                    EMPLOYEE_ID = <cfif attributes.member_type eq "employee" and len(attributes.employee_id)>#attributes.employee_id#<cfelse>NULL</cfif>,
					PAYROLL_CASH_ID = #listfirst(form.cash_id,';')#,
                </cfif>
				PAYROLL_AVG_DUEDATE = #attributes.pyrll_avg_duedate#,
				PAYROLL_TOTAL_VALUE = #attributes.payroll_total#,
				PAYROLL_OTHER_MONEY=<cfif isdefined("attributes.basket_money") and len(attributes.basket_money)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.basket_money#"><cfelse>NULL</cfif>,
				PAYROLL_OTHER_MONEY_VALUE=<cfif isdefined("attributes.other_payroll_total") and len(attributes.other_payroll_total)>#attributes.other_payroll_total#<cfelse>NULL</cfif>,
				PAYROLL_AVG_AGE=<cfif len(attributes.pyrll_avg_age)>#attributes.pyrll_avg_age#,<cfelse>NULL,</cfif>
				<cfif not attributes.del_flag>
                	PAYROLL_REVENUE_DATE=#attributes.PAYROLL_REVENUE_DATE#,
                </cfif>
				NUMBER_OF_CHEQUE=#attributes.cheque_num#,
				PROJECT_ID = <cfif len(attributes.project_name) and len(attributes.project_id)>#attributes.project_id#<cfelse>NULL</cfif>,
				PAYROLL_NO=<cfif len(attributes.PAYROLL_NO)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.PAYROLL_NO#">,<cfelse>NULL,</cfif>
				BRANCH_ID = #branch_id_info#,
				UPDATE_EMP=#session.ep.userid#,
				UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">,
				UPDATE_DATE = #NOW()#,
				REVENUE_COLLECTOR_ID=#attributes.REVENUE_COLLECTOR_ID#,
				CHEQUE_BASED_ACC_CARI = <cfif len(is_cheque_based)>#is_cheque_based#<cfelse>0</cfif>,
				ACTION_DETAIL = <cfif isDefined("attributes.action_detail") and len(attributes.action_detail)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.action_detail#"><cfelse>NULL</cfif>,
				SPECIAL_DEFINITION_ID = <cfif isdefined("attributes.special_definition_id") and len(attributes.special_definition_id)>#attributes.special_definition_id#<cfelse>NULL</cfif>,
				ASSETP_ID = <cfif isdefined("attributes.asset_id") and len(attributes.asset_id) and len(attributes.asset_name)>#attributes.asset_id#<cfelse>NULL</cfif>,
				CONTRACT_ID = <cfif isdefined("attributes.contract_id") and len(attributes.contract_id) and len(attributes.contract_head)>#attributes.contract_id#<cfelse>NULL</cfif>,
			    ACC_TYPE_ID = <cfif isdefined("attributes.acc_type_id") and len(attributes.acc_type_id)>#attributes.acc_type_id#<cfelse>NULL</cfif>
			WHERE
				ACTION_ID=#attributes.id#
		</cfquery>
		<!--- update cheque --->
		<cfquery name="GET_REL_CHEQUES" datasource="#dsn2#">
			SELECT CHEQUE_ID FROM CHEQUE_HISTORY WHERE PAYROLL_ID=#attributes.id#
		</cfquery>
		<cfset old_cheque_list = valuelist(get_rel_cheques.CHEQUE_ID, ',')>
		<cfset ches = valuelist(get_rel_cheques.CHEQUE_ID, ',')>
		<cfset ches_flag = valuelist(get_rel_cheques.CHEQUE_ID, ',')>
		<cfloop from="1" to="#attributes.record_num#" index="i">
			<cfif ListFindNoCase(ches,evaluate("attributes.cheque_id#i#"), ',') and evaluate("attributes.row_kontrol#i#")>
				<cfif evaluate("attributes.cheque_status_id#i#") eq 1>
					<cf_date tarih='attributes.cheque_duedate#i#'>
					<cfquery name="UPD_CHEQUE" datasource="#dsn2#">
						UPDATE
							CHEQUE
						SET
                        	<cfif not attributes.del_flag>
                                COMPANY_ID = <cfif attributes.member_type eq "partner" and len(attributes.company_id)>#attributes.company_id#<cfelse>NULL</cfif>,
                                CONSUMER_ID = <cfif attributes.member_type eq "consumer" and len(attributes.consumer_id)>#attributes.consumer_id#<cfelse>NULL</cfif>,
                                EMPLOYEE_ID = <cfif attributes.member_type eq "employee" and len(attributes.employee_id)>#attributes.employee_id#<cfelse>NULL</cfif>,
                                OWNER_COMPANY_ID = <cfif attributes.member_type eq "partner" and len(attributes.company_id)>#attributes.company_id#<cfelse>NULL</cfif>,
                                OWNER_CONSUMER_ID = <cfif attributes.member_type eq "consumer" and len(attributes.consumer_id)>#attributes.consumer_id#<cfelse>NULL</cfif>,
                                OWNER_EMPLOYEE_ID = <cfif attributes.member_type eq "employee" and len(attributes.employee_id)>#attributes.employee_id#<cfelse>NULL</cfif>,
                            </cfif>
							CHEQUE_DUEDATE = #evaluate("attributes.cheque_duedate#i#")#,
							CHEQUE_VALUE = #evaluate("attributes.cheque_value#i#")#,
							CURRENCY_ID = <cfif len(evaluate("attributes.currency_id#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.currency_id#i#")#'>,<cfelse>NULL,</cfif>
							DEBTOR_NAME = <cfif len(evaluate("attributes.debtor_name#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.debtor_name#i#")#'>,<cfelse>NULL,</cfif>
							BANK_NAME = <cfif len(evaluate("attributes.bank_name#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.bank_name#i#")#'>,<cfelse>NULL,</cfif>
							BANK_BRANCH_NAME = <cfif len(evaluate("attributes.bank_branch_name#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.bank_branch_name#i#")#'>,<cfelse>NULL,</cfif>
							TAX_NO = <cfif len(evaluate("attributes.tax_no#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.tax_no#i#")#'>,<cfelse>NULL,</cfif>
							TAX_PLACE = <cfif len(evaluate("attributes.tax_place#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.tax_place#i#")#'>,<cfelse>NULL,</cfif>
							ACCOUNT_ID = <cfif len(evaluate("attributes.account_id#i#"))>#wrk_eval("attributes.account_id#i#")#,<cfelse>NULL,</cfif>
							ACCOUNT_NO = <cfif len(evaluate("attributes.account_no#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.account_no#i#")#'>,<cfelse>NULL,</cfif>
							CHEQUE_NO = <cfif len(evaluate("attributes.cheque_no#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.cheque_no#i#")#'>,<cfelse>NULL,</cfif>
							CHEQUE_PURSE_NO = <cfif len(evaluate("attributes.portfoy_no#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.portfoy_no#i#")#'>,<cfelse>NULL,</cfif>
							CHEQUE_CITY = <cfif len(evaluate("attributes.cheque_city#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.cheque_city#i#")#'>,<cfelse>NULL,</cfif>
							SELF_CHEQUE = <cfif len(evaluate("attributes.from_cheque_info#i#"))>#evaluate("attributes.from_cheque_info#i#")#,<cfelse>NULL,</cfif>
							OTHER_MONEY_VALUE = <cfif len(evaluate("attributes.cheque_system_currency_value#i#"))>#evaluate("attributes.cheque_system_currency_value#i#")#,<cfelse>NULL,</cfif>
							OTHER_MONEY = <cfif len(evaluate("attributes.system_money_info#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.system_money_info#i#")#'>,<cfelse>NULL,</cfif>
							OTHER_MONEY_VALUE2 = <cfif len(evaluate("attributes.other_money_value2#i#"))>#evaluate("attributes.other_money_value2#i#")#,<cfelse>NULL,</cfif>
							OTHER_MONEY2 = <cfif len(evaluate("attributes.other_money2#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.other_money2#i#")#'>,<cfelse>NULL,</cfif>
							ENDORSEMENT_MEMBER = <cfif len(evaluate("attributes.endorsement_member#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.endorsement_member#i#")#'>,<cfelse>NULL,</cfif>
							<cfif not attributes.del_flag>
                            	CASH_ID = #listfirst(form.cash_id,';')#,
                            </cfif>
							CHEQUE_CODE = <cfif len(evaluate("attributes.cheque_code#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.cheque_code#i#")#'><cfelse>NULL</cfif>,
							CH_OTHER_MONEY_VALUE=#wrk_round((evaluate("attributes.cheque_system_currency_value#i#")/attributes.basket_money_rate),4)#,
							CH_OTHER_MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value='#attributes.basket_money#'>
						WHERE
							CHEQUE_ID = #evaluate("attributes.cheque_id#i#")#
					</cfquery>
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
					<cfquery name="UPD_CHEQUE_HISTORY" datasource="#dsn2#">
						UPDATE 
							CHEQUE_HISTORY
						SET
                        	<cfif not attributes.del_flag>
								ACT_DATE = #attributes.PAYROLL_REVENUE_DATE#,
                            </cfif>
							OTHER_MONEY_VALUE = <cfif len(evaluate("attributes.cheque_system_currency_value#i#"))>#evaluate("attributes.cheque_system_currency_value#i#")#,<cfelse>NULL,</cfif>
							OTHER_MONEY = <cfif len(evaluate("attributes.system_money_info#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.system_money_info#i#")#'>,<cfelse>NULL,</cfif>
							OTHER_MONEY_VALUE2 = <cfif len(evaluate("attributes.other_money_value2#i#"))>#evaluate("attributes.other_money_value2#i#")#,<cfelse>NULL,</cfif>
							OTHER_MONEY2 = <cfif len(evaluate("attributes.other_money2#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.other_money2#i#")#'>,<cfelse>NULL,</cfif>
							SELF_CHEQUE = <cfif len(evaluate("attributes.from_cheque_info#i#"))>#evaluate("attributes.from_cheque_info#i#")#<cfelse>NULL</cfif>
						WHERE
							CHEQUE_ID = #evaluate("attributes.cheque_id#i#")#
                            AND STATUS = 1
					</cfquery>
				<cfelse>
					<cfquery name="UPD_CHEQUE" datasource="#dsn2#">
						UPDATE
							CHEQUE
						SET
							CH_OTHER_MONEY_VALUE=#wrk_round((evaluate("attributes.cheque_system_currency_value#i#")/attributes.basket_money_rate),4)#,
							CH_OTHER_MONEY=<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.basket_money#">
						WHERE
							CHEQUE_ID = #evaluate("attributes.cheque_id#i#")#
					</cfquery>
					<cfquery name="UPD_CHEQUE_HISTORY" datasource="#dsn2#">
						UPDATE 
							CHEQUE_HISTORY
						SET
                        	<cfif not attributes.del_flag>
								ACT_DATE = #attributes.PAYROLL_REVENUE_DATE#,
                            </cfif>
							SELF_CHEQUE = <cfif len(evaluate("attributes.from_cheque_info#i#"))>#evaluate("attributes.from_cheque_info#i#")#<cfelse>NULL</cfif>
						WHERE
							CHEQUE_ID = #evaluate("attributes.cheque_id#i#")#
					</cfquery>
				</cfif>
				<cfset ches_flag = ListDeleteAt(ches_flag, ListFindNoCase(ches_flag,evaluate("attributes.cheque_id#i#"), ','), ',')>
			</cfif>
		</cfloop>
		<cfif len(ches_flag)> <!--- ches_flag listesinin kullanımına dikkat, muhasebeci ve caricide de bordrodan cıkarılan ceklerin hareketlerini silmek icin kullanılıyor --->
			<cfquery name="DEL_CHEQUE" datasource="#dsn2#">
				DELETE FROM CHEQUE WHERE CHEQUE_ID IN (#ches_flag#)
			</cfquery>
			<cfquery name="DEL_CHEQUE_HISTORY" datasource="#dsn2#">
				DELETE FROM CHEQUE_HISTORY WHERE CHEQUE_ID IN (#ches_flag#)
			</cfquery>
		</cfif>
		<cfset portfoy_no = get_cheque_no(belge_tipi:'cheque')>
		<cfloop from="1" to="#attributes.record_num#" index="i">
			<cfif not len(evaluate("attributes.cheque_id#i#")) and evaluate("attributes.row_kontrol#i#")>
				<cf_date tarih='attributes.cheque_duedate#i#'>
				<cfquery name="ADD_CHEQUE" datasource="#dsn2#">
					INSERT INTO CHEQUE
					(
						CHEQUE_PAYROLL_ID,
						CHEQUE_CODE,
						COMPANY_ID,
						CONSUMER_ID,
						EMPLOYEE_ID,
                        OWNER_COMPANY_ID,
                        OWNER_CONSUMER_ID,
                        OWNER_EMPLOYEE_ID,
                        CHEQUE_DUEDATE,
						CHEQUE_NO,
						CHEQUE_VALUE,
						OTHER_MONEY_VALUE,
						OTHER_MONEY,
						OTHER_MONEY_VALUE2,
						OTHER_MONEY2,
						DEBTOR_NAME,
						CHEQUE_STATUS_ID,
						BANK_NAME,
						BANK_BRANCH_NAME,
						ACCOUNT_ID,
						ACCOUNT_NO,
						CHEQUE_CITY,
						TAX_NO,
						TAX_PLACE,
						CHEQUE_PURSE_NO,
						CURRENCY_ID,
						SELF_CHEQUE,
						ENDORSEMENT_MEMBER,
						CASH_ID,
						RECORD_EMP,
						RECORD_IP,
						RECORD_DATE,
						CH_OTHER_MONEY_VALUE,
						CH_OTHER_MONEY	
					)
					VALUES
					(
						#attributes.ID#,
						<cfif len(evaluate("attributes.cheque_code#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.cheque_code#i#")#'>,<cfelse>NULL,</cfif>
						<cfif attributes.member_type eq "partner" and len(attributes.company_id)>#attributes.company_id#<cfelse>NULL</cfif>,
						<cfif attributes.member_type eq "consumer" and len(attributes.consumer_id)>#attributes.consumer_id#<cfelse>NULL</cfif>,
						<cfif attributes.member_type eq "employee" and len(attributes.employee_id)>#attributes.employee_id#<cfelse>NULL</cfif>,
						<cfif attributes.member_type eq "partner" and len(attributes.company_id)>#attributes.company_id#<cfelse>NULL</cfif>,
						<cfif attributes.member_type eq "consumer" and len(attributes.consumer_id)>#attributes.consumer_id#<cfelse>NULL</cfif>,
						<cfif attributes.member_type eq "employee" and len(attributes.employee_id)>#attributes.employee_id#<cfelse>NULL</cfif>,
						#evaluate("attributes.cheque_duedate#i#")#,
						<cfif len(evaluate("attributes.cheque_no#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.cheque_no#i#")#'>,<cfelse>NULL,</cfif>
						#evaluate("attributes.cheque_value#i#")#,
						<cfif len(evaluate("attributes.cheque_system_currency_value#i#"))>#evaluate("attributes.cheque_system_currency_value#i#")#,<cfelse>NULL,</cfif>
						<cfif len(evaluate("attributes.system_money_info#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.system_money_info#i#")#'>,<cfelse>NULL,</cfif>
						<cfif len(evaluate("attributes.other_money_value2#i#"))>#evaluate("attributes.other_money_value2#i#")#,<cfelse>NULL,</cfif>
						<cfif len(evaluate("attributes.other_money2#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.other_money2#i#")#'>,<cfelse>NULL,</cfif>
						<cfif len(evaluate("attributes.debtor_name#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.debtor_name#i#")#'>,<cfelse>NULL,</cfif>
						1,
						<cfif len(evaluate("attributes.bank_name#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.bank_name#i#")#'>,<cfelse>NULL,</cfif>
						<cfif len(evaluate("attributes.bank_branch_name#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.bank_branch_name#i#")#'>,<cfelse>NULL,</cfif>
						<cfif len(evaluate("attributes.account_id#i#"))>#wrk_eval("attributes.account_id#i#")#,<cfelse>NULL,</cfif>
						<cfif len(evaluate("attributes.account_no#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.account_no#i#")#'>,<cfelse>NULL,</cfif>
						<cfif len(evaluate("attributes.cheque_city#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.cheque_city#i#")#'>,<cfelse>NULL,</cfif>
						<cfif len(evaluate("attributes.tax_no#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.tax_no#i#")#'>,<cfelse>NULL,</cfif>
						<cfif len(evaluate("attributes.tax_place#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.tax_place#i#")#'>,<cfelse>NULL,</cfif>
						<cfqueryparam cfsqltype="cf_sql_varchar" value='#portfoy_no#'>,
						<cfif len(evaluate("attributes.currency_id#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.currency_id#i#")#'>,<cfelse>NULL,</cfif>
						<cfif len(evaluate("attributes.from_cheque_info#i#"))>#evaluate("attributes.from_cheque_info#i#")#,<cfelse>NULL,</cfif>
						<cfif len(evaluate("attributes.endorsement_member#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#evaluate("attributes.endorsement_member#i#")#'>,<cfelse>NULL,</cfif>
						#listfirst(form.cash_id,';')#,
						#session.ep.userid#,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
						#now()#,
						#wrk_round((evaluate("attributes.cheque_system_currency_value#i#")/attributes.basket_money_rate),4)#,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.basket_money#">
					)
				</cfquery>
				<cfquery name="GET_LAST_CHEQUE" datasource="#dsn2#">
					SELECT MAX(CHEQUE_ID) AS CHEQUE_ID FROM CHEQUE
				</cfquery>
				<cfquery name="ADD_CHEQUE_HISTORY" datasource="#dsn2#">
					INSERT INTO
						CHEQUE_HISTORY
							(
								CHEQUE_ID,
								PAYROLL_ID,
								COMPANY_ID,
								CONSUMER_ID,
								EMPLOYEE_ID,
								STATUS,
								ACT_DATE,
								RECORD_DATE,
								SELF_CHEQUE,
								OTHER_MONEY_VALUE,
								OTHER_MONEY,
								OTHER_MONEY_VALUE2,
								OTHER_MONEY2
							)
						VALUES
							(
								#get_last_cheque.CHEQUE_ID#,
								#attributes.ID#,
								<cfif attributes.member_type eq "partner" and len(attributes.company_id)>#attributes.company_id#<cfelse>NULL</cfif>,
								<cfif attributes.member_type eq "consumer" and len(attributes.consumer_id)>#attributes.consumer_id#<cfelse>NULL</cfif>,
								<cfif attributes.member_type eq "employee" and len(attributes.employee_id)>#attributes.employee_id#<cfelse>NULL</cfif>,
								1,
								#attributes.PAYROLL_REVENUE_DATE#,
								#NOW()#,
								<cfif len(evaluate("attributes.from_cheque_info#i#"))>#evaluate("attributes.from_cheque_info#i#")#,<cfelse>NULL,</cfif>
								<cfif len(evaluate("attributes.cheque_system_currency_value#i#"))>#evaluate("attributes.cheque_system_currency_value#i#")#,<cfelse>NULL,</cfif>
								<cfif len(evaluate("attributes.system_money_info#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.system_money_info#i#")#'>,<cfelse>NULL,</cfif>
								<cfif len(evaluate("attributes.other_money_value2#i#"))>#evaluate("attributes.other_money_value2#i#")#,<cfelse>NULL,</cfif>
								<cfif len(evaluate("attributes.other_money2#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.other_money2#i#")#'><cfelse>NULL</cfif>
							)
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
								#get_last_cheque.CHEQUE_ID#,
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
		</cfloop>
		<cfset portfoy_no = get_cheque_no(belge_tipi:'cheque',belge_no:portfoy_no)>
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
		<cfset last_cheque_list = valuelist(GET_CHEQUES_LAST.CHEQUE_ID)>
		<!--- update cari - account --->
		<cfscript>
			include('upd_payroll_entry_cari_account_process.cfm'); /*cari ve muhasebe islemleri yapılıyor*/
			basket_kur_ekle(action_id:attributes.id,table_type_id:11,process_type:1);
		</cfscript>
		<!--- onay ve uyarıların gelebilmesi icin action file sarti kaldirildi --->
		<cf_workcube_process_cat 
			process_cat="#form.process_cat#"
			old_process_cat_id = "#attributes.old_process_cat_id#"
			action_id = #attributes.id#
			is_action_file = 1
			action_db_type = '#dsn2#'
			action_page='#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_add_payroll_entry&event=upd&id=#attributes.id#'
			action_file_name='#get_process_type.action_file_name#'
			is_template_action_file = '#get_process_type.action_file_from_template#'>
     	<cf_add_log employee_id="#session.ep.userid#" log_type="0" action_id="#attributes.id#" action_name="#attributes.PAYROLL_NO# Güncellendi" paper_no="#form.PAYROLL_NO#" period_id="#session.ep.period_id#" process_type="#process_type#" data_source="#dsn2#">
	</cftransaction>
</cflock>
<cfquery name="get_closed_id" datasource="#dsn2#">
	SELECT CLOSED_ID FROM CARI_CLOSED_ROW WHERE ACTION_ID = #attributes.id# AND ACTION_TYPE_ID = #process_type# AND CARI_ACTION_ID IN (SELECT CARI_ACTION_ID FROM CARI_ROWS WHERE ACTION_TABLE = 'PAYROLL')
</cfquery>
<!---<cf_add_log employee_id="#session.ep.userid#" log_type="1" action_id="#attributes.id# " action_name="#attributes.name# " period_id="#session.ep.period_id#"  process_type="#process_type#">--->
<cfset attributes.actionId=attributes.id>
<script type="text/javascript">
	<cfif session.ep.our_company_info.is_paper_closer eq 1 and (len(attributes.company_id) or len(attributes.consumer_id) or len(attributes.employee_id))>
		<cfif get_closed_id.recordcount gt 0>
			window.open('<cfoutput>#request.self#?fuseaction=finance.list_payment_actions&event=upd&closed_id=#get_closed_id.closed_id#&act_type=1</cfoutput>','page');
		<cfelse>
			window.open('<cfoutput>#request.self#?fuseaction=finance.list_payment_actions&event=add&act_type=1&member_id=#attributes.company_id#&consumer_id=#attributes.consumer_id#&employee_id_new=#attributes.employee_id#&acc_type_id=#attributes.acc_type_id#&money_type=#form.basket_money#&row_action_id=#attributes.id#&row_action_type=#process_type#</cfoutput>','page');
		</cfif>
	</cfif>
	window.location.href="<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_add_payroll_entry&event=upd&id=#attributes.id#</cfoutput>";
</script> 
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
