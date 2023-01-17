<!---19072012 e.a select ifadeleri düzenlendi.--->
<cfif form.active_period neq session.ep.period_id>
	<script type="text/javascript">
		alert("<cf_get_lang_main no='1659.İşlem Yapmak İstediğiniz Muhasebe Dönemi ile Aktif Muhasebe Döneminiz Farklı Muhasebe Döneminizi Kontrol Ediniz'>!");
		window.location.href='<cfoutput>#request.self#?fuseaction=ch.form_add_due_diff_action</cfoutput>';
	</script>
	<cfabort>
</cfif>
<cf_date tarih='attributes.action_date'>
<cfscript>
	for(k=1; k lte attributes.kur_say; k=k+1)
	{
		'attributes.txt_rate2_#k#' = filterNum(evaluate('attributes.txt_rate2_#k#'),session.ep.our_company_info.rate_round_num);
		'attributes.txt_rate1_#k#' = filterNum(evaluate('attributes.txt_rate1_#k#'),session.ep.our_company_info.rate_round_num);
	}
</cfscript>
<cfif isdefined("form.process_cat") and len(form.process_cat)>
	<cfquery name="get_process_type" datasource="#dsn2#">
		SELECT 
			PROCESS_TYPE,
			IS_CARI,
			IS_ACCOUNT,
			PROCESS_CAT,
			ACTION_FILE_NAME,
			ACTION_FILE_FROM_TEMPLATE
		 FROM 
			#dsn3_alias#.SETUP_PROCESS_CAT 
		WHERE 
			PROCESS_CAT_ID = #form.process_cat#
	</cfquery>
	<cfscript>
		process_type = get_process_type.process_type;
		is_cari =get_process_type.is_cari;
		is_account = get_process_type.is_account;
	</cfscript>
