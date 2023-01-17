<cf_date tarih = "attributes.act_date">
<cfquery name="get_process_type" datasource="#dsn3#">
	SELECT 
		PROCESS_TYPE,
		IS_ACCOUNT,
		IS_ACCOUNT_GROUP,
		ACTION_FILE_NAME,
		ACTION_FILE_FROM_TEMPLATE
	 FROM 
	 	SETUP_PROCESS_CAT 
	WHERE 
		PROCESS_CAT_ID = #form.process_cat#
</cfquery>
<cfif not isdefined("is_collacted")><!--- Toplu işlemlerde databaseden geliyor filternuma gerek yok --->
	<cfloop from="1" to="#attributes.kur_say#" index="ii">
		<cfscript>
			'attributes.txt_rate2_#ii#' = filterNum(evaluate('attributes.txt_rate2_#ii#'),session.ep.our_company_info.rate_round_num);
			'attributes.txt_rate1_#ii#' = filterNum(evaluate('attributes.txt_rate1_#ii#'),session.ep.our_company_info.rate_round_num);
		</cfscript>
	</cfloop>
</cfif>
<cfscript>
	process_type = get_process_type.process_type;
	is_account = get_process_type.is_account;
	is_account_group = get_process_type.IS_ACCOUNT_GROUP;
	rd_money_value = listfirst(attributes.rd_money, ';');
	currency_multiplier = '';
	currency_multiplier_2 = '';
	if(isDefined('attributes.kur_say') and len(attributes.kur_say))
	{
		for(mon=1;mon lte attributes.kur_say;mon=mon+1)
		{
			if(evaluate("attributes.hidden_rd_money_#mon#") is rd_money_value)
				currency_multiplier = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
			if(evaluate("attributes.hidden_rd_money_#mon#") is session.ep.money2)
				currency_multiplier_2 = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
		}
	}
