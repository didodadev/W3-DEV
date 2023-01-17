<cfquery name="GET_PRODUCT_CAT" datasource="#DSN3#">
	SELECT 
		PRODUCT_CATID, 
		HIERARCHY, 
		PRODUCT_CAT
	FROM
		PRODUCT_CAT
	WHERE
		PRODUCT_CATID IS NOT NULL
		<cfif isDefined("attributes.id")>
			AND PRODUCT_CATID = #attributes.id#
		<cfelseif isDefined("attributes.hier")>
			AND HIERARCHY = '#attributes.hier#'
		</cfif>
	ORDER BY
		HIERARCHY
</cfquery>

