<cfquery name="get_dep" datasource="#DSN#">
	SELECT DEPARTMENT_HEAD,BRANCH_ID FROM DEPARTMENT WHERE DEPARTMENT_ID=#DELIVER_DEPT#
</cfquery>

