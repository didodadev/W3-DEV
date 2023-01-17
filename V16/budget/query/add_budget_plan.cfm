<cfif isdefined("form.active_period") and form.active_period neq session.ep.period_id>
	<script type="text/javascript">
		alert("İşlem Yapmak İstediğiniz Muhasebe Dönemi ile Aktif Muhasebe Döneminiz Farklı. Muhasebe Döneminizi Kontrol Ediniz!");
		window.location.href='<cfoutput>#request.self#</cfoutput>?fuseaction=budget.add_budget_plan&from_plan_list';
	</script>
	<cfabort>
</cfif>
<cf_date tarih = 'attributes.record_date'>
<cf_date tarih = 'attributes.due_date'>
<cfset wrk_id = dateformat(now(),'YYYYMMDD')&timeformat(now(),'HHmmss')&'_#session.ep.userid#_'&round(rand()*100)>
<cfquery name="get_process_type" datasource="#dsn2#">
	SELECT PROCESS_TYPE,IS_CARI,IS_ACCOUNT,IS_ACCOUNT_GROUP,IS_BUDGET FROM #dsn3#.SETUP_PROCESS_CAT WHERE PROCESS_CAT_ID = #form.process_cat#
</cfquery>

<cfscript>
	process_cat = form.process_cat;
	is_cari = get_process_type.is_cari;
	if(isdefined("attributes.invoice_id") and len(attributes.invoice_id)) { // faturadan gelirse muhasebe yapmasın.
		is_account = 0;
	} else {
		is_account = get_process_type.is_account;
	}
	
	is_budget = get_process_type.is_budget;
	is_account_group = get_process_type.is_account_group;
	process_type = get_process_type.process_type;
	rd_money_value = attributes.rd_money;
	currency_multiplier = '';
	currency_multiplier2 = '';
	if(isDefined('attributes.kur_say') and len(attributes.kur_say))
		for(mon=1;mon lte attributes.kur_say;mon=mon+1)
		{
			if(evaluate("attributes.hidden_rd_money_#mon#") is rd_money_value)
				currency_multiplier = (evaluate('attributes.txt_rate2_#mon#'))/(evaluate('attributes.txt_rate1_#mon#'));
			if(evaluate("attributes.hidden_rd_money_#mon#") is session.ep.money2)
				currency_multiplier2 = (evaluate('attributes.txt_rate2_#mon#'))/(evaluate('attributes.txt_rate1_#mon#'));
		}
