<cfquery name="GET_EXPENSE_ITEM" datasource="#DSN#">
	SELECT
		EXPENSE_ITEMS.*,
		EXPENSE_CATEGORY.EXPENSE_CAT_NAME
	FROM
		<cfif fusebox.use_period>#dsn2_alias#.</cfif>EXPENSE_ITEMS AS EXPENSE_ITEMS,
		#dsn2_alias#.EXPENSE_CATEGORY
	WHERE 
		EXPENSE_CATEGORY.EXPENSE_CAT_ID=EXPENSE_ITEMS.EXPENSE_CATEGORY_ID		
		<cfif isdefined("attributes.item_id")>
		AND EXPENSE_ITEM_ID=#attributes.item_id#
		</cfif>
		<cfif isdefined('attributes.keyword') and len(attributes.keyword)>
		AND EXPENSE_ITEMS.EXPENSE_ITEM_NAME LIKE '#attributes.keyword#%'
		</cfif>
		<cfif isdefined("attributes.cat_id")>
		AND EXPENSE_CATEGORY_ID=#attributes.cat_id#
		</cfif>
	ORDER BY
		EXPENSE_CATEGORY.EXPENSE_CAT_NAME
</cfquery>
