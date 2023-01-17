<cfquery name="get_rows_stocks" datasource="#dsn2#">
	SELECT
		SHIP_ROW.AMOUNT,
		SHIP_ROW.TAX,
		SHIP_ROW.STOCK_ID,
		SHIP_ROW.WRK_ROW_ID,
		SHIP.SHIP_DATE,
		SHIP.SHIP_ID,
		SHIP.DEPARTMENT_IN,
		SHIP.LOCATION_IN,
		SHIP.SHIP_DETAIL,
		SHIP.PROJECT_ID,
		SHIP.REF_NO,
		SHIP.OTHER_MONEY,
		SHIP.DELIVER_EMP_ID,
		SHIP_ROW.PRODUCT_ID,
		SHIP_ROW.STOCK_ID,
		SHIP_ROW.UNIT,
		SHIP_ROW.UNIT_ID,
		SUBSCRIPTION_ID
	FROM
		SHIP_ROW,
		SHIP 
	WHERE
		SHIP.SHIP_ID = SHIP_ROW.SHIP_ID 
		<cfif isdefined("ADD_PURCHASE_MAX_ID.IDENTITYCOL")>
			AND SHIP_ROW.SHIP_ID = #ADD_PURCHASE_MAX_ID.IDENTITYCOL#
		</cfif>
		<cfif isdefined("attributes.invent_return_row_ids") and listlen(attributes.invent_return_row_ids)>
			AND STOCK_ID IN (#attributes.invent_return_row_ids#)
		<cfelse>
			<cfif isdefined("ADD_PURCHASE_MAX_ID.IDENTITYCOL")>
				AND SHIP_ROW.SHIP_ID = #ADD_PURCHASE_MAX_ID.IDENTITYCOL#
			<cfelseif not isdefined("attributes.upd_id")>
				AND 1 = 0
			<cfelse>
				AND SHIP_ROW.SHIP_ID = #attributes.upd_id#
			</cfif>
		</cfif>
</cfquery>
<cfif len(get_rows_stocks.SUBSCRIPTION_ID)>
	<cfif not isDefined("wrk_id")><cfset wrk_id = dateformat(now(),'YYYYMMDD')&timeformat(now(),'HHmmss')&'_#session.ep.userid#_'&round(rand()*100)></cfif><!--- pda den gelen işlemler için --->
	<cfif isdefined("ADD_PURCHASE_MAX_ID.IDENTITYCOL")>
		<cfset row_ship_id = ADD_PURCHASE_MAX_ID.IDENTITYCOL>
	<cfelse>
		<cfset row_ship_id = attributes.upd_id>
	</cfif>
	<cfquery name="get_inventory_type" datasource="#dsn2#">
		SELECT PROCESS_TYPE,PROCESS_CAT_ID,IS_ACCOUNT,IS_ACCOUNT_GROUP,IS_BUDGET,IS_ACCOUNT_GROUP,IS_PROJECT_BASED_ACC,IS_BUDGET,IS_STOCK_ACTION,ACTION_FILE_NAME,ACTION_FILE_FROM_TEMPLATE,IS_COST FROM #dsn3_alias#.SETUP_PROCESS_CAT WHERE PROCESS_TYPE = 1182 AND IS_DEFAULT = 1
	</cfquery>
	<cfquery name="get_inv_stock" datasource="#dsn2#">
		SELECT * FROM STOCK_FIS WHERE RELATED_SHIP_ID = #row_ship_id#
	</cfquery>
	<cfif get_inv_stock.recordcount>
		<cfquery name="DEL_STOCKS_ROW" datasource="#dsn2#">
			DELETE FROM STOCKS_ROW WHERE PROCESS_TYPE=1182 AND UPD_ID IN(#valuelist(get_inv_stock.fis_id)#)
		</cfquery>
		<cfquery name="DEL_SHIP_ROW_MONEY" datasource="#dsn2#">
			DELETE FROM STOCK_FIS_MONEY WHERE ACTION_ID IN(#valuelist(get_inv_stock.fis_id)#)
		</cfquery>			
		<cfquery name="DEL_STOCK_FIS_ROW" datasource="#DSN2#">
			DELETE FROM STOCK_FIS_ROW WHERE FIS_ID IN(#valuelist(get_inv_stock.fis_id)#)
		</cfquery>
		<cfquery name="DEL_STOCK_FIS" datasource="#DSN2#">
			DELETE FROM STOCK_FIS WHERE FIS_ID IN(#valuelist(get_inv_stock.fis_id)#)
		</cfquery>
		<cfquery name="DEL_INVENTORY_ROW" datasource="#dsn2#">
			DELETE FROM #dsn3_alias#.INVENTORY_ROW WHERE ACTION_ID IN(#valuelist(get_inv_stock.fis_id)#) AND PROCESS_TYPE = 1182 AND PERIOD_ID = #session.ep.period_id#
		</cfquery>
	</cfif>
	<cfif get_inventory_type.recordcount eq 0>
		<script type="text/javascript">
			alert("Demirbaş Stok İade Fişi İşlem Kategorisi Tanımlayınız !");
			window.location.href='<cfoutput>#cgi.referer#</cfoutput>';
		</script>
		<cfabort>
	<cfelse>
		<cfif (get_inventory_type.is_cost eq 1 and get_process_type.is_cost eq 1) or (get_inventory_type.is_stock_action eq 1 and get_process_type.is_stock_action eq 1)>
			<script type="text/javascript">
				alert("Lütfen İşlem Kategorilerinizi Düzenleyiniz ! ");
				window.location.href='<cfoutput>#cgi.referer#</cfoutput>';
			</script>
			<cfabort>
		</cfif>
	</cfif>
	<cfif get_rows_stocks.recordcount>
		<cfquery name="GET_MONEY_INFO" datasource="#dsn2#">
			SELECT * FROM SHIP_MONEY WHERE ACTION_ID = #row_ship_id#
		</cfquery>
		<cfquery name="GET_BRANCH" datasource="#dsn2#">
			SELECT * FROM #dsn_alias#.DEPARTMENT WHERE DEPARTMENT_ID = #get_rows_stocks.DEPARTMENT_IN#
		</cfquery>
		<cfquery name="get_gen_paper_" datasource="#dsn2#">
			 SELECT * FROM #dsn3_alias#.GENERAL_PAPERS WHERE ZONE_TYPE = 0 AND STOCK_FIS_NO IS NOT NULL
		</cfquery>
		<cfset paper_code = evaluate('get_gen_paper_.STOCK_FIS_NO')>
		<cfset system_paper_no_add = evaluate('get_gen_paper_.STOCK_FIS_NUMBER') +1>
		<cfset attributes.FIS_NO = '#paper_code#-#system_paper_no_add#'>
		<cfscript>
			attributes.start_date = createodbcdatetime(get_rows_stocks.SHIP_DATE);
			attributes.process_cat = get_inventory_type.process_cat_id;//stok iade fişinin işlem kategorisi
			attributes.process_type = 1182;//stok iade fişinin işlem kategorisi
			is_stock_act = get_inventory_type.is_stock_action;
			is_budget = get_inventory_type.is_budget;
			is_account = get_inventory_type.is_account;
			is_project_based_acc = get_inventory_type.is_project_based_acc;
			is_account_group = get_inventory_type.is_account_group;
			attributes.kur_say = GET_MONEY_INFO.RECORDCOUNT;
			rd_money_value = get_rows_stocks.OTHER_MONEY;
			for(stp_mny=1;stp_mny lte GET_MONEY_INFO.RECORDCOUNT;stp_mny=stp_mny+1)
			{
				if(GET_MONEY_INFO.IS_SELECTED[stp_mny])
					attributes.rd_money = "#GET_MONEY_INFO.MONEY_TYPE[stp_mny]#,#stp_mny#,#GET_MONEY_INFO.RATE1[stp_mny]#,#GET_MONEY_INFO.RATE2[stp_mny]#";
				if(get_rows_stocks.OTHER_MONEY eq GET_MONEY_INFO.MONEY_TYPE[stp_mny])
					currency_mult_other = (GET_MONEY_INFO.RATE2[stp_mny]/GET_MONEY_INFO.RATE1[stp_mny]);
				if(GET_MONEY_INFO.MONEY_TYPE[stp_mny] is session.ep.money2)
					currency_multiplier = (GET_MONEY_INFO.RATE2[stp_mny]/GET_MONEY_INFO.RATE1[stp_mny]);
				'attributes.hidden_rd_money_#stp_mny#'=GET_MONEY_INFO.MONEY_TYPE[stp_mny];
				'attributes.txt_rate1_#stp_mny#'=GET_MONEY_INFO.RATE1[stp_mny];	
				'attributes.txt_rate2_#stp_mny#'=GET_MONEY_INFO.RATE2[stp_mny];
				'attributes.t_txt_rate1_#GET_MONEY_INFO.MONEY_TYPE[stp_mny]#'=GET_MONEY_INFO.RATE1[stp_mny];	
				'attributes.t_txt_rate2_#GET_MONEY_INFO.MONEY_TYPE[stp_mny]#'=GET_MONEY_INFO.RATE2[stp_mny];
			}
			attributes.department_id = get_rows_stocks.DEPARTMENT_IN;
			attributes.location_id = get_rows_stocks.LOCATION_IN;
			branch_id = GET_BRANCH.BRANCH_ID;
			branch_id_2 = '';
			if (len(get_rows_stocks.DELIVER_EMP_ID))
				deliver_get_id = get_rows_stocks.DELIVER_EMP_ID;
			else
				deliver_get_id = session.ep.userid;
	
			attributes.ref_no = get_rows_stocks.ref_no;
			attributes.project_id = get_rows_stocks.PROJECT_ID;
			attributes.project_head = get_rows_stocks.PROJECT_ID;
			attributes.detail = get_rows_stocks.SHIP_DETAIL;
			attributes.subscription_id = get_rows_stocks.SUBSCRIPTION_ID;
			related_ship_id = row_ship_id;
			row_info = 0;
		</cfscript>
		<cfloop query="get_rows_stocks">
			<cfset miktar_ = get_rows_stocks.AMOUNT>
            <cfset kalan_miktar_ = get_rows_stocks.AMOUNT>
            <cfif kalan_miktar_ gt 0>
				<cfset wrk_id_ = get_rows_stocks.WRK_ROW_ID>
                <cfset s_id_ = get_rows_stocks.STOCK_ID>
                <cfset subscription_id_ = get_rows_stocks.subscription_id>
                <cfquery name="get_periods" datasource="#dsn2#">
                    SELECT * FROM #dsn_alias#.SETUP_PERIOD WHERE OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> ORDER BY PERIOD_YEAR DESC	<!--- AND PERIOD_YEAR <= #session.ep.period_year# gecmise donuk stok iade fisi olusturabilmek icin yil kontolu kaldirildi 20140715 EsraNur --->
                </cfquery>					
                <cfquery name="get_system_inventory" datasource="#dsn2#">
                    SELECT
                        SUM(INV_TOTAL) AS TOTAL,
                        INVENTORY_ID,
                        INVENTORY_NAME,
                        AMORTIZATON_ESTIMATE,
                        ENTRY_DATE,
                        ACCOUNT_ID,
                        AMORT_DIFF_ACCOUNT_ID,
                        SALE_DIFF_ACCOUNT_ID,
                        EXPENSE_ITEM_ID,
                        EXPENSE_CENTER_ID,
                        LAST_INVENTORY_VALUE,
                        AMOUNT,
                        COMPANY_ID
                    FROM
                        (
                        <cfset count_ = 0>
                        <cfloop query="get_periods">
                            <cfset count_ = count_ + 1>
                            SELECT
                                SUM(IR.STOCK_IN-IR.STOCK_OUT) AS INV_TOTAL,
                                I.INVENTORY_ID,
                                I.INVENTORY_NAME,
                                I.AMORTIZATON_ESTIMATE,
                                I.ENTRY_DATE,
                                I.ACCOUNT_ID,
                                I.CLAIM_ACCOUNT_ID AMORT_DIFF_ACCOUNT_ID,
                                I.DEBT_ACCOUNT_ID SALE_DIFF_ACCOUNT_ID,
                                I.EXPENSE_ITEM_ID,
                                I.EXPENSE_CENTER_ID,
                                I.LAST_INVENTORY_VALUE,
                                I.AMOUNT,						
                                #get_periods.period_id# AS PERIOD_ID,
                                #get_periods.period_year# AS PERIOD_YEAR,
                                #session.ep.company_id# AS COMPANY_ID
                            FROM
                                #dsn3_alias#.INVENTORY I,
                                #dsn3_alias#.INVENTORY_ROW IR,
                                #dsn3_alias#.STOCKS S,
                                #dsn#_#get_periods.period_year#_#session.ep.company_id#.STOCK_FIS SF,
                                #dsn#_#get_periods.period_year#_#session.ep.company_id#.STOCK_FIS_ROW SFR
                            WHERE
                                I.INVENTORY_ID = IR.INVENTORY_ID AND
                                IR.ACTION_ID =  SF.FIS_ID AND
                                SFR.FIS_ID =  SF.FIS_ID AND
                                SFR.STOCK_ID = S.STOCK_ID AND
                                SFR.INVENTORY_ID = I.INVENTORY_ID AND
                                IR.PERIOD_ID = #get_periods.period_id# AND
                                I.SUBSCRIPTION_ID = #subscription_id_# AND
                                S.STOCK_ID = #s_id_#
                            GROUP BY
                                I.INVENTORY_ID,
                                I.INVENTORY_NAME,
                                I.AMORTIZATON_ESTIMATE,
                                I.ENTRY_DATE,
                                I.ACCOUNT_ID,
                                I.CLAIM_ACCOUNT_ID,
                                I.DEBT_ACCOUNT_ID,
                                I.EXPENSE_ITEM_ID,
                                I.EXPENSE_CENTER_ID,
                                I.LAST_INVENTORY_VALUE,
                                I.AMOUNT
                            <cfif get_periods.recordcount neq count_>UNION ALL</cfif>
                        </cfloop>
                        ) AS SATIRLAR
                    GROUP BY
                        INVENTORY_ID,
                        INVENTORY_NAME,
                        AMORTIZATON_ESTIMATE,
                        ENTRY_DATE,
                        ACCOUNT_ID,
                        AMORT_DIFF_ACCOUNT_ID,
                        SALE_DIFF_ACCOUNT_ID,
                        EXPENSE_ITEM_ID,
                        EXPENSE_CENTER_ID,
                        LAST_INVENTORY_VALUE,
                        AMOUNT,
                        COMPANY_ID
                    ORDER BY
                        ENTRY_DATE
                </cfquery>
                <cfoutput query="get_system_inventory">
                    <cfif TOTAL gt 0>
                        <cfif kalan_miktar_ gt TOTAL>
                            <cfset row_amount = TOTAL>
                            <cfset kalan_miktar_ = kalan_miktar_ - TOTAL>
                        <cfelse>
                            <cfset row_amount = kalan_miktar_>
                            <cfset kalan_miktar_ = 0>
                        </cfif>
                        <cfif isdefined("used_amount_#get_system_inventory.inventory_id#_#get_rows_stocks.ship_id#")>
                            <cfset row_amount = row_amount - evaluate("used_amount_#get_system_inventory.inventory_id#_#get_rows_stocks.ship_id#")>
                        </cfif>
                        <cfif row_amount gt 0>
                            <cfscript>
                                if(isdefined("used_amount_#get_system_inventory.inventory_id#_#get_rows_stocks.ship_id#"))
                                    "used_amount_#get_system_inventory.inventory_id#_#get_rows_stocks.ship_id#" = evaluate("used_amount_#get_system_inventory.inventory_id#_#get_rows_stocks.ship_id#")+row_amount;
                                else
                                    "used_amount_#get_system_inventory.inventory_id#_#get_rows_stocks.ship_id#" = row_amount;
                                row_info = row_info + 1;
                                row_gross_total = get_system_inventory.last_inventory_value;
                                row_rate_1 = evaluate('attributes.t_txt_rate1_#get_rows_stocks.OTHER_MONEY#');
                                row_rate_2 = evaluate('attributes.t_txt_rate2_#get_rows_stocks.OTHER_MONEY#');
                                row_currency_mult = row_rate_2 / row_rate_1;
                                row_other_gross_total = wrk_round(get_system_inventory.last_inventory_value/row_currency_mult,4);
                                'attributes.row_kontrol#row_info#' = 1;
                                'attributes.quantity#row_info#' = row_amount;
                                'attributes.invent_id#row_info#' = inventory_id;
                                'attributes.amortization_rate#row_info#' = amortizaton_estimate;
                                'attributes.invent_name#row_info#' = inventory_name;
                                'attributes.row_total#row_info#' = row_gross_total;
                                'attributes.expense_center_id#row_info#' = get_system_inventory.expense_center_id;
                                'attributes.expense_center_name#row_info#' = get_system_inventory.expense_center_id;
                                'attributes.budget_item_id#row_info#' = get_system_inventory.expense_item_id;
                                'attributes.amort_account_id#row_info#' = get_system_inventory.amort_diff_account_id;
                                'attributes.account_id#row_info#' = get_system_inventory.account_id;
                                'attributes.budget_account_id#row_info#' = get_system_inventory.sale_diff_account_id;
                                'attributes.budget_item_name#row_info#' = "Gider Kalemi";
                                'attributes.subscription_id#row_info#' = get_rows_stocks.SUBSCRIPTION_ID;
                                'attributes.stock_id#row_info#' = get_rows_stocks.STOCK_ID;
                                'attributes.product_id#row_info#' = get_rows_stocks.PRODUCT_ID;
                                'attributes.stock_unit#row_info#' = get_rows_stocks.UNIT;
                                'attributes.stock_unit_id#row_info#' = get_rows_stocks.UNIT_ID;
                                'attributes.row_other_total#row_info#' = row_other_gross_total;
                                'attributes.tax_rate#row_info#' = 0;
                                'attributes.kdv_total#row_info#' = 0;
                                'attributes.money_id#row_info#' = get_rows_stocks.OTHER_MONEY;
                                'attributes.unit_first_value#row_info#' = get_system_inventory.amount;
                                'attributes.total_first_value#row_info#' = wrk_round(get_system_inventory.amount*kalan_miktar_,4);
                                'attributes.unit_last_value#row_info#' = row_gross_total;
                                'attributes.last_diff_value#row_info#' = 0;
                                'attributes.last_inventory_value#row_info#' = last_inventory_value;
                            </cfscript>
                        </cfif>
                    </cfif>
                </cfoutput>
        	</cfif>
		</cfloop>
		<cfif row_info gt 0>
			<cfset attributes.record_num = row_info>
			<cfinclude template="../../inventory/query/add_invent_stock_fis_return_ic.cfm">
			<cfquery name="UPD_GEN_PAP" datasource="#DSN2#">
				UPDATE 
					#dsn3_alias#.GENERAL_PAPERS
				SET
					STOCK_FIS_NUMBER = #system_paper_no_add#
				WHERE
					STOCK_FIS_NUMBER IS NOT NULL
			</cfquery>
		</cfif>
	</cfif>
</cfif>

