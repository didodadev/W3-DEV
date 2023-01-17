<cfquery name="ADD_FAULT_RATIO" datasource="#dsn#"> 
	INSERT 
	INTO 
		SETUP_FAULT_RATIO
	(
		FAULT_RATIO_NAME,
		RECORD_DATE,
		RECORD_EMP,
		RECORD_IP
	) 
	VALUES 
	(
		'#attributes.fault_ratio_name#',
		#now()#,
		#session.ep.userid#,
		'#cgi.remote_addr#'
	)
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_fault_ratio" addtoken="no">
