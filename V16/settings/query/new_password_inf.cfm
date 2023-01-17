<cfquery name="ADD_PROPERTY" datasource="#dsn#"> 
	INSERT 
	INTO 
		SETUP_PROPERTY
	(
		PROPERTY_NAME,
		RECORD_DATE,
		RECORD_EMP,
		RECORD_IP
	) 
	VALUES 
	(
		'#attributes.property_name#',
		#now()#,
		#session.ep.userid#,
		'#cgi.remote_addr#'
	)
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_property" addtoken="no">
