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
				OTHER_MONEY,
				OTHER_MONEY_VALUE,
				OTHER_MONEY2,
				OTHER_MONEY_VALUE2,
				VOUCHER.CURRENCY_ID,
				VOUCHER_PURSE_NO,
				VOUCHER_DUEDATE,
				VOUCHER_PAYROLL.PROJECT_ID,
                VOUCHER_NO
			FROM
				VOUCHER
                	LEFT JOIN VOUCHER_PAYROLL ON VOUCHER_PAYROLL.ACTION_ID = VOUCHER.VOUCHER_PAYROLL_ID
			WHERE
				VOUCHER_ID=#attributes.voucher_id#
		</cfquery>
		<cfif isdefined("is_collacted")>
			<cfset attributes.system_currency_value = wrk_round(GET_VOUCHER.VOUCHER_VALUE*currency_multiplier)>
			<cfset attributes.system_currency_value2 = wrk_round((GET_VOUCHER.VOUCHER_VALUE*currency_multiplier)/currency_multiplier_2)>
		</cfif>
		<cfif attributes.extra_status eq 1><!--- portfoyde --->
			<cfquery name="GET_VOUCHER_HISTORY" datasource="#dsn2#" maxrows="1">
				SELECT PAYROLL_ID FROM VOUCHER_HISTORY WHERE VOUCHER_ID=#attributes.voucher_id# AND STATUS=1 AND PAYROLL_ID IS NOT NULL ORDER BY HISTORY_ID DESC
			</cfquery>
			<cfquery name="GET_PAYROLL" datasource="#dsn2#">
				SELECT PAYROLL_CASH_ID FROM VOUCHER_PAYROLL WHERE ACTION_ID=#GET_VOUCHER_HISTORY.PAYROLL_ID#
			</cfquery>
		<cfelse><!--- bankada --->
			<cfquery name="GET_VOUCHER_HISTORY" datasource="#dsn2#" maxrows="1">
				SELECT 
					PAYROLL_ID 
				FROM 
					VOUCHER_HISTORY 
				WHERE 
					VOUCHER_ID=#attributes.voucher_id#
					<cfif GET_VOUCHER.VOUCHER_STATUS_ID eq 2>
						AND STATUS=2 
					<cfelse>
						AND STATUS=13	
					</cfif>
				ORDER BY 
					HISTORY_ID DESC
			</cfquery>
			<cfquery name="GET_PAYROLL" datasource="#dsn2#">
				SELECT PAYROLL_ACCOUNT_ID FROM VOUCHER_PAYROLL WHERE ACTION_ID=#GET_VOUCHER_HISTORY.PAYROLL_ID#
			</cfquery>
		</cfif>
		<cfquery name="CHANGE_STATUS" datasource="#dsn2#">
			UPDATE VOUCHER SET VOUCHER_STATUS_ID=5 WHERE VOUCHER_ID=#attributes.voucher_id#
		</cfquery>
		<cfquery name="ADD_VOUCHER_HISTORY" datasource="#dsn2#" result="MAX_ID">
			INSERT INTO
				VOUCHER_HISTORY
				(
					VOUCHER_ID,
					STATUS,
                    PAYROLL_ID,
					OTHER_MONEY,
					OTHER_MONEY_VALUE,
					OTHER_MONEY2,
					OTHER_MONEY_VALUE2,
					ACT_DATE,
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
					5,
                    #GET_VOUCHER_HISTORY.PAYROLL_ID#,
					'#session.ep.money#',
					<cfif isdefined("attributes.system_currency_value") and len(attributes.system_currency_value)>#attributes.system_currency_value#,<cfelse>NULL,</cfif>
					<cfif len(session.ep.money2)>'#session.ep.money2#',<cfelse>NULL,</cfif>
					<cfif isdefined("attributes.system_currency_value2") and len(attributes.system_currency_value2)>#attributes.system_currency_value2#,<cfelse>NULL,</cfif>
					#attributes.act_date#,
					#now()#,
					<cfif isdefined("attributes.system_currency_value_diff") and len(attributes.system_currency_value_diff)>#attributes.system_currency_value_diff#,<cfelse>NULL,</cfif>
					'#session.ep.money#',
					<cfif isdefined("attributes.system_currency_value_diff2") and len(attributes.system_currency_value_diff2)>#attributes.system_currency_value_diff2#,<cfelse>NULL,</cfif>
					'#session.ep.money2#',
					<cfif isdefined("attributes.other_currency_value_diff") and len(attributes.other_currency_value_diff)>#attributes.other_currency_value_diff#,<cfelse>NULL,</cfif>
					'#attributes.other_money#',
					<cfif isDefined("attributes.DETAIL") and len(attributes.DETAIL)>'#DETAIL#'<cfelse>NULL</cfif>
				)
		</cfquery>
		<cfloop from="1" to="#attributes.kur_say#" index="i">
			<cfquery name="ADD_MONEY_INFO" datasource="#dsn2#">
				INSERT INTO CHEQUE_HISTORY_MONEY 
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
		<cfif attributes.extra_status eq 1>
			<cfquery name="GET_BANK_ACC_CODE" datasource="#dsn2#">
				SELECT A_VOUCHER_ACC_CODE VOUCHER_EXCHANGE_CODE,'' VOUCHER_GUARANTY_CODE FROM CASH WHERE CASH_ID = #GET_PAYROLL.PAYROLL_CASH_ID#
			</cfquery>
		<cfelse>
			<cfquery name="GET_BANK_ACC_CODE" datasource="#dsn2#">
				SELECT VOUCHER_EXCHANGE_CODE,VOUCHER_GUARANTY_CODE FROM #dsn3_alias#.ACCOUNTS AS ACCOUNTS WHERE ACCOUNT_ID = #GET_PAYROLL.PAYROLL_ACCOUNT_ID#
			</cfquery>
		</cfif>
		<cfif attributes.extra_status eq 1>
			<cfquery name="GET_KARSILIKSIZ_HESAP" datasource="#DSN2#">
				SELECT PROTESTOLU_SENETLER_CODE FROM #dsn2_alias#.CASH WHERE CASH_ID = #GET_PAYROLL.PAYROLL_CASH_ID#
			</cfquery>
		<cfelse>
			<cfquery name="GET_KARSILIKSIZ_HESAP" datasource="#DSN2#">
				SELECT PROTESTOLU_SENETLER_CODE FROM #dsn3_alias#.ACCOUNTS AS ACCOUNTS WHERE ACCOUNT_ID = #GET_PAYROLL.PAYROLL_ACCOUNT_ID#
			</cfquery>
		</cfif>
		<cfif GET_VOUCHER.VOUCHER_STATUS_ID eq 2 or GET_VOUCHER.VOUCHER_STATUS_ID eq 1>
			<cfset alacak_hesap = GET_BANK_ACC_CODE.VOUCHER_EXCHANGE_CODE>
		<cfelse>
			<cfif len(GET_BANK_ACC_CODE.VOUCHER_GUARANTY_CODE)>
				<cfset alacak_hesap = GET_BANK_ACC_CODE.VOUCHER_GUARANTY_CODE>
			<cfelse>
				<cfquery name="get_bank_acc_code_general" datasource="#dsn2#">
					SELECT VOUCHER_GUARANTY_CODE FROM #dsn3_alias#.ACCOUNTS AS ACCOUNTS WHERE ACCOUNT_ID = #GET_PAYROLL.PAYROLL_ACCOUNT_ID#
				</cfquery>
				<cfset alacak_hesap = get_bank_acc_code_general.VOUCHER_GUARANTY_CODE>	
			</cfif>
		</cfif>
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
		<cfscript>
			if(is_account eq 1)
			{
				if(isDefined("attributes.detail") and len(attributes.detail))
					satir_detay_list[2][1] = ' #GET_VOUCHER.VOUCHER_PURSE_NO# - #GET_VOUCHER.voucher_no# - #attributes.detail#';
				else
					satir_detay_list[2][1] = ' #GET_VOUCHER.VOUCHER_PURSE_NO# - #GET_VOUCHER.voucher_no# - PROTESTOLU SENET İŞLEMİ';
			
			
				if(isDefined("attributes.detail") and len(attributes.detail))
					satir_detay_list[1][1] = ' #GET_VOUCHER.VOUCHER_PURSE_NO# - #GET_VOUCHER.voucher_no# - #attributes.detail#';
				else
					satir_detay_list[1][1] = ' #GET_VOUCHER.VOUCHER_PURSE_NO# - #GET_VOUCHER.voucher_no# - PROTESTOLU SENET İŞLEMİ';
				
				if(isDefined("GET_VOUCHER.project_id") and len(GET_VOUCHER.project_id))
					project_id_ = GET_VOUCHER.project_id;
				else
					project_id_ = '';
				
				if(session.ep.our_company_info.is_edefter eq 1)
					due_date_ = createODBCdatetime(GET_VOUCHER.VOUCHER_DUEDATE);
				else
					due_date_ = '';
					
				muhasebeci (
					action_id:attributes.voucher_id,
					workcube_process_type:process_type,
					account_card_type:13,
					islem_tarihi: attributes.act_date,
					borc_hesaplar:GET_KARSILIKSIZ_HESAP.PROTESTOLU_SENETLER_CODE,
					borc_tutarlar:get_last_hist.OTHER_MONEY_VALUE,
					other_amount_borc:GET_VOUCHER.VOUCHER_VALUE,
					other_currency_borc:GET_VOUCHER.CURRENCY_ID,
					alacak_hesaplar:alacak_hesap,
					alacak_tutarlar:get_last_hist.OTHER_MONEY_VALUE,
					other_amount_alacak:GET_VOUCHER.VOUCHER_VALUE,
					other_currency_alacak:GET_VOUCHER.CURRENCY_ID,
					currency_multiplier : currency_multiplier_2,
					from_branch_id : listgetat(session.ep.user_location,2,'-'),
					fis_detay:iif((isdefined("attributes.detail") and len(attributes.detail)),'attributes.detail',de(' #GET_VOUCHER.VOUCHER_PURSE_NO# - PROTESTOLU SENET İŞLEMİ')),
					fis_satir_detay:satir_detay_list,
					workcube_process_cat : form.process_cat,
					is_account_group : is_account_group,
					acc_project_id : project_id_,
					belge_no : GET_VOUCHER.VOUCHER_NO,
					due_date : due_date_
				);
			}
		</cfscript>
		<cfif not(isdefined("attributes.voucher_id_list") and len(attributes.voucher_id_list))>
			<cf_workcube_process_cat 
				process_cat="#form.process_cat#"
				action_id = #attributes.voucher_id#
				is_action_file = 1
				action_file_name='#get_process_type.action_file_name#'
				action_db_type = '#dsn2#'
				is_template_action_file = '#get_process_type.action_file_from_template#'>
		</cfif>
	</cftransaction>
</cflock>

