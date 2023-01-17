<!---e.a select ifadeleri düzenledi 19072012 --->
<cfif form.active_period neq session.ep.period_id>
	<script type="text/javascript">
		alert("<cf_get_lang_main no='1659.İşlem Yapmak İstediğiniz Muhasebe Dönemi ile Aktif Muhasebe Döneminiz Farklı Muhasebe Döneminizi Kontrol Ediniz'>!");
		window.location.href='<cfoutput>#request.self#?fuseaction=ch.form_add_premium_payment</cfoutput>';
	</script>
	<cfabort>
</cfif>
<cfquery name="get_process_type" datasource="#dsn3#">
	SELECT 
		PROCESS_TYPE,
		IS_CARI,
		IS_ACCOUNT,
		IS_ACCOUNT_GROUP,
		PROCESS_CAT,
		ACTION_FILE_NAME,
		ACTION_FILE_FROM_TEMPLATE
	 FROM 
	 	SETUP_PROCESS_CAT 
	WHERE 
		PROCESS_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_cat#"> 
</cfquery>
<cfscript>
	process_type_premium = get_process_type.process_type;
	is_account_premium =get_process_type.is_account;
	is_account_group_premium = get_process_type.is_account_group;
</cfscript>
<cf_date tarih='attributes.action_date'>
<cf_date tarih='attributes.payment_date'>
<cflock name="#createUUID()#" timeout="60">	
	<cftransaction>
		<!--- Prim Kayıtları Yapılıyor--->
		<cfinclude template="add_premium_payment_1.cfm">
		<cfquery name="get_rows" datasource="#dsn2#">
			<!---SELECT SUM(PAY_AMOUNT) PAY_AMOUNT,SUM(STOPPAGE_AMOUNT) STOPPAGE_AMOUNT,CONSUMER_ID FROM INVOICE_MULTILEVEL_PAYMENT_ROWS WHERE INV_PAYMENT_ID = #get_max_id_pre.max_id# GROUP BY CONSUMER_ID--->
			SELECT SUM(IMPR.PAY_AMOUNT) PAY_AMOUNT,SUM(IMPR.STOPPAGE_AMOUNT) STOPPAGE_AMOUNT,IMPR.CONSUMER_ID,C.MEMBER_CODE,C.CONSUMER_NAME,C.CONSUMER_SURNAME FROM INVOICE_MULTILEVEL_PAYMENT_ROWS IMPR, #dsn_alias#.CONSUMER C WHERE IMPR.CONSUMER_ID = C.CONSUMER_ID AND IMPR.INV_PAYMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_max_id_pre.max_id#"> GROUP BY IMPR.CONSUMER_ID,C.MEMBER_CODE,C.CONSUMER_NAME,C.CONSUMER_SURNAME
		</cfquery>
		<!--- Muhasebe kayıtları yapılıyor --->
		<cfinclude template="add_premium_payment_2.cfm">
		<!--- Dekont talimat kayıtları --->
		<cfquery name="GET_MONEY_INFO" datasource="#dsn2#">
			SELECT MONEY,RATE1,RATE2 FROM SETUP_MONEY WHERE MONEY_STATUS = 1
		</cfquery>
		<cfquery name="GET_PROCESS_MONEY" datasource="#dsn2#">
			SELECT ISNULL(STANDART_PROCESS_MONEY,OTHER_MONEY) MONEY_TYPE FROM #dsn_alias#.SETUP_PERIOD WHERE PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#"> 
		</cfquery>
		<cfscript>
			is_from_premium = 1;
			is_from_makeage = 1;
			is_transaction = 1;
			attributes.project_name = "";
			attributes.project_id = "";
			form.money_type = GET_PROCESS_MONEY.MONEY_TYPE;
			attributes.money_type = GET_PROCESS_MONEY.MONEY_TYPE;
			attributes.ACTION_CURRENCY_ID = "1;#GET_PROCESS_MONEY.MONEY_TYPE#";
			currency_mult_other = 1;
			currency_multiplier = "";
			attributes.kur_say = GET_MONEY_INFO.RECORDCOUNT;
			for(stp_mny=1;stp_mny lte GET_MONEY_INFO.RECORDCOUNT;stp_mny=stp_mny+1)
			{
				'attributes.hidden_rd_money_#stp_mny#'=GET_MONEY_INFO.MONEY[stp_mny];
				'attributes.txt_rate1_#stp_mny#'=GET_MONEY_INFO.RATE1[stp_mny];	
				'attributes.txt_rate2_#stp_mny#'=GET_MONEY_INFO.RATE2[stp_mny];
				if(attributes.ACTION_CURRENCY_ID eq GET_MONEY_INFO.MONEY[stp_mny])
					currency_mult_acc = (GET_MONEY_INFO.RATE2[stp_mny]/GET_MONEY_INFO.RATE1[stp_mny]);
				if(GET_PROCESS_MONEY.MONEY_TYPE eq GET_MONEY_INFO.MONEY[stp_mny])
					currency_mult_other = (GET_MONEY_INFO.RATE2[stp_mny]/GET_MONEY_INFO.RATE1[stp_mny]);
				if(GET_MONEY_INFO.MONEY[stp_mny] eq session.ep.money2)
					currency_multiplier = (GET_MONEY_INFO.RATE2[stp_mny]/GET_MONEY_INFO.RATE1[stp_mny]);
			}
			form.company_id = '';
			form.employee_id = '';
			attributes.company_id = '';
			attributes.employee_id = '';
			attributes.action_account_code = '';
			attributes.paper_number= '';
		</cfscript>
		<cfoutput query="get_rows">
			<!--- Dekont Kaydediliyor --->
			<cfif attributes.is_checked_value_by_single eq 0 or (isdefined("attributes.checked_value")) or (isdefined("attributes.checked_value") and isdefined("attributes.checked_value2"))>
				<cfif len(attributes.dekont_process_id)>
				<cfquery name="get_paper_no" datasource="#dsn2#">
					SELECT
						DEBIT_CLAIM_NO,
						DEBIT_CLAIM_NUMBER+1 AS DEBIT_CLAIM_NUMBER
					FROM
						#dsn3_alias#.GENERAL_PAPERS
					WHERE 
						PAPER_TYPE IS NULL 
				</cfquery>
				<cfset attributes.paper_number = '#get_paper_no.DEBIT_CLAIM_NO#-#get_paper_no.DEBIT_CLAIM_NUMBER#'>
				<cfset first_value = wrk_round((get_rows.pay_amount+get_rows.stoppage_amount),2)>
				<cfset attributes.action_detail = 'Pr:#first_value# Stpj:#wrk_round(get_rows.stoppage_amount,2)# Net Ödn:#wrk_round(get_rows.pay_amount,2)#'>
				<cfscript>
					form.process_cat = attributes.dekont_process_id;
					form.consumer_id = get_rows.consumer_id;
					attributes.consumer_id = get_rows.consumer_id;
					attributes.action_value = wrk_round(get_rows.pay_amount,4);
					if(listgetat(attributes.ACTION_CURRENCY_ID,2,';') eq session.ep.money)
					{
						attributes.other_cash_act_value = wrk_round(attributes.action_value/currency_mult_other,4);
						attributes.system_amount = wrk_round(attributes.action_value,4);	
					}
					else
					{
						attributes.system_amount = wrk_round(attributes.action_value*currency_mult_acc,4);
						attributes.other_cash_act_value = wrk_round(attributes.system_amount/currency_mult_other,4);
					}
				</cfscript>
				<cfinclude template="add_debit_claim_note.cfm">
				<cfquery name="upd_paper_no" datasource="#dsn2#">
					UPDATE 
						#dsn3_alias#.GENERAL_PAPERS
					SET
						DEBIT_CLAIM_NUMBER = DEBIT_CLAIM_NUMBER+1
					WHERE
						DEBIT_CLAIM_NUMBER IS NOT NULL
				</cfquery>
				<cfquery name="upd_payment" datasource="#dsn2#">
					UPDATE
						INVOICE_MULTILEVEL_PAYMENT_ROWS
					SET
						CARI_ACTION_ID = #GET_MAX.ACTION_ID#
					WHERE
						INV_PAYMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_max_id_pre.max_id#">  AND 
                        CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_rows.consumer_id#"> 
				</cfquery>
				<cfquery name="GET_CARI_INFO_1" datasource="#dsn2#">
					SELECT CLOSED_ID FROM CARI_CLOSED_ROW WHERE ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_max.action_id#"> AND ACTION_TYPE_ID = 42
				</cfquery>
				<cfif GET_CARI_INFO_1.recordcount>
					<cfquery name="del_closed_row" datasource="#dsn2#">
						DELETE FROM CARI_CLOSED_ROW WHERE CLOSED_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_cari_info_1.closed_id#">
					</cfquery>
					<cfquery name="del_closed" datasource="#dsn2#">
						DELETE FROM CARI_CLOSED WHERE CLOSED_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_cari_info_1.closed_id#">
					</cfquery>
				</cfif>
				<cfset dekont_action_id = GET_MAX.ACTION_ID>
			</cfif>
			</cfif>
			<!--- Banka talimatı Kaydediliyor --->
			<cfif attributes.is_checked_value_by_single eq 0 or (isdefined("attributes.checked_value2")) or (isdefined("attributes.checked_value") and isdefined("attributes.checked_value2"))>
				<cfif len(attributes.bank_order_process_id)>
					<cfscript>
						form.process_cat = attributes.bank_order_process_id;
						attributes.currency_id = session.ep.money;
						if(listgetat(attributes.form_account_id,2,';') eq session.ep.money)
						{
							attributes.ORDER_AMOUNT = wrk_round(attributes.action_value,4);
							attributes.OTHER_CASH_ACT_VALUE = wrk_round(attributes.action_value/currency_mult_other,4);
							attributes.system_amount = wrk_round(attributes.action_value,4);	
						}
						else
						{
							attributes.ORDER_AMOUNT = wrk_round(attributes.action_value,4);
							attributes.system_amount = wrk_round(attributes.action_value*currency_mult_acc,4);
							attributes.OTHER_CASH_ACT_VALUE = wrk_round(attributes.system_amount/currency_mult_other,4);
						}
						attributes.account_id = listfirst(attributes.form_account_id,';');
					</cfscript>
					<cfinclude template="../../bank/query/add_assign_order.cfm">
					<cfquery name="upd_payment" datasource="#dsn2#">
						UPDATE
							INVOICE_MULTILEVEL_PAYMENT_ROWS
						SET
							BANK_ORDER_ID = #MAX_ID.IDENTITYCOL#
						WHERE
							INV_PAYMENT_ID = #get_max_id_pre.max_id# AND 
                            CONSUMER_ID = #get_rows.consumer_id#
					</cfquery>
					<cfquery name="GET_CARI_INFO_2" datasource="#dsn2#">
						SELECT CLOSED_ID FROM CARI_CLOSED_ROW WHERE ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#max_id.identitycol#"> AND ACTION_TYPE_ID = 260
					</cfquery>
					<cfif GET_CARI_INFO_2.recordcount>
						<cfquery name="del_closed_row" datasource="#dsn2#">
							DELETE FROM CARI_CLOSED_ROW WHERE CLOSED_ID = #GET_CARI_INFO_2.CLOSED_ID#
						</cfquery>
						<cfquery name="del_closed" datasource="#dsn2#">
							DELETE FROM CARI_CLOSED WHERE CLOSED_ID = #GET_CARI_INFO_2.CLOSED_ID#
						</cfquery>
					</cfif>
					<cfset bank_order_action_id = MAX_ID.IDENTITYCOL>
				</cfif>
				<cfquery name="GET_CARI_INFO1" datasource="#dsn2#">
					SELECT CARI_ACTION_ID FROM CARI_ROWS WHERE ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#bank_order_action_id#"> AND ACTION_TYPE_ID = 260
				</cfquery>
				<cfquery name="GET_CARI_INFO2" datasource="#dsn2#">
					SELECT CARI_ACTION_ID FROM CARI_ROWS WHERE ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#dekont_action_id#"> AND ACTION_TYPE_ID = 42
				</cfquery>
				<cfif len(attributes.dekont_process_id) and len(attributes.bank_order_process_id) and GET_CARI_INFO1.recordcount and GET_CARI_INFO2.recordcount>
					<cfquery name="add_closed" datasource="#dsn2#">
						INSERT INTO CARI_CLOSED(CONSUMER_ID) VALUES(#get_rows.consumer_id#)
					</cfquery>
					<cfquery name="get_max_closed" datasource="#dsn2#">
						SELECT MAX(CLOSED_ID) MAX_ID FROM CARI_CLOSED
					</cfquery>
					<cfquery name="add_closed_row_1" datasource="#dsn2#">
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
							OTHER_MONEY
						)
						VALUES
						(
							#get_max_closed.MAX_ID#,
							#GET_CARI_INFO2.CARI_ACTION_ID#,
							#dekont_action_id#,
							42,
							#attributes.action_value#,
							#attributes.action_value#,
							#attributes.OTHER_CASH_ACT_VALUE#,
							'#GET_PROCESS_MONEY.MONEY_TYPE#'
						)					
					</cfquery>
					<cfquery name="add_closed_row_2" datasource="#dsn2#">
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
							OTHER_MONEY
						)
						VALUES
						(
							#get_max_closed.MAX_ID#,
							#GET_CARI_INFO1.CARI_ACTION_ID#,
							#bank_order_action_id#,
							250,
							#attributes.action_value#,
							#attributes.action_value#,
							#attributes.OTHER_CASH_ACT_VALUE#,
							'#GET_PROCESS_MONEY.MONEY_TYPE#'
						)					
					</cfquery>
				</cfif>
			</cfif>
		</cfoutput>
		<cfquery name="upd_payment" datasource="#dsn2#">
			UPDATE
				INVOICE_MULTILEVEL_PAYMENT
			SET
				PAY_AMOUNT = #total_payment_amount#,
				STOPPAGE_AMOUNT = #total_stoppage_amount#
			WHERE
				INV_PAYMENT_ID = #get_max_id_pre.max_id#
		</cfquery>
	</cftransaction>
</cflock>
<cfset attributes.actionId = get_max_id_pre.max_id>
<script type="text/javascript">
	window.location.href="<cfoutput>#request.self#?fuseaction=ch.form_upd_premium_payment&inv_payment_id=#get_max_id_pre.max_id#</cfoutput>";
</script>
