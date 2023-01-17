<cfquery name="GET_OFFTIME_CATS" datasource="#dsn#">
	SELECT 
		* 
	FROM 
		SETUP_OFFTIME
	WHERE 
		IS_ACTIVE = 1
		AND UPPER_OFFTIMECAT_ID = 0  
	ORDER BY 
		OFFTIMECAT
</cfquery>

