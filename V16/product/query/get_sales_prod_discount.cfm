<cfquery name="GET_SALES_PROD_DISCOUNT" datasource="#dsn3#">
SELECT
	*
FROM
	CONTRACT_SALES_PROD_DISCOUNT
WHERE
	C_S_PROD_DISCOUNT_ID = #attributes.discount_id#
</cfquery>
