<cfquery name="GET_PROPERTY_DETAIL" datasource="#DSN1#">
	SELECT 
		PROPERTY_DETAIL_ID,
        PROPERTY_DETAIL,
        RELATED_VARIATION_ID,
        PROPERTY_VALUES,
        UNIT
	FROM 
		PRODUCT_PROPERTY_DETAIL 
	WHERE 
		<cfif isdefined('attributes.prpt_id')>
            PRPT_ID IN (#attributes.prpt_id#)
        <cfelseif isdefined('attributes.variations_id')>    
            PROPERTY_DETAIL_ID IN (#attributes.variations_id#)
        </cfif>
	ORDER BY
		PROPERTY_DETAIL
</cfquery>

