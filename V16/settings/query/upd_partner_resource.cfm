<cfquery name="UPD_PARTNER_RES" datasource="#dsn#">
	UPDATE
		COMPANY_PARTNER_RESOURCE
	SET
		RESOURCE = '#FORM.PARTNER_RESOURCE#',
		DETAIL= '#FORM.DETAIL#',
		UPDATE_DATE = #now()#,
		UPDATE_EMP = #session.ep.userid#,
		UPDATE_IP = '#cgi.remote_addr#'
	WHERE
		RESOURCE_ID = #FORM.RESOURCE_ID#
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_partner_resorce&resource_id=#form.resource_id#" addtoken="no">
