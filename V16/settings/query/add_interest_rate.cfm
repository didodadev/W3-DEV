<cflock name="#CreateUUID()#" timeout="60">
	<cftransaction>
		<cfquery name="del_rows" datasource="#dsn3#">
			DELETE FROM SETUP_INTEREST_RATE
		</cfquery>
		<cfloop from="1" to="#attributes.record_num#" index="i">
			<cfif isdefined("attributes.row_kontrol#i#") and evaluate("attributes.row_kontrol#i#") and len(evaluate("attributes.month#i#"))>
				<cfquery name="add_rate" datasource="#dsn3#">
					INSERT INTO 
						SETUP_INTEREST_RATE
						(
							MONTH_VALUE,
							DUE_DAY,
							CREDITCARD_RATE,
							CREDITCARD_RATE_DISCOUNT,
							VOUCHER_RATE,
							VOUCHER_RATE_DISCOUNT,
							CHEQUE_RATE,
							CHEQUE_RATE_DISCOUNT,
							BANKPAYMENT_RATE,
							BANKPAYMENT_RATE_DISCOUNT,
							UPDATE_EMP,
							UPDATE_IP,
							UPDATE_DATE
						)
						VALUES
						(
							#evaluate("attributes.month#i#")#,
							#evaluate("attributes.due_day#i#")#,
							<cfif len(evaluate("attributes.creditcard_rate#i#"))>#evaluate("attributes.creditcard_rate#i#")#<cfelse>0</cfif>,
							<cfif len(evaluate("attributes.creditcard_rate_discount#i#"))>#evaluate("attributes.creditcard_rate_discount#i#")#<cfelse>0</cfif>,
							<cfif len(evaluate("attributes.voucher_rate#i#"))>#evaluate("attributes.voucher_rate#i#")#<cfelse>0</cfif>,
							<cfif len(evaluate("attributes.voucher_rate_discount#i#"))>#evaluate("attributes.voucher_rate_discount#i#")#<cfelse>0</cfif>,
							<cfif len(evaluate("attributes.cheque_rate#i#"))>#evaluate("attributes.cheque_rate#i#")#<cfelse>0</cfif>,
							<cfif len(evaluate("attributes.cheque_rate_discount#i#"))>#evaluate("attributes.cheque_rate_discount#i#")#<cfelse>0</cfif>,
							<cfif len(evaluate("attributes.bankpayment_rate#i#"))>#evaluate("attributes.bankpayment_rate#i#")#<cfelse>0</cfif>,
							<cfif len(evaluate("attributes.bankpayment_rate_discount#i#"))>#evaluate("attributes.bankpayment_rate_discount#i#")#<cfelse>0</cfif>,
							#session.ep.userid#,
							'#cgi.remote_addr#',
							#now()#
						)
				</cfquery>
			</cfif>
		</cfloop>
	</cftransaction>
</cflock>
<cflocation url="#request.self#?fuseaction=settings.form_add_interest_rate" addtoken="no">
