<cfquery name="DETAIL" datasource="#dsn3#">
	SELECT
		*
	FROM
		SCEN_EXPENSE_PERIOD
	WHERE
		PERIOD_ID=#URL.ID#
</cfquery>
