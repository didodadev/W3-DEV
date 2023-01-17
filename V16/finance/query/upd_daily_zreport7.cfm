<cfquery name="GET_INVOICE_STATISTICAL" datasource="#DSN2#">
	SELECT * FROM INVOICE_STATISTICAL WHERE INVOICE_ID = #attributes.invoice_id#
</cfquery>
<cfif get_invoice_statistical.recordcount>
	<cfquery name="UPD_INVOICE_STATISTICAL" datasource="#DSN2#">
		UPDATE 
			INVOICE_STATISTICAL
		SET 
			TOTAL_NUMBER_RECEIPT = <cfif len(attributes.total_number_receipt)>#attributes.total_number_receipt#<cfelse>NULL</cfif>,
			VALID_NUMBER_RECEIPT = <cfif len(attributes.valid_number_receipt)>#attributes.valid_number_receipt#<cfelse>NULL</cfif>,
			CANCEL_NUMBER_RECEIPT = <cfif len(attributes.cancel_number_receipt)>#attributes.cancel_number_receipt#<cfelse>NULL</cfif>,
			TOTAL_NUMBER_SALES_RECEIPT = <cfif len(attributes.total_number_sales_receipt)>#attributes.total_number_sales_receipt#<cfelse>NULL</cfif>,
			CANCEL_NUMBER_SALES_RECEIPT = <cfif len(attributes.cancel_number_sales_receipt)>#attributes.cancel_number_sales_receipt#<cfelse>NULL</cfif>,
			
			TOTAL_CANCELLATION = <cfif len(attributes.total_cancellation)>#attributes.total_cancellation#<cfelse>NULL</cfif>,
			TOTAL_BONUS = <cfif len(attributes.total_bonus)>#attributes.total_bonus#<cfelse>NULL</cfif>,
			TOTAL_DISCOUNT = <cfif len(attributes.total_discount)>#attributes.total_discount#<cfelse>NULL</cfif>,
			TOTAL_DEPOSIT = <cfif len(attributes.total_deposit)>#attributes.total_deposit#<cfelse>NULL</cfif>,
			TOTAL_DISCOUNT2 = <cfif len(attributes.total_discount2)>#attributes.total_discount2#<cfelse>NULL</cfif>,
			CANCEL_INVOICE_TOTAL = <cfif len(attributes.cancel_invoice_total)>#attributes.cancel_invoice_total#<cfelse>NULL</cfif>,
			NOT_FINANCIAL_INVOICE_TOTAL = <cfif len(attributes.not_financial_invoice_total)>#attributes.not_financial_invoice_total#<cfelse>NULL</cfif>,
			TOTAL_NUMBER_INVOICE = <cfif len(attributes.total_number_invoice)>#attributes.total_number_invoice#<cfelse>NULL</cfif>,
			VALID_NUMBER_INVOICE = <cfif len(attributes.valid_number_invoice)>#attributes.valid_number_invoice#<cfelse>NULL</cfif>,
			CANCEL_NUMBER_INVOICE = <cfif len(attributes.cancel_number_invoice)>#attributes.cancel_number_invoice#<cfelse>NULL</cfif>,
			TOTAL_INVOICE = <cfif len(attributes.total_invoice)>#attributes.total_invoice#<cfelse>NULL</cfif>,
			TOTAL_KDV_INVOICE = <cfif len(attributes.total_kdv_invoice)>#attributes.total_kdv_invoice#<cfelse>NULL</cfif>,
			TOTAL_CANCEL_INVOICE = <cfif len(attributes.total_cancel_invoice)>#attributes.total_cancel_invoice#<cfelse>NULL</cfif>,
			
			TOTAL_EXPENSE_NUMBER_RECEIPT = <cfif len(attributes.total_expense_number_receipt)>#attributes.total_expense_number_receipt#<cfelse>NULL</cfif>,
			VALID_EXPENSE_NUMBER_RECEIPT = <cfif len(attributes.valid_expense_number_receipt)>#attributes.valid_expense_number_receipt#<cfelse>NULL</cfif>,
			CANCEL_EXPENSE_NUMBER_RECEIPT = <cfif len(attributes.cancel_expense_number_receipt)>#attributes.cancel_expense_number_receipt#<cfelse>NULL</cfif>,
			TOTAL_EXPENSE = <cfif len(attributes.total_expense)>#attributes.total_expense#<cfelse>NULL</cfif>,
			TOTAL_KDV_EXPENSE = <cfif len(attributes.total_kdv_expense)>#attributes.total_kdv_expense#<cfelse>NULL</cfif>,
			TOTAL_CANCEL_EXPENSE = <cfif len(attributes.total_cancel_expense)>#attributes.total_cancel_expense#<cfelse>NULL</cfif>,
			TOTAL_NUMBER_DIPLOMATIC_RECEIPT = <cfif len(attributes.total_number_diplomatic_receipt)>#attributes.total_number_diplomatic_receipt#<cfelse>NULL</cfif>,
			VALID_NUMBER_DIPLOMATIC_RECEIPT = <cfif len(attributes.valid_number_diplomatic_receipt)>#attributes.valid_number_diplomatic_receipt#<cfelse>NULL</cfif>,
			CANCEL_NUMBER_DIPLOMATIC_RECEIPT = <cfif len(attributes.cancel_number_diplomatic_receipt)>#attributes.cancel_number_diplomatic_receipt#<cfelse>NULL</cfif>,
			TOTAL_DIPLOMATIC = <cfif len(attributes.total_diplomatic)>#attributes.total_diplomatic#<cfelse>NULL</cfif>,
			TOTAL_CANCEL_DIPLOMATIC = <cfif len(attributes.total_cancel_dıplomatıc)>#attributes.total_cancel_dıplomatıc#<cfelse>NULL</cfif>,
			TOTAL_ERROR_NUMBER_MEMORY = <cfif len(attributes.total_error_number_memory)>#attributes.total_error_number_memory#<cfelse>NULL</cfif>
		WHERE
			INVOICE_ID = #form.invoice_id#
	</cfquery>
