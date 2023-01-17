<cfquery name="GET_OUR_COMP_AND_BRANCHS" datasource="#DSN#">
	SELECT
		OC.NICK_NAME,
		OC.COMP_ID,
		B.BRANCH_NAME,
		B.RELATED_COMPANY,
		BRANCH_ID,
		COMPANY_NAME
	FROM
		BRANCH B,
		OUR_COMPANY OC
	WHERE
		B.COMPANY_ID = OC.COMP_ID
	<cfif session.ep.ehesap neq 1>
		AND B.BRANCH_ID IN (
						SELECT
							BRANCH_ID
						FROM
							EMPLOYEE_POSITION_BRANCHES
						WHERE
							POSITION_CODE = #session.ep.position_code#
						)
	</cfif>
	ORDER BY
		BRANCH_NAME
</cfquery>

<cfquery name="GET_RELATED_COMPANIES" dbtype="query">
	SELECT DISTINCT RELATED_COMPANY FROM GET_OUR_COMP_AND_BRANCHS
</cfquery>
