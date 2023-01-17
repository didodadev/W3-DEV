<cfquery name="UPD_PUNISHMENT_TYPE" datasource="#DSN#">
	UPDATE 
		SETUP_PUNISHMENT_TYPE
	SET 
		PUNISHMENT_TYPE_NAME = '#attributes.punishment_type_name#',
		UPDATE_DATE = #now()#,
		UPDATE_EMP = #session.ep.userid#,
		UPDATE_IP = '#cgi.remote_addr#'
	WHERE 
		PUNISHMENT_TYPE_ID = #attributes.punishment_type_id#
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_punishment_type" addtoken="no">
