<cfquery name="GET_BRANCH_NAMES" datasource="#dsn#">
	SELECT 
		BRANCH_NAME,
		BRANCH_ID
	FROM 
		BRANCH
	<cfif not session.ep.ehesap>
		WHERE BRANCH_ID IN ( SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code# )
	</cfif>
	ORDER BY
		BRANCH_NAME
</cfquery>
