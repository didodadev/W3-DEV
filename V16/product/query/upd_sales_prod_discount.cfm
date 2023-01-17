<cfif len(attributes.start_date)><cf_date tarih='attributes.start_date'></cfif>
<cfif len(attributes.finish_date)><cf_date tarih='attributes.finish_date'></cfif>
<cflock name="#createuuid()#" timeout="60">
	<cftransaction>
		<cfquery name="UPD_SALES_PROD_DISCOUNT" datasource="#dsn3#">
			UPDATE
				CONTRACT_SALES_PROD_DISCOUNT
			SET
				COMPANY_ID = <cfif len(attributes.company_id) and len(attributes.company_name)>#attributes.company_id#<cfelse>NULL</cfif>,
				DISCOUNT1 = <cfif len(attributes.discount1)>#filterNum(attributes.discount1)#<cfelse>NULL</cfif>,
				DISCOUNT2 = <cfif len(attributes.discount2)>#filterNum(attributes.discount2)#<cfelse>NULL</cfif>,
				DISCOUNT3 = <cfif len(attributes.discount3)>#filterNum(attributes.discount3)#<cfelse>NULL</cfif>,
				DISCOUNT4 = <cfif len(attributes.discount4)>#filterNum(attributes.discount4)#<cfelse>NULL</cfif>,
				DISCOUNT5 = <cfif len(attributes.discount5)>#filterNum(attributes.discount5)#<cfelse>NULL</cfif>,
				PAYMETHOD_ID = <cfif isnumeric(attributes.paymethod_id)>#attributes.paymethod_id#<cfelse>NULL</cfif>,
				DELIVERY_DATENO = <cfif len(attributes.delivery_dateno)>#filterNum(attributes.delivery_dateno)#<cfelse>NULL</cfif>,
				START_DATE = <cfif len(attributes.start_date)>#attributes.start_date#<cfelse>NULL</cfif>,
				FINISH_DATE = <cfif len(attributes.finish_date)>#attributes.finish_date#<cfelse>NULL</cfif>,
				DISCOUNT_CASH = <cfif len(attributes.discount_cash)>#filterNum(attributes.discount_cash)#<cfelse>NULL</cfif>,
				REBATE_CASH_1 = <cfif len(attributes.rebate_cash_1)>#filterNum(attributes.rebate_cash_1)#<cfelse>NULL</cfif>,
				RETURN_DAY = <cfif len(attributes.return_day)>#filterNum(attributes.return_day)#<cfelse>NULL</cfif>,
				RETURN_RATE = <cfif len(attributes.return_rate)>#filterNum(attributes.return_rate)#<cfelse>NULL</cfif>,
				PRICE_PROTECTION_DAY = <cfif len(attributes.price_protection_day)>#filterNum(attributes.price_protection_day)#<cfelse>NULL</cfif>,
				EXTRA_PRODUCT_1 = <cfif len(attributes.extra_product_1)>#filterNum(attributes.extra_product_1)#<cfelse>NULL</cfif>,
				EXTRA_PRODUCT_2 = <cfif len(attributes.extra_product_2)>#filterNum(attributes.extra_product_2)#<cfelse>NULL</cfif>,
				REBATE_RATE = <cfif len(attributes.rebate_rate)>#filterNum(attributes.rebate_rate)#<cfelse>NULL</cfif>,
				PROCESS_STAGE = <cfif len(attributes.process_stage)>#attributes.process_stage#<cfelse>NULL</cfif>,
				UPDATE_EMP = #session.ep.userid#, 
				UPDATE_IP = '#remote_addr#', 
				UPDATE_DATE = #now()#
			WHERE
				C_S_PROD_DISCOUNT_ID = #attributes.discount_id#
		</cfquery>
		<cfquery name="DELETE_SALES_PROD_DISCOUNT" datasource="#DSN3#">
			DELETE CONTRACT_SALES_PROD_PRICE_LIST WHERE C_S_PROD_DISCOUNT_ID = #attributes.discount_id#
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
						#attributes.discount_id#,
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
