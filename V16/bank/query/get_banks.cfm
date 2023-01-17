<cfscript>
	if (fusebox.use_period)
		center_dsn = dsn3_alias;
	else
		center_dsn = dsn_alias;
</cfscript>
<cfquery name="GET_BANKS" datasource="#center_dsn#">
	SELECT
		DISTINCT(BANK_NAME)
	FROM
		BANK_BRANCH
	ORDER BY
		BANK_NAME
</cfquery>