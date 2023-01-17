<cfquery name="get_pro_assort" datasource="#DSN3#">
	SELECT
		*
	FROM
		PRODUCTION_ASSORTMENT
	WHERE
		P_ORDER_ID=#attributes.p_order_id#
</cfquery>
