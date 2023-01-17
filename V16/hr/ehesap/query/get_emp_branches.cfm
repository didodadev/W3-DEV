<cfquery name="get_emp_branch" datasource="#DSN#">
	SELECT
		<!--- EMPLOYEE_POSITION_BRANCHES.PRIORITY_BRANCH_ID,
		EMPLOYEE_POSITION_BRANCHES.PRIORITY_DEPARTMENT_ID, FB 20070720 bu alanlar kaldirildi 100 gune silinsin--->
		EMPLOYEE_POSITION_BRANCHES.BRANCH_ID,
		EMPLOYEE_POSITION_BRANCHES.POSITION_CODE
		
	FROM
		EMPLOYEE_POSITION_BRANCHES,
		BRANCH
	WHERE
		EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = #session.ep.position_code#
		AND EMPLOYEE_POSITION_BRANCHES.BRANCH_ID = BRANCH.BRANCH_ID
	ORDER BY
		BRANCH.BRANCH_NAME
</cfquery>

<cfset emp_branch_list=valuelist(get_emp_branch.BRANCH_ID)>

<cfif LEN(emp_branch_list)>
	<cfset emp_branch_list=ListSort("#emp_branch_list#,#ListGetAt(session.ep.user_location,2,"-")#","Numeric")>
<cfelse>
	<cfset emp_branch_list=ListGetAt(session.ep.user_location,2,"-")>
</cfif>
