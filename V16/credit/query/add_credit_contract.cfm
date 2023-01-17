<cfif isdefined('attributes.order_no') and len(attributes.order_no)>
	<cfquery name="CHECK_CREDIT_CONTRACT" datasource="#DSN3#"><!--- Bu sipariş ile bir credi eklenmişmi? --->
		SELECT 
			ORDER_NO
		FROM 
			CREDIT_CONTRACT
		WHERE ORDER_NO LIKE '%#attributes.order_no#%'
	</cfquery>
	<cfif CHECK_CREDIT_CONTRACT.RECORDCOUNT>
		<script type="text/javascript">
		alert("Bu Sipariş Numarası ile Daha Önce Bir Kredi Eklenmiş.");
		window.history.go(-1);
		</script>	
	<cfabort>
	</cfif>
</cfif>
<cf_date tarih="attributes.credit_date">
<cf_papers paper_type="credit">
<cfset rd_money_value = listfirst(attributes.rd_money, ',')>
<cfquery name="get_process_type" datasource="#dsn3#">
	SELECT PROCESS_TYPE,IS_CARI,IS_ACCOUNT,IS_ACCOUNT_GROUP,ACTION_FILE_NAME,ACTION_FILE_FROM_TEMPLATE FROM SETUP_PROCESS_CAT WHERE PROCESS_CAT_ID = #form.process_cat#
