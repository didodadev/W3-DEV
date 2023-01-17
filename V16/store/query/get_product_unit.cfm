<cfquery name="GET_PRODUCT_UNIT" datasource="#dsn3#">
	SELECT 
		MAIN_UNIT_ID,
		PRODUCT_UNIT_ID,
		ADD_UNIT
	FROM 
		PRODUCT_UNIT
	WHERE 
		PRODUCT_ID = #attributes.pid#
		<cfif isdefined('attributes.product_unit_id')>
			AND PRODUCT_UNIT_ID=#attributes.product_unit_id#
		</cfif>
	ORDER BY	
		ADD_UNIT
</cfquery>
