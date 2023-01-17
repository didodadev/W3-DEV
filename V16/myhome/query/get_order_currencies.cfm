<cfquery name="GET_ORDER_CURRENCIES" datasource="#DSN3#">
	SELECT
		*
	FROM
		ORDER_CURRENCY
	ORDER BY
		ORDER_CURRENCY
</cfquery>
