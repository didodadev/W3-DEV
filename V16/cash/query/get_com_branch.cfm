<cfquery name="GET_COM_BRANCH" datasource="#dsn#">
	SELECT
		BRANCH_NAME,BRANCH_ID
	FROM
		BRANCH
	<cfif isdefined("attributes.according_to_session") and attributes.according_to_session eq 1>
	WHERE
		COMPANY_ID=#SESSION.EP.COMPANY_ID#
	</cfif>
	ORDER BY
		BRANCH_NAME
</cfquery>
<cfquery name="GET_COM_BRANCH_" datasource="#dsn#">
	SELECT
		BRANCH_NAME,BRANCH_ID
	FROM
		BRANCH
	WHERE
		COMPANY_ID=#SESSION.EP.COMPANY_ID#
	ORDER BY
		BRANCH_NAME
</cfquery>
