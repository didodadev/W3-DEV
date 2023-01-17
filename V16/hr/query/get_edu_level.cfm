<cfquery name="get_edu_level" datasource="#DSN#">
	SELECT * FROM SETUP_EDUCATION_LEVEL ORDER BY EDU_LEVEL_ID
</cfquery>
