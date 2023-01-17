<cfquery name="GET_CONTENT_STAGES" datasource="#DSN#">
	SELECT 
		STAGE_ID, 
		STAGE_NAME 
	FROM 
		CONTENT_STAGES 
	ORDER BY
		STAGE_NAME
</cfquery>

