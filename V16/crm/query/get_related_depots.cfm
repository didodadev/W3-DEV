<cfquery name="GET_RELATED_DEPOTS" datasource="#dsn#">
	SELECT 
		OUR_COMPANY.COMP_ID,
		BRANCH.BRANCH_NAME
	FROM 
		OUR_COMPANY,
		COMPANY_BRANCH_RELATED,
		BRANCH
	WHERE 
		COMPANY_BRANCH_RELATED.MUSTERIDURUM IS NOT NULL AND
		COMPANY_BRANCH_RELATED.COMPANY_ID = #attributes.cpid# AND
		COMPANY_BRANCH_RELATED.BRANCH_ID = BRANCH.BRANCH_ID AND
		OUR_COMPANY.COMP_ID = BRANCH.COMPANY_ID
</cfquery>