</cfif>
<cflock name="#createUUID()#" timeout="60">	
	<cftransaction>
		<cfquery name="add_due_diff_act" datasource="#dsn2#" result="MAX_ID">
			INSERT INTO
				CARI_DUE_DIFF_ACTIONS
				(
					ACTION_TYPE,
					ACTION_DATE,
					PROCESS_TYPE,
					PROCESS_CAT,
					IS_KDV,
					PRODUCT_ID,
					RECORD_DATE,
					RECORD_IP,
					RECORD_EMP
				)
			VALUES
				(
					#attributes.act_type#,
					#attributes.action_date#,
					<cfif isdefined("form.process_cat")>#form.process_cat#<cfelse>NULL</cfif>,
					<cfif isdefined("form.process_cat")>#process_type#<cfelse>NULL</cfif>,
					<cfif isdefined("attributes.is_kdv")>1<cfelse>0</cfif>,
					<cfif isdefined("attributes.product_name") and len(attributes.product_name) and len(attributes.product_id)>#attributes.product_id#<cfelse>NULL</cfif>,
					#now()#,
					'#cgi.remote_addr#',
					#session.ep.userid#
				)
		</cfquery>
        <cfset get_due_id.MAX_ID = MAX_ID.IDENTITYCOL>
		<cfif attributes.act_type neq 2>
			<cfloop from="1" to="#attributes.all_records#" index="int_i">
				<cfif isdefined("attributes.is_pay_#int_i#")>
					<cfscript>
						'attributes.control_amount_2_#int_i#' = filterNum(evaluate('attributes.control_amount_2_#int_i#'));
					</cfscript>
					<cfquery name="add_due_diff_act_row" datasource="#dsn2#">
						INSERT INTO
							CARI_DUE_DIFF_ACTIONS_ROW
							(
								DUE_DIFF_ID,
								COMPANY_ID,
								CONSUMER_ID,
								INVOICE_ID,
								PERIOD_ID,
								CARI_ROW_ID,
								ACTION_VALUE,
								DUE_DIFF_VALUE
							)
						VALUES
							(
								#get_due_id.max_id#,
								<cfif isdefined("attributes.company_id_#int_i#")>#evaluate("attributes.company_id_#int_i#")#<cfelse>NULL</cfif>,
								<cfif isdefined("attributes.consumer_id_#int_i#")>#evaluate("attributes.consumer_id_#int_i#")#<cfelse>NULL</cfif>,
								#evaluate("attributes.invoice_id_#int_i#")#,
								<cfif attributes.act_type eq 2>#evaluate("attributes.period_id_#int_i#")#<cfelse>NULL</cfif>,
								<cfif attributes.act_type neq 2>#evaluate("attributes.cari_action_id_#int_i#")#<cfelse>NULL</cfif>,
								#evaluate("attributes.act_value_#int_i#")#,
								#evaluate("attributes.control_amount_#int_i#")#							)
					</cfquery>
				</cfif>
			</cfloop>
		</cfif>
		<cfloop from="1" to="#attributes.kur_say#" index="r">
			<cfquery name="add_action_money" datasource="#dsn2#">
				INSERT INTO 
					CARI_DUE_DIFF_ACTIONS_MONEY 
					(
						ACTION_ID,
						MONEY_TYPE,
						RATE2,
						RATE1,
						IS_SELECTED
					)
					VALUES
					(
						#get_due_id.max_id#,
						'#evaluate("attributes.hidden_rd_money_#r#")#',
						#evaluate("attributes.txt_rate2_#r#")#,
						#evaluate("attributes.txt_rate1_#r#")#,
						<cfif evaluate("attributes.hidden_rd_money_#r#") is listfirst(attributes.rd_money,',')>1<cfelse>0</cfif>
					)
			</cfquery>
		</cfloop>
		<cfif attributes.act_type eq 1><!--- Dekont ekleniyor --->
			<cfscript>
				is_from_premium = 1;
				is_from_makeage = 1;
				is_transaction = 1;
				attributes.project_name = "";
				attributes.project_id = "";
				form.money_type = listfirst(attributes.rd_money,',');
				attributes.money_type = listfirst(attributes.rd_money,',');
				attributes.ACTION_CURRENCY_ID = "1;#listfirst(attributes.rd_money,',')#";
				form.employee_id = '';
				attributes.employee_id = '';
				attributes.action_account_code = '';
				attributes.action_detail= attributes.note;
				attributes.expense_center_1= '';
				attributes.expense_center_2= '';
				attributes.due_diff_id= get_due_id.max_id;
			</cfscript>
			<cfloop from="1" to="#attributes.all_records#" index="int_i">
				<cfif isdefined("attributes.is_pay_#int_i#")>
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
					<cfscript>
						attributes.action_value = evaluate("attributes.control_amount_2_#int_i#");
						attributes.other_cash_act_value = evaluate("attributes.control_amount_2_#int_i#");
						attributes.system_amount = evaluate("attributes.control_amount_#int_i#");
						attributes.invoice_id= evaluate("attributes.invoice_id_#int_i#");	
					</cfscript>
					<cfif isdefined("attributes.consumer_id_#int_i#")>
						<cfset attributes.consumer_id = evaluate("attributes.consumer_id_#int_i#")>
						<cfset form.consumer_id = evaluate("attributes.consumer_id_#int_i#")>
						<cfset form.company_id = ''>
						<cfset attributes.company_id = ''>
					<cfelse>
						<cfset attributes.company_id = evaluate("attributes.company_id_#int_i#")>
						<cfset form.company_id = evaluate("attributes.company_id_#int_i#")>
						<cfset form.consumer_id = ''>
						<cfset attributes.consumer_id = ''>
					</cfif>
					<cfinclude template="add_debit_claim_note.cfm">
					<cfquery name="upd_paper_no" datasource="#dsn2#">
						UPDATE 
							#dsn3_alias#.GENERAL_PAPERS
						SET
							DEBIT_CLAIM_NUMBER = DEBIT_CLAIM_NUMBER+1
						WHERE
							DEBIT_CLAIM_NUMBER IS NOT NULL
					</cfquery>
				</cfif>
			</cfloop>
		<cfelseif attributes.act_type eq 2><!--- Sistem ödeme planı satırları ekleniyor --->
			<cfquery name="GET_PROD_UNIT" datasource="#dsn2#">
				SELECT MAIN_UNIT,MAIN_UNIT_ID FROM #dsn3_alias#.PRODUCT_UNIT WHERE PRODUCT_ID = #attributes.product_id# AND IS_MAIN=1 AND PRODUCT_UNIT_STATUS=1
			</cfquery>
			<cfloop from="1" to="#attributes.all_records#" index="int_i">
				<cfif isdefined("attributes.is_pay_#int_i#")>
					<cfscript>
						'attributes.control_amount_2_#int_i#' = filterNum(evaluate('attributes.control_amount_2_#int_i#'));
					</cfscript>
					<cfif not isdefined("attributes.is_kdv")>
						<cfset "attributes.control_amount_2_#int_i#" = evaluate("attributes.control_amount_2_#int_i#")*((100+attributes.tax)/100)>
						<cfset "attributes.control_amount_#int_i#" = evaluate("attributes.control_amount_#int_i#")*((100+attributes.tax)/100)>
					</cfif>
					<cfset act_date_info = dateadd('d',attributes.due_day,attributes.action_date)>
					<cfquery name="ADD_PAYMENT_PLAN_ROW" datasource="#dsn2#">
						INSERT INTO
							#dsn3_alias#.SUBSCRIPTION_PAYMENT_PLAN_ROW
							(
								DUE_DIFF_ID,
								SUBSCRIPTION_ID,
								PRODUCT_ID,
								STOCK_ID,
								PAYMENT_DATE,
								PAYMENT_FINISH_DATE,
								DETAIL,
								UNIT,
								UNIT_ID,
								QUANTITY,
								AMOUNT,
								MONEY_TYPE,
								ROW_TOTAL,
								DISCOUNT,
								ROW_NET_TOTAL,
								IS_COLLECTED_INVOICE,
								IS_GROUP_INVOICE,
								IS_BILLED,
								IS_COLLECTED_PROVISION,
								IS_PAID,
								IS_ACTIVE,
								INVOICE_ID,
								PERIOD_ID,
								PAYMETHOD_ID,
								CARD_PAYMETHOD_ID,
								SUBS_REFERENCE_ID,
								DUE_DIFF_INVOICE_ID,
								DUE_DIFF_PERIOD_ID,
								RECORD_DATE,
								RECORD_IP,
								RECORD_EMP
							)
						VALUES
							(
								#get_due_id.max_id#,
								#evaluate("attributes.subscription_id_#int_i#")#,
								#attributes.product_id#,
								#attributes.stock_id#,
								#act_date_info#,
								#act_date_info#,
								'<cfif attributes.is_invoice_no_product eq 1>#evaluate("attributes.invoice_number_#int_i#")# Faturası</cfif> #left(attributes.product_name,50)#',
								'#GET_PROD_UNIT.MAIN_UNIT#',
								#GET_PROD_UNIT.MAIN_UNIT_ID#,
								1,
								#evaluate("attributes.control_amount_2_#int_i#")#,
								'#listfirst(attributes.rd_money,',')#',
								#evaluate("attributes.control_amount_2_#int_i#")#,
								0,
								#evaluate("attributes.control_amount_2_#int_i#")#,
								1,
								0,
								0,
								0,
								0,
								1,
								NULL,
								#session.ep.period_id#,
								<cfif len(attributes.payment_type_id2)>#attributes.payment_type_id2#,<cfelse>NULL,</cfif>
								<cfif len(attributes.card_paymethod_id2)>#attributes.card_paymethod_id2#,<cfelse>NULL,</cfif>
								NULL,
								#evaluate("attributes.invoice_id_#int_i#")#,
								#evaluate("attributes.period_id_#int_i#")#,
								#now()#,
								'#cgi.remote_addr#',
								#session.ep.userid#
							)
					</cfquery>
					<cfquery name="get_max_row_id" datasource="#dsn2#">
						SELECT MAX(SUBSCRIPTION_PAYMENT_ROW_ID) AS MAX_ID FROM #dsn3_alias#.SUBSCRIPTION_PAYMENT_PLAN_ROW
					</cfquery>
					<cfquery name="add_due_diff_act_row" datasource="#dsn2#">
						INSERT INTO
							CARI_DUE_DIFF_ACTIONS_ROW
							(
								DUE_DIFF_ID,
								COMPANY_ID,
								CONSUMER_ID,
								INVOICE_ID,
								PERIOD_ID,
								CARI_ROW_ID,
								ACTION_VALUE,
								DUE_DIFF_VALUE,
								SUBSCRIPTION_PAYMENT_ROW_ID
							)
						VALUES
							(
								#get_due_id.max_id#,
								<cfif isdefined("attributes.company_id_#int_i#")>#evaluate("attributes.company_id_#int_i#")#<cfelse>NULL</cfif>,
								<cfif isdefined("attributes.consumer_id_#int_i#")>#evaluate("attributes.consumer_id_#int_i#")#<cfelse>NULL</cfif>,
								#evaluate("attributes.invoice_id_#int_i#")#,
								<cfif attributes.act_type eq 2>#evaluate("attributes.period_id_#int_i#")#<cfelse>NULL</cfif>,
								<cfif attributes.act_type neq 2>#evaluate("attributes.cari_action_id_#int_i#")#<cfelse>NULL</cfif>,
								#evaluate("attributes.act_value_#int_i#")#,
								#evaluate("attributes.control_amount_#int_i#")#,
								#get_max_row_id.MAX_ID#							)
					</cfquery>
				</cfif>
			</cfloop>
		<cfelseif attributes.act_type eq 3><!---Fatura kontrol satırları ekleniyor --->
			<cfloop from="1" to="#attributes.all_records#" index="int_i">
				<cfif isdefined("attributes.is_pay_#int_i#")>
					<cfif not isdefined("attributes.is_kdv")>
						<cfset "attributes.control_amount_2_#int_i#" = evaluate("attributes.control_amount_2_#int_i#")*((100+attributes.tax)/100)>
						<cfset "attributes.control_amount_#int_i#" = evaluate("attributes.control_amount_#int_i#")*((100+attributes.tax)/100)>
					</cfif>
					<cfquery name="get_inv" datasource="#dsn2#">
						SELECT 
							DEPARTMENT_ID,
							DEPARTMENT_LOCATION
						FROM 
							INVOICE
						WHERE 
							INVOICE.INVOICE_ID = #evaluate("attributes.invoice_id_#int_i#")#
					</cfquery>
					<cf_date tarih='attributes.invoice_date_#int_i#'>
					<cfquery name="add_inv_control" datasource="#dsn2#">
						INSERT INTO 
							INVOICE_CONTROL
							(
								DUE_DIFF_ID,
								INVOICE_NUMBER,
								INVOICE_ID,
								COMPANY_ID,
								CONSUMER_ID,
								MONEY,
								RETURN_MONEY_VALUE,				
								IS_CONTROL,
								RECORD_EMP,
								RECORD_IP,
								RECORD_DATE
							)
						VALUES
							(
								#get_due_id.max_id#,
								'#evaluate("attributes.invoice_number_#int_i#")#',
								#evaluate("attributes.invoice_id_#int_i#")#,
								<cfif isdefined("attributes.company_id_#int_i#")>#evaluate("attributes.company_id_#int_i#")#<cfelse>NULL</cfif>,
								<cfif isdefined("attributes.consumer_id_#int_i#")>#evaluate("attributes.consumer_id_#int_i#")#<cfelse>NULL</cfif>,
								'#listfirst(attributes.rd_money,',')#',
								0,
								1,
								#session.ep.userid#,
								'#cgi.remote_addr#',
								#now()#
							)
					</cfquery>
					<cfquery name="add_inv_cont" datasource="#dsn2#">
						INSERT INTO 
							INVOICE_CONTRACT_COMPARISON
							(
								DUE_DIFF_ID,
								MAIN_INVOICE_ID,
								MAIN_INVOICE_DATE,
								MAIN_INVOICE_NUMBER,
								COMPANY_ID,
								CONSUMER_ID,
								MAIN_PRODUCT_ID,
								MAIN_STOCK_ID,							
								AMOUNT,
								DIFF_RATE,
								DIFF_AMOUNT,
								DIFF_AMOUNT_OTHER,
								OTHER_MONEY,
								IS_DIFF_DISCOUNT,
								IS_DIFF_PRICE,
								DIFF_TYPE,
								INVOICE_TYPE,
								TAX,
								DEPARTMENT_ID,
								LOCATION_ID,
								RECORD_EMP,
								RECORD_IP,
								RECORD_DATE,
								NOTE
							)
						VALUES
							(
								#get_due_id.max_id#,
								#evaluate("attributes.invoice_id_#int_i#")#,
								#evaluate("attributes.invoice_date_#int_i#")#,
								'#evaluate("attributes.invoice_number_#int_i#")#',
								<cfif isdefined("attributes.company_id_#int_i#")>#evaluate("attributes.company_id_#int_i#")#<cfelse>NULL</cfif>,
								<cfif isdefined("attributes.consumer_id_#int_i#")>#evaluate("attributes.consumer_id_#int_i#")#<cfelse>NULL</cfif>,
								#attributes.product_id#,
								#attributes.stock_id#,
								1,
								NULL,
								#evaluate("attributes.control_amount_#int_i#")#,
								#evaluate("attributes.control_amount_2_#int_i#")#,
								'#listfirst(attributes.rd_money,',')#',
								0,
								0,
								8,
								0,
								#attributes.tax#,
								#get_inv.department_id#,
								#get_inv.department_location#,
								#session.ep.userid#,
								'#cgi.remote_addr#',
								#now()#,
								'#attributes.NOTE#'
							)
					</cfquery>
				</cfif>
			</cfloop>
		</cfif>
	</cftransaction>
</cflock>
<script type="text/javascript">
	window.location.href='<cfoutput>#request.self#?fuseaction=ch.list_due_diff_actions&event=upd&due_diff_id=#get_due_id.max_id#</cfoutput>';
</script>
