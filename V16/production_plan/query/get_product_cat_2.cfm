<cfquery name="GET_PRODUCT_CAT_2" datasource="#DSN3#">
	SELECT 
		PRODUCT_CATID, 
		HIERARCHY, 
		PRODUCT_CAT 
	FROM 
		PRODUCT_CAT
	WHERE 
		PRODUCT_CATID IS NOT NULL
	<cfif isDefined("attributes.CAT")>
	 AND
		HIERARCHY = '#attributes.CAT#'
	</cfif>
	ORDER BY
		HIERARCHY
</cfquery>
