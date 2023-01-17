<cfquery name="GET_CARE_CAT" datasource="#DSN#">
	SELECT
		HIERARCHY,
		CARE_CAT,
		IS_SUB_CARE_CAT,
		CARE_CAT_ID
	FROM
		SETUP_CARE_CAT
	WHERE 
		CARE_CAT_ID IS NOT NULL
		<cfif isDefined('attributes.keyword') and len(attributes.keyword)>
			AND (CARE_CAT LIKE '<cfif len(attributes.keyword) neq 1>%</cfif>#attributes.keyword#%' OR HIERARCHY LIKE '#attributes.keyword#%')
		</cfif>
		ORDER BY HIERARCHY
</cfquery>
