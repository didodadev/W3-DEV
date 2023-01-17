<cfquery name="GET_DISCOUNT_TYPES" datasource="#DSN3#">
	SELECT
		*
	FROM
		SETUP_DISCOUNT_TYPE 
	ORDER BY
		DISCOUNT_TYPE
</cfquery>
