<cfquery name="del_broadcast_cat" datasource="#dsn#">
	DELETE FROM BROADCAST_CAT WHERE CAT_ID=#attributes.cat_id#
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_broadcast_cat" addtoken="no">

