<cfquery name="GET_PROM" datasource="#DSN3#">
	SELECT * FROM PROMOTIONS LEFT JOIN CATALOG ON PROMOTIONS.CATALOG_ID = CATALOG.CATALOG_ID WHERE PROM_ID = #attributes.prom_id#
</cfquery>
