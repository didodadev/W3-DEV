<cfquery name="GET_ACTION_CASH" datasource="#dsn2#">
	SELECT
		CASH_NAME,CASH_ID,BRANCH_ID
	FROM
		CASH
	<cfif isDefined("CASH_ID") and len(CASH_ID)>
	WHERE	
		CASH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CASH_ID#">
	</cfif>
</cfquery>
