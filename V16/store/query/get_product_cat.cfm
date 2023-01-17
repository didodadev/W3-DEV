<cfquery name="GET_PRODUCT_CAT" datasource="#DSN3#">
	SELECT 
		PRODUCT_CATID, 
		HIERARCHY, 
		PRODUCT_CAT 
	FROM 
		PRODUCT_CAT
	<cfif isDefined("URL.ID")>
	WHERE 
		PRODUCT_CATID = #URL.ID#
	</cfif>
	ORDER BY 
		HIERARCHY
</cfquery>