</cfquery>
<cfset process_type = get_process_type.process_type>
<cfset is_account = get_process_type.is_account>
<cfset is_account_group = get_process_type.is_account_group>
<cfset full_paper_no = paper_code & '-' & paper_number>
<cflock name="#CREATEUUID()#" timeout="60">
	<cftransaction>
		<cfquery name="ADD_CREDIT_CONTRACT" datasource="#DSN3#" result="MAX_ID">
			INSERT INTO 
				CREDIT_CONTRACT
			(
				PROCESS_TYPE,
				PROCESS_CAT,
				COMPANY_ID,
				CREDIT_NO,
				CREDIT_DATE,
				REFERENCE,
				DETAIL,
				IS_SCENARIO,
				IS_ACTIVE,
				TOTAL_REVENUE,
				OTHER_TOTAL_REVENUE,
				TOTAL_PAYMENT,
				OTHER_TOTAL_PAYMENT,
				MONEY_TYPE,
				AGREEMENT_NO,
				CREDIT_EMP_ID,
				ORDER_NO,
				PROJECT_ID,
				CREDIT_TYPE,
				CREDIT_LIMIT_ID,
				RECORD_EMP,
				RECORD_IP,
				RECORD_DATE,
                INTEREST_RATE,
                INTEREST_PERIOD
			)
			VALUES
			(							
				#process_type#,
				#form.process_cat#,
				<cfif len(attributes.company_id) and len(attributes.company)>#attributes.company_id#<cfelse>NULL</cfif>,
				<cfif len(attributes.credit_no)>'#attributes.credit_no#'<cfelse>NULL</cfif>,
				#attributes.credit_date#,
				'#attributes.reference#',
				'#attributes.detail#',
				<cfif isdefined("attributes.is_scenario")>1<cfelse>0</cfif>,
				<cfif isdefined("attributes.is_active")>1<cfelse>0</cfif>,
				<cfif len(attributes.total_revenue)>#attributes.total_revenue#<cfelse>0</cfif>,
				<cfif len(attributes.other_total_revenue)>#attributes.other_total_revenue#<cfelse>0</cfif>,
				<cfif len(attributes.total_payment)>#attributes.total_payment#<cfelse>0</cfif>,
				<cfif len(attributes.other_total_payment)>#attributes.other_total_payment#<cfelse>0</cfif>,				
				'#rd_money_value#',
				<cfif len(attributes.agreement_no)>'#attributes.agreement_no#'<cfelse>NULL</cfif>,
				<cfif len(attributes.credit_emp_id) and len(attributes.credit_emp_name)>#attributes.credit_emp_id#<cfelse>NULL</cfif>,
				<cfif isdefined('attributes.order_no')>'#attributes.order_no#'<cfelse>NULL</cfif>,
				<cfif len(attributes.related_project_id)>#related_project_id#<cfelse>NULL</cfif>,
				<cfif len(attributes.credit_type)>#attributes.credit_type#<cfelse>NULL</cfif>,
				<cfif len(attributes.credit_limit_id)>#attributes.credit_limit_id#<cfelse>NULL</cfif>,
				#session.ep.userid#,
				'#cgi.remote_addr#',
				#now()#,
                <cfif len(attributes.interest_rate)>#attributes.interest_rate#<cfelse>NULL</cfif>,		
                <cfif attributes.interest_period eq 1>1<cfelseif attributes.interest_period eq 2>2<cfelse>3</cfif>
			)
		</cfquery>
		<!--- Odeme Satirlarinin kaydi --->
		<cfloop from="1" to="#attributes.payment_record_num#" index="i">
		  <cfif evaluate("attributes.payment_row_kontrol#i#")>
		 	<cfscript>
				form_payment_date = evaluate("attributes.payment_date#i#");
				form_capital_price = evaluate("attributes.payment_capital_price#i#");
				form_interest_price = evaluate("attributes.payment_interest_price#i#");
				form_tax_price = evaluate("attributes.payment_tax_price#i#");
				form_total_price = evaluate("attributes.payment_total_price#i#");
				form_detail = evaluate("attributes.payment_detail#i#");	
			</cfscript>
			<cf_date tarih='form_payment_date'>
			<cfquery name="ADD_CREDIT_CONTRACT_ROW" datasource="#DSN3#">
				INSERT INTO
					CREDIT_CONTRACT_ROW
				(
					CREDIT_CONTRACT_TYPE,
					CREDIT_CONTRACT_ID,						
					PROCESS_DATE,
					CAPITAL_PRICE,						
					INTEREST_PRICE,
					TAX_PRICE,
					TOTAL_PRICE,
					OTHER_MONEY,
					EXPENSE_CENTER_ID,
					EXPENSE_ITEM_ID,
					INTEREST_ACCOUNT_ID,
					TOTAL_EXPENSE_ITEM_ID,
					TOTAL_ACCOUNT_ID,
					CAPITAL_EXPENSE_ITEM_ID,
					CAPITAL_ACCOUNT_ID,					
					DETAIL,
                    <cfif process_type eq 296>
                    BORROW,
                    </cfif>
					IS_PAID<!---(ödenmemiş veya tahsil edeilmemiş) sözleşme satırları --->
				)
				VALUES
				(
					1,
					#MAX_ID.IDENTITYCOL#,						
					#form_payment_date#,
					#form_capital_price#,
					<cfif len(form_interest_price)>#form_interest_price#<cfelse>0</cfif>,
					<cfif len(form_tax_price)>#form_tax_price#<cfelse>0</cfif>,
					#form_total_price#,
					'#rd_money_value#',
					<cfif isdefined("attributes.expense_center_id#i#") and len(evaluate("attributes.expense_center_id#i#"))>#evaluate("attributes.expense_center_id#i#")#<cfelse>NULL</cfif>,
					<cfif isdefined("attributes.expense_item_id#i#") and len(evaluate("attributes.expense_item_id#i#"))>#evaluate("attributes.expense_item_id#i#")#<cfelse>NULL</cfif>,
					<cfif isdefined("attributes.interest_account_code#i#") and len(evaluate("attributes.interest_account_code#i#"))>'#wrk_eval("attributes.interest_account_id#i#")#'<cfelse>NULL</cfif>,
					<cfif isdefined("attributes.total_expense_item_id#i#") and len(evaluate("attributes.total_expense_item_id#i#"))>#evaluate("attributes.total_expense_item_id#i#")#<cfelse>NULL</cfif>,
					'#wrk_eval("attributes.total_account_id#i#")#',
					<cfif isdefined("attributes.capital_expense_item_id#i#") and len(evaluate("attributes.capital_expense_item_id#i#"))>#evaluate("attributes.capital_expense_item_id#i#")#<cfelse>NULL</cfif>,
					<cfif isdefined("attributes.capital_account_code#i#") and len(evaluate("attributes.capital_account_code#i#"))>'#wrk_eval("attributes.capital_account_id#i#")#'<cfelse>NULL</cfif>,
					'#form_detail#',
                    <cfif process_type eq 296>
                    '#wrk_eval("attributes.borrow_id#i#")#',
                    </cfif>
					0
				)
			</cfquery>
		  </cfif>
		</cfloop>

		<!--- Tahsilat Satirlarinin kaydi --->
		<cfloop from="1" to="#attributes.revenue_record_num#" index="i">
		  <cfif evaluate("attributes.revenue_row_kontrol#i#")>
		 	<cfscript>
				form_revenue_date = evaluate("attributes.revenue_date#i#");
				form_capital_price = evaluate("attributes.revenue_capital_price#i#");
				form_interest_price = evaluate("attributes.revenue_interest_price#i#");
				form_tax_price = evaluate("attributes.revenue_tax_price#i#");
				form_total_price = evaluate("attributes.revenue_total_price#i#");
				form_detail = evaluate("attributes.revenue_detail#i#");				
			</cfscript>
			<cf_date tarih='form_revenue_date'>
			<cfquery name="ADD_CREDIT_CONTRACT_ROW" datasource="#DSN3#">
				INSERT INTO
					CREDIT_CONTRACT_ROW
				(
					CREDIT_CONTRACT_TYPE,
					CREDIT_CONTRACT_ID,						
					PROCESS_DATE,
					CAPITAL_PRICE,						
					INTEREST_PRICE,
					TAX_PRICE,
					TOTAL_PRICE,
					OTHER_MONEY,						
					DETAIL,
					IS_PAID,<!--- (ödenmemiş veya tahsil edeilmemiş) sözleşme satırları  --->
					EXPENSE_CENTER_ID,
					EXPENSE_ITEM_ID,
					INTEREST_ACCOUNT_ID,
					TOTAL_EXPENSE_ITEM_ID,
					TOTAL_ACCOUNT_ID,	
					CAPITAL_EXPENSE_ITEM_ID,
					CAPITAL_ACCOUNT_ID
				)
				VALUES
				(
					2,
					#MAX_ID.IDENTITYCOL#,						
					#form_revenue_date#,
					#form_capital_price#,
					<cfif len(form_interest_price)>#form_interest_price#<cfelse>0</cfif>,
					<cfif len(form_tax_price)>#form_tax_price#<cfelse>0</cfif>,
					#form_total_price#,
					'#rd_money_value#',					
					'#form_detail#',
					0,	
					<cfif isdefined("attributes.revenue_expense_center_id#i#") and len(evaluate("attributes.revenue_expense_center_id#i#"))>#evaluate("attributes.revenue_expense_center_id#i#")#<cfelse>NULL</cfif>,
					<cfif isdefined("attributes.revenue_expense_item_id#i#") and len(evaluate("attributes.revenue_expense_item_id#i#"))>#evaluate("attributes.revenue_expense_item_id#i#")#<cfelse>NULL</cfif>,
					<cfif isdefined("attributes.revenue_interest_account_code#i#") and len(evaluate("attributes.revenue_interest_account_code#i#"))>'#wrk_eval("attributes.revenue_interest_account_id#i#")#'<cfelse>NULL</cfif>,
					<cfif isdefined("attributes.revenue_total_expense_item_id#i#") and len(evaluate("attributes.revenue_total_expense_item_id#i#"))>#evaluate("attributes.revenue_total_expense_item_id#i#")#<cfelse>NULL</cfif>,
					<cfif isdefined("attributes.revenue_total_account_code#i#") and len(evaluate("attributes.revenue_total_account_code#i#"))>'#wrk_eval("attributes.revenue_total_account_id#i#")#'<cfelse>NULL</cfif>,
					<cfif isdefined("attributes.revenue_capital_expense_item_id#i#") and len(evaluate("attributes.revenue_capital_expense_item_id#i#"))>#evaluate("attributes.revenue_capital_expense_item_id#i#")#<cfelse>NULL</cfif>,
					<cfif isdefined("attributes.revenue_capital_account_code#i#") and len(evaluate("attributes.revenue_capital_account_code#i#"))>'#wrk_eval("attributes.revenue_capital_account_id#i#")#'<cfelse>NULL</cfif>

				)
			</cfquery>
		  </cfif>
		</cfloop>
		<cfif len(paper_number)>
			<!--- Belge numarasi update ediliyor. --->
			<cfquery name="UPD_GEN_PAP" datasource="#DSN3#">
				UPDATE 
					GENERAL_PAPERS
				SET
					CREDIT_NUMBER = #paper_number#
				WHERE
					CREDIT_NUMBER IS NOT NULL
			</cfquery>
		</cfif>
		<!--- money kayıtları --->
		<cfloop from="1" to="#attributes.deger_get_money#" index="i">
			<cfquery name="ADD_MONEY_INFO" datasource="#dsn3#">
				INSERT INTO CREDIT_CONTRACT_MONEY 
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
		<cfif process_type eq 296 and is_account eq 1><!--- Finansal kiralama sözleşmesi ise muhasebe kayıtlarını yapacak --->
			<cfinclude template="add_credit_contract1.cfm">
		</cfif>
		<cfif len(get_process_type.action_file_name)> <!--- secilen islem kategorisine bir action file eklenmisse --->
			<cf_workcube_process_cat 
				process_cat="#form.process_cat#"
				action_id = #MAX_ID.IDENTITYCOL#
				is_action_file = 1
				action_file_name='#get_process_type.action_file_name#'
				action_page='#request.self#?fuseaction=credit.detail_credit_contract&credit_contract_id=#MAX_ID.IDENTITYCOL#'
				action_db_type = '#dsn3#'
				is_template_action_file = '#get_process_type.action_file_from_template#'>
		</cfif>	
	</cftransaction>
</cflock>
<script type="text/javascript">	
	window.location.href='<cfoutput>#request.self#?fuseaction=credit.list_credit_contract&event=upd&credit_contract_id=#MAX_ID.IDENTITYCOL#</cfoutput>';
</script>