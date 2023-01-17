<cfquery name="DEL_TASK" datasource="#DSN#">
	DELETE FROM SETUP_MAIL_WARNING WHERE MAIL_CAT_ID = #attributes.id#
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_mail_cat" addtoken="no">
