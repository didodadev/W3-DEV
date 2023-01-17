<cfquery name="DEL_USER_GROUP" datasource="#dsn#">
	DELETE FROM BLOCK_GROUP WHERE BLOCK_GROUP_ID=#attributes.group_id#
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_block_group" addtoken="no">
