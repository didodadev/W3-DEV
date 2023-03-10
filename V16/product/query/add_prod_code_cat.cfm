<cflock name="#CREATEUUID()#" timeout="20">
	<cftransaction>
		<cfquery name="ADD_PRODUCT_PERIODS" datasource="#DSN3#" result="MAX_ID">
			INSERT INTO 
				SETUP_PRODUCT_PERIOD_CAT
				(
					IS_ACTIVE,  
					PRO_CODE_CAT_NAME,
					ACCOUNT_CODE,
					ACCOUNT_CODE_PUR,
					ACCOUNT_DISCOUNT,
					ACCOUNT_PRICE,
					ACCOUNT_PRICE_PUR,
					ACCOUNT_PUR_IADE,
					ACCOUNT_IADE,
					ACCOUNT_YURTDISI,
					ACCOUNT_YURTDISI_PUR,
					ACCOUNT_DISCOUNT_PUR,
					ACCOUNT_LOSS,
					ACCOUNT_EXPENDITURE,
					OVER_COUNT,
					UNDER_COUNT,
					PRODUCTION_COST,
					HALF_PRODUCTION_COST,
					SALE_PRODUCT_COST,
					SALE_MANUFACTURED_COST,
					DETAIL,
					MATERIAL_CODE,
					KONSINYE_PUR_CODE,
					KONSINYE_SALE_CODE,
					KONSINYE_SALE_NAZ_CODE,
					DIMM_CODE,
					DIMM_YANS_CODE,
					PROMOTION_CODE,
					EXP_CENTER_ID,
					EXP_ITEM_ID,
					EXP_TEMPLATE_ID,
					EXP_ACTIVITY_TYPE_ID,
					INC_CENTER_ID,
					INC_ITEM_ID,
					INC_TEMPLATE_ID,
					INC_ACTIVITY_TYPE_ID,
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
					SCRAP_CODE,
					MATERIAL_CODE_SALE,
					PRODUCTION_COST_SALE,
					SCRAP_CODE_SALE,
					EXPENSE_PROGRESS_CODE,
					INCOME_PROGRESS_CODE,
					EXE_VAT_SALE_INVOICE,
					DISCOUNT_EXPENSE_CENTER_ID,
					DISCOUNT_EXPENSE_ITEM_ID,
					DISCOUNT_ACTIVITY_TYPE_ID,
					REASON_CODE,
					INCOMING_STOCK,
					OUTGOING_STOCK,
					ACCOUNT_EXPORTREGISTERED,
					RECORD_EMP,
					RECORD_IP,
					RECORD_DATE
				)
				VALUES
				(
					<cfif isdefined('attributes.is_active')>1<cfelse>0</cfif>,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#PRO_CODE_CAT_NAME#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#ACCOUNT_CODE_SALE#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#ACCOUNT_CODE_PURCHASE#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#ACCOUNT_DISCOUNT#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#ACCOUNT_PRICE#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#ACCOUNT_PRICE_PUR#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#ACCOUNT_PUR_IADE#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#ACCOUNT_IADE#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#ACCOUNT_YURTDISI#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#ACCOUNT_YURTDISI_PUR#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#ACCOUNT_DISCOUNT_PUR#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#ACCOUNT_LOSS#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#ACCOUNT_EXPENDITURE#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#OVER_COUNT#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#UNDER_COUNT#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#PRODUCTION_COST#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#HALF_PRODUCTION_COST#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#SALE_PRODUCT_COST#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#SALE_MANUFACTURED_COST#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#DETAIL#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#MATERIAL_CODE#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#KONSINYE_PUR_CODE#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#KONSINYE_SALE_CODE#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#KONSINYE_SALE_NAZ_CODE#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#DIMM_CODE#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#DIMM_YANS_CODE#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#PROMOTION_CODE#">,
					<cfif len(attributes.exp_center_id)>#attributes.exp_center_id#<cfelse>NULL</cfif>,
					<cfif len(attributes.exp_item_id)>#attributes.exp_item_id#<cfelse>NULL</cfif>,
					<cfif len(attributes.exp_template_id)>#attributes.exp_template_id#<cfelse>NULL</cfif>,
					<cfif len(attributes.exp_activity_type_id)>#attributes.exp_activity_type_id#<cfelse>NULL</cfif>,
					<cfif len(attributes.inc_center_id)>#attributes.inc_center_id#<cfelse>NULL</cfif>,
					<cfif len(attributes.inc_item_id)>#attributes.inc_item_id#<cfelse>NULL</cfif>,
					<cfif len(attributes.inc_template_id)>#attributes.inc_template_id#<cfelse>NULL</cfif>,
					<cfif len(attributes.inc_activity_type_id)>#attributes.inc_activity_type_id#<cfelse>NULL</cfif>,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#INVENTORY_CODE#">,
					<cfif len(attributes.inventory_cat_id) and len(attributes.inventory_cat)>#attributes.inventory_cat_id#<cfelse>NULL</cfif>,
					<cfif len(attributes.AMORTIZATION_METHOD_ID)>#attributes.AMORTIZATION_METHOD_ID#<cfelse>NULL</cfif>,
					<cfif len(attributes.AMORTIZATION_TYPE_ID)>#attributes.AMORTIZATION_TYPE_ID#<cfelse>NULL</cfif>,
					<cfif len(attributes.AMORTIZATION_EXP_CENTER_ID)>#attributes.AMORTIZATION_EXP_CENTER_ID#<cfelse>NULL</cfif>,
					<cfif len(attributes.AMORTIZATION_EXP_ITEM_ID)>#attributes.AMORTIZATION_EXP_ITEM_ID#<cfelse>NULL</cfif>,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.AMORTIZATION_CODE#">,
					<cfif isdefined("PROD_GENERAL_CODE") and len(PROD_GENERAL_CODE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#PROD_GENERAL_CODE#">,<cfelse>NULL,</cfif>
					<cfif isdefined("PROD_LABOR_COST_CODE") and len(PROD_LABOR_COST_CODE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#PROD_LABOR_COST_CODE#">,<cfelse>NULL,</cfif>
                    <cfif isdefined("get_progress_code") and len(get_progress_code)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_PROGRESS_CODE#"><cfelse>NULL</cfif>,
                    <cfif isdefined("submitted_progress_code") and len(submitted_progress_code)><cfqueryparam cfsqltype="cf_sql_varchar" value="#SUBMITTED_PROGRESS_CODE#"><cfelse>NULL</cfif>,
                    <cfif isdefined("scrap_code") and len(scrap_code)><cfqueryparam cfsqltype="cf_sql_varchar" value="#scrap_code#"><cfelse>NULL</cfif>,
					<cfif isdefined("MATERIAL_CODE_SALE") and len(MATERIAL_CODE_SALE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#MATERIAL_CODE_SALE#"><cfelse>NULL</cfif>,
					<cfif isdefined("PRODUCTION_COST_SALE") and len(PRODUCTION_COST_SALE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#PRODUCTION_COST_SALE#"><cfelse>NULL</cfif>,
					<cfif isdefined("SCRAP_CODE_SALE") and len(SCRAP_CODE_SALE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#SCRAP_CODE_SALE#"><cfelse>NULL</cfif>,
					<cfif isdefined("EXPENSE_PROGRESS_CODE") and len(EXPENSE_PROGRESS_CODE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#EXPENSE_PROGRESS_CODE#"><cfelse>NULL</cfif>,
					<cfif isdefined("INCOME_PROGRESS_CODE") and len(INCOME_PROGRESS_CODE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#INCOME_PROGRESS_CODE#"><cfelse>NULL</cfif>,
                    <cfif len(exe_vat_sale_invoice)><cfqueryparam cfsqltype="cf_sql_varchar" value="#exe_vat_sale_invoice#"><cfelse>NULL</cfif>,
					<cfif isdefined("attributes.discount_expense_center_id") and len(attributes.discount_expense_center_id) and len(attributes.discount_expense_center_name)><cfqueryparam cfsqltype="cf_sql_integer" value="#discount_expense_center_id#"><cfelse>NULL</cfif>,
					<cfif isdefined("attributes.discount_expense_item_id") and len(attributes.discount_expense_item_id) and len(attributes.discount_expense_item_name)><cfqueryparam cfsqltype="cf_sql_integer" value="#discount_expense_item_id#"><cfelse>NULL</cfif>,
					<cfif isdefined("attributes.discount_activity_type") and len(attributes.discount_activity_type)><cfqueryparam cfsqltype="cf_sql_integer" value="#discount_activity_type#"><cfelse>NULL</cfif>,
					<cfif isdefined("attributes.reason_code") and len(attributes.reason_code)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#attributes.reason_code#"><cfelse>NULL</cfif>,
					<cfif isdefined("attributes.incoming_stock") and len(attributes.incoming_stock)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#attributes.incoming_stock#"><cfelse>NULL</cfif>,
					<cfif isdefined("attributes.outgoing_stock") and len(attributes.outgoing_stock)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#attributes.outgoing_stock#"><cfelse>NULL</cfif>,
					<cfif isdefined("attributes.account_exportregistered") and len(attributes.account_exportregistered)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#attributes.account_exportregistered#"><cfelse>NULL</cfif>,
					#SESSION.EP.USERID#,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">,
					#NOW()#
				)
		</cfquery>
	</cftransaction>
</cflock>
<script type="text/javascript">	
	window.location.href='<cfoutput>#request.self#?fuseaction=product.list_prod_code_cat&event=upd&cat_id=#MAX_ID.IDENTITYCOL#</cfoutput>';
</script>