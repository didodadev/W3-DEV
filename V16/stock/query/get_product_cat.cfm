<cfquery name="GET_PRODUCT_CAT" datasource="#dsn3#">
	SELECT 
		PRODUCT_CATID, 
		HIERARCHY, 
		PRODUCT_CAT 
	FROM 
		PRODUCT_CAT
		<cfif isDefined("URL.ID")>
	WHERE 
		PRODUCT_CATID = #URL.ID#
		<cfelseif isDefined('attributes.product_catid')>
	WHERE 
		PRODUCT_CATID = #attributes.product_catid#
		</cfif>
	ORDER BY
		HIERARCHY
</cfquery>
