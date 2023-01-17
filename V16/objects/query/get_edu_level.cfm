<cfquery name="GET_EDU_LEVEL" datasource="#DSN#">
	SELECT
		EDU_LEVEL_ID,
		EDUCATION_NAME
	FROM
		SETUP_EDUCATION_LEVEL
</cfquery>
