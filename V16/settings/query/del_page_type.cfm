<cfquery name="del_page_type" datasource="#dsn#">
	DELETE FROM
		SETUP_PAGE_TYPES
	WHERE
		PAGE_TYPE_ID = #attributes.PAGE_TYPE_ID#
</cfquery>

<cflocation url="#request.self#?fuseaction=settings.form_add_page_type" addtoken="no">
