<cflock name="#CREATEUUID()#" timeout="20">
	<cftransaction>
		<cfquery name="ADD_PRODUCT_PERIODS" datasource="#DSN3#">
			UPDATE
				SETUP_PRODUCT_PERIOD_CAT
			SET
				IS_ACTIVE = <cfif isdefined('attributes.is_active')>1<cfelse>0</cfif>,  
				PRO_CODE_CAT_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#PRO_CODE_CAT_NAME#">,
				ACCOUNT_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ACCOUNT_CODE_SALE#">,
				ACCOUNT_CODE_PUR = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ACCOUNT_CODE_PURCHASE#">,
				ACCOUNT_DISCOUNT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ACCOUNT_DISCOUNT#">,
				ACCOUNT_PRICE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ACCOUNT_PRICE#">,
				ACCOUNT_PRICE_PUR = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ACCOUNT_PRICE_PUR#">,
				ACCOUNT_PUR_IADE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ACCOUNT_PUR_IADE#">,
				ACCOUNT_IADE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ACCOUNT_IADE#">,
				ACCOUNT_YURTDISI = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ACCOUNT_YURTDISI#">,
				ACCOUNT_YURTDISI_PUR = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ACCOUNT_YURTDISI_PUR#">,
				ACCOUNT_DISCOUNT_PUR = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ACCOUNT_DISCOUNT_PUR#">,
				ACCOUNT_LOSS = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ACCOUNT_LOSS#">,
				ACCOUNT_EXPENDITURE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ACCOUNT_EXPENDITURE#">,
				OVER_COUNT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#OVER_COUNT#">,
				UNDER_COUNT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#UNDER_COUNT#">,
				PRODUCTION_COST = <cfqueryparam cfsqltype="cf_sql_varchar" value="#PRODUCTION_COST#">,
				HALF_PRODUCTION_COST = <cfqueryparam cfsqltype="cf_sql_varchar" value="#HALF_PRODUCTION_COST#">,
				SALE_PRODUCT_COST = <cfqueryparam cfsqltype="cf_sql_varchar" value="#SALE_PRODUCT_COST#">,
				SALE_MANUFACTURED_COST = <cfqueryparam cfsqltype="cf_sql_varchar" value="#SALE_MANUFACTURED_COST#">,
				DETAIL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#DETAIL#">,
				MATERIAL_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#MATERIAL_CODE#">,
				KONSINYE_PUR_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#KONSINYE_PUR_CODE#">,
				KONSINYE_SALE_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#KONSINYE_SALE_CODE#">,
				KONSINYE_SALE_NAZ_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#KONSINYE_SALE_NAZ_CODE#">,
				DIMM_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#DIMM_CODE#">,
				DIMM_YANS_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#DIMM_YANS_CODE#">,
				PROMOTION_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#PROMOTION_CODE#">,
				EXP_CENTER_ID = <cfif len(attributes.exp_center_id)>#attributes.exp_center_id#<cfelse>NULL</cfif>,
				EXP_ITEM_ID = <cfif len(attributes.exp_item_id)>#attributes.exp_item_id#<cfelse>NULL</cfif>,
				EXP_TEMPLATE_ID = <cfif len(attributes.exp_template_id)>#attributes.exp_template_id#<cfelse>NULL</cfif>,
				EXP_ACTIVITY_TYPE_ID = <cfif len(attributes.exp_activity_type_id)>#attributes.exp_activity_type_id#<cfelse>NULL</cfif>,
				INC_CENTER_ID = <cfif len(attributes.inc_center_id)>#attributes.inc_center_id#<cfelse>NULL</cfif>,
				INC_ITEM_ID = <cfif len(attributes.inc_item_id)>#attributes.inc_item_id#<cfelse>NULL</cfif>,
				INC_TEMPLATE_ID = <cfif len(attributes.inc_template_id)>#attributes.inc_template_id#<cfelse>NULL</cfif>,
				INC_ACTIVITY_TYPE_ID = <cfif len(attributes.inc_activity_type_id)>#attributes.inc_activity_type_id#<cfelse>NULL</cfif>,
				INVENTORY_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#INVENTORY_CODE#">,
				INVENTORY_CAT_ID = <cfif len(attributes.inventory_cat_id) and len(attributes.inventory_cat)>#attributes.inventory_cat_id#<cfelse>NULL</cfif>,
				AMORTIZATION_METHOD_ID = <cfif len(attributes.AMORTIZATION_METHOD_ID)>#attributes.AMORTIZATION_METHOD_ID#<cfelse>NULL</cfif>,
				AMORTIZATION_TYPE_ID = <cfif len(attributes.AMORTIZATION_TYPE_ID)>#attributes.AMORTIZATION_TYPE_ID#<cfelse>NULL</cfif>,
				AMORTIZATION_EXP_CENTER_ID = <cfif len(attributes.AMORTIZATION_EXP_CENTER_ID)>#attributes.AMORTIZATION_EXP_CENTER_ID#<cfelse>NULL</cfif>,
				AMORTIZATION_EXP_ITEM_ID = <cfif len(attributes.AMORTIZATION_EXP_ITEM_ID)>#attributes.AMORTIZATION_EXP_ITEM_ID#<cfelse>NULL</cfif>,
				AMORTIZATION_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.AMORTIZATION_CODE#">,
				PROD_GENERAL_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.PROD_GENERAL_CODE#">,
				PROD_LABOR_COST_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.PROD_LABOR_COST_CODE#">,
                RECEIVED_PROGRESS_CODE=<cfif len(get_progress_code)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_PROGRESS_CODE#"><cfelse>NULL</cfif>,
                PROVIDED_PROGRESS_CODE=<cfif len(submitted_progress_code)><cfqueryparam cfsqltype="cf_sql_varchar" value="#SUBMITTED_PROGRESS_CODE#"><cfelse>NULL</cfif>,
				SCRAP_CODE = <cfif len(scrap_code)><cfqueryparam cfsqltype="cf_sql_varchar" value="#SCRAP_CODE#"><cfelse>NULL</cfif>,
				MATERIAL_CODE_SALE = <cfif len(material_code_sale)><cfqueryparam cfsqltype="cf_sql_varchar" value="#MATERIAL_CODE_SALE#"><cfelse>NULL</cfif>,
				PRODUCTION_COST_SALE = <cfif len(production_cost_sale)><cfqueryparam cfsqltype="cf_sql_varchar" value="#PRODUCTION_COST_SALE#"><cfelse>NULL</cfif>,
				SCRAP_CODE_SALE = <cfif len(scrap_code_sale)><cfqueryparam cfsqltype="cf_sql_varchar" value="#SCRAP_CODE_SALE#"><cfelse>NULL</cfif>,
				EXPENSE_PROGRESS_CODE = <cfif len(expense_progress_code)><cfqueryparam cfsqltype="cf_sql_varchar" value="#EXPENSE_PROGRESS_CODE#"><cfelse>NULL</cfif>,
				INCOME_PROGRESS_CODE = <cfif len(income_progress_code)><cfqueryparam cfsqltype="cf_sql_varchar" value="#INCOME_PROGRESS_CODE#"><cfelse>NULL</cfif>,
				EXE_VAT_SALE_INVOICE = <cfif len(exe_vat_sale_invoice)><cfqueryparam cfsqltype="cf_sql_varchar" value="#exe_vat_sale_invoice#"><cfelse>NULL</cfif>,
				DISCOUNT_EXPENSE_CENTER_ID  = <cfif len(discount_expense_center_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#discount_expense_center_id#"><cfelse>NULL</cfif>,
				DISCOUNT_EXPENSE_ITEM_ID =   <cfif len(discount_expense_item_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#discount_expense_item_id#"><cfelse>NULL</cfif>,
				DISCOUNT_ACTIVITY_TYPE_ID =  <cfif len(discount_activity_type)><cfqueryparam cfsqltype="cf_sql_integer" value="#discount_activity_type#"><cfelse>NULL</cfif>,
				REASON_CODE = <cfif isdefined("attributes.reason_code") and len(attributes.reason_code)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#attributes.reason_code#"><cfelse>NULL</cfif>,
				INCOMING_STOCK = <cfif isdefined("attributes.incoming_stock") and len(attributes.incoming_stock)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#attributes.incoming_stock#"><cfelse>NULL</cfif>,
				OUTGOING_STOCK = <cfif isdefined("attributes.outgoing_stock") and len(attributes.outgoing_stock)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#attributes.outgoing_stock#"><cfelse>NULL</cfif>,
				ACCOUNT_EXPORTREGISTERED = <cfif isdefined("attributes.account_exportregistered") and len(attributes.account_exportregistered)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#attributes.account_exportregistered#"><cfelse>NULL</cfif>,
				UPDATE_DATE = #NOW()#,
				UPDATE_EMP = #SESSION.EP.USERID#,
				UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">
			WHERE
				PRO_CODE_CATID = #attributes.cat_id#
		</cfquery>
	</cftransaction>
</cflock>
<script type="text/javascript">	
	window.location.href='<cfoutput>#request.self#?fuseaction=product.list_prod_code_cat&event=upd&cat_id=#attributes.cat_id#</cfoutput>';
</script>