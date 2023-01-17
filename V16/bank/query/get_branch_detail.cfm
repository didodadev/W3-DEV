<cfif fusebox.use_period><cfset dsn_branch = dsn3><cfelse><cfset dsn_branch = dsn></cfif>
<cfquery name="GET_BRANCH_DETAIL" datasource="#dsn_branch#">
	SELECT
		*
	FROM
		BANK_BRANCH
	WHERE
		BANK_BRANCH_ID = #url.id#	
</cfquery>
	