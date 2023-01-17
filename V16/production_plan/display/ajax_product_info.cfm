<cfsetting showdebugoutput="no">
<cfquery name="GET_PRODUCT_INFO" datasource="#DSN3#">
	SELECT TOP 1 * FROM PRODUCTION_ORDERS
</cfquery>
<cfdump var="#GET_PRODUCT_INFO#">
