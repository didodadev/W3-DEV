<cfquery name="GET_PROM" datasource="#dsn3#">
	SELECT
		PROMOTIONS.*
	FROM
		PROMOTIONS
	WHERE
		PROMOTIONS.PROM_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.PROM_ID#">
</cfquery>
