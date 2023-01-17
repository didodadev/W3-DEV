<cfquery name="del_PARTNER_REL" datasource="#dsn#">
	DELETE FROM
		COMPANY_PARTNER_RESOURCE
	WHERE
		RESOURCE_ID = #attributes.resource_id#
</cfquery>

<cflocation url="#request.self#?fuseaction=settings.form_add_partner_resorce" addtoken="no">
