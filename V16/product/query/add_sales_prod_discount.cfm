<cfif len(attributes.start_date)><cf_date tarih='attributes.start_date'></cfif>
<cfif len(attributes.finish_date)><cf_date tarih='attributes.finish_date'></cfif>

<cflock name="#createuuid()#" timeout="60">
	<cftransaction>
		<cfquery name="UPDATE_PREVIOUS_FINISH_DATE" datasource="#DSN3#" maxrows="1">
			UPDATE 
				CONTRACT_SALES_PROD_DISCOUNT 
			SET 
				FINISH_DATE = #DATEADD('s',-1,attributes.start_date)# 
			WHERE 
				PRODUCT_ID = #attributes.pid# AND 
			<cfif len(attributes.company_id) and len(attributes.company_name)>
				COMPANY_ID = #attributes.company_id# AND 
			<cfelse>
				COMPANY_ID IS NULL AND 
			</cfif>
				START_DATE < #attributes.start_date# AND 
				FINISH_DATE IS NULL
		</cfquery>
		<cfquery name="ADD_SALES_PROD_DISCOUNT" datasource="#DSN3#" result="MAX_ID">
			INSERT INTO
				CONTRACT_SALES_PROD_DISCOUNT
			(
				CONTRACT_ID,
				COMPANY_ID,
				PRODUCT_ID, 
				DISCOUNT1,
				DISCOUNT2,
				DISCOUNT3,
				DISCOUNT4,
				DISCOUNT5,
				PAYMETHOD_ID,
				DELIVERY_DATENO,
				START_DATE,
				FINISH_DATE,
				DISCOUNT_CASH,
				DISCOUNT_CASH_MONEY,
				REBATE_CASH_1,
				REBATE_CASH_1_MONEY,
				RETURN_DAY,
				RETURN_RATE,
				PRICE_PROTECTION_DAY,
				EXTRA_PRODUCT_1,
				EXTRA_PRODUCT_2,
				REBATE_RATE,
				PROCESS_STAGE,
				RECORD_EMP, 
				RECORD_IP, 
				RECORD_DATE			
			)
			VALUES
			(
				NULL,
				<cfif len(attributes.company_id) and len(attributes.company_name)>#attributes.company_id#<cfelse>NULL</cfif>,
				<cfif IsNumeric(attributes.pid)>#attributes.pid#<cfelse>NULL</cfif>,
				<cfif len(attributes.discount1)>#filterNum(attributes.discount1)#<cfelse>NULL</cfif>,
				<cfif len(attributes.discount2)>#filterNum(attributes.discount2)#<cfelse>NULL</cfif>,
				<cfif len(attributes.discount3)>#filterNum(attributes.discount3)#<cfelse>NULL</cfif>,
				<cfif len(attributes.discount4)>#filterNum(attributes.discount4)#<cfelse>NULL</cfif>,
				<cfif len(attributes.discount5)>#filterNum(attributes.discount5)#<cfelse>NULL</cfif>,
				<cfif IsNumeric(attributes.paymethod_id)>#attributes.paymethod_id#<cfelse>NULL</cfif>,
				<cfif len(attributes.delivery_dateno)>#filterNum(attributes.delivery_dateno)#<cfelse>NULL</cfif>,
				<cfif len(attributes.start_date)>#attributes.start_date#<cfelse>NULL</cfif>,
				<cfif len(attributes.finish_date)>#attributes.finish_date#<cfelse>NULL</cfif>,
				<cfif len(attributes.discount_cash)>#filterNum(attributes.discount_cash)#<cfelse>NULL</cfif>,
				<cfif len(attributes.discount_cash)>'#attributes.discount_cash_money#'<cfelse>NULL</cfif>,
				<cfif len(attributes.rebate_cash_1)>#filterNum(attributes.rebate_cash_1)#<cfelse>NULL</cfif>,
				<cfif len(attributes.rebate_cash_1)>'#attributes.rebate_cash_1_money#'<cfelse>NULL</cfif>,
				<cfif len(attributes.return_day)>#attributes.return_day#<cfelse>NULL</cfif>,
				<cfif len(attributes.return_rate)>#filterNum(attributes.return_rate)#<cfelse>NULL</cfif>,
				<cfif len(attributes.price_protection_day)>#filterNum(attributes.price_protection_day)#<cfelse>NULL</cfif>,
				<cfif len(attributes.extra_product_1)>#filterNum(attributes.extra_product_1)#<cfelse>NULL</cfif>,
				<cfif len(attributes.extra_product_2)>#filterNum(attributes.extra_product_2)#<cfelse>NULL</cfif>,
				<cfif len(attributes.rebate_rate)>#filterNum(attributes.rebate_rate)#<cfelse>NULL</cfif>,
				<cfif len(attributes.process_stage)>#attributes.process_stage#<cfelse>NULL</cfif>,
				#session.ep.userid#, 
				'#remote_addr#', 
				#now()#
			)
		</cfquery>
		<cfif isDefined("attributes.price_cats_list")>
			<cfloop list="#attributes.price_cats_list#" index="i">
				<cfquery name="ADD_CONTRACT_SALES_PROD_PRICE_LIST" datasource="#DSN3#">
					INSERT INTO 
						CONTRACT_SALES_PROD_PRICE_LIST
					(
						C_S_PROD_DISCOUNT_ID,
						PRICE_CAT_ID
					)
					VALUES
					(
						#MAX_ID.IDENTITYCOL#,
						#i#
					)
				</cfquery>
			</cfloop>
		</cfif>
	</cftransaction>
</cflock>		
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
