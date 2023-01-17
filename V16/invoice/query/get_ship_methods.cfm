<cfquery name="SHIP_METHODS" datasource="#DSN#">
	SELECT
		SHIP_METHOD_ID,
		SHIP_METHOD
	FROM
		SHIP_METHOD
	<cfif isDefined('attributes.ship_method_id')>
	WHERE
		SHIP_METHOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ship_method_id#">
	</cfif>		
</cfquery>
