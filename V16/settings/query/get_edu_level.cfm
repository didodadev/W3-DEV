<cfquery name="GET_EDU" datasource="#dsn#">
	SELECT
	#dsn#.Get_Dynamic_Language(EDU_LEVEL_ID,'#session.ep.language#','SETUP_EDUCATION_LEVEL','EDUCATION_NAME',NULL,NULL,EDUCATION_NAME) AS EDUCATION_NAME, 
		*
	FROM 
		SETUP_EDUCATION_LEVEL
	<cfif isdefined("attributes.upd_edu_id")>
		WHERE
			EDU_LEVEL_ID= #attributes.upd_edu_id#
	</cfif>
</cfquery>