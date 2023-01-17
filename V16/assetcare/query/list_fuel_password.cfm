<cfquery name="GET_FUEL_PASSWORD" datasource="#DSN#">
	SELECT
		ASSET_P_FUEL_PASSWORD.*,
		DEPARTMENT.DEPARTMENT_HEAD,
<!--- 		BRANCH.BRANCH_ID, --->
		BRANCH.BRANCH_NAME
	FROM
		ASSET_P_FUEL_PASSWORD,
		DEPARTMENT DEPARTMENT,
		BRANCH BRANCH
	WHERE
		DEPARTMENT.DEPARTMENT_ID = ASSET_P_FUEL_PASSWORD.DEPARTMENT_ID AND
		BRANCH.BRANCH_ID = DEPARTMENT.BRANCH_ID
		<cfif len(attributes.keyword)>AND ASSET_P_FUEL_PASSWORD.COMPANY_NAME LIKE '%#attributes.keyword#%'</cfif>
		<!---<cfif len(attributes.asset_cat)>AND CARE_STATES.CARE_STATE_ID = #attributes.asset_cat#</cfif> --->
		<cfif len(attributes.department_id)>AND ASSET_P_FUEL_PASSWORD.DEPARTMENT_ID = #attributes.department_id#</cfif>
		<!--- <cfif len(attributes.branch_id)>AND BRANCH.BRANCH_ID =#attributes.branch_id#</cfif> --->
</cfquery>
