<cfquery name="UPD_ACCS" datasource="#DSN#">
	UPDATE 
		SETUP_ACCIDENT_TYPE
	SET 
		ACCIDENT_TYPE_NAME = '#attributes.accs_name#',
		UPDATE_IP = '#cgi.remote_addr#',
		UPDATE_DATE = #now()#,
		UPDATE_EMP = #session.ep.userid#
	WHERE 
		ACCIDENT_TYPE_ID = #attributes.accs_id#
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_accidents" addtoken="no">
