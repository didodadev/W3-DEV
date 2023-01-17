<cfquery name="INSCARD" datasource="#DSN#">
	INSERT INTO 
		SETUP_CREDITCARD
	(
		CARDCAT,
		RECORD_IP,
		RECORD_DATE,
		RECORD_EMP
	) 
	VALUES 
	(
		'#cardcat#',
		'#cgi.remote_addr#',
		#now()#,
		#session.ep.userid#
	)
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_card" addtoken="no">
