<cfquery name="GET_BRANCH_DEPARTMENTS" datasource="#DSN#">
	SELECT
		DEPARTMENT_ID
	FROM
		DEPARTMENT
	WHERE
		BRANCH_ID=#ListGetAt(session.ep.user_location,2,"-")# AND
		IS_STORE <> 2
</cfquery>
