<cfquery name="DEL_MAILLIST" datasource="#dsn#">
	DELETE 
	FROM
		MAILLIST_CAT
	WHERE
		MAILLIST_CAT_ID = #attributes.MAILLIST_CAT_ID#
</cfquery>

<cflocation url="#request.self#?fuseaction=settings.form_add_maillist_cat" addtoken="no">
