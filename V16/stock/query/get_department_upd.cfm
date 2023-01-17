<cfquery name="GET_DEPARTMENT_UPD" datasource="#DSN#">
	SELECT
		*
	FROM
		DEPARTMENT
	WHERE
		DEPARTMENT_ID = #attributes.department_id#
	<cfif session.ep.isBranchAuthorization>
		AND BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ListGetAt(session.ep.user_location,2,"-")#">
	</cfif>
</cfquery>

