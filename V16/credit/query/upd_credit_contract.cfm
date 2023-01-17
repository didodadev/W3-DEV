<cf_date tarih="attributes.credit_date">
<cfset rd_money_value = listfirst(attributes.rd_money, ',')>
<cfquery name="get_process_type" datasource="#dsn3#">
	SELECT PROCESS_TYPE,IS_CARI,IS_ACCOUNT,IS_ACCOUNT_GROUP,ACTION_FILE_NAME,ACTION_FILE_FROM_TEMPLATE FROM SETUP_PROCESS_CAT WHERE PROCESS_CAT_ID = #form.process_cat#
</cfquery>
<cfset process_type = get_process_type.process_type>
<cfset is_account = get_process_type.is_account>
<cfset is_account_group = get_process_type.is_account_group>
<cfset full_paper_no = attributes.credit_no>
<cflock timeout="60">
  <cftransaction>
	<cfquery name="UPD_CREDIT_CONTRACT" datasource="#DSN3#">
		UPDATE
			CREDIT_CONTRACT
		SET
			PROCESS_TYPE = #process_type#,
			PROCESS_CAT = #form.process_cat#,
			COMPANY_ID = <cfif len(attributes.company_id) and len(attributes.company)>#attributes.company_id#<cfelse>NULL</cfif>,
			CREDIT_DATE = #attributes.credit_date#,
			REFERENCE = '#attributes.reference#',
			DETAIL = '#attributes.detail#',
			IS_SCENARIO = <cfif isdefined("attributes.is_scenario")>1<cfelse>0</cfif>,
			IS_ACTIVE = <cfif isdefined("attributes.is_active")>1<cfelse>0</cfif>,
			ACCOUNT_NO = <cfif len(attributes.account_no)>'#attributes.account_no#'<cfelse>NULL</cfif>,
			TOTAL_REVENUE = <cfif len(attributes.total_revenue)>#attributes.total_revenue#<cfelse>0</cfif>,
			OTHER_TOTAL_REVENUE = <cfif len(attributes.other_total_revenue)>#attributes.other_total_revenue#<cfelse>0</cfif>,
			TOTAL_PAYMENT = <cfif len(attributes.total_payment)>#attributes.total_payment#<cfelse>0</cfif>,
			OTHER_TOTAL_PAYMENT = <cfif len(attributes.other_total_payment)>#attributes.other_total_payment#<cfelse>0</cfif>,	
			MONEY_TYPE = '#rd_money_value#',
			AGREEMENT_NO = <cfif len(attributes.agreement_no)>'#attributes.agreement_no#'<cfelse>NULL</cfif>,
			CREDIT_EMP_ID = <cfif len(attributes.credit_emp_id)>'#attributes.credit_emp_id#'<cfelse>NULL</cfif>,
			PROJECT_ID = <cfif len(attributes.related_project_id)>#related_project_id#<cfelse>NULL</cfif>,
			CREDIT_TYPE = <cfif len(attributes.credit_type)>#attributes.credit_type#<cfelse>NULL</cfif>,
			CREDIT_LIMIT_ID = <cfif len(attributes.credit_limit_id)>#attributes.credit_limit_id#<cfelse>NULL</cfif>,
			UPDATE_EMP = #session.ep.userid#,
			UPDATE_IP = '#cgi.remote_addr#',
			UPDATE_DATE = #now()#,
            INTEREST_RATE =	<cfif len(attributes.interest_rate)>#attributes.interest_rate#<cfelse>NULL</cfif>,		
            INTEREST_PERIOD = <cfif attributes.interest_period eq 1>1<cfelseif attributes.interest_period eq 2>2<cfelse>3</cfif>,
			CREDIT_NO = <cfif len(attributes.credit_no)>'#attributes.credit_no#'<cfelse>NULL</cfif>
			   
		WHERE 
			CREDIT_CONTRACT_ID = #attributes.credit_contract_id#
	</cfquery>		
	<!--- Odeme Satirlarinin kaydi --->
	<cfset is_row_payment = attributes.payment_record_num>
	<cfloop from="1" to="#attributes.payment_record_num#" index="i">
	  <cfif evaluate("attributes.payment_row_kontrol#i#")>
		<cfscript>
			form_credit_contract_row_id = evaluate("attributes.payment_credit_contract_row_id#i#");
			form_date = evaluate("attributes.payment_date#i#");
			form_capital_price = evaluate("attributes.payment_capital_price#i#");
			form_interest_price = evaluate("attributes.payment_interest_price#i#");
			form_tax_price = evaluate("attributes.payment_tax_price#i#");
			form_total_price = evaluate("attributes.payment_total_price#i#");
			form_detail = evaluate("attributes.payment_detail#i#");
		</cfscript>
		<cf_date tarih='form_date'>
		<cfif not len(form_credit_contract_row_id)><!--- Bu satir yeni eklendi --->
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
						DETAIL,
						IS_PAID,
						CAPITAL_EXPENSE_ITEM_ID,
                        <cfif process_type eq 296>
                        BORROW,
                        </cfif>
						CAPITAL_ACCOUNT_ID
					)
					VALUES
					(
						1,
						#attributes.credit_contract_id#,
						#form_date#,
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
						'#form_detail#',						
						0,
						<cfif isdefined("attributes.capital_expense_item_id#i#") and len(evaluate("attributes.capital_expense_item_id#i#"))>#evaluate("attributes.capital_expense_item_id#i#")#<cfelse>NULL</cfif>,
						<cfif process_type eq 296>
                        '#wrk_eval("attributes.borrow_id#i#")#',
                        </cfif>
						<cfif isdefined("attributes.capital_account_code#i#") and len(evaluate("attributes.capital_account_code#i#"))>'#wrk_eval("attributes.capital_account_id#i#")#'<cfelse>NULL</cfif>
					)
			</cfquery>
		<cfelse><!--- Bu satir vardi guncellendi --->
			<cfquery name="UPD_CREDIT_CONTRACT_ROW" datasource="#DSN3#">
				UPDATE
					CREDIT_CONTRACT_ROW
				SET
					CREDIT_CONTRACT_TYPE = 1,
					CREDIT_CONTRACT_ID = #attributes.credit_contract_id#,
					PROCESS_DATE = #form_date#,
					CAPITAL_PRICE = #form_capital_price#,						
					INTEREST_PRICE = <cfif len(form_interest_price)>#form_interest_price#<cfelse>0</cfif>,
					TAX_PRICE = <cfif len(form_tax_price)>#form_tax_price#<cfelse>0</cfif>,
					TOTAL_PRICE = #form_total_price#,
					OTHER_MONEY = '#rd_money_value#',
					EXPENSE_CENTER_ID = <cfif isdefined("attributes.expense_center_id#i#") and len(evaluate("attributes.expense_center_id#i#"))>#evaluate("attributes.expense_center_id#i#")#<cfelse>NULL</cfif>,
					EXPENSE_ITEM_ID = <cfif isdefined("attributes.expense_item_id#i#") and len(evaluate("attributes.expense_item_id#i#"))>#evaluate("attributes.expense_item_id#i#")#<cfelse>NULL</cfif>,
					INTEREST_ACCOUNT_ID = <cfif isdefined("attributes.interest_account_code#i#") and len(evaluate("attributes.interest_account_code#i#"))>'#wrk_eval("attributes.interest_account_id#i#")#'<cfelse>NULL</cfif>,
					TOTAL_EXPENSE_ITEM_ID = <cfif isdefined("attributes.total_expense_item_id#i#") and len(evaluate("attributes.total_expense_item_id#i#"))>#evaluate("attributes.total_expense_item_id#i#")#<cfelse>NULL</cfif>,
					TOTAL_ACCOUNT_ID = '#wrk_eval("attributes.total_account_id#i#")#',		
					DETAIL = '#form_detail#',
					CAPITAL_EXPENSE_ITEM_ID = <cfif isdefined("attributes.capital_expense_item_id#i#") and len(evaluate("attributes.capital_expense_item_id#i#"))>#evaluate("attributes.capital_expense_item_id#i#")#<cfelse>NULL</cfif>,
					<cfif process_type eq 296>
                    BORROW = '#wrk_eval("attributes.borrow_id#i#")#',
                    </cfif>
                    CAPITAL_ACCOUNT_ID = <cfif isdefined("attributes.capital_account_code#i#") and len(evaluate("attributes.capital_account_code#i#"))>'#wrk_eval("attributes.capital_account_id#i#")#'<cfelse>NULL</cfif>	
				WHERE
					CREDIT_CONTRACT_ROW_ID = #form_credit_contract_row_id#
			</cfquery>		
		</cfif>
	  <cfelse>
	  	<cfset is_row_payment = is_row_payment - 1>
  		<cfscript>
			form_credit_contract_row_id = evaluate("attributes.payment_credit_contract_row_id#i#");
		</cfscript>
	    <cfif len(form_credit_contract_row_id)><!--- Bu satir silindi --->
			<cfquery name="DEL_CREDIT_CONTRACT_ROW" datasource="#DSN3#">
				DELETE FROM CREDIT_CONTRACT_ROW WHERE CREDIT_CONTRACT_ROW_ID = #form_credit_contract_row_id#
			</cfquery>
		</cfif>
	  </cfif>
	</cfloop>
	
	<!--- Tahsilat Satirlarinin kaydi --->
	<cfset is_row_revenue = attributes.revenue_record_num>
	<cfloop from="1" to="#attributes.revenue_record_num#" index="i">
	  <cfif evaluate("attributes.revenue_row_kontrol#i#")>
		<cfscript>
			form_credit_contract_row_id = evaluate("attributes.revenue_credit_contract_row_id#i#");
			form_date = evaluate("attributes.revenue_date#i#");
			form_capital_price = evaluate("attributes.revenue_capital_price#i#");
			form_interest_price = evaluate("attributes.revenue_interest_price#i#");
			form_tax_price = evaluate("attributes.revenue_tax_price#i#");
			form_total_price = evaluate("attributes.revenue_total_price#i#");
			form_detail = evaluate("attributes.revenue_detail#i#");
		</cfscript>
		<cf_date tarih='form_date'>
		<cfif not len(form_credit_contract_row_id)><!--- Bu satir yeni eklendi --->
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
						IS_PAID,
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
						#attributes.credit_contract_id#,
						#form_date#,
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
		<cfelse><!--- Bu satir vardi guncellendi --->
			<cfquery name="UPD_CREDIT_CONTRACT_ROW" datasource="#DSN3#">
				UPDATE
					CREDIT_CONTRACT_ROW
				SET
					CREDIT_CONTRACT_TYPE = 2,
					CREDIT_CONTRACT_ID = #attributes.credit_contract_id#,
					PROCESS_DATE = #form_date#,
					CAPITAL_PRICE = #form_capital_price#,						
					INTEREST_PRICE = <cfif len(form_interest_price)>#form_interest_price#<cfelse>0</cfif>,
					TAX_PRICE = <cfif len(form_tax_price)>#form_tax_price#<cfelse>0</cfif>,
					TOTAL_PRICE = #form_total_price#,
					OTHER_MONEY = '#rd_money_value#',			
					DETAIL = '#form_detail#',
					EXPENSE_CENTER_ID = <cfif isdefined("attributes.revenue_expense_center_id#i#") and len(evaluate("attributes.revenue_expense_center_id#i#"))>#evaluate("attributes.revenue_expense_center_id#i#")#<cfelse>NULL</cfif>,
					EXPENSE_ITEM_ID = <cfif isdefined("attributes.revenue_expense_item_id#i#") and len(evaluate("attributes.revenue_expense_item_id#i#"))>#evaluate("attributes.revenue_expense_item_id#i#")#<cfelse>NULL</cfif>,
					INTEREST_ACCOUNT_ID = <cfif isdefined("attributes.revenue_interest_account_code#i#") and len(evaluate("attributes.revenue_interest_account_code#i#"))>'#wrk_eval("attributes.revenue_interest_account_id#i#")#'<cfelse>NULL</cfif>,
					TOTAL_EXPENSE_ITEM_ID = <cfif isdefined("attributes.revenue_total_expense_item_id#i#") and len(evaluate("attributes.revenue_total_expense_item_id#i#"))>#evaluate("attributes.revenue_total_expense_item_id#i#")#<cfelse>NULL</cfif>,
					TOTAL_ACCOUNT_ID = <cfif isdefined("attributes.revenue_total_account_code#i#") and len(evaluate("attributes.revenue_total_account_code#i#"))>'#wrk_eval("attributes.revenue_total_account_id#i#")#'<cfelse>NULL</cfif>,			
					CAPITAL_EXPENSE_ITEM_ID = <cfif isdefined("attributes.revenue_capital_expense_item_id#i#") and len(evaluate("attributes.revenue_capital_expense_item_id#i#"))>#evaluate("attributes.revenue_capital_expense_item_id#i#")#<cfelse>NULL</cfif>,
					CAPITAL_ACCOUNT_ID = <cfif isdefined("attributes.revenue_capital_account_code#i#") and len(evaluate("attributes.revenue_capital_account_code#i#"))>'#wrk_eval("attributes.revenue_capital_account_id#i#")#'<cfelse>NULL</cfif>	
				WHERE
					CREDIT_CONTRACT_ROW_ID = #form_credit_contract_row_id#
			</cfquery>		
		</cfif>
	  <cfelse>
	  	<cfset is_row_revenue = is_row_revenue - 1>
  		<cfscript>
			form_credit_contract_row_id = evaluate("attributes.revenue_credit_contract_row_id#i#");
		</cfscript>
	    <cfif len(form_credit_contract_row_id)><!--- Bu satir silindi --->
			<cfquery name="DEL_CREDIT_CONTRACT_ROW" datasource="#DSN3#">
				DELETE FROM CREDIT_CONTRACT_ROW WHERE CREDIT_CONTRACT_ROW_ID = #form_credit_contract_row_id#
			</cfquery>
		</cfif>
	  </cfif>
	</cfloop>
	<cfif is_row_payment lte 0 or is_row_revenue lte 0>
	<!--- Satirlarin tamami silindiginde belgedeki tutarin da guncellenmesi icin eklendi --->
		<cfquery name="upd_contract_total" datasource="#dsn3#">
			UPDATE
				CREDIT_CONTRACT
			SET
				<cfif is_row_revenue lte 0>
					TOTAL_REVENUE = 0,
					OTHER_TOTAL_REVENUE = 0,
				</cfif>
				<cfif is_row_payment lte 0>
					TOTAL_PAYMENT = 0,
					OTHER_TOTAL_PAYMENT = 0,
				</cfif>
				PROCESS_TYPE = #process_type#
			WHERE
				CREDIT_CONTRACT_ID = #attributes.credit_contract_id#
		</cfquery>
	</cfif>
	<!--- money kayıtları --->
	<cfquery name="DEL_MONEY_INFO" datasource="#dsn3#">
		DELETE FROM CREDIT_CONTRACT_MONEY WHERE ACTION_ID = #attributes.credit_contract_id#
	</cfquery>
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
				#attributes.credit_contract_id#,
				'#wrk_eval("attributes.hidden_rd_money_#i#")#',
				#evaluate("attributes.txt_rate2_#i#")#,
				#evaluate("attributes.txt_rate1_#i#")#,
				<cfif evaluate("attributes.hidden_rd_money_#i#") is rd_money_value>1<cfelse>0</cfif>
			)
		</cfquery>
	</cfloop>
	<cfif process_type eq 296 and is_account eq 1><!--- Finansal kiralama sözleşmesi ise muhasebe kayıtlarını yapacak --->
		<cfinclude template="upd_credit_contract1.cfm">
	<cfelse>
		<cfscript>
			muhasebe_sil(action_id:attributes.credit_contract_id, process_type:form.old_process_type ,muhasebe_db: dsn3,muhasebe_db_alias : dsn2);
		</cfscript>
	</cfif>
	<cfif len(get_process_type.action_file_name)> <!--- secilen islem kategorisine bir action file eklenmisse --->
		<cf_workcube_process_cat 
			process_cat="#form.process_cat#"
			action_id = #attributes.credit_contract_id#
			is_action_file = 1
			action_file_name='#get_process_type.action_file_name#'
			action_page='#request.self#?fuseaction=credit.upd_credit_contract&credit_contract_id=#attributes.credit_contract_id#'
			action_db_type = '#dsn3#'
			is_template_action_file = '#get_process_type.action_file_from_template#'>
	</cfif>	
  </cftransaction>
</cflock>
<script type="text/javascript">	
	window.location.href='<cfoutput>#request.self#?fuseaction=credit.list_credit_contract&event=upd&credit_contract_id=#attributes.credit_contract_id#</cfoutput>';
</script>