<cfquery name="GET_ORDER_PLUSES" datasource="#dsn3#">
	SELECT
		*
	FROM
		ORDER_PLUS
	WHERE
		ORDER_ID = #attributes.order_id#<!---HS_sil  <cfif isDefined("ORDER_ID")>#ORDER_ID#<cfelse>#order_id#</cfif> --->
</cfquery>
