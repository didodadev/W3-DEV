<cfquery name="GET_PROJECT_DATES" DATASOURCE=#DSN#>
	SELECT
		REAL_START,
		REAL_FINISH
	FROM
		PRO_PROJECTS
	WHERE 
		PROJECT_ID = #attributes.PROJECT_ID#
</cfquery>