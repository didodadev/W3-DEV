<cfset toplanti="toplantı">
<cfquery name="GET_EXPENSE" datasource="#dsn2#">
	SELECT
		EXPENSE_ID,
		EXPENSE
	FROM
		EXPENSE_CENTER 
	<cfif isDefined("attributes.keyword") and len(attributes.keyword)>
		WHERE 
			EXPENSE LIKE '<cfif len(attributes.keyword) neq 1>%</cfif>#attributes.keyword#%'
	</cfif>
	ORDER BY 
		EXPENSE
</cfquery>
