<cfquery name="DELPRO_WORK_CAT" datasource="#dsn#">
	DELETE FROM PRO_WORK_CAT WHERE WORK_CAT_ID=#URL.PRO_WORK_CAT_ID#
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_pro_work_cat" addtoken="no">
