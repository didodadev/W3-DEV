<cfquery name="ADD_NOTICE_TYPE" datasource="#DSN#">
	INSERT INTO 
		SETUP_NOTICE_GROUP
	(
		NOTICE,
		DETAIL,
		RECORD_IP,
		RECORD_DATE,
		RECORD_EMP
	) 
	VALUES 
	(
		'#attributes.notice#',
		'#attributes.detail#',
		'#cgi.remote_addr#',
		#now()#,
		#session.ep.userid#
	)
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_notice_type" addtoken="no">
