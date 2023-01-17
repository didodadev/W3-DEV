<cfquery name="SETUP_ACTIVITY_STAGE" datasource="#dsn#">
	UPDATE
		SETUP_ACTIVITY_STAGES
	SET
		ACTIVITY_STAGE = '#attributes.activity_stage#',
		DETAIL = <cfif len(attributes.detail)>'#attributes.detail#'<cfelse>null</cfif>,
		UPDATE_DATE = #now()#,
		UPDATE_EMP = #session.ep.userid#,
		UPDATE_IP = '#cgi.remote_addr#'
	WHERE
		ACTIVITY_STAGE_ID = #attributes.activity_stage_id#
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_activity_stages" addtoken="no">

