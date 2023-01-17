<cfquery name="get_name_of_dep" datasource="#DSN#">
	SELECT
		DEPARTMENT_HEAD,BRANCH_ID
	FROM
		DEPARTMENT
	WHERE
		DEPARTMENT_ID=#search_dep_id# AND 
		IS_STORE <> 2		
</cfquery>

