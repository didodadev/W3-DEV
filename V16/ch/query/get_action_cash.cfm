<cfquery name="GET_ACTION_CASH" datasource="#dsn2#">
	SELECT
		CASH_NAME
	FROM
		CASH
	WHERE	
		CASH_ID = #CASH_ID#
</cfquery>
