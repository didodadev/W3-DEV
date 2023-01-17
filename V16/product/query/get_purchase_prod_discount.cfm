<cfquery name="GET_PURCHASE_PROD_DISCOUNT" datasource="#dsn3#">
	SELECT
		*
	FROM
		CONTRACT_PURCHASE_PROD_DISCOUNT
	WHERE
		C_P_PROD_DISCOUNT_ID = #attributes.discount_id#
</cfquery>
