<cfquery name="GET_EXPENSE_ITEM" datasource="#DSN2#" cachedwithin="#fusebox.general_cached_time#">
	SELECT
		EXPENSE_ITEMS.*,
		EXPENSE_CATEGORY.EXPENSE_CAT_NAME,
		ACCOUNT_PLAN.ACCOUNT_NAME
	FROM
		EXPENSE_ITEMS,
		EXPENSE_CATEGORY,
		ACCOUNT_PLAN
	WHERE 
		EXPENSE_CATEGORY.EXPENSE_CAT_ID = EXPENSE_ITEMS.EXPENSE_CATEGORY_ID AND
		ACCOUNT_PLAN.ACCOUNT_CODE = EXPENSE_ITEMS.ACCOUNT_CODE AND
		EXPENSE_ITEMS.IS_EXPENSE = 1
		<cfif isdefined("attributes.item_id")>AND EXPENSE_ITEM_ID=#attributes.item_id#</cfif>
		<cfif isdefined('attributes.keyword') and len(attributes.keyword)>AND EXPENSE_ITEMS.EXPENSE_ITEM_NAME LIKE '#attributes.keyword#%'</cfif>
		<cfif isdefined("attributes.cat_id")>AND EXPENSE_CATEGORY_ID=#attributes.cat_id#</cfif>
		<cfif isDefined("attributes.expense_cat") and len(attributes.expense_cat)>AND EXPENSE_ITEMS.EXPENSE_CATEGORY_ID = #attributes.expense_cat#</cfif>
	ORDER BY
		EXPENSE_ITEMS.EXPENSE_ITEM_NAME
</cfquery>
