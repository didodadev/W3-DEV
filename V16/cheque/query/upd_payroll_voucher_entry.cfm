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
		IS_UPD_CARI_ROW,
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
	is_upd_cari_row = get_process_type.IS_UPD_CARI_ROW;
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
	if(listlen(attributes.employee_id,'_') eq 2)
	{
		attributes.acc_type_id = listlast(attributes.employee_id,'_');
		attributes.employee_id = listfirst(attributes.employee_id,'_');
	}
</cfscript>
<cfif not isdefined("attributes.acc_type_id")><cfset attributes.acc_type_id = len(is_account_type_id) ? is_account_type_id : ""></cfif>
<cfquery name="CONTROL_VOUCHER_STATUS" datasource="#dsn2#">
	SELECT
    	V.VOUCHER_ID
    FROM
        VOUCHER V
        LEFT JOIN VOUCHER_HISTORY VH ON VH.VOUCHER_ID = V.VOUCHER_ID
    WHERE
        VH.PAYROLL_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#">
        AND ISNULL((SELECT TOP 1 PAYROLL_ID FROM VOUCHER_HISTORY VH2 WHERE VH2.VOUCHER_ID = V.VOUCHER_ID ORDER BY HISTORY_ID DESC),0) <> <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#">
</cfquery>
<cfquery name="CONTROL_NO" datasource="#DSN2#">
	SELECT 
		ACTION_ID 
	FROM 
		VOUCHER_PAYROLL 
	WHERE 
		PAYROLL_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#PAYROLL_NO#"> AND
		ACTION_ID<>#attributes.id#
</cfquery>
<cfif control_no.recordcount>
	<script type="text/javascript">
		alert("<cf_get_lang no='125.Aynı Bordro No lu Kayıt Var !'>");
		history.back();
	</script>
	<cfabort>
