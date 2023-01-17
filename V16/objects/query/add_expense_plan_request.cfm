<cf_date tarih = 'attributes.expense_date'>
<cf_date tarih = "attributes.basket_due_value_date_">
<cfif isDefined("attributes.basket_due_value_date_") and len(attributes.basket_due_value_date_)>
	<cfset expense_due_date = attributes.basket_due_value_date_>
<cfelse>
	<cfset expense_due_date = attributes.expense_date>
</cfif>
<cf_papers paper_type="expenditure_request">
<cfset system_paper_no = paper_code & '-' & paper_number>
<cfscript>
	rd_money_value = listfirst(attributes.rd_money, ',');
</cfscript>
<cfif listlen(attributes.expense_employee_id,'_') eq 2>
	<cfset acc_type_id = listLast(attributes.expense_employee_id,'_')>
	<cfset attributes.expense_employee_id = listFirst(attributes.expense_employee_id,'_')>
<cfelse>
	<cfset acc_type_id = ''>
</cfif>

<cflock timeout="60" name="#CreateUUID()#">
	<cftransaction>	
		<cfquery name="add_expense_total_cost" datasource="#dsn2#" result="MAX_ID">
			INSERT INTO
				EXPENSE_ITEM_PLAN_REQUESTS
			(
				IS_BANK,
				IS_CASH,
				EXPENSE_CASH_ID,
				OTHER_MONEY_AMOUNT,
				OTHER_MONEY_KDV,
				OTHER_MONEY_NET_TOTAL,
				OTHER_MONEY,
				PAYMETHOD_ID,
				PAPER_NO,
				EMP_ID,
				EXPENSE_DATE,
				PAPER_TYPE,
				SYSTEM_RELATION,
				DETAIL,
				RECORD_DATE,
				RECORD_EMP,
				RECORD_IP,
				TOTAL_AMOUNT,
				NET_TOTAL_AMOUNT,
				NET_KDV_AMOUNT,
				SALES_COMPANY_ID,
				SALES_PARTNER_ID,
				SALES_CONSUMER_ID,
				EXPENSE_STAGE,
                PROJECT_ID,
				BRANCH_ID,
				ACC_TYPE_ID,
				DUE_DATE
			)
			VALUES
			(
				<cfif isdefined("attributes.bank")>1<cfelse>0</cfif>,
				<cfif isdefined("attributes.cash")>1<cfelse>0</cfif>,
				<cfif isdefined("attributes.cash")>#attributes.kasa#<cfelseif isdefined("attributes.bank")>#attributes.banka#<cfelse>NULL</cfif>,
				<cfif len(attributes.other_total_amount)>#filternum(attributes.other_total_amount,8)#<cfelse>NULL</cfif>,
				<cfif len(attributes.other_kdv_total_amount)>#filternum(attributes.other_kdv_total_amount,8)#<cfelse>NULL</cfif>,
				<cfif len(attributes.other_net_total_amount)>#filternum(attributes.other_net_total_amount,8)#<cfelse>NULL</cfif>,
				<cfif len(rd_money_value)><cfqueryparam cfsqltype="cf_sql_varchar" value="#rd_money_value#"><cfelse>NULL</cfif>,
				<cfif isdefined("attributes.paymethod") and len(attributes.paymethod)>#attributes.paymethod#<cfelse>NULL</cfif>,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#system_paper_no#">,
				<cfif len(attributes.expense_employee) and len(attributes.expense_employee_id)>#attributes.expense_employee_id#<cfelse>NULL</cfif>,
				<cfif len(attributes.expense_date)>#attributes.expense_date#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.expense_paper_type") and len(attributes.expense_paper_type)>#attributes.expense_paper_type#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.system_relation") and len(attributes.system_relation)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.system_relation#"><cfelse>NULL</cfif>,
				<cfif len(attributes.detail)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.detail#"><cfelse>NULL</cfif>,
				#now()#,
				#session.ep.userid#,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
				#filternum(attributes.total_amount,8)#,
				#filternum(attributes.kdv_total_amount,8)#,
				#filternum(attributes.net_total_amount,8)#,
				<cfif isdefined("attributes.sales_company_id") and len(sales_member_type) and sales_member_type eq 'partner'>
					<cfif len(attributes.sales_company) and len(attributes.sales_company_id)>#attributes.sales_company_id#<cfelse>NULL</cfif>,
					<cfif len(attributes.sales_partner) and len(attributes.sales_partner_id)>#attributes.sales_partner_id#<cfelse>NULL</cfif>,
					NULL,
				<cfelseif isdefined("attributes.sales_company_id") and len(sales_member_type) and sales_member_type eq 'consumer'>
					NULL,
					NULL,
					<cfif len(attributes.sales_partner) and len(attributes.sales_partner_id)>#attributes.sales_partner_id#<cfelse>NULL</cfif>,
				<cfelse>
					NULL,
					NULL,
					NULL,
				</cfif>
				#attributes.process_stage#,
                <cfif isdefined("attributes.project_id") and len(attributes.project_id) and len(attributes.project_head)>#attributes.project_id#<cfelse>NULL</cfif>,
				<cfif listlen(session.ep.user_location,"-") gte 2> #listgetat(session.ep.user_location,2,'-')#<cfelse>NULL</cfif>,
				<cfif isdefined("acc_type_id") and len(acc_type_id)>#acc_type_id#<cfelse>NULL</cfif>,
				<cfif len(expense_due_date)>#expense_due_date#<cfelse>NULL</cfif>
			)
		</cfquery>
		<cfif len(attributes.record_num) and attributes.record_num neq "">
			<cfloop from="1" to="#attributes.record_num#" index="i">
				<cfif evaluate("attributes.row_kontrol#i#")>
					<cfif isdefined("attributes.expense_date#i#") and isdefined("attributes.expense_date#i#")>
						<cf_date tarih="attributes.expense_date#i#">
					</cfif>
					<cfscript>
						form_row_detail = evaluate("attributes.row_detail#i#");
						form_expense_item_id = evaluate("attributes.expense_item_id#i#");
						form_expense_center_id = evaluate("attributes.expense_center_id#i#");
						if(isdefined("attributes.activity_type#i#"))
							form_activity_type = evaluate("attributes.activity_type#i#");
						else
							form_activity_type = '';
						if(isdefined("attributes.member_id#i#"))
						{
							form_member_id = evaluate("attributes.member_id#i#");
							form_company_id = evaluate("attributes.company_id#i#");
							form_company = evaluate("attributes.company#i#");
							form_authorized = evaluate("attributes.authorized#i#");
							form_member_type = evaluate("attributes.member_type#i#");
						}
						else
						{
							form_member_id = '';
							form_company_id = '';
							form_company = '';
							form_authorized = '';
							form_member_type = '';
						}
						if(isdefined("attributes.asset_id#i#"))
						{
							form_asset = evaluate("attributes.asset#i#");
							form_asset_id = evaluate("attributes.asset_id#i#");
						}
						else
						{
							form_asset = '';
							form_asset_id = '';
						}
						if(isdefined("attributes.project_id#i#"))
						{
							form_project_id = evaluate("attributes.project_id#i#");
							form_project = evaluate("attributes.project#i#");
						}
						else
						{
							form_project_id = '';
							form_project = '';
						}
						form_total = evaluate("attributes.total#i#");
						if(isdefined("attributes.money_id#i#"))
							form_money_id = evaluate("attributes.money_id#i#");
						else
							form_money_id = session.ep.money;
						form_kdv_total = evaluate("attributes.kdv_total#i#");
						form_net_total = evaluate("attributes.net_total#i#");
						form_money_1 = listgetat(form_money_id, 1, ',');
						form_money_2 = listgetat(form_money_id, 2, ',');
						form_money_3 = listgetat(form_money_id, 3, ',');
						form_tax_rate = evaluate("attributes.tax_rate#i#");
						if(isdefined("attributes.other_net_total#i#"))
							form_other_net_total = evaluate("attributes.other_net_total#i#");
						else
							form_other_net_total = form_net_total;
						if(isdefined("attributes.product_id#i#"))
						{
							form_product_id = evaluate("attributes.product_id#i#");
							form_stock_id = evaluate("attributes.stock_id#i#");
							form_product_name = evaluate("attributes.product_name#i#");
							form_stock_unit = evaluate("attributes.stock_unit#i#");
							form_stock_unit_id = evaluate("attributes.stock_unit_id#i#");
						}
						else
						{
							form_product_id = '';
							form_stock_id = '';
							form_product_name = '';
							form_stock_unit = '';
							form_stock_unit_id = '';
						}
						form_quantity = evaluate("attributes.quantity#i#");
					</cfscript>
					<cfquery name="add_expense_rows" datasource="#dsn2#">
						INSERT INTO
							EXPENSE_ITEM_PLAN_REQUESTS_ROWS
						(
							EXPENSE_ID,
							EXPENSE_DATE,
							EXPENSE_CENTER_ID,
							EXPENSE_ITEM_ID,
							PAPER_TYPE,
							DETAIL,
							SYSTEM_RELATION,
							IS_INCOME,
							ACTION_ID,
							EXPENSE_EMPLOYEE,
							COMPANY_ID,
							COMPANY_PARTNER_ID,
							MEMBER_TYPE,
							PYSCHICAL_ASSET_ID,
							PROJECT_ID,
							ACTIVITY_TYPE,
							AMOUNT,
							AMOUNT_KDV,
							TOTAL_AMOUNT,
							MONEY_CURRENCY_ID,
							RATE1,
							RATE2,
							KDV_RATE,
							OTHER_MONEY_VALUE,
							RATE,
							PRODUCT_ID,
							STOCK_ID,
							PRODUCT_NAME,
							QUANTITY,
							UNIT,
							UNIT_ID,
							RECORD_EMP,
							RECORD_IP,
							WORK_ID,
							OPP_ID,
							RECORD_DATE
						)
						VALUES
						(
							#MAX_ID.IDENTITYCOL#,
							<cfif isdefined("attributes.expense_date#i#") and isdefined("attributes.expense_date#i#")>#evaluate("attributes.expense_date#i#")#,<cfelseif len(attributes.expense_date)>#attributes.expense_date#,<cfelse>NULL,</cfif>
							<cfif len(form_expense_center_id)>#form_expense_center_id#<cfelse>NULL</cfif>,
							<cfif len(form_expense_item_id)>#form_expense_item_id#<cfelse>NULL</cfif>,
							<cfif isdefined("attributes.expense_paper_type") and len(attributes.expense_paper_type)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.expense_paper_type#"><cfelse>NULL</cfif>,
							<cfif len(form_row_detail)><cfqueryparam cfsqltype="cf_sql_varchar" value="#form_row_detail#"><cfelse>NULL</cfif>,
							<cfif isdefined("attributes.system_relation") and len(attributes.system_relation)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.system_relation#"><cfelse>NULL</cfif>,
							0,
							0,
							<cfif len(attributes.expense_employee) and len(attributes.expense_employee_id)>#attributes.expense_employee_id#<cfelse>NULL</cfif>,
							<cfif form_member_type is 'partner'>
								<cfif len(form_company) and len(form_authorized) and len(form_company_id)>#form_company_id#,<cfelse>NULL,</cfif>
								<cfif len(form_company) and len(form_authorized) and len(form_member_id)>#form_member_id#,<cfelse>NULL,</cfif>
								<cfif len(form_company) and len(form_authorized) and len(form_member_type)>#sql_unicode()#'#form_member_type#',<cfelse>NULL,</cfif>
							<cfelse>
								NULL,
								<cfif len(form_authorized) and len(form_member_id)>#form_member_id#,<cfelse>NULL,</cfif>
								<cfif len(form_authorized) and len(form_member_type)>#sql_unicode()#'#form_member_type#',<cfelse>NULL,</cfif>
							</cfif>
							<cfif len(form_asset) and len(form_asset_id)>#form_asset_id#<cfelse>NULL</cfif>,
							<cfif len(form_project) and len(form_project_id)>#form_project_id#<cfelse>NULL</cfif>,
							<cfif len(form_activity_type)>#form_activity_type#<cfelse>NULL</cfif>,
							<cfif len(form_total)><cfqueryparam cfsqltype="cf_sql_varchar" value="#filterNum(form_total,8)#"><cfelse>NULL</cfif>,
							<cfif len(form_kdv_total)>#filterNum(form_kdv_total,8)#<cfelse>NULL</cfif>,
							<cfif len(form_net_total)>#filterNum(form_net_total,8)#<cfelse>NULL</cfif>,
							<cfif len(form_money_1)><cfqueryparam cfsqltype="cf_sql_varchar" value="#form_money_1#"><cfelse>NULL</cfif>,
							<cfif len(form_money_2)>#form_money_2#<cfelse>NULL</cfif>,
							<cfif len(form_money_3)>#form_money_3#<cfelse>NULL</cfif>,
							<cfif len(form_tax_rate)><cfqueryparam cfsqltype="cf_sql_varchar" value="#filterNum(form_tax_rate,8)#"><cfelse>NULL</cfif>,
							<cfif len(form_other_net_total)>#filterNum(form_other_net_total,8)#<cfelse>NULL</cfif>,
							1,
							<cfif len(form_product_id) and len(form_product_name)>#form_product_id#<cfelse>NULL</cfif>,
							<cfif len(form_stock_id) and len(form_product_name)>#form_stock_id#<cfelse>NULL</cfif>,
							<cfif len(form_product_name)><cfqueryparam cfsqltype="cf_sql_varchar" value="#left(form_product_name,40)#"><cfelse>NULL</cfif>,
							<cfif len(form_quantity)>#filterNum(form_quantity,8)#<cfelse>1</cfif>,
							<cfif len(form_stock_unit)><cfqueryparam cfsqltype="cf_sql_varchar" value="#form_stock_unit#"><cfelse>NULL</cfif>,
							<cfif len(form_stock_unit_id)>#form_stock_unit_id#<cfelse>NULL</cfif>,
							#session.ep.userid#,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
							<cfif isDefined("attributes.work_id#i#") and len(evaluate("attributes.work_id#i#")) and isDefined("attributes.work_head#i#") and len(evaluate("attributes.work_head#i#"))>#evaluate("attributes.work_id#i#")#<cfelse>NULL</cfif>,
							<cfif isDefined("attributes.opp_id#i#") and len(evaluate("attributes.opp_id#i#")) and isDefined("attributes.opp_head#i#") and len(evaluate("attributes.opp_head#i#"))>#evaluate("attributes.opp_id#i#")#<cfelse>NULL</cfif>,
							#now()#
						)
					</cfquery>
				</cfif>
			</cfloop>
		</cfif>
		<!--- money kayıtları --->
		<cfloop from="1" to="#attributes.kur_say#" index="i">
			<cfset txt_rate2 = evaluate("attributes.txt_rate2_#i#")>
			<cfset txt_rate1 = evaluate("attributes.txt_rate1_#i#")>
			<cfquery name="add_money" datasource="#dsn2#">
				INSERT INTO
					EXPENSE_ITEM_PLAN_REQUESTS_MONEY 
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
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('attributes.hidden_rd_money_#i#')#">,
					#filterNum(txt_rate2,8)#,
					#filterNum(txt_rate1,8)#,
					<cfif evaluate("attributes.hidden_rd_money_#i#") is rd_money_value>1<cfelse>0</cfif>
				)
			</cfquery>
		</cfloop>
		<cfif len(paper_number)>
			<cfquery name="UPD_GENERAL_PAPERS" datasource="#DSN2#">
				UPDATE 
					#dsn3_alias#.GENERAL_PAPERS
				SET
					EXPENDITURE_REQUEST_NUMBER = #paper_number#
				WHERE
					EXPENDITURE_REQUEST_NUMBER IS NOT NULL
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
	action_table='EXPENSE_ITEM_PLAN_REQUESTS'
	action_column='EXPENSE_ID'
	action_id='#MAX_ID.IDENTITYCOL#'
	action_page='#request.self#?fuseaction=cost.list_expense_requests&event=upd&request_id=#MAX_ID.IDENTITYCOL#' 
	warning_description='Harcama Talebi : #attributes.paper_number#'>
<cfif attributes.cost_type eq 1>
	<cfset request_id_ = contentEncryptingandDecodingAES(isEncode:1,content:MAX_ID.IDENTITYCOL,accountKey:'wrk')>
    <script type="text/javascript">
    	window.location.href = "<cfoutput>#request.self#?fuseaction=myhome.list_my_expense_requests&event=upd&request_id=#request_id_#</cfoutput>";
    </script>
<cfelse>
	<script type="text/javascript">
    	window.location.href = "<cfoutput>#request.self#?fuseaction=cost.list_expense_requests&event=upd&request_id=#MAX_ID.IDENTITYCOL#</cfoutput>";
    </script>
</cfif>
