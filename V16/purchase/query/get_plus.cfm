<cfif attributes.plus_type is "offer">
	<cfquery name="GET_PLUS" datasource="#dsn3#">
		SELECT 
			* 
		FROM 
			OFFER_PLUS 
		WHERE 
			OFFER_PLUS_ID = #attributes.OID#
	</cfquery>
<cfelseif attributes.plus_type is "order">
	<cfquery name="GET_PLUS" datasource="#dsn3#">
		SELECT 
			* 
		FROM 
			ORDER_PLUS 
		WHERE 
			ORDER_PLUS_ID = #attributes.OID#
	</cfquery>
</cfif>
