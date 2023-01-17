<cfquery name="GET_PARTNER_SETTINGS" datasource="#DSN#">
	SELECT
		TIME_ZONE,
		TIMEOUT_LIMIT
	FROM
		MY_SETTINGS_P
	WHERE
		PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.pid#">
</cfquery>
