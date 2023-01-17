<cfquery name="GET_NAME_OF_DEP" datasource="#DSN#">
	SELECT
		DEPARTMENT_HEAD,
		BRANCH_ID
	FROM
		DEPARTMENT
	WHERE
		DEPARTMENT_ID = #search_dep_id#	AND 
		IS_STORE <> 2
</cfquery>
