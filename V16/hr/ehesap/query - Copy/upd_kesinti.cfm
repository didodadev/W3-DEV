<cfif isdefined("attributes.METHOD") and (attributes.METHOD eq 2) and (attributes.amount gt 100)>
  <script type="text/javascript">
    alert("Miktar % 100 den fazla olamaz, kontrol edin !");
    history.back();
  </script>
  <cfabort>
<cfelseif isdefined("attributes.is_inst_avans") and (attributes.is_inst_avans eq 1) and isdefined("attributes.METHOD") and (attributes.METHOD eq 2)>
	<script type="text/javascript">
    alert("Taksitlendirmede yuzde yöntemi  kullanilmaz kontrol edin !");
    history.back();
    </script>
    <cfabort>
</cfif>
<CFLOCK name="#CREATEUUID()#" timeout="20">
	<CFTRANSACTION>
		<cfquery name="upd_odenek" datasource="#dsn#">
			UPDATE 
				SETUP_PAYMENT_INTERRUPTION
			SET
				STATUS = <cfif isdefined("attributes.is_active")>1<cfelse>0</cfif>,
				IS_DEMAND = <cfif isdefined("attributes.is_demand")>1<cfelse>0</cfif>,
				COMMENT_PAY = '#FORM.comment#',
				PERIOD_PAY = #FORM.PERIOD#,
				METHOD_PAY = #FORM.METHOD#,
				AMOUNT_PAY = #FORM.AMOUNT#,
				SHOW = <cfif isDefined("FORM.SHOW")>1, <cfelse>0,</cfif>
				CALC_DAYS = #FORM.CALC_DAYS#,
				<cfif session.ep.ehesap>
				IS_EHESAP = <cfif isDefined("FORM.IS_EHESAP")>1,<cfelse>0,</cfif>
				</cfif>
				IS_INST_AVANS = <cfif isDefined("FORM.is_inst_avans")>1, <cfelse>0,</cfif>
				START_SAL_MON = #FORM.start_sal_mon#,
				END_SAL_MON = #FORM.end_sal_mon#,
				IS_ODENEK = 0,
				FROM_SALARY = #form.from_salary#,				
				ACCOUNT_CODE =  <cfif isDefined("attributes.account_code") and len(attributes.account_code)>'#attributes.account_code#'<cfelse>NULL</cfif>,
				ACCOUNT_NAME =  <cfif isDefined("attributes.account_name") and len(attributes.account_name)>'#attributes.account_name#'<cfelse>NULL</cfif>,
				COMPANY_ID = <cfif isDefined("attributes.company_id") and len(attributes.company_id) and len(attributes.member_name)>#attributes.company_id#<cfelse>NULL</cfif>,
				CONSUMER_ID = <cfif isDefined("attributes.consumer_id") and len(attributes.consumer_id) and len(attributes.member_name)>#attributes.consumer_id#<cfelse>NULL</cfif>,
				ACC_TYPE_ID = <cfif isDefined("attributes.acc_type_id") and len(attributes.acc_type_id)>#attributes.acc_type_id#<cfelse>NULL</cfif>,
				MONEY = '#attributes.money#',
				TAX = #attributes.tax#,
				UPDATE_EMP = #session.ep.userid#,
				UPDATE_DATE = #now()#,
				UPDATE_IP = '#cgi.REMOTE_ADDR#',
				IS_DISCIPLINARY_PUNISHMENT = <cfif isDefined("attributes.is_disciplinary_punishment") and len(attributes.is_disciplinary_punishment)><cfqueryparam cfsqltype="cf_sql_bit" value="#attributes.is_disciplinary_punishment#"><cfelse>0</cfif>,
				IS_UNION_INFORMATION = <cfif isDefined("attributes.is_union_information") and len(attributes.is_union_information)><cfqueryparam cfsqltype="cf_sql_bit" value="#attributes.is_union_information#"><cfelse>0</cfif>,
				UNION_INFORMATION_NAME = <cfif isDefined("attributes.union_information_name") and len(attributes.union_information_name)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#attributes.union_information_name#"><cfelse>NULL</cfif>,
				UNION_INFORMATION_ADDRESS = <cfif isDefined("attributes.union_information_address") and len(attributes.union_information_address)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#attributes.union_information_address#"><cfelse>NULL</cfif>,
				UNION_INFORMATION_BANK_NAME	= <cfif isDefined("attributes.union_information_bank_name") and len(attributes.union_information_bank_name)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#attributes.union_information_bank_name#"><cfelse>NULL</cfif>,
				UNION_INFORMATION_BRANCH_NAME = <cfif isDefined("attributes.union_information_branch_name") and len(attributes.union_information_branch_name)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#attributes.union_information_branch_name#"><cfelse>NULL</cfif>,
				UNION_INFORMATION_ACCOUNT_NAME = <cfif isDefined("attributes.union_information_account_name") and len(attributes.union_information_account_name)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#attributes.union_information_account_name#"><cfelse>NULL</cfif>,
				IS_NET_TO_GROSS = <cfif isDefined("attributes.is_net_to_gross") and len(attributes.is_net_to_gross) and attributes.from_salary eq 1><cfqueryparam cfsqltype="cf_sql_bit" value="#attributes.is_net_to_gross#"><cfelse>0</cfif> 
			WHERE
				ODKES_ID = #attributes.ODKES_ID#
		</cfquery>
	</CFTRANSACTION>
