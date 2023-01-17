<cfquery name="GET_EXPENSE" datasource="#dsn2#">
	SELECT
		*
	FROM
		EXPENSE_CENTER
	<cfif isDefined("attributes.keyword") and len(attributes.keyword)>
	WHERE
		EXPENSE LIKE '%#attributes.keyword#%' OR
		DETAIL LIKE '%#attributes.keyword#%' OR
		EXPENSE_CODE LIKE '%#attributes.keyword#%'
	</cfif>
	<cfif isdefined("attributes.EXPENSE_ID")>
	WHERE 
		EXPENSE_ID <> #attributes.EXPENSE_ID#
	</cfif>
	ORDER BY
		EXPENSE_CODE
</cfquery>
