<cfquery name="GET_MODULES" datasource="#DSN#">
	SELECT * FROM MODULES ORDER BY MODULE_NAME
</cfquery>
