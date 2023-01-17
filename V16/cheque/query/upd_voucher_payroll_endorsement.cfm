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
	is_cari = get_process_type.IS_CARI;
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
<cfquery name="CONTROL_NO" datasource="#DSN2#">
	SELECT 
		ACTION_ID 
	FROM 
		VOUCHER_PAYROLL 
	WHERE 
		PAYROLL_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#PAYROLL_NO#"> AND
		ACTION_ID<>#attributes.ID#
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
		<cfset acc = get_company_period(company_id: attributes.company_id,acc_type_id: len(is_account_type_id) ? is_account_type_id : "")>
	<cfelseif attributes.member_type eq "consumer" and len(attributes.consumer_id)>
		<cfset acc = get_consumer_period(consumer_id : attributes.consumer_id, acc_type_id : len(is_account_type_id) ? is_account_type_id : "")>
	<cfelseif attributes.member_type eq "employee" and len(attributes.employee_id)>
		<cfset acc = get_employee_period(attributes.employee_id,attributes.acc_type_id)>
	</cfif>
	<cfif not len(ACC)>
		<script type="text/javascript">
			alert("<cf_get_lang no='126.Seçtiğiniz Üyenin Muhasebe Kodu Secilmemiş !'>");
			history.back();	
		</script>
		<cfabort>
	</cfif>
