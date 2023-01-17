<cfquery name="GET_DEPARTMENT" datasource="#DSN#">
	SELECT
		*
	FROM
		DEPARTMENT
	WHERE
		BRANCH_ID IS NOT NULL AND
		IS_PRODUCTION = 1
		<cfif isDefined("attributes.branch_id")>
			<cfif attributes.branch_id NEQ 0>
		AND
			BRANCH_ID = #attributes.branch_id#
			</cfif>
		</cfif>
	ORDER BY
		DEPARTMENT_HEAD
</cfquery>

