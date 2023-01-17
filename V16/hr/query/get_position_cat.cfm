<cfquery name="GET_POSITION_CAT" datasource="#dsn#">
	SELECT 
    	POSITION_CAT_ID,
        POSITION_CAT FROM SETUP_POSITION_CAT 
	WHERE 
    	POSITION_CAT_ID 
	IN 
    	(#ListSort(attributes.POSITION_CAT_ID,"numeric")#) 
    ORDER BY 
    	POSITION_CAT_ID
</cfquery>
