<cfquery name="SHIP_METHODS" datasource="#DSN#">
	SELECT
	<cfif isDefined("attributes.NAMES")>
		SHIP_METHOD_ID,
		SHIP_METHOD
	<cfelse>
		*
	</cfif>
	FROM
		SHIP_METHOD
</cfquery>
