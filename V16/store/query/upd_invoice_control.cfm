<cfif len(attributes.get_date)>
	<cf_date tarih='attributes.get_date'>
</cfif>
<cfquery name="ADD_INVOICE_CONTROL" datasource="#DSN2#">
	UPDATE
		INVOICE_CONTROL
	SET
		IS_CONTROL=<cfif isdefined("attributes.is_page_control")>1,<cfelse>0,</cfif>
		INVOICE_ID=#attributes.invoice_id#,
		INVOICE_NUMBER='#FORM.INVOICE_NUMBER#',
		CONSUMER_ID=<cfif len(attributes.consumer_id)>#attributes.consumer_id#,<cfelse>NULL,</cfif>
		COMPANY_ID=<cfif len(attributes.company_id)>#attributes.company_id#,<cfelse>NULL,</cfif>
		PURCHASE_SALES=#attributes.purchase_sales#,
		PROCESS_TYPE=#attributes.PROCESS_TYPE#,
		IS_PROCESSED=#attributes.is_processed#,
		RETURN_PRODUCT=<cfif len(attributes.product_id)>#attributes.product_id#,<cfelse>NULL,</cfif>
		RETURN_DATE=<cfif len(attributes.get_date)>#attributes.get_date#,<cfelse>NULL,</cfif>
		MONEY='#attributes.add_money_id#',
		RETURN_MONEY_VALUE=#attributes.fark_toplam#,
		VALID_EMP=<cfif len(attributes.employee_id)>#attributes.employee_id#<cfelse>NULL</cfif>,
		RECORD_DATE=#NOW()#,
		RECORD_EMP=#SESSION.EP.USERID#,
		RECORD_IP='#CGI.REMOTE_ADDR#'
	WHERE
		INVOICE_CONTROL_ID = #attributes.invoice_control_id#
</cfquery>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
