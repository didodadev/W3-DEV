<cfquery name="GET_CUSTOMER_VALUE" datasource="#DSN#">
	SELECT
		CUSTOMER_VALUE_ID,
		CUSTOMER_VALUE 
	FROM
		SETUP_CUSTOMER_VALUE WITH (NOLOCK)
	ORDER BY
		CUSTOMER_VALUE
</cfquery>
