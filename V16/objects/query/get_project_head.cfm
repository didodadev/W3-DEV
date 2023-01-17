<cfquery name="GET_PROJECT_HEAD" datasource="#dsn#">
	SELECT
		PROJECT_HEAD
	FROM
		PRO_PROJECTS
	WHERE
		PROJECT_ID = #attributes.PROJECT_ID#
</cfquery>
