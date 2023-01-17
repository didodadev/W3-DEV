<cflock name="#CreateUUID()#" timeout="60">
	<cftransaction>
		<cfif len(attributes.expense_date)>
			<cf_date tarih = 'attributes.expense_date'>
		</cfif>
		<cfif not isdefined('attributes.is_stock_fis') and isdefined("attributes.page_info")><!--- eğer detaylı dağılımdan gelmiyorsa ana dağıtım sayfasından geliyorsa değişkenler oluşturulacak --->
			<cfset page_record_num = attributes.page_record_num>
		<cfelse>
			<cfset page_record_num = 1>
		</cfif>
		<cfif isDefined("attributes.is_stock_fis") and attributes.is_stock_fis eq 1>
			<cfquery name="get_branch_id" datasource="#dsn2#">
				SELECT
					D.BRANCH_ID
				FROM
					STOCK_FIS SF,
					#dsn_alias#.DEPARTMENT D
				WHERE
					SF.FIS_ID = #attributes.invoice_id#
					AND ISNULL(SF.DEPARTMENT_OUT,SF.DEPARTMENT_IN) = D.DEPARTMENT_ID
			</cfquery>
		<cfelse>
			<cfquery name="get_branch_id" datasource="#dsn2#">
				SELECT
					D.BRANCH_ID
				FROM
					INVOICE I,
					#dsn_alias#.DEPARTMENT D
				WHERE
					I.INVOICE_ID = #attributes.invoice_id#
					AND I.DEPARTMENT_ID = D.DEPARTMENT_ID
			</cfquery>
		</cfif>
		<cfloop from="1" to="#page_record_num#" index="kk">
			<cfif (not isdefined('attributes.is_stock_fis') and isdefined("attributes.page_info") and len(evaluate('attributes.exp_template_id#kk#'))) or not isdefined("attributes.page_info")>
				<cfif isdefined("attributes.page_info")>
					<cfset invoice_row_id = evaluate('attributes.invoice_row_id#kk#')>
					<cfset name_product = evaluate('attributes.name_product#kk#')>
					<cfset stock_id = evaluate('attributes.stock_id#kk#')>					
					<cfquery name="get_temp_rows" datasource="#dsn2#">
						SELECT 
							ETR.PROMOTION_ID,
							ETR.WORKGROUP_ID,
							ETR.PROJECT_ID,
							ETR.ASSET_ID,
							ETR.COMPANY_ID,
							ETR.COMPANY_PARTNER_ID,
							ETR.MEMBER_TYPE,
							ISNULL(ETR.RATE,0) RATE,
							ETR.EXPENSE_CENTER_ID,
							ETR.EXPENSE_ITEM_ID,
							ETR.SUBSCRIPTION_ID
						FROM 
							EXPENSE_PLANS_TEMPLATES_ROWS ETR
						WHERE 
							TEMPLATE_ID = #evaluate('attributes.exp_template_id#kk#')#
					</cfquery>
					<cfoutput query="get_temp_rows">
						<cfscript>
							'attributes.expense_item_id#get_temp_rows.currentrow#' = get_temp_rows.EXPENSE_ITEM_ID;
							'attributes.expense_center_ids#get_temp_rows.currentrow#' = get_temp_rows.EXPENSE_CENTER_ID;
							'attributes.member_id#get_temp_rows.currentrow#' = get_temp_rows.COMPANY_PARTNER_ID;
							'attributes.member_type#get_temp_rows.currentrow#' = get_temp_rows.MEMBER_TYPE;
							'attributes.asset_id#get_temp_rows.currentrow#' = get_temp_rows.ASSET_ID;
							'attributes.asset#get_temp_rows.currentrow#' = 'aaaa';
							'attributes.project_id#get_temp_rows.currentrow#' = get_temp_rows.PROJECT_ID;
							'attributes.project#get_temp_rows.currentrow#' = 'aaaa';
							'attributes.authorized#get_temp_rows.currentrow#' = 'aaaa';
							'attributes.activity_type#get_temp_rows.currentrow#' = get_temp_rows.PROMOTION_ID;
							'attributes.workgroup_id#get_temp_rows.currentrow#' = get_temp_rows.WORKGROUP_ID;
							'attributes.total_expense_item#get_temp_rows.currentrow#' = evaluate('attributes.grosstotal_page#kk#') * get_temp_rows.RATE / 100;
							'attributes.expense_item_value#get_temp_rows.currentrow#' = get_temp_rows.RATE;
							'attributes.grosstotal#get_temp_rows.currentrow#' = evaluate('attributes.grosstotal_page#kk#');
							'attributes.nettotal#get_temp_rows.currentrow#' = evaluate('attributes.nettotal_page#kk#');
							'attributes.taxtotal#get_temp_rows.currentrow#' = evaluate('attributes.taxtotal_page#kk#');
							'attributes.otvtotal#get_temp_rows.currentrow#' = evaluate('attributes.otvtotal_page#kk#');
							'attributes.bsmvtotal#get_temp_rows.currentrow#' = evaluate('attributes.bsmvtotal_page#kk#');
							'attributes.oivtotal#get_temp_rows.currentrow#' = evaluate('attributes.oivtotal_page#kk#');
							'attributes.tevkifattotal#get_temp_rows.currentrow#' = evaluate('attributes.tevkifattotal_page#kk#');
							'attributes.tax#get_temp_rows.currentrow#' = evaluate('attributes.tax_page#kk#');
							'attributes.otv_oran#get_temp_rows.currentrow#' = evaluate('attributes.otv_oran_page#kk#');
							'attributes.bsmv_oran#get_temp_rows.currentrow#' = evaluate('attributes.bsmv_oran_page#kk#');
							'attributes.oiv_oran#get_temp_rows.currentrow#' = evaluate('attributes.oiv_oran_page#kk#');
							'attributes.tevkifat_oran#get_temp_rows.currentrow#' = evaluate('attributes.tevkifat_oran_page#kk#');
							'attributes.other_money_value#get_temp_rows.currentrow#' = evaluate('attributes.other_money_value_page#kk#');
							'attributes.other_money_grosstotal#get_temp_rows.currentrow#' = evaluate('attributes.other_money_grosstotal_page#kk#');		
							'attributes.other_money#get_temp_rows.currentrow#' = evaluate('attributes.other_money_page#kk#');
							'attributes.row_kontrol#get_temp_rows.currentrow#' = 1;	
							'attributes.subscription_id#get_temp_rows.currentrow#' = get_temp_rows.SUBSCRIPTION_ID;
							'attributes.subscription_name#get_temp_rows.currentrow#' = 'aaaa';	
						</cfscript>
					</cfoutput>
					<cfset record_num = get_temp_rows.recordcount>
				<cfelse>
					<cfset invoice_row_id = attributes.invoice_row_id>
					<cfset record_num = attributes.record_num>
					<cfset name_product = attributes.name_product>
					<cfset stock_id = attributes.stock_id>
				</cfif>
				<cfquery name="DEL_EXPENSE_ROWS" datasource="#DSN2#">
					DELETE FROM EXPENSE_ITEMS_ROWS WHERE ACTION_ID = #invoice_row_id# AND EXPENSE_COST_TYPE = #invoice_cat#
				</cfquery>
				<cfif len(record_num) and record_num neq "">
					<cfscript>
						if(session.ep.money neq session.ep.money2)
						{
								get_currency_rate_2 = cfquery(datasource : "#dsn2#", sqlstring : "SELECT (RATE2/RATE1) RATE FROM SETUP_MONEY WHERE MONEY ='#session.ep.money2#'");
								if(get_currency_rate_2.recordcount)
									currency_2_rate = get_currency_rate_2.RATE;
								else currency_2_rate = 1;
						}
						else
							currency_2_rate = 1;
					</cfscript>
					<cfloop from="1" to="#record_num#" index="i">
						<cfif evaluate("attributes.row_kontrol#i#")>
							<cfscript>
								form_expense_item_id = evaluate('attributes.expense_item_id#i#');
								form_expense_center_ids = evaluate('attributes.expense_center_ids#i#');
								form_member_id = evaluate('attributes.member_id#i#');
								form_member_type = evaluate('attributes.member_type#i#');
								form_asset=evaluate("attributes.asset#i#");
								form_asset_id=evaluate("attributes.asset_id#i#");
								form_project=evaluate("attributes.project#i#");
								form_project_id=evaluate("attributes.project_id#i#");
								form_authorized = evaluate("attributes.authorized#i#");
								form_sub_id = evaluate("attributes.subscription_id#i#");
								form_sub_name = evaluate("attributes.subscription_name#i#");
								
								form_activity_type = evaluate("attributes.activity_type#i#");
								form_workgroup_id = evaluate("attributes.workgroup_id#i#");
								
								form_total_expense_item = evaluate('attributes.total_expense_item#i#');
								form_expense_item_value = evaluate('attributes.expense_item_value#i#');
																
								form_gross_total = evaluate('attributes.grosstotal#i#');
								form_net_total = evaluate('attributes.nettotal#i#');
								form_tax_total = evaluate('attributes.taxtotal#i#');
								form_otv_total = evaluate('attributes.otvtotal#i#');
								form_bsmv_total = evaluate('attributes.bsmvtotal#i#');
								form_oiv_total = evaluate('attributes.oivtotal#i#');
								form_tevkifat_total = evaluate('attributes.tevkifattotal#i#');
								
								form_tax = evaluate('attributes.tax#i#');
								form_otv_oran = evaluate('attributes.otv_oran#i#');
								form_bsmv_oran = evaluate('attributes.bsmv_oran#i#');
								form_oiv_oran = evaluate('attributes.oiv_oran#i#');
								form_tevkifat_oran = evaluate('attributes.tevkifat_oran#i#');
								
								other_money_value = evaluate('attributes.other_money_value#i#');
								other_money_grosstotal = evaluate('attributes.other_money_grosstotal#i#');
								form_other_money = evaluate('attributes.other_money#i#');
								
								form_gross_total_  = (form_gross_total * form_expense_item_value)/100;
								form_net_total_ = (form_net_total * form_expense_item_value)/100;
								form_tax_total_ = (form_tax_total * form_expense_item_value)/100;
								form_otv_total_ = (form_otv_total * form_expense_item_value)/100;
								form_bsmv_total_ = (form_bsmv_total * form_expense_item_value)/100;
								form_oiv_total_ = (form_oiv_total * form_expense_item_value)/100;
								form_tevkifat_total_ = (form_tevkifat_total * form_tax_total)/100;
								
								if(len(other_money_grosstotal))
									other_money_grosstotal_ = (other_money_grosstotal * form_expense_item_value)/100;
								else
									other_money_grosstotal_ = 0;
								if(len(other_money_value))
									other_money_value_ = (other_money_value * form_expense_item_value)/100;
								else
									other_money_value_ = 0;

								if(len(currency_2_rate))
										other_money_gross_total_2=wrk_round(form_gross_total_/currency_2_rate,2);
									else
										other_money_gross_total_2='';
							</cfscript>
							<cfquery name="ADD_EXPENSE_ROW" datasource="#dsn2#">
								INSERT INTO
									EXPENSE_ITEMS_ROWS
								(
                                	ROW_PAPER_NO,
									EXPENSE_COST_TYPE,
									ACTION_ID,
									EXPENSE_CENTER_ID,
									EXPENSE_ITEM_ID,
									DETAIL,
									COMPANY_PARTNER_ID,
									PYSCHICAL_ASSET_ID,
									PROJECT_ID,
									ACTIVITY_TYPE,
									WORKGROUP_ID,
									STOCK_ID,
									EXPENSE_DATE,
									RECORD_IP,
									RECORD_EMP,
									RECORD_DATE,
									MEMBER_TYPE,
									AMOUNT_KDV,
									AMOUNT_OTV,
									AMOUNT_BSMV,
									AMOUNT_OIV,
									AMOUNT_TEVKIFAT,
									KDV_RATE,
									OTV_RATE,
									BSMV_RATE,
									OIV_RATE,
									TEVKIFAT_RATE,
									AMOUNT,
									TOTAL_AMOUNT,
									RATE,
									EXPENSE_ID,
									<cfif not isdefined("attributes.is_stock_fis")>
										INVOICE_ID,
									<cfelse>
										STOCK_FIS_ID,
									</cfif>
									SALE_PURCHASE,
									IS_INCOME,
									MONEY_CURRENCY_ID,
									OTHER_MONEY_VALUE,
									OTHER_MONEY_GROSS_TOTAL,
									MONEY_CURRENCY_ID_2,
									OTHER_MONEY_VALUE_2,
									IS_DETAILED,
									QUANTITY,
									BRANCH_ID,
									SUBSCRIPTION_ID
								)
								VALUES
								(	'#attributes.invoice_number#',
									#invoice_cat#,
									#invoice_row_id#,
									<cfif len(form_expense_center_ids)>#form_expense_center_ids#,<cfelse>NULL,</cfif>
									<cfif len(form_expense_item_id)>#form_expense_item_id#,<cfelse>NULL,</cfif>
									<cfif len(name_product)>'#name_product#',<cfelse>NULL,</cfif>
									<cfif len(form_member_type) and len(form_member_id) and len(form_authorized)>#form_member_id#,<cfelse>NULL,</cfif>
									<cfif len(form_asset) and len(form_asset_id)>#form_asset_id#,<cfelse>NULL,</cfif>
									<cfif len(form_project) and len(form_project_id)>#form_project_id#,<cfelse>NULL,</cfif>
									<cfif len(form_activity_type) and len(form_activity_type)>#form_activity_type#,<cfelse>NULL,</cfif>
									<cfif len(form_workgroup_id) and len(form_workgroup_id)>#form_workgroup_id#,<cfelse>NULL,</cfif>
									#stock_id#,
									<cfif len(attributes.expense_date)>#attributes.expense_date#,<cfelse>NULL,</cfif>
									'#cgi.remote_addr#',
									#session.ep.userid#,
									#now()#,
									<cfif len(form_member_type)>'#form_member_type#',<cfelse>NULL,</cfif>
									#form_tax_total_#,
									#form_otv_total_#,
									#form_bsmv_total_#,
									#form_oiv_total_#,
									#form_tevkifat_total_#,
									#form_tax#,
									#form_otv_oran#,
									#form_bsmv_oran#,
									#form_oiv_oran#,
									#form_tevkifat_oran#,
									#form_net_total_#,
									#form_total_expense_item#,
									#form_expense_item_value#,
									0,
									#attributes.invoice_id#,
									1,
									0,
									<cfif len(form_other_money)>'#form_other_money#',<cfelse>NULL,</cfif>
									<cfif len(other_money_value_)>#other_money_value_#<cfelse>NULL</cfif>,
									<cfif len(other_money_grosstotal_)>#other_money_grosstotal_#<cfelse>NULL</cfif>,
									<cfif len(other_money_gross_total_2)>'#session.ep.money2#',<cfelse>NULL,</cfif>
									<cfif len(other_money_gross_total_2)>#other_money_gross_total_2#,<cfelse>NULL,</cfif>
									1,
									1,
									<cfif get_branch_id.recordcount>#get_branch_id.branch_id#<cfelse>NULL</cfif>,
									<cfif len(form_sub_id) and len(form_sub_name)><cfqueryparam cfsqltype="cf_sql_integer" value="#form_sub_id#"><cfelse>NULL</cfif>
							 	)
							</cfquery>
						</cfif>
					</cfloop>
					<cfif not isdefined("attributes.is_stock_fis")>
						<cfquery name="upd_invoice_cost" datasource="#dsn2#">
							UPDATE INVOICE SET IS_COST=1 WHERE INVOICE_ID = #attributes.invoice_id#
						</cfquery>
					<cfelse>
						<cfquery name="upd_fis_cost" datasource="#dsn2#">
							UPDATE STOCK_FIS SET IS_COST=1 WHERE FIS_ID = #attributes.invoice_id#
						</cfquery>
					</cfif>
				</cfif>
			</cfif>
		</cfloop>
	</cftransaction>
</cflock>
<script type="text/javascript">
	<cfif not isdefined("attributes.draggable")>
		wrk_opener_reload();
		window.close();
	<cfelse>
		closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );
		location.reload();
	</cfif>
</script>
