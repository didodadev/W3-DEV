<cfquery name="ADD_PUNISHMENT_TYPE" datasource="#dsn#"> 
	INSERT 
	INTO 
		SETUP_PUNISHMENT_TYPE
	(
		PUNISHMENT_TYPE_NAME,
		RECORD_DATE,
		RECORD_EMP,
		RECORD_IP
	) 
	VALUES 
	(
		'#attributes.punishment_type_name#',
		#now()#,
		#session.ep.userid#,
		'#cgi.remote_addr#'
	)
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_punishment_type" addtoken="no">
