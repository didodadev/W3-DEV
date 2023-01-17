<cf_date tarih = 'attributes.expense_date'>
<cf_date tarih = "attributes.basket_due_value_date_">
<cfif isDefined("attributes.basket_due_value_date_") and len(attributes.basket_due_value_date_)>
	<cfset expense_due_date = attributes.basket_due_value_date_>
<cfelse>
	<cfset expense_due_date = attributes.expense_date>
</cfif>
<cfscript>
	rd_money_value = listfirst(attributes.rd_money, ',');
</cfscript>
<cfif listlen(attributes.expense_employee_id,'_') eq 2>
	<cfset acc_type_id = listLast(attributes.expense_employee_id,'_')>
	<cfset attributes.expense_employee_id = listFirst(attributes.expense_employee_id,'_')>
<cfelse>
	<cfset acc_type_id = ''>
</cfif>
<!---History--->
<cfinclude template="add_expense_request_history.cfm">
<!---History--->
<cflock timeout="60" name="#CreateUUID()#">
	<cftransaction>
		<cfquery name="UPD_EXPENSE_TOTAL_COST" datasource="#dsn2#">
			UPDATE
				EXPENSE_ITEM_PLAN_REQUESTS
			SET
				EXPENSE_CASH_ID = <cfif isdefined("attributes.cash")>#attributes.kasa#,<cfelseif isdefined("attributes.bank")>#attributes.banka#,<cfelse>NULL,</cfif>
				OTHER_MONEY_AMOUNT = <cfif len(attributes.other_total_amount)>#filterNum(attributes.other_total_amount,8)#,<cfelse>NULL,</cfif>
				OTHER_MONEY_KDV = <cfif len(attributes.other_kdv_total_amount)>#filterNum(attributes.other_kdv_total_amount,8)#,<cfelse>NULL,</cfif>
				OTHER_MONEY_NET_TOTAL = <cfif len(attributes.other_net_total_amount)>#filterNum(attributes.other_net_total_amount,8)#,<cfelse>NULL,</cfif>
				OTHER_MONEY = <cfif len(rd_money_value)>#sql_unicode()#'#rd_money_value#',<cfelse>NULL,</cfif>
				PAYMETHOD_ID = <cfif isdefined("attributes.paymethod") and len(attributes.paymethod)>#attributes.paymethod#,<cfelse>NULL,</cfif>
				PAPER_NO = <cfif len(attributes.paper_number)>'#attributes.paper_number#',<cfelse>NULL,</cfif>
				EMP_ID = <cfif len(attributes.expense_employee) and len(attributes.expense_employee_id)>#attributes.expense_employee_id#,<cfelse>NULL,</cfif>
				EXPENSE_DATE = <cfif len(attributes.expense_date)>#attributes.expense_date#,<cfelse>NULL,</cfif>
				PAPER_TYPE = <cfif isdefined("attributes.expense_paper_type") and len(attributes.expense_paper_type)>#attributes.expense_paper_type#,<cfelse>NULL,</cfif>
				SYSTEM_RELATION = <cfif isdefined("attributes.system_relation") and len(attributes.system_relation)>#sql_unicode()#'#attributes.system_relation#',<cfelse>NULL,</cfif>
				DETAIL = <cfif len(attributes.detail)>#sql_unicode()#'#attributes.detail#',<cfelse>NULL,</cfif>
				UPDATE_DATE = #now()#,
				UPDATE_EMP = #session.ep.userid#,
				UPDATE_IP = #sql_unicode()#'#cgi.remote_addr#',
				TOTAL_AMOUNT = #filterNum(attributes.total_amount,8)#,
				NET_TOTAL_AMOUNT = #filterNum(attributes.kdv_total_amount,8)#,
				NET_KDV_AMOUNT = #filterNum(attributes.net_total_amount,8)#,
				EXPENSE_STAGE = #attributes.process_stage#,
                PROJECT_ID = <cfif isdefined("attributes.project_id") and len(attributes.project_id) and len(attributes.project_head)>#attributes.project_id#<cfelse>NULL</cfif>,
				ACC_TYPE_ID = <cfif isdefined("acc_type_id") and len(acc_type_id)>#acc_type_id#<cfelse>NULL</cfif>,
				DUE_DATE = <cfif len(expense_due_date)>#expense_due_date#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.sales_company_id") and len(sales_member_type) and sales_member_type eq 'partner'>
					SALES_COMPANY_ID = <cfif len(attributes.sales_company) and len(attributes.sales_company_id)>#attributes.sales_company_id#,<cfelse>NULL,</cfif>
					SALES_PARTNER_ID = <cfif len(attributes.sales_company) and len(attributes.sales_partner) and len(attributes.sales_partner_id)>#attributes.sales_partner_id#,<cfelse>NULL,</cfif>
					SALES_CONSUMER_ID = NULL
				<cfelseif isdefined("attributes.sales_company_id") and len(sales_member_type) and sales_member_type eq 'consumer'>
					SALES_COMPANY_ID = NULL,
					SALES_PARTNER_ID = NULL,
					SALES_CONSUMER_ID = <cfif len(attributes.sales_partner) and len(attributes.sales_partner_id)>#attributes.sales_partner_id#<cfelse>NULL</cfif>
				<cfelse>
					SALES_COMPANY_ID = NULL,
					SALES_PARTNER_ID = NULL,
					SALES_CONSUMER_ID = NULL
				</cfif>
			WHERE
				EXPENSE_ID = #attributes.request_id#
		</cfquery>
		<cfquery name="DEL_ROW" datasource="#dsn2#">
			DELETE FROM EXPENSE_ITEM_PLAN_REQUESTS_ROWS WHERE EXPENSE_ID = #attributes.request_id#
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
					<cfquery name="ADD_EXPENSE_ROWS" datasource="#dsn2#">
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
								#attributes.request_id#,
								<cfif isdefined("attributes.expense_date#i#") and isdefined("attributes.expense_date#i#")>#evaluate("attributes.expense_date#i#")#,<cfelseif len(attributes.expense_date)>#attributes.expense_date#,<cfelse>NULL,</cfif>
								<cfif len(form_expense_center_id)>#form_expense_center_id#,<cfelse>NULL,</cfif>
								<cfif len(form_expense_item_id)>#form_expense_item_id#,<cfelse>NULL,</cfif>
								<cfif isdefined("attributes.expense_paper_type") and len(attributes.expense_paper_type)>#sql_unicode()#'#attributes.expense_paper_type#',<cfelse>NULL,</cfif>
								<cfif len(form_row_detail)>#sql_unicode()#'#form_row_detail#',<cfelse>NULL,</cfif>
								<cfif isdefined("attributes.system_relation") and len(attributes.system_relation)>#sql_unicode()#'#attributes.system_relation#',<cfelse>NULL,</cfif>
								0,
								0,
								<cfif len(attributes.expense_employee) and len(attributes.expense_employee_id)>#attributes.expense_employee_id#,<cfelse>NULL,</cfif>
								<cfif form_member_type is 'partner'>
									<cfif len(form_company) and len(form_authorized) and len(form_company_id)>#form_company_id#,<cfelse>NULL,</cfif>
									<cfif len(form_company) and len(form_authorized) and len(form_member_id)>#form_member_id#,<cfelse>NULL,</cfif>
									<cfif len(form_company) and len(form_authorized) and len(form_member_type)>#sql_unicode()#'#form_member_type#',<cfelse>NULL,</cfif>
								<cfelse>
									NULL,
									<cfif len(form_authorized) and len(form_member_id)>#form_member_id#,<cfelse>NULL,</cfif>
									<cfif len(form_authorized) and len(form_member_type)>#sql_unicode()#'#form_member_type#',<cfelse>NULL,</cfif>
								</cfif>
								<cfif len(form_asset) and len(form_asset_id)>#form_asset_id#,<cfelse>NULL,</cfif>
								<cfif len(form_project) and len(form_project_id)>#form_project_id#,<cfelse>NULL,</cfif>
								<cfif len(form_activity_type)>#form_activity_type#,<cfelse>NULL,</cfif>
								<cfif len(form_total)>#sql_unicode()#'#filterNum(form_total,8)#',<cfelse>NULL,</cfif>
								<cfif len(form_kdv_total)>#filterNum(form_kdv_total,8)#,<cfelse>NULL,</cfif>
								<cfif len(form_net_total)>#filterNum(form_net_total,8)#,<cfelse>NULL,</cfif>
								<cfif len(form_money_1)>#sql_unicode()#'#form_money_1#',<cfelse>NULL,</cfif>
								<cfif len(form_money_2)>#form_money_2#,<cfelse>NULL,</cfif>
								<cfif len(form_money_3)>#form_money_3#,<cfelse>NULL,</cfif>
								<cfif len(form_tax_rate)>#sql_unicode()#'#filterNum(form_tax_rate,8)#',<cfelse>NULL,</cfif>
								<cfif len(form_other_net_total)>#filterNum(form_other_net_total,8)#,<cfelse>NULL,</cfif>
								1,
								<cfif len(form_product_id) and len(form_product_name)>#form_product_id#<cfelse>NULL</cfif>,
								<cfif len(form_stock_id) and len(form_product_name)>#form_stock_id#<cfelse>NULL</cfif>,
								<cfif len(form_product_name)>#sql_unicode()#'#left(form_product_name,40)#'<cfelse>NULL</cfif>,
								<cfif len(form_quantity)>#filterNum(form_quantity,8)#<cfelse>1</cfif>,
								<cfif len(form_stock_unit)>#sql_unicode()#'#form_stock_unit#'<cfelse>NULL</cfif>,
								<cfif len(form_stock_unit_id)>#form_stock_unit_id#<cfelse>NULL</cfif>,
								#session.ep.userid#,
								#sql_unicode()#'#cgi.remote_addr#',
								<cfif isDefined("attributes.work_id#i#") and len(evaluate("attributes.work_id#i#")) and isDefined("attributes.work_head#i#") and len(evaluate("attributes.work_head#i#"))>#evaluate("attributes.work_id#i#")#<cfelse>NULL</cfif>,
								<cfif isDefined("attributes.opp_id#i#") and len(evaluate("attributes.opp_id#i#")) and isDefined("attributes.opp_head#i#") and len(evaluate("attributes.opp_head#i#"))>#evaluate("attributes.opp_id#i#")#<cfelse>NULL</cfif>,
								#now()#
							)
					</cfquery>
				</cfif>
			</cfloop>
		</cfif>
		<!--- Money Kayitlari --->
		<cfquery name="del_expense_item_plan_requests_money" datasource="#dsn2#">
			DELETE FROM EXPENSE_ITEM_PLAN_REQUESTS_MONEY WHERE ACTION_ID = #attributes.request_id#
		</cfquery>
		<cfloop from="1" to="#attributes.kur_say#" index="i">
			<cfset txt_rate2 = evaluate("attributes.txt_rate2_#i#")>
            <cfset txt_rate1 = evaluate("attributes.txt_rate1_#i#")>
			<cfquery name="add_money_info" datasource="#dsn2#">
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
					#attributes.request_id#,
					#sql_unicode()#'#wrk_eval("attributes.hidden_rd_money_#i#")#',
					#filternum(txt_rate2,8)#,
					#filternum(txt_rate1,8)#,
				<cfif evaluate("attributes.hidden_rd_money_#i#") is rd_money_value>1<cfelse>0</cfif>
				)
			</cfquery>
		</cfloop>
        <cfquery name="GET_INTERNALDEMAND_PAPER" datasource="#DSN2#">
			SELECT PAPER_NO FROM EXPENSE_ITEM_PLAN_REQUESTS WHERE EXPENSE_ID = #attributes.request_id#
		</cfquery>
	</cftransaction>
