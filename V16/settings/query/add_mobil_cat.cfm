<cfquery name="INSMOBILCAT" datasource="#dsn#">
	INSERT 
	INTO 
			SETUP_MOBILCAT
		(
			MOBILCAT,
			RECORD_DATE,
			RECORD_EMP,
			RECORD_IP
		) 
		VALUES 
		(
			'#MOBILCAT#',
			#NOW()#,
			#SESSION.EP.USERID#,
			'#CGI.REMOTE_ADDR#'
		)
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_mobil_cat" addtoken="no">
