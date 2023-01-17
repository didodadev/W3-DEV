<cfquery name="ADD_COMPANY_SIZE_CAT" datasource="#dsn#">
	UPDATE
		SETUP_VISIT_TYPES
	SET
		VISIT_TYPE = '#attributes.visit_type#',
		DETAIL = '#attributes.detail#',
		UPDATE_IP = '#cgi.remote_addr#',
		UPDATE_DATE = #now()#,
		UPDATE_EMP = #session.ep.userid#
	WHERE
		VISIT_TYPE_ID = #attributes.visit_type_id#
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_visit_types" addtoken="no">
