<cf_date tarih = 'attributes.start_date'>
<cf_date tarih = 'attributes.finish_date'>
<cfquery name="GET_PAPER_NO" datasource="#dsn3#">
	SELECT PAPER_NO FROM SALES_QUOTAS WHERE PAPER_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.paper_no#">
</cfquery>	
<cfif GET_PAPER_NO.recordcount>
	<script type="text/javascript">
		alert("<cf_get_lang_main no ='710.Girdiğiniz Belge Numarası Kullanılıyor'>!");
		window.location.href='<cfoutput>#cgi.referer#</cfoutput>';
	</script>
	<cfabort>
</cfif>
<cflock name="#CreateUUID()#" timeout="60">
	<cftransaction>
		<cfquery name="ADD_SALES_QUOTAS" datasource="#dsn3#" result="MAX_ID">
			INSERT INTO
				SALES_QUOTAS
				(
					PROCESS_STAGE,
					PAPER_NO,
					COMPANYCAT_ID,
					PLAN_DATE,
					FINISH_DATE,
					PLANNER_EMP_ID,
					RELATED_BUDGET_ID,
					RELATED_PROJECT_ID,
					BRANCH_ID,
					DEPARTMENT_ID,
					TEAM_ID,
					EMPLOYEE_ID,
					SALES_ZONE_ID,
					IMS_CODE_ID,
					CUSTOMER_VALUE_ID,
					RELATION_TYPE_ID,
					COMPANY_ID,
					PARTNER_ID,
					CONSUMER_ID,
					DETAIL,
					TOTAL_QUANTITY,
					TOTAL_AMOUNT,
					OTHER_TOTAL_AMOUNT,
					TOTAL_EXTRA_STOCK,
					TOTAL_PREMIUM_AMOUNT,
					TOTAL_PROFIT_AMOUNT,
					OTHER_MONEY,
					MAIN_PRODUCT_ID,
					IS_ACTIVE,
					IS_WIEW_PURVEYOR,
					IS_WIEW_MARK,
					IS_WIEW_CAT,
					IS_WIEW_PRODUCT,
					IS_SALES_PURCHASE,
					IS_RETURNS,
					IS_PURCHASE_DISCOUNTS,
					IS_ACTION_DISCOUNTS,
					IS_TOTAL_INSIDE_DISCOUNTS,
					RECORD_DATE,
					RECORD_IP,
					RECORD_EMP
				)
			VALUES
				(
					<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_stage#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.paper_no#">,
					<cfif isdefined('attributes.companycat_id') and len(attributes.companycat_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.companycat_id#"><cfelse>NULL</cfif>,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#">,
					<cfif isdefined('attributes.planner_id') and len(attributes.planner_id) and len(attributes.planner_name)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.planner_id#">,<cfelse>NULL,</cfif>
					<cfif isdefined('attributes.budget_id') and len(attributes.budget_id) and len(attributes.budget_name)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.budget_id#">,<cfelse>NULL,</cfif>
					<cfif isdefined('attributes.project_id') and len(attributes.project_id) and len(attributes.project_head)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">,<cfelse>NULL,</cfif>
					<cfif isdefined('attributes.branch_id') and len(attributes.branch_id) and len(attributes.branch_name)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#">,<cfelse>NULL,</cfif>
					<cfif isdefined('attributes.department_id') and len(attributes.department_id) and len(attributes.department)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department_id#">,<cfelse>NULL,</cfif>
					<cfif isdefined('attributes.team_id') and len(attributes.team_id) and len(attributes.team_name)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.team_id#">,<cfelse>NULL,</cfif>
					<cfif isdefined('attributes.employee_id') and len(attributes.employee_id) and len(attributes.employee_name)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">,<cfelse>NULL,</cfif>
					<cfif isdefined('attributes.sales_zone_id') and len(attributes.sales_zone_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sales_zone_id#">,<cfelse>NULL,</cfif>
					<cfif isdefined('attributes.ims_code_id') and len(attributes.ims_code_id) and len(attributes.ims_code_name)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ims_code_id#">,<cfelse>NULL,</cfif>
					<cfif isdefined('attributes.customer_value') and len(attributes.customer_value)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.customer_value#">,<cfelse>NULL,</cfif>
					<cfif isdefined('attributes.resource') and len(attributes.resource)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.resource#">,<cfelse>NULL,</cfif>
					<cfif isdefined('attributes.comp_name') and len(attributes.comp_name) and len(attributes.company_id)>
						<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">,
						<cfif isDefined("attributes.partner_id") and len(attributes.partner_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.partner_id#"><cfelse>NULL</cfif>,
						NULL,
					<cfelseif len(attributes.comp_name) and len(attributes.consumer_id)>
						NULL,
						NULL,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">,
					<cfelse>
						NULL,
						NULL,
						NULL,
					</cfif>
					<cfif len(attributes.detail)>'#left(attributes.detail,300)#',<cfelse>NULL,</cfif>
					<cfqueryparam cfsqltype="cf_sql_integer" value="#toplam_miktar#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#toplam_tutar#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#tutar_doviz#">,
					<cfif isdefined("attributes.mal_miktar") and len(attributes.mal_miktar)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.mal_miktar#"><cfelse>NULL</cfif>,
					<cfif isdefined("attributes.prim_tutar") and len(attributes.prim_tutar)><cfqueryparam cfsqltype="cf_sql_float" value="#attributes.prim_tutar#"><cfelse>NULL</cfif>,
					<cfif isdefined("attributes.kar_tutar") and len(attributes.kar_tutar)><cfqueryparam cfsqltype="cf_sql_float" value="#attributes.kar_tutar#"><cfelse>NULL</cfif>,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#rd_money#">,
					<cfif isDefined("attributes.main_product_id") and Len(attributes.main_product_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.main_product_id#"><cfelse>NULL</cfif>,
					<cfif isDefined("attributes.is_active")>1,<cfelse>0,</cfif>
					<cfif isdefined('attributes.is_wiew_purveyor')>1<cfelse>0</cfif>,
					<cfif isdefined('attributes.is_wiew_mark')>1<cfelse>0</cfif>,
					<cfif isdefined('attributes.is_wiew_cat')>1<cfelse>0</cfif>,
					<cfif isdefined('attributes.is_wiew_product')>1<cfelse>0</cfif>,
					<cfif isdefined("attributes.quota_type") and len(attributes.quota_type)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.quota_type#"></cfif>,
					<cfif isDefined("attributes.is_returns")>1<cfelse>0</cfif>,
					<cfif isDefined("attributes.is_purchase_discounts")>1<cfelse>0</cfif>,
					<cfif isDefined("attributes.is_action_discounts")>1<cfelse>0</cfif>,
					<cfif isDefined("attributes.is_total_inside_discounts")>1<cfelse>0</cfif>,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
				)
		</cfquery>
		
		<cfloop from="1" to="#attributes.record_num#" index="i">
			<cfif isdefined("attributes.row_kontrol#i#") and evaluate("attributes.row_kontrol#i#")>
				<cfset detail_info =  "#left(evaluate("attributes.row_detail#i#"),300)#">
					<cfquery name="ADD_SALES_QUOTA_ROW" datasource="#dsn3#">
						INSERT INTO
							SALES_QUOTAS_ROW
							(
								SALES_QUOTA_ID,
								SUPPLIER_ID,
								BRAND_ID,
								MULTI_CATEGORY_ID,
								CATEGORY_ID,
								<cfif x_products_not_included eq 1 and isdefined('attributes.is_wiew_cat')>
								MULTI_PRODUCT_ID2,
								MULTI_STOCK_ID2,
								</cfif>
								PRODUCT_ID,
								STOCK_ID,
								PRODUCT_NAME,
								QUANTITY,
								ROW_TOTAL,
								ROW_OTHER_TOTAL,
								ROW_TOTAL_MAX,
								ROW_OTHER_TOTAL_MAX,
								ROW_PREMIUM_PERCENT,
								ROW_PREMIUM_PERCENT2,
								ROW_PREMIUM_PERCENT3,
								ROW_PREMIUM_TOTAL,
								ROW_EXTRA_STOCK,
								ROW_PROFIT_PERCENT,
								ROW_PROFIT_TOTAL,
								ROW_DETAIL,
								PERIOD_TYPE,
								PERIOD_COUNT
							)
							VALUES
							(
								<cfqueryparam cfsqltype="cf_sql_integer" value="#MAX_ID.IDENTITYCOL#">,
								<cfif len(evaluate("attributes.row_company_id#i#")) and len(evaluate("attributes.row_comp_name#i#")) and isdefined('attributes.is_wiew_purveyor')><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.row_company_id#i#')#">,<cfelse>NULL,</cfif>
								<cfif len(evaluate("attributes.row_brand_id#i#")) and len(evaluate("attributes.row_brand_name#i#")) and isdefined('attributes.is_wiew_mark')><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.row_brand_id#i#')#">,<cfelse>NULL,</cfif>
								<cfif isdefined('attributes.is_wiew_cat') and len(evaluate("attributes.row_category#i#"))><!---  and len(evaluate("attributes.row_category_name#i#")) --->
									<!--- Coklu Kategori secimi eklendi, bu yuzden alan nvarchar yapildi FBS 20100202 --->
									<cfif Len(attributes.multi_category_selected) and attributes.multi_category_selected eq 1>
										<cfqueryparam cfsqltype="cf_sql_varchar" value=",#evaluate('attributes.row_category#i#')#,">,
										NULL,
									<cfelse>
										NULL,
										<cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.row_category#i#')#">,
									</cfif>
								<cfelse>
									NULL,
									NULL,
								</cfif>
								<cfif x_products_not_included eq 1 and isdefined('attributes.is_wiew_cat')>
									<cfif len(evaluate("attributes.product_name2#i#")) and len(evaluate("attributes.product_id2#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.product_id2#i#')#">,<cfelse>NULL,</cfif>
									<cfif len(evaluate("attributes.product_name2#i#")) and len(evaluate("attributes.stock_id2#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.stock_id2#i#')#">,<cfelse>NULL,</cfif>
								</cfif>
								<cfif len(evaluate("attributes.product_id#i#")) and len(evaluate("attributes.product_name#i#")) and isdefined('attributes.is_wiew_product')><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.product_id#i#')#">,<cfelse>NULL,</cfif>
								<cfif len(evaluate("attributes.stock_id#i#")) and len(evaluate("attributes.product_name#i#")) and isdefined('attributes.is_wiew_product')><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.stock_id#i#')#">,<cfelse>NULL,</cfif>
								<cfif len(evaluate("attributes.product_name#i#")) and isdefined('attributes.is_wiew_product')><cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('attributes.product_name#i#')#">,<cfelse>NULL,</cfif>
								<cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('attributes.quantity#i#')#">,
								<cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('attributes.row_total#i#')#">,
								<cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('attributes.row_other_total#i#')#">,
								<cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('attributes.row_total_max#i#')#">,
								<cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('attributes.row_other_total_max#i#')#">,
								<cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('attributes.premium_per_#i#')#">,
								<cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('attributes.premium_per2_#i#')#">,
								<cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('attributes.premium_per3_#i#')#">,
								<cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('attributes.row_premium_total#i#')#">,
								<cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('attributes.extra_stock#i#')#">,
								<cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('attributes.profit_per#i#')#">,
								<cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('attributes.row_profit_total#i#')#">,
								<cfif len(detail_info)><cfqueryparam cfsqltype="cf_sql_varchar" value="#detail_info#"><cfelse>NULL</cfif>,
								<cfif isdefined("attributes.period_type#i#") and len(evaluate("attributes.period_type#i#"))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.period_type#i#')#"><cfelse>NULL</cfif>,
								<cfif evaluate("attributes.period_type#i#") eq 0>12<cfelseif evaluate("attributes.period_type#i#") eq 1>4<cfelse>1</cfif>
							)
					</cfquery>
			</cfif>
		</cfloop>
	
		<cfloop from="1" to="#attributes.kur_say#" index="kk">
			<cfquery name="ADD_MONEY_INFO" datasource="#dsn3#">
				INSERT INTO
					SALES_QUOTAS_MONEY 
					(
						ACTION_ID,
						MONEY_TYPE,
						RATE2,
						RATE1,
						IS_SELECTED
					)
				VALUES
					(
						<cfqueryparam cfsqltype="cf_sql_integer" value="#MAX_ID.IDENTITYCOL#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('attributes.hidden_rd_money_#kk#')#">,
						<cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('attributes.txt_rate2_#kk#')#">,
						<cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('attributes.txt_rate1_#kk#')#">,
						<cfif evaluate("attributes.hidden_rd_money_#kk#") is rd_money>1<cfelse>0</cfif>
					)
			</cfquery>
		</cfloop>
	</cftransaction>
</cflock>
<cf_workcube_process
	is_upd='1' 
	data_source='#dsn3#' 
	old_process_line='0'
	process_stage='#attributes.process_stage#' 
	record_member='#session.ep.userid#' 
	record_date='#now()#' 
	action_table='SALES_QUOTAS'
	action_column='SALES_QUOTA_ID'
	action_id='#MAX_ID.IDENTITYCOL#'
	action_page='#request.self#?fuseaction=salesplan.list_sales_quotas&event=upd&q_id=#MAX_ID.IDENTITYCOL#' 
	warning_description='Kota : #attributes.paper_no#'>
    
    <script type="text/javascript">
		window.location.href="<cfoutput>#request.self#?fuseaction=salesplan.list_sales_quotas&event=upd&q_id=#MAX_ID.IDENTITYCOL#</cfoutput>";
	</script>
    	
