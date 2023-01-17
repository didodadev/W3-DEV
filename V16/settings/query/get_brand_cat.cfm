<cfquery name="GET_BRAND_CAT" datasource="#DSN#">
	SELECT
		*
	FROM
		SETUP_BRAND_CAT
	WHERE 
		BRAND_CAT_ID IS NOT NULL
		<cfif isDefined('attributes.cat') and len(attributes.cat)>
		AND HIERARCHY LIKE '#attributes.cat#%'
		</cfif>
		<cfif isDefined('attributes.keyword') and len(attributes.keyword)>
		AND (BRAND_CAT LIKE '%#attributes.keyword#%' OR HIERARCHY LIKE '#attributes.keyword#%')			
		</cfif>
	ORDER BY
		HIERARCHY
</cfquery>