</cfif>
<!--- update payroll--->
<cflock name="#createUUID()#" timeout="20">
	<cftransaction>
	<cfquery name="UPD_PAYROLL" datasource="#dsn2#">
		UPDATE 
			VOUCHER_PAYROLL
		SET
			PROCESS_CAT = #form.process_cat#,
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
			PAYROLL_AVG_DUEDATE=<cfif len(attributes.pyrll_avg_duedate)>#attributes.pyrll_avg_duedate#,<cfelse>NULL,</cfif>
			PAYROLL_AVG_AGE=<cfif len(attributes.pyrll_avg_age)>#attributes.pyrll_avg_age#,<cfelse>NULL,</cfif>
			PAYROLL_REV_MEMBER=#attributes.pro_employee_id#,
			<cfif len(attributes.PAYROLL_NO)>PAYROLL_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.PAYROLL_NO#">,</cfif>
			UPDATE_EMP=#session.ep.userid#,
			UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">,
			UPDATE_DATE=#NOW()#	,
			VOUCHER_BASED_ACC_CARI = <cfif len(is_voucher_based)>#is_voucher_based#<cfelse>0</cfif>,
			ACTION_DETAIL = <cfif isDefined("attributes.action_detail") and len(attributes.action_detail)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.action_detail#"><cfelse>NULL</cfif>,
			BRANCH_ID = #branch_id_info#,
			SPECIAL_DEFINITION_ID = <cfif isdefined("attributes.special_definition_id") and len(attributes.special_definition_id)>#attributes.special_definition_id#<cfelse>NULL</cfif>,
			ASSETP_ID = <cfif isdefined("attributes.asset_id") and len(attributes.asset_id) and len(attributes.asset_name)>#attributes.asset_id#<cfelse>NULL</cfif>,
			CONTRACT_ID = <cfif isdefined("attributes.contract_id") and len(attributes.contract_id) and len(attributes.contract_head)>#attributes.contract_id#<cfelse>NULL</cfif>,
			ACC_TYPE_ID = <cfif isdefined("attributes.acc_type_id") and len(attributes.acc_type_id)>#attributes.acc_type_id#<cfelse>NULL</cfif>
		WHERE
			ACTION_ID=#attributes.ID#
	</cfquery>
	<!--- update voucher --->
	<cfquery name="GET_REL_VOUCHERS" datasource="#dsn2#">
		SELECT VOUCHER_ID FROM VOUCHER_HISTORY WHERE PAYROLL_ID=#attributes.ID#
	</cfquery>
	<cfset old_voucher_list=valuelist(get_rel_vouchers.VOUCHER_ID)>
	<cfset ches=valuelist(get_rel_vouchers.VOUCHER_ID)>
	<cfloop from="1" to="#attributes.record_num#" index="k">
		<cfif evaluate("attributes.row_kontrol#k#")><cf_date tarih='attributes.voucher_duedate#k#'></cfif>
	</cfloop>
	<cfloop list="#ches#" index="i">
		<cfset ctr=0>
		<cfloop from="1" to="#attributes.record_num#" index="k">
			<cfif evaluate("attributes.row_kontrol#k#") and i eq evaluate("attributes.voucher_id#k#")>
			  <cfset ctr=1>
				<cfif evaluate("attributes.voucher_status_id#k#") eq 6>
					<cfquery name="UPD_VOUCHER" datasource="#dsn2#">
						UPDATE 
							VOUCHER
						SET
							COMPANY_ID = <cfif attributes.member_type eq "partner" and len(attributes.company_id)>#attributes.company_id#<cfelse>NULL</cfif>,
							CONSUMER_ID = <cfif attributes.member_type eq "consumer" and len(attributes.consumer_id)>#attributes.consumer_id#<cfelse>NULL</cfif>,
							EMPLOYEE_ID = <cfif attributes.member_type eq "employee" and len(attributes.employee_id)>#attributes.employee_id#<cfelse>NULL</cfif>,
							VOUCHER_DUEDATE=#evaluate("attributes.voucher_duedate#k#")#,
							VOUCHER_VALUE=#evaluate("attributes.voucher_value#k#")#,		
							VOUCHER_CITY = <cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.voucher_city#k#")#'>,
							VOUCHER_PURSE_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.portfoy_no#k#")#'>,
							CURRENCY_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.currency_id#k#")#'>,
							VOUCHER_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.voucher_no#k#")#'>,
							VOUCHER_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.voucher_code#k#")#'>,
							OTHER_MONEY_VALUE = <cfif len(evaluate("attributes.voucher_system_currency_value#k#"))>#evaluate("attributes.voucher_system_currency_value#k#")#,<cfelse>NULL,</cfif>
							OTHER_MONEY=<cfif len(evaluate("attributes.system_money_info#k#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.system_money_info#k#")#'>,<cfelse>NULL,</cfif>
							OTHER_MONEY_VALUE2 = <cfif len(evaluate("attributes.other_money_value2#k#"))>#evaluate("attributes.other_money_value2#k#")#,<cfelse>NULL,</cfif>
							OTHER_MONEY2=<cfif len(evaluate("attributes.other_money2#k#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.other_money2#k#")#'><cfelse>NULL</cfif>,
							CASH_ID = <cfif len(evaluate("attributes.cash_id#k#"))><cfqueryparam cfsqltype="cf_sql_integer" value='#wrk_eval("attributes.cash_id#k#")#'><cfelse>NULL</cfif>
						WHERE
							VOUCHER_ID=#evaluate("attributes.voucher_id#k#")#
					</cfquery>
					<cfquery name="del_voucher_money" datasource="#dsn2#">
						DELETE FROM VOUCHER_MONEY WHERE ACTION_ID = #evaluate("attributes.voucher_id#k#")#
					</cfquery>
					<cfif len(evaluate("attributes.money_list#k#"))>
						<cfloop from="1" to="#ListGetAt(evaluate("attributes.money_list#k#"),1,'-')#" index="j">
							<cfset money = ListGetAt(evaluate("attributes.money_list#k#"),j+1,'-')>
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
									#evaluate("attributes.voucher_id#k#")#,
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#ListGetAt(money,1,',')#">,
									#ListGetAt(money,3,',')#,					
									#ListGetAt(money,2,',')#,
									<cfif ListGetAt(money,1,',') is evaluate("attributes.currency_id#k#")>1<cfelse>0</cfif>
								)
							</cfquery>
						</cfloop>
					</cfif>
				</cfif>
			</cfif>
		</cfloop>
		<cfif ctr eq 0>
			<cfquery name="GET_VOUCHER_STATUS" datasource="#dsn2#">
				SELECT VOUCHER_STATUS_ID,VOUCHER_VALUE,CURRENCY_ID,OTHER_MONEY_VALUE,VOUCHER_DUEDATE FROM VOUCHER WHERE VOUCHER_ID=#i#
			</cfquery>
			<cfif GET_VOUCHER_STATUS.VOUCHER_STATUS_ID eq 4><!--- cirolu icin --->
				<cfquery name="UPD_VOUCHER" datasource="#dsn2#">
					UPDATE VOUCHER SET VOUCHER_STATUS_ID=1 WHERE VOUCHER_ID=#i#
				</cfquery>
			 <cfelseif GET_VOUCHER_STATUS.VOUCHER_STATUS_ID eq 6><!--- kendi senetlerimiz icin  --->
				<!--- acilis bordrolarina geri döndürüyoruz--->
				<cfquery name="GET_BORDRO_ID" datasource="#dsn2#">
					SELECT ACTION_ID FROM VOUCHER_PAYROLL WHERE PAYROLL_TYPE = 107 AND PAYROLL_NO = '-2'
				</cfquery>
				<cfif not GET_BORDRO_ID.recordcount>
					<cfquery name="ADD_REVENUE_TO_PAYROLL" datasource="#dsn2#">
						INSERT INTO
							VOUCHER_PAYROLL
							(
								PAYROLL_NO,
								PAYROLL_TOTAL_VALUE,
								NUMBER_OF_VOUCHER,
								CURRENCY_ID,
								PAYROLL_REVENUE_DATE,
								PAYROLL_TYPE,
								RECORD_EMP,
								RECORD_IP,
								RECORD_DATE
							)
							VALUES
							(
								'-2',
								<cfif GET_VOUCHER_STATUS.CURRENCY_ID is session.ep.money>
									#GET_VOUCHER_STATUS.VOUCHER_VALUE#,
								<cfelse>
									#GET_VOUCHER_STATUS.OTHER_MONEY_VALUE#,
								</cfif>
								1,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money#">,
								#CreateODBCDateTime(GET_VOUCHER_STATUS.VOUCHER_DUEDATE)#,
								107,
								#session.ep.userid#,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">,
								#NOW()#
							)
					</cfquery>
					<cfquery name="GET_BORDRO_ID" datasource="#dsn2#">
						SELECT MAX(ACTION_ID) AS ACTION_ID FROM VOUCHER_PAYROLL
					</cfquery>
				</cfif>
				<cfquery name="UPD_VOUCHER" datasource="#dsn2#">
					UPDATE VOUCHER SET VOUCHER_PAYROLL_ID=#GET_BORDRO_ID.ACTION_ID# WHERE VOUCHER_ID=#i#
				</cfquery>
			</cfif>
			<cfquery name="DEL_CHE_HIST" datasource="#dsn2#">
				DELETE FROM	VOUCHER_HISTORY WHERE VOUCHER_ID=#i# AND PAYROLL_ID=#attributes.ID#
			</cfquery>
		</cfif>
	</cfloop>
	<cfset portfoy_no = get_cheque_no(belge_tipi:'voucher')>
	<cfloop from="1" to="#attributes.record_num#" index="i">
		<cfif evaluate("attributes.row_kontrol#i#")>
			<cfset ctr=0>
			<cfloop list="#ches#" index="k">
				<cfif k eq evaluate("attributes.voucher_id#i#")>
					<cfset ctr=1>
				</cfif>
			</cfloop>
			<cfif ctr eq 0>
			<!--- wrk_not : db de ve session da bulanan senetlere daha yukarida islem yapilmisti simdi de db de olmayan ama 
				session a yeni eklenmis senetleri de isleyelim.
			--->
				<cfif evaluate("attributes.voucher_status_id#i#") eq 1><!--- portföydeki senet cirolanacak --->
					<cfquery name="UPD_VOUCHERS" datasource="#dsn2#">
						UPDATE VOUCHER SET VOUCHER_STATUS_ID=4 WHERE VOUCHER_ID= #evaluate("attributes.voucher_id#i#")#
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
									4,
									#attributes.PAYROLL_REVENUE_DATE#,
									<cfif len(evaluate("attributes.voucher_system_currency_value#i#"))>#evaluate("attributes.voucher_system_currency_value#i#")#,<cfelse>NULL,</cfif>
									<cfif len(evaluate("attributes.system_money_info#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.system_money_info#i#")#'>,<cfelse>NULL,</cfif>
									<cfif len(evaluate("attributes.other_money_value2#i#"))>#evaluate("attributes.other_money_value2#i#")#,<cfelse>NULL,</cfif>
									<cfif len(evaluate("attributes.other_money2#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.other_money2#i#")#'>,<cfelse>NULL,</cfif>
									#NOW()#
								)
					</cfquery>
				<cfelseif evaluate("attributes.voucher_status_id#i#") eq 6 and not len(evaluate("attributes.voucher_id#i#"))>
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
								DEBTOR_NAME, 
								VOUCHER_STATUS_ID,
								VOUCHER_CITY,
								VOUCHER_PURSE_NO,
								CURRENCY_ID,
								RECORD_EMP,
								RECORD_IP,
								RECORD_DATE,
								CH_OTHER_MONEY_VALUE,
								CH_OTHER_MONEY,
								CASH_ID
							)
							VALUES
							(
								#attributes.ID#,
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
								<cfif len(evaluate("attributes.debtor_name#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.debtor_name#i#")#'>,<cfelse>NULL,</cfif>
								6,
								<cfif len(evaluate("attributes.voucher_city#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.voucher_city#i#")#'>,<cfelse>NULL,</cfif>
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#portfoy_no#">,
								<cfif len(evaluate("attributes.currency_id#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.currency_id#i#")#'>,<cfelse>NULL,</cfif>
								#session.ep.userid#,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
								#NOW()#,
								#wrk_round((evaluate("attributes.voucher_system_currency_value#i#")/attributes.basket_money_rate),4)#,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.basket_money#">,
								<cfif len(evaluate("attributes.cash_id#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.cash_id#i#")#'><cfelse>NULL</cfif>
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
					<cfquery name="ADD_SELF_CHE_TO_HIST" datasource="#dsn2#">
						INSERT INTO
							VOUCHER_HISTORY
							(
								VOUCHER_ID,
								PAYROLL_ID,
								STATUS,
								COMPANY_ID,
								CONSUMER_ID,
								EMPLOYEE_ID,
								ACT_DATE,
								OTHER_MONEY_VALUE,
								OTHER_MONEY,
								OTHER_MONEY_VALUE2,
								OTHER_MONEY2,
								RECORD_DATE
							)
						VALUES
						(
								#GET_LAST_ID.VOUCHER_ID#,
								#attributes.ID#,
								6,
								<cfif attributes.member_type eq "partner" and len(attributes.company_id)>#attributes.company_id#<cfelse>NULL</cfif>,
								<cfif attributes.member_type eq "consumer" and len(attributes.consumer_id)>#attributes.consumer_id#<cfelse>NULL</cfif>,
								<cfif attributes.member_type eq "employee" and len(attributes.employee_id)>#attributes.employee_id#<cfelse>NULL</cfif>,
								#attributes.PAYROLL_REVENUE_DATE#,
								<cfif len(evaluate("attributes.voucher_system_currency_value#i#"))>#evaluate("attributes.voucher_system_currency_value#i#")#,<cfelse>NULL,</cfif>
								<cfif len(evaluate("attributes.system_money_info#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.system_money_info#i#")#'>,<cfelse>NULL,</cfif>
								<cfif len(evaluate("attributes.other_money_value2#i#"))>#evaluate("attributes.other_money_value2#i#")#,<cfelse>NULL,</cfif>
								<cfif len(evaluate("attributes.other_money2#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.other_money2#i#")#'>,<cfelse>NULL,</cfif>
								#NOW()#
						)
					</cfquery>
					<cfset portfoy_no = portfoy_no+1>
				<cfelseif evaluate("attributes.voucher_status_id#i#") eq 6 and len(evaluate("attributes.voucher_id#i#"))><!--- bir kendi senedimiz güncellenecek --->
					<cfquery name="UPD_VOUCHER" datasource="#dsn2#">
						UPDATE 
							VOUCHER
						SET
							COMPANY_ID = <cfif attributes.member_type eq "partner" and len(attributes.company_id)>#attributes.company_id#<cfelse>NULL</cfif>,
							CONSUMER_ID = <cfif attributes.member_type eq "consumer" and len(attributes.consumer_id)>#attributes.consumer_id#<cfelse>NULL</cfif>,
							EMPLOYEE_ID = <cfif attributes.member_type eq "employee" and len(attributes.employee_id)>#attributes.employee_id#<cfelse>NULL</cfif>,
							VOUCHER_DUEDATE=#evaluate("attributes.voucher_duedate#i#")#,
							VOUCHER_VALUE=#evaluate("attributes.voucher_value#i#")#,
							VOUCHER_CITY=<cfif len(evaluate("attributes.voucher_city#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.voucher_city#i#")#'>,<cfelse>NULL,</cfif>
							VOUCHER_PURSE_NO=<cfif len(evaluate("attributes.portfoy_no#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.portfoy_no#i#")#'>,<cfelse>NULL,</cfif>
							CURRENCY_ID=<cfif len(evaluate("attributes.currency_id#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.currency_id#i#")#'>,<cfelse>NULL,</cfif>
							VOUCHER_PAYROLL_ID=#attributes.ID#,
							VOUCHER_NO = <cfif len(evaluate("attributes.voucher_no#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.voucher_no#i#")#'>,<cfelse>NULL,</cfif>
							VOUCHER_CODE=<cfif len(evaluate("attributes.voucher_code#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.voucher_code#i#")#'>,<cfelse>NULL,</cfif>
							OTHER_MONEY_VALUE = <cfif len(evaluate("attributes.voucher_system_currency_value#i#"))>#evaluate("attributes.voucher_system_currency_value#i#")#,<cfelse>NULL,</cfif>
							OTHER_MONEY = <cfif len(evaluate("attributes.system_money_info#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.system_money_info#i#")#'>,<cfelse>NULL,</cfif>
							OTHER_MONEY_VALUE2 = <cfif len(evaluate("attributes.other_money_value2#i#"))>#evaluate("attributes.other_money_value2#i#")#,<cfelse>NULL,</cfif>
							OTHER_MONEY2 = <cfif len(evaluate("attributes.other_money2#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.other_money2#i#")#'><cfelse>NULL</cfif>,
							CH_OTHER_MONEY_VALUE=#wrk_round((evaluate("attributes.voucher_system_currency_value#i#")/attributes.basket_money_rate),4)#,
							CH_OTHER_MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.basket_money#">,
							CASH_ID = <cfif len(evaluate("attributes.cash_id#i#"))><cfqueryparam cfsqltype="cf_sql_int" value='#wrk_eval("attributes.cash_id#i#")#'><cfelse>NULL</cfif>
						WHERE
							VOUCHER_ID=#evaluate("attributes.voucher_id#i#")#
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
					<cfquery name="ADD_SELF_CHE_TO_HIST" datasource="#dsn2#">
						INSERT INTO
							VOUCHER_HISTORY
							(
								VOUCHER_ID,
								PAYROLL_ID,
								STATUS,
								COMPANY_ID,
								CONSUMER_ID,
								EMPLOYEE_ID,
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
								6,
								<cfif attributes.member_type eq "partner" and len(attributes.company_id)>#attributes.company_id#<cfelse>NULL</cfif>,
								<cfif attributes.member_type eq "consumer" and len(attributes.consumer_id)>#attributes.consumer_id#<cfelse>NULL</cfif>,
								<cfif attributes.member_type eq "employee" and len(attributes.employee_id)>#attributes.employee_id#<cfelse>NULL</cfif>,
								#attributes.PAYROLL_REVENUE_DATE#,
								<cfif len(evaluate("attributes.voucher_system_currency_value#i#"))>#evaluate("attributes.voucher_system_currency_value#i#")#,<cfelse>NULL,</cfif>
								<cfif len(evaluate("attributes.system_money_info#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.system_money_info#i#")#'>,<cfelse>NULL,</cfif>
								<cfif len(evaluate("attributes.other_money_value2#i#"))>#evaluate("attributes.other_money_value2#i#")#,<cfelse>NULL,</cfif>
								<cfif len(evaluate("attributes.other_money2#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.other_money2#i#")#'>,<cfelse>NULL,</cfif>
								#NOW()#
							)
					</cfquery>
				</cfif>
			<cfelseif ctr eq 1>
				<cfquery name="UPD_VOUCHER_HISTORY" datasource="#dsn2#">
					UPDATE 
						VOUCHER_HISTORY
					SET 
						ACT_DATE = #attributes.PAYROLL_REVENUE_DATE#,
						OTHER_MONEY_VALUE = <cfif len(evaluate("attributes.voucher_system_currency_value#i#"))>#evaluate("attributes.voucher_system_currency_value#i#")#,<cfelse>NULL,</cfif>
						OTHER_MONEY = <cfif len(evaluate("attributes.system_money_info#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.system_money_info#i#")#'>,<cfelse>NULL,</cfif>
						OTHER_MONEY_VALUE2 = <cfif len(evaluate("attributes.other_money_value2#i#"))>#evaluate("attributes.other_money_value2#i#")#,<cfelse>NULL,</cfif>
						OTHER_MONEY2 = <cfif len(evaluate("attributes.other_money2#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.other_money2#i#")#'><cfelse>NULL</cfif>
					WHERE 
						VOUCHER_ID= #evaluate("attributes.voucher_id#i#")# AND
						PAYROLL_ID = #attributes.ID#
				</cfquery>
			</cfif>
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
			AND PAYROLL_ID=#attributes.ID#
	</cfquery>
	<cfset last_voucher_list = valuelist(GET_VOUCHERS_LAST.VOUCHER_NO)>
	<cfset ches_2 = old_voucher_list>
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
		if(is_cari eq 1 or is_account eq 1)
		{ /*bordrodan cıkarılan senetler bulunuyor*/
			for(cheq_x=1; cheq_x lte attributes.record_num; cheq_x=cheq_x+1)
			{
				if(evaluate("attributes.row_kontrol#cheq_x#") and ListFindNoCase(ches_2,evaluate("attributes.voucher_id#cheq_x#")))
					ches_2 = ListDeleteAt(ches_2,ListFindNoCase(ches_2,evaluate("attributes.voucher_id#cheq_x#"), ','), ',');
			}
		}
		if (is_cari eq 1)
		{
			if(is_voucher_based eq 1) /*islem kategorisinde cek bazında carici secili*/
				{
					if(attributes.payroll_acc_cari_voucher_based eq 1)
					{ /*senetlerin cari hareketleri siliniyor*/
						for(cheq_n=1;cheq_n lte listlen(ches_2);cheq_n=cheq_n+1)
							cari_sil(action_id:listgetat(ches_2,cheq_n,','),action_table:'VOUCHER',process_type:form.old_process_type,payroll_id :attributes.id);
					}
					else if(attributes.payroll_acc_cari_voucher_based neq 1)  //bordro ilk eklendiginde carici bordro bazında calıstırılmıs ise, silinir
						cari_sil(action_id:attributes.id,action_table:'VOUCHER_PAYROLL',process_type:form.old_process_type);
					
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
							if(len(evaluate("attributes.voucher_id#cheq_i#")))
								my_obj_val = evaluate("attributes.voucher_id#cheq_i#");
							else
								my_obj_val = GET_VOUCHERS_LAST.VOUCHER_ID[listfind(last_voucher_list,evaluate("attributes.voucher_no#cheq_i#"))]; 
							GET_VOUCHER_STATUS=cfquery(datasource:"#dsn2#",sqlstring:"
							SELECT VOUCHER_STATUS_ID FROM VOUCHER WHERE VOUCHER_ID=#my_obj_val#");
							carici(
								action_id :iif(len(evaluate("attributes.voucher_id#cheq_i#")),'evaluate("attributes.voucher_id#cheq_i#")','GET_VOUCHERS_LAST.VOUCHER_ID[listfind(last_voucher_list,evaluate("attributes.voucher_no#cheq_i#"))]'),
								action_table :'VOUCHER',
								process_cat :form.process_cat,
								workcube_process_type :process_type,
								workcube_old_process_type :form.old_process_type,
								account_card_type :13,
								islem_tarihi :attributes.PAYROLL_REVENUE_DATE,
								islem_tutari : evaluate("attributes.voucher_system_currency_value#cheq_i#"),
								other_money_value : other_money_value,
								other_money : other_money,
								islem_belge_no :iif(len(evaluate("attributes.voucher_no#cheq_i#")),evaluate("attributes.voucher_no#cheq_i#"),de('')),
								due_date : iif(len(GET_VOUCHERS_LAST.VOUCHER_DUEDATE[listfind(last_voucher_list,evaluate("attributes.voucher_no#cheq_i#"))]),'createodbcdatetime(GET_VOUCHERS_LAST.VOUCHER_DUEDATE[listfind(last_voucher_list,evaluate("attributes.voucher_no#cheq_i#"))])','attributes.pyrll_avg_duedate'),
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
								payroll_id :attributes.id,
								special_definition_id : iif((isdefined("attributes.special_definition_id") and len(attributes.special_definition_id)),'attributes.special_definition_id',de('')),
								assetp_id : iif((isdefined("attributes.asset_id") and len(attributes.asset_id) and len(attributes.asset_name)),'attributes.asset_id',de('')),
								is_upd_other_value : iif(GET_VOUCHER_STATUS.VOUCHER_STATUS_ID eq 7,is_upd_cari_row,0),//işlem kategrnsdeki extre güncelleme işlemnde dövizleri tekrar değiştirmesn
								rate2:paper_currency_multiplier
								);
						}
					}
				}
				else
				{
				   if(attributes.payroll_acc_cari_voucher_based eq 1)
					{ /*bordro ilk kaydedildiginde senet bazında cari islem yapılmıssa bu cari hareketler silinir*/
						for(cheq_k=1;cheq_k lte listlen(old_voucher_list);cheq_k=cheq_k+1)
							cari_sil(action_id:listgetat(old_voucher_list,cheq_k,','),action_table:'VOUCHER',process_type:form.old_process_type,payroll_id :attributes.id);
					}
					carici(
						action_id :attributes.id,
						action_table :'VOUCHER_PAYROLL',
						process_cat :form.process_cat,
						workcube_process_type :process_type,
						workcube_old_process_type :form.old_process_type,
						account_card_type :13,
						islem_tarihi :attributes.PAYROLL_REVENUE_DATE,
						islem_tutari :attributes.payroll_total,
						islem_belge_no :attributes.payroll_no,
						other_money_value : iif(len(attributes.other_payroll_total),'attributes.other_payroll_total',de('')),
						other_money : iif(len(form.basket_money),'form.basket_money',de('')),
						due_date : attributes.pyrll_avg_duedate,
						payer_id : attributes.pro_employee_id,
						to_cmp_id : iif(attributes.member_type eq "partner",'attributes.company_id',de('')),
						to_consumer_id : iif(attributes.member_type eq "consumer",'attributes.consumer_id',de('')),
						to_employee_id : iif(attributes.member_type eq "employee",'attributes.employee_id',de('')),
						islem_detay : 'SENET ÇIKIŞ BORDROSU(CİRO)',
						acc_type_id : attributes.acc_type_id,
						action_detail : attributes.action_detail,
						currency_multiplier : currency_multiplier,
						belge_no : form.payroll_no,
						project_id : attributes.project_id,
						special_definition_id : iif((isdefined("attributes.special_definition_id") and len(attributes.special_definition_id)),'attributes.special_definition_id',de('')),
						assetp_id : iif((isdefined("attributes.asset_id") and len(attributes.asset_id) and len(attributes.asset_name)),'attributes.asset_id',de('')),
						from_branch_id : branch_id_info,
						rate2:paper_currency_multiplier
						);
				}
		  }
		else/*işlem kategorilerinde cari işlem seçili değilse önceki kayıtlar siliniyor*/
			{
				if(attributes.payroll_acc_cari_voucher_based eq 1) /*bordro kaydedilirken cari-muhasebe hareketleri senet bazında yapılmış ise her bir senet icin olusturulmus cari hareket siliniyor*/
				{
					for(che_q=1;che_q lte listlen(old_voucher_list);che_q=che_q+1)
						cari_sil(action_id:listgetat(old_voucher_list,che_q,','),action_table:'VOUCHER',process_type:form.old_process_type,payroll_id :attributes.id);	
				}
				else /*bordro bazında cari hareket siliniyor*/
					cari_sil(action_id:attributes.id,action_table:'VOUCHER_PAYROLL',process_type:form.old_process_type);
			}
		if (is_account eq 1)
		{
			if(is_voucher_based_acc neq 1)	/*standart muhasebe islemleri yapılıyor*/
			{
				alacak_tutarlar = '';
				alacak_hesaplar = '';
				other_currency_alacak_list= '';
				other_amount_alacak_list= '';
				for(tt=1; tt lte attributes.record_num; tt=tt+1)
				{
					if (evaluate("attributes.row_kontrol#tt#"))
					{
						if (evaluate("attributes.currency_id#tt#") eq session.ep.money)
							alacak_tutarlar=listappend(alacak_tutarlar,evaluate("attributes.voucher_value#tt#"),',');
						else
							alacak_tutarlar=listappend(alacak_tutarlar,evaluate("attributes.voucher_system_currency_value#tt#"),',');
						other_amount_alacak_list = listappend(other_amount_alacak_list,evaluate("attributes.voucher_value#tt#"),',');
						other_currency_alacak_list = listappend(other_currency_alacak_list,evaluate("attributes.currency_id#tt#"),',');
						if(len(evaluate("attributes.acc_code#tt#")))//özel muhasebe hesabı secilmis ise
							alacak_hesaplar=listappend(alacak_hesaplar,evaluate("attributes.acc_code#tt#"),',');
						else if(listfind('6,7,8,9',evaluate("attributes.voucher_status_id#tt#"),','))//bizim banka id lerimizin muh hesabini bulalim yani bizim senedimiz icin
						{	
							GET_V_ACC_CODE = cfquery(datasource:"#dsn2#",sqlstring:"
								SELECT 
									V_VOUCHER_ACC_CODE
								FROM
									CASH C
								WHERE
									C.CASH_ID=#evaluate("attributes.cash_id#tt#")#");
							alacak_hesaplar=listappend(alacak_hesaplar ,GET_V_ACC_CODE.V_VOUCHER_ACC_CODE, ',');
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
									CH.VOUCHER_ID=#evaluate("attributes.voucher_id#tt#")#");
							if(GET_ACC_CODE.recordcount eq 0)
							{
								GET_ACC_CODE=cfquery(datasource:"#dsn2#", sqlstring:"
									SELECT
									C.A_VOUCHER_ACC_CODE
								FROM
									VOUCHER_PAYROLL AS VP,
									VOUCHER_HISTORY AS VH,
									CASH AS C
								WHERE
									VP.PAYROLL_CASH_ID = C.CASH_ID AND
									VP.PAYROLL_TYPE IN (97,107,109) AND
									VP.ACTION_ID= VH.PAYROLL_ID AND
									VH.VOUCHER_ID=#evaluate("attributes.voucher_id#tt#")#");
							}
							alacak_hesaplar=listappend(alacak_hesaplar, GET_ACC_CODE.A_VOUCHER_ACC_CODE, ',');
						}
						if (is_account_group neq 1)
						{
							if (isDefined("attributes.action_detail") and len(attributes.action_detail))
								str_card_detail[2][listlen(alacak_tutarlar)] = ' #evaluate("attributes.voucher_no#tt#")# - #attributes.company_name# - #attributes.action_detail#';
							else
								str_card_detail[2][listlen(alacak_tutarlar)] = ' #evaluate("attributes.voucher_no#tt#")# - #attributes.company_name# - SENET ÇIKIŞ İŞLEMİ';
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
					action_id:attributes.ID,
					workcube_process_type:process_type,
					workcube_old_process_type :form.old_process_type,
					account_card_type:13,
					action_table :'VOUCHER_PAYROLL',
					islem_tarihi:attributes.PAYROLL_REVENUE_DATE,
					company_id : iif(attributes.member_type eq "partner",'attributes.company_id',de('')),
					consumer_id : iif(attributes.member_type eq "consumer",'attributes.consumer_id',de('')),
					employee_id : iif(attributes.member_type eq "employee",'attributes.employee_id',de('')),
					borc_hesaplar:acc,
					borc_tutarlar: attributes.payroll_total,
					other_amount_borc : iif(len(attributes.other_payroll_total),'attributes.other_payroll_total',de('')),
					other_currency_borc : iif(len(attributes.basket_money),'attributes.basket_money',de('')),
					alacak_hesaplar : alacak_hesaplar,
					alacak_tutarlar : alacak_tutarlar,
					other_amount_alacak : other_amount_alacak_list,
					other_currency_alacak : other_currency_alacak_list,
					belge_no : form.payroll_no,
					currency_multiplier : currency_multiplier,
					fis_detay : 'SENET ÇIKIŞ İŞLEMİ',
					fis_satir_detay : str_card_detail,
					from_branch_id : branch_id_info,
					workcube_process_cat : form.process_cat,
					acc_project_id : attributes.project_id,
					is_account_group : is_account_group
				);
			}
			else		/*e-deftere uygun muhasebe islemleri yapılıyor*/
			{
				// tum muhasebe kayıtlari silinir sonra yaniden eklenir.
				muhasebe_sil(action_id:attributes.id,action_table:'VOUCHER_PAYROLL',process_type:form.old_process_type);
				
				alacak_tutarlar = '';
				alacak_hesaplar = '';
				other_currency_alacak_list= '';
				other_amount_alacak_list= '';
				for(i=1; i lte GET_VOUCHERS_LAST.recordcount; i=i+1)
				{
					if(GET_VOUCHERS_LAST.CURRENCY_ID[i] neq session.ep.money)
						alacak_tutarlar = GET_VOUCHERS_LAST.OTHER_MONEY_VALUE_LAST[i];
					else
						alacak_tutarlar = GET_VOUCHERS_LAST.VOUCHER_VALUE[i];
					
					if(len(GET_VOUCHERS_LAST.ACCOUNT_CODE[i]))//özel muhasebe hesabı secilmis ise
						alacak_hesaplar = GET_VOUCHERS_LAST.ACCOUNT_CODE[i];
					else if(listfind('6,7,8,9',GET_VOUCHERS_LAST.VOUCHER_STATUS_ID[i],','))//bizim banka id lerimizin muh hesabini bulalim yani bizim senedimiz icin
					{	
						GET_V_ACC_CODE = cfquery(datasource:"#dsn2#",sqlstring:"
							SELECT 
								V_VOUCHER_ACC_CODE
							FROM
								CASH C
							WHERE
								C.CASH_ID=#GET_VOUCHERS_LAST.CASH_ID[i]#");
						alacak_hesaplar = GET_V_ACC_CODE.V_VOUCHER_ACC_CODE;
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
								CH.VOUCHER_ID=#GET_VOUCHERS_LAST.VOUCHER_ID[i]#");
						if(GET_ACC_CODE.recordcount eq 0)
						{
							GET_ACC_CODE=cfquery(datasource:"#dsn2#", sqlstring:"
								SELECT
								C.A_VOUCHER_ACC_CODE
							FROM
								VOUCHER_PAYROLL AS VP,
								VOUCHER_HISTORY AS VH,
								CASH AS C
							WHERE
								VP.PAYROLL_CASH_ID = C.CASH_ID AND
								VP.PAYROLL_TYPE IN (97,107,109) AND
								VP.ACTION_ID= VH.PAYROLL_ID AND
								VH.VOUCHER_ID=#GET_VOUCHERS_LAST.VOUCHER_ID[i]#");
						}
						alacak_hesaplar = GET_ACC_CODE.A_VOUCHER_ACC_CODE;
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
						action_id:attributes.ID,
						action_row_id : GET_VOUCHERS_LAST.VOUCHER_ID[i],
						due_date :iif(len(GET_VOUCHERS_LAST.VOUCHER_DUEDATE[i]),'createodbcdatetime(GET_VOUCHERS_LAST.VOUCHER_DUEDATE[i])','attributes.pyrll_avg_duedate'),
						workcube_process_type:process_type,
						workcube_old_process_type :form.old_process_type,
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
						belge_no : GET_VOUCHERS_LAST.VOUCHER_NO[i],
						currency_multiplier : currency_multiplier,
						fis_detay : 'SENET ÇIKIŞ İŞLEMİ',
						fis_satir_detay : str_card_detail,
						from_branch_id : branch_id_info,
						workcube_process_cat : form.process_cat,
						acc_project_id : attributes.project_id,
						is_account_group : is_account_group
					);	
				}
			}
		}
		else/*İşlem kategorismde muhasebe seçili değilse önceki kayıtlar silinir*/
		{
			muhasebe_sil(action_id:attributes.id,action_table:'VOUCHER_PAYROLL',process_type:form.old_process_type);
		}
		basket_kur_ekle(action_id:attributes.id,table_type_id:12,process_type:1);
	</cfscript>
    <cf_workcube_process_cat 
        process_cat="#form.process_cat#"
        action_id = #attributes.ID#
        is_action_file = 1
        action_db_type = '#dsn2#'
        action_page='#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_upd_payroll_voucher_endorsement&id=#attributes.ID#'
        action_file_name='#get_process_type.action_file_name#'
        is_template_action_file = '#get_process_type.action_file_from_template#'>
    <cf_add_log employee_id="#session.ep.userid#" log_type="0" action_id="#attributes.id#" action_name="#PAYROLL_NO# Güncellendi" paper_no="#PAYROLL_NO#" period_id="#session.ep.period_id#"  process_type="#get_process_type.PROCESS_TYPE#" data_source="#dsn2#">
	</cftransaction>
</cflock>
<script type="text/javascript">
	window.location.href="<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_add_voucher_payroll_endorsement&event=upd&ID=#attributes.ID#</cfoutput>";
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
