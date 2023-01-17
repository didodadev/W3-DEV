<cfquery name="GET_STOCKS" datasource="#DSN3#">
	SELECT * FROM STOCKS WHERE PRODUCT_ID = #attributes.pid#
</cfquery>
