<cfquery name="get_offtime_limit" datasource="#dsn#">
	SELECT
		*
	FROM
		SETUP_OFFTIME_LIMIT
	WHERE
		LIMIT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.limit_id#">
</cfquery>
