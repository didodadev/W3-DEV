<cfquery name="get_ssk_offices" datasource="#dsn#">
	SELECT DISTINCT
		BRANCH_ID,
		BRANCH_NAME,		
		SSK_OFFICE,
		SSK_NO
	FROM
		BRANCH
	WHERE
		BRANCH.SSK_NO IS NOT NULL AND
		BRANCH.SSK_OFFICE IS NOT NULL AND 
		BRANCH.SSK_BRANCH IS NOT NULL AND
		BRANCH.SSK_NO <> '' AND
		BRANCH.SSK_OFFICE <> '' AND
		BRANCH.SSK_BRANCH <> ''
		<cfif not session.ep.ehesap>
		AND BRANCH_ID IN (
						SELECT
							BRANCH_ID
						FROM
							EMPLOYEE_POSITION_BRANCHES
						WHERE
							EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = #session.ep.position_code#
						)
		</cfif>
	ORDER BY
		BRANCH_NAME
</cfquery>
