<!--- Ilk bolum odeme plani faturalandirma --->
<cfif isDefined('attributes.list_payment_row_id') and len(attributes.list_payment_row_id)>
	<cfset list_payment_row_id = attributes.list_payment_row_id>
	<cfloop from="1" to="#listlen(list_payment_row_id)#" index="i_counter">
		<cfquery name="ADD_CONTRACT_INVOICE" datasource="#new_dsn2_group#">
			INSERT INTO
				#dsn3_alias#.SUBSCRIPTION_CONTRACT_INVOICE
			(
				SUBSCRIPTION_ID,
				INVOICE_ID,
				INVOICE_NUMBER,
				PERIOD_ID,
				PAYMENT_ROW_ID
			)
			VALUES
			(
				#attributes.subscription_id#,
				#get_invoice_id.max_id#,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.invoice_number#">,
				#session.ep.period_id#,
				#ListGetAt(list_payment_row_id, i_counter)#
			)
		</cfquery>
		<cfquery name="UPD_PAYMENT_PLAN_ROWS" datasource="#new_dsn2_group#">
			UPDATE
				#dsn3_alias#.SUBSCRIPTION_PAYMENT_PLAN_ROW
			SET
				IS_BILLED = 1,
				INVOICE_ID = #get_invoice_id.max_id#,
				PERIOD_ID = #session.ep.period_id#,
				UPDATE_DATE = #now()#,
				UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
				UPDATE_EMP = #session.ep.userid#
			WHERE
				SUBSCRIPTION_PAYMENT_ROW_ID = #ListGetAt(list_payment_row_id, i_counter)#
		</cfquery>
	</cfloop>
<cfelse><!--- İkinci bolum sayac faturalandirma --->
	<cfif isdefined("attributes.invoice_counter_number") and len(attributes.invoice_counter_number)>
		<cfloop from="1" to="#attributes.invoice_counter_number#" index="i_counter">
		  <cfif len(evaluate('attributes.invoice_stock_id_#i_counter#'))><!--- Stok id dolu ise faturada satir olusturacak. --->
			<cfloop from="1" to="#evaluate('attributes.counter_row_#i_counter#')#" index="i_counter2">		
			  <cfif isdefined("attributes.is_invoice_#i_counter#_#i_counter2#")><!--- Fatura gelirken satirda chack varmi yani faturalama islemi yapilacak mi --->
				<cfquery name="ADD_CONTRACT_INVOICE" datasource="#new_dsn2_group#">
					INSERT INTO
						#dsn3_alias#.SUBSCRIPTION_CONTRACT_INVOICE
					(
						SUBSCRIPTION_ID,
						INVOICE_ID,
						INVOICE_NUMBER,
						PERIOD_ID,
						RESULT_ROW_ID,
						COUNTER_VALUE,
						INVOICE_VALUE
					)
					VALUES
					(
						#attributes.subscription_id#,
						#get_invoice_id.max_id#,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.invoice_number#">,
						#session.ep.period_id#,
						#evaluate('attributes.result_row_id_#i_counter#_#i_counter2#')#,
						#evaluate('attributes.h_invoice_difference_#i_counter#_#i_counter2#')#,
						#evaluate('attributes.invoice_difference_#i_counter#_#i_counter2#')#
					)
				</cfquery>
			  </cfif>		
			</cfloop>
		  </cfif>
		</cfloop>
	</cfif>
</cfif>

