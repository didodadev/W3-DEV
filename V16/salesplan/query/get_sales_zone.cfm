<cfquery name="GET_SALES_ZONE" datasource="#DSN#">
	SELECT
		*
	FROM
		SALES_ZONES
	WHERE
		SZ_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.SZ_ID#">
</cfquery>
