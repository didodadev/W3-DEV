<cfquery name="GET_COMPANY" datasource="#dsn#">
	SELECT 
		COMPANY_ID,
		FULLNAME
	FROM 
		COMPANY
	WHERE
		COMPANY_ID IS NOT NULL
	<cfif isDefined("attributes.keyword") and len(attributes.keyword)>
		<cfif len(attributes.keyword) eq 1>
		AND
		FULLNAME LIKE '#attributes.keyword#%'
		</cfif>
		AND
		(
		NICKNAME LIKE '%#attributes.keyword#%'
		OR
		FULLNAME LIKE '%#attributes.keyword#%'
		)
	</cfif>
	ORDER BY
		FULLNAME
</cfquery>
