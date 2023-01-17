<cfquery name="GET_PROJECT_HEAD" datasource="#DSN#">
	SELECT
		PROJECT_HEAD
	FROM
		PRO_PROJECTS
	WHERE
		PROJECT_ID = #attributes.project_id#
</cfquery>
