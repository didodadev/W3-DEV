<cfquery name="SHIP_TYPE" datasource="#dsn#">
	SELECT
		SHIP_TYPE
	FROM
		SHIP_TYPE
	WHERE
		SHIP_TYPE_ID = #attributes.SHIP_TYPE_ID#
</cfquery>
