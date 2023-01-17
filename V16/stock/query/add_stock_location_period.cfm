<cflock name="#createuuid()#" timeout="60">
	<cftransaction>
		<cfset mylist=ListToArray(attributes.for_control)>
		<cfquery name="del_periods" datasource="#dsn#">
			DELETE FROM	STOCKS_LOCATION_PERIOD WHERE LOCATION_ID=#attributes.location_id# AND DEPARTMENT_ID=#attributes.department_id# AND PERIOD_ID=#attributes.period_main_id#
		</cfquery>
		<cfquery name="add_loc_periods" datasource="#dsn#">
			INSERT INTO 
				STOCKS_LOCATION_PERIOD
				(
					LOCATION_ID,
					DEPARTMENT_ID,
					PERIOD_ID,
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
					PRODUCTION_COST,
					MATERIAL_CODE,
					ACCOUNT_EXPENDITURE,
					SALE_PRODUCT_COST,
					ACCOUNT_LOSS,
					SCRAP_CODE,
					MATERIAL_CODE_SALE,
					PRODUCTION_COST_SALE,
					SCRAP_CODE_SALE,
					RECORD_IP,
					RECORD_DATE,
					RECORD_EMP
				)
				VALUES
				(
					#attributes.location_id#,
					#attributes.department_id#,
					#attributes.period_main_id#,
					'#evaluate("account_code")#',
					'#evaluate("account_code_purchase")#',
					'#evaluate("account_discount")#',
					'#evaluate("account_price")#',
					'#evaluate("account_price_pur")#',
					'#evaluate("account_pur_iade")#',
					'#evaluate("account_iade")#',
					'#evaluate("account_yurtdisi")#',
					'#evaluate("account_yurtdisi_pur")#',
					'#evaluate("account_discount_pur")#',
					'#evaluate("production_cost")#',
					'#evaluate("material_code")#',
					'#evaluate("account_expenditure")#',
					'#evaluate("sale_product_cost")#',
					'#evaluate("account_loss")#',
					'#evaluate("scrap_code")#',
					'#evaluate("material_code_sale")#',
					'#evaluate("production_cost_sale")#',
					'#evaluate("scrap_code_sale")#',
					'#cgi.remote_addr#',
					 #now()#,
					 #session.ep.userid#
				)
		</cfquery>
	</cftransaction>
</cflock>
<script type="text/javascript">
	window.close();
</script>