</cfif>
<cfif is_account eq 1>
	<cfif attributes.member_type eq "partner" and len(attributes.company_id)>
		<cfset acc = get_company_period(company_id: attributes.company_id,acc_type_id:len(is_account_type_id) ? is_account_type_id : "")>
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
		<!--- update payroll--->
		<cfquery name="UPD_PAYROLL" datasource="#dsn2#">
			UPDATE 
				VOUCHER_PAYROLL
			SET
				PROCESS_CAT=#form.process_cat#,
				PAYROLL_TYPE=#process_type#,
                <cfif control_voucher_status.recordcount eq 0>
                    COMPANY_ID = <cfif attributes.member_type eq "partner" and len(attributes.company_id)>#attributes.company_id#<cfelse>NULL</cfif>,
                    CONSUMER_ID = <cfif attributes.member_type eq "consumer" and len(attributes.consumer_id)>#attributes.consumer_id#<cfelse>NULL</cfif>,
                    EMPLOYEE_ID = <cfif attributes.member_type eq "employee" and len(attributes.employee_id)>#attributes.employee_id#<cfelse>NULL</cfif>,
                    PAYROLL_CASH_ID=#listfirst(form.cash_id,';')#,
                </cfif>
				PAYROLL_AVG_DUEDATE=#attributes.pyrll_avg_duedate#,
				PAYROLL_TOTAL_VALUE=#attributes.payroll_total#,
				PAYROLL_OTHER_MONEY=<cfif isdefined("attributes.basket_money") and len(attributes.basket_money)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.basket_money#"><cfelse>NULL</cfif>,
				PAYROLL_OTHER_MONEY_VALUE=<cfif isdefined("attributes.other_payroll_total") and len(attributes.other_payroll_total)>#attributes.other_payroll_total#<cfelse>NULL</cfif>,
				PAYROLL_AVG_AGE=<cfif len(attributes.pyrll_avg_age)>#attributes.pyrll_avg_age#,<cfelse>NULL,</cfif>
				<cfif control_voucher_status.recordcount eq 0>
                	PAYROLL_REVENUE_DATE=#attributes.PAYROLL_REVENUE_DATE#,
                </cfif>
				NUMBER_OF_VOUCHER=#attributes.voucher_num#,
				PROJECT_ID = <cfif len(attributes.project_name) and len(attributes.project_id)>#attributes.project_id#<cfelse>NULL</cfif>,
				PAYROLL_NO=<cfif len(attributes.PAYROLL_NO)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.PAYROLL_NO#"><cfelse>NULL</cfif>,
				UPDATE_EMP=#session.ep.userid#,
				UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">,
				UPDATE_DATE=#NOW()#,
				REVENUE_COLLECTOR_ID=#attributes.REVENUE_COLLECTOR_ID#,
				VOUCHER_BASED_ACC_CARI = <cfif len(is_voucher_based)>#is_voucher_based#<cfelse>0</cfif>,
				ACTION_DETAIL = <cfif isDefined("attributes.action_detail") and len(attributes.action_detail)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.action_detail#"><cfelse>NULL</cfif>,
				BRANCH_ID = #branch_id_info#,
				SPECIAL_DEFINITION_ID = <cfif isdefined("attributes.special_definition_id") and len(attributes.special_definition_id)>#attributes.special_definition_id#<cfelse>NULL</cfif>,
				ASSETP_ID = <cfif isdefined("attributes.asset_id") and len(attributes.asset_id) and len(attributes.asset_name)>#attributes.asset_id#<cfelse>NULL</cfif>,
				CONTRACT_ID = <cfif isdefined("attributes.contract_id") and len(attributes.contract_id) and len(attributes.contract_head)>#attributes.contract_id#<cfelse>NULL</cfif>,
				PAYMETHOD_ID = <cfif isdefined("attributes.paymethod_id") and len(attributes.paymethod_id) and len(attributes.paymethod_name)>#attributes.paymethod_id#<cfelse>NULL</cfif>,
			    ACC_TYPE_ID = <cfif isdefined("attributes.acc_type_id") and len(attributes.acc_type_id)>#attributes.acc_type_id#<cfelse>NULL</cfif>
			WHERE
				ACTION_ID=#attributes.id#
		</cfquery>
		<!--- update voucher --->
		<cfquery name="GET_REL_VOUCHERS" datasource="#dsn2#">
			SELECT VOUCHER_ID FROM VOUCHER_HISTORY WHERE PAYROLL_ID=#attributes.id#
		</cfquery>
		<cfset old_voucher_list = valuelist(GET_REL_VOUCHERS.VOUCHER_ID, ',')>
		<cfset ches = valuelist(GET_REL_VOUCHERS.VOUCHER_ID, ',')>
		<cfset ches_flag = valuelist(GET_REL_VOUCHERS.VOUCHER_ID, ',')>
		<cfloop from="1" to="#attributes.record_num#" index="i">
			<cfif evaluate("attributes.row_kontrol#i#")><cf_date tarih='attributes.voucher_duedate#i#'></cfif>
			<cfif ListFindNoCase(ches,evaluate("attributes.voucher_id#i#"), ',') and evaluate("attributes.row_kontrol#i#")>
				<cfquery name="UPD_VOUCHER" datasource="#dsn2#">
					UPDATE 
						VOUCHER
					SET
						VOUCHER_DUEDATE=#evaluate("attributes.voucher_duedate#i#")#,
						VOUCHER_VALUE=#evaluate("attributes.voucher_value#i#")#,
						DEBTOR_NAME=<cfif len(evaluate("attributes.debtor_name#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.debtor_name#i#")#'>,<cfelse>NULL,</cfif>
						VOUCHER_NO=<cfif len(evaluate("attributes.voucher_no#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.voucher_no#i#")#'>,<cfelse>NULL,</cfif>
						VOUCHER_PURSE_NO=<cfif len(evaluate("attributes.portfoy_no#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.portfoy_no#i#")#'>,<cfelse>NULL,</cfif>
						VOUCHER_CITY=<cfif len(evaluate("attributes.voucher_city#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.voucher_city#i#")#'>,<cfelse>NULL,</cfif>
						<cfif control_voucher_status.recordcount eq 0>
                            COMPANY_ID = <cfif attributes.member_type eq "partner" and len(attributes.company_id)>#attributes.company_id#<cfelse>NULL</cfif>,
                            CONSUMER_ID = <cfif attributes.member_type eq "consumer" and len(attributes.consumer_id)>#attributes.consumer_id#<cfelse>NULL</cfif>,
                            EMPLOYEE_ID = <cfif attributes.member_type eq "employee" and len(attributes.employee_id)>#attributes.employee_id#<cfelse>NULL</cfif>,
                            OWNER_COMPANY_ID = <cfif attributes.member_type eq "partner" and len(attributes.company_id)>#attributes.company_id#<cfelse>NULL</cfif>,
                            OWNER_CONSUMER_ID = <cfif attributes.member_type eq "consumer" and len(attributes.consumer_id)>#attributes.consumer_id#<cfelse>NULL</cfif>,
                            OWNER_EMPLOYEE_ID = <cfif attributes.member_type eq "employee" and len(attributes.employee_id)>#attributes.employee_id#<cfelse>NULL</cfif>,
						</cfif>
                        SELF_VOUCHER=<cfif len(evaluate("attributes.from_voucher_info#i#"))>#evaluate("attributes.from_voucher_info#i#")#,<cfelse>NULL,</cfif>
						OTHER_MONEY_VALUE = <cfif len(evaluate("attributes.voucher_system_currency_value#i#"))>#evaluate("attributes.voucher_system_currency_value#i#")#,<cfelse>NULL,</cfif>
						OTHER_MONEY=<cfif len(evaluate("attributes.system_money_info#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.system_money_info#i#")#'>,<cfelse>NULL,</cfif>
						OTHER_MONEY_VALUE2 = <cfif len(evaluate("attributes.other_money_value2#i#"))>#evaluate("attributes.other_money_value2#i#")#,<cfelse>NULL,</cfif>
						OTHER_MONEY2=<cfif len(evaluate("attributes.other_money2#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.other_money2#i#")#'>,<cfelse>NULL,</cfif>
						ACCOUNT_CODE = <cfif len(evaluate("attributes.acc_code#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.acc_code#i#")#'>,<cfelse>NULL,</cfif>
						<cfif control_voucher_status.recordcount eq 0>
                        	CASH_ID = #listfirst(form.cash_id,';')#,
                        </cfif>
						VOUCHER_CODE=<cfif len(evaluate("attributes.voucher_code#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.voucher_code#i#")#'><cfelse>NULL</cfif>,
						CH_OTHER_MONEY_VALUE=#wrk_round((evaluate("attributes.voucher_system_currency_value#i#")/attributes.basket_money_rate),4)#,
						CH_OTHER_MONEY=<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.basket_money#">,
						IS_PAY_TERM = <cfif isdefined("attributes.is_pay_term#i#") and evaluate("attributes.is_pay_term#i#") eq 1>1<cfelse>0</cfif>
					WHERE
						VOUCHER_ID = #evaluate("attributes.voucher_id#i#")#
				</cfquery>
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
				<cfquery name="UPD_VOUCHER_HISTORY" datasource="#dsn2#">
					UPDATE 
						VOUCHER_HISTORY
					SET
                    	<cfif control_voucher_status.recordcount eq 0>
							ACT_DATE = #attributes.PAYROLL_REVENUE_DATE#,
                        </cfif>
						COMPANY_ID = <cfif attributes.member_type eq "partner" and len(attributes.company_id)>#attributes.company_id#<cfelse>NULL</cfif>,
						CONSUMER_ID = <cfif attributes.member_type eq "consumer" and len(attributes.consumer_id)>#attributes.consumer_id#<cfelse>NULL</cfif>,
						EMPLOYEE_ID = <cfif attributes.member_type eq "employee" and len(attributes.employee_id)>#attributes.employee_id#<cfelse>NULL</cfif>,
						OTHER_MONEY_VALUE = <cfif len(evaluate("attributes.voucher_system_currency_value#i#"))>#evaluate("attributes.voucher_system_currency_value#i#")#,<cfelse>NULL,</cfif>
						OTHER_MONEY=<cfif len(evaluate("attributes.system_money_info#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.system_money_info#i#")#'>,<cfelse>NULL,</cfif>
						OTHER_MONEY_VALUE2 = <cfif len(evaluate("attributes.other_money_value2#i#"))>#evaluate("attributes.other_money_value2#i#")#,<cfelse>NULL,</cfif>
						OTHER_MONEY2=<cfif len(evaluate("attributes.other_money2#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.other_money2#i#")#'>,<cfelse>NULL,</cfif>
						SELF_VOUCHER = <cfif len(evaluate("attributes.from_voucher_info#i#"))>#evaluate("attributes.from_voucher_info#i#")#<cfelse>NULL</cfif>
					WHERE
						VOUCHER_ID = #evaluate("attributes.voucher_id#i#")#
                        AND PAYROLL_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#">
				</cfquery>
				<cfset ches_flag = ListDeleteAt(ches_flag, ListFindNoCase(ches_flag,evaluate("attributes.voucher_id#i#"), ','), ',')>
			</cfif>
		</cfloop>
		<cfif len(ches_flag)>
			<cfquery name="DEL_VOUCHER" datasource="#dsn2#">
				DELETE FROM VOUCHER WHERE VOUCHER_ID IN (#ches_flag#)
			</cfquery>
			<cfquery name="DEL_VOUCHER_HISTORY" datasource="#dsn2#">
				DELETE FROM VOUCHER_HISTORY WHERE VOUCHER_ID IN (#ches_flag#)
			</cfquery>
		</cfif>
		<cfset portfoy_no = get_cheque_no(belge_tipi:'voucher')>
		<cfloop from="1" to="#attributes.record_num#" index="i">
			<cfif not len(evaluate("attributes.voucher_id#i#")) and evaluate("attributes.row_kontrol#i#")>
				<cfquery name="ADD_VOUCHER" datasource="#dsn2#">
				INSERT INTO
					VOUCHER
					(
						VOUCHER_PAYROLL_ID,
						COMPANY_ID,
						CONSUMER_ID,
						EMPLOYEE_ID,
                        OWNER_COMPANY_ID,
						OWNER_CONSUMER_ID,
						OWNER_EMPLOYEE_ID,
						VOUCHER_CODE,
						VOUCHER_DUEDATE,
						VOUCHER_NO,
						VOUCHER_VALUE,
						OTHER_MONEY_VALUE,
						OTHER_MONEY,
						OTHER_MONEY_VALUE2,
						OTHER_MONEY2,
						DEBTOR_NAME,
						VOUCHER_STATUS_ID,
						VOUCHER_CITY,
						VOUCHER_PURSE_NO,
						CURRENCY_ID,
						SELF_VOUCHER,
						CASH_ID,
						ACCOUNT_CODE,
						RECORD_DATE,
						CH_OTHER_MONEY_VALUE,
						CH_OTHER_MONEY,
						IS_PAY_TERM
					)
					VALUES
					(
						#attributes.id#,
						<cfif attributes.member_type eq "partner" and len(attributes.company_id)>#attributes.company_id#<cfelse>NULL</cfif>,
						<cfif attributes.member_type eq "consumer" and len(attributes.consumer_id)>#attributes.consumer_id#<cfelse>NULL</cfif>,
						<cfif attributes.member_type eq "employee" and len(attributes.employee_id)>#attributes.employee_id#<cfelse>NULL</cfif>,
						<cfif attributes.member_type eq "partner" and len(attributes.company_id)>#attributes.company_id#<cfelse>NULL</cfif>,
						<cfif attributes.member_type eq "consumer" and len(attributes.consumer_id)>#attributes.consumer_id#<cfelse>NULL</cfif>,
						<cfif attributes.member_type eq "employee" and len(attributes.employee_id)>#attributes.employee_id#<cfelse>NULL</cfif>,
						<cfif len(evaluate("attributes.voucher_code#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.voucher_code#i#")#'>,<cfelse>NULL,</cfif>
						#evaluate("attributes.voucher_duedate#i#")#,
						<cfif len(evaluate("attributes.voucher_no#i#"))>'#wrk_eval("attributes.voucher_no#i#")#',<cfelse>NULL,</cfif>
						#evaluate("attributes.voucher_value#i#")#,
						<cfif len(evaluate("attributes.voucher_system_currency_value#i#"))>#evaluate("attributes.voucher_system_currency_value#i#")#,<cfelse>NULL,</cfif>
						<cfif len(evaluate("attributes.system_money_info#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.system_money_info#i#")#'>,<cfelse>NULL,</cfif>
						<cfif len(evaluate("attributes.other_money_value2#i#"))>#evaluate("attributes.other_money_value2#i#")#,<cfelse>NULL,</cfif>
						<cfif len(evaluate("attributes.other_money2#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.other_money2#i#")#'>,<cfelse>NULL,</cfif>
						<cfif len(evaluate("attributes.debtor_name#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.debtor_name#i#")#'>,<cfelse>NULL,</cfif>
						1,
						<cfif len(evaluate("attributes.voucher_city#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.voucher_city#i#")#'>,<cfelse>NULL,</cfif>
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#portfoy_no#">,
						<cfif len(evaluate("attributes.currency_id#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.currency_id#i#")#'>,<cfelse>NULL,</cfif>
						<cfif len(evaluate("attributes.from_voucher_info#i#"))>#evaluate("attributes.from_voucher_info#i#")#,<cfelse>NULL,</cfif>
						#listfirst(form.cash_id,';')#,
						<cfif len(evaluate("attributes.acc_code#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.acc_code#i#")#'>,<cfelse>NULL,</cfif>
						#NOW()#,
						#wrk_round((evaluate("attributes.voucher_system_currency_value#i#")/attributes.basket_money_rate),4)#,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.basket_money#">,
						<cfif isdefined("attributes.is_pay_term#i#") and evaluate("attributes.is_pay_term#i#") eq 1>1<cfelse>0</cfif>
					)
				</cfquery>
				<cfquery name="GET_LAST_VOUCHER" datasource="#dsn2#">
					SELECT MAX(VOUCHER_ID) AS V_ID FROM VOUCHER
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
								#get_last_voucher.V_ID#,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#ListGetAt(money,1,',')#">,
								#ListGetAt(money,3,',')#,					
								#ListGetAt(money,2,',')#,
								<cfif ListGetAt(money,1,',') is evaluate("attributes.currency_id#i#")>1<cfelse>0</cfif>
							)
						</cfquery>
					</cfloop>
				</cfif>
				<cfquery name="ADD_VOUCHER_HISTORY" datasource="#dsn2#">
					INSERT INTO
						VOUCHER_HISTORY
							(
								VOUCHER_ID,
								COMPANY_ID,
								CONSUMER_ID,
								EMPLOYEE_ID,
								PAYROLL_ID,
								STATUS,
								ACT_DATE,
								RECORD_DATE,
								SELF_VOUCHER,
								OTHER_MONEY_VALUE,
								OTHER_MONEY,
								OTHER_MONEY_VALUE2,
								OTHER_MONEY2
							)
						VALUES
							(
								#get_last_voucher.V_ID#,
								<cfif attributes.member_type eq "partner" and len(attributes.company_id)>#attributes.company_id#<cfelse>NULL</cfif>,
								<cfif attributes.member_type eq "consumer" and len(attributes.consumer_id)>#attributes.consumer_id#<cfelse>NULL</cfif>,
								<cfif attributes.member_type eq "employee" and len(attributes.employee_id)>#attributes.employee_id#<cfelse>NULL</cfif>,
								#attributes.id#,
								1,
								#attributes.PAYROLL_REVENUE_DATE#,
								#NOW()#,
								<cfif len(evaluate("attributes.from_voucher_info#i#"))>#evaluate("attributes.from_voucher_info#i#")#,<cfelse>NULL,</cfif>
								<cfif len(evaluate("attributes.voucher_system_currency_value#i#"))>#evaluate("attributes.voucher_system_currency_value#i#")#,<cfelse>NULL,</cfif>
								<cfif len(evaluate("attributes.system_money_info#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.system_money_info#i#")#'>,<cfelse>NULL,</cfif>
								<cfif len(evaluate("attributes.other_money_value2#i#"))>#evaluate("attributes.other_money_value2#i#")#,<cfelse>NULL,</cfif>
								<cfif len(evaluate("attributes.other_money2#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.other_money2#i#")#'><cfelse>NULL</cfif>
							)
				</cfquery>
				<cfset portfoy_no = portfoy_no+1>
			</cfif>
		</cfloop>
		<cfset portfoy_no = get_cheque_no(belge_tipi:'voucher',belge_no:portfoy_no)>
		<cfquery name="GET_VOUCHERS_LAST" datasource="#dsn2#">
			SELECT 
				VOUCHER.* 
			FROM
				VOUCHER, 
				VOUCHER_HISTORY 
			WHERE
				VOUCHER.VOUCHER_ID=VOUCHER_HISTORY.VOUCHER_ID
				AND PAYROLL_ID=#attributes.id#
		</cfquery>
		<cfset last_voucher_list = valuelist(GET_VOUCHERS_LAST.VOUCHER_ID)>

		<!--- update cari --->
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
                if(is_voucher_based eq 1) /*islem kategorisinde senet bazında carici secili*/
                {	
                    /*bordro ilk kaydedildiginde carici bordro bazında calıstırılmıssa, once bu kayıt silinir ardından senet bazında carici cagırılır*/
                    if(attributes.payroll_acc_cari_voucher_based neq 1) 
                        cari_sil(action_id:attributes.id,action_table:'VOUCHER_PAYROLL',process_type:form.old_process_type);
                    else
                    { /*bordrodan cıkarılan senetlerin cari hareketleri siliniyor*/
                        for(cheq_n=1;cheq_n lte listlen(ches_flag);cheq_n=cheq_n+1)
                            cari_sil(action_id:listgetat(ches_flag,cheq_n,','),action_table:'VOUCHER',process_type:form.old_process_type,payroll_id :attributes.id);
                    }
                    for(cheq_x=1;cheq_x lte listlen(last_voucher_list);cheq_x=cheq_x+1) /*bordrodaki senetlerin herbiri icin cari hareket yazılıyor*/
                    {
                        if(get_vouchers_last.IS_PAY_TERM[cheq_x] eq 0)
                        {
                            if(len(attributes.basket_money) and len(attributes.basket_money_rate))
                            {
                                other_money = attributes.basket_money;
                                other_money_value = wrk_round(get_vouchers_last.OTHER_MONEY_VALUE[cheq_x]/attributes.basket_money_rate);
                            }
                            else if(get_vouchers_last.CURRENCY_ID[cheq_x] is not session.ep.money)
                            {
                                other_money =get_vouchers_last.CURRENCY_ID[cheq_x];
                                other_money_value =get_vouchers_last.VOUCHER_VALUE[cheq_x];
                            }
                            else if(len(get_vouchers_last.OTHER_MONEY_VALUE2[cheq_x]) and len(get_vouchers_last.OTHER_MONEY2[cheq_x]) )
                            {
                                other_money =get_vouchers_last.OTHER_MONEY2[cheq_x];
                                other_money_value =get_vouchers_last.OTHER_MONEY_VALUE2[cheq_x];
                            }
                            else
                            {
                                other_money = get_vouchers_last.OTHER_MONEY[cheq_x];
                                other_money_value = get_vouchers_last.OTHER_MONEY_VALUE[cheq_x];
                            }
                            paper_currency_multiplier = '';
                            if(isDefined('attributes.kur_say') and len(attributes.kur_say))
                                for(mon=1;mon lte attributes.kur_say;mon=mon+1)
                                {
                                    if(evaluate("attributes.hidden_rd_money_#mon#") is other_money)
                                        paper_currency_multiplier = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
                                }
                            GET_VOUCHER_STATUS=cfquery(datasource:"#dsn2#",sqlstring:"SELECT VOUCHER_STATUS_ID FROM VOUCHER WHERE VOUCHER_ID=#listgetat(last_voucher_list,cheq_x,',')#");
                            carici(
                                action_id :listgetat(last_voucher_list,cheq_x,','),
                                action_table :'VOUCHER',
                                workcube_process_type :process_type,
                                workcube_old_process_type :form.old_process_type,
                                process_cat :form.process_cat,
                                account_card_type :13,
                                islem_tarihi :attributes.PAYROLL_REVENUE_DATE,
                                islem_tutari :get_vouchers_last.OTHER_MONEY_VALUE[cheq_x],
                                other_money_value : iif(isdefined('other_money_value'),'other_money_value',de('')),
                                other_money :iif(isdefined('other_money'),'other_money',de('')),
                                islem_belge_no : get_vouchers_last.VOUCHER_NO[cheq_x],
                                from_cmp_id : iif(attributes.member_type eq "partner",'attributes.company_id',de('')),
                                from_consumer_id : iif(attributes.member_type eq "consumer",'attributes.consumer_id',de('')),
                                from_employee_id : iif(attributes.member_type eq "employee",'attributes.employee_id',de('')),							
                                to_cash_id : listfirst(form.cash_id,';'),
                                due_date :iif(len(get_vouchers_last.VOUCHER_DUEDATE[cheq_x]),'createodbcdatetime(get_vouchers_last.VOUCHER_DUEDATE[cheq_x])','attributes.pyrll_avg_duedate'),
                                currency_multiplier : currency_multiplier,
                                islem_detay : 'SENET GİRİŞ BORDROSU(Senet Bazında)',
                                acc_type_id : attributes.acc_type_id,
                                action_detail : attributes.action_detail,
                                project_id : attributes.project_id,
                                to_branch_id : branch_id_info,
                                payroll_id :attributes.id,
                                special_definition_id : iif((isdefined("attributes.special_definition_id") and len(attributes.special_definition_id)),'attributes.special_definition_id',de('')),
                                assetp_id : iif((isdefined("attributes.asset_id") and len(attributes.asset_id) and len(attributes.asset_name)),'attributes.asset_id',de('')),
                                is_upd_other_value : iif(GET_VOUCHER_STATUS.VOUCHER_STATUS_ID eq 3,is_upd_cari_row,0),//işlem kategrnsdeki extre güncelleme işlemnde dövizleri tekrar değiştirmesn
                                rate2:paper_currency_multiplier
                                );
                        }
                        else
                            cari_sil(action_id:listgetat(last_voucher_list,cheq_x,','),action_table:'VOUCHER',process_type:form.old_process_type,payroll_id :attributes.id);
        
                    }
                }
                else
                {
                    /*bordro ilk kaydedildiginde carici senet bazında calıstırılmıssa, once bu kayıt silinir ardından 
                    bordro bazında carici (eğer önceki kayıt bordro bazında ise zaten old_process_type ile siliniyor)cagırılır*/
                    if(attributes.payroll_acc_cari_voucher_based eq 1)
                    { 
                        for(cheq_w=1;cheq_w lte listlen(ches);cheq_w=cheq_w+1)
                            cari_sil(action_id:listgetat(ches,cheq_w,','),action_table:'VOUCHER',process_type:form.old_process_type,payroll_id :attributes.id);
                    }
                    carici(
                        action_id :attributes.id,
                        action_table :'VOUCHER_PAYROLL',
                        workcube_process_type :process_type,		
                        workcube_old_process_type :form.old_process_type,
                        process_cat : form.process_cat,
                        account_card_type :13,
                        islem_tarihi :attributes.PAYROLL_REVENUE_DATE,
                        islem_tutari :attributes.payroll_total,
                        other_money_value : iif(len(attributes.other_payroll_total),'attributes.other_payroll_total',de('')),
                        other_money :iif(len(attributes.basket_money),'attributes.basket_money',de('')),
                        islem_belge_no : attributes.payroll_no,
                        due_date : attributes.pyrll_avg_duedate,
                        from_cmp_id : iif(attributes.member_type eq "partner",'attributes.company_id',de('')),
                        from_consumer_id : iif(attributes.member_type eq "consumer",'attributes.consumer_id',de('')),
                        from_employee_id : iif(attributes.member_type eq "employee",'attributes.employee_id',de('')),
                        to_cash_id : listfirst(form.cash_id,';'),
                        currency_multiplier : currency_multiplier,
                        islem_detay : 'SENET GİRİŞ BORDROSU',
                        acc_type_id : attributes.acc_type_id,
                        action_detail : attributes.action_detail,
                        project_id : attributes.project_id,
                        special_definition_id : iif((isdefined("attributes.special_definition_id") and len(attributes.special_definition_id)),'attributes.special_definition_id',de('')),
                        assetp_id : iif((isdefined("attributes.asset_id") and len(attributes.asset_id) and len(attributes.asset_name)),'attributes.asset_id',de('')),
                        to_branch_id : branch_id_info,
                        rate2:paper_currency_multiplier
                        );
                    }
            }
            else
            {
                 //bordro kaydedilirken cari-muhasebe hareketleri senet bazında yapılmış ise her bir senet icin olusturulmus cari hareket siliniyor
                if(attributes.payroll_acc_cari_voucher_based eq 1)
                    {
                    for(che_q=1;che_q lte listlen(old_voucher_list);che_q=che_q+1) 
                        cari_sil(action_id:listgetat(old_voucher_list,che_q,','),action_table:'VOUCHER',process_type:form.old_process_type,payroll_id :attributes.id);	
                    }
                else /*bordro bazında cari hareket siliniyor*/
                    cari_sil(action_id:attributes.id,action_table:'VOUCHER_PAYROLL',process_type:form.old_process_type);
            }
            if(is_account eq 1)
            {	
                if(is_voucher_based_acc neq 1)	/*standart muhasebe islemleri yapılıyor*/
                {	
                    GET_ACC_CODE=cfquery(datasource:"#dsn2#", sqlstring:"SELECT A_VOUCHER_ACC_CODE FROM CASH WHERE CASH_ID=#listfirst(form.cash_id,';')#");
                    check_tutar_list = '';
                    check_hesap_list = '';
                    other_currency_borc_list= '';
                    other_amount_borc_list= '';
                    kontrol_row = 0;
                    payroll_total_ = 0;
                    for(i=1; i lte attributes.record_num; i=i+1)
                    {
                        if (evaluate("attributes.row_kontrol#i#") and evaluate("attributes.is_pay_term#i#") eq 0)
                        {
                            kontrol_row = 1;
                            if(evaluate("attributes.currency_id#i#") neq session.ep.money)
                                check_tutar_list = listappend(check_tutar_list,evaluate("attributes.voucher_system_currency_value#i#"),',');
                            else
                                check_tutar_list=listappend(check_tutar_list,evaluate("attributes.voucher_value#i#"),',');
                            other_currency_borc_list = listappend(other_currency_borc_list,listgetat(form.cash_id,3,';'),',');
                            other_amount_borc_list =  listappend(other_amount_borc_list,evaluate("attributes.voucher_value#i#"),',');
                            if(len(evaluate("attributes.acc_code#i#")))
                                check_hesap_list=listappend(check_hesap_list,evaluate("attributes.acc_code#i#"),',');
                            else
                                check_hesap_list=listappend(check_hesap_list,GET_ACC_CODE.A_VOUCHER_ACC_CODE,',');
                            payroll_total_ = payroll_total_ + evaluate("attributes.voucher_system_currency_value#i#");
                        
                            /* Muhasebe kaydi satirlari icin aciklama alanlari duzenleniyor */
                            if (is_account_group neq 1)
                            {
                                if(isDefined("attributes.action_detail") and len(attributes.action_detail))
                                    str_card_detail[1][listlen(check_tutar_list)] = ' #evaluate("attributes.voucher_no#i#")# - #attributes.company_name# - #attributes.action_detail#';
                                else
                                    str_card_detail[1][listlen(check_tutar_list)] = ' #evaluate("attributes.voucher_no#i#")# - #attributes.company_name# - SENET GİRİŞ İŞLEMİ';
                            }
                            else
                            {
                                if(isDefined("attributes.action_detail") and len(attributes.action_detail))
                                    str_card_detail[1][listlen(check_tutar_list)] = ' #attributes.company_name# - #attributes.action_detail#';
                                else
                                    str_card_detail[1][listlen(check_tutar_list)] = ' #attributes.company_name# - SENET GİRİŞ İŞLEMİ';
                            }
                        }
                    }
                    if(isDefined("attributes.action_detail") and len(attributes.action_detail))
                        str_card_detail[2][1] = ' #attributes.company_name# - #attributes.action_detail#';
                    else
                        str_card_detail[2][1] = ' #attributes.company_name# - SENET GİRİŞ İŞLEMİ';
                    
                    if(kontrol_row eq 1)
                    {
                        muhasebeci (
                            action_id:attributes.id,
                            workcube_process_type:process_type,
                            workcube_old_process_type :form.old_process_type,
                            account_card_type:13,
                            action_table :'VOUCHER_PAYROLL',
                            company_id : iif(attributes.member_type eq "partner",'attributes.company_id',de('')),
                            consumer_id : iif(attributes.member_type eq "consumer",'attributes.consumer_id',de('')),
                            employee_id : iif(attributes.member_type eq "employee",'attributes.employee_id',de('')),
                            islem_tarihi:attributes.PAYROLL_REVENUE_DATE,
                            borc_hesaplar: check_hesap_list,
                            borc_tutarlar: check_tutar_list,
                            other_amount_borc : other_amount_borc_list,
                            other_currency_borc :other_currency_borc_list,
                            alacak_hesaplar: acc,
                            alacak_tutarlar: payroll_total_,
                            other_amount_alacak : wrk_round(payroll_total_/paper_currency_multiplier),
                            other_currency_alacak : iif(len(attributes.basket_money),'attributes.basket_money',de('')),
                            fis_detay:'SENET GİRİŞ İŞLEMİ',
                            fis_satir_detay:str_card_detail,
                            currency_multiplier : currency_multiplier,
                            belge_no : form.payroll_no,
                            to_branch_id : branch_id_info,
                            workcube_process_cat : form.process_cat,
                            acc_project_id : attributes.project_id,
                            is_account_group : is_account_group
                        );
                    }
                    else
                        muhasebe_sil(action_id:attributes.id,action_table:'VOUCHER_PAYROLL',process_type:form.old_process_type);
                }
                else		/*e-deftere uygun muhasebe islemleri yapılıyor*/
                {
					// tum muhasebe kayıtlari silinir sonra yaniden eklenir.
					muhasebe_sil(action_id:attributes.id,action_table:'VOUCHER_PAYROLL',process_type:form.old_process_type);
					
                    GET_ACC_CODE=cfquery(datasource:"#dsn2#", sqlstring:"SELECT A_VOUCHER_ACC_CODE FROM CASH WHERE CASH_ID=#listfirst(form.cash_id,';')#");
                    check_tutar_list = '';
                    check_hesap_list = '';
                    for(i=1; i lte get_vouchers_last.recordcount; i=i+1)
					{
						if(get_vouchers_last.IS_PAY_TERM[i] eq 0)
						{
                            if(get_vouchers_last.CURRENCY_ID[i] neq session.ep.money)
								check_tutar_list = get_vouchers_last.OTHER_MONEY_VALUE[i];
							else
								check_tutar_list = get_vouchers_last.VOUCHER_VALUE[i];
							
							if(len(get_vouchers_last.ACCOUNT_CODE[i]))
								check_hesap_list = get_vouchers_last.ACCOUNT_CODE[i];
							else
								check_hesap_list = GET_ACC_CODE.A_VOUCHER_ACC_CODE;
                            /* Muhasebe kaydi satirlari icin aciklama alanlari duzenleniyor */
							if (is_account_group neq 1)
							{
								if(isDefined("attributes.action_detail") and len(attributes.action_detail))
									str_card_detail[1][1] = ' #get_vouchers_last.VOUCHER_NO[i]# - #attributes.company_name# - #attributes.action_detail#';
								else
									str_card_detail[1][1] = ' #get_vouchers_last.VOUCHER_NO[i]# - #attributes.company_name# - SENET GİRİŞ İŞLEMİ';
							}
							else
							{
								if(isDefined("attributes.action_detail") and len(attributes.action_detail))
									str_card_detail[1][1] = ' #attributes.company_name# - #attributes.action_detail#';
								else
									str_card_detail[1][1] = ' #attributes.company_name# - SENET GİRİŞ İŞLEMİ';
							}
							if(isDefined("attributes.action_detail") and len(attributes.action_detail))
								str_card_detail[2][1] = ' #attributes.company_name# - #attributes.action_detail#';
							else
								str_card_detail[2][1] = ' #attributes.company_name# - SENET GİRİŞ İŞLEMİ';
							muhasebeci (
								action_id:attributes.id,
								action_row_id : get_vouchers_last.VOUCHER_ID[i],
								due_date :iif(len(get_vouchers_last.VOUCHER_DUEDATE[i]),'createodbcdatetime(get_vouchers_last.VOUCHER_DUEDATE[i])','attributes.pyrll_avg_duedate'),
								workcube_process_type:process_type,
								workcube_old_process_type :form.old_process_type,
								account_card_type:13,
								action_table :'VOUCHER_PAYROLL',
								company_id : iif(attributes.member_type eq "partner",'attributes.company_id',de('')),
								consumer_id : iif(attributes.member_type eq "consumer",'attributes.consumer_id',de('')),
								employee_id : iif(attributes.member_type eq "employee",'attributes.employee_id',de('')),
								islem_tarihi:attributes.PAYROLL_REVENUE_DATE,
								borc_hesaplar: check_hesap_list,
								borc_tutarlar: check_tutar_list,
								other_amount_borc : get_vouchers_last.VOUCHER_VALUE[i],
								other_currency_borc :listgetat(form.cash_id,3,';'),
								alacak_hesaplar: acc,
								alacak_tutarlar: check_tutar_list,
								other_amount_alacak : get_vouchers_last.OTHER_MONEY_VALUE[i]/paper_currency_multiplier,
								other_currency_alacak : iif(len(attributes.basket_money),'attributes.basket_money',de('')),
								fis_detay:'SENET GİRİŞ İŞLEMİ',
								fis_satir_detay:str_card_detail,
								currency_multiplier : currency_multiplier,
								belge_no : get_vouchers_last.VOUCHER_NO[i],
								to_branch_id : branch_id_info,
								workcube_process_cat : form.process_cat,
								acc_project_id : attributes.project_id,
								is_account_group : is_account_group
							);
                        }
                    }
                }
            }
            else/*eğer işlem kategorisinde muhasebe işlemi seçili değilse önceki işlemleri silecek*/
            {
                muhasebe_sil(action_id:attributes.id,action_table:'VOUCHER_PAYROLL',process_type:form.old_process_type);
            }
        	basket_kur_ekle(action_id:attributes.id,table_type_id:12,process_type:1);
        </cfscript>
        <cf_workcube_process_cat 
            process_cat="#form.process_cat#"
            old_process_cat_id = "#attributes.old_process_cat_id#"
            action_id = #attributes.id#
            is_action_file = 1
            action_db_type = '#dsn2#'
            action_page='#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_add_voucher_payroll_entry&event=upd&ID=#attributes.id#'
            action_file_name='#get_process_type.action_file_name#'
            is_template_action_file = '#get_process_type.action_file_from_template#'>
	    <cf_add_log employee_id="#session.ep.userid#" log_type="0" action_id="#attributes.id#" action_name="#form.payroll_no# Güncellendi" paper_no="#form.payroll_no#" period_id="#session.ep.period_id#" process_type="#get_process_type.PROCESS_TYPE#" data_source="#dsn2#">
	</cftransaction>
</cflock>
<cfquery name="get_closed_id" datasource="#dsn2#">
	SELECT CLOSED_ID FROM CARI_CLOSED_ROW WHERE ACTION_ID = #attributes.id# AND ACTION_TYPE_ID = #process_type# AND CARI_ACTION_ID IN (SELECT CARI_ACTION_ID FROM CARI_ROWS WHERE ACTION_TABLE = 'VOUCHER_PAYROLL')
</cfquery>
<script type="text/javascript">
	<cfif session.ep.our_company_info.is_paper_closer eq 1 and (len(attributes.company_id) or len(attributes.consumer_id) or len(attributes.employee_id))>
		<cfif get_closed_id.recordcount gt 0>
			window.open('<cfoutput>#request.self#?fuseaction=finance.list_payment_actions&event=upd&closed_id=#get_closed_id.closed_id#&act_type=1</cfoutput>','page');
		<cfelse>
			window.open('<cfoutput>#request.self#?fuseaction=finance.list_payment_actions&event=add&act_type=1&member_id=#attributes.company_id#&consumer_id=#attributes.consumer_id#&employee_id_new=#attributes.employee_id#&acc_type_id=#attributes.acc_type_id#&money_type=#form.basket_money#&row_action_id=#attributes.id#&row_action_type=#process_type#</cfoutput>','page');
		</cfif>
	</cfif>
	window.location.href="<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_add_voucher_payroll_entry&event=upd&ID=#attributes.id#</cfoutput>";
</script> 
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
