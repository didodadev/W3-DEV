<cfquery name="GET_POSITION_CATS" datasource="#dsn#">
	SELECT 
		* 
	FROM 
		SETUP_POSITION_CAT
	ORDER BY 
		POSITION_CAT 
</cfquery>