</cfscript>
<cf_papers paper_type="budget_plan">
<cflock name="#CreateUUID()#" timeout="60">
	<cftransaction>
		<cfquery name="ADD_BUDGET_PLAN" datasource="#dsn2#" result="MAX_ID">
			INSERT INTO
				#dsn_alias#.BUDGET_PLAN
			(
				BUDGET_ID,
				PROCESS_STAGE,
				PROCESS_TYPE,
				PROCESS_CAT,
				PAPER_NO,
				BUDGET_PLAN_DATE,
				BUDGET_PLANNER_EMP_ID,
				DETAIL,
				INCOME_TOTAL,
				EXPENSE_TOTAL,
				DIFF_TOTAL,
				INCOME_TOTAL_2,
				EXPENSE_TOTAL_2,
				DIFF_TOTAL_2,
				OTHER_INCOME_TOTAL,
				OTHER_EXPENSE_TOTAL,
				OTHER_DIFF_TOTAL,
				OTHER_MONEY,
				IS_SCENARIO,
				BRANCH_ID,
				ACC_DEPARTMENT_ID,
				RECORD_DATE,
				RECORD_IP,
				RECORD_EMP,
				OUR_COMPANY_ID,
				PERIOD_ID,
                DOCUMENT_TYPE,
                PAYMENT_METHOD,
                DUE_DATE,
				INVOICE_ID,
				IS_TRANSFER,
				DEMAND_ID
			)
			VALUES
			(
				<cfif len(attributes.budget_id)>#attributes.budget_id#<cfelse>NULL</cfif>,
				#attributes.process_stage#,
				#process_type#,
				#process_cat#,
				'#attributes.paper_number#',
				#attributes.record_date#,
				<cfif len(attributes.employee_id) and len(attributes.employee_name)>#attributes.employee_id#,<cfelse>NULL,</cfif>
				<cfif len(attributes.detail)>'#left(attributes.detail,300)#',<cfelse>NULL,</cfif>
				#income_total_amount#,
				#expense_total_amount#,
				<cfif isdefined("attributes.diff_total_amount") and len(attributes.diff_total_amount)>#diff_total_amount#<cfelse>NULL</cfif>,
				<cfif len(currency_multiplier2)>#wrk_round(income_total_amount/currency_multiplier2)#<cfelse>NULL</cfif>,
				<cfif len(currency_multiplier2)>#wrk_round(expense_total_amount/currency_multiplier2)#<cfelse>NULL</cfif>,
				<cfif len(currency_multiplier2) and isdefined("attributes.diff_total_amount") and len(diff_total_amount)>#wrk_round(diff_total_amount/currency_multiplier2)#<cfelse>NULL</cfif>,
				#other_income_total_amount#,
				#other_expense_total_amount#,
				<cfif isdefined("attributes.other_diff_total_amount") and len(attributes.other_diff_total_amount)>#other_diff_total_amount#<cfelse>NULL</cfif>,
				'#rd_money#',
				<cfif isDefined("attributes.is_scenario")>1,<cfelse>0,</cfif>
				<cfif isdefined("attributes.acc_branch_id") and len(attributes.acc_branch_id)>#attributes.acc_branch_id#,<cfelse>NULL,</cfif>
				<cfif isdefined("attributes.acc_department_id") and len(attributes.acc_department_id)>#attributes.acc_department_id#,<cfelse>NULL,</cfif>
				#now()#,
				'#cgi.remote_addr#',
				#session.ep.userid#,
				#session.ep.company_id#,
				#session.ep.period_id#,
                <cfif isdefined("attributes.document_type") and len(attributes.document_type)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.document_type#">,<cfelse>NULL,</cfif>
                <cfif isdefined("attributes.payment_type") and len(attributes.payment_type)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.payment_type#">,<cfelse>NULL,</cfif>
                <cfif isdefined("attributes.due_date") and len(attributes.due_date) and (attributes.document_type eq -1 or attributes.document_type eq -3)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.due_date#">,<cfelse>NULL,</cfif>
				<cfif isdefined("attributes.invoice_id") and len(attributes.invoice_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.invoice_id#"><cfelse>NULL</cfif>,
				<cfif isdefined("attributes.is_transfer") and len(attributes.is_transfer)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.is_transfer#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" null="yes" value="NULL"></cfif>,
				<cfif isdefined("attributes.demand_id") and len(attributes.demand_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.demand_id#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" null="yes" value="NULL"></cfif>
			)
		</cfquery>
		<cfset GET_MAX_ID.MAX_ID = MAX_ID.IDENTITYCOL>
		<cfif isdefined("attributes.demand_id") and len(attributes.demand_id)>
			<cfquery name="UPD_GENERAL_PAPERS" datasource="#dsn2#">
				UPDATE 
					BUDGET_TRANSFER_DEMAND_ROWS
				SET
					TRANSFER_STATUS = 1
				WHERE
					DEMAND_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.demand_id#">
			</cfquery>
		</cfif>
		<!--- bütçe gelir/gider planı --->
		<cfloop from="1" to="#attributes.record_num#" index="i">
			<cfif isdefined("attributes.row_kontrol#i#") and evaluate("attributes.row_kontrol#i#")>
				<cfscript>
					"attributes.acc_type_id#i#" = '';
					if(listlen(evaluate("attributes.employee_id#i#"),'_') eq 2)
					{
						"attributes.acc_type_id#i#" = listlast(evaluate("attributes.employee_id#i#"),'_');
						"attributes.employee_id#i#" = listfirst(evaluate("attributes.employee_id#i#"),'_');
					}
				</cfscript>
                <cfif isdefined("attributes.expense_date#i#")>
                    <cf_date tarih='attributes.expense_date#i#'>
                </cfif>
				
				<cfset detail_info =  "#left(evaluate("attributes.row_detail#i#"),300)#"><!--- tırnaklı girilmişlerde sorun oldugu için tekrar setedilir --->
				<cfquery name="ADD_BUDGET_PLAN_ROW" datasource="#dsn2#">
					INSERT INTO
						#dsn_alias#.BUDGET_PLAN_ROW
						(
							BUDGET_PLAN_ID,
							PLAN_DATE,
							DETAIL,
							EXP_INC_CENTER_ID,
							BUDGET_ITEM_ID,
							BUDGET_ACCOUNT_CODE,
							ACTIVITY_TYPE_ID,
							RELATED_EMP_ID,
							RELATED_EMP_TYPE,
							ROW_TOTAL_INCOME,
							ROW_TOTAL_EXPENSE,
							ROW_TOTAL_DIFF,
							ROW_TOTAL_INCOME_2,
							ROW_TOTAL_EXPENSE_2,
							ROW_TOTAL_DIFF_2,
							OTHER_ROW_TOTAL_INCOME,
							OTHER_ROW_TOTAL_EXPENSE,
							OTHER_ROW_TOTAL_DIFF,
							WORKGROUP_ID,
							IS_PAYMENT,
							PROJECT_ID ,
							ACC_TYPE_ID,
							ASSETP_ID
						)
						VALUES
						(
							#GET_MAX_ID.MAX_ID#,
                            <cfif isdefined("attributes.expense_date#i#") and Len(evaluate("attributes.expense_date#i#"))>#evaluate("attributes.expense_date#i#")#<cfelseif len(attributes.record_date)>#attributes.record_date#<cfelse>NULL</cfif>,	<!--- satirda tarih yoksa, belge kayit tarihinden alinsin --->
							'#detail_info#',
							<cfif isdefined("attributes.expense_center_id#i#") and len(evaluate("attributes.expense_center_id#i#"))>#evaluate("attributes.expense_center_id#i#")#<cfelse>NULL</cfif>,
							<cfif isdefined("attributes.expense_item_name#i#") and len(evaluate("attributes.expense_item_name#i#"))>#evaluate("attributes.expense_item_id#i#")#<cfelse>NULL</cfif>,
							<cfif isdefined("attributes.account_id#i#") and len(evaluate("attributes.account_id#i#")) and isdefined("attributes.account_code#i#") and len(evaluate("attributes.account_code#i#"))>'#wrk_eval("attributes.account_id#i#")#'<cfelse>NULL</cfif>,
							<cfif isdefined("attributes.activity_type#i#") and len(evaluate("attributes.activity_type#i#"))>#evaluate("attributes.activity_type#i#")#,<cfelse>NULL,</cfif>
							<cfif isdefined("attributes.authorized#i#") and len(evaluate("attributes.authorized#i#"))>
								<cfif isdefined("attributes.member_type#i#") and len(evaluate("attributes.member_type#i#")) and evaluate("attributes.member_type#i#") is 'partner' and isdefined("attributes.company_id#i#") and len(evaluate("attributes.company_id#i#"))>
									#evaluate("attributes.company_id#i#")#,
								<cfelseif isdefined("attributes.member_type#i#") and len(evaluate("attributes.member_type#i#")) and evaluate("attributes.member_type#i#") is 'consumer' and isdefined("attributes.consumer_id#i#") and len(evaluate("attributes.consumer_id#i#"))> 
									#evaluate("attributes.consumer_id#i#")#,
								<cfelseif isdefined("attributes.member_type#i#") and len(evaluate("attributes.member_type#i#")) and evaluate("attributes.member_type#i#") is 'employee' and isdefined("attributes.employee_id#i#") and len(evaluate("attributes.employee_id#i#"))>
									#evaluate("attributes.employee_id#i#")#,
								</cfif>
							<cfelse>
								NULL,
							</cfif>
							<cfif isdefined("attributes.member_type#i#") and isdefined("attributes.authorized#i#") and len(evaluate("attributes.member_type#i#")) and len(evaluate("attributes.authorized#i#"))>'#wrk_eval("attributes.member_type#i#")#',<cfelse>NULL,</cfif>
							#evaluate("attributes.income_total#i#")#,
							#evaluate("attributes.expense_total#i#")#,
							<cfif isdefined("attributes.diff_total#i#")>#evaluate("attributes.diff_total#i#")#<cfelse>NULL</cfif>,
							<cfif isdefined("currency_multiplier2") and len(currency_multiplier2)>#wrk_round(evaluate("attributes.income_total#i#")/currency_multiplier2)#<cfelse>NULL</cfif>,
							<cfif isdefined("currency_multiplier2") and len(currency_multiplier2)>#wrk_round(evaluate("attributes.expense_total#i#")/currency_multiplier2)#<cfelse>NULL</cfif>,
							<cfif isdefined("attributes.diff_total#i#") and isdefined("currency_multiplier2") and len(currency_multiplier2)>#wrk_round(evaluate("attributes.diff_total#i#")/currency_multiplier2)#<cfelse>NULL</cfif>,
							#wrk_round(evaluate("attributes.income_total#i#")/currency_multiplier,4)#,
							#wrk_round(evaluate("attributes.expense_total#i#")/currency_multiplier,4)#,
							<cfif isdefined("attributes.diff_total#i#")>#wrk_round(evaluate("attributes.diff_total#i#")/currency_multiplier,4)#<cfelse>NULL</cfif>,
							<cfif isdefined("attributes.workgroup_id#i#") and len(evaluate("attributes.workgroup_id#i#"))>#evaluate("attributes.workgroup_id#i#")#,<cfelse>NULL,</cfif>
							<cfif isdefined("attributes.is_payment#i#")>1<cfelse>0</cfif>,
							<cfif isdefined("attributes.project_id#i#") and len(evaluate("attributes.project_id#i#")) and len(evaluate("attributes.project_head#i#"))>#evaluate("attributes.project_id#i#")#<cfelse>NULL</cfif>,
							<cfif len(evaluate("attributes.acc_type_id#i#"))>#evaluate("attributes.acc_type_id#i#")#<cfelse>NULL</cfif>,
							<cfif isdefined("attributes.assetp_id#i#") and len(evaluate("attributes.assetp_id#i#")) and len(evaluate("attributes.assetp_name#i#"))>#evaluate("attributes.assetp_id#i#")#<cfelse>NULL</cfif>
						)
				</cfquery>
				<cfquery name="get_max" datasource="#dsn2#">
					SELECT MAX(BUDGET_PLAN_ROW_ID) AS MAX_ID FROM #dsn_alias#.BUDGET_PLAN_ROW
				</cfquery>
			</cfif>
		</cfloop>
		<!--- money kayıtları --->
		<cfloop from="1" to="#attributes.kur_say#" index="i">
			<cfquery name="ADD_MONEY_INFO" datasource="#dsn2#">
				INSERT INTO
					#dsn_alias#.BUDGET_PLAN_MONEY 
				(
					ACTION_ID,
					MONEY_TYPE,
					RATE2,
					RATE1,
					IS_SELECTED
				)
				VALUES
				(
					 #GET_MAX_ID.MAX_ID#,
					'#wrk_eval("attributes.hidden_rd_money_#i#")#',
					 #evaluate("attributes.txt_rate2_#i#")#,
					 #evaluate("attributes.txt_rate1_#i#")#,
					<cfif evaluate("attributes.hidden_rd_money_#i#") is rd_money>1<cfelse>0</cfif>
				)
			</cfquery>
		</cfloop>
		<cfquery name="get_last_rows" datasource="#dsn2#">
			SELECT
				ROW_TOTAL_EXPENSE AS ACTION_VALUE_EXP,
				OTHER_ROW_TOTAL_EXPENSE AS OTHER_MONEY_VALUE_EXP,
				ROW_TOTAL_INCOME AS ACTION_VALUE_INC,
				OTHER_ROW_TOTAL_INCOME AS OTHER_MONEY_VALUE_INC,
				PLAN_DATE,
				RELATED_EMP_ID,
				RELATED_EMP_TYPE,
				EXP_INC_CENTER_ID,
				BUDGET_ITEM_ID,
				BUDGET_PLAN_ROW_ID,
				BUDGET_ACCOUNT_CODE,
				DETAIL,
				PROJECT_ID,
				ACTIVITY_TYPE_ID,
				ACC_TYPE_ID
			FROM
				#dsn_alias#.BUDGET_PLAN_ROW
			WHERE
				BUDGET_PLAN_ID = #get_max_id.max_id#
		</cfquery>
		<!--- cari - muhasebe -bütçe--->
		<cfinclude template="add_budget_plan_1.cfm">
		<!--- Belge No update ediliyor --->
		<cfif listlen(attributes.paper_number,'-') eq 2 and isNumeric(ListLast(attributes.paper_number,'-'))>
			<cfquery name="UPD_GENERAL_PAPERS" datasource="#dsn2#">
				UPDATE 
					#dsn3_alias#.GENERAL_PAPERS
				SET
					BUDGET_PLAN_NUMBER = '#ListLast(attributes.paper_number,'-')#'
				WHERE
					BUDGET_PLAN_NUMBER IS NOT NULL
			</cfquery>
		</cfif>
	</cftransaction>
</cflock>
<cf_workcube_process 
	is_upd='1' 
	data_source='#dsn2#' 
	old_process_line='0'
	process_stage='#attributes.process_stage#' 
	record_member='#session.ep.userid#' 
	record_date='#now()#' 
	action_table='BUDGET_PLAN'
	action_column='BUDGET_PLAN_ID'
	action_id='#GET_MAX_ID.MAX_ID#'
	action_page='#request.self#?fuseaction=budget.list_plan_rows&event=upd&budget_plan_id=#GET_MAX_ID.MAX_ID#' 
	warning_description='Bütçe Planı: #GET_MAX_ID.MAX_ID#'>

<cfset attributes.actionId=GET_MAX_ID.MAX_ID/>

<cfif not (isDefined('from_invoice') and from_invoice eq 1)>
	<script type="text/javascript">
		window.location.href="<cfoutput>#request.self#?fuseaction=budget.list_plan_rows&event=upd&budget_plan_id=#GET_MAX_ID.MAX_ID#</cfoutput>";
	</script>
</cfif>
