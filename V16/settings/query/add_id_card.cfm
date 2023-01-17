<cfquery name="INSIDENTYCARD" datasource="#dsn#">
	INSERT 
	INTO 
		SETUP_IDENTYCARD
	(
		IDENTYCAT,
		RECORD_EMP,
		RECORD_DATE,
		RECORD_IP
	) 
	VALUES 
	(
		'#IDENTYCAT#',
		#SESSION.EP.USERID#,
		#NOW()#,
		'#CGI.REMOTE_ADDR#'
	)
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_id_card" addtoken="no">
