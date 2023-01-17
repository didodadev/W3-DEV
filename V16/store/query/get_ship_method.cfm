<cfquery name="SHIP_METHOD" datasource="#dsn#">
	SELECT
		SHIP_METHOD
	FROM
		SHIP_METHOD
	WHERE
		SHIP_METHOD_ID = #attributes.SHIP_METHOD_ID#
</cfquery>
