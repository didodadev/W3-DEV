<cfquery name="insert_hobbies" datasource="#DSN#"> 
	INSERT 
		INTO SETUP_HOBBY
	(
		HOBBY_NAME,
		RECORD_IP,
		RECORD_DATE,
		RECORD_EMP
	) 
	  VALUES 
	(
		'#attributes.hobby_name#',
		'#cgi.remote_addr#',
		#now()#,
		#session.ep.userid#
	)
</cfquery>
<cflocation url="#cgi.http_referer#" addtoken="no">
