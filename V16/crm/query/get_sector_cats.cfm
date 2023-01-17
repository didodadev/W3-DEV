<cfquery name="GET_SECTOR_CATS" datasource="#dsn#">
	SELECT 
		* 
	FROM 
		SETUP_SECTOR_CATS 
	ORDER BY 
		SECTOR_CAT
</cfquery>
