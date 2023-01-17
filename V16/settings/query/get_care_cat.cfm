<cfquery name="get_care_cat" datasource="#DSN#">
	SELECT
		*
	FROM
		SETUP_CARE_CAT
	WHERE 
		CARE_CAT_ID IS NOT NULL
		<cfif isDefined('attributes.cat') and len(attributes.cat)>
		AND HIERARCHY LIKE '#attributes.cat#%'
		</cfif>
		<cfif isDefined('attributes.keyword') and len(attributes.keyword)>
		AND (CARE_CAT LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR HIERARCHY LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#">)			
		</cfif>
	ORDER BY
		HIERARCHY
</cfquery>
