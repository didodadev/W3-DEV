<cfquery name="GET_MONEYS" datasource="#dsn#">
	SELECT
		*
	FROM
		SETUP_MONEY
	WHERE
	    PERIOD_ID = #session.ep.period_id#
</cfquery>
