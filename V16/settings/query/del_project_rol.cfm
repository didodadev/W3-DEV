<cfquery name="DELPRO_ROL" datasource="#dsn#">
	DELETE FROM SETUP_PROJECT_ROLES WHERE PROJECT_ROLES_ID=#url.PROJECT_ROLES_ID#
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_pro_rol" addtoken="no">
