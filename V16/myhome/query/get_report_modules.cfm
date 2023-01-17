<cfquery name="GET_MODULES" datasource="#DSN#">
	SELECT 
		MODULE_ID, 
		MODULE_NAME 
	FROM 
		MODULES 
	ORDER BY
		MODULE_NAME
</cfquery>
