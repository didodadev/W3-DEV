<cfquery name="get_payment_order_rows" datasource="#DSN3#">
	SELECT
		*
	FROM
		PAYMENT_ORDERS_ROW
	WHERE
		RESULT_ID = #attributes.RESULT_ID#
		AND
		INVOICE_ID IS NOT NULL
</cfquery>
<cfquery name="get_payment_order_rows_order" datasource="#DSN3#">
	SELECT
		*
	FROM
		PAYMENT_ORDERS_ROW
	WHERE
		RESULT_ID = #attributes.RESULT_ID#
		AND
		INVOICE_ID IS NULL
</cfquery>
