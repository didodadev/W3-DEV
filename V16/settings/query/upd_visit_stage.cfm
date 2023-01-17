<cfquery name="ADD_STAGE" datasource="#dsn#">
	UPDATE
		SETUP_VISIT_STAGES
	SET
		VISIT_STAGE = '#attributes.visit_stage#',
		DETAIL = <cfif len(attributes.detail)>'#attributes.detail#'<cfelse>null</cfif>,
		UPDATE_IP = '#cgi.remote_addr#',
		UPDATE_DATE = #now()#,
		UPDATE_EMP = #session.ep.userid#
	WHERE
		VISIT_STAGE_ID = #attributes.visit_stage_id#
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_visit_stages" addtoken="no">
