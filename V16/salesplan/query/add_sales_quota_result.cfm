<cfsetting showdebugoutput="no">
<cfif isdefined("attributes.quota_row_id")>
	<cflock name="#CreateUUID()#" timeout="60">
		<cftransaction>
		<cfquery name="get_sales_quota_row" datasource="#dsn2#">
			SELECT 
				SR.*,
				S.COMPANY_ID,
				S.CONSUMER_ID,
				S.IS_SALES_PURCHASE	,
				S.OTHER_MONEY	
			FROM
				#dsn3_alias#.SALES_QUOTAS S,
				#dsn3_alias#.SALES_QUOTAS_ROW SR 
			WHERE 
				S.SALES_QUOTA_ID = SR.SALES_QUOTA_ID
				AND SR.SALES_QUOTA_ROW_ID = #attributes.quota_row_id#
		</cfquery>
		<cfquery name="get_rate2" datasource="#dsn2#">
			SELECT * FROM SETUP_MONEY WHERE MONEY = '#get_sales_quota_row.other_money#'
		</cfquery>
		<cfif evaluate("all_premium_value_#attributes.quota_row_id#") gt 0>
			<cfquery name="add_inv_cont" datasource="#dsn2#">
				INSERT INTO 
					INVOICE_CONTRACT_COMPARISON
					(
						COMPANY_ID,
						CONSUMER_ID,
						MAIN_PRODUCT_ID,
						MAIN_STOCK_ID,							
						AMOUNT,
						DIFF_RATE,
						DIFF_AMOUNT,
						DIFF_AMOUNT_OTHER,
						OTHER_MONEY,
						IS_DIFF_DISCOUNT,
						IS_DIFF_PRICE,
						DIFF_TYPE,
						INVOICE_TYPE,
						TAX,
						RECORD_EMP,
						RECORD_IP,
						RECORD_DATE
					)
				VALUES
					(
						<cfif len(get_sales_quota_row.company_id)>#get_sales_quota_row.company_id#<cfelse>NULL</cfif>,
						<cfif len(get_sales_quota_row.consumer_id)>#get_sales_quota_row.consumer_id#<cfelse>NULL</cfif>,
						#evaluate("attributes.product_id_#attributes.quota_row_id#")#,
						#evaluate("attributes.stock_id_#attributes.quota_row_id#")#,
						1,
						NULL,
						#evaluate("attributes.all_premium_value_#attributes.quota_row_id#")#,
						#evaluate("attributes.all_premium_value_#attributes.quota_row_id#")/get_rate2.rate2#,
						'#get_sales_quota_row.other_money#',
						0,
						0,
						9,
						#get_sales_quota_row.IS_SALES_PURCHASE#,
						0,
						#session.ep.userid#,
						'#cgi.remote_addr#',
						#now()#
					)
			</cfquery>
			<cfquery name="get_max_1" datasource="#dsn2#">
				SELECT MAX(CONTRACT_COMPARISON_ROW_ID) MAX_ID FROM INVOICE_CONTRACT_COMPARISON
			</cfquery>
			<cfquery name="add_inv_relation" datasource="#dsn2#">
				INSERT INTO 
					#dsn3_alias#.SALES_QUOTAS_ROW_RELATION
					(
						SALES_QUOTAS_ROW_ID,
						INVOICE_COMPARISON_ID,
						PERIOD_ID,
						TYPE,
						AMOUNT
					)
				VALUES
					(
						#attributes.quota_row_id#,
						#get_max_1.max_id#,
						#session.ep.period_id#,
						1<!--- Prim Satırı --->,
						1
					)
			</cfquery>
		</cfif>
		<cfif evaluate("all_extra_stock_#attributes.quota_row_id#") gt 0>
			<cfquery name="add_inv_cont" datasource="#dsn2#">
				INSERT INTO 
					INVOICE_CONTRACT_COMPARISON
					(
						COMPANY_ID,
						CONSUMER_ID,
						MAIN_PRODUCT_ID,
						MAIN_STOCK_ID,							
						AMOUNT,
						DIFF_RATE,
						DIFF_AMOUNT,
						DIFF_AMOUNT_OTHER,
						OTHER_MONEY,
						IS_DIFF_DISCOUNT,
						IS_DIFF_PRICE,
						DIFF_TYPE,
						INVOICE_TYPE,
						TAX,
						RECORD_EMP,
						RECORD_IP,
						RECORD_DATE
					)
				VALUES
					(
						<cfif len(get_sales_quota_row.company_id)>#get_sales_quota_row.company_id#<cfelse>NULL</cfif>,
						<cfif len(get_sales_quota_row.consumer_id)>#get_sales_quota_row.consumer_id#<cfelse>NULL</cfif>,
						#get_sales_quota_row.product_id#,
						#get_sales_quota_row.stock_id#,
						#evaluate("attributes.all_extra_stock_#attributes.quota_row_id#")#,
						NULL,
						0,
						0,
						'#session.ep.money#',
						0,
						0,
						10,
						#get_sales_quota_row.IS_SALES_PURCHASE#,
						0,
						#session.ep.userid#,
						'#cgi.remote_addr#',
						#now()#
					)
			</cfquery>
			<cfquery name="get_max_2" datasource="#dsn2#">
				SELECT MAX(CONTRACT_COMPARISON_ROW_ID) MAX_ID FROM INVOICE_CONTRACT_COMPARISON
			</cfquery>
			<cfquery name="add_inv_relation" datasource="#dsn2#">
				INSERT INTO 
					#dsn3_alias#.SALES_QUOTAS_ROW_RELATION
					(
						SALES_QUOTAS_ROW_ID,
						INVOICE_COMPARISON_ID,
						PERIOD_ID,
						TYPE,
						AMOUNT
					)
				VALUES
					(
						#attributes.quota_row_id#,
						#get_max_2.max_id#,
						#session.ep.period_id#,
						2<!--- Mal Fazlası Satırı --->,
						#evaluate("attributes.all_extra_stock_#attributes.quota_row_id#")#
					)
			</cfquery>
		</cfif>
		</cftransaction>
	</cflock>
</cfif>
