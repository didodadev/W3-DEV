<cfsetting showdebugoutput="no">
<cflock name="#CreateUUID()#" timeout="60">
	<cftransaction>
		<cfloop from="1" to="#listlen(attributes.line_id)#" index="i">
			<cfquery name="get_" datasource="#DSN2#">
				SELECT INVOICE_ID FROM INVOICE_CONTROL WHERE INVOICE_ID = #Evaluate("invoice_id_#ListGetAt(attributes.line_id,i)#")#
			</cfquery>
			<cfquery name="get_invoice" datasource="#DSN2#">
				SELECT INVOICE_ID,CONSUMER_ID,COMPANY_ID,INVOICE_NUMBER,NETTOTAL,DEPARTMENT_ID,DEPARTMENT_LOCATION FROM INVOICE WHERE INVOICE_ID = #Evaluate("invoice_id_#ListGetAt(attributes.line_id,i)#")#
			</cfquery>
			<cfif get_invoice.recordcount>
				<cfif get_.recordcount eq 0>
					<cfquery name="add_in_con" datasource="#DSN2#">
						INSERT INTO 
							INVOICE_CONTROL
							(
								INVOICE_NUMBER,
								INVOICE_ID,
								COMPANY_ID,
								CONSUMER_ID,
								MONEY,
								RETURN_MONEY_VALUE,				
								IS_CONTROL,
								RECORD_EMP,
								RECORD_IP,
								RECORD_DATE
							)
						VALUES
							(	
								'#get_invoice.INVOICE_NUMBER#',
								#get_invoice.INVOICE_ID#,
								<cfif len(get_invoice.COMPANY_ID)>#get_invoice.COMPANY_ID#,<cfelse>NULL,</cfif>
								<cfif len(get_invoice.CONSUMER_ID)>#get_invoice.CONSUMER_ID#,<cfelse>NULL,</cfif>
								'#session.ep.money#',
								0,
								1,
								#SESSION.EP.USERID#,
								'#CGI.REMOTE_ADDR#',
								#NOW()#
							)
					</cfquery>
				</cfif>
				<cfquery name="get_2" datasource="#DSN2#">
					SELECT CONTRACT_COMPARISON_ROW_ID MAX_ID FROM INVOICE_CONTRACT_COMPARISON WHERE MAIN_INVOICE_ROW_ID = #Evaluate("invoice_row_id_#ListGetAt(attributes.line_id,i)#")#
				</cfquery>
				<cfif get_2.recordcount eq 0>
					<cfquery name="add_in_com" datasource="#DSN2#">
						INSERT INTO 
							INVOICE_CONTRACT_COMPARISON
						(
							MAIN_INVOICE_ID,
							MAIN_INVOICE_DATE,
							MAIN_INVOICE_NUMBER,
							MAIN_INVOICE_ROW_ID,
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
							TAX,
							DEPARTMENT_ID,
							LOCATION_ID,
							INVOICE_TYPE,
							RECORD_EMP,
							RECORD_IP,
							RECORD_DATE
						)
						VALUES
						(
							#Evaluate("invoice_id_#ListGetAt(attributes.line_id,i)#")#,
							#Evaluate("invoice_date_#ListGetAt(attributes.line_id,i)#")#,
							'#Evaluate("invoice_number_#ListGetAt(attributes.line_id,i)#")#',
							#Evaluate("invoice_row_id_#ListGetAt(attributes.line_id,i)#")#,
							<cfif len(get_invoice.company_id)>#get_invoice.company_id#<cfelse>NULL</cfif>,
							<cfif len(get_invoice.consumer_id)>#get_invoice.consumer_id#<cfelse>NULL</cfif>,
							#evaluate("attributes.product_id_#ListGetAt(attributes.line_id,i)#")#,
							#evaluate("attributes.stock_id_#ListGetAt(attributes.line_id,i)#")#,
							#evaluate("attributes.amount_#ListGetAt(attributes.line_id,i)#")#,
							0,
							#evaluate("attributes.invoice_amount_#ListGetAt(attributes.line_id,i)#")#,
							#evaluate("attributes.invoice_amount_other_#ListGetAt(attributes.line_id,i)#")#,
							'#evaluate("attributes.other_money_#ListGetAt(attributes.line_id,i)#")#',
							0,
							0,
							4,
							#evaluate("attributes.tax_#ListGetAt(attributes.line_id,i)#")#,
							#get_invoice.department_id#,
							#get_invoice.department_location#,
							<cfif isdefined('attributes.invoice_type_#ListGetAt(attributes.line_id,i)#') and evaluate('attributes.invoice_type_#ListGetAt(attributes.line_id,i)#') eq 1>1<cfelse>0</cfif>,
							#SESSION.EP.USERID#,
							'#CGI.REMOTE_ADDR#',
							#NOW()#
						)
					</cfquery>
					<cfquery name="get_max_2" datasource="#dsn2#">
						SELECT MAX(CONTRACT_COMPARISON_ROW_ID) MAX_ID FROM INVOICE_CONTRACT_COMPARISON
					</cfquery>
					<cfoutput>
						<script type="text/javascript">
							document.all.contract_row_id_#ListGetAt(attributes.line_id,i)#.value = '#get_max_2.max_id#';
						</script>
					</cfoutput>
				<cfelse>
					<cfoutput>
						<script type="text/javascript">
							document.all.contract_row_id_#ListGetAt(attributes.line_id,i)#.value = '#get_2.max_id#';
						</script>
					</cfoutput>
				</cfif>
			</cfif>
		</cfloop>
	</cftransaction>
</cflock>

