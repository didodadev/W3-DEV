<cfif form.active_period neq session.ep.period_id>
	<script type="text/javascript">
		alert("İşlem Yapmak İstediğiniz Muhasebe Dönemi ile Aktif Muhasebe Döneminiz Farklı Muhasebe Döneminizi Kontrol Ediniz!");
		wrk_opener_reload();
		window.close();
	</script>
	<cfabort>
</cfif>
<cf_get_lang_set module_name="cheque">
<cf_date tarih='attributes.PAYROLL_REVENUE_DATE'>
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
<cfquery name="CONTROL_NO" datasource="#DSN2#">
	SELECT ACTION_ID FROM PAYROLL WHERE PAYROLL_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#PAYROLL_NO#"> AND ACTION_ID <> #attributes.id#
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
<!--- update payroll--->
<cflock name="#createUUID()#" timeout="60">
	<cftransaction>
		<cfquery name="UPD_PAYROLL" datasource="#dsn2#">
			UPDATE 
				PAYROLL
			SET
				PROCESS_CAT = #form.process_cat#,
				PAYROLL_TYPE = #process_type#,
				COMPANY_ID = <cfif attributes.member_type eq "partner" and len(attributes.company_id)>#attributes.company_id#<cfelse>NULL</cfif>,
				CONSUMER_ID = <cfif attributes.member_type eq "consumer" and len(attributes.consumer_id)>#attributes.consumer_id#<cfelse>NULL</cfif>,
				EMPLOYEE_ID = <cfif attributes.member_type eq "employee" and len(attributes.employee_id)>#attributes.employee_id#<cfelse>NULL</cfif>,
				PAYROLL_TOTAL_VALUE = #attributes.payroll_total#,
				PAYROLL_OTHER_MONEY = <cfif isdefined("attributes.basket_money") and len(attributes.basket_money)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.basket_money#"><cfelse>NULL</cfif>,
				PAYROLL_OTHER_MONEY_VALUE = <cfif isdefined("attributes.other_payroll_total") and len(attributes.other_payroll_total)>#attributes.other_payroll_total#<cfelse>NULL</cfif>,
				PAYROLL_REVENUE_DATE = #attributes.PAYROLL_REVENUE_DATE#,
				PROJECT_ID = <cfif len(attributes.project_name) and len(attributes.project_id)>#attributes.project_id#<cfelse>NULL</cfif>,
				NUMBER_OF_CHEQUE = #attributes.cheque_num#,
				PAYROLL_AVG_DUEDATE = <cfif len(attributes.pyrll_avg_duedate)>#attributes.pyrll_avg_duedate#,<cfelse>NULL,</cfif>
				PAYROLL_AVG_AGE = <cfif len(attributes.pyrll_avg_age)>#attributes.pyrll_avg_age#,<cfelse>NULL,</cfif>
				PAYROLL_REV_MEMBER = #attributes.pro_employee_id#,
				CHEQUE_BASED_ACC_CARI = <cfif len(is_cheque_based)>#is_cheque_based#<cfelse>0</cfif>,
				PAYROLL_NO = <cfif len(attributes.payroll_no)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.payroll_no#">,<cfelse>NULL,</cfif>
				BRANCH_ID = #branch_id_info#,
				UPDATE_EMP = #session.ep.userid#,
				UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">,
				UPDATE_DATE = #NOW()#,
				ACTION_DETAIL = <cfif isDefined("attributes.action_detail") and len(attributes.action_detail)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.action_detail#"><cfelse>NULL</cfif>,
				SPECIAL_DEFINITION_ID = <cfif isdefined("attributes.special_definition_id") and len(attributes.special_definition_id)>#attributes.special_definition_id#<cfelse>NULL</cfif>,
				ASSETP_ID = <cfif isdefined("attributes.asset_id") and len(attributes.asset_id) and len(attributes.asset_name)>#attributes.asset_id#<cfelse>NULL</cfif>,
				CONTRACT_ID = <cfif isdefined("attributes.contract_id") and len(attributes.contract_id) and len(attributes.contract_head)>#attributes.contract_id#<cfelse>NULL</cfif>,
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
				<cfif i eq evaluate("attributes.cheque_id#k#") and evaluate("attributes.row_kontrol#k#")>
					<cfset ctr=1>
					<cfif evaluate("attributes.cheque_status_id#k#") eq 6>
						<cf_date tarih='attributes.cheque_duedate#k#'>
						<cfquery name="UPD_CHEQUE" datasource="#dsn2#">
							UPDATE 
								CHEQUE
							SET
								COMPANY_ID = <cfif attributes.member_type eq "partner" and len(attributes.company_id)>#attributes.company_id#<cfelse>NULL</cfif>,
								CONSUMER_ID = <cfif attributes.member_type eq "consumer" and len(attributes.consumer_id)>#attributes.consumer_id#<cfelse>NULL</cfif>,
								EMPLOYEE_ID = <cfif attributes.member_type eq "employee" and len(attributes.employee_id)>#attributes.employee_id#<cfelse>NULL</cfif>,
								CHEQUE_DUEDATE = <cfif len(evaluate("attributes.cheque_duedate#k#"))>#evaluate("attributes.cheque_duedate#k#")#,<cfelse>NULL,</cfif>
								ACCOUNT_ID = <cfif len(evaluate("attributes.account_id#k#"))>#wrk_eval("attributes.account_id#k#")#,<cfelse>NULL,</cfif>
								ACCOUNT_NO = <cfif len(evaluate("attributes.account_no#k#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.account_no#k#")#'>,<cfelse>NULL,</cfif>
								BANK_NAME = <cfif len(evaluate("attributes.bank_name#k#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.bank_name#k#")#'>,<cfelse>NULL,</cfif>
								BANK_BRANCH_NAME = <cfif len(evaluate("attributes.bank_branch_name#k#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.bank_branch_name#k#")#'>,<cfelse>NULL,</cfif>
								CHEQUE_VALUE = #evaluate("attributes.cheque_value#k#")#,
								CHEQUE_CITY = <cfif len(evaluate("attributes.cheque_city#k#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.cheque_city#k#")#'>,<cfelse>NULL,</cfif>
								CHEQUE_PURSE_NO = <cfif len(evaluate("attributes.portfoy_no#k#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.portfoy_no#k#")#'>,<cfelse>NULL,</cfif>
								CURRENCY_ID = <cfif len(evaluate("attributes.currency_id#k#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.currency_id#k#")#'>,<cfelse>NULL,</cfif>
								DEBTOR_NAME = <cfif len(evaluate("attributes.debtor_name#k#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.debtor_name#k#")#'>,<cfelse>NULL,</cfif>
								CHEQUE_NO = <cfif len(evaluate("attributes.cheque_no#k#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.cheque_no#k#")#'>,<cfelse>NULL,</cfif>
								CHEQUE_CODE = <cfif len(evaluate("attributes.cheque_code#k#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.cheque_code#k#")#'>,<cfelse>NULL,</cfif>
								OTHER_MONEY_VALUE = <cfif len(evaluate("attributes.cheque_system_currency_value#k#"))>#evaluate("attributes.cheque_system_currency_value#k#")#<cfelse>NULL</cfif>,
								OTHER_MONEY = <cfif len(evaluate("attributes.system_money_info#k#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.system_money_info#k#")#'><cfelse>NULL</cfif>,
								OTHER_MONEY_VALUE2 = <cfif len(evaluate("attributes.other_money_value2#k#"))>#evaluate("attributes.other_money_value2#k#")#<cfelse>NULL</cfif>,
								OTHER_MONEY2 = <cfif len(evaluate("attributes.other_money2#k#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.other_money2#k#")#'><cfelse>NULL</cfif>
							WHERE
								CHEQUE_ID = #evaluate("attributes.cheque_id#k#")#
						</cfquery>
						<cfquery name="del_cheque_money" datasource="#dsn2#">
							DELETE FROM CHEQUE_MONEY WHERE ACTION_ID = #evaluate("attributes.cheque_id#k#")#
						</cfquery>
						<cfif len(evaluate("attributes.money_list#k#"))>
							<cfloop from="1" to="#ListGetAt(evaluate("attributes.money_list#k#"),1,'-')#" index="j">
								<cfset money = ListGetAt(evaluate("attributes.money_list#k#"),j+1,'-')>
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
										#evaluate("attributes.cheque_id#k#")#,
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
				<!--- wrk_not : çek ciro bordrosundan cikarilmis ama eskiden bu bordroya dahilmis bu durumda ;
				1-cirolu bir cek ise portföyde durumuna geri dönecek,
				2-kendi cekimiz ise yine cikis bordrolarina bagli olmayan aylak ceklere dönecek
				--->
				<cfquery name="GET_CHEQUE_STATUS" datasource="#dsn2#">
					SELECT CHEQUE_STATUS_ID,CHEQUE_VALUE,CURRENCY_ID,OTHER_MONEY_VALUE,CHEQUE_DUEDATE FROM CHEQUE WHERE CHEQUE_ID=#i#
				</cfquery>
				<cfif GET_CHEQUE_STATUS.CHEQUE_STATUS_ID eq 4><!--- cirolu icin --->
					<cfquery name="UPD_CHEQUE" datasource="#dsn2#">
						UPDATE CHEQUE SET CHEQUE_STATUS_ID=1 WHERE CHEQUE_ID=#i#
					</cfquery>
				<cfelseif GET_CHEQUE_STATUS.CHEQUE_STATUS_ID eq 6><!--- kendi ceklerimiz icin  --->
					<!--- acilis bordrolarina geri döndürüyoruz--->
					<cfquery name="GET_BORDRO_ID" datasource="#dsn2#">
						SELECT ACTION_ID FROM PAYROLL WHERE PAYROLL_TYPE = 106 AND PAYROLL_NO = '-2'
					</cfquery>
					<cfif not GET_BORDRO_ID.recordcount>
						<cfquery name="ADD_REVENUE_TO_PAYROLL" datasource="#dsn2#">
							INSERT INTO
								PAYROLL(
									PAYROLL_NO,
									PAYROLL_TOTAL_VALUE,
									NUMBER_OF_CHEQUE,
									CURRENCY_ID,
									PAYROLL_REVENUE_DATE,
									PAYROLL_TYPE,
									RECORD_EMP,
									RECORD_IP,
									RECORD_DATE
								)
								VALUES(
									'-2',
								<cfif GET_CHEQUE_STATUS.CURRENCY_ID is session.ep.money>
									#GET_CHEQUE_STATUS.CHEQUE_VALUE#,
								<cfelse>
									#GET_CHEQUE_STATUS.OTHER_MONEY_VALUE#,
								</cfif>
									1,
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money#">,
									#createodbcdate(GET_CHEQUE_STATUS.CHEQUE_DUEDATE)#,
									106,
									#session.ep.userid#,
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">,
									#NOW()#
								)
						</cfquery>
						<cfquery name="GET_BORDRO_ID" datasource="#dsn2#">
							SELECT MAX(ACTION_ID) AS ACTION_ID FROM PAYROLL
						</cfquery>
					</cfif>
					<cfquery name="UPD_CHEQUE" datasource="#dsn2#">
						UPDATE CHEQUE SET CHEQUE_PAYROLL_ID=#GET_BORDRO_ID.ACTION_ID# WHERE CHEQUE_ID=#i#
					</cfquery>
				</cfif>
				<cfquery name="DEL_CHE_HIST" datasource="#dsn2#">
					DELETE FROM	CHEQUE_HISTORY WHERE CHEQUE_ID=#i# AND PAYROLL_ID=#attributes.id#
				</cfquery>
			</cfif>
		</cfloop>
		<cfset portfoy_no = get_cheque_no(belge_tipi:'cheque')>
		<cfloop from="1" to="#attributes.record_num#" index="i">
			<cfif evaluate("attributes.row_kontrol#i#")>
				<cfset ctr=0>
				<cfloop list="#ches#" index="k">
					<cfif k eq evaluate("attributes.cheque_id#i#")>
						<cfset ctr=1>
					</cfif>
				</cfloop>
				<cfif ctr eq 0>
				<!--- wrk_not : db de ve session da bulanan ceklere daha yukarida islem yapilmisti simdi de db de olmayan ama 
					session a yeni eklenmis cekleri de isleyelim.
				--->
				<cfif evaluate("attributes.cheque_status_id#i#") eq 1><!--- portföydeki cek cirolanacak --->
					<cfquery name="UPD_CHEQUES" datasource="#dsn2#">
						UPDATE CHEQUE SET CHEQUE_STATUS_ID=4 WHERE CHEQUE_ID= #evaluate("attributes.cheque_id#i#")#
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
									4,
									#attributes.PAYROLL_REVENUE_DATE#,
									<cfif len(evaluate("attributes.cheque_system_currency_value#i#"))>#evaluate("attributes.cheque_system_currency_value#i#")#,<cfelse>NULL,</cfif>
									<cfif len(evaluate("attributes.system_money_info#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.system_money_info#i#")#'>,<cfelse>NULL,</cfif>
									<cfif len(evaluate("attributes.other_money_value2#i#"))>#evaluate("attributes.other_money_value2#i#")#,<cfelse>NULL,</cfif>
									<cfif len(evaluate("attributes.other_money2#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.other_money2#i#")#'>,<cfelse>NULL,</cfif>
									#NOW()#
								)
					</cfquery>
				<cfelseif evaluate("attributes.cheque_status_id#i#") eq 6 and (not len(evaluate("attributes.cheque_id#i#")))><!--- yeni bir kendi cekimiz eklenecek --->
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
								DEBTOR_NAME, 
								CHEQUE_STATUS_ID,
								BANK_NAME,
								BANK_BRANCH_NAME,
								ACCOUNT_ID,
								ACCOUNT_NO,
								CHEQUE_CITY,
								CHEQUE_PURSE_NO,
								CURRENCY_ID,
								RECORD_EMP,
								RECORD_IP,
								RECORD_DATE,
								CH_OTHER_MONEY_VALUE,
								CH_OTHER_MONEY
							)
							VALUES
							(
								#attributes.id#,
								<cfif attributes.member_type eq "partner" and len(attributes.company_id)>#attributes.company_id#<cfelse>NULL</cfif>,
								<cfif attributes.member_type eq "consumer" and len(attributes.consumer_id)>#attributes.consumer_id#<cfelse>NULL</cfif>,
								<cfif attributes.member_type eq "employee" and len(attributes.employee_id)>#attributes.employee_id#<cfelse>NULL</cfif>,
								<cfif len(evaluate("attributes.cheque_code#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.cheque_code#i#")#'>,<cfelse>NULL,</cfif>
								#evaluate("attributes.cheque_duedate#i#")#,
								<cfif len(evaluate("attributes.cheque_no#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.cheque_no#i#")#'>,<cfelse>NULL,</cfif>
								#evaluate("attributes.cheque_value#i#")#,
								<cfif len(evaluate("attributes.cheque_system_currency_value#i#"))>#evaluate("attributes.cheque_system_currency_value#i#")#,<cfelse>NULL,</cfif>
								<cfif len(evaluate("attributes.system_money_info#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.system_money_info#i#")#'>,<cfelse>NULL,</cfif>
								<cfif len(evaluate("attributes.other_money_value2#i#"))>#evaluate("attributes.other_money_value2#i#")#,<cfelse>NULL,</cfif>
								<cfif len(evaluate("attributes.other_money2#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.other_money2#i#")#'>,<cfelse>NULL,</cfif>
								<cfif len(evaluate("attributes.debtor_name#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.debtor_name#i#")#'>,<cfelse>NULL,</cfif>
								6,
								<cfif len(evaluate("attributes.bank_name#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.bank_name#i#")#'>,<cfelse>NULL,</cfif>
								<cfif len(evaluate("attributes.bank_branch_name#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.bank_branch_name#i#")#'>,<cfelse>NULL,</cfif>
								<cfif len(evaluate("attributes.account_id#i#"))>#wrk_eval("attributes.account_id#i#")#,<cfelse>NULL,</cfif>
								<cfif len(evaluate("attributes.account_no#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.account_no#i#")#'>,<cfelse>NULL,</cfif>
								<cfif len(evaluate("attributes.cheque_city#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.cheque_city#i#")#'>,<cfelse>NULL,</cfif>
								<cfqueryparam cfsqltype="cf_sql_varchar" value='#portfoy_no#'>,
								<cfif len(evaluate("attributes.currency_id#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.currency_id#i#")#'>,<cfelse>NULL,</cfif>
								#session.ep.userid#,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
								#now()#,
								#wrk_round((evaluate("attributes.cheque_system_currency_value#i#")/attributes.basket_money_rate),4)#,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.basket_money#">
							)
					</cfquery>
					<cfquery name="GET_LAST_ID" datasource="#dsn2#">
						SELECT MAX(CHEQUE_ID) AS CHEQUE_ID FROM CHEQUE
					</cfquery>
					<cfquery name="ADD_SELF_CHE_TO_HIST" datasource="#dsn2#">
						INSERT INTO
							CHEQUE_HISTORY
							(
								CHEQUE_ID,
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
								#GET_LAST_ID.CHEQUE_ID#,
								#attributes.id#,
								6,
								<cfif attributes.member_type eq "partner" and len(attributes.company_id)>#attributes.company_id#<cfelse>NULL</cfif>,
								<cfif attributes.member_type eq "consumer" and len(attributes.consumer_id)>#attributes.consumer_id#<cfelse>NULL</cfif>,
								<cfif attributes.member_type eq "employee" and len(attributes.employee_id)>#attributes.employee_id#<cfelse>NULL</cfif>,
								#attributes.PAYROLL_REVENUE_DATE#,
								<cfif len(evaluate("attributes.cheque_system_currency_value#i#"))>#evaluate("attributes.cheque_system_currency_value#i#")#,<cfelse>NULL,</cfif>
								<cfif len(evaluate("attributes.system_money_info#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.system_money_info#i#")#'>,<cfelse>NULL,</cfif>
								<cfif len(evaluate("attributes.other_money_value2#i#"))>#evaluate("attributes.other_money_value2#i#")#,<cfelse>NULL,</cfif>
								<cfif len(evaluate("attributes.other_money2#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.other_money2#i#")#'>,<cfelse>NULL,</cfif>
								#NOW()#
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
				<cfelseif evaluate("attributes.cheque_status_id#i#") eq 6 and len(evaluate("attributes.cheque_id#i#"))><!--- bir kendi cekimiz güncellenecek --->
					<cf_date tarih='attributes.cheque_duedate#i#'>
					<cfquery name="UPD_CHEQUE" datasource="#dsn2#">
						UPDATE 
							CHEQUE
						SET
							COMPANY_ID = <cfif attributes.member_type eq "partner" and len(attributes.company_id)>#attributes.company_id#<cfelse>NULL</cfif>,
							CONSUMER_ID = <cfif attributes.member_type eq "consumer" and len(attributes.consumer_id)>#attributes.consumer_id#<cfelse>NULL</cfif>,
							EMPLOYEE_ID = <cfif attributes.member_type eq "employee" and len(attributes.employee_id)>#attributes.employee_id#<cfelse>NULL</cfif>,
							CHEQUE_DUEDATE = #evaluate("attributes.cheque_duedate#i#")#,
							ACCOUNT_ID = <cfif len(evaluate("attributes.account_id#i#"))>#wrk_eval("attributes.account_id#i#")#,<cfelse>NULL,</cfif>
							ACCOUNT_NO = <cfif len(evaluate("attributes.account_no#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.account_no#i#")#'>,<cfelse>NULL,</cfif>
							BANK_NAME = <cfif len(evaluate("attributes.bank_name#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.bank_name#i#")#'>,<cfelse>NULL,</cfif>
							BANK_BRANCH_NAME = <cfif len(evaluate("attributes.bank_branch_name#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.bank_branch_name#i#")#'>,<cfelse>NULL,</cfif>
							CHEQUE_VALUE = #evaluate("attributes.cheque_value#i#")#,
							CHEQUE_CITY = <cfif len(evaluate("attributes.cheque_city#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.cheque_city#i#")#'>,<cfelse>NULL,</cfif>
							CHEQUE_PURSE_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#portfoy_no#">,
							CURRENCY_ID = <cfif len(evaluate("attributes.currency_id#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.currency_id#i#")#'>,<cfelse>NULL,</cfif>
							CHEQUE_PAYROLL_ID = #attributes.id#,
							CHEQUE_NO = <cfif len(evaluate("attributes.cheque_no#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.cheque_no#i#")#'>,<cfelse>NULL,</cfif>
							CHEQUE_CODE = <cfif len(evaluate("attributes.cheque_code#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.cheque_code#i#")#'>,<cfelse>NULL,</cfif>
							OTHER_MONEY_VALUE = <cfif len(evaluate("attributes.cheque_system_currency_value#i#"))>#evaluate("attributes.cheque_system_currency_value#i#")#<cfelse>NULL</cfif>,
							OTHER_MONEY = <cfif len(evaluate("attributes.system_money_info#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.system_money_info#i#")#'><cfelse>NULL</cfif>,
							OTHER_MONEY_VALUE2 = <cfif len(evaluate("attributes.other_money_value2#i#"))>#evaluate("attributes.other_money_value2#i#")#<cfelse>NULL</cfif>,
							OTHER_MONEY2 = <cfif len(evaluate("attributes.other_money2#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.other_money2#i#")#'><cfelse>NULL</cfif>,
							CH_OTHER_MONEY_VALUE=#wrk_round((evaluate("attributes.cheque_system_currency_value#i#")/attributes.basket_money_rate),4)#,
							CH_OTHER_MONEY=<cfqueryparam cfsqltype="cf_sql_varchar" value='#attributes.basket_money#'>
						WHERE
							CHEQUE_ID = #evaluate("attributes.cheque_id#i#")#
					</cfquery>
					<cfquery name="ADD_SELF_CHE_TO_HIST" datasource="#dsn2#">
						INSERT INTO
							CHEQUE_HISTORY
							(
								CHEQUE_ID,
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
								#evaluate("attributes.cheque_id#i#")#,
								#attributes.id#,
								6,
								<cfif attributes.member_type eq "partner" and len(attributes.company_id)>#attributes.company_id#<cfelse>NULL</cfif>,
								<cfif attributes.member_type eq "consumer" and len(attributes.consumer_id)>#attributes.consumer_id#<cfelse>NULL</cfif>,
								<cfif attributes.member_type eq "employee" and len(attributes.employee_id)>#attributes.employee_id#<cfelse>NULL</cfif>,
								#attributes.PAYROLL_REVENUE_DATE#,
								<cfif len(evaluate("attributes.cheque_system_currency_value#i#"))>#evaluate("attributes.cheque_system_currency_value#i#")#,<cfelse>NULL,</cfif>
								<cfif len(evaluate("attributes.system_money_info#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.system_money_info#i#")#'>,<cfelse>NULL,</cfif>
								<cfif len(evaluate("attributes.other_money_value2#i#"))>#evaluate("attributes.other_money_value2#i#")#,<cfelse>NULL,</cfif>
								<cfif len(evaluate("attributes.other_money2#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.other_money2#i#")#'>,<cfelse>NULL,</cfif>
								#NOW()#
							)
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
				</cfif>
				<cfelseif ctr eq 1>
					<cfquery name="UPD_CHEQUE_HISTORY" datasource="#dsn2#">
						UPDATE 
							CHEQUE_HISTORY
						SET 
							ACT_DATE = #attributes.PAYROLL_REVENUE_DATE#,
							OTHER_MONEY_VALUE = <cfif len(evaluate("attributes.cheque_system_currency_value#i#"))>#evaluate("attributes.cheque_system_currency_value#i#")#<cfelse>NULL</cfif>,
							OTHER_MONEY = <cfif len(evaluate("attributes.system_money_info#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.system_money_info#i#")#'><cfelse>NULL</cfif>,
							OTHER_MONEY_VALUE2 = <cfif len(evaluate("attributes.other_money_value2#i#"))>#evaluate("attributes.other_money_value2#i#")#<cfelse>NULL</cfif>,
							OTHER_MONEY2 = <cfif len(evaluate("attributes.other_money2#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.other_money2#i#")#'><cfelse>NULL</cfif>
						WHERE 
							CHEQUE_ID= #evaluate("attributes.cheque_id#i#")# AND
							PAYROLL_ID = #attributes.id#
					</cfquery>
				</cfif>
			</cfif>
		</cfloop>
		<cfset portfoy_no = get_cheque_no(belge_tipi:'cheque',belge_no:portfoy_no)>
		<cfquery name="GET_CHEQUES_LAST" datasource="#dsn2#">
			SELECT 
				CHEQUE.*,
                CHEQUE_HISTORY.OTHER_MONEY_VALUE OTHER_MONEY_VALUE_LAST
			FROM
				CHEQUE, 
				CHEQUE_HISTORY 
			WHERE
				CHEQUE.CHEQUE_ID=CHEQUE_HISTORY.CHEQUE_ID
				AND PAYROLL_ID=#attributes.id#
		</cfquery>
		<cfset cheq_no_list=valuelist(GET_CHEQUES_LAST.CHEQUE_NO)>
		<cfset ches_2 = ches>
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
			{ /*bordrodan cıkarılan cekler bulunuyor*/
				for(cheq_x=1; cheq_x lte attributes.record_num; cheq_x=cheq_x+1)
				{
					if (evaluate("attributes.row_kontrol#cheq_x#"))
						if(len(evaluate("attributes.cheque_id#cheq_x#")) and ListFindNoCase(ches_2,evaluate("attributes.cheque_id#cheq_x#")))
							ches_2 = ListDeleteAt(ches_2,ListFindNoCase(ches_2,evaluate("attributes.cheque_id#cheq_x#"), ','), ',');
				}
			}
						
			if(is_cari eq 1)
			{
				if(is_cheque_based eq 1) /*islem kategorisinde cek bazında carici secili*/
				{
					if(attributes.payroll_acc_cari_cheque_based neq 1)  //bordro ilk eklendiginde carici bordro bazında calıstırılmıs ise, silinir
						cari_sil(action_id:attributes.id,action_table:'PAYROLL',process_type:form.old_process_type);
					
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
							if(len(evaluate("attributes.cheque_id#cheq_i#")))
								my_obj_val = evaluate("attributes.cheque_id#cheq_i#");
							else
								my_obj_val = GET_CHEQUES_LAST.CHEQUE_ID[listfind(cheq_no_list,evaluate("attributes.cheque_no#cheq_i#"))]; 
							GET_CHEQUE_STATUS=cfquery(datasource:"#dsn2#",sqlstring:"SELECT CHEQUE_STATUS_ID FROM CHEQUE WHERE CHEQUE_ID=#my_obj_val#");
							if(GET_CHEQUE_STATUS.CHEQUE_STATUS_ID eq 7) kontrol_info = 1; else  kontrol_info = 0;
							carici(
								action_id :iif(len(evaluate("attributes.cheque_id#cheq_i#")),'evaluate("attributes.cheque_id#cheq_i#")','GET_CHEQUES_LAST.CHEQUE_ID[listfind(cheq_no_list,evaluate("attributes.cheque_no#cheq_i#"))]'),
								action_table :'CHEQUE',
								process_cat :form.process_cat,
								workcube_process_type :process_type,
								workcube_old_process_type :form.old_process_type,
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
								payroll_id :attributes.id,
								special_definition_id : iif((isdefined("attributes.special_definition_id") and len(attributes.special_definition_id)),'attributes.special_definition_id',de('')),
								assetp_id : iif((isdefined("attributes.asset_id") and len(attributes.asset_id) and len(attributes.asset_name)),'attributes.asset_id',de('')),
								is_upd_other_value : kontrol_info,//işlem kategrnsdeki extre güncelleme işlemnde dövizleri tekrar değiştirmesn
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
						action_id :attributes.id,
						action_table :'PAYROLL',
						process_cat :form.process_cat,
						workcube_process_type :process_type,
						workcube_old_process_type :form.old_process_type,
						account_card_type :13,
						islem_tarihi :attributes.PAYROLL_REVENUE_DATE,
						islem_tutari : attributes.payroll_total,
						other_money_value : iif(len(attributes.other_payroll_total),'attributes.other_payroll_total',de('')),
						other_money : iif(len(attributes.basket_money),'attributes.basket_money',de('')),
						islem_belge_no :attributes.payroll_no,
						due_date : attributes.pyrll_avg_duedate,
						to_cmp_id : iif(attributes.member_type eq "partner",'attributes.company_id',de('')),
						to_consumer_id : iif(attributes.member_type eq "consumer",'attributes.consumer_id',de('')),
						to_employee_id : iif(attributes.member_type eq "employee",'attributes.employee_id',de('')),
						payer_id : attributes.pro_employee_id,
						islem_detay : 'ÇEK ÇIKIŞ BORDROSU(CİRO)',
						acc_type_id : attributes.acc_type_id,
						action_detail : attributes.action_detail,
						currency_multiplier : currency_multiplier,
						project_id : attributes.project_id,
						special_definition_id : iif((isdefined("attributes.special_definition_id") and len(attributes.special_definition_id)),'attributes.special_definition_id',de('')),
						assetp_id : iif((isdefined("attributes.asset_id") and len(attributes.asset_id) and len(attributes.asset_name)),'attributes.asset_id',de('')),
						from_branch_id : branch_id_info,
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
			//muhasebe update
			if (is_account eq 1)
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
							if(listfind('6,7,9,8',evaluate("attributes.cheque_status_id#i#"),',') and len(evaluate("attributes.account_id#i#")))//bizim banka id lerimizin muh hesabini bulalim yani bizim cekimiz icin
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
							else//cek ciroludur girdigi hesaptan (ki o da bir kasanin hesabidir) cikalim
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
						action_id:attributes.id,
						workcube_process_type:process_type,
						workcube_old_process_type :form.old_process_type,
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
						other_currency_alacak : other_currency_alacak_list,
						belge_no : form.payroll_no,
						currency_multiplier : currency_multiplier,
						fis_detay : UCase(getLang('main',2737)),
						fis_satir_detay : satir_detay_list,
						from_branch_id : branch_id_info,
						workcube_process_cat : form.process_cat,
						acc_project_id : attributes.project_id,
						is_account_group : is_account_group
					);
				}
				else		/*e-deftere uygun muhasebe islemleri yapılıyor*/
				{
					// tum muhasebe kayıtlari silinir sonra yaniden eklenir.
					muhasebe_sil(action_id:attributes.id,action_table:'PAYROLL',process_type:form.old_process_type,belge_no:form.payroll_no);
					alacak_hesap = '';
					alacak_tutar = '';
					satir_detay_list = ArrayNew(2);
					
					for(i=1; i lte get_cheques_last.recordcount; i=i+1)
					{
						if(get_cheques_last.CURRENCY_ID[i] neq session.ep.money)
							alacak_tutar = get_cheques_last.OTHER_MONEY_VALUE_LAST[i];
						else
							alacak_tutar = get_cheques_last.CHEQUE_VALUE[i];
							
						if(listfind('6,7,9,8',get_cheques_last.CHEQUE_STATUS_ID[i],',') and len(get_cheques_last.ACCOUNT_ID[i]))//bizim banka id lerimizin muh hesabini bulalim yani bizim cekimiz icin
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
						else//cek ciroludur girdigi hesaptan (ki o da bir kasanin hesabidir) cikalim
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
										P.ACTION_ID= CH.PAYROLL_ID AND
										CH.CHEQUE_ID = #get_cheques_last.CHEQUE_ID[i]# 
									ORDER BY
										CH.HISTORY_ID DESC");
							}
							alacak_hesap = GET_ACC_CODE.A_CHEQUE_ACC_CODE;
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
							action_id:attributes.id,
							action_row_id : get_cheques_last.CHEQUE_ID[i],
							due_date :iif(len(get_cheques_last.CHEQUE_DUEDATE[i]),'createodbcdatetime(get_cheques_last.CHEQUE_DUEDATE[i])','attributes.pyrll_avg_duedate'),
							workcube_process_type:process_type,
							workcube_old_process_type :form.old_process_type,
							account_card_type:13,
							action_table :'PAYROLL',
							islem_tarihi:attributes.PAYROLL_REVENUE_DATE,
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
							belge_no : get_cheques_last.CHEQUE_NO[i],
							currency_multiplier : currency_multiplier,
							fis_detay : UCase(getLang('main',2737)),
							fis_satir_detay : satir_detay_list,
							from_branch_id : branch_id_info,
							workcube_process_cat : form.process_cat,
							acc_project_id : attributes.project_id,
							is_account_group : is_account_group
						);	
					}
				}
			}
			else
			{
				muhasebe_sil(action_id:attributes.id,action_table:'PAYROLL',process_type:form.old_process_type,belge_no:form.payroll_no);
			}
			basket_kur_ekle(action_id:attributes.id,table_type_id:11,process_type:1);
		</cfscript>
		<cf_workcube_process_cat 
			process_cat="#form.process_cat#"
			old_process_cat_id = "#attributes.old_process_cat_id#"
			action_id = #attributes.id#
			is_action_file = 1
			action_db_type = '#dsn2#'
			action_page='#request.self#?fuseaction=cheque.form_add_payroll_endorsement&event=upd&ID=#attributes.id#'
			action_file_name='#get_process_type.action_file_name#'
			is_template_action_file = '#get_process_type.action_file_from_template#'>
    <cf_add_log log_type="0" action_id="#attributes.id#" action_name="#attributes.payroll_no# Güncellendi" paper_no="#attributes.payroll_no#" period_id="#session.ep.period_id#" process_type="#get_process_type.PROCESS_TYPE#" data_source="#dsn2#">
	</cftransaction>
</cflock>
<cfquery name="get_closed_id" datasource="#dsn2#">
	SELECT CLOSED_ID FROM CARI_CLOSED_ROW WHERE ACTION_ID = #attributes.id# AND ACTION_TYPE_ID = #process_type# AND CARI_ACTION_ID IN (SELECT CARI_ACTION_ID FROM CARI_ROWS WHERE ACTION_TABLE = 'PAYROLL')
</cfquery>
<script type="text/javascript">
	<cfif session.ep.our_company_info.is_paper_closer eq 1 and (len(attributes.company_id) or len(attributes.consumer_id) or len(attributes.employee_id))>
		<cfif get_closed_id.recordcount gt 0>
			window.open('<cfoutput>#request.self#?fuseaction=finance.list_payment_actions&event=upd&closed_id=#get_closed_id.closed_id#&act_type=1</cfoutput>','page');
		<cfelse>
			window.open('<cfoutput>#request.self#?fuseaction=finance.list_payment_actions&event=add&act_type=1&member_id=#attributes.company_id#&consumer_id=#attributes.consumer_id#&employee_id_new=#attributes.employee_id#&acc_type_id=#attributes.acc_type_id#&money_type=#form.basket_money#&row_action_id=#attributes.id#&row_action_type=#process_type#</cfoutput>','page');
		</cfif>
	</cfif>
	window.location.href="<cfoutput>#request.self#?fuseaction=cheque.form_add_payroll_endorsement&event=upd&ID=#attributes.id#</cfoutput>";
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
