<cfquery name="GET_PRODUCTION_LABEL" datasource="#DSN3#">
	SELECT
		*
	FROM
		PRODUCTION_LABEL
	WHERE
		PRODUCTION_ORDER_ID = '#attributes.p_order_id#'
</cfquery>
