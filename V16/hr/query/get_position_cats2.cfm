<cfquery name="GET_POSITION_CATS" datasource="#dsn#">
	SELECT 
		* 
	FROM 
		SETUP_POSITION_CAT
	WHERE 
		POSITION_CAT_STATUS = 1 
	ORDER BY 
		POSITION_CAT 
</cfquery>
