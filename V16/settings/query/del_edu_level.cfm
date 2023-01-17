<cfquery name="del_sr" datasource="#DSN#">
	DELETE
	FROM
		SETUP_EDUCATION_LEVEL
	WHERE
		EDU_LEVEL_ID=#attributes.edu_id#
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_edu_level" addtoken="no">
