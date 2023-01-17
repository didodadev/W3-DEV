<cfquery name="GET_SALES_ZONE_HIERARCHY" datasource="#dsn#">
	SELECT
		SZ_HIERARCHY,
		SZ_NAME,
		SZ_ID
	FROM
		SALES_ZONES
</cfquery>