</cfscript>
<cflock name="#createUUID()#" timeout="60">
	<cftransaction>
		<cfquery name="GET_VOUCHER" datasource="#dsn2#">
			SELECT 
				VOUCHER_STATUS_ID,
				VOUCHER_VALUE,
				VOUCHER.CURRENCY_ID,
				VOUCHER_PURSE_NO,
				OTHER_MONEY,
				OTHER_MONEY_VALUE,
				OTHER_MONEY2,
				OTHER_MONEY_VALUE2,
				VOUCHER_DUEDATE,
				ACCOUNT_CODE,
				VOUCHER_PAYROLL_ID,
				CASH_ID,
				VOUCHER_PAYROLL.PROJECT_ID,
                VOUCHER_NO
			FROM
				VOUCHER
                	LEFT JOIN VOUCHER_PAYROLL ON VOUCHER_PAYROLL.ACTION_ID = VOUCHER.VOUCHER_PAYROLL_ID
			WHERE
				VOUCHER_ID=#attributes.voucher_id# AND
				VOUCHER_STATUS_ID=6
		</cfquery>
		<cfquery name="CHANGE_STATUS" datasource="#dsn2#">
			UPDATE VOUCHER SET VOUCHER_STATUS_ID=7 WHERE VOUCHER_ID=#attributes.voucher_id#
		</cfquery>
		<cfquery name="GET_VOUCHER_HISTORY_PORT" datasource="#dsn2#" maxrows="1">
			SELECT PAYROLL_ID,OTHER_MONEY_VALUE2 FROM VOUCHER_HISTORY WHERE VOUCHER_ID=#attributes.voucher_id# AND STATUS=6 ORDER BY HISTORY_ID DESC
		</cfquery>
		<cfif get_voucher_history_port.recordcount>		
			<cfquery name="GET_PAYROLL_PORT" datasource="#dsn2#">
				SELECT PROCESS_CAT,PAYROLL_TYPE FROM VOUCHER_PAYROLL WHERE ACTION_ID=#GET_VOUCHER_HISTORY_PORT.PAYROLL_ID#
			</cfquery>
            <cfif not (isdefined("attributes.system_currency_value2") and len(attributes.system_currency_value2))>
            	<cfset attributes.system_currency_value2 = get_voucher_history_port.other_money_value2>
            </cfif>
			<cfif len(get_payroll_port.process_cat) or len(get_payroll_port.payroll_type)>
				<cfquery name="get_process_type1" datasource="#dsn2#">
					SELECT 
						IS_CHEQUE_BASED_ACTION,
						IS_UPD_CARI_ROW
					 FROM 
						#dsn3_alias#.SETUP_PROCESS_CAT 
					WHERE 
					<cfif len(get_payroll_port.process_cat)>
						PROCESS_CAT_ID = #get_payroll_port.process_cat#
					<cfelse><!--- devirden oluşan bordrolarn process_cat ı olmadığı için,type dan bakıyorz --->
						PROCESS_TYPE = #get_payroll_port.payroll_type#
					</cfif>
				</cfquery>
				<cfif get_process_type1.IS_CHEQUE_BASED_ACTION eq 1 and get_process_type1.IS_UPD_CARI_ROW eq 1>
					<cfquery name="UPD_CHEQUE" datasource="#dsn2#">
						UPDATE
							CARI_ROWS
						SET
							OTHER_MONEY = '#rd_money_value#',
							RATE2=#currency_multiplier#,
							<cfif isdefined("attributes.system_currency_value") and len(attributes.system_currency_value)>OTHER_CASH_ACT_VALUE = #wrk_round(attributes.system_currency_value/currency_multiplier)#,</cfif>
							<cfif len(session.ep.money2)>ACTION_CURRENCY_2 = '#session.ep.money2#',</cfif>
							<cfif isdefined("attributes.system_currency_value") and len(attributes.system_currency_value) and len(currency_multiplier_2)>ACTION_VALUE_2 = #wrk_round(attributes.system_currency_value/currency_multiplier_2)#,</cfif>					
							ACTION_ID = #attributes.voucher_id#
						WHERE
							ACTION_ID = #attributes.voucher_id# AND
							ACTION_TYPE_ID IN (98,107) AND
							ACTION_TABLE = 'VOUCHER'
					</cfquery>
				</cfif>
			</cfif>
		</cfif>
		<cfquery name="ADD_VOUCHER_HISTORY" datasource="#dsn2#" result="MAX_ID">
			INSERT INTO
				VOUCHER_HISTORY
				(
					VOUCHER_ID,
					STATUS,
					ACT_DATE,
					OTHER_MONEY,
					OTHER_MONEY_VALUE,
					OTHER_MONEY2,
					OTHER_MONEY_VALUE2,
					RECORD_DATE,
					SYSTEM_VALUE_DIFF,
					SYSTEM_MONEY_DIFF,
					SYSTEM_VALUE_DIFF2,
					SYSTEM_MONEY_DIFF2,
					OTHER_MONEY_VALUE_DIFF,
					OTHER_MONEY_DIFF,
					DETAIL
				)
				VALUES
				(
					#attributes.voucher_id#,
					7,
					#attributes.act_date#,
					'#session.ep.money#',
					<cfif isdefined("attributes.system_currency_value") and len(attributes.system_currency_value)>#attributes.system_currency_value#,<cfelse>NULL,</cfif>
					<cfif len(session.ep.money2)>'#session.ep.money2#',<cfelse>NULL,</cfif>
					<cfif isdefined("attributes.system_currency_value2") and len(attributes.system_currency_value2)>#attributes.system_currency_value2#,<cfelse>NULL,</cfif>
					#now()#,
					#attributes.system_currency_value_diff#,
					'#session.ep.money#',
					#attributes.system_currency_value_diff2#,
					'#session.ep.money2#',
					#attributes.other_currency_value_diff#,
					'#attributes.other_money#',
					<cfif isDefined("attributes.DETAIL") and len(attributes.DETAIL)>'#DETAIL#'<cfelse>NULL</cfif>
				)
		</cfquery>
		<cfloop from="1" to="#attributes.kur_say#" index="i">
			<cfquery name="ADD_MONEY_INFO" datasource="#dsn2#">
				INSERT INTO VOUCHER_HISTORY_MONEY 
				(
					ACTION_ID,
					MONEY_TYPE,
					RATE2,
					RATE1,
					IS_SELECTED
				)
				VALUES
				(
					#MAX_ID.IDENTITYCOL#,
					'#wrk_eval("attributes.hidden_rd_money_#i#")#',
					#evaluate("attributes.txt_rate2_#i#")#,
					#evaluate("attributes.txt_rate1_#i#")#,
					<cfif evaluate("attributes.hidden_rd_money_#i#") is rd_money_value>1<cfelse>0</cfif>
				)
			</cfquery>
		</cfloop>
		<cfquery name="GET_VOUCHER_HISTORY" datasource="#dsn2#" maxrows="1">
			SELECT PAYROLL_ID FROM VOUCHER_HISTORY WHERE VOUCHER_ID=#attributes.voucher_id# AND STATUS=6 ORDER BY HISTORY_ID DESC
		</cfquery>
		<cfquery name="GET_PAYROLL" datasource="#dsn2#">
			SELECT PAYROLL_CASH_ID FROM VOUCHER_PAYROLL WHERE ACTION_ID=#GET_VOUCHER_HISTORY.PAYROLL_ID#
		</cfquery>
		<cfif get_payroll.recordcount>
			<cfif not len(get_payroll.payroll_cash_id)><cfset get_payroll.payroll_cash_id = get_voucher.cash_id></cfif>
			<cfquery name="GET_ACCOUNT_CODE" datasource="#dsn2#">
				SELECT
					CASH_ACC_CODE,
					V_VOUCHER_ACC_CODE
				FROM
					CASH
				WHERE
					CASH_ID=#get_payroll.payroll_cash_id#
			</cfquery>			
			<cfif process_type eq 1054>
				<cfif get_payroll.recordcount and len(get_payroll.payroll_cash_id)>
                	<cfquery name="get_last_hist" datasource="#dsn2#">
						SELECT
							OTHER_MONEY,
							OTHER_MONEY_VALUE,
							OTHER_MONEY2,
							OTHER_MONEY_VALUE2
						FROM
							VOUCHER_HISTORY
						WHERE
							HISTORY_ID = #MAX_ID.IDENTITYCOL#
					</cfquery>
					<cfquery name="ADD_CASH_ACTION" datasource="#dsn2#">
						INSERT INTO
							CASH_ACTIONS
							(
								ACTION_TYPE,
								ACTION_TYPE_ID,
								CASH_ACTION_VALUE,
								ACTION_DATE,
								CASH_ACTION_FROM_CASH_ID,
								CASH_ACTION_CURRENCY_ID,
								ACTION_DETAIL,
								VOUCHER_ID,
								IS_ACCOUNT,
								IS_ACCOUNT_TYPE,
								RECORD_DATE,
								RECORD_EMP,
								ACTION_VALUE,
								ACTION_CURRENCY_ID
								<cfif len(session.ep.money2)>
									,ACTION_VALUE_2
									,ACTION_CURRENCY_ID_2
								</cfif>
							)
							VALUES
							(
								'SENET ÖDEMESİ',
								#process_type#,
								#GET_VOUCHER.VOUCHER_VALUE#,
								#attributes.act_date#,
								#get_payroll.payroll_cash_id#,
								'#GET_VOUCHER.CURRENCY_ID#',
								'#GET_VOUCHER.VOUCHER_PURSE_NO# PORTFOY NOLU CIRO EDILMIS SENEDIN ODENMESI',
								#attributes.voucher_id#,
								<cfif is_account eq 1>
									1,
									13,
								<cfelse>
									0,
									13,
								</cfif>
								#now()#,
								#session.ep.userid#,
								#get_last_hist.OTHER_MONEY_VALUE#,
								'#session.ep.money#'
								<cfif len(session.ep.money2)>
									,#get_last_hist.OTHER_MONEY_VALUE2#
									,'#session.ep.money2#'
								</cfif>
							)
					</cfquery>
					
					<cfquery name="GET_LAST_RECORD" datasource="#dsn2#">
						SELECT MAX(ACTION_ID) AS ACTION_ID FROM CASH_ACTIONS
					</cfquery>
					
					<cfscript>
						if(is_account eq 1)
						{
							if(isDefined("attributes.detail") and len(attributes.detail))
								satir_detay_list[2][1] = ' #GET_VOUCHER.VOUCHER_PURSE_NO# - #attributes.voucher_no# - #attributes.detail#';
							else
								satir_detay_list[2][1] = ' #GET_VOUCHER.VOUCHER_PURSE_NO# - #attributes.voucher_no# - SENET ÖDEME İŞLEMİ KASADAN';
						
						
							if(isDefined("attributes.detail") and len(attributes.detail))
								satir_detay_list[1][1] = ' #GET_VOUCHER.VOUCHER_PURSE_NO# - #attributes.voucher_no# - #attributes.detail#';
							else
								satir_detay_list[1][1] = ' #GET_VOUCHER.VOUCHER_PURSE_NO# - #attributes.voucher_no# - SENET ÖDEME İŞLEMİ KASADAN';
								
							if(isDefined("GET_VOUCHER.project_id") and len(GET_VOUCHER.project_id))
								project_id_ = GET_VOUCHER.project_id;
							else
								project_id_ = '';
								
							if(session.ep.our_company_info.is_edefter eq 1)
								due_date_ = createODBCdatetime(GET_VOUCHER.VOUCHER_DUEDATE);
							else
								due_date_ = '';
							
							muhasebeci (
								action_id:GET_LAST_RECORD.ACTION_ID,
								workcube_process_type:process_type,
								account_card_type:13,
								islem_tarihi: attributes.act_date,
								borc_hesaplar:GET_ACCOUNT_CODE.V_VOUCHER_ACC_CODE,
								borc_tutarlar:get_last_hist.OTHER_MONEY_VALUE,
								other_amount_borc:GET_VOUCHER.VOUCHER_VALUE,
								other_currency_borc:GET_VOUCHER.CURRENCY_ID,
								alacak_hesaplar:GET_ACCOUNT_CODE.CASH_ACC_CODE,
								alacak_tutarlar:get_last_hist.OTHER_MONEY_VALUE,
								other_amount_alacak:GET_VOUCHER.VOUCHER_VALUE,
								other_currency_alacak:GET_VOUCHER.CURRENCY_ID,
								currency_multiplier : currency_multiplier_2,
								from_branch_id : listgetat(session.ep.user_location,2,'-'),
								fis_detay:iif((isdefined("attributes.detail") and len(attributes.detail)),'attributes.detail',de(' #GET_VOUCHER.VOUCHER_PURSE_NO# - SENET KASADAN ÖDEME')),
								fis_satir_detay:satir_detay_list,
								is_account_group : is_account_group,
								acc_project_id : project_id_,
								belge_no : GET_VOUCHER.VOUCHER_NO,
								due_date : due_date_
							);
						}
					</cfscript>
				</cfif>
			<cfelse>
            	<cfquery name="get_last_hist" datasource="#dsn2#">
					SELECT
						OTHER_MONEY,
						OTHER_MONEY_VALUE,
						OTHER_MONEY2,
						OTHER_MONEY_VALUE2
					FROM
						VOUCHER_HISTORY
					WHERE
						HISTORY_ID = #MAX_ID.IDENTITYCOL#
				</cfquery>
				<cfquery name="ADD_BANK_ACTION" datasource="#dsn2#">
					INSERT INTO
						BANK_ACTIONS
						(
							ACTION_TYPE,
							ACTION_TYPE_ID,
							ACTION_FROM_ACCOUNT_ID,
							ACTION_VALUE,
							ACTION_DATE,
							ACTION_CURRENCY_ID,
							ACTION_DETAIL,
							VOUCHER_ID,
							IS_ACCOUNT,
							IS_ACCOUNT_TYPE,
							RECORD_DATE,
							RECORD_EMP,
							FROM_BRANCH_ID,
							SYSTEM_ACTION_VALUE,
							SYSTEM_CURRENCY_ID
							<cfif len(session.ep.money2)>
								,ACTION_VALUE_2
								,ACTION_CURRENCY_ID_2
							</cfif>
						)
						VALUES
						(
							'SENET ÖDEMESİ',
							#process_type#,
							#attributes.account_id#,
							#GET_VOUCHER.VOUCHER_VALUE#,
							#attributes.act_date#,
							'#GET_VOUCHER.CURRENCY_ID#',
							'#GET_VOUCHER.VOUCHER_PURSE_NO# PORTFOY NOLU CIRO EDILMIS SENEDIN ODENMESI',
							#attributes.voucher_id#,
						<cfif is_account eq 1>
							1,
							13,
						<cfelse>
							0,
							13,
						</cfif>
							#now()#,
							#session.ep.userid#,
							#listgetat(session.ep.user_location,2,'-')#,
							#get_last_hist.OTHER_MONEY_VALUE#,
							'#session.ep.money#'
							<cfif len(session.ep.money2)>
								,#get_last_hist.OTHER_MONEY_VALUE2#
								,'#session.ep.money2#'
							</cfif>
						)
				</cfquery>	
				
				<cfquery name="GET_LAST_RECORD" datasource="#dsn2#">
					SELECT MAX(ACTION_ID) AS ACTION_ID FROM BANK_ACTIONS
				</cfquery>
				<cfquery name="GET_ACCOUNT_CODE_BANK" datasource="#dsn2#">
					SELECT
						ACCOUNT_ACC_CODE
					FROM
						#dsn3_alias#.ACCOUNTS
					WHERE
						ACCOUNT_ID=#attributes.account_id#
				</cfquery>
				<cfscript>
					if(is_account eq 1)
					{
						if(isDefined("attributes.detail") and len(attributes.detail))
							satir_detay_list[2][1] = ' #GET_VOUCHER.VOUCHER_PURSE_NO# - #attributes.voucher_no# - #attributes.detail#';
						else
							satir_detay_list[2][1] = ' #GET_VOUCHER.VOUCHER_PURSE_NO# - #attributes.voucher_no# - SENET ÖDEME İŞLEMİ BANKADAN';
					
					
						if(isDefined("attributes.detail") and len(attributes.detail))
							satir_detay_list[1][1] = ' #GET_VOUCHER.VOUCHER_PURSE_NO# - #attributes.voucher_no# - #attributes.detail#';
						else
							satir_detay_list[1][1] = ' #GET_VOUCHER.VOUCHER_PURSE_NO# - #attributes.voucher_no# - SENET ÖDEME İŞLEMİ BANKDAN';
							
						if(isDefined("GET_VOUCHER.project_id") and len(GET_VOUCHER.project_id))
							project_id_ = GET_VOUCHER.project_id;
						else
							project_id_ = '';
						
						if(session.ep.our_company_info.is_edefter eq 1)
							due_date_ = createODBCdatetime(GET_VOUCHER.VOUCHER_DUEDATE);
						else
							due_date_ = '';
							
						muhasebeci (
							action_id:GET_LAST_RECORD.ACTION_ID,
							workcube_process_type:process_type,
							account_card_type:13,
							islem_tarihi: attributes.act_date,
							borc_hesaplar:GET_ACCOUNT_CODE.V_VOUCHER_ACC_CODE,
							borc_tutarlar:get_last_hist.OTHER_MONEY_VALUE,
							other_amount_borc:GET_VOUCHER.VOUCHER_VALUE,
							other_currency_borc:GET_VOUCHER.CURRENCY_ID,
							alacak_hesaplar:GET_ACCOUNT_CODE_BANK.ACCOUNT_ACC_CODE,
							alacak_tutarlar:get_last_hist.OTHER_MONEY_VALUE,
							other_amount_alacak:GET_VOUCHER.VOUCHER_VALUE,
							other_currency_alacak:GET_VOUCHER.CURRENCY_ID,
							currency_multiplier : currency_multiplier_2,
							from_branch_id : listgetat(session.ep.user_location,2,'-'),
							fis_detay:iif((isdefined("attributes.detail") and len(attributes.detail)),'attributes.detail',de(' #GET_VOUCHER.VOUCHER_PURSE_NO# - SENET BANKADAN ÖDEME')),
							fis_satir_detay : satir_detay_list,
							workcube_process_cat : form.process_cat,
							is_account_group : is_account_group,
							acc_project_id : project_id_,
							belge_no : GET_VOUCHER.VOUCHER_NO,
							due_date : due_date_
						);
					}
				</cfscript>
			</cfif>
		</cfif>
		<cfif not (isdefined("attributes.voucher_id_list") and len(attributes.voucher_id_list))>
			<cf_workcube_process_cat 
				process_cat="#form.process_cat#"
				action_id = #attributes.voucher_id#
                action_page='#request.self#?fuseaction=cheque.popup_view_voucher_detail&ID=#attributes.voucher_id#'
				is_action_file = 1
				action_file_name='#get_process_type.action_file_name#'
				action_db_type = '#dsn2#'
				is_template_action_file = '#get_process_type.action_file_from_template#'>
		</cfif>
	</cftransaction>
</cflock>
