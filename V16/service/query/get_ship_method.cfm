<cfquery name="SHIP_METHOD" datasource="#DSN#">
	SELECT
		SHIP_METHOD
	FROM
		SHIP_METHOD
	WHERE
		SHIP_METHOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ship_method_id#">
</cfquery>
