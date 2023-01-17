<cfquery name="get_position_cats" datasource="#dsn#">
	SELECT 
		POSITION_CAT,
		POSITION_CAT_ID
	FROM 
		SETUP_POSITION_CAT
	ORDER BY
		POSITION_CAT
</cfquery>
