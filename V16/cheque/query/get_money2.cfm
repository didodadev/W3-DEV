<cfquery name="GET_MONEY" datasource="#DSN#">
	SELECT
		MONEY,
		RATE2,
		RATE1
	FROM
		SETUP_MONEY
	WHERE
		PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.EP.PERIOD_ID#"> AND
		MONEY_STATUS = <cfqueryparam cfsqltype="cf_sql_smallint" value="1">
		<cfif isDefined('attributes.money') and len(attributes.money)>
		AND MONEY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.money#">
		</cfif>
	ORDER BY 
		MONEY_ID
</cfquery>
