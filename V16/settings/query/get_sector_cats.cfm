<cfquery name="GET_SECTOR_CATS" datasource="#dsn#">
	SELECT 
		*,
        (SELECT SECTOR_CAT_CODE FROM SETUP_SECTOR_CAT_UPPER WHERE SECTOR_UPPER_ID = SETUP_SECTOR_CATS.SECTOR_UPPER_ID ) AS UPPER_SECTOR_CAT_CODE
	FROM 
		SETUP_SECTOR_CATS 
	ORDER BY 
		SECTOR_CAT
</cfquery>
