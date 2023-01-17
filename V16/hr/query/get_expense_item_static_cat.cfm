<cfquery name="GET_EXPENSE_ITEM_STA" datasource="#dsn2#">
	SELECT
		*
	FROM
		EXPENSE_ITEMS
	WHERE 
		EXPENSE_CATEGORY_ID=-3
	<cfif isdefined('attributes.keyword') and len(attributes.keyword)>
		AND
		EXPENSE_ITEMS.EXPENSE_ITEM_NAME LIKE '#attributes.keyword#%'
	</cfif>
	<cfif isdefined('attributes.item_id')>
		AND
		EXPENSE_ITEMS.EXPENSE_ITEM_ID =#attributes.item_id#
	</cfif>
</cfquery>
