<cfquery name="GET_HR_SETTINGS" datasource="#dsn#">
	SELECT 
		INTERFACE_ID,
		LANGUAGE_ID,
		TIME_ZONE,
		LAST_LOGIN,
		LOGIN_TIME,
		LAST_LOGIN_IP,
		OZEL_MENU_ID
	FROM 
		MY_SETTINGS
	WHERE 
		EMPLOYEE_ID = #attributes.EMPLOYEE_ID#
</cfquery>

