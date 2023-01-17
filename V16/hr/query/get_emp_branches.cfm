<cfquery name="get_emp_branch" datasource="#DSN#">
	SELECT
		*
	FROM
		EMPLOYEE_POSITION_BRANCHES	
	WHERE
		POSITION_CODE = #SESSION.EP.POSITION_CODE#
</cfquery>
<cfset emp_branch_list=valuelist(get_emp_branch.BRANCH_ID)>
<cfif len(emp_branch_list) and not isdefined("attributes.is_store_module")>
	<cfset emp_branch_list=ListSort(listdeleteduplicates("#emp_branch_list#,#ListGetAt(session.ep.user_location,2,"-")#"),"Numeric")>
<cfelse>
	<cfset emp_branch_list=ListGetAt(session.ep.user_location,2,"-")>
</cfif>
<cfif not listlen(listsort(emp_branch_list,'numeric'))>
	<cfset emp_branch_list = 0>
</cfif>