</CFLOCK>
<cfquery name="GET_BUDGET_ACCOUNTS" datasource="#DSN#">
	SELECT * FROM SETUP_PAYMENT_INTERRUPTION_BUDGET_ACCOUNTS WHERE ODKES_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate("attributes.odkes_id")#">
</cfquery>
<cfif GET_BUDGET_ACCOUNTS.recordcount>
	<cfquery name="DEL_BUDGET_ACCOUNTS" datasource="#DSN#">
		DELETE FROM SETUP_PAYMENT_INTERRUPTION_BUDGET_ACCOUNTS WHERE ODKES_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate("attributes.odkes_id")#">
	</cfquery>
</cfif>
<cfif len(attributes.record_num) and attributes.record_num neq ''>
	<cfloop from="1" to="#attributes.record_num#" index="i">
		<cfif isdefined("attributes.row_kontrol#i#") and evaluate("attributes.row_kontrol#i#") eq 1>
			<cfquery name="ADD_BUDGET_ACCOUNTS" datasource="#DSN#">
				INSERT INTO SETUP_PAYMENT_INTERRUPTION_BUDGET_ACCOUNTS
				(
					ODKES_ID
					,EXPENSE_CENTER_ID
					,EXPENSE_ITEM_ID
					,OUR_COMPANY_ID
					,PERIOD_YEAR
				<!---	,ACCOUNT_CODE --->
					,RECORD_EMP
					,RECORD_IP
					,RECORD_DATE
				)
				VALUES
				(<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.odkes_id#">
				, <cfif len(evaluate("attributes.expense_center_id#i#"))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate("attributes.expense_center_id#i#")#"><cfelse>NULL</cfif>
				,<cfif len(evaluate("attributes.expense_item_id#i#"))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate("attributes.expense_item_id#i#")#"><cfelse>NULL</cfif>
				,<cfif len(evaluate("attributes.our_company_id#i#"))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate("attributes.our_company_id#i#")#"><cfelse>NULL</cfif>
				,<cfif len(evaluate("attributes.period_year#i#"))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate("attributes.period_year#i#")#"><cfelse>NULL</cfif>
				<!---,<cfif len(evaluate("attributes.account_id#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate("attributes.account_id#i#")#"><cfelse>NULL</cfif>--->
				,<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
				,<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.REMOTE_ADDR#">
				,<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
				)    
			</cfquery>
		</cfif>
	</cfloop>
</cfif>
<script type="text/javascript">
  	window.location.href ="<cfoutput>#request.self#?fuseaction=ehesap.list_kesinti&event=upd&odkes_id=#attributes.odkes_id#</cfoutput>";
</script>