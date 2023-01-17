<cfquery name="DEL_SETUP_PARTNER_TITLE" datasource="#DSN#">
	DELETE
	FROM
		SETUP_PARTNER_DEPARTMENT
	WHERE
		PARTNER_DEPARTMENT_ID = #attributes.id#
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_setup_partner_department" addtoken="no">
