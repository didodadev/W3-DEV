<cfquery name="GET_PARTNER_DEPARTMENTS" datasource="#dsn#">
	SELECT 
		* 
	FROM 
		SETUP_PARTNER_DEPARTMENT 
	ORDER BY 
		PARTNER_DEPARTMENT 
</cfquery>