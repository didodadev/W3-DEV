<cfquery name="INSKNOWLEVEL" datasource="#dsn#">
	INSERT 
	INTO 
		SETUP_KNOWLEVEL
		(
			KNOWLEVEL,
			RECORD_EMP,
			RECORD_DATE,
			RECORD_IP
		) 
	VALUES 
		(
			'#KNOWLEVEL#',
			#SESSION.EP.USERID#,
			#NOW()#,
			'#CGI.REMOTE_ADDR#'
		)
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_know_level" addtoken="no">
