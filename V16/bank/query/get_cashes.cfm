<cfquery name="GET_CASHES" datasource="#dsn2#">
	SELECT 
		*
	FROM
		CASH
	WHERE
		CASH_STATUS = <cfqueryparam cfsqltype="cf_sql_smallint" value="1">
		<cfif session.ep.isBranchAuthorization>
			AND BRANCH_ID = #ListGetAt(session.ep.user_location,2,"-")#
		</cfif>
	ORDER BY 
		CASH_NAME
</cfquery>
