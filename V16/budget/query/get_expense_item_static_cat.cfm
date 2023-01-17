<cfquery name="GET_EXPENSE_ITEM_STA" datasource="#dsn2#">
	SELECT
		IS_ACTIVE,
		INCOME_EXPENSE,
		IS_EXPENSE,
		EXPENSE_CATEGORY_ID,
		#dsn#.Get_Dynamic_Language(EXPENSE_ITEM_ID,'#session.ep.language#','EXPENSE_ITEMS','EXPENSE_ITEM_NAME',NULL,NULL,EXPENSE_ITEM_NAME) AS EXPENSE_ITEM_NAME,
		EXPENSE_ITEM_CODE,
		ACCOUNT_CODE,
		TAX_CODE,
		#dsn#.Get_Dynamic_Language(EXPENSE_ITEM_ID,'#session.ep.language#','EXPENSE_ITEMS','EXPENSE_ITEM_DETAIL',NULL,NULL,EXPENSE_ITEM_DETAIL) AS EXPENSE_ITEM_DETAIL
	FROM
		EXPENSE_ITEMS
	WHERE 
		EXPENSE_ITEM_ID IS NOT NULL
	  <cfif isdefined('attributes.item_id')>
	  	AND EXPENSE_ITEM_ID = #attributes.item_id#
	  </cfif>
	  <cfif isdefined('attributes.keyword') and len(attributes.keyword)>
	  	AND EXPENSE_ITEM_NAME LIKE '#attributes.keyword#%'
	  </cfif>
	  <cfif isdefined('attributes.static_cat_id')>
	  	AND EXPENSE_CATEGORY_ID = #attributes.static_cat_id#
	  </cfif>
	  <cfif isdefined("attributes.is_expense") and attributes.is_expense>
	  	AND EXPENSE_ITEMS.IS_EXPENSE = 1
	  <cfelseif  isdefined("attributes.is_expense") and not attributes.is_expense>
	  	AND EXPENSE_ITEMS.INCOME_EXPENSE = 1
	  </cfif>		
	ORDER BY
		EXPENSE_ITEM_NAME
</cfquery>
