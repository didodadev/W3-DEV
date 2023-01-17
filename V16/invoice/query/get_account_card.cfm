<cfquery datasource="#dsn2#" name="get_account_card_id">
	SELECT
		CARD_ID,
		INVOICE.INVOICE_NUMBER AS INVOICE_NUMBER
	FROM
		ACCOUNT_CARD AC,
		INVOICE
	WHERE		
		<cfif not isDefined("attributes.ID")>
			INVOICE.INVOICE_ID=#attributes.IID#
		<cfelse>
			INVOICE.INVOICE_ID=#attributes.ID#
		</cfif>
		 AND AC.PAPER_NO=INVOICE_NUMBER
		 AND AC.ACTION_ID = INVOICE.INVOICE_ID
		 AND AC.ACTION_TYPE = #get_sale_det.process_cat#
</cfquery>

