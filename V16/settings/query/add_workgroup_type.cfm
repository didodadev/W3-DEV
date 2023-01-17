<cfquery name="ADD_WORKGROUP_TYPE" datasource="#DSN#">
	INSERT 
	INTO 
		SETUP_WORKGROUP_TYPE
	(
		WORKGROUP_TYPE_NAME,
		RECORD_IP,
		RECORD_DATE,
		RECORD_EMP
	) 
	VALUES 
	(
		'#attributes.workgroup_type_name#',
		'#cgi.remote_addr#',
		#now()#,
		#session.ep.userid#
	)
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_workgroup_type" addtoken="no">
