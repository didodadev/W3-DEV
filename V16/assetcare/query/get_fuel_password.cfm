<cfquery name="GET_FUEL_PASSWORD" datasource="#DSN#">
	SELECT
		ASSET_P_FUEL_PASSWORD.*,
		COMPANY.FULLNAME,
		BRANCH.BRANCH_NAME
	FROM
		ASSET_P_FUEL_PASSWORD,
		COMPANY,		
		BRANCH
	WHERE
		PASSWORD_ID = #attributes.password_id# AND
		BRANCH.BRANCH_ID = ASSET_P_FUEL_PASSWORD.BRANCH_ID AND		
		COMPANY.COMPANY_ID = ASSET_P_FUEL_PASSWORD.COMPANY_ID
</cfquery>
