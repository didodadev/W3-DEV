<cfquery name="GET_MONEY_RATE" datasource="#DSN2#">
	SELECT
		*
	FROM
		SETUP_MONEY
	WHERE
		MONEY_STATUS = 1
</cfquery>
