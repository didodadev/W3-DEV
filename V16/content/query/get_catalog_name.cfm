<cfquery name="GET_CATALOG_NAME" datasource="#dsn3#">
	SELECT 
		CATALOG_HEAD,
		CATALOG_ID
	FROM
		CATALOG
	WHERE
		CATALOG_ID = #attributes.CATALOG_ID#
</cfquery>
