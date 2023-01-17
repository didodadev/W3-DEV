<cfquery name="get_branches" datasource="#DSN#">
	SELECT
		ZONE.ZONE_NAME,
		BRANCH.BRANCH_NAME,
		BRANCH.BRANCH_ID,
		OUR_COMPANY.NICK_NAME
	FROM 
		BRANCH,
		ZONE,
		OUR_COMPANY
	WHERE 
		BRANCH.COMPANY_ID = OUR_COMPANY.COMP_ID AND
		ZONE_STATUS = 1 AND
		BRANCH_STATUS = 1 AND
		ZONE.ZONE_ID = BRANCH.ZONE_ID
	<cfif not session.ep.ehesap>
		AND
		BRANCH_ID IN (
						SELECT
							BRANCH_ID
						FROM
							EMPLOYEE_POSITION_BRANCHES
						WHERE
							POSITION_CODE = #SESSION.EP.POSITION_CODE#
					)
	</cfif>
	<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
		AND BRANCH.BRANCH_NAME LIKE '%#attributes.keyword#%'
	</cfif>
	<cfif isdefined("attributes.company_id") and len(attributes.company_id)>
		AND OUR_COMPANY.COMP_ID = #attributes.company_id#
	</cfif>
	<cfif isdefined("attributes.BRANCH_ID") and len(attributes.BRANCH_ID)>
		AND BRANCH.BRANCH_ID = #attributes.BRANCH_ID#
	</cfif>
	ORDER BY
		ZONE.ZONE_NAME,
		BRANCH.BRANCH_NAME
</cfquery>
