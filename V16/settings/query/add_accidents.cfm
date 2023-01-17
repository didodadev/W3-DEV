<cfquery name="INSERT_ACCS" datasource="#DSN#"> 
	INSERT INTO 
		SETUP_ACCIDENT_TYPE
	(
	  	ACCIDENT_TYPE_NAME,
		RECORD_IP,
		RECORD_DATE,
		RECORD_EMP
	) 
	VALUES 
	(
		'#attributes.acc_name#',
		'#cgi.remote_addr#',
		#now()#,
		#session.ep.userid#
	)
</cfquery>
<cflocation url="#cgi.http_referer#" addtoken="no">
