<cfquery name="GET_SERVICE_APPCAT" datasource="#dsn3#">
	SELECT 
		* 
	FROM 	
		SERVICE_APPCAT
	ORDER BY
		SERVICECAT
</cfquery>
