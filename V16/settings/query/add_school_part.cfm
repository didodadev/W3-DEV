<cfquery name="add_school_part" datasource="#dsn#">
	INSERT 
	INTO 
		SETUP_SCHOOL_PART
	(
		PART_NAME,
		DETAIL,
		RECORD_EMP,
		RECORD_DATE,
		RECORD_IP
	) 
	VALUES 
	(
		'#TITLE#',
		'#TITLE_DETAIL#',
		#SESSION.EP.USERID#,
		#NOW()#,
		'#CGI.REMOTE_ADDR#'
	)
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_school_part" addtoken="no">
