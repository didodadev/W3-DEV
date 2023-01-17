<cfif not session.ep.ehesap>
	<cfinclude template="get_emp_branches.cfm">
</cfif>
<cfif isdefined("ALL_DEPARTMENTS")>
	<cfquery dbtype="query" name="departments">
		SELECT
			*
		FROM
			ALL_DEPARTMENTS
		<cfif NOT session.ep.ehesap>
			WHERE
				BRANCH_ID IN (#emp_branch_list#)
		</cfif>	
	</cfquery>
<cfelseif isdefined("departments")>
	<cfquery dbtype="query" name="departments">
		SELECT
			*
		FROM
			DEPARTMENTS
		<cfif NOT session.ep.ehesap>
			WHERE
				BRANCH_ID IN (#emp_branch_list#)	
		</cfif>	
	</cfquery>
</cfif>
