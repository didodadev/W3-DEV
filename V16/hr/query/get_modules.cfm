<cfquery name="GET_MODULES" datasource="#dsn#">
	SELECT * FROM MODULES ORDER BY MODULE_NAME
</cfquery>
