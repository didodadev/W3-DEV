<cfquery name="INSERT_UNIVERSITY" datasource="#dsn#"> 
	INSERT 
	INTO 
		SETUP_UNIVERSITY
		(
			UNIVERSITY_NAME,
			RECORD_IP,
			RECORD_DATE,
			RECORD_EMP
		) 
		VALUES 
		(
			'#attributes.university_name#',
			'#cgi.remote_addr#',
			#now()#,
			#session.ep.userid#
		)
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_university" addtoken="no">
