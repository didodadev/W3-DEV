<cfquery name="GET_WORKGROUPS" datasource="#DSN#">
	SELECT 
		GOAL,
		WORKGROUP_ID,
		HIERARCHY,
		WORKGROUP_NAME 
	FROM 
		WORK_GROUP 
	WHERE
		HIERARCHY IS NOT NULL
	ORDER BY 
		HIERARCHY,
		WORKGROUP_NAME
</cfquery>
<cfquery name="GET_WORKGROUP_TYPES" datasource="#DSN#">
	SELECT 
		WORKGROUP_TYPE_ID,
		WORKGROUP_TYPE_NAME
	FROM
		SETUP_WORKGROUP_TYPE
	ORDER BY 
		WORKGROUP_TYPE_NAME
</cfquery>
