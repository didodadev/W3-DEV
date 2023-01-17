<cfquery name="GET_DET_STOCK_LOCATION" datasource="#DSN#">
	SELECT
		SL.* 
	FROM 
		STOCKS_LOCATION SL,
		DEPARTMENT D
	WHERE
		SL.DEPARTMENT_LOCATION = '#attributes.id#' AND
		SL.DEPARTMENT_ID = D.DEPARTMENT_ID
	<cfif session.ep.isBranchAuthorization>
		AND D.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ListGetAt(session.ep.user_location,2,"-")#">
	</cfif>
</cfquery>
