<cfquery name="GET_POS_EQUIPMENT_BANK" datasource="#dsn3#">
	SELECT
		*
	FROM
		POS_EQUIPMENT_BANK
	WHERE
		POS_ID IS NOT NULL
		<cfif len(attributes.keyword)>
		AND
		(
			EQUIPMENT LIKE '%#attributes.keyword#%' OR
			POS_CODE LIKE '%#attributes.keyword#%' OR
			SELLER_CODE LIKE '%#attributes.keyword#%'
		)
		</cfif>
		<cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>AND BRANCH_ID = #attributes.branch_id#</cfif>
</cfquery>
