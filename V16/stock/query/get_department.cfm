<cfquery name="GET_DEPARTMENT" datasource="#DSN#">
	SELECT 
		*
	FROM 
		DEPARTMENT
	WHERE 
		IS_STORE <> 2
		<cfif isDefined("attributes.branch_id") and len(attributes.branch_id)>
			AND	BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#">
		</cfif>
		<cfif session.ep.isBranchAuthorization>
			AND	BRANCH_ID = #listgetat(session.ep.user_location,2,'-')#
		</cfif>
	ORDER BY 
		DEPARTMENT_HEAD
</cfquery>
