<cfquery name="GET_COMPANY_SECTOR" datasource="#dsn#">
	SELECT 
    	SECTOR_CAT_ID, 
        SECTOR_UPPER_ID, 
        SECTOR_CAT, 
        SECTOR_LIMIT, 
        IS_INTERNET, 
        SECTOR_IMAGE, 
        SERVER_SECTOR_IMAGE_ID, 
        RECORD_EMP, 
        RECORD_DATE, 
        RECORD_IP, 
        UPDATE_EMP, 
        UPDATE_DATE, 
        UPDATE_IP 
    FROM 
    	SETUP_SECTOR_CATS 
    ORDER BY 
    	SECTOR_CAT
</cfquery>