<cfelse>
	<cfquery name="ADD_INVOICE_STATISTICAL" datasource="#DSN2#">
		INSERT INTO 
			INVOICE_STATISTICAL
		(
			INVOICE_ID,
			TOTAL_NUMBER_RECEIPT,
			VALID_NUMBER_RECEIPT, 
			CANCEL_NUMBER_RECEIPT, 
			TOTAL_NUMBER_SALES_RECEIPT, 
			CANCEL_NUMBER_SALES_RECEIPT, 
			TOTAL_CANCELLATION, 
			TOTAL_BONUS,
			TOTAL_DISCOUNT,
			TOTAL_DEPOSIT, 
			TOTAL_DISCOUNT2, 
			CANCEL_INVOICE_TOTAL,
			NOT_FINANCIAL_INVOICE_TOTAL, 
			TOTAL_NUMBER_INVOICE,
			VALID_NUMBER_INVOICE,
			CANCEL_NUMBER_INVOICE, 
			TOTAL_INVOICE,
			TOTAL_KDV_INVOICE,
			TOTAL_CANCEL_INVOICE,
			TOTAL_EXPENSE_NUMBER_RECEIPT,
			VALID_EXPENSE_NUMBER_RECEIPT,
			CANCEL_EXPENSE_NUMBER_RECEIPT,
			TOTAL_EXPENSE,
			TOTAL_KDV_EXPENSE,
			TOTAL_CANCEL_EXPENSE,
			TOTAL_NUMBER_DIPLOMATIC_RECEIPT,
			VALID_NUMBER_DIPLOMATIC_RECEIPT,
			CANCEL_NUMBER_DIPLOMATIC_RECEIPT,
			TOTAL_DIPLOMATIC,
			TOTAL_CANCEL_DIPLOMATIC,
			TOTAL_ERROR_NUMBER_MEMORY
		)
		VALUES
		(
			#form.invoice_id#,
			<cfif len(attributes.total_number_receipt)>#attributes.total_number_receipt#<cfelse>NULL</cfif>,
			<cfif len(attributes.valid_number_receipt)>#attributes.valid_number_receipt#<cfelse>NULL</cfif>,
			<cfif len(attributes.cancel_number_receipt)>#attributes.cancel_number_receipt#<cfelse>NULL</cfif>,
			<cfif len(attributes.total_number_sales_receipt)>#attributes.total_number_sales_receipt#<cfelse>NULL</cfif>,
			<cfif len(attributes.cancel_number_sales_receipt)>#attributes.cancel_number_sales_receipt#<cfelse>NULL</cfif>,
			<cfif len(attributes.total_cancellation)>#attributes.total_cancellation#<cfelse>NULL</cfif>,
			<cfif len(attributes.total_bonus)>#attributes.total_bonus#<cfelse>NULL</cfif>,
			<cfif len(attributes.total_discount)>#attributes.total_discount#<cfelse>NULL</cfif>,
			<cfif len(attributes.total_deposit)>#attributes.total_deposit#<cfelse>NULL</cfif>,
			<cfif len(attributes.total_discount2)>#attributes.total_discount2#<cfelse>NULL</cfif>,
			<cfif len(attributes.cancel_invoice_total)>#attributes.cancel_invoice_total#<cfelse>NULL</cfif>,
			<cfif len(attributes.not_financial_invoice_total)>#attributes.not_financial_invoice_total#<cfelse>NULL</cfif>,
			<cfif len(attributes.total_number_invoice)>#attributes.total_number_invoice#<cfelse>NULL</cfif>,
			<cfif len(attributes.valid_number_invoice)>#attributes.valid_number_invoice#<cfelse>NULL</cfif>,
			<cfif len(attributes.cancel_number_invoice)>#attributes.cancel_number_invoice#<cfelse>NULL</cfif>,
			<cfif len(attributes.total_invoice)>#attributes.total_invoice#<cfelse>NULL</cfif>,
			<cfif len(attributes.total_kdv_invoice)>#attributes.total_kdv_invoice#<cfelse>NULL</cfif>,
			<cfif len(attributes.total_cancel_invoice)>#attributes.total_cancel_invoice#<cfelse>NULL</cfif>,
			<cfif len(attributes.total_expense_number_receipt)>#attributes.total_expense_number_receipt#<cfelse>NULL</cfif>,
			<cfif len(attributes.valid_expense_number_receipt)>#attributes.valid_expense_number_receipt#<cfelse>NULL</cfif>,
			<cfif len(attributes.cancel_expense_number_receipt)>#attributes.cancel_expense_number_receipt#<cfelse>NULL</cfif>,
			<cfif len(attributes.total_expense)>#attributes.total_expense#<cfelse>NULL</cfif>,
			<cfif len(attributes.total_kdv_expense)>#attributes.total_kdv_expense#<cfelse>NULL</cfif>,
			<cfif len(attributes.total_cancel_expense)>#attributes.total_cancel_expense#<cfelse>NULL</cfif>,
			<cfif len(attributes.total_number_diplomatic_receipt)>#attributes.total_number_diplomatic_receipt#<cfelse>NULL</cfif>,
			<cfif len(attributes.valid_number_diplomatic_receipt)>#attributes.valid_number_diplomatic_receipt#<cfelse>NULL</cfif>,
			<cfif len(attributes.cancel_number_diplomatic_receipt)>#attributes.cancel_number_diplomatic_receipt#<cfelse>NULL</cfif>,
			<cfif len(attributes.total_diplomatic)>#attributes.total_diplomatic#<cfelse>NULL</cfif>,
			<cfif len(attributes.total_cancel_diplomatic)>#attributes.total_cancel_diplomatic#<cfelse>NULL</cfif>,
			<cfif len(attributes.total_error_number_memory)>#attributes.total_error_number_memory#<cfelse>NULL</cfif>
		)
	</cfquery>
</cfif>

