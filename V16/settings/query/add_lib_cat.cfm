<cfquery name="ADD_LIB_CAT" datasource="#DSN#">
	INSERT INTO 
		LIBRARY_CAT 
	(
		LIBRARY_CAT,
		DETAIL,
		RECORD_IP,
		RECORD_DATE,
		RECORD_EMP
	)
	VALUES
	(
		'#attributes.libcat#',
		'#attributes.detail#',
		'#cgi.remote_addr#',
		#now()#,
		#session.ep.userid#
	)
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_library_set" addtoken="no">
