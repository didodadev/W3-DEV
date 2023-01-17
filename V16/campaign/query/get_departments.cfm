<cfquery name="GET_DEPARTMENTS" datasource="#DSN#">
	SELECT 
		DEPARTMENT.DEPARTMENT_ID,
		DEPARTMENT.DEPARTMENT_HEAD,
		DEPARTMENT.BRANCH_ID,
		DEPARTMENT.DEPARTMENT_STATUS,
		BRANCH.BRANCH_ID,
		BRANCH.BRANCH_NAME,
		BRANCH.BRANCH_STATUS
	FROM 
		DEPARTMENT,
		BRANCH
	WHERE
		BRANCH.BRANCH_STATUS = 1 AND
		BRANCH.BRANCH_ID = DEPARTMENT.BRANCH_ID AND
		DEPARTMENT.DEPARTMENT_STATUS = 1 
		<cfif isDefined("attributes.branch_id")>
            AND BRANCH.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#">
        </cfif>	
		<cfif isdefined("attributes.department_id")>
            AND DEPARTMENT.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department_id#">
        </cfif>
	ORDER BY
		DEPARTMENT.DEPARTMENT_HEAD
</cfquery>
