<cfquery name="GET_UPPER_SZ_NAME" datasource="#DSN#">
	SELECT
		SZ_ID,
		SZ_NAME
	FROM
		SALES_ZONES
	WHERE
		SZ_HIERARCHY = '#attributes.HIERARCHY#'
</cfquery>
