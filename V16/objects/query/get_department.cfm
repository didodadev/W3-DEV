<cfquery name="GET_DEPARTMENT" datasource="#DSN#">
	SELECT
		DEPARTMENT_ID,
		DEPARTMENT_HEAD
	FROM
		DEPARTMENT
	WHERE
		DEPARTMENT_ID = #attributes.department_id#
</cfquery>
