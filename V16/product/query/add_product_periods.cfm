<cflock name="#createuuid()#" timeout="60">
	<cftransaction>
		<cfset mylist=ListToArray(attributes.for_control)>
		<cfquery name="DEL_PERIODS" datasource="#DSN3#">
			DELETE FROM	PRODUCT_PERIOD WHERE PRODUCT_ID=#attributes.product_id# AND PERIOD_ID=#attributes.period_main_id#
		</cfquery>
		<cfquery name="DEL_TAX" datasource="#DSN3#">
			DELETE FROM	PRODUCT_TAX WHERE PRODUCT_ID=#attributes.product_id# AND OUR_COMPANY_ID=#attributes.company_main_id#
		</cfquery>
		<cfset muhasebe_kodu = evaluate("account_code_sale")>
		<cfset muhasebe_kodu_purchase = evaluate("account_code_purchase")>
		<cfquery name="ADD_PRODUCT_PERIODS" datasource="#DSN3#">
			INSERT INTO 
				PRODUCT_PERIOD
            (
                PRODUCT_ID,
                PERIOD_ID,
                ACCOUNT_CODE,
                ACCOUNT_CODE_PUR,
                ACCOUNT_DISCOUNT,
                ACCOUNT_PRICE,
                ACCOUNT_PRICE_PUR,
                ACCOUNT_PUR_IADE,
                ACCOUNT_IADE,
                ACCOUNT_DISCOUNT_PUR,
                ACCOUNT_YURTDISI,					
                ACCOUNT_YURTDISI_PUR,
                EXPENSE_CENTER_ID,
                EXPENSE_ITEM_ID,
                INCOME_ITEM_ID,
                EXPENSE_TEMPLATE_ID,
                ACTIVITY_TYPE_ID,
                COST_EXPENSE_CENTER_ID,
                INCOME_ACTIVITY_TYPE_ID,
                INCOME_TEMPLATE_ID,
                ACCOUNT_LOSS,
                ACCOUNT_EXPENDITURE,
                OVER_COUNT,
                UNDER_COUNT,
                PRODUCTION_COST,
                HALF_PRODUCTION_COST,
                SALE_PRODUCT_COST,
                SALE_MANUFACTURED_COST,
                SCRAP_CODE,
                MATERIAL_CODE,
                KONSINYE_PUR_CODE,
                KONSINYE_SALE_CODE,
                KONSINYE_SALE_NAZ_CODE,
                DIMM_CODE,
                DIMM_YANS_CODE,
                PROMOTION_CODE,
                PRODUCT_PERIOD_CAT_ID,
                INVENTORY_CODE,
                INVENTORY_CAT_ID,
                AMORTIZATION_METHOD_ID,
                AMORTIZATION_TYPE_ID,
                AMORTIZATION_EXP_CENTER_ID,
                AMORTIZATION_EXP_ITEM_ID,
                AMORTIZATION_CODE,
                PROD_GENERAL_CODE,
                PROD_LABOR_COST_CODE,
                RECEIVED_PROGRESS_CODE,
                PROVIDED_PROGRESS_CODE,
                MATERIAL_CODE_SALE,
                PRODUCTION_COST_SALE,
                SCRAP_CODE_SALE,
                TAX_CODE,
                TAX_CODE_NAME,
                TAX,
                EXE_VAT_SALE_INVOICE,
                DISCOUNT_EXPENSE_CENTER_ID,
                DISCOUNT_EXPENSE_ITEM_ID,
                DISCOUNT_ACTIVITY_TYPE_ID,
                RECORD_IP,
                RECORD_DATE,
                RECORD_EMP,
                REASON_CODE,
                ACCRUAL_MONTH,
                ACCRUAL_MONTH_IFRS,
                ACCRUAL_INCOME_ITEM_ID,
                ACCRUAL_EXPENSE_ITEM_ID,
                NEXT_MONTH_INCOMES_ACC_CODE,
                NEXT_YEAR_INCOMES_ACC_CODE,
                NEXT_MONTH_EXPENSES_ACC_CODE,
                NEXT_YEAR_EXPENSES_ACC_CODE,
                SALES_PAYMETHOD_ID,
                PURCHASE_PAYMETHOD_ID,
                FIRST_12_TO_MONTH,
                START_FROM_DELIVERY_DATE,
                DISTRIBUTE_TO_FISCAL_END,
                DISTRIBUTE_DAY_BASED,
                FIRST_12_TO_MONTH_IFRS,
                START_FROM_DELIVERY_DATE_IFRS,
                DISTRIBUTE_TO_FISCAL_END_IFRS,
                DISTRIBUTE_DAY_BASED_IFRS,
                PAST_MONTHS_TO_FIRST,
                PAST_MONTHS_TO_FIRST_IFRS,
                NEXT_MONTH_INCOMES_ACC_KEY,
                NEXT_YEAR_INCOMES_ACC_KEY,
                NEXT_MONTH_EXPENSES_ACC_KEY,
                NEXT_YEAR_EXPENSES_ACC_KEY,
                ACCRUAL_MONTH_BUDGET,
                INCOMING_STOCK,
				OUTGOING_STOCK,
                ACCOUNT_EXPORTREGISTERED
            )
            VALUES
            (
                #attributes.product_id#,
                #attributes.period_main_id#,
                <cfif isdefined("muhasebe_kodu") and len(muhasebe_kodu)>'#muhasebe_kodu#',<cfelse>NULL,</cfif>
                <cfif isdefined("muhasebe_kodu_purchase") and len(muhasebe_kodu_purchase)>'#muhasebe_kodu_purchase#',<cfelse>NULL,</cfif>
                <cfif isdefined("ACCOUNT_DISCOUNT") and len(ACCOUNT_DISCOUNT)>'#ACCOUNT_DISCOUNT#',<cfelse>NULL,</cfif>
                <cfif isdefined("ACCOUNT_PRICE") and len(ACCOUNT_PRICE)>'#ACCOUNT_PRICE#',<cfelse>NULL,</cfif>
                <cfif isdefined("ACCOUNT_PRICE_PUR") and len(ACCOUNT_PRICE_PUR)>'#ACCOUNT_PRICE_PUR#'<cfelse>NULL</cfif>,
                <cfif isdefined("ACCOUNT_PUR_IADE") and len(ACCOUNT_PUR_IADE)>'#ACCOUNT_PUR_IADE#',<cfelse>NULL,</cfif>
                <cfif isdefined("ACCOUNT_IADE") and len(ACCOUNT_IADE)>'#ACCOUNT_IADE#',<cfelse>NULL,</cfif>
                <cfif isdefined("ACCOUNT_DISCOUNT_PUR") and len(ACCOUNT_DISCOUNT_PUR)>'#ACCOUNT_DISCOUNT_PUR#',<cfelse>NULL,</cfif>
                <cfif isdefined("ACCOUNT_YURTDISI") and len(ACCOUNT_YURTDISI)>'#ACCOUNT_YURTDISI#',<cfelse>NULL,</cfif>
                <cfif isdefined("ACCOUNT_YURTDISI_PUR") and len(ACCOUNT_YURTDISI_PUR)>'#ACCOUNT_YURTDISI_PUR#',<cfelse>NULL,</cfif>
                <cfif isdefined("attributes.expense_center") and len(attributes.expense_center) and isDefined("attributes.expense1") and len(attributes.expense1)>#attributes.expense_center#,<cfelse>NULL,</cfif>
                <cfif isdefined("attributes.expense_item") and len(attributes.expense_item) and isdefined("attributes.expense_item_name") and len(attributes.expense_item_name)>#attributes.expense_item#,<cfelse>NULL,</cfif>
                <cfif isdefined("attributes.income_item") and len(attributes.income_item) and isdefined("attributes.expense_item_name1") and len(attributes.expense_item_name1)>#attributes.income_item#,<cfelse>NULL,</cfif>
                <cfif isdefined("attributes.expense_template") and len(attributes.expense_template)>#attributes.expense_template#,<cfelse>NULL,</cfif>
                <cfif isdefined("attributes.activity_type") and len(attributes.activity_type)>#attributes.activity_type#,<cfelse>NULL,</cfif>
                <cfif isdefined("attributes.expense_center_gider") and len(attributes.expense_center_gider) and isdefined("attributes.expense") and len(attributes.expense)>#attributes.expense_center_gider#<cfelse>NULL</cfif>,
                <cfif isdefined("attributes.activity_type_income") and len(attributes.activity_type_income)>#attributes.activity_type_income#<cfelse>NULL</cfif>,
                <cfif isdefined("attributes.expense_template_income") and len(attributes.expense_template_income)>#attributes.expense_template_income#<cfelse>NULL</cfif>,
                <cfif isdefined("ACCOUNT_LOSS") and len(ACCOUNT_LOSS)>'#ACCOUNT_LOSS#',<cfelse>NULL,</cfif>
                <cfif isdefined("ACCOUNT_EXPENDITURE") and len(ACCOUNT_EXPENDITURE)>'#ACCOUNT_EXPENDITURE#',<cfelse>NULL,</cfif>
                <cfif isdefined("OVER_COUNT") and len(OVER_COUNT)>'#OVER_COUNT#',<cfelse>NULL,</cfif>
                <cfif isdefined("UNDER_COUNT") and len(UNDER_COUNT)>'#UNDER_COUNT#',<cfelse>NULL,</cfif>
                <cfif isdefined("PRODUCTION_COST") and len(PRODUCTION_COST)>'#PRODUCTION_COST#',<cfelse>NULL,</cfif>
                <cfif isdefined("HALF_PRODUCTION_COST") and len(HALF_PRODUCTION_COST)>'#HALF_PRODUCTION_COST#',<cfelse>NULL,</cfif>
                <cfif isdefined("SALE_PRODUCT_COST") and len(SALE_PRODUCT_COST)>'#SALE_PRODUCT_COST#',<cfelse>NULL,</cfif>
                <cfif isdefined("SALE_MANUFACTURED_COST") and len(SALE_MANUFACTURED_COST)>'#SALE_MANUFACTURED_COST#',<cfelse>NULL,</cfif>
                <cfif isdefined("SCRAP_CODE") and len(SCRAP_CODE)>'#SCRAP_CODE#',<cfelse>NULL,</cfif>
                <cfif isdefined("MATERIAL_CODE") and len(MATERIAL_CODE)>'#MATERIAL_CODE#',<cfelse>NULL,</cfif>
                <cfif isdefined("KONSINYE_PUR_CODE") and len(KONSINYE_PUR_CODE)>'#KONSINYE_PUR_CODE#',<cfelse>NULL,</cfif>
                <cfif isdefined("KONSINYE_SALE_CODE") and len(KONSINYE_SALE_CODE)>'#KONSINYE_SALE_CODE#',<cfelse>NULL,</cfif>
                <cfif isdefined("KONSINYE_SALE_NAZ_CODE") and len(KONSINYE_SALE_NAZ_CODE)>'#KONSINYE_SALE_NAZ_CODE#',<cfelse>NULL,</cfif>
                <cfif isdefined("DIMM_CODE") and len(DIMM_CODE)>'#DIMM_CODE#',<cfelse>NULL,</cfif>
                <cfif isdefined("DIMM_YANS_CODE") and len(DIMM_YANS_CODE)>'#DIMM_YANS_CODE#',<cfelse>NULL,</cfif>
                <cfif isdefined("PROMOTION_CODE") and len(PROMOTION_CODE)>'#PROMOTION_CODE#',<cfelse>NULL,</cfif>
                <cfif len(attributes.product_period_cat_id)>#attributes.product_period_cat_id#<cfelse>NULL</cfif>,
                <cfif isdefined("INVENTORY_CODE") and len(INVENTORY_CODE)>'#INVENTORY_CODE#'<cfelse>NULL</cfif>,
                <cfif len(attributes.inventory_cat_id) and len(attributes.inventory_cat)>#attributes.inventory_cat_id#<cfelse>NULL</cfif>,
                <cfif isdefined("attributes.AMORTIZATION_METHOD_ID") and len(attributes.AMORTIZATION_METHOD_ID)>#attributes.AMORTIZATION_METHOD_ID#<cfelse>NULL</cfif>,
                <cfif isdefined("attributes.AMORTIZATION_TYPE_ID") and len(attributes.AMORTIZATION_TYPE_ID)>#attributes.AMORTIZATION_TYPE_ID#<cfelse>NULL</cfif>,
                <cfif isdefined("attributes.AMORTIZATION_EXP_CENTER_ID") and len(attributes.AMORTIZATION_EXP_CENTER_ID)>#attributes.AMORTIZATION_EXP_CENTER_ID#<cfelse>NULL</cfif>,
                <cfif isdefined("attributes.AMORTIZATION_EXP_ITEM_ID") and len(attributes.AMORTIZATION_EXP_ITEM_ID)>#attributes.AMORTIZATION_EXP_ITEM_ID#<cfelse>NULL</cfif>,
                '#attributes.AMORTIZATION_CODE#',
                <cfif isdefined("PROD_GENERAL_CODE") and len(PROD_GENERAL_CODE)>'#PROD_GENERAL_CODE#',<cfelse>NULL,</cfif>
                <cfif isdefined("PROD_LABOR_COST_CODE") and len(PROD_LABOR_COST_CODE)>'#PROD_LABOR_COST_CODE#',<cfelse>NULL,</cfif>
                <cfif isdefined("GET_RECEIVED_CODE") and len(GET_RECEIVED_CODE)>'#GET_RECEIVED_CODE#'<cfelse>NULL</cfif>,
                <cfif isdefined("GET_PROVIDED_CODE") and len(GET_PROVIDED_CODE)>'#GET_PROVIDED_CODE#'<cfelse>NULL</cfif>,
                <cfif isdefined("MATERIAL_CODE_SALE") and len(MATERIAL_CODE_SALE)>'#MATERIAL_CODE_SALE#'<cfelse>NULL</cfif>,
                <cfif isdefined("PRODUCTION_COST_SALE") and len(PRODUCTION_COST_SALE)>'#PRODUCTION_COST_SALE#'<cfelse>NULL</cfif>,
                <cfif isdefined("SCRAP_CODE_SALE") and len(SCRAP_CODE_SALE)>'#SCRAP_CODE_SALE#'<cfelse>NULL</cfif>,
                <cfif isdefined("attributes.tax_code") and len(attributes.tax_code)>'#listfirst(attributes.tax_code,';')#'<cfelse>NULL</cfif>,
                <cfif isdefined("attributes.tax_code") and len(attributes.tax_code)>'#listlast(attributes.tax_code,';')#'<cfelse>NULL</cfif>,
                <cfif isdefined("attributes.tax_code") and len(attributes.tax_code) and isdefined("attributes.tax_code2") and len(attributes.tax_code2)>#attributes.tax_code2#<cfelse>NULL</cfif>,	
				<cfif isdefined("exe_vat_sale_invoice") and len(exe_vat_sale_invoice)>'#exe_vat_sale_invoice#'<cfelse>NULL</cfif>,
                <cfif isdefined("discount_expense_center") and len(discount_expense_center) and len(discount_expense_center_name)>'#discount_expense_center#'<cfelse>NULL</cfif>,	 				
                <cfif isdefined("attributes.discount_expense_item") and len(attributes.discount_expense_item) and len(attributes.discount_expense_item_name)>#attributes.discount_expense_item#,<cfelse>NULL,</cfif>
                <cfif isdefined("attributes.discount_activity_type") and len(attributes.discount_activity_type)>#attributes.discount_activity_type#,<cfelse>NULL,</cfif>
                '#cgi.remote_addr#',
                 #now()#,
                 #session.ep.userid#,
                <cfif isdefined("attributes.reason_code") and len(attributes.reason_code)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#attributes.reason_code#"><cfelse>NULL</cfif>,
                <cfif isdefined("attributes.accrual_month") and len(attributes.accrual_month)><cfqueryparam cfsqltype="cf_sql_numeric" value="#attributes.accrual_month#"><cfelse>NULL</cfif>,
                <cfif isdefined("attributes.accrual_month_ifrs") and len(attributes.accrual_month_ifrs)><cfqueryparam cfsqltype="cf_sql_numeric" value="#attributes.accrual_month_ifrs#"><cfelse>NULL</cfif>,
                <cfif isdefined("attributes.accrual_income_item_id") and len(attributes.accrual_income_item_id)><cfqueryparam cfsqltype="cf_sql_numeric" value="#attributes.accrual_income_item_id#"><cfelse>NULL</cfif>,
                <cfif isdefined("attributes.accrual_expense_item_id") and len(attributes.accrual_expense_item_id)><cfqueryparam cfsqltype="cf_sql_numeric" value="#attributes.accrual_expense_item_id#"><cfelse>NULL</cfif>,
                <cfif isdefined("attributes.next_month_incomes_acc_code") and len(attributes.next_month_incomes_acc_code)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#attributes.next_month_incomes_acc_code#"><cfelse>NULL</cfif>,
                <cfif isdefined("attributes.next_year_incomes_acc_code") and len(attributes.next_year_incomes_acc_code)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#attributes.next_year_incomes_acc_code#"><cfelse>NULL</cfif>,
                <cfif isdefined("attributes.next_month_expenses_acc_code") and len(attributes.next_month_expenses_acc_code)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#attributes.next_month_expenses_acc_code#"><cfelse>NULL</cfif>,
                <cfif isdefined("attributes.next_year_expenses_acc_code") and len(attributes.next_year_expenses_acc_code)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#attributes.next_year_expenses_acc_code#"><cfelse>NULL</cfif>,
                <cfif isdefined("attributes.SALES_PAYMETHOD_ID") and len(attributes.SALES_PAYMETHOD) and len(attributes.SALES_PAYMETHOD_ID)><cfqueryparam cfsqltype="cf_sql_numeric" value="#attributes.SALES_PAYMETHOD_ID#"><cfelse>NULL</cfif>,
                <cfif isdefined("attributes.PURCHASE_PAYMETHOD_ID") and len(attributes.PURCHASE_PAYMETHOD) and len(attributes.PURCHASE_PAYMETHOD_ID)><cfqueryparam cfsqltype="cf_sql_numeric" value="#attributes.PURCHASE_PAYMETHOD_ID#"><cfelse>NULL</cfif>,
                <cfif isdefined("attributes.first_12_to_month") and len(attributes.first_12_to_month)>1<cfelse>0</cfif>,
                <cfif isdefined("attributes.start_from_delivery_date") and len(attributes.start_from_delivery_date)>1<cfelse>0</cfif>,
                <cfif isdefined("attributes.distribute_to_fiscal_end") and len(attributes.distribute_to_fiscal_end)>1<cfelse>0</cfif>,
                <cfif isdefined("attributes.distribute_day_based") and len(attributes.distribute_day_based)>1<cfelse>0</cfif>,
                <cfif isdefined("attributes.first_12_to_month_ifrs") and len(attributes.first_12_to_month_ifrs)>1<cfelse>0</cfif>,
                <cfif isdefined("attributes.start_from_delivery_date_ifrs") and len(attributes.start_from_delivery_date_ifrs)>1<cfelse>0</cfif>,
                <cfif isdefined("attributes.distribute_to_fiscal_end_ifrs") and len(attributes.distribute_to_fiscal_end_ifrs)>1<cfelse>0</cfif>,
                <cfif isdefined("attributes.distribute_day_based_ifrs") and len(attributes.distribute_day_based_ifrs)>1<cfelse>0</cfif>,
                <cfif isdefined("attributes.past_months_to_first") and len(attributes.past_months_to_first)>1<cfelse>0</cfif>,
                <cfif isdefined("attributes.past_months_to_first_ifrs") and len(attributes.past_months_to_first_ifrs)>1<cfelse>0</cfif>,
                <cfif isdefined("attributes.next_month_incomes_acc_key") and len(attributes.next_month_incomes_acc_key)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#attributes.next_month_incomes_acc_key#"><cfelse>NULL</cfif>,
                <cfif isdefined("attributes.next_year_incomes_acc_key") and len(attributes.next_year_incomes_acc_key)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#attributes.next_year_incomes_acc_key#"><cfelse>NULL</cfif>,
                <cfif isdefined("attributes.next_month_expenses_acc_key") and len(attributes.next_month_expenses_acc_key)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#attributes.next_month_expenses_acc_key#"><cfelse>NULL</cfif>,
                <cfif isdefined("attributes.next_year_expenses_acc_key") and len(attributes.next_year_expenses_acc_key)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#attributes.next_year_expenses_acc_key#"><cfelse>NULL</cfif>,
                <cfif isdefined("attributes.accrual_month_budget") and len(attributes.accrual_month_budget)><cfqueryparam cfsqltype="cf_sql_numeric" value="#attributes.accrual_month_budget#"><cfelse>NULL</cfif>,                
				<cfif isdefined("attributes.incoming_stock") and len(attributes.incoming_stock)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#attributes.incoming_stock#"><cfelse>NULL</cfif>,
				<cfif isdefined("attributes.outgoing_stock") and len(attributes.outgoing_stock)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#attributes.outgoing_stock#"><cfelse>NULL</cfif>,
				<cfif isdefined("attributes.account_exportregistered") and len(attributes.account_exportregistered)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#attributes.account_exportregistered#"><cfelse>NULL</cfif>
              )
		</cfquery>
		<cfquery name="add_tax" datasource="#dsn3#">
			INSERT INTO
				PRODUCT_TAX
			(
				PRODUCT_ID,
				OUR_COMPANY_ID,
				TAX,
				TAX_PURCHASE,
				OTV
			)
			VALUES
			(
				#attributes.product_id#,
				#attributes.company_main_id#,
				<cfif isdefined("attributes.tax") and len(attributes.tax)>#attributes.tax#,<cfelse>NULL,</cfif>
				<cfif isdefined("attributes.tax_purchase") and len(attributes.tax_purchase)>#attributes.tax_purchase#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.otv") and len(attributes.otv)>#attributes.otv#<cfelse>NULL</cfif>
			)
		</cfquery>
	</cftransaction>
</cflock>
<script type="text/javascript">
    <cfif not isdefined("attributes.draggable")>
        window.close();
    <cfelse>
        closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );
        location.reload();
    </cfif>
</script>
