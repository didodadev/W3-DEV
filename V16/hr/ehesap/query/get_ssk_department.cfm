<cfquery name="get_ssk_department" datasource="#dsn#">
	SELECT
		B.BRANCH_ID,
		B.BRANCH_NAME,	
		B.BRANCH_FULLNAME,	
		B.SSK_OFFICE,
		B.COMPANY_ID,
		B.SSK_NO,
		B.BRANCH_TAX_NO,
		B.BRANCH_TAX_OFFICE,
		D.DEPARTMENT_HEAD,
		D.DEPARTMENT_ID
	FROM
		BRANCH B,
		DEPARTMENT D
	WHERE
		B.SSK_NO IS NOT NULL AND
		D.BRANCH_ID=B.BRANCH_ID AND
		B.SSK_NO IS NOT NULL AND
		B.SSK_OFFICE IS NOT NULL AND
		B.SSK_BRANCH IS NOT NULL AND
		B.SSK_NO <> '' AND
		B.SSK_OFFICE <> '' AND
		B.SSK_BRANCH <> ''
	<cfif not session.ep.ehesap>
		AND B.BRANCH_ID IN (
						SELECT
							BRANCH_ID
						FROM
							EMPLOYEE_POSITION_BRANCHES
						WHERE
							EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = #session.ep.position_code#
							)
	</cfif>
	ORDER BY
		DEPARTMENT_HEAD,
		SSK_OFFICE
</cfquery>
