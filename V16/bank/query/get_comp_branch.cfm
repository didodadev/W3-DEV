<cfquery name="GET_COM_BRANCH" datasource="#dsn#">
	SELECT
		BRANCH_NAME,BRANCH_ID
	FROM
		BRANCH
	WHERE
		COMPANY_ID=#session.ep.company_id#
		<cfif session.ep.isBranchAuthorization>
			AND BRANCH_ID = #listgetat(session.ep.user_location,2,"-")#
		</cfif>
	ORDER BY
		BRANCH_NAME
</cfquery>
