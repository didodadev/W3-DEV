<cfquery name="get_catalog_names" datasource="#dsn3#">
	SELECT
		CATALOG_ID, CATALOG_HEAD
	FROM
		CATALOG
	WHERE
		CATALOG_STATUS = 1
		<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
			AND CATALOG_HEAD LIKE '%#attributes.keyword#%'
		</cfif>
</cfquery>
