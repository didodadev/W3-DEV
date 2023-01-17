<cfquery name="del_service_appcat" datasource="#dsn#">
	DELETE FROM G_SERVICE_APPCAT WHERE SERVICECAT_ID = #attributes.servicecat_id#
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_g_service_app_cat" addtoken="no">

