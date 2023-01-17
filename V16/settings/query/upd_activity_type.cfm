<cfquery name="ADD_STAGE" datasource="#dsn#">
	UPDATE
		SETUP_ACTIVITY_TYPES
	SET
		ACTIVITY_TYPE = '#attributes.activity_type#',
		DETAIL = <cfif len(attributes.detail)>'#attributes.detail#'<cfelse>null</cfif>,
		UPDATE_DATE = #now()#,
		UPDATE_EMP = #session.ep.userid#,
		UPDATE_IP = '#cgi.remote_addr#'
	WHERE
		ACTIVITY_TYPE_ID = #attributes.activity_type_id#
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_activity_type" addtoken="no">
