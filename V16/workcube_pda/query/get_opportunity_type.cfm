<cfquery name="GET_OPPORTUNITY_TYPE" datasource="#DSN3#">
	SELECT
		OPPORTUNITY_TYPE_ID,
		OPPORTUNITY_TYPE
	FROM
		SETUP_OPPORTUNITY_TYPE
	ORDER BY
		OPPORTUNITY_TYPE
</cfquery>