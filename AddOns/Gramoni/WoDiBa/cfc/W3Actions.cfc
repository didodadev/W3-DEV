<!---
	File: W3Actions.cfc
	Author: Cemil Durgan <cemildurgan@startechbt.com>
	Date: 19.03.2018
	Description:
		WoDiBa banka kayıtlarını Workcube belgesi olarak sisteme kayıt eder.
	History:
		06.04.2019 Mahmut Çifçi - wodiba_carici, wodiba_muhasebeci ve wodiba_butceci metodları eklendi
		09.04.2019 Mahmut Çifçi - addCollactedExpenseCost metodu eklendi
		14.06.2019 Mahmut Çifçi - addEFT metodu eklendi
		10.11.2019 Mahmut Çifçi - addIncomingExpenseCost metodu eklendi
	To Do:
		wodiba_muhasebeci branch_id eklenecek
		wodiba_carici branch_id eklenecek
		addIncomingTransfer ve addOutgoingTransfer metodlarına cf_workcube_process_cat eklenecek
		wodiba_muhasebeci alert uyarıları WodibaLoggera taşınacak
--->

<cfcomponent>

	<cffunction name="addInvestMoney" access="public" returntype="struct" output="false" hint="Wodiba para yatırma işlemi ekler">
		<cfset addInvestMoney_return_struct = structNew() />
		<cfreturn addInvestMoney_return_struct />
	</cffunction>

	<cffunction name="addGetMoney" access="public" returntype="struct" output="false" hint="Wodiba para çekme işlemi ekler">
		<cfset addGetMoney_return_struct    = structNew() />
		<cfreturn addGetMoney_return_struct />
	</cffunction>

	<cffunction name="addIncomingTransfer" access="public" returntype="struct" output="false" hint="Wodiba gelen havale kaydı ekler">
		<cfargument name="period_id" type="numeric" required="true" />
		<cfargument name="process_cat" type="numeric" required="true" />
		<cfargument name="acc_type_id" type="numeric" required="true" />
		<cfargument name="account_id" type="numeric" required="true" />
		<cfargument name="amount" type="any" required="true" hint="Tutarlar structure ile gönderilmelidir" />
		<cfargument name="date" type="date" required="true" />
		<cfargument name="detail" type="string" required="true" />
		<cfargument name="paper_no" type="string" required="true" />
		<cfargument name="record_emp" type="numeric" required="true" />
		<cfargument name="expense_center_id" type="numeric" required="true" />
		<cfargument name="expense_item_id" type="numeric" required="true" />
		<cfargument name="project_id" type="numeric" required="true" />
		<cfargument name="company_id" type="numeric" required="true" />
		<cfargument name="consumer_id" type="numeric" required="true" />
		<cfargument name="employee_id" type="numeric" required="true" />
		<cfargument name="payment_type_id" type="numeric" required="true" />
		<cfargument name="special_definition_id" type="numeric" required="true" />
		<cfargument name="asset_id" type="numeric" required="true" />
		<cfargument name="branch_id" type="numeric" required="true" />
		<cfargument name="department_id" type="numeric" required="true" />

		<cfscript>
			period_id               = arguments.period_id;
			process_cat             = arguments.process_cat;
			acc_type_id             = arguments.acc_type_id;
			account_id              = arguments.account_id;
			amount                  = arguments.amount;
			date                    = arguments.date;
			detail                  = arguments.detail;
			paper_no                = arguments.paper_no;
			record_emp              = arguments.record_emp;
			expense_center_id       = arguments.expense_center_id;
			expense_item_id         = arguments.expense_item_id;
			project_id              = arguments.project_id;
			company_id              = arguments.company_id;
			consumer_id             = arguments.consumer_id;
			employee_id             = arguments.employee_id;
			payment_type_id         = arguments.payment_type_id;
			special_definition_id   = arguments.special_definition_id;
			asset_id                = arguments.asset_id;
			branch_id               = arguments.branch_id;
			department_id           = arguments.department_id;
			dsn_alias               = dsn;
			session.ep.period_id    = period_id;
			error_str               = structNew();

			//static
			action_type     = 'GELEN HAVALE';
			action_type_id  = 24;

			//computed
			periodQuery = new Query();
			periodQuery.setDatasource("#dsn#");
			periodQuery.setSQL("SELECT PERIOD_YEAR, IS_INTEGRATED, OUR_COMPANY_ID FROM SETUP_PERIOD WHERE PERIOD_ID = #period_id#");
			periodResult = periodQuery.execute();
			periodResult = periodResult.getResult();

			wodiba_dsn          = dsn;
			wodiba_dsn1         = dsn1;
			wodiba_dsn2         = '#dsn#_#periodResult.period_year#_#periodResult.our_company_id#';
			wodiba_dsn3         = '#dsn#_#periodResult.our_company_id#';
			caller.dsn3_alias   = wodiba_dsn3;

			processCatQuery = new Query();
			processCatQuery.setDatasource("#wodiba_dsn3#");
			processCatQuery.setSQL("SELECT IS_CARI, IS_ACCOUNT, ACCOUNT_TYPE_ID FROM SETUP_PROCESS_CAT WHERE PROCESS_CAT_ID = #process_cat#");
			processCatResult = processCatQuery.execute();
			processCatResult = processCatResult.getResult();

			moneyQuery = new Query();
			moneyQuery.setDatasource("#wodiba_dsn2#");
			moneyQuery.setSQL("SELECT MONEY, RATE1, RATE2 FROM SETUP_MONEY WHERE PERIOD_ID = #period_id#");
			moneyResult = moneyQuery.execute();
			moneyResult = moneyResult.getResult();

			accountQuery = new Query();
			accountQuery.setDatasource("#wodiba_dsn3#");
			accountQuery.setSQL("SELECT ACCOUNT_CURRENCY_ID, ACCOUNT_ACC_CODE FROM ACCOUNTS WHERE ACCOUNT_ID = #account_id#");
			accountResult = accountQuery.execute();
			accountResult = accountResult.getResult();

			if (Not Len(accountResult.ACCOUNT_ACC_CODE)) {
				error_str.error_type    = 'account_code';
				error_str.error_message = 'account_id: #account_id# için muhasebe hesabı tanımlı değil!';
			}

			memberQuery = new Query();
			memberQuery.setDatasource("#wodiba_dsn#");
			memberQuery.setSQL("
				SELECT FULLNAME AS MEMBER_NAME FROM COMPANY WHERE COMPANY_ID = #company_id# UNION ALL
				SELECT CONSUMER_NAME + ' ' + CONSUMER_SURNAME AS MEMBER_NAME FROM CONSUMER WHERE CONSUMER_ID = #consumer_id# UNION ALL
				SELECT EMPLOYEE_NAME + ' ' + EMPLOYEE_SURNAME AS MEMBER_NAME FROM EMPLOYEES WHERE EMPLOYEE_ID = #employee_id#
			");
			memberResult = memberQuery.execute();
			memberResult = memberResult.getResult();

			attributes.kur_say = moneyResult.recordcount;
			attributes.money_type = accountResult.account_currency_id;
			for(mon=1; mon lte moneyResult.recordcount; mon++){//f_kur_ekle_action için gerekli
				evaluate("attributes.hidden_rd_money_#mon#  = moneyResult.money[mon]");
				evaluate("attributes.txt_rate1_#mon#        = moneyResult.rate1[mon]");
				evaluate("attributes.txt_rate2_#mon#        = moneyResult.rate2[mon]");
			}

			member_name_ = memberResult.member_name;
			str_card_detail = '#member_name_#-#detail#';
			if(company_id gt 0)
				member_acc_code = get_company_period(company_id: company_id, period_id: period_id, acc_type_id: processCatResult.ACCOUNT_TYPE_ID);
			else if(consumer_id gt 0)
				member_acc_code = get_consumer_period(consumer_id);
			else if(employee_id gt 0)
				member_acc_code = queryExecute("SELECT TOP 1 ACCOUNT_CODE FROM EMPLOYEES_ACCOUNTS WHERE ACC_TYPE_ID = #acc_type_id# AND PERIOD_ID = #period_id# AND EMPLOYEE_ID = #employee_id# ORDER BY IN_OUT_ID DESC",{},{datasource='#dsn#'}).ACCOUNT_CODE;

			if((company_id gt 0 Or consumer_id gt 0 Or employee_id gt 0) And isDefined('member_acc_code') And Not Len(member_acc_code)) {
				error_str.error_type    = 'account_code';
				error_str.error_message = 'Üye için muhasebe hesabı tanımlı değil!';
			}
		</cfscript>

		<cfif structIsEmpty(error_str)>
			<cflock name="#createUUID()#" timeout="60">
				<cftransaction>
					<cfquery datasource="#wodiba_dsn2#" result="res">
						INSERT INTO
							BANK_ACTIONS
						(
							ACTION_TYPE,
							PROCESS_CAT,
							ACTION_TYPE_ID,
							ACTION_FROM_COMPANY_ID,
							ACTION_FROM_EMPLOYEE_ID,
							ACTION_FROM_CONSUMER_ID,
							ACTION_TO_ACCOUNT_ID,
							ACTION_VALUE,
							ACTION_DATE,
							ACTION_CURRENCY_ID,
							ACTION_DETAIL,
							OTHER_CASH_ACT_VALUE,
							OTHER_MONEY,
							IS_ACCOUNT,
							IS_ACCOUNT_TYPE,
							PAPER_NO,
							MASRAF,
							RECORD_EMP,
							RECORD_IP,
							RECORD_DATE,
							SYSTEM_ACTION_VALUE,
							SYSTEM_CURRENCY_ID,
							ACC_TYPE_ID,
							ACTION_VALUE_2,
							ACTION_CURRENCY_ID_2,
							PROJECT_ID,
							TO_BRANCH_ID,
							EXPENSE_CENTER_ID,
							EXPENSE_ITEM_ID,
							ASSETP_ID,
							SPECIAL_DEFINITION_ID,
							ACC_DEPARTMENT_ID
						)
						VALUES
						(
							'#action_type#',
							#process_cat#,
							#action_type_id#,
							<cfif company_id gt 0>#company_id#<cfelse>NULL</cfif>,
							<cfif employee_id gt 0>#employee_id#<cfelse>NULL</cfif>,
							<cfif consumer_id gt 0>#consumer_id#<cfelse>NULL</cfif>,
							#account_id#,
							#wrk_round(amount.action_value)#,
							#date#,
							'#amount.action_currency_id#',
							'#detail#',
							#wrk_round(amount.action_value)#,
							'#amount.action_currency_id#',
							#processCatResult.is_account#,
							13,
							'#paper_no#',
							0,
							#record_emp#,
							'#cgi.remote_addr#',
							#now()#,
							#wrk_round(amount.system_action_value)#,
							'#amount.system_currency_id#',
							<cfif isdefined('acc_type_id') and len(acc_type_id) and acc_type_id neq 0>#acc_type_id#<cfelse>NULL</cfif>,
							#wrk_round(amount.system_action_value_2)#,
							'#amount.system_currency_id_2#',
							<cfif Len(project_id) And project_id Neq 0>#project_id#<cfelse>NULL</cfif>,
							<cfif Len(branch_id) And branch_id Neq 0>#branch_id#<cfelse>NULL</cfif>,
							<cfif Len(expense_center_id) And expense_center_id Neq 0>#expense_center_id#<cfelse>NULL</cfif>,
							<cfif Len(expense_item_id) And expense_item_id Neq 0>#expense_item_id#<cfelse>NULL</cfif>,
							<cfif Len(asset_id) And asset_id Neq 0>#asset_id#<cfelse>NULL</cfif>,
							<cfif Len(special_definition_id) And special_definition_id Neq 0>#special_definition_id#<cfelse>NULL</cfif>,
							<cfif Len(department_id) And department_id Neq 0>#department_id#<cfelse>NULL</cfif>
						)
					</cfquery>
					<cfscript>
						if(processCatResult.is_cari eq 1)
						{
							wodiba_carici(
								action_id : res.IDENTITYCOL,
								action_table : 'BANK_ACTIONS',
								islem_belge_no : paper_no,
								workcube_process_type : action_type_id,
								process_cat : process_cat,
								islem_tarihi : date,
								to_account_id : account_id,
								islem_tutari : wrk_round(amount.system_action_value),
								action_currency : amount.system_currency_id,
								action_currency_2 : amount.system_currency_id_2,
								other_money_value : wrk_round(amount.action_value),
								other_money : amount.action_currency_id,
								currency_multiplier : amount.action_rate_2,
								islem_detay : action_type,
								period_is_integrated: periodResult.IS_INTEGRATED,
								action_detail : detail,
								account_card_type : 13,
								acc_type_id : iif(acc_type_id neq 0,acc_type_id,de('')),
								due_date: date,
								from_employee_id : iif(employee_id neq 0,employee_id,de('')),
								from_cmp_id : iif(company_id neq 0,company_id,de('')),
								from_consumer_id : iif(consumer_id neq 0,consumer_id,de('')),
								rate2: amount.action_rate,
								record_emp: record_emp,
								cari_db: wodiba_dsn2,
								project_id: project_id,
								assetp_id: asset_id,
								special_definition_id: special_definition_id
							);
						}
						if(processCatResult.is_account eq 1)
						{
							str_borclu_hesaplar     = accountResult.ACCOUNT_ACC_CODE;
							str_alacakli_hesaplar   = member_acc_code;
							str_tutarlar            = wrk_round(amount.system_action_value);

							str_borclu_other_amount_tutar   = wrk_round(amount.action_value);
							str_borclu_other_currency       = amount.action_currency_id;
							str_alacakli_other_amount_tutar = wrk_round(amount.action_value);
							str_alacakli_other_currency     = amount.action_currency_id;

							if (Len(str_borclu_hesaplar) And Len(str_alacakli_hesaplar)) {
								wodiba_muhasebeci (
									action_id: res.IDENTITYCOL,
									workcube_process_type: action_type_id,
									workcube_process_cat: process_cat,
									account_card_type: 13,
									company_id: iif(company_id neq 0,company_id,de('')),
									consumer_id: iif(consumer_id neq 0,consumer_id,de('')),
									employee_id: iif(employee_id neq 0,employee_id,de('')),
									islem_tarihi: date,
									fis_satir_detay: str_card_detail,
									borc_hesaplar: str_borclu_hesaplar,
									borc_tutarlar: str_tutarlar,
									other_amount_borc : str_borclu_other_amount_tutar,
									other_currency_borc : str_borclu_other_currency,
									alacak_hesaplar: str_alacakli_hesaplar,
									alacak_tutarlar: str_tutarlar,
									other_amount_alacak : str_alacakli_other_amount_tutar,
									other_currency_alacak : str_alacakli_other_currency,
									currency_multiplier : amount.action_rate_2,
									fis_detay: UCase(getLang('main',422)),
									belge_no : paper_no,
									is_abort : 0,
									action_currency : amount.system_currency_id,
									action_currency_2 : amount.system_currency_id_2,
									muhasebe_db: wodiba_dsn2,
									period_id: period_id,
									acc_department_id: department_id,
									acc_project_id: project_id
								);
							}
						}
						f_kur_ekle_action(
							action_id:res.IDENTITYCOL,
							process_type:0,
							action_table_name:'BANK_ACTION_MONEY',
							action_table_dsn:'#wodiba_dsn2#');
					</cfscript>
				</cftransaction>
			</cflock>

			<cfscript>
				return_struct                   = structNew();
				return_struct.bank_action_id    = res.IDENTITYCOL;
				return_struct.document_id       = res.IDENTITYCOL;
			</cfscript>

			<cfreturn return_struct />
		<cfelse>
			<cfreturn error_str />
		</cfif>
	</cffunction>

	<cffunction name="addOutgoingTransfer" access="public" returntype="struct" output="false" hint="Wodiba giden havale kaydı ekler">
		<cfargument name="period_id" type="numeric" required="true" />
		<cfargument name="process_cat" type="numeric" required="true" />
		<cfargument name="acc_type_id" type="numeric" required="true" />
		<cfargument name="account_id" type="numeric" required="true" />
		<cfargument name="amount" type="any" required="true" hint="Tutarlar structure ile gönderilmelidir" />
		<cfargument name="date" type="date" required="true" />
		<cfargument name="detail" type="string" required="true" />
		<cfargument name="paper_no" type="string" required="true" />
		<cfargument name="record_emp" type="numeric" required="true" />
		<cfargument name="expense_center_id" type="numeric" required="true" />
		<cfargument name="expense_item_id" type="numeric" required="true" />
		<cfargument name="project_id" type="numeric" required="true" />
		<cfargument name="company_id" type="numeric" required="true" />
		<cfargument name="consumer_id" type="numeric" required="true" />
		<cfargument name="employee_id" type="numeric" required="true" />
		<cfargument name="payment_type_id" type="numeric" required="true" />
		<cfargument name="special_definition_id" type="numeric" required="true" />
		<cfargument name="asset_id" type="numeric" required="true" />
		<cfargument name="branch_id" type="numeric" required="true" />
		<cfargument name="department_id" type="numeric" required="true" />

		<cfscript>
			// parametric
			period_id               = arguments.period_id;
			process_cat             = arguments.process_cat;
			acc_type_id             = arguments.acc_type_id;
			account_id              = arguments.account_id;
			amount                  = arguments.amount;
			date                    = arguments.date;
			detail                  = arguments.detail;
			paper_no                = arguments.paper_no;
			record_emp              = arguments.record_emp;
			expense_center_id       = arguments.expense_center_id;
			expense_item_id         = arguments.expense_item_id;
			project_id              = arguments.project_id;
			company_id              = arguments.company_id;
			consumer_id             = arguments.consumer_id;
			employee_id             = arguments.employee_id;
			payment_type_id         = arguments.payment_type_id;
			special_definition_id   = arguments.special_definition_id;
			asset_id                = arguments.asset_id;
			branch_id               = arguments.branch_id;
			department_id           = arguments.department_id;
			dsn_alias               = dsn;
			session.ep.period_id    = period_id;
			error_str               = structNew();

			//static
			action_type     = 'GİDEN HAVALE';
			action_type_id  = 25;

			//computed
			periodQuery = new Query();
			periodQuery.setDatasource("#dsn#");
			periodQuery.setSQL("SELECT PERIOD_YEAR, IS_INTEGRATED, OUR_COMPANY_ID FROM SETUP_PERIOD WHERE PERIOD_ID = #period_id#");
			periodResult = periodQuery.execute();
			periodResult = periodResult.getResult();

			wodiba_dsn          = dsn;
			wodiba_dsn1         = dsn1;
			wodiba_dsn2         = '#dsn#_#periodResult.PERIOD_YEAR#_#periodResult.OUR_COMPANY_ID#';
			wodiba_dsn3         = '#dsn#_#periodResult.OUR_COMPANY_ID#';
			caller.dsn3_alias   = wodiba_dsn3;

			processCatQuery = new Query();
			processCatQuery.setDatasource("#wodiba_dsn3#");
			processCatQuery.setSQL("SELECT IS_CARI, IS_ACCOUNT, ACCOUNT_TYPE_ID FROM SETUP_PROCESS_CAT WHERE PROCESS_CAT_ID = #process_cat#");
			processCatResult = processCatQuery.execute();
			processCatResult = processCatResult.getResult();

			moneyQuery = new Query();
			moneyQuery.setDatasource("#wodiba_dsn2#");
			moneyQuery.setSQL("SELECT MONEY, RATE1, RATE2 FROM SETUP_MONEY WHERE PERIOD_ID = #period_id#");
			moneyResult = moneyQuery.execute();
			moneyResult = moneyResult.getResult();

			accountQuery = new Query();
			accountQuery.setDatasource("#wodiba_dsn3#");
			accountQuery.setSQL("SELECT ACCOUNT_CURRENCY_ID, ACCOUNT_ACC_CODE FROM ACCOUNTS WHERE ACCOUNT_ID = #account_id#");
			accountResult = accountQuery.execute();
			accountResult = accountResult.getResult();

			if (Not Len(accountResult.ACCOUNT_ACC_CODE)) {
				error_str.error_type    = 'account_code';
				error_str.error_message = 'account_id: #account_id# için muhasebe hesabı tanımlı değil!';
			}

			memberQuery = new Query();
			memberQuery.setDatasource("#wodiba_dsn#");
			memberQuery.setSQL("
				SELECT FULLNAME AS MEMBER_NAME FROM COMPANY WHERE COMPANY_ID = #company_id# UNION ALL
				SELECT CONSUMER_NAME + ' ' + CONSUMER_SURNAME AS MEMBER_NAME FROM CONSUMER WHERE CONSUMER_ID = #consumer_id# UNION ALL
				SELECT EMPLOYEE_NAME + ' ' + EMPLOYEE_SURNAME AS MEMBER_NAME FROM EMPLOYEES WHERE EMPLOYEE_ID = #employee_id#
			");
			memberResult = memberQuery.execute();
			memberResult = memberResult.getResult();

			attributes.kur_say = moneyResult.recordcount;
			attributes.money_type = accountResult.account_currency_id;
			for(mon=1; mon lte moneyResult.recordcount; mon++){//f_kur_ekle_action için gerekli
				evaluate("attributes.hidden_rd_money_#mon#  = moneyResult.money[mon]");
				evaluate("attributes.txt_rate1_#mon#        = moneyResult.rate1[mon]");
				evaluate("attributes.txt_rate2_#mon#        = moneyResult.rate2[mon]");
			}

			member_name_ = memberResult.member_name;
			str_card_detail = '#member_name_#-#detail#';
			if(company_id gt 0)
				member_acc_code = get_company_period(company_id: company_id, period_id: period_id, acc_type_id: processCatResult.ACCOUNT_TYPE_ID);
			else if(consumer_id gt 0)
				member_acc_code = get_consumer_period(consumer_id);
			else if(employee_id gt 0)
				member_acc_code = queryExecute("SELECT TOP 1 ACCOUNT_CODE FROM EMPLOYEES_ACCOUNTS WHERE ACC_TYPE_ID = #acc_type_id# AND PERIOD_ID = #period_id# AND EMPLOYEE_ID = #employee_id# ORDER BY IN_OUT_ID DESC",{},{datasource='#dsn#'}).ACCOUNT_CODE;

			if((company_id gt 0 Or consumer_id gt 0 Or employee_id gt 0) And isDefined('member_acc_code') And Not Len(member_acc_code)) {
				error_str.error_type    = 'account_code';
				error_str.error_message = 'Üye için muhasebe hesabı tanımlı değil!';
			}
		</cfscript>

		<cfif structIsEmpty(error_str)>
			<cflock name="#createUUID()#" timeout="60">
				<cftransaction>
					<cfquery datasource="#wodiba_dsn2#" result="res">
						INSERT INTO
							BANK_ACTIONS
						(
							ACTION_TYPE,
							PROCESS_CAT,
							ACTION_TYPE_ID,
							ACTION_TO_COMPANY_ID,
							ACTION_TO_EMPLOYEE_ID,
							ACTION_TO_CONSUMER_ID,
							ACTION_FROM_ACCOUNT_ID,
							ACTION_VALUE,
							ACTION_DATE,
							ACTION_CURRENCY_ID,
							ACTION_DETAIL,
							OTHER_CASH_ACT_VALUE,
							OTHER_MONEY,
							IS_ACCOUNT,
							IS_ACCOUNT_TYPE,
							PAPER_NO,
							MASRAF,
							RECORD_EMP,
							RECORD_IP,
							RECORD_DATE,
							SYSTEM_ACTION_VALUE,
							SYSTEM_CURRENCY_ID,
							ACC_TYPE_ID,
							ACTION_VALUE_2,
							ACTION_CURRENCY_ID_2,
							PROJECT_ID,
							FROM_BRANCH_ID,
							EXPENSE_CENTER_ID,
							EXPENSE_ITEM_ID,
							ASSETP_ID,
							SPECIAL_DEFINITION_ID,
							ACC_DEPARTMENT_ID
						)
						VALUES
						(
							'#action_type#',
							#process_cat#,
							#action_type_id#,
							<cfif company_id gt 0>#company_id#<cfelse>NULL</cfif>,
							<cfif employee_id gt 0>#employee_id#<cfelse>NULL</cfif>,
							<cfif consumer_id gt 0>#consumer_id#<cfelse>NULL</cfif>,
							#account_id#,
							#wrk_round(amount.action_value)#,
							#date#,
							'#amount.action_currency_id#',
							'#detail#',
							#wrk_round(amount.action_value)#,
							'#amount.action_currency_id#',
							#processCatResult.is_account#,
							13,
							'#paper_no#',
							0,
							#record_emp#,
							'#cgi.remote_addr#',
							#now()#,
							#wrk_round(amount.system_action_value)#,
							'#amount.system_currency_id#',
							<cfif isdefined('acc_type_id') and len(acc_type_id) and acc_type_id neq 0>#acc_type_id#<cfelse>NULL</cfif>,
							#wrk_round(amount.system_action_value_2)#,
							'#amount.system_currency_id_2#',
							<cfif Len(project_id) And project_id Neq 0>#project_id#<cfelse>NULL</cfif>,
							<cfif Len(branch_id) And branch_id Neq 0>#branch_id#<cfelse>NULL</cfif>,
							<cfif Len(expense_center_id) And expense_center_id Neq 0>#expense_center_id#<cfelse>NULL</cfif>,
							<cfif Len(expense_item_id) And expense_item_id Neq 0>#expense_item_id#<cfelse>NULL</cfif>,
							<cfif Len(asset_id) And asset_id Neq 0>#asset_id#<cfelse>NULL</cfif>,
							<cfif Len(special_definition_id) And special_definition_id Neq 0>#special_definition_id#<cfelse>NULL</cfif>,
							<cfif Len(department_id) And department_id Neq 0>#department_id#<cfelse>NULL</cfif>
						)
					</cfquery>
					<cfscript>
						if(processCatResult.is_cari eq 1)
						{
							wodiba_carici(
								action_id : res.IDENTITYCOL,
								action_table : 'BANK_ACTIONS',
								islem_belge_no : paper_no,
								workcube_process_type : action_type_id,
								process_cat : process_cat,
								islem_tarihi : date,
								from_account_id : account_id,
								islem_tutari : wrk_round(amount.system_action_value),
								action_currency : amount.action_currency_id,
								action_currency_2 : amount.system_currency_id_2,
								other_money_value : wrk_round(amount.action_value),
								other_money : amount.action_currency_id,
								currency_multiplier : amount.action_rate_2,
								islem_detay : action_type,
								period_is_integrated: periodResult.IS_INTEGRATED,
								action_detail : detail,
								account_card_type : 13,
								acc_type_id : iif(acc_type_id neq 0,acc_type_id,de('')),
								due_date: date,
								to_employee_id : iif(employee_id neq 0,employee_id,de('')),
								to_cmp_id : iif(company_id neq 0,company_id,de('')),
								to_consumer_id : iif(consumer_id neq 0,consumer_id,de('')),
								rate2: amount.action_rate,
								record_emp: record_emp,
								cari_db: wodiba_dsn2,
								project_id: project_id,
								assetp_id: asset_id,
								special_definition_id: special_definition_id
							);
						}
						if(processCatResult.is_account eq 1)
						{
							str_borclu_hesaplar     = member_acc_code;
							str_alacakli_hesaplar   = accountResult.ACCOUNT_ACC_CODE;
							str_tutarlar            = wrk_round(amount.system_action_value);

							str_borclu_other_amount_tutar   = wrk_round(amount.action_value);
							str_borclu_other_currency       = amount.action_currency_id;
							str_alacakli_other_amount_tutar = wrk_round(amount.action_value);
							str_alacakli_other_currency     = amount.action_currency_id;

							if (Len(str_borclu_hesaplar) And Len(str_alacakli_hesaplar)) {
								wodiba_muhasebeci (
									action_id: res.IDENTITYCOL,
									workcube_process_type: action_type_id,
									workcube_process_cat: process_cat,
									account_card_type: 13,
									company_id: iif(company_id neq 0,company_id,de('')),
									consumer_id: iif(consumer_id neq 0,consumer_id,de('')),
									employee_id: iif(employee_id neq 0,employee_id,de('')),
									islem_tarihi: date,
									fis_satir_detay: str_card_detail,
									borc_hesaplar: str_borclu_hesaplar,
									borc_tutarlar: str_tutarlar,
									other_amount_borc : str_borclu_other_amount_tutar,
									other_currency_borc : str_borclu_other_currency,
									alacak_hesaplar: str_alacakli_hesaplar,
									alacak_tutarlar: str_tutarlar,
									other_amount_alacak : str_alacakli_other_amount_tutar,
									other_currency_alacak : str_alacakli_other_currency,
									currency_multiplier : amount.action_rate_2,
									fis_detay: UCase(getLang('main',423)),
									belge_no : paper_no,
									is_abort : 0,
									action_currency : amount.system_currency_id,
									action_currency_2 : amount.system_currency_id_2,
									muhasebe_db: wodiba_dsn2,
									period_id: period_id,
									acc_department_id : department_id,
									acc_project_id : project_id
								);
							}
						}
						f_kur_ekle_action(
							action_id:res.IDENTITYCOL,
							process_type:0,
							action_table_name:'BANK_ACTION_MONEY',
							action_table_dsn:'#wodiba_dsn2#');
					</cfscript>
				</cftransaction>
			</cflock>

			<cfscript>
				return_struct                   = structNew();
				return_struct.bank_action_id    = res.IDENTITYCOL;
				return_struct.document_id       = res.IDENTITYCOL;
			</cfscript>

			<cfreturn return_struct />
		<cfelse>
			<cfreturn error_str />
		</cfif>
	</cffunction>

	<cffunction name="addCollactedExpenseCost" access="public" returntype="struct" output="false" hint="Wodiba masraf kaydı ekler">
		<cfargument name="period_id" type="numeric" required="true" />
		<cfargument name="process_cat" type="numeric" required="true" />
		<cfargument name="acc_type_id" type="numeric" required="true" />
		<cfargument name="account_id" type="numeric" required="true" />
		<cfargument name="amount" type="any" required="true" hint="Tutarlar structure ile gönderilmelidir" />
		<cfargument name="date" type="date" required="true" />
		<cfargument name="detail" type="string" required="true" />
		<cfargument name="paper_no" type="string" required="true" />
		<cfargument name="record_emp" type="numeric" required="true" />
		<cfargument name="expense_center_id" type="numeric" required="true" />
		<cfargument name="expense_item_id" type="numeric" required="true" />
		<cfargument name="other_expense_item_id" type="numeric" required="true" />
		<cfargument name="other_expense_rate" type="numeric" required="true" />
		<cfargument name="project_id" type="numeric" required="true" />
		<cfargument name="company_id" type="numeric" required="true" />
		<cfargument name="consumer_id" type="numeric" required="true" />
		<cfargument name="employee_id" type="numeric" required="true" />
		<cfargument name="payment_type_id" type="numeric" required="true" />
		<cfargument name="special_definition_id" type="numeric" required="true" />
		<cfargument name="asset_id" type="numeric" required="true" />
		<cfargument name="branch_id" type="numeric" required="true" />
		<cfargument name="department_id" type="numeric" required="true" />

		<cfscript>
			wrk_id              = dateformat(now(),'YYYYMMDD')&timeformat(now(),'HHmmss')&'_#arguments.record_emp#_'&round(rand()*100);
			period_id           = arguments.period_id;
			process_cat         = arguments.process_cat;
			acc_type_id         = arguments.acc_type_id;
			account_id          = arguments.account_id;
			amount              = arguments.amount;
			date                = arguments.date;
			detail              = arguments.detail;
			paper_no            = arguments.paper_no;
			record_emp          = arguments.record_emp;
			expense_center_id   = arguments.expense_center_id;
			expense_item_id     = arguments.expense_item_id;
			other_expense_item_id= arguments.other_expense_item_id;
			other_expense_rate   = arguments.other_expense_rate;
			project_id          = arguments.project_id;
			company_id          = arguments.company_id;
			consumer_id         = arguments.consumer_id;
			employee_id         = arguments.employee_id;
			payment_type_id     = arguments.payment_type_id;
			special_definition_id   = arguments.special_definition_id;
			asset_id            = arguments.asset_id;
			branch_id           = arguments.branch_id;
			department_id       = arguments.department_id;
			dsn_alias           = dsn;
			action_type         = 'BANKA MASRAF FİŞİ';
			action_type_id      = 120;
			error_str           = structNew();

			periodQuery = new Query();
			periodQuery.setDatasource("#dsn#");
			periodQuery.setSQL("SELECT PERIOD_YEAR, OUR_COMPANY_ID FROM SETUP_PERIOD WHERE PERIOD_ID = #period_id#");
			periodResult = periodQuery.execute();
			periodResult = periodResult.getResult();

			wodiba_dsn  = dsn;
			wodiba_dsn1 = dsn1;
			wodiba_dsn2 = '#dsn#_#periodResult.period_year#_#periodResult.our_company_id#';
			wodiba_dsn3 = '#dsn#_#periodResult.our_company_id#';
			dsn3_alias  = wodiba_dsn3;

			//oturum değişkenleri, işlem kategorisi için gerekli
			session.ep.period_id    = period_id;
			session.ep.userid       = record_emp;
			session.ep.position_code= 0;
			session.ep.position_name= 'Wodiba';
			session.ep.name         = 'Wodiba';
			session.ep.surname      = 'Wodiba';
			session.ep.company_id   = company_id;
			session.ep.company_nick = '';
			session.ep.period_year  = periodResult.PERIOD_YEAR;
			caller.dsn3_alias       = wodiba_dsn3;

			processCatQuery = new Query();
			processCatQuery.setDatasource("#wodiba_dsn3#");
			processCatQuery.setSQL("SELECT * FROM SETUP_PROCESS_CAT WHERE PROCESS_CAT_ID = #process_cat#");
			processCatResult = processCatQuery.execute();
			processCatResult = processCatResult.getResult();

			moneyQuery = new Query();
			moneyQuery.setDatasource("#wodiba_dsn2#");
			moneyQuery.setSQL("SELECT MONEY, RATE1, RATE2 FROM SETUP_MONEY WHERE PERIOD_ID = #period_id#");
			moneyResult = moneyQuery.execute();
			moneyResult = moneyResult.getResult();

			expenseQuery = new Query();
			expenseQuery.setDatasource("#wodiba_dsn2#");
			expenseQuery.setSQL("SELECT * FROM EXPENSE_ITEMS WHERE EXPENSE_ITEM_ID = #expense_item_id#");
			expenseResult = expenseQuery.execute();
			expenseResult = expenseResult.getResult();

			if (Not Len(expenseResult.ACCOUNT_CODE)) {
				error_str.error_type    = 'account_code';
				error_str.error_message = 'expense_item_id: #expense_item_id# için muhasebe hesabı tanımlı değil!';
			}

			accountQuery = new Query();
			accountQuery.setDatasource("#wodiba_dsn3#");
			accountQuery.setSQL("SELECT ACCOUNT_CURRENCY_ID, ACCOUNT_ACC_CODE FROM ACCOUNTS WHERE ACCOUNT_ID = #account_id#");
			accountResult = accountQuery.execute();
			accountResult = accountResult.getResult();

			if (Not Len(accountResult.ACCOUNT_ACC_CODE)) {
				error_str.error_type    = 'account_code';
				error_str.error_message = 'account_id: #account_id# için muhasebe hesabı tanımlı değil!';
			}

			memberQuery = new Query();
			memberQuery.setDatasource("#wodiba_dsn#");
			memberQuery.setSQL("
				SELECT FULLNAME AS MEMBER_NAME FROM COMPANY WHERE COMPANY_ID = #company_id# UNION ALL
				SELECT CONSUMER_NAME + ' ' + CONSUMER_SURNAME AS MEMBER_NAME FROM CONSUMER WHERE CONSUMER_ID = #consumer_id# UNION ALL
				SELECT EMPLOYEE_NAME + ' ' + EMPLOYEE_SURNAME AS MEMBER_NAME FROM EMPLOYEES WHERE EMPLOYEE_ID = #employee_id#
			");
			memberResult = memberQuery.execute();
			memberResult = memberResult.getResult();

			attributes.kur_say = moneyResult.recordcount;
			attributes.money_type = accountResult.account_currency_id;
			for(mon = 1; mon lte moneyResult.recordcount; mon++){
				evaluate("attributes.hidden_rd_money_#mon#  = moneyResult.money[mon]");
				evaluate("attributes.txt_rate1_#mon#        = moneyResult.rate1[mon]");
				evaluate("attributes.txt_rate2_#mon#        = moneyResult.rate2[mon]");
			}

			member_name_ = memberResult.member_name;
			str_card_detail = '#member_name_#-#detail#';

			if(company_id gt 0){
				member_acc_code = get_company_period(company_id: company_id, period_id: period_id, acc_type_id: processCatResult.ACCOUNT_TYPE_ID);
			}
			else if(consumer_id gt 0){
				member_acc_code = get_consumer_period(consumer_id);
			}
			else if(employee_id gt 0){
				member_acc_code = queryExecute("SELECT TOP 1 ACCOUNT_CODE FROM EMPLOYEES_ACCOUNTS WHERE ACC_TYPE_ID = #acc_type_id# AND PERIOD_ID = #period_id# AND EMPLOYEE_ID = #employee_id# ORDER BY IN_OUT_ID DESC",{},{datasource='#dsn#'}).ACCOUNT_CODE;
			}

			if((company_id gt 0 Or consumer_id gt 0 Or employee_id gt 0) And isDefined('member_acc_code') And Not Len(member_acc_code)) {
				error_str.error_type    = 'account_code';
				error_str.error_message = 'Üye için muhasebe hesabı tanımlı değil!';
			}

			expense_account_code = expenseResult.ACCOUNT_CODE;

			islem_detay                 = UCASETR(get_process_name(process_type));
			is_project_based_acc        = processCatResult.IS_PROJECT_BASED_ACC;
			is_row_project_based_cari   = processCatResult.IS_ROW_PROJECT_BASED_CARI;
			is_cari                     = processCatResult.is_cari;
			is_account                  = processCatResult.is_account;
			is_dept_based_acc           = processCatResult.is_dept_based_acc;
			is_paymethod_based_cari     = processCatResult.is_paymethod_based_cari;
			account_group               = processCatResult.is_account_group;
			is_exp_based_acc            = processCatResult.is_exp_based_acc;
			acc_project_list_alacak     = '';
			acc_project_list_borc       = '';
			fis_satir_row_detail        = '#paper_no# - #detail# - #islem_detay#';
		</cfscript>

		<cfif structIsEmpty(error_str)>
			<cflock timeout="60" name="#CreateUUID()#">
				<cftransaction>
					<cfquery datasource="#wodiba_dsn2#" result="ADD_EXPENSE_TOTAL_COST">
						INSERT INTO
							EXPENSE_ITEM_PLANS
						(
							WRK_ID,
							IS_BANK,
							IS_CASH,
							EXPENSE_CASH_ID,
							EXPENSE_COST_TYPE,
							TOTAL_AMOUNT,
							KDV_TOTAL,
							TOTAL_AMOUNT_KDVLI,
							OTHER_MONEY_AMOUNT,
							OTHER_MONEY_KDV,
							OTHER_MONEY_NET_TOTAL,
							OTHER_MONEY,
							SERIAL_NUMBER,
							SERIAL_NO,
							PAPER_NO,
							PAYMETHOD_ID,
							SYSTEM_RELATION,
							FIRST_PROCESS_CAT,
							PROCESS_CAT,
							ACTION_TYPE,
							EMP_ID,
							EXPENSE_DATE,
							DETAIL,
							CH_COMPANY_ID,
							CH_PARTNER_ID,
							CH_CONSUMER_ID,
							CH_EMPLOYEE_ID,
							DUE_DATE,
							DEPARTMENT_ID,
							BRANCH_ID,
							PROJECT_ID,
							SPECIAL_DEFINITION_ID,
							IS_IPTAL,
							RECORD_DATE,
							RECORD_EMP,
							RECORD_IP
						)
						VALUES
						(
							#sql_unicode()#'#wrk_id#',
							1,
							0,
							#account_id#,
							#action_type_id#,
							#wrk_round(amount.system_action_value_tax_free)#,--TOTAL_AMOUNT
							#wrk_round(amount.tax_value)#,--KDV_TOTAL
							#wrk_round(amount.system_action_value)#,--TOTAL_AMOUNT_KDVLI
							#wrk_round(amount.action_value_tax_free)#,<!--- OTHER_MONEY_AMOUNT --->
							#wrk_round(amount.other_money_tax_value)#,<!--- OTHER_MONEY_KDV --->
							#wrk_round(amount.action_value)#,<!--- OTHER_MONEY_NET_TOTAL --->
							#sql_unicode()#'#amount.action_currency_id#',<!--- OTHER_MONEY --->
							'WDB',
							#sql_unicode()#'#paper_no#',
							#sql_unicode()#'#paper_no#',
							<cfif Len(payment_type_id) And payment_type_id Neq 0>#payment_type_id#<cfelse>NULL</cfif>,
							#sql_unicode()#'#paper_no#',
							#process_cat#,
							#process_cat#,
							#process_type#,
							#record_emp#,
							#date#,
							#sql_unicode()#'#detail#',
							NULL,
							NULL,
							NULL,
							NULL,
							#date#,
							<cfif Len(department_id) And department_id Neq 0>#department_id#<cfelse>NULL</cfif>,
							<cfif Len(branch_id) And branch_id Neq 0>#branch_id#<cfelse>NULL</cfif>,
							<cfif Len(project_id) And project_id Neq 0>#project_id#<cfelse>NULL</cfif>,
							<cfif Len(special_definition_id) And special_definition_id Neq 0>#special_definition_id#<cfelse>NULL</cfif>,
							0,
							#now()#,
							#record_emp#,
							#sql_unicode()#'#cgi.remote_addr#'
						)
					</cfquery>

					<cfquery datasource="#wodiba_dsn2#" result="ADD_BANK_ACTION">
						INSERT INTO
							BANK_ACTIONS
							(
								PROCESS_CAT,
								ACTION_TYPE,
								ACTION_TYPE_ID,
								ACTION_DETAIL,
								ACTION_VALUE,
								BANK_ACTION_KDVSIZ_VALUE,
								BANK_ACTION_TAX_VALUE,
								ACTION_CURRENCY_ID,
								ACTION_DATE,
								OTHER_CASH_ACT_VALUE,
								OTHER_MONEY,
								SYSTEM_ACTION_VALUE,
								SYSTEM_CURRENCY_ID,
								ACTION_VALUE_2,
								ACTION_CURRENCY_ID_2,
								ACTION_EMPLOYEE_ID,
								IS_ACCOUNT,
								IS_ACCOUNT_TYPE,
								PAPER_NO,
								PROJECT_ID,
								ACTION_FROM_ACCOUNT_ID,
								EXPENSE_ID,
								FROM_BRANCH_ID,
								ASSETP_ID,
								SPECIAL_DEFINITION_ID,
								ACC_DEPARTMENT_ID,
								RECORD_DATE,
								RECORD_EMP,
								RECORD_IP
							)
							VALUES
							(
								#process_cat#,
								#sql_unicode()#'#action_type#',
								#process_type#,
								#sql_unicode()#'#action_type#',
								#wrk_round(amount.action_value)#,--ACTION_VALUE
								#wrk_round(amount.action_value_tax_free)#,--BANK_ACTION_KDVSIZ_VALUE
								#wrk_round(amount.other_money_tax_value)#,--BANK_ACTION_TAX_VALUE
								'#amount.action_currency_id#',
								#date#,
								#wrk_round(amount.action_value)#,--OTHER_CASH_ACT_VALUE
								'#amount.action_currency_id#',--OTHER_MONEY
								#wrk_round(amount.system_action_value)#,--SYSTEM_ACTION_VALUE
								'#amount.system_currency_id#',--SYSTEM_CURRENCY_ID
								#wrk_round(amount.system_action_value_2)#,--ACTION_VALUE_2
								'#amount.system_currency_id_2#',--ACTION_CURRENCY_ID_2
								#record_emp#,
								1,
								13,
								#sql_unicode()#'#paper_no#',
								<cfif Len(project_id) And project_id Neq 0>#project_id#<cfelse>NULL</cfif>,
								#account_id#,
								#ADD_EXPENSE_TOTAL_COST.IDENTITYCOL#,
								<cfif Len(branch_id) And branch_id Neq 0>#branch_id#<cfelse>NULL</cfif>,
								<cfif Len(asset_id) And asset_id Neq 0>#asset_id#<cfelse>NULL</cfif>,
								<cfif Len(special_definition_id) And special_definition_id Neq 0>#special_definition_id#<cfelse>NULL</cfif>,
								<cfif Len(department_id) And department_id Neq 0>#department_id#<cfelse>NULL</cfif>,
								#now()#,
								#record_emp#,
								#sql_unicode()#'#cgi.REMOTE_ADDR#'
							)
					</cfquery>

					<cfscript>
						if(Len(other_expense_item_id) And other_expense_item_id Gt 0 And Len(other_expense_rate) And other_expense_rate Gt 0){
							is_other_expense = 1;
						}
						else{
							is_other_expense = 0;
						}

						if(is_other_expense){
							other_expense_account_code = queryExecute("SELECT ACCOUNT_CODE FROM EXPENSE_ITEMS WHERE EXPENSE_ITEM_ID = #other_expense_item_id#",{},{datasource='#wodiba_dsn2#'}).ACCOUNT_CODE;

							amount_new 							= structNew();
							amount_new.ACTION_CURRENCY_ID		= amount.ACTION_CURRENCY_ID;
							amount_new.ACTION_RATE				= amount.ACTION_RATE;
							amount_new.ACTION_RATE_2			= amount.ACTION_RATE_2;
							amount_new.ACTION_VALUE				= amount.ACTION_VALUE - ((amount.ACTION_VALUE / 100) * other_expense_rate);
							amount_new.action_value_tax_free    = amount.action_value_tax_free - ((amount.action_value_tax_free / 100) * other_expense_rate);
							amount_new.SYSTEM_ACTION_VALUE		= amount.SYSTEM_ACTION_VALUE - ((amount.SYSTEM_ACTION_VALUE / 100) * other_expense_rate);
							amount_new.system_action_value_tax_free = amount.system_action_value_tax_free - ((amount.system_action_value_tax_free / 100) * other_expense_rate);
							amount_new.SYSTEM_ACTION_VALUE_2	= amount.SYSTEM_ACTION_VALUE_2 - ((amount.SYSTEM_ACTION_VALUE_2 / 100) * other_expense_rate);
							amount_new.SYSTEM_CURRENCY_ID		= amount.SYSTEM_CURRENCY_ID;
							amount_new.SYSTEM_CURRENCY_ID_2		= amount.SYSTEM_CURRENCY_ID_2;
							amount_new.TAX						= amount.TAX;
							amount_new.TAX_VALUE				= amount.TAX_VALUE - ((amount.TAX_VALUE / 100) * other_expense_rate);

							other_amount 						= structNew();
							other_amount.ACTION_CURRENCY_ID		= amount.ACTION_CURRENCY_ID;
							other_amount.ACTION_RATE			= amount.ACTION_RATE;
							other_amount.ACTION_RATE_2			= amount.ACTION_RATE_2;
							other_amount.TAX					= amount.TAX;
							other_amount.TAX_VALUE				= (amount.TAX_VALUE / 100) * other_expense_rate;
							other_amount.ACTION_VALUE			= (amount.ACTION_VALUE / 100) * other_expense_rate;
							other_amount.action_value_tax_free  = ((amount.ACTION_VALUE / 100) * other_expense_rate) - other_amount.tax_value;
							other_amount.SYSTEM_ACTION_VALUE	= (amount.SYSTEM_ACTION_VALUE / 100) * other_expense_rate;
							other_amount.system_action_value_tax_free = ((amount.SYSTEM_ACTION_VALUE / 100) * other_expense_rate) - other_amount.tax_value;
							other_amount.SYSTEM_ACTION_VALUE_2	= (amount.SYSTEM_ACTION_VALUE_2 / 100) * other_expense_rate;
							other_amount.SYSTEM_CURRENCY_ID		= amount.SYSTEM_CURRENCY_ID;
							other_amount.SYSTEM_CURRENCY_ID_2	= amount.SYSTEM_CURRENCY_ID_2;

							wodiba_butceci(
								muhasebe_db: wodiba_dsn2,
								expense_id: ADD_EXPENSE_TOTAL_COST.IDENTITYCOL,
								expense_date: date,
								expense_center_id: expense_center_id,
								expense_item_id: expense_item_id,
								expense_account_code: expense_account_code,
								process_type: action_type_id,
								detail: detail,
								is_income_expense: false,
								action_id: 0,
								amount: amount_new,
								paper_no: paper_no,
								branch_id: 0,
								record_emp: record_emp,
								project_id: project_id,
								asset_id: asset_id
							);

							wodiba_butceci(
								muhasebe_db: wodiba_dsn2,
								expense_id: ADD_EXPENSE_TOTAL_COST.IDENTITYCOL,
								expense_date: date,
								expense_center_id: expense_center_id,
								expense_item_id: other_expense_item_id,
								expense_account_code: other_expense_account_code,
								process_type: action_type_id,
								detail: detail,
								is_income_expense: false,
								action_id: 0,
								amount: other_amount,
								paper_no: paper_no,
								branch_id: 0,
								record_emp: record_emp,
								project_id: project_id,
								asset_id: asset_id
							);
						}
						else {
							wodiba_butceci(
								muhasebe_db: wodiba_dsn2,
								expense_id: ADD_EXPENSE_TOTAL_COST.IDENTITYCOL,
								expense_date: date,
								expense_center_id: expense_center_id,
								expense_item_id: expense_item_id,
								expense_account_code: expense_account_code,
								process_type: action_type_id,
								detail: detail,
								is_income_expense: false,
								action_id: 0,
								amount: amount,
								paper_no: paper_no,
								branch_id: 0,
								record_emp: record_emp,
								project_id: project_id,
								asset_id: asset_id
							);
						}

						f_kur_ekle_action(
							action_id: ADD_EXPENSE_TOTAL_COST.IDENTITYCOL,
							process_type: 0,
							action_table_name: 'EXPENSE_ITEM_PLANS_MONEY',
							action_table_dsn: '#wodiba_dsn2#'
						);

						if(processCatResult.is_account eq 1)
						{
							if(is_other_expense){
								str_borclu_hesaplar     		= expense_account_code;
								str_borclu_tutarlar     		= wrk_round(amount_new.system_action_value_tax_free);
								str_borclu_other_amount_tutar   = wrk_round(amount_new.action_value_tax_free);
								str_borclu_other_currency       = amount.action_currency_id;

								str_borclu_hesaplar 			= ListAppend(str_borclu_hesaplar,other_expense_account_code,",");
								str_borclu_tutarlar 			= ListAppend(str_borclu_tutarlar,wrk_round(other_amount.system_action_value_tax_free),",");
								str_borclu_other_amount_tutar   = ListAppend(str_borclu_other_amount_tutar,wrk_round(other_amount.action_value_tax_free),",");
								str_borclu_other_currency       = ListAppend(str_borclu_other_currency,amount.action_currency_id,",");
							}
							else{
								str_borclu_hesaplar     		= expense_account_code;
								str_borclu_tutarlar     		= wrk_round(amount.system_action_value_tax_free);
								str_borclu_other_amount_tutar   = wrk_round(amount.action_value_tax_free);
								str_borclu_other_currency       = amount.action_currency_id;
							}

							str_alacakli_hesaplar   			= accountResult.ACCOUNT_ACC_CODE;
							str_alacakli_tutarlar   			= wrk_round(amount.system_action_value);
							str_alacakli_other_amount_tutar 	= wrk_round(amount.action_value);
							str_alacakli_other_currency     	= amount.action_currency_id;

							if(amount.tax Gt 0){
								get_tax_acc_code				= cfquery(datasource: "#dsn2#", sqlstring: "SELECT PURCHASE_CODE FROM SETUP_TAX WHERE TAX = #amount.tax#");
								str_borclu_hesaplar 			= ListAppend(str_borclu_hesaplar,get_tax_acc_code.PURCHASE_CODE,",");
								str_borclu_tutarlar 			= ListAppend(str_borclu_tutarlar,wrk_round(amount.tax_value),",");
								str_borclu_other_amount_tutar   = ListAppend(str_borclu_other_amount_tutar,wrk_round(amount.other_money_tax_value),",");
								str_borclu_other_currency       = ListAppend(str_borclu_other_currency,amount.action_currency_id,",");
							}

							if (ListLen(str_alacakli_hesaplar) And ListLen(str_borclu_hesaplar)) {
								wodiba_muhasebeci(
									action_id: ADD_EXPENSE_TOTAL_COST.IDENTITYCOL,
									workcube_process_type: action_type_id,
									workcube_process_cat: process_cat,
									account_card_type: 13,
									company_id: iif(company_id neq 0,company_id,de('')),
									consumer_id: iif(consumer_id neq 0,consumer_id,de('')),
									employee_id: iif(employee_id neq 0,employee_id,de('')),
									islem_tarihi: date,
									fis_satir_detay: fis_satir_row_detail,
									borc_hesaplar: str_borclu_hesaplar,
									borc_tutarlar: str_borclu_tutarlar,
									other_amount_borc : str_borclu_other_amount_tutar,
									other_currency_borc : str_borclu_other_currency,
									alacak_hesaplar: str_alacakli_hesaplar,
									alacak_tutarlar: str_alacakli_tutarlar,
									other_amount_alacak : str_alacakli_other_amount_tutar,
									other_currency_alacak : str_alacakli_other_currency,
									currency_multiplier : amount.action_rate_2,
									fis_detay: action_type,
									belge_no : paper_no,
									is_abort : 0,
									action_currency : amount.system_currency_id,
									action_currency_2 : amount.system_currency_id_2,
									muhasebe_db: wodiba_dsn2,
									period_id: period_id,
									acc_department_id : department_id,
									acc_project_id : project_id
								);
							}
						}
					</cfscript>
				</cftransaction>
			</cflock>

			<!--- <cf_workcube_process_cat
				process_cat="#process_cat#"
				action_id = #ADD_EXPENSE_TOTAL_COST.IDENTITYCOL#
				is_action_file = 1
				action_table="EXPENSE_ITEM_PLANS"
				action_column="EXPENSE_ID"
				action_file_name='#processCatResult.action_file_name#'
				action_page='#request.self#?fuseaction=cost.form_add_expense_cost&event=upd&expense_id=#ADD_EXPENSE_TOTAL_COST.IDENTITYCOL#'
				action_db_type="#wodiba_dsn2#"
				is_template_action_file = '#processCatResult.action_file_from_template#'> --->

			<cf_add_log	log_type="1" action_id="#ADD_EXPENSE_TOTAL_COST.IDENTITYCOL#" action_name="#paper_no# Eklendi" paper_no="#paper_no#" period_id="#period_id#" process_type="#processCatResult.process_type#" data_source="#wodiba_dsn2#">

			<cfscript>
				return_struct                   = structNew();
				return_struct.bank_action_id    = ADD_BANK_ACTION.IDENTITYCOL;
				return_struct.document_id       = ADD_EXPENSE_TOTAL_COST.IDENTITYCOL;
			</cfscript>
		
			<cfreturn return_struct />
		<cfelse>
			<cfreturn error_str />
		</cfif>
	</cffunction>

	<cffunction name="addIncomingExpenseCost" access="public" returntype="struct" output="false" hint="Wodiba gelir fişi ekler">
		<cfargument name="period_id" type="numeric" required="true" />
		<cfargument name="process_cat" type="numeric" required="true" />
		<cfargument name="acc_type_id" type="numeric" required="true" />
		<cfargument name="account_id" type="numeric" required="true" />
		<cfargument name="amount" type="any" required="true" hint="Tutarlar structure ile gönderilmelidir" />
		<cfargument name="date" type="date" required="true" />
		<cfargument name="detail" type="string" required="true" />
		<cfargument name="paper_no" type="string" required="true" />
		<cfargument name="record_emp" type="numeric" required="true" />
		<cfargument name="expense_center_id" type="numeric" required="true" />
		<cfargument name="expense_item_id" type="numeric" required="true" />
		<cfargument name="other_expense_item_id" type="numeric" required="true" />
		<cfargument name="other_expense_rate" type="numeric" required="true" />
		<cfargument name="project_id" type="numeric" required="true" />
		<cfargument name="company_id" type="numeric" required="true" />
		<cfargument name="consumer_id" type="numeric" required="true" />
		<cfargument name="employee_id" type="numeric" required="true" />
		<cfargument name="payment_type_id" type="numeric" required="true" />
		<cfargument name="special_definition_id" type="numeric" required="true" />
		<cfargument name="asset_id" type="numeric" required="true" />
		<cfargument name="branch_id" type="numeric" required="true" />
		<cfargument name="department_id" type="numeric" required="true" />

		<cfscript>
			wrk_id              = dateformat(now(),'YYYYMMDD')&timeformat(now(),'HHmmss')&'_#arguments.record_emp#_'&round(rand()*100);
			period_id           = arguments.period_id;
			process_cat         = arguments.process_cat;
			acc_type_id         = arguments.acc_type_id;
			account_id          = arguments.account_id;
			amount              = arguments.amount;
			date                = arguments.date;
			detail              = arguments.detail;
			paper_no            = arguments.paper_no;
			record_emp          = arguments.record_emp;
			expense_center_id   = arguments.expense_center_id;
			expense_item_id     = arguments.expense_item_id;
			other_expense_item_id= arguments.other_expense_item_id;
			other_expense_rate   = arguments.other_expense_rate;
			project_id          = arguments.project_id;
			company_id          = arguments.company_id;
			consumer_id         = arguments.consumer_id;
			employee_id         = arguments.employee_id;
			payment_type_id     = arguments.payment_type_id;
			special_definition_id   = arguments.special_definition_id;
			asset_id            = arguments.asset_id;
			branch_id           = arguments.branch_id;
			department_id       = arguments.department_id;
			dsn_alias           = dsn;
			error_str           = structNew();

			action_type         = 'BANKA GELİR FİŞİ';
			action_type_id      = 121;

			periodQuery = new Query();
			periodQuery.setDatasource("#dsn#");
			periodQuery.setSQL("SELECT PERIOD_YEAR, OUR_COMPANY_ID FROM SETUP_PERIOD WHERE PERIOD_ID = #period_id#");
			periodResult = periodQuery.execute();
			periodResult = periodResult.getResult();

			wodiba_dsn  = dsn;
			wodiba_dsn1 = dsn1;
			wodiba_dsn2 = '#dsn#_#periodResult.period_year#_#periodResult.our_company_id#';
			wodiba_dsn3 = '#dsn#_#periodResult.our_company_id#';
			dsn3_alias  = wodiba_dsn3;

			//oturum değişkenleri, işlem kategorisi için gerekli
			session.ep.period_id    = period_id;
			session.ep.userid       = record_emp;
			session.ep.position_code= 0;
			session.ep.position_name= 'Wodiba';
			session.ep.name         = 'Wodiba';
			session.ep.surname      = 'Wodiba';
			session.ep.company_id   = company_id;
			session.ep.company_nick = '';
			session.ep.period_year  = periodResult.PERIOD_YEAR;
			caller.dsn3_alias       = wodiba_dsn3;

			processCatQuery = new Query();
			processCatQuery.setDatasource("#wodiba_dsn3#");
			processCatQuery.setSQL("SELECT * FROM SETUP_PROCESS_CAT WHERE PROCESS_CAT_ID = #process_cat#");
			processCatResult = processCatQuery.execute();
			processCatResult = processCatResult.getResult();

			moneyQuery = new Query();
			moneyQuery.setDatasource("#wodiba_dsn2#");
			moneyQuery.setSQL("SELECT MONEY, RATE1, RATE2 FROM SETUP_MONEY WHERE PERIOD_ID = #period_id#");
			moneyResult = moneyQuery.execute();
			moneyResult = moneyResult.getResult();

			expenseQuery = new Query();
			expenseQuery.setDatasource("#wodiba_dsn2#");
			expenseQuery.setSQL("SELECT * FROM EXPENSE_ITEMS WHERE EXPENSE_ITEM_ID = #expense_item_id#");
			expenseResult = expenseQuery.execute();
			expenseResult = expenseResult.getResult();

			if (Not Len(expenseResult.ACCOUNT_CODE)) {
				error_str.error_type    = 'account_code';
				error_str.error_message = 'expense_item_id: #expense_item_id# için muhasebe hesabı tanımlı değil!';
			}

			accountQuery = new Query();
			accountQuery.setDatasource("#wodiba_dsn3#");
			accountQuery.setSQL("SELECT ACCOUNT_CURRENCY_ID, ACCOUNT_ACC_CODE FROM ACCOUNTS WHERE ACCOUNT_ID = #account_id#");
			accountResult = accountQuery.execute();
			accountResult = accountResult.getResult();

			if (Not Len(accountResult.ACCOUNT_ACC_CODE)) {
				error_str.error_type    = 'account_code';
				error_str.error_message = 'account_id: #account_id# için muhasebe hesabı tanımlı değil!';
			}

			memberQuery = new Query();
			memberQuery.setDatasource("#wodiba_dsn#");
			memberQuery.setSQL("
				SELECT FULLNAME AS MEMBER_NAME FROM COMPANY WHERE COMPANY_ID = #company_id# UNION ALL
				SELECT CONSUMER_NAME + ' ' + CONSUMER_SURNAME AS MEMBER_NAME FROM CONSUMER WHERE CONSUMER_ID = #consumer_id# UNION ALL
				SELECT EMPLOYEE_NAME + ' ' + EMPLOYEE_SURNAME AS MEMBER_NAME FROM EMPLOYEES WHERE EMPLOYEE_ID = #employee_id#
			");
			memberResult = memberQuery.execute();
			memberResult = memberResult.getResult();

			attributes.kur_say = moneyResult.recordcount;
			attributes.money_type = accountResult.account_currency_id;
			for(mon = 1; mon lte moneyResult.recordcount; mon++){
				evaluate("attributes.hidden_rd_money_#mon#  = moneyResult.money[mon]");
				evaluate("attributes.txt_rate1_#mon#        = moneyResult.rate1[mon]");
				evaluate("attributes.txt_rate2_#mon#        = moneyResult.rate2[mon]");
			}

			member_name_ = memberResult.member_name;
			str_card_detail = '#member_name_#-#detail#';

			if(company_id gt 0){
				member_acc_code = get_company_period(company_id: company_id, period_id: period_id, acc_type_id: processCatResult.ACCOUNT_TYPE_ID);
			}
			else if(consumer_id gt 0){
				member_acc_code = get_consumer_period(consumer_id);
			}
			else if(employee_id gt 0){
				member_acc_code = queryExecute("SELECT TOP 1 ACCOUNT_CODE FROM EMPLOYEES_ACCOUNTS WHERE ACC_TYPE_ID = #acc_type_id# AND PERIOD_ID = #period_id# AND EMPLOYEE_ID = #employee_id# ORDER BY IN_OUT_ID DESC",{},{datasource='#dsn#'}).ACCOUNT_CODE;
			}

			if((company_id gt 0 Or consumer_id gt 0 Or employee_id gt 0) And isDefined('member_acc_code') And Not Len(member_acc_code)) {
				error_str.error_type    = 'account_code';
				error_str.error_message = 'Üye için muhasebe hesabı tanımlı değil!';
			}

			expense_account_code = expenseResult.ACCOUNT_CODE;

			islem_detay                     = UCASETR(get_process_name(process_type));
			is_project_based_acc            = processCatResult.IS_PROJECT_BASED_ACC;
			is_row_project_based_cari       = processCatResult.IS_ROW_PROJECT_BASED_CARI;
			is_cari                         = processCatResult.is_cari;
			is_account                      = processCatResult.is_account;
			is_dept_based_acc               = processCatResult.is_dept_based_acc;
			is_paymethod_based_cari         = processCatResult.is_paymethod_based_cari;
			account_group                   = processCatResult.is_account_group;
			is_exp_based_acc                = processCatResult.is_exp_based_acc;
			acc_project_list_alacak         = '';
			acc_project_list_borc           = '';
			fis_satir_row_detail            = '#paper_no# - #detail# - #islem_detay#';
		</cfscript>

		<cfif structIsEmpty(error_str)>
			<cflock timeout="60" name="#CreateUUID()#">
				<cftransaction>
					<cfquery datasource="#wodiba_dsn2#" result="ADD_EXPENSE_TOTAL_COST">
						INSERT INTO
							EXPENSE_ITEM_PLANS
						(
							WRK_ID,
							IS_BANK,
							IS_CASH,
							EXPENSE_CASH_ID,
							EXPENSE_COST_TYPE,
							TOTAL_AMOUNT,
							KDV_TOTAL,
							TOTAL_AMOUNT_KDVLI,
							OTHER_MONEY_AMOUNT,
							OTHER_MONEY_KDV,
							OTHER_MONEY_NET_TOTAL,
							OTHER_MONEY,
							SERIAL_NUMBER,
							SERIAL_NO,
							PAPER_NO,
							PAYMETHOD_ID,
							SYSTEM_RELATION,
							FIRST_PROCESS_CAT,
							PROCESS_CAT,
							ACTION_TYPE,
							EMP_ID,
							EXPENSE_DATE,
							DETAIL,
							CH_COMPANY_ID,
							CH_PARTNER_ID,
							CH_CONSUMER_ID,
							CH_EMPLOYEE_ID,
							DUE_DATE,
							DEPARTMENT_ID,
							BRANCH_ID,
							PROJECT_ID,
							SPECIAL_DEFINITION_ID,
							IS_IPTAL,
							RECORD_DATE,
							RECORD_EMP,
							RECORD_IP
						)
						VALUES
						(
							#sql_unicode()#'#wrk_id#',
							1,
							0,
							#account_id#,
							#action_type_id#,
							#wrk_round(amount.system_action_value_tax_free)#,--TOTAL_AMOUNT
							#wrk_round(amount.tax_value)#,--KDV_TOTAL
							#wrk_round(amount.system_action_value)#,--TOTAL_AMOUNT_KDVLI
							#wrk_round(amount.action_value_tax_free)#,<!--- OTHER_MONEY_AMOUNT --->
							#wrk_round(amount.other_money_tax_value)#,<!--- OTHER_MONEY_KDV --->
							#wrk_round(amount.action_value)#,<!--- OTHER_MONEY_NET_TOTAL --->
							#sql_unicode()#'#amount.action_currency_id#',<!--- OTHER_MONEY --->
							'WDB',
							#sql_unicode()#'#paper_no#',
							#sql_unicode()#'#paper_no#',
							<cfif Len(payment_type_id) And payment_type_id Neq 0>#payment_type_id#<cfelse>NULL</cfif>,
							#sql_unicode()#'#paper_no#',
							#process_cat#,
							#process_cat#,
							#process_type#,
							#record_emp#,
							#date#,
							#sql_unicode()#'#detail#',
							NULL,
							NULL,
							NULL,
							NULL,
							#date#,
							<cfif Len(department_id) And department_id Neq 0>#department_id#<cfelse>NULL</cfif>,
							<cfif Len(branch_id) And branch_id Neq 0>#branch_id#<cfelse>NULL</cfif>,
							<cfif Len(project_id) And project_id Neq 0>#project_id#<cfelse>NULL</cfif>,
							<cfif Len(special_definition_id) And special_definition_id Neq 0>#special_definition_id#<cfelse>NULL</cfif>,
							0,
							#now()#,
							#record_emp#,
							#sql_unicode()#'#cgi.remote_addr#'
						)
					</cfquery>

					<cfquery datasource="#wodiba_dsn2#" result="ADD_BANK_ACTION">
						INSERT INTO
							BANK_ACTIONS
							(
								PROCESS_CAT,
								ACTION_TYPE,
								ACTION_TYPE_ID,
								ACTION_DETAIL,
								ACTION_VALUE,
								BANK_ACTION_KDVSIZ_VALUE,
								BANK_ACTION_TAX_VALUE,
								ACTION_CURRENCY_ID,
								ACTION_DATE,
								OTHER_CASH_ACT_VALUE,
								OTHER_MONEY,
								SYSTEM_ACTION_VALUE,
								SYSTEM_CURRENCY_ID,
								ACTION_VALUE_2,
								ACTION_CURRENCY_ID_2,
								ACTION_EMPLOYEE_ID,
								IS_ACCOUNT,
								IS_ACCOUNT_TYPE,
								PAPER_NO,
								PROJECT_ID,
								ACTION_TO_ACCOUNT_ID,
								EXPENSE_ID,
								FROM_BRANCH_ID,
								ASSETP_ID,
								SPECIAL_DEFINITION_ID,
								ACC_DEPARTMENT_ID,
								RECORD_DATE,
								RECORD_EMP,
								RECORD_IP
							)
							VALUES
							(
								#process_cat#,
								#sql_unicode()#'#action_type#',
								#process_type#,
								#sql_unicode()#'#action_type#',
								#wrk_round(amount.action_value)#,--ACTION_VALUE
								#wrk_round(amount.action_value_tax_free)#,--BANK_ACTION_KDVSIZ_VALUE
								#wrk_round(amount.other_money_tax_value)#,--BANK_ACTION_TAX_VALUE
								'#amount.action_currency_id#',
								#date#,
								#wrk_round(amount.action_value)#,--OTHER_CASH_ACT_VALUE
								'#amount.action_currency_id#',--OTHER_MONEY
								#wrk_round(amount.system_action_value)#,--SYSTEM_ACTION_VALUE
								'#amount.system_currency_id#',--SYSTEM_CURRENCY_ID
								#wrk_round(amount.system_action_value_2)#,--ACTION_VALUE_2
								'#amount.system_currency_id_2#',--ACTION_CURRENCY_ID_2
								#record_emp#,
								1,
								13,
								#sql_unicode()#'#paper_no#',
								<cfif Len(project_id) And project_id Neq 0>#project_id#<cfelse>NULL</cfif>,
								#account_id#,
								#ADD_EXPENSE_TOTAL_COST.IDENTITYCOL#,
								<cfif Len(branch_id) And branch_id Neq 0>#branch_id#<cfelse>NULL</cfif>,
								<cfif Len(asset_id) And asset_id Neq 0>#asset_id#<cfelse>NULL</cfif>,
								<cfif Len(special_definition_id) And special_definition_id Neq 0>#special_definition_id#<cfelse>NULL</cfif>,
								<cfif Len(department_id) And department_id Neq 0>#department_id#<cfelse>NULL</cfif>,
								#now()#,
								#record_emp#,
								#sql_unicode()#'#cgi.REMOTE_ADDR#'
							)
					</cfquery>

					<cfscript>
						if(Len(other_expense_item_id) And other_expense_item_id Gt 0 And Len(other_expense_rate) And other_expense_rate Gt 0){
							is_other_expense = 1;
						}
						else{
							is_other_expense = 0;
						}

						if(is_other_expense){
							other_expense_account_code = queryExecute("SELECT ACCOUNT_CODE FROM EXPENSE_ITEMS WHERE EXPENSE_ITEM_ID = #other_expense_item_id#",{},{datasource='#wodiba_dsn2#'}).ACCOUNT_CODE;

							amount_new 							= structNew();
							amount_new.ACTION_CURRENCY_ID		= amount.ACTION_CURRENCY_ID;
							amount_new.ACTION_RATE				= amount.ACTION_RATE;
							amount_new.ACTION_RATE_2			= amount.ACTION_RATE_2;
							amount_new.ACTION_VALUE				= amount.ACTION_VALUE - ((amount.ACTION_VALUE / 100) * other_expense_rate);
							amount_new.action_value_tax_free    = amount.action_value_tax_free - ((amount.action_value_tax_free / 100) * other_expense_rate);
							amount_new.SYSTEM_ACTION_VALUE		= amount.SYSTEM_ACTION_VALUE - ((amount.SYSTEM_ACTION_VALUE / 100) * other_expense_rate);
							amount_new.system_action_value_tax_free = amount.system_action_value_tax_free - ((amount.system_action_value_tax_free / 100) * other_expense_rate);
							amount_new.SYSTEM_ACTION_VALUE_2	= amount.SYSTEM_ACTION_VALUE_2 - ((amount.SYSTEM_ACTION_VALUE_2 / 100) * other_expense_rate);
							amount_new.SYSTEM_CURRENCY_ID		= amount.SYSTEM_CURRENCY_ID;
							amount_new.SYSTEM_CURRENCY_ID_2		= amount.SYSTEM_CURRENCY_ID_2;
							amount_new.TAX						= amount.TAX;
							amount_new.TAX_VALUE				= amount.TAX_VALUE - ((amount.TAX_VALUE / 100) * other_expense_rate);

							other_amount 						= structNew();
							other_amount.ACTION_CURRENCY_ID		= amount.ACTION_CURRENCY_ID;
							other_amount.ACTION_RATE			= amount.ACTION_RATE;
							other_amount.ACTION_RATE_2			= amount.ACTION_RATE_2;
							other_amount.TAX					= amount.TAX;
							other_amount.TAX_VALUE				= (amount.TAX_VALUE / 100) * other_expense_rate;
							other_amount.ACTION_VALUE			= (amount.ACTION_VALUE / 100) * other_expense_rate;
							other_amount.action_value_tax_free  = ((amount.ACTION_VALUE / 100) * other_expense_rate) - other_amount.tax_value;
							other_amount.SYSTEM_ACTION_VALUE	= (amount.SYSTEM_ACTION_VALUE / 100) * other_expense_rate;
							other_amount.system_action_value_tax_free = ((amount.SYSTEM_ACTION_VALUE / 100) * other_expense_rate) - other_amount.tax_value;
							other_amount.SYSTEM_ACTION_VALUE_2	= (amount.SYSTEM_ACTION_VALUE_2 / 100) * other_expense_rate;
							other_amount.SYSTEM_CURRENCY_ID		= amount.SYSTEM_CURRENCY_ID;
							other_amount.SYSTEM_CURRENCY_ID_2	= amount.SYSTEM_CURRENCY_ID_2;

							wodiba_butceci(
								muhasebe_db: wodiba_dsn2,
								expense_id: ADD_EXPENSE_TOTAL_COST.IDENTITYCOL,
								expense_date: date,
								expense_center_id: expense_center_id,
								expense_item_id: expense_item_id,
								expense_account_code: expense_account_code,
								process_type: action_type_id,
								detail: detail,
								is_income_expense: true,
								action_id: 0,
								amount: amount_new,
								paper_no: paper_no,
								branch_id: 0,
								record_emp: record_emp,
								project_id: project_id,
								asset_id: asset_id
							);

							wodiba_butceci(
								muhasebe_db: wodiba_dsn2,
								expense_id: ADD_EXPENSE_TOTAL_COST.IDENTITYCOL,
								expense_date: date,
								expense_center_id: expense_center_id,
								expense_item_id: other_expense_item_id,
								expense_account_code: other_expense_account_code,
								process_type: action_type_id,
								detail: detail,
								is_income_expense: true,
								action_id: 0,
								amount: other_amount,
								paper_no: paper_no,
								branch_id: 0,
								record_emp: record_emp,
								project_id: project_id,
								asset_id: asset_id
							);
						}
						else {
							wodiba_butceci(
								muhasebe_db: wodiba_dsn2,
								expense_id: ADD_EXPENSE_TOTAL_COST.IDENTITYCOL,
								expense_date: date,
								expense_center_id: expense_center_id,
								expense_item_id: expense_item_id,
								expense_account_code: expense_account_code,
								process_type: action_type_id,
								detail: detail,
								is_income_expense: true,
								action_id: 0,
								amount: amount,
								paper_no: paper_no,
								branch_id: 0,
								record_emp: record_emp,
								project_id: project_id,
								asset_id: asset_id
							);
						}

						f_kur_ekle_action(
							action_id: ADD_EXPENSE_TOTAL_COST.IDENTITYCOL,
							process_type: 0,
							action_table_name: 'EXPENSE_ITEM_PLANS_MONEY',
							action_table_dsn: '#wodiba_dsn2#'
						);

						if(processCatResult.is_account eq 1)
						{
							str_borclu_hesaplar     			= accountResult.ACCOUNT_ACC_CODE;
							str_borclu_tutarlar     			= wrk_round(amount.system_action_value);
							str_borclu_other_amount_tutar   	= wrk_round(amount.action_value);
							str_borclu_other_currency       	= amount.action_currency_id;

							if(is_other_expense){
								str_alacakli_hesaplar   		= expense_account_code;
								str_alacakli_tutarlar   		= wrk_round(amount_new.system_action_value_tax_free);
								str_alacakli_other_amount_tutar = wrk_round(amount_new.action_value_tax_free);
								str_alacakli_other_currency     = amount.action_currency_id;

								str_alacakli_hesaplar 			= ListAppend(str_alacakli_hesaplar,other_expense_account_code,",");
								str_alacakli_tutarlar 			= ListAppend(str_alacakli_tutarlar,wrk_round(other_amount.system_action_value_tax_free),",");
								str_alacakli_other_amount_tutar	= ListAppend(str_alacakli_other_amount_tutar,wrk_round(other_amount.action_value_tax_free),",");
								str_alacakli_other_currency		= ListAppend(str_alacakli_other_currency,amount.action_currency_id,",");
							}
							else{
								str_alacakli_hesaplar   		= expense_account_code;
								str_alacakli_tutarlar   		= wrk_round(amount.system_action_value_tax_free);
								str_alacakli_other_amount_tutar = wrk_round(amount.action_value_tax_free);
								str_alacakli_other_currency     = amount.action_currency_id;
							}

							if(amount.tax Gt 0){
								get_tax_acc_code				= cfquery(datasource: "#dsn2#", sqlstring: "SELECT SALE_CODE FROM SETUP_TAX WHERE TAX = #amount.tax#");
								str_alacakli_hesaplar 			= ListAppend(str_alacakli_hesaplar,get_tax_acc_code.SALE_CODE,",");
								str_alacakli_tutarlar 			= ListAppend(str_alacakli_tutarlar,wrk_round(amount.tax_value),",");
								str_alacakli_other_amount_tutar	= ListAppend(str_alacakli_other_amount_tutar,wrk_round(amount.other_money_tax_value),",");
								str_alacakli_other_currency		= ListAppend(str_alacakli_other_currency,amount.action_currency_id,",");
							}

							if (ListLen(str_alacakli_hesaplar) And ListLen(str_borclu_hesaplar)) {
								wodiba_muhasebeci (
									action_id: ADD_EXPENSE_TOTAL_COST.IDENTITYCOL,
									workcube_process_type: action_type_id,
									workcube_process_cat: process_cat,
									account_card_type: 13,
									company_id: iif(company_id neq 0,company_id,de('')),
									consumer_id: iif(consumer_id neq 0,consumer_id,de('')),
									employee_id: iif(employee_id neq 0,employee_id,de('')),
									islem_tarihi: date,
									fis_satir_detay: fis_satir_row_detail,
									borc_hesaplar: str_borclu_hesaplar,
									borc_tutarlar: str_borclu_tutarlar,
									other_amount_borc : str_borclu_other_amount_tutar,
									other_currency_borc : str_borclu_other_currency,
									alacak_hesaplar: str_alacakli_hesaplar,
									alacak_tutarlar: str_alacakli_tutarlar,
									other_amount_alacak : str_alacakli_other_amount_tutar,
									other_currency_alacak : str_alacakli_other_currency,
									currency_multiplier : amount.action_rate_2,
									fis_detay: action_type,
									belge_no : paper_no,
									is_abort : 0,
									action_currency : amount.system_currency_id,
									action_currency_2 : amount.system_currency_id_2,
									muhasebe_db: wodiba_dsn2,
									period_id: period_id,
									acc_department_id : department_id,
									acc_project_id : project_id
								);
							}
						}
					</cfscript>
				</cftransaction>
			</cflock>

			<!--- <cf_workcube_process_cat
				process_cat="#process_cat#"
				action_id = #ADD_EXPENSE_TOTAL_COST.IDENTITYCOL#
				is_action_file = 1
				action_table="EXPENSE_ITEM_PLANS"
				action_column="EXPENSE_ID"
				action_file_name='#processCatResult.action_file_name#'
				action_page='#request.self#?fuseaction=cost.form_add_expense_cost&event=upd&expense_id=#ADD_EXPENSE_TOTAL_COST.IDENTITYCOL#'
				action_db_type="#wodiba_dsn2#"
				is_template_action_file = '#processCatResult.action_file_from_template#'> --->

			<cf_add_log	log_type="1" action_id="#ADD_EXPENSE_TOTAL_COST.IDENTITYCOL#" action_name="#paper_no# Eklendi" paper_no="#paper_no#" period_id="#period_id#" process_type="#processCatResult.process_type#" data_source="#wodiba_dsn2#">

			<cfscript>
				return_struct                   = structNew();
				return_struct.bank_action_id    = ADD_BANK_ACTION.IDENTITYCOL;
				return_struct.document_id       = ADD_EXPENSE_TOTAL_COST.IDENTITYCOL;
			</cfscript>
		
			<cfreturn return_struct />
		<cfelse>
			<cfreturn error_str />
		</cfif>
	</cffunction>

	<cffunction name="addEFT" access="public" returntype="struct" output="false" hint="Virman işlemi eklemek için kullanılır">
		<cfargument name="arguments_str" type="struct" required="true" displayname="Parametreler" hint="İşlem parametreleri structure olarak gönderilmelidir." />

		<cfscript>
			wrk_id                  = dateformat(now(),'YYYYMMDD')&timeformat(now(),'HHmmss')&'_#arguments.arguments_str.record_emp#_'&round(rand()*100);
			period_id               = arguments.arguments_str.period_id;
			process_cat             = arguments.arguments_str.process_cat;
			from_account_id         = arguments.arguments_str.from_account_id;
			from_amount             = arguments.arguments_str.from_amount;
			date                    = arguments.arguments_str.date;
			from_detail             = arguments.arguments_str.from_detail;
			from_paper_no           = arguments.arguments_str.from_paper_no;
			to_amount               = arguments.arguments_str.to_amount;
			to_account_id           = arguments.arguments_str.to_account_id;
			to_detail               = arguments.arguments_str.to_detail;
			to_paper_no             = arguments.arguments_str.to_paper_no;
			currency                = to_amount.action_rate;
			record_emp              = arguments.arguments_str.record_emp;
			expense_center_id       = arguments.arguments_str.expense_center_id;
			expense_item_id         = arguments.arguments_str.expense_item_id;
			project_id              = arguments.arguments_str.project_id;
			special_definition_id   = arguments.arguments_str.special_definition_id;
			branch_id               = arguments.arguments_str.branch_id;
			branch_id_borc          = arguments.arguments_str.branch_id_borc;
			branch_id_alacak          = arguments.arguments_str.branch_id_alacak;
			department_id           = arguments.arguments_str.department_id;
			dsn_alias               = dsn;
			action_type             = 'VİRMAN';
			action_type_id          = 23;
			error_str               = structNew();

			periodQuery = new Query();
			periodQuery.setDatasource("#dsn#");
			periodQuery.setSQL("SELECT PERIOD_YEAR, IS_INTEGRATED, OUR_COMPANY_ID FROM SETUP_PERIOD WHERE PERIOD_ID = #period_id#");
			periodResult = periodQuery.execute();
			periodResult = periodResult.getResult();

			wodiba_dsn  = dsn;
			wodiba_dsn1 = dsn1;
			wodiba_dsn2 = '#dsn#_#periodResult.period_year#_#periodResult.our_company_id#';
			wodiba_dsn3 = '#dsn#_#periodResult.our_company_id#';
			dsn3_alias  = wodiba_dsn3;

			//oturum değişkenleri, işlem kategorisi için gerekli
			session.ep.period_id    = period_id;
			session.ep.userid       = record_emp;
			session.ep.position_code= 0;
			session.ep.position_name= 'Wodiba';
			session.ep.name         = 'Wodiba';
			session.ep.surname      = 'Wodiba';
			session.ep.company_id   = company_id;
			session.ep.company_nick = '';
			session.ep.period_year  = periodResult.PERIOD_YEAR;
			caller.dsn3_alias       = wodiba_dsn3;

			processCatQuery = new Query();
			processCatQuery.setDatasource("#wodiba_dsn3#");
			processCatQuery.setSQL("SELECT IS_CARI, IS_ACCOUNT, ACTION_FILE_NAME, ACTION_FILE_FROM_TEMPLATE FROM SETUP_PROCESS_CAT WHERE PROCESS_CAT_ID = #process_cat#");
			processCatResult = processCatQuery.execute();
			processCatResult = processCatResult.getResult();

			moneyQuery = new Query();
			moneyQuery.setDatasource("#wodiba_dsn2#");
			moneyQuery.setSQL("SELECT MONEY, RATE1, RATE2 FROM SETUP_MONEY WHERE PERIOD_ID = #period_id#");
			moneyResult = moneyQuery.execute();
			moneyResult = moneyResult.getResult();

			/* expenseQuery = new Query();
			expenseQuery.setDatasource("#wodiba_dsn2#");
			expenseQuery.setSQL("SELECT * FROM EXPENSE_ITEMS WHERE EXPENSE_ITEM_ID = #expense_item_id#");
			expenseResult = expenseQuery.execute();
			expenseResult = expenseResult.getResult();

			if (Not Len(expenseResult.ACCOUNT_CODE)) {
				error_str.error_type    = 'account_code';
				error_str.error_message = 'expense_item_id: #expense_item_id# için muhasebe hesabı tanımlı değil!';
			} */

			fromAccountQuery = new Query();
			fromAccountQuery.setDatasource("#wodiba_dsn3#");
			fromAccountQuery.setSQL("SELECT ACCOUNT_CURRENCY_ID, ACCOUNT_ACC_CODE FROM ACCOUNTS WHERE ACCOUNT_ID = #from_account_id#");
			fromAccountResult = fromAccountQuery.execute();
			fromAccountResult = fromAccountResult.getResult();

			if (Not Len(fromAccountResult.ACCOUNT_ACC_CODE)) {
				error_str.error_type    = 'account_code';
				error_str.error_message = 'account_id: #from_account_id# için muhasebe hesabı tanımlı değil!';
			}

			toAccountQuery = new Query();
			toAccountQuery.setDatasource("#wodiba_dsn3#");
			toAccountQuery.setSQL("SELECT ACCOUNT_CURRENCY_ID, ACCOUNT_ACC_CODE FROM ACCOUNTS WHERE ACCOUNT_ID = #to_account_id#");
			toAccountResult = toAccountQuery.execute();
			toAccountResult = toAccountResult.getResult();

			if (Not Len(toAccountResult.ACCOUNT_ACC_CODE)) {
				error_str.error_type    = 'account_code';
				error_str.error_message = 'account_id: #to_account_id# için muhasebe hesabı tanımlı değil!';
			}
			
			attributes.kur_say = moneyResult.recordcount;
			attributes.money_type = toAccountResult.account_currency_id;
			for(mon=1; mon lte moneyResult.recordcount; mon++){//f_kur_ekle_action için gerekli
				evaluate("attributes.hidden_rd_money_#mon#  = moneyResult.money[mon]");
				evaluate("attributes.txt_rate1_#mon#        = moneyResult.rate1[mon]");
				evaluate("attributes.txt_rate2_#mon#        = moneyResult.rate2[mon]");
			}

			str_card_detail = '#detail#';

			/* expense_account_code = expenseResult.ACCOUNT_CODE; */

			islem_detay = UCASETR(get_process_name(process_type));
			is_cari = processCatResult.is_cari;
			is_account = processCatResult.is_account;
			acc_project_list_alacak='';
			acc_project_list_borc='';
			fis_satir_row_detail = '#paper_no# - #detail# - #islem_detay#';  //muhasebe islemlerinde kullanılıyor
		</cfscript>

		<cfif structIsEmpty(error_str)>
			<cflock name="#createUUID()#" timeout="20">
				<cftransaction>
					<cfquery datasource="#wodiba_dsn2#" result="res">
						INSERT INTO
							BANK_ACTIONS
						(
							ACTION_TYPE,
							PROCESS_CAT,
							ACTION_TYPE_ID,
							ACTION_FROM_ACCOUNT_ID,
							ACTION_DATE,
							ACTION_DETAIL,
							ACTION_VALUE,
							ACTION_CURRENCY_ID,
							OTHER_CASH_ACT_VALUE,
							OTHER_MONEY,
							SYSTEM_ACTION_VALUE,
							SYSTEM_CURRENCY_ID,
							ACTION_VALUE_2,
							ACTION_CURRENCY_ID_2,
							IS_ACCOUNT,
							IS_ACCOUNT_TYPE,
							PAPER_NO,
							MASRAF,
							RECORD_EMP,
							RECORD_IP,
							RECORD_DATE,
							FROM_BRANCH_ID,
							WITH_NEXT_ROW,
							PROJECT_ID
						)
						VALUES
						(
							'#action_type#',
							#process_cat#,
							#action_type_id#,
							#from_account_id#,
							#date#,
							<cfif Len(from_detail)>'#from_detail#'<cfelse>NULL</cfif>,
							#wrk_round(from_amount.action_value)#, --ACTION_VALUE
							'#from_amount.action_currency_id#', --ACTION_CURRENCY_ID
							#wrk_round(to_amount.action_value)#, --OTHER_CASH_ACT_VALUE
							'#to_amount.action_currency_id#', --OTHER_MONEY
							#wrk_round(from_amount.system_action_value)#, --SYSTEM_ACTION_VALUE
							'#from_amount.system_currency_id#', --SYSTEM_CURRENCY_ID
							#wrk_round(from_amount.system_action_value_2)#, --ACTION_VALUE_2
							'#from_amount.system_currency_id_2#', --ACTION_CURRENCY_ID_2
							<cfif is_account eq 1>1<cfelse>0</cfif>,
							13,
							'#from_paper_no#',
							0,
							#record_emp#,
							'#CGI.REMOTE_ADDR#',
							#Now()#,
							<cfif branch_id_alacak Neq 0>#branch_id_alacak#<cfelse>NULL</cfif>,
							1,
							<cfif project_id Neq 0>#project_id#<cfelse>NULL</cfif>
						)
					</cfquery>
					<cfquery datasource="#wodiba_dsn2#">
						INSERT INTO
							BANK_ACTIONS
						(
							ACTION_TYPE,
							PROCESS_CAT,
							ACTION_TYPE_ID,
							ACTION_TO_ACCOUNT_ID,
							ACTION_DATE,
							ACTION_DETAIL,
							ACTION_VALUE,
							ACTION_CURRENCY_ID,
							OTHER_CASH_ACT_VALUE,
							OTHER_MONEY,
							SYSTEM_ACTION_VALUE,
							SYSTEM_CURRENCY_ID,
							ACTION_VALUE_2,
							ACTION_CURRENCY_ID_2,
							IS_ACCOUNT,
							IS_ACCOUNT_TYPE,
							PAPER_NO,
							MASRAF,
							RECORD_EMP,
							RECORD_IP,
							RECORD_DATE,
							TO_BRANCH_ID,
							WITH_NEXT_ROW,
							PROJECT_ID
						)
						VALUES
						(
							'#action_type#',
							#process_cat#,
							#action_type_id#,
							#to_account_id#,
							#date#,
							<cfif Len(to_detail)>'#to_detail#'<cfelse>NULL</cfif>,
							#wrk_round(to_amount.action_value)#, --ACTION_VALUE
							'#to_amount.action_currency_id#', --ACTION_CURRENCY_ID
							#wrk_round(from_amount.action_value)#, --OTHER_CASH_ACT_VALUE
							'#from_amount.action_currency_id#', --OTHER_MONEY
							#wrk_round(to_amount.system_action_value)#, --SYSTEM_ACTION_VALUE
							'#to_amount.system_currency_id#', --SYSTEM_CURRENCY_ID
							#wrk_round(to_amount.system_action_value_2)#, --ACTION_VALUE_2
							'#to_amount.system_currency_id_2#', --ACTION_CURRENCY_ID_2
							<cfif is_account eq 1>1<cfelse>0</cfif>,
							13,
							'#to_paper_no#',
							0,
							#record_emp#,
							'#CGI.REMOTE_ADDR#',
							#Now()#,
							<cfif branch_id_borc Neq 0>#branch_id_borc#<cfelse>NULL</cfif>,
							0,
							<cfif project_id Neq 0>#project_id#<cfelse>NULL</cfif>
						)
					</cfquery>

					<cfscript>
						BANK_ACT_ID = res.IDENTITYCOL;

						//Masraf netleştikten sonra açılacak
						/* if(Len(expense_item_id) and (masraf gt 0) and Len(expense_center_id))
						{
							butceci(
								action_id : BANK_ACT_ID,
								muhasebe_db : dsn2,
								is_income_expense : false,
								process_type : process_type,
								nettotal : attributes.masraf,
								other_money_value : wrk_round(attributes.masraf/masraf_curr_multiplier),
								action_currency : form.money_type,
								currency_multiplier : currency_multiplier,
								expense_date : attributes.action_date,
								expense_center_id : attributes.expense_center_id,
								expense_item_id : attributes.expense_item_id,
								detail : UCase(getLang('main',2700)), //VİRMAN MASRAFI
								paper_no : attributes.paper_number,
								branch_id : from_branch_id_info,
								insert_type : 1,//banka vs den eklenen masraflar için farklı ekleme metodu tanımlar
								project_id : attributes.project_id
							);
							GET_EXP_ACC = cfquery(datasource : "#dsn2#", sqlstring : "SELECT ACCOUNT_CODE FROM EXPENSE_ITEMS WHERE EXPENSE_ITEM_ID = #attributes.expense_item_id#");
						} */

						if(is_account eq 1)
						{
							acc_branch_list_borc    = '';
							acc_branch_list_alacak  = '';
							acc_branch_list_alacak  = listappend(acc_branch_list_alacak,branch_id,',');
							acc_branch_list_borc    = listappend(acc_branch_list_borc,branch_id,',');
							if(Len(from_detail))
								str_card_detail = '#from_detail#';
							else if(from_amount.action_currency_id is from_amount.system_currency_id)
								str_card_detail = UCase(getLang('main',2724)); //VİRMAN HESAP İŞLEMİ
							else
								str_card_detail = UCase(getLang('main',2725));//DÖVİZLİ VİRMAN HESAP İŞLEMİ
						
							str_borclu_hesaplar     = toAccountResult.ACCOUNT_ACC_CODE;
							str_alacakli_hesaplar   = fromAccountResult.ACCOUNT_ACC_CODE;
							str_tutarlar            = from_amount.system_action_value;
						
							str_borclu_other_amount_tutar   = to_amount.action_value;
							str_borclu_other_currency       = to_amount.action_currency_id;
							str_alacakli_other_amount_tutar = from_amount.action_value;
							str_alacakli_other_currency     = from_amount.action_currency_id;
									
							//Masraf netleştiğinde açılacak
							/* if(len(attributes.masraf) and attributes.masraf gt 0 and len(GET_EXP_ACC.ACCOUNT_CODE))
							{
								acc_branch_list_alacak = listappend(acc_branch_list_alacak,from_branch_id_info,',');
								acc_branch_list_borc = listappend(acc_branch_list_borc,from_branch_id_info,',');
								str_borclu_hesaplar = ListAppend(str_borclu_hesaplar,GET_EXP_ACC.ACCOUNT_CODE,",");	
								str_alacakli_hesaplar = ListAppend(str_alacakli_hesaplar,attributes.account_acc_code,",");	
								
								if(attributes.currency_id is session.ep.money)
								{
									masraf_doviz = wrk_round(attributes.masraf/masraf_curr_multiplier);
									str_tutarlar = ListAppend(str_tutarlar,attributes.masraf,",");
								}
								else
								{
									masraf_doviz = wrk_round(attributes.masraf*dovizli_islem_multiplier);
									str_tutarlar = ListAppend(str_tutarlar,masraf_doviz,",");
								}
								str_borclu_other_amount_tutar = ListAppend(str_borclu_other_amount_tutar,attributes.masraf,",");
								str_borclu_other_currency = ListAppend(str_borclu_other_currency,attributes.currency_id,",");
								str_alacakli_other_amount_tutar = ListAppend(str_alacakli_other_amount_tutar,attributes.masraf,",");
								str_alacakli_other_currency = ListAppend(str_alacakli_other_currency,attributes.currency_id,",");
							} */

							if (Len(str_borclu_hesaplar) And Len(str_alacakli_hesaplar)) {
								wodiba_muhasebeci (
									action_id: BANK_ACT_ID,
									workcube_process_type: action_type_id,
									workcube_process_cat: process_cat,
									account_card_type: 13,
									islem_tarihi: date,
									fis_satir_detay: str_card_detail,
									borc_hesaplar: str_borclu_hesaplar,
									borc_tutarlar: str_tutarlar,
									other_amount_borc : str_borclu_other_amount_tutar,
									other_currency_borc : str_borclu_other_currency,
									alacak_hesaplar: str_alacakli_hesaplar,
									alacak_tutarlar: str_tutarlar,
									other_amount_alacak : str_alacakli_other_amount_tutar,
									other_currency_alacak : str_alacakli_other_currency,
									currency_multiplier : from_amount.action_rate_2,
									fis_detay: UCase(getLang('main',422)),
									belge_no : from_paper_no,
									is_abort : 0,
									action_currency : from_amount.system_currency_id,
									action_currency_2 : from_amount.system_currency_id_2,
									muhasebe_db: wodiba_dsn2,
									period_id: period_id,
									acc_department_id: department_id,
									acc_project_id: project_id
								);
							}
						}
						f_kur_ekle_action(
							action_id:BANK_ACT_ID,
							process_type:0,
							action_table_name:'BANK_ACTION_MONEY',
							action_table_dsn:'#wodiba_dsn2#');
					</cfscript>
		
					<!--- <cf_workcube_process_cat 
						process_cat="#process_cat#"
						action_id = #BANK_ACT_ID#
						is_action_file = 1
						action_file_name='#processCatResult.action_file_name#'
						action_page='#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_add_virman&event=upd&id=#BANK_ACT_ID#'
						action_db_type = '#wodiba_dsn2#'
						is_template_action_file = '#processCatResult.action_file_from_template#'> --->

					<cf_add_log log_type="1" action_id="#BANK_ACT_ID#" action_name= "#from_paper_no# Eklendi" paper_no= "#from_paper_no#" period_id="#period_id#" process_type="#process_type#" data_source="#wodiba_dsn2#" employee_id="#record_emp#">
				</cftransaction>
			</cflock>

			<cfscript>
				return_struct                   = structNew();
				return_struct.bank_action_id    = BANK_ACT_ID;
				return_struct.document_id       = BANK_ACT_ID;
			</cfscript>
		
			<cfreturn return_struct />
		<cfelse>
			<cfreturn error_str />
		</cfif>
	</cffunction>

	<cffunction name="addPaymentCreditCard" access="public" returntype="struct" output="false" hint="Wodiba kredi kartı hesaba geçiş işlemi ekler">
		<cfset addPaymentCreditCard_return_struct = structNew() />
		<cfreturn addPaymentCreditCard_return_struct />
	</cffunction>
	
	<cffunction name="addDebitCreditCard" access="public" returntype="struct" output="false" hint="Wodiba kredi kartı borcu ödeme işlemi ekler">
		<cfargument name="period_id" type="numeric" required="true" />
		<cfargument name="process_cat" type="numeric" required="true" />
		<cfargument name="account_id" type="numeric" required="true" />
		<cfargument name="amount" type="any" required="true" hint="Tutarlar structure ile gönderilmelidir" />
		<cfargument name="date" type="date" required="true" />
		<cfargument name="detail" type="string" required="true" />
		<cfargument name="paper_no" type="string" required="true" />
		<cfargument name="record_emp" type="numeric" required="true" />
		<cfargument name="creditcard_id" type="numeric" required="true" />

		<cfscript>
			// parametric
			period_id               = arguments.period_id;
			process_cat             = arguments.process_cat;
			account_id              = arguments.account_id;
			amount                  = arguments.amount;
			date                    = arguments.date;
			detail                  = arguments.detail;
			paper_no                = arguments.paper_no;
			record_emp              = arguments.record_emp;
			dsn_alias               = dsn;
			session.ep.period_id    = period_id;
			creditcard_id			= arguments.creditcard_id;
			error_str               = structNew();

			//static
			action_type     = 'KREDİ KARTI BORCU ÖDEME';
			action_type_id  = 244;

			//computed
			periodQuery = new Query();
			periodQuery.setDatasource("#dsn#");
			periodQuery.setSQL("SELECT PERIOD_YEAR, IS_INTEGRATED, OUR_COMPANY_ID FROM SETUP_PERIOD WHERE PERIOD_ID = #period_id#");
			periodResult = periodQuery.execute();
			periodResult = periodResult.getResult();

			wodiba_dsn          = dsn;
			wodiba_dsn1         = dsn1;
			wodiba_dsn2         = '#dsn#_#periodResult.PERIOD_YEAR#_#periodResult.OUR_COMPANY_ID#';
			wodiba_dsn3         = '#dsn#_#periodResult.OUR_COMPANY_ID#';
			caller.dsn3_alias   = wodiba_dsn3;

			processCatQuery = new Query();
			processCatQuery.setDatasource("#wodiba_dsn3#");
			processCatQuery.setSQL("SELECT IS_ACCOUNT FROM SETUP_PROCESS_CAT WHERE PROCESS_CAT_ID = #process_cat#");
			processCatResult = processCatQuery.execute();
			processCatResult = processCatResult.getResult();

			moneyQuery = new Query();
			moneyQuery.setDatasource("#wodiba_dsn2#");
			moneyQuery.setSQL("SELECT MONEY, RATE1, RATE2 FROM SETUP_MONEY WHERE PERIOD_ID = #period_id#");
			moneyResult = moneyQuery.execute();
			moneyResult = moneyResult.getResult();

			accountQuery = new Query();
			accountQuery.setDatasource("#wodiba_dsn3#");
			accountQuery.setSQL("SELECT ACCOUNT_CURRENCY_ID, ACCOUNT_ACC_CODE FROM ACCOUNTS WHERE ACCOUNT_ID = #account_id#");
			accountResult = accountQuery.execute();
			accountResult = accountResult.getResult();

			if (Not Len(accountResult.ACCOUNT_ACC_CODE)) {
				error_str.error_type    = 'account_code';
				error_str.error_message = 'account_id: #account_id# için muhasebe hesabı tanımlı değil!';
			}

			ccQuery = new Query();
			ccQuery.setDatasource("#wodiba_dsn3#");
			ccQuery.setSQL("SELECT ACCOUNT_CODE FROM CREDIT_CARD WHERE CREDITCARD_ID = #creditcard_id#");
			ccResult = ccQuery.execute();
			ccResult = ccResult.getResult();

			if (Not Len(ccResult.ACCOUNT_CODE)) {
				error_str.error_type    = 'account_code';
				error_str.error_message = 'creditcard_id: #creditcard_id# için muhasebe hesabı tanımlı değil!';
			}

			attributes.kur_say = moneyResult.recordcount;
			attributes.money_type = accountResult.account_currency_id;
			for(mon=1; mon lte moneyResult.recordcount; mon++){//f_kur_ekle_action için gerekli
				evaluate("attributes.hidden_rd_money_#mon#  = moneyResult.money[mon]");
				evaluate("attributes.txt_rate1_#mon#        = moneyResult.rate1[mon]");
				evaluate("attributes.txt_rate2_#mon#        = moneyResult.rate2[mon]");
			}

			str_card_detail = 'KREDİ KARTI BORCU ÖDEME İŞLEMİ';
		</cfscript>

		<cfif structIsEmpty(error_str)>
			<cflock name="#createUUID()#" timeout="60">
				<cftransaction>
					<cfquery datasource="#wodiba_dsn2#" result="res">
						INSERT INTO
							BANK_ACTIONS
						(
							PROCESS_CAT,
							ACTION_TYPE,
							ACTION_TYPE_ID,
							ACTION_FROM_ACCOUNT_ID,
							ACTION_VALUE,
							ACTION_CURRENCY_ID,
							OTHER_CASH_ACT_VALUE,
							OTHER_MONEY,
							SYSTEM_ACTION_VALUE,
							SYSTEM_CURRENCY_ID,
							ACTION_VALUE_2,
							ACTION_CURRENCY_ID_2,
							ACTION_DATE,
							ACTION_DETAIL,
							CREDITCARD_ID,
							IS_ACCOUNT,
							IS_ACCOUNT_TYPE,
							PAPER_NO,
							RECORD_DATE,
							RECORD_EMP
						)
							VALUES
						(
							#process_cat#,
							'#action_type#',
							#action_type_id#,
							#account_id#,
							#wrk_round(amount.action_value)#,--ACTION_VALUE
							'#amount.action_currency_id#',--ACTION_CURRENCY_ID
							#wrk_round(amount.action_value)#,--OTHER_CASH_ACT_VALUE
							'#amount.action_currency_id#',--OTHER_MONEY
							#wrk_round(amount.system_action_value)#,--SYSTEM_ACTION_VALUE
							'#amount.system_currency_id#',--SYSTEM_CURRENCY_ID
							#wrk_round(amount.system_action_value_2)#,--ACTION_VALUE_2
							'#amount.system_currency_id_2#',--ACTION_CURRENCY_ID_2
							#date#,
							'#detail#',--ACTION_DETAIL
							#creditcard_id#,--CREDITCARD_ID
							#processCatResult.is_account#,
							13,
							'#paper_no#',
							#Now()#,
							#record_emp#
						)
					</cfquery>
					<cfscript>
						if(processCatResult.is_account eq 1)
						{
							str_borclu_hesaplar     = ccResult.ACCOUNT_CODE;
							str_alacakli_hesaplar   = accountResult.ACCOUNT_ACC_CODE;
							str_tutarlar            = wrk_round(amount.action_value);

							str_borclu_other_amount_tutar   = wrk_round(amount.action_value);
							str_borclu_other_currency       = amount.action_currency_id;
							str_alacakli_other_amount_tutar = wrk_round(amount.action_value);
							str_alacakli_other_currency     = amount.action_currency_id;

							if (Len(str_borclu_hesaplar) And Len(str_alacakli_hesaplar)) {
								wodiba_muhasebeci (
									action_id: res.IDENTITYCOL,
									workcube_process_type: action_type_id,
									workcube_process_cat: process_cat,
									account_card_type: 13,
									islem_tarihi: date,
									fis_satir_detay: str_card_detail,
									borc_hesaplar: str_borclu_hesaplar,
									borc_tutarlar: str_tutarlar,
									other_amount_borc : str_borclu_other_amount_tutar,
									other_currency_borc : str_borclu_other_currency,
									alacak_hesaplar: str_alacakli_hesaplar,
									alacak_tutarlar: str_tutarlar,
									other_amount_alacak : str_alacakli_other_amount_tutar,
									other_currency_alacak : str_alacakli_other_currency,
									currency_multiplier : amount.action_rate_2,
									fis_detay: str_card_detail,
									belge_no : paper_no,
									is_abort : 0,
									action_currency : amount.action_currency_id,
									action_currency_2 : amount.system_currency_id_2,
									muhasebe_db: wodiba_dsn2,
									period_id: period_id
								);
							}
						}
						f_kur_ekle_action(
							action_id:res.IDENTITYCOL,
							process_type:0,
							action_table_name:'BANK_ACTION_MONEY',
							action_table_dsn:'#wodiba_dsn2#');
					</cfscript>
				</cftransaction>
			</cflock>

			<cfscript>
				addDebitCreditCard_return_struct                = structNew();
				addDebitCreditCard_return_struct.bank_action_id = res.IDENTITYCOL;
				addDebitCreditCard_return_struct.document_id    = res.IDENTITYCOL;
			</cfscript>
			<cfreturn addDebitCreditCard_return_struct />
		<cfelse>
			<cfreturn error_str />
		</cfif>
	</cffunction>

	<cffunction name="addPaymentCreditContract" access="public" returntype="struct" output="false" hint="Wodiba kredi ödeme işlemi ekler">
		<cfargument name="period_id" type="numeric" required="true" />
		<cfargument name="process_cat" type="numeric" required="true" />
		<cfargument name="account_id" type="numeric" required="true" />
		<cfargument name="amount" type="any" required="true" hint="Tutarlar structure ile gönderilmelidir" />
		<cfargument name="date" type="date" required="true" />
		<cfargument name="detail" type="string" required="true" />
		<cfargument name="paper_no" type="string" required="true" />
		<cfargument name="record_emp" type="numeric" required="true" />
		<cfargument name="credit_id" type="numeric" required="true" />
		<cfargument name="credit_no" type="string" required="true" />
		<cfargument name="company_id" type="numeric" required="false" default="0" />
		<cfargument name="project_id" type="numeric" required="false" default="0" />
		<cfargument name="interest_action" type="any" required="true" />
		<cfargument name="tax_action" type="any" required="true" />

		<cfscript>
			// parametric
			period_id               = arguments.period_id;
			process_cat             = arguments.process_cat;
			account_id              = arguments.account_id;
			amount                  = arguments.amount;
			date                    = arguments.date;
			detail                  = arguments.detail;
			paper_no                = arguments.paper_no;
			record_emp              = arguments.record_emp;
			dsn_alias               = dsn;
			session.ep.period_id    = period_id;
			credit_id				= arguments.credit_id;
			credit_no				= arguments.credit_no;
			company_id				= arguments.company_id;
			project_id				= arguments.project_id;
			interest_price          = 0;//faiz tutarı
			tax_price               = 0;//vergi masraf tutarı
			amount_interest			= structNew();
			amount_tax				= structNew();
			amount_interest.action_value 		= 0;
			amount_interest.system_action_value = 0;
			amount_interest.system_action_value_2 = 0;
			amount_tax.action_value 			= 0;
			amount_tax.system_action_value 		= 0;
			amount_tax.system_action_value_2 	= 0;
			error_str               = structNew();

			if (isDefined('interest_action.recordcount') And interest_action.recordcount) {
				interest_price = replace(interest_action.MIKTAR,'-','');

				amount_interest.ACTION_CURRENCY_ID		= amount.ACTION_CURRENCY_ID;
				amount_interest.ACTION_RATE				= amount.ACTION_RATE;
				amount_interest.ACTION_RATE_2			= amount.ACTION_RATE_2;
				amount_interest.ACTION_VALUE			= interest_price;
				amount_interest.action_value_tax_free	= interest_price;
				amount_interest.SYSTEM_ACTION_VALUE		= amount_interest.ACTION_VALUE * amount_interest.ACTION_RATE;
				amount_interest.system_action_value_tax_free = amount_interest.SYSTEM_ACTION_VALUE;
				amount_interest.SYSTEM_ACTION_VALUE_2	= amount_interest.ACTION_VALUE * amount_interest.ACTION_RATE / amount_interest.ACTION_RATE_2;
				amount_interest.SYSTEM_CURRENCY_ID		= amount.SYSTEM_CURRENCY_ID;
				amount_interest.SYSTEM_CURRENCY_ID_2	= amount.SYSTEM_CURRENCY_ID_2;
				amount_interest.TAX						= 0;
				amount_interest.TAX_VALUE				= 0;
			}
			if (isDefined('tax_action.recordcount') And tax_action.recordcount) {
				tax_price = replace(tax_action.MIKTAR,'-','');

				amount_tax.ACTION_CURRENCY_ID		= amount.ACTION_CURRENCY_ID;
				amount_tax.ACTION_RATE				= amount.ACTION_RATE;
				amount_tax.ACTION_RATE_2			= amount.ACTION_RATE_2;
				amount_tax.ACTION_VALUE				= tax_price;
				amount_tax.action_value_tax_free	= tax_price;
				amount_tax.SYSTEM_ACTION_VALUE		= amount_tax.ACTION_VALUE * amount_tax.ACTION_RATE;
				amount_tax.system_action_value_tax_free = amount_tax.SYSTEM_ACTION_VALUE;
				amount_tax.SYSTEM_ACTION_VALUE_2	= amount_tax.ACTION_VALUE * amount_tax.ACTION_RATE / amount_tax.ACTION_RATE_2;
				amount_tax.SYSTEM_CURRENCY_ID		= amount.SYSTEM_CURRENCY_ID;
				amount_tax.SYSTEM_CURRENCY_ID_2		= amount.SYSTEM_CURRENCY_ID_2;
				amount_tax.TAX						= 0;
				amount_tax.TAX_VALUE				= 0;
			}

			//static
			action_type     = 'KREDİ ÖDEMESİ';
			action_type_id  = 291;

			//computed
			periodQuery = new Query();
			periodQuery.setDatasource("#dsn#");
			periodQuery.setSQL("SELECT PERIOD_YEAR, OUR_COMPANY_ID, IS_INTEGRATED FROM SETUP_PERIOD WHERE PERIOD_ID = #period_id#");
			periodResult = periodQuery.execute();
			periodResult = periodResult.getResult();

			wodiba_dsn          = dsn;
			wodiba_dsn1         = dsn1;
			wodiba_dsn2         = '#dsn#_#periodResult.PERIOD_YEAR#_#periodResult.OUR_COMPANY_ID#';
			wodiba_dsn3         = '#dsn#_#periodResult.OUR_COMPANY_ID#';
			caller.dsn3_alias   = wodiba_dsn3;

			processCatQuery = new Query();
			processCatQuery.setDatasource("#wodiba_dsn3#");
			processCatQuery.setSQL("SELECT IS_ACCOUNT, IS_BUDGET, IS_CARI FROM SETUP_PROCESS_CAT WHERE PROCESS_CAT_ID = #process_cat#");
			processCatResult = processCatQuery.execute();
			processCatResult = processCatResult.getResult();

			moneyQuery = new Query();
			moneyQuery.setDatasource("#wodiba_dsn2#");
			moneyQuery.setSQL("SELECT MONEY, RATE1, RATE2 FROM SETUP_MONEY WHERE PERIOD_ID = #period_id#");
			moneyResult = moneyQuery.execute();
			moneyResult = moneyResult.getResult();

			accountQuery = new Query();
			accountQuery.setDatasource("#wodiba_dsn3#");
			accountQuery.setSQL("SELECT ACCOUNT_CURRENCY_ID, ACCOUNT_ACC_CODE FROM ACCOUNTS WHERE ACCOUNT_ID = #account_id#");
			accountResult = accountQuery.execute();
			accountResult = accountResult.getResult();

			if (Not Len(accountResult.ACCOUNT_ACC_CODE)) {
				error_str.error_type    = 'account_code';
				error_str.error_message = 'account_id: #account_id# için muhasebe hesabı tanımlı değil!';
			}

			attributes.kur_say = moneyResult.recordcount;
			attributes.money_type = accountResult.account_currency_id;
			for(mon=1; mon lte moneyResult.recordcount; mon++){//f_kur_ekle_action için gerekli
				evaluate("attributes.hidden_rd_money_#mon#  = moneyResult.money[mon]");
				evaluate("attributes.txt_rate1_#mon#        = moneyResult.rate1[mon]");
				evaluate("attributes.txt_rate2_#mon#        = moneyResult.rate2[mon]");
			}

			str_card_detail = '#credit_no# KREDİ ÖDEME İŞLEMİ';

			get_credit_row = queryExecute("
				SELECT
					ccr.CREDIT_CONTRACT_ROW_ID,
					ccr.EXPENSE_CENTER_ID,
					ccr.EXPENSE_ITEM_ID,
					ccr.INTEREST_ACCOUNT_ID,
					ccr.TOTAL_EXPENSE_ITEM_ID,
					ccr.TOTAL_ACCOUNT_ID,
	   				ccr.CAPITAL_EXPENSE_ITEM_ID,
					ccr.CAPITAL_ACCOUNT_ID 
	   			FROM
					CREDIT_CONTRACT_ROW AS ccr
				WHERE
					ccr.CREDIT_CONTRACT_ID = #credit_id# AND
					ccr.IS_PAID = 0 AND
					ccr.IS_PAID_ROW IS NULL AND
					ccr.PROCESS_DATE BETWEEN DATEADD(day, -10, #date#) AND DATEADD(day, 10, #date#)",{},{datasource='#dsn3#'});

			if (Not get_credit_row.recordcount) {
				error_str.error_type    = 'credit_row';
				error_str.error_message = 'Kredi No: #credit_no# için işlem tarihine uygun kredi satırı bulunamadı.';
			}
		</cfscript>

		<cfif structIsEmpty(error_str)>
			<cflock name="#createUUID()#" timeout="60">
				<cftransaction>
					<cfquery datasource="#wodiba_dsn2#" result="res">
						INSERT INTO
							BANK_ACTIONS
						(
							PROCESS_CAT,
							ACTION_TYPE,
							ACTION_TYPE_ID,
							ACTION_FROM_ACCOUNT_ID,
							ACTION_TO_COMPANY_ID,
							ACTION_VALUE,
							ACTION_CURRENCY_ID,
							SYSTEM_ACTION_VALUE,
							SYSTEM_CURRENCY_ID,
							ACTION_VALUE_2,
							ACTION_CURRENCY_ID_2,
							OTHER_CASH_ACT_VALUE,
							OTHER_MONEY,
							MASRAF,
							OTHER_COST,
							ACTION_DATE,
							ACTION_DETAIL,
							PAPER_NO,
							IS_ACCOUNT,
							IS_ACCOUNT_TYPE,
							PROJECT_ID,
							RECORD_DATE,
							RECORD_EMP
						)
							VALUES
						(
							#process_cat#,
							'#action_type#',
							#action_type_id#,
							#account_id#,--ACTION_FROM_ACCOUNT_ID
							<cfif Len(company_id)>#company_id#<cfelse>NULL</cfif>,--ACTION_TO_COMPANY_ID
							#wrk_round(amount.action_value + amount_interest.action_value + amount_tax.action_value)#,--ACTION_VALUE
							'#amount.action_currency_id#',--ACTION_CURRENCY_ID
							#wrk_round(amount.system_action_value + amount_interest.system_action_value + amount_tax.system_action_value)#,--SYSTEM_ACTION_VALUE
							'#amount.system_currency_id#',--SYSTEM_CURRENCY_ID
							#wrk_round(amount.system_action_value_2 + amount_interest.system_action_value_2 + amount_tax.system_action_value_2)#,--ACTION_VALUE_2
							'#amount.system_currency_id_2#',--ACTION_CURRENCY_ID_2
							#wrk_round(amount.action_value + amount_interest.action_value + amount_tax.action_value)#,--OTHER_CASH_ACT_VALUE
							'#amount.action_currency_id#',--OTHER_MONEY
							#wrk_round(interest_price + tax_price)#,
							#wrk_round(interest_price + tax_price)#,
							#date#,
							'#str_card_detail#',--ACTION_DETAIL
							'#paper_no#',--PAPER_NO
							#processCatResult.is_account#,
							13,--IS_ACCOUNT_TYPE
							#project_id#,
							#Now()#,
							#record_emp#
						)
					</cfquery>
					<cfquery datasource="#wodiba_dsn2#" result="payment">
						INSERT INTO
							CREDIT_CONTRACT_PAYMENT_INCOME
						(
							CREDIT_CONTRACT_ID,
							CREDIT_CONTRACT_ROW_ID,
							BANK_ACTION_ID,
							PROCESS_CAT,
							PROCESS_TYPE,
							DOCUMENT_NO,
							COMPANY_ID,
							BANK_ACCOUNT_ID,
							ACTION_CURRENCY_ID,
							EXPENSE_CENTER_ID,
							PROCESS_DATE,
							CAPITAL_EXPENSE_ITEM_ID,
							INTEREST_EXPENSE_ITEM_ID,
							CAPITAL_PRICE,
							INTEREST_PRICE,
							TAX_PRICE,
							DELAY_PRICE,
							TOTAL_PRICE,
							OTHER_TOTAL_PRICE,
							OTHER_MONEY,
							CAPITAL_EXPENSE_ITEM_ID_ACC,
							INTEREST_EXPENSE_ITEM_ID_ACC,
							RECORD_EMP,
							RECORD_DATE
						)
						VALUES
						(
							#credit_id#,
							#get_credit_row.CREDIT_CONTRACT_ROW_ID#,
							#res.IDENTITYCOL#,
							#process_cat#,
							#action_type_id#,--PROCESS_TYPE
							'#paper_no#',--DOCUMENT_NO
							#company_id#,
							#account_id#,--BANK_ACCOUNT_ID
							'#amount.action_currency_id#',--ACTION_CURRENCY_ID
							<cfif Len(get_credit_row.EXPENSE_CENTER_ID)>#get_credit_row.EXPENSE_CENTER_ID#<cfelse>NULL</cfif>,
							#date#,--PROCESS_DATE
							<cfif Len(get_credit_row.CAPITAL_EXPENSE_ITEM_ID)>#get_credit_row.CAPITAL_EXPENSE_ITEM_ID#<cfelse>NULL</cfif>,--CAPITAL_EXPENSE_ITEM_ID
							#get_credit_row.EXPENSE_ITEM_ID#,--INTEREST_EXPENSE_ITEM_ID
							#wrk_round(amount.action_value)#,--CAPITAL_PRICE taksit tutarı
							#wrk_round(interest_price)#,--INTEREST_PRICE faiz tutarı
							#wrk_round(tax_price)#,--TAX_PRICE masraf tutarı
							0,--DELAY_PRICE
							#wrk_round(amount.action_value + amount_interest.action_value + amount_tax.action_value)#,--TOTAL_PRICE
							#wrk_round(amount.action_value + amount_interest.action_value + amount_tax.action_value)#,--OTHER_TOTAL_PRICE
							'#amount.action_currency_id#',
							'#get_credit_row.CAPITAL_ACCOUNT_ID#',--CAPITAL_EXPENSE_ITEM_ID_ACC
							'#get_credit_row.INTEREST_ACCOUNT_ID#',--INTEREST_EXPENSE_ITEM_ID_ACC
							#record_emp#,
							#Now()#
						)
					</cfquery>
					<cfquery datasource="#wodiba_dsn2#">
						UPDATE #wodiba_dsn3#.CREDIT_CONTRACT_ROW SET IS_PAID_ROW = 1 WHERE CREDIT_CONTRACT_ROW_ID = #get_credit_row.CREDIT_CONTRACT_ROW_ID#
					</cfquery>
					<cfquery datasource="#wodiba_dsn2#">
						INSERT INTO
						#wodiba_dsn3#.CREDIT_CONTRACT_ROW
						(
							CREDIT_CONTRACT_TYPE,
							CREDIT_CONTRACT_ID,
							PROCESS_DATE,
							CAPITAL_PRICE,
							INTEREST_PRICE,
							TAX_PRICE,
							TOTAL_PRICE,
							OTHER_MONEY,
							IS_PAID,
							OUR_COMPANY_ID,
							PERIOD_ID,
							PROCESS_TYPE,
							ACTION_ID
						)
						VALUES
						(
							1,--ödeme
							#credit_id#,--CREDIT_CONTRACT_ID
							#date#,--PROCESS_DATE
							#wrk_round(amount.action_value)#,--CAPITAL_PRICE taksit tutarı
							#wrk_round(interest_price)#,--INTEREST_PRICE faiz tutarı
							#wrk_round(tax_price)#,--TAX_PRICE masraf tutarı
							#wrk_round(amount.action_value)#,--TOTAL_PRICE
							'#amount.action_currency_id#',--OTHER_MONEY
							1,--IS_PAID
							#periodResult.OUR_COMPANY_ID#,--OUR_COMPANY_ID
							#period_id#,
							#action_type_id#,--PROCESS_TYPE
							#payment.IDENTITYCOL#--ACTION_ID
						)
					</cfquery>
					<cfquery datasource="#wodiba_dsn2#">
						INSERT INTO
							CREDIT_CONTRACT_PAYMENT_INCOME_TAX
						(
							CREDIT_CONTRACT_PAYMENT_ID,
							TAX_PRICE,
							TAX_EXPENSE_ITEM_ID,
							TAX_EXPENSE_ITEM_ID_ACC
						)
						VALUES
						(
							#payment.IDENTITYCOL#,
							#wrk_round(tax_price)#,
							<cfif len(get_credit_row.TOTAL_EXPENSE_ITEM_ID)>#get_credit_row.TOTAL_EXPENSE_ITEM_ID#<cfelse>NULL</cfif>,
							<cfif len(get_credit_row.TOTAL_ACCOUNT_ID)>'#get_credit_row.TOTAL_ACCOUNT_ID#'<cfelse>NULL</cfif>
						)
					</cfquery>
					<cfscript>
						if (processCatResult.IS_CARI) {
							wodiba_carici(
								action_id : payment.IDENTITYCOL,
								action_table : 'CREDIT_CONTRACT_PAYMENT_INCOME',
								islem_belge_no : paper_no,
								workcube_process_type : action_type_id,
								process_cat : process_cat,
								islem_tarihi : date,
								from_account_id : account_id,
								islem_tutari : wrk_round(amount.system_action_value + amount_interest.system_action_value + amount_tax.system_action_value),
								action_currency : amount.action_currency_id,
								action_currency_2 : amount.system_currency_id_2,
								other_money_value : wrk_round(amount.action_value + amount_interest.action_value + amount_tax.action_value),
								other_money : amount.action_currency_id,
								currency_multiplier : amount.action_rate_2,
								islem_detay : action_type,
								period_is_integrated: periodResult.IS_INTEGRATED,
								action_detail : detail,
								account_card_type : 13,
								due_date: date,
								to_cmp_id : company_id,
								rate2: amount.action_rate,
								record_emp: record_emp,
								cari_db: wodiba_dsn2,
								project_id: project_id
							);
						}
						if(processCatResult.is_account eq 1) {
							str_borclu_hesaplar     = get_credit_row.CAPITAL_ACCOUNT_ID;
							str_alacakli_hesaplar   = accountResult.ACCOUNT_ACC_CODE;
							str_borclu_tutarlar     = wrk_round(amount.action_value);
							str_alacakli_tutarlar   = wrk_round(amount.action_value + amount_interest.action_value + amount_tax.action_value);

							str_borclu_other_amount_tutar   = wrk_round(amount.action_value);
							str_borclu_other_currency       = amount.action_currency_id;
							str_alacakli_other_amount_tutar = wrk_round(amount.action_value + amount_interest.action_value + amount_tax.action_value);
							str_alacakli_other_currency     = amount.action_currency_id;

							if (Len(get_credit_row.INTEREST_ACCOUNT_ID) And interest_price Gt 0) {
								str_borclu_hesaplar 			= ListAppend(str_borclu_hesaplar,get_credit_row.INTEREST_ACCOUNT_ID,",");
								str_borclu_tutarlar 			= ListAppend(str_borclu_tutarlar,wrk_round(interest_price),",");
								str_borclu_other_amount_tutar   = ListAppend(str_borclu_other_amount_tutar,wrk_round(interest_price),",");
								str_borclu_other_currency       = ListAppend(str_borclu_other_currency,amount.action_currency_id,",");
							}

							if (Len(get_credit_row.TOTAL_ACCOUNT_ID) And tax_price Gt 0) {
								str_borclu_hesaplar 			= ListAppend(str_borclu_hesaplar,get_credit_row.TOTAL_ACCOUNT_ID,",");
								str_borclu_tutarlar 			= ListAppend(str_borclu_tutarlar,wrk_round(tax_price),",");
								str_borclu_other_amount_tutar   = ListAppend(str_borclu_other_amount_tutar,wrk_round(tax_price),",");
								str_borclu_other_currency       = ListAppend(str_borclu_other_currency,amount.action_currency_id,",");
							}

							if (Len(str_borclu_hesaplar) And Len(str_alacakli_hesaplar)) {
								wodiba_muhasebeci (
									action_id: payment.IDENTITYCOL,
									workcube_process_type: action_type_id,
									workcube_process_cat: process_cat,
									account_card_type: 13,
									islem_tarihi: date,
									fis_satir_detay: str_card_detail,
									borc_hesaplar: str_borclu_hesaplar,
									borc_tutarlar: str_borclu_tutarlar,
									other_amount_borc : str_borclu_other_amount_tutar,
									other_currency_borc : str_borclu_other_currency,
									alacak_hesaplar: str_alacakli_hesaplar,
									alacak_tutarlar: str_alacakli_tutarlar,
									other_amount_alacak : str_alacakli_other_amount_tutar,
									other_currency_alacak : str_alacakli_other_currency,
									currency_multiplier : amount.action_rate_2,
									fis_detay: str_card_detail,
									belge_no : paper_no,
									is_abort : 0,
									action_currency : amount.action_currency_id,
									action_currency_2 : amount.system_currency_id_2,
									muhasebe_db: wodiba_dsn2,
									period_id: period_id
								);
							}
						}
						if (processCatResult.IS_BUDGET) {//işlem tipi bütçe hareketi yapıyor ise
							if (Len(get_credit_row.EXPENSE_CENTER_ID) And Len(get_credit_row.CAPITAL_EXPENSE_ITEM_ID)) {//ödeme tutarı için bütçe kaydı
								wodiba_butceci(
									muhasebe_db: wodiba_dsn2,
									expense_date: date,
									expense_center_id: get_credit_row.EXPENSE_CENTER_ID,
									expense_item_id: get_credit_row.CAPITAL_EXPENSE_ITEM_ID,
									expense_account_code: get_credit_row.CAPITAL_ACCOUNT_ID,
									process_type: action_type_id,
									detail: '#credit_no# KREDİ ÖDEMESİ MASRAFI',
									is_income_expense: false,
									action_id: payment.IDENTITYCOL,
									amount: amount,
									paper_no: paper_no,
									branch_id: 0,
									record_emp: record_emp,
									project_id: project_id,
									asset_id: 0
								);
							}
							if (Len(get_credit_row.EXPENSE_CENTER_ID) And Len(get_credit_row.EXPENSE_ITEM_ID) And interest_price Gt 0) {//faiz masrafı için bütçe kaydı
								wodiba_butceci(
									muhasebe_db: wodiba_dsn2,
									expense_date: date,
									expense_center_id: get_credit_row.EXPENSE_CENTER_ID,
									expense_item_id: get_credit_row.EXPENSE_ITEM_ID,
									expense_account_code: get_credit_row.TOTAL_ACCOUNT_ID,
									process_type: action_type_id,
									detail: '#credit_no# KREDİ ÖDEMESİ FAİZ MASRAFI',
									is_income_expense: false,
									action_id: payment.IDENTITYCOL,
									amount: amount_interest,
									paper_no: paper_no,
									branch_id: 0,
									record_emp: record_emp,
									project_id: project_id,
									asset_id: 0
								);
							}
							if (Len(get_credit_row.EXPENSE_CENTER_ID) And Len(get_credit_row.TOTAL_EXPENSE_ITEM_ID) And tax_price Gt 0) {//vergi masrafı için bütçe kaydı
								wodiba_butceci(
									muhasebe_db: wodiba_dsn2,
									expense_date: date,
									expense_center_id: get_credit_row.EXPENSE_CENTER_ID,
									expense_item_id: get_credit_row.TOTAL_EXPENSE_ITEM_ID,
									expense_account_code: get_credit_row.TOTAL_ACCOUNT_ID,
									process_type: action_type_id,
									detail: '#credit_no# KREDİ ÖDEMESİ VERGİ MASRAFI',
									is_income_expense: false,
									action_id: payment.IDENTITYCOL,
									amount: amount_tax,
									paper_no: paper_no,
									branch_id: 0,
									record_emp: record_emp,
									project_id: project_id,
									asset_id: 0
								);
							}
						}
						f_kur_ekle_action(
							action_id:payment.IDENTITYCOL,
							process_type:0,
							action_table_name:'CREDIT_CONTRACT_PAYMENT_INCOME_MONEY',
							action_table_dsn:'#wodiba_dsn2#');
					</cfscript>
				</cftransaction>
			</cflock>
			<cfscript>
				addPaymentCreditContract_return					= structNew();
				addPaymentCreditContract_return.bank_action_id    = res.IDENTITYCOL;
				addPaymentCreditContract_return.document_id       = res.IDENTITYCOL;
				return addPaymentCreditContract_return;
			</cfscript>
		<cfelse>
			<cfreturn error_str />
		</cfif>
	</cffunction>

	<cffunction name="addRevenueCreditContract" access="public" returntype="struct" output="false" hint="Wodiba kredi tahsilat işlemi ekler">
		<cfset addRevenueCreditContract_return_struct = structNew() />
		<cfreturn addRevenueCreditContract_return_struct />
	</cffunction>

	<cffunction name="addRevenueCheque" access="public" returntype="struct" output="false" hint="Wodiba çekin bankadan tahsil edilmesi işlemi ekler">
		<cfset addRevenueCheque_return_struct = structNew() />
		<cfreturn addRevenueCheque_return_struct />
	</cffunction>

	<cffunction name="addPaymentCheque" access="public" returntype="struct" output="true" hint="Wodiba çekin bankadan ödenmesi işlemi ekler">
		<cfargument name="period_id" type="numeric" required="true" />
		<cfargument name="process_cat" type="numeric" required="true" />
		<cfargument name="account_id" type="numeric" required="true" />
		<cfargument name="amount" type="any" required="true" hint="Tutarlar structure ile gönderilmelidir" />
		<cfargument name="date" type="date" required="true" />
		<cfargument name="detail" type="string" required="true" />
		<cfargument name="paper_no" type="string" required="true" />
		<cfargument name="record_emp" type="numeric" required="true" />
		<cfargument name="cheque_id" type="numeric" required="true" />
		<cfargument name="cheque_no" type="numeric" required="true" />
		<cfargument name="cheque_purse_no" type="string" required="true" />

		<cfscript>
			// parametric
			period_id               = arguments.period_id;
			process_cat             = arguments.process_cat;
			account_id              = arguments.account_id;
			amount                  = arguments.amount;
			date                    = arguments.date;
			detail                  = arguments.detail;
			paper_no                = arguments.paper_no;
			record_emp              = arguments.record_emp;
			dsn_alias               = dsn;
			session.ep.period_id    = period_id;
			cheque_id				= arguments.cheque_id;
			cheque_no				= arguments.cheque_no;
			cheque_purse_no			= arguments.cheque_purse_no;
			error_str               = structNew();

			//static
			action_type     = 'ÇEK ÖDEMESİ';
			action_type_id  = 1044;

			//computed
			periodQuery = new Query();
			periodQuery.setDatasource("#dsn#");
			periodQuery.setSQL("SELECT PERIOD_YEAR, IS_INTEGRATED, OUR_COMPANY_ID FROM SETUP_PERIOD WHERE PERIOD_ID = #period_id#");
			periodResult = periodQuery.execute();
			periodResult = periodResult.getResult();

			wodiba_dsn          = dsn;
			wodiba_dsn1         = dsn1;
			wodiba_dsn2         = '#dsn#_#periodResult.PERIOD_YEAR#_#periodResult.OUR_COMPANY_ID#';
			wodiba_dsn3         = '#dsn#_#periodResult.OUR_COMPANY_ID#';
			caller.dsn3_alias   = wodiba_dsn3;

			processCatQuery = new Query();
			processCatQuery.setDatasource("#wodiba_dsn3#");
			processCatQuery.setSQL("SELECT IS_ACCOUNT FROM SETUP_PROCESS_CAT WHERE PROCESS_CAT_ID = #process_cat#");
			processCatResult = processCatQuery.execute();
			processCatResult = processCatResult.getResult();

			moneyQuery = new Query();
			moneyQuery.setDatasource("#wodiba_dsn2#");
			moneyQuery.setSQL("SELECT MONEY, RATE1, RATE2 FROM SETUP_MONEY WHERE PERIOD_ID = #period_id#");
			moneyResult = moneyQuery.execute();
			moneyResult = moneyResult.getResult();

			accountQuery = new Query();
			accountQuery.setDatasource("#wodiba_dsn3#");
			accountQuery.setSQL("SELECT ACCOUNT_CURRENCY_ID, ACCOUNT_ACC_CODE, V_CHEQUE_ACC_CODE FROM ACCOUNTS WHERE ACCOUNT_ID = #account_id#");
			accountResult = accountQuery.execute();
			accountResult = accountResult.getResult();

			if (Not Len(accountResult.ACCOUNT_ACC_CODE) Or Not Len(accountResult.V_CHEQUE_ACC_CODE)) {
				error_str.error_type    = 'account_code';
				error_str.error_message = 'account_id: #account_id# için muhasebe hesabı tanımlı değil!';
			}

			attributes.kur_say = moneyResult.recordcount;
			attributes.money_type = accountResult.account_currency_id;
			for(mon=1; mon lte moneyResult.recordcount; mon++){//f_kur_ekle_action için gerekli
				evaluate("attributes.hidden_rd_money_#mon#  = moneyResult.money[mon]");
				evaluate("attributes.txt_rate1_#mon#        = moneyResult.rate1[mon]");
				evaluate("attributes.txt_rate2_#mon#        = moneyResult.rate2[mon]");
			}

			str_card_detail = '#cheque_no# - #cheque_purse_no# - ÇEK ÖDEME İŞLEMİ BANKADAN';
		</cfscript>

		<cfif structIsEmpty(error_str)>
		<cflock name="#createUUID()#" timeout="60">
			<cftransaction>
				<cfquery datasource="#wodiba_dsn2#">
					UPDATE CHEQUE SET CHEQUE_STATUS_ID = 7 WHERE CHEQUE_ID = #cheque_id#
				</cfquery>
				<cfquery datasource="#wodiba_dsn2#">
					INSERT INTO
						CHEQUE_HISTORY
					(
						CHEQUE_ID,
						STATUS,
						ACT_DATE,
						OTHER_MONEY,
						OTHER_MONEY_VALUE,
						OTHER_MONEY2,
						OTHER_MONEY_VALUE2,
						RECORD_DATE,
						RECORD_EMP
					)
						VALUES
					(
						#cheque_id#,
						7,
						#date#,
						'#amount.action_currency_id#',--OTHER_MONEY
						#wrk_round(amount.action_value)#,--OTHER_MONEY_VALUE
						'#amount.system_currency_id_2#',--OTHER_MONEY2
						#wrk_round(amount.system_action_value_2)#,--OTHER_MONEY_VALUE2
						#Now()#,
						#record_emp#
					)
				</cfquery>
				<cfquery datasource="#wodiba_dsn2#" result="res">
					INSERT INTO
						BANK_ACTIONS
					(
						PROCESS_CAT,
						ACTION_TYPE,
						ACTION_TYPE_ID,
						ACTION_FROM_ACCOUNT_ID,
						ACTION_VALUE,
						ACTION_CURRENCY_ID,
						SYSTEM_ACTION_VALUE,
						SYSTEM_CURRENCY_ID,
						ACTION_VALUE_2,
						ACTION_CURRENCY_ID_2,
						ACTION_DATE,
						ACTION_DETAIL,
						CHEQUE_ID,
						IS_ACCOUNT,
						IS_ACCOUNT_TYPE,
						RECORD_DATE,
						RECORD_EMP
					)
						VALUES
					(
						#process_cat#,
						'#action_type#',
						#action_type_id#,
						#account_id#,
						#wrk_round(amount.action_value)#,--ACTION_VALUE
						'#amount.action_currency_id#',--ACTION_CURRENCY_ID
						#wrk_round(amount.system_action_value)#,--SYSTEM_ACTION_VALUE
						'#amount.system_currency_id#',--SYSTEM_CURRENCY_ID
						#wrk_round(amount.system_action_value_2)#,--ACTION_VALUE_2
						'#amount.system_currency_id_2#',--ACTION_CURRENCY_ID_2
						#date#,
						'#str_card_detail#',--ACTION_DETAIL
						#cheque_id#,--CHEQUE_ID
						#processCatResult.is_account#,
						13,--IS_ACCOUNT_TYPE
						#Now()#,
						#record_emp#
					)
				</cfquery>
				<cfscript>
					if(processCatResult.is_account eq 1)
					{
						str_borclu_hesaplar     = accountResult.V_CHEQUE_ACC_CODE;
						str_alacakli_hesaplar   = accountResult.ACCOUNT_ACC_CODE;
						str_tutarlar            = wrk_round(amount.action_value);

						str_borclu_other_amount_tutar   = wrk_round(amount.action_value);
						str_borclu_other_currency       = amount.action_currency_id;
						str_alacakli_other_amount_tutar = wrk_round(amount.action_value);
						str_alacakli_other_currency     = amount.action_currency_id;

						if (Len(str_borclu_hesaplar) And Len(str_alacakli_hesaplar)) {
							wodiba_muhasebeci (
								action_id: res.IDENTITYCOL,
								workcube_process_type: action_type_id,
								workcube_process_cat: process_cat,
								account_card_type: 13,
								islem_tarihi: date,
								fis_satir_detay: str_card_detail,
								borc_hesaplar: str_borclu_hesaplar,
								borc_tutarlar: str_tutarlar,
								other_amount_borc : str_borclu_other_amount_tutar,
								other_currency_borc : str_borclu_other_currency,
								alacak_hesaplar: str_alacakli_hesaplar,
								alacak_tutarlar: str_tutarlar,
								other_amount_alacak : str_alacakli_other_amount_tutar,
								other_currency_alacak : str_alacakli_other_currency,
								currency_multiplier : amount.action_rate_2,
								fis_detay: str_card_detail,
								belge_no : paper_no,
								is_abort : 0,
								action_currency : amount.action_currency_id,
								action_currency_2 : amount.system_currency_id_2,
								muhasebe_db: wodiba_dsn2,
								period_id: period_id
							);
						}
					}
					f_kur_ekle_action(
						action_id:res.IDENTITYCOL,
						process_type:0,
						action_table_name:'CHEQUE_HISTORY_MONEY',
						action_table_dsn:'#wodiba_dsn2#');
				</cfscript>
			</cftransaction>
		</cflock>

		<cfscript>
			addPaymentCheque_return_struct                   = structNew();
			addPaymentCheque_return_struct.bank_action_id    = res.IDENTITYCOL;
			addPaymentCheque_return_struct.document_id       = res.IDENTITYCOL;
			return addPaymentCheque_return_struct;
		</cfscript>
		<cfelse>
			<cfreturn error_str />
		</cfif>
	</cffunction>

	<cffunction name="addPaymentVoucher" access="public" returntype="struct" output="false" hint="Wodiba senedin bankadan ödenmesi işlemi ekler">
		<cfset addPaymentVoucher_return_struct = structNew() />
		<cfreturn addPaymentVoucher_return_struct />
	</cffunction>

	<cffunction name="addRevenueVoucher" access="public" returntype="struct" output="false" hint="Wodiba senedin bankadan tahsil edilmesi işlemi ekler">
		<cfset addRevenueVoucher_return_struct = structNew() />
		<cfreturn addRevenueVoucher_return_struct />
	</cffunction>

	<cffunction name="wodiba_carici" access="private" returntype="boolean" output="false" hint="Wodiba cari kayıtları ekler">
		<!---
			wodiba_carici(
				action_id : res.IDENTITYCOL,
				action_table : 'BANK_ACTIONS',
				islem_belge_no : paper_no,
				workcube_process_type : action_type_id,
				process_cat : process_cat,
				islem_tarihi : date,
				to_account_id : account_id,
				islem_tutari : wrk_round(amount * actionRate),
				action_currency : system_money,
				action_currency_2 : system_money2,
				other_money_value : amount,
				other_money : accountResult.account_currency_id,
				currency_multiplier : money2Rate,
				islem_detay : action_type,
				period_is_integrated:
				action_detail : detail,
				account_card_type : 13,
				acc_type_id : iif(acc_type_id neq 0,acc_type_id,de('')),
				due_date: date,
				from_employee_id : iif(employee_id neq 0,employee_id,de('')),
				from_cmp_id : iif(company_id neq 0,company_id,de('')),
				from_consumer_id : iif(consumer_id neq 0,consumer_id,de('')),
				rate2: actionRate,
				record_emp: record_emp,
				cari_db: wodiba_dsn2,
				project_id: project_id,
				assetp_id: assetp_id,
				special_definition_id: special_definition_id
				); --->
		<cfargument name="action_id" required="yes" type="numeric">
		<cfargument name="process_cat" required="yes" type="numeric">
		<cfargument name="action_table" type="string">
		<cfargument name="workcube_process_type" required="yes" type="numeric">
		<cfargument name="workcube_old_process_type" type="numeric">
		<cfargument name="action_currency" required="yes">
		<cfargument name="action_currency_2" type="string">
		<cfargument name="currency_multiplier" type="string" default="">
		<cfargument name="other_money" type="string" default="">
		<cfargument name="other_money_value" type="string" default="">
		<cfargument name="account_card_type" type="numeric">
		<cfargument name="islem_tarihi" required="yes" type="date">
		<cfargument name="paper_act_date" type="date">
		<cfargument name="acc_type_id" required="false" />
		<cfargument name="due_date" type="string">
		<cfargument name="islem_tutari" required="yes" type="numeric">
		<cfargument name="action_value2">
		<cfargument name="islem_belge_no" type="string" default="">
		<cfargument name="islem_detay" type="string" default="">
		<cfargument name="period_is_integrated" type="boolean" required="false" default="0" />
		<cfargument name="cari_db" type="string" default="#dsn2#">
		<cfargument name="cari_db_alias" type="string">
		<cfargument name="expense_center_id">
		<cfargument name="expense_item_id">
		<cfargument name="payer_id">
		<cfargument name="revenue_collector_id">
		<cfargument name="to_cmp_id">
		<cfargument name="from_cmp_id">
		<cfargument name="to_account_id">
		<cfargument name="from_account_id">
		<cfargument name="to_cash_id">
		<cfargument name="from_cash_id">
		<cfargument name="to_employee_id">
		<cfargument name="from_employee_id">
		<cfargument name="to_consumer_id">
		<cfargument name="from_consumer_id">
		<cfargument name="is_processed" type="numeric" default="0">
		<cfargument name="action_detail" type="string" default="">
		<cfargument name="from_branch_id">
		<cfargument name="to_branch_id">
		<cfargument name="project_id">
		<cfargument name="payroll_id">
		<cfargument name="rate2">
		<cfargument name="is_cancel">
		<cfargument name="is_cash_payment" default="0">
		<cfargument name="is_upd_other_value" default="0">
		<cfargument name="payment_value">
		<cfargument name="record_emp">
		<cfargument name="assetp_id" type="numeric">
		<cfargument name="special_definition_id" type="numeric">
		<cftry>
		<cfscript>
			if(cari_db is not '#dsn2#'){
				if(arguments.cari_db is '#dsn#' or arguments.cari_db is '#dsn1#' or arguments.cari_db is '#dsn3#')
					arguments.cari_db_alias = '#dsn2_alias#.';
				else
					arguments.cari_db_alias = '#cari_db#.';
			}
			else{
				arguments.cari_db_alias = '';
			}
		</cfscript>

		<cfif len(arguments.action_currency_2) and (not len(arguments.currency_multiplier)) and (not (isdefined('arguments.action_value2') and len(arguments.action_value2)))>
			<cfquery name="get_currency_rate" datasource="#arguments.cari_db#">
				SELECT (RATE2/RATE1) RATE FROM SETUP_MONEY WHERE MONEY = '#arguments.action_currency_2#'
			</cfquery>
			<cfif get_currency_rate.recordcount>
				<cfset arguments.currency_multiplier = get_currency_rate.RATE />
			</cfif>
		</cfif>

		<cfquery name="ADD_CARI" datasource="#arguments.cari_db#" result="GET_MAX_CARI">
			INSERT INTO
				#arguments.cari_db_alias#CARI_ROWS
				(
					ACTION_ID,
					ACTION_TYPE_ID,
					ACTION_DATE,
					PROCESS_CAT,
					ACTION_VALUE,
					ACTION_CURRENCY_ID,
					<cfif len(arguments.action_currency_2)>
					ACTION_VALUE_2,ACTION_CURRENCY_2,
					</cfif>
					PAYMENT_VALUE,
					ACTION_TABLE,
					PAPER_NO,
					ACTION_DETAIL,
					DUE_DATE,
					ACTION_NAME,
					EXPENSE_CENTER_ID,
					EXPENSE_ITEM_ID,
					SPECIAL_DEFINITION_ID,
					PAYER_ID,
					OTHER_CASH_ACT_VALUE,
					OTHER_MONEY,
					RATE2,
					TO_CMP_ID,
					FROM_CMP_ID,
					TO_ACCOUNT_ID,
					FROM_ACCOUNT_ID,
					TO_CASH_ID,
					FROM_CASH_ID,
					TO_EMPLOYEE_ID,
					FROM_EMPLOYEE_ID,
					TO_CONSUMER_ID,
					FROM_CONSUMER_ID,
					REVENUE_COLLECTOR_ID,
					IS_PROCESSED,
					IS_CASH_PAYMENT,
					ACC_TYPE_ID,
					PAPER_ACT_DATE,
					FROM_BRANCH_ID,
					TO_BRANCH_ID,
					ASSETP_ID,
					PROJECT_ID,
					PAYROLL_ID,
					IS_ACCOUNT,
					IS_ACCOUNT_TYPE,
					IS_CANCEL,
					RECORD_DATE,
					RECORD_EMP,
					RECORD_IP
				)
			VALUES
				(
					#arguments.action_id#,
					#arguments.workcube_process_type#,
					#arguments.islem_tarihi#,
					#arguments.process_cat#,
					#wrk_round(arguments.islem_tutari,2)#,
					'#arguments.action_currency#',
					<cfif len(arguments.action_currency_2)>
						<cfif isdefined('arguments.action_value2') and len(arguments.action_value2)>#wrk_round(arguments.action_value2,2)#,<cfelseif isdefined("arguments.currency_multiplier") and len(arguments.currency_multiplier)>#wrk_round((arguments.islem_tutari/arguments.currency_multiplier),2)#,<cfelse>NULL,</cfif>
						'#arguments.action_currency_2#',
					</cfif>
					<cfif isDefined('arguments.payment_value') and len(arguments.payment_value)>#arguments.payment_value#<cfelse>NULL</cfif>,
					<cfif isDefined('arguments.action_table') and len(arguments.action_table)>'#arguments.action_table#'<cfelse>NULL</cfif>,
					<cfif isDefined('arguments.islem_belge_no') and len(arguments.islem_belge_no)>'#arguments.islem_belge_no#'<cfelse>NULL</cfif>,
					<cfif isDefined('arguments.action_detail') and len(arguments.action_detail)><cfqueryparam cfsqltype="cf_sql_varchar" value="#LEFT(arguments.action_detail,250)#"><cfelse>NULL</cfif>,
					<cfif isDefined('arguments.due_date') and isdate(arguments.due_date)>#arguments.due_date#<cfelse>#arguments.islem_tarihi#</cfif>,
					<cfif isDefined('arguments.islem_detay') and len(arguments.islem_detay)>'#LEFT(arguments.islem_detay,100)#'<cfelse>NULL</cfif>,
					<cfif isDefined('arguments.expense_center_id') and isnumeric(arguments.expense_center_id)>#arguments.expense_center_id#<cfelse>NULL</cfif>,
					<cfif isDefined('arguments.expense_item_id') and isnumeric(arguments.expense_item_id)>#arguments.expense_item_id#<cfelse>NULL</cfif>,
					<cfif isDefined('arguments.special_definition_id') and isnumeric(arguments.special_definition_id)>#arguments.special_definition_id#<cfelse>NULL</cfif>,
					<cfif isDefined('arguments.payer_id') and isnumeric(arguments.payer_id)>#arguments.payer_id#<cfelse>NULL</cfif>,
					<cfif isDefined('arguments.other_money_value') and isnumeric(arguments.other_money_value)>#wrk_round(arguments.other_money_value,2)#<cfelse>NULL</cfif>,
					<cfif isDefined('arguments.other_money') and len(arguments.other_money)>'#arguments.other_money#'<cfelse>NULL</cfif>,
					<cfif isdefined("arguments.rate2") and len(arguments.rate2) and arguments.rate2 neq 0>#arguments.rate2#<cfelseif isDefined('arguments.other_money_value') and isnumeric(arguments.other_money_value) and arguments.other_money_value neq 0>#arguments.islem_tutari/arguments.other_money_value#<cfelse>NULL</cfif>,
					<cfif isDefined('arguments.to_cmp_id') and isnumeric(arguments.to_cmp_id) and not (isDefined('arguments.to_employee_id') and isnumeric(arguments.to_employee_id))>#arguments.to_cmp_id#<cfelse>NULL</cfif>,
					<cfif isDefined('arguments.from_cmp_id') and isnumeric(arguments.from_cmp_id) and not (isDefined('arguments.from_employee_id') and isnumeric(arguments.from_employee_id))>#arguments.from_cmp_id#<cfelse>NULL</cfif>,
					<cfif isDefined('arguments.to_account_id') and isnumeric(arguments.to_account_id)>#arguments.to_account_id#<cfelse>NULL</cfif>,
					<cfif isDefined('arguments.from_account_id') and isnumeric(arguments.from_account_id)>#arguments.from_account_id#<cfelse>NULL</cfif>,
					<cfif isDefined('arguments.to_cash_id') and isnumeric(arguments.to_cash_id)>#arguments.to_cash_id#<cfelse>NULL</cfif>,
					<cfif isDefined('arguments.from_cash_id') and isnumeric(arguments.from_cash_id)>#arguments.from_cash_id#<cfelse>NULL</cfif>,
					<cfif isDefined('arguments.to_employee_id') and isnumeric(arguments.to_employee_id)>#arguments.to_employee_id#<cfelse>NULL</cfif>,
					<cfif isDefined('arguments.from_employee_id') and isnumeric(arguments.from_employee_id)>#arguments.from_employee_id#<cfelse>NULL</cfif>,
					<cfif isDefined('arguments.to_consumer_id') and isnumeric(arguments.to_consumer_id)>#arguments.to_consumer_id#<cfelse>NULL</cfif>,
					<cfif isDefined('arguments.from_consumer_id') and isnumeric(arguments.from_consumer_id)>#arguments.from_consumer_id#<cfelse>NULL</cfif>,
					<cfif isDefined('arguments.revenue_collector_id') and isnumeric(arguments.revenue_collector_id)>#arguments.revenue_collector_id#<cfelse>NULL</cfif>,
					<cfif isDefined('arguments.is_processed') and isnumeric(arguments.is_processed)>#arguments.is_processed#<cfelse>0</cfif>,
					<cfif isdefined('arguments.is_cash_payment') and len(arguments.is_cash_payment)>#arguments.is_cash_payment#<cfelse>NULL</cfif>,
					<cfif isdefined('arguments.acc_type_id') and len(arguments.acc_type_id) and arguments.acc_type_id neq 0>
						#arguments.acc_type_id#
					<cfelseif (isDefined('arguments.to_employee_id') and isnumeric(arguments.to_employee_id)) or (isDefined('arguments.from_employee_id') and isnumeric(arguments.from_employee_id))>
						-1
					<cfelse>
						NULL
					</cfif>,
					<cfif isdefined('arguments.paper_act_date') and len(arguments.paper_act_date)>#arguments.paper_act_date#<cfelse>NULL</cfif>,
					<cfif isdefined('arguments.from_branch_id') and len(arguments.from_branch_id)>#arguments.from_branch_id#<cfelse>NULL</cfif>,
					<cfif isdefined('arguments.to_branch_id') and len(arguments.to_branch_id)>#arguments.to_branch_id#<cfelse>NULL</cfif>,
					<cfif isdefined('arguments.assetp_id') and len(arguments.assetp_id)>#arguments.assetp_id#<cfelse>NULL</cfif>,
					<cfif isdefined('arguments.project_id') and len(arguments.project_id)>#arguments.project_id#<cfelse>NULL</cfif>,
					<cfif isdefined('arguments.payroll_id') and len(arguments.payroll_id)>#arguments.payroll_id#<cfelse>NULL</cfif>,
					<cfif arguments.period_is_integrated>1,#arguments.account_card_type#<cfelse>0,0</cfif>,
					<cfif isdefined('arguments.is_cancel') and len(arguments.is_cancel)>#arguments.is_cancel#,<cfelse>0,</cfif>
					#now()#,
					#record_emp#,
					'#CGI.REMOTE_ADDR#'
				)
		</cfquery>
		<cfcatch>
			<cfdump var="#cfcatch#" abort="true" />
		</cfcatch>
		</cftry>
		<cfset max_cari_action_id = GET_MAX_CARI.IDENTITYCOL>
		<cfreturn 1>
	</cffunction>

	<cffunction name="wodiba_muhasebeci" access="private" returntype="numeric" output="false" hint="Wodiba muhasebeci kayıtlarını ekler">
		<!---
			wodiba_muhasebeci (
				action_id: res.IDENTITYCOL,
				workcube_process_type: action_type_id,
				workcube_process_cat: process_cat,
				account_card_type: 13,
				company_id: iif(company_id neq 0,company_id,de('')),
				consumer_id: iif(consumer_id neq 0,consumer_id,de('')),
				employee_id: iif(employee_id neq 0,employee_id,de('')),
				islem_tarihi: date,
				fis_satir_detay: str_card_detail,
				borc_hesaplar: str_borclu_hesaplar,
				borc_tutarlar: str_tutarlar,
				other_amount_borc : str_borclu_other_amount_tutar,
				other_currency_borc : str_borclu_other_currency,
				alacak_hesaplar: str_alacakli_hesaplar,
				alacak_tutarlar: str_tutarlar,
				other_amount_alacak : str_alacakli_other_amount_tutar,
				other_currency_alacak : str_alacakli_other_currency,
				currency_multiplier : money2Rate,
				fis_detay: UCase(getLang('main',422)),
				belge_no : paper_no,
				is_abort : 0,
				action_currency : system_money,
				action_currency_2 : system_money2,
				muhasebe_db: wodiba_dsn2,
				period_id: period_id,
				acc_project_id: project_id
			); --->
		<cfargument name="action_id" required="yes" type="numeric">
		<cfargument name="action_currency" required="yes">
		<cfargument name="action_currency_2" type="string">
		<cfargument name="currency_multiplier" type="string" default="">
		<cfargument name="workcube_process_type" required="yes" type="numeric">
		<cfargument name="workcube_old_process_type" type="numeric">
		<cfargument name="account_card_type" required="yes" type="numeric">
		<cfargument name="account_card_catid" required="yes" type="numeric" default="0"> <!--- muhasebe fiş türünün process_cat_id si--->
		<cfargument name="islem_tarihi" required="yes" type="date">
		<cfargument name="borc_hesaplar" required="yes" type="string">
		<cfargument name="borc_tutarlar" required="yes" type="string">
		<cfargument name="alacak_hesaplar" required="yes" type="string">
		<cfargument name="alacak_tutarlar" required="yes" type="string">
		<cfargument name="other_amount_borc" type="string" default="">
		<cfargument name="other_amount_alacak" type="string" default="">
		<cfargument name="other_currency_borc" type="string" default="">
		<cfargument name="other_currency_alacak" type="string" default="">
		<cfargument name="belge_no" type="string" default="">
		<cfargument name="fis_detay" type="string">
		<cfargument name="fis_satir_detay" default="">
		<cfargument name="wrk_id" type="string" default="">
		<cfargument name="muhasebe_db" type="string" default="#dsn2#">
		<cfargument name="muhasebe_db_alias" type="string" default="">
		<cfargument name="company_id" default="">
		<cfargument name="consumer_id" default="">
		<cfargument name="employee_id" default="">
		<cfargument name="alacak_miktarlar" default="">
		<cfargument name="borc_miktarlar" default="">
		<cfargument name="alacak_birim_tutar" default="">
		<cfargument name="borc_birim_tutar" default="">
		<cfargument name="is_account_group" type="numeric" default="0">
		<cfargument name="is_other_currency" type="numeric" default="0"><!--- 0: muhasebe fisi dovizli goruntulenMEsin, 1: goruntulensin --->
		<cfargument name="base_period_year_start" default="">
		<cfargument name="base_period_year_finish" default="">
		<cfargument name="action_table" type="string"> <!--- payrollda cek bazlı muhasebe islemi yapılabilmesi icin eklendi --->
		<cfargument name="from_branch_id">
		<cfargument name="to_branch_id">
		<cfargument name="acc_department_id">
		<cfargument name="acc_project_id">
		<cfargument name="acc_project_list_alacak" type="string" default="">
		<cfargument name="acc_project_list_borc" type="string" default="">
		<cfargument name="acc_branch_list_alacak" type="string" default="">
		<cfargument name="acc_branch_list_borc" type="string" default="">
		<cfargument name="is_abort" type="numeric" default="1">
		<cfargument name="dept_round_account" default=""> <!---muhasebe fisi borc-alacak toplamları arasındaki BORC FARKI icin kullanılacak yuvarlama hesabı --->
		<cfargument name="claim_round_account" default=""> <!---muhasebe fisi borc-alacak toplamları arasındaki ALACAK FARKI icin kullanılacak yuvarlama hesabı --->
		<cfargument name="max_round_amount" default="0"> <!---borc-alacak toplamları arasında yuvarlama yapılabilecek max. fark --->
		<cfargument name="round_row_detail" default=""><!--- yuvarlama satırı acıklama bilgisi, gönderilmezse yuvarlama satırına fis_detay bilgisi yazılır --->
		<cfargument name="workcube_process_cat" default=""> <!--- islem kategorisi process_cat_id --->
		<cfargument name="action_row_id" default="">
		<cfargument name="due_date" default="">
		<cfargument name="is_cancel">
		<cfargument name="document_type" default="">
		<cfargument name="payment_method" default="">
		<cfargument name="period_id" default="">

		<cftry>
		<cfscript>
			if(arguments.muhasebe_db_alias == '' and arguments.muhasebe_db is not '#dsn2#')
			{
				if(arguments.muhasebe_db is '#dsn#' or arguments.muhasebe_db is '#dsn1#' or arguments.muhasebe_db is '#dsn3#')
					arguments.muhasebe_db_alias = '#dsn2_alias#.';
				else
					arguments.muhasebe_db_alias = '#muhasebe_db#.';
			}
			else
			{
				arguments.muhasebe_db_alias = '#arguments.muhasebe_db_alias#.';
			}

			companyQuery = new Query();
			companyQuery.setDatasource("#arguments.muhasebe_db#");
			companyQuery.setSQL("SELECT IS_PROJECT_GROUP, IS_EDEFTER, IS_USE_IFRS FROM #dsn_alias#.OUR_COMPANY_INFO WHERE COMP_ID = #periodResult.our_company_id#");
			companyResult = companyQuery.execute();
			companyResult = companyResult.getResult();
		</cfscript>

		<cfif companyResult.is_edefter eq 1>
			<cfset netbook_date = ''>
			<cfstoredproc procedure="GET_NETBOOK" datasource="#arguments.muhasebe_db#">
				<cfprocparam cfsqltype="cf_sql_timestamp" value="#netbook_date#" null="#not(len(netbook_date))#">
				<cfprocparam cfsqltype="cf_sql_timestamp" value="#arguments.islem_tarihi#">
				<cfprocparam cfsqltype="cf_sql_varchar" value="#arguments.muhasebe_db_alias#">
				<cfprocresult name="getNetbook">
			</cfstoredproc>
			<cfif getNetbook.recordcount>
				<!--- <script type="text/javascript">
					alert('Muhasebeci : İşlemi yapamazsınız. İşlem tarihine ait e-defter bulunmaktadır.');
				</script>
				<cfabort> --->
			</cfif>
		</cfif>

		<cfif len(arguments.account_card_type) and arguments.account_card_catid eq 0 or not len(arguments.account_card_catid)>
			<cfquery name="CONTROL_ACC_CARD_PROCESS_" datasource="#arguments.muhasebe_db#"> <!---fiş türüne ait default olarak tanımlanmış işlem kategorisi bulunuyor --->
				SELECT
					PROCESS_CAT_ID,PROCESS_CAT,
					PROCESS_TYPE,DISPLAY_FILE_NAME,
					DISPLAY_FILE_FROM_TEMPLATE
				FROM
					<cfif isdefined('dsn3_alias')>#dsn3_alias#<cfelse>#caller.dsn3_alias#</cfif>.SETUP_PROCESS_CAT <!--- işlem kategorilerinin action fileların tanımlı olmama durumu için eklendi --->
				WHERE
					PROCESS_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.account_card_type#">
					AND IS_DEFAULT=1
			</cfquery>
			<cfif control_acc_card_process_.recordcount eq 0>
				<cfscript>
					if(arguments.account_card_type eq 13)
						alert_card_type_name='Mahsup';
					else if(arguments.account_card_type eq 12)
						alert_card_type_name='Tediye';
					else if(arguments.account_card_type eq 11)
						alert_card_type_name='Tahsil';
				</cfscript>
				<!--- <script type="text/javascript">
					alert('Muhasebeci: Standart <cfoutput>#alert_card_type_name#</cfoutput> Fişi İşlem Kategorisi Tanımlı Değil! İşlem Kategorileri Bölümünde Fiş Tanımlarınızı Yapınız!');
				</script>
				<cfabort> --->
			<cfelse>
				<cfset arguments.account_card_catid=control_acc_card_process_.process_cat_id>
			</cfif>
		</cfif>
		<cfif ((isDefined('arguments.base_period_year_start') and year(arguments.islem_tarihi) lt arguments.base_period_year_start) or (isDefined('arguments.base_period_year_finish') and len(arguments.base_period_year_finish) and year(arguments.islem_tarihi) gt arguments.base_period_year_finish)) and workcube_process_type neq 130 and workcube_process_type neq 161>
			<!--- <script type="text/javascript">
				alert('Muhasebeci : İşlem Tarihi Döneme Uygun Değil.');
			</script>
			<cfabort> --->
		</cfif>
		<cfif len(arguments.other_amount_borc) and listlen(arguments.other_amount_borc,',') neq listlen(arguments.borc_tutarlar,',')>
			<!--- <script type="text/javascript">
				alert('Muhasebeci : Dövizli Borç Listesi Eksik.');
			</script>
			<cfabort> --->
		</cfif>
		<cfif len(arguments.other_amount_alacak) and listlen(arguments.other_amount_alacak,',') neq listlen(arguments.alacak_tutarlar,',')>
			<!--- <script type="text/javascript">
				alert('Muhasebeci : Dövizli Alacak Listesi Eksik.');
			</script>
			<cfabort> --->
		</cfif>
		<cfif len(arguments.action_currency_2) and (not len(arguments.currency_multiplier))>
			<cfquery name="get_currency_rate" datasource="#arguments.muhasebe_db#">
				SELECT (RATE2/RATE1) RATE FROM SETUP_MONEY WHERE MONEY ='#arguments.action_currency_2#'
			</cfquery>
			<cfif get_currency_rate.recordcount>
				<cfset arguments.currency_multiplier = get_currency_rate.RATE />
			</cfif>
		</cfif>
		<cfscript>
			muh_query = QueryNew("BA,ACCOUNT_CODE,AMOUNT,OTHER_AMOUNT,OTHER_CURRENCY,DETAIL,QUANTITY,PRICE,ACC_PROJECT_ID,ACC_BRANCH_ID","Bit,VarChar,Double,Double,Varchar,Varchar,Double,Double,Double,Double");
			muh_query_row = 0;
			borc_hesaplar_total = 0;
			alacak_hesaplar_total = 0;
			other_borc_hesaplar_total = 0;
			other_alacak_hesaplar_total = 0;
			for(i_index=1;i_index lte listlen(arguments.borc_hesaplar,',');i_index=i_index+1){
				if((wrk_round(listgetat(arguments.borc_tutarlar,i_index,','),4) gt 0 and len(listgetat(arguments.borc_hesaplar,i_index,',')) gt 0) or (listlen(arguments.other_amount_borc) and wrk_round(listgetat(arguments.other_amount_borc,i_index,','),4) gt 0 and len(listgetat(arguments.borc_hesaplar,i_index,',')) gt 0))
					{
					muh_query_row = muh_query_row + 1;
					QueryAddRow(muh_query,1);
					QuerySetCell(muh_query,"BA",0,muh_query_row);
					QuerySetCell(muh_query,"ACCOUNT_CODE",listgetat(arguments.borc_hesaplar,i_index,','),muh_query_row);
					{
						QuerySetCell(muh_query,"AMOUNT",listgetat(arguments.borc_tutarlar,i_index,','),muh_query_row);
						if(len(arguments.other_amount_borc)){
							QuerySetCell(muh_query,"OTHER_AMOUNT",listgetat(arguments.other_amount_borc,i_index,','),muh_query_row);
							QuerySetCell(muh_query,"OTHER_CURRENCY",listgetat(arguments.other_currency_borc,i_index,','),muh_query_row);
							}
					}
					if(IsArray(arguments.fis_satir_detay) and Arraylen(arguments.fis_satir_detay[1]) gte i_index)
					{
						if(len(arguments.belge_no))
							arguments.fis_satir_detay[1][i_index] = replace(arguments.fis_satir_detay[1][i_index],arguments.belge_no,'','all');
						if(len(arguments.belge_no) and not findnocase(arguments.belge_no,arguments.fis_satir_detay[1][i_index]))
						{
							arguments.fis_satir_detay[1][i_index] =  arguments.belge_no&"-"&arguments.fis_satir_detay[1][i_index] ;
							arguments.fis_satir_detay[1][i_index] = replace(arguments.fis_satir_detay[1][i_index],'- -','-');
						}
						QuerySetCell(muh_query,"DETAIL",arguments.fis_satir_detay[1][i_index],muh_query_row);
					}
					else if (not IsArray(arguments.fis_satir_detay))
					{
						if(len(arguments.belge_no))
							arguments.fis_satir_detay = replace(arguments.fis_satir_detay,"#arguments.belge_no# - ",'','all');
						if(len(arguments.belge_no) and not findnocase(arguments.belge_no,arguments.fis_satir_detay))
						{
							arguments.fis_satir_detay =  arguments.belge_no&"-"&arguments.fis_satir_detay;
							arguments.fis_satir_detay = replace(arguments.fis_satir_detay,'- -','-');
						}
						QuerySetCell(muh_query,"DETAIL",arguments.fis_satir_detay,muh_query_row);
					}
					if(IsArray(arguments.borc_miktarlar) and Arraylen(arguments.borc_miktarlar) gte i_index)
						QuerySetCell(muh_query,"QUANTITY",arguments.borc_miktarlar[i_index],muh_query_row);
					else if (not IsArray(arguments.borc_miktarlar))
						QuerySetCell(muh_query,"QUANTITY",arguments.borc_miktarlar,muh_query_row);
					if(IsArray(arguments.borc_birim_tutar) and Arraylen(arguments.borc_birim_tutar) gte i_index)
						QuerySetCell(muh_query,"PRICE",arguments.borc_birim_tutar[i_index],muh_query_row);
					else if (not IsArray(arguments.borc_birim_tutar))
						QuerySetCell(muh_query,"PRICE",arguments.borc_birim_tutar,muh_query_row);
					if(listlen(arguments.acc_project_list_borc))
						QuerySetCell(muh_query,"ACC_PROJECT_ID",listgetat(arguments.acc_project_list_borc,i_index,','),muh_query_row);
					else if (not listlen(arguments.acc_project_list_borc))
						QuerySetCell(muh_query,"ACC_PROJECT_ID",0,muh_query_row);
					if(len(arguments.acc_branch_list_borc))
						QuerySetCell(muh_query,"ACC_BRANCH_ID",listgetat(arguments.acc_branch_list_borc,i_index,','),muh_query_row);
					else
						QuerySetCell(muh_query,"ACC_BRANCH_ID",0,muh_query_row);
					}
			}
			for(i_index=1;i_index lte listlen(arguments.alacak_hesaplar,',');i_index=i_index+1){
				if((wrk_round(listgetat(arguments.alacak_tutarlar,i_index,','),4) gt 0 and len(listgetat(arguments.alacak_hesaplar,i_index,',')) gt 0) or (listlen(arguments.other_amount_alacak) and wrk_round(listgetat(arguments.other_amount_alacak,i_index,','),4) gt 0 and len(listgetat(arguments.alacak_hesaplar,i_index,',')) gt 0))
					{
					muh_query_row = muh_query_row + 1;
					QueryAddRow(muh_query,1);
					QuerySetCell(muh_query,"BA",1,muh_query_row);
					QuerySetCell(muh_query,"ACCOUNT_CODE",listgetat(arguments.alacak_hesaplar,i_index,','),muh_query_row);
					{
						QuerySetCell(muh_query,"AMOUNT",listgetat(arguments.alacak_tutarlar,i_index,','),muh_query_row);
						if(len(arguments.other_amount_alacak)){
							QuerySetCell(muh_query,"OTHER_AMOUNT",listgetat(arguments.other_amount_alacak,i_index,','),muh_query_row);
							QuerySetCell(muh_query,"OTHER_CURRENCY",listgetat(arguments.other_currency_alacak,i_index,','),muh_query_row);
							}
					}
					if(IsArray(arguments.fis_satir_detay) and Arraylen(arguments.fis_satir_detay[2]) gte i_index)
					{
						if(len(arguments.belge_no) and not findnocase(arguments.belge_no,arguments.fis_satir_detay[2][i_index]))
						{
							arguments.fis_satir_detay[2][i_index] =  arguments.belge_no&"-"&arguments.fis_satir_detay[2][i_index] ;
							arguments.fis_satir_detay[2][i_index] = replace(arguments.fis_satir_detay[2][i_index],'- -','-');
						}
						QuerySetCell(muh_query,"DETAIL",arguments.fis_satir_detay[2][i_index],muh_query_row);
					}
					else if (not IsArray(arguments.fis_satir_detay))
					{
						if(len(arguments.belge_no) and not findnocase(arguments.belge_no,arguments.fis_satir_detay))
						{
							arguments.fis_satir_detay =  arguments.belge_no&"-"&arguments.fis_satir_detay ;
							arguments.fis_satir_detay = replace(arguments.fis_satir_detay,'- -','-');
						}
						QuerySetCell(muh_query,"DETAIL",arguments.fis_satir_detay,muh_query_row);
					}
					if(IsArray(arguments.alacak_miktarlar) and Arraylen(arguments.alacak_miktarlar) gte i_index)
						QuerySetCell(muh_query,"QUANTITY",arguments.alacak_miktarlar[i_index],muh_query_row);
					else if (not IsArray(arguments.alacak_miktarlar))
						QuerySetCell(muh_query,"QUANTITY",arguments.alacak_miktarlar,muh_query_row);
					if(IsArray(arguments.alacak_birim_tutar) and Arraylen(arguments.alacak_birim_tutar) gte i_index)
						QuerySetCell(muh_query,"PRICE",arguments.alacak_birim_tutar[i_index],muh_query_row);
					else if (not IsArray(arguments.alacak_birim_tutar))
						QuerySetCell(muh_query,"PRICE",arguments.alacak_birim_tutar,muh_query_row);
					if(listlen(arguments.acc_project_list_alacak))
						QuerySetCell(muh_query,"ACC_PROJECT_ID",listgetat(arguments.acc_project_list_alacak,i_index,','),muh_query_row);
					else if (not listlen(arguments.acc_project_list_alacak))
						QuerySetCell(muh_query,"ACC_PROJECT_ID",0,muh_query_row);
					if(len(arguments.acc_branch_list_alacak))
						QuerySetCell(muh_query,"ACC_BRANCH_ID",listgetat(arguments.acc_branch_list_alacak,i_index,','),muh_query_row);
					else
						QuerySetCell(muh_query,"ACC_BRANCH_ID",0,muh_query_row);
					}
			}
		</cfscript>

		<cfif arguments.is_account_group>
			<cfif not len(companyResult.is_project_group) or companyResult.is_project_group eq 1><!--- şirket akış parametrelerinde proje bazında grupla seçili ise --->
				<cfquery name="muh_query" dbtype="query">
					SELECT SUM(OTHER_AMOUNT) OTHER_AMOUNT,SUM(AMOUNT) AMOUNT,ACC_PROJECT_ID, BA, ACCOUNT_CODE, OTHER_CURRENCY,DETAIL,SUM(QUANTITY) QUANTITY, SUM(PRICE) PRICE FROM muh_query GROUP BY ACC_PROJECT_ID,BA, ACCOUNT_CODE, OTHER_CURRENCY,DETAIL ORDER BY BA
				</cfquery>
			<cfelse>
				<cfquery name="muh_query" dbtype="query">
					SELECT SUM(OTHER_AMOUNT) OTHER_AMOUNT,SUM(AMOUNT) AMOUNT,0 ACC_PROJECT_ID, BA, ACCOUNT_CODE, OTHER_CURRENCY,DETAIL,SUM(QUANTITY) QUANTITY, SUM(PRICE) PRICE FROM muh_query GROUP BY BA, ACCOUNT_CODE, OTHER_CURRENCY,DETAIL ORDER BY BA
				</cfquery>
			</cfif>
		</cfif>

		<cfscript>
			is_ifrs = companyResult.IS_USE_IFRS;

			if(len(arguments.belge_no) and not findnocase(arguments.belge_no,arguments.fis_detay))
				arguments.fis_detay = arguments.belge_no&" No'lu "&arguments.fis_detay;
			for(cnt_i=1;cnt_i lte muh_query.recordcount;cnt_i=cnt_i+1) //borc alacak toplamı bulunup, fiste fark var mı bakılır
			{
				if(muh_query.BA[cnt_i] eq 1)
				{
					alacak_hesaplar_total = alacak_hesaplar_total + wrk_round(muh_query.AMOUNT[cnt_i]);
					if(len(muh_query.OTHER_AMOUNT[cnt_i]))
						other_alacak_hesaplar_total = other_alacak_hesaplar_total + wrk_round(muh_query.OTHER_AMOUNT[cnt_i]);
				}
				else if (muh_query.BA[cnt_i] eq 0)
				{
					borc_hesaplar_total = borc_hesaplar_total + wrk_round(muh_query.AMOUNT[cnt_i]);
					if(len(muh_query.OTHER_AMOUNT[cnt_i]))
						other_borc_hesaplar_total = other_borc_hesaplar_total + wrk_round(muh_query.OTHER_AMOUNT[cnt_i]);
				}
			}

			if(wrk_round(alacak_hesaplar_total) is not wrk_round(borc_hesaplar_total) or wrk_round((alacak_hesaplar_total-borc_hesaplar_total),2) neq 0) // borc-alacak tutmayan fisler icin yuvarlama yapılıyor
			{
				temp_fark = round((alacak_hesaplar_total-borc_hesaplar_total)*100);

				if(temp_fark gte (arguments.max_round_amount*-100) and temp_fark lt 0 and len(arguments.claim_round_account))
				{// fark alacaklilara eklenmeli, borc bakiye gelmis,muhasebeci querysine fark satırı ekleniyor
					muh_query_row = muh_query.recordcount + 1;
					QueryAddRow(muh_query,1);
					QuerySetCell(muh_query,"BA",1,muh_query_row);
					QuerySetCell(muh_query,"ACCOUNT_CODE",claim_round_account,muh_query_row);
					QuerySetCell(muh_query,"AMOUNT",abs(temp_fark/100),muh_query_row);
					QuerySetCell(muh_query,"OTHER_AMOUNT",abs(temp_fark/100),muh_query_row);
					QuerySetCell(muh_query,"OTHER_CURRENCY",system_money,muh_query_row);
					QuerySetCell(muh_query,"DETAIL",arguments.fis_detay,muh_query_row);
					QuerySetCell(muh_query,"ACC_PROJECT_ID",0,muh_query_row);
				}
				else if(temp_fark lte (arguments.max_round_amount*100) and temp_fark gt 0 and len(arguments.dept_round_account))
				{//fark borclulara eklenmeli, alacak bakiye gelmis,muhasebeci querysine fark satırı ekleniyor
					muh_query_row = muh_query.recordcount + 1;
					QueryAddRow(muh_query,1);
					QuerySetCell(muh_query,"BA",0,muh_query_row);
					QuerySetCell(muh_query,"ACCOUNT_CODE",dept_round_account,muh_query_row);
					QuerySetCell(muh_query,"AMOUNT",abs(temp_fark/100),muh_query_row);
					QuerySetCell(muh_query,"OTHER_AMOUNT",abs(temp_fark/100),muh_query_row);
					QuerySetCell(muh_query,"OTHER_CURRENCY",system_money,muh_query_row);
					QuerySetCell(muh_query,"DETAIL",arguments.fis_detay,muh_query_row);
					QuerySetCell(muh_query,"ACC_PROJECT_ID",0,muh_query_row);
				}
				//yuvarlama satırı da eklenlendikten sonra fark olup olmadıgı yeniden kontrol ediliyor
				alacak_hesaplar_total =0;
				borc_hesaplar_total = 0;
				other_alacak_hesaplar_total =0;
				other_borc_hesaplar_total = 0;
				for(cnt_k=1;cnt_k lte muh_query.recordcount;cnt_k=cnt_k+1)
				{
					if(muh_query.BA[cnt_k] eq 1)
					{
						alacak_hesaplar_total = alacak_hesaplar_total + wrk_round(muh_query.AMOUNT[cnt_k]);
						if(len(muh_query.OTHER_AMOUNT[cnt_k]))
							other_alacak_hesaplar_total = other_alacak_hesaplar_total + wrk_round(muh_query.OTHER_AMOUNT[cnt_k]);
					}
					else if (muh_query.BA[cnt_k] eq 0)
					{
						borc_hesaplar_total = borc_hesaplar_total + wrk_round(muh_query.AMOUNT[cnt_k]);
						if(len(muh_query.OTHER_AMOUNT[cnt_k]))
						other_borc_hesaplar_total = other_borc_hesaplar_total + wrk_round(muh_query.OTHER_AMOUNT[cnt_k]);
					}
				}
			}
		</cfscript>
		<cfif wrk_round((alacak_hesaplar_total-borc_hesaplar_total),2) neq 0 or (arguments.workcube_process_type eq 111 and (listlen(arguments.alacak_tutarlar) neq listlen(arguments.alacak_hesaplar) or listlen(arguments.borc_tutarlar) neq listlen(arguments.borc_hesaplar)))>
		<!--- yuvarlama hesabı henuz alerta dahil edilmedi --->
			<cfif workcube_mode>
				<script type="text/javascript">
				var alert_str='Muhasebe Fişi Borç-Alacak Bakiyesi Eşit Değil!';
				<!--- <cfoutput>
					alert_str = alert_str + '\nborc_hesaplar:\n';
					<cfloop from="1" to="#listlen(arguments.borc_hesaplar,',')#" index="i">
						alert_str = alert_str + '<cfoutput>#listgetat(arguments.borc_hesaplar,i,',')#=#TLFormat(listgetat(arguments.borc_tutarlar,i,','))#  <cfif (i mod 4) eq 0>\n<cfelse> ; </cfif></cfoutput>';
					</cfloop>
					alert_str = alert_str + 'borc_hesaplar_total = #TLFormat(borc_hesaplar_total)#\n';
					alert_str = alert_str + '\nalacak_hesaplar:\n';
					<cfloop from="1" to="#listlen(arguments.alacak_hesaplar,',')#" index="i">
						alert_str = alert_str + '<cfoutput>#listgetat(arguments.alacak_hesaplar,i,',')#=#TLFormat(listgetat(arguments.alacak_tutarlar,i,','))#  <cfif (i mod 4) eq 0>\n<cfelse> ; </cfif></cfoutput>';
					</cfloop>
					alert_str = alert_str + 'alacak_hesaplar_total = #TLFormat(alacak_hesaplar_total)#\n\n';
					alert_str = alert_str + 'Fark = #TLFormat(borc_hesaplar_total-alacak_hesaplar_total)# <cfif borc_hesaplar_total gt alacak_hesaplar_total>(B)<cfelse>(A)</cfif>';
				</cfoutput>
					alert(alert_str);
				</script>
				<cfabort> --->
			<cfelse>
				<cfif arguments.workcube_process_type eq 111 and (listlen(arguments.alacak_tutarlar) neq listlen(arguments.alacak_hesaplar) or listlen(arguments.borc_tutarlar) neq listlen(arguments.borc_hesaplar))>

					<!---<script type="text/javascript">
					 <cfoutput>
						alert_str = 'Borç-Alacak Hesaplarında Eksik Tanımlamalar Mevcut!';
					</cfoutput>
						alert(alert_str);
					</script>
					<cfabort>--->
				<cfelse>
					<!--- baskette kur sorunlarına sebep oldugundan acıklama yukardaki gibi degistirildi, bu bölüm sadece development modda calısıyor --->
				   <script type="text/javascript">
					var alert_str='Muhasebe Fişi Borç-Alacak Bakiyesi Eşit Değil!';
					<!--- <cfoutput>
						alert_str = alert_str + '\nborc_hesaplar:\n';
						<cfloop from="1" to="#listlen(arguments.borc_hesaplar,',')#" index="i">
							alert_str = alert_str + '<cfoutput>#listgetat(arguments.borc_hesaplar,i,',')#=#TLFormat(listgetat(arguments.borc_tutarlar,i,','))#  <cfif (i mod 4) eq 0>\n<cfelse> ; </cfif></cfoutput>';
						</cfloop>
						alert_str = alert_str + 'borc_hesaplar_total = #TLFormat(borc_hesaplar_total)#\n';
						alert_str = alert_str + '\nalacak_hesaplar:\n';
						<cfloop from="1" to="#listlen(arguments.alacak_hesaplar,',')#" index="i">
							alert_str = alert_str + '<cfoutput>#listgetat(arguments.alacak_hesaplar,i,',')#=#TLFormat(listgetat(arguments.alacak_tutarlar,i,','))#  <cfif (i mod 4) eq 0>\n<cfelse> ; </cfif></cfoutput>';
						</cfloop>
						alert_str = alert_str + 'alacak_hesaplar_total = #TLFormat(alacak_hesaplar_total)#\n\n';
						alert_str = alert_str + 'Fark = #TLFormat(borc_hesaplar_total-alacak_hesaplar_total)# <cfif borc_hesaplar_total gt alacak_hesaplar_total>(B)<cfelse>(A)</cfif>';
					</cfoutput>
						alert(alert_str);
					</script>
					 <cfabort> --->
				</cfif>
			</cfif>
		</cfif>
		<cfquery name="get_bill_no" datasource="#arguments.muhasebe_db#">SELECT BILL_NO,MAHSUP_BILL_NO,TAHSIL_BILL_NO,TEDIYE_BILL_NO FROM #arguments.muhasebe_db_alias#BILLS</cfquery>
		<cfset bill_no=get_bill_no.BILL_NO>
		<cfif arguments.account_card_type is '11'>
			<cfset card_type_no = get_bill_no.TAHSIL_BILL_NO>
			<cfquery name="upd_bill_no" datasource="#arguments.muhasebe_db#">UPDATE #arguments.muhasebe_db_alias#BILLS SET BILL_NO=#bill_no+1#,TAHSIL_BILL_NO=#card_type_no+1#</cfquery>
		<cfelseif arguments.account_card_type is '12'>
			<cfset card_type_no = get_bill_no.TEDIYE_BILL_NO>
			<cfquery name="upd_bill_no" datasource="#arguments.muhasebe_db#">UPDATE #arguments.muhasebe_db_alias#BILLS SET BILL_NO=#bill_no+1#,TEDIYE_BILL_NO=#card_type_no+1#</cfquery>
		<cfelse>
			<cfset card_type_no = get_bill_no.MAHSUP_BILL_NO>
			<cfquery name="upd_bill_no" datasource="#arguments.muhasebe_db#">UPDATE #arguments.muhasebe_db_alias#BILLS SET BILL_NO=#bill_no+1#,MAHSUP_BILL_NO=#card_type_no+1#</cfquery>
		</cfif>

		<!--- parametre olarak gönderilmişse --->
		<cfif not (len(arguments.document_type) OR len(arguments.payment_method))>
			<!--- edefter kapsaminda islem kategorisine bagli belge tipi ve odeme sekilleri cekiliyor. Masraf gelir fislerinde buradan degil belgeden gelene gore calismasi gerekiyor FA --->
			<cfif len(arguments.workcube_process_cat) and arguments.workcube_process_cat neq 0>
				<cfquery name="getProcessCatInfo" datasource="#arguments.muhasebe_db#">
					SELECT
						DOCUMENT_TYPE,
						PAYMENT_TYPE
					FROM
						<cfif isdefined('dsn3_alias')>#dsn3_alias#<cfelse>#caller.dsn3_alias#</cfif>.SETUP_PROCESS_CAT
					WHERE
						PROCESS_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.workcube_process_cat#">
				</cfquery>
			<cfelseif len(arguments.workcube_process_type)>
				<cfquery name="getProcessCatInfo" datasource="#arguments.muhasebe_db#">
					SELECT TOP 1
						DOCUMENT_TYPE,
						PAYMENT_TYPE
					FROM
						<cfif isdefined('dsn3_alias')>#dsn3_alias#<cfelse>#caller.dsn3_alias#</cfif>.SETUP_PROCESS_CAT
					WHERE
						PROCESS_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.workcube_process_type#">
				</cfquery>
			</cfif>
		</cfif>

		<cfquery name="ADD_ACCOUNT_CARD" datasource="#arguments.muhasebe_db#">
			INSERT INTO
				#arguments.muhasebe_db_alias#ACCOUNT_CARD
				(
				<cfif len(arguments.wrk_id)>
					WRK_ID,
				</cfif>
					ACTION_ID,
					IS_ACCOUNT,
					BILL_NO,
					CARD_DETAIL,
					CARD_TYPE,
					CARD_CAT_ID,
					CARD_TYPE_NO,
					ACTION_TYPE,
					ACTION_CAT_ID,
					ACTION_DATE,
				<cfif isdefined('arguments.action_table') and len(arguments.action_table)>
					ACTION_TABLE,
				</cfif>
				<cfif len(arguments.belge_no)>
					PAPER_NO,
				</cfif>
				<cfif len(arguments.company_id)>
					ACC_COMPANY_ID,
				<cfelseif len(arguments.consumer_id)>
					ACC_CONSUMER_ID,
				<cfelseif len(arguments.employee_id)>
					ACC_EMPLOYEE_ID,
				</cfif>
					IS_OTHER_CURRENCY,
					RECORD_EMP,
					RECORD_IP,
					RECORD_DATE,
					IS_CANCEL,
					ACTION_ROW_ID,
					DUE_DATE,
					CARD_DOCUMENT_TYPE,
					CARD_PAYMENT_METHOD
				)
			VALUES
				(
				<cfif len(arguments.wrk_id)>
					'#arguments.wrk_id#',
				</cfif>
					#arguments.action_id#,
					1,
					#bill_no#,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#LEFT(arguments.fis_detay,150)#">,
					#arguments.account_card_type#,
					#account_card_catid#,
					#card_type_no#,
					#arguments.workcube_process_type#,
				<cfif len(arguments.workcube_process_cat)>#arguments.workcube_process_cat#<cfelse>NULL</cfif>,
					#CreateODBCDate(arguments.islem_tarihi)#,
				<cfif isdefined('arguments.action_table') and len(arguments.action_table)>
					'#arguments.action_table#',
				</cfif>
				<cfif len(arguments.belge_no)>
					'#arguments.belge_no#',
				</cfif>
				<cfif len(arguments.company_id)>
					#arguments.company_id#,
				<cfelseif len(arguments.consumer_id)>
					#arguments.consumer_id#,
				<cfelseif len(arguments.employee_id)>
					#arguments.employee_id#,
				</cfif>
				1,
				#record_emp#,
				'#CGI.REMOTE_ADDR#',
				#now()#,
				<cfif isdefined('arguments.is_cancel') and len(arguments.is_cancel)>#arguments.is_cancel#,<cfelse>0,</cfif>
				<cfif len(arguments.action_row_id)>#arguments.action_row_id#<cfelse>NULL</cfif>,
				<cfif len(arguments.due_date)>#arguments.due_date#<cfelse>NULL</cfif>,
				<!--- belge tipi --->
				<cfif len(arguments.document_type) OR len(arguments.payment_method)>
					<cfif len(arguments.document_type)>
						#arguments.document_type#
					<cfelse>
						NULL
					</cfif>
				<cfelseif isdefined('getProcessCatInfo.DOCUMENT_TYPE') and len(getProcessCatInfo.DOCUMENT_TYPE)>
					#getProcessCatInfo.DOCUMENT_TYPE#
				<cfelse>
					NULL
				</cfif>,
				<!--- odeme sekli --->
				<cfif len(arguments.document_type) OR len(arguments.payment_method)>
					<cfif len(arguments.payment_method)>
						#arguments.payment_method#
					<cfelse>
						NULL
					</cfif>
				<cfelseif isdefined('getProcessCatInfo.PAYMENT_TYPE') and len(getProcessCatInfo.PAYMENT_TYPE)>
					#getProcessCatInfo.PAYMENT_TYPE#
				<cfelse>
					NULL
				</cfif>
				)
		</cfquery>
		<cfquery name="GET_MAX_ACCOUNT_CARD_ID" datasource="#arguments.muhasebe_db#">
			SELECT
				MAX(CARD_ID) AS MAX_ID
			FROM
				#arguments.muhasebe_db_alias#ACCOUNT_CARD
			WHERE
				1=1
				<cfif len(arguments.wrk_id)>
					AND WRK_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.wrk_id#">
				</cfif>
				<cfif len(arguments.action_id)>
					AND ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.action_id#">
				</cfif>
				<cfif len(arguments.workcube_process_type)>
					AND ACTION_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.workcube_process_type#">
				</cfif>
		</cfquery>
		<cfif is_ifrs eq 1> <!--- sirket parametrelerinde ifrs_code kullan secilmisse hesapların ifrs ve özel kodları alınıyor --->
			<cfset acc_list_for_ifrs = listsort(listdeleteduplicates(valuelist(muh_query.ACCOUNT_CODE)),'text','asc')>
			<cfif listlen(acc_list_for_ifrs)>
				<cfquery name="GET_IFRS_CODE" datasource="#arguments.muhasebe_db#">
					SELECT ACCOUNT_CODE,IFRS_CODE,ACCOUNT_CODE2 FROM #arguments.muhasebe_db_alias#ACCOUNT_PLAN WHERE ACCOUNT_CODE IN (#listqualify(acc_list_for_ifrs,"'")#) ORDER BY ACCOUNT_CODE
				</cfquery>
			 </cfif>
		</cfif>
		<cfloop query="muh_query">
			<cfset action_value2 = (wrk_round(muh_query.AMOUNT)/arguments.currency_multiplier)>
			<cfif wrk_round(muh_query.AMOUNT,2) neq 0 or wrk_round(muh_query.OTHER_AMOUNT,2) neq 0>
				<cfquery name="ADD_FIS_ROW" datasource="#arguments.muhasebe_db#">
					INSERT INTO
						#arguments.muhasebe_db_alias#ACCOUNT_CARD_ROWS
						(
							CARD_ID,
							ACCOUNT_ID,
						<cfif is_ifrs eq 1>
							IFRS_CODE,
							ACCOUNT_CODE2,
						</cfif>
							DETAIL,
							BA,
							AMOUNT,
							AMOUNT_CURRENCY,
							AMOUNT_2,
							AMOUNT_CURRENCY_2,
							OTHER_CURRENCY,
							OTHER_AMOUNT,
							QUANTITY,
							PRICE,
							ACC_DEPARTMENT_ID,
							ACC_BRANCH_ID,
							ACC_PROJECT_ID
						)
					VALUES
						(
							#GET_MAX_ACCOUNT_CARD_ID.MAX_ID#,
							'#muh_query.ACCOUNT_CODE#',
						<cfif is_ifrs eq 1>
							<cfif len(GET_IFRS_CODE.IFRS_CODE[listfind(acc_list_for_ifrs,muh_query.ACCOUNT_CODE)])>'#GET_IFRS_CODE.IFRS_CODE[listfind(acc_list_for_ifrs,muh_query.ACCOUNT_CODE)]#',<cfelse>NULL,</cfif>
							<cfif len(GET_IFRS_CODE.ACCOUNT_CODE2[listfind(acc_list_for_ifrs,muh_query.ACCOUNT_CODE)])>'#GET_IFRS_CODE.ACCOUNT_CODE2[listfind(acc_list_for_ifrs,muh_query.ACCOUNT_CODE)]#',<cfelse>NULL,</cfif>
						</cfif>
							#sql_unicode()#'#left(muh_query.DETAIL,500)#',
							#muh_query.BA#,
							#wrk_round(muh_query.AMOUNT,2)#,
							'#arguments.action_currency#'
						<cfif len(arguments.currency_multiplier)>
							,#wrk_round(action_value2,2)#
							,'#arguments.action_currency_2#'
						<cfelse>
							,NULL
							,NULL
						</cfif>
						<cfif len(muh_query.OTHER_CURRENCY) and len(muh_query.OTHER_AMOUNT)>
							,'#muh_query.OTHER_CURRENCY#'
							,#wrk_round(muh_query.OTHER_AMOUNT,2)#
						<cfelse>
							,'#arguments.action_currency#'
							,#wrk_round(muh_query.AMOUNT,2)#
						</cfif>
						<cfif len(muh_query.QUANTITY)>,#muh_query.QUANTITY#<cfelse>,NULL</cfif>
						<cfif len(muh_query.PRICE)>,#muh_query.PRICE#<cfelse>,NULL</cfif>
						<cfif isdefined('arguments.acc_department_id') and len(arguments.acc_department_id)>
							,#arguments.acc_department_id#
						<cfelse>
							,NULL
						</cfif>
						<cfif isdefined("muh_query.ACC_BRANCH_ID") and len(muh_query.ACC_BRANCH_ID) and muh_query.ACC_BRANCH_ID gt 0>
							,#muh_query.ACC_BRANCH_ID#
						<cfelse>
							<cfif isdefined('arguments.from_branch_id') and len(arguments.from_branch_id) and not (isdefined('arguments.to_branch_id') and len(arguments.to_branch_id))>
							<!--- sadece from_branch_id gönderildiyse --->
								,#arguments.from_branch_id#
							<cfelseif isdefined('arguments.to_branch_id') and len(arguments.to_branch_id) and not (isdefined('arguments.from_branch_id') and len(arguments.from_branch_id))>
							<!--- sadece to_branch_id gönderildiyse --->
								,#arguments.to_branch_id#
							<cfelse>
								<cfif muh_query.BA eq 1>
									<cfif isdefined('arguments.from_branch_id') and len(arguments.from_branch_id)>
										,#arguments.from_branch_id#
									<cfelse>
										,NULL
									</cfif>
								<cfelse>
									<cfif isdefined('arguments.to_branch_id') and len(arguments.to_branch_id)>
										,#arguments.to_branch_id#
									<cfelse>
										,NULL
									</cfif>
								</cfif>
							</cfif>
						</cfif>
						<cfif isdefined("muh_query.ACC_PROJECT_ID") and len(muh_query.ACC_PROJECT_ID) and muh_query.ACC_PROJECT_ID gt 0>
							,#muh_query.ACC_PROJECT_ID#
						<cfelse>
							<cfif isdefined('arguments.acc_project_id') and len(arguments.acc_project_id) and arguments.acc_project_id neq 0>
								,#arguments.acc_project_id#
							<cfelse>
								,NULL
							</cfif>
						</cfif>
						)
				</cfquery>
			</cfif>
		</cfloop>
		<cfquery name="ADD_LOG" datasource="#arguments.muhasebe_db#">
			INSERT INTO
				#dsn_alias#.WRK_LOG
			(
				PROCESS_TYPE,
				EMPLOYEE_ID,
				LOG_TYPE,
				LOG_DATE,
				<cfif len(arguments.belge_no)>
				PAPER_NO,
				</cfif>
				FUSEACTION,
				ACTION_ID,
				ACTION_NAME,
				PERIOD_ID
			)
			VALUES
			(
				#arguments.account_card_type#,
				#record_emp#,
				<cfif isDefined('arguments.workcube_old_process_type') and len(arguments.workcube_old_process_type)>0<cfelse>1</cfif>,
				#now()#,
				<cfif len(arguments.belge_no)>
						'#arguments.belge_no#',
				</cfif>
				<cfif isdefined("fusebox.circuit") and isdefined("fusebox.fuseaction")>
					'#fusebox.circuit#.#fusebox.fuseaction#',
				<cfelseif isdefined("caller.fusebox.circuit") and isdefined("caller.fusebox.fuseaction")>
					'#caller.fusebox.circuit#.#caller.fusebox.fuseaction#',
				<cfelseif isdefined("caller.caller.fusebox.circuit") and isdefined("caller.caller.fusebox.fuseaction")>
					'#caller.caller.fusebox.circuit#.#caller.caller.fusebox.fuseaction#',
				</cfif>
				#GET_MAX_ACCOUNT_CARD_ID.MAX_ID#,
				'#left(bill_no,250)#',
				#period_id#
			)
		</cfquery>
		<cfcatch>
			<cfdump var="#cfcatch#" abort="true" />
		</cfcatch>
		</cftry>
		<cfreturn GET_MAX_ACCOUNT_CARD_ID.MAX_ID>
	</cffunction>

	<cffunction name="wodiba_butceci" access="private" returntype="void" output="false" hint="Bütçe işlemi yapar, masraf fişinden gönderildiğinde expense_id dolu gönderilmelidir.">
		<!---
		wodiba_butceci (
				muhasebe_db:dsn2,
				expense_id:
				expense_date:attributes.INVOICE_DATE
				expense_center_id:
				expense_item_id:
				expense_account_code:
				process_type:INVOICE_CAT,
				detail:
				is_income_expense: 'false', <!---true:gelir , false:gider--->
				action_id: bank_action_id,
				amount: amount,
				paper_no:
				project_id: projeye gore dagilim yapacaksa yollanmali,
				record_emp: record_emp,
				branch_id:
				asset_id:
			);
		--->
		<cfargument name="muhasebe_db" type="string" required="false" default="#dsn2#" displayname="Muhasebe dönemi DB" hint="Muhasebe dönemi DB" />
		<cfargument name="expense_id" type="numeric" required="false" default="0" displayname="Masraf fişi ID" hint="Masraf fişinden çağrıldığında bu alan dolu gönderilmelidir." />
		<cfargument name="expense_date" type="date" required="false" default="#now()#" displayname="İşlem Tarihi" hint="İşlem Tarihi" />
		<cfargument name="expense_center_id" type="numeric" required="true" /><!--- masraf/gelir merkezi --->
		<cfargument name="expense_item_id" type="numeric" required="true" /><!--- bütçe kalemi --->
		<cfargument name="expense_account_code" type="string" required="true" /><!--- muhasebe kodu --->
		<cfargument name="process_type" type="numeric" required="yes"><!---INVOICE_CAT--->
		<cfargument name="detail" type="string" required="false" default="" />
		<cfargument name="is_income_expense" type="boolean" required="true" /><!---true:gelir , false:gider --->
		<cfargument name="action_id" type="numeric" required="yes" />
		<cfargument name="amount" type="any" required="true" hint="Tutarlar structure ile gönderilmelidir" />
		<cfargument name="paper_no" type="string" required="false" default="" />
		<cfargument name="project_id" type="numeric" required="false" default="0" />
		<cfargument name="branch_id" type="numeric" required="false" default="0" />
		<cfargument name="record_emp" type="numeric" required="true" />
		<cfargument name="asset_id" type="numeric" required="true" />

		<cfset amount = arguments.amount />

		<cftry>
		<cfquery name="ADD_EXPENSE" datasource="#arguments.muhasebe_db#">
			INSERT INTO
				EXPENSE_ITEMS_ROWS
			(
				EXPENSE_ID,
				EXPENSE_DATE,
				EXPENSE_CENTER_ID,
				EXPENSE_ITEM_ID,
				EXPENSE_ACCOUNT_CODE,
				EXPENSE_COST_TYPE,
				PYSCHICAL_ASSET_ID,
				PROJECT_ID,
				DETAIL,
				IS_INCOME,
				ACTION_ID,
				AMOUNT,
				AMOUNT_KDV,
				MONEY_CURRENCY_ID,
				TOTAL_AMOUNT,
				KDV_RATE,
				OTHER_MONEY_VALUE,
				OTHER_MONEY_VALUE_2,
				MONEY_CURRENCY_ID_2,
				OTHER_MONEY_GROSS_TOTAL,
				OTV_RATE,
				AMOUNT_OTV,
				ROW_PAPER_NO,
				QUANTITY,
				BRANCH_ID,
				RECORD_IP,
				RECORD_EMP,
				RECORD_DATE
			)
				VALUES
			(
				#arguments.expense_id#,
				#arguments.expense_date#,
				#arguments.expense_center_id#,
				#arguments.expense_item_id#,
				<cfif isDefined("arguments.expense_account_code") and Len(arguments.expense_account_code)>'#arguments.expense_account_code#'<cfelse>NULL</cfif>,
				#arguments.process_type#,
				<cfif Len(asset_id) And asset_id Neq 0>#asset_id#<cfelse>NULL</cfif>,
				<cfif isDefined("arguments.project_id") and arguments.project_id Neq 0>#arguments.project_id#<cfelse>NULL</cfif>,
				#sql_unicode()#'#arguments.detail#',
				<cfif arguments.is_income_expense>1<cfelse>0</cfif>,
				#arguments.action_id#,
				#wrk_round(amount.system_action_value_tax_free)#,--AMOUNT
				#wrk_round(amount.tax_value)#,--AMOUNT_KDV
				'#amount.action_currency_id#',--MONEY_CURRENCY_ID
				#wrk_round(amount.system_action_value)#,--TOTAL_AMOUNT
				#amount.tax#,--KDV_RATE
				#wrk_round(amount.action_value_tax_free)#,--OTHER_MONEY_VALUE
				#wrk_round(amount.system_action_value_2)#,--OTHER_MONEY_VALUE_2
				'#amount.system_currency_id_2#',--MONEY_CURRENCY_ID_2
				#wrk_round(amount.action_value)#,--OTHER_MONEY_GROSS_TOTAL
				0,--OTV_RATE
				0,--AMOUNT_OTV
				<cfif isDefined("arguments.paper_no") and len(arguments.paper_no)>'#arguments.paper_no#'<cfelse>NULL</cfif>,
				1,
				<cfif len(arguments.branch_id) And arguments.branch_id Neq 0>#arguments.branch_id#<cfelse>NULL</cfif>,
				'#CGI.REMOTE_ADDR#',
				#arguments.record_emp#,
				#Now()#
			)
		</cfquery>
		<cfcatch>
			<cfdump var="#cfcatch#" abort="true" />
		</cfcatch>
		</cftry>
	</cffunction>
	
	<cffunction name="AddInvoiceClose" access="public" returntype="void" output="true"  hint="Fatura kapama işlemi">
		<cfargument name="process_stage" type="numeric" required="false" default="" />
		<cfargument name="company_id" type="numeric" required="true" />
		<cfargument name="consumer_id" type="numeric" required="true" />
		<cfargument name="other_money" type="string" required="true" />
		<cfargument name="difference_amount_value" type="numeric" required="true" />
		<cfargument name="debt_action_type_id" type="numeric" required="true" />
		<cfargument name="debt_action_value" type="numeric" required="true" />
		<cfargument name="debt_action_id" type="numeric" required="true" />
		<cfargument name="claim_action_type_id" type="numeric" required="true" />
		<cfargument name="claim_action_value" type="numeric" required="true" />
		<cfargument name="claim_action_id" type="numeric" required="true" />
		<cfargument name="closed_amount" type="numeric" required="true" />
		<cfargument name="other_closed_amount" type="numeric" required="true" />
		<cfargument name="record_emp" type="numeric" required="true" />


		<cfquery name="ADD_COMPANY_CLOSED" datasource="#dsn2#" result ="cariClosed">
			INSERT INTO 
					CARI_CLOSED
				(	
					PROCESS_STAGE,
					COMPANY_ID,
					CONSUMER_ID,
					OTHER_MONEY,
					IS_CLOSED,
					DEBT_AMOUNT_VALUE,
					CLAIM_AMOUNT_VALUE,
					DIFFERENCE_AMOUNT_VALUE,
					PAPER_ACTION_DATE,
					PAPER_DUE_DATE,
					RECORD_DATE,
					RECORD_IP,
					RECORD_EMP
				)
				VALUES
				(
					#arguments.process_stage#,
					<cfif arguments.company_id Gt 0>#arguments.company_id#<cfelse>NULL</cfif>,
					<cfif arguments.consumer_id Gt 0>#arguments.consumer_id#<cfelse>NULL</cfif>,
					'#arguments.other_money#',
					1,
					#arguments.debt_action_value#,
					#arguments.claim_action_value#,
					#arguments.difference_amount_value#,
					#Now()#,
					#Now()#,
					#Now()#,
					'#cgi.remote_addr#',
					#arguments.record_emp#
				)
			</cfquery>

			<cfscript>
				cariQuery = new Query();
				cariQuery.setDatasource("#dsn2#");
				cariQuery.setSQL("SELECT CARI_ACTION_ID,DUE_DATE 
									FROM CARI_ROWS 
								   WHERE ACTION_ID = #arguments.debt_action_id# 
									 AND ACTION_TYPE_ID=#arguments.debt_action_type_id#");
				cariResult = cariQuery.execute();
				cariResult = cariResult.getResult();
			</cfscript>
			
			<cfquery name="ADD_COMPANY_CLOSED_ROW_DEBT" datasource="#dsn2#" result ="cariClosedRowDebt">
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
					OTHER_MONEY,
					DUE_DATE
				)
				VALUES
				(
					#cariClosed.GENERATEDKEY#,
					#cariResult.CARI_ACTION_ID#,
					#arguments.debt_action_id#,		
					#arguments.debt_action_type_id#,	
					#arguments.debt_action_value#,
					#closed_amount#,		
					#other_closed_amount#,
					'#arguments.other_money#',   	
					'#cariResult.DUE_DATE#'
				)
			</cfquery>

			<cfscript>
				cariQuery = new Query();
				cariQuery.setDatasource("#dsn2#");
				cariQuery.setSQL("SELECT CARI_ACTION_ID 
									FROM CARI_ROWS 
								   WHERE ACTION_ID = #arguments.claim_action_id# 
									 AND ACTION_TYPE_ID=#arguments.claim_action_type_id#");
				cariResult = cariQuery.execute();
				cariResult = cariResult.getResult();
			</cfscript>

			<cfquery name="ADD_COMPANY_CLOSED_ROW_CLAIM" datasource="#dsn2#" result ="cariClosedRowClaim">
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
					OTHER_MONEY,
					DUE_DATE
				)
				VALUES
				(
					#cariClosed.GENERATEDKEY#,
					#cariResult.CARI_ACTION_ID#,
					#arguments.claim_action_id#,
					#arguments.claim_action_type_id#,
					#arguments.claim_action_value#,
					#closed_amount#,		
					#other_closed_amount#,
					'#arguments.other_money#',
					#Now()#
				)
			</cfquery>
	</cffunction>

</cfcomponent>