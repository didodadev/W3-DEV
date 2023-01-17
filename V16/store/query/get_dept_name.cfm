<cfquery name="get_dept_name" datasource="#DSN#">
	SELECT
		DEPARTMENT_HEAD,BRANCH_ID
	FROM
		DEPARTMENT
	WHERE
		DEPARTMENT_ID=#attributes.department_id#
</cfquery>

