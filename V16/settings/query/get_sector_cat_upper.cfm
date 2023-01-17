<cfquery name="GET_SECTOR_CAT_UPPER" datasource="#DSN#">
	SELECT 
    	SECTOR_UPPER_ID,
		#dsn#.Get_Dynamic_Language(SECTOR_UPPER_ID,'#session.ep.language#','SETUP_SECTOR_CAT_UPPER ','SECTOR_CAT',NULL,NULL,SECTOR_CAT) AS SECTOR_CAT
	FROM 
		SETUP_SECTOR_CAT_UPPER 
	ORDER BY 
		SECTOR_CAT
</cfquery>
