<cfquery name="get_expense_cat_list" datasource="#dsn2#">
	SELECT 
		*
	FROM
		EXPENSE_CATEGORY
	WHERE
		EXPENSE_CAT_ID IS NOT NULL
		<cfif isdefined("attributes.cat_id") and len(attributes.cat_id)>AND EXPENSE_CAT_ID=#URL.cat_id#</cfif>
		<cfif isdefined("attributes.keyword") and len(attributes.keyword)>AND EXPENSE_CAT_NAME LIKE '#attributes.keyword#%'</cfif>
	ORDER BY
		EXPENSE_CAT_NAME
</cfquery>
