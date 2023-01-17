<cfquery name="DEL_TARGET_CAT" datasource="#dsn#">
	DELETE FROM TARGET_CAT WHERE TARGETCAT_ID=#TARGETCAT_ID#
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_target_cat" addtoken="no">
