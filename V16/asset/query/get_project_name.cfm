<cfquery name="GET_PROJECT_NAME" datasource="#dsn#">
	SELECT 
		PROJECT_ID,
		PROJECT_HEAD
	FROM 
		PRO_PROJECTS
	WHERE
		PROJECT_ID = #attributes.PROJECT_ID#
</cfquery>

