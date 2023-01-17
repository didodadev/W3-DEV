<cfquery name="get_expense_cat_list" datasource="#dsn2#">
	SELECT 
		*
	FROM
		EXPENSE_CATEGORY
  <cfif isdefined("attributes.cat_id")>
	WHERE 
		EXPENSE_CAT_ID=#attributes.cat_id#
  </cfif>
  <cfif isdefined('attributes.keyword') and len(attributes.keyword)>
	WHERE 
		EXPENSE_CAT_NAME LIKE '#attributes.keyword#%'
  </cfif>
</cfquery>
