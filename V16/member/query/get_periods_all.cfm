<cfquery name="PERIODS" datasource="#DSN#">
	SELECT 
		SETUP_PERIOD.PERIOD,
		SETUP_PERIOD.PERIOD_ID,
		SETUP_PERIOD.OUR_COMPANY_ID
	FROM
		SETUP_PERIOD,
		OUR_COMPANY
	WHERE
		OUR_COMPANY.COMP_ID = SETUP_PERIOD.OUR_COMPANY_ID
</cfquery>

