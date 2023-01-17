<cfquery name="GET_DEPARTMENT" datasource="#DSN#">
	SELECT
		BRANCH_ID,
		DEPARTMENT_ID,
		DEPARTMENT_HEAD  
	FROM
		DEPARTMENT
	WHERE
		BRANCH_ID = #get_cash_detail.branch_id#
</cfquery>

