<cfquery name="GET_MAIN_MENUS" datasource="#DSN#">
	SELECT 
		MENU_ID,
		MENU_NAME
	FROM 
		MAIN_MENU_SETTINGS
	ORDER BY 
		MENU_NAME
</cfquery>

