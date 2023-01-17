<cfquery name="UPD_WORKGROUP_TYPE" datasource="#DSN#">
	UPDATE 
		SETUP_WORKGROUP_TYPE 
	SET 
		WORKGROUP_TYPE_NAME='#attributes.workgroup_type_name#',
		UPDATE_IP = '#cgi.remote_addr#',
		UPDATE_DATE = #now()#,
		UPDATE_EMP = #session.ep.userid#	 
	WHERE 
		WORKGROUP_TYPE_ID=#attributes.workgroup_type_id#
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_workgroup_type" addtoken="no">
