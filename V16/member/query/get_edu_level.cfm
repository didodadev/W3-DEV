<cfquery name="GET_EDU_LEVEL" datasource="#DSN#">
	SELECT
		EDU_LEVEL_ID,
		#dsn#.Get_Dynamic_Language(EDU_LEVEL_ID,'#session.ep.language#','SETUP_EDUCATION_LEVEL','EDUCATION_NAME',NULL,NULL,EDUCATION_NAME) AS EDUCATION_NAME
	FROM
		SETUP_EDUCATION_LEVEL
</cfquery>