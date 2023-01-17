<cfquery name="DEL_SETUP_BLACKLIST_INFO" datasource="#DSN#">
	DELETE FROM
		SETUP_BLACKLIST_INFO
	WHERE
		BLACKLIST_INFO_ID = #attributes.id#
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_setup_blacklist_info" addtoken="no">
