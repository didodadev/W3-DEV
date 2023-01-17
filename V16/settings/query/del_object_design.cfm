<cfquery name="del_object_design" datasource="#dsn#">
	DELETE FROM MAIN_SITE_OBJECT_DESIGN WHERE DESIGN_ID=#attributes.design_id#
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_object_design" addtoken="no">

