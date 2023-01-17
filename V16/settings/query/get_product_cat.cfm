<cfquery name="GET_PRODUCT_CAT" datasource="#DSN3#">
	SELECT 
		PRODUCT_CATID, 
		HIERARCHY, 
		PRODUCT_CAT 
	FROM 
		PRODUCT_CAT
	WHERE 
		PRODUCT_CATID IS NOT NULL
		<cfif isDefined("attributes.ID")>
		AND PRODUCT_CATID = #attributes.ID#
		<cfelseif isDefined("attributes.HIER")>
		AND HIERARCHY = '#attributes.HIER#'
		</cfif>
	ORDER BY 
		HIERARCHY
</cfquery>
