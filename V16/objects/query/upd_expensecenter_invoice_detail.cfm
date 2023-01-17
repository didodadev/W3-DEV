<cflock name="#CreateUUID()#" timeout="60">
	<cftransaction>
    	<cfquery name="GET_EXPENSE" datasource="#dsn2#">
        	SELECT * FROM EXPENSE_ITEMS_ROWS WHERE ACTION_ID = #attributes.invoice_row_id# AND EXPENSE_COST_TYPE = #invoice_cat#
        </cfquery>
        <cfif get_expense.recordcount>
        	<cfset is_update = 1>
            <cfset record_ip_list = valuelist(get_expense.RECORD_IP)>
            <cfset record_emp_list = valuelist(get_expense.RECORD_EMP)>
            <cfset record_date_list = valuelist(get_expense.RECORD_DATE)>
        <cfelse>
        	<cfset is_update = 0>    
        </cfif>
		<cfquery name="DEL_EXPENSE" datasource="#dsn2#">
			DELETE FROM EXPENSE_ITEMS_ROWS WHERE ACTION_ID = #attributes.invoice_row_id# AND EXPENSE_COST_TYPE = #invoice_cat#
		</cfquery>
		<cfif len(attributes.expense_date)>
			<cf_date tarih = 'attributes.expense_date'>
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
		<cfif len(attributes.record_num) and attributes.record_num neq "">
			<cfscript>
				if(session.ep.money neq session.ep.money2)
				{
					get_currency_rate_2 = cfquery(datasource : "#dsn2#", sqlstring : "SELECT (RATE2/RATE1) RATE FROM SETUP_MONEY WHERE MONEY ='#session.ep.money2#'");
					if(get_currency_rate_2.recordcount)
						currency_2_rate = get_currency_rate_2.RATE;
					else currency_2_rate = 1;
				}else{currency_2_rate = 1;}
			</cfscript>
            <cfset ind = 0>
			<cfloop from="1" to="#attributes.record_num#" index="i">
                <cfset row_expense_date = evaluate('attributes.expense_date#i#')>
                <cf_date tarih = "row_expense_date">
				<cfif evaluate("attributes.row_kontrol#i#")>
					<cfscript>
						if(ind < get_expense.recordcount)
							ind++;
						form_record_ip = listgetat(record_ip_list,ind);
						form_record_emp = listgetat(record_emp_list,ind);
						form_record_date = listgetat(record_date_list,ind);

						form_expense_item_id = evaluate('attributes.expense_item_id#i#');
						form_expense_center_ids = evaluate('attributes.expense_center_ids#i#');
						form_member_id = evaluate('attributes.member_id#i#');
						form_member_code = evaluate('attributes.member_code#i#');
						form_member_type = evaluate('attributes.member_type#i#');
						form_asset = evaluate("attributes.asset#i#");
						form_asset_id = evaluate("attributes.asset_id#i#");
						form_project = evaluate("attributes.project#i#");
						form_project_id = evaluate("attributes.project_id#i#");
						form_authorized = evaluate("attributes.authorized#i#");
						form_total_expense_item = evaluate('attributes.total_expense_item#i#');
						form_expense_item_value = evaluate('attributes.expense_item_value#i#');
						form_sub_id = evaluate("attributes.subscription_id#i#");
						form_sub_name = evaluate("attributes.subscription_name#i#");
						
						form_activity_type = evaluate("attributes.activity_type#i#");
						form_workgroup_id = evaluate("attributes.workgroup_id#i#");
						
						form_rate_value_one = evaluate('attributes.rate_value_one#i#');
						form_rate_value_two = evaluate('attributes.rate_value_two#i#');
						
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
                        form_tevkifat_total_ = (form_tevkifat_total * form_tax_total_)/100;
						
						if(len(other_money_grosstotal))
							other_money_grosstotal_ = (other_money_grosstotal * form_expense_item_value)/100;
						else
							other_money_grosstotal_ = 0;
						if(len(other_money_value))
							other_money_value_ = (other_money_value * form_expense_item_value)/100;
						else
							other_money_value_ = 0;
							
						if(len(currency_2_rate))
							other_money_gross_total_2=wrk_round(form_total_expense_item/currency_2_rate,2);
						else
							other_money_gross_total_2= 0;
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
                            <cfif is_update eq 1>
                                UPDATE_IP,
                                UPDATE_EMP,
                                UPDATE_DATE,
                            </cfif>
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
                        (
                        	'#attributes.invoice_number#',
                            #invoice_cat#,
                            #attributes.invoice_row_id#,
                            <cfif len(form_expense_center_ids)>#form_expense_center_ids#,<cfelse>NULL,</cfif>
                            <cfif len(form_expense_item_id)>#form_expense_item_id#,<cfelse>NULL,</cfif>
                            <cfif len(attributes.name_product)>'#attributes.name_product#',<cfelse>NULL,</cfif>
                            <cfif len(form_member_type) and len(form_member_id) and len(form_authorized)>#form_member_id#,<cfelse>NULL,</cfif>
                            <cfif len(form_asset) and len(form_asset_id)>#form_asset_id#,<cfelse>NULL,</cfif>
                            <cfif len(form_project) and len(form_project_id)>#form_project_id#,<cfelse>NULL,</cfif>
                            <cfif len(form_activity_type)>#form_activity_type#,<cfelse>NULL,</cfif>
                            <cfif len(form_workgroup_id)>#form_workgroup_id#,<cfelse>NULL,</cfif>
                            #attributes.stock_id#,
                            <cfif len(row_expense_date)>#row_expense_date#,<cfelse>NULL,</cfif>
                            <cfif is_update eq 1>
                                '#form_record_ip#',
                                #form_record_emp#,
                                {ts '#form_record_date#'},
                            <cfelse>
                                '#cgi.remote_addr#',
                                #session.ep.userid#,
                                #now()#,
                            </cfif>
                            <cfif is_update eq 1>
                                '#cgi.remote_addr#',
                                #session.ep.userid#,
                                #now()#,
                            </cfif>
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
		</cfif>
	</cftransaction>
</cflock>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
