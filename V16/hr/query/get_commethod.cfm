<cfquery name="GET_COMMETHOD" datasource="#dsn#">
	SELECT * FROM SETUP_COMMETHOD WHERE COMMETHOD_ID = #attributes.COMMETHOD_ID#
</cfquery>
