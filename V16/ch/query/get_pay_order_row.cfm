<cfquery name="get_payment_order_rows" datasource="#DSN3#">
	SELECT
		*
	FROM
		PAYMENT_ORDERS_ROW
	WHERE
		RESULT_ID = #attributes.RESULT_ID#
</cfquery>
