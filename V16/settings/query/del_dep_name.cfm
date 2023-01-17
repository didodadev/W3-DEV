<cfquery name="del_title" datasource="#dsn#">
	DELETE FROM SETUP_DEPARTMENT_NAME WHERE DEPARTMENT_NAME_ID=#attributes.id#
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_department_name" addtoken="no">
