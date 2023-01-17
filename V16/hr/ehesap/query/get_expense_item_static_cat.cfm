
<cfquery name="get_expense_item_sta" datasource="#dsn2#">
	SELECT
	<cfif isDefined("attributes.cat_item_id") and len(attributes.cat_item_id)>
		EC.EXPENSE_CAT_ID,
		EC.EXPENSE_CAT_NAME,
		EC.EXPENSE_CAT_DETAIL
	<cfelse>
		*
	</cfif>
	FROM
		EXPENSE_CATEGORY EC
		<cfif not isDefined("attributes.is_all_cat")>
			JOIN EXPENSE_ITEMS EI ON EC.EXPENSE_CAT_ID = EI.EXPENSE_CATEGORY_ID
		</cfif>
	WHERE
		EXPENCE_IS_HR = 1
		<cfif not isDefined("attributes.is_all_cat")>
			AND EI.EXPENSE_ITEM_NAME IS NOT NULL
			<cfif isdefined('attributes.item_id') and len(attributes.item_id)>
				AND EI.EXPENSE_ITEM_ID = #attributes.item_id#
			</cfif>
		</cfif>
		<cfif isDefined("attributes.cat_id") and len(attributes.cat_id)>
			AND EC.EXPENSE_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cat_id#">
		</cfif>
		<cfif isDefined("attributes.keyword") and len(attributes.keyword)>
			AND	
			(
				<cfif not isDefined("attributes.is_all_cat")>
					EI.EXPENSE_ITEM_NAME LIKE '%#attributes.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI OR
				</cfif>
				EC.EXPENSE_CAT_NAME LIKE '%#attributes.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI OR
				EC.EXPENSE_CAT_DETAIL LIKE '%#attributes.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI 
			)
		</cfif>
	<cfif isDefined("attributes.cat_item_id") and len(attributes.cat_item_id)>
	    GROUP BY EC.EXPENSE_CAT_ID,EC.EXPENSE_CAT_NAME,EC.EXPENSE_CAT_DETAIL
	</cfif>
</cfquery>
