<cfquery name="get_name_of_dep" datasource="#DSN#">
	SELECT
		DEPARTMENT_HEAD
	FROM
		DEPARTMENT
	WHERE
		DEPARTMENT_ID=#search_dep_id#
</cfquery>
