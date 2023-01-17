<cfquery name="GET_COMPANY_SECTOR" datasource="#dsn#">
	SELECT 
		* 
	FROM 
		SETUP_SECTOR_CATS 
	ORDER BY 
		SECTOR_CAT
</cfquery>
