<cfquery name="GET_WORKGROUPS" datasource="#DSN#" maxrows="1">
	SELECT 
		WORKGROUP_NAME,
		GOAL,
		WORKGROUP_ID 
	FROM 
		WORK_GROUP 
	WHERE 
		ONLINE_HELP = 1 
	ORDER BY 
		WORKGROUP_ID ASC
</cfquery>
