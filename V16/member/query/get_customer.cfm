<cfquery name="GET_CUSTOMER" datasource="#DSN#">
	SELECT 
		CUSTOMER_VALUE_ID,
		CUSTOMER_VALUE
	FROM
		SETUP_CUSTOMER_VALUE
	ORDER BY
		CUSTOMER_VALUE
</cfquery>
