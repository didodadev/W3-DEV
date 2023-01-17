<cfquery name="GET_PRODUCT_UNITS" datasource="#dsn3#">
	SELECT 
		DISTINCT
		ADD_UNIT
	FROM 
		PRODUCT_UNIT
	ORDER BY
		ADD_UNIT
</cfquery>
