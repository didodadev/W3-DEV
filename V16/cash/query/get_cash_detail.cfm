<cfquery name="GET_CASH_DETAIL" datasource="#DSN2#">
	SELECT 
		*
	FROM
		CASH
	WHERE	
		CASH_ID = #URL.ID#
</cfquery>
