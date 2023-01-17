<cfquery name="get_action_stages" datasource="#dsn#">
	SELECT 
		STAGE_ID,
		STAGE_NAME 
	FROM 
		SETUP_ACTION_STAGES 
	ORDER BY 
		STAGE_NAME
</cfquery>
