<cfquery name="ADD_COUNTER_TYPE" datasource="#DSN3#">
	INSERT INTO 
		SETUP_COUNTER_TYPE
	(
		COUNTER_TYPE,
		RECORD_DATE,
		RECORD_EMP,
		RECORD_IP
	) 
	VALUES 
	(
		'#attributes.counter_type#',
		#now()#,
		#session.ep.userid#,
		'#cgi.remote_addr#'
	)
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.add_counter_type" addtoken="no">