</cflock>
<cf_workcube_process 
	is_upd='1' 
	data_source='#dsn2#'
	old_process_line='#attributes.old_process_line#'
	process_stage='#attributes.process_stage#' 
	record_member='#session.ep.userid#' 
	record_date='#now()#' 
	action_table='EXPENSE_ITEM_PLAN_REQUESTS'
	action_column='EXPENSE_ID'
	action_id='#attributes.request_id#'
	action_page='#request.self#?fuseaction=cost.list_expense_requests&event=upd&request_id=#attributes.request_id#' 
	warning_description = 'Harcama Talebi : #GET_INTERNALDEMAND_PAPER.PAPER_NO#'>
<cfif attributes.cost_type eq 1>
	<cfset attributes.request_id = contentEncryptingandDecodingAES(isEncode:1,content:attributes.request_id,accountKey:'wrk')>
    <script type="text/javascript">
        window.location.href = "<cfoutput>#request.self#?fuseaction=myhome.list_my_expense_requests&event=upd&request_id=#attributes.request_id#</cfoutput>";
    </script>
<cfelse>
	<script type="text/javascript">
        window.location.href = "<cfoutput>#request.self#?fuseaction=cost.list_expense_requests&event=upd&request_id=#attributes.request_id#</cfoutput>";
    </script>
</cfif>
