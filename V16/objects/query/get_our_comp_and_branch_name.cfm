<cfquery name="get_com_branch" datasource="#DSN#">
	SELECT
		OC.NICK_NAME,
		B.BRANCH_NAME,
		BRANCH_ID,
		COMPANY_NAME
	FROM
		BRANCH B,
		OUR_COMPANY OC
	WHERE
		B.COMPANY_ID=OC.COMP_ID 
		AND B.BRANCH_STATUS = 1
	<cfif isdefined("my_comp_branch_id") and len(my_comp_branch_id)>
		AND BRANCH_ID = #my_comp_branch_id#
	</cfif>
	<cfif not session.ep.ehesap>
		AND BRANCH_ID IN (
							SELECT
								BRANCH_ID
							FROM
								EMPLOYEE_POSITION_BRANCHES
							WHERE
								POSITION_CODE = #SESSION.EP.POSITION_CODE#
							)
	</cfif>
	ORDER BY COMPANY_NAME,B.BRANCH_NAME
</cfquery>
