<cfquery name="get_inv_cancel_types" datasource="#dsn3#">
	SELECT
		*
	FROM
		SETUP_INVOICE_CANCEL_TYPE
	ORDER BY 
		INV_CANCEL_TYPE
</cfquery>
