<cfquery name="DELSUPPORTCAT" datasource="#dsn#">
	DELETE FROM SETUP_SUPPORT WHERE SUPPORT_CAT_ID=#SUPPORT_CAT_ID#
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_service_support_cat" addtoken="no">

