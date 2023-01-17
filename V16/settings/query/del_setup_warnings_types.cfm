<cfquery name="DEL_SETUP_WARNINIGS" datasource="#DSN#">
	DELETE
	FROM
		SETUP_WARNINGS
	WHERE
		SETUP_WARNING_ID=#attributes.SETUP_WARNING_ID#
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_warnings_approval_types" addtoken="no">